/*****************************************************************************
** Programa: upc\cd0821-upc.p
** VersÆo..: 1.00
** Data....: 16/09/2010
** Obs.....: Programa para incluir o Campo "Unidade Neg¢cio"
*****************************************************************************/


/*--- Defini‡Æo dos Parƒmetros ---*/
DEFINE INPUT PARAMETER p-ind-event    AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object   AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object   AS HANDLE             NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame    AS WIDGET-HANDLE      NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table    AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-row-table    AS ROWID              NO-UNDO.



/*--- Defini‡Æo das Vari veis Globais ---*/
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_unid_negoc           AS CHARACTER      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-cd0821-upc               AS HANDLE         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-fi-usuario-cd0821       AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-rt-unid-negoc-cd0821    AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-unid-negoc-cd0821    AS WIDGET-HANDLE  NO-UNDO.



/*--- Defini‡Æo das Vari velis Locais ---*/
DEFINE VARIABLE c-objeto       AS CHARACTER   NO-UNDO.



/*--- Defini‡Æo das Fun‡äes ---*/
FUNCTION getObject RETURNS HANDLE (pFrame AS HANDLE, pObj AS CHAR).
    DEFINE VARIABLE hHdl AS HANDLE NO-UNDO.

    ASSIGN hHdl = pFrame:FIRST-CHILD
           hHdl = hHdl:FIRST-CHILD.

    DO WHILE VALID-HANDLE(hHdl):
        IF hHdl:NAME = pObj THEN LEAVE.

        hHdl = hHdl:NEXT-SIBLING.
    END.

    RETURN IF  VALID-HANDLE(hHdl) THEN hHdl ELSE ?.
END FUNCTION.



/*--- Bloco Principal ---*/
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME, "~/"), p-wgh-object:FILE-NAME, "~/").


IF  p-ind-event  = "BEFORE-INITIALIZE":U AND
    p-ind-object = "CONTAINER"           THEN DO:
    IF  NOT VALID-HANDLE(h-cd0821-upc) THEN
        RUN upc/cd0821-upc.p PERSISTENT SET h-cd0821-upc (INPUT "",
                                                          INPUT "",
                                                          INPUT p-wgh-object,
                                                          INPUT p-wgh-frame,
                                                          INPUT "",
                                                          INPUT p-row-table).
END.


IF  p-ind-event = "INITIALIZE" AND
    c-objeto    = "v01di211.w" THEN DO:
    ASSIGN wh-fi-usuario-cd0821 = getObject(p-wgh-frame, "fi-usuario").
END.


IF  p-ind-event = "INITIALIZE" AND
    c-objeto    = "v08di211.w" THEN DO:

    ASSIGN p-wgh-frame:WIDTH = p-wgh-frame:WIDTH + 7.

    CREATE RECTANGLE wh-rt-unid-negoc-cd0821
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 32
           HEIGHT       = 1.75
           ROW          = 8
           COL          = 45.4
           VISIBLE      = YES
           GRAPHIC-EDGE = YES
           EDGE-PIXELS  = 2
           FILLED       = NO.

    CREATE BUTTON wh-bt-unid-negoc-cd0821
    ASSIGN FRAME     = p-wgh-frame
           WIDTH     = 15
           HEIGHT    = 1
           ROW       = 8.35
           COL       = 54
           LABEL     = "Unidade Comercial"
           VISIBLE   = YES
           SENSITIVE = YES
        TRIGGERS:
            ON "CHOOSE":U  PERSISTENT RUN pi-choose-bt-unid-negoc IN h-cd0821-upc.
        END TRIGGERS.
END.


IF  p-ind-event = "AFTER-DELETE" THEN DO:
    IF  VALID-HANDLE(wh-fi-usuario-cd0821) THEN DO:
        FOR EACH  int-user-coml EXCLUSIVE-LOCK
            WHERE int-user-coml.cd-usuario = wh-fi-usuario-cd0821:SCREEN-VALUE:
            DELETE int-user-coml.
        END.
    END.
END.


IF  p-ind-event = "DESTROY" THEN DO:
    IF  VALID-HANDLE(h-cd0821-upc) THEN DO:
        DELETE PROCEDURE h-cd0821-upc.
        ASSIGN h-cd0821-upc = ?.
    END.

    IF  VALID-HANDLE(wh-rt-unid-negoc-cd0821) THEN DO:
        DELETE OBJECT wh-rt-unid-negoc-cd0821.
        ASSIGN wh-rt-unid-negoc-cd0821 = ?.
    END.

    IF  VALID-HANDLE(wh-bt-unid-negoc-cd0821) THEN DO:
        DELETE OBJECT wh-bt-unid-negoc-cd0821.
        ASSIGN wh-bt-unid-negoc-cd0821 = ?.
    END.
END.



/*--- Procedures Internas ---*/
PROCEDURE pi-choose-bt-unid-negoc:

    RUN upc/cd0821-upc01.w (INPUT IF  VALID-HANDLE(wh-fi-usuario-cd0821) THEN
                                      wh-fi-usuario-cd0821:SCREEN-VALUE
                                  ELSE
                                      "").

    RETURN "OK":U.
END PROCEDURE.
