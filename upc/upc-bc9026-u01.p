/*****************************************************************************************
** PROGRAMA.: upc-bc9026-u01
** OBJETIVO.: Chamada de UPC - ImpressÆo de etiquetas conforme impressora escolhida
** AUTOR....: VISUS / SCM Concept
** DATA.....: MAIO/2022
******************************************************************************************/
/*{ esinc/bco_ems2_ems5.i }*/
{include/i-prgvrs.i upc-bc9026-u01 12.1.4.000}
{ utp/ut-glob.i }

/* Variaveis de Parƒmetros */ 
DEFINE INPUT PARAMETER p-ind-event   AS CHAR.
DEFINE INPUT PARAMETER p-ind-object  AS CHAR.
DEFINE INPUT PARAMETER p-wgh-object  AS HANDLE.
DEFINE INPUT PARAMETER p-wgh-frame   AS WIDGET-HANDLE.
DEFINE INPUT PARAMETER p-cod-table   AS CHAR.
DEFINE INPUT PARAMETER p-row-table   AS ROWID.

DEFINE VARIABLE c-handle-obj       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-objeto           AS CHARACTER   NO-UNDO.
                                             
{upc/upc-bc9026-u01.i}

DEFINE NEW GLOBAL SHARED VARIABLE g-imp-impressora-bc9026 AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE g-log-troca-imp-bc9026  AS LOGICAL NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-upcbc90261                     AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-op             AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-it             AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-dc             AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-rf             AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-op-falso       AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-it-falso       AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-dc-falso       AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-rf-falso       AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-todos-op       AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-todos-it       AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-todos-dc       AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-todos-rf       AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-todos-op-falso AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-todos-it-falso AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-todos-dc-falso AS WIDGET-HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-bt-imprimir-todos-rf-falso AS WIDGET-HANDLE      NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-bc9026-fpage2 AS HANDLE NO-UNDO.

DEF VAR h-frame1  AS HANDLE NO-UNDO.
DEF VAR wh-frame1 AS HANDLE NO-UNDO.
DEF VAR h-frame2  AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE c-cod-impress AS CHARACTER   NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/").

FUNCTION fc-handle-obj RETURN CHARACTER (p-obj AS CHARACTER, p-frame AS WIDGET-HANDLE) FORWARD.


/* MESSAGE SELF SKIP                                                     */
/*         "1) Teste de Pontos de UPC"                             SKIP  */
/*         "2) p-ind-event....:" string(p-ind-event )              SKIP  */
/*         "3) p-ind-object...:" string(p-ind-object)              SKIP  */
/*         "4) p-wgh-object...:" string(p-wgh-object)              SKIP  */
/*         "4.1) p-wgh-object.:" string(p-wgh-object:file-name)    SKIP  */
/*         "5) p-wgh-frame....:" string(p-wgh-frame )              SKIP  */
/*         "6) p-cod-table....:" string(p-cod-table )              SKIP  */
/*         "7) p-row-table....:" string(p-row-table )              SKIP  */
/*         "8) self:type......:" self:type                         SKIP  */
/*         "9) self:frame-name:" self:frame-name                   SKIP  */
/*         "10)self:name......:" self:name                         SKIP  */
/*         "11)nome programa..:" PROGRAM-NAME(0)                   SKIP  */
/*         "12)nome programa..:" PROGRAM-NAME(1)                   SKIP  */
/*         "13)nome programa..:" PROGRAM-NAME(2)                   SKIP  */
/*         "14)nome programa..:" PROGRAM-NAME(3)                   SKIP  */
/*         "15)nome programa..:" PROGRAM-NAME(4)                   SKIP  */
/*         "16)nome programa..:" PROGRAM-NAME(5)                   SKIP  */
/*         "17) " self:SCREEN-VALUE                                 SKIP */
/*         "18) " FRAME-VALUE                                            */
/*         VIEW-AS ALERT-BOX .                                           */




