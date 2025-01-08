/***********************************************************************
**  Programa..: upc\re1001-upc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/
/*
{utp/ut-glob.i}
*/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.
DEFINE VARIABLE wgh-grupo          AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE d-total-perc       AS DECIMAL     NO-UNDO.
{esp/es0018.i}
DEFINE NEW GLOBAL SHARED VARIABLE wh-button           AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-serv-re1001   AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btConf           AS HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gr-docum-est        AS ROWID            NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gr-docum-estFat     AS ROWID            NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gr-docum-estAtu     AS ROWID            NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-Page1            AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btItens          AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hBrowseTela-re1001  AS HANDLE           NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-emitente-re1001 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-serie-docto-re1001  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nro-docto-re1001    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nat-operacao-re1001 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-nota-gerada-re1001   AS CHAR INIT "" NO-UNDO.
 
DEFINE NEW GLOBAL SHARED VARIABLE h-serie-re1001         AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-nota-re1001          AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-cfop-re1001          AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-query-re1001        AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-completo-re1001-upc    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-button-depos-re1001    AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-button-ord-prod-re1001 AS WIDGET-HANDLE    NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-upc-re1001           AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-browse-page1 AS WIDGET-HANDLE NO-UNDO.

DEF VAR c-objeto     AS CHAR        NO-UNDO.

DEFINE VARIABLE iCod-mensagem   LIKE mensagem.cod-mensagem      NO-UNDO.
DEFINE VARIABLE cnarrativa      LIKE docum-est.observacao       NO-UNDO.
DEFINE VARIABLE cconta-transit  LIKE docum-est.conta-transit    NO-UNDO.
DEFINE VARIABLE c-arquivoXMLEnv AS CHARACTER FORMAT 'X(150)'    NO-UNDO.
DEFINE VARIABLE i-num-pedido    AS INTEGER                      NO-UNDO.
DEFINE VARIABLE i-num-ordem     AS INTEGER                      NO-UNDO.

DEFINE BUFFER b-docum-est FOR docum-est.
DEFINE BUFFER b-item-doc-est FOR item-doc-est.
DEFINE BUFFER b-natur-oper FOR natur-oper.

/*DEFINE TEMP-TABLE tt-ft0910 NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR FORMAT "x(35)":U
    FIELD usuario           AS CHAR FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD serie             LIKE nota-fiscal.serie
    FIELD nr-nota-fis-ini   LIKE nota-fiscal.nr-nota-fis
    FIELD nr-nota-fis-fim   LIKE nota-fiscal.nr-nota-fis
    FIELD nome-ab-cli-ini   LIKE nota-fiscal.nome-ab-cli
    FIELD nome-ab-cli-fim   LIKE nota-fiscal.nome-ab-cli
    FIELD dt-emis-nota-ini  LIKE nota-fiscal.dt-emis-nota
    FIELD dt-emis-nota-fim  LIKE nota-fiscal.dt-emis-nota
    FIELD gera-nfe-n-gerada AS LOGICAL
    FIELD gera-nfe-gerada   AS LOGICAL
    FIELD exporta-est-txt   AS LOGICAL
    FIELD gera-nfe-cancel   AS LOGICAL
    FIELD gera-nfe-inut     AS LOGICAL
    FIELD c-motivo          AS CHARACTER.*/

DEFINE TEMP-TABLE tt-raw-ft0910 NO-UNDO
    FIELD raw-digita AS RAW.
DEFINE VARIABLE raw-param    AS RAW         NO-UNDO.


ASSIGN c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

/* MESSAGE "Evento " p-ind-event  SKIP        */
/*         "Objeto " p-ind-object SKIP        */
/*         "Tabela " p-cod-table  SKIP        */
/*         "Rowid  " STRING(p-row-table) SKIP */
/*         "Objeto " c-objeto     SKIP        */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */

IF  p-ind-object = "CONTAINER" 
AND p-ind-event = "AFTER-DISPLAY" THEN DO:

    ASSIGN gr-docum-est = p-row-table.

    FIND FIRST b-docum-est NO-LOCK
         WHERE ROWID(b-docum-est) = p-row-table NO-ERROR.

    IF VALID-HANDLE (wh-completo-re1001-upc) THEN DO:
        IF  AVAIL b-docum-est THEN DO:
            FIND FIRST int-docum-est NO-LOCK
                 WHERE int-docum-est.serie-docto  = b-docum-est.serie-docto
                   AND int-docum-est.nro-docto    = b-docum-est.nro-docto
                   AND int-docum-est.cod-emitente = b-docum-est.cod-emitente
                   AND int-docum-est.nat-operacao = b-docum-est.nat-operacao  NO-ERROR.
    
            IF  AVAIL int-docum-est
            AND int-docum-est.nota-completa THEN 
                ASSIGN wh-completo-re1001-upc:CHECKED = YES.
            ELSE 
                ASSIGN wh-completo-re1001-upc:CHECKED = NO.
        END.
        ELSE DO:
            ASSIGN wh-completo-re1001-upc:CHECKED = NO.
        END.
    END.

    IF VALID-HANDLE(wh-btConf) THEN
        ASSIGN wh-btConf:SENSITIVE = NO.
END.

IF  p-ind-object = "CONTAINER" 
AND p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/re1001-upc.p PERSISTENT SET h-upc-re1001(INPUT "",            
                                                     INPUT "",            
                                                     INPUT p-wgh-object,  
                                                     INPUT p-wgh-frame,   
                                                     INPUT "",            
                                                     INPUT p-row-table).  
END.

IF  p-ind-event = "destroy" THEN
    IF VALID-HANDLE(h-upc-re1001) THEN
        DELETE PROCEDURE h-upc-re1001.


