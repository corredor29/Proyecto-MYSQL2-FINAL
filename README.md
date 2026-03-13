# ERP_ACM – Sistema ERP para Gestión de Tecnología y Hardware

## 1. Descripción del Proyecto

**ERP_ACM** es un sistema de gestión empresarial diseñado para una empresa dedicada a la **venta de productos tecnológicos y hardware**.  

El sistema permite administrar:

- clientes
- proveedores
- empleados
- productos
- inventario
- compras
- ventas
- devoluciones por garantía
- traslados entre bodegas
- comisiones de vendedores
- auditoría de cambios

La empresa opera actualmente en **Colombia** con sedes en:

- Barranquilla  
- Cali  
- Medellín  
- Bucaramanga  
- Bogotá  

y planea expandirse a:

- Chile  
- Ecuador  
- Perú  

---

# 2. Características del Sistema

El sistema ERP incluye los siguientes módulos:

| Módulo | Funcionalidad |
|------|------|
| Ubicación | gestión de países, ciudades, sedes y bodegas |
| Clientes | clientes naturales y empresas |
| Proveedores | nacionales e internacionales |
| Productos | categorías, productos y precios |
| Inventario | control de stock por bodega |
| Compras | registro de facturas de compra |
| Ventas | registro de facturas de venta |
| Pagos | diferentes medios de pago |
| Garantías | control de devoluciones |
| Traslados | movimientos entre bodegas |
| Comisiones | cálculo de comisiones por vendedor |
| Seguridad | usuarios, roles y permisos |
| Auditoría | historial de cambios en el sistema |

---

# 3. Reglas del Negocio

Las principales reglas implementadas en el sistema son:

### Inventario

- Cada **producto pertenece a una sola categoría**
- Un producto puede existir en **varias bodegas**
- El inventario se mueve mediante:
  - compras
  - ventas
  - devoluciones
  - traslados

---

### IVA

Si el valor de un producto **supera el salario mínimo colombiano**, se aplica:

```

IVA = 19%

```

---

### Garantías

| Tipo | Duración |
|----|----|
Empresa | 3 meses |
Proveedor | 12 meses |

Las devoluciones solo pueden hacerse **si la garantía está vigente**.

---

### Descuentos

Se aplican descuentos según reglas:

| Condición | Descuento |
|------|------|
Compra mayor a 200 millones | 5% |
Clientes especiales | configurable |
Manual por usuario | permitido |

---

### Comisiones de ventas

Las comisiones se calculan según **ventas mensuales del vendedor**:

| Ventas Mensuales | Comisión |
|------|------|
1000M – 2000M | 1% |
2000M – 3000M | 1.5% |
3000M – 4000M | 2% |
Más de 4000M | 5% |

---

# 4. Estructura de la Base de Datos

El sistema se diseñó siguiendo **Tercera Forma Normal (3FN)**.

## Tablas principales

### Ubicación

- Pais
- Ciudad
- Sede
- Bodega

---

### Personas

- TipoDocumento
- Clientes
- EmpresaCliente
- Proveedor
- Empleado
- Cargo

---

### Seguridad

- Usuario
- Rol
- Permiso
- UsuarioRol
- RolPermiso

---

### Productos

- Categoria
- Producto
- HistorialPrecioProducto
- ParametroFiscal

---

### Inventario

- Inventario
- TipoMovimientoInventario
- MovimientoInventario

---

### Compras

- FacturaCompra
- DetalleFacturaCompra

---

### Ventas

- FacturaVenta
- DetalleFacturaVenta

---

### Pagos

- MedioPago
- PagoVenta

---

### Garantías

- SolicitudGarantia
- DetalleSolicitudGarantia
- DevolucionCliente
- DetalleDevolucionCliente

---

### Traslados

- TrasladoBodega
- DetalleTrasladoBodega

---

### Comisiones

- RangoComision
- ComisionMensualVendedor

---

### Auditoría

- Auditoria

---

# 5. Funciones Implementadas

Las funciones permiten realizar cálculos dentro de la base de datos.

| Función | Descripción |
|------|------|
CalcularIVA | calcula IVA según salario mínimo |
CalcularPrecioVenta | calcula precio con utilidad |
CalcularDescuentoCompra | aplica descuento por monto |
CalcularComisionMensual | calcula comisión del vendedor |
GarantiaEmpresaVigente | valida garantía de empresa |
GarantiaProveedorVigente | valida garantía del proveedor |
CalcularTotalVenta | calcula total final de venta |

