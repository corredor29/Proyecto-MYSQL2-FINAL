USE ERP_ACM;

-- 1. Vista de productos con su categoría
CREATE VIEW Vista_Productos_Categoria AS
SELECT
    p.ID_Producto,
    p.CodigoProducto,
    p.NombreProducto,
    c.CodigoCategoria,
    c.NombreCategoria,
    p.PorcentajeUtilidad,
    p.AplicaIVA,
    p.GarantiaEmpresaMeses,
    p.GarantiaProveedorMeses,
    p.Estado
FROM Producto p
JOIN Categoria c
    ON p.ID_Categoria = c.ID_Categoria;

-- 2. Vista de clientes con ciudad
CREATE VIEW Vista_Clientes_Ciudad AS
SELECT
    cl.ID_Cliente,
    td.NombreTipoDocumento,
    cl.NumeroDocumento,
    cl.Nombre,
    cl.Apellidos,
    cl.TipoCliente,
    cl.Telefono,
    cl.Email,
    cl.Direccion,
    ci.NombreCiudad,
    cl.Activo
FROM Clientes cl
JOIN TipoDocumento td
    ON cl.ID_TipoDocumento = td.ID_TipoDocumento
JOIN Ciudad ci
    ON cl.ID_Ciudad = ci.ID_Ciudad;

-- 3. Vista de clientes empresa
CREATE VIEW Vista_Clientes_Empresa AS
SELECT
    cl.ID_Cliente,
    cl.NumeroDocumento,
    ec.RazonSocial,
    ec.NIT,
    ec.RepresentanteLegal,
    cl.Telefono,
    cl.Email,
    ci.NombreCiudad,
    cl.Activo
FROM EmpresaCliente ec
JOIN Clientes cl
    ON ec.ID_Cliente = cl.ID_Cliente
JOIN Ciudad ci
    ON cl.ID_Ciudad = ci.ID_Ciudad;

-- 4. Vista de proveedores con tipo y ciudad
CREATE VIEW Vista_Proveedores AS
SELECT
    p.ID_Proveedor,
    tp.NombreTipoProveedor,
    p.RazonSocial,
    p.NIT,
    p.ContactoPrincipal,
    p.Telefono,
    p.Email,
    p.Direccion,
    c.NombreCiudad,
    p.Activo
FROM Proveedor p
JOIN TipoProveedor tp
    ON p.ID_TipoProveedor = tp.ID_TipoProveedor
JOIN Ciudad c
    ON p.ID_Ciudad = c.ID_Ciudad;

-- 5. Vista de empleados con cargo y sede
CREATE VIEW Vista_Empleados AS
SELECT
    e.ID_Empleado,
    e.NumeroDocumento,
    e.Nombres,
    e.Apellidos,
    e.Telefono,
    e.Email,
    c.NombreCargo,
    s.NombreSede,
    ci.NombreCiudad,
    e.FechaIngreso,
    e.Estado
FROM Empleado e
JOIN Cargo c
    ON e.ID_Cargo = c.ID_Cargo
JOIN Sede s
    ON e.ID_Sede = s.ID_Sede
JOIN Ciudad ci
    ON e.ID_Ciudad = ci.ID_Ciudad;

-- 6. Vista de usuarios con empleado
CREATE VIEW Vista_Usuarios_Empleados AS
SELECT
    u.ID_Usuario,
    u.NombreUsuario,
    e.Nombres,
    e.Apellidos,
    u.Estado
FROM Usuario u
JOIN Empleado e
    ON u.ID_Empleado = e.ID_Empleado;

-- 7. Vista de usuarios con roles
CREATE VIEW Vista_Usuarios_Roles AS
SELECT
    u.ID_Usuario,
    u.NombreUsuario,
    r.NombreRol
FROM UsuarioRol ur
JOIN Usuario u
    ON ur.ID_Usuario = u.ID_Usuario
JOIN Rol r
    ON ur.ID_Rol = r.ID_Rol;

-- 8. Vista de inventario por bodega
CREATE VIEW Vista_Inventario_Bodega AS
SELECT
    i.ID_Inventario,
    b.NombreBodega,
    ci.NombreCiudad,
    p.CodigoProducto,
    p.NombreProducto,
    cat.NombreCategoria,
    i.CantidadDisponible,
    i.CantidadReservada,
    i.StockMinimo,
    i.StockMaximo
FROM Inventario i
JOIN Bodega b
    ON i.ID_Bodega = b.ID_Bodega
JOIN Ciudad ci
    ON b.ID_Ciudad = ci.ID_Ciudad
JOIN Producto p
    ON i.ID_Producto = p.ID_Producto
JOIN Categoria cat
    ON p.ID_Categoria = cat.ID_Categoria;

