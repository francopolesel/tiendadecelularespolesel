CREATE SCHEMA celularespolesel;
USE celularespolesel;

CREATE TABLE vendedor(
	ID_vendedor INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombreCompleto VARCHAR (45) NOT NULL,
    email VARCHAR (45) NOT NULL
);

CREATE TABLE cliente(
	ID_cliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombreCompleto VARCHAR (45) NOT NULL,
    email VARCHAR (45) NOT NULL
);

CREATE TABLE celular(
	ID_celular INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	modelo VARCHAR (45) NOT NULL,
    precio FLOAT,
    en_reparacion BOOLEAN NOT NULL,
    ID_vendedor INT,
	FOREIGN KEY (ID_vendedor) REFERENCES vendedor(ID_vendedor),
    ID_cliente INT NOT NULL,
    FOREIGN KEY (ID_cliente) REFERENCES cliente(ID_cliente)
);

-- Agregar restricción a la foreign key ID_vendedor
ALTER TABLE celular
ADD CONSTRAINT FK_celular_vendedor
FOREIGN KEY (ID_vendedor) REFERENCES vendedor(ID_vendedor);

-- Agregar restricción a la foreign key ID_cliente
ALTER TABLE celular
ADD CONSTRAINT FK_celular_cliente
FOREIGN KEY (ID_cliente) REFERENCES cliente(ID_cliente);


CREATE TABLE extra(
	ID_extra INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	tipoDeExtra VARCHAR (45) NOT NULL,
    precioExtra FLOAT NOT NULL,
    ID_celular INT NOT NULL,
    FOREIGN KEY (ID_celular) REFERENCES celular(ID_celular)
);

-- Agregar restricción a la foreign key ID_celular
ALTER TABLE extra
ADD CONSTRAINT FK_extra_celular
FOREIGN KEY (ID_celular) REFERENCES celular(ID_celular);

CREATE TABLE tecnico(
	ID_tecnico INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombreCompleto VARCHAR (45) NOT NULL,
    email VARCHAR (45) NOT NULL
);
 
CREATE TABLE reparacion(
	ID_reparacion INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	tipoDeReparacion VARCHAR (45) NOT NULL,
    precio FLOAT NOT NULL,
    ID_tecnico INT NOT NULL,
    FOREIGN KEY (ID_tecnico) REFERENCES tecnico(ID_tecnico),
    ID_celular INT NOT NULL,
    FOREIGN KEY (ID_celular) REFERENCES celular(ID_celular)
);

-- Agregar restricción a la foreign key ID_tecnico
ALTER TABLE reparacion
ADD CONSTRAINT FK_reparacion_tecnico
FOREIGN KEY (ID_tecnico) REFERENCES tecnico(ID_tecnico);

-- Agregar restricción a la foreign key ID_celular
ALTER TABLE reparacion
ADD CONSTRAINT FK_reparacion_celular
FOREIGN KEY (ID_celular) REFERENCES celular(ID_celular);

CREATE TABLE factura(
	ID_factura INT PRIMARY KEY auto_increment,
    nombreCliente VARCHAR(50),
    nombreVendedor VARCHAR(50),
    modeloCelular VARCHAR(50),
    precio FLOAT,
    fechaDeVenta datetime
);
    
INSERT INTO vendedor (nombreCompleto, email)
VALUES
('Juan Pérez', 'juan.perez@example.com'),
('María López', 'maria.lopez@example.com'),
('Carlos Rodríguez', 'carlos.rodriguez@example.com'),
('Laura Martínez', 'laura.martinez@example.com'),
('Andrés Gómez', 'andres.gomez@example.com'),
('Ana Silva', 'ana.silva@example.com'),
('Pedro Sánchez', 'pedro.sanchez@example.com'),
('Sofía Ramírez', 'sofia.ramirez@example.com'),
('Luisa Castro', 'luisa.castro@example.com'),
('Javier Herrera', 'javier.herrera@example.com');

