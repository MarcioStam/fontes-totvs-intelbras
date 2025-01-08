/* ---------------------------------------------------------------------------
Programa : ft4003-upc.p
Funcao   : Preencher automaticamente os dados do c lculo da NF com os valores
           obtidos das tabelas espec¡ficas.
           O programa se utiliza de BOs da Datasul para a cria‡Æo das
           WT's, tabelas que ap¢s efetivadas dÆo origem a Nota Fiscal.
Autor    : Robinson Rafael Koprowski
Data     : 11/2004
Altera‡Æo:
--------------------------------------------------------------------------- */
{esp/es0018.i}
{utp/utapi019.i}

DEFINE INPUT PARAMETER p-ind-event      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object     AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object     AS HANDLE           NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame      AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-row-table      AS ROWID            NO-UNDO.


DEFINE VARIABLE h-object    AS HANDLE           NO-UNDO.
DEFINE VARIABLE c-objeto    AS CHARACTER        NO-UNDO.
DEFINE VARIABLE h-frame     AS HANDLE           NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE hFT4003                 AS HANDLE              NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-but-peso             AS WIDGET-HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-button               AS WIDGET-HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-mail              AS WIDGET-HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-btCalcula             AS HANDLE              NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-btSimula             AS HANDLE              NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hFT4003-frame0          AS HANDLE              NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-seq-wt-docto-ft4003  AS WIDGET-HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v-row-wt-docto-ft4003   AS ROWID               NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE I-NumPedidoEsftp060     AS INTEGER             NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE g-finalidade-esftp009   AS CHAR FORMAT "x(40)" NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-finalidade           AS HANDLE              NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-new-btCalcula-ft4003 AS WIDGET-HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-new-btSimula-ft4003  AS WIDGET-HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-ft4003-upc            AS HANDLE              NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-row-ft4003            AS ROWID               NO-UNDO.
DEFINE VARIABLE l-calcula AS LOGICAL     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-simula-ft4003         AS LOG INIT NO         NO-UNDO.

DEFINE VAR l-mantem-volume AS LOG INIT NO NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR c-volume-ft4003 AS CHAR INIT "" NO-UNDO.



ASSIGN c-objeto   = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

IF  p-cod-table  = "wt-docto" AND
    p-row-table <> ? 
THEN
    ASSIGN v-row-wt-docto-ft4003 = p-row-table.