-- 9. Vista de productos con precios actuales
CREATE VIEW Vista_Precios_Actuales AS
SELECT
    p.ID_Producto,
    p.CodigoProducto,
    p.NombreProducto,
    hp.ValorCompraBase,
    hp.PorcentajeUtilidad,
    hp.ValorVentaBase,
    hp.PorcentajeIVA,
    hp.AplicaIVA,
    hp.FechaInicio,
    hp.FechaFin
FROM Producto p
JOIN HistorialPrecioProducto hp
    ON p.ID_Producto = hp.ID_Producto
WHERE hp.FechaFin IS NULL;

-- 10. Vista de facturas de compra
CREATE VIEW Vista_Facturas_Compra AS
SELECT
    fc.ID_FacturaCompra,
    fc.NumeroFacturaCompra,
    fc.FechaCompra,
    pr.RazonSocial AS Proveedor,
    b.NombreBodega,
    fc.Subtotal,
    fc.IVA,
    fc.Total,
    fc.Estado
FROM FacturaCompra fc
JOIN Proveedor pr
    ON fc.ID_Proveedor = pr.ID_Proveedor
JOIN Bodega b
    ON fc.ID_BodegaDestino = b.ID_Bodega;

-- 11. Vista detalle de compra
CREATE VIEW Vista_Detalle_Factura_Compra AS
SELECT
    fc.NumeroFacturaCompra,
    fc.FechaCompra,
    pr.RazonSocial AS Proveedor,
    p.CodigoProducto,
    p.NombreProducto,
    dfc.Cantidad,
    dfc.ValorUnitarioCompra,
    dfc.PorcentajeUtilidadAplicado,
    dfc.ValorUnitarioVentaSugerido,
    dfc.PorcentajeIVA,
    dfc.SubtotalLinea,
    dfc.TotalLinea
FROM DetalleFacturaCompra dfc
JOIN FacturaCompra fc
    ON dfc.ID_FacturaCompra = fc.ID_FacturaCompra
JOIN Proveedor pr
    ON fc.ID_Proveedor = pr.ID_Proveedor
JOIN Producto p
    ON dfc.ID_Producto = p.ID_Producto;

-- 12. Vista de facturas de venta
CREATE VIEW Vista_Facturas_Venta AS
SELECT
    fv.ID_FacturaVenta,
    fv.NumeroFacturaVenta,
    fv.FechaVenta,
    CONCAT(cl.Nombre, ' ', cl.Apellidos) AS Cliente,
    CONCAT(e.Nombres, ' ', e.Apellidos) AS Vendedor,
    b.NombreBodega,
    fv.TipoVenta,
    fv.Subtotal,
    fv.DescuentoManual,
    fv.DescuentoPorVolumen,
    fv.IVA,
    fv.Total,
    fv.Estado
FROM FacturaVenta fv
JOIN Clientes cl
    ON fv.ID_Cliente = cl.ID_Cliente
JOIN Empleado e
    ON fv.ID_EmpleadoVendedor = e.ID_Empleado
JOIN Bodega b
    ON fv.ID_BodegaSalida = b.ID_Bodega;

-- 13. Vista detalle de venta
CREATE VIEW Vista_Detalle_Factura_Venta AS
SELECT
    fv.NumeroFacturaVenta,
    fv.FechaVenta,
    CONCAT(cl.Nombre, ' ', cl.Apellidos) AS Cliente,
    p.CodigoProducto,
    p.NombreProducto,
    dfv.Cantidad,
    dfv.ValorUnitarioVenta,
    dfv.PorcentajeDescuento,
    dfv.ValorDescuento,
    dfv.PorcentajeIVA,
    dfv.SubtotalLinea,
    dfv.TotalLinea
FROM DetalleFacturaVenta dfv
JOIN FacturaVenta fv
    ON dfv.ID_FacturaVenta = fv.ID_FacturaVenta
JOIN Clientes cl
    ON fv.ID_Cliente = cl.ID_Cliente
JOIN Producto p
    ON dfv.ID_Producto = p.ID_Producto;

-- 14. Vista de pagos de ventas
CREATE VIEW Vista_Pagos_Ventas AS
SELECT
    pv.ID_PagoVenta,
    fv.NumeroFacturaVenta,
    mp.NombreMedioPago,
    pv.FechaPago,
    pv.ValorPagado,
    pv.ReferenciaPago
FROM PagoVenta pv
JOIN FacturaVenta fv
    ON pv.ID_FacturaVenta = fv.ID_FacturaVenta
JOIN MedioPago mp
    ON pv.ID_MedioPago = mp.ID_MedioPago;

