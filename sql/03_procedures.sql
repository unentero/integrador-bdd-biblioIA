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

