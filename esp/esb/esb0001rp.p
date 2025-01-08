{include/i-prgvrs.i esb0001rp 2.00.00.001}  

{esp/esb/esesb000.i}
{include/i-rpvar.i}
{esp/es0018.i}

DEFINE VARIABLE h-acomp AS HANDLE     NO-UNDO.
DEFINE BUFFER b-int-ped-venda FOR int-ped-venda.
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

DEFINE TEMP-TABLE tt-natur-oper NO-UNDO LIKE natur-oper.   
DEFINE TEMP-TABLE tt-fam-com-item NO-UNDO LIKE fam-com-item.

DEFINE VARIABLE time-ini          AS INTEGER     NO-UNDO.
DEFINE VARIABLE time-fim          AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-nota-com-pedido AS LOGICAL     NO-UNDO.

ASSIGN time-ini = TIME.

{esp/esb/out/msg0159.i}

/* tt-param */
{esp/esb/esb0001rp.i}


DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
   FIELD raw-digita AS RAW.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* OUTPUT TO VALUE (SESSION:TEMP-DIRECTORY + "integracao_canais.txt"). */

RUN pi-inicializar IN h-acomp (INPUT "Integra‡Æo").

{include/i-rpout.i}

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(250)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEF BUFFER b-nota-orig FOR nota-fiscal.

DEF TEMP-TABLE tt-nat NO-UNDO
    FIELD nat-operacao AS CHAR.

DEF VAR l-envia-nota-sem-pedido AS LOG INIT NO NO-UNDO.

FOR FIRST ponto-programa NO-LOCK
    WHERE ponto-programa.nome-programa = "esb0001rp"
      AND ponto-programa.ponto         = 1,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

    CREATE tt-nat.
    ASSIGN tt-nat.nat-operacao = conteudo-programa.conteudo.
END.

