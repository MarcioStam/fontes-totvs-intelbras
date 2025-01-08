/*********************************************************************************
** Programa: esp/crm/escrm022.p
** Vers∆o..: 1.00
** Data....: 08/11/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: API para buscar os produtos das Tabelas de Preáo cadastradas para o
**           cliente.
*********************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Temp-Tables ---*/
DEFINE TEMP-TABLE tt-produtos NO-UNDO
    FIELD it-codigo LIKE item.it-codigo.



/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER pCod-cliente AS INTEGER     NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-produtos.



/*--- Bloco Principal ---*/
FOR EACH  crm-un-cli-tb-preco NO-LOCK
    WHERE crm-un-cli-tb-preco.cod-emitente     = pCod-cliente
    AND   crm-un-cli-tb-preco.dt-vigencia-ini <= TODAY
    AND   (IF crm-un-cli-tb-preco.dt-vigencia-fim <> ? THEN crm-un-cli-tb-preco.dt-vigencia-fim >= TODAY ELSE YES):
    FOR EACH  preco-item NO-LOCK
        WHERE preco-item.nr-tabpre  = crm-un-cli-tb-preco.nr-tabpre
        AND   preco-item.dt-inival <= TODAY
        BREAK BY preco-item.it-codigo
              BY preco-item.dt-inival DESC:

        IF  CAN-FIND(FIRST tt-produtos NO-LOCK
                     WHERE tt-produtos.it-codigo = preco-item.it-codigo) THEN
            NEXT.

        IF  FIRST-OF(preco-item.it-codigo) THEN DO:
            IF  preco-item.situacao = 1 /* Ativo */ THEN DO:
                CREATE tt-produtos.
                ASSIGN tt-produtos.it-codigo = preco-item.it-codigo.
            END.
        END.
    END.
END.


DELETE WIDGET-POOL.
RETURN "OK":U.
