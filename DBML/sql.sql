CREATE DATABASE ERP_ACM;
USE ERP_ACM;
-- Ubicaciones
CREATE TABLE Pais(
    ID_Pais INT PRIMARY KEY AUTO_INCREMENT,
    NombrePais VARCHAR(30) NOT NULL
);
CREATE TABLE Ciudad(
    ID_Ciudad INT PRIMARY KEY AUTO_INCREMENT,
    NombreCiudad VARCHAR(30) NOT NULL,
    ID_Pais INT,
    FOREIGN KEY (ID_Pais) REFERENCES Pais(ID_Pais)
);
CREATE TABLE Sede (
    ID_Sede INT PRIMARY KEY AUTO_INCREMENT,
    NombreSede VARCHAR(30) NOT NULL,
    ID_Ciudad INT,
    FOREIGN KEY (ID_Ciudad) REFERENCES Ciudad(ID_Ciudad)
);
CREATE TABLE Bodega (
    ID_Bodega INT PRIMARY KEY AUTO_INCREMENT,
    NombreBodega VARCHAR(30) NOT NULL,
    ID_Ciudad INT,
    ID_Sede INT,
    FOREIGN KEY (ID_Ciudad) REFERENCES Ciudad(ID_Ciudad),
    FOREIGN KEY (ID_Sede) REFERENCES Sede(ID_Sede)
);
--- Clientes
CREATE TABLE TipoDocumento(
    ID_TipoDocumento INT PRIMARY KEY AUTO_INCREMENT,
    NombreTipoDocumento VARCHAR (30) NOT NULL,
    Abreviatura VARCHAR(30) NOT NULL
);
CREATE TABLE Clientes (
    ID_Cliente INT PRIMARY KEY AUTO_INCREMENT,
    ID_TipoDocumento INT,
    NumeroDocumento VARCHAR (30) NOT NULL,
    Nombre VARCHAR (30) NOT NULL,
    Apellidos VARCHAR (30) NOT NULL,
    Genero VARCHAR(30) NOT NULL,
    Direccion VARCHAR(30) NOT NULL,
    ID_Ciudad INT,
    Telefono VARCHAR(30) NOT NULL,
    Email VARCHAR(30) NOT NULL,
    TipoCliente ENUM('Natural','Empresa'),
    Activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (ID_TipoDocumento) REFERENCES TipoDocumento(ID_TipoDocumento),
    FOREIGN KEY (ID_Ciudad) REFERENCES Ciudad(ID_Ciudad)
);
CREATE TABLE EmpresaCliente(
    ID_EmpresaCliente INT PRIMARY KEY AUTO_INCREMENT,
    ID_Cliente INT,
    RazonSocial VARCHAR(30) NOT NULL,
    NIT VARCHAR(30) NOT NULL,
    RepresentanteLegal VARCHAR(30) NOT NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente)
);

--- Proveedores
CREATE TABLE TipoProveedor(
    ID_TipoProveedor INT PRIMARY KEY AUTO_INCREMENT,
    NombreTipoProveedor ENUM('Nacional','Internacional')
);
CREATE TABLE Proveedor (
    ID_Proveedor INT PRIMARY KEY AUTO_INCREMENT,
    ID_TipoProveedor INT,
    RazonSocial VARCHAR(30) NOT NULL,
    NIT VARCHAR(30) NOT NULL,
    ContactoPrincipal VARCHAR(30) NOT NULL,
    Telefono VARCHAR(30) NOT NULL,
    Email VARCHAR(30) NOT NULL,
    Direccion VARCHAR(30) NOT NULL,
    ID_Ciudad INT,
    Activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (ID_TipoProveedor) REFERENCES TipoProveedor(ID_TipoProveedor),
    FOREIGN KEY (ID_Ciudad) REFERENCES Ciudad(ID_Ciudad)
);
--- Empleados y vendedores
CREATE TABLE Cargo (
    ID_Cargo INT PRIMARY KEY AUTO_INCREMENT,
    NombreCargo VARCHAR(30) NOT NULL
);
CREATE TABLE Empleado (
    ID_Empleado INT PRIMARY KEY AUTO_INCREMENT,
    ID_TipoDocumento INT,
    NumeroDocumento VARCHAR(30) NOT NULL,
    Nombres VARCHAR(30) NOT NULL,
    Apellidos VARCHAR(30) NOT NULL,
    Telefono VARCHAR(30) NOT NULL,
    Email VARCHAR(30) NOT NULL,
    Direccion VARCHAR(30) NOT NULL,
    ID_Ciudad INT,
    ID_Cargo INT,
    ID_Sede INT,
    FechaIngreso DATE,
    Estado BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (ID_TipoDocumento) REFERENCES TipoDocumento(ID_TipoDocumento),
    FOREIGN KEY (ID_Ciudad) REFERENCES Ciudad(ID_Ciudad),
    FOREIGN KEY (ID_Cargo) REFERENCES Cargo(ID_Cargo),
    FOREIGN KEY (ID_Sede) REFERENCES Sede(ID_Sede)
);

