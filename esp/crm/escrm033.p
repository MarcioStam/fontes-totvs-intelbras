/*********************************************************************************
** Programa: esp/crm/escrm033.p
** VersÆo..: 1.00
** Data....: 14/02/2011
** Autor...: Anderson Cenci 
** Obs.....: API para retornar O indice de financiamento de acordo com a condi‡Æo de pagamento
*********************************************************************************/


CREATE WIDGET-POOL.


/*--- Defini‡Æo dos Parƒmetros ---*/
DEFINE INPUT  PARAMETER p-cod-cond-pag LIKE cond-pagto.cod-cond-pag    NO-UNDO.
DEFINE OUTPUT PARAMETER p-indice-financiamento AS DECIMAL             NO-UNDO.


DEFINE VARIABLE l-log AS LOGICAL     NO-UNDO.
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
                    "Inicio API BuscarIndiceFinanciamento -- " + STRING(TODAY, "99/99/9999") + " - " + STRING(TIME, "HH:MM:SS") SKIP.
    PUT UNFORMATTED "Parametros Recebidos:" SKIP
                    " - Condicao de Pagamento: " p-cod-cond-pag SKIP.
    OUTPUT CLOSE.
END.
/*****************************************************************/
                                                                      
FIND cond-pagto
     WHERE cond-pagto.cod-cond-pag = p-cod-cond-pag
     NO-LOCK NO-ERROR.
IF AVAIL cond-pagto THEN DO:
    FIND TAB-finan 
        WHERE tab-finan.nr-tab-finan = cond-pagto.nr-tab-finan
        NO-LOCK NO-ERROR.
    IF AVAIL tab-finan AND
        tab-finan.dt-ini-val <= TODAY AND
        tab-finan.dt-fim-val >= TODAY THEN DO:

        FIND FIRST tab-finan-indice NO-LOCK
             WHERE tab-finan-indice.nr-tab-finan = cond-pagto.nr-tab-finan
               AND tab-finan-indice.num-seq = cond-pagto.nr-ind-finan NO-ERROR.

        IF AVAIL tab-finan-indice THEN DO:
            ASSIGN  p-indice-financiamento = tab-finan-indice.tab-ind-fin.
        END.
    END.

END.



/******************** Log de Execu‡Æo da API *********************/
IF  l-log THEN DO:
    IF  OPSYS = "WIN32":U THEN DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    ELSE DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    PUT UNFORMATTED "Indice Encontrado : " p-indice-financiamento  SKIP
                    "--------------------------------------------------------------------------------" SKIP(2).
    OUTPUT CLOSE.
END.
/*****************************************************************/


DELETE WIDGET-POOL.
RETURN "OK":U.
