USE biblioia;

START TRANSACTION;

	INSERT INTO Genero (nombre,descripcion) VALUES
	
	('Literatura Clásica', 'Obras fundamentales de la literatura universal que han perdurado en el tiempo, abarcando desde la antigüedad hasta la modernidad, ideales para el estudio en ediciones inalteradas o académicas.'),
	('Ciencia Ficción' , 'Ficción especulativa que explora conceptos imaginativos y futuristas, viajes espaciales, tecnología avanzada y universos paralelos llenos de aventuras galácticas.'),
	('Informática y Tecnología' , 'Material educativo, manuales técnicos y literatura académica sobre ingeniería de software, arquitectura de sistemas operativos, bases de datos y lenguajes de programación.'),
	('Historia y Cultura Argentina' , 'Textos, ensayos y crónicas que documentan exhaustivamente el desarrollo histórico, político, las tradiciones, el folklore y la formación de la identidad nacional.'),
	('Misterio y Policial' , 'Narrativa literaria centrada en la investigación y resolución de crímenes, enigmas lógicos y secretos, manteniendo la tensión y el suspenso hasta la última página.');
	
COMMIT;


START TRANSACTION;
	
	INSERT INTO Autor (nombre , apellido , nacionalidad) VALUES
		
	('Franz', 'Kafka', 'Checa'),
	('Albert', 'Camus', 'Francesa'),
	('Francis Scott', 'Fitzgerald', 'Estadounidense'),
	('Domingo Faustino', 'Sarmiento', 'Argentina'),
	('Jorge Luis', 'Borges', 'Argentina'),
	('Isaac', 'Asimov', 'Estadounidense'),
	('George', 'Orwell', 'Británica'),
	('Agatha', 'Christie', 'Británica'),
	('Andrew', 'Tanenbaum', 'Estadounidense'), 
	('Dennis', 'Ritchie', 'Estadounidense'),   
	('Ian', 'Sommerville', 'Británica'),
	('Edgar Allan', 'Poe', 'Estadounidense');
	
COMMIT;

START TRANSACTION;

	INSERT INTO Socio (dni, nombre, apellido, email, fecha_alta, estado) VALUES	
	('41234567', 'Marco', 'Gallegos', 'mgallegos@gmail.com', '2024-02-15', 'activo'),
	('42345678', 'Facundo', 'Dun', 'fdun@gmail.com', '2024-03-10', 'activo'),
	('40123987', 'Ignacio Nicolás', 'Picart', 'ipicart@hotmail.com', '2024-03-12', 'activo'),
	('39876543', 'Matias', 'Valdez', 'mvaldez@utn.edu.ar', '2024-04-01', 'activo'),
	('43567890', 'Valentino', 'Gussalli', 'vgussalli@gmail.com', '2024-05-20', 'suspendido'),
	('38765432', 'Antonella', 'Gomez', 'antonella.gomez@gmail.com', '2024-06-11', 'activo'),
	('35678901', 'Juan', 'Perez', 'jperez@yahoo.com', '2024-07-05', 'activo'),
	('34567890', 'Lucía', 'Fernandez', 'lfernandez@gmail.com', '2024-08-15', 'activo'),
	('36789012', 'Martín', 'Rodriguez', 'mrodriguez@outlook.com', '2024-09-02', 'suspendido'),
	('31234567', 'Sofía', 'Martinez', 'smartinez@gmail.com', '2024-10-10', 'activo'),
	('29876543', 'Alejandro', 'Lopez', 'alopez@gmail.com', '2024-11-20', 'activo'),
	('40567890', 'Camila', 'Gonzalez', 'cgonzalez@hotmail.com', '2024-12-05', 'activo'),
	('37654321', 'Lucas', 'Diaz', 'ldiaz@gmail.com', '2025-01-15', 'activo'),
	('32345678', 'Mariana', 'Perez', 'mperez@yahoo.com', '2025-02-20', 'activo'),
	('38901234', 'Agustín', 'Sanchez', 'asanchez@gmail.com', '2025-03-10', 'suspendido'),
	('33456789', 'Florencia', 'Romero', 'fromero@outlook.com', '2025-04-05', 'activo'),
	('39012345', 'Joaquín', 'Sosa', 'jsosa@gmail.com', '2025-05-12', 'activo'),
	('34561234', 'Julieta', 'Torres', 'jtorres@hotmail.com', '2025-06-20', 'activo'),
	('35672345', 'Tomás', 'Ruiz', 'truiz@gmail.com', '2025-07-15', 'activo'),
	('36783456', 'Micaela', 'Alvarez', 'malvarez@yahoo.com', '2025-08-10', 'activo'),
	('37894567', 'Nicolás', 'Gimenez', 'ngimenez@gmail.com', '2025-09-05', 'activo'),
	('38905678', 'Carolina', 'Castro', 'ccastro@outlook.com', '2025-10-20', 'suspendido'),
	('39016789', 'Federico', 'Molina', 'fmolina@gmail.com', '2025-11-15', 'activo'),
	('30127890', 'Paula', 'Rios', 'prios@hotmail.com', '2025-12-10', 'activo'),
	('31238901', 'Diego', 'Silva', 'dsilva@gmail.com', '2026-01-05', 'activo'),
	('32349012', 'Victoria', 'Dominguez', 'vdominguez@yahoo.com', '2026-02-20', 'activo'),
	('33450123', 'Gonzalo', 'Vega', 'gvega@gmail.com', '2026-03-15', 'activo'),
	('34561235', 'Daniela', 'Quiroga', 'dquiroga@outlook.com', '2026-04-10', 'activo'),
	('35672346', 'Ezequiel', 'Luna', 'eluna@gmail.com', '2026-05-05', 'activo'),
	('36783457', 'Antonella', 'Paz', 'apaz@hotmail.com', '2026-06-01', 'suspendido');

