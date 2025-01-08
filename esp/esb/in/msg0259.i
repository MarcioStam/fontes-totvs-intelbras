{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0259 NO-UNDO XML-NODE-NAME 'MSG0259'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoInterna    LIKE pagamento.nr-pagamento.

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0259R1 NO-UNDO XML-NODE-NAME 'MSG0259R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE VARIABLE h-boes138 AS HANDLE      NO-UNDO.
{esbo/boes138.i tt-pagamento}
{method/dbotterr.i}
DEFINE VARIABLE r-row AS ROWID       NO-UNDO.
