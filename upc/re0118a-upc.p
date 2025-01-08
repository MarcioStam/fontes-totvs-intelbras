/*******************************************************************************
#@# 
@programa: upc/re0118a-upc.p
@data:     11/04/2017
@autor:    Paulo Cesar Demiciano
@release:  DTS11
@objetivo: UPC para gravar a localiza»’o em branco
@versÊo:   1.00 - VersÊo Inicial
#@#
*******************************************************************************/

/*--- Defini»’o dos Par³metros ---*/
DEFINE INPUT PARAMETER p-ind-event    AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object   AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object   AS HANDLE             NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame    AS WIDGET-HANDLE      NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table    AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-row-table    AS ROWID              NO-UNDO.

/* Variÿveis Locais */
def var c-objeto                as char          no-undo.

DEF NEW GLOBAL SHARED VAR h-upc-re0118a           AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-fpage1-re0118a                  AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-fpage2-re0118a                  AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-fpage4-re0118a                  AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-sav-re0118a                  AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-inc-lote-re0118a             AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-inc-lote-re0118aNew          AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-desc-item-re0118a               AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-deposito-re0118a            AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-localiz-re0118a             AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-lote-fabrican-re0118a       AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-dat-valid-lote-fabrican-re0118a AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-dat-fabricc-lote-re0118a        AS WIDGET-HANDLE   NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-it-codigo-re0118a               AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-class-fiscal-re0118a            AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-it-codigo-new-re0118a           AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa                        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-prog-re0118a                   AS WIDGET-HANDLE   NO-UNDO.


DEF BUFFER b-item-doc-orig-nfe FOR item-doc-orig-nfe.
DEF BUFFER b-item FOR ITEM.

/* message 'Nome progrm: ' c-objeto                      skip */
/*      'Nome evento: ' p-ind-Event                   skip    */
/*      'Nome objeto: ' p-ind-object                  skip    */
/*      'WHO:         ' string ( p-wgh-object )       skip    */
/*      'WHF:         ' string ( p-wgh-frame )        skip    */
/*      'WHF Nome:    ' string ( p-wgh-frame:name )   skip    */
/*      'Nome tabela: ' p-cod-table                   skip    */
/*      'RowiD tabela: ' string ( p-row-table )               */
/*      view-as alert-box.                                    */


assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").


IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    ASSIGN wh-prog-re0118a = p-wgh-object.
    RUN upc/re0118a-upc.p PERSISTENT SET h-upc-re0118a(INPUT "",            
                                                     INPUT "",            
                                                     INPUT p-wgh-object,  
                                                     INPUT p-wgh-frame,   
                                                     INPUT "",            
                                                     INPUT p-row-table).
END.

IF p-ind-event = "after-habilitaCamposItemConEst" THEN DO:
    IF VALID-HANDLE(wh-it-codigo-new-re0118a) THEN DO:
        ASSIGN wh-it-codigo-new-re0118a:SCREEN-VALUE = wh-it-codigo-re0118a:SCREEN-VALUE.
    END.
END.

IF p-ind-event = "BEFORE-SAVE-FIELDS" THEN DO:
    FIND FIRST b-item-doc-orig-nfe NO-LOCK
         WHERE ROWID(b-item-doc-orig-nfe) = p-row-table NO-ERROR.
    IF AVAIL b-item-doc-orig-nfe THEN DO:
        FIND FIRST b-item NO-LOCK
             WHERE b-item.it-codigo = wh-it-codigo-re0118a:screen-value NO-ERROR.
            
        IF AVAIL b-item THEN DO:
      
           IF b-item.tipo-con-est = 3 THEN DO: /* Item Controlado por Lote */
              IF wh-cod-deposito-re0118a:SCREEN-VALUE = "" THEN DO:
              
                  APPLY "CHOOSE" TO wh-bt-inc-lote-re0118a.

                  IF b-item-doc-orig-nfe.nat-operacao = "112400" OR 
                     b-item-doc-orig-nfe.nat-operacao = "212401" OR
                     b-item-doc-orig-nfe.nat-operacao = "212400" THEN
                     ASSIGN wh-cod-deposito-re0118a:SCREEN-VALUE = "LOG".
                  
                  ASSIGN wh-cod-localiz-re0118a            :SCREEN-VALUE = ""
                         wh-cod-lote-fabrican-re0118a      :SCREEN-VALUE = "GENERICO"
                         wh-dat-valid-lote-fabrican-re0118a:SCREEN-VALUE = "31/12/9999"
                         wh-dat-fabricc-lote-re0118a       :SCREEN-VALUE = STRING(TODAY).

                  APPLY "CHOOSE" TO wh-bt-sav-re0118a.
               END.
            END.
        END.
    END.
