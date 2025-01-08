/***********************************************************************
**  Programa..: UPC\im0045a-UPC.P                     
**  Autor.....: Silvio Ferrari                        
**  Data......: maráo/2011 - Desenvolvimento          
**  Descricao.:                                       
**  Vers∆o....: 001 16/03/2011                        
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.
                                                      
DEFINE VARIABLE h-objeto-aux AS WIDGET-HANDLE   NO-UNDO.
DEFINE VARIABLE i2-nr-ordem     AS INTEGER         NO-UNDO.
DEFINE VARIABLE i2-nr-parcela   AS INTEGER         NO-UNDO.
                                                      
DEF NEW GLOBAL SHARED VAR h-data    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR hquery    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR hbuffer   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-browser AS HANDLE        NO-UNDO.

define new global shared var h-browser-im0045a as widget-handle no-undo.
define new global shared var hquery-im0045a    as widget-handle no-undo.
define new global shared var hbuffer-im0045a   as handle        no-undo.

define new global shared var h-browser-im0045a-2 as widget-handle no-undo.
define new global shared var hquery-im0045a-2    as widget-handle no-undo.
define new global shared var hbuffer-im0045a-2   as handle        no-undo.

DEFINE VARIABLE c-embarque    AS CHARACTER NO-UNDO.   
DEFINE VARIABLE c-cod-estabel AS CHARACTER NO-UNDO.   
DEFINE VARIABLE i-num-ordem   AS INTEGER   NO-UNDO.   
DEFINE VARIABLE i-parcela     AS INTEGER   NO-UNDO.   
DEFINE VARIABLE h-object      AS HANDLE    NO-UNDO.   
DEFINE VARIABLE h-buffer      AS HANDLE    NO-UNDO.   
DEFINE VARIABLE h-query       AS HANDLE    NO-UNDO.   
                                                      
DEFINE VARIABLE wh-objeto    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-fPage1    AS WIDGET-HANDLE NO-UNDO.
                                                      
DEFINE NEW GLOBAL SHARED VARIABLE h-im0045a-upc               AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel-im0045a-upc  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-embarque-im0045a-upc     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-brSon1-im0045a-upc       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-brSon3-im0045a-upc       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btNext-2-im0045a-upc     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btLast-2-im0045a-upc     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btNext-2-aux-im0045a-upc AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btLast-2-aux-im0045a-upc AS WIDGET-HANDLE NO-UNDO.
                                                      
DEFINE TEMP-TABLE tt-ordens-invalidas NO-UNDO         
    FIELD num-pedido   AS INTEGER FORMAT ">>>>>,>>9":U
    FIELD numero-ordem AS INTEGER FORMAT "zzzzz9,99":U
    FIELD parcela      AS INTEGER FORMAT ">>>>9":U    
    FIELD via-transp   AS INTEGER FORMAT ">9":U       
    INDEX ch-primario IS PRIMARY                      
        num-pedido                                    
        numero-ordem                                  
        parcela.                                      
                                                      
IF p-ind-event  = "AFTER-INITIALIZE":U AND            
   p-ind-object = "CONTAINER":U         THEN DO:      
    IF  NOT VALID-HANDLE(h-im0045a-upc) THEN          
        RUN upc/im0045a-upc.p PERSISTENT SET h-im0045a-upc (INPUT "":U,
                                                            INPUT "":U,
                                                            INPUT p-wgh-object,
                                                            INPUT p-wgh-frame,
                                                            INPUT "":U,
                                                            INPUT p-row-table).
                                                      
    ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD        
           wh-objeto = wh-objeto:FIRST-CHILD.         
                                                      
    DO  WHILE wh-objeto <> ?:                         
        IF  wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
            CASE wh-objeto:NAME:                      
                WHEN "cod-estabel":U THEN ASSIGN wh-cod-estabel-im0045a-upc = wh-objeto.
                WHEN "embarque":U    THEN ASSIGN wh-embarque-im0045a-upc    = wh-objeto.
                WHEN "fPage1":U      THEN ASSIGN wh-fPage1                  = wh-objeto.
            END CASE.                                 
            ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
        END.                                          
        ELSE ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
    END.                                              
                                                      
    ASSIGN wh-objeto = wh-fPage1:FIRST-CHILD          
           wh-objeto = wh-objeto:FIRST-CHILD.         
                                                      
    DO  WHILE wh-objeto <> ?:                         
        IF  wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
            CASE wh-objeto:NAME:                      
                WHEN "brSon1":U   THEN ASSIGN wh-brSon1-im0045a-upc   = wh-objeto.
                WHEN "brSon3":U   THEN ASSIGN wh-brSon3-im0045a-upc   = wh-objeto.
                WHEN "btNext-2":U THEN ASSIGN wh-btNext-2-im0045a-upc = wh-objeto.
                WHEN "btLast-2":U THEN ASSIGN wh-btLast-2-im0045a-upc = wh-objeto.
            END CASE.                                 
            ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
        END.                                          
        ELSE ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
    END.                                              
                                                      
    IF VALID-HANDLE(wh-brSon1-im0045a-upc)   AND      
       VALID-HANDLE(wh-brSon3-im0045a-upc)   AND      
       VALID-HANDLE(wh-btNext-2-im0045a-upc) AND      
       VALID-HANDLE(wh-btLast-2-im0045a-upc) THEN DO: 
        CREATE BUTTON wh-btNext-2-aux-im0045a-upc     
        ASSIGN NAME      = wh-btNext-2-im0045a-upc:NAME + "-upc":U
               FRAME     = wh-btNext-2-im0045a-upc:FRAME
               COLUMN    = wh-btNext-2-im0045a-upc:COLUMN
               ROW       = wh-btNext-2-im0045a-upc:ROW
               WIDTH     = wh-btNext-2-im0045a-upc:WIDTH
               HEIGHT    = wh-btNext-2-im0045a-upc:HEIGHT
               LABEL     = wh-btNext-2-im0045a-upc:LABEL
               SENSITIVE = YES                        
               VISIBLE   = YES                        
               TRIGGERS:                              
                   ON "CHOOSE":U PERSISTENT RUN pi-choose-btNext-2 IN h-im0045a-upc.
               END TRIGGERS.                          
                                                      
        wh-btNext-2-aux-im0045a-upc:LOAD-IMAGE-UP(wh-btNext-2-im0045a-upc:IMAGE-UP).
        wh-btNext-2-aux-im0045a-upc:LOAD-IMAGE-DOWN(wh-btNext-2-im0045a-upc:IMAGE-DOWN).
        wh-btNext-2-aux-im0045a-upc:LOAD-IMAGE-INSENSITIVE(wh-btNext-2-im0045a-upc:IMAGE-INSENSITIVE).
                                                      
        ASSIGN wh-btNext-2-im0045a-upc:HIDDEN    = YES
               wh-btNext-2-im0045a-upc:SENSITIVE = NO 
               wh-btNext-2-im0045a-upc:VISIBLE   = NO.
                                                      
        CREATE BUTTON wh-btLast-2-aux-im0045a-upc     
        ASSIGN NAME      = wh-btLast-2-im0045a-upc:NAME + "-upc":U
               FRAME     = wh-btLast-2-im0045a-upc:FRAME
               COLUMN    = wh-btLast-2-im0045a-upc:COLUMN
               ROW       = wh-btLast-2-im0045a-upc:ROW
               WIDTH     = wh-btLast-2-im0045a-upc:WIDTH
               HEIGHT    = wh-btLast-2-im0045a-upc:HEIGHT
               LABEL     = wh-btLast-2-im0045a-upc:LABEL
               SENSITIVE = YES                        
               VISIBLE   = YES                        
               TRIGGERS:                              
                   ON "CHOOSE":U PERSISTENT RUN pi-choose-btLast-2 IN h-im0045a-upc.
               END TRIGGERS.                          
                                                      
        wh-btLast-2-aux-im0045a-upc:LOAD-IMAGE-UP(wh-btLast-2-im0045a-upc:IMAGE-UP).
        wh-btLast-2-aux-im0045a-upc:LOAD-IMAGE-DOWN(wh-btLast-2-im0045a-upc:IMAGE-DOWN).
        wh-btLast-2-aux-im0045a-upc:LOAD-IMAGE-INSENSITIVE(wh-btLast-2-im0045a-upc:IMAGE-INSENSITIVE).
                                                      
        ASSIGN wh-btLast-2-im0045a-upc:HIDDEN    = YES
               wh-btLast-2-im0045a-upc:SENSITIVE = NO 
               wh-btLast-2-im0045a-upc:VISIBLE   = NO.
    END.                                              
END.                                                  
                                                      
If  p-ind-event = "BEFORE-DISPLAY":U THEN DO:         
                                                      
    ASSIGN h-browser = p-wgh-frame:FIRST-CHILD.       
                                                      
    blk-main:                                         
    do  while valid-handle(h-browser):                
         IF  h-browser:TYPE <> "field-group" and      
             h-browser:TYPE <> "frame" THEN DO:       
             h-browser = h-browser:NEXT-SIBLING.      
         END.                                         
         ELSE DO:                                     
             IF  h-browser:TYPE = "FRAME" THEN DO:    
                 ASSIGN h-objeto-aux = h-browser:FIRST-CHILD.
                 do  while valid-handle(h-objeto-aux):
                     IF   h-objeto-aux:TYPE <> "field-group" and
                          h-objeto-aux:TYPE <> "frame" THEN DO:
                                                      
                          IF  h-objeto-aux:NAME = "brSon3" THEN DO:
                                                      
                              ASSIGN h-browser = h-objeto-aux:HANDLE.
                                                      
                              ASSIGN hquery  = h-browser:QUERY
                                     hbuffer = hquery:GET-BUFFER-HANDLE(1).    
                                                      
                              /* Para evitar erro de se perder ao movimentar de um browse para outro */
                              ASSIGN h-browser-im0045a = h-browser
                                     hquery-im0045a    = hquery
                                     hbuffer-im0045a   = hbuffer.
                                
                              LEAVE blk-main.
                          END.
                          h-objeto-aux = h-objeto-aux:NEXT-SIBLING.
                     END.
                     ELSE DO:
                          h-objeto-aux = h-objeto-aux:FIRST-CHILD.
                     END.
                 END.
                 h-browser = h-browser:NEXT-SIBLING.
             END.
             ELSE h-browser = h-browser:FIRST-CHILD.
         END.
    END.

    IF  VALID-HANDLE(h-browser) THEN DO:
        h-data = h-browser:ADD-CALC-COLUMN("date", "99/99/9999", " ", "Data Entrega", 3).

        ON 'row-display':U OF h-browser PERSISTENT RUN upc\im0045a-upc.p (INPUT "ROW-DISPLAY",
                                                                          INPUT p-ind-object,
                                                                          INPUT p-wgh-object,
                                                                          INPUT p-wgh-frame, 
                                                                          INPUT p-cod-table, 
                                                                          INPUT p-row-table). 
    END. /* IF  VALID-HANDLE(h-browser) THEN DO: */