IF  p-ind-event  = "AFTER-INITIALIZE"
AND p-ind-object = "CONTAINER" THEN DO:

    create button wh-bt-serv-re1001
    assign frame     = p-wgh-frame 
           width     = 4.00        
           height    = 1.25        
           row       = 1.12       
           col       = 59.12       
           visible   = yes
           sensitive = yes
           tooltip   = "Serviáo"
           triggers:
             on choose persistent RUN upc/re1001-upcl.w.
           end triggers.

    wh-bt-serv-re1001:load-image("image/im-ajusi.bmp":U).
    wh-bt-serv-re1001:MOVE-TO-TOP().
    
/*
    assign h-programa = p-wgh-object
           wgh-window = p-wgh-object.
*/           
    create button wh-button  
    assign frame     = p-wgh-frame 
           width     = 4.00        
           height    = 1.25        
           row       = 1.12       
           col       = 63.12       
           visible   = yes
           sensitive = yes
           tooltip   = "UPC"
           triggers:
             on choose persistent RUN upc/re1001-upcb.w.

           end triggers.
    if wh-button:load-image("image/gr-lay.bmp") then.

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = 'btConf' THEN 
                ASSIGN wh-btConf = h-object.
            IF h-object:NAME = 'fPage1' THEN 
                ASSIGN wh-Page1 = h-object.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.
    
    ASSIGN h-object = wh-Page1:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = "btItens" THEN DO:
                ASSIGN wh-btItens = h-object.
                LEAVE.
            END.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    ASSIGN wh-btItens:LABEL = "&Itens".


    IF VALID-HANDLE(wh-btConf) THEN DO:

        ASSIGN gr-docum-est    = p-row-table
               gr-docum-estFat = p-row-table
               gr-docum-estAtu = ?. 

        IF gr-docum-estFat = ? THEN
            ASSIGN gr-docum-estFat = p-row-table.

        ASSIGN wh-btConf:SENSITIVE = NO
               wh-btConf:VISIBLE = NO.

        CREATE BUTTON wh-button
        ASSIGN FRAME        = p-wgh-frame
               WIDTH        = wh-btConf:WIDTH
               HEIGHT       = wh-btConf:HEIGHT
               ROW          = wh-btConf:ROW
               LABEL        = wh-btConf:LABEL
               COLUMN       = wh-btConf:COLUMN
               SENSITIVE    = YES
               VISIBLE      = YES
               TOOLTIP      = wh-btConf:TOOLTIP
               HELP         = wh-btConf:HELP
               TRIGGERS:
                  ON CHOOSE PERSISTENT RUN upc/re1001-upca.p.
               END TRIGGERS.

        wh-button:LOAD-IMAGE(wh-btConf:IMAGE).
        wh-button:MOVE-TO-TOP().
    END.

    CREATE BUTTON wh-button-depos-re1001
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 10
           HEIGHT       = 1
           ROW          = 16.20
           LABEL        = "Dep¢sitos"
           COLUMN       = 15
           SENSITIVE    = YES
           VISIBLE      = YES
           TOOLTIP      = "Dep¢sitos"
           HELP         = "Dep¢sitos"
           TRIGGERS:
              ON CHOOSE PERSISTENT RUN pi-botao-depositos IN h-upc-re1001.
           END TRIGGERS.
    wh-button-depos-re1001:MOVE-TO-TOP().

    CREATE BUTTON wh-button-ord-prod-re1001
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 13
           HEIGHT       = 1
           ROW          = 16.20
           LABEL        = "Ordens Produá∆o"
           COLUMN       = 25
           SENSITIVE    = YES
           VISIBLE      = YES
           TOOLTIP      = "Ordens Produá∆o"
           HELP         = "Ordens Produá∆o"
           TRIGGERS:
              ON CHOOSE PERSISTENT RUN pi-botao-ord-prod IN h-upc-re1001.
           END TRIGGERS.
    wh-button-ord-prod-re1001:MOVE-TO-TOP().

    /*Informaá‰es nota devoluá∆o*/
    run getFieldHandle (INPUT "brSon1", 
                        OUTPUT hBrowseTela-re1001).

    ASSIGN h-serie-re1001           = hBrowseTela-re1001:ADD-CALC-COLUMN("CHAR", "X(16)", " ", "Serie NFS")
           h-serie-re1001:VISIBLE   = TRUE
           h-serie-re1001:READ-ONLY = TRUE.

    ASSIGN h-nota-re1001           = hBrowseTela-re1001:ADD-CALC-COLUMN("CHAR", "X(16)", " ", "Nota Fiscal Sa°da")
           h-nota-re1001:VISIBLE   = TRUE
           h-nota-re1001:READ-ONLY = TRUE.

    ASSIGN h-cfop-re1001           = hBrowseTela-re1001:ADD-CALC-COLUMN("CHAR", "X(16)", " ", "CFOP NFS")
           h-cfop-re1001:VISIBLE   = TRUE
           h-cfop-re1001:READ-ONLY = TRUE.

    run pi-busca-valor-atual.

    /*APPLY "row-display" TO hBrowseTela-re1001.*/
    /****/

    CREATE TOGGLE-BOX wh-completo-re1001-upc
    ASSIGN FRAME     = p-wgh-frame
           COLUMN    = 71.57
           ROW       = 6
           WIDTH     = 13.00
           HEIGHT    = 0.88
           LABEL     = "Completo?":U
           SENSITIVE = YES
           VISIBLE   = YES
           TRIGGERS:
              ON "VALUE-CHANGED" PERSISTENT RUN pi-value-changed-completa IN h-upc-re1001.
           END TRIGGERS.
END.

IF p-ind-event  = "before-change-page" AND 
   p-ind-object = "container"          AND
   p-cod-table  = "tt-item-doc-est" THEN DO:

    IF VALID-HANDLE(wh-button-depos-re1001) THEN
        wh-button-depos-re1001:MOVE-TO-TOP().

    IF VALID-HANDLE(wh-button-ord-prod-re1001) THEN
        wh-button-ord-prod-re1001:MOVE-TO-TOP().
END.