END.

IF p-ind-event = "destroy" AND VALID-HANDLE(h-upc-re0118a) THEN
    DELETE PROCEDURE h-upc-re0118a.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "BEFORE-INITIALIZE" THEN DO:

    /*fPage1*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "frame",       /*** Type ***/
                  INPUT "fPage1",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-fpage1-re0118a).

    /*fPage2*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "frame",       /*** Type ***/
                  INPUT "fPage2",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-fpage2-re0118a).

    /*fPage4*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "frame",       /*** Type ***/
                  INPUT "fPage4",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-fpage4-re0118a).

    IF VALID-HANDLE(wh-fpage1-re0118a) THEN DO:

        RUN tela-upc (INPUT wh-fpage1-re0118a,
                      INPUT p-ind-Event,                                                       
                      INPUT "fill-in",       /*** Type ***/
                      INPUT "desc-item",      /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-desc-item-re0118a).

        ASSIGN wh-desc-item-re0118a:SENSITIVE = YES 
               wh-desc-item-re0118a:READ-ONLY = YES .
               
        RUN tela-upc (INPUT wh-fpage1-re0118a,
                      INPUT p-ind-Event,                                                       
                      INPUT "fill-in",       /*** Type ***/
                      INPUT "it-codigo",      /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 2,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-it-codigo-re0118a).

        IF VALID-HANDLE (wh-it-codigo-re0118a) THEN DO:
        
            CREATE FILL-IN wh-it-codigo-new-re0118a
            ASSIGN FRAME             = wh-it-codigo-re0118a:FRAME
                   DATA-TYPE         = wh-it-codigo-re0118a:DATA-TYPE
                   FORMAT            = wh-it-codigo-re0118a:FORMAT
                   WIDTH             = wh-it-codigo-re0118a:WIDTH
                   HEIGHT            = wh-it-codigo-re0118a:HEIGHT
                   ROW               = wh-it-codigo-re0118a:ROW
                   COLUMN            = wh-it-codigo-re0118a:COLUMN
                   HIDDEN            = wh-it-codigo-re0118a:HIDDEN
                   SIDE-LABEL-HANDLE = wh-it-codigo-re0118a:SIDE-LABEL-HANDLE
                   HELP              = wh-it-codigo-re0118a:HELP
                   TOOLTIP           = wh-it-codigo-re0118a:TOOLTIP
                   BGCOLOR           = 14                   FGCOLOR           = wh-it-codigo-re0118a:FGCOLOR
                   SENSITIVE         = wh-it-codigo-re0118a:SENSITIVE
                   VISIBLE           = YES.

            wh-it-codigo-new-re0118a:LOAD-MOUSE-POINTER('image/lupa.cur').

            ASSIGN wh-it-codigo-re0118a:SENSITIVE = NO.
            wh-it-codigo-new-re0118a:MOVE-TO-TOP().
            ASSIGN wh-it-codigo-new-re0118a:SCREEN-VALUE =  wh-it-codigo-re0118a:SCREEN-VALUE.

            ON "LEAVE":U OF wh-it-codigo-new-re0118a PERSISTENT RUN pi-leave-it-codigo IN h-upc-re0118a.
            ON "F5":U OF wh-it-codigo-new-re0118a PERSISTENT RUN upc/re0118azoom-upc.p.
            ON "MOUSE-SELECT-DBLCLICK" OF wh-it-codigo-new-re0118a PERSISTENT RUN upc/re0118azoom-upc.p.
        END.
       
    END.

    IF VALID-HANDLE(wh-fpage2-re0118a) THEN DO:
        RUN tela-upc (INPUT wh-fpage2-re0118a,
                      INPUT p-ind-Event,                                                       
                      INPUT "fill-in",              /*** Type ***/
                      INPUT "class-fiscal",      /*** Name ***/
                      INPUT NO,                     /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,                      /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-class-fiscal-re0118a).
    END.

    IF VALID-HANDLE(wh-fpage4-re0118a) THEN DO:
        RUN tela-upc (INPUT wh-fpage4-re0118a,
                      INPUT p-ind-Event,                                                       
                      INPUT "fill-in",              /*** Type ***/
                      INPUT "fi-cod-deposito",      /*** Name ***/
                      INPUT NO,                     /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,                      /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-cod-deposito-re0118a).

        RUN tela-upc (INPUT wh-fpage4-re0118a,
                      INPUT p-ind-Event,                                                       
                      INPUT "fill-in",             /*** Type ***/
                      INPUT "fi-cod-localiz",      /*** Name ***/
                      INPUT NO,                    /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,                     /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-cod-localiz-re0118a).

        RUN tela-upc (INPUT wh-fpage4-re0118a,
                      INPUT p-ind-Event,                                                       
                      INPUT "fill-in",                   /*** Type ***/
                      INPUT "fi-cod-lote-fabrican",      /*** Name ***/
                      INPUT NO,                          /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,                           /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-cod-lote-fabrican-re0118a).

        RUN tela-upc (INPUT wh-fpage4-re0118a,
                      INPUT p-ind-Event,                                                       
                      INPUT "fill-in",                         /*** Type ***/
                      INPUT "fi-dat-valid-lote-fabrican",      /*** Name ***/
                      INPUT NO,                                /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,                                 /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-dat-valid-lote-fabrican-re0118a).

        RUN tela-upc (INPUT wh-fpage4-re0118a,
                      INPUT p-ind-Event,                                                       
                      INPUT "fill-in",                         /*** Type ***/
                      INPUT "fi-dat-fabricc-lote",             /*** Name ***/
                      INPUT NO,                                /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,                                 /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-dat-fabricc-lote-re0118a).

        RUN tela-upc (INPUT wh-fpage4-re0118a,
                      INPUT p-ind-Event,                                                       
                      INPUT "BUTTON",        /*** Type ***/
                      INPUT "bt-sav",      /*** Name ***/
                      INPUT NO,               /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,                /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-bt-sav-re0118a).

        RUN tela-upc (INPUT wh-fpage4-re0118a,
                      INPUT p-ind-Event,                                                       
                      INPUT "BUTTON",         /*** Type ***/
                      INPUT "bt-inc-lote",    /*** Name ***/
                      INPUT NO,               /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,                /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-bt-inc-lote-re0118a).

        IF VALID-HANDLE(wh-bt-inc-lote-re0118a) THEN
        DO:
            CREATE BUTTON wh-bt-inc-lote-re0118aNew
            ASSIGN FRAME     = wh-bt-inc-lote-re0118a:FRAME
                   WIDTH     = wh-bt-inc-lote-re0118a:WIDTH
                   HEIGHT    = wh-bt-inc-lote-re0118a:HEIGHT
                   ROW       = wh-bt-inc-lote-re0118a:ROW
                   LABEL     = wh-bt-inc-lote-re0118a:LABEL
                   COL       = wh-bt-inc-lote-re0118a:COL
                   SENSITIVE = wh-bt-inc-lote-re0118a:SENSITIVE
                   VISIBLE   = YES.
                   wh-bt-inc-lote-re0118aNew:LOAD-IMAGE-UP(wh-bt-inc-lote-re0118a:IMAGE-UP).
                   wh-bt-inc-lote-re0118aNew:LOAD-IMAGE-INSENSITIVE(wh-bt-inc-lote-re0118a:IMAGE-INSENSITIVE).
        
            ON "CHOOSE" OF wh-bt-inc-lote-re0118aNew PERSISTENT RUN piBtIncLote IN h-upc-re0118a.
        END.

    END.
