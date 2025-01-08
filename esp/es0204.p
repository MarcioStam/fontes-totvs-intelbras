DEFINE INPUT PARAMETER p-estabel AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-it-codigo AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p-narrativa AS CHARACTER NO-UNDO.

FIND FIRST ITEM 
    WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.
IF AVAIL ITEM THEN DO:
    IF INDEX(ITEM.narrativa,"#MANAUS#") <> 0 THEN DO:
        IF p-estabel = "105" THEN DO:
            ASSIGN p-narrativa = TRIM(SUBSTRING(ITEM.narrativa,INDEX(ITEM.narrativa,"#MANAUS#") + 8,LENGTH(ITEM.narrativa))).

            IF p-narrativa = "" THEN /*caso nao tenha nada na narrativa de manaus, puxa a narrativa padr∆o*/
                ASSIGN p-narrativa = TRIM(SUBSTRING(ITEM.narrativa,1,INDEX(ITEM.narrativa,"#MANAUS#") - 1)).
        END.
        ELSE
            ASSIGN p-narrativa = TRIM(SUBSTRING(ITEM.narrativa,1,INDEX(ITEM.narrativa,"#MANAUS#") - 1)).
    END.
    ELSE DO:
        /*caso nao tenha narrativa manaus, puxa a narrativa padr∆o*/
        ASSIGN p-narrativa = TRIM(ITEM.narrativa).
    END.
END.
