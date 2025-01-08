{include/i-prgvrs.i ESBOIN175 2.04.00.001}
/***********************************************************************
**  Programa..: esbo/esboin175.p
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Cria/Altera Tabela item-desenho via BO
**  Vers∆o....: 001 06/11/2004 - Marcio Chaves
**                  Desenvolvimento Programa
************************************************************************/

{cdp/cd0666.i}          /* Definicao da temp-table de erros */

DEF TEMP-TABLE rowerrors NO-UNDO    /* Temp-table dos erros */
    FIELD errorsequence    AS INT
    FIELD errornumber      AS INT
    FIELD errordescription AS CHAR FORMAT "x(150)"
    FIELD errorparameters  AS CHAR
    FIELD errortype        AS CHAR
    FIELD errorhelp        AS CHAR FORMAT "x(150)"
    FIELD errorsubtype     AS CHAR.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE l-data                  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE iRowsReturned           AS INTEGER   NO-UNDO. 
DEFINE VARIABLE epc-rowid1              AS ROWID     NO-UNDO.
DEFINE VARIABLE cReturnAux              AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-sequencia             AS INTEGER   NO-UNDO.
DEFINE VARIABLE hDBOin175 AS HANDLE NO-UNDO. /* item-desenho */

DEFINE TEMP-TABLE ttTableAux NO-UNDO LIKE item-desenho
       FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE ttitem-desenho NO-UNDO LIKE item-desenho
       FIELD r-rowid AS ROWID.


DEFINE INPUT  PARAMETER pFuncao AS CHARACTER NO-UNDO.
/*
CASE pFUNCAO
WHEN "ADD" - Cria item-desenho 
WHEN "MOD" - Modifica item-desenho
*/
DEFINE INPUT  PARAMETER TABLE    FOR ttitem-desenho.
DEFINE OUTPUT PARAMETER TABLE    FOR tt-erro.

SESSION:SET-WAIT-STATE("GENERAL":U).
/*--- Verifica se o DBO (item-desenho) j† est† inicializado ---*/
IF NOT VALID-HANDLE(hDBOin175) OR 
   hDBOin175:TYPE <> "PROCEDURE":U OR
   hDBOin175:FILE-NAME <> "inbo/BOin175.p":U THEN DO:
   RUN inbo/BOin175.p PERSISTEN SET hDBOin175.
END.
RUN openquerystatic IN hDBOin175 ('main').
/*--- Limpa temp-table RowErrors no DBO ---*/
RUN emptyRowErrors IN hDBOin175.

dbo-logic:
DO TRANSACTION:
    IF NOT VALID-HANDLE(hDBOin175) THEN LEAVE dbo-logic.
    /* Limpa a tt auxiliar */
    FOR EACH ttTableAux:
        DELETE ttTableAux.
    END.
    RUN piAtualizaTabTemp.
    RUN piAtualizaBase.
END.

IF  VALID-HANDLE(hDBOin175) THEN
    RUN destroy IN hDBOin175.
/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).

/******** FIM PROGRAMA *********/

PROCEDURE piAtualizaTabTemp:
    FIND FIRST ttitem-desenho NO-LOCK NO-ERROR.
    IF NOT AVAIL ttitem-desenho THEN RETURN ERROR.
    IF ttitem-desenho.r-rowid = ? AND pFuncao = "MOD" THEN
        RETURN ERROR.
    
    IF   pFuncao = "ADD" THEN DO:
         RUN newRecord IN hDBOin175.
         /* Busca esse registro novo com os initials da tabela */
         RUN getRecord IN hDBOin175 (OUTPUT TABLE ttTableAux).
         IF  RETURN-VALUE <> "NOK":U THEN DO:
             FOR FIRST ttTableAux EXCLUSIVE-LOCK:
                 BUFFER-COPY ttitem-desenho TO ttTableAux. END.
         END.
         ELSE RUN piErros.
    END. /* ADD */ 
    ELSE DO:
        CREATE ttTableAux.
        BUFFER-COPY ttitem-desenho TO ttTableAux.
        RUN repositionRecord IN hDBOin175 (INPUT ttitem-desenho.r-rowid).
        RUN piErros.
    END. /* MOD */
END.

PROCEDURE piAtualizaBase:
    /* Passa o conte£do da tt para a BO */
    RUN setRecord IN hDBOin175 (INPUT TABLE ttTableAux).
    RUN piErros.
    IF   pFuncao = "ADD" THEN 
         RUN createRecord IN hDBOin175.
    ELSE IF  pFuncao = "MOD" THEN 
         RUN updateRecord IN hDBOin175.
    ELSE IF  pFuncao = "DEL" THEN 
         RUN DeleteRecord IN hDBOin175.
    RUN piErros.
END.


PROCEDURE piErros:
    IF  RETURN-VALUE = 'NOK':U THEN DO:
        RUN getRowErrors IN hDBOin175 (OUTPUT TABLE RowErrors).
        FOR EACH RowErrors:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 17567
                   tt-erro.mensagem = RowErrors.errordescription.
        END.
        RETURN ERROR.
    END.
END.
