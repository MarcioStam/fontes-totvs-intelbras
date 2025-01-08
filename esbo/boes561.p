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

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOES561
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName canhoto-nf
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName}


/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{esbo/boes561.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-cod-transp        AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-cod-caixa         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-envelope      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie-ini         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie-fim         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-nota-fis-ini   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-nota-fis-fim   AS CHARACTER   NO-UNDO.

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
         HEIGHT             = 10.92
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-caixa":U THEN ASSIGN pFieldValue = RowObject.cod-caixa.
        WHEN "cod-envelope":U THEN ASSIGN pFieldValue = RowObject.cod-envelope.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "nr-nota-fis":U THEN ASSIGN pFieldValue = RowObject.nr-nota-fis.
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
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
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice idx-canhoto-nf
  Parameters:  
               retorna valor do campo cod-transp
               retorna valor do campo cod-caixa
               retorna valor do campo cod-envelope
               retorna valor do campo cod-estabel
               retorna valor do campo serie
               retorna valor do campo nr-nota-fis
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-transp LIKE canhoto-nf.cod-transp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-caixa LIKE canhoto-nf.cod-caixa NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-envelope LIKE canhoto-nf.cod-envelope NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE canhoto-nf.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pserie LIKE canhoto-nf.serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-nota-fis LIKE canhoto-nf.nr-nota-fis NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-transp = RowObject.cod-transp
           pcod-caixa = RowObject.cod-caixa
           pcod-envelope = RowObject.cod-envelope
           pcod-estabel = RowObject.cod-estabel
           pserie = RowObject.serie
           pnr-nota-fis = RowObject.nr-nota-fis.

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
  Purpose:     Reposiciona registro com base no °ndice idx-canhoto-nf
  Parameters:  
               recebe valor do campo cod-transp
               recebe valor do campo cod-caixa
               recebe valor do campo cod-envelope
               recebe valor do campo cod-estabel
               recebe valor do campo serie
               recebe valor do campo nr-nota-fis
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-transp LIKE canhoto-nf.cod-transp NO-UNDO.
    DEFINE INPUT PARAMETER pcod-caixa LIKE canhoto-nf.cod-caixa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-envelope LIKE canhoto-nf.cod-envelope NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE canhoto-nf.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pserie LIKE canhoto-nf.serie NO-UNDO.
    DEFINE INPUT PARAMETER pnr-nota-fis LIKE canhoto-nf.nr-nota-fis NO-UNDO.

    FIND FIRST bfcanhoto-nf WHERE 
        bfcanhoto-nf.cod-transp = pcod-transp AND 
        bfcanhoto-nf.cod-caixa = pcod-caixa AND 
        bfcanhoto-nf.cod-envelope = pcod-envelope AND 
        bfcanhoto-nf.cod-estabel = pcod-estabel AND 
        bfcanhoto-nf.serie = pserie AND 
        bfcanhoto-nf.nr-nota-fis = pnr-nota-fis NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcanhoto-nf THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcanhoto-nf)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToCanhoto DBOProgram 
PROCEDURE linkToCanhoto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-boes560 AS HANDLE      NO-UNDO.

    RUN getKey IN p-boes560 (OUTPUT i-cod-transp,
                             OUTPUT c-cod-caixa,
                             OUTPUT c-cod-envelope).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCanhotoNF DBOProgram 
PROCEDURE openQueryCanhotoNF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH  {&TableName} NO-LOCK USE-INDEX idx-canhoto-nf
                                WHERE {&TableName}.cod-transp   = i-cod-transp
                                AND   {&TableName}.cod-caixa    = c-cod-caixa
                                AND   {&TableName}.cod-envelope = c-cod-envelope.

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

    OPEN QUERY {&QueryName} FOR EACH  {&TableName} NO-LOCK.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryNota DBOProgram 
