{utp/ut-glob.i}
{upc/btb910za-upc.i}

/* Definio da temp-table "tt-prog-ponto" */
{esp/es0018.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.
DEFINE VARIABLE l-habilita         AS LOGICAL       NO-UNDO.
DEFINE VARIABLE l-trans            AS LOGICAL       NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-c-cod-estabel     AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-c-cod-depos       AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-quantidade        AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-lote-cq0210e-orig AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-lote-cq0210e-dest AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-ok-cq0210e     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-ok-aux-cq0210e AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-qtd-cq0210e       AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE wh-frame                             AS WIDGET-HANDLE NO-UNDO. 
DEFINE NEW GLOBAL SHARED VAR wh-nr-ficha             AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-dt-vali-lote-cq0210e AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-dt-fabric-cq0210e       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-dt-fabric-cq0210e       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-it-codigo-cq0210e    AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-quantidade-cq0210e   AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-upc-cq0210e      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cq0210e         AS HANDLE        NO-UNDO.
DEFINE new global shared VARIABLE wgh-objeto         AS WIDGET-HANDLE NO-UNDO.
DEF BUFFER b-item FOR ITEM.
DEF BUFFER b-ficha-cq FOR ficha-cq.
DEF BUFFER bf-ficha-cq FOR ficha-cq.
DEF BUFFER b-movto-estoq FOR movto-estoq.
def new global shared var gr-ficha-cq as rowid no-undo.
def new global shared var ficha-cq-cq0210-row as rowid no-undo.

DEFINE TEMP-TABLE ttWm-box-picking NO-UNDO
    FIELD cod-estabel   AS CHARACTER
    FIELD cod-local     AS CHARACTER
    FIELD id-box-comp   AS DECIMAL
    FIELD cod-picking   AS CHARACTER 
    FIELD cod-refer     AS CHARACTER.

DEFINE VARIABLE  h-bosc130 AS HANDLE      NO-UNDO.

DEF VAR r-nr-ficha AS ROWID     NO-UNDO.
DEF VAR l-transf   AS LOGICAL   NO-UNDO.

FUNCTION getWidgetHandle RETURNS WIDGET-HANDLE (INPUT pWidget AS CHAR) FORWARD.

{utp/utapi019.i}

/*
MESSAGE 
    "p-ind-event:  " p-ind-event  SKIP
    "p-ind-object: " p-ind-object SKIP
    "p-wgh-object: " p-wgh-object SKIP
    "p-wgh-frame : " p-wgh-frame  SKIP
    "p-cod-table:  " p-cod-table  SKIP
    "p-row-table:  " string(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
  */   

IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/cq0210e-upc.p PERSISTENT SET h-upc-cq0210e(INPUT "",            
                                                       INPUT "",            
                                                       INPUT p-wgh-object,  
                                                       INPUT p-wgh-frame,   
                                                       INPUT "",            
                                                       INPUT p-row-table).                                                                                  

    ASSIGN wh-cq0210e = p-wgh-object.
    
END.

IF VALID-HANDLE(p-wgh-frame) THEN DO:
    ON 'return':U OF p-wgh-frame ANYWHERE DO:
        IF VALID-HANDLE(wh-bt-ok-aux-cq0210e) THEN 
            APPLY 'choose':U TO wh-bt-ok-aux-cq0210e.
    END.
END.

IF p-ind-event  = "INITIALIZE"  AND
   p-ind-object = "CONTAINER"   THEN DO:

    IF NOT VALID-HANDLE(wh-bt-ok-cq0210e) THEN 
        ASSIGN wh-bt-ok-cq0210e = getWidgetHandle("bt-ok").

END.

IF  p-ind-event  = "INITIALIZE" THEN DO:   
    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD. 

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = 'c-cod-depos' THEN DO:
                ASSIGN wh-c-cod-depos = h-object.
            END.
            
            IF h-object:NAME = 'c-cod-estabel' THEN DO:
                ASSIGN wh-c-cod-estabel = h-object.
            END.

            IF  h-object:NAME = 'quantidade' THEN DO:
                ASSIGN wh-quantidade = h-object.
                ASSIGN wh-qtd-cq0210e = h-object:HANDLE.
            END.
            
            IF  h-object:NAME = 'lote' THEN DO:
                ASSIGN wh-lote-cq0210e-orig = h-object.
            END.

            IF  h-object:NAME = 'c-lote' THEN DO:
                ASSIGN wh-lote-cq0210e-dest = h-object.
            END.

            IF  h-object:NAME = 'dt-vali' THEN DO:
                ASSIGN wh-dt-vali-lote-cq0210e = h-object.
            END.

            IF  h-object:NAME = 'it-codigo' THEN DO:
                ASSIGN wh-it-codigo-cq0210e = h-object.
            END.

            IF  h-object:NAME = 'quantidade' THEN DO:
                ASSIGN wh-quantidade-cq0210e = h-object.
            END.

            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.     
    
    FIND FIRST b-item NO-LOCK
         WHERE b-item.it-codigo = wh-it-codigo-cq0210e:SCREEN-VALUE NO-ERROR.
    IF AVAIL b-item THEN DO:
          IF b-item.tipo-con-est = 3 THEN DO: /* Item Controlado por Lote */
             FIND FIRST in-grup-estoq NO-LOCK
                  WHERE in-grup-estoq.ge-codigo = b-item.ge-codigo NO-ERROR.
             IF NOT AVAIL in-grup-estoq OR 
                in-grup-estoq.log-ckd = NO THEN DO:
                IF NOT VALID-HANDLE(tx-dt-fabric-cq0210e) THEN DO:
                   CREATE TEXT tx-dt-fabric-cq0210e
                   ASSIGN FRAME        = p-wgh-frame
                          FORMAT       = "x(14)"
                          WIDTH        = 10.43
                          SCREEN-VALUE = "Dt Fabricao:"
                          ROW          = 9.10
                          COL          = 49.20 
                          VISIBLE      = YES.
                   
                   CREATE FILL-IN wh-dt-fabric-cq0210e
                   ASSIGN FRAME             = p-wgh-frame
                          DATA-TYPE         = "date"
                          FORMAT            = "99/99/9999"
                          WIDTH             = 12
                          HEIGHT            = 0.88
                          ROW               = 9
                          COL               = 59.5
                          VISIBLE           = YES
                          SENSITIVE         = YES.
                   
                   wh-dt-fabric-cq0210e:MOVE-AFTER-TAB-ITEM(wh-qtd-cq0210e) NO-ERROR.   
                   
                   ON "LEAVE":U OF wh-dt-fabric-cq0210e PERSISTENT RUN pi-monta-lote-validade IN h-upc-cq0210e.                           
                               
                   
                END.
             END.
          END.
    END.     

    IF  VALID-HANDLE(wh-bt-ok-cq0210e)         
       AND NOT VALID-HANDLE(wh-bt-ok-aux-cq0210e) THEN DO:
    
           CREATE BUTTON wh-bt-ok-aux-cq0210e
           ASSIGN DEFAULT      = YES
                  NAME         = "btOK-aux"
                  FRAME        = wh-bt-ok-cq0210e:FRAME
                  WIDTH        = wh-bt-ok-cq0210e:WIDTH
                  HEIGHT       = wh-bt-ok-cq0210e:HEIGHT
                  LABEL        = wh-bt-ok-cq0210e:LABEL
                  ROW          = wh-bt-ok-cq0210e:ROW
                  COL          = wh-bt-ok-cq0210e:COL
                  FONT         = wh-bt-ok-cq0210e:FONT
                  HELP         = wh-bt-ok-cq0210e:HELP
                  VISIBLE      = YES
                  SENSITIVE    = YES
                  TRIGGERS:
                      ON CHOOSE 
                          PERSISTENT RUN pi-choose-btOK IN h-upc-cq0210e.
                  END TRIGGERS.
                   
           wh-bt-ok-aux-cq0210e:MOVE-BEFORE-TAB-ITEM(wh-bt-ok-cq0210e:NEXT-TAB-ITEM).
           ASSIGN wh-bt-ok-cq0210e:TAB-STOP = NO.
        
    END.
       
    ASSIGN l-transf = NO.
    FIND FIRST ficha-cq WHERE 
        ROWID(ficha-cq) = gr-ficha-cq NO-LOCK NO-ERROR.
    IF AVAIL ficha-cq THEN DO:
        FIND FIRST docum-est OF ficha-cq NO-LOCK NO-ERROR.
        IF AVAIL docum-est AND docum-est.esp-docto = 23 /* NFT */ THEN
            ASSIGN l-transf = YES.
    END.

    IF l-transf = NO THEN DO:
        IF CAN-FIND(FIRST deposito WHERE 
                    deposito.cod-depos    = wh-c-cod-depos:SCREEN-VALUE AND 
                    deposito.log-gera-wms = YES                         NO-LOCK) THEN DO:
            ASSIGN l-habilita = YES.
            FOR EACH wm-local WHERE
                wm-local.cod-estabel = wh-c-cod-estabel:SCREEN-VALUE AND
                wm-local.cod-depos   = wh-c-cod-depos:SCREEN-VALUE   NO-LOCK:
                IF CAN-FIND(FIRST wm-local-deposito WHERE
                            wm-local-deposito.cod-estabel = wm-local.cod-estabel AND 
                            wm-local-deposito.cod-local   = wm-local.cod-local   NO-LOCK) THEN DO:
                    ASSIGN l-habilita = NO.
                    LEAVE.
                END.
            END.
            
            /* Se encontrar item na tabela de skype lote, no deve validar */
           FIND FIRST item-uni-estab NO-LOCK
                WHERE item-uni-estab.it-codigo   = wh-it-codigo-cq0210e:SCREEN-VALUE   
                  AND item-uni-estab.cod-estabel = wh-c-cod-estabel:SCREEN-VALUE NO-ERROR.
           IF AVAIL item-uni-estab THEN DO:
               FIND FIRST wm-local NO-LOCK
                    WHERE wm-local.cod-estabel = item-uni-estab.cod-estabel
                      AND wm-local.cod-depos   = item-uni-estab.deposito-pad NO-ERROR.
               IF AVAIL wm-local THEN DO:
                   FIND FIRST wm-local-deposito 
                        WHERE wm-local-deposito.cod-estabel = wm-local.cod-estab
                          AND wm-local-deposito.cod-local   = wm-local.cod-local
                          AND wm-local-deposito.cod-depos   = 'REC'   NO-LOCK NO-ERROR.
                   IF AVAIL wm-local-deposito THEN DO:
                       FIND FIRST int-item-fornec-skip-lote NO-LOCK
                            WHERE int-item-fornec-skip-lote.it-codigo    = item-uni-estab.it-codigo
                              AND int-item-fornec-skip-lote.cod-emitente = 0 NO-ERROR.
                       IF NOT AVAIL int-item-fornec-skip-lote THEN 
                           ASSIGN l-habilita = YES.
                       ELSE DO:
                           FIND FIRST wm-item NO-LOCK
                                WHERE wm-item.cod-item = item-uni-estab.it-codigo NO-ERROR.
                           IF AVAIL wm-item AND wm-item.log-1 = YES THEN DO:
                               FIND FIRST wms-item-estab-local NO-LOCK
                                    WHERE wms-item-estab-local.cod-estab = wm-local-deposito.cod-estabel
                                      AND wms-item-estab-local.cod-local = wm-local-deposito.cod-local
                                      AND wms-item-estab-local.cod-item  = item-uni-estab.it-codigo NO-ERROR.
                               IF AVAIL wms-item-estab-local AND wms-item-estab-local.log-armaz-estado-cq = YES THEN 
                                   ASSIGN l-habilita = NO.
                           END.
                       END.
                   END.
               END.
           END.
    
            ASSIGN wh-c-cod-depos:SENSITIVE = l-habilita.
        END.
    END.

END.

IF p-ind-event = "AFTER-ENABLE" 
THEN DO:
    FIND ficha-cq NO-LOCK
        WHERE rowid(ficha-cq) = ficha-cq-cq0210-row NO-ERROR.

    IF AVAIL ficha-cq 
    THEN ASSIGN wh-quantidade-cq0210e:SCREEN-VALUE = string(ficha-cq.qt-original  - 
                                                            ficha-cq.qt-aprovada  - 
                                                            ficha-cq.qt-consumida - 
                                                            ficha-cq.qt-rejeitada - 
                                                            ficha-cq.qt-apr-cond).
END.

IF  p-ind-event = "confirmacao-cq" THEN DO:    
    
    FIND ficha-cq NO-LOCK
        WHERE rowid(ficha-cq) = p-row-table NO-ERROR.

    IF  NOT AVAIL ficha-cq THEN
        RETURN "Ok".        

    FIND ITEM NO-LOCK
        WHERE ITEM.it-codigo = ficha-cq.it-codigo NO-ERROR.
        
    RUN esp/es0018p.p (INPUT "cq0210e",
                       INPUT 1,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FOR EACH tt-prog-ponto:

        IF  NUM-ENTRIES(tt-prog-ponto.conteudo) <> 3 THEN DO:
            RUN utp/ut-msgs ("Show",
                             17006,
                             "ES0018 para o programa cq0210E est com nmero de parmetros incorretos. Verifique cadastro.").
            RETURN "OK".
        END.

        IF  ENTRY(1,tt-prog-ponto.conteudo) = ficha-cq.cod-estabel 
        AND ENTRY(2,tt-prog-ponto.conteudo) = wh-c-cod-depos:SCREEN-VALUE  THEN
            RUN pi-monta-mail-liberado (INPUT ENTRY(1,tt-prog-ponto.conteudo),
                                        INPUT ENTRY(2,tt-prog-ponto.conteudo),
                                        INPUT ENTRY(3,tt-prog-ponto.conteudo)).
    END.

    FIND FIRST int-item-fornec
         WHERE int-item-fornec.cod-emitente = ficha-cq.cod-emitente
           AND int-item-fornec.it-codigo    = ficha-cq.it-codigo
    NO-LOCK NO-ERROR.

    IF AVAIL int-item-fornec THEN
    DO:
        IF int-item-fornec.obs-rec <> '' THEN
        DO: 
            run utp/ut-msgs.p (input "show":U,
                               input 27100,                                            
                               input 'Deseja realmente liberar o Roteiro ?~~' + 'Item ' + upper(int-item-fornec.it-codigo) + ' possui observacao' +  CHR(13) + CHR(13) + 
                                     'Conteudo: ' + upper(int-item-fornec.obs-rec)  ).

            IF RETURN-VALUE = 'no' THEN
               RETURN ERROR. 
        END.
    END.

    /*FT0305*/
    IF NOT CAN-FIND (FIRST item-caixa
                     WHERE item-caixa.it-codigo = ficha-cq.it-codigo) THEN DO:

        RUN esp/es0018p.p (INPUT "cq0210e",
                           INPUT 2,
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        FIND FIRST tt-prog-ponto NO-ERROR.

        IF AVAIL tt-prog-ponto THEN DO:
            RUN pi-envia-email (INPUT tt-prog-ponto.conteudo,
                                INPUT "Item sem cadastro no FT0305",
                                INPUT "Favor cadastrar embalagem para o item " + ficha-cq.it-codigo).
        END.
    END.

    /*WM0108*/
    FIND FIRST wm-item NO-LOCK
         WHERE wm-item.cod-item = ficha-cq.it-codigo NO-ERROR.

    IF NOT AVAIL wm-item THEN DO:
        RUN esp/es0018p.p (INPUT "cq0210e",
                           INPUT 3,
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        FIND FIRST tt-prog-ponto NO-ERROR.

        IF AVAIL tt-prog-ponto THEN DO:
            RUN pi-envia-email (INPUT tt-prog-ponto.conteudo,
                                INPUT "Item sem cadastro no WM0108",
                                INPUT "Favor cadastrar peso e medida para o item " + ficha-cq.it-codigo).
        END.
        
    END.

    /*WM0212*/
    RUN scbo/bosc130.p PERSISTENT SET h-bosc130.
    RUN openQueryStatic IN h-bosc130 (INPUT "Main":U) NO-ERROR.
    RUN retornaAreaPickingItem IN h-bosc130 (INPUT  ficha-cq.it-codigo,
                                             INPUT  "",
                                             INPUT  "ZZZZZ",
                                             INPUT  "",
                                             INPUT  "ZZZ",
                                             INPUT  "",
                                             INPUT  "ZZZZZZZZ",
                                             OUTPUT TABLE ttWm-box-picking).     
    
    IF NOT CAN-FIND (FIRST ttWm-box-picking) THEN DO:
        RUN esp/es0018p.p (INPUT "cq0210e",
                           INPUT 4,
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        FIND FIRST tt-prog-ponto NO-ERROR.

        IF AVAIL tt-prog-ponto THEN DO:
            RUN pi-envia-email (INPUT tt-prog-ponto.conteudo,
                                INPUT "Item sem cadastro no WM0212",
                                INPUT "avor cadastrar picking para o item " + ficha-cq.it-codigo).
        END.
    END.

    /*WM0291*/
    IF NOT CAN-FIND (FIRST wm-box-preferencia
                     WHERE wm-box-preferencia.cod-item = ficha-cq.it-codigo) THEN DO:

        RUN esp/es0018p.p (INPUT "cq0210e",
                           INPUT 5,
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        FIND FIRST tt-prog-ponto NO-ERROR.

        IF AVAIL tt-prog-ponto THEN DO:
            RUN pi-envia-email (INPUT tt-prog-ponto.conteudo,
                                INPUT "Item sem cadastro no WM0291",
                                INPUT "Favor cadastrar picking para o item " + ficha-cq.it-codigo).
        END.
    END.

    /*ESCPP072*/
    IF NOT CAN-FIND (FIRST item-rast
                     WHERE item-rast.it-codigo = ficha-cq.it-codigo) THEN DO:

        RUN esp/es0018p.p (INPUT "cq0210e",
                           INPUT 6,
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        FIND FIRST tt-prog-ponto NO-ERROR.

        IF AVAIL tt-prog-ponto THEN DO:
            RUN pi-envia-email (INPUT tt-prog-ponto.conteudo,
                                INPUT "Item sem cadastro no ESCPP072",
                                INPUT " Favor habilitar item " + ficha-cq.it-codigo + " na rastreabilidade").
        END.
    END.
    
IF VALID-HANDLE(h-bosc130) THEN DO:
    RUN destroy IN h-bosc130.
    DELETE OBJECT h-bosc130 NO-ERROR.
END.
  



END.

PROCEDURE pi-monta-mail-liberado:

    DEF INPUT PARAM p-estab        AS CHAR NO-UNDO.
    DEF INPUT PARAM p-deposito     AS CHAR NO-UNDO.
    DEF INPUT PARAM p-destinatario AS CHAR NO-UNDO.

    DEF VAR icont         AS INT. 
    DEF VAR c-corpo-email AS CHAR FORMAT "x(2000)" NO-UNDO.

    ASSIGN c-corpo-email = "Roteiro: "     + string(ficha-cq.nr-ficha)                  + CHR(10) + 
                           "Item: "        + ficha-cq.it-codigo + "-" + ITEM.desc-item  + CHR(10) + 
                           "Data: "        + STRING(TODAY, "99/99/9999")                + CHR(10) + 
                           "Estab: "       + ficha-cq.cod-estabel                       + CHR(10) + 
                           "Depos: "       + wh-c-cod-depos:SCREEN-VALUE                + CHR(10) + 
                           "Quantidade: "  + wh-quantidade:SCREEN-VALUE                 + CHR(10).

    RUN pi-envia-email (INPUT p-destinatario,
                        INPUT "Roteiro Liberado",
                        INPUT c-corpo-email).

END.

PROCEDURE pi-envia-email:
    DEF INPUT PARAM p-destinatario AS CHAR NO-UNDO.
    DEF INPUT PARAM p-assunto      AS CHAR NO-UNDO.
    DEF INPUT PARAM p-corpo        AS CHAR NO-UNDO.

    DEF VAR icont         AS INT. 
    DEF VAR c-corpo-email AS CHAR FORMAT "x(2000)" NO-UNDO.

    FOR FIRST param-global NO-LOCK: END.    

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = p-destinatario           /* Destinatrio       */ 
           tt-envio2.remetente         = "ems@intelbras.com.br"   /* Remetente          */ 
           tt-envio2.assunto           = p-assunto                /* Assunto            */
           tt-envio2.formato           = "TEXTO".

    ASSIGN c-corpo-email = p-corpo.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = c-corpo-email.          /* Mensagem           */


    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros 
    THEN run cdp/cd0666.w (input table tt-erros).
END.

PROCEDURE pi-monta-lote-validade:
    DEFINE VARIABLE i-dias-val AS INTEGER                   NO-UNDO.
    DEFINE VARIABLE d-data     AS DATE    FORM "99/99/9999" NO-UNDO.
    FIND FIRST b-item NO-LOCK
         WHERE b-item.it-codigo = wh-it-codigo-cq0210e:SCREEN-VALUE NO-ERROR.
    IF AVAIL b-item THEN DO:        
    
       if string(r-nr-ficha) = ? then do:
       
        FIND FIRST bf-ficha-cq NO-LOCK
             WHERE rowid(bf-ficha-cq) = gr-ficha-cq NO-ERROR.
             
             if avail bf-ficha-cq then assign r-nr-ficha = rowid(bf-ficha-cq).        
       end.
    
       FIND FIRST b-ficha-cq NO-LOCK
            WHERE rowid(b-ficha-cq) = r-nr-ficha NO-ERROR.
       IF b-item.tipo-con-est = 3 THEN DO: /* Item Controlado por Lote */
          FOR first familia no-lock 
              WHERE familia.fm-codigo = b-item.fm-codigo:
              assign i-dias-val = 1.
              FOR FIRST int-familia of familia NO-LOCK:
                  assign i-dias-val = int-familia.meses-validade * 30.
              END.
          END.

          ASSIGN d-data = DATE(wh-dt-fabric-cq0210e:SCREEN-VALUE).

          assign wh-dt-vali-lote-cq0210e:SCREEN-VALUE = string("01/" + string(month(date(d-data + i-dias-val)),"99") + "/" + string(YEAR(date(d-data + i-dias-val)),"9999"))                                  
                 wh-lote-cq0210e-dest:SCREEN-VALUE    = string(b-ficha-cq.cod-emitente) + "-" + substr(STRING(d-data,"99/99/9999"),7,4) + substr(STRING(d-data,"99/99/9999"),4,2)
                 wh-dt-vali-lote-cq0210e:READ-ONLY    = NO
                 wh-dt-vali-lote-cq0210e:SENSITIVE    = NO
                 wh-lote-cq0210e-dest:READ-ONLY       = NO
                 wh-lote-cq0210e-dest:SENSITIVE       = NO.
                                                       
       END.
    END.

END PROCEDURE.

PROCEDURE pi-choose-btOK:

   IF VALID-HANDLE (wh-dt-fabric-cq0210e) THEN DO:
       if date(wh-dt-fabric-cq0210e:SCREEN-VALUE) = ? THEN DO:
    
            RUN utp/ut-msgs (INPUT "Show",
                             INPUT 17006,
                             INPUT "Data de fabricao deve ser informada!").  
                             
            APPLY 'entry':U TO wh-dt-fabric-cq0210e.                        
                             
            RETURN "NOK":U.        
                
        END.
    
        if date(wh-dt-fabric-cq0210e:SCREEN-VALUE) > TODAY THEN DO:
    
            RUN utp/ut-msgs (INPUT "Show",
                             INPUT 17006,
                             INPUT "Data de fabricao no pode ser maior do que a data atual!").  
                             
            APPLY 'entry':U TO wh-dt-fabric-cq0210e.                        
                             
            RETURN "NOK":U.        
                
        END.
    
        if date(wh-dt-vali-lote-cq0210e:SCREEN-VALUE) < TODAY THEN DO:
    
            RUN utp/ut-msgs (INPUT "Show",
                             INPUT 17006,
                             INPUT "Data de Validade no pode ser menor do que a data atual!").  
                             
            APPLY 'entry':U TO wh-dt-fabric-cq0210e.                        
                             
            RETURN "NOK":U.        
                
        END.
   END.

   IF SUBSTRING(wh-it-codigo-cq0210e:SCREEN-VALUE,1,1) = "4" THEN DO:
       FIND FIRST item-caixa NO-LOCK
            WHERE item-caixa.it-codigo = wh-it-codigo-cq0210e:SCREEN-VALUE NO-ERROR.

       IF NOT AVAIL item-caixa THEN DO:
           RUN utp/ut-msgs.p(INPUT "show",
                             INPUT 17006,
                             INPUT "Item sem cadastro no programa FT0305!").

           RETURN "NOK":U.        
       END.

       FIND FIRST wm-item NO-LOCK
            WHERE wm-item.cod-item = wh-it-codigo-cq0210e:SCREEN-VALUE NO-ERROR.

       IF NOT AVAIL wm-item 
       OR wm-item.qtd-peso        = 0  
       OR wm-item.qtd-comprimento = 0
       OR wm-item.qtd-altura      = 0
       OR wm-item.qtd-largura     = 0 THEN DO:
           RUN utp/ut-msgs.p(INPUT "show",
                             INPUT 17006,
                             INPUT "Item sem cadastro de medidas no programa WM0108!").

           RETURN "NOK":U.        
       END.
   END.

   IF CAN-FIND(FIRST deposito WHERE 
                deposito.cod-depos    = wh-c-cod-depos:SCREEN-VALUE AND 
                deposito.log-gera-wms = YES                         NO-LOCK) THEN DO:
       ASSIGN l-habilita = YES.
       FOR EACH wm-local WHERE
            wm-local.cod-estabel = wh-c-cod-estabel:SCREEN-VALUE AND
            wm-local.cod-depos = wh-c-cod-depos:SCREEN-VALUE NO-LOCK:
            IF CAN-FIND(FIRST wm-local-deposito WHERE
                        wm-local-deposito.cod-estabel = wm-local.cod-estabel AND 
                        wm-local-deposito.cod-local   = wm-local.cod-local   NO-LOCK) THEN DO:
                ASSIGN l-habilita = NO.
                LEAVE.
            END.
       END.
       
       /* Se encontrar item na tabela de skype lote, no deve validar */
       FIND FIRST item-uni-estab NO-LOCK
            WHERE item-uni-estab.it-codigo   = wh-it-codigo-cq0210e:SCREEN-VALUE   
              AND item-uni-estab.cod-estabel = wh-c-cod-estabel:SCREEN-VALUE NO-ERROR.
       IF AVAIL item-uni-estab THEN DO:
           FIND FIRST wm-local NO-LOCK
                WHERE wm-local.cod-estabel = item-uni-estab.cod-estabel
                  AND wm-local.cod-depos   = item-uni-estab.deposito-pad NO-ERROR.
           IF AVAIL wm-local THEN DO:
               FIND FIRST wm-local-deposito 
                    WHERE wm-local-deposito.cod-estabel = wm-local.cod-estab
                      AND wm-local-deposito.cod-local   = wm-local.cod-local
                      AND wm-local-deposito.cod-depos   = 'REC'   NO-LOCK NO-ERROR.
               IF AVAIL wm-local-deposito THEN DO:
                   FIND FIRST int-item-fornec-skip-lote NO-LOCK
                        WHERE int-item-fornec-skip-lote.it-codigo    = item-uni-estab.it-codigo
                          AND int-item-fornec-skip-lote.cod-emitente = 0 NO-ERROR.
                   IF NOT AVAIL int-item-fornec-skip-lote THEN 
                       ASSIGN l-habilita = YES.
                   ELSE DO:
                       FIND FIRST wm-item NO-LOCK
                            WHERE wm-item.cod-item = item-uni-estab.it-codigo NO-ERROR.
                       IF AVAIL wm-item AND wm-item.log-1 = YES THEN DO:
                           FIND FIRST wms-item-estab-local NO-LOCK
                                WHERE wms-item-estab-local.cod-estab = wm-local-deposito.cod-estabel
                                  AND wms-item-estab-local.cod-local = wm-local-deposito.cod-local
                                  AND wms-item-estab-local.cod-item  = item-uni-estab.it-codigo NO-ERROR.
                           IF AVAIL wms-item-estab-local AND wms-item-estab-local.log-armaz-estado-cq = YES THEN 
                               ASSIGN l-habilita = NO.
                       END.
                   END.
               END.
           END.
       END.

       IF NOT l-habilita AND wh-c-cod-depos:SENSITIVE = NO THEN DO:
           if string(r-nr-ficha) = ? then do:
               FIND FIRST bf-ficha-cq NO-LOCK
                    WHERE rowid(bf-ficha-cq) = gr-ficha-cq NO-ERROR.
               FIND FIRST Wm-roteiro-docto-itens NO-LOCK
                    WHERE Wm-roteiro-docto-itens.nr-ficha = bf-ficha-cq.nr-ficha NO-ERROR.
           END.
           IF AVAIL Wm-roteiro-docto-itens THEN DO:
               RUN utp/ut-msgs.p(INPUT "show",
                                 INPUT 17006,
                                 INPUT "Depsito WMS!~~Liberacaaaaaao permitida somente pelo programa ESCQP014").
               RETURN "NOK":U.        
           END.
       END.

   END.

   FIND FIRST b-item NO-LOCK
        WHERE b-item.it-codigo = wh-it-codigo-cq0210e:SCREEN-VALUE NO-ERROR.
   /* CKD precisa ser lote */
   IF CAN-FIND(first in-grup-estoq 
               where in-grup-estoq.ge-codigo = b-item.ge-codigo
                 AND in-grup-estoq.log-ckd   = YES) THEN DO:
       IF b-item.tipo-con-est <> 3 THEN DO:
          RUN utp/ut-msgs.p(INPUT "show",
                            INPUT 17006,
                            INPUT "Item CKD sem ser lote!~~Liberao de CKD apenas  permitido para itens controlados por lote.").
          RETURN "NOK":U.      
       END.
   END.

   APPLY "CHOOSE" TO wh-bt-ok-cq0210e.

END PROCEDURE.

FUNCTION getWidgetHandle RETURNS WIDGET-HANDLE
    (INPUT pWidget  AS CHAR).
    DEFINE VARIABLE wh-WIDGET-HANDLE    AS WIDGET-HANDLE    NO-UNDO.
    ASSIGN wh-frame = p-wgh-frame:FIRST-CHILD
           wh-frame = wh-frame:FIRST-CHILD.
    DO WHILE wh-frame <> ?:
        IF wh-frame:NAME = pWidget THEN DO:
            ASSIGN wh-WIDGET-HANDLE = wh-frame:HANDLE.
            LEAVE.
        END.
        ASSIGN wh-frame = wh-frame:NEXT-SIBLING.
    END.
    RETURN wh-WIDGET-HANDLE.
END FUNCTION.

