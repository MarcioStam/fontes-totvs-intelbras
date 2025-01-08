{include/i-prgvrs.i ESBOIN165 2.04.00.001}
/***********************************************************************
**  Programa..: esbo\esboin165.p
**  Autor.....: Marcio Chaves - Gestech
**  Data......: DEZEMBRO/2004 - Desenvolvimento
**  Descricao.: Cria/Altera Tabela it-msg-carac via BO
**  Vers∆o....: 001 11/12/2004 - Marcio Chaves
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
DEFINE VARIABLE hDBOin165 AS HANDLE NO-UNDO. /* it-msg-carac */

DEFINE TEMP-TABLE ttTableAux NO-UNDO LIKE it-msg-carac
       FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE ttit-msg-carac NO-UNDO LIKE it-msg-carac
       FIELD r-rowid AS ROWID.


DEFINE INPUT  PARAMETER pFuncao AS CHARACTER NO-UNDO.
/*
CASE pFUNCAO
WHEN "ADD" - Cria it-msg-carac 
WHEN "MOD" - Modifica it-msg-carac
*/
DEFINE INPUT  PARAMETER TABLE    FOR ttit-msg-carac.
DEFINE OUTPUT PARAMETER TABLE    FOR tt-erro.

SESSION:SET-WAIT-STATE("GENERAL":U).
/*--- Verifica se o DBO (it-msg-carac) j† est† inicializado ---*/
IF NOT VALID-HANDLE(hDBOin165) OR 
   hDBOin165:TYPE <> "PROCEDURE":U OR
   hDBOin165:FILE-NAME <> "inbo/boin165.p":U THEN DO:
   RUN inbo/boin165.p PERSISTEN SET hDBOin165.
END.
RUN openquerystatic IN hDBOin165 ('main').
/*--- Limpa temp-table RowErrors no DBO ---*/
RUN emptyRowErrors IN hDBOin165.

dbo-logic:
DO TRANSACTION:
    IF NOT VALID-HANDLE(hDBOin165) THEN LEAVE dbo-logic.
    /* Limpa a tt auxiliar */
    FOR EACH ttTableAux:
        DELETE ttTableAux.
    END.
    RUN piAtualizaTabTemp.
    RUN piAtualizaBase.
END.

IF  VALID-HANDLE(hDBOin165) THEN
    RUN destroy IN hDBOin165.
/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).

/******** FIM PROGRAMA *********/

PROCEDURE piAtualizaTabTemp:
    FIND FIRST ttit-msg-carac NO-LOCK NO-ERROR.
    IF NOT AVAIL ttit-msg-carac THEN RETURN ERROR.
    IF ttit-msg-carac.r-rowid = ? AND pFuncao = "MOD" THEN
        RETURN ERROR.
    
    IF   pFuncao = "ADD" THEN DO:
         RUN newRecord IN hDBOin165.
         /* Busca esse registro novo com os initials da tabela */
         RUN getRecord IN hDBOin165 (OUTPUT TABLE ttTableAux).
         IF  RETURN-VALUE <> "NOK":U THEN DO:
             FOR FIRST ttTableAux EXCLUSIVE-LOCK:
                 BUFFER-COPY ttit-msg-carac TO ttTableAux. END.
         END.
         ELSE RUN piErros.
    END. /* ADD */ 
    ELSE DO:
        CREATE ttTableAux.
        BUFFER-COPY ttit-msg-carac TO ttTableAux.
        RUN repositionRecord IN hDBOin165 (INPUT ttit-msg-carac.r-rowid).
        RUN piErros.
    END. /* MOD */
END.

PROCEDURE piAtualizaBase:
    /* Passa o conte£do da tt para a BO */
    RUN setRecord IN hDBOin165 (INPUT TABLE ttTableAux).
    RUN piErros.
    IF   pFuncao = "ADD" THEN 
         RUN CreateRecord IN hDBOin165.
    ELSE IF  pFuncao = "MOD" THEN 
         RUN UpdateRecord IN hDBOin165.
    ELSE IF  pFuncao = "DEL" THEN 
         RUN DeleteRecord IN hDBOin165.
    RUN piErros.
END.


PROCEDURE piErros:
    IF  RETURN-VALUE = 'NOK':U THEN DO:
        RUN getRowErrors IN hDBOin165 (OUTPUT TABLE RowErrors).
        FOR EACH RowErrors:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 17567
                   tt-erro.mensagem = RowErrors.errordescription.
        END.
        RETURN ERROR.
    END.
END.
