-- Registrar clientes
DELIMITER $$

CREATE PROCEDURE RegistrarCliente(
    IN p_ID_TipoDocumento INT,
    IN p_NumeroDocumento VARCHAR(30),
    IN p_Nombre VARCHAR(30),
    IN p_Apellidos VARCHAR(30),
    IN p_Genero VARCHAR(30),
    IN p_Direccion VARCHAR(30),
    IN p_ID_Ciudad INT,
    IN p_Telefono VARCHAR(30),
    IN p_Email VARCHAR(30),
    IN p_TipoCliente ENUM('Natural','Empresa')
)
BEGIN
    INSERT INTO Clientes(
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
    )
    VALUES(
        p_ID_TipoDocumento,
        p_NumeroDocumento,
        p_Nombre,
        p_Apellidos,
        p_Genero,
        p_Direccion,
        p_ID_Ciudad,
        p_Telefono,
        p_Email,
        p_TipoCliente,
        TRUE
    );
END$$

DELIMITER ;

-- registrar proveedores

DELIMITER $$

CREATE PROCEDURE RegistrarProveedor(
    IN p_ID_TipoProveedor INT,
    IN p_RazonSocial VARCHAR(30),
    IN p_IdentificacionFiscal VARCHAR(30),
    IN p_ContactoPrincipal VARCHAR(30),
    IN p_Telefono VARCHAR(30),
    IN p_Email VARCHAR(30),
    IN p_Direccion VARCHAR(30),
    IN p_ID_Ciudad INT
)
BEGIN
    INSERT INTO Proveedor(
        ID_TipoProveedor,
        RazonSocial,
        IdentificacionFiscal,
        ContactoPrincipal,
        Telefono,
        Email,
        Direccion,
        ID_Ciudad,
        Activo
    )
    VALUES(
        p_ID_TipoProveedor,
        p_RazonSocial,
        p_IdentificacionFiscal,
        p_ContactoPrincipal,
        p_Telefono,
        p_Email,
        p_Direccion,
        p_ID_Ciudad,
        TRUE
    );
END$$

DELIMITER ;

-- registrar producto

DELIMITER $$

CREATE PROCEDURE RegistrarProducto(
    IN p_CodigoProducto VARCHAR(20),
    IN p_NombreProducto VARCHAR(80),
    IN p_ID_Categoria INT,
    IN p_Descripcion VARCHAR(150),
    IN p_GarantiaEmpresaMeses INT,
    IN p_GarantiaProveedorMeses INT,
    IN p_PorcentajeUtilidad DECIMAL(5,2),
    IN p_AplicaIVA BOOLEAN
)
BEGIN
    INSERT INTO Producto(
        CodigoProducto,
        NombreProducto,
        ID_Categoria,
        Descripcion,
        GarantiaEmpresaMeses,
        GarantiaProveedorMeses,
        PorcentajeUtilidad,
        AplicaIVA,
        Estado
    )
    VALUES(
        p_CodigoProducto,
        p_NombreProducto,
        p_ID_Categoria,
        p_Descripcion,
        p_GarantiaEmpresaMeses,
        p_GarantiaProveedorMeses,
        p_PorcentajeUtilidad,
        p_AplicaIVA,
        TRUE
    );
END$$

DELIMITER ;

-- Registrar compra 

DELIMITER $$

CREATE PROCEDURE RegistrarFacturaCompra(
    IN p_NumeroFacturaCompra VARCHAR(30),
    IN p_ID_Proveedor INT,
    IN p_ID_BodegaDestino INT,
    IN p_Subtotal DECIMAL(15,2),
    IN p_IVA DECIMAL(15,2),
    IN p_Total DECIMAL(15,2),
    IN p_FotoFactura VARCHAR(255),
    IN p_ID_UsuarioRegistro INT
)
BEGIN
    INSERT INTO FacturaCompra(
        NumeroFacturaCompra,
        ID_Proveedor,
        ID_BodegaDestino,
        Subtotal,
        IVA,
        Total,
        FotoFactura,
        Estado,
        ID_UsuarioRegistro
    )
    VALUES(
        p_NumeroFacturaCompra,
        p_ID_Proveedor,
        p_ID_BodegaDestino,
        p_Subtotal,
        p_IVA,
        p_Total,
        p_FotoFactura,
        'Activa',
        p_ID_UsuarioRegistro
    );
END$$

DELIMITER ;

-- registrar detalle de compra y actualizar inventario

DELIMITER $$

