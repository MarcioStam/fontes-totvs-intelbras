/***********************************************************************************/
/**Objetivo: Carregar a tabela int-item-for-PN com o c¢digo do item do fornecedor, */
/*           limapando os campos das tabelas ITEM-FORNE E ITEM-FORNEC-ESTAB        */
/***********************************************************************************/

DO TRANS:
    FOR EACH item-fornec EXCLUSIVE-LOCK:

        FIND FIRST int-item-for-PN EXCLUSIVE-LOCK
            WHERE int-item-for-PN.cod-emitente = item-fornec.cod-emitente
              AND int-item-for-PN.it-codigo    = item-fornec.it-codigo   NO-ERROR. 
        IF  NOT AVAIL int-item-for-PN THEN DO:
            CREATE int-item-for-PN.
            ASSIGN int-item-for-PN.cod-emitente = item-fornec.cod-emitente
                   int-item-for-PN.it-codigo    = item-fornec.it-codigo
                   int-item-for-PN.item-do-forn = item-fornec.item-do-forn.
        END.
        ELSE
            ASSIGN int-item-for-PN.item-do-forn = item-fornec.item-do-forn.

        /*Limpa campo padr∆o*/
        ASSIGN item-fornec.item-do-forn = "".
    END.

    FOR EACH item-fornec-estab EXCLUSIVE-LOCK:

        FIND FIRST int-item-for-PN EXCLUSIVE-LOCK
            WHERE int-item-for-PN.cod-emitente = item-fornec-estab.cod-emitente
              AND int-item-for-PN.it-codigo    = item-fornec-estab.it-codigo NO-ERROR.

        IF  NOT AVAIL int-item-for-PN THEN DO:
            CREATE int-item-for-PN.
            ASSIGN int-item-for-PN.cod-emitente = item-fornec-estab.cod-emitente
                   int-item-for-PN.it-codigo    = item-fornec-estab.it-codigo
                   int-item-for-PN.item-do-forn = item-fornec-estab.item-do-forn.
        END.
        ELSE 
            ASSIGN int-item-for-PN.item-do-forn = item-fornec-estab.item-do-forn.

        /*Limpa campo padr∆o*/
        ASSIGN item-fornec-estab.item-do-forn = "".

    END.

    UNDO, LEAVE.

END.
