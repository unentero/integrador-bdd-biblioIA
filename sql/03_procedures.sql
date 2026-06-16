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

