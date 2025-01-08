&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
{include/i-prgvrs.i boes910 2.00.00.003}  /*** 010003 ***/


    /*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName boes910
&GLOBAL-DEFINE DBOVersion 2.00.00.000 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName int-rateio-plan
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS INT-RATEIO, Main

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{esbo/boes910.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* DEFINE TEMP-TABLE ttClientes NO-UNDO                 */
/*     FIELD id-exporta   AS CHARACTER FORMAT "x"       */
/*     FIELD cod-emitente LIKE emitente-tr.cod-emitente */
/*     FIELD nome-emit    LIKE emitente-tr.nome-emit    */
/*     INDEX id cod-emitente.                           */

DEFINE VARIABLE cCd-tipo-rateio     AS INT  NO-UNDO.
DEFINE VARIABLE cCd-competencia     AS CHAR NO-UNDO.
DEFINE VARIABLE cCd-cod-estabel     AS CHAR NO-UNDO.
DEFINE VARIABLE cCd-Nr-fatura       AS DEC  NO-UNDO.

DEFINE VARIABLE cCd-rateio-ini      AS INT  NO-UNDO.
DEFINE VARIABLE cCd-rateio-fim      AS INT  NO-UNDO.
DEFINE VARIABLE cCd-competencia-ini AS CHAR NO-UNDO.
DEFINE VARIABLE cCd-competencia-fim AS CHAR NO-UNDO.
DEFINE VARIABLE cCd-cod-estabel-ini AS CHAR NO-UNDO.
DEFINE VARIABLE cCd-cod-estabel-fim AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar    AS CHARACTER    NO-UNDO.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 21.63
         WIDTH              = 38.86.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstUsuario DBOProgram 
PROCEDURE findFirstRateio-Fatur :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST {&TableName} NO-LOCK WHERE
     {&TableName}.tipo-rateio = cCd-tipo-rateio AND 
     {&TableName}.competencia = cCd-competencia AND 
     {&TableName}.cod-estabel = cCd-cod-estabel  NO-ERROR.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastUsuario DBOProgram 
PROCEDURE findLastTipo-Rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST {&TableName} NO-LOCK WHERE
     {&TableName}.tipo-rateio = cCd-tipo-rateio AND 
     {&TableName}.competencia = cCd-competencia AND 
     {&TableName}.cod-estabel = cCd-cod-estabel NO-ERROR.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextUsuario DBOProgram 
PROCEDURE findNexttipo-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND NEXT {&TableName} NO-LOCK WHERE
     {&TableName}.tipo-rateio = cCd-tipo-rateio AND 
     {&TableName}.competencia = cCd-competencia AND 
     {&TableName}.cod-estabel = cCd-cod-estabel NO-ERROR.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevUsuario DBOProgram 
PROCEDURE findPrevTipo-Rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND PREV {&TableName} NO-LOCK WHERE
     {&TableName}.tipo-rateio = cCd-tipo-rateio AND 
     {&TableName}.competencia = cCd-competencia AND 
     {&TableName}.cod-estabel = cCd-cod-estabel NO-ERROR.

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
        WHEN "competencia":U      THEN ASSIGN pFieldValue = RowObject.competencia.
        WHEN "cod-estabel":U      THEN ASSIGN pFieldValue = RowObject.cod-estabel.
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

/*     CASE pFieldName:                                                */
/*         WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1. */
/*         WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2. */
/*         OTHERWISE RETURN "NOK":U.                                   */
/*     END CASE.                                                       */

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


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice padrao
  Parameters:  
               retorna valor do campo cd-padrao
               retorna valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER ptipo-rateio      LIKE int-rateio-plan.tipo-rateio   NO-UNDO.
    DEFINE OUTPUT PARAMETER pCompetencia      LIKE int-rateio-plan.competencia   NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-estabel      LIKE int-rateio-plan.cod-estabel   NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-estabel-rat  LIKE int-rateio-plan.cod-estabel-rat NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-centro-custo LIKE int-rateio-plan.cod-centro-custo NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-unid-neg     LIKE int-rateio-plan.cod-unid-neg NO-UNDO.
    
    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN ptipo-rateio      = RowObject.tipo-rateio
           pCompetencia      = RowObject.competencia
           pCod-estabel      = RowObject.cod-estabel
           pCod-estabel-rat  = RowObject.cod-estabel-rat
           pCod-centro-custo = RowObject.cod-centro-custo
           pCod-unid-neg     = RowObject.cod-unid-neg.

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
  Purpose:     Reposiciona registro com base no °ndice padrao
  Parameters:  
               recebe valor do campo cd-padrao
               recebe valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER ptipo-rateio      LIKE int-rateio-plan.tipo-rateio      NO-UNDO.
    DEFINE INPUT PARAMETER pcompetencia      LIKE int-rateio-plan.competencia      NO-UNDO.
    DEFINE INPUT PARAMETER pCod-estabel      LIKE int-rateio-plan.cod-estabel      NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel-rat    LIKE int-rateio-plan.cod-estabel-rat    NO-UNDO.
    DEFINE INPUT PARAMETER pCod-centro-custo LIKE int-rateio-plan.cod-centro-custo NO-UNDO.
    DEFINE INPUT PARAMETER pCod-unid-neg     LIKE int-rateio-plan.cod-unid-neg     NO-UNDO.

    FIND FIRST bfint-rateio-plan
        WHERE bfint-rateio-plan.tipo-rateio      = ptipo-rateio
          AND bfint-rateio-plan.competencia      = pcompetencia 
          AND bfint-rateio-plan.cod-estabel      = pCod-estabel
          AND bfint-rateio-plan.cod-estabel-rat    = pcod-estabel-rat 
          AND bfint-rateio-plan.cod-centro-custo = pCod-centro-custo 
          AND bfint-rateio-plan.cod-unid-neg     = pCod-unid-neg NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfint-rateio-plan THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfint-rateio-plan)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToIso-Usuario DBOProgram 