CREATE PROCEDURE RegistrarDetalleCompra(
    IN p_ID_FacturaCompra INT,
    IN p_ID_Producto INT,
    IN p_Cantidad INT,
    IN p_ValorUnitarioCompra DECIMAL(15,2),
    IN p_PorcentajeUtilidadAplicado DECIMAL(5,2),
    IN p_ValorUnitarioVentaSugerido DECIMAL(15,2),
    IN p_PorcentajeIVA DECIMAL(5,2),
    IN p_ValorIVAUnitario DECIMAL(15,2),
    IN p_SubtotalLinea DECIMAL(15,2),
    IN p_TotalLinea DECIMAL(15,2)
)
BEGIN
    DECLARE v_ID_BodegaDestino INT;

    INSERT INTO DetalleFacturaCompra(
        ID_FacturaCompra,
        ID_Producto,
        Cantidad,
        ValorUnitarioCompra,
        PorcentajeUtilidadAplicado,
        ValorUnitarioVentaSugerido,
        PorcentajeIVA,
        ValorIVAUnitario,
        SubtotalLinea,
        TotalLinea
    )
    VALUES(
        p_ID_FacturaCompra,
        p_ID_Producto,
        p_Cantidad,
        p_ValorUnitarioCompra,
        p_PorcentajeUtilidadAplicado,
        p_ValorUnitarioVentaSugerido,
        p_PorcentajeIVA,
        p_ValorIVAUnitario,
        p_SubtotalLinea,
        p_TotalLinea
    );

    SELECT ID_BodegaDestino
    INTO v_ID_BodegaDestino
    FROM FacturaCompra
    WHERE ID_FacturaCompra = p_ID_FacturaCompra;

    INSERT INTO Inventario(ID_Producto, ID_Bodega, CantidadDisponible, CantidadReservada, StockMinimo, StockMaximo)
    VALUES(p_ID_Producto, v_ID_BodegaDestino, p_Cantidad, 0, 0, 0)
    ON DUPLICATE KEY UPDATE
        CantidadDisponible = CantidadDisponible + p_Cantidad;
END$$

DELIMITER ;

-- registrar venta 

DELIMITER $$

CREATE PROCEDURE RegistrarFacturaVenta(
    IN p_NumeroFacturaVenta VARCHAR(30),
    IN p_ID_Cliente INT,
    IN p_ID_EmpleadoVendedor INT,
    IN p_ID_BodegaSalida INT,
    IN p_TipoVenta ENUM('Mayor','Detal'),
    IN p_Subtotal DECIMAL(15,2),
    IN p_DescuentoManual DECIMAL(15,2),
    IN p_DescuentoPorVolumen DECIMAL(15,2),
    IN p_IVA DECIMAL(15,2),
    IN p_Total DECIMAL(15,2),
    IN p_FotoFactura VARCHAR(255),
    IN p_ID_UsuarioRegistro INT
)
BEGIN
    INSERT INTO FacturaVenta(
        NumeroFacturaVenta,
        ID_Cliente,
        ID_EmpleadoVendedor,
        ID_BodegaSalida,
        TipoVenta,
        Subtotal,
        DescuentoManual,
        DescuentoPorVolumen,
        IVA,
        Total,
        FotoFactura,
        Estado,
        SaleDeBodega,
        ID_UsuarioRegistro
    )
    VALUES(
        p_NumeroFacturaVenta,
        p_ID_Cliente,
        p_ID_EmpleadoVendedor,
        p_ID_BodegaSalida,
        p_TipoVenta,
        p_Subtotal,
        p_DescuentoManual,
        p_DescuentoPorVolumen,
        p_IVA,
        p_Total,
        p_FotoFactura,
        'Activa',
        TRUE,
        p_ID_UsuarioRegistro
    );
END$$

DELIMITER ;

-- registrar detalle de venta y descontar inventario

DELIMITER $$

