{include/i-prgvrs.i esesb011rp 2.04.00.001}
 
{esp/esb/esesb000.i}
{include/i-rpvar.i}

DEFINE VARIABLE h-acomp AS HANDLE     NO-UNDO.

IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

DEFINE TEMP-TABLE tt-natur-oper LIKE natur-oper.   
DEFINE TEMP-TABLE tt-fam-com-item LIKE fam-com-item.

DEFINE VARIABLE time-ini AS INTEGER     NO-UNDO.
DEFINE VARIABLE time-fim AS INTEGER     NO-UNDO.

ASSIGN time-ini = TIME.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                     AS INTEGER
    FIELD arquivo                     AS CHAR FORMAT "x(35)"
    FIELD usuario                     AS CHAR FORMAT "x(12)"
    FIELD data-exec                   AS DATE
    FIELD hora-exec                   AS INTEGER
    FIELD classifica                  AS INTEGER
    FIELD desc-classifica             AS CHAR FORMAT "x(40)"
    FIELD modelo-rtf                  AS CHAR FORMAT "x(35)"
    FIELD l-habilitaRtf               AS LOG
    FIELD ind-execucao                AS INT
    FIELD cod-emitente                AS INT.

DEFINE TEMP-TABLE tt-raw-digita
   FIELD raw-digita AS RAW.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* OUTPUT TO VALUE (SESSION:TEMP-DIRECTORY + "integracao_canais.txt"). */

RUN pi-inicializar IN h-acomp (INPUT "Integra‡Æo").

{include/i-rpout.i}

FOR EACH ped-venda NO-LOCK
    WHERE ped-venda.cod-emitente  = tt-param.cod-emitente
    AND   ped-venda.dt-implant   >= 07/01/2014:
     RAW-TRANSFER ped-venda TO raw-param.

    RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                            INPUT        raw-param, /* Tupla do registro */
                            OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
    RUN pi-result (INPUT "msg0091").
END.


FOR EACH nota-fiscal 
   WHERE nota-fiscal.dt-emis-nota >= 07/01/2014
     AND nota-fiscal.cod-emitente  = tt-param.cod-emitente
     AND nota-fiscal.dt-confirma  <> ? 
     AND nota-fiscal.nr-pedcli    <> "" 
     AND nota-fiscal.nr-pedcli    <> ? NO-LOCK:

    RAW-TRANSFER nota-fiscal TO raw-param.
    
    RUN esp/esb/esesb003.p (INPUT        "msg0094", /* Nome Mensagem */  
                            INPUT        raw-param, /* Tupla do registro */
                            OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
    RUN pi-result (INPUT "msg0094").

    PUT UNFORMATTED "Nota enviada para o barramento: " + nota-fiscal.cod-estabel + " - " + nota-fiscal.serie + " - " nota-fiscal.nr-nota-fis SKIP. 

END.



ASSIGN time-fim = TIME.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i}
                           
PROCEDURE pi-result:
    DEFINE INPUT PARAM c-msg AS CHAR.

    RUN pi-acompanhar IN h-acomp (INPUT c-msg).

    FIND FIRST resultado NO-ERROR.

    PUT UNFORMATTED c-msg.
    IF AVAIL resultado THEN
        PUT UNFORMATTED " " + resultado.mensagem SKIP.
    ELSE 
        PUT UNFORMATTED " sem Resultado" SKIP.
END.
