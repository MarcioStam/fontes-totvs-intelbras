{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0260 NO-UNDO XML-NODE-NAME 'MSG0260'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoInterna  LIKE pagamento.nr-pagamento
   FIELD MotivoCancelamento        AS CHAR.

DEFINE TEMP-TABLE Fatura NO-UNDO XML-NODE-NAME 'Fatura'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque        LIKE pagamento-invoice.embarque
   FIELD CodigoEstabelecimento LIKE pagamento.cod-estabel
   FIELD NumeroInvoice         LIKE pagamento-invoice.nr-invoice
   FIELD ParcelaInvoice        LIKE pagamento-invoice.parcela
   .

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0260R1 NO-UNDO XML-NODE-NAME 'MSG0260R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

