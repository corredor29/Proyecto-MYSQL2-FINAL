USE ERP_ACM;

DELIMITER $$

CREATE TRIGGER trg_DescontarInventarioVenta
AFTER INSERT ON DetalleFacturaVenta
FOR EACH ROW
BEGIN
    DECLARE v_ID_BodegaSalida INT;
    DECLARE v_StockActual INT;

    SELECT ID_BodegaSalida
    INTO v_ID_BodegaSalida
    FROM FacturaVenta
    WHERE ID_FacturaVenta = NEW.ID_FacturaVenta;

    SELECT CantidadDisponible
    INTO v_StockActual
    FROM Inventario
    WHERE ID_Producto = NEW.ID_Producto
        AND ID_Bodega = v_ID_BodegaSalida;

    IF v_StockActual IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No existe inventario para este producto en la bodega de salida';
    END IF;

    IF v_StockActual < NEW.Cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente para realizar la venta';
    END IF;

    UPDATE Inventario
    SET CantidadDisponible = CantidadDisponible - NEW.Cantidad
    WHERE ID_Producto = NEW.ID_Producto
        AND ID_Bodega = v_ID_BodegaSalida;
END$$

DELIMITER ;

CREATE TABLE ReporteMensualVentasVendedorProducto (
    ID_Reporte INT PRIMARY KEY AUTO_INCREMENT,
    Anio YEAR NOT NULL,
    Mes TINYINT NOT NULL,
    ID_Empleado INT NOT NULL,
    ID_Producto INT NOT NULL,
    CantidadVendida INT NOT NULL,
    TotalVendido DECIMAL(15,2) NOT NULL,
    FechaGeneracion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ID_Empleado) REFERENCES Empleado(ID_Empleado),
    FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto),
    UNIQUE (Anio, Mes, ID_Empleado, ID_Producto)
);

CREATE TABLE ReporteMensualRotacionProducto (
    ID_ReporteRotacion INT PRIMARY KEY AUTO_INCREMENT,
    Anio YEAR NOT NULL,
    Mes TINYINT NOT NULL,
    ID_Producto INT NOT NULL,
    Entradas INT NOT NULL DEFAULT 0,
    Salidas INT NOT NULL DEFAULT 0,
    StockPromedio DECIMAL(15,2) NOT NULL DEFAULT 0,
    Rotacion DECIMAL(15,2) NOT NULL DEFAULT 0,
    FechaGeneracion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto),
    UNIQUE (Anio, Mes, ID_Producto)
);

DELIMITER $$

