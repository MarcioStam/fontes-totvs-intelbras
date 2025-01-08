/*------------------------------------------------------------------------
    File        : CD0134-UPC.P
    Purpose     : UPC Manutená∆o Fam°lia Materiais.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQLWorks / Exponencial TI)
    Created     : Agosto de 2012
    Notes       : Revis∆o da UPC para a vers∆o 2.06B do Datasul EMS.
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE c-objeto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-frame  AS HANDLE      NO-UNDO.

DEFINE VARIABLE wgh-fPage1              AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wgh-deposito-pad        AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wgh-cod-unid-negoc      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wgh-oem                 AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wgh-variacao-perm       AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE wh-aux                  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-aux                   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-aux                   AS INTEGER     NO-UNDO.

DEFINE VARIABLE wh-cd0134-familia       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cd0134-espec         AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-boes294 AS HANDLE      NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE grw-int-familia-cd0134 AS ROWID NO-UNDO.


/* ***************************  Main Block  *************************** */

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).

/*
MESSAGE "EVENTO: ":U   p-ind-event      SKIP
        "OBJETO: ":U   p-ind-object     SKIP
        "NOME OBJ: ":U c-objeto         SKIP
        "FRAME: ":U    p-wgh-frame:NAME SKIP
        "TABELA: ":U   p-cod-table      SKIP
        "ROWID: ":U    STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

IF p-ind-event  = "BEFORE-INITIALIZE":U AND
   p-ind-object = "CONTAINER":U         THEN DO:
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:TYPE <> "FIELD-GROUP":U THEN DO:
            IF h-frame:NAME = "fPage1":U THEN DO:
                ASSIGN wgh-fPage1 = h-frame.
                LEAVE.
            END.

            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN h-frame = h-frame:FIRST-CHILD.
    END.

    IF VALID-HANDLE(wgh-fPage1) THEN DO:
        ASSIGN wgh-fPage1:BOX = NO.

        ASSIGN h-frame = wgh-fPage1:FIRST-CHILD
               h-frame = h-frame:FIRST-CHILD.
    
        DO WHILE VALID-HANDLE(h-frame):
            IF h-frame:TYPE <> "FIELD-GROUP":U THEN DO:
                CASE h-frame:NAME:
                    WHEN "c-cod-unid-negoc":U THEN ASSIGN wgh-cod-unid-negoc = h-frame.
                    WHEN "res-cq-comp":U      THEN ASSIGN h-frame:HEIGHT = 0.88 h-frame:ROW = 1.85 h-frame:SIDE-LABEL-HANDLE:ROW = h-frame:ROW.
                    WHEN "res-cq-fabri":U     THEN ASSIGN h-frame:HEIGHT = 0.88 h-frame:ROW = 2.80 h-frame:SIDE-LABEL-HANDLE:ROW = h-frame:ROW.
                    WHEN "res-for-comp":U     THEN ASSIGN h-frame:HEIGHT = 0.88 h-frame:ROW = 3.75 h-frame:SIDE-LABEL-HANDLE:ROW = h-frame:ROW.
                    WHEN "res-int-comp":U     THEN ASSIGN h-frame:HEIGHT = 0.88 h-frame:ROW = 4.70 h-frame:SIDE-LABEL-HANDLE:ROW = h-frame:ROW.
                    WHEN "ressup-fabri":U     THEN ASSIGN h-frame:HEIGHT = 0.88 h-frame:ROW = 5.65 h-frame:SIDE-LABEL-HANDLE:ROW = h-frame:ROW.
                    WHEN "lote-economi":U     THEN ASSIGN h-frame:HEIGHT = 0.88 h-frame:ROW = 6.60 h-frame:SIDE-LABEL-HANDLE:ROW = h-frame:ROW.
                    WHEN "lote-minimo":U      THEN ASSIGN h-frame:HEIGHT = 0.88 h-frame:ROW = 7.55 h-frame:SIDE-LABEL-HANDLE:ROW = h-frame:ROW.
                    WHEN "lote-multipl":U     THEN ASSIGN h-frame:HEIGHT = 0.88 h-frame:ROW = 8.50 h-frame:SIDE-LABEL-HANDLE:ROW = h-frame:ROW.
                    WHEN "variacao-perm":U    THEN ASSIGN h-frame:HEIGHT = 0.88 h-frame:ROW = 9.45 h-frame:SIDE-LABEL-HANDLE:ROW = h-frame:ROW wgh-variacao-perm = h-frame.
                END CASE.
    
                ASSIGN h-frame = h-frame:NEXT-SIBLING.
            END.
            ELSE
                ASSIGN h-frame = h-frame:FIRST-CHILD.
        END.

        CREATE TOGGLE-BOX wgh-oem
        ASSIGN NAME      = "wgh-oem":U
               FORMAT    = "Sim/N∆o":U
               FRAME     = wgh-fPage1
               WIDTH     = 10.00
               HEIGHT    =  0.70
               COLUMN    = 70.00
               ROW       =  1.08
               LABEL     = "OEM":U
               HELP      = "OEM?":U
               CHECKED   = NO
               VISIBLE   = YES
               SENSITIVE = NO.

        IF VALID-HANDLE(wgh-cod-unid-negoc) AND
           VALID-HANDLE(wgh-oem)            THEN
            wgh-oem:MOVE-AFTER-TAB-ITEM(wgh-cod-unid-negoc).
        
    END.

    ASSIGN h-frame                 = ?
           wgh-fPage1              = ?
           wgh-cod-unid-negoc      = ?
           wgh-oem                 = ?
           wgh-variacao-perm       = ?.
END.



if p-ind-event  = "AFTER-INITIALIZE" and 
   p-ind-object = "CONTAINER" then do:

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "bt-exp",
                     OUTPUT wh-aux).

    ASSIGN wh-aux:COL = wh-aux:COL + 2.

    ASSIGN c-aux = "btUpdate,btUndo,btCancel,btSave,bt-cc,bt-ce,bt-re".

    DO i-aux = 1 TO NUM-ENTRIES(c-aux, ","):

        RUN busca-handle(INPUT p-wgh-frame,
                         INPUT ENTRY(i-aux, c-aux, ","),
                         OUTPUT wh-aux).
    
        ASSIGN wh-aux:COL = wh-aux:COL - 4.

    END.

    create button wh-cd0134-familia
    assign flat-button   = YES
           frame         = p-wgh-frame 
           width         = wh-aux:WIDTH
           height        = wh-aux:HEIGHT
           row           = wh-aux:ROW
           col           = wh-aux:COLUMN + wh-aux:WIDTH
           visible       = yes
           sensitive     = yes
           tooltip       = "Fam°lia"
           triggers:
                on choose PERSISTENT run cpp/cp0104.w.
           end triggers.

    if wh-cd0134-familia:load-image("image/im-comments.bmp") then.
    if wh-cd0134-familia:load-image-down("image/im-comments.bmp") then.

    create button wh-cd0134-espec
    assign flat-button   = YES
           frame         = p-wgh-frame 
           width         = wh-aux:WIDTH
           height        = wh-aux:HEIGHT
           row           = wh-aux:ROW
           col           = wh-aux:COLUMN + wh-aux:WIDTH + wh-aux:WIDTH
           visible       = yes
           sensitive     = yes
           tooltip       = "Espec°ficos"
           triggers:
                on choose PERSISTENT run upc/cd0134-upca.p.
           end triggers.

    if wh-cd0134-espec:load-image("image/gr-lay.bmp") then.
    if wh-cd0134-espec:load-image-down("image/gr-lay.bmp") then.

END.


IF p-ind-event  = "AFTER-DISPLAY":U AND
   p-ind-object = "CONTAINER":U     AND
   p-cod-table  = "familia":U       THEN DO:
    FIND FIRST familia
        WHERE ROWID(familia) = p-row-table NO-LOCK NO-ERROR.

    IF AVAILABLE familia THEN DO:

        ASSIGN grw-int-familia-cd0134 = ?.

        FIND FIRST int-familia
            WHERE int-familia.fm-codigo = familia.fm-codigo EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE int-familia THEN DO:
            CREATE int-familia.
            ASSIGN int-familia.fm-codigo = familia.fm-codigo.
        END.

        ASSIGN grw-int-familia-cd0134 = ROWID(int-familia).
        
        RUN pi-upc-field.

        IF VALID-HANDLE(wgh-oem) THEN
            ASSIGN wgh-oem:CHECKED = int-familia.oem.

        ASSIGN wgh-oem = ?.

        FIND CURRENT int-familia NO-LOCK NO-ERROR.
    END.
END.

IF p-ind-event  = "AFTER-ENABLE":U AND
   p-ind-object = "CONTAINER":U    THEN DO:
    RUN pi-upc-field.

    IF VALID-HANDLE(wgh-oem) THEN
        ASSIGN wgh-oem:SENSITIVE = YES.

END.

IF p-ind-event  = "AFTER-DISABLE":U AND
   p-ind-object = "CONTAINER":U     THEN DO:
    RUN pi-upc-field.

    IF VALID-HANDLE(wgh-oem) THEN
        ASSIGN wgh-oem:SENSITIVE = NO.

    ASSIGN wgh-oem = ?.
END.

IF p-ind-event  = "AFTER-UPDATE":U AND
   p-ind-object = "CONTAINER":U    THEN DO:
    RUN pi-entry.

    IF VALID-HANDLE(wgh-deposito-pad) THEN
        APPLY "ENTRY":U TO wgh-deposito-pad.

    ASSIGN wgh-deposito-pad = ?.
END.

IF p-ind-event  = "AFTER-ASSIGN":U AND
   p-ind-object = "CONTAINER":U    AND
   p-cod-table  = "familia":U      THEN DO:
    FIND FIRST familia
        WHERE ROWID(familia) = p-row-table NO-ERROR.

    IF AVAILABLE familia THEN DO:
        FIND FIRST int-familia
            WHERE int-familia.fm-codigo = familia.fm-codigo EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE int-familia THEN DO:
            CREATE int-familia.
            ASSIGN int-familia.fm-codigo = familia.fm-codigo.
        END.

        RUN pi-upc-field.

        IF VALID-HANDLE(wgh-oem) THEN
            ASSIGN int-familia.oem = wgh-oem:CHECKED.

        ASSIGN wgh-oem = ?.
        
        FIND CURRENT int-familia NO-LOCK NO-ERROR.
    END.
END.

IF p-ind-event  = "AFTER-DESTROY-INTERFACE":U AND
   p-ind-object = "CONTAINER":U                THEN DO:
    RUN pi-upc-field.

    IF VALID-HANDLE(wgh-oem) THEN
        DELETE WIDGET wgh-oem.

    ASSIGN wgh-oem = ?.

END.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-upc-field :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:TYPE <> "FIELD-GROUP":U THEN DO:
            IF h-frame:NAME = "fPage1":U THEN DO:
                ASSIGN wgh-fPage1 = h-frame.
                LEAVE.
            END.

            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN h-frame = h-frame:FIRST-CHILD.
    END.

    IF VALID-HANDLE(wgh-fPage1) THEN DO:
        ASSIGN h-frame = wgh-fPage1:FIRST-CHILD
               h-frame = h-frame:FIRST-CHILD.
    
        DO WHILE VALID-HANDLE(h-frame):
            IF h-frame:TYPE <> "FIELD-GROUP":U THEN DO:
                CASE h-frame:NAME:
                    WHEN "wgh-oem":U                 THEN ASSIGN wgh-oem                 = h-frame.
                END CASE.
    
                ASSIGN h-frame = h-frame:NEXT-SIBLING.
            END.
            ELSE
                ASSIGN h-frame = h-frame:FIRST-CHILD.
        END.
    END.

    ASSIGN wgh-fPage1 = ?
           h-frame    = ?.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-entry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:TYPE <> "FIELD-GROUP":U THEN DO:
            IF h-frame:NAME = "fPage1":U THEN DO:
                ASSIGN wgh-fPage1 = h-frame.
                LEAVE.
            END.

            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN h-frame = h-frame:FIRST-CHILD.
    END.

    IF VALID-HANDLE(wgh-fPage1) THEN DO:
        ASSIGN h-frame = wgh-fPage1:FIRST-CHILD
               h-frame = h-frame:FIRST-CHILD.
    
        DO WHILE VALID-HANDLE(h-frame):
            IF h-frame:TYPE <> "FIELD-GROUP":U THEN DO:
                IF h-frame:NAME = "deposito-pad":U THEN DO:
                    ASSIGN wgh-deposito-pad = h-frame.
                    LEAVE.
                END.
    
                ASSIGN h-frame = h-frame:NEXT-SIBLING.
            END.
            ELSE
                ASSIGN h-frame = h-frame:FIRST-CHILD.
        END.
    END.

    ASSIGN wgh-fPage1 = ?
           h-frame    = ?.

    RETURN "OK":U.

END PROCEDURE.






PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.
    DEFINE VARIABLE h-prox AS HANDLE     NO-UNDO.


    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame
           h-prox = ?.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:

        IF NOT valid-handle(h-aux) AND
           NOT VALID-HANDLE(h-prox) THEN DO:

            ASSIGN h-aux = ?.
            LEAVE.

        END.

        IF NOT valid-handle(h-aux) THEN DO:
            ASSIGN h-aux = h-prox.
            ASSIGN h-prox = ?.
            NEXT.
        END.

        IF h-aux:NAME = "panel-frame" THEN DO:

            ASSIGN h-prox = h-aux:NEXT-SIBLING.
            ASSIGN h-aux = h-aux:FIRST-CHILD.
            ASSIGN h-aux = h-aux:FIRST-CHILD.

            NEXT.
            
        END.

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            
            IF NOT VALID-HANDLE(h-aux) THEN
                NEXT.

        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.

        

    END.

END.


