/*********************************************************************************************
** Programa...: wm0240-upc.p                                                                **
** Versao.....: 2.00.00.001                                                                 **
** Data.......: Janeiro/2022                                                                **
** Respons vel: SCM Concept Tecnologia da Informacao                                        **
** Objetivo...: Cria‡Æo do campo "Sem Sugestao Armazenagem"                                 **
*********************************************************************************************/

/*************************** Parƒmetros Padräes ************************************/
DEFINE INPUT PARAM p-ind-event                              AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAM p-ind-object                             AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAM p-wgh-object                             AS HANDLE        NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame                              AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAM p-cod-table                              AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAM p-row-table                              AS ROWID         NO-UNDO.
/***********************************************************************************/
/* Chaves */
DEFINE NEW GLOBAL SHARED VAR wgh-cod-estabel-wm0240                 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wgh-cod-local-wm0240                   AS WIDGET-HANDLE NO-UNDO.

/* Frames */
DEFINE NEW GLOBAL SHARED VAR wh-frame                               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-window-wm0240                       AS WIDGET-HANDLE NO-UNDO.

/* Esquerda */
DEFINE NEW GLOBAL SHARED VAR wh-log-sem-sugestao-wm0240             AS WIDGET-HANDLE NO-UNDO.

def var h-temp   as handle   no-undo.

DEFINE BUFFER bf-wm-local FOR wm-local.

IF p-ind-event  = "AFTER-INITIALIZE" AND 
   p-ind-object = "CONTAINER"        THEN DO:

    ASSIGN wh-window-wm0240 = p-wgh-frame:PARENT.

    DO:
        ASSIGN wh-frame = p-wgh-frame:FIRST-CHILD
               wh-frame = wh-frame:FIRST-CHILD.
        DO  WHILE wh-frame <> ?:

            IF  wh-frame:TYPE <> "field-group":U THEN DO:
                IF wh-frame:NAME = "cod-estabel":U THEN
                   ASSIGN wgh-cod-estabel-wm0240 = wh-frame.
            
                IF wh-frame:NAME = "cod-local":U THEN
                   ASSIGN wgh-cod-local-wm0240 = wh-frame.

                ASSIGN wh-frame = wh-frame:NEXT-SIBLING.
            END.
            ELSE
                ASSIGN wh-frame = wh-frame:FIRST-CHILD.
        END.
    END.

    /* Cria novo campo em tela */
    IF NOT VALID-HANDLE(wh-log-sem-sugestao-wm0240) THEN DO:
        CREATE TOGGLE-BOX wh-log-sem-sugestao-wm0240
        ASSIGN FRAME        = p-wgh-frame
               ROW          = 8.25
               COL          = 24.0
               LABEL        = "Sem SugestÆo Armazenagem"
               SENSITIVE    = NO
               VISIBLE      = YES
               NAME         = "wh-log-sem-sugestao"
               WIDTH        = 24
               FORMAT       = "Yes,No".
    END.

    IF VALID-HANDLE(wh-log-sem-sugestao-wm0240) THEN DO:
       FIND FIRST bf-wm-local EXCLUSIVE-LOCK
            WHERE ROWID(bf-wm-local) = p-row-table NO-ERROR.
       IF AVAIL bf-wm-local THEN DO:
          ASSIGN wh-log-sem-sugestao-wm0240:CHECKED = bf-wm-local.log-2.
       END.
    END.

END.

/* Habilita o campo para altera‡Æo */
IF p-ind-event  = "AFTER-ENABLE" AND
   p-ind-object = "CONTAINER"    THEN DO:
    IF VALID-HANDLE(wh-log-sem-sugestao-wm0240) THEN
        ASSIGN wh-log-sem-sugestao-wm0240:SENSITIVE = TRUE.
END.

/* Desabilita o campo */
IF p-ind-event  = "AFTER-DISABLE" AND
   p-ind-object = "CONTAINER"    THEN DO:
    IF VALID-HANDLE(wh-log-sem-sugestao-wm0240) THEN
        ASSIGN wh-log-sem-sugestao-wm0240:SENSITIVE = FALSE.
END.

IF p-ind-event  = "AFTER-ASSIGN" AND
   p-ind-object = "CONTAINER"    THEN DO:
    IF VALID-HANDLE(wh-log-sem-sugestao-wm0240) THEN DO:
        FIND FIRST bf-wm-local EXCLUSIVE-LOCK
             WHERE ROWID(bf-wm-local) = p-row-table NO-ERROR.
        IF AVAIL bf-wm-local THEN DO:
           ASSIGN bf-wm-local.log-2 = wh-log-sem-sugestao-wm0240:CHECKED.
        END.
    END.
END.

IF p-ind-event  = "AFTER-DISPLAY" THEN DO:
   IF VALID-HANDLE(wh-log-sem-sugestao-wm0240) THEN DO:
       FIND FIRST bf-wm-local EXCLUSIVE-LOCK
            WHERE ROWID(bf-wm-local) = p-row-table NO-ERROR.
       IF AVAIL bf-wm-local THEN DO:
          ASSIGN wh-log-sem-sugestao-wm0240:CHECKED = bf-wm-local.log-2.
       END.
   END.
END.

RETURN "OK":U.

