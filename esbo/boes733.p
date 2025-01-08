&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
{include/i-prgvrs.i BOES733 2.00.00.000}  /*** 010003 ***/

    /*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOES733
&GLOBAL-DEFINE DBOVersion 2.00.00.000 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ncm-origem-sem-prot
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS Main

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{esbo/boes733.i RowObject}

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-ncm       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-codigo-orig   AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-uf-origem     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-uf-destino    AS CHARACTER   NO-UNDO.
/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
        WHEN "cod-ncm":U THEN ASSIGN pFieldValue = RowObject.cod-ncm.
        WHEN "uf-origem":U THEN ASSIGN pFieldValue = RowObject.uf-origem.
        WHEN "uf-destino":U THEN ASSIGN pFieldValue = RowObject.uf-destino.
        WHEN "desc-msg":U THEN ASSIGN pFieldValue = RowObject.desc-msg.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.        
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.        
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.  
        WHEN "protocolo":U THEN ASSIGN pFieldValue = RowObject.protocolo.  
        WHEN "usuar-ultima-rev":U THEN ASSIGN pFieldValue = RowObject.usuar-ultima-rev.
        
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-ultima-rec":U THEN ASSIGN pFieldValue = RowObject.dt-ultima-rec.    
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
        WHEN "per-sub-tri":U THEN ASSIGN pFieldValue = RowObject.per-sub-tri.
        WHEN "perc-red-sub":U THEN ASSIGN pFieldValue = RowObject.perc-red-sub.
        WHEN "perc-aliq-interna":U THEN ASSIGN pFieldValue = RowObject.perc-aliq-interna.
        WHEN "perc-credito-icms":U THEN ASSIGN pFieldValue = RowObject.perc-credito-icms.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
          WHEN "codigo-orig" THEN ASSIGN pFieldValue = RowObject.codigo-orig.
          WHEN "cod-msg-nf" THEN ASSIGN pFieldValue = RowObject.cod-msg-nf.
          WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1. 
          WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.               
         OTHERWISE RETURN "NOK":U.                                               
      END CASE.                                                                   

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
    DEFINE OUTPUT PARAMETER p-c-cod-ncm       LIKE ncm-origem-sem-prot.cod-ncm     NO-UNDO.
    DEFINE OUTPUT PARAMETER p-c-codigo-orig   LIKE ncm-origem-sem-prot.codigo-orig NO-UNDO.
    

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN p-c-cod-ncm     = RowObject.cod-ncm
           p-c-codigo-orig = RowObject.codigo-orig.
           
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
        WHEN "l-tem-st":U THEN ASSIGN pFieldValue = RowObject.l-tem-st.
        WHEN "l-gera-of":U THEN ASSIGN pFieldValue = RowObject.l-gera-of.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
    DEFINE INPUT PARAMETER p-cod-ncm      LIKE ncm-origem-sem-prot.cod-ncm     NO-UNDO.
    DEFINE INPUT PARAMETER p-codigo-orig  LIKE ncm-origem-sem-prot.codigo-orig NO-UNDO.
    DEFINE INPUT PARAMETER p-uf-origem    LIKE ncm-origem-sem-prot.uf-origem   NO-UNDO.
    DEFINE INPUT PARAMETER p-uf-destino   LIKE ncm-origem-sem-prot.uf-destino  NO-UNDO.
    
    FIND FIRST bfncm-origem-sem-prot 
        WHERE bfncm-origem-sem-prot.cod-ncm     = p-cod-ncm 
          AND bfncm-origem-sem-prot.codigo-orig = p-codigo-orig
          AND bfncm-origem-sem-prot.uf-origem   = p-uf-origem 
          AND bfncm-origem-sem-prot.uf-destino  = p-uf-destino NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfncm-origem-sem-prot THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfncm-origem-sem-prot)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToncm-origem DBOProgram 
PROCEDURE linkToncm-origem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER hncm-origem AS HANDLE     NO-UNDO.

RUN getKey IN hncm-origem (OUTPUT c-cod-ncm,
                           OUTPUT i-codigo-orig).

RUN setConstraintncm-origem IN THIS-PROCEDURE(INPUT c-cod-ncm,
                                              INPUT i-codigo-orig).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryncm-origem-sem-prot DBOProgram 
PROCEDURE openQueryncm-origem-sem-prot :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
     {&TableName}.cod-ncm     = c-cod-ncm AND 
     {&TableName}.codigo-orig = i-codigo-orig
     BY ncm-origem-sem-prot.uf-origem
     INDEXED-REPOSITION.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintncm-origem DBOProgram 
PROCEDURE setConstraintncm-origem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-cod-ncm      AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p-codigo-orig  AS INTEGER   NO-UNDO.
 
 ASSIGN  c-cod-ncm     = p-cod-ncm
         i-codigo-orig = p-codigo-orig.
           
 RETURN  "OK":U.

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

    FIND FIRST mensagem NO-LOCK
        WHERE mensagem.cod-mensagem = RowObject.cod-msg-nf NO-ERROR.

    IF  NOT AVAIL mensagem AND RowObject.cod-msg-nf <> 0 THEN DO:
        {method/svc/errors/inserr.i
            &ERRORNUMBER = "17006"
            &ERRORTYPE = "EMS"
            &ERRORSUBTYPE = "ERROR"   
            &ERRORDescription = "C¢digo de Mensagem inexistente."}
    END.
    
    FIND FIRST unid-feder NO-LOCK
        WHERE unid-feder.estado = RowObject.uf-origem NO-ERROR.
    IF  NOT AVAIL unid-feder THEN DO:
        {method/svc/errors/inserr.i
            &ERRORNUMBER = "17006"
            &ERRORTYPE = "EMS"
            &ERRORSUBTYPE = "ERROR"   
            &ERRORDescription = "UF de Origem Inexistente."}
    END.
    
    FIND FIRST unid-feder NO-LOCK
        WHERE unid-feder.estado = RowObject.uf-destino NO-ERROR.
    IF  NOT AVAIL unid-feder THEN DO:
        {method/svc/errors/inserr.i
            &ERRORNUMBER = "17006"
            &ERRORTYPE = "EMS"
            &ERRORSUBTYPE = "ERROR"   
            &ERRORDescription = "UF de Destino Inexistente."}
    END.

    FIND FIRST classif-fisc NO-LOCK
        WHERE classif-fisc.class-fiscal = RowObject.cod-ncm NO-ERROR.
    IF  NOT AVAIL classif-fisc THEN DO:
        {method/svc/errors/inserr.i
            &ERRORNUMBER = "17006"
            &ERRORTYPE = "EMS"
            &ERRORSUBTYPE = "ERROR"   
            &ERRORDescription = "Classificaá∆o Fiscal(NCM) Inexistente."}
    END.

    IF  RowObject.codigo-orig > 8 THEN DO:
        {method/svc/errors/inserr.i
            &ERRORNUMBER = "17006"
            &ERRORTYPE = "EMS"
            &ERRORSUBTYPE = "ERROR"   
            &ERRORDescription = "Origem Inexistente."}
    END.
    


    /*--- Verifica ocorrància de erros ---*/
    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

