USE ERP_ACM;

-- 1. PAISES
INSERT INTO Pais (NombrePais) VALUES
('Colombia'),
('Chile'),
('Ecuador'),
('Perú');

-- 2. CIUDADES
INSERT INTO Ciudad (NombreCiudad, ID_Pais) VALUES
('Barranquilla', 1),
('Cali', 1),
('Medellín', 1),
('Bucaramanga', 1),
('Bogotá', 1);

-- 3. SEDES
INSERT INTO Sede (NombreSede, ID_Ciudad) VALUES
('Sede Barranquilla', 1),
('Sede Cali', 2),
('Sede Medellín', 3),
('Sede Bucaramanga', 4),
('Sede Bogotá', 5);

-- 4. BODEGAS
INSERT INTO Bodega (NombreBodega, ID_Ciudad, ID_Sede) VALUES
('Bodega Barranquilla', 1, 1),
('Bodega Cali', 2, 2),
('Bodega Medellín', 3, 3),
('Bodega Bucaramanga', 4, 4),
('Bodega Bogotá', 5, 5);

-- 5. TIPOS DE DOCUMENTO
INSERT INTO TipoDocumento (NombreTipoDocumento, Abreviatura) VALUES
('Cédula de Ciudadanía', 'CC'),
('Tarjeta de Identidad', 'TI'),
('Cédula de Extranjería', 'CE'),
('NIT', 'NIT'),
('Pasaporte', 'PAS');

-- 6. TIPOS DE PROVEEDOR
INSERT INTO TipoProveedor (NombreTipoProveedor) VALUES
('Nacional'),
('Internacional');

-- 7. CARGOS
INSERT INTO Cargo (NombreCargo) VALUES
('Administrador'),
('Coordinador de Ventas'),
('Asesor Comercial'),
('Encargado de Inventario'),
('Auxiliar de Inventario'),
('Gerente de Compras'),
('Auxiliar de Compras');

-- 8. ROLES
INSERT INTO Rol (NombreRol) VALUES
('Administrador'),
('Gerente'),
('CajeroVendedor'),
('Bodeguero'),
('AsesorComercial'),
('Contador'),
('AppBackend');

-- 9. PERMISOS
INSERT INTO Permiso (NombrePermiso, Descripcion) VALUES
('GestionarUsuarios', 'Puede crear, editar y consultar usuarios'),
('GestionarRoles', 'Puede asignar roles y permisos'),
('GestionarClientes', 'Puede crear y actualizar clientes'),
('EliminarClientes', 'Puede eliminar clientes'),
('GestionarVentas', 'Puede crear, editar y consultar ventas'),
('EliminarVentas', 'Puede eliminar ventas'),
('GestionarDevolucionesVenta', 'Puede registrar devoluciones de venta'),
('GestionarCompras', 'Puede crear, editar y consultar compras'),
('EliminarCompras', 'Puede eliminar compras'),
('GestionarProveedores', 'Puede crear y modificar proveedores'),
('ConsultarProveedores', 'Puede consultar proveedores'),
('GestionarInventario', 'Puede gestionar inventario'),
('GestionarBodegas', 'Puede gestionar bodegas'),
('GestionarProductos', 'Puede crear y modificar productos'),
('GestionarCategorias', 'Puede crear y modificar categorías'),
('GestionarTraslados', 'Puede hacer traslados entre bodegas'),
('VerReportes', 'Puede consultar reportes'),
('GestionarComisiones', 'Puede calcular y consultar comisiones');

-- 10. ROL PERMISO
-- Admin
INSERT INTO RolPermiso (ID_Rol, ID_Permiso)
SELECT 1, ID_Permiso FROM Permiso;

-- CoordinadorVentas
INSERT INTO RolPermiso (ID_Rol, ID_Permiso) VALUES
(2, 3),
(2, 5),
(2, 7),
(2, 17),
(2, 18);