IF p-ind-event = "before-initialize":U  THEN DO:
    
    run pi-busca-handle (input p-wgh-frame,
                         input p-ind-event,
                         input 'fill-in':U,
                         input 'cod-emitente':U,
                         input NO,
                         output wh-cod-emitente-re1001).
    run pi-busca-handle (input p-wgh-frame,
                         input p-ind-event,
                         input 'fill-in':U,
                         input 'serie-docto':U,
                         input NO,
                         output wh-serie-docto-re1001).
    run pi-busca-handle (input p-wgh-frame,
                         input p-ind-event,
                         input 'fill-in':U,
                         input 'nro-docto':U,
                         input NO,
                         output wh-nro-docto-re1001).
    run pi-busca-handle (input p-wgh-frame,
                         input p-ind-event,
                         input 'fill-in':U,
                         input 'nat-operacao':U,
                         input NO,
                         output wh-nat-operacao-re1001).
END.

/*IF  p-ind-event  = "after-open-query" 
AND p-ind-object = "container"          
AND p-cod-table  = "item-doc-est" THEN DO:

    IF gr-docum-estAtu = ? THEN 
        NEXT.

    FIND FIRST docum-est EXCLUSIVE-LOCK
         WHERE ROWID(docum-est) = gr-docum-estAtu NO-ERROR.

    IF AVAIL docum-est THEN DO:

        IF docum-est.ce-atual = NO THEN 
            NEXT.

        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.

        IF AVAIL natur-oper THEN DO:

            IF natur-oper.imp-nota = NO THEN 
                NEXT.

            /* Regra para integraá∆o NFE - GATI */
            FIND FIRST nota-fiscal EXCLUSIVE-LOCK 
                 WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
                   AND nota-fiscal.serie       = docum-est.serie-docto
                   AND nota-fiscal.nr-nota-fis = docum-est.nro-docto NO-ERROR.

            IF AVAIL nota-fiscal THEN DO:
                IF nota-fiscal.cod-emitente <> docum-est.cod-emitente THEN 
                    NEXT.

                ASSIGN docum-est.ce-atual = NO.

                /*** reenvia arquivo txt e xml ***/
                FOR EACH gati-nfe-param NO-LOCK
                   WHERE gati-nfe-param.cod-estabel = nota-fiscal.cod-estabel.
                    IF opsys <> 'WIN32' THEN DO:
                        FIND FIRST gati-nfe-param-ext
                            WHERE gati-nfe-param-ext.cod-estabel = gati-nfe-param.cod-estabel NO-LOCK NO-ERROR.
                        IF AVAIL gati-nfe-param-ext THEN
                            ASSIGN c-arquivoXMLEnv = gati-nfe-param-ext.end-exp-nfe + '-bkp' + "/" + string(int(nota-fiscal.nr-nota-fis)) + "_" + nota-fiscal.serie + ".xml".
                    END.
                    ELSE DO:     
                        ASSIGN c-arquivoXMLEnv = gati-nfe-param.end-exp-nfe + '-bkp'  + "~\" + string(int(nota-fiscal.nr-nota-fis)) + "_" + nota-fiscal.serie + ".xml".
                    END.
                END.

                IF SEARCH(c-arquivoXMLEnv) = ?  
                AND c-nota-gerada-re1001   <>  nota-fiscal.nr-nota-fis THEN DO:
                    /*** gera TXT e XML - MAUAL ***/
                    
                    CREATE tt-ft0910.
                    ASSIGN tt-ft0910.usuario           = ""
                           tt-ft0910.arquivo           = SESSION:TEMP-DIRECTORY + "re1005rp-epc-" + trim(replace(string(TODAY), "/", "")) + trim(STRING(TIME)) + ".txt"
                           tt-ft0910.destino           = 2
                           tt-ft0910.data-exec         = TODAY
                           tt-ft0910.hora-exec         = TIME
                           tt-ft0910.cod-estabel       = nota-fiscal.cod-estabel
                           tt-ft0910.serie             = nota-fiscal.serie
                           tt-ft0910.nr-nota-fis-ini   = nota-fiscal.nr-nota-fis
                           tt-ft0910.nr-nota-fis-fim   = nota-fiscal.nr-nota-fis
                           tt-ft0910.nome-ab-cli-ini   = ""
                           tt-ft0910.nome-ab-cli-fim   = "ZZZZZZZZZZZZZ"
                           tt-ft0910.dt-emis-nota-ini  = 01/01/1900
                           tt-ft0910.dt-emis-nota-fim  = 12/31/2099
                           tt-ft0910.gera-nfe-n-gerada = YES
                           tt-ft0910.gera-nfe-gerada   = YES
                           tt-ft0910.exporta-est-txt   = YES
                           tt-ft0910.gera-nfe-cancel   = YES
                           tt-ft0910.gera-nfe-inut     = YES
                           tt-ft0910.c-motivo          = "".
    
                    raw-transfer tt-ft0910 to raw-param.
    
                    RUN ftp/ft0910rp.p (INPUT raw-param, INPUT TABLE tt-raw-ft0910).
    
                    run esp/ftp/esft067rp.p (input nota-fiscal.cod-estabel,
                                             input 'NFe_' + nota-fiscal.nr-nota-fis + '_' + nota-fiscal.cod-estabel + '_' + nota-fiscal.serie + '_' + replace(string(today,'99/99/9999'),'/','_') + '.txt').
    
                   ASSIGN nota-fiscal.dt-confirma = TODAY
                          c-nota-gerada-re1001    = nota-fiscal.nr-nota-fis.

                END.
                ASSIGN docum-est.ce-atual = YES.
            END. /* IF AVAIL nota-fiscal THEN DO: */
            FIND CURRENT nota-fiscal NO-LOCK NO-ERROR.
            RELEASE nota-fiscal.

        END. /* IF AVAIL natur-oper AND natur-oper.imp-nota THEN DO: */
        
    END. /* if avail docum-est and docum-est.ce-atual then DO: */
    FIND CURRENT docum-est NO-LOCK NO-ERROR.
    RELEASE docum-est.

END.*/