PROCEDURE linkToint-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER hint-rat-desp AS HANDLE     NO-UNDO.

RUN getKey IN hint-rat-desp (OUTPUT cCd-tipo-rateio,
                             OUTPUT cCd-competencia,
                             OUTPUT cCd-cod-estabel).

RUN setConstraintRateio IN THIS-PROCEDURE(INPUT cCd-Tipo-rateio,
                                          INPUT cCd-competencia,
                                          INPUT cCd-cod-estabel).

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryIso-Usuario DBOProgram 
PROCEDURE openQueryint-rateio-plan :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
     {&TableName}.tipo-rateio = cCd-Tipo-Rateio AND 
     {&TableName}.competencia = cCd-competencia AND
     {&TableName}.cod-estabel = cCd-cod-estabel INDEXED-REPOSITION.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaRateio DBOProgram 
PROCEDURE openQueryFaixaRateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
    {&TableName}.tipo-rateio >= cCd-rateio-ini AND
    {&TableName}.tipo-rateio <= cCd-rateio-FIM
        by tipo-rateio.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRateio DBOProgram 
PROCEDURE setConstraintRateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER p-tipo-rateio    AS INT   NO-UNDO.
 DEFINE INPUT  PARAMETER p-competencia    AS CHAR  NO-UNDO.
 DEFINE INPUT  PARAMETER p-cod-estabel    AS CHAR  NO-UNDO.
 
 ASSIGN  cCd-Tipo-Rateio = p-tipo-rateio
         cCd-competencia = p-competencia
         cCd-cod-estabel = p-cod-estabel.
          
 RETURN  "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPadraoCliente DBOProgram 
PROCEDURE setConstraintPadraoCliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCd-tipo-rateio-ini LIKE {&TableName}.tipo-rateio NO-UNDO.
    DEFINE INPUT PARAMETER pCd-tipo-rateio-end LIKE {&TableName}.tipo-rateio NO-UNDO.
    DEFINE INPUT PARAMETER pCd-competencia-ini LIKE {&TableName}.competencia NO-UNDO.
    DEFINE INPUT PARAMETER pCd-competencia-end LIKE {&TableName}.competencia NO-UNDO.
    DEFINE INPUT PARAMETER pCd-cod-estabel-ini LIKE {&TableName}.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pCd-cod-estabel-end LIKE {&TableName}.cod-estabel NO-UNDO.
   
    ASSIGN cCd-Rateio-ini      = pCd-tipo-rateio-ini 
           cCd-Rateio-fim      = pCd-tipo-rateio-end 
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
    
    IF pType = "create" THEN DO:

       IF CAN-FIND (FIRST int-rateio-plan WHERE
                    int-rateio-plan.Tipo-rateio      = RowObject.Tipo-rateio      AND
                    int-rateio-plan.competencia      = RowObject.competencia      AND
                    int-rateio-plan.cod-estabel      = RowObject.cod-estabel      AND
                    int-rateio-plan.cod-estabel-rat  = RowObject.cod-estabel-rat    AND
                    int-rateio-plan.cod-centro-custo = RowObject.cod-centro-custo AND
                    int-rateio-plan.cod-unid-neg     = RowObject.cod-unid-neg)       
       THEN DO:
          {method/svc/errors/inserr.i
              &ERRORNUMBER = "7"
              &ERRORTYPE = "EMS"
              &ERRORParameters = "'Rateio'"}
       END.

    END.


    IF  pType <> "delete" THEN DO:
        find emscad.ccusto NO-LOCK 
            where emscad.ccusto.cod_empresa       = v_cod_empres_usuar
              AND emscad.ccusto.cod_plano_ccusto  = "Padr∆o" 
              AND emscad.ccusto.cod_ccusto = RowObject.cod-centro-custo NO-ERROR.
    
        IF  NOT AVAIL emscad.ccusto THEN DO:
              {method/svc/errors/inserr.i
                  &ERRORNUMBER = "17006"
                  &ERRORTYPE = "EMS"
                  &ERRORParameters = "'Centro de Custo'"}
        END.
    
        FIND FIRST unid-negoc NO-LOCK
            WHERE unid-negoc.cod-unid-negoc = RowObject.cod-unid-neg NO-ERROR.
        IF  NOT AVAIL unid-negoc THEN DO:
            {method/svc/errors/inserr.i
                &ERRORNUMBER = "17006"
                &ERRORTYPE = "EMS"
                &ERRORParameters = "'Unidade Neg¢cio'"}
        END.
    
        IF  RowObject.vl-perc-rateio <= 0 THEN DO:
            {method/svc/errors/inserr.i
                &ERRORNUMBER = "17006"
                &ERRORTYPE = "EMS"
                &ERRORParameters = "'Percentual de Rateio inv†lido'"}
        END.
    END.

    IF  pType = "delete" THEN DO:
    END.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

