USE ERP_ACM;

DELIMITER $$

-- CLIENTES

CREATE TRIGGER trg_Audit_Insert_Clientes
AFTER INSERT ON Clientes
FOR EACH ROW
BEGIN
INSERT INTO Auditoria(
TablaAfectada,
ID_RegistroAfectado,
Accion,
ID_Usuario,
ValorAnterior,
ValorNuevo
)
VALUES(
'Clientes',
NEW.ID_Cliente,
'INSERT',
@usuario_actual,
NULL,
CONCAT('Documento:',NEW.NumeroDocumento,' Nombre:',NEW.Nombre,' ',NEW.Apellidos)
);
END$$


CREATE TRIGGER trg_Audit_Update_Clientes
AFTER UPDATE ON Clientes
FOR EACH ROW
BEGIN
INSERT INTO Auditoria(
TablaAfectada,
ID_RegistroAfectado,
Accion,
ID_Usuario,
ValorAnterior,
ValorNuevo
)
VALUES(
'Clientes',
NEW.ID_Cliente,
'UPDATE',
@usuario_actual,
CONCAT('Antes:',OLD.Nombre,' ',OLD.Apellidos),
CONCAT('Despues:',NEW.Nombre,' ',NEW.Apellidos)
);
END$$


CREATE TRIGGER trg_Audit_Delete_Clientes
AFTER DELETE ON Clientes
FOR EACH ROW
BEGIN
INSERT INTO Auditoria(
TablaAfectada,
ID_RegistroAfectado,
Accion,
ID_Usuario,
ValorAnterior,
ValorNuevo
)
VALUES(
'Clientes',
OLD.ID_Cliente,
'DELETE',
@usuario_actual,
CONCAT('Eliminado:',OLD.Nombre,' ',OLD.Apellidos),
NULL
);
END$$


-- PRODUCTOS

CREATE TRIGGER trg_Audit_Insert_Producto
AFTER INSERT ON Producto
FOR EACH ROW
BEGIN
INSERT INTO Auditoria(
TablaAfectada,
ID_RegistroAfectado,
Accion,
ID_Usuario,
ValorAnterior,
ValorNuevo
)
VALUES(
'Producto',
NEW.ID_Producto,
'INSERT',
@usuario_actual,
NULL,
CONCAT('Producto:',NEW.NombreProducto)
);
END$$


CREATE TRIGGER trg_Audit_Update_Producto
AFTER UPDATE ON Producto
FOR EACH ROW
BEGIN
INSERT INTO Auditoria(
TablaAfectada,
ID_RegistroAfectado,
Accion,
ID_Usuario,
ValorAnterior,
ValorNuevo
)
VALUES(
'Producto',
NEW.ID_Producto,
'UPDATE',
@usuario_actual,
CONCAT('Antes:',OLD.NombreProducto),
CONCAT('Despues:',NEW.NombreProducto)
);
END$$


CREATE TRIGGER trg_Audit_Delete_Producto
AFTER DELETE ON Producto
FOR EACH ROW
BEGIN
INSERT INTO Auditoria(
TablaAfectada,
ID_RegistroAfectado,
Accion,
ID_Usuario,
ValorAnterior,
ValorNuevo
)
VALUES(
'Producto',
OLD.ID_Producto,
'DELETE',
@usuario_actual,
CONCAT('Eliminado:',OLD.NombreProducto),
NULL
);
END$$


-- FACTURAS VENTA

CREATE TRIGGER trg_Audit_Insert_FacturaVenta
AFTER INSERT ON FacturaVenta
FOR EACH ROW
BEGIN
INSERT INTO Auditoria(
TablaAfectada,
ID_RegistroAfectado,
Accion,
ID_Usuario,
ValorAnterior,
ValorNuevo
)
VALUES(
'FacturaVenta',
NEW.ID_FacturaVenta,
'INSERT',
NEW.ID_UsuarioRegistro,
NULL,
CONCAT('Factura:',NEW.NumeroFacturaVenta,' Total:',NEW.Total)
);
END$$


CREATE TRIGGER trg_Audit_Update_FacturaVenta
AFTER UPDATE ON FacturaVenta
FOR EACH ROW
BEGIN
INSERT INTO Auditoria(
TablaAfectada,
ID_RegistroAfectado,
Accion,
ID_Usuario,
ValorAnterior,
ValorNuevo
)
VALUES(
'FacturaVenta',
NEW.ID_FacturaVenta,
'UPDATE',
@usuario_actual,
CONCAT('Antes Estado:',OLD.Estado,' Total:',OLD.Total),
CONCAT('Despues Estado:',NEW.Estado,' Total:',NEW.Total)
);
END$$


-- FACTURAS COMPRA

CREATE TRIGGER trg_Audit_Insert_FacturaCompra
AFTER INSERT ON FacturaCompra
FOR EACH ROW
BEGIN
INSERT INTO Auditoria(
TablaAfectada,
ID_RegistroAfectado,
Accion,
ID_Usuario,
ValorAnterior,
ValorNuevo
)
VALUES(
'FacturaCompra',
NEW.ID_FacturaCompra,
'INSERT',
NEW.ID_UsuarioRegistro,
NULL,
CONCAT('FacturaCompra:',NEW.NumeroFacturaCompra,' Total:',NEW.Total)
);
END$$


CREATE TRIGGER trg_Audit_Update_FacturaCompra
AFTER UPDATE ON FacturaCompra
FOR EACH ROW
BEGIN
INSERT INTO Auditoria(
TablaAfectada,
ID_RegistroAfectado,
Accion,
ID_Usuario,
ValorAnterior,
ValorNuevo
)
VALUES(
'FacturaCompra',
NEW.ID_FacturaCompra,
'UPDATE',
@usuario_actual,
CONCAT('Antes Total:',OLD.Total),
CONCAT('Despues Total:',NEW.Total)
);
END$$


-- PROVEEDORES

CREATE TRIGGER trg_Audit_Insert_Proveedor
AFTER INSERT ON Proveedor
FOR EACH ROW
BEGIN
INSERT INTO Auditoria(
TablaAfectada,
ID_RegistroAfectado,
Accion,
ID_Usuario,
ValorAnterior,
ValorNuevo
)
VALUES(
'Proveedor',
NEW.ID_Proveedor,
'INSERT',
@usuario_actual,
NULL,
CONCAT('Proveedor:',NEW.RazonSocial)
);
END$$


CREATE TRIGGER trg_Audit_Update_Proveedor
AFTER UPDATE ON Proveedor
FOR EACH ROW
BEGIN
INSERT INTO Auditoria(
TablaAfectada,
ID_RegistroAfectado,
Accion,
ID_Usuario,
ValorAnterior,
ValorNuevo
)
VALUES(
'Proveedor',
NEW.ID_Proveedor,
'UPDATE',
@usuario_actual,
CONCAT('Antes:',OLD.RazonSocial),
CONCAT('Despues:',NEW.RazonSocial)
);
END$$

DELIMITER ;