INSERT INTO cliente (nombreCompleto, email)
VALUES
('Roberto Torres', 'roberto.torres@example.com'),
('Julia Fernández', 'julia.fernandez@example.com'),
('Miguel González', 'miguel.gonzalez@example.com'),
('Carmen Vargas', 'carmen.vargas@example.com'),
('Diego Herrera', 'diego.herrera@example.com'),
('Sara Mendoza', 'sara.mendoza@example.com'),
('Raúl Navarro', 'raul.navarro@example.com'),
('Lucía Reyes', 'lucia.reyes@example.com'),
('Fernando Peña', 'fernando.pena@example.com'),
('Gabriela Morales', 'gabriela.morales@example.com');

INSERT INTO celular (modelo, precio, en_reparacion, ID_vendedor, ID_cliente)
VALUES
('iPhone 12', 999.99, FALSE, 1, 1),
('Samsung Galaxy S21', 899.99, FALSE, 2, 2),
('Google Pixel 5', 799.99, FALSE, 3, 3),
('OnePlus 9 Pro', 899.99, FALSE, 4, 4),
('Xiaomi Mi 11', 699.99, FALSE, 5, 5),
('LG Velvet', NULL, TRUE, NULL, 6),
('Motorola Edge', NULL, TRUE, NULL, 7),
('Sony Xperia 1 II', NULL, TRUE, NULL, 8),
('Huawei P40 Pro', NULL, TRUE, NULL, 9),
('Nokia 8.3', NULL, TRUE, NULL, 10);

INSERT INTO extra (tipoDeExtra, ID_celular, precioExtra)
VALUES
('Funda protectora', 1, 500),
('Protector de pantalla', 2, 800),
('Auriculares Bluetooth', 3, 400),
('Cargador inalámbrico', 4, 600),
('Tarjeta de memoria', 5, 700);

INSERT INTO tecnico (nombreCompleto, email)
VALUES
('Jorge Ramírez', 'jorge.ramirez@example.com'),
('Elena Morales', 'elena.morales@example.com'),
('Martín González', 'martin.gonzalez@example.com'),
('Isabel Torres', 'isabel.torres@example.com'),
('Luis Medina', 'luis.medina@example.com');

INSERT INTO reparacion (tipoDeReparacion, precio, ID_tecnico, ID_celular)
VALUES
('Solución de problemas de conectividad', 70.00, 1, 6),
('Reparación de botón de encendido', 90.00, 2, 7),
('Limpieza y mantenimiento', 40.00, 3, 8),
('Reparación de puerto de carga', 100.00, 4, 9),
('Reparación de sensor de huellas dactilares', 80.00, 5, 10);


#Vista de celulares en reparación con detalles de reparación y técnico asignado:

CREATE VIEW celulares_en_reparacion AS
SELECT c.modelo, r.tipoDeReparacion, t.nombreCompleto AS tecnico_asignado
FROM celular c
JOIN reparacion r ON c.ID_celular = r.ID_celular
JOIN tecnico t ON r.ID_tecnico = t.ID_tecnico
WHERE c.en_reparacion = TRUE;


#Vista de vendedores y la cantidad de celulares vendidos:

CREATE VIEW vendedores_con_cantidad_celulares AS
SELECT v.nombreCompleto, COUNT(c.ID_celular) AS cantidad_celulares_vendidos
FROM vendedor v
LEFT JOIN celular c ON v.ID_vendedor = c.ID_vendedor
GROUP BY v.ID_vendedor;


#Vista de reparaciones y el nombre completo del cliente asociado:

CREATE VIEW reparaciones_con_cliente AS
SELECT r.tipoDeReparacion, cl.nombreCompleto AS cliente_asociado
FROM reparacion r
JOIN celular c ON r.ID_celular = c.ID_celular
JOIN cliente cl ON c.ID_cliente = cl.ID_cliente;

#Vista de clientes y su historial de compras:

CREATE VIEW clientes_con_historial_compras AS
SELECT cl.ID_cliente, cl.nombreCompleto, GROUP_CONCAT(c.modelo ORDER BY c.ID_celular SEPARATOR ', ') AS historial_compras
FROM cliente cl
JOIN celular c ON cl.ID_cliente = c.ID_cliente
GROUP BY cl.ID_cliente;

