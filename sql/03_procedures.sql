-- Crea una sanción proporcional a los días de mora. Actualiza
-- estado del socio.

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

create procedure sp_renovar_prestamo( in id_prestamo int)
    begin 
        declare socio_actual int;
        declare estado_prestamo varchar(50);
        declare vencimiento date;
        declare estado_socio varchar(50);

        select id_socio, estado, fecha_vencimiento 
        into socio_actual, estado_prestamo, vencimiento_actual
        from Prestamo
        where id_prestamo = id_prestamo2;

        if socio_actual is null then
            signal sqlstate '45000' set message_text = 'Error: El préstamo no existe.';
        end if;

        if estado_prestamo = 'Devuelto' then
            signal sqlstate '45000' set message_text = 'Error: Solo se pueden renovar préstamos activos.';
        end if;

        select estado into estado_socio from Socio where id_socio = socio_actual; 

        if estado_socio != 'Activo' then
            signal sqlstate '45000' set message_text = 'Error: El socio no está activo.';
        end if;

        update Prestamo
        set fecha_vencimiento = date_add(vencimiento_actual, interval 14 day)
        where id_prestamo = id_prestamo2;

    end //


DELIMITER;


