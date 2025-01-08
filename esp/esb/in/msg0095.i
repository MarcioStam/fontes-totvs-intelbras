{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0095 NO-UNDO XML-NODE-NAME 'MSG0095'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD NumeroPedido AS CHAR.

DEFINE TEMP-TABLE msg0095r NO-UNDO XML-NODE-NAME 'MSG0095R1'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE nota-fiscal-itens NO-UNDO XML-NODE-NAME 'NotasFiscaisItens'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE nota-fiscal-item NO-UNDO XML-NODE-NAME 'NotaFiscalItem'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD NumeroNotaFiscal                AS CHAR
    FIELD NumeroSerie                     AS CHAR
    FIELD Descricao                       AS CHAR
    FIELD SituacaoNota                    AS INT
    FIELD SituacaoEntrega                 AS INT
    FIELD DataEmissao                     AS DATE
    FIELD DataPrevisaoEntrega             AS DATE 
    FIELD ValorFrete                      AS DEC    FORMAT "9999999999.9999"
    FIELD Volume                          AS CHAR
    FIELD ValorBaseICMS                   AS DEC    FORMAT "9999999999.9999"
    FIELD ValorICMS                       AS DEC    FORMAT "9999999999.9999"
    FIELD ValorIPI                        AS DEC    FORMAT "9999999999.9999"
    FIELD ValorBaseSubstituicaoTributaria AS DEC    FORMAT "9999999999.9999"
    FIELD ValorSubstituicaoTributaria     AS DEC    FORMAT "9999999999.9999"
    FIELD ValorDesconto                   AS DEC    FORMAT "9999999999.9999"
    FIELD PercentualDesconto              AS DEC    FORMAT "999.99"
    FIELD ValorTotal                      AS DEC    FORMAT "9999999999.9999"
    FIELD ValorTotalImpostos              AS DEC    FORMAT "9999999999.9999"
    FIELD ValorTotalSemImposto            AS DEC    FORMAT "9999999999.9999"
    FIELD ValorTotalSemFrete              AS DEC    FORMAT "9999999999.9999"
    FIELD ValorTotalDesconto              AS DEC    FORMAT "9999999999.9999"
    FIELD ValorTotalProdutos              AS DEC    FORMAT "9999999999.9999"
    FIELD ValorTotalProdutosSemImposto    AS DEC    FORMAT "9999999999.9999"
    FIELD NotaDevolucao                   AS LOG .
    