--- Seguridad
CREATE TABLE Usuario (
    ID_Usuario INT PRIMARY KEY AUTO_INCREMENT,
    ID_Empleado INT NOT NULL,
    NombreUsuario VARCHAR(50) NOT NULL UNIQUE,
    ClaveHash VARCHAR(255) NOT NULL,
    Estado BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (ID_Empleado) REFERENCES Empleado(ID_Empleado)
);

CREATE TABLE Rol (
    ID_Rol INT PRIMARY KEY AUTO_INCREMENT,
    NombreRol VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE UsuarioRol (
    ID_UsuarioRol INT PRIMARY KEY AUTO_INCREMENT,
    ID_Usuario INT NOT NULL,
    ID_Rol INT NOT NULL,
    FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario),
    FOREIGN KEY (ID_Rol) REFERENCES Rol(ID_Rol),
    UNIQUE (ID_Usuario, ID_Rol)
);

CREATE TABLE Permiso (
    ID_Permiso INT PRIMARY KEY AUTO_INCREMENT,
    NombrePermiso VARCHAR(100) NOT NULL UNIQUE,
    Descripcion VARCHAR(150)
);

CREATE TABLE RolPermiso (
    ID_RolPermiso INT PRIMARY KEY AUTO_INCREMENT,
    ID_Rol INT NOT NULL,
    ID_Permiso INT NOT NULL,
    FOREIGN KEY (ID_Rol) REFERENCES Rol(ID_Rol),
    FOREIGN KEY (ID_Permiso) REFERENCES Permiso(ID_Permiso),
    UNIQUE (ID_Rol, ID_Permiso)
);

--- Productos
CREATE TABLE Categoria (
    ID_Categoria INT PRIMARY KEY AUTO_INCREMENT,
    CodigoCategoria VARCHAR(20) NOT NULL UNIQUE,
    NombreCategoria VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(100),
    Estado BOOLEAN DEFAULT TRUE
);

CREATE TABLE Producto (
    ID_Producto INT PRIMARY KEY AUTO_INCREMENT,
    CodigoProducto VARCHAR(20) NOT NULL UNIQUE,
    NombreProducto VARCHAR(80) NOT NULL,
    ID_Categoria INT NOT NULL,
    Descripcion VARCHAR(150),
    GarantiaEmpresaMeses INT DEFAULT 3,
    GarantiaProveedorMeses INT DEFAULT 12,
    PorcentajeUtilidad DECIMAL(5,2) NOT NULL,
    AplicaIVA BOOLEAN DEFAULT TRUE,
    Estado BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (ID_Categoria) REFERENCES Categoria(ID_Categoria)
);

--- Parámetros fiscales
CREATE TABLE ParametroFiscal (
    ID_ParametroFiscal INT PRIMARY KEY AUTO_INCREMENT,
    Anio YEAR NOT NULL,
    SalarioMinimo DECIMAL(15,2) NOT NULL,
    PorcentajeIVA DECIMAL(5,2) NOT NULL DEFAULT 19.00,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL
);

--- Historial de precios
CREATE TABLE HistorialPrecioProducto (
    ID_HistorialPrecio INT PRIMARY KEY AUTO_INCREMENT,
    ID_Producto INT NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE,
    ValorCompraBase DECIMAL(15,2) NOT NULL,
    PorcentajeUtilidad DECIMAL(5,2) NOT NULL,
    ValorVentaBase DECIMAL(15,2) NOT NULL,
    AplicaIVA BOOLEAN DEFAULT TRUE,
    PorcentajeIVA DECIMAL(5,2) DEFAULT 19.00,
    FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto)
);

