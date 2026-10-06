DROP DATABASE IF EXISTS campus_pizza;
CREATE DATABASE campus_pizza CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE campus_pizza;

-- 1. Categorías
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    es_elaborado BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

-- 2. Clientes
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100)
) ENGINE=InnoDB;

-- 3. Productos
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    id_categoria INT NOT NULL,
    disponible BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_productos_categorias FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4. Adiciones
CREATE TABLE adiciones (
    id_adicion INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

-- 5. Combos
CREATE TABLE combos (
    id_combo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

-- 6. Productos en Combos
CREATE TABLE combo_productos (
    id_combo INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_combo, id_producto),
    CONSTRAINT fk_cbprod_combos FOREIGN KEY (id_combo) REFERENCES combos(id_combo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cbprod_productos FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 7. Pedidos
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_entrega ENUM('comer_alla', 'recoger') NOT NULL,
    estado ENUM('pendiente', 'en_preparacion', 'listo', 'entregado', 'cancelado') NOT NULL DEFAULT 'entregado',
    CONSTRAINT fk_pedidos_clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 8. Detalle de Pedidos
CREATE TABLE detalle_pedidos (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NULL,
    id_combo INT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_pedidos FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_productos FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_combos FOREIGN KEY (id_combo) REFERENCES combos(id_combo) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_item_type CHECK (
        (id_producto IS NOT NULL AND id_combo IS NULL) OR 
        (id_producto IS NULL AND id_combo IS NOT NULL)
    )
) ENGINE=InnoDB;

-- 9. Adiciones en Detalles
CREATE TABLE detalle_adiciones (
    id_detalle_adicion INT AUTO_INCREMENT PRIMARY KEY,
    id_detalle INT NOT NULL,
    id_adicion INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detadic_detalles FOREIGN KEY (id_detalle) REFERENCES detalle_pedidos(id_detalle) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detadic_adiciones FOREIGN KEY (id_adicion) REFERENCES adiciones(id_adicion) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;


USE campus_pizza;

INSERT INTO categorias (id_categoria, nombre, es_elaborado) VALUES
(1, 'Pizzas', TRUE),
(2, 'Panzarottis', TRUE),
(3, 'Bebidas', FALSE),
(4, 'Postres', FALSE),
(5, 'Acompañantes', FALSE);

INSERT INTO productos (id_producto, nombre, descripcion, precio, id_categoria) VALUES
(1, 'Pizza Hawaiana Mediana', 'Queso, jamón y piña', 25000.00, 1),
(2, 'Pizza Pepperoni Mediana', 'Queso y pepperoni abundante', 27000.00, 1),
(3, 'Pizza Carnes Mediana', 'Carne desmechada, pollo y tocineta', 30000.00, 1),
(4, 'Panzarotti Carne', 'Relleno de carne picada y queso', 12000.00, 2),
(5, 'Panzarotti Pollo y Champiñones', 'Relleno de pollo desmechado', 13000.00, 2),
(6, 'Gaseosa 1.5L', 'Coca-Cola o Postobón 1.5 Litros', 7000.00, 3),
(7, 'Cerveza Club Colombia', 'Lata 330ml', 5000.00, 3),
(8, 'Volcán de Chocolate', 'Postre con helado de vainilla', 10000.00, 4),
(9, 'Pan de Ajo (4 uds)', 'Acompañante crujiente', 8000.00, 5);

INSERT INTO adiciones (id_adicion, nombre, precio) VALUES
(1, 'Extra Queso', 3000.00),
(2, 'Tocineta Criptana', 4000.00),
(3, 'Salsa de la Casa', 1500.00),
(4, 'Jalapeños', 2000.00);

INSERT INTO combos (id_combo, nombre, descripcion, precio) VALUES
(1, 'Combo Familiar', '2 Pizzas Medianas + Gaseosa 1.5L', 52000.00),
(2, 'Combo Personal Panzarotti', '1 Panzarotti + Cerveza', 15000.00);

INSERT INTO combo_productos (id_combo, id_producto, cantidad) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 6, 1),
(2, 4, 1),
(2, 7, 1);

INSERT INTO clientes (id_cliente, nombre, telefono, email) VALUES
(1, 'Carlos Mendoza', '3101234567', 'carlos@gmail.com'),
(2, 'María Rodríguez', '3209876543', 'maria@gmail.com'),
(3, 'Andrés Gómez', '3001112233', 'andres@gmail.com'),
(4, 'Laura Torres', '3154445566', 'laura@gmail.com'),
(5, 'Daniel Figueroa', '3187778899', 'daniel@gmail.com');

INSERT INTO pedidos (id_pedido, id_cliente, fecha_hora, tipo_entrega) VALUES
(1, 1, '2026-09-15 12:30:00', 'comer_alla'),
(2, 1, '2026-09-18 19:10:00', 'recoger'),
(3, 1, '2026-09-20 20:00:00', 'comer_alla'),
(4, 1, '2026-09-22 13:15:00', 'recoger'),
(5, 1, '2026-09-25 18:45:00', 'recoger'),
(6, 1, '2026-09-28 21:00:00', 'comer_alla'),
(7, 2, '2026-10-01 13:00:00', 'comer_alla'),
(8, 2, '2026-10-02 20:30:00', 'recoger'),
(9, 3, '2026-10-03 14:00:00', 'comer_alla'),
(10, 4, '2026-10-04 19:00:00', 'recoger'),
(11, 5, '2026-10-05 11:00:00', 'recoger');

INSERT INTO detalle_pedidos (id_detalle, id_pedido, id_producto, id_combo, cantidad, precio_unitario) VALUES
(1, 1, 1, NULL, 1, 25000.00),
(2, 1, 6, NULL, 1, 7000.00),
(3, 2, 4, NULL, 2, 12000.00),
(4, 3, NULL, 1, 1, 52000.00),
(5, 4, 2, NULL, 1, 27000.00),
(6, 5, 5, NULL, 1, 13000.00),
(7, 6, 3, NULL, 2, 30000.00),
(8, 7, NULL, 2, 1, 15000.00),
(9, 7, 8, NULL, 1, 10000.00),
(10, 8, 1, NULL, 1, 25000.00),
(11, 8, 2, NULL, 1, 27000.00),
(12, 8, 6, NULL, 1, 7000.00),
(13, 8, 8, NULL, 1, 10000.00),
(14, 9, 4, NULL, 1, 12000.00),
(15, 10, 1, NULL, 1, 25000.00),
(16, 11, 2, NULL, 1, 27000.00);

INSERT INTO detalle_adiciones (id_detalle_adicion, id_detalle, id_adicion, cantidad, precio_unitario) VALUES
(1, 1, 1, 1, 3000.00),
(2, 3, 1, 2, 3000.00),
(3, 5, 2, 1, 4000.00),
(4, 10, 1, 1, 3000.00),
(5, 14, 1, 1, 3000.00);

USE campus_pizza;

-- 1. Insertar Categorías
INSERT INTO categorias (id_categoria, nombre, es_elaborado) VALUES
(1, 'Pizzas', TRUE),
(2, 'Panzarottis', TRUE),
(3, 'Bebidas', FALSE),
(4, 'Postres', FALSE),
(5, 'Acompañantes', FALSE);

-- 2. Insertar Productos
INSERT INTO productos (id_producto, nombre, descripcion, precio, id_categoria) VALUES
(1, 'Pizza Hawaiana Mediana', 'Queso, jamón y piña', 25000.00, 1),
(2, 'Pizza Pepperoni Mediana', 'Queso y pepperoni abundante', 27000.00, 1),
(3, 'Pizza Carnes Mediana', 'Carne desmechada, pollo y tocineta', 30000.00, 1),
(4, 'Panzarotti Carne', 'Relleno de carne picada y queso', 12000.00, 2),
(5, 'Panzarotti Pollo y Champiñones', 'Relleno de pollo desmechado', 13000.00, 2),
(6, 'Gaseosa 1.5L', 'Coca-Cola o Postobón 1.5 Litros', 7000.00, 3),
(7, 'Cerveza Club Colombia', 'Lata 330ml', 5000.00, 3),
(8, 'Volcán de Chocolate', 'Postre con helado de vainilla', 10000.00, 4),
(9, 'Pan de Ajo (4 uds)', 'Acompañante crujiente', 8000.00, 5);

-- 3. Insertar Adiciones
INSERT INTO adiciones (id_adicion, nombre, precio) VALUES
(1, 'Extra Queso', 3000.00),
(2, 'Tocineta Criptana', 4000.00),
(3, 'Salsa de la Casa', 1500.00),
(4, 'Jalapeños', 2000.00);

-- 4. Insertar Combos
INSERT INTO combos (id_combo, nombre, descripcion, precio) VALUES
(1, 'Combo Familiar', '2 Pizzas Medianas + Gaseosa 1.5L', 52000.00),
(2, 'Combo Personal Panzarotti', '1 Panzarotti + Cerveza', 15000.00);

-- 5. Insertar Productos dentro de Combos
INSERT INTO combo_productos (id_combo, id_producto, cantidad) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 6, 1),
(2, 4, 1),
(2, 7, 1);

-- 6. Insertar Clientes
INSERT INTO clientes (id_cliente, nombre, telefono, email) VALUES
(1, 'Carlos Mendoza', '3101234567', 'carlos@gmail.com'),
(2, 'María Rodríguez', '3209876543', 'maria@gmail.com'),
(3, 'Andrés Gómez', '3001112233', 'andres@gmail.com'),
(4, 'Laura Torres', '3154445566', 'laura@gmail.com'),
(5, 'Daniel Figueroa', '3187778899', 'daniel@gmail.com');

-- 7. Insertar Pedidos
INSERT INTO pedidos (id_pedido, id_cliente, fecha_hora, tipo_entrega) VALUES
(1, 1, '2026-09-15 12:30:00', 'comer_alla'),
(2, 1, '2026-09-18 19:10:00', 'recoger'),
(3, 1, '2026-09-20 20:00:00', 'comer_alla'),
(4, 1, '2026-09-22 13:15:00', 'recoger'),
(5, 1, '2026-09-25 18:45:00', 'recoger'),
(6, 1, '2026-09-28 21:00:00', 'comer_alla'),
(7, 2, '2026-10-01 13:00:00', 'comer_alla'),
(8, 2, '2026-10-02 20:30:00', 'recoger'),
(9, 3, '2026-10-03 14:00:00', 'comer_alla'),
(10, 4, '2026-10-04 19:00:00', 'recoger'),
(11, 5, '2026-10-05 11:00:00', 'recoger');

-- 8. Insertar Detalle de Pedidos
INSERT INTO detalle_pedidos (id_detalle, id_pedido, id_producto, id_combo, cantidad, precio_unitario) VALUES
(1, 1, 1, NULL, 1, 25000.00),
(2, 1, 6, NULL, 1, 7000.00),
(3, 2, 4, NULL, 2, 12000.00),
(4, 3, NULL, 1, 1, 52000.00),
(5, 4, 2, NULL, 1, 27000.00),
(6, 5, 5, NULL, 1, 13000.00),
(7, 6, 3, NULL, 2, 30000.00),
(8, 7, NULL, 2, 1, 15000.00),
(9, 7, 8, NULL, 1, 10000.00),
(10, 8, 1, NULL, 1, 25000.00),
(11, 8, 2, NULL, 1, 27000.00),
(12, 8, 6, NULL, 1, 7000.00),
(13, 8, 8, NULL, 1, 10000.00),
(14, 9, 4, NULL, 1, 12000.00),
(15, 10, 1, NULL, 1, 25000.00),
(16, 11, 2, NULL, 1, 27000.00);

-- 9. Insertar Adiciones en Pedidos
INSERT INTO detalle_adiciones (id_detalle_adicion, id_detalle, id_adicion, cantidad, precio_unitario) VALUES
(1, 1, 1, 1, 3000.00),
(2, 3, 1, 2, 3000.00),
(3, 5, 2, 1, 4000.00),
(4, 10, 1, 1, 3000.00),
(5, 14, 1, 1, 3000.00);