IF p-ind-event = "after-INITIALIZE" AND p-ind-object = "CONTAINER" THEN DO:

    ASSIGN c-handle-obj = fc-handle-obj("bt-imprimir-op,bt-imprimir-it,bt-imprimir-dc,bt-imprimir-rf", p-wgh-frame).
    ASSIGN h-bt-imprimir-op = WIDGET-HANDLE(ENTRY(1,c-handle-obj)) 
           h-bt-imprimir-it = WIDGET-HANDLE(ENTRY(2,c-handle-obj)) 
           h-bt-imprimir-dc = WIDGET-HANDLE(ENTRY(3,c-handle-obj)) 
           h-bt-imprimir-rf = WIDGET-HANDLE(ENTRY(4,c-handle-obj)) NO-ERROR.

    
    IF VALID-HANDLE(h-bt-imprimir-op) THEN DO:

        CREATE BUTTON h-bt-imprimir-op-falso
        ASSIGN FRAME       = h-bt-imprimir-op:FRAME
               WIDTH       = h-bt-imprimir-op:WIDTH
               HEIGHT      = h-bt-imprimir-op:HEIGHT
               LABEL       = h-bt-imprimir-op:LABEL
               ROW         = h-bt-imprimir-op:ROW 
               COLUMN      = h-bt-imprimir-op:COLUMN  
               NAME        = "h-bt-imprimir-op-falso"
               SENSITIVE   = YES /*h-bt-imprimir-op:SENSITIVE*/
               VISIBLE     = YES /*h-bt-imprimir-op:VISIBLE*/
               
        TRIGGERS:

            ON "choose":U PERSISTENT RUN upc/upc-bc9026-u01.p (INPUT "h-bt-imprimir-op-falso",
                                                          INPUT "CHOOSE",
                                                          INPUT p-wgh-object,
                                                          INPUT p-wgh-frame,
                                                          INPUT p-cod-table,
                                                          INPUT p-row-table).

        END TRIGGERS.
    
        h-bt-imprimir-op-falso:load-image(h-bt-imprimir-op:image-up).
        h-bt-imprimir-op-falso:load-image-insensitive(h-bt-imprimir-op:image-insensitive).
        h-bt-imprimir-op-falso:move-to-top().




    END.

    IF VALID-HANDLE(h-bt-imprimir-it) THEN DO:

        CREATE BUTTON h-bt-imprimir-it-falso
        ASSIGN FRAME       = h-bt-imprimir-it:FRAME
               WIDTH       = h-bt-imprimir-it:WIDTH
               HEIGHT      = h-bt-imprimir-it:HEIGHT
               LABEL       = h-bt-imprimir-it:LABEL
               ROW         = h-bt-imprimir-it:ROW 
               COLUMN      = h-bt-imprimir-it:COLUMN 
               NAME        = "h-bt-imprimir-it-falso"
               SENSITIVE   = YES /*h-bt-imprimir-it:SENSITIVE*/
               VISIBLE     = YES /*h-bt-imprimir-it:VISIBLE*/
               
        TRIGGERS:

            ON "choose":U PERSISTENT RUN upc/upc-bc9026-u01.p (INPUT "h-bt-imprimir-it-falso",
                                                               INPUT "CHOOSE",
                                                               INPUT p-wgh-object,
                                                               INPUT p-wgh-frame,
                                                               INPUT p-cod-table,
                                                               INPUT p-row-table).

        END TRIGGERS.
    
        h-bt-imprimir-it-falso:load-image(h-bt-imprimir-it:image-up).
        h-bt-imprimir-it-falso:load-image-insensitive(h-bt-imprimir-it:image-insensitive).
        h-bt-imprimir-it-falso:move-to-top().

    END.

    IF VALID-HANDLE(h-bt-imprimir-dc) THEN DO:

        CREATE BUTTON h-bt-imprimir-dc-falso
        ASSIGN FRAME       = h-bt-imprimir-dc:FRAME
               WIDTH       = h-bt-imprimir-dc:WIDTH
               HEIGHT      = h-bt-imprimir-dc:HEIGHT
               LABEL       = h-bt-imprimir-dc:LABEL
               ROW         = h-bt-imprimir-dc:ROW 
               COLUMN      = h-bt-imprimir-dc:COLUMN 
               NAME        = "h-bt-imprimir-dc-falso"
               SENSITIVE   = YES /*h-bt-imprimir-dc:SENSITIVE*/
               VISIBLE     = YES /*h-bt-imprimir-dc:VISIBLE*/
               
        TRIGGERS:

            ON "choose":U PERSISTENT RUN upc/upc-bc9026-u01.p (INPUT "h-bt-imprimir-dc-falso",
                                                               INPUT "CHOOSE",
                                                               INPUT p-wgh-object,
                                                               INPUT p-wgh-frame,
                                                               INPUT p-cod-table,
                                                               INPUT p-row-table).

        END TRIGGERS.
    
        h-bt-imprimir-dc-falso:load-image(h-bt-imprimir-dc:image-up).
        h-bt-imprimir-dc-falso:load-image-insensitive(h-bt-imprimir-dc:image-insensitive).
        h-bt-imprimir-dc-falso:move-to-top().

    END.

    IF VALID-HANDLE(h-bt-imprimir-rf) THEN DO:

        CREATE BUTTON h-bt-imprimir-rf-falso
        ASSIGN FRAME       = h-bt-imprimir-rf:FRAME
               WIDTH       = h-bt-imprimir-rf:WIDTH
               HEIGHT      = h-bt-imprimir-rf:HEIGHT
               LABEL       = h-bt-imprimir-rf:LABEL
               ROW         = h-bt-imprimir-rf:ROW 
               COLUMN      = h-bt-imprimir-rf:COLUMN 
               NAME        = "h-bt-imprimir-rf-falso"
               SENSITIVE   = YES /*h-bt-imprimir-rf:SENSITIVE*/
               VISIBLE     = YES /*h-bt-imprimir-rf:VISIBLE*/
               
        TRIGGERS:

            ON "choose":U PERSISTENT RUN upc/upc-bc9026-u01.p (INPUT "h-bt-imprimir-rf-falso",
                                                               INPUT "CHOOSE",
                                                               INPUT p-wgh-object,
                                                               INPUT p-wgh-frame,
                                                               INPUT p-cod-table,
                                                               INPUT p-row-table).

        END TRIGGERS.
    
        h-bt-imprimir-rf-falso:load-image(h-bt-imprimir-rf:image-up).
        h-bt-imprimir-rf-falso:load-image-insensitive(h-bt-imprimir-rf:image-insensitive).
        h-bt-imprimir-rf-falso:move-to-top().

    END.

    ASSIGN c-handle-obj = fc-handle-obj("bt-imprimir-todos-op,bt-imprimir-todos-it,bt-imprimir-todos-dc,bt-imprimir-todos-rf", p-wgh-frame).
    ASSIGN h-bt-imprimir-todos-op = WIDGET-HANDLE(ENTRY(1,c-handle-obj)) 
           h-bt-imprimir-todos-it = WIDGET-HANDLE(ENTRY(2,c-handle-obj)) 
           h-bt-imprimir-todos-dc = WIDGET-HANDLE(ENTRY(3,c-handle-obj)) 
           h-bt-imprimir-todos-rf = WIDGET-HANDLE(ENTRY(4,c-handle-obj)) NO-ERROR.

    IF VALID-HANDLE(h-bt-imprimir-todos-op) THEN DO:

        CREATE BUTTON h-bt-imprimir-todos-op-falso
        ASSIGN FRAME       = h-bt-imprimir-todos-op:FRAME
               WIDTH       = h-bt-imprimir-todos-op:WIDTH
               HEIGHT      = h-bt-imprimir-todos-op:HEIGHT
               LABEL       = h-bt-imprimir-todos-op:LABEL
               ROW         = h-bt-imprimir-todos-op:ROW 
               COLUMN      = h-bt-imprimir-todos-op:COLUMN  
               NAME        = "h-bt-imprimir-todos-op-falso"
               SENSITIVE   = YES /*h-bt-imprimir-todos-op:SENSITIVE*/
               VISIBLE     = YES /*h-bt-imprimir-todos-op:VISIBLE*/
               
        TRIGGERS:

            ON "choose":U PERSISTENT RUN upc/upc-bc9026-u01.p (INPUT "h-bt-imprimir-todos-op-falso",
                                                               INPUT "CHOOSE",
                                                               INPUT p-wgh-object,
                                                               INPUT p-wgh-frame,
                                                               INPUT p-cod-table,
                                                               INPUT p-row-table).

        END TRIGGERS.
    
        h-bt-imprimir-todos-op-falso:load-image(h-bt-imprimir-todos-op:image-up).
        h-bt-imprimir-todos-op-falso:load-image-insensitive(h-bt-imprimir-todos-op:image-insensitive).
        h-bt-imprimir-todos-op-falso:move-to-top().




    END.

    IF VALID-HANDLE(h-bt-imprimir-todos-it) THEN DO:

        CREATE BUTTON h-bt-imprimir-todos-it-falso
        ASSIGN FRAME       = h-bt-imprimir-todos-it:FRAME
               WIDTH       = h-bt-imprimir-todos-it:WIDTH
               HEIGHT      = h-bt-imprimir-todos-it:HEIGHT
               LABEL       = h-bt-imprimir-todos-it:LABEL
               ROW         = h-bt-imprimir-todos-it:ROW 
               COLUMN      = h-bt-imprimir-todos-it:COLUMN 
               NAME        = "h-bt-imprimir-todos-it-falso"
               SENSITIVE   = YES /*h-bt-imprimir-todos-it:SENSITIVE*/
               VISIBLE     = YES /*h-bt-imprimir-todos-it:VISIBLE*/
               
        TRIGGERS:

            ON "choose":U PERSISTENT RUN upc/upc-bc9026-u01.p (INPUT "h-bt-imprimir-todos-it-falso",
                                                               INPUT "CHOOSE",
                                                               INPUT p-wgh-object,
                                                               INPUT p-wgh-frame,
                                                               INPUT p-cod-table,
                                                               INPUT p-row-table).

        END TRIGGERS.
    
        h-bt-imprimir-todos-it-falso:load-image(h-bt-imprimir-todos-it:image-up).
        h-bt-imprimir-todos-it-falso:load-image-insensitive(h-bt-imprimir-todos-it:image-insensitive).
        h-bt-imprimir-todos-it-falso:move-to-top().

    END.

    IF VALID-HANDLE(h-bt-imprimir-todos-dc) THEN DO:

        CREATE BUTTON h-bt-imprimir-todos-dc-falso
        ASSIGN FRAME       = h-bt-imprimir-todos-dc:FRAME
               WIDTH       = h-bt-imprimir-todos-dc:WIDTH
               HEIGHT      = h-bt-imprimir-todos-dc:HEIGHT
               LABEL       = h-bt-imprimir-todos-dc:LABEL
               ROW         = h-bt-imprimir-todos-dc:ROW 
               COLUMN      = h-bt-imprimir-todos-dc:COLUMN 
               NAME        = "h-bt-imprimir-todos-dc-falso"
               SENSITIVE   = YES /*h-bt-imprimir-todos-dc:SENSITIVE*/
               VISIBLE     = YES /*h-bt-imprimir-todos-dc:VISIBLE*/
               
        TRIGGERS:

            ON "choose":U PERSISTENT RUN upc/upc-bc9026-u01.p (INPUT "h-bt-imprimir-todos-dc-falso",
                                                               INPUT "CHOOSE",
                                                               INPUT p-wgh-object,
                                                               INPUT p-wgh-frame,
                                                               INPUT p-cod-table,
                                                               INPUT p-row-table).

        END TRIGGERS.
    
        h-bt-imprimir-todos-dc-falso:load-image(h-bt-imprimir-todos-dc:image-up).
        h-bt-imprimir-todos-dc-falso:load-image-insensitive(h-bt-imprimir-todos-dc:image-insensitive).
        h-bt-imprimir-todos-dc-falso:move-to-top().

    END.

    IF VALID-HANDLE(h-bt-imprimir-todos-rf) THEN DO:

        CREATE BUTTON h-bt-imprimir-todos-rf-falso
        ASSIGN FRAME       = h-bt-imprimir-todos-rf:FRAME
               WIDTH       = h-bt-imprimir-todos-rf:WIDTH
               HEIGHT      = h-bt-imprimir-todos-rf:HEIGHT
               LABEL       = h-bt-imprimir-todos-rf:LABEL
               ROW         = h-bt-imprimir-todos-rf:ROW 
               COLUMN      = h-bt-imprimir-todos-rf:COLUMN 
               NAME        = "h-bt-imprimir-todos-rf-falso"
               SENSITIVE   = YES /*h-bt-imprimir-todos-rf:SENSITIVE*/
               VISIBLE     = YES /*h-bt-imprimir-todos-rf:VISIBLE*/
               
        TRIGGERS:

            ON "choose":U PERSISTENT RUN upc/upc-bc9026-u01.p (INPUT "h-bt-imprimir-todos-rf-falso",
                                                               INPUT "CHOOSE",
                                                               INPUT p-wgh-object,
                                                               INPUT p-wgh-frame,
                                                               INPUT p-cod-table,
                                                               INPUT p-row-table).

        END TRIGGERS.
    
        h-bt-imprimir-todos-rf-falso:load-image(h-bt-imprimir-todos-rf:image-up).
        h-bt-imprimir-todos-rf-falso:load-image-insensitive(h-bt-imprimir-todos-rf:image-insensitive).
        h-bt-imprimir-todos-rf-falso:move-to-top().

    END.

    ASSIGN h-frame1 = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-frame1 = h-frame1:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame1):
       IF h-frame1:TYPE <> "field-group" THEN DO:


          IF h-frame1:NAME = "fPage2" THEN DO:

             ASSIGN h-bc9026-fpage2 = h-frame1.

             ASSIGN h-frame2 = h-bc9026-fpage2:FIRST-CHILD.
             ASSIGN h-frame2 = h-frame2:FIRST-CHILD.

          END.

          ASSIGN h-frame1 = h-frame1:NEXT-SIBLING.
       END.
       ELSE DO:
          ASSIGN h-frame1 = h-frame1:FIRST-CHILD.
       END.
    END.

