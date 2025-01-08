/** include para habilitar e desabilitar cte **/

PROCEDURE pi-habilita:

    DEFINE OUTPUT PARAMETER l-encontrou-cte AS LOGICAL.
    DEFINE INPUT  PARAMETER p-row-table     AS ROWID.

    FIND docum-est WHERE ROWID(docum-est) = p-row-table NO-LOCK NO-ERROR.
    IF CAN-FIND(gati-cte WHERE gati-cte.cod-aces-comp-nfe = substring(docum-est.char-1,93,60)) THEN DO:
        ASSIGN l-encontrou-cte = YES.
        FIND FIRST funcao EXCLUSIVE-LOCK WHERE
                   funcao.cd-funcao = "SPP-INTEG-TSS" NO-ERROR.
        IF AVAIL funcao THEN
            ASSIGN funcao.ativo = NO.
    END.

END PROCEDURE.

PROCEDURE pi-desabilita:

    DEFINE INPUT PARAMETER l-encontrou-cte AS LOGICAL.

    IF l-encontrou-cte THEN DO:
        FIND FIRST funcao EXCLUSIVE-LOCK WHERE
                   funcao.cd-funcao = "SPP-INTEG-TSS" NO-ERROR.
        IF AVAIL funcao THEN
            ASSIGN funcao.ativo = YES.
    END.

END PROCEDURE.