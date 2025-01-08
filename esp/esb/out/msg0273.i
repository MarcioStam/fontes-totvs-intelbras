DEFINE TEMP-TABLE msg0273 NO-UNDO XML-NODE-NAME 'MSG0273'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoARB           AS CHAR
    FIELD DataPagamento       AS DATE
    FIELD TipoPagamento       AS CHAR
    FIELD Moeda               AS CHAR
    FIELD NumeroContaCorrente AS CHAR
    FIELD ProvisaoPagamento   AS DEC
    FIELD Observacao          AS CHAR.
                                   
DEFINE TEMP-TABLE msg0273r NO-UNDO XML-NODE-NAME 'MSG0273R1'
    FIELD idm               AS INT XML-NODE-TYPE 'hidden'.
