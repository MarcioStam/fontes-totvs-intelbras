&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i boes908 2.00.00.003}  /*** 010003 ***/
/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName boes908
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName int-rateio
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS tipo-rateio, Main

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{esbo/boes908.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE cCd-rateio-ini      AS INT  NO-UNDO.
DEFINE VARIABLE cCd-rateio-fim      AS INT  NO-UNDO.
DEFINE VARIABLE cCd-competencia-ini AS CHAR NO-UNDO.
DEFINE VARIABLE cCd-competencia-fim AS CHAR NO-UNDO.
DEFINE VARIABLE cCd-cod-estabel-ini AS CHAR NO-UNDO.
DEFINE VARIABLE cCd-cod-estabel-fim AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 18.54
         WIDTH              = 43.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*RUN sbp/sb0001.p ( "mgesp", "int-rateio", "inc", ROWID(int-rateio) ).*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*RUN sbp/sb0001.p ( "mgesp", "int-rateio", "alt", RowObject.r-rowid).*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN clearint-rateio (INPUT RowObject.tipo-rateio,
                         INPUT RowObject.competencia,
                         INPUT RowObject.cod-estabel ).
    IF  RETURN-VALUE = 'NOK' THEN
        RETURN 'NOK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearint-rateio DBOProgram 
PROCEDURE clearint-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pTipo-Rateio LIKE int-rateio.Tipo-Rateio NO-UNDO.
    DEFINE INPUT  PARAMETER pCompetencia LIKE int-rateio.Competencia NO-UNDO.
    DEFINE INPUT  PARAMETER pCod-Estabel LIKE int-rateio.Cod-Estabel NO-UNDO.
    
    DEFINE VARIABLE hdboes909         AS HANDLE     NO-UNDO.

    /********************** DELETAR A TABELA int-rat-desp-lancto ************************/
    RUN esbo/boes909.p PERSISTENT SET hdboes909.
    IF  NOT VALID-HANDLE(hdboes909) THEN
        RETURN 'NOK':U.

    RUN openQueryStatic IN hdboes909 ('Main').

    FOR EACH int-rateio-fatur
        WHERE int-rateio-fatur.tipo-rateio = pTipo-rateio
          AND int-rateio-fatur.competencia = pCompetencia
          AND int-rateio-fatur.cod-estabel = pCod-Estabel NO-LOCK:

        RUN repositionRecord IN hdboes909 (ROWID(int-rateio-fatur)).
        RUN deleteRecord IN hdboes909.

        IF RETURN-VALUE = 'NOK' THEN DO:
            RUN getRowErrors IN hdboes909 (OUTPUT TABLE RowErrors).
            LEAVE.
        END.
    END.

    RUN destroy IN hdboes909.

    /*--- Verifica ocorrància de erros ---*/
    IF  CAN-FIND(FIRST RowErrors
                 WHERE RowErrors.ErrorSubType = "ERROR":U
                   AND RowErrors.ErrorType    <> "INTERNAL":U) THEN
        RETURN 'NOK':U.


    /********************** DELETAR A TABELA int-rat-desp-lancto ************************/
    DEFINE VARIABLE hdboes910         AS HANDLE     NO-UNDO.

    /* Elimina relacionamentos com int-rat-desp-FAIXA invocando a BO respectiva */
    RUN esbo/boes910.p PERSISTENT SET hdboes910.
    IF  NOT VALID-HANDLE(hdboes910) THEN
        RETURN 'NOK':U.

    RUN openQueryStatic IN hdboes910 ('Main').

    FOR EACH int-rateio-plan
        WHERE int-rateio-plan.tipo-rateio = pTipo-rateio
          AND int-rateio-plan.competencia = pCompetencia
          AND int-rateio-plan.cod-estabel = pCod-Estabel NO-LOCK:

        RUN repositionRecord IN hdboes910 (ROWID(int-rateio-plan)).
        RUN deleteRecord IN hdboes910.

        IF RETURN-VALUE = 'NOK' THEN DO:
            RUN getRowErrors IN hdboes910 (OUTPUT TABLE RowErrors).
            LEAVE.
        END.
    END.

    RUN destroy IN hdboes910.

    /*--- Verifica ocorrància de erros ---*/
    IF  CAN-FIND(FIRST RowErrors
                 WHERE RowErrors.ErrorSubType = "ERROR":U
                   AND RowErrors.ErrorType    <> "INTERNAL":U) THEN
        RETURN 'NOK':U.

    DO TRANS:
    
        FOR EACH int-rateio-hist EXCLUSIVE-LOCK
            WHERE int-rateio-hist.tipo-rateio =  pTipo-rateio 
              AND int-rateio-hist.competencia =  pCompetencia 
              AND int-rateio-hist.cod-estabel =  pCod-Estabel :

            DELETE int-rateio-hist.
        
        END.
    
    END.
    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstTipo-rateio DBOProgram 
PROCEDURE findFirstRateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST {&TableName} NO-LOCK WHERE 
        {&TableName}.tipo-rateio >= cCd-rateio-ini AND
        {&TableName}.tipo-rateio <= cCd-rateio-fim AND 
        {&TableName}.competencia >= cCd-competencia-ini AND
        {&TableName}.competencia <= cCd-competencia-fim AND 
        {&TableName}.cod-estabel >= cCd-cod-estabel-ini AND
        {&TableName}.cod-estabel <= cCd-cod-estabel-fim NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstMain DBOProgram 
PROCEDURE findFirstMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST {&TableName} NO-LOCK NO-ERROR.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastTipo-Rateio DBOProgram 
PROCEDURE findLastRateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST {&TableName} NO-LOCK WHERE 
        {&TableName}.tipo-rateio >= cCd-rateio-ini AND
        {&TableName}.tipo-rateio <= cCd-rateio-fim AND 
        {&TableName}.competencia >= cCd-competencia-ini AND
        {&TableName}.competencia <= cCd-competencia-fim AND 
        {&TableName}.cod-estabel >= cCd-cod-estabel-ini AND
        {&TableName}.cod-estabel <= cCd-cod-estabel-fim NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastMain DBOProgram 
PROCEDURE findLastMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST {&TableName} NO-LOCK NO-ERROR.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextTipo-rateio DBOProgram 
PROCEDURE findNextrateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND NEXT {&TableName} NO-LOCK WHERE 
        {&TableName}.tipo-rateio >= cCd-rateio-ini AND
        {&TableName}.tipo-rateio <= cCd-rateio-fim AND 
        {&TableName}.competencia >= cCd-competencia-ini AND
        {&TableName}.competencia <= cCd-competencia-fim AND 
        {&TableName}.cod-estabel >= cCd-cod-estabel-ini AND
        {&TableName}.cod-estabel <= cCd-cod-estabel-fim NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextMain DBOProgram 
PROCEDURE findNextMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND NEXT {&TableName} NO-LOCK NO-ERROR.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevTipo-rateio DBOProgram 
PROCEDURE findPrevTipo-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND PREV {&TableName} NO-LOCK WHERE 
        {&TableName}.tipo-rateio >= cCd-rateio-ini AND
        {&TableName}.tipo-rateio <= cCd-rateio-fim AND 
        {&TableName}.competencia >= cCd-competencia-ini AND
        {&TableName}.competencia <= cCd-competencia-fim AND 
        {&TableName}.cod-estabel >= cCd-cod-estabel-ini AND
        {&TableName}.cod-estabel <= cCd-cod-estabel-fim NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevMain DBOProgram 
PROCEDURE findPrevMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND PREV {&TableName} NO-LOCK NO-ERROR.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "competencia":U THEN ASSIGN pFieldValue = RowObject.competencia.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "char-1":U      THEN ASSIGN pFieldValue = RowObject.char-1.
        
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "date-1":U THEN ASSIGN pFieldValue = RowObject.date-1.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "tipo-rateio":U THEN ASSIGN pFieldValue = RowObject.tipo-rateio.
        WHEN "id-statuts":U  THEN ASSIGN pFieldValue = RowObject.id-status.
        WHEN "int-1":U       THEN ASSIGN pFieldValue = RowObject.int-1.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo Usuario
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-tipo-rateio LIKE int-rateio.tipo-rateio NO-UNDO.
    DEFINE OUTPUT PARAMETER p-competencia LIKE int-rateio.competencia NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cod-estabel LIKE int-rateio.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN p-tipo-rateio = RowObject.tipo-rateio
           p-competencia = RowObject.competencia
           p-cod-estabel = RowObject.cod-estabel.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecidField DBOProgram 
PROCEDURE getRecidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo recid
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RECID NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo Usuario
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-tipo-rateio LIKE int-rateio.tipo-rateio NO-UNDO.
    DEFINE INPUT PARAMETER p-competencia LIKE int-rateio.competencia NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel LIKE int-rateio.cod-estabel NO-UNDO.

    FIND FIRST bfint-rateio 
        WHERE bfint-rateio.tipo-rateio = p-tipo-rateio 
          AND bfint-rateio.competencia = p-competencia
          AND bfint-rateio.cod-estabel = p-cod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfint-rateio THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfint-rateio)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryUsuario DBOProgram 