IF  p-ind-event = "AFTER-INITIALIZE" 
AND p-ind-object = "CONTAINER" THEN DO:

    IF  NOT VALID-HANDLE(h-ft4003-upc) THEN
        RUN upc/ft4003-upc.p PERSISTENT SET h-ft4003-upc (INPUT "",
                                                          INPUT "",
                                                          INPUT p-wgh-object,
                                                          INPUT p-wgh-frame,
                                                          INPUT "",
                                                          INPUT p-row-table).

    ASSIGN hFT4003 = p-wgh-object
           hFT4003-frame0 = p-wgh-frame.

    ASSIGN v-row-wt-docto-ft4003 = ?.
           
    CREATE BUTTON wh-button
        ASSIGN FRAME        = p-wgh-frame
               WIDTH        = 4
               HEIGHT       = 1.25
               ROW          = 1.14
               LABEL        = "PedFis"
               COLUMN       = 65
               SENSITIVE    = YES
               VISIBLE      = YES
               TOOLTIP      = 'Buscar Itens do Pedido de Faturamento'
            TRIGGERS:
               ON CHOOSE PERSISTENT RUN esp/ftp/esftp009.w.
            END TRIGGERS.

    wh-button:LOAD-IMAGE ( 'image/im-carga.bmp' ).

    CREATE BUTTON wh-but-peso
        ASSIGN FRAME        = p-wgh-frame
               WIDTH        = 4
               HEIGHT       = 1.25
               ROW          = 1.14
               LABEL        = "Peso"
               COLUMN       = 69.5
               SENSITIVE    = YES
               VISIBLE      = YES
               TOOLTIP      = 'Peso bruto da nota fiscal, apenas para item d‚bito direto.'
            TRIGGERS:
               ON CHOOSE PERSISTENT RUN upc/ft4003-upcb.w.
            END TRIGGERS.

    wh-but-peso:LOAD-IMAGE ( 'image/im-equv.bmp' ).

    CREATE BUTTON wh-bt-mail
        ASSIGN FRAME        = p-wgh-frame
               WIDTH        = 4
               HEIGHT       = 1.25
               ROW          = 1.14
               LABEL        = "Peso"
               COLUMN       = 43.5
               SENSITIVE    = YES
               VISIBLE      = YES
               TOOLTIP      = 'Envia E-mail Solicitante.'
            TRIGGERS:
               ON CHOOSE PERSISTENT RUN pi-envia-mail IN h-ft4003-upc.
            END TRIGGERS.

    wh-bt-mail:LOAD-IMAGE ( 'image/im-send.bmp' ).

    /*
    /* Altera label */
    if (PROGRAM-NAME(1) MATCHES "*esftp009*" OR
        PROGRAM-NAME(2) MATCHES "*esftp009*" OR
        PROGRAM-NAME(3) MATCHES "*esftp009*" OR
        PROGRAM-NAME(4) MATCHES "*esftp009*" OR
        PROGRAM-NAME(5) MATCHES "*esftp009*" OR
        PROGRAM-NAME(6) MATCHES "*esftp009*" OR
        PROGRAM-NAME(7) MATCHES "*esftp009*" OR
        PROGRAM-NAME(1) MATCHES "*esftp060*" OR
        PROGRAM-NAME(2) MATCHES "*esftp060*" OR
        PROGRAM-NAME(3) MATCHES "*esftp060*" OR
        PROGRAM-NAME(4) MATCHES "*esftp060*" OR
        PROGRAM-NAME(5) MATCHES "*esftp060*" OR
        PROGRAM-NAME(6) MATCHES "*esftp060*" OR
        PROGRAM-NAME(7) MATCHES "*esftp060*") THEN DO:
     */
        CREATE TEXT tx-finalidade
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(40)"
               WIDTH        = 20
               SCREEN-VALUE = ""
               ROW          = 6.45
               COL          = 66.2
               VISIBLE      = YES.   
    /*
    END.
    */
    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(h-object):
        IF  h-object:TYPE <> "field-group" THEN DO:

            IF h-object:NAME = 'BtSimula' THEN ASSIGN h-BtSimula = h-object.
            IF h-object:NAME = 'btCalcula'    THEN ASSIGN h-btCalcula = h-object.
            IF h-object:NAME = 'seq-wt-docto' THEN ASSIGN wh-seq-wt-docto-ft4003 = h-object.

            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    CREATE BUTTON wh-new-btCalcula-ft4003
    ASSIGN FRAME       = h-btCalcula:FRAME
           WIDTH       = h-btCalcula:WIDTH
           HEIGHT      = h-btCalcula:HEIGHT
           LABEL       = h-btCalcula:LABEL
           ROW         = h-btCalcula:ROW
           COL         = h-btCalcula:COL 
           TOOLTIP     = h-btCalcula:TOOLTIP
           FLAT-BUTTON = h-btCalcula:FLAT-BUTTON
           VISIBLE     = h-btCalcula:VISIBLE
           SENSITIVE   = h-btCalcula:SENSITIVE.
    ON "CHOOSE" OF wh-new-btCalcula-ft4003 PERSISTENT RUN pi-btCalcula IN h-ft4003-upc.

    wh-new-btCalcula-ft4003:LOAD-IMAGE-UP (h-btCalcula:IMAGE-UP).

    ASSIGN h-btCalcula:SENSITIVE = NO.
    wh-new-btCalcula-ft4003:MOVE-TO-TOP().

    CREATE BUTTON wh-new-btSimula-ft4003
    ASSIGN FRAME       = h-btSimula:FRAME
           WIDTH       = h-btSimula:WIDTH
           HEIGHT      = h-btSimula:HEIGHT
           LABEL       = h-btSimula:LABEL
           ROW         = h-btSimula:ROW
           COL         = h-btSimula:COL 
           TOOLTIP     = h-btSimula:TOOLTIP
           FLAT-BUTTON = h-btSimula:FLAT-BUTTON
           VISIBLE     = h-btSimula:VISIBLE
           SENSITIVE   = h-btSimula:SENSITIVE.
    ON "CHOOSE" OF wh-new-btSimula-ft4003 PERSISTENT RUN pi-btSimula IN h-ft4003-upc.

    wh-new-btSimula-ft4003:LOAD-IMAGE-UP (h-btSimula:IMAGE-UP).

    ASSIGN h-btSimula:SENSITIVE = NO.
    wh-new-btSimula-ft4003:MOVE-TO-TOP().
    
   
    IF  VALID-HANDLE(wh-button) AND I-NumPedidoEsftp060 <> 0 THEN DO:

        IF  CAN-FIND (FIRST ped-fiscal 
                                WHERE ped-fiscal.nr-pedido = I-NumPedidoEsftp060 
                                  AND ped-fiscal.situacao  = 2) THEN /* A relacionar */
            APPLY "choose" TO wh-button.

        tx-finalidade:SCREEN-VALUE = g-finalidade-esftp009.

    END.
    ELSE DO:
        tx-finalidade:SCREEN-VALUE = "".
        g-finalidade-esftp009 = "".
    END.
    