---

# 6. Vistas del Sistema

Las vistas facilitan consultas complejas.

| Vista | Descripción |
|------|------|
Vista_ProductosCategoria | productos con categoría |
Vista_Clientes | clientes con ciudad |
Vista_Proveedores | proveedores con ubicación |
Vista_Empleados | empleados con cargo y sede |
Vista_UsuariosRoles | usuarios con roles |
Vista_InventarioBodega | inventario por bodega |
Vista_PreciosActuales | precios actuales |
Vista_FacturasCompra | compras registradas |
Vista_FacturasVenta | ventas registradas |
Vista_PagosVenta | pagos realizados |
Vista_MovimientosInventario | historial inventario |
Vista_ComisionesMensuales | comisiones de vendedores |

---

# 7. Procedimientos Almacenados

Los procedimientos automatizan operaciones del sistema.

## Operaciones

| Procedimiento | Función |
|------|------|
RegistrarCliente | crear cliente |
RegistrarProveedor | crear proveedor |
RegistrarProducto | crear producto |

---

## Compras

| Procedimiento | Función |
|------|------|
RegistrarFacturaCompra | registrar compra |
RegistrarDetalleCompra | agregar productos a compra |

---

## Ventas

| Procedimiento | Función |
|------|------|
RegistrarFacturaVenta | registrar venta |
RegistrarDetalleVenta | agregar productos vendidos |
RegistrarPagoVenta | registrar pago |

---

## Inventario

| Procedimiento | Función |
|------|------|
RegistrarTrasladoBodega | traslado entre bodegas |
RegistrarDetalleTraslado | movimiento de productos |

---

## Comisiones

| Procedimiento | Función |
|------|------|
CalcularComisionVendedor | calcula comisión mensual |

---

# 8. Procedimientos de Reporte

El sistema incluye reportes para análisis del negocio.

| Reporte | Descripción |
|------|------|
ReporteInventarioPorBodega | stock por bodega |
ReporteBajoStock | productos con bajo inventario |
ReporteVentasPorFechas | ventas por rango de fechas |
ReporteComprasPorFechas | compras por fechas |
ReporteVentasPorVendedor | ventas por asesor |
ReporteTotalVendidoPorVendedor | ranking de vendedores |
ReporteClientesTop | clientes que más compran |
ReporteProductosMasVendidos | productos más vendidos |
ReporteMovimientosInventario | historial de inventario |
ReporteComisionesMensuales | comisiones por vendedor |
ReporteGarantias | devoluciones |
ReporteTraslados | movimientos entre bodegas |

---

# 9. Triggers de Auditoría

El sistema registra automáticamente cambios en la tabla **Auditoria**.

Eventos auditados:

| Evento | Tabla |
|------|------|
INSERT | Clientes |
UPDATE | Clientes |
DELETE | Clientes |
INSERT | Producto |
UPDATE | Producto |
DELETE | Producto |
INSERT | FacturaVenta |
UPDATE | FacturaVenta |
INSERT | FacturaCompra |
UPDATE | FacturaCompra |
INSERT | Proveedor |
UPDATE | Proveedor |

Cada registro guarda:

- tabla afectada
- registro modificado
- acción
- fecha y hora
- usuario
- valor anterior
- valor nuevo

---

# 10. Usuarios Privilegiados

El sistema define usuarios de MySQL con diferentes permisos.

| Usuario | Rol |
|------|------|
admin_erp | administrador total |
gerente_erp | lectura y reportes |
cajero_erp | ventas |
bodeguero_erp | inventario |
asesor_erp | ventas y comisiones |
contador_erp | facturas y reportes |
app_backend | ejecución de procedimientos |

---

# 11. Tecnologías Utilizadas

- MySQL
- SQL
- Procedimientos almacenados
- Triggers
- Funciones
- Vistas

---

# 12. Seguridad

El sistema implementa:

- control de roles
- permisos por usuario
- auditoría de cambios
- separación de privilegios

---

# 13. Autor
### Felipe Corredor Silva

Proyecto desarrollado como **sistema ERP académico para gestión de hardware y tecnología**.

Incluye implementación completa de:

- modelo relacional
- normalización
- lógica de negocio
- automatización con SQL
```


