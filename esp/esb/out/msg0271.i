DEFINE TEMP-TABLE msg0271 NO-UNDO XML-NODE-NAME 'MSG0271'
    FIELD idm               AS INT XML-NODE-TYPE 'hidden'
    FIELD DataInicio        AS DATE
    FIELD DataFim           AS DATE
    FIELD StatusSolicitacao AS CHAR
    FIELD StatusDespesa     AS CHAR
    FIELD TipoData          AS CHAR.
                                   
DEFINE TEMP-TABLE msg0271r NO-UNDO XML-NODE-NAME 'MSG0271R1'
    FIELD idm               AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE ListaSolicitacaoAdiantamento NO-UNDO XML-NODE-NAME 'ListaSolicitacaoAdiantamento'
    FIELD idm               AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE ItemSolicitacaoAdiantamento NO-UNDO XML-NODE-NAME 'ItemSolicitacaoAdiantamento'
    FIELD idm               AS INT XML-NODE-TYPE 'hidden'
    FIELD IdentificadorARB  AS CHAR
    FIELD StatusDespesa     AS CHAR
    FIELD CodigoARB         AS CHAR
    FIELD StatusSolicitacao AS CHAR.



    
    