END.

IF p-ind-event = "before-change-page" AND p-ind-object = "CONTAINER" THEN DO:

    IF VALID-HANDLE(h-bt-imprimir-op-falso) THEN h-bt-imprimir-op-falso:move-to-top().
    IF VALID-HANDLE(h-bt-imprimir-it-falso) THEN h-bt-imprimir-it-falso:move-to-top().
    IF VALID-HANDLE(h-bt-imprimir-dc-falso) THEN h-bt-imprimir-dc-falso:move-to-top().
    IF VALID-HANDLE(h-bt-imprimir-rf-falso) THEN h-bt-imprimir-rf-falso:move-to-top().

    ASSIGN h-bt-imprimir-op:SENSITIVE = NO
           h-bt-imprimir-it:SENSITIVE = NO
           h-bt-imprimir-dc:SENSITIVE = NO
           h-bt-imprimir-rf:SENSITIVE = NO NO-ERROR.

    ASSIGN h-bt-imprimir-op-falso:SENSITIVE = YES
           h-bt-imprimir-it-falso:SENSITIVE = YES
           h-bt-imprimir-dc-falso:SENSITIVE = YES
           h-bt-imprimir-rf-falso:SENSITIVE = YES NO-ERROR.

    IF VALID-HANDLE(h-bt-imprimir-todos-op-falso) THEN h-bt-imprimir-todos-op-falso:move-to-top().
    IF VALID-HANDLE(h-bt-imprimir-todos-it-falso) THEN h-bt-imprimir-todos-it-falso:move-to-top().
    IF VALID-HANDLE(h-bt-imprimir-todos-dc-falso) THEN h-bt-imprimir-todos-dc-falso:move-to-top().
    IF VALID-HANDLE(h-bt-imprimir-todos-rf-falso) THEN h-bt-imprimir-todos-rf-falso:move-to-top().

    ASSIGN h-bt-imprimir-todos-op:SENSITIVE = NO
           h-bt-imprimir-todos-it:SENSITIVE = NO
           h-bt-imprimir-todos-dc:SENSITIVE = NO
           h-bt-imprimir-todos-rf:SENSITIVE = NO NO-ERROR.

    ASSIGN h-bt-imprimir-todos-op-falso:SENSITIVE = YES
           h-bt-imprimir-todos-it-falso:SENSITIVE = YES
           h-bt-imprimir-todos-dc-falso:SENSITIVE = YES
           h-bt-imprimir-todos-rf-falso:SENSITIVE = YES NO-ERROR.