END.

IF  p-ind-event = "ROW-DISPLAY" THEN DO:
    RUN piAtualizaBrowse.
    RETURN "OK":U.
END. /* IF  p-ind-event = "ROW-DISPLAY" THEN DO: */

IF  p-ind-event = "CONSIST-CONTAB" THEN DO:
    ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD
           wh-objeto = wh-objeto:FIRST-CHILD
           h-buffer  = WIDGET-HANDLE(p-cod-table).

    CREATE QUERY h-query.
    h-query:SET-BUFFERS(h-buffer).
    h-query:QUERY-PREPARE("for each tt-embarque-imp").
    h-query:QUERY-OPEN.
    h-query:GET-FIRST().

    DO WHILE wh-objeto <> ?:
        IF  wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
            CASE wh-objeto:NAME:
                WHEN "brSon2":U THEN DO:
                    ASSIGN h-browser = wh-objeto:HANDLE.
                    ASSIGN hquery    = h-browser:QUERY
                           hbuffer   = hquery:GET-BUFFER-HANDLE(1).
                END.
            END CASE.

            ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
    END.

    IF  h-buffer:AVAILABLE THEN
        ASSIGN c-embarque    = h-buffer:BUFFER-FIELD("embarque"):BUFFER-VALUE
               c-cod-estabel = h-buffer:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE.

    IF  hbuffer:AVAILABLE THEN
        ASSIGN i-num-ordem   = hbuffer:BUFFER-FIELD("numero-ordem"):BUFFER-VALUE
               i-parcela     = hbuffer:BUFFER-FIELD("parcela"):BUFFER-VALUE.

    /** Chamado 674 **/
    IF CAN-FIND(FIRST recebimento NO-LOCK
                WHERE recebimento.numero-ordem = i-num-ordem
                  AND recebimento.parcela      = i-parcela) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Operaá∆o n∆o permitida!" + "~~" +
                                 "Parcela j† possui nota fiscal de entrada vinculada. Portanto n∆o pode ser desvinculada do embarque").
        RETURN "adm-error".
    END.
    /****/

    FOR FIRST pagamento-invoice
        WHERE pagamento-invoice.embarque = c-embarque NO-LOCK:
        FOR FIRST pagamento
            WHERE pagamento.nr-pagamento = pagamento-invoice.nr-pagamento NO-LOCK:
            IF pagamento.recebido-ap THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW",
                                   INPUT 17006,
                                   INPUT "Operaá∆o n∆o permitida!" + "~~" +
                                         "Este embarque est† vinculado a uma CI, entre em contato com o financeiro para que seja efetuada a liberaá∆o da CI.").
                RETURN "adm-error".
            END.
        END.
    END.
