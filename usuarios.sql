USE ERP_ACM;

CREATE USER IF NOT EXISTS 'admin_erp'@'localhost' IDENTIFIED BY 'Admin123*';
CREATE USER IF NOT EXISTS 'gerente_erp'@'localhost' IDENTIFIED BY 'Gerente123*';
CREATE USER IF NOT EXISTS 'cajero_erp'@'localhost' IDENTIFIED BY 'Cajero123*';
CREATE USER IF NOT EXISTS 'bodeguero_erp'@'localhost' IDENTIFIED BY 'Bodega123*';
CREATE USER IF NOT EXISTS 'asesor_erp'@'localhost' IDENTIFIED BY 'Asesor123*';
CREATE USER IF NOT EXISTS 'contador_erp'@'localhost' IDENTIFIED BY 'Contador123*';
CREATE USER IF NOT EXISTS 'app_backend'@'localhost' IDENTIFIED BY 'Backend123*';

GRANT ALL PRIVILEGES ON ERP_ACM.* TO 'admin_erp'@'localhost';

GRANT SELECT ON ERP_ACM.* TO 'gerente_erp'@'localhost';

-- 4. CAJERO / VENDEDOR
-- VENTAS, CLIENTES, PAGOS, LECTURA INVENTARIO
GRANT SELECT, INSERT, UPDATE ON ERP_ACM.Clientes TO 'cajero_erp'@'localhost';
GRANT SELECT, INSERT, UPDATE ON ERP_ACM.FacturaVenta TO 'cajero_erp'@'localhost';
GRANT SELECT, INSERT, UPDATE ON ERP_ACM.DetalleFacturaVenta TO 'cajero_erp'@'localhost';
GRANT SELECT, INSERT, UPDATE ON ERP_ACM.PagoVenta TO 'cajero_erp'@'localhost';
GRANT SELECT ON ERP_ACM.Inventario TO 'cajero_erp'@'localhost';
GRANT SELECT ON ERP_ACM.Producto TO 'cajero_erp'@'localhost';
GRANT SELECT ON ERP_ACM.Bodega TO 'cajero_erp'@'localhost';

-- 5. BODEGUERO
-- INVENTARIO, COMPRAS, TRASLADOS
GRANT SELECT, INSERT, UPDATE ON ERP_ACM.Inventario TO 'bodeguero_erp'@'localhost';
GRANT SELECT, INSERT, UPDATE ON ERP_ACM.FacturaCompra TO 'bodeguero_erp'@'localhost';
GRANT SELECT, INSERT, UPDATE ON ERP_ACM.DetalleFacturaCompra TO 'bodeguero_erp'@'localhost';
GRANT SELECT, INSERT, UPDATE ON ERP_ACM.TrasladoBodega TO 'bodeguero_erp'@'localhost';
GRANT SELECT, INSERT, UPDATE ON ERP_ACM.DetalleTrasladoBodega TO 'bodeguero_erp'@'localhost';
GRANT SELECT ON ERP_ACM.Producto TO 'bodeguero_erp'@'localhost';
GRANT SELECT ON ERP_ACM.Bodega TO 'bodeguero_erp'@'localhost';
GRANT SELECT ON ERP_ACM.Proveedor TO 'bodeguero_erp'@'localhost';

-- 6. ASESOR COMERCIAL
-- SUS VENTAS Y COMISIONES
-- MYSQL NO CONTROLA "SOLO SUS DATOS" FÁCILMENTE,
-- ASÍ QUE AQUÍ SE DA ACCESO GENERAL A ESAS TABLAS
-- Y ESO SE FILTRA DESDE LA APP
GRANT SELECT, INSERT, UPDATE ON ERP_ACM.FacturaVenta TO 'asesor_erp'@'localhost';
GRANT SELECT, INSERT, UPDATE ON ERP_ACM.DetalleFacturaVenta TO 'asesor_erp'@'localhost';
GRANT SELECT ON ERP_ACM.ComisionMensualVendedor TO 'asesor_erp'@'localhost';
GRANT SELECT, INSERT, UPDATE ON ERP_ACM.Clientes TO 'asesor_erp'@'localhost';
GRANT SELECT ON ERP_ACM.Producto TO 'asesor_erp'@'localhost';
GRANT SELECT ON ERP_ACM.Inventario TO 'asesor_erp'@'localhost';

-- 7. CONTADOR
-- FACTURAS, PAGOS, REPORTES, SOLO LECTURA
GRANT SELECT ON ERP_ACM.FacturaVenta TO 'contador_erp'@'localhost';
GRANT SELECT ON ERP_ACM.DetalleFacturaVenta TO 'contador_erp'@'localhost';
GRANT SELECT ON ERP_ACM.FacturaCompra TO 'contador_erp'@'localhost';
GRANT SELECT ON ERP_ACM.DetalleFacturaCompra TO 'contador_erp'@'localhost';
GRANT SELECT ON ERP_ACM.PagoVenta TO 'contador_erp'@'localhost';
GRANT SELECT ON ERP_ACM.ComisionMensualVendedor TO 'contador_erp'@'localhost';
GRANT SELECT ON ERP_ACM.Auditoria TO 'contador_erp'@'localhost';

-- 8. APP BACKEND
-- SOLO EJECUTAR PROCEDIMIENTOS
GRANT EXECUTE ON PROCEDURE ERP_ACM.RegistrarCliente TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.RegistrarProveedor TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.RegistrarProducto TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.RegistrarFacturaCompra TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.RegistrarDetalleCompra TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.RegistrarFacturaVenta TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.RegistrarDetalleVenta TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.RegistrarPagoVenta TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.RegistrarTrasladoBodega TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.RegistrarDetalleTraslado TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.CalcularComisionVendedor TO 'app_backend'@'localhost';

GRANT EXECUTE ON PROCEDURE ERP_ACM.ReporteInventarioPorBodega TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.ReporteBajoStock TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.ReporteVentasPorFechas TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.ReporteComprasPorFechas TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.ReporteVentasPorVendedor TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.ReporteTotalVendidoPorVendedor TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.ReporteClientesTop TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.ReporteProductosMasVendidos TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.ReporteMovimientosInventario TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.ReporteComisionesMensuales TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.ReporteGarantias TO 'app_backend'@'localhost';
GRANT EXECUTE ON PROCEDURE ERP_ACM.ReporteTraslados TO 'app_backend'@'localhost';

-- 9. APLICAR CAMBIOS
FLUSH PRIVILEGES;