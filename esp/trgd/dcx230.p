/********************************************************************************
 ** UPC........: dcx230.p - UPC DELETE historico-embarque
 ** Data.......: Julho / 2015
 ** Objetivo...: Envia email na exclus∆o dos Ponto de Controle Chave de um Embarque
 ********************************************************************************/
 
{esp/es0018.i} 
{utp/utapi019.i}

 
DEF PARAM BUFFER b-historico-embarque      FOR historico-embarque.

DEFINE VARIABLE l-despacho      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-embarque      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-eadi          AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-nacionaliza   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-solicita-li   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-chegada       AS LOGICAL     NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.


FOR FIRST pto-itiner NO-LOCK
    WHERE pto-itiner.cod-itiner    = b-historico-embarque.cod-itiner
    AND   pto-itiner.cod-pto-contr = b-historico-embarque.cod-pto-contr:

    RUN pi-verifica-ponto-controle-chave(OUTPUT l-despacho,
                                         OUTPUT l-embarque,   
                                         OUTPUT l-eadi,
                                         OUTPUT l-nacionaliza,
                                         OUTPUT l-solicita-li,
                                         OUTPUT l-chegada).

    IF b-historico-embarque.dt-efetiva <> ? AND
       l-embarque THEN
        RUN pi-envia-email-eliminacao.

    

END.



RETURN "OK":U.



PROCEDURE pi-envia-email-eliminacao:

    DEFINE VARIABLE c-destinos      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-utapi019      AS HANDLE      NO-UNDO.

    DEFINE VARIABLE c-dt-previsao       AS CHAR     NO-UNDO.
    DEFINE VARIABLE c-dt-ult-previsao   AS CHAR     NO-UNDO.
    DEFINE VARIABLE c-dt-efetiva        AS CHAR     NO-UNDO.


    EMPTY TEMP-TABLE tt-prog-ponto.
    
    RUN esp/es0018p.p (INPUT "im0055a",  /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   

    ASSIGN c-destinos = "".
 
    FOR EACH tt-prog-ponto
         where tt-prog-ponto.nome-programa = "im0055a"
           and tt-prog-ponto.ponto         = 1:

        ASSIGN c-destinos = c-destinos + tt-prog-ponto.conteudo + ';'.

    END.

    ASSIGN c-destinos = SUBSTRING(c-destinos, 1, LENGTH(c-destinos) - 1).

    /**/
    
    FOR FIRST param-global NO-LOCK: END.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    EMPTY TEMP-TABLE tt-envio2 NO-ERROR.
    EMPTY TEMP-TABLE tt-mensagem NO-ERROR.


    ASSIGN c-dt-previsao = IF b-historico-embarque.dt-previsao = ? THEN "" ELSE STRING(b-historico-embarque.dt-previsao, "99/99/9999")
           c-dt-ult-previsao = IF b-historico-embarque.dt-ult-previsao = ? THEN "" ELSE STRING(b-historico-embarque.dt-ult-previsao, "99/99/9999")
           c-dt-efetiva = IF b-historico-embarque.dt-efetiva = ? THEN "" ELSE STRING(b-historico-embarque.dt-efetiva, "99/99/9999").

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail  /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail /* Porta do Servidor  */ 
           tt-envio2.destino           = c-destinos              /* Destinat†rio       */ 
           tt-envio2.remetente         = 'ems@intelbras.com.br'  /* Remetente          */ 
           tt-envio2.assunto           = 'Eliminaá∆o de Acompanhamento de Embarque: ' + string(b-historico-embarque.embarque) + ' - Estab: ' + b-historico-embarque.cod-estabel        /* Assunto            */
           tt-envio2.arq-anexo         = ""                      /* Arquivo Tempor†rio */
           tt-envio2.formato           = "TXT".

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE  usuar_mestre.cod_usuar = v_cod_usuar_corren:
    END.

    

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem = "Ponto de Controle Embarque foi Eliminado conforme dados abaixo:" + CHR(10) + CHR(10) +
                                  "Estabelecimento: " + b-historico-embarque.cod-estabel + CHR(10) +
                                  "N£mero do embarque: " + string(b-historico-embarque.embarque) + CHR(10) +
                                  "C¢digo Itiner†rio: " + string(b-historico-embarque.cod-itiner) + CHR(10) +
                                  "Sequencia: " + string(b-historico-embarque.sequencia) + CHR(10) +
                                  "Pto Controle: " + string(b-historico-embarque.cod-pto-contr) + CHR(10) +
                                  "C¢digo do usu†rio: " + v_cod_usuar_corren + CHR(10) +
                                  "Nome do usu†rio: " + (IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "") + CHR(10) + 
                                  "Data de modificaá∆o: " + STRING(TODAY, "99/99/9999") + CHR(10) +
                                  "Hora de modificaá∆o: " + STRING(TIME, "HH:MM:SS") + CHR(10) + 
                                  "Data Previs∆o: " + c-dt-previsao + CHR(10) + 
                                  "Data Èltima Previs∆o: " + c-dt-ult-previsao + CHR(10) + 
                                  "Data Efetiva: " + c-dt-efetiva + CHR(10) +
                                  "Atenciosamente," + CHR(10) +
                                  "Equipe TI Sistemas".
            
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF  AVAIL tt-erros THEN DO:
        OUTPUT TO erros-comerc.LOG APPEND.

        FOR EACH tt-erros:
            DISP tt-erros.cod-erro
                 tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
        END.
        OUTPUT CLOSE.
    END. /* IF  AVAIL tt-erros THEN DO: */
    
    DELETE PROCEDURE h-utapi019.

END PROCEDURE.


PROCEDURE pi-verifica-ponto-controle-chave:

    DEFINE OUTPUT PARAMETER p-despacho      AS LOGICAL  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-embarque      AS LOGICAL  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-eadi          AS LOGICAL  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-nacionaliza   AS LOGICAL  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-solicita-li   AS LOGICAL  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-chegada       AS LOGICAL  NO-UNDO.

    DEFINE VARIABLE h-bocx120   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cLocal AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-recebimento AS LOGICAL     NO-UNDO.


    IF AVAIL pto-itiner THEN DO:

        RUN cxbo/bocx120.p PERSISTENT SET h-bocx120.

        RUN setalocais in h-bocx120 (input ROWID(pto-itiner),
                                     output p-eadi,
                                     OUTPUT l-recebimento,
                                     output clocal).
    
        run getParameterLI in h-bocx120 (output p-solicita-li).
        
        if clocal = "embarque/despacho" then
            assign p-embarque    = yes
                   p-nacionaliza = no
                   p-despacho    = yes
                   p-chegada     = no.
        ELSE if clocal = "desembarque/chegada" then
            assign p-embarque    = no
                   p-nacionaliza = yes
                   p-despacho    = no
                   p-chegada     = yes.
        else if clocal = "desembarque" then
            assign p-embarque    = no
                   p-nacionaliza = yes
                   p-despacho    = no
                   p-chegada     = no.
        else if clocal = "despacho" then
            assign p-embarque    = no
                   p-nacionaliza = no
                   p-despacho    = yes
                   p-chegada     = no.
        else if clocal = "chegada" then
            assign p-embarque    = no
                   p-nacionaliza = no
                   p-despacho    = no
                   p-chegada     = yes.
        else if clocal = "embarque" then
            assign p-embarque    = yes
                   p-nacionaliza = no
                   p-despacho    = no
                   p-chegada     = no.


        DELETE PROCEDURE h-bocx120.

        ASSIGN h-bocx120 = ?.
        
    END.

    RETURN "OK":U.


END PROCEDURE.

