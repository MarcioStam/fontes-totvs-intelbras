/*********************************************************************************
** Programa: esp/crm/escrm031.p
** Vers∆o..: 1.00
** Data....: 06/01/2011
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: API para retornar os Estabelecimentos relacionados com a Tabela de Preáo
*********************************************************************************/


CREATE WIDGET-POOL.


/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE TEMP-TABLE tt-estabelec NO-UNDO
    FIELD cod-estabel LIKE estabelec.cod-estabel
    FIELD nome        LIKE estabelec.nome.

DEFINE INPUT  PARAMETER p-nr-tabpre AS CHARACTER FORMAT "x(08)"  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-estabelec.




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
                    " - Tabela de Preáo: " p-nr-tabpre SKIP.
    OUTPUT CLOSE.
END.
/*****************************************************************/


IF  NOT CAN-FIND(FIRST tb-preco NO-LOCK
                 WHERE tb-preco.nr-tabpre = p-nr-tabpre) THEN DO:
    /******************** Log de Execuá∆o da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "N∆o encontrou a Tabela de Preáo (" + p-nr-tabpre + ")!" SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/
    RETURN "NOK":U.
END.

/******************** Log de Execuá∆o da API *********************/
IF  l-log THEN DO:
    IF  OPSYS = "WIN32":U THEN DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    ELSE DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    PUT UNFORMATTED "Ir† buscar os Estabelecimentos para a Tabela de Preáo (" + p-nr-tabpre + "):" SKIP.
    OUTPUT CLOSE.
END.
/*****************************************************************/

FOR EACH  crm-tab-estab NO-LOCK
    WHERE crm-tab-estab.nr-tabpre = p-nr-tabpre,
    FIRST estabelec NO-LOCK
    WHERE estabelec.cod-estabel = crm-tab-estab.cod-estabel:

    /******************** Log de Execuá∆o da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED " - Estabelecimento: " crm-tab-estab.cod-estabel SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/

    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cod-emitente = estabelec.cod-emitente NO-ERROR.

    CREATE tt-estabelec.
    ASSIGN tt-estabelec.cod-estabel = estabelec.cod-estabel
           tt-estabelec.nome        = IF AVAIL emitente THEN emitente.nome-abrev ELSE "".
END.


/******************** Log de Execuá∆o da API *********************/
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
