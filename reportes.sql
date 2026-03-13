USE ERP_ACM;

DELIMITER $$

-- REPORTE INVENTARIO POR BODEGA
CREATE PROCEDURE ReporteInventarioPorBodega(IN p_ID_Bodega INT)
BEGIN
    SELECT
        b.NombreBodega,
        c.NombreCiudad,
        p.CodigoProducto,
        p.NombreProducto,
        ca.NombreCategoria,
        i.CantidadDisponible,
        i.CantidadReservada,
        i.StockMinimo,
        i.StockMaximo
    FROM Inventario i
    JOIN Bodega b ON i.ID_Bodega = b.ID_Bodega
    JOIN Ciudad c ON b.ID_Ciudad = c.ID_Ciudad
    JOIN Producto p ON i.ID_Producto = p.ID_Producto
    JOIN Categoria ca ON p.ID_Categoria = ca.ID_Categoria
    WHERE i.ID_Bodega = p_ID_Bodega
    ORDER BY p.NombreProducto;
END$$


-- REPORTE PRODUCTOS CON BAJO STOCK
CREATE PROCEDURE ReporteBajoStock()
BEGIN
    SELECT
        b.NombreBodega,
        c.NombreCiudad,
        p.CodigoProducto,
        p.NombreProducto,
        i.CantidadDisponible,
        i.StockMinimo
    FROM Inventario i
    JOIN Bodega b ON i.ID_Bodega = b.ID_Bodega
    JOIN Ciudad c ON b.ID_Ciudad = c.ID_Ciudad
    JOIN Producto p ON i.ID_Producto = p.ID_Producto
    WHERE i.CantidadDisponible <= i.StockMinimo
    ORDER BY b.NombreBodega, p.NombreProducto;
END$$


-- REPORTE VENTAS POR FECHA
CREATE PROCEDURE ReporteVentasPorFechas(
    IN p_FechaInicio DATE,
    IN p_FechaFin DATE
)
BEGIN
    SELECT
        fv.NumeroFacturaVenta,
        fv.FechaVenta,
        CONCAT(cl.Nombre,' ',cl.Apellidos) AS Cliente,
        CONCAT(e.Nombres,' ',e.Apellidos) AS Vendedor,
        b.NombreBodega,
        fv.TipoVenta,
        fv.Subtotal,
        fv.DescuentoManual,
        fv.DescuentoPorVolumen,
        fv.IVA,
        fv.Total,
        fv.Estado
    FROM FacturaVenta fv
    JOIN Clientes cl ON fv.ID_Cliente = cl.ID_Cliente
    JOIN Empleado e ON fv.ID_EmpleadoVendedor = e.ID_Empleado
    JOIN Bodega b ON fv.ID_BodegaSalida = b.ID_Bodega
    WHERE DATE(fv.FechaVenta) BETWEEN p_FechaInicio AND p_FechaFin
    ORDER BY fv.FechaVenta;
END$$


-- REPORTE COMPRAS POR FECHA
CREATE PROCEDURE ReporteComprasPorFechas(
    IN p_FechaInicio DATE,
    IN p_FechaFin DATE
)
BEGIN
    SELECT
        fc.NumeroFacturaCompra,
        fc.FechaCompra,
        pr.RazonSocial AS Proveedor,
        b.NombreBodega,
        fc.Subtotal,
        fc.IVA,
        fc.Total,
        fc.Estado
    FROM FacturaCompra fc
    JOIN Proveedor pr ON fc.ID_Proveedor = pr.ID_Proveedor
    JOIN Bodega b ON fc.ID_BodegaDestino = b.ID_Bodega
    WHERE DATE(fc.FechaCompra) BETWEEN p_FechaInicio AND p_FechaFin
    ORDER BY fc.FechaCompra;
END$$


-- REPORTE VENTAS POR VENDEDOR
CREATE PROCEDURE ReporteVentasPorVendedor(IN p_ID_Empleado INT)
BEGIN
    SELECT
        CONCAT(e.Nombres,' ',e.Apellidos) AS Vendedor,
        fv.NumeroFacturaVenta,
        fv.FechaVenta,
        CONCAT(cl.Nombre,' ',cl.Apellidos) AS Cliente,
        fv.Total,
        fv.Estado
    FROM FacturaVenta fv
    JOIN Empleado e ON fv.ID_EmpleadoVendedor = e.ID_Empleado
    JOIN Clientes cl ON fv.ID_Cliente = cl.ID_Cliente
    WHERE fv.ID_EmpleadoVendedor = p_ID_Empleado
    ORDER BY fv.FechaVenta;
END$$


-- REPORTE TOTAL VENDIDO POR VENDEDOR
CREATE PROCEDURE ReporteTotalVendidoPorVendedor()
BEGIN
    SELECT
        e.ID_Empleado,
        CONCAT(e.Nombres,' ',e.Apellidos) AS Vendedor,
        COUNT(fv.ID_FacturaVenta) AS CantidadVentas,
        IFNULL(SUM(fv.Total),0) AS TotalVendido
    FROM Empleado e
    LEFT JOIN FacturaVenta fv
        ON e.ID_Empleado = fv.ID_EmpleadoVendedor
        AND fv.Estado='Activa'
    GROUP BY e.ID_Empleado,e.Nombres,e.Apellidos
    ORDER BY TotalVendido DESC;