CREATE PROCEDURE GenerarReporteMensualVentasVendedorProducto(
    IN p_Anio YEAR,
    IN p_Mes TINYINT
)
BEGIN
    INSERT INTO ReporteMensualVentasVendedorProducto (
        Anio,
        Mes,
        ID_Empleado,
        ID_Producto,
        CantidadVendida,
        TotalVendido
    )
    SELECT
        p_Anio,
        p_Mes,
        fv.ID_EmpleadoVendedor,
        dfv.ID_Producto,
        SUM(dfv.Cantidad) AS CantidadVendida,
        SUM(dfv.TotalLinea) AS TotalVendido
    FROM FacturaVenta fv
    JOIN DetalleFacturaVenta dfv
        ON fv.ID_FacturaVenta = dfv.ID_FacturaVenta
    WHERE YEAR(fv.FechaVenta) = p_Anio
        AND MONTH(fv.FechaVenta) = p_Mes
        AND fv.Estado = 'Activa'
    GROUP BY fv.ID_EmpleadoVendedor, dfv.ID_Producto
    ON DUPLICATE KEY UPDATE
        CantidadVendida = VALUES(CantidadVendida),
        TotalVendido = VALUES(TotalVendido),
        FechaGeneracion = CURRENT_TIMESTAMP;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE GenerarReporteMensualRotacionProducto(
    IN p_Anio YEAR,
    IN p_Mes TINYINT
)
BEGIN
    INSERT INTO ReporteMensualRotacionProducto (
        Anio,
        Mes,
        ID_Producto,
        Entradas,
        Salidas,
        StockPromedio,
        Rotacion
    )
    SELECT
        p_Anio,
        p_Mes,
        p.ID_Producto,
        IFNULL(ent.Entradas, 0) AS Entradas,
        IFNULL(sal.Salidas, 0) AS Salidas,
        IFNULL(inv.StockPromedio, 0) AS StockPromedio,
        CASE
            WHEN IFNULL(inv.StockPromedio, 0) = 0 THEN 0
            ELSE ROUND(IFNULL(sal.Salidas, 0) / inv.StockPromedio, 2)
        END AS Rotacion
    FROM Producto p
    LEFT JOIN (
        SELECT
            mi.ID_Producto,
            SUM(mi.Cantidad) AS Entradas
        FROM MovimientoInventario mi
        JOIN TipoMovimientoInventario tmi
            ON mi.ID_TipoMovimiento = tmi.ID_TipoMovimiento
        WHERE YEAR(mi.FechaMovimiento) = p_Anio
          AND MONTH(mi.FechaMovimiento) = p_Mes
          AND tmi.NombreTipoMovimiento IN ('EntradaCompra', 'EntradaDevolucionCliente', 'EntradaTraslado')
        GROUP BY mi.ID_Producto
    ) ent
        ON p.ID_Producto = ent.ID_Producto
    LEFT JOIN (
        SELECT
            mi.ID_Producto,
            SUM(mi.Cantidad) AS Salidas
        FROM MovimientoInventario mi
        JOIN TipoMovimientoInventario tmi
            ON mi.ID_TipoMovimiento = tmi.ID_TipoMovimiento
        WHERE YEAR(mi.FechaMovimiento) = p_Anio
            AND MONTH(mi.FechaMovimiento) = p_Mes
            AND tmi.NombreTipoMovimiento IN ('SalidaVenta', 'SalidaTraslado', 'SalidaDevolucionProveedor')
        GROUP BY mi.ID_Producto
    ) sal
        ON p.ID_Producto = sal.ID_Producto
    LEFT JOIN (
        SELECT
            ID_Producto,
            AVG(CantidadDisponible) AS StockPromedio
        FROM Inventario
        GROUP BY ID_Producto
    ) inv
        ON p.ID_Producto = inv.ID_Producto
    ON DUPLICATE KEY UPDATE
        Entradas = VALUES(Entradas),
        Salidas = VALUES(Salidas),
        StockPromedio = VALUES(StockPromedio),
        Rotacion = VALUES(Rotacion),
        FechaGeneracion = CURRENT_TIMESTAMP;
END$$

DELIMITER ;

DELIMITER $$

CREATE EVENT ev_ReporteMensualVentasVendedorProducto
ON SCHEDULE EVERY 1 MONTH
STARTS '2026-04-01 00:10:00'
DO
BEGIN
    CALL GenerarReporteMensualVentasVendedorProducto(
        YEAR(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)),
        MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE EVENT ev_ReporteMensualRotacionProducto
ON SCHEDULE EVERY 1 MONTH
STARTS '2026-04-01 00:20:00'
DO
BEGIN
    CALL GenerarReporteMensualRotacionProducto(
        YEAR(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)),
        MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
    );
END$$

DELIMITER ;

SELECT
    r.Anio,
    r.Mes,
    CONCAT(e.Nombres, ' ', e.Apellidos) AS Vendedor,
    p.NombreProducto,
    r.CantidadVendida,
    r.TotalVendido
FROM ReporteMensualVentasVendedorProducto r
JOIN Empleado e ON r.ID_Empleado = e.ID_Empleado
JOIN Producto p ON r.ID_Producto = p.ID_Producto
ORDER BY r.Anio DESC, r.Mes DESC, r.TotalVendido DESC;

SELECT
    r.Anio,
    r.Mes,
    p.NombreProducto,
    r.Entradas,
    r.Salidas,
    r.StockPromedio,
    r.Rotacion
FROM ReporteMensualRotacionProducto r
JOIN Producto p ON r.ID_Producto = p.ID_Producto
ORDER BY r.Anio DESC, r.Mes DESC, r.Rotacion DESC;