END.

IF p-ind-event = "before-bt-save" THEN DO:
    APPLY "LEAVE" TO wh-it-codigo-new-re0118a.
END.
    

IF p-ind-event = "after-habilitaCamposItemConEst" THEN DO:
   ASSIGN wh-bt-inc-lote-re0118aNew:SENSITIVE = wh-bt-inc-lote-re0118a:SENSITIVE.
   
END.


IF p-ind-event = "AFTER-ENABLE" THEN DO:
    ASSIGN wh-it-codigo-new-re0118a:SENSITIVE = YES
           wh-it-codigo-re0118a:SENSITIVE = NO.
END.

IF p-ind-event = "AFTER-DISABLE" THEN DO:
    ASSIGN wh-it-codigo-new-re0118a:SENSITIVE = NO
           wh-it-codigo-re0118a:SENSITIVE = NO.
END.

IF p-ind-event = "AFTER-INITIALIZE"
OR p-ind-event = "AFTER-CANCEL"  
OR p-ind-event = "BEFORE-CONTROL-TOOL-BAR" THEN DO:
    ASSIGN wh-it-codigo-new-re0118a:SCREEN-VALUE = wh-it-codigo-re0118a:SCREEN-VALUE.
END.

PROCEDURE piBtIncLote:
   FIND FIRST b-item NO-LOCK
        WHERE b-item.it-codigo = wh-it-codigo-re0118a:screen-value NO-ERROR.
   IF AVAIL b-item THEN DO:
      IF b-item.tipo-con-est = 3 THEN DO: /* Item Controlado por Lote */
         IF wh-cod-deposito-re0118a:SCREEN-VALUE = "" THEN DO:
             ASSIGN wh-cod-localiz-re0118a            :SCREEN-VALUE = ""
                    wh-cod-lote-fabrican-re0118a      :SCREEN-VALUE = "GENERICO"
                    wh-dat-valid-lote-fabrican-re0118a:SCREEN-VALUE = "31/12/9999".
          END.
       END.
   END.

