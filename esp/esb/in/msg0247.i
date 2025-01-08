{esp/esb/esesb000.i}

/*Dataset de entrada*/
DEFINE TEMP-TABLE MSG0247 NO-UNDO XML-NODE-NAME 'MSG0247'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque          LIKE historico-embarque.embarque
   FIELD CodigoEstabelecimento   LIKE historico-embarque.cod-estabel
   FIELD CodigoPontoControle     LIKE historico-embarque.cod-pto-contr.

/*Dataset de sa¡da*/
DEFINE TEMP-TABLE MSG0247R1 NO-UNDO XML-NODE-NAME 'MSG0247R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque        LIKE historico-embarque.embarque    INITIAL ?
   FIELD CodigoEstabelecimento LIKE historico-embarque.cod-estabel INITIAL ?.

DEFINE TEMP-TABLE PontoControle NO-UNDO XML-NODE-NAME 'PontoControle'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoPontoControle             LIKE historico-embarque.cod-pto-contr
   FIELD SequenciaPontoControle          LIKE historico-embarque.sequencia
   FIELD DescricaoPontoControle          LIKE pto-contr.descricao
   FIELD DataPrevOriginalPontoControle   LIKE historico-embarque.dt-previsao
   FIELD DataUltimaPrevisaoPontoControle LIKE historico-embarque.dt-ult-previsao
   FIELD IntegrouDI                      AS LOG
   FIELD DataEfetivaPontoControle        LIKE historico-embarque.dt-efetiva
   FIELD VeiculoTransporte               LIKE historico-embarque.id-meio-transp
   FIELD ObservacoesPontoControle        LIKE historico-embarque.observacao
   FIELD CodigoTipoPontoControle         AS INT.        

/*Outras Defini‡äes*/
DEF TEMP-TABLE tt-historico-embarque NO-UNDO LIKE historico-embarque
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
   FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE VARIABLE r-row AS ROWID       NO-UNDO.
{method/dbotterr.i}

DEFINE VARIABLE l-integra-di   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-eadi         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-solicita-li  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE clocal         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-bocx384      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx120      AS HANDLE      NO-UNDO.
