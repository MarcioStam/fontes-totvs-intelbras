DEFINE VARIABLE d-dt-embarque  AS DATE        NO-UNDO.
DEFINE VARIABLE c-mensagem     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-dt-limite    AS DATE        NO-UNDO.

{esp/imp/esimp000.i1}
{utp/ut-glob.i}
{utp/utapi019.i}
{esp/es0018.i}

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG.

DEFINE TEMP-TABLE tt-emitente NO-UNDO
    FIELD cod-emitente LIKE ordem-compra.cod-emitente
    FIELD embarque     LIKE embarque-imp.embarque
    FIELD num-pedido   LIKE ordem-compra.num-pedido
    FIELD numero-ordem LIKE prazo-compra.numero-ordem
    FIELD parcela      LIKE prazo-compra.parcela
    FIELD dt-limite    AS DATE
    FIELD num-dias     AS INT.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

FOR EACH embarque-imp NO-LOCK
   WHERE embarque-imp.situacao = 1:
    {esp/imp/esimp000.i}

    FIND FIRST tt-emb NO-ERROR.

    IF NOT AVAIL tt-emb THEN
        NEXT.

    IF  tt-emb.situacao <> 1 
    AND tt-emb.situacao <> 99 
    AND tt-emb.situacao <> 96 THEN
        NEXT.
    
    FIND FIRST historico-embarque OF embarque-imp NO-LOCK NO-ERROR.

    FIND FIRST itinerario NO-LOCK
         WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.

    FIND FIRST historico-embarque NO-LOCK
         WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
           AND historico-embarque.embarque      = embarque-imp.embarque
           AND historico-embarque.cod-pto-contr = itinerario.pto-embarque NO-ERROR.

    ASSIGN d-dt-embarque = IF  AVAIL historico-embarque 
                           AND historico-embarque.dt-efetiva <> ? THEN 
                               historico-embarque.dt-efetiva 
                           ELSE IF AVAIL historico-embarque THEN
                               historico-embarque.dt-ult-prev
                           ELSE 
                                ?.

    FIND FIRST historico-embarque
         WHERE historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-despch
           AND historico-embarque.cod-estabel   = embarque-imp.cod-estabel
           AND historico-embarque.embarque      = embarque-imp.embarque NO-LOCK NO-ERROR.

    IF d-dt-embarque <> ? THEN
        ASSIGN d-dt-limite = d-dt-embarque - 10.
    ELSE
        ASSIGN d-dt-limite = IF AVAIL historico-embarque THEN 
                                 IF historico-embarque.dt-efetiva <> ? THEN 
                                    historico-embarque.dt-efetiva - 10 
                                 ELSE historico-embarque.dt-ult-previsao - 10 
                             ELSE ?.  

    IF d-dt-limite - 20 = TODAY THEN DO:
        RUN pi-cria-tt (INPUT 20).
    END.

/*     IF d-dt-limite - 15 = TODAY THEN DO: */
/*         RUN pi-cria-tt (INPUT 15).       */
/*     END.                                 */

    IF d-dt-limite - 10 = TODAY THEN DO:
        RUN pi-cria-tt (INPUT 10).
    END.
END.

RUN pi-ler-tt.

PROCEDURE pi-cria-tt:

    DEFINE INPUT PARAM p-num-dias AS INT NO-UNDO.

    FOR EACH ordens-embarque OF embarque-imp NO-LOCK,
        EACH prazo-compra NO-LOCK
       WHERE prazo-compra.numero-ordem = ordens-embarque.numero-ordem:

        /*Se n∆o tem inspeá∆o agendada cria tt para envio de email*/
        IF NOT CAN-FIND (FIRST historico-inspecao
                         WHERE historico-inspecao.numero-ordem = prazo-compra.numero-ordem
                           AND historico-inspecao.parcela = prazo-compra.parcela
                           AND historico-inspecao.CodigoAgendamento <> 0) THEN DO:

            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-ERROR.

            FIND FIRST int-item-fornec-estab NO-LOCK
                 WHERE int-item-fornec-estab.it-codigo    = ordem-compra.it-codigo 
                   AND int-item-fornec-estab.cod-emitente = ordem-compra.cod-emitente
                   AND int-item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel NO-ERROR.
    
            IF NOT AVAIL int-item-fornec-estab 
            OR NOT int-item-fornec-estab.log-nec-inspec THEN
                NEXT.

            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "esrep041":U,
                               INPUT 2,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).

            IF CAN-FIND (FIRST tt-prog-ponto
                         WHERE tt-prog-ponto.conteudo = string(ordem-compra.cod-emitente))  THEN
                NEXT.

            IF NOT CAN-FIND (FIRST tt-emitente
                             WHERE tt-emitente.num-pedido = ordem-compra.num-pedido) THEN DO:

                CREATE tt-emitente.
                ASSIGN tt-emitente.num-pedido   = ordem-compra.num-pedido
                       tt-emitente.cod-emitente = ordem-compra.cod-emitente
                       tt-emitente.embarque     = ordens-embarque.embarque
                       tt-emitente.numero-ordem = prazo-compra.numero-ordem
                       tt-emitente.parcela      = prazo-compra.parcela
                       tt-emitente.dt-limite    = d-dt-limite
                       tt-emitente.num-dias     = p-num-dias.
            END.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-ler-tt:
    FOR EACH tt-emitente:
        
        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = tt-emitente.cod-emitente NO-ERROR.

        FIND FIRST ordem-compra NO-LOCK
             WHERE ordem-compra.numero-ordem = tt-emitente.numero-ordem NO-ERROR.

        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = ordem-compra.cod-comprado NO-ERROR.

        ASSIGN c-mensagem = "<b>This is an automatic e-mail from Intelbras.</b> <br> <br>" +
                            "Dear Supplier, <br>" + 
                            "we would like to inform you, there is a pending inspection booking on the Supplier Portal(<b>PO: " + string(tt-emitente.num-pedido) + "</b>). There are <b>" + STRING(tt-emitente.num-dias) + " Days</b> remaining for the deadline. <br>" + 
                            "<b>Remember:</b> You have until 5 days prior to the date limit to schedule, after that, the booking will be blocked. <br>"  + 
                            "If you need any help, please contact us. <br><br>" + 
                            "<b>Thank you!<br>" + 
                            "Best regards.</b> <br><br>".

        RUN pi-email (INPUT emitente.e-mail,
                      INPUT usuar_mestre.cod_e_mail_local,
                      INPUT c-mensagem).

    END.
END PROCEDURE.

PROCEDURE pi-email:
    DEFINE INPUT PARAM c-mail     AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAM c-copia    AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-utapi019 AS HANDLE      NO-UNDO.

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "esrep041":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH tt-prog-ponto:
        IF c-copia = "" THEN
            ASSIGN c-copia = tt-prog-ponto.conteudo.
        ELSE 
            ASSIGN c-copia = c-copia + ";" + tt-prog-ponto.conteudo.
    END.

    FOR FIRST param-global NO-LOCK:
    END.

    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-ERROR.
    
    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = c-mail                   /* Destinatòrio       */ 
           tt-envio2.copia             = c-copia                  /* Destinatòrio       */ 
           tt-envio2.remetente         = "nao_responda@intelbras.com.br"  /* Remetente          */ 
           tt-envio2.assunto           = "Pending Inspection Booking - SUPPLIER PORTAL"
           tt-envio2.formato           = "HTML".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = p-mensagem.

    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
   
    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    
    IF VALID-HANDLE(h-utapi019) THEN
        DELETE PROCEDURE h-utapi019.
END.
