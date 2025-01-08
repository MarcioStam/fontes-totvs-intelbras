/*------------------------------------------------------------------------
    File        : ESMSSP014.P
    Purpose     : Busca Componente
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Abril/Maio de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-it-codigo    AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-estab        AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER p-desc         AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER p-desc-posicao AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER p-custo-item   AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER p-un           AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER p-error        AS CHARACTER   NO-UNDO.

DEFINE VARIABLE d-valor AS DECIMAL     NO-UNDO.


/* ***************************  Main Block  *************************** */

FIND FIRST item
    WHERE item.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

/*LOG-MANAGER:WRITE-MESSAGE('>>>Maicon - ' + string( p-it-codigo ) ) NO-ERROR.*/

IF NOT AVAILABLE item THEN DO:
    ASSIGN p-error = "Item ~"":U + p-it-codigo + "~" inexistente!":U.

    RETURN "NOK":U.
END.
ELSE IF item.cod-obsoleto <> 1 THEN DO:
    ASSIGN p-error = "Item ~"":U + p-it-codigo + "~" obsoleto!":U.

    RETURN "NOK":U.
END.

ASSIGN p-desc = item.desc-item
       p-un   = item.un.

FIND FIRST estrutura
    WHERE estrutura.es-codigo = item.it-codigo NO-LOCK NO-ERROR.

IF AVAILABLE estrutura THEN DO:
    
    ASSIGN p-desc-posicao = STRING(estrutura.local-montag).
    
END.

ASSIGN d-valor = 0.
    
FIND FIRST item-estab
    WHERE item-estab.cod-estabel = p-estab
      AND item-estab.it-codigo   = item.it-codigo NO-LOCK NO-ERROR.

IF AVAILABLE item-estab THEN
    ASSIGN d-valor = item-estab.val-unit-mat-m[1].


IF NOT AVAIL item-estab OR d-valor = 0 THEN DO:

    FIND FIRST item-uni-estab
        WHERE item-uni-estab.cod-estabel = p-estab
          AND item-uni-estab.it-codigo   = item.it-codigo NO-LOCK NO-ERROR.

    IF AVAILABLE item-uni-estab THEN
        ASSIGN d-valor = item-uni-estab.preco-ul-ent.

    IF NOT AVAIL item-uni-estab OR d-valor = 0 THEN DO:

        FIND FIRST item-tab
            WHERE item-tab.it-codigo = item.it-codigo 
            AND   item-tab.situacao = 1 /* ativo */
            NO-LOCK NO-ERROR.

        IF AVAILABLE item-tab THEN DO:

            FOR FIRST item-fornec NO-LOCK
                WHERE item-fornec.it-codigo    = item-tab.it-codigo
                AND   item-fornec.cod-emitente = item-tab.cod-emitente:

                /* ConversÆo pela unidade de medida do fornecedor - CC0531 */
                ASSIGN d-valor = (item-fornec.fator-conver * item-tab.pr-item) / EXP(10, item-fornec.num-casa-dec).

            END.

        END.
    END.
END.

ASSIGN p-custo-item = TRIM(STRING(d-valor, ">>>>9.9999":U)).

RETURN "OK":U.

