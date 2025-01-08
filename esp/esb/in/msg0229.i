{esp/esb/esesb000.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0229 NO-UNDO XML-NODE-NAME 'MSG0229'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque        LIKE invoice-emb-imp.embarque
   FIELD CodigoEstabelecimento LIKE invoice-emb-imp.cod-estabel.


DEFINE TEMP-TABLE CommercialInvoice NO-UNDO XML-NODE-NAME 'CommercialInvoice'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroCommercialInvoice  LIKE invoice-emb-imp.nr-invoice
   FIELD ParcelaCommercialInvoice LIKE invoice-emb-imp.parcela
   FIELD DataCommercialInvoice    LIKE invoice-emb-imp.dt-vencim
   FIELD ValorCommercialInvoice   LIKE invoice-emb-imp.vl-invoice
   FIELD CodigoMoedaEMS           LIKE invoice-emb-imp.mo-codigo.

/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0229R1 NO-UNDO XML-NODE-NAME 'MSG0229R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

/*Outras Defini‡äes*/
DEF TEMP-TABLE tt-invoice-emb-imp NO-UNDO LIKE invoice-emb-imp
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

{method/dbotterr.i}
