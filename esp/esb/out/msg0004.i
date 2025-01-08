{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0004 NO-UNDO XML-NODE-NAME 'MSG0004'
    FIELD idm                       AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoCondicaoPagamento   AS INTEGER
    FIELD Nome                      AS CHARACTER FORMAT "x(100)"
    FIELD NumeroParcelas            AS INTEGER
    FIELD PercentualDesconto        AS DECIMAL 
    FIELD Prazo                     AS INTEGER
    FIELD Situacao                  AS INTEGER
    FIELD SupplierCard              AS LOGICAL
    FIELD UtilizadoCanais           AS LOGICAL
    FIELD UtilizadoFornecedores     AS LOGICAL
    FIELD UtilizadoB2B              AS LOGICAL
    FIELD UtilizadoSDCV             AS LOGICAL
    FIELD NumeroTabelaFinanciamento AS CHARACTER FORMAT "x(20)"
    FIELD ChaveIntegracaoIndice     AS CHARACTER FORMAT "x(50)"
    FIELD UtilizadoRevenda          AS LOG
    FIELD CondicaoFFT               LIKE int-cond-pagto.log-controla-fft.
   
DEFINE TEMP-TABLE msg0004r NO-UNDO XML-NODE-NAME 'MSG0004R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