-- 15. Vista de movimientos de inventario
CREATE VIEW Vista_Movimientos_Inventario AS
SELECT
    mi.ID_Movimiento,
    tmi.NombreTipoMovimiento,
    mi.FechaMovimiento,
    p.CodigoProducto,
    p.NombreProducto,
    bo.NombreBodega AS BodegaOrigen,
    bd.NombreBodega AS BodegaDestino,
    mi.Cantidad,
    mi.CostoUnitario,
    mi.ReferenciaDocumento,
    mi.Observacion
FROM MovimientoInventario mi
JOIN TipoMovimientoInventario tmi
    ON mi.ID_TipoMovimiento = tmi.ID_TipoMovimiento
JOIN Producto p
    ON mi.ID_Producto = p.ID_Producto
LEFT JOIN Bodega bo
    ON mi.ID_BodegaOrigen = bo.ID_Bodega
LEFT JOIN Bodega bd
    ON mi.ID_BodegaDestino = bd.ID_Bodega;

-- 16. Vista de traslados entre bodegas
CREATE VIEW Vista_Traslados_Bodega AS
SELECT
    tb.ID_Traslado,
    tb.FechaTraslado,
    bo.NombreBodega AS BodegaOrigen,
    bd.NombreBodega AS BodegaDestino,
    tb.Estado,
    tb.Observacion
FROM TrasladoBodega tb
JOIN Bodega bo
    ON tb.ID_BodegaOrigen = bo.ID_Bodega
JOIN Bodega bd
    ON tb.ID_BodegaDestino = bd.ID_Bodega;

-- 17. Vista detalle de traslados
CREATE VIEW Vista_Detalle_Traslado AS
SELECT
    tb.ID_Traslado,
    tb.FechaTraslado,
    bo.NombreBodega AS BodegaOrigen,
    bd.NombreBodega AS BodegaDestino,
    p.CodigoProducto,
    p.NombreProducto,
    dtb.Cantidad
FROM DetalleTrasladoBodega dtb
JOIN TrasladoBodega tb
    ON dtb.ID_Traslado = tb.ID_Traslado
JOIN Producto p
    ON dtb.ID_Producto = p.ID_Producto
JOIN Bodega bo
    ON tb.ID_BodegaOrigen = bo.ID_Bodega
JOIN Bodega bd
    ON tb.ID_BodegaDestino = bd.ID_Bodega;

-- 18. Vista de garantías
CREATE VIEW Vista_Garantias AS
SELECT
    sg.ID_SolicitudGarantia,
    sg.FechaSolicitud,
    CONCAT(cl.Nombre, ' ', cl.Apellidos) AS Cliente,
    fv.NumeroFacturaVenta,
    sg.Motivo,
    sg.Estado
FROM SolicitudGarantia sg
JOIN Clientes cl
    ON sg.ID_Cliente = cl.ID_Cliente
JOIN FacturaVenta fv
    ON sg.ID_FacturaVenta = fv.ID_FacturaVenta;

-- 19. Vista detalle de garantías
CREATE VIEW Vista_Detalle_Garantias AS
SELECT
    sg.ID_SolicitudGarantia,
    fv.NumeroFacturaVenta,
    p.CodigoProducto,
    p.NombreProducto,
    dsg.Cantidad,
    dsg.FechaVencimientoGarantiaEmpresa,
    dsg.FechaVencimientoGarantiaProveedor,
    dsg.AplicaGarantiaEmpresa,
    dsg.AplicaGarantiaProveedor,
    dsg.Resultado
FROM DetalleSolicitudGarantia dsg
JOIN SolicitudGarantia sg
    ON dsg.ID_SolicitudGarantia = sg.ID_SolicitudGarantia
JOIN FacturaVenta fv
    ON sg.ID_FacturaVenta = fv.ID_FacturaVenta
JOIN Producto p
    ON dsg.ID_Producto = p.ID_Producto;

-- 20. Vista de comisiones mensuales
CREATE VIEW Vista_Comisiones_Mensuales AS
SELECT
    cmv.ID_ComisionMensual,
    CONCAT(e.Nombres, ' ', e.Apellidos) AS Vendedor,
    cmv.Anio,
    cmv.Mes,
    cmv.TotalVendido,
    rc.PorcentajeComision,
    cmv.ValorComision,
    cmv.FechaCalculo
FROM ComisionMensualVendedor cmv
JOIN Empleado e
    ON cmv.ID_Empleado = e.ID_Empleado
LEFT JOIN RangoComision rc
    ON cmv.ID_RangoComision = rc.ID_RangoComision;

-- 21. Vista de auditoría
CREATE VIEW Vista_Auditoria AS
SELECT
    a.ID_Auditoria,
    a.TablaAfectada,
    a.ID_RegistroAfectado,
    a.Accion,
    a.FechaHora,
    u.NombreUsuario,
    a.ValorAnterior,
    a.ValorNuevo
FROM Auditoria a
LEFT JOIN Usuario u
    ON a.ID_Usuario = u.ID_Usuario;