#Vista de técnicos y el número de reparaciones realizadas:

CREATE VIEW tecnicos_con_numero_reparaciones AS
SELECT t.ID_tecnico, t.nombreCompleto, COUNT(r.ID_reparacion) AS numero_reparaciones
FROM tecnico t
LEFT JOIN reparacion r ON t.ID_tecnico = r.ID_tecnico
GROUP BY t.ID_tecnico;

SELECT * FROM celulares_en_reparacion;
SELECT * FROM vendedores_con_cantidad_celulares;
SELECT * FROM reparaciones_con_cliente;
SELECT * FROM clientes_con_historial_compras;
SELECT * FROM tecnicos_con_numero_reparaciones;

DELIMITER $$
CREATE FUNCTION obtenerPrecioTotalExtra(extraID INT) RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE celularPrecio FLOAT;
    DECLARE extraPrecio FLOAT;
    DECLARE totalPrecio FLOAT;
    
    SELECT precio INTO celularPrecio
    FROM celular
    INNER JOIN extra ON celular.ID_celular = extra.ID_celular
    WHERE extra.ID_extra = extraID;
    
    SELECT precioExtra INTO extraPrecio
    FROM extra
    WHERE ID_extra = extraID;
    
    SET totalPrecio = celularPrecio + extraPrecio;
    
    RETURN totalPrecio;
END;
$$

DELIMITER $$
CREATE FUNCTION agradecerCompra(clienteID INT) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE clienteNombre VARCHAR(45);
    DECLARE mensaje VARCHAR(100);
    
    SELECT nombreCompleto INTO clienteNombre
    FROM cliente
    WHERE ID_cliente = clienteID;
    
    SET mensaje = CONCAT('Gracias por tu compra ', clienteNombre);
    
    RETURN mensaje;
END;
$$

select obtenerPrecioTotalExtra(6);
select agradecerCompra(1);

#Busca un campo en la celular y lo ordena ascendente o descedientemente, segun indique el usuario
DELIMITER $$
CREATE PROCEDURE ordenarCelulares (IN CampoOrdenamiento VARCHAR(45), IN Orden VARCHAR(4))
BEGIN
    SET @Query = CONCAT('SELECT * FROM celular ORDER BY ', CampoOrdenamiento, ' ', Orden);
    PREPARE runSQL FROM @Query;
    EXECUTE runSQL;
    DEALLOCATE PREPARE runSQL;
END 
$$

CALL ordenarCelulares('precio', 'ASC');

#Aumenta los precios de los celulares según el porcentaje que se le indique en el parametro
DELIMITER $$

CREATE PROCEDURE aumentarPrecios(IN porcentaje FLOAT)
BEGIN
    UPDATE celular SET precio = precio + (precio * porcentaje / 100);
END $$

CALL aumentarPrecios(50);

#Le hace un descuento a los precios de los celulares según el porcentaje que se le indique en el parametro
DELIMITER $$

CREATE PROCEDURE aplicarDescuento(IN porcentaje FLOAT)
BEGIN
    UPDATE celular SET precio = precio - (precio * porcentaje / 100);
END $$

CALL aplicarDescuento(10);

select * from celular;

-- Se inserta en la tabla factura cada vez que se inserta un celular para la venta 
-- Crear el trigger
DELIMITER $$
CREATE TRIGGER insertar_factura
AFTER INSERT ON celular
FOR EACH ROW
BEGIN
    -- Verificar si en_reparacion es FALSE
    IF NEW.en_reparacion = FALSE THEN
        -- Obtener el nombre del cliente
        SET @nombreCliente = (SELECT nombreCompleto FROM cliente WHERE ID_cliente = NEW.ID_cliente);

        -- Obtener el nombre del vendedor
        SET @nombreVendedor = (SELECT nombreCompleto FROM vendedor WHERE ID_vendedor = NEW.ID_vendedor);

        -- Insertar en la tabla factura
        INSERT INTO factura (nombreCliente, nombreVendedor, modeloCelular, precio, fechaDeVenta)
        VALUES (@nombreCliente, @nombreVendedor, NEW.modelo, NEW.precio, CURRENT_TIMESTAMP());
    END IF;