PROCEDURE pi-busca-handle:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.
    
    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
            
    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(wgh-obj):

        IF  pApresMsg = YES THEN
            MESSAGE
                "Nome do Objeto " wgh-obj:NAME SKIP
                "Type do Objeto " wgh-obj:TYPE skip
                "P-Ind-Event    " pIndEvent
                VIEW-AS ALERT-BOX.

        IF  wgh-obj:TYPE    =   pObjType    AND 
            wgh-obj:NAME    =   pObjName    THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE.
            /*LEAVE.*/
        END. 

        IF  wgh-obj:TYPE = "field-group" THEN    
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.           
END PROCEDURE.

PROCEDURE getFieldHandle:
    DEF INPUT PARAMETER  p-campo  AS CHAR no-undo.
    DEF OUTPUT PARAMETER p-handle AS HANDLE no-undo.
    
    def var h_frame as widget-handle no-undo. 
    
    ASSIGN h_Frame = wh-Page1:FIRST-CHILD. /* pegando o Field-Group */
    /*ASSIGN h_Frame = h_Frame:FIRST-CHILD.     /* pegando o 1o. Campo */*/
    
    DO WHILE h_Frame <> ? :
        IF h_frame:type <> "field-group" THEN DO: 
            IF h_Frame:NAME = p-campo THEN DO:
                assign p-handle = h_Frame.
                leave.
            END.
            ASSIGN h_Frame = h_Frame:NEXT-SIBLING.
        END. 
        ELSE
            ASSIGN h_frame = h_frame:first-child. 
    END.
END.

PROCEDURE pi-botao-depositos:

/*    IF CAN-FIND(FIRST rat-lote NO-LOCK
                WHERE rat-lote.cod-emitente = int(wh-cod-emitente-re1001:SCREEN-VALUE)
                  AND rat-lote.serie-docto  = wh-serie-docto-re1001:SCREEN-VALUE
                  AND rat-lote.nro-docto    = wh-nro-docto-re1001:SCREEN-VALUE
                  AND rat-lote.nat-operacao = wh-nat-operacao-re1001:SCREEN-VALUE) THEN DO:*/

    IF VALID-HANDLE(wh-cod-emitente-re1001) THEN DO:
        RUN upc/re1001-upcv.w (INPUT int(wh-cod-emitente-re1001:SCREEN-VALUE),
                               INPUT wh-serie-docto-re1001:SCREEN-VALUE,
                               INPUT wh-nro-docto-re1001:SCREEN-VALUE,
                               INPUT wh-nat-operacao-re1001:SCREEN-VALUE).
    END.

END PROCEDURE.

PROCEDURE pi-botao-ord-prod:
    IF VALID-HANDLE(wh-cod-emitente-re1001) THEN DO:
        RUN upc/re1001-upcv-a.w (INPUT int(wh-cod-emitente-re1001:SCREEN-VALUE),
                                 INPUT wh-serie-docto-re1001:SCREEN-VALUE,
                                 INPUT wh-nro-docto-re1001:SCREEN-VALUE,
                                 INPUT wh-nat-operacao-re1001:SCREEN-VALUE).
    END.

END PROCEDURE.

PROCEDURE pi-busca-valor-atual.
    
    ASSIGN wh-browse-page1 = hBrowseTela-re1001:FIRST-COLUMN.
    IF VALID-HANDLE(wh-browse-page1) THEN DO:
        ASSIGN wh-query-re1001 = hBrowseTela-re1001:QUERY.
        IF VALID-HANDLE(hBrowseTela-re1001) THEN
             ON 'ROW-DISPLAY' OF hBrowseTela-re1001 PERSISTENT RUN upc/re1001-upcc.P (INPUT wh-browse-page1,
                                                                                      INPUT wh-query-re1001).
    END.

END PROCEDURE.

