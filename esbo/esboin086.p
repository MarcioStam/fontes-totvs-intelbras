{include/i-prgvrs.i ESBOIN086 2.04.00.001}
/***********************************************************************
**  Programa..: esbo\esboin086.p
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Cria/Altera Tabela desenho-item via BO
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
DEFINE VARIABLE hDBOin086 AS HANDLE NO-UNDO. /* desenho-item */

DEFINE TEMP-TABLE ttTableAux NO-UNDO LIKE desenho-item
       FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE ttdesenho-item NO-UNDO LIKE desenho-item
       FIELD r-rowid AS ROWID.


DEFINE INPUT  PARAMETER pFuncao AS CHARACTER NO-UNDO.
/*
CASE pFUNCAO
WHEN "ADD" - Cria desenho-item 
WHEN "MOD" - Modifica desenho-item
*/
DEFINE INPUT  PARAMETER TABLE    FOR ttdesenho-item.
DEFINE OUTPUT PARAMETER TABLE    FOR tt-erro.

SESSION:SET-WAIT-STATE("GENERAL":U).
/*--- Verifica se o DBO (desenho-item) j† est† inicializado ---*/
IF NOT VALID-HANDLE(hDBOin086) OR 
   hDBOin086:TYPE <> "PROCEDURE":U OR
   hDBOin086:FILE-NAME <> "inbo/boin086.p":U THEN DO:
   RUN inbo/boin086.p PERSISTEN SET hDBOin086.
END.
RUN openquerystatic IN hDBOin086 ('main').
/*--- Limpa temp-table RowErrors no DBO ---*/
RUN emptyRowErrors IN hDBOin086.

dbo-logic:
DO TRANSACTION:
    IF NOT VALID-HANDLE(hDBOin086) THEN LEAVE dbo-logic.
    /* Limpa a tt auxiliar */
    FOR EACH ttTableAux:
        DELETE ttTableAux.
    END.
    RUN piAtualizaTabTemp.
    RUN piAtualizaBase.
END.

IF  VALID-HANDLE(hDBOin086) THEN
    RUN destroy IN hDBOin086.
/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).

/******** FIM PROGRAMA *********/

PROCEDURE piAtualizaTabTemp:
    FIND FIRST ttdesenho-item NO-LOCK NO-ERROR.
    IF NOT AVAIL ttdesenho-item THEN RETURN ERROR.
    IF ttdesenho-item.r-rowid = ? AND pFuncao = "MOD" THEN
        RETURN ERROR.
    
    IF   pFuncao = "ADD" THEN DO:
         RUN newRecord IN hDBOin086.
         /* Busca esse registro novo com os initials da tabela */
         RUN getRecord IN hDBOin086 (OUTPUT TABLE ttTableAux).
         IF  RETURN-VALUE <> "NOK":U THEN DO:
             FOR FIRST ttTableAux EXCLUSIVE-LOCK:
                 BUFFER-COPY ttdesenho-item TO ttTableAux. END.
         END.
         ELSE RUN piErros.
    END. /* ADD */ 
    ELSE DO:
        CREATE ttTableAux.
        BUFFER-COPY ttdesenho-item TO ttTableAux.
        RUN repositionRecord IN hDBOin086 (INPUT ttdesenho-item.r-rowid).
        RUN piErros.
    END. /* MOD */
END.

PROCEDURE piAtualizaBase:
    /* Passa o conte£do da tt para a BO */
    RUN setRecord IN hDBOin086 (INPUT TABLE ttTableAux).
    RUN piErros.
    IF   pFuncao = "ADD" THEN 
         RUN createRecord IN hDBOin086.
    ELSE IF  pFuncao = "MOD" THEN 
         RUN updateRecord IN hDBOin086.
    ELSE IF  pFuncao = "DEL" THEN 
         RUN DeleteRecord IN hDBOin086.
    RUN piErros.
END.


PROCEDURE piErros:
    IF  RETURN-VALUE = 'NOK':U THEN DO:
        RUN getRowErrors IN hDBOin086 (OUTPUT TABLE RowErrors).
        FOR EACH RowErrors:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 17567
                   tt-erro.mensagem = RowErrors.errordescription.
        END.
        RETURN ERROR.
    END.
END.