END.

IF ( p-ind-event = "h-bt-imprimir-op-falso" OR p-ind-event = "h-bt-imprimir-it-falso" OR 
     p-ind-event = "h-bt-imprimir-dc-falso" OR p-ind-event = "h-bt-imprimir-rf-falso" OR 
     p-ind-event = "h-bt-imprimir-todos-op-falso" OR p-ind-event = "h-bt-imprimir-todos-it-falso" OR 
     p-ind-event = "h-bt-imprimir-todos-dc-falso" OR p-ind-event = "h-bt-imprimir-todos-rf-falso") AND 
     p-ind-object = "CHOOSE" THEN DO:

    ASSIGN c-cod-impress = "".
    RUN esp\bcp\esbc9026d.w (INPUT-OUTPUT c-cod-impress).

    IF c-cod-impress = "" THEN DO:
    
        //MESSAGE "Deve ser informado a impressora!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
        RETURN NO-APPLY.
    
    END.

    ASSIGN g-imp-impressora-bc9026 = c-cod-impress 
           g-log-troca-imp-bc9026  = YES.
    
    IF p-ind-event = "h-bt-imprimir-op-falso" AND VALID-HANDLE(h-bt-imprimir-op) THEN APPLY "choose" TO h-bt-imprimir-op.
    IF p-ind-event = "h-bt-imprimir-it-falso" AND VALID-HANDLE(h-bt-imprimir-it) THEN APPLY "choose" TO h-bt-imprimir-it.
    IF p-ind-event = "h-bt-imprimir-dc-falso" AND VALID-HANDLE(h-bt-imprimir-dc) THEN APPLY "choose" TO h-bt-imprimir-dc.
    IF p-ind-event = "h-bt-imprimir-rf-falso" AND VALID-HANDLE(h-bt-imprimir-rf) THEN APPLY "choose" TO h-bt-imprimir-rf.

    IF p-ind-event = "h-bt-imprimir-todos-op-falso" AND VALID-HANDLE(h-bt-imprimir-todos-op) THEN APPLY "choose" TO h-bt-imprimir-todos-op.
    IF p-ind-event = "h-bt-imprimir-todos-it-falso" AND VALID-HANDLE(h-bt-imprimir-todos-it) THEN APPLY "choose" TO h-bt-imprimir-todos-it.
    IF p-ind-event = "h-bt-imprimir-todos-dc-falso" AND VALID-HANDLE(h-bt-imprimir-todos-dc) THEN APPLY "choose" TO h-bt-imprimir-todos-dc.
    IF p-ind-event = "h-bt-imprimir-todos-rf-falso" AND VALID-HANDLE(h-bt-imprimir-todos-rf) THEN APPLY "choose" TO h-bt-imprimir-todos-rf.
    
