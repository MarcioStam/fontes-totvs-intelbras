{esp/esb/esesb000.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0220 NO-UNDO XML-NODE-NAME 'MSG0220'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE Despesa NO-UNDO XML-NODE-NAME 'Despesa'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque          LIKE desp-embarque.embarque
   FIELD CodigoEstabelecimento   LIKE desp-embarque.cod-estabel
   FIELD CodigoPontoControle     LIKE desp-embarque.cod-pto-contr
   FIELD CodigoDespesa           LIKE desp-embarque.cod-desp         
   FIELD CodigoFornecedorEMS     LIKE desp-embarque.cod-emitente-desp
   FIELD CodigoCondicaoPagamento LIKE desp-embarque.cod-cond-pag     
   FIELD CodigoMoedaEMS          LIKE desp-embarque.mo-codigo        
   FIELD ValorDespesa            LIKE desp-embarque.val-desp.

/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0220R1 NO-UNDO XML-NODE-NAME 'MSG0220R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

/*Outras Defini‡äes*/

DEF TEMP-TABLE tt-desp-embarque NO-UNDO LIKE desp-embarque
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

{method/dbotterr.i}
