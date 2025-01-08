FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT) FORWARD.

FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT):
    
    CASE p-beneficio:
        WHEN 04 THEN RETURN "BACKUP".
        WHEN 08 THEN RETURN "PRICE PROTECTION".
        WHEN 15 THEN RETURN "SHOW ROOM".
        WHEN 21 THEN RETURN "VMC".
        WHEN 22 THEN RETURN "STOCK ROTATION".
        WHEN 37 THEN RETURN "REBATE".
        WHEN 66 THEN RETURN "REBATE P‡S-VENDA".
    END CASE.

    RETURN "".
END FUNCTION.
