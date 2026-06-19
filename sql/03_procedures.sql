USE biblioia;

DELIMITER //

CREATE PROCEDURE sp_registrar_prestamo(IN par_id_socio INT, IN par_id_ejemplar INT)
BEGIN
	
	DECLARE var_estado_socio VARCHAR(20);
	DECLARE var_cantidad_prestamos INT;
	DECLARE var_estado_fisico VARCHAR(20);
	DECLARE var_ejemplar_prestado INT;
	
	# Recupera el estado del socio, el cual puede ser: activo, suspendido o baja.
	SELECT estado INTO var_estado_socio
	FROM Socio
	WHERE id_socio = par_id_socio;
	
	# SIGNAL detiene la ejecucion del programa.
	# SQLSTATE '45000' es un codigo estandar internacional resevado para excepciones definidas por el usuario. 
	# Si el socio ya se encuentra suspendido, no hace falta buscar sanciones correspondientes en la tabla Sancion.
	IF var_estado_socio = 'suspendido' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El socio se encuentra suspendido. No puede solicitar prestamos';
	ELSEIF var_estado_socio = 'baja' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El socio ha sido dado de baja.';
	END IF;
	
	# Un socio no puede tener mas de tres prestamos activos en simultaneo. Si el estado del prestamo es 'vencido', aun no ha sido devuelto.
	SELECT COUNT(*) INTO var_cantidad_prestamos
	FROM Prestamo 
	WHERE id_socio = par_id_socio AND estado IN ('activo','vencido');
	
	IF var_cantidad_prestamos >= 3 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El soocio ha alcanzado el limite maximo de tres libros prestados.';
	END IF;
	
	# Recupera el estado del ejemplar fisico del libro en var_estado_fisico
	SELECT estado_fisico INTO var_estado_fisico
	FROM Ejemplar
	WHERE id_ejemplar = par_id_ejemplar;
	
	# Un ejemplar dado de baja no puede ser prestado. Un ejemplar que se encuentra en estado de reparacion, tampoco.	
	IF var_estado_fisico = 'reparacion' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El ejemplar se encuentra en reparacion.';
	ELSEIF var_estado_fisico = 'baja' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: El ejemplar ha sido dado de baja.';
	END IF;
	
	# Si el estado de un prestamo es activo o vencido, significa que el ejemplar no se encuentra fisicamente en la biblioteca.
	# Si tambien ha sido prestado, deberia ser contado en var_ejemplar_prestado
	SELECT COUNT(*) INTO var_ejemplar_prestado
	FROM Prestamo
	WHERE id_ejemplar = par_id_ejemplar AND estado IN ('activo','vencido');
	
	IF var_ejemplar_prestado > 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR: El ejemplar ya ha sido prestado a otro socio.';
	END IF;
	
	# Si no se ha cortado la ejecucion del procedimiento con los filtros anteriores, se carga el prestamo a la tabla
	INSERT INTO Prestamo (id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, estado)
    VALUES (par_id_socio, par_id_ejemplar, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 15 DAY), 'activo');	
		
END //

DELIMITER ;

DELIMITER //

create procedure sp_generar_sancion( in id_socio2 int, in tipo2 varchar(50), in dias_mora2 int)
    begin
        declare dias_sancion int;
        declare fecha_fin date;
        declare motivo varchar(150);

        set dias_sancion = dias_mora2 * 2; 
        set fecha_fin = date_add(CURDATE(), interval dias_sancion day);
        set motivo = concat('Sanción por ', dias_mora2, ' días de retraso en la devolución de un libro.');
        insert into Sancion (id_socio, tipo, fecha_inicio, fecha_fin, motivo)
        values (id_socio2, tipo2, CURDATE(), fecha_fin, motivo);
    end //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_registrar_devolucion(IN par_id_prestamo INT)
BEGIN

	# Definimos variables para almacenar datos
	DECLARE var_id_prestamo INT;
	DECLARE var_id_socio INT;
	DECLARE var_id_ejemplar INT;
	DECLARE var_fecha_vencimiento DATE;
	DECLARE var_estado_prestamo VARCHAR(20);

	SELECT id_prestamo, id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, estado 
	INTO var_id_prestamo, var_id_socio, var_id_ejemplar , var_fecha_vencimiento, var_estado_prestamo
	FROM Prestamo
	WHERE id_prestamo = par_id_prestamo;
	
	
	IF var_estado_prestamo <> 'devuelto' THEN
	
		# Si el prestamo ya se encuentra vencido, la sancion se crea cuando el socio se presenta a devolver el ejemplar
		# Si al momento de devolver el ejemplar, aun no se encuentra el estado=vencido pero ya se ha excedido la fecha, se genera la sancion
		IF var_estado_prestamo = 'vencido' OR var_fecha_vencimiento < CURDATE() THEN
			CALL sp_generar_sancion(var_id_socio, 'Mora', DATEDIFF(CURDATE(), var_fecha_vencimiento));
		END IF;	
	
		# Se cambia el estado del prestamo, y se carga la fecha de devolucion como la fecha actual
		UPDATE Prestamo
		SET estado = 'devuelto',
			fecha_devolucion = CURDATE()
		WHERE id_prestamo = var_id_prestamo;
		
		# Luego de actualizar en la tabla Prestamo, deberia ejecutarse el trigger trg_actualizar_stock
		
		# Asumimos que casi siempre son devueltos en buen estado, y cuando no es asi se modifica manualmente el estado del ejemplar(?
		UPDATE Ejemplar
		SET estado_fisico = 'bueno'
		WHERE id_ejemplar = var_id_ejemplar;	
		
	END IF;
	
