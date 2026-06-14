USE biblioia;

# Un prestamo puede tener como estado: activo, devuelto(finalizado) o vencido. La unica manera en la que el libro no se encuente en la bilbioteca es que el estado del prestamo sea activo o vencido.
DELIMITER //

CREATE TRIGGER trg_actualizar_stock_insert 
AFTER INSERT ON Prestamo
FOR EACH ROW
BEGIN
	IF NEW.estado IN ('activo','vencido') THEN  #Asumo que se puede cargar un prestamo que ya ha vencido
		UPDATE Libro 
		SET stock_disponible = stock_disponible - 1   #Disminuye el stock disponible del libro verificando el ISBN del prestamo nuevo
		WHERE isbn = (SELECT isbn
		              FROM Ejemplar
					  WHERE id_ejemplar = NEW.id_ejemplar   
		              );			
	END IF;
	
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_actualizar_stock_update 
AFTER UPDATE ON Prestamo
FOR EACH ROW
BEGIN
	IF OLD.estado IN ('activo','vencido') AND NEW.estado = 'devuelto' THEN  
		UPDATE Libro 
		SET stock_disponible = stock_disponible + 1  #Aumenta el stock cuando el libro es devuelto
		WHERE isbn = (SELECT isbn
		              FROM Ejemplar
					  WHERE id_ejemplar = OLD.id_ejemplar
		              );			
	END IF;
	
END //

DELIMITER ;



#CAMBIA ESTADO DEL SOCIO a 'suspendido' automaticamente
DELIMITER //

CREATE TRIGGER trg_estado_socio
AFTER INSERT ON Sancion
FOR EACH ROW
BEGIN	
	UPDATE Socio
	SET estado = 'suspendido'
	WHERE id_socio = NEW.id_socio;	
END //

DELIMITER ;


#Registra cada cambio en tabla AUDITORIA_PRESTAMOS con timestamp y usuario de BD
DELIMITER //

CREATE TRIGGER trg_audit_prestamo_insert 
AFTER INSERT ON Prestamo
FOR EACH ROW
BEGIN
	INSERT INTO Auditoria_Prestamos (id_prestamo,accion,fecha_hora,usuario_bd)
	VALUES (NEW.id_prestamo,'insert',NOW(),CURRENT_USER());
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_audit_prestamo_update
AFTER UPDATE ON Prestamo
FOR EACH ROW
BEGIN
	INSERT INTO Auditoria_Prestamos (id_prestamo,accion,fecha_hora,usuario_bd)
	VALUES (NEW.id_prestamo,'update',NOW(),CURRENT_USER());
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_audit_prestamo_delete
AFTER DELETE ON Prestamo
FOR EACH ROW
BEGIN
	INSERT INTO Auditoria_Prestamos (id_prestamo,accion,fecha_hora,usuario_bd)
	VALUES (OLD.id_prestamo,'delete',NOW(),CURRENT_USER());
END //

DELIMITER ;




























