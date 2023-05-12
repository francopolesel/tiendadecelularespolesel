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
    precio DECIMAL,
    stock INT,
    ID_vendedor INT NOT NULL,
    FOREIGN KEY (ID_vendedor) REFERENCES vendedor(ID_vendedor),
    ID_cliente INT NOT NULL,
    FOREIGN KEY (ID_cliente) REFERENCES cliente(ID_cliente)
);

CREATE TABLE extra(
	ID_extra INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	tipoDeExtra VARCHAR (45) NOT NULL,
    ID_celular INT NOT NULL,
    FOREIGN KEY (ID_celular) REFERENCES celular(ID_celular)
);

CREATE TABLE tecnico(
	ID_tecnico INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombreCompleto VARCHAR (45) NOT NULL,
    email VARCHAR (45) NOT NULL
);

CREATE TABLE reparacion(
	ID_reparacion INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	tipoDeReparacion VARCHAR (45) NOT NULL,
    precio DECIMAL NOT NULL,
    ID_tecnico INT NOT NULL,
    FOREIGN KEY (ID_tecnico) REFERENCES tecnico(ID_tecnico),
    ID_celular INT NOT NULL,
    FOREIGN KEY (ID_celular) REFERENCES celular(ID_celular)
);