-- AsesorComercial
INSERT INTO RolPermiso (ID_Rol, ID_Permiso) VALUES
(3, 3),
(3, 5),
(3, 7),
(3, 17);

-- EncargadoInventario
INSERT INTO RolPermiso (ID_Rol, ID_Permiso) VALUES
(4, 12),
(4, 13),
(4, 14),
(4, 15),
(4, 16),
(4, 17);

-- AuxiliarInventario
INSERT INTO RolPermiso (ID_Rol, ID_Permiso) VALUES
(5, 14),
(5, 15),
(5, 17);

-- GerenteCompras
INSERT INTO RolPermiso (ID_Rol, ID_Permiso) VALUES
(6, 8),
(6, 9),
(6, 10),
(6, 11),
(6, 17);

-- AuxiliarCompras
INSERT INTO RolPermiso (ID_Rol, ID_Permiso) VALUES
(7, 8),
(7, 11),
(7, 17);

-- 11. CLIENTES
INSERT INTO Clientes (
    ID_TipoDocumento,
    NumeroDocumento,
    Nombre,
    Apellidos,
    Genero,
    Direccion,
    ID_Ciudad,
    Telefono,
    Email,
    TipoCliente,
    Activo
) VALUES
(1, '1098765432', 'Felipe', 'Corredor', 'Masculino', 'Cra 10 #20-30', 4, '3001112233', 'felipe@email.com', 'Natural', TRUE),
(1, '1022334455', 'Laura', 'Ramirez', 'Femenino', 'Calle 45 #12-10', 5, '3002223344', 'laura@email.com', 'Natural', TRUE),
(4, '900123456', 'Comercializadora Andes', 'SAS', 'Empresa', 'Zona Industrial 12', 5, '6014567890', 'contacto@andes.com', 'Empresa', TRUE),
(4, '901987654', 'Tecnología Global', 'SAS', 'Empresa', 'Parque Empresarial Norte', 2, '6024561234', 'ventas@tecnoglobal.com', 'Empresa', TRUE);

-- 12. EMPRESA CLIENTE
INSERT INTO EmpresaCliente (ID_Cliente, RazonSocial, NIT, RepresentanteLegal) VALUES
(3, 'Comercializadora Andes SAS', '900123456', 'Carlos Mendoza'),
(4, 'Tecnología Global SAS', '901987654', 'Diana Rojas');

-- 13. PROVEEDORES
INSERT INTO Proveedor (
    ID_TipoProveedor,
    RazonSocial,
    NIT,
    ContactoPrincipal,
    Telefono,
    Email,
    Direccion,
    ID_Ciudad,
    Activo
) VALUES
(1, 'Distribuciones Tech Colombia', '800111222', 'Juan Perez', '3005551111', 'contacto@techcol.com', 'Zona Franca', 5, TRUE),
(1, 'Mayorista Digital SAS', '900222333', 'Andrea Lopez', '3005552222', 'ventas@mayoristadigital.com', 'Av Industrial 45', 3, TRUE),
(2, 'Shenzhen Hardware Ltd', 'INT-445566', 'Liu Wei', '+861300000000', 'sales@shenzhenhw.com', 'Baoan District', 8, TRUE),
(2, 'Andes Components Chile', 'CL-778899', 'Matias Rojas', '+56912345678', 'contacto@andescomponents.cl', 'Santiago Centro', 6, TRUE);

