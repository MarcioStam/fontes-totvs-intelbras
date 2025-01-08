{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0082 NO-UNDO XML-NODE-NAME 'MSG0082'
    FIELD idm                  AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoItemListaPreco AS CHAR
    FIELD Produto              LIKE ITEM.it-codigo
    FIELD ListaPreco           AS CHAR
    FIELD Valor                AS DEC
    FIELD Porcentagem          AS DEC
    FIELD ListaDesconto        AS CHAR
    FIELD MetodoPrecificacao   AS INT
    FIELD OpcaoVendaParcial    AS INT
    FIELD ValorArredondamento  AS DEC
    FIELD OpcaoArredondamento  AS INT
    FIELD PoliticaArredondamento  AS INT
    FIELD Moeda                AS CHAR
    FIELD UnidadeMedida        AS CHAR
    .
   
DEFINE TEMP-TABLE msg0082r NO-UNDO XML-NODE-NAME 'MSG0082R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