CREATE PROCEDURE RegistrarDetalleVenta(
    IN p_ID_FacturaVenta INT,
    IN p_ID_Producto INT,
    IN p_Cantidad INT,
    IN p_ValorUnitarioVenta DECIMAL(15,2),
    IN p_PorcentajeDescuento DECIMAL(5,2),
    IN p_ValorDescuento DECIMAL(15,2),
    IN p_PorcentajeIVA DECIMAL(5,2),
    IN p_ValorIVAUnitario DECIMAL(15,2),
    IN p_SubtotalLinea DECIMAL(15,2),
    IN p_TotalLinea DECIMAL(15,2)
)
BEGIN
    DECLARE v_ID_BodegaSalida INT;
    DECLARE v_StockActual INT;

    SELECT ID_BodegaSalida
    INTO v_ID_BodegaSalida
    FROM FacturaVenta
    WHERE ID_FacturaVenta = p_ID_FacturaVenta;

    SELECT CantidadDisponible
    INTO v_StockActual
    FROM Inventario
    WHERE ID_Producto = p_ID_Producto
        AND ID_Bodega = v_ID_BodegaSalida;

    IF v_StockActual >= p_Cantidad THEN

        INSERT INTO DetalleFacturaVenta(
            ID_FacturaVenta,
            ID_Producto,
            Cantidad,
            ValorUnitarioVenta,
            PorcentajeDescuento,
            ValorDescuento,
            PorcentajeIVA,
            ValorIVAUnitario,
            SubtotalLinea,
            TotalLinea
        )
        VALUES(
            p_ID_FacturaVenta,
            p_ID_Producto,
            p_Cantidad,
            p_ValorUnitarioVenta,
            p_PorcentajeDescuento,
            p_ValorDescuento,
            p_PorcentajeIVA,
            p_ValorIVAUnitario,
            p_SubtotalLinea,
            p_TotalLinea
        );

        UPDATE Inventario
        SET CantidadDisponible = CantidadDisponible - p_Cantidad
        WHERE ID_Producto = p_ID_Producto
            AND ID_Bodega = v_ID_BodegaSalida;

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente en la bodega para realizar la venta';
    END IF;
END$$

DELIMITER ;

-- registrar pago de ventas 

DELIMITER $$

CREATE PROCEDURE RegistrarPagoVenta(
    IN p_ID_FacturaVenta INT,
    IN p_ID_MedioPago INT,
    IN p_ValorPagado DECIMAL(15,2),
    IN p_ReferenciaPago VARCHAR(50)
)
BEGIN
    INSERT INTO PagoVenta(
        ID_FacturaVenta,
        ID_MedioPago,
        ValorPagado,
        ReferenciaPago
    )
    VALUES(
        p_ID_FacturaVenta,
        p_ID_MedioPago,
        p_ValorPagado,
        p_ReferenciaPago
    );
END$$

DELIMITER ;

-- registrar traslado entre bodegas 

DELIMITER $$

CREATE PROCEDURE RegistrarTrasladoBodega(
    IN p_ID_BodegaOrigen INT,
    IN p_ID_BodegaDestino INT,
    IN p_Observacion VARCHAR(150),
    IN p_ID_UsuarioRegistro INT
)
BEGIN
    INSERT INTO TrasladoBodega(
        ID_BodegaOrigen,
        ID_BodegaDestino,
        Estado,
        Observacion,
        ID_UsuarioRegistro
    )
    VALUES(
        p_ID_BodegaOrigen,
        p_ID_BodegaDestino,
        'Pendiente',
        p_Observacion,
        p_ID_UsuarioRegistro
    );
END$$

DELIMITER ;

-- registrar detalle de traslado entre bodegas y mover inventario

DELIMITER $$

CREATE PROCEDURE RegistrarDetalleTraslado(
    IN p_ID_Traslado INT,
    IN p_ID_Producto INT,
    IN p_Cantidad INT
)
BEGIN
    DECLARE v_ID_BodegaOrigen INT;
    DECLARE v_ID_BodegaDestino INT;
    DECLARE v_StockActual INT;

    SELECT ID_BodegaOrigen, ID_BodegaDestino
    INTO v_ID_BodegaOrigen, v_ID_BodegaDestino
    FROM TrasladoBodega
    WHERE ID_Traslado = p_ID_Traslado;

    SELECT CantidadDisponible
    INTO v_StockActual
    FROM Inventario
    WHERE ID_Producto = p_ID_Producto
        AND ID_Bodega = v_ID_BodegaOrigen;

    IF v_StockActual >= p_Cantidad THEN

        INSERT INTO DetalleTrasladoBodega(
            ID_Traslado,
            ID_Producto,
            Cantidad
        )
        VALUES(
            p_ID_Traslado,
            p_ID_Producto,
            p_Cantidad
        );

        UPDATE Inventario
        SET CantidadDisponible = CantidadDisponible - p_Cantidad
        WHERE ID_Producto = p_ID_Producto
            AND ID_Bodega = v_ID_BodegaOrigen;

        INSERT INTO Inventario(ID_Producto, ID_Bodega, CantidadDisponible, CantidadReservada, StockMinimo, StockMaximo)
        VALUES(p_ID_Producto, v_ID_BodegaDestino, p_Cantidad, 0, 0, 0)
        ON DUPLICATE KEY UPDATE
            CantidadDisponible = CantidadDisponible + p_Cantidad;

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente en la bodega origen para el traslado';
    END IF;
END$$

DELIMITER ;