PROCEDURE OpenQueryNota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
    WHERE {&tablename}.cod-estabel >= c-cod-estabel-ini
      AND {&tablename}.cod-estabel <= c-cod-estabel-fim
      AND {&tablename}.serie       >= c-serie-ini
      AND {&tablename}.serie       <= c-serie-fim
      AND {&tablename}.nr-nota-fis >= c-nr-nota-fis-ini
      AND {&tablename}.nr-nota-fis <= c-nr-nota-fis-fim.

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCanhotoNF DBOProgram 
PROCEDURE setConstraintCanhotoNF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cod-transp   AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-caixa    AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-envelope AS CHARACTER   NO-UNDO.

    ASSIGN i-cod-transp   = p-cod-transp
           c-cod-caixa    = p-cod-caixa
           c-cod-envelope = p-cod-envelope.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintnota DBOProgram 
PROCEDURE setconstraintnota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcod-estabel-ini AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-estabel-fim AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pserie-ini       AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pserie-fim       AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-nota-fis-ini AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-nota-fis-fim AS CHARACTER   NO-UNDO.

    ASSIGN c-cod-estabel-ini = pcod-estabel-ini 
           c-cod-estabel-fim = pcod-estabel-fim 
           c-serie-ini       = pserie-ini       
           c-serie-fim       = pserie-fim       
           c-nr-nota-fis-ini = pnr-nota-fis-ini 
           c-nr-nota-fis-fim = pnr-nota-fis-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF  pType = "Create":U THEN DO:
        IF  CAN-FIND(FIRST canhoto-nf NO-LOCK
                     WHERE canhoto-nf.cod-transp   = rowObject.cod-transp
                     AND   canhoto-nf.cod-caixa    = rowObject.cod-caixa
                     AND   canhoto-nf.cod-envelope = rowObject.cod-envelope
                     AND   canhoto-nf.cod-estabel  = rowObject.cod-estabel
                     AND   canhoto-nf.serie        = rowObject.serie
                     AND   canhoto-nf.nr-nota-fis  = rowObject.nr-nota-fis)  THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber     = 7
                                        &ErrorType       = "EMS"
                                        &ErrorParameters = "'Canhoto x Nota Fiscal'"}
        END.

        IF  NOT CAN-FIND(FIRST nota-fiscal NO-LOCK
                         WHERE nota-fiscal.cod-estabel = rowObject.cod-estabel
                         AND   nota-fiscal.serie       = rowObject.serie
                         AND   nota-fiscal.nr-nota-fis = rowObject.nr-nota-fis) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber     = 56
                                        &ErrorType       = "EMS"
                                        &ErrorParameters = "'Nota Fiscal (' + rowObject.cod-estabel + '/' + rowObject.serie + '/' + rowObject.nr-nota-fis + ')'"}
        END.

        IF  CAN-FIND(FIRST canhoto-nf NO-LOCK
                     WHERE canhoto-nf.cod-estabel = rowObject.cod-estabel
                     AND   canhoto-nf.serie       = rowObject.serie
                     AND   canhoto-nf.nr-nota-fis = rowObject.nr-nota-fis) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                        &ErrorType       = "EMS"
                                        &ErrorParameters = "'Nota Fiscal (' + rowObject.cod-estabel + '/' + rowObject.serie + '/' + rowObject.nr-nota-fis + ') j† relacionada!~~Nota Fiscal j† est† relacionada com outra Transportadora, ou Caixa, ou Envelope.'"}
        END.

        FIND FIRST nota-fiscal NO-LOCK
            WHERE  nota-fiscal.cod-estabel = rowObject.cod-estabel
            AND    nota-fiscal.serie       = rowObject.serie
            AND    nota-fiscal.nr-nota-fis = rowObject.nr-nota-fis NO-ERROR.
        IF  AVAIL  nota-fiscal THEN DO:
            FIND FIRST transporte NO-LOCK
                WHERE  transporte.cod-transp = rowObject.cod-transp NO-ERROR.
            IF  NOT AVAIL transporte THEN
                LEAVE.

            IF  nota-fiscal.nome-transp <> transporte.nome-abrev THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                            &ErrorType       = "EMS"
                                            &ErrorParameters = "'Transportadora da Nota Fiscal (' + nota-fiscal.nome-transp + ') diferente da transportador informada na Capa do Envelope (' + transporte.nome-abrev + ').'"}
            END.
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