--- Inventario
CREATE TABLE Inventario (
    ID_Inventario INT PRIMARY KEY AUTO_INCREMENT,
    ID_Producto INT NOT NULL,
    ID_Bodega INT NOT NULL,
    CantidadDisponible INT NOT NULL DEFAULT 0,
    CantidadReservada INT NOT NULL DEFAULT 0,
    StockMinimo INT DEFAULT 0,
    StockMaximo INT DEFAULT 0,
    FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto),
    FOREIGN KEY (ID_Bodega) REFERENCES Bodega(ID_Bodega),
    UNIQUE (ID_Producto, ID_Bodega)
);

CREATE TABLE TipoMovimientoInventario (
    ID_TipoMovimiento INT PRIMARY KEY AUTO_INCREMENT,
    NombreTipoMovimiento VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE MovimientoInventario (
    ID_Movimiento INT PRIMARY KEY AUTO_INCREMENT,
    ID_TipoMovimiento INT NOT NULL,
    FechaMovimiento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ID_Producto INT NOT NULL,
    ID_BodegaOrigen INT,
    ID_BodegaDestino INT,
    Cantidad INT NOT NULL,
    CostoUnitario DECIMAL(15,2),
    ReferenciaDocumento VARCHAR(50),
    Observacion VARCHAR(150),
    ID_Usuario INT,
    FOREIGN KEY (ID_TipoMovimiento) REFERENCES TipoMovimientoInventario(ID_TipoMovimiento),
    FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto),
    FOREIGN KEY (ID_BodegaOrigen) REFERENCES Bodega(ID_Bodega),
    FOREIGN KEY (ID_BodegaDestino) REFERENCES Bodega(ID_Bodega),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario)
);

--- Compras
CREATE TABLE FacturaCompra (
    ID_FacturaCompra INT PRIMARY KEY AUTO_INCREMENT,
    NumeroFacturaCompra VARCHAR(30) NOT NULL UNIQUE,
    FechaCompra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ID_Proveedor INT NOT NULL,
    ID_BodegaDestino INT NOT NULL,
    Subtotal DECIMAL(15,2) NOT NULL DEFAULT 0,
    IVA DECIMAL(15,2) NOT NULL DEFAULT 0,
    Total DECIMAL(15,2) NOT NULL DEFAULT 0,
    FotoFactura VARCHAR(255),
    Estado ENUM('Activa','Anulada','Devuelta') DEFAULT 'Activa',
    ID_UsuarioRegistro INT,
    FOREIGN KEY (ID_Proveedor) REFERENCES Proveedor(ID_Proveedor),
    FOREIGN KEY (ID_BodegaDestino) REFERENCES Bodega(ID_Bodega),
    FOREIGN KEY (ID_UsuarioRegistro) REFERENCES Usuario(ID_Usuario)
);

CREATE TABLE DetalleFacturaCompra (
    ID_DetalleCompra INT PRIMARY KEY AUTO_INCREMENT,
    ID_FacturaCompra INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad INT NOT NULL,
    ValorUnitarioCompra DECIMAL(15,2) NOT NULL,
    PorcentajeUtilidadAplicado DECIMAL(5,2) NOT NULL,
    ValorUnitarioVentaSugerido DECIMAL(15,2) NOT NULL,
    PorcentajeIVA DECIMAL(5,2) NOT NULL DEFAULT 19.00,
    ValorIVAUnitario DECIMAL(15,2) NOT NULL DEFAULT 0,
    SubtotalLinea DECIMAL(15,2) NOT NULL,
    TotalLinea DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (ID_FacturaCompra) REFERENCES FacturaCompra(ID_FacturaCompra),
    FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto)
);

--- Ventas
CREATE TABLE FacturaVenta (
    ID_FacturaVenta INT PRIMARY KEY AUTO_INCREMENT,
    NumeroFacturaVenta VARCHAR(30) NOT NULL UNIQUE,
    FechaVenta DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ID_Cliente INT NOT NULL,
    ID_EmpleadoVendedor INT NOT NULL,
    ID_BodegaSalida INT NOT NULL,
    TipoVenta ENUM('Mayor','Detal') NOT NULL,
    Subtotal DECIMAL(15,2) NOT NULL DEFAULT 0,
    DescuentoManual DECIMAL(15,2) NOT NULL DEFAULT 0,
    DescuentoPorVolumen DECIMAL(15,2) NOT NULL DEFAULT 0,
    IVA DECIMAL(15,2) NOT NULL DEFAULT 0,
    Total DECIMAL(15,2) NOT NULL DEFAULT 0,
    FotoFactura VARCHAR(255),
    Estado ENUM('Activa','Anulada','Devuelta') DEFAULT 'Activa',
    SaleDeBodega BOOLEAN DEFAULT TRUE,
    ID_UsuarioRegistro INT,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_EmpleadoVendedor) REFERENCES Empleado(ID_Empleado),
    FOREIGN KEY (ID_BodegaSalida) REFERENCES Bodega(ID_Bodega),
    FOREIGN KEY (ID_UsuarioRegistro) REFERENCES Usuario(ID_Usuario)
);

