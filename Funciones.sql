-- Funcion: Calcular si aplica o IVA y cuanto IVA cobrar 

DELIMITER $$

CREATE FUNCTION CalcularIVA(
    p_ValorVenta DECIMAL(15,2),
    p_Anio YEAR
)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE v_SalarioMinimo DECIMAL(15,2);
    DECLARE v_PorcentajeIVA DECIMAL(5,2);
    DECLARE v_IVA DECIMAL(15,2);

    SELECT SalarioMinimo, PorcentajeIVA
    INTO v_SalarioMinimo, v_PorcentajeIVA
    FROM ParametroFiscal
    WHERE Anio = p_Anio
    LIMIT 1;

    IF p_ValorVenta > v_SalarioMinimo THEN
        SET v_IVA = p_ValorVenta * (v_PorcentajeIVA / 100);
    ELSE
        SET v_IVA = 0;
    END IF;

    RETURN v_IVA;
END$$

DELIMITER ;

-- Funcion: calcular precio de venta con utilidad 
DELIMITER $$

CREATE FUNCTION CalcularPrecioVenta(
    p_ValorCompra DECIMAL(15,2),
    p_PorcentajeUtilidad DECIMAL(5,2)
)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE v_PrecioVenta DECIMAL(15,2);

    SET v_PrecioVenta = p_ValorCompra + (p_ValorCompra * (p_PorcentajeUtilidad / 100));

    RETURN v_PrecioVenta;
END$$

DELIMITER ;

-- Funcion: para calcular descuento por compra mayor a 200 millones 

DELIMITER $$

CREATE FUNCTION CalcularDescuentoCompra(
    p_TotalCompra DECIMAL(15,2)
)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE v_Descuento DECIMAL(15,2);

    IF p_TotalCompra > 200000000 THEN
        SET v_Descuento = p_TotalCompra * 0.05;
    ELSE
        SET v_Descuento = 0;
    END IF;

    RETURN v_Descuento;
END$$

DELIMITER ;

-- Funcion: calcular comision segun venta mensual 

DELIMITER $$

CREATE FUNCTION CalcularComisionMensual(
    p_TotalVendido DECIMAL(15,2)
)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE v_Porcentaje DECIMAL(5,2);
    DECLARE v_Comision DECIMAL(15,2);

    SELECT PorcentajeComision
    INTO v_Porcentaje
    FROM RangoComision
    WHERE p_TotalVendido >= VentaMinima
        AND (p_TotalVendido <= VentaMaxima OR VentaMaxima IS NULL)
    LIMIT 1;

    IF v_Porcentaje IS NULL THEN
        SET v_Porcentaje = 0;
    END IF;

    SET v_Comision = p_TotalVendido * (v_Porcentaje / 100);

    RETURN v_Comision;
END$$

DELIMITER ;

-- Funcion: validar garantia empresa 
DELIMITER $$

CREATE FUNCTION GarantiaEmpresaVigente(
    p_FechaVenta DATE,
    p_FechaActual DATE,
    p_MesesGarantia INT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_FechaLimite DATE;

    SET v_FechaLimite = DATE_ADD(p_FechaVenta, INTERVAL p_MesesGarantia MONTH);

    IF p_FechaActual <= v_FechaLimite THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END$$

DELIMITER ;

-- Funcion: validar garantia proveedor

DELIMITER $$

CREATE FUNCTION GarantiaProveedorVigente(
    p_FechaVenta DATE,
    p_FechaActual DATE,
    p_MesesGarantia INT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_FechaLimite DATE;

    SET v_FechaLimite = DATE_ADD(p_FechaVenta, INTERVAL p_MesesGarantia MONTH);

    IF p_FechaActual <= v_FechaLimite THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END$$

DELIMITER ;

-- Funcion: para calcular el precio de descuento mas IVA
DELIMITER $$

CREATE FUNCTION CalcularTotalVenta(
    p_Subtotal DECIMAL(15,2),
    p_Descuento DECIMAL(15,2),
    p_IVA DECIMAL(15,2)
)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    RETURN (p_Subtotal - p_Descuento) + p_IVA;
END$$

DELIMITER ;