END.
/****/

IF p-ind-event  = "AFTER-DESTROY-INTERFACE":U AND
   p-ind-object = "CONTAINER":U               THEN DO:
    IF VALID-HANDLE(h-im0045a-upc) THEN
        DELETE OBJECT h-im0045a-upc.

    ASSIGN h-im0045a-upc = ?.

    IF VALID-HANDLE(wh-btNext-2-aux-im0045a-upc) THEN
        DELETE WIDGET wh-btNext-2-aux-im0045a-upc.

    ASSIGN wh-btNext-2-aux-im0045a-upc = ?.

    IF VALID-HANDLE(wh-btLast-2-aux-im0045a-upc) THEN
        DELETE WIDGET wh-btLast-2-aux-im0045a-upc.

    ASSIGN wh-btLast-2-aux-im0045a-upc = ?.

    ASSIGN wh-cod-estabel-im0045a-upc = ?
           wh-embarque-im0045a-upc    = ?
           wh-brSon1-im0045a-upc      = ?
           wh-brSon3-im0045a-upc      = ?
           wh-btNext-2-im0045a-upc    = ?
           wh-btLast-2-im0045a-upc    = ?.
END.

RETURN "OK":U.


PROCEDURE piAtualizaBrowse:
    
    IF  VALID-HANDLE(h-browser-im0045a) THEN DO:
        ASSIGN i2-nr-ordem   = hbuffer-im0045a:BUFFER-FIELD('numero-ordem'):BUFFER-VALUE
               i2-nr-parcela = hbuffer-im0045a:BUFFER-FIELD('parcela'):BUFFER-VALUE.

        FOR FIRST prazo-compra NO-LOCK
            WHERE prazo-compra.numero-ordem = i2-nr-ordem 
            AND   prazo-compra.parcela      = i2-nr-parcela:
    
            ASSIGN h-data:SCREEN-VALUE = STRING(prazo-compra.data-entrega).
        END. /* FOR FIRST prazo-compra NO-LOCK */

        RELEASE prazo-compra.
    END. /* IF  VALID-HANDLE(h-browser-im0045a) */

    RETURN "OK":U.

