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
{include/i-prgvrs.i boes793.i 2.00.01.006}  /*** 010106 ***/

/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName      boes794
&GLOBAL-DEFINE DBOVersion   1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName    it-mod-img-etiq
&GLOBAL-DEFINE TableLabel   item-modelo-imagem
&GLOBAL-DEFINE QueryName    qr{&TableName} 


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{esbo/boes794.i RowObject}


/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE VARIABLE c-it-codigo-ini        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-it-codigo-fim        AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-cod-modelo-ini       AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-cod-modelo-fim       AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-des-modelo-ini       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-des-modelo-fim       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-it-codigo            AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-cod-modelo           AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-cod-imagem           AS INTEGER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaDescImg DBOProgram 
FUNCTION fnRetornaDescImg RETURNS CHARACTER
  ( INPUT i-imagem AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaQtdeImg DBOProgram 
FUNCTION fnRetornaQtdeImg RETURNS INTEGER
  ( INPUT c-item AS CHARACTER,
    INPUT i-modelo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaQtdeSelo DBOProgram 
FUNCTION fnRetornaQtdeSelo RETURNS INTEGER
  ( INPUT i-modelo AS  INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaSeq DBOProgram 
FUNCTION fnRetornaSeq RETURNS INTEGER
  ( INPUT c-item AS CHARACTER,
    INPUT i-modelo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnVerificaImgQtde DBOProgram 
FUNCTION fnVerificaImgQtde RETURNS LOGICAL
  ( INPUT c-item AS CHARACTER,
    INPUT i-mod  AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 15.67
         WIDTH              = 49.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:        
        WHEN "cod-modelo":U THEN ASSIGN pFieldValue = RowObject.cod-modelo.
        WHEN "cod-imagem":U THEN ASSIGN pFieldValue = RowObject.cod-imagem.
        WHEN "sequencia":U  THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice idx-esp-wm-equipamento-transp
  Parameters:  
               retorna valor do campo cod-equipamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo  LIKE it-mod-img-etiq.it-codigo  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-modelo LIKE it-mod-img-etiq.cod-modelo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-imagem LIKE it-mod-img-etiq.cod-imagem NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo  = RowObject.it-codigo
           pcod-modelo = RowObject.cod-modelo
           pcod-imagem = RowObject.cod-imagem.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice idx-esp-wm-equipamento-transp
  Parameters:  
               recebe valor do campo cod-equipamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo  LIKE it-mod-img-etiq.it-codigo  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-modelo LIKE it-mod-img-etiq.cod-modelo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-imagem LIKE it-mod-img-etiq.cod-imagem NO-UNDO.

    FIND FIRST bfit-mod-img-etiq
        WHERE bfit-mod-img-etiq.it-codigo  = pit-codigo
        AND   bfit-mod-img-etiq.cod-modelo = pcod-modelo
        AND   bfit-mod-img-etiq.cod-imagem = pcod-imagem NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfit-mod-img-etiq THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfit-mod-img-etiq)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LinkToItemModelo DBOProgram 
PROCEDURE LinkToItemModelo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.

    RUN getKey IN pHandle (OUTPUT c-it-codigo,
                           OUTPUT i-cod-modelo).
                           
    RETURN 'OK':U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixa DBOProgram 
PROCEDURE openQueryFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
        {&TableName}.it-codigo  >= c-it-codigo-ini  AND
        {&TableName}.it-codigo  <= c-it-codigo-fim  AND
        {&TableName}.cod-modelo >= i-cod-modelo-ini AND
        {&TableName}.cod-modelo <= i-cod-modelo-fim INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryImagem DBOProgram 
PROCEDURE openQueryImagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        OPEN QUERY {&QueryName} 
            FOR EACH it-mod-img-etiq.
        
    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItem-Modelo-Imagem DBOProgram 
PROCEDURE openQueryItem-Modelo-Imagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} 
        FOR EACH {&TableName} 
           WHERE {&TableName}.it-codigo  = c-it-codigo
           AND   {&TableName}.cod-modelo = i-cod-modelo NO-LOCK INDEXED-REPOSITION.

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
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaImagem DBOProgram 
PROCEDURE piBuscaImagem :
/*------------------------------------------------------------------------------
  Purpose: Retorna temp-table com registros da it-mod-img-etiq
  Notes:   Carlos Daniel - 27/04/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-item   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER i-modelo AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR RowObject.

FOR EACH {&TableName}
    WHERE {&TableName}.it-codigo  = c-item
    AND   {&TableName}.cod-modelo = i-modelo NO-LOCK:

    CREATE RowObject.
    BUFFER-COPY {&TableName} TO RowObject.
    ASSIGN RowObject.descricao = fnRetornaDescImg(RowObject.cod-imagem).
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixa DBOProgram 
PROCEDURE setConstraintFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-it-codigo-ini  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo-fim  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-modelo-ini AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-modelo-fim AS INTEGER   NO-UNDO.

    assign c-it-codigo-ini  = p-it-codigo-ini
           c-it-codigo-fim  = p-it-codigo-fim
           i-cod-modelo-ini = p-cod-modelo-ini
           i-cod-modelo-fim = p-cod-modelo-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintImagem DBOProgram 
PROCEDURE SetConstraintImagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodImagem  AS INTEGER   NO-UNDO.
        
ASSIGN i-cod-imagem  = pCodImagem.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintItem-Modelo-Imagem DBOProgram 
PROCEDURE SetConstraintItem-Modelo-Imagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintItemModelo DBOProgram 
PROCEDURE SetConstraintItemModelo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pItCodigo  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pCodModelo AS INTEGER   NO-UNDO.
    
    ASSIGN c-it-codigo  = pitCodigo
           i-cod-modelo = pCodModelo.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/
     
     IF pType = "Create":U THEN DO:
        /* Registro Duplicado */
        IF CAN-FIND(FIRST bfit-mod-img-etiq WHERE
            bfit-mod-img-etiq.it-codigo   = RowObject.it-codigo  AND
            bfit-mod-img-etiq.cod-modelo  = RowObject.cod-modelo AND
            bfit-mod-img-etiq.cod-imagem  = RowObject.cod-imagem) THEN
                {method/svc/errors/inserr.i &ErrorNumber=1
                                            &ErrorType="EMS"
                                            &ErrorParameters="'Modelo'"}
     END.                                    
     
     IF pType = "Create":U or pType = "Update":U THEN DO:
        IF RowObject.cod-modelo = 0 OR RowObject.it-codigo = "" THEN
            {method/svc/errors/inserr.i
                    &ErrorNumber="366"
                    &ErrorType="show"
                    &ErrorParameters="'ItemModelo'"}
   
     END.
        
       /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetornaDescImg DBOProgram 
FUNCTION fnRetornaDescImg RETURNS CHARACTER
  ( INPUT i-imagem AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna descri‡Æo da imagem
    Notes: Carlos Daniel - 28/04/2016
------------------------------------------------------------------------------*/

FOR FIRST imagem-etiq FIELDS(descricao)
    WHERE imagem-etiq.cod-imagem = i-imagem NO-LOCK:

    RETURN imagem-etiq.descricao.
END.

RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetornaQtdeImg DBOProgram 
FUNCTION fnRetornaQtdeImg RETURNS INTEGER
  ( INPUT c-item AS CHARACTER,
    INPUT i-modelo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna quantidade de imagens vinculadas para item e modelo informado
  Notes:   Carlos Daniel - 29/04/2016
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-cont AS INTEGER NO-UNDO.

FOR EACH it-mod-img-etiq
    WHERE it-mod-img-etiq.it-codigo  = c-item
    AND   it-mod-img-etiq.cod-modelo = i-modelo NO-LOCK:
    
    ASSIGN i-cont = i-cont + 1.
END.

RETURN i-cont.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetornaQtdeSelo DBOProgram 
FUNCTION fnRetornaQtdeSelo RETURNS INTEGER
  ( INPUT i-modelo AS  INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna quantidade de selos cadastrada para o modelo informado
    Notes: Carlos Daniel - 28/04/2016
------------------------------------------------------------------------------*/
FOR FIRST modelo-etiq FIELDS(quantidade-selo)
    WHERE modelo-etiq.cod-modelo = i-modelo NO-LOCK:

    RETURN modelo-etiq.quantidade-selo.
END.

RETURN 0.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetornaSeq DBOProgram 
FUNCTION fnRetornaSeq RETURNS INTEGER
  ( INPUT c-item AS CHARACTER,
    INPUT i-modelo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna £ltima sequˆncia do modelo informado
  Notes:   Carlos Daniel - 27/04/2016
------------------------------------------------------------------------------*/
FOR LAST it-mod-img-etiq
    WHERE it-mod-img-etiq.it-codigo  = c-item
    AND   it-mod-img-etiq.cod-modelo = i-modelo
    NO-LOCK BY it-mod-img-etiq.sequencia:
    
    RETURN it-mod-img-etiq.sequencia.
END.

RETURN 0.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnVerificaImgQtde DBOProgram 
FUNCTION fnVerificaImgQtde RETURNS LOGICAL
  ( INPUT c-item AS CHARACTER,
    INPUT i-mod  AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Verifica se quantidade de imagens vinculadas estÆo de acordo com a
           quantidade de imagens cadastrada no modelo 
    Notes: Carlos Daniel - 05/05/2016
------------------------------------------------------------------------------*/
IF fnRetornaQtdeImg(c-item,i-mod) = fnRetornaQtdeSelo(i-mod) THEN
    RETURN TRUE.

RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