END.

RETURN.

FUNCTION fc-handle-obj RETURN CHARACTER (p-obj AS CHARACTER, p-frame AS WIDGET-HANDLE):
    DEFINE VARIABLE wh-objeto AS WIDGET-HANDLE NO-UNDO.
    
    IF p-frame:TYPE = "browse" THEN 
        ASSIGN wh-objeto = p-frame:FIRST-COLUMN.
    ELSE
        ASSIGN wh-objeto = p-frame:first-child.
    
    DO WHILE VALID-HANDLE(wh-objeto):
    
        IF wh-objeto:TYPE = "field-group" THEN
            ASSIGN p-obj = fc-handle-obj(p-obj,wh-objeto).
    
        IF wh-objeto:TYPE = "frame" THEN
            ASSIGN p-obj = fc-handle-obj(p-obj,wh-objeto).
    
        IF LOOKUP(wh-objeto:NAME,p-obj) <> 0 AND
           LOOKUP(wh-objeto:NAME,p-obj) <> ? THEN
            ASSIGN ENTRY(LOOKUP(wh-objeto:NAME,p-obj),p-obj) = STRING(wh-objeto:HANDLE).
        
        IF p-frame:TYPE = "browse" THEN
            ASSIGN wh-objeto = wh-objeto:NEXT-COLUMN.
        ELSE
            ASSIGN wh-objeto = wh-objeto:next-sibling.
    
    END.
    
    RETURN p-obj.
END FUNCTION.


