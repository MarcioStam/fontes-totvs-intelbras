{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0251 NO-UNDO XML-NODE-NAME 'MSG0251'
    FIELD idm                    AS INT XML-NODE-TYPE 'hidden'
    FIELD NumeroPedidoCompra     AS INTEGER
    FIELD CadastrarSerialNumbers AS LOGICAL
    FIELD SucessoSerialNumbers   AS LOGICAL
    FIELD MensagemSerialNumbers  AS CHARACTER FORMAT "X(5000)"
    FIELD CadastrarMacAddresses  AS LOGICAL
    FIELD SucessoMacAddresses    AS LOGICAL
    FIELD MensagemMacAddresses   AS CHARACTER FORMAT "X(5000)"
    .

DEFINE TEMP-TABLE ItensConsulta NO-UNDO XML-NODE-NAME 'ItensConsulta'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoProduto LIKE ordem-compra.it-codigo
    .

DEFINE TEMP-TABLE msg0251r NO-UNDO XML-NODE-NAME 'MSG0002R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    .

{cdp/cd0666.i}         /*tt-erro*/
DEFINE TEMP-TABLE tt-erro-ns  LIKE tt-erro.
DEFINE TEMP-TABLE tt-erro-mac LIKE tt-erro.    
    
/*Outras temp tables*/
DEFINE TEMP-TABLE tt-lista-ns
    FIELD num-serie AS CHAR FORMAT "X(13)".