END$$
DELIMITER ;

-- Se inserta en la tabla de auditoria cada vez que se inserta en la tabla celular
-- Crear el trigger
CREATE TABLE audits (
	ID_log INT PRIMARY KEY auto_increment,
    entity varchar(100),
    entity_id int,
    insert_dt datetime,
    created_by varchar(100),
    last_updated_dt datetime,
    last_updated_by varchar(100)
);

CREATE TRIGGER tr_insert_celular_aud
AFTER INSERT ON celular
FOR EACH ROW
INSERT INTO audits (entity, entity_id, insert_dt, created_by, last_updated_dt, last_updated_by)
VALUES ('celular', NEW.ID_celular, CURRENT_TIMESTAMP(), USER(), CURRENT_TIMESTAMP(), USER());

INSERT INTO celular (modelo, precio, en_reparacion, ID_vendedor, ID_cliente)
VALUES
('Xiaomi 9', 1999.99, FALSE, 3, 3),
('Xioami 10', 1899.99, FALSE, 4, 4);

SELECT * FROM factura;
SELECT * FROM audits;

SET AUTOCOMMIT = 0;

START TRANSACTION;

-- Insertar un nuevo registro en la tabla celular
INSERT INTO celular (modelo, precio, en_reparacion, ID_vendedor, ID_cliente)
VALUES ('Nuevo Modelo', 100.00, FALSE, 1, 1);

-- Obtener el último ID_celular insertado
SET @ultimoIDCelular = LAST_INSERT_ID();

-- Obtener el ID_cliente correspondiente al nuevo registro
SET @clienteID = (SELECT ID_cliente FROM celular WHERE ID_celular = @ultimoIDCelular);

-- Llamar a la función agradecerCompra() con el ID_cliente obtenido
SELECT agradecerCompra(@clienteID);

COMMIT;

START TRANSACTION;

-- Insertar un nuevo registro en la tabla celular
INSERT INTO celular (modelo, precio, en_reparacion, ID_vendedor, ID_cliente)
VALUES ('Nuevo Modelo', 100.00, FALSE, 1, 1);

-- Obtener el último ID_celular insertado
SET @ultimoIDCelular = LAST_INSERT_ID();

-- Insertar un nuevo registro en la tabla extra con el ID_celular correspondiente
INSERT INTO extra (tipoDeExtra, precioExtra, ID_celular)
VALUES ('Nuevo Extra', 50.00, @ultimoIDCelular);

-- Obtener el último ID_extra insertado
SET @ultimoIDextra = LAST_INSERT_ID();

-- Obtener el precio extra relacionado al último registro insertado en la tabla extra
SELECT obtenerPrecioTotalExtra(@ultimoIDextra);

COMMIT;

-- Crea el usuario vendedorJuan
CREATE USER 'vendedorJuan'@'localhost' IDENTIFIED BY 'contraseña'; -- Reemplaza 'contraseña' por la contraseña deseada para el usuario

-- Asigna permisos de solo lectura al usuario vendedorJuan en todas las tablas de celularespolesel
GRANT SELECT ON celularespolesel.* TO 'vendedorJuan'@'localhost';

-- No permite al usuario vendedorJuan eliminar registros de ninguna tabla
REVOKE DELETE ON celularespolesel.* FROM 'vendedorJuan'@'localhost';

-- Crea el usuario vendedorJavier
CREATE USER 'vendedorJavier'@'localhost' IDENTIFIED BY 'contraseña'; -- Reemplaza 'contraseña' por la contraseña deseada para el usuario

-- Asigna permisos de lectura, inserción y modificación al usuario vendedorJavier en todas las tablas de celularespolesel
GRANT SELECT, INSERT, UPDATE ON celularespolesel.* TO 'vendedorJavier'@'localhost';

-- No permite al usuario vendedorJavier eliminar registros de ninguna tabla
REVOKE DELETE ON celularespolesel.* FROM 'vendedorJavier'@'localhost';