COMMIT;

START TRANSACTION;

	INSERT INTO Libro (isbn, titulo, anio_publicacion, stock_total, stock_disponible) VALUES
		('9789875666472', 'La Metamorfosis', 1915, 5, 5), # Alta de libros
		('9788420636945', 'El Extranjero', 1942, 4, 4),
		('9788420674114', 'El Gran Gatsby', 1925, 3, 3),
		('9789871081446', 'Facundo: Civilización y Barbarie', 1845, 6, 6),
		('9789875666489', 'Ficciones', 1944, 4, 4),
		('9789875666496', 'El Aleph', 1949, 5, 5),
		('9788435020471', 'Yo, Robot', 1950, 7, 7),
		('9788499083209', 'Fundación', 1951, 6, 6),
		('9788499890944', '1984', 1949, 8, 8),
		('9788499890951', 'Rebelión en la granja', 1945, 5, 5),
		('9788467045338', 'Asesinato en el Orient Express', 1934, 4, 4),
		('9788467045406', 'Y no quedó ninguno', 1939, 5, 5),
		('9788441413818', 'Cuentos Completos', 1845, 4, 4),
		('9786073214036', 'Sistemas Operativos Modernos', 2001, 3, 3),
		('9786073213114', 'Redes de Computadoras', 1981, 4, 4),
		('9789688802308', 'El lenguaje de programación C', 1978, 5, 5),
		('9786073206031', 'Ingeniería de Software', 1982, 3, 3),
		('9788420674251', 'El Proceso', 1925, 4, 4),
		('9788420674107', 'La Peste', 1947, 5, 5),
		('9789875666502', 'El libro de arena', 1975, 3, 3);
		SAVEPOINT libros_cargados;

	INSERT INTO Ejemplar (isbn, nro_ejemplar, estado_fisico) VALUES #Alta de ejemplares o copias de cada libro
		('9789875666472', 1, 'BUENO'), ('9789875666472', 2, 'BUENO'), ('9789875666472', 3, 'BUENO'), ('9789875666472', 4, 'BUENO'), ('9789875666472', 5, 'BUENO'),
		('9788420636945', 1, 'BUENO'), ('9788420636945', 2, 'BUENO'), ('9788420636945', 3, 'BUENO'), ('9788420636945', 4, 'BUENO'),
		('9788420674114', 1, 'BUENO'), ('9788420674114', 2, 'BUENO'), ('9788420674114', 3, 'BUENO'),
		('9789871081446', 1, 'BUENO'), ('9789871081446', 2, 'BUENO'), ('9789871081446', 3, 'BUENO'), ('9789871081446', 4, 'BUENO'), ('9789871081446', 5, 'BUENO'), ('9789871081446', 6, 'BUENO'),
		('9789875666489', 1, 'BUENO'), ('9789875666489', 2, 'BUENO'), ('9789875666489', 3, 'BUENO'), ('9789875666489', 4, 'BUENO'),
		('9789875666496', 1, 'BUENO'), ('9789875666496', 2, 'BUENO'), ('9789875666496', 3, 'BUENO'), ('9789875666496', 4, 'BUENO'), ('9789875666496', 5, 'BUENO'),
		('9788435020471', 1, 'BUENO'), ('9788435020471', 2, 'BUENO'), ('9788435020471', 3, 'BUENO'), ('9788435020471', 4, 'BUENO'), ('9788435020471', 5, 'BUENO'), ('9788435020471', 6, 'BUENO'), ('9788435020471', 7, 'BUENO'),
		('9788499083209', 1, 'BUENO'), ('9788499083209', 2, 'BUENO'), ('9788499083209', 3, 'BUENO'), ('9788499083209', 4, 'BUENO'), ('9788499083209', 5, 'BUENO'), ('9788499083209', 6, 'BUENO'),
		('9788499890944', 1, 'BUENO'), ('9788499890944', 2, 'BUENO'), ('9788499890944', 3, 'BUENO'), ('9788499890944', 4, 'BUENO'), ('9788499890944', 5, 'BUENO'), ('9788499890944', 6, 'BUENO'), ('9788499890944', 7, 'BUENO'), ('9788499890944', 8, 'BUENO'),
		('9788499890951', 1, 'BUENO'), ('9788499890951', 2, 'BUENO'),
		('9789875666502', 1, 'BUENO'), ('9789875666502', 2, 'BUENO'), ('9789875666502', 3, 'BUENO'); # IDs 51, 52 y 53
	
		SAVEPOINT ejemplares_cargados;

    # BLOQUE 1: Devueltos
	INSERT INTO Prestamo (id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, fecha_devolucion, estado) VALUES
		(1, 1, '2025-08-10', '2025-08-25', '2025-08-20', 'devuelto'), 		
		(2, 2, '2025-09-01', '2025-09-16', '2025-09-15', 'devuelto'),
		(3, 3, '2025-09-15', '2025-09-30', '2025-09-28', 'devuelto'),
		(4, 4, '2025-10-05', '2025-10-20', '2025-10-20', 'devuelto'),
		(5, 5, '2025-10-10', '2025-10-25', '2025-10-28', 'devuelto'),
		(6, 6, '2025-11-01', '2025-11-16', '2025-11-10', 'devuelto'),
		(7, 7, '2025-11-20', '2025-12-05', '2025-12-01', 'devuelto'),
		(8, 8, '2025-12-01', '2025-12-16', '2025-12-15', 'devuelto'),
		(9, 9, '2026-01-10', '2026-01-25', '2026-01-22', 'devuelto'),
		(10, 10, '2026-01-15', '2026-01-30', '2026-01-29', 'devuelto'),
		(11, 11, '2026-02-01', '2026-02-16', '2026-02-14', 'devuelto'),
		(12, 12, '2026-02-10', '2026-02-25', '2026-02-26', 'devuelto'),
		(13, 13, '2026-03-05', '2026-03-20', '2026-03-18', 'devuelto'),
		(14, 14, '2026-03-10', '2026-03-25', '2026-03-25', 'devuelto'),
		(15, 15, '2026-04-01', '2026-04-16', '2026-04-15', 'devuelto'),
		(16, 16, '2026-04-05', '2026-04-20', '2026-04-19', 'devuelto'),
		(17, 17, '2026-04-10', '2026-04-25', '2026-04-22', 'devuelto'),
		(18, 18, '2026-04-15', '2026-04-30', '2026-04-29', 'devuelto'),
		(19, 19, '2026-04-20', '2026-05-05', '2026-05-02', 'devuelto'),
		(20, 20, '2026-04-25', '2026-05-10', '2026-05-09', 'devuelto'),
		(21, 21, '2026-05-01', '2026-05-16', '2026-05-15', 'devuelto'),
		(22, 22, '2026-05-05', '2026-05-20', '2026-05-18', 'devuelto'),
		(23, 23, '2026-05-10', '2026-05-25', '2026-05-24', 'devuelto'),
		(24, 24, '2026-05-15', '2026-05-30', '2026-05-29', 'devuelto'),
		(25, 25, '2026-05-20', '2026-06-04', '2026-06-02', 'devuelto');

		SAVEPOINT prestamos_devueltos; # Alta de 25 prestamos que han sido devueltos
	
    -- BLOQUE 2: Activos 
    INSERT INTO Prestamo (id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, fecha_devolucion, estado) VALUES
		(26, 26, '2026-06-01', '2026-06-16', NULL, 'activo'), 
		(27, 27, '2026-06-02', '2026-06-17', NULL, 'activo'),
		(28, 28, '2026-06-03', '2026-06-18', NULL, 'activo'),
		(29, 29, '2026-06-04', '2026-06-19', NULL, 'activo'),
		(30, 30, '2026-06-05', '2026-06-20', NULL, 'activo'),
		(1, 31, '2026-06-06', '2026-06-21', NULL, 'activo'),
		(2, 32, '2026-06-07', '2026-06-22', NULL, 'activo'),
		(3, 33, '2026-06-08', '2026-06-23', NULL, 'activo'),
		(4, 34, '2026-06-08', '2026-06-23', NULL, 'activo'),
		(6, 35, '2026-06-09', '2026-06-24', NULL, 'activo'),
		(7, 36, '2026-06-09', '2026-06-24', NULL, 'activo'),
		(8, 37, '2026-06-10', '2026-06-25', NULL, 'activo'),
		(10, 38, '2026-06-10', '2026-06-25', NULL, 'activo'),
		(11, 39, '2026-06-11', '2026-06-26', NULL, 'activo'),
		(13, 40, '2026-06-11', '2026-06-26', NULL, 'activo'),
		(12, 51, '2026-06-12', '2026-06-27', NULL, 'activo'); # Nuevo prestamo activo
		
		SAVEPOINT prestamos_activos; #15 Activos (Vencen después de hoy 11 de Junio)

    -- BLOQUE 3: Vencidos
    INSERT INTO Prestamo (id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, fecha_devolucion, estado) VALUES
		(14, 41, '2026-04-10', '2026-04-25', NULL, 'vencido'),
		(15, 42, '2026-04-15', '2026-04-30', NULL, 'vencido'),
		(16, 43, '2026-04-20', '2026-05-05', NULL, 'vencido'),
		(17, 44, '2026-04-25', '2026-05-10', NULL, 'vencido'),
		(18, 45, '2026-05-01', '2026-05-16', NULL, 'vencido'),
		(19, 46, '2026-05-05', '2026-05-20', NULL, 'vencido'),
		(20, 47, '2026-05-10', '2026-05-25', NULL, 'vencido'),
		(21, 48, '2026-05-15', '2026-05-30', NULL, 'vencido'),
		(22, 49, '2026-05-20', '2026-06-04', NULL, 'vencido'),
		(23, 50, '2026-05-25', '2026-06-09', NULL, 'vencido');
	
		SAVEPOINT prestamos_vencidos; #10 vencidos. (También te arreglé el nombre del savepoint que decía 'venciodos')
 
		UPDATE Libro L  #Parche de coherencia de stock
		SET stock_disponible = stock_total - (
		    SELECT COUNT(*) FROM Ejemplar E
		    JOIN Prestamo P ON E.id_ejemplar = P.id_ejemplar
		    	WHERE E.isbn = L.isbn 
		      	AND P.estado IN ('activo', 'vencido')); #Si un libro se encuentra 'devuelto' ya se encuentra en la biblioteca, no tiene sentido contarlo

