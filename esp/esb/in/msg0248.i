{esp/esb/esesb000.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0248 NO-UNDO XML-NODE-NAME 'MSG0248'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque          LIKE desp-embarque.embarque
   FIELD CodigoEstabelecimento   LIKE desp-embarque.cod-estabel
   FIELD CodigoDespesa           LIKE desp-embarque.cod-desp
   FIELD CodigoPontoControle     LIKE desp-embarque.cod-pto-contr
   FIELD CodigoFornecedorEMS     LIKE desp-embarque.cod-emitente-desp.

/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0248R1 NO-UNDO XML-NODE-NAME 'MSG0248R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

/*Outras Defini‡äes*/

DEF TEMP-TABLE tt-desp-embarque NO-UNDO LIKE desp-embarque
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE VARIABLE r-row AS ROWID       NO-UNDO.
{method/dbotterr.i}
