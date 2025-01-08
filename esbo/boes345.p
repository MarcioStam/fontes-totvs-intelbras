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
&GLOBAL-DEFINE DBOName BOES345
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName meta-rep
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{esbo/boes345.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR v-ini-cod-estabel   AS CHAR NO-UNDO.
DEF VAR v-fim-cod-estabel   AS CHAR NO-UNDO.
DEF VAR v-ini-cod-diretoria AS CHAR NO-UNDO.
DEF VAR v-fim-cod-diretoria AS CHAR NO-UNDO.
DEF VAR v-ini-cod-gerente   AS INT NO-UNDO.
DEF VAR v-fim-cod-gerente   AS INT NO-UNDO.
DEF VAR v-ini-cod-rep       AS INT NO-UNDO.
DEF VAR v-fim-cod-rep       AS INT NO-UNDO.
DEF VAR v-ini-periodo       AS CHAR NO-UNDO.
DEF VAR v-fim-periodo       AS CHAR NO-UNDO.

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
         HEIGHT             = 13.75
         WIDTH              = 32.86.
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
        WHEN "cod-diretoria":U THEN ASSIGN pFieldValue = RowObject.cod-diretoria.
        WHEN "periodo":U THEN ASSIGN pFieldValue = RowObject.periodo.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
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
        WHEN "Valor":U THEN ASSIGN pFieldValue = RowObject.Valor.
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
        WHEN "cod-gerente":U THEN ASSIGN pFieldValue = RowObject.cod-gerente.
        WHEN "cod-rep":U THEN ASSIGN pFieldValue = RowObject.cod-rep.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ch-cota
  Parameters:  
               retorna valor do campo cod-diretoria
               retorna valor do campo cod-gerente
               retorna valor do campo cod-rep
               retorna valor do campo periodo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel   LIKE meta-rep.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-diretoria LIKE meta-rep.cod-diretoria NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-gerente   LIKE meta-rep.cod-gerente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-rep       LIKE meta-rep.cod-rep NO-UNDO.
    DEFINE OUTPUT PARAMETER pperiodo       LIKE meta-rep.periodo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-diretoria = RowObject.cod-diretoria
           pcod-gerente = RowObject.cod-gerente
           pcod-rep = RowObject.cod-rep
           pperiodo = RowObject.periodo.

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
  Purpose:     Reposiciona registro com base no °ndice ch-cota
  Parameters:  
               recebe valor do campo cod-diretoria
               recebe valor do campo cod-gerente
               recebe valor do campo cod-rep
               recebe valor do campo periodo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel   LIKE meta-rep.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-diretoria LIKE meta-rep.cod-diretoria NO-UNDO.
    DEFINE INPUT PARAMETER pcod-gerente   LIKE meta-rep.cod-gerente   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-rep       LIKE meta-rep.cod-rep       NO-UNDO.
    /* DEFINE INPUT PARAMETER pperiodo       LIKE meta-rep.periodo       NO-UNDO.*/

    FIND FIRST bfmeta-rep WHERE 
        bfmeta-rep.cod-estabel = pcod-estabel AND
        bfmeta-rep.cod-diretoria = pcod-diretoria AND 
        bfmeta-rep.cod-gerente = pcod-gerente AND 
        bfmeta-rep.cod-rep = pcod-rep /*AND 
        bfmeta-rep.periodo = pperiodo */ NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmeta-rep THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmeta-rep)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCod DBOProgram 
