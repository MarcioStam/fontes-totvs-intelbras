{include/i-prgvrs.i ESBOIN390 2.04.00.001}
/***********************************************************************
**  Programa..: esbo/esboin390.p
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Cria/Altera Tabela reservas via BO
**  Vers∆o....: 001 18/11/2004 - Marcio Chaves
**                  Desenvolvimento Programa
************************************************************************/

DEF TEMP-TABLE rowerrors NO-UNDO    /* Temp-table dos erros */
    FIELD errorsequence    AS INT
    FIELD errornumber      AS INT
    FIELD errordescription AS CHAR FORMAT "x(150)"
    FIELD errorparameters  AS CHAR
    FIELD errortype        AS CHAR
    FIELD errorhelp        AS CHAR FORMAT "x(150)"
    FIELD errorsubtype     AS CHAR.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD descricao     AS CHAR format "x(132)".

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE l-data                  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE iRowsReturned           AS INTEGER   NO-UNDO. 
DEFINE VARIABLE epc-rowid1              AS ROWID     NO-UNDO.
DEFINE VARIABLE cReturnAux              AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-sequencia             AS INTEGER   NO-UNDO.
DEFINE VARIABLE hDBOin390 AS HANDLE NO-UNDO. /* reservas */
DEFINE VARIABLE c-usuario        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-senha          AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE ttTableAux NO-UNDO LIKE reservas
       FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE ttreservas NO-UNDO LIKE reservas
       FIELD r-rowid AS ROWID.

DEFINE INPUT  PARAMETER pFuncao AS CHARACTER NO-UNDO.
/*
CASE pFUNCAO
WHEN "ADD" - Cria reservas 
WHEN "MOD" - Modifica reservas
*/
DEFINE INPUT        PARAMETER TABLE    FOR ttreservas.
DEFINE INPUT-OUTPUT PARAMETER TABLE    FOR tt-erro.
DEFINE OUTPUT       PARAMETER p-erro   AS LOG NO-UNDO.

SESSION:SET-WAIT-STATE("GENERAL":U).
/*--- Verifica se o DBO (reservas) j† est† inicializado ---*/
IF NOT VALID-HANDLE(hDBOin390) OR 
   hDBOin390:TYPE <> "PROCEDURE":U OR
   hDBOin390:FILE-NAME <> "inbo/boin390.p":U THEN DO:

    /** Conex∆o com o EMS para a execuá∆o de BO **/
    FIND FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "esboin390":U
          AND ponto-programa.ponto         = 1 NO-LOCK NO-ERROR.
    
    IF AVAILABLE ponto-programa THEN DO:
        FOR EACH conteudo-programa
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa NO-LOCK:
            
            IF conteudo-programa.sequencia = 1 THEN DO:
                assign c-usuario = ENTRY(1,conteudo-programa.conteudo,",")
                       c-senha   = ENTRY(2,conteudo-programa.conteudo,",").
            END.
        END.
    END.
    
    RUN bi/esbi002.p (INPUT c-usuario,
                      INPUT c-senha).

    RUN inbo/boin390.p PERSISTEN SET hDBOin390.
END.
RUN openquerystatic IN hDBOin390 ('main').
/*--- Limpa temp-table RowErrors no DBO ---*/
RUN emptyRowErrors IN hDBOin390.

dbo-logic:
DO TRANSACTION:
    IF NOT VALID-HANDLE(hDBOin390) THEN LEAVE dbo-logic.
    /* Limpa a tt auxiliar */
    FOR EACH ttTableAux:
        DELETE ttTableAux.
    END.
    RUN piAtualizaTabTemp.
    RUN piAtualizaBase.
END.

IF  VALID-HANDLE(hDBOin390) THEN
    RUN destroy IN hDBOin390.
/*--- Seta cursor do mouse para normal ---*/
SESSION:SET-WAIT-STATE("":U).

/******** FIM PROGRAMA *********/

PROCEDURE piAtualizaTabTemp:
    FIND FIRST ttreservas NO-LOCK NO-ERROR.
    IF NOT AVAIL ttreservas THEN RETURN ERROR.
    IF ttreservas.r-rowid = ? AND pFuncao = "MOD" THEN
        RETURN ERROR.
    
    IF   pFuncao = "ADD" THEN DO:
         RUN newRecord IN hDBOin390.
         /* Busca esse registro novo com os initials da tabela */
         RUN getRecord IN hDBOin390 (OUTPUT TABLE ttTableAux).
         IF  RETURN-VALUE <> "NOK":U THEN DO:
             FOR FIRST ttTableAux EXCLUSIVE-LOCK:
                 BUFFER-COPY ttreservas TO ttTableAux. END.
         END.
         ELSE RUN piErros.
    END. /* ADD */ 
    ELSE DO:
        CREATE ttTableAux.
        BUFFER-COPY ttreservas TO ttTableAux.
        RUN repositionRecord IN hDBOin390 (INPUT ttreservas.r-rowid).
        RUN piErros.
    END. /* MOD */
END.

PROCEDURE piAtualizaBase:
    /* Passa o conte£do da tt para a BO */
    RUN setRecord IN hDBOin390 (INPUT TABLE ttTableAux).
    RUN piErros.
    IF   pFuncao = "ADD" THEN 
         RUN createRecord IN hDBOin390.
    ELSE IF  pFuncao = "MOD" THEN 
         RUN updateRecord IN hDBOin390.
    ELSE IF  pFuncao = "DEL" THEN 
         RUN DeleteRecord IN hDBOin390.
    RUN piErros.
END.


PROCEDURE piErros:
    IF  RETURN-VALUE = 'NOK':U THEN DO:
        RUN getRowErrors IN hDBOin390 (OUTPUT TABLE RowErrors).
        FOR EACH RowErrors:
            CREATE tt-erro.
            ASSIGN tt-erro.descricao = RowErrors.errordescription
                   p-erro            = YES.
        END.
        RETURN ERROR.
    END.
END.