PROCEDURE pi-value-changed-completa:
    DEFINE VARIABLE l-validou-pis-cofins AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-aviso-nf-dev       AS LOGICAL     NO-UNDO.


    FIND FIRST b-docum-est NO-LOCK
         WHERE ROWID(b-docum-est) = gr-docum-est NO-ERROR.

        
    /*Consistencias para "nota completa"*/
    IF wh-completo-re1001-upc:CHECKED THEN DO:

        RUN esp/es0018p.p (INPUT "re1001":U,
                           INPUT 3,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        /*serviáo*/
        IF b-docum-est.cod-observa = 4 
        AND NOT CAN-FIND (FIRST tt-prog-ponto
                          WHERE tt-prog-ponto.conteudo = b-docum-est.nat-operacao) THEN DO:

            FIND FIRST int-docum-est NO-LOCK
                 WHERE int-docum-est.serie-docto  = b-docum-est.serie-docto 
                   AND int-docum-est.nro-docto    = b-docum-est.nro-docto   
                   AND int-docum-est.cod-emitente = b-docum-est.cod-emitente
                   AND int-docum-est.nat-operacao = b-docum-est.nat-operacao NO-ERROR.
    
            IF NOT AVAIL int-docum-est
            OR int-docum-est.cd-servico = 0 THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "N∆o informado c¢digo do serviáo!" + "~~" + 
                                         "N∆o informado c¢digo do serviáo!").
    
                ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                RETURN NO-APPLY.   
            END.
    
            IF NOT AVAIL int-docum-est
            OR int-docum-est.cd-enquadramento = "" THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "N∆o informado c¢digo do enquadramento!" + "~~" + 
                                         "N∆o informado c¢digo do enquadramento!").
    
                ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                RETURN NO-APPLY.   
            END.
        END.

        FIND FIRST natur-oper NO-LOCK 
             WHERE natur-oper.nat-operacao =  b-docum-est.nat-operacao NO-ERROR.

        IF AVAIL natur-oper THEN DO:

            IF  natur-oper.terceiros
            AND (natur-oper.tp-oper-terc = 1 OR natur-oper.tp-oper-terc = 3) THEN DO:

                 FIND FIRST int-docum-est NO-LOCK
                      WHERE int-docum-est.serie-docto  = b-docum-est.serie-docto 
                        AND int-docum-est.nro-docto    = b-docum-est.nro-docto   
                        AND int-docum-est.cod-emitente = b-docum-est.cod-emitente
                        AND int-docum-est.nat-operacao = b-docum-est.nat-operacao NO-ERROR.

                 IF NOT AVAIL int-docum-est 
                 OR int-docum-est.user-solic-nf-terc = ""
                 OR int-docum-est.cod-ccusto-nf-terc = "" THEN DO:
                     RUN utp/ut-msgs.p (INPUT "show",
                                        INPUT 17006,
                                        INPUT "N∆o informado Solicitante NF Terc!" + "~~" + 
                                              "N∆o informado Solicitante NF Terc!").

                         ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                         RETURN NO-APPLY.   
                 END.
            END.


           IF natur-oper.especie-doc = "NFD" THEN DO:
              FIND FIRST int-docum-est NO-LOCK
                   WHERE int-docum-est.serie-docto  = b-docum-est.serie-docto 
                     AND int-docum-est.nro-docto    = b-docum-est.nro-docto   
                     AND int-docum-est.cod-emitente = b-docum-est.cod-emitente
                     AND int-docum-est.nat-operacao = b-docum-est.nat-operacao NO-ERROR.
                IF AVAIL int-docum-est THEN DO:
                     IF int-docum-est.cod-msg-devolucao  = 0 THEN DO:
                         RUN utp/ut-msgs.p (INPUT "show",
                                            INPUT 17006,
                                            INPUT "MOTIVO DE DEOLUÄ«O DEVE SER INFORMADO" + "~~" + 
                                                  "Deve ser informado o motivo de devoluá∆o").

                         ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                         RETURN NO-APPLY.
                   END.
                END.
                ELSE DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 17006,
                                       INPUT "MOTIVO DE DEOLUÄ«O DEVE SER INFORMADO" + "~~" + 
                                             "Deve ser informado o motivo de devoluá∆o").
                    ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                    RETURN NO-APPLY.
                END.
           END.
        END.

        /*Naturezas de telefonia e energia 57182*/
        RUN esp/es0018p.p (INPUT "re1001",
                           INPUT 1,
                           INPUT 0,
                           INPUT "", 
                           OUTPUT TABLE tt-prog-ponto).
    
        FIND FIRST tt-prog-ponto
             WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = "Energia" NO-ERROR.
    
        IF  AVAIL tt-prog-ponto
        AND LOOKUP(b-docum-est.nat-operacao,tt-prog-ponto.conteudo,";") <> 0
        AND NOT CAN-FIND (FIRST nota-fisc-adc
                          WHERE nota-fisc-adc.cod-estab        = b-docum-est.cod-estabe
                            AND nota-fisc-adc.cod-serie        = b-docum-est.serie-docto
                            AND nota-fisc-adc.cod-nota-fisc    = b-docum-est.nro-docto
                            AND nota-fisc-adc.cdn-emitente     = b-docum-est.cod-emitente
                            AND nota-fisc-adc.cod-natur-operac = b-docum-est.nat-operacao
                            AND nota-fisc-adc.idi-tip-dado     = 8) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "INFORMAÄÂES ADICIONAIS DA NOTA FISCAL" + "~~" + 
                                     "Para lanáamentos de faturas de energia elÇtrica favor preencher as ÀINFORMAÄÂES ADICIONAIS DA NOTA FISCALÃ no CD4035 antes de marcar NF Completa.").
    
            ASSIGN wh-completo-re1001-upc:CHECKED = NO.
            RETURN NO-APPLY.
        END.
    
        FIND FIRST tt-prog-ponto
             WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = "Telefonia" NO-ERROR.

        IF  AVAIL tt-prog-ponto
        AND LOOKUP(b-docum-est.nat-operacao,tt-prog-ponto.conteudo,";") <> 0
        AND NOT CAN-FIND (FIRST nota-fisc-adc
                          WHERE nota-fisc-adc.cod-estab        = b-docum-est.cod-estabe
                            AND nota-fisc-adc.cod-serie        = b-docum-est.serie-docto
                            AND nota-fisc-adc.cod-nota-fisc    = b-docum-est.nro-docto
                            AND nota-fisc-adc.cdn-emitente     = b-docum-est.cod-emitente
                            AND nota-fisc-adc.cod-natur-operac = b-docum-est.nat-operacao
                            AND nota-fisc-adc.idi-tip-dado     = 12) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "INFORMAÄÂES ADICIONAIS DA NOTA FISCAL" + "~~" + 
                                     "Para lanáamentos de faturas de telefonia favor preencher as ÀINFORMAÄÂES ADICIONAIS DA NOTA FISCALÃ no CD4035 antes de marcar NF Completa.").
    
            ASSIGN wh-completo-re1001-upc:CHECKED = NO.
            RETURN NO-APPLY.
        END.

        ASSIGN i-num-pedido = 0
               l-validou-pis-cofins = NO.

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = b-docum-est.cod-emitente NO-ERROR.

        FIND FIRST natur-oper NO-LOCK 
             WHERE natur-oper.nat-operacao =  b-docum-est.nat-operacao NO-ERROR.
    
        ASSIGN l-aviso-nf-dev = NO.
        
        FOR EACH b-item-doc-est OF b-docum-est NO-LOCK:
             
            IF b-item-doc-est.nro-comp = '' AND NOT l-aviso-nf-dev THEN DO:
                IF AVAIL natur-oper THEN DO:
                   IF natur-oper.especie-doc = 'NFD' AND natur-oper.tipo-compra = 3 THEN DO: /* Devolucao Cliente */ 
                      
                      RUN utp/ut-msgs.p (INPUT "show",
                                         INPUT 27100,
                                         INPUT "Lanáamento NF Devoluá∆o sem nota de Origem" + CHR(13) + "Tem certeza que deseja continuar ?" ).

                      IF RETURN-VALUE <> "YES" THEN DO:
                         ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                         RETURN NO-APPLY.
                      END.
                      ELSE 
                        ASSIGN l-aviso-nf-dev = YES.
                   END.
                END.
            END.

            /*Consistencia cadastro cont†bil.*/
            IF b-item-doc-est.sc-codigo <> "" THEN DO:
                IF NOT CAN-FIND (FIRST cc_uni_estab 
                                 WHERE cc_uni_estab.cod_estab      = b-docum-est.cod-estabel
                                   AND cc_uni_estab.cc_codigo      = b-item-doc-est.sc-codigo
                                   AND cc_uni_estab.cod_unid_negoc = b-item-doc-est.cod-unid-negoc) THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 17006,
                                       INPUT "Inconsistencia no cadastro cont†bil." + "~~" + 
                                             "N∆o encontrado cadastro cont†bil para o centro de custo " + b-item-doc-est.sc-codigo + " com unidade de neg¢cio " + b-item-doc-est.cod-unid-negoc + " informados no item " + b-item-doc-est.it-codigo).
    
                    ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                    RETURN NO-APPLY.
                END.
            END.

            /*Consistencia cart∆o de credito*/
            ASSIGN i-num-pedido = b-item-doc-est.num-pedido.

            IF i-num-pedido = 0 THEN DO:
                FIND FIRST rat-ordem OF b-item-doc-est NO-LOCK NO-ERROR.
                IF AVAIL rat-ordem THEN
                    ASSIGN i-num-pedido = rat-ordem.num-pedido.
            END.
            
/*             IF  CAN-FIND (FIRST pedido-compr                                                                                                                                                                                             */
/*                           WHERE pedido-compr.num-pedido   = i-num-pedido                                                                                                                                                                 */
/*                             AND pedido-compr.cod-cond-pag = 78)                                                                                                                                                                          */
/*             AND CAN-FIND (FIRST natur-oper                                                                                                                                                                                               */
/*                           WHERE natur-oper.nat-operacao   = b-docum-est.nat-operacao                                                                                                                                                     */
/*                             AND natur-oper.emite-duplic)  THEN DO:                                                                                                                                                                       */
/*                                                                                                                                                                                                                                          */
/*                 RUN utp/ut-msgs.p (INPUT "show",                                                                                                                                                                                         */
/*                                    INPUT 17006,                                                                                                                                                                                          */
/*                                    INPUT "Pedido com condiá∆o cart∆o de crÇdito." + "~~" +                                                                                                                                               */
/*                                          "O item " + b-item-doc-est.it-codigo + " possui condiá∆o de pagamento cart∆o de crÇdito, n∆o Ç poss°vel utilizar a natureza  " + b-docum-est.nat-operacao + " que atualiza o contas a pagar."). */
/*                                                                                                                                                                                                                                          */
/*                 ASSIGN wh-completo-re1001-upc:CHECKED = NO.                                                                                                                                                                              */
/*                 RETURN NO-APPLY.                                                                                                                                                                                                         */
/*             END.                                                                                                                                                                                                                         */

            ASSIGN i-num-ordem = b-item-doc-est.numero-ordem.
            IF i-num-ordem = 0 THEN DO:
                FIND FIRST rat-ordem OF b-item-doc-est NO-LOCK NO-ERROR.
                IF AVAIL rat-ordem THEN
                    ASSIGN i-num-ordem = rat-ordem.numero-ordem.
            END.

            /*Valida % de ratio dos pedidos*/
            FOR FIRST ordem-compra NO-LOCK
                WHERE ordem-compra.numero-ordem = i-num-ordem,
               FIRST ITEM NO-LOCK
               WHERE ITEM.it-codigo  = ordem-compra.it-codigo
                 AND ITEM.tipo-contr = 4:

                ASSIGN d-total-perc = 0.
                FOR EACH matriz-rat-ordem 
                   WHERE matriz-rat-ordem.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
                    ASSIGN d-total-perc = d-total-perc + matriz-rat-ordem.perc-rateio.
                END.

                IF d-total-perc < 100 THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                        INPUT 17006,
                                        INPUT "Matriz de rateio do pedido de compra n∆o est† 100%" + "~~" + 
                                              "Matriz de rateio da ordem de compra " + string(ordem-compra.numero-ordem) + " relacionada ao item " + b-item-doc-est.it-codigo + " n∆o est† com 100%").

                    ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                    RETURN NO-APPLY.    
                END.
            END.
            

            FIND FIRST int-natur-oper NO-LOCK
                 WHERE int-natur-oper.nat-operacao = natur-oper.nat-operacao NO-ERROR.

            IF  b-docum-est.nat-operacao BEGINS "3"
            AND natur-oper.especie-doc <> "NFD"
            AND int-natur-oper.cod-observa = 1
            AND natur-oper.tp-oper-terc <> 2 THEN DO:
                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = b-item-doc-est.it-codigo NO-ERROR.

                IF  ITEM.codigo-orig <> 1
                AND ITEM.codigo-orig <> 6 THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 17006,
                                       INPUT "Item " + b-item-doc-est.it-codigo + " com origem inv†lida!" + "~~" + 
                                             "Para naturezas de importaá∆o o item deve possuir origem 1 ou 6.").

                    ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                    RETURN NO-APPLY.    
                END.
            END.
            FIND FIRST b-natur-oper NO-LOCK
                 WHERE b-natur-oper.nat-operacao = b-item-doc-est.nat-of NO-ERROR.
            IF AVAIL b-natur-oper AND l-validou-pis-cofins = NO AND natur-oper.especie-doc <> "NFD" THEN DO:
               IF substr(b-natur-oper.char-1,86,1) = "1" AND substr(b-natur-oper.char-1,87,1) = "1" THEN DO: /* PIS e COFINS Tributados */
                   IF AVAIL emitente THEN DO:
                       IF emitente.estado <> "EX" THEN DO:
                          IF emitente.idi-tributac-pis <> 1 OR
                             emitente.idi-tributac-cofins <> 1 THEN DO:
                             ASSIGN l-validou-pis-cofins = YES.
                             RUN utp/ut-msgs.p (INPUT "show",
                                                 INPUT 27100,
                                                 INPUT "Tem certeza que deseja continuar?" + "~~" +
                                                       "Para esta natureza de operaá∆o, a Tributaá∆o PIS/COFINS do fornecedor devem estar marcadas.Sequencia do item:" + STRING(b-item-doc-est.sequencia)).
                             IF RETURN-VALUE <> "YES" THEN DO: 
                                ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                                RETURN NO-APPLY.
                             END.
                          END.
                       END.
                   END.
               END.
            END.
            
        END.

        IF  AVAIL emitente
        AND emitente.natureza = 1 /*pessoa F°sica*/ THEN DO:
            
            IF CAN-FIND (FIRST dupli-apagar OF b-docum-est
                         WHERE dupli-apagar.cod-esp <> "PF") THEN DO:
                
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "EspÇcie da duplicada inv†lida." + "~~" + 
                                         "Para pessoa f°sica somente a espÇcie PF Ç permitida.").

                ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                RETURN NO-APPLY.    
            END.
        END.

        IF  AVAIL emitente
        AND emitente.natureza = 3 /*estrangeiro*/ THEN DO:
            
            IF CAN-FIND (FIRST dupli-apagar OF b-docum-est
                         WHERE dupli-apagar.cod-esp <> "DI") THEN DO:
                
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "EspÇcie da duplicada inv†lida." + "~~" + 
                                         "Para fornecedor estrangeiro somente a espÇcie DI Ç permitida.").

                ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                RETURN NO-APPLY.    
            END.

            IF b-docum-est.nat-operacao BEGINS "3" THEN DO:
               IF trim(SUBSTR(emitente.char-1,103,30)) = "" THEN DO:
                  RUN utp/ut-msgs.p (INPUT "show",
                                     INPUT 17006,
                                     INPUT "Nr Passaporte do fornecedor inv†lido." + "~~" + 
                                           "Para naturezas de importaá∆o o nr do passaporte do fornecedor n∆o pode ser branco.").
                  
                  ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                  RETURN NO-APPLY.    

               END.
               IF trim(SUBSTR(emitente.char-1,103,30)) = "ISENTO" OR trim(SUBSTR(emitente.char-1,103,30)) = "ISENTA" THEN DO:
                  RUN utp/ut-msgs.p (INPUT "show",
                                     INPUT 17006,
                                     INPUT "Nr Passaporte do fornecedor inv†lido." + "~~" + 
                                           "Para naturezas de importaá∆o o nr do passaporte do fornecedor n∆o pode ser ISENTO/ISENTA.").
                  
                  ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                  RETURN NO-APPLY.    
               END.
               IF LENGTH(trim(SUBSTR(emitente.char-1,103,30))) < 5 THEN DO:
                  RUN utp/ut-msgs.p (INPUT "show",
                                     INPUT 17006,
                                     INPUT "Nr Passaporte do fornecedor inv†lido." + "~~" + 
                                           "Para naturezas de importaá∆o o nr do passaporte do fornecedor n∆o pode conter menos de 5 caracteres.").
                  
                  ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                  RETURN NO-APPLY.    
               END.
               IF LENGTH(trim(SUBSTR(emitente.char-1,103,30))) > 20 THEN DO:
                  RUN utp/ut-msgs.p (INPUT "show",
                                     INPUT 17006,
                                     INPUT "Nr Passaporte do fornecedor inv†lido." + "~~" + 
                                           "Para naturezas de importaá∆o o nr do passaporte do fornecedor n∆o pode conter mais de 20 caracteres.").
                  
                  ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                  RETURN NO-APPLY.    
               END.
            END.
        END.

        RUN esp/es0018p.p (INPUT "re1001",
                           INPUT 2,
                           INPUT 0,
                           INPUT "", 
                           OUTPUT TABLE tt-prog-ponto).
    
        IF CAN-FIND (FIRST tt-prog-ponto
                     WHERE tt-prog-ponto.conteudo = b-docum-est.nat-operacao) THEN DO:

            IF CAN-FIND (FIRST rat-docum NO-LOCK
                         WHERE rat-docum.serie-docto  = b-docum-est.serie-docto 
                           AND rat-docum.nro-docto    = b-docum-est.nro-docto   
                           AND rat-docum.cod-emitente = b-docum-est.cod-emitente
                           AND rat-docum.nat-operacao = b-docum-est.nat-operacao
                           AND rat-docum.nf-nat-oper BEGINS "3551") THEN DO:

                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Natureza de operaá∆o n∆o permitida." + "~~" + 
                                         "Documento possui rateio com natureza iniciada em 3551.").

                ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                RETURN NO-APPLY.    
            END.
        END.

        RUN esp/es0018p.p (INPUT "esfas016", /* naturezas de transferencia de imobilizado */
                           INPUT 1,
                           INPUT 0,
                           INPUT "", 
                           OUTPUT TABLE tt-prog-ponto).
    
        IF  CAN-FIND (FIRST tt-prog-ponto
                      WHERE tt-prog-ponto.conteudo = b-docum-est.nat-operacao) THEN DO:

            FIND FIRST int_solic_transf
                WHERE int_solic_transf.nr_nota_transf = b-docum-est.nro-docto
                AND   int_solic_transf.dat_transf    >= b-docum-est.dt-emissao
                AND   int_solic_transf.ind_aprovac    = "Pendente" NO-LOCK NO-ERROR.

            IF  NOT AVAIL int_solic_transf THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Solicitaá∆o de transferància de imobilizado n∆o foi informada." + "~~" +
                                         "Para esta natureza de operaá∆o Ç obrigat¢rio criar a solicitaá∆o de transferància de imobilizado. Utilizar bot∆o Dep¢sitos, folder Transf Imob ou diretamente pela rotina ESFAS016.").

                ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                RETURN NO-APPLY.    
            END.
        END.

        IF natur-oper.terceiros AND natur-oper.tp-oper-terc = 1 AND b-docum-est.tot-valor <= 100 THEN DO:
           RUN utp/ut-msgs.p (INPUT "show",
                              INPUT 27100,
                              INPUT "Tem certeza que deseja continuar?" + "~~" +
                                    "NF com valor atÇ R$ 100,00 e natureza movimentando saldo terceiros.").
           IF RETURN-VALUE <> "YES" THEN DO:
              ASSIGN wh-completo-re1001-upc:CHECKED = NO.
              RETURN NO-APPLY.    
           END.
        END.

        /* Nao permitir despesa com valor zerado*/

        RUN esp/es0018p.p (INPUT "re1001", 
                           INPUT 5,
                           INPUT 0,
                           INPUT "", 
                           OUTPUT TABLE tt-prog-ponto).

        IF  NOT CAN-FIND (FIRST tt-prog-ponto
                          WHERE tt-prog-ponto.conteudo = b-docum-est.nat-operacao) THEN DO:
            FIND FIRST dupli-apagar-cex NO-LOCK
                 WHERE dupli-apagar-cex.serie-docto  = b-docum-est.serie-docto 
                   AND dupli-apagar-cex.nro-docto    = b-docum-est.nro-docto   
                   AND dupli-apagar-cex.cod-emitente = b-docum-est.cod-emitente
                   AND dupli-apagar-cex.nat-operacao = b-docum-est.nat-operacao
                   AND dupli-apagar-cex.vl-a-pagar   = 0 NO-ERROR.
            IF AVAIL dupli-apagar-cex THEN DO:
               RUN utp/ut-msgs.p (INPUT "show",
                                  INPUT 17006,
                                  INPUT "Duplicata de despesa com valor 0." + "~~" +
                                        "N∆o Ç permitido duplicata de despesa com valor zerado.").
               
               ASSIGN wh-completo-re1001-upc:CHECKED = NO.
               RETURN NO-APPLY.
            END.
        END.

        RUN esp/es0018p.p (INPUT "re1001", 
                           INPUT 7,
                           INPUT 0,
                           INPUT "", 
                           OUTPUT TABLE tt-prog-ponto).
        FOR EACH tt-prog-ponto:
            IF substr(b-docum-est.nat-operacao,2,3) = tt-prog-ponto.conteudo THEN DO:
               IF CAN-FIND(FIRST b-item-doc-est OF b-docum-est
                           WHERE substr(b-item-doc-est.nat-comp,2,3) <> tt-prog-ponto.conteudo) THEN DO:

                  RUN utp/ut-msgs.p (INPUT "show",
                                     INPUT 27100,
                                     INPUT "Tem certeza que deseja continuar?" + "~~" +
                                           "A natureza da NF Ç X" + tt-prog-ponto.conteudo + " " + "e existe item da NF com natureza diferente de X" + tt-prog-ponto.conteudo).
                  IF RETURN-VALUE <> "YES" THEN DO:
                     ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                     RETURN NO-APPLY.    
                  END.

               END.
            END.
            ELSE DO:
               IF CAN-FIND(FIRST b-item-doc-est OF b-docum-est
                           WHERE substr(b-item-doc-est.nat-comp,2,3) = tt-prog-ponto.conteudo) THEN DO:

                  RUN utp/ut-msgs.p (INPUT "show",
                                     INPUT 27100,
                                     INPUT "Tem certeza que deseja continuar?" + "~~" +
                                           "A natureza da NF n∆o Ç X" + tt-prog-ponto.conteudo + " " + "e existe item da NF com natureza igual a X" + tt-prog-ponto.conteudo).
                  IF RETURN-VALUE <> "YES" THEN DO:
                     ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                     RETURN NO-APPLY.    
                  END.

               END.
            END.
        END.

        IF AVAIL emitente AND AVAIL natur-oper THEN DO:
           IF natur-oper.imp-nota = YES THEN DO:
              FOR EACH b-item-doc-est OF b-docum-est NO-LOCK
                 WHERE b-item-doc-est.nro-comp <> "":
                  FIND FIRST nota-fiscal NO-LOCK
                       WHERE nota-fiscal.cod-estabel = b-docum-est.cod-estabel
                       AND   nota-fiscal.serie       = b-item-doc-est.serie-comp
                       AND   nota-fiscal.nr-nota-fis = b-item-doc-est.nro-comp NO-ERROR.
                  IF AVAIL nota-fiscal THEN DO:
                      IF nota-fiscal.estado   <> emitente.estado THEN DO:
                         RUN utp/ut-msgs.p (INPUT "show",
                                            INPUT 27100,
                                            INPUT "Tem certeza que deseja continuar?" + "~~" +
                                                  "Estado emitente diferente do estado da NF de origem. Seq.:" + STRING(b-item-doc-est.sequencia)).
                         IF RETURN-VALUE <> "YES" THEN DO:
                            ASSIGN wh-completo-re1001-upc:CHECKED = NO.
                            RETURN NO-APPLY.    
                         END.
                      END.
                  END.
              END.
           END.
        END.
    END. /*wh-completo-re1001-upc:CHECKED*/

    IF AVAIL b-docum-est THEN DO:
        FIND FIRST int-docum-est EXCLUSIVE-LOCK
             WHERE int-docum-est.serie-docto  = b-docum-est.serie-docto
               AND int-docum-est.nro-docto    = b-docum-est.nro-docto
               AND int-docum-est.cod-emitente = b-docum-est.cod-emitente
               AND int-docum-est.nat-operacao = b-docum-est.nat-operacao  NO-ERROR.
    
        IF NOT AVAIL int-docum-est THEN DO:
            CREATE int-docum-est.
            ASSIGN int-docum-est.serie-docto  = b-docum-est.serie-docto 
                   int-docum-est.nro-docto    = b-docum-est.nro-docto   
                   int-docum-est.cod-emitente = b-docum-est.cod-emitente
                   int-docum-est.nat-operacao = b-docum-est.nat-operacao.
        END.
        
        ASSIGN int-docum-est.nota-completa = wh-completo-re1001-upc:CHECKED.

        RELEASE int-docum-est.
    END.
END PROCEDURE.
