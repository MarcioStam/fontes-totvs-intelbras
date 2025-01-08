DEFINE TEMP-TABLE tt-familia NO-UNDO
    FIELD fm-codigo        LIKE familia.fm-codigo
    FIELD descricao        LIKE familia.descricao.

DEFINE VARIABLE p-mensagem AS CHARACTER   NO-UNDO.
DEFINE VARIABLE p-desc     AS CHARACTER   NO-UNDO.

/*
ASSIGN p-desc = "Adesivo Bast∆o Silicone BR µrtico 50g".
REPEAT:

    IF NOT AVAIL familia THEN DO:
        
        MESSAGE p-desc
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        ASSIGN p-desc = SUBSTRING(p-desc, 1, INDEX(p-desc, " " + ENTRY(NUM-ENTRIES(p-desc, " "), p-desc, " ")) - 1).

        FOR FIRST familia NO-LOCK
            WHERE familia.descricao BEGINS p-desc:
        END.

        IF NUM-ENTRIES(p-desc, " ") = 1 THEN
            LEAVE.

    END.
    ELSE
        LEAVE.

END.
*/

RUN c:\fontes11\esp\mssp\esmssp027.p (INPUT  "Adesivo Bast∆o Silicone BL 50g",
                                      OUTPUT TABLE tt-familia,
                                      OUTPUT p-mensagem).
FOR EACH tt-familia:
    DISP tt-familia.
END.
