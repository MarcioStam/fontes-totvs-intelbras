{include/i-prgvrs.i ESBOIN158 2.04.00.001}
/***********************************************************************
**  Programa..: esbo\esboin158.p
**  Autor.....: Marcio Chaves - Gestech
**  Data......: DEZEMBRO/2004 - Desenvolvimento
**  Descricao.: Cria/Altera Tabela it-carac-tec via BO
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
DEFINE VARIABLE hDBOin158 AS HANDLE NO-UNDO. /* it-carac-tec */

DEFINE TEMP-TABLE ttTableAux NO-UNDO LIKE it-carac-tec
       FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE ttit-carac-tec NO-UNDO LIKE it-carac-tec
       FIELD r-rowid AS ROWID.


DEFINE INPUT  PARAMETER pFuncao AS CHARACTER NO-UNDO.
/*
CASE pFUNCAO
WHEN "ADD" - Cria it-carac-tec 
WHEN "MOD" - Modifica it-carac-tec
*/
DEFINE INPUT  PARAMETER TABLE    FOR ttit-carac-tec.
DEFINE OUTPUT PARAMETER TABLE    FOR tt-erro.

SESSION:SET-WAIT-STATE("GENERAL":U).
/*--- Verifica se o DBO (it-carac-tec) j† est† inicializado ---*/
IF NOT VALID-HANDLE(hDBOin158) OR 
   hDBOin158:TYPE <> "PROCEDURE":U OR
   hDBOin158:FILE-NAME <> "inbo/boin158.p":U THEN DO:
   RUN inbo/boin158.p PERSISTEN SET hDBOin158.
END.
RUN openquerystatic IN hDBOin158 ('main').
/*--- Limpa temp-table RowErrors no DBO ---*/
RUN emptyRowErrors IN hDBOin158.

dbo-logic:
DO TRANSACTION:
    IF NOT VALID-HANDLE(hDBOin158) THEN LEAVE dbo-logic.
    /* Limpa a tt auxiliar */
    FOR EACH ttTableAux:
        DELETE ttTableAux.
    END.
    RUN piAtualizaTabTemp.
    RUN piAtualizaBase.
END.

IF  VALID-HANDLE(hDBOin158) THEN
    RUN destroy IN hDBOin158.
/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).

/******** FIM PROGRAMA *********/

PROCEDURE piAtualizaTabTemp:
    FIND FIRST ttit-carac-tec NO-LOCK NO-ERROR.
    IF NOT AVAIL ttit-carac-tec THEN RETURN ERROR.
    IF ttit-carac-tec.r-rowid = ? AND pFuncao = "MOD" THEN
        RETURN ERROR.
    
    IF   pFuncao = "ADD" THEN DO:
         RUN newRecord IN hDBOin158.
         /* Busca esse registro novo com os initials da tabela */
         RUN getRecord IN hDBOin158 (OUTPUT TABLE ttTableAux).
         IF  RETURN-VALUE <> "NOK":U THEN DO:
             FOR FIRST ttTableAux EXCLUSIVE-LOCK:
                 BUFFER-COPY ttit-carac-tec TO ttTableAux. END.
         END.
         ELSE RUN piErros.
    END. /* ADD */ 
    ELSE DO:
        CREATE ttTableAux.
        BUFFER-COPY ttit-carac-tec TO ttTableAux.
        RUN repositionRecord IN hDBOin158 (INPUT ttit-carac-tec.r-rowid).
        RUN piErros.
    END. /* MOD */
END.

PROCEDURE piAtualizaBase:
    /* Passa o conte£do da tt para a BO */
    RUN setRecord IN hDBOin158 (INPUT TABLE ttTableAux).
    RUN piErros.
    IF   pFuncao = "ADD" THEN 
         RUN createRecord IN hDBOin158.
    ELSE IF  pFuncao = "MOD" THEN 
         RUN updateRecord IN hDBOin158.
    ELSE IF  pFuncao = "DEL" THEN 
         RUN DeleteRecord IN hDBOin158.
    RUN piErros.
END.


PROCEDURE piErros:
    IF  RETURN-VALUE = 'NOK':U THEN DO:
        RUN getRowErrors IN hDBOin158 (OUTPUT TABLE RowErrors).
        FOR EACH RowErrors:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 17567
                   tt-erro.mensagem = RowErrors.errordescription.
        END.
        RETURN ERROR.
    END.
END.