-- 14. EMPLEADOS
INSERT INTO Empleado (
    ID_TipoDocumento,
    NumeroDocumento,
    Nombres,
    Apellidos,
    Telefono,
    Email,
    Direccion,
    ID_Ciudad,
    ID_Cargo,
    ID_Sede,
    FechaIngreso,
    Estado
) VALUES
(1, '1001001001', 'Ana', 'Martinez', '3007001001', 'ana.martinez@acm.com', 'Cra 11 #10-20', 5, 1, 5, '2024-01-10', TRUE),
(1, '1001001002', 'Luis', 'Gomez', '3007001002', 'luis.gomez@acm.com', 'Calle 9 #8-40', 5, 2, 5, '2024-02-15', TRUE),
(1, '1001001003', 'Sofia', 'Rueda', '3007001003', 'sofia.rueda@acm.com', 'Cra 20 #15-18', 4, 3, 4, '2024-03-01', TRUE),
(1, '1001001004', 'Miguel', 'Torres', '3007001004', 'miguel.torres@acm.com', 'Av 30 #22-11', 3, 4, 3, '2024-01-22', TRUE),
(1, '1001001005', 'Camila', 'Herrera', '3007001005', 'camila.herrera@acm.com', 'Calle 80 #14-50', 2, 5, 2, '2024-04-18', TRUE),
(1, '1001001006', 'Jorge', 'Pabon', '3007001006', 'jorge.pabon@acm.com', 'Cra 5 #7-12', 1, 6, 1, '2024-02-05', TRUE),
(1, '1001001007', 'Natalia', 'Suarez', '3007001007', 'natalia.suarez@acm.com', 'Calle 100 #30-12', 5, 7, 5, '2024-05-01', TRUE);

-- 15. USUARIOS
INSERT INTO Usuario (ID_Empleado, NombreUsuario, ClaveHash, Estado) VALUES
(1, 'admin.acm', 'hash_admin_123', TRUE),
(2, 'coord.ventas', 'hash_coord_123', TRUE),
(3, 'asesor.sofia', 'hash_asesor_123', TRUE),
(4, 'inv.miguel', 'hash_inventario_123', TRUE),
(5, 'aux.camila', 'hash_auxinv_123', TRUE),
(6, 'ger.compra', 'hash_gercompra_123', TRUE),
(7, 'aux.compra', 'hash_auxcompra_123', TRUE);

-- 16. USUARIO ROL
INSERT INTO UsuarioRol (ID_Usuario, ID_Rol) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7);

-- 17. CATEGORIAS
INSERT INTO Categoria (CodigoCategoria, NombreCategoria, Descripcion, Estado) VALUES
('CAT001', 'Memorias USB', 'Dispositivos de almacenamiento USB', TRUE),
('CAT002', 'Discos SSD', 'Unidades de estado sólido', TRUE),
('CAT003', 'Tarjetas Gráficas', 'Componentes GPU para equipos', TRUE),
('CAT004', 'Procesadores', 'CPU para computadores', TRUE),
('CAT005', 'Monitores', 'Pantallas y monitores', TRUE),
('CAT006', 'Periféricos', 'Teclados, mouse y accesorios', TRUE);

-- 18. PRODUCTOS
INSERT INTO Producto (
    CodigoProducto,
    NombreProducto,
    ID_Categoria,
    Descripcion,
    GarantiaEmpresaMeses,
    GarantiaProveedorMeses,
    PorcentajeUtilidad,
    AplicaIVA,
    Estado
) VALUES
('PROD001', 'Memoria USB 64GB Kingston', 1, 'Memoria USB 3.0 de 64GB', 3, 12, 10.00, TRUE, TRUE),
('PROD002', 'SSD Samsung 1TB', 2, 'Disco sólido interno de 1TB', 3, 12, 12.00, TRUE, TRUE),
('PROD003', 'RTX 4060 8GB', 3, 'Tarjeta gráfica de alto rendimiento', 3, 12, 15.00, TRUE, TRUE),
('PROD004', 'Intel Core i7 12700', 4, 'Procesador Intel de 12 generación', 3, 12, 14.00, TRUE, TRUE),
('PROD005', 'Monitor LG 24 Pulgadas', 5, 'Monitor Full HD', 3, 12, 18.00, TRUE, TRUE),
('PROD006', 'Mouse Logitech Inalámbrico', 6, 'Mouse inalámbrico ergonómico', 3, 12, 8.00, TRUE, TRUE);

