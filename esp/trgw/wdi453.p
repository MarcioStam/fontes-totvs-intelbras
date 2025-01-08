/********************************************************************************
 ** UPC........: wdi453.p - UPC WRITE ri-bem
 ** Data.......: Julho/2023
 ********************************************************************************/

DEF PARAM BUFFER b-ri-bem      FOR ri-bem.
DEF PARAM BUFFER b-old-ri-bem  FOR ri-bem.
    
IF  NEW(b-ri-bem) THEN DO:
    
    FOR FIRST ri-param NO-LOCK
        WHERE ri-param.cod-estabel = b-ri-bem.cod-estabel:
    
        IF   ri-param.log-un 
        AND  ri-param.cod-unid-negoc <> "" THEN
            ASSIGN b-ri-bem.cod-unid-neg = ri-param.cod-unid-negoc.
            
    END.
END.

RETURN "OK".
