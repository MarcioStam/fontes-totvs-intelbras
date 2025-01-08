/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: upc/cd0405-upc.p
**  Objetivo.: 
**  Criaá∆o..: 28/07/2010
**  Vers∆o...: 00001 - 28/07/2010 - Aumentar tamanho de caracter da mensagem.
**             - Gustavo Eduardo Tamanini - Gran Systems.
** 
**
*******************************************************************************/
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object AS HANDLE          NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame  AS WIDGET-HANDLE   NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table  AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-row-table  AS ROWID           NO-UNDO.

DEFINE VARIABLE h-frame  AS HANDLE      NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-texto-mensag-cd0405 AS WIDGET-HANDLE   NO-UNDO.

IF p-ind-event = "BEFORE-INITIALIZE":U THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-frame = h-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:TYPE <> "field-group":U THEN DO:
            CASE h-frame:NAME:
                WHEN "texto-mensag":U THEN ASSIGN wh-texto-mensag-cd0405 = h-frame.                
            END CASE.
            ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    IF VALID-HANDLE(wh-texto-mensag-cd0405) THEN
        ASSIGN wh-texto-mensag-cd0405:MAX-CHARS = 8000.    
END.