/*--------------------------------*/
/*    M O V I M E N T A € å E S   */
/*--------------------------------*/
IF tt-param.log-nota-fiscal THEN DO:     
    IF  tt-param.ind-execucao = 2 
    AND tt-param.dt-emiss-nota-ini = 01/01/0001 
    AND tt-param.dt-emiss-nota-fim = 01/01/0001 THEN DO:

        FOR EACH nota-fiscal 
           WHERE nota-fiscal.dt-emis-nota >= TODAY - 1
             AND nota-fiscal.dt-confirma  <> ? NO-LOCK:
             
            /* Naturezas parametrizadas no es0018, permitem envio de nota sem pedido */
            IF  (nota-fiscal.nr-pedcli = "" OR nota-fiscal.nr-pedcli = ?) 
            AND NOT can-find(tt-nat WHERE tt-nat.nat-operacao = nota-fiscal.nat-operacao) THEN
                NEXT.

            IF CAN-FIND (FIRST int-emitente
                         WHERE int-emitente.cod-emitente = nota-fiscal.cod-emitente
                           AND int-emitente.guid-class <> "") THEN DO:
                RAW-TRANSFER nota-fiscal TO raw-param.
                
                RUN esp/esb/esesb003.p (INPUT        "msg0094", /* Nome Mensagem */  
                                        INPUT        raw-param, /* Tupla do registro */
                                        OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                RUN pi-result (INPUT "msg0094").

                PUT UNFORMATTED "Nota enviada para o barramento: " + nota-fiscal.cod-estabel + " - " + nota-fiscal.serie + " - " nota-fiscal.nr-nota-fis SKIP. 
    
                FOR FIRST ped-venda NO-LOCK
                    WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli:
                     RAW-TRANSFER ped-venda TO raw-param.
            
                    RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                                            INPUT        raw-param, /* Tupla do registro */
                                            OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                    RUN pi-result (INPUT "msg0091").
                END.
            END.
        END.

        /* NOTAS DEVOLU€ÇO */
        FOR EACH devol-cli NO-LOCK 
            WHERE devol-cli.dt-devol >= TODAY - 1
        , FIRST nota-fiscal no-lock
             WHERE nota-fiscal.cod-estabel = devol-cli.cod-estabel
               AND nota-fiscal.serie       = devol-cli.serie-docto
               AND nota-fiscal.nr-nota-fis = devol-cli.nro-docto
               AND nota-fiscal.dt-confirma <> ?
               AND nota-fiscal.esp-docto   = 20
            BREAK BY devol-cli.cod-estabel
                  BY devol-cli.serie
                  BY devol-cli.nr-nota-fis:

            ASSIGN l-nota-com-pedido = NO.

            IF  FIRST-OF (devol-cli.nr-nota-fis)  THEN DO:
                 FOR FIRST b-nota-orig no-lock
                     WHERE b-nota-orig.cod-estabel = devol-cli.cod-estabel
                       AND b-nota-orig.serie       = devol-cli.serie
                       AND b-nota-orig.nr-nota-fis = devol-cli.nr-nota-fis:

                       IF  b-nota-orig.nr-pedcli  <> "" 
                       AND b-nota-orig.nr-pedcli  <> ? THEN DO:
                           FOR FIRST ped-venda NO-LOCK
                               WHERE ped-venda.nome-abrev = b-nota-orig.nome-ab-cli
                                 AND ped-venda.nr-pedcli  = b-nota-orig.nr-pedcli:
                                   
                                 ASSIGN l-nota-com-pedido = YES.
                                 RAW-TRANSFER ped-venda TO raw-param.

                                 RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                                                         INPUT        raw-param, /* Tupla do registro */
                                                         OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                                RUN pi-result (INPUT "msg0091").
                           END.
                       END.
                 END.

                IF CAN-FIND (FIRST int-emitente
                             WHERE int-emitente.cod-emitente = b-nota-orig.cod-emitente
                               AND int-emitente.guid-class <> "") THEN DO:             /* Indica que o cliente esta cadastrado no crm2013, portanto o pedido deve ser integrado - chamado 48202 */
                    /*Envia somente as devolu‡äes que possuem pedido na nota de entrada*/
                    IF l-nota-com-pedido THEN DO:
                        RAW-TRANSFER nota-fiscal TO raw-param.
                        
                        RUN esp/esb/esesb003.p (INPUT        "msg0094", /* Nome Mensagem */  
                                                INPUT        raw-param, /* Tupla do registro */
                                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                        RUN pi-result (INPUT "msg0094").
        
                        PUT UNFORMATTED "Nota de Devolu‡Æo enviada para o barramento: " + nota-fiscal.cod-estabel + " - " + nota-fiscal.serie + " - " nota-fiscal.nr-nota-fis SKIP. 
                    END.
                END.
            END.
        END.


    END.
    ELSE DO:
        /* NOTAS NORMAIS */
        FOR EACH nota-fiscal 
           WHERE nota-fiscal.cod-estabel  >= tt-param.c-cod-estabel-ini
             AND nota-fiscal.cod-estabel  <= tt-param.c-cod-estabel-fim
             AND nota-fiscal.serie        >= tt-param.c-serie-ini
             AND nota-fiscal.serie        <= tt-param.c-serie-fim
             AND nota-fiscal.nr-nota-fis  >= tt-param.c-nr-nota-fis-ini 
             AND nota-fiscal.nr-nota-fis  <= tt-param.c-nr-nota-fis-fim 
             AND nota-fiscal.dt-emis-nota >= tt-param.dt-emiss-nota-ini 
             AND nota-fiscal.dt-emis-nota <= tt-param.dt-emiss-nota-fim
             AND nota-fiscal.cod-emitente >= tt-param.c-cod-emitente-ini 
             AND nota-fiscal.cod-emitente <= tt-param.c-cod-emitente-fim 
             AND nota-fiscal.dt-confirma  <> ? NO-LOCK:


            /* Naturezas parametrizadas no es0018, permitem envio de nota sem pedido */
            IF  (nota-fiscal.nr-pedcli = "" OR nota-fiscal.nr-pedcli = ?) 
            AND NOT can-find(tt-nat WHERE tt-nat.nat-operacao = nota-fiscal.nat-operacao) THEN
                NEXT.
    
            IF CAN-FIND (FIRST int-emitente
                         WHERE int-emitente.cod-emitente = nota-fiscal.cod-emitente
                           AND int-emitente.guid-class <> "") THEN DO:
                RAW-TRANSFER nota-fiscal TO raw-param.
                
                RUN esp/esb/esesb003.p (INPUT        "msg0094", /* Nome Mensagem */  
                                        INPUT        raw-param, /* Tupla do registro */
                                        OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                RUN pi-result (INPUT "msg0094").

                PUT UNFORMATTED "Nota enviada para o barramento: " + nota-fiscal.cod-estabel + " - " + nota-fiscal.serie + " - " nota-fiscal.nr-nota-fis SKIP. 
    
                FOR FIRST ped-venda NO-LOCK
                    WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli:
                     RAW-TRANSFER ped-venda TO raw-param.
            
                    RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                                            INPUT        raw-param, /* Tupla do registro */
                                            OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                    RUN pi-result (INPUT "msg0091").
                END.
            END.
        END.

        /* NOTAS DE DEVOLU€ÇO */
        FOR EACH devol-cli NO-LOCK 
            WHERE devol-cli.cod-estabel  >= tt-param.c-cod-estabel-ini
              AND devol-cli.cod-estabel  <= tt-param.c-cod-estabel-fim
              AND devol-cli.serie-docto  >= tt-param.c-serie-ini 
              AND devol-cli.serie-docto  <= tt-param.c-serie-fim 
              AND devol-cli.nro-docto    >= tt-param.c-nr-nota-fis-ini 
              AND devol-cli.nro-docto    <= tt-param.c-nr-nota-fis-fim 
              AND devol-cli.dt-devol     >= tt-param.dt-emiss-nota-ini
              AND devol-cli.dt-devol     <= tt-param.dt-emiss-nota-fim
              AND devol-cli.cod-emitente >= tt-param.c-cod-emitente-ini 
              AND devol-cli.cod-emitente <= tt-param.c-cod-emitente-fim 
        , FIRST nota-fiscal no-lock
             WHERE nota-fiscal.cod-estabel = devol-cli.cod-estabel
               AND nota-fiscal.serie       = devol-cli.serie-docto
               AND nota-fiscal.nr-nota-fis = devol-cli.nro-docto
               AND nota-fiscal.esp-docto = 20
            BREAK BY devol-cli.cod-estabel
                  BY devol-cli.serie
                  BY devol-cli.nr-nota-fis:

            ASSIGN l-nota-com-pedido = NO.

            IF  FIRST-OF (devol-cli.nr-nota-fis)  THEN DO:
                IF CAN-FIND (FIRST int-emitente
                             WHERE int-emitente.cod-emitente = nota-fiscal.cod-emitente
                               AND int-emitente.guid-class <> "") THEN DO:             /* Indica que o cliente esta cadastrado no crm2013, portanto o pedido deve ser integrado - chamado 48202 */
                               
                    /* ENVIAR O PEDIDO REFERENTE · NOTA DE ORIGEM */
                    FOR FIRST b-nota-orig no-lock
                        WHERE b-nota-orig.cod-estabel = devol-cli.cod-estabel
                          AND b-nota-orig.serie       = devol-cli.serie
                          AND b-nota-orig.nr-nota-fis = devol-cli.nr-nota-fis:

                        FOR FIRST ped-venda NO-LOCK
                            WHERE ped-venda.nome-abrev = b-nota-orig.nome-ab-cli
                              AND ped-venda.nr-pedcli  = b-nota-orig.nr-pedcli:

                              ASSIGN l-nota-com-pedido = YES.
                             
                              RAW-TRANSFER ped-venda TO raw-param.
                    
                              RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                                                      INPUT        raw-param, /* Tupla do registro */
                                                      OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                             RUN pi-result (INPUT "msg0091").
                        END.
                    END.
                    /*Envia somente as devolu‡äes que possuem pedido na nota de entrada*/
                    IF l-nota-com-pedido THEN DO:

                        RAW-TRANSFER nota-fiscal TO raw-param.
                        
                        RUN esp/esb/esesb003.p (INPUT        "msg0094", /* Nome Mensagem */  
                                                INPUT        raw-param, /* Tupla do registro */
                                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                        RUN pi-result (INPUT "msg0094").
        
                        PUT UNFORMATTED "Nota de Devolu‡Æo enviada para o barramento: " + nota-fiscal.cod-estabel + " - " + nota-fiscal.serie + " - " nota-fiscal.nr-nota-fis SKIP. 
                    END.
                END.
            END.

        END. /* FOR EACH DEVOLU€åES*/

    END.
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