END.

IF p-ind-event = "AFTER-DISPLAY" THEN DO:
    ASSIGN  h-row-ft4003 = p-row-table.
END.

IF  VALID-HANDLE(tx-finalidade)  THEN DO:
    FIND wt-docto NO-LOCK
        WHERE ROWID(wt-docto) = p-row-table NO-ERROR.

    IF  AVAIL wt-docto THEN DO:
        FIND int-wt-docto NO-LOCK
            WHERE int-wt-docto.seq-wt-docto = wt-docto.seq-wt-docto NO-ERROR.

        IF  AVAIL int-wt-docto AND int-wt-docto.finalidade <> "" THEN 
            tx-finalidade:SCREEN-VALUE = int-wt-docto.finalidade.  
        ELSE 
            tx-finalidade:SCREEN-VALUE = "".
    END.
END.



IF  p-ind-event = "AFTER-CONTROL-TOOL-BAR" THEN DO:
    IF  VALID-HANDLE(h-btCalcula) AND VALID-HANDLE(wh-button) THEN ASSIGN wh-button:SENSITIVE = h-btCalcula:SENSITIVE.
END.

IF  p-ind-event = "AFTER-DESTROY-INTERFACE" THEN DO:
    IF  VALID-HANDLE(wh-seq-wt-docto-ft4003) THEN ASSIGN wh-seq-wt-docto-ft4003 = ?.
    ASSIGN v-row-wt-docto-ft4003 = ?.

    DELETE PROCEDURE h-ft4003-upc.
    g-finalidade-esftp009 = "".
END.

PROCEDURE pi-btCalcula:
    FIND wt-docto NO-LOCK
        WHERE ROWID(wt-docto) = h-row-ft4003 NO-ERROR.

    ASSIGN l-calcula = YES
           c-volume-ft4003 = "".

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "ft4003":U,
                       INPUT 2,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FOR EACH wt-it-docto OF wt-docto NO-LOCK:
        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = wt-it-docto.nat-operacao NO-ERROR.
        
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = wt-it-docto.it-codigo NO-ERROR.
    
        IF  AVAIL natur-oper 
        AND natur-oper.baixa-estoq = NO 
        AND AVAIL ITEM 
        AND ITEM.baixa-estoq = YES THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW", 
                               INPUT 27100, 
                               INPUT "Item " + ITEM.it-codigo + " possui controle de estoque e a natureza informada nÆo baixa estoque. Confirma a inclusÆo desse item na nota?").
    
            IF RETURN-VALUE = "YES" THEN
                ASSIGN l-calcula = YES.
            ELSE DO:
                ASSIGN l-calcula = NO.
                LEAVE.
            END.
        END.
        FIND FIRST tt-prog-ponto NO-LOCK
             WHERE tt-prog-ponto.conteudo = string(ITEM.ge-codigo) NO-ERROR.
        IF AVAIL tt-prog-ponto THEN
           ASSIGN l-mantem-volume = YES.
    END.

    IF NOT l-mantem-volume THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW", 
                           INPUT 15825, 
                           INPUT "O volume desta sequencia seraÿcalculado automaticamente").
        ASSIGN c-volume-ft4003 = "0".
    END.
    ELSE
        ASSIGN c-volume-ft4003 = wt-docto.nr-volume. 

    IF l-calcula THEN
        APPLY "CHOOSE" TO h-btCalcula.
    