COMMIT;


START TRANSACTION;

	INSERT INTO Autor_libro (id_autor,isbn) VALUES
	
		(1, '9789875666472'),  -- Franz Kafka - La Metamorfosis
		(2, '9788420636945'),  -- Albert Camus - El Extranjero
		(3, '9788420674114'),  -- F. Scott Fitzgerald - El Gran Gatsby
		(4, '9789871081446'),  -- Domingo F. Sarmiento - Facundo: Civilización y Barbarie
		(5, '9789875666489'), -- Jorge Luis Borges - Ficciones
		(5, '9789875666496'),  -- Jorge Luis Borges - El Aleph
		(5, '9789875666502'),  -- Jorge Luis Borges - El libro de arena
		(6, '9788435020471'),  -- Isaac Asimov - Yo, Robot
		(6, '9788499083209'),  -- Isaac Asimov - Fundación
		(7, '9788499890944'),  -- George Orwell - 1984
		(7, '9788499890951'),  -- George Orwell - Rebelión en la granja
		(8, '9788467045338'),  -- Agatha Christie - Asesinato en el Orient Express
		(8, '9788467045406'),  -- Agatha Christie - Y no quedó ninguno
		(12, '9788441413818'), -- Edgar Allan Poe - Cuentos Completos
		(9, '9786073214036'),  -- Andrew Tanenbaum - Sistemas Operativos Modernos
		(9, '9786073213114'),  -- Andrew Tanenbaum - Redes de Computadoras
		(10, '9789688802308'), -- Dennis Ritchie - El lenguaje de programación C
		(11, '9786073206031'), -- Ian Sommerville - Ingeniería de Software
		(1, '9788420674251'),  -- Franz Kafka - El Proceso
		(2, '9788420674107');  -- Albert Camus - La Peste

COMMIT;

START TRANSACTION;

	INSERT INTO Sancion (id_socio, tipo, fecha_inicio, fecha_fin, motivo) VALUES 
	
    (5, 'Falta de pago', '2026-01-15', '2026-08-15', 'Adeuda más de 3 meses consecutivos de la cuota social desde el año pasado.'),
    (9, 'Infracción al reglamento', '2026-02-10', '2026-09-10', 'Daños comprobados a las instalaciones del área deportiva.'),
    (15, 'Mal comportamiento', '2026-03-20', '2026-11-20', 'Agresión verbal reiterada a otros socios y personal del club.'),
    (22, 'Falta de pago', '2026-04-05', '2026-10-05', 'Falta de pago de la cuota extraordinaria de mantenimiento.'),
    (30, 'Infracción al reglamento', '2026-06-02', '2026-12-02', 'Uso indebido del carnet de socia inmediatamente después del alta.');

COMMIT;