END//

DELIMITER ;


DELIMITER //

create procedure sp_renovar_prestamo( in id_prestamo2 int)
    begin 
        declare socio_actual int;
        declare estado_prestamo varchar(50);
        declare vencimiento date;
        declare estado_socio varchar(50);

        select id_socio, estado, fecha_vencimiento 
        into socio_actual, estado_prestamo, vencimiento
        from Prestamo
        where id_prestamo = id_prestamo2;

        if socio_actual is null then
            signal sqlstate '45000' set message_text = 'Error: El préstamo no existe.';
        end if;

        if estado_prestamo = 'devuelto' then
            signal sqlstate '45000' set message_text = 'Error: Solo se pueden renovar préstamos activos.';
        end if;

        if CURDATE() > vencimiento then
            signal sqlstate '45000' set message_text = 'Error: El préstamo está vencido. Debe devolver el libro, no puede renovar.';
        end if;

        select estado into estado_socio from Socio where id_socio = socio_actual; 

        if estado_socio != 'activo' then
            signal sqlstate '45000' set message_text = 'Error: El socio no está activo.';
        end if;

        update Prestamo
        set fecha_vencimiento = date_add(vencimiento, interval 14 day)
        where id_prestamo = id_prestamo2;

    end //


DELIMITER ;
DELIMITER //

CREATE PROCEDURE Recomendar(
    IN p_id_socio INT
)
BEGIN
    WITH HistorialSocio AS (
        SELECT DISTINCT 
            lg.id_genero,
            al.id_autor,
            l.isbn AS isbn_leido
        FROM Prestamo p
        INNER JOIN Ejemplar e ON p.id_ejemplar = e.id_ejemplar
        INNER JOIN Libro l ON e.isbn = l.isbn
        LEFT JOIN Libro_Genero lg ON l.isbn = lg.isbn
        LEFT JOIN Autor_libro al ON l.isbn = al.isbn
        WHERE p.id_socio = p_id_socio
    ),
    LibrosNoLeidos AS (
        SELECT l.isbn, l.titulo, l.stock_disponible
        FROM Libro l
        WHERE l.stock_disponible > 0
          AND l.isbn NOT IN (
              SELECT isbn_leido 
              FROM HistorialSocio 
              WHERE isbn_leido IS NOT NULL
          )
    )
    SELECT DISTINCT 
        lnl.isbn,
        lnl.titulo,
        lnl.stock_disponible
    FROM LibrosNoLeidos lnl
    INNER JOIN Libro_Genero lg ON lnl.isbn = lg.isbn
    INNER JOIN Autor_libro al ON lnl.isbn = al.isbn
    WHERE 
        lg.id_genero IN (SELECT id_genero FROM HistorialSocio WHERE id_genero IS NOT NULL)
        OR 
        al.id_autor IN (SELECT id_autor FROM HistorialSocio WHERE id_autor IS NOT NULL)
    ORDER BY lnl.titulo;

END //

DELIMITER ;
DELIMITER //
CREATE PROCEDURE LibrosLeidos(in idSocio int)
BEGIN
	SELECT distinct(l.titulo), GROUP_CONCAT(DISTINCT g.nombre SEPARATOR ', ') AS generos, CONCAT(a.nombre, ' ', a.apellido) as 'autor'   from Libro l 
	join Libro_Genero lg on l.isbn = lg.isbn 
	join Genero g on lg.id_genero = g.id_genero 
	join Ejemplar e on e.isbn = l.isbn
	join Prestamo p on p.id_ejemplar = e.id_ejemplar 
	join Socio s on s.id_socio = p.id_socio 
	join Autor_libro al on al.isbn = l.isbn 
	join Autor a on a.id_autor = al.id_autor
	where s.id_socio = idSocio
	GROUP BY l.isbn, l.titulo, l.anio_publicacion;

END //
DELIMITER ;