-- 19. PARAMETROS FISCALES
INSERT INTO ParametroFiscal (
    Anio,
    SalarioMinimo,
    PorcentajeIVA,
    FechaInicio,
    FechaFin
) VALUES
(2025, 1300000.00, 19.00, '2025-01-01', '2025-12-31'),
(2026, 1423500.00, 19.00, '2026-01-01', '2026-12-31');

-- 20. HISTORIAL PRECIOS
INSERT INTO HistorialPrecioProducto (
    ID_Producto,
    FechaInicio,
    FechaFin,
    ValorCompraBase,
    PorcentajeUtilidad,
    ValorVentaBase,
    AplicaIVA,
    PorcentajeIVA
) VALUES
(1, '2026-01-01', NULL, 50000.00, 10.00, 55000.00, TRUE, 19.00),
(2, '2026-01-01', NULL, 280000.00, 12.00, 313600.00, TRUE, 19.00),
(3, '2026-01-01', NULL, 1800000.00, 15.00, 2070000.00, TRUE, 19.00),
(4, '2026-01-01', NULL, 1200000.00, 14.00, 1368000.00, TRUE, 19.00),
(5, '2026-01-01', NULL, 420000.00, 18.00, 495600.00, TRUE, 19.00),
(6, '2026-01-01', NULL, 70000.00, 8.00, 75600.00, TRUE, 19.00);

-- 21. INVENTARIO
INSERT INTO Inventario (
    ID_Producto,
    ID_Bodega,
    CantidadDisponible,
    CantidadReservada,
    StockMinimo,
    StockMaximo
) VALUES
(1, 1, 120, 5, 20, 300),
(1, 5, 200, 10, 30, 500),
(2, 5, 80, 4, 10, 200),
(3, 5, 25, 2, 5, 60),
(4, 3, 40, 1, 8, 100),
(5, 2, 35, 0, 5, 80),
(6, 4, 150, 3, 20, 400);

-- 22. TIPO MOVIMIENTO INVENTARIO
INSERT INTO TipoMovimientoInventario (NombreTipoMovimiento) VALUES
('EntradaCompra'),
('SalidaVenta'),
('EntradaDevolucionCliente'),
('SalidaDevolucionProveedor'),
('SalidaTraslado'),
('EntradaTraslado'),
('AjusteManual');

-- 23. MEDIOS DE PAGO
INSERT INTO MedioPago (NombreMedioPago) VALUES
('Transferencia'),
('Efectivo'),
('Tarjeta'),
('PSE');

-- 24. TIPO GARANTIA
INSERT INTO TipoGarantia (NombreTipoGarantia) VALUES
('Empresa'),
('Proveedor');

-- 25. POLITICAS DE DESCUENTO
INSERT INTO PoliticaDescuento (
    NombrePolitica,
    TipoPolitica,
    MontoMinimo,
    MontoMaximo,
    PorcentajeDescuento,
    Estado,
    FechaInicio,
    FechaFin
) VALUES
('Descuento compra mayor a 200 millones', 'PorMonto', 200000000.00, NULL, 5.00, TRUE, '2026-01-01', NULL),
('Descuento cliente preferencial Andes', 'PorCliente', NULL, NULL, 3.00, TRUE, '2026-01-01', NULL),
('Descuento manual autorizado', 'Manual', NULL, NULL, 10.00, TRUE, '2026-01-01', NULL);

-- 26. CLIENTE POLITICA DESCUENTO
INSERT INTO ClientePoliticaDescuento (ID_Cliente, ID_PoliticaDescuento) VALUES
(3, 2),
(4, 2);

-- 27. RANGOS DE COMISION
INSERT INTO RangoComision (VentaMinima, VentaMaxima, PorcentajeComision) VALUES
(0.00, 999999999.99, 0.00),
(1000000000.00, 2000000000.00, 1.00),
(2000000000.01, 2999999999.99, 1.50),
(3000000000.00, 3999999999.99, 2.00),
(4000000000.00, NULL, 5.00);