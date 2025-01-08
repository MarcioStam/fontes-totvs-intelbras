/*------------------------------------------------------------------------
    File        : ESMSSP027.P
    Purpose     : Busca Fam¡lia por Descri‡Æo
    Procedure   : buscaFamiliaDescParcial
    Syntax      : <none>
    Description : <none>

    Author(s)   : Maicon Roberto Correa (Sensus Tecnologia)
    Created     : Janeiro / 2015
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-familia NO-UNDO
    FIELD fm-codigo        LIKE familia.fm-codigo
    FIELD descricao        LIKE familia.descricao.
    
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-query AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-where AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-sort  AS CHARACTER   NO-UNDO.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-desc     AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-familia.
DEFINE OUTPUT PARAMETER p-mensagem  AS CHARACTER   NO-UNDO.


/* ***************************  Main Block  *************************** */

EMPTY TEMP-TABLE tt-familia.

IF p-desc = "":U THEN DO:
    ASSIGN p-mensagem = "Descri‡Æo enviada igual a branco.":U.

    RETURN "NOK":U.
END.




/*ASSIGN p-desc = "dispositivos oticos lentes maicon roberto correa".*/

ASSIGN p-desc = TRIM(p-desc).

FOR FIRST familia NO-LOCK
    WHERE familia.descricao BEGINS p-desc:
END.

REPEAT:

    IF NOT AVAIL familia THEN DO:
        /*ASSIGN p-desc = SUBSTRING(p-desc, 1, INDEX(p-desc, " " + ENTRY(NUM-ENTRIES(p-desc, " "), p-desc, " ")) - 1).*/
        ASSIGN p-desc = SUBSTRING(p-desc, 1, INDEX(p-desc, " ", LENGTH(p-desc) - LENGTH(ENTRY(NUM-ENTRIES(p-desc, " "), p-desc, " "))) - 1).

        FOR FIRST familia NO-LOCK
            WHERE familia.descricao BEGINS p-desc:
        END.

        IF NUM-ENTRIES(p-desc, " ") = 1 THEN
            LEAVE.

    END.
    ELSE
        LEAVE.

END.

IF AVAIL familia THEN DO:

    FOR EACH familia NO-LOCK
        WHERE familia.descricao BEGINS p-desc:

        IF INDEX("0123456789", substring(familia.fm-codigo, 1, 1)) = 0 THEN
            NEXT.

        CREATE tt-familia.
        ASSIGN tt-familia.fm-codigo = familia.fm-codigo
               tt-familia.descricao = familia.descricao.
         
    END.


END.

IF NOT CAN-FIND(FIRST tt-familia) THEN DO:

    ASSIGN p-mensagem = "Nenuma Fam¡lia encontrada!":U.

    RETURN "NOK":U.

END.

RETURN "OK":U.