APPLY 'choose' TO wh-bt-inc-lote-re0118a.
END PROCEDURE. 

PROCEDURE tela-upc:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):                                

        IF pApresMsg = YES THEN                                    
            MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP             
                    "Type do Objeto" wgh-obj:TYPE SKIP             
                    "P-Ind-Event"    pIndEvent VIEW-AS ALERT-BOX.  

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.

            IF i-aux = pAux THEN
                LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.
END PROCEDURE.

/* Comentado para deixar o registro do que tinha antes na UPC - Nicol s
def input parameter p-ind-event  as char           no-undo.
def input parameter p-ind-object as char           no-undo.
def input parameter p-wgh-object as handle         no-undo.
def input parameter p-wgh-frame  as widget-handle  no-undo.
def input parameter p-cod-table  as char           no-undo.
def input parameter p-row-table  as rowid          no-undo.

if p-ind-event  = "before-bt-save" AND p-ind-object = "button" THEN DO:

     find first item-doc-orig-nfe exclusive-lock 
                where rowid(item-doc-orig-nfe)  = p-row-table no-error.

     IF AVAIL item-doc-orig-nfe THEN DO:

         ASSIGN item-doc-orig-nfe.cod-localiz = "".

     END.
    
END.
*/
PROCEDURE pi-leave-it-codigo:
    ASSIGN wh-it-codigo-re0118a:SCREEN-VALUE = wh-it-codigo-new-re0118a:SCREEN-VALUE.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = wh-it-codigo-re0118a:SCREEN-VALUE NO-ERROR.

    IF AVAIL ITEM 
    AND item.tipo-contr <> 4
    AND VALID-HANDLE (wh-class-fiscal-re0118a) THEN DO:
        ASSIGN wh-class-fiscal-re0118a:SCREEN-VALUE = ITEM.class-fiscal.
        APPLY "LEAVE" TO wh-class-fiscal-re0118a.
    END.

    APPLY "leave" TO wh-it-codigo-re0118a.
END PROCEDURE.
