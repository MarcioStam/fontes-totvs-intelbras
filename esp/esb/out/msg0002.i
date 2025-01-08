{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0002 NO-UNDO XML-NODE-NAME 'MSG0002'
    FIELD idm                  AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoUnidadeNegocio AS CHARACTER FORMAT "x(20)"
    FIELD Nome                 AS CHARACTER FORMAT "x(100)"
    field Situacao             as integer.

DEFINE TEMP-TABLE msg0002r NO-UNDO XML-NODE-NAME 'MSG0002R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD Proprietario         AS CHAR
    FIELD TipoProprietario     AS CHAR.

    
    