END PROCEDURE. /* PROCEDURE piAtualizaBrowse: */

PROCEDURE pi-choose-btNext-2 :
    DEFINE VARIABLE wh-browse          AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE c-tabela           AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE i-linha            AS INTEGER       NO-UNDO.
    DEFINE VARIABLE h-query            AS HANDLE        NO-UNDO.
    DEFINE VARIABLE c-query            AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE c-ordens-invalidas AS CHARACTER     NO-UNDO.

    EMPTY TEMP-TABLE tt-ordens-invalidas.

    IF  NOT wh-brSon1-im0045a-upc:HIDDEN 
    THEN ASSIGN wh-browse = wh-brSon1-im0045a-upc
                c-tabela  = "tt-ordem-compra":U.
    ELSE IF  NOT wh-brSon3-im0045a-upc:HIDDEN 
         THEN ASSIGN wh-browse = wh-brSon3-im0045a-upc
                     c-tabela  =  "tt-prazo-compra":U.
         ELSE ASSIGN wh-browse = ?
                     c-tabela  = "":U.

    IF  VALID-HANDLE(wh-browse) THEN DO:
        SESSION:SET-WAIT-STATE("GENERAL":U).

        FIND FIRST embarque-imp
            WHERE embarque-imp.cod-estabel = wh-cod-estabel-im0045a-upc:SCREEN-VALUE
              AND embarque-imp.embarque    = wh-embarque-im0045a-upc:SCREEN-VALUE NO-LOCK NO-ERROR.

        IF  AVAILABLE embarque-imp THEN DO:
            validacao:
            REPEAT:
                DO i-linha = 1 TO wh-browse:NUM-SELECTED-ROWS:
                    wh-browse:FETCH-SELECTED-ROW(i-linha).

                    CREATE QUERY h-query.

                    ASSIGN c-query = "FOR ":U.

                    IF NOT wh-brSon3-im0045a-upc:HIDDEN THEN DO:

                        h-query:ADD-BUFFER(BUFFER prazo-compra:HANDLE).

                        ASSIGN c-query = c-query + " EACH prazo-compra NO-LOCK ":U +
                                                   " WHERE prazo-compra.numero-ordem = ":U + TRIM(STRING(wh-browse:QUERY:GET-BUFFER-HANDLE(c-tabela):BUFFER-FIELD("numero-ordem":U):BUFFER-VALUE)) +
                                                   "   AND prazo-compra.parcela      = ":U + TRIM(STRING(wh-browse:QUERY:GET-BUFFER-HANDLE(c-tabela):BUFFER-FIELD("parcela":U):BUFFER-VALUE)) + ",":U.
                    END.

                    h-query:ADD-BUFFER(BUFFER ordem-compra:HANDLE).
                    
                    ASSIGN c-query = c-query + " FIRST ordem-compra NO-LOCK ":U +
                                               " WHERE ordem-compra.numero-ordem = ":U + trim(STRING(wh-browse:QUERY:GET-BUFFER-HANDLE(c-tabela):BUFFER-FIELD("numero-ordem":U):BUFFER-VALUE)) + ",":U.

                    h-query:ADD-BUFFER(BUFFER pedido-compr:HANDLE).

                    ASSIGN c-query = c-query + " FIRST pedido-compr NO-LOCK ":U +
                                               " WHERE pedido-compr.num-pedido  = ordem-compra.num-pedido ":U +
                                               "   AND pedido-compr.via-transp <> ":U + TRIM(STRING(embarque-imp.cod-via-transp)).

                    h-query:QUERY-PREPARE(c-query).
                    h-query:QUERY-OPEN().
                    h-query:GET-FIRST().

                    DO WHILE NOT h-query:QUERY-OFF-END:
                        wh-browse:DESELECT-SELECTED-ROW(i-linha).

                        CREATE tt-ordens-invalidas.
                        ASSIGN tt-ordens-invalidas.num-pedido   = pedido-compr.num-pedido
                               tt-ordens-invalidas.numero-ordem = ordem-compra.numero-ordem
                               tt-ordens-invalidas.via-transp   = pedido-compr.via-transp.

                        IF NOT wh-brSon3-im0045a-upc:HIDDEN THEN
                            ASSIGN tt-ordens-invalidas.parcela = prazo-compra.parcela.

                        h-query:GET-NEXT().

                        h-query:QUERY-CLOSE.

                        DELETE WIDGET h-query.
    
                        NEXT validacao.
                    END.

                    h-query:QUERY-CLOSE.

                    DELETE WIDGET h-query.
                END.

                LEAVE validacao.
            END.

            IF wh-browse:NUM-SELECTED-ROWS > 0 THEN
                APPLY "CHOOSE":U TO wh-btNext-2-im0045a-upc.

            ASSIGN c-ordens-invalidas = "":U.

            FOR EACH tt-ordens-invalidas:
                IF c-ordens-invalidas <> "":U THEN
                    ASSIGN c-ordens-invalidas = c-ordens-invalidas + CHR(10).

                IF tt-ordens-invalidas.parcela <> ? THEN
                    ASSIGN c-ordens-invalidas = c-ordens-invalidas + "- Pedido: ":U + TRIM(STRING(tt-ordens-invalidas.num-pedido, ">>>>>,>>9":U)) + " / Ord. Compra: ":U + TRIM(STRING(tt-ordens-invalidas.numero-ordem, "zzzzz9,99":U)) + " / Parc.: ":U + TRIM(STRING(tt-ordens-invalidas.parcela, ">>>>9":U)) + " / Via Transp.: ":U + TRIM({adinc/i01ad268.i 04 tt-ordens-invalidas.via-transp}).
                ELSE
                    ASSIGN c-ordens-invalidas = c-ordens-invalidas + "- Pedido: ":U + TRIM(STRING(tt-ordens-invalidas.num-pedido, ">>>>>,>>9":U)) + " / Ord. Compra: ":U + TRIM(STRING(tt-ordens-invalidas.numero-ordem, "zzzzz9,99":U)) + " / Via Transp.: ":U + TRIM({adinc/i01ad268.i 04 tt-ordens-invalidas.via-transp}).
            END.

            SESSION:SET-WAIT-STATE("":U).

            IF c-ordens-invalidas <> "":U THEN
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Existe(m) ordem(s) de compra com Via Transporte diferente do Embarque.":U +
                                         "~~":U +
                                         "A(s) ordem(s) abaixo est†(∆o) com o campo ~"Via Transporte~" diferente do Embarque (Via Transp.: ":U + TRIM({adinc/i01ad268.i 04 embarque-imp.cod-via-transp}) + "):":U + CHR(10) + CHR(10) + c-ordens-invalidas).
        END.
        ELSE DO:
            IF wh-browse:NUM-SELECTED-ROWS > 0 THEN
                APPLY "CHOOSE":U TO wh-btNext-2-im0045a-upc.
        END.
    END.
    ELSE DO:
        IF wh-browse:NUM-SELECTED-ROWS > 0 THEN
            APPLY "CHOOSE":U TO wh-btNext-2-im0045a-upc.
    END.

    ASSIGN wh-browse = ?.

    APPLY "ENTRY":U TO wh-btNext-2-aux-im0045a-upc.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-choose-btLast-2 :
    DEFINE VARIABLE wh-browse AS WIDGET-HANDLE NO-UNDO.

    IF NOT wh-brSon1-im0045a-upc:HIDDEN THEN
        ASSIGN wh-browse = wh-brSon1-im0045a-upc.
    ELSE IF NOT wh-brSon3-im0045a-upc:HIDDEN THEN
        ASSIGN wh-browse = wh-brSon3-im0045a-upc.
    ELSE
        ASSIGN wh-browse = ?.

    IF VALID-HANDLE(wh-browse) THEN DO:
        wh-browse:SELECT-ALL().

        ASSIGN wh-browse = ?.

        APPLY "CHOOSE":U TO wh-btNext-2-aux-im0045a-upc.

        APPLY "ENTRY":U TO wh-btLast-2-aux-im0045a-upc.
    END.
    ELSE DO:
        APPLY "CHOOSE":U TO wh-btLast-2-im0045a-upc.

        APPLY "ENTRY":U TO wh-btLast-2-aux-im0045a-upc.
    END.

    RETURN "OK":U.

END PROCEDURE.
