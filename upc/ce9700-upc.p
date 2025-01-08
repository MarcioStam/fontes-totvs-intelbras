/*------------------------------------------------------------------------
    File        : cd0301-UPC.P
    Author      : Carlos Daniel - 11/03/2016
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-ce9700-imp              AS WIDGET-HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ce9700-det              AS WIDGET-HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ce9700-cbg              AS WIDGET-HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-depos-entr-ce9700   AS WIDGET-HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-depos-saida-ce9700  AS WIDGET-HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-num-docto-transf-ce9700 AS WIDGET-HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-brSon1-ce9700           AS WIDGET-HANDLE           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-fPage1-ce9700           AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE h-upc-ce9700                   AS WIDGET-HANDLE           NO-UNDO.

DEFINE VARIABLE h-frame           AS HANDLE      NO-UNDO.
DEFINE VARIABLE wh-aux            AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-aux             AS CHARACTER     NO-UNDO.
DEFINE VARIABLE i-aux             AS INTEGER       NO-UNDO.
DEFINE VARIABLE c-ge-codigo       AS CHARACTER     NO-UNDO.

/*
MESSAGE "EVENTO: ":U   p-ind-event      SKIP
        "OBJETO: ":U   p-ind-object     SKIP
        "NOME OBJ: ":U c-objeto         SKIP
        "FRAME: ":U    p-wgh-frame:NAME SKIP
        "TABELA: ":U   p-cod-table      SKIP
        "ROWID: ":U    STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/

IF  p-ind-event = "AFTER-INITIALIZE" 
AND p-ind-object = "CONTAINER" THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):

        IF h-frame:TYPE = "button" AND h-frame:NAME = "btfirst" then
           LEAVE.

        IF h-frame:TYPE ne "field-group" THEN
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        ELSE
            ASSIGN h-frame = h-frame:FIRST-CHILD.
    END.

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "num-docto-transf",
                     OUTPUT wh-num-docto-transf-ce9700).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "cod-depos-saida",
                     OUTPUT wh-cod-depos-saida-ce9700).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "cod-depos-entr",
                     OUTPUT wh-cod-depos-entr-ce9700).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "fPage1",
                     OUTPUT wh-fPage1-ce9700).

    RUN busca-handle(INPUT wh-fPage1-ce9700,
                     INPUT "brSon1",
                     OUTPUT wh-brSon1-ce9700).

    IF  h-frame:TYPE = "button" 
    AND h-frame:NAME = "btfirst" THEN DO:

        IF NOT VALID-HANDLE (h-upc-ce9700) THEN
            RUN upc/ce9700-upc.p PERSISTENT SET h-upc-ce9700 (INPUT "",
                                                              INPUT "",
                                                              INPUT p-wgh-object,
                                                              INPUT p-wgh-frame,
                                                              INPUT "",
                                                              INPUT p-row-table).

        CREATE BUTTON wh-ce9700-imp
        ASSIGN FRAME     = h-frame:FRAME
               WIDTH     = 4.00
               HEIGHT    = 1.10
               ROW       = 1.15
               COL       = 60
               VISIBLE   = YES
               SENSITIVE = YES
               TOOLTIP   = "Importar Itens"
               TRIGGERS:
                    ON CHOOSE PERSISTENT RUN pi-teste IN h-upc-ce9700.
               END TRIGGERS.
    
        IF wh-ce9700-imp:LOAD-IMAGE("image/im-exp.gif") THEN.
        IF wh-ce9700-imp:LOAD-IMAGE-DOWN("image/im-exp.gif") THEN.

        CREATE BUTTON wh-ce9700-det
        ASSIGN FRAME     = h-frame:FRAME
               WIDTH     = 4.00
               HEIGHT    = 1.10
               ROW       = 1.15
               COL       = 65
               VISIBLE   = YES
               SENSITIVE = YES
               TOOLTIP   = "Detalhes"
               TRIGGERS:
                    ON CHOOSE PERSISTENT RUN pi-datalha IN h-upc-ce9700.
               END TRIGGERS.
    
        IF wh-ce9700-det:LOAD-IMAGE("image/im-info.gif") THEN.
        IF wh-ce9700-det:LOAD-IMAGE-DOWN("image/im-info.gif") THEN.

        CREATE BUTTON wh-ce9700-cbg
        ASSIGN FRAME     = h-frame:FRAME
               WIDTH     = 4.00
               HEIGHT    = 1.10
               ROW       = 1.15
               COL       = 70
               VISIBLE   = YES
               SENSITIVE = YES
               TOOLTIP   = "Cubagem"
               TRIGGERS:
                    ON CHOOSE PERSISTENT RUN pi-cubagem IN h-upc-ce9700.
               END TRIGGERS.
    
        IF wh-ce9700-cbg:LOAD-IMAGE("image/im-gmat.gif") THEN. //im-f-dw.gif  im-cla.gif
        IF wh-ce9700-cbg:LOAD-IMAGE-DOWN("image/im-gmat.gif") THEN.

    END.
    
END.

PROCEDURE pi-teste:
    RUN upc/ce9700-imp.w.
    RUN openQueriesSon  IN p-wgh-object.
    RUN displayFields   IN p-wgh-object.
    IF CAN-FIND(FIRST item-docto-transf-depos
                WHERE item-docto-transf-depos.num-docto-transf = int(wh-num-docto-transf-ce9700:SCREEN-VALUE)) 
       THEN wh-brSon1-ce9700:REFRESH().
END PROCEDURE.
    
PROCEDURE pi-datalha:

    RUN upc/ce9700-det.w (INPUT int(wh-num-docto-transf-ce9700:SCREEN-VALUE)).

END PROCEDURE.

PROCEDURE pi-cubagem:

    RUN upc/ce9700-cbg.w (INPUT int(wh-num-docto-transf-ce9700:SCREEN-VALUE)).

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
        IF NOT valid-handle(h-aux) AND NOT VALID-HANDLE(h-prox) THEN DO:
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
