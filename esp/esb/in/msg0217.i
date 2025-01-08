{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0217 NO-UNDO XML-NODE-NAME 'MSG0217'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque        LIKE invoice-emb-imp.embarque
   FIELD CodigoEstabelecimento LIKE invoice-emb-imp.cod-estabel.


/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0217_R1 NO-UNDO XML-NODE-NAME 'MSG0217R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE PrevisaoFatura NO-UNDO XML-NODE-NAME 'PrevisaoFatura'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque         LIKE invoice-emb-imp.embarque   
   FIELD CodigoEstabelecimento  LIKE invoice-emb-imp.cod-estabel
   FIELD DataCommercialInvoice  LIKE invoice-emb-imp.dt-vencim
   FIELD ValorCommercialInvoice LIKE invoice-emb-imp.vl-invoice
   FIELD CodigoMoedaEMS         LIKE invoice-emb-imp.mo-codigo
   FIELD NomeMoeda              LIKE moeda.descricao.

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