END$$


-- REPORTE CLIENTES QUE MÁS COMPRAN
CREATE PROCEDURE ReporteClientesTop()
BEGIN
    SELECT
        cl.ID_Cliente,
        CONCAT(cl.Nombre,' ',cl.Apellidos) AS Cliente,
        COUNT(fv.ID_FacturaVenta) AS CantidadCompras,
        IFNULL(SUM(fv.Total),0) AS TotalComprado
    FROM Clientes cl
    LEFT JOIN FacturaVenta fv
        ON cl.ID_Cliente = fv.ID_Cliente
        AND fv.Estado='Activa'
    GROUP BY cl.ID_Cliente,cl.Nombre,cl.Apellidos
    ORDER BY TotalComprado DESC;
END$$


-- REPORTE PRODUCTOS MÁS VENDIDOS
CREATE PROCEDURE ReporteProductosMasVendidos()
BEGIN
    SELECT
        p.ID_Producto,
        p.CodigoProducto,
        p.NombreProducto,
        SUM(dfv.Cantidad) AS TotalUnidadesVendidas,
        SUM(dfv.TotalLinea) AS TotalVendido
    FROM DetalleFacturaVenta dfv
    JOIN Producto p ON dfv.ID_Producto = p.ID_Producto
    JOIN FacturaVenta fv ON dfv.ID_FacturaVenta = fv.ID_FacturaVenta
    WHERE fv.Estado='Activa'
    GROUP BY p.ID_Producto,p.CodigoProducto,p.NombreProducto
    ORDER BY TotalUnidadesVendidas DESC;
END$$


-- REPORTE MOVIMIENTOS INVENTARIO
CREATE PROCEDURE ReporteMovimientosInventario(IN p_ID_Producto INT)
BEGIN
    SELECT
        mi.FechaMovimiento,
        tmi.NombreTipoMovimiento,
        p.CodigoProducto,
        p.NombreProducto,
        bo.NombreBodega AS BodegaOrigen,
        bd.NombreBodega AS BodegaDestino,
        mi.Cantidad,
        mi.CostoUnitario,
        mi.ReferenciaDocumento,
        mi.Observacion
    FROM MovimientoInventario mi
    JOIN TipoMovimientoInventario tmi ON mi.ID_TipoMovimiento = tmi.ID_TipoMovimiento
    JOIN Producto p ON mi.ID_Producto = p.ID_Producto
    LEFT JOIN Bodega bo ON mi.ID_BodegaOrigen = bo.ID_Bodega
    LEFT JOIN Bodega bd ON mi.ID_BodegaDestino = bd.ID_Bodega
    WHERE mi.ID_Producto = p_ID_Producto
    ORDER BY mi.FechaMovimiento DESC;
END$$


-- REPORTE COMISIONES
CREATE PROCEDURE ReporteComisionesMensuales(
    IN p_Anio YEAR,
    IN p_Mes TINYINT
)
BEGIN
    SELECT
        CONCAT(e.Nombres,' ',e.Apellidos) AS Vendedor,
        cmv.Anio,
        cmv.Mes,
        cmv.TotalVendido,
        cmv.PorcentajeAplicado,
        cmv.ValorComision,
        cmv.FechaCalculo
    FROM ComisionMensualVendedor cmv
    JOIN Empleado e ON cmv.ID_Empleado = e.ID_Empleado
    WHERE cmv.Anio = p_Anio
    AND cmv.Mes = p_Mes
    ORDER BY cmv.ValorComision DESC;
END$$


-- REPORTE GARANTÍAS
CREATE PROCEDURE ReporteGarantias()
BEGIN
    SELECT
        sg.ID_SolicitudGarantia,
        sg.FechaSolicitud,
        CONCAT(cl.Nombre,' ',cl.Apellidos) AS Cliente,
        fv.NumeroFacturaVenta,
        sg.Motivo,
        sg.Estado
    FROM SolicitudGarantia sg
    JOIN Clientes cl ON sg.ID_Cliente = cl.ID_Cliente
    JOIN FacturaVenta fv ON sg.ID_FacturaVenta = fv.ID_FacturaVenta
    ORDER BY sg.FechaSolicitud DESC;
END$$


-- REPORTE TRASLADOS BODEGA
CREATE PROCEDURE ReporteTraslados()
BEGIN
    SELECT
        tb.ID_Traslado,
        tb.FechaTraslado,
        bo.NombreBodega AS BodegaOrigen,
        bd.NombreBodega AS BodegaDestino,
        tb.Estado,
        tb.Observacion
    FROM TrasladoBodega tb
    JOIN Bodega bo ON tb.ID_BodegaOrigen = bo.ID_Bodega
    JOIN Bodega bd ON tb.ID_BodegaDestino = bd.ID_Bodega
    ORDER BY tb.FechaTraslado DESC;
END$$

DELIMITER ;