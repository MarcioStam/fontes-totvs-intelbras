/*------------------------------------------------------------------------
    File        : ESMSSP013.P
    Purpose     : Busca Produto
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Abril/Maio de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-it-codigo AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER p-desc      AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER p-error     AS CHARACTER   NO-UNDO.


/* ***************************  Main Block  *************************** */

FIND FIRST item
    WHERE item.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

IF NOT AVAILABLE item THEN DO:
    ASSIGN p-error = "Item ~"":U + p-it-codigo + "~" inexistente.":U.

    RETURN "NOK":U.
END.
ELSE IF item.cod-obsoleto <> 1 THEN DO:
    ASSIGN p-error = "Item ~"":U + p-it-codigo + "~" obsoleto.":U.

    RETURN "NOK":U.
END.

ASSIGN p-desc = item.desc-item.

RETURN "OK":U.

