/***********************************************************************
**  Programa..: upc\cd0603-upc.p
**  Autor.....: Raphael Matei Paini
**  Data......: 10/11/2009
**  Descricao.: UPC - Destaque NCM
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.
{utp\ut-glob.i}

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.

IF p-wgh-object <> ? THEN
    assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

DEFINE NEW GLOBAL SHARED VAR wh-button-upc-cd0603a AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR h-upc-cd0603           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-PanelFrame-cd0603   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-class-fiscal-cd0603 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-inss-faturamento-cd0603 AS WIDGET-HANDLE NO-UNDO.




/* MESSAGE 'p-ind-event  ' p-ind-event  SKIP        */
/*         'p-ind-object ' p-ind-object SKIP        */
/*         'p-cod-table  ' p-cod-table  SKIP        */
/*         'p-row-table  ' string(p-row-table) SKIP */
/*         'c-objeto     ' c-objeto                 */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.           */


/****************************  Variaveis    ****************************/

IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/cd0603-upc.p PERSISTENT SET h-upc-cd0603(INPUT "",            
                                                       INPUT "",            
                                                       INPUT p-wgh-object,  
                                                       INPUT p-wgh-frame,   
                                                       INPUT "",            
                                                       INPUT p-row-table).  
END.

IF  p-ind-event = "destroy" THEN
    IF VALID-HANDLE(h-upc-cd0603) THEN
        DELETE PROCEDURE h-upc-cd0603.


IF p-ind-object = "VIEWER"      AND
   c-objeto     = "v02in046.w"  THEN DO:

    IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:
        /*class-fiscal*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",      /*** Type ***/
                      INPUT "class-fiscal", /*** Name ***/
                      INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-class-fiscal-cd0603).
    END.
    ELSE IF p-ind-event = "after-enable" THEN DO:
        ASSIGN wh-button-upc-cd0603a:SENSITIVE = FALSE.

    END.
    ELSE IF p-ind-event = "after-disable" THEN DO:
        ASSIGN wh-button-upc-cd0603a:SENSITIVE = TRUE.
    END.
END.

/*     RUN tela-upc (INPUT p-wgh-frame,                                                                */
/*                   INPUT p-ind-Event,                                                                */
/*                   INPUT "toggle-box",      /*** Type ***/                                           */
/*                   INPUT "log-1", /*** Name ***/                                                     */
/*                   INPUT YES,             /*** Apresenta Mensagem dos Objetos ***/                   */
/*                   INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/ */
/*                   OUTPUT wh-class-fiscal-cd0603).                                                   */
/*                                                                                                     */

IF p-ind-event  = "INITIALIZE":U AND
   p-ind-object = "VIEWER":U     AND
   c-objeto       = "v06in046.w":U THEN DO:
  
   

    CREATE TOGGLE-BOX wh-inss-faturamento-cd0603
    ASSIGN FRAME     = p-wgh-frame
           COLUMN    = 30.00
           ROW       = 3.17
           WIDTH     = 21.00
           HEIGHT    = 0.88
           LABEL     = "INSS s/Faturamento":U
           SENSITIVE = NO
           VISIBLE   = YES.
    FIND FIRST classif-fisc
        WHERE ROWID(classif-fisc) = p-row-table NO-ERROR.
    IF AVAIL classif-fisc THEN DO:
        FIND int-classif-fisc
             WHERE int-classif-fisc.class-fiscal = classif-fisc.class-fiscal
            NO-LOCK NO-ERROR.
        IF NOT AVAIL int-classif-fisc THEN DO:
           CREATE int-classif-fisc.
           ASSIGN int-classif-fisc.class-fiscal = classif-fisc.class-fiscal
                  int-classif-fisc.inss-faturamento = NO.
        END.

        ASSIGN wh-inss-faturamento-cd0603:CHECKED = int-classif-fisc.inss-faturamento.
    END.
END.

IF  p-ind-event = "DISPLAY"
AND c-objeto      = "v06in046.w" THEN DO:

    FIND FIRST classif-fisc
        WHERE ROWID(classif-fisc) = p-row-table NO-ERROR.
    IF AVAIL classif-fisc THEN DO:
        FIND int-classif-fisc
             WHERE int-classif-fisc.class-fiscal = classif-fisc.class-fiscal
            NO-LOCK NO-ERROR.
        IF NOT AVAIL int-classif-fisc THEN DO:
           CREATE int-classif-fisc.
           ASSIGN int-classif-fisc.class-fiscal = classif-fisc.class-fiscal
                  int-classif-fisc.inss-faturamento = NO.
        END.
        
        IF VALID-HANDLE(wh-inss-faturamento-cd0603) THEN
            ASSIGN wh-inss-faturamento-cd0603:CHECKED = int-classif-fisc.inss-faturamento.
    END.
END.
IF  p-ind-event = "ASSIGN"
AND c-objeto      = "v06in046.w" THEN DO:

    FIND FIRST classif-fisc
        WHERE ROWID(classif-fisc) = p-row-table NO-ERROR.
    IF AVAIL classif-fisc THEN DO:
        FIND int-classif-fisc
             WHERE int-classif-fisc.class-fiscal = classif-fisc.class-fiscal
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL int-classif-fisc THEN DO:
           CREATE int-classif-fisc.
           ASSIGN int-classif-fisc.class-fiscal = classif-fisc.class-fiscal
                  int-classif-fisc.inss-faturamento = NO.
        END.
        ASSIGN int-classif-fisc.inss-faturamento = wh-inss-faturamento-cd0603:CHECKED.
    END.
END.
IF  p-ind-event  = "ENABLE"
AND c-objeto       = "v06in046.w" THEN do:

    assign wh-inss-faturamento-cd0603:SENSITIVE = YES.    
end.
IF  p-ind-event  = "DISABLE"
AND c-objeto       = "v06in046.w" THEN do:

    assign wh-inss-faturamento-cd0603:SENSITIVE = NO.    
end.

if p-ind-event  = "INITIALIZE" and 
   p-ind-object = "CONTAINER" then do:

    CREATE BUTTON wh-button-upc-cd0603a
    ASSIGN FRAME     = p-wgh-frame
           WIDTH     = 4.00  
           HEIGHT    = 1.25  
           ROW       = 1.32  
           COL       = 60.32 
           LABEL     = ""
           SENSITIVE = YES /* whBtExportaTela-cd0603:SENSITIVE */
           VISIBLE   = YES /* whBtExportaTela-cd0603:VISIBLE */
           tooltip   = "Destaques NCM"
    TRIGGERS:
        ON CHOOSE PERSISTENT RUN pi-chama-destaques IN h-upc-cd0603.
    END TRIGGERS.

    if wh-button-upc-cd0603a:load-image("image/gr-lay.bmp") then.

    wh-button-upc-cd0603a:MOVE-TO-TOP().
END.

PROCEDURE pi-chama-destaques:

    FIND FIRST classif-fisc NO-LOCK
         WHERE classif-fisc.class-fiscal = REPLACE(wh-class-fiscal-cd0603:SCREEN-VALUE,".","") NO-ERROR.
    IF AVAIL classif-fisc THEN DO:
        run upc/cd0603a-upc.w(INPUT classif-fisc.class-fiscal,
                              INPUT classif-fisc.descricao).
    END.
    ELSE DO:
        MESSAGE "Classificaá∆o Fiscal " wh-class-fiscal-cd0603:SCREEN-VALUE " n∆o cadastrada!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
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

