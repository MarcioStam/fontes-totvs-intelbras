{esp/esb/esesb000.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0249 NO-UNDO XML-NODE-NAME 'MSG0249'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque           LIKE invoice-emb-imp.embarque
   FIELD CodigoEstabelecimento    LIKE invoice-emb-imp.cod-estabel
   FIELD NumeroCommercialInvoice  LIKE invoice-emb-imp.nr-invoice
   FIELD ParcelaCommercialInvoice LIKE invoice-emb-imp.parcela.


/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0249R1 NO-UNDO XML-NODE-NAME 'MSG0249R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

/*Outras Defini‡äes*/

DEF TEMP-TABLE tt-invoice-emb-imp NO-UNDO LIKE invoice-emb-imp
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE VARIABLE r-row AS ROWID       NO-UNDO.
{method/dbotterr.i}
