{esp/esb/esesb000.i}

DEF TEMP-TABLE tt-tmp-integra-ccusto NO-UNDO
    FIELD c-cod-estab  AS CHAR
    FIELD c-cod-ccusto AS CHAR
    FIELD c-nom-ccusto AS CHAR
    FIELD c-ind-movto  AS CHAR
    INDEX id-ccusto
            c-cod-ccusto
            c-cod-estab.

DEFINE TEMP-TABLE msg0178 NO-UNDO XML-NODE-NAME 'MSG0178'
    FIELD idm                  AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoCentroCusto    AS CHAR
    FIELD NomeCentroCusto      AS CHAR
    FIELD NomeEmpresa          AS CHAR
    FIELD CodigoCentroCustoPai AS CHAR
    FIELD Acao                 AS CHAR.

DEFINE TEMP-TABLE msg0178r NO-UNDO XML-NODE-NAME 'MSG0178R'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.