PROCEDURE openQueryByCod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
    WHERE {&TableName}.cod-estabel   >= v-ini-cod-estabel   AND
          {&TableName}.cod-estabel   <= v-fim-cod-estabel   AND
          {&TableName}.cod-diretoria >= v-ini-cod-diretoria AND
          {&TableName}.cod-diretoria <= v-fim-cod-diretoria AND
          {&TableName}.cod-gerente   >= v-ini-cod-gerente   AND
          {&TableName}.cod-gerente   <= v-fim-cod-gerente   AND     
          {&TableName}.cod-rep       >= v-ini-cod-rep       AND
          {&TableName}.cod-rep       <= v-fim-cod-rep       AND
          {&TableName}.periodo       >= v-ini-periodo       AND 
          {&TableName}.periodo       <= v-fim-periodo   .
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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByCod DBOProgram 
PROCEDURE setConstraintByCod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-ini-cod-estabel   LIKE meta-rep.cod-estabel   NO-UNDO.
    DEF INPUT PARAM p-fim-cod-estabel   LIKE meta-rep.cod-estabel   NO-UNDO.
    DEF INPUT PARAM p-ini-cod-diretoria LIKE meta-rep.cod-diretoria NO-UNDO.
    DEF INPUT PARAM p-fim-cod-diretoria LIKE meta-rep.cod-diretoria NO-UNDO.
    DEF INPUT PARAM p-ini-cod-gerente   LIKE meta-rep.cod-gerente   NO-UNDO.
    DEF INPUT PARAM p-fim-cod-gerente   LIKE meta-rep.cod-gerente   NO-UNDO.
    DEF INPUT PARAM p-ini-cod-rep       LIKE meta-rep.cod-rep       NO-UNDO.
    DEF INPUT PARAM p-fim-cod-rep       LIKE meta-rep.cod-rep       NO-UNDO.
    DEF INPUT PARAM p-ini-periodo       LIKE meta-rep.periodo       NO-UNDO.
    DEF INPUT PARAM p-fim-perioso       LIKE meta-rep.periodo       NO-UNDO.

    ASSIGN v-ini-cod-estabel    = p-ini-cod-estabel
           v-fim-cod-estabel    = p-fim-cod-estabel
           v-ini-cod-diretoria  = p-ini-cod-diretoria
           v-fim-cod-diretoria  = p-fim-cod-diretoria
           v-ini-cod-gerente    = p-ini-cod-gerente
           v-fim-cod-gerente    = p-fim-cod-gerente
           v-ini-cod-rep        = p-ini-cod-rep
           v-fim-cod-rep        = p-fim-cod-rep
           v-ini-periodo        = p-ini-periodo
           v-fim-periodo        = p-fim-perioso .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.

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


    IF pType = "Create" THEN DO:
        IF  CAN-FIND(FIRST meta-rep
                     WHERE meta-rep.cod-estabel   = rowObject.cod-estabel
                     AND   meta-rep.cod-diretoria = string(RowObject.cod-diretoria) 
                     AND   meta-rep.cod-gerente   = RowObject.cod-gerente
                     AND   meta-rep.cod-rep       = RowObject.cod-rep
                     AND   meta-rep.periodo       = string(RowObject.periodo)) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="outros"
                                        &ErrorSubType="ERROR"
                                        &ErrorDescription="Cota j† cadastrada para este per°odo."}
        END.
                        
        IF  CAN-FIND(FIRST meta-rep
                     WHERE meta-rep.cod-estabel   = rowObject.cod-estabel
                     AND   meta-rep.cod-diretoria = string(RowObject.cod-diretoria) 
                     AND   meta-rep.cod-rep       = RowObject.cod-rep
                     AND   meta-rep.periodo       = RowObject.periodo
                     AND   meta-rep.cod-estabel   = rowObject.cod-estabel
                     AND   meta-rep.cod-gerente  <> RowObject.cod-gerente) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="outros"
                                        &ErrorSubType="ERROR"
                                        &ErrorDescription="Representante j† cadastrado para outro gerente neste per°odo."}
        END.

        /* Validaá∆o nada a ver... Retirada da BO para o programa funcionar corretamente,
           j† que a chave Ç diretoria/gerente/representante */
        /*
        IF CAN-FIND (meta-rep
           WHERE meta-rep.cod-gerente   = RowObject.cod-gerente
           AND   meta-rep.periodo       = RowObject.periodo
           AND   meta-rep.cod-rep       = RowObject.cod-rep
           AND   meta-rep.cod-diretoria <> RowObject.cod-diretoria) THEN DO:
           {method/svc/errors/inserr.i
           &ErrorNumber="2"
           &ErrorType="outros"
           &ErrorSubType="ERROR"
           &ErrorDescription="Gerente j† cadastrado para outro diretor neste per°odo."}            
        END.
        */

        RUN setRecord IN THIS-PROCEDURE (INPUT TABLE RowObject).
    END.

    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