END PROCEDURE.

PROCEDURE pi-btSimula:
    FIND wt-docto NO-LOCK
        WHERE ROWID(wt-docto) = h-row-ft4003 NO-ERROR.

    ASSIGN l-simula-ft4003 = YES. 

    APPLY "CHOOSE" TO h-btSimula.
    
END PROCEDURE.

PROCEDURE pi-envia-mail:
    DEF VAR h-utapi019 AS HANDLE NO-UNDO.
    DEF VAR c-mensagem AS CHAR   NO-UNDO.
    DEFINE VARIABLE c-mail-destino AS CHARACTER   NO-UNDO.

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 27100,
                       INPUT "Confirma o envio do e-mail ao solicitante?").

    IF RETURN-VALUE = "yes" THEN DO:

        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "ft4003":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FIND FIRST tt-prog-ponto NO-ERROR.
      
        EMPTY TEMP-TABLE tt-envio2.
        EMPTY TEMP-TABLE tt-mensagem.
        EMPTY TEMP-TABLE tt-erros.

        FIND FIRST wt-docto NO-LOCK
             WHERE ROWID(wt-docto) = v-row-wt-docto-ft4003 NO-ERROR.
    
        FIND FIRST ped-fiscal NO-LOCK 
             WHERE ped-fiscal.seq-wt-docto = wt-docto.seq-wt-docto NO-ERROR.
       
        IF NOT AVAIL ped-fiscal THEN DO:
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 17006,
                              INPUT "NÆo encontrado pedido de faturamento para este documento.").
            RETURN "OK".
        END.
            

        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = ped-fiscal.usuario-magnus NO-ERROR.
            
        FIND FIRST param-global NO-LOCK NO-ERROR.

        ASSIGN c-mail-destino = usuar_mestre.cod_e_mail_local.

        FOR EACH tt-prog-ponto
           WHERE ENTRY(1,tt-prog-ponto.conteudo) = wt-docto.cod-estabel:
            ASSIGN c-mail-destino = c-mail-destino + "," + ENTRY(2,tt-prog-ponto.conteudo).
        END.
    
        ASSIGN c-mensagem = "Pedido: " + STRING(wt-docto.num-romaneio) + "<BR>" +
                            "Sequencia: " + STRING(ped-fiscal.seq-wt-docto) + "<BR>" +
                            "Solicitante: " + STRING(ped-fiscal.usuario-magnus) + "<BR><BR><BR>".
              
        ASSIGN c-mensagem = c-mensagem + "<html>Prezado solicitante, " + "<BR>" + "<BR>" +
                            "NÆo havendo o comparecimento do solicitante no setor de expedi‡Æo em at‚ 10 dias, o pedido ser  reprovado. " + "<BR>" + 
                            "Verifique no setor de expedi‡Æo a NF emitida, pois caso a mesma tenha sido rejeitada devido a parƒmetros tribut rios ou do cadastro do cliente, ser  necess rio entrar em contato com o Fiscal (conforme estabelecimento da NF).".
    
        RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    
        IF  AVAIL usuar_mestre THEN DO:
            
            create tt-envio2.
            assign tt-envio2.versao-integracao = 1
                   tt-envio2.servidor          = param-global.serv-mail
                   tt-envio2.porta             = param-global.porta-mail
                   tt-envio2.remetente         = "EMS@intelbras.com.br"
                   tt-envio2.destino           = usuar_mestre.cod_e_mail_local
                   tt-envio2.assunto           = "Informa‡äes para faturamento do pedido: " + STRING(wt-docto.nr-pedcli)
                   tt-envio2.formato           = "HTML"
                   tt-envio2.exchange          = NO.
      
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 1
                   tt-mensagem.mensagem = c-mensagem.
    
            RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2,
                                           INPUT TABLE tt-mensagem,
                                           OUTPUT TABLE tt-erros).
        END.
        
        DELETE PROCEDURE h-utapi019.
    
    END.
END PROCEDURE.
