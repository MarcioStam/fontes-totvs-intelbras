/*********************************************************************************
** Programa: esp/crm/escrm023.p
** VersÆo..: 1.00
** Data....: 09/11/2010
** Autor...: Estevan Krger - Exponencial TI
** Obs.....: Relat¢rio do Portal B2B.
**           C¢pia da procedure "process-zoom-tabpreco-consumidor", programa "soap-b2b-tabpreco"
**           Listagem da Tabela de Pre‡o, para Consumidor Final
*********************************************************************************/

CREATE WIDGET-POOL.


/*--- Defini‡Æo das Temp-Tables ---*/
DEFINE TEMP-TABLE tt-layout-tabpreco NO-UNDO
    FIELD lay-codigo    LIKE layout-tabpreco.lay-codigo
    FIELD lay-nome      LIKE layout-tabpreco.lay-nome
    INDEX idx-layout    AS PRIMARY UNIQUE lay-codigo.

DEFINE TEMP-TABLE tt-preco-item NO-UNDO
    FIELD lay-codigo    LIKE layout-tabpreco.lay-codigo
    FIELD it-codigo     LIKE item.it-codigo
    FIELD desc-item     LIKE item.desc-item
    FIELD aliquota-ipi  LIKE item.aliquota-ipi
    FIELD pma           LIKE int-preco-item.pma
    FIELD preco-com-ipi AS DECIMAL
    INDEX idx-preco     AS PRIMARY UNIQUE lay-codigo it-codigo
    INDEX idx-layout    lay-codigo.



/*--- Defini‡Æo das Vari veis ---*/
DEFINE VARIABLE i-lay-ini AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-lay-fim AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.



/*--- Parƒmetros do Programa ---*/
DEFINE INPUT  PARAMETER p-cod-layout AS INTEGER     NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-layout-tabpreco.
DEFINE OUTPUT PARAMETER TABLE FOR tt-preco-item.



/*--- Bloco Principal ---*/
IF  p-cod-layout > 0 THEN
    ASSIGN i-lay-ini = p-cod-layout
           i-lay-fim = p-cod-layout.
ELSE
    ASSIGN i-lay-ini = 0
           i-lay-fim = 999.


FOR EACH  layout-tabpreco NO-LOCK
    WHERE layout-tabpreco.lay-codigo >= i-lay-ini
    AND   layout-tabpreco.lay-codigo <= i-lay-fim,
    EACH  item-layout-tabpreco OF layout-tabpreco NO-LOCK,
    FIRST item FIELDS (it-codigo desc-item aliquota-ipi) OF item-layout-tabpreco NO-LOCK,
    FIRST preco-item FIELDS (situacao) NO-LOCK
    WHERE preco-item.it-codigo  = item-layout-tabpreco.it-codigo
    AND   preco-item.situacao   = 1
    AND   preco-item.cod-refer  = ''
    AND   preco-item.nr-tabpre  = '00101'
    AND   preco-item.dt-inival <= TODAY,
    FIRST int-preco-item FIELDS (pma pmd preco-unico) OF preco-item NO-LOCK
    BREAK BY layout-tabpreco.lay-nome
          BY item.desc-item:
    
    IF  FIRST-OF (layout-tabpreco.lay-nome) THEN DO:
        CREATE tt-layout-tabpreco.
        ASSIGN tt-layout-tabpreco.lay-codigo = layout-tabpreco.lay-codigo
               tt-layout-tabpreco.lay-nome   = layout-tabpreco.lay-nome.
    END.

    CREATE tt-preco-item.
    ASSIGN tt-preco-item.lay-codigo    = layout-tabpreco.lay-codigo
           tt-preco-item.it-codigo     = item.it-codigo
           tt-preco-item.desc-item     = item.desc-item
           tt-preco-item.aliquota-ipi  = item.aliquota-ipi
           tt-preco-item.pma           = int-preco-item.pma
           tt-preco-item.preco-com-ipi = (((item.aliquota-ipi / 100) + 1) * int-preco-item.pma).
END.



DELETE WIDGET-POOL.
RETURN "OK":U.