CREATE TABLE DetalleFacturaVenta (
    ID_DetalleVenta INT PRIMARY KEY AUTO_INCREMENT,
    ID_FacturaVenta INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad INT NOT NULL,
    ValorUnitarioVenta DECIMAL(15,2) NOT NULL,
    PorcentajeDescuento DECIMAL(5,2) NOT NULL DEFAULT 0,
    ValorDescuento DECIMAL(15,2) NOT NULL DEFAULT 0,
    PorcentajeIVA DECIMAL(5,2) NOT NULL DEFAULT 19.00,
    ValorIVAUnitario DECIMAL(15,2) NOT NULL DEFAULT 0,
    SubtotalLinea DECIMAL(15,2) NOT NULL,
    TotalLinea DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (ID_FacturaVenta) REFERENCES FacturaVenta(ID_FacturaVenta),
    FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto)
);

--- Descuentos
CREATE TABLE PoliticaDescuento (
    ID_PoliticaDescuento INT PRIMARY KEY AUTO_INCREMENT,
    NombrePolitica VARCHAR(80) NOT NULL,
    TipoPolitica ENUM('PorMonto','PorCliente','Manual') NOT NULL,
    MontoMinimo DECIMAL(15,2),
    MontoMaximo DECIMAL(15,2),
    PorcentajeDescuento DECIMAL(5,2) NOT NULL,
    Estado BOOLEAN DEFAULT TRUE,
    FechaInicio DATE,
    FechaFin DATE
);

CREATE TABLE ClientePoliticaDescuento (
    ID_ClientePolitica INT PRIMARY KEY AUTO_INCREMENT,
    ID_Cliente INT NOT NULL,
    ID_PoliticaDescuento INT NOT NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_PoliticaDescuento) REFERENCES PoliticaDescuento(ID_PoliticaDescuento),
    UNIQUE (ID_Cliente, ID_PoliticaDescuento)
);

--- Pagos
CREATE TABLE MedioPago (
    ID_MedioPago INT PRIMARY KEY AUTO_INCREMENT,
    NombreMedioPago VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE PagoVenta (
    ID_PagoVenta INT PRIMARY KEY AUTO_INCREMENT,
    ID_FacturaVenta INT NOT NULL,
    ID_MedioPago INT NOT NULL,
    FechaPago DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ValorPagado DECIMAL(15,2) NOT NULL,
    ReferenciaPago VARCHAR(50),
    FOREIGN KEY (ID_FacturaVenta) REFERENCES FacturaVenta(ID_FacturaVenta),
    FOREIGN KEY (ID_MedioPago) REFERENCES MedioPago(ID_MedioPago)
);

--- Garantías y devoluciones
CREATE TABLE TipoGarantia (
    ID_TipoGarantia INT PRIMARY KEY AUTO_INCREMENT,
    NombreTipoGarantia ENUM('Empresa','Proveedor') NOT NULL
);

CREATE TABLE SolicitudGarantia (
    ID_SolicitudGarantia INT PRIMARY KEY AUTO_INCREMENT,
    ID_FacturaVenta INT NOT NULL,
    ID_Cliente INT NOT NULL,
    FechaSolicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Motivo VARCHAR(150) NOT NULL,
    Estado ENUM('Pendiente','Aprobada','Rechazada','Finalizada') DEFAULT 'Pendiente',
    ID_UsuarioRegistro INT,
    FOREIGN KEY (ID_FacturaVenta) REFERENCES FacturaVenta(ID_FacturaVenta),
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_UsuarioRegistro) REFERENCES Usuario(ID_Usuario)
);

