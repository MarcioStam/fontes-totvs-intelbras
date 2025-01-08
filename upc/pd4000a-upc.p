DEFINE INPUT PARAM p-ind-event  AS CHAR          NO-UNDO.
DEFINE INPUT PARAM p-ind-object AS CHAR          NO-UNDO.
DEFINE INPUT PARAM p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAM p-cod-table  AS CHAR          NO-UNDO.
DEFINE INPUT PARAM p-row-table  AS ROWID         NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-c-narrativa-pd4000a        AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE h-object        AS HANDLE        NO-UNDO.

IF  p-ind-event  = "BEFORE-INITIALIZE" 
AND p-ind-object = "CONTAINER" THEN DO:

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.
            
    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = 'c-narrativa' THEN DO:
                ASSIGN wh-c-narrativa-pd4000a = h-object.
                LEAVE.
            END.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.    

    IF VALID-HANDLE (wh-c-narrativa-pd4000a)  THEN DO:
        ASSIGN wh-c-narrativa-pd4000a:MAX-CHARS = 2000.
    END.
END.


    /*ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.
            
    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = 'cod-imagem' THEN DO:
                ASSIGN wh-cod-imagem-cd0404 = h-object.
            END.
            IF h-object:NAME = 'cod-cond-pag' THEN DO:
                ASSIGN wh-cod-cond-pagto-cd0404 = h-object.
            END.
            IF h-object:NAME = 'descricao' THEN DO:
                ASSIGN wh-descricao-cd0404 = h-object.
            END.
            IF h-object:NAME = 'cb-cod-vencto' THEN DO:
                ASSIGN wh-cb-cod-vencto-cd0404 = h-object.
            END.
            IF h-object:NAME = 'dia-mes-base' THEN DO:
                ASSIGN wh-dia-mes-base-cd0404 = h-object.
            END.
            IF h-object:NAME = 'cb-dia-sem-base' THEN DO:
                ASSIGN wh-cb-dia-sem-base-cd0404 = h-object.
            END.
            IF h-object:NAME = 'dia-mes-venc' THEN DO:
                ASSIGN wh-dia-mes-venc-cd0404 = h-object.
            END.
            IF h-object:NAME = 'cb-dia-sem-venc ' THEN DO:
                ASSIGN wh-cb-dia-sem-venc-cd0404 = h-object.
            END.
            IF h-object:NAME = 'nr-dias-ante' THEN DO:
                ASSIGN wh-nr-dias-ante-cd0404 = h-object.
            END.
            IF h-object:NAME = 'nr-dupdes' THEN DO:
                ASSIGN wh-nr-dupdes-cd0404 = h-object.
            END.
            IF h-object:NAME = 'per-des-pgan' THEN DO:
                ASSIGN wh-per-des-pgan-cd0404 = h-object.
            END.
            IF h-object:NAME = 'nr-tab-finan' THEN DO:
                ASSIGN wh-nr-tab-finan-cd0404 = h-object.
            END.
            IF h-object:NAME = 'nr-ind-finan' THEN DO:
                ASSIGN wh-nr-ind-finan-cd0404 = h-object.
            END.
            IF h-object:NAME = 'lAtualizaIndice' THEN DO:
                ASSIGN wh-lAtualizaIndice-cd0404 = h-object.
            END.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.    */
