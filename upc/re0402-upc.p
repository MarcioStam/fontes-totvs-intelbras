/*************************************************************************
**    Programa.:  upc-wm0115
**    Objetivo.:  UPC para Incluir campo de controle Movimento Zim
**    Data.....:  Maio de 2015
*************************************************************************/
/*********************** Definicao de Parametros *************************/
define input parameter p-ind-event               as character      no-undo.
define input parameter p-ind-object              as character      no-undo.
define input parameter p-wgh-object              as handle         no-undo.
define input parameter p-wgh-frame               as widget-handle  no-undo.
define input parameter p-cod-table               as character      no-undo.
define input parameter p-row-table               as rowid          no-undo.

DEFINE VARIABLE wh-objeto             AS HANDLE  NO-UNDO.
DEFINE VARIABLE c-char                AS CHAR    NO-UNDO.
DEFINE VARIABLE h-frame               AS HANDLE  NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario         AS character NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-objeto-0402        AS widget-handle NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-executar-re0402 AS HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-new-bt-executar    AS HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-page-dig            AS HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-tt-dig              AS HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-br-dig              AS HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-upc-program-0402    AS HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-l-des-wms           AS HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-l-desatual-nf       AS HANDLE  NO-UNDO.


ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"),
                                  p-wgh-object:FILE-NAME,"~/") NO-ERROR.

/************************************************************************/
/*Functions*/
FUNCTION getObject RETURNS HANDLE (pFrame AS HANDLE, pObj AS CHAR).
    DEFINE VARIABLE hHdl AS HANDLE NO-UNDO.

    ASSIGN hHdl = pFrame:FIRST-CHILD
           hHdl = hHdl:FIRST-CHILD.

    DO WHILE VALID-HANDLE(hHdl):
        
        IF hHdl:NAME = pObj THEN LEAVE.
        hHdl = hHdl:NEXT-SIBLING.
    END.

    RETURN IF VALID-HANDLE(hHdl) THEN hHdl ELSE ?.
END FUNCTION.
/************************************************************************/

IF p-ind-event  = "BEFORE-INITIALIZE" THEN DO: 

    IF NOT VALID-HANDLE(h-upc-program-0402) THEN 
        RUN upc\re0402-upc.p PERSISTENT SET h-upc-program-0402 (INPUT "",
                                                                INPUT "",
                                                                INPUT p-wgh-object,
                                                                INPUT p-wgh-frame,
                                                                INPUT "",                                                          
                                                                INPUT p-row-table).
END.
/************************************************************************/
CASE p-ind-event:
    WHEN "INITIALIZE":U THEN 
        RUN pi-inicializa.
    WHEN "CHANGE-PAGE" THEN
        RUN piAlteraFrame.
END CASE.
ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
       h-frame = h-frame:FIRST-CHILD.

RETURN "OK".

/************************************************************************/
PROCEDURE pi-inicializa:

    ASSIGN wh-bt-executar-re0402  = getObject(p-wgh-frame,"bt-executar":U)
           h-page-dig             = getObject(p-wgh-frame,"f-pg-dig":U)
           h-br-dig               = getObject(h-page-dig,"br-digita":U).

    IF VALID-HANDLE(wh-bt-executar-re0402) THEN DO:

        CREATE BUTTON wh-new-bt-executar
        ASSIGN FRAME     = wh-bt-executar-re0402:FRAME
               ROW       = wh-bt-executar-re0402:ROW 
               COLUMN    = wh-bt-executar-re0402:COLUMN  
               HEIGHT    = wh-bt-executar-re0402:HEIGHT 
               WIDTH     = wh-bt-executar-re0402:WIDTH 
               TOOLTIP   = wh-bt-executar-re0402:TOOLTIP
               HELP      = wh-bt-executar-re0402:HELP
               LABEL     = wh-bt-executar-re0402:LABEL
               SENSITIVE = YES 
               VISIBLE   = wh-bt-executar-re0402:VISIBLE
               TRIGGERS:
                   ON CHOOSE PERSISTENT RUN pi-botao-executa IN h-upc-program-0402.
               END TRIGGERS.
               
        wh-new-bt-executar:MOVE-TO-TOP().

    END.
    
    RETURN "OK".

END PROCEDURE.
/************************************************************************/
PROCEDURE pi-botao-executa:
   IF h-br-dig:NUM-ENTRIES = 0 THEN DO:
       RUN utp/ut-msgs.p (INPUT "show":U, 
                          INPUT 17006, 
                          INPUT "NÆo h  Informa‡Æo no Pasta de Digita‡Æo.~~Informe os Dados da Nota que Deseja Desatualizar.").
        RETURN "NOK".    
   END.
   ELSE
       APPLY "CHOOSE":U TO wh-bt-executar-re0402.
END PROCEDURE.


PROCEDURE piAlteraFrame:
    IF p-wgh-frame:NAME = "f-pg-par" 
    THEN DO:
        ASSIGN h-l-des-wms = getObject(p-wgh-frame,"l-desatualiza-wms":U).

        IF VALID-HANDLE(h-l-des-wms) THEN
            ASSIGN h-l-des-wms:SCREEN-VALUE = "Yes".

        /* Chamado 74282 */
        ASSIGN h-l-desatual-nf = getObject(p-wgh-frame,"l-desatual":U).

        /*IF  VALID-HANDLE(h-l-desatual-nf)
        THEN DO:
            ASSIGN h-l-desatual-nf:SENSITIVE = NO.
            ASSIGN h-l-desatual-nf:CHECKED   = NO.
        END.*/
    END.
END PROCEDURE.