CREATE TABLE DetalleSolicitudGarantia (
    ID_DetalleSolicitudGarantia INT PRIMARY KEY AUTO_INCREMENT,
    ID_SolicitudGarantia INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad INT NOT NULL,
    FechaVencimientoGarantiaEmpresa DATE,
    FechaVencimientoGarantiaProveedor DATE,
    AplicaGarantiaEmpresa BOOLEAN DEFAULT FALSE,
    AplicaGarantiaProveedor BOOLEAN DEFAULT FALSE,
    Resultado VARCHAR(100),
    FOREIGN KEY (ID_SolicitudGarantia) REFERENCES SolicitudGarantia(ID_SolicitudGarantia),
    FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto)
);

CREATE TABLE DevolucionCliente (
    ID_DevolucionCliente INT PRIMARY KEY AUTO_INCREMENT,
    ID_SolicitudGarantia INT NOT NULL,
    FechaDevolucion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ID_BodegaEntrada INT NOT NULL,
    Observacion VARCHAR(150),
    Estado ENUM('Recibida','EnRevision','Aceptada','Rechazada') DEFAULT 'Recibida',
    FOREIGN KEY (ID_SolicitudGarantia) REFERENCES SolicitudGarantia(ID_SolicitudGarantia),
    FOREIGN KEY (ID_BodegaEntrada) REFERENCES Bodega(ID_Bodega)
);

CREATE TABLE DetalleDevolucionCliente (
    ID_DetalleDevolucionCliente INT PRIMARY KEY AUTO_INCREMENT,
    ID_DevolucionCliente INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad INT NOT NULL,
    EstadoProducto VARCHAR(50),
    FOREIGN KEY (ID_DevolucionCliente) REFERENCES DevolucionCliente(ID_DevolucionCliente),
    FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto)
);

--- Traslados entre bodegas
CREATE TABLE TrasladoBodega (
    ID_Traslado INT PRIMARY KEY AUTO_INCREMENT,
    FechaTraslado DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ID_BodegaOrigen INT NOT NULL,
    ID_BodegaDestino INT NOT NULL,
    Estado ENUM('Pendiente','Enviado','Recibido','Cancelado') DEFAULT 'Pendiente',
    Observacion VARCHAR(150),
    ID_UsuarioRegistro INT,
    FOREIGN KEY (ID_BodegaOrigen) REFERENCES Bodega(ID_Bodega),
    FOREIGN KEY (ID_BodegaDestino) REFERENCES Bodega(ID_Bodega),
    FOREIGN KEY (ID_UsuarioRegistro) REFERENCES Usuario(ID_Usuario)
);

CREATE TABLE DetalleTrasladoBodega (
    ID_DetalleTraslado INT PRIMARY KEY AUTO_INCREMENT,
    ID_Traslado INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad INT NOT NULL,
    FOREIGN KEY (ID_Traslado) REFERENCES TrasladoBodega(ID_Traslado),
    FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto)
);

--- Comisiones
CREATE TABLE RangoComision (
    ID_RangoComision INT PRIMARY KEY AUTO_INCREMENT,
    VentaMinima DECIMAL(15,2) NOT NULL,
    VentaMaxima DECIMAL(15,2),
    PorcentajeComision DECIMAL(5,2) NOT NULL
);

CREATE TABLE ComisionMensualVendedor (
    ID_ComisionMensual INT PRIMARY KEY AUTO_INCREMENT,
    ID_Empleado INT NOT NULL,
    Anio YEAR NOT NULL,
    Mes TINYINT NOT NULL,
    TotalVendido DECIMAL(15,2) NOT NULL,
    ID_RangoComision INT,
    PorcentajeAplicado DECIMAL(5,2) NOT NULL,
    ValorComision DECIMAL(15,2) NOT NULL,
    FechaCalculo DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ID_Empleado) REFERENCES Empleado(ID_Empleado),
    FOREIGN KEY (ID_RangoComision) REFERENCES RangoComision(ID_RangoComision),
    UNIQUE (ID_Empleado, Anio, Mes)
);

--- Auditoría / historial
CREATE TABLE Auditoria (
    ID_Auditoria INT PRIMARY KEY AUTO_INCREMENT,
    TablaAfectada VARCHAR(50) NOT NULL,
    ID_RegistroAfectado INT NOT NULL,
    Accion ENUM('INSERT','UPDATE','DELETE') NOT NULL,
    FechaHora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ID_Usuario INT,
    ValorAnterior TEXT,
    ValorNuevo TEXT,
    FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario)
);