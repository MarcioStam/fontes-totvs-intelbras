/*********************************************************************************
** Programa: esp/crm/escrm032.p
** Vers∆o..: 1.00
** Data....: 14/02/2011
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: API para retornar se a Cidade Ç uma Cidade da Zona Franca de Manaus
*********************************************************************************/


CREATE WIDGET-POOL.


/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER p-cidade    AS CHARACTER FORMAT "x(25)"  NO-UNDO.
DEFINE INPUT  PARAMETER p-uf        AS CHARACTER FORMAT "x(04)"  NO-UNDO.
DEFINE OUTPUT PARAMETER p-cidade-zf AS LOGICAL                   NO-UNDO.




/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE l-log AS LOGICAL     NO-UNDO.




/*--- Bloco Principal ---*/
ASSIGN l-log = YES.

/******************** Log de Execuá∆o da API *********************/
IF  l-log THEN DO:
    IF  OPSYS = "WIN32":U THEN DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    ELSE DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    PUT UNFORMATTED "--------------------------------------------------------------------------------" SKIP
                    "Inicio API BuscarEstabTabPreco -- " + STRING(TODAY, "99/99/9999") + " - " + STRING(TIME, "HH:MM:SS") SKIP.
    PUT UNFORMATTED "Parametros Recebidos:" SKIP
                    " - Cidade: " p-cidade SKIP
                    " - UF: " p-uf SKIP.
    OUTPUT CLOSE.
END.
/*****************************************************************/


ASSIGN p-cidade-zf = (CAN-FIND(FIRST cidade-zf NO-LOCK
                               WHERE cidade-zf.cidade = p-cidade
                               AND   cidade-zf.estado = p-uf)).


/******************** Log de Execuá∆o da API *********************/
IF  l-log THEN DO:
    IF  OPSYS = "WIN32":U THEN DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    ELSE DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    PUT UNFORMATTED "ê cidade da ZF? " + STRING(p-cidade-zf) SKIP
                    "--------------------------------------------------------------------------------" SKIP(2).
    OUTPUT CLOSE.
END.
/*****************************************************************/


DELETE WIDGET-POOL.
RETURN "OK":U.