PROCEDURE openQueryint-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE 
        {&TableName}.tipo-rateio >= cCd-rateio-ini AND
        {&TableName}.tipo-rateio <= cCd-rateio-fim AND
        {&TableName}.competencia >= cCd-competencia-ini AND
        {&TableName}.competencia <= cCd-competencia-fim AND
        {&TableName}.cod-estabel >= cCd-cod-estabel-ini AND
        {&TableName}.cod-estabel <= cCd-cod-estabel-fim INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName}
    FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintUsuario DBOProgram 
PROCEDURE setConstraintint-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCd-tipo-rateio-ini AS INT NO-UNDO.
DEFINE INPUT PARAMETER pCd-tipo-rateio-end AS INT NO-UNDO.
DEFINE INPUT PARAMETER pCd-competencia-ini AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pCd-competencia-end AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pCd-cod-estabel-ini   AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pCd-cod-estabel-end   AS CHAR NO-UNDO.

    ASSIGN cCd-rateio-ini      = pCd-tipo-rateio-ini
           cCd-rateio-fim      = pCd-tipo-rateio-end
           cCd-competencia-ini = pCd-competencia-ini
           cCd-competencia-fim = pCd-competencia-end
           cCd-cod-estabel-ini = pCd-cod-estabel-ini
           cCd-cod-estabel-fim = pCd-cod-estabel-end.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    IF  pType = "create" THEN DO:

        FIND FIRST int-rat-desp NO-LOCK
            WHERE int-rat-desp.tipo-rateio = RowObject.tipo-rateio NO-ERROR.
    
        IF  NOT AVAIL int-rat-desp THEN DO:

            {method/svc/errors/inserr.i
                &ERRORNUMBER = "17006"
                &ERRORTYPE = "EMS"
                &ERRORParameters = "'Tipo de Rateio inexistente'"}

        END.


       IF CAN-FIND (FIRST int-rateio WHERE 
                    int-rateio.tipo-rateio      = RowObject.tipo-rateio AND 
                    int-rateio.competencia      = RowObject.competencia AND 
                    int-rateio.cod-estabel      = RowObject.cod-estabel 
                    ) THEN DO: 
          {method/svc/errors/inserr.i
              &ERRORNUMBER = "7"
              &ERRORTYPE = "EMS"
              &ERRORParameters = "'Rateio'"}
       END.

        FIND FIRST estabelec NO-LOCK
            WHERE estabelec.cod-estabel = RowObject.cod-estabel NO-ERROR.


        IF  NOT AVAIL estabelec THEN DO:
            {method/svc/errors/inserr.i
                &ERRORNUMBER = "17006"
                &ERRORTYPE = "EMS"
                &ERRORParameters = "'Estabelecimento inexistente'"}

        END.



    END.

    

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

