/*********************************************************************************
** Programa: esp/crm/escrm008.p
** VersÆo..: 1.00
** Data....: 30/09/2010
** Autor...: Estevan Krger - Exponencial TI
** Obs.....: API para calcular o % de Desconto que ser  dado ao cliente, e retornar
**           ao Portal B2B
*********************************************************************************/


CREATE WIDGET-POOL.


/*--- Defini‡Æo dos Parƒmetros ---*/
DEFINE INPUT  PARAMETER p-cod-cliente    AS INTEGER   FORMAT ">>>>>>>>9"     NO-UNDO.
DEFINE INPUT  PARAMETER p-ds-unid-comerc AS CHARACTER FORMAT "x(3)"          NO-UNDO.
DEFINE INPUT  PARAMETER p-cd-categoria   AS INTEGER   FORMAT ">>9"           NO-UNDO.
DEFINE INPUT  PARAMETER p-fm-cod-com     AS CHARACTER FORMAT "x(8)"          NO-UNDO.
DEFINE INPUT  PARAMETER p-quantidade     AS DECIMAL   FORMAT ">>>>,>>9.9999" NO-UNDO.
DEFINE OUTPUT PARAMETER p-desconto-qtd   AS DECIMAL   FORMAT ">>9.99"        NO-UNDO.



/*--- Defini‡Æo das Vari veis ---*/
DEFINE VARIABLE i-cod-gr-cli     AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cd-unid-comerc AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-log            AS LOGICAL     NO-UNDO.




/*--- Bloco Principal ---*/
ASSIGN l-log = YES.

/******************** Log de Execu‡Æo da API *********************/
IF  l-log THEN DO:
    IF  OPSYS = "WIN32":U THEN DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    ELSE DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    PUT UNFORMATTED "--------------------------------------------------------------------------------" SKIP
                    "Inicio API BuscarDesconto -- " + STRING(TODAY, "99/99/9999") + " - " + STRING(TIME, "HH:MM:SS") SKIP.
    PUT UNFORMATTED "Parametros Recebidos:" SKIP
                    " - C¢d Cliente.: " p-cod-cliente SKIP
                    " - Unid Comercial.: " p-ds-unid-comerc SKIP
                    " - C¢d Categoria.: " p-cd-categoria SKIP
                    " - Fam¡lia Comercial: " p-fm-cod-com SKIP
                    " - Quantidade: " p-quantidade SKIP.
    OUTPUT CLOSE.
END.
/*****************************************************************/


/* Valida as informa‡äes recebidas como parƒmetros */
IF  NOT CAN-FIND(FIRST crm-categoria NO-LOCK
                 WHERE crm-categoria.cd-categoria = p-cd-categoria) THEN DO:
    /******************** Log de Execu‡Æo da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "NÆo encontrou a Categoria (" + STRING(p-cd-categoria) + ")!" SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/

    RETURN "NOK":U.
END.

IF  NOT CAN-FIND(FIRST fam-comerc NO-LOCK
                 WHERE fam-comerc.fm-cod-com = p-fm-cod-com) THEN DO:
    /******************** Log de Execu‡Æo da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "NÆo encontrou a Fam¡lia Comercial (" + STRING(p-fm-cod-com) + ")!" SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/

    RETURN "NOK":U.
END.

FIND FIRST emitente NO-LOCK
    WHERE  emitente.cod-emitente = p-cod-cliente NO-ERROR.
IF  NOT AVAIL emitente THEN DO:
    /******************** Log de Execu‡Æo da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "NÆo encontrou o Cliente (" + STRING(p-cod-cliente) + ")!" SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/

    RETURN "NOK":U.
END.

IF  NOT CAN-FIND(FIRST gr-cli NO-LOCK
                 WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli) THEN DO:
    /******************** Log de Execu‡Æo da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "NÆo encontrou o Grupo de Cliente (" + STRING(emitente.cod-gr-cli) + ")!" SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/

    RETURN "NOK":U.
END.

ASSIGN i-cod-gr-cli = emitente.cod-gr-cli.


FIND FIRST unid-comerc NO-LOCK
    WHERE  unid-comerc.ds-unid-comerc = p-ds-unid-comerc NO-ERROR.
IF  NOT AVAIL unid-comerc THEN DO:
    /******************** Log de Execu‡Æo da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "NÆo encontrou a Unidade Comercial (" + STRING(p-ds-unid-comerc) + ")!" SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/

    RETURN "NOK":U.
END.

ASSIGN i-cd-unid-comerc = unid-comerc.cd-unid-comerc.




/* Busca o % de Desconto para a Fam¡lia do Produto, na Quantidade */
FIND FIRST crm-desc-qtd NO-LOCK
    WHERE  crm-desc-qtd.cd-unid-negoc    = STRING(i-cd-unid-comerc)
    AND    crm-desc-qtd.cod-gr-cli       = i-cod-gr-cli
    AND    crm-desc-qtd.cd-categoria     = p-cd-categoria
    AND    crm-desc-qtd.fm-cod-com       = p-fm-cod-com
    AND    crm-desc-qtd.dt-vigencia-ini <= TODAY
    AND   (IF crm-desc-qtd.dt-vigencia-fim <> ? THEN crm-desc-qtd.dt-vigencia-fim > TODAY ELSE YES)
    AND    crm-desc-qtd.qtd-ini         <= p-quantidade
    AND    crm-desc-qtd.qtd-fim         >= p-quantidade NO-ERROR.
/******************** Log de Execu‡Æo da API *********************/
IF  l-log THEN DO:
    IF  OPSYS = "WIN32":U THEN DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    ELSE DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    PUT UNFORMATTED "Encontrou Desconto para a Faixa de Quantidade (crm-desc-qtd)? " AVAIL crm-desc-qtd SKIP
                    " - Unid Comercial: " i-cd-unid-comerc SKIP
                    " - Grupo Cliente: " i-cod-gr-cli SKIP
                    " - Categoria: " p-cd-categoria SKIP
                    " - Fam Comerc: " p-fm-cod-com SKIP.
    OUTPUT CLOSE.
END.
/*****************************************************************/
IF  AVAIL  crm-desc-qtd THEN DO:
    /******************** Log de Execu‡Æo da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "Desconto (crm-des-qtd): " + STRING(crm-desc-qtd.pc-desconto) + " %" SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/

    ASSIGN p-desconto-qtd = crm-desc-qtd.pc-desconto.
END.



/******************** Log de Execu‡Æo da API *********************/
IF  l-log THEN DO:
    IF  OPSYS = "WIN32":U THEN DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    ELSE DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    PUT UNFORMATTED "--------------------------------------------------------------------------------" SKIP(2).
    OUTPUT CLOSE.
END.
/*****************************************************************/

DELETE WIDGET-POOL.
RETURN "OK":U.
