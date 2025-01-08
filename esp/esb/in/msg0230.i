{esp/esb/esesb000.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0230 NO-UNDO XML-NODE-NAME 'MSG0230'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.


DEFINE TEMP-TABLE LI NO-UNDO XML-NODE-NAME 'LI'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque        LIKE embarque-imp.embarque
   FIELD CodigoEstabelecimento LIKE embarque-imp.cod-estabel
   FIELD NumeroOrdemCompra     LIKE licenciam-import-oc.numero-ordem
   FIELD SequenciaParcela      LIKE licenciam-import-oc.parcela
   FIELD NumeroLIAnuida        LIKE licenciam-import-oc.licenca-import
   FIELD ValidadeLI            AS DATE
   FIELD ExportarLI            AS LOG.

/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0230R1 NO-UNDO XML-NODE-NAME 'MSG0230R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

/*Outras Defini‡äes*/
DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

{method/dbotterr.i}
