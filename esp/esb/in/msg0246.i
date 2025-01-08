{esp/esb/esesb000.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0246 NO-UNDO XML-NODE-NAME 'MSG0246'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque          LIKE desp-embarque.embarque
   FIELD CodigoEstabelecimento   LIKE desp-embarque.cod-estabel.

/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0246R1 NO-UNDO XML-NODE-NAME 'MSG0246R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

/*Outras Defini‡äes*/

DEF TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE VARIABLE r-row AS ROWID       NO-UNDO.
{method/dbotterr.i}
