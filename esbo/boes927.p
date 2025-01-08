&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/
{include/i-prgvrs.i escep086b-bo 3.00.00.000 }

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName boes927
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName int-estabel-origem-ressup
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

{esbo/boes927.i RowObject}

/* Datasul Rest */
{java/boRest.i}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

DEFINE VAR c-cod-estabel-ressup     AS CHARACTER    NO-UNDO.
DEFINE VAR c-cod-depos-ressup       AS CHARACTER    NO-UNDO.

DEFINE TEMP-TABLE tt-int-estabel-origem-ressup NO-UNDO LIKE  RowObject.
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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 20
         WIDTH              = 40.
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

    /*--- Verifica se temptable RowObject est∆o dispon°vel, caso n∆o esteja ser∆o
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estabel-ressup":U THEN ASSIGN pFieldValue = RowObject.cod-estabel-ressup.
        WHEN "cod-depos-ressup":U THEN ASSIGN pFieldValue = RowObject.cod-depos-ressup.
        WHEN "cod-estabel-origem":U THEN ASSIGN pFieldValue = RowObject.cod-estabel-origem.
        WHEN "cod-depos-origem":U THEN ASSIGN pFieldValue = RowObject.cod-depos-origem.
        WHEN "cod-depos-cdi":U THEN ASSIGN pFieldValue = RowObject.cod-depos-cdi.
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

    /*--- Verifica se temptable RowObject est∆o dispon°vel, caso n∆o esteja ser∆o
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

    /*--- Verifica se temptable RowObject est∆o dispon°vel, caso n∆o esteja ser∆o
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

    /*--- Verifica se temptable RowObject est∆o dispon°vel, caso n∆o esteja ser∆o
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "num-lead-time":U THEN ASSIGN pFieldValue = RowObject.num-lead-time.
        OTHERWISE RETURN "NOK":U.
    END CASE.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice mftvdqpt-id
  Parameters:  
               retorna valor do campo cod-ativid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pCod-estabel-ressup LIKE int-estabel-origem-ressup.cod-estabel-ressup NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-depos-ressup   LIKE int-estabel-origem-ressup.cod-depos-ressup   NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-estabel-origem LIKE int-estabel-origem-ressup.cod-estabel-origem NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-depos-origem   LIKE int-estabel-origem-ressup.cod-depos-origem   NO-UNDO.

    /*--- Verifica se temptable RowObject est∆o dispon°vel, caso n∆o esteja ser∆o
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN  pcod-estabel-ressup = RowObject.cod-estabel-ressup
            pcod-depos-ressup   = RowObject.cod-depos-ressup  
            pcod-estabel-origem = RowObject.cod-estabel-origem
            pcod-depos-origem   = RowObject.cod-depos-origem .

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

    /*--- Verifica se temptable RowObject est∆o dispon°vel, caso n∆o esteja ser∆o
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

    /*--- Verifica se temptable RowObject est∆o dispon°vel, caso n∆o esteja ser∆o
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

    /*--- Verifica se temptable RowObject est∆o dispon°vel, caso n∆o esteja ser∆o
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
  Purpose:     Reposiciona registro com base no °ndice mftvdqpt-id
  Parameters:  
               recebe valor do campo cod-ativid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCod-estabel-ressup LIKE int-estabel-origem-ressup.cod-estabel-ressup NO-UNDO.
    DEFINE INPUT PARAMETER pCod-depos-ressup   LIKE int-estabel-origem-ressup.cod-depos-ressup   NO-UNDO.
    DEFINE INPUT PARAMETER pCod-estabel-origem LIKE int-estabel-origem-ressup.cod-estabel-origem NO-UNDO.
    DEFINE INPUT PARAMETER pCod-depos-origem   LIKE int-estabel-origem-ressup.cod-depos-origem   NO-UNDO.
    
    DEFINE BUFFER bfint-estabel-origem-ressup FOR int-estabel-origem-ressup.

    FIND FIRST bfint-estabel-origem-ressup
         WHERE bfint-estabel-origem-ressup.cod-estabel-ressup   = pCod-estabel-ressup
           AND bfint-estabel-origem-ressup.cod-depos-ressup     = pCod-depos-ressup  
           AND bfint-estabel-origem-ressup.cod-estabel-origem   = pCod-estabel-origem
           AND bfint-estabel-origem-ressup.cod-depos-origem     = pCod-depos-origem  
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser∆o retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfint-estabel-origem-ressup THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser∆o retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfint-estabel-origem-ressup)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToint-Estabel-ressuprimento DBOProgram 
PROCEDURE linkToint-Estabel-ressuprimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.

    RUN getKey IN pHandle (OUTPUT c-cod-estabel-ressup,
                           OUTPUT c-cod-depos-ressup).

    RUN getCharField IN pHandle (INPUT "cod-estabel-ressup", OUTPUT c-cod-estabel-ressup).
    RUN getCharField IN pHandle (INPUT "cod-depos-ressup", OUTPUT c-cod-depos-ressup).

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEstabel DBOProgram 
PROCEDURE openQueryEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryName} FOR  EACH {&tableName} 
                                WHERE {&TableName}.cod-estabel-ressup  = c-cod-estabel-ressup
                                  AND {&TableName}.cod-depos-ressup    = c-cod-depos-ressup
        NO-LOCK.

RETURN "OK".

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

OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK.
RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaEstabelOrigemRessuprimento DBOProgram 
PROCEDURE retornaEstabelOrigemRessuprimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-cod-estabel-ressup     AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-depos-ressup       AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-int-estabel-origem-ressup.

    FOR EACH tt-int-estabel-origem-ressup:
        DELETE tt-int-estabel-origem-ressup.
    END.

    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.cod-estabel-ressup  = p-cod-estabel-ressup
         AND bf{&TableName}.cod-depos-ressup    = p-cod-depos-ressup:
        CREATE tt-int-estabel-origem-ressup.
        BUFFER-COPY bf{&TableName} TO tt-int-estabel-origem-ressup.
        ASSIGN tt-int-estabel-origem-ressup.r-Rowid = ROWID(bf{&TableName}).          
    END.         

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    define variable cTexto as character no-undo.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    if pType = "CREATE" then do:
        if can-find (bf{&tableName}
                     WHERE bf{&tableName}.cod-estabel-ressup    = rowObject.cod-estabel-ressup
                       AND bf{&tableName}.cod-depos-ressup      = rowObject.cod-depos-ressup
                       AND bf{&tableName}.cod-estabel-origem    = rowObject.cod-estabel-origem
                       AND bf{&tableName}.cod-depos-origem      = rowObject.cod-depos-origem)
        then do:
            {utp/ut-liter.i "Estabelecimento Origem "} 
            {method/svc/errors/inserr.i
                               &ErrorNumber="1"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="return-value"} 
        end.
        //Estabelecimento Origem n∆o pode ser o mesmo do estabelecimento de ressuprimento
        IF CAN-FIND (FIRST bf{&tableName}
                     WHERE bf{&tableName}.cod-estabel-ressup = rowObject.cod-estabel-origem)
        THEN DO:
            {method/svc/errors/inserr.i
                               &ErrorNumber="17006"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters='"Estabelecimento Origem n∆o pode ser o mesmo do Destino."'} 
        END.

        IF NOT CAN-FIND (FIRST deposito NO-LOCK
                         WHERE deposito.cod-depos = rowObject.cod-depos-origem)
        THEN DO:
            {utp/ut-liter.i "Dep¢sito"} 
            {method/svc/errors/inserr.i
                               &ErrorNumber="2"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="return-value"} 
        END.
        IF NOT CAN-FIND (FIRST estabelec NO-LOCK
                         WHERE estabelec.cod-estabel = rowObject.cod-estabel-origem)
        THEN DO:
            {utp/ut-liter.i "Estabelecimento"} 
            {method/svc/errors/inserr.i
                               &ErrorNumber="2"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="return-value"} 
        END.


  end.

  if pType = "DELETE" then do: 
  end.
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

