{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0255 NO-UNDO XML-NODE-NAME 'MSG0255'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoInterna    LIKE pagamento.nr-pagamento
   .

/*Dataset Entrada*/
DEFINE TEMP-TABLE Fatura NO-UNDO XML-NODE-NAME 'Fatura'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD NumeroEmbarque        LIKE pagamento-invoice.embarque
    FIELD CodigoEstabelecimento LIKE embarque-imp.cod-estabel
    FIELD NumeroInvoice         LIKE pagamento-invoice.nr-invoice
    FIELD ParcelaInvoice        LIKE pagamento-invoice.parcela.
    .

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0255R1 NO-UNDO XML-NODE-NAME 'MSG0255R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   .

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
