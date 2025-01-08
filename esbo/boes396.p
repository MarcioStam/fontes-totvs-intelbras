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
&GLOBAL-DEFINE DBOName BOES396
&GLOBAL-DEFINE DBOVersion 2.04.00.002
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName comissoes
&GLOBAL-DEFINE TableLabel comissoes
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
{esbo/boes396.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE v-ini-cod-estabel     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-fim-cod-estabel     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-ini-cod-rep         AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-fim-cod-rep         AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-ini-cod-emitente    AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-fim-cod-emitente    AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-fm-cod-com-ini      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-fm-cod-com-fim      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-ini-dt-inicial      AS DATE        NO-UNDO.
DEFINE VARIABLE v-fim-dt-inicial      AS DATE        NO-UNDO.

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
         HEIGHT             = 2.5
         WIDTH              = 28.43.
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "fm-cod-com-ini":U THEN ASSIGN pFieldValue = RowObject.fm-cod-com-ini.
        WHEN "fm-cod-com-fim":U THEN ASSIGN pFieldValue = RowObject.fm-cod-com-fim.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getComissao DBOProgram 
PROCEDURE getComissao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT   PARAMETER p-cod-estabel       LIKE {&TableName}.cod-estabel       NO-UNDO.
   DEFINE INPUT   PARAMETER p-cod-rep           LIKE {&TableName}.cod-rep           NO-UNDO.
   DEFINE INPUT   PARAMETER p-cod-emitente      LIKE {&TableName}.cod-emitente      NO-UNDO.
   DEFINE INPUT   PARAMETER p-fm-cod-com        LIKE {&TableName}.fm-cod-com-ini    NO-UNDO.
   DEFINE INPUT   PARAMETER p-data              AS DATE                             NO-UNDO.
   DEFINE OUTPUT  PARAMETER p-perc              LIKE {&TableName}.perc              NO-UNDO.

   DEFINE VARIABLE l-ok AS LOGICAL     NO-UNDO.

   /* Retirado toda a logica porque o percentual de comiss∆o Ç agora da tabela comissoes-faixa */
   
   ASSIGN p-perc = 0.
   RETURN "NOK":U.

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
        WHEN "dt-inicial":U THEN ASSIGN pFieldValue = RowObject.dt-inicial.
        WHEN "dt-final":U THEN ASSIGN pFieldValue = RowObject.dt-final.
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
        WHEN "perc":U THEN ASSIGN pFieldValue = RowObject.perc.
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
        WHEN "cod-rep":U THEN ASSIGN pFieldValue = RowObject.cod-rep.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice comissoes
  Parameters:  
               retorna valor do campo cod-rep
               retorna valor do campo cod-gr-cli
               retorna valor do campo seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel     LIKE {&TableName}.cod-estabel       NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-rep         LIKE {&TableName}.cod-rep           NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente    LIKE {&TableName}.cod-emitente      NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-inicial      LIKE {&TableName}.dt-inicial        NO-UNDO.
    DEFINE OUTPUT PARAMETER pfm-cod-com-ini  LIKE {&TableName}.fm-cod-com-ini    NO-UNDO.
    DEFINE OUTPUT PARAMETER pfm-cod-com-fim  LIKE {&TableName}.fm-cod-com-fim    NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel     = RowObject.cod-estabel
           pcod-rep         = RowObject.cod-rep
           pcod-emitente    = RowObject.cod-emitente
           pdt-inicial      = RowObject.dt-inicial
           pfm-cod-com-ini  = RowObject.fm-cod-com-ini
           pfm-cod-com-fim  = RowObject.fm-cod-com-fim  .

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
        WHEN "ativo":U THEN ASSIGN pFieldValue = RowObject.ativo.
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
  Purpose:     Reposiciona registro com base no °ndice comissoes
  Parameters:  
               recebe valor do campo cod-rep
               recebe valor do campo cod-gr-cli
               recebe valor do campo seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel      LIKE {&TableName}.cod-estabel       NO-UNDO.    
    DEFINE INPUT PARAMETER pcod-rep          LIKE {&TableName}.cod-rep           NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente     LIKE {&TableName}.cod-emitente      NO-UNDO.
    DEFINE INPUT PARAMETER pdt-inicial       LIKE {&TableName}.dt-inicial        NO-UNDO.
    DEFINE INPUT PARAMETER pfm-cod-com-ini   LIKE {&TableName}.fm-cod-com-ini    NO-UNDO.
    DEFINE INPUT PARAMETER pfm-cod-com-fim   LIKE {&TableName}.fm-cod-com-fim    NO-UNDO.
    
    FIND FIRST bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.cod-estabel     = pcod-estabel
         AND bf{&TableName}.cod-rep         = pcod-rep
         AND bf{&TableName}.cod-emitente    = pcod-emitente
         AND bf{&TableName}.dt-inicial      = pdt-inicial
         AND bf{&TableName}.fm-cod-com-ini  = pfm-cod-com-ini
         AND bf{&TableName}.fm-cod-com-fim  = pfm-cod-com-fim NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bf{&TableName} THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
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
    WHERE {&TableName}.cod-estabel     >= v-ini-cod-estabel     AND
          {&TableName}.cod-estabel     <= v-fim-cod-estabel     AND
          {&TableName}.cod-rep         >= v-ini-cod-rep         AND
          {&TableName}.cod-rep         <= v-fim-cod-rep         AND
          {&TableName}.cod-emitente    >= v-ini-cod-emitente    AND
          {&TableName}.cod-emitente    <= v-fim-cod-emitente    AND
          {&TableName}.fm-cod-com-ini  >= v-fm-cod-com-ini      AND
          {&TableName}.fm-cod-com-fim  <= v-fm-cod-com-fim      AND
          {&TableName}.dt-inicial      >= v-ini-dt-inicial      AND
          {&TableName}.dt-inicial      <= v-fim-dt-inicial .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom1 DBOProgram 
PROCEDURE openQueryZoom1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                           WHERE {&TableName}.cod-estabel  >= v-ini-cod-estabel
                             AND {&TableName}.cod-estabel  <= v-fim-cod-estabel
                             AND {&TableName}.cod-rep      >= v-ini-cod-rep
                             AND {&TableName}.cod-rep      <= v-fim-cod-rep.

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
    DEF INPUT PARAM p-ini-cod-estabel     LIKE {&TableName}.cod-estabel       NO-UNDO.
    DEF INPUT PARAM p-fim-cod-estabel     LIKE {&TableName}.cod-estabel       NO-UNDO.
    DEF INPUT PARAM p-ini-cod-rep         LIKE {&TableName}.cod-rep           NO-UNDO.
    DEF INPUT PARAM p-fim-cod-rep         LIKE {&TableName}.cod-rep           NO-UNDO.
    DEF INPUT PARAM p-ini-cod-emitente    LIKE {&TableName}.cod-emitente      NO-UNDO.
    DEF INPUT PARAM p-fim-cod-emitente    LIKE {&TableName}.cod-emitente      NO-UNDO.
    DEF INPUT PARAM p-fm-cod-com-ini      LIKE {&TableName}.fm-cod-com-ini    NO-UNDO.
    DEF INPUT PARAM p-fm-cod-com-fim      LIKE {&TableName}.fm-cod-com-fim    NO-UNDO.
    DEF INPUT PARAM p-ini-dt-inicial      LIKE {&TableName}.dt-inicial        NO-UNDO.
    DEF INPUT PARAM p-fim-dt-inicial      LIKE {&TableName}.dt-inicial        NO-UNDO.

    ASSIGN v-ini-cod-estabel     = p-ini-cod-estabel
           v-fim-cod-estabel     = p-fim-cod-estabel
           v-ini-cod-rep         = p-ini-cod-rep
           v-fim-cod-rep         = p-fim-cod-rep
           v-ini-cod-emitente    = p-ini-cod-emitente
           v-fim-cod-emitente    = p-fim-cod-emitente
           v-fm-cod-com-ini      = p-fm-cod-com-ini
           v-fm-cod-com-fim      = p-fm-cod-com-fim
           v-ini-dt-inicial      = p-ini-dt-inicial
           v-fim-dt-inicial      = p-fim-dt-inicial.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom1 DBOProgram 
PROCEDURE setConstraintZoom1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-ini-cod-estabel       LIKE {&TableName}.cod-estabel    NO-UNDO.
    DEF INPUT PARAM p-fim-cod-estabel       LIKE {&TableName}.cod-estabel    NO-UNDO.
    DEF INPUT PARAM p-ini-cod-rep           LIKE {&TableName}.cod-rep        NO-UNDO.
    DEF INPUT PARAM p-fim-cod-rep           LIKE {&TableName}.cod-rep        NO-UNDO.

    ASSIGN v-ini-cod-estabel = p-ini-cod-estabel
           v-fim-cod-estabel = p-fim-cod-estabel
           v-ini-cod-rep     = p-ini-cod-rep    
           v-fim-cod-rep     = p-fim-cod-rep.

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
   CASE pType:
      WHEN "Create" THEN DO:
         IF (RowObject.cod-rep    = 0) OR
            (RowObject.dt-inicial = ?) THEN DO:
            {method/svc/errors/inserr.i
             &ErrorNumber="2"
             &ErrorType="outros"
             &ErrorSubType="ERROR"
             &ErrorDescription="O c¢digo do representante e data inicial s∆o obrigat¢rios"}
         END.

         IF RowObject.fm-cod-com-ini <> "" AND LENGTH(RowObject.fm-cod-com-ini) <> 8 THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Familia Comercial Inicial inv†lida.~~~~Familia Comercial Inicial dever ter 8 digitos.'"}
         END.

         IF RowObject.fm-cod-com-fim = "" OR LENGTH(RowObject.fm-cod-com-fim) <> 8 THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Familia Comercial Final inv†lida.~~~~Familia Comercial Final dever ter 8 digitos.'"}
         END.

         IF RowObject.fm-cod-com-ini > RowObject.fm-cod-com-fim THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Familia Comercial Final menor que Inicial.~~~~Familia Comercial Final dever ser maior que Inicial.'"}
         END.

         IF CAN-FIND (FIRST bf{&TableName}
                         WHERE bf{&TableName}.cod-estabel     = RowObject.cod-estabel
                           AND bf{&TableName}.cod-rep         = RowObject.cod-rep
                           AND bf{&TableName}.cod-emitente    = RowObject.cod-emitente
                           AND bf{&TableName}.dt-inicial      = RowObject.dt-inicial
                           AND bf{&TableName}.fm-cod-com-ini  = RowObject.fm-cod-com-ini
                           AND bf{&TableName}.fm-cod-com-fim  = RowObject.fm-cod-com-fim) THEN DO:
            {method/svc/errors/inserr.i
             &ErrorNumber="2"
             &ErrorType="outros"
             &ErrorSubType="ERROR"
             &ErrorDescription="Comiss∆o do representante j† cadastrada"}
         END.
           IF CAN-FIND (FIRST bf{&TableName}
                           WHERE bf{&TableName}.cod-estabel     = RowObject.cod-estabel
                             AND bf{&TableName}.cod-rep         = RowObject.cod-rep
                             AND bf{&TableName}.cod-emitente    = RowObject.cod-emitente
                             AND bf{&TableName}.dt-inicial     <= RowObject.dt-inicial
                             AND bf{&TableName}.fm-cod-com-ini  = RowObject.fm-cod-com-ini
                             AND bf{&TableName}.fm-cod-com-fim  = RowObject.fm-cod-com-fim
                             AND bf{&TableName}.dt-final       >= RowObject.dt-inicial
                             AND ROWID(bf{&TableName})         <> RowObject.r-Rowid) THEN DO:
              {method/svc/errors/inserr.i
               &ErrorNumber="2"
               &ErrorType="outros"
               &ErrorSubType="ERROR"
               &ErrorDescription="J† existe comiss∆o cadastrada para este representante com a data inicial informada"}
           END.
           IF CAN-FIND (FIRST bf{&TableName}
                           WHERE bf{&TableName}.cod-estabel     = RowObject.cod-estabel
                             AND bf{&TableName}.cod-rep         = RowObject.cod-rep
                             AND bf{&TableName}.cod-emitente    = RowObject.cod-emitente
                             AND bf{&TableName}.dt-inicial     <= RowObject.dt-final
                             AND bf{&TableName}.fm-cod-com-ini  = RowObject.fm-cod-com-ini
                             AND bf{&TableName}.fm-cod-com-fim  = RowObject.fm-cod-com-fim
                             AND bf{&TableName}.dt-final       >= RowObject.dt-final
                             AND ROWID(bf{&TableName})         <> RowObject.r-Rowid) THEN DO:
              {method/svc/errors/inserr.i
               &ErrorNumber="2"
               &ErrorType="outros"
               &ErrorSubType="ERROR"
               &ErrorDescription="J† existe comiss∆o cadastrada para este representante com a data final informada"}
           END.
           IF CAN-FIND (FIRST bf{&TableName}
                           WHERE bf{&TableName}.cod-estabel     = RowObject.cod-estabel
                             AND bf{&TableName}.cod-rep         = RowObject.cod-rep
                             AND bf{&TableName}.cod-emitente    = RowObject.cod-emitente
                             AND bf{&TableName}.dt-inicial     <= RowObject.dt-inicial
                             AND bf{&TableName}.fm-cod-com-ini  = RowObject.fm-cod-com-ini
                             AND bf{&TableName}.fm-cod-com-fim  = RowObject.fm-cod-com-fim
                             AND bf{&TableName}.dt-final       >= RowObject.dt-final
                             AND ROWID(bf{&TableName})         <> RowObject.r-Rowid) THEN DO:
              {method/svc/errors/inserr.i
               &ErrorNumber="2"
               &ErrorType="outros"
               &ErrorSubType="ERROR"
               &ErrorDescription="J† existe comiss∆o cadastrada para este representante no intervalo de datas informado"}
           END.
      END.
   END CASE.
   
   IF (RowObject.dt-inicial = ?) OR
      (RowObject.dt-final   = ?) THEN DO:
      {method/svc/errors/inserr.i
       &ErrorNumber="2"
       &ErrorType="outros"
       &ErrorSubType="ERROR"
       &ErrorDescription="As datas inicial e final s∆o de preenchimento obrigat¢rio"}
   END.
   IF (RowObject.dt-inicial > RowObject.dt-final) THEN DO:
      {method/svc/errors/inserr.i
       &ErrorNumber="2"
       &ErrorType="outros"
       &ErrorSubType="ERROR"
       &ErrorDescription="A data final deve ser maior ou igual Ö data inicial"}
   END.

   /*:T--- Verifica ocorrància de erros ---*/
   IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
      RETURN "NOK":U.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

