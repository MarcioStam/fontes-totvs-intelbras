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
&GLOBAL-DEFINE DBOName BOES601
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName int-licenca-softphone
&GLOBAL-DEFINE TableLabel Licenáa Softphone
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
{esbo/boes601.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE v-it-codigo-ini   LIKE {&TableName}.it-codigo   NO-UNDO.
DEFINE VARIABLE v-it-codigo-fin   LIKE {&TableName}.it-codigo   NO-UNDO.
DEFINE VARIABLE v-it-fornec-ini   LIKE {&TableName}.it-fornec   NO-UNDO.
DEFINE VARIABLE v-it-fornec-fin   LIKE {&TableName}.it-fornec   NO-UNDO.
DEFINE VARIABLE v-licenca-ini     LIKE {&TableName}.licenca     NO-UNDO.
DEFINE VARIABLE v-licenca-fin     LIKE {&TableName}.licenca     NO-UNDO.
DEFINE VARIABLE v-nome-abrev-ini  LIKE {&TableName}.nome-abrev  NO-UNDO.
DEFINE VARIABLE v-nome-abrev-fin  LIKE {&TableName}.nome-abrev  NO-UNDO.
DEFINE VARIABLE v-nr-pedcli-ini   LIKE {&TableName}.nr-pedcli   NO-UNDO.
DEFINE VARIABLE v-nr-pedcli-fin   LIKE {&TableName}.nr-pedcli   NO-UNDO.
DEFINE VARIABLE v-cod-estabel-ini LIKE {&TableName}.cod-estabel NO-UNDO.
DEFINE VARIABLE v-cod-estabel-fin LIKE {&TableName}.cod-estabel NO-UNDO.
DEFINE VARIABLE v-serie-ini       LIKE {&TableName}.serie       NO-UNDO.
DEFINE VARIABLE v-serie-fin       LIKE {&TableName}.serie       NO-UNDO.
DEFINE VARIABLE v-nr-nota-fis-ini LIKE {&TableName}.nr-nota-fis NO-UNDO.
DEFINE VARIABLE v-nr-nota-fis-fin LIKE {&TableName}.nr-nota-fis NO-UNDO.

DEFINE VARIABLE v-nome-abrev  LIKE {&TableName}.nome-abrev  NO-UNDO.
DEFINE VARIABLE v-nr-pedcli   LIKE {&TableName}.nr-pedcli   NO-UNDO.
DEFINE VARIABLE v-cod-estabel LIKE {&TableName}.cod-estabel NO-UNDO.
DEFINE VARIABLE v-serie       LIKE {&TableName}.serie       NO-UNDO.
DEFINE VARIABLE v-nr-nota-fis LIKE {&TableName}.nr-nota-fis NO-UNDO.

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
         HEIGHT             = 17.67
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST bf{&TableName}
        WHERE bf{&TableName}.it-codigo = RowObject.it-codigo
          AND bf{&TableName}.it-fornec = RowObject.it-fornec
          AND bf{&TableName}.licenca   = RowObject.licenca NO-LOCK NO-ERROR.

    IF AVAILABLE bf{&TableName} THEN DO:
        IF (bf{&TableName}.nome-abrev <> "":U                 OR
            bf{&TableName}.nr-pedcli  <> "":U)                AND
           (bf{&TableName}.nome-abrev <> RowObject.nome-abrev OR
            bf{&TableName}.nr-pedcli  <> RowObject.nr-pedcli) THEN DO:
            IF RowObject.observacao = "":U THEN
                ASSIGN RowObject.observacao = "- Pedido Anterior (Alteraá∆o: ":U + STRING(TODAY, "99/99/9999":U) + " - ":U + STRING(TIME, "hh:mm:ss":U) + ") >> Cliente: ":U + bf{&TableName}.nome-abrev + " - Pedido Cliente: ":U + bf{&TableName}.nr-pedcli.
            ELSE
                ASSIGN RowObject.observacao = RowObject.observacao + CHR(10) + "- Pedido Anterior (Alteraá∆o: ":U + STRING(TODAY, "99/99/9999":U) + " - ":U + STRING(TIME, "hh:mm:ss":U) + ") >> Cliente: ":U + bf{&TableName}.nome-abrev + " - Pedido Cliente: ":U + bf{&TableName}.nr-pedcli.
        END.

        IF (bf{&TableName}.cod-estabel <> "":U                   OR
            bf{&TableName}.serie       <> "":U                   OR
            bf{&TableName}.nr-nota-fis <> "":U)                  AND
           (bf{&TableName}.cod-estabel <> RowObject.cod-estabel  OR
            bf{&TableName}.serie       <> RowObject.serie        OR
            bf{&TableName}.nr-nota-fis <> RowObject.nr-nota-fis) THEN DO:
            IF RowObject.observacao = "":U THEN
                ASSIGN RowObject.observacao = "- Nota Fiscal Anterior (Alteraá∆o: ":U + STRING(TODAY, "99/99/9999":U) + " - ":U + STRING(TIME, "hh:mm:ss":U) + ") >> Estabelecimento: ":U + bf{&TableName}.cod-estabel + " - SÇrie: ":U + bf{&TableName}.serie + " - Nr Nota Fiscal: ":U + bf{&TableName}.nr-nota-fis.
            ELSE
                ASSIGN RowObject.observacao = RowObject.observacao + CHR(10) + "- Nota Fiscal Anterior (Alteraá∆o: ":U + STRING(TODAY, "99/99/9999":U) + " - ":U + STRING(TIME, "hh:mm:ss":U) + ") >> Estabelecimento: ":U + bf{&TableName}.cod-estabel + " - SÇrie: ":U + bf{&TableName}.serie + " - Nr Nota Fiscal: ":U + bf{&TableName}.nr-nota-fis.
        END.
    END.

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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "it-fornec":U THEN ASSIGN pFieldValue = RowObject.it-fornec.
        WHEN "licenca":U THEN ASSIGN pFieldValue = RowObject.licenca.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-nota-fis":U THEN ASSIGN pFieldValue = RowObject.nr-nota-fis.
        WHEN "nr-pedcli":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
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
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
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
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
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
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ch-primario
  Parameters:  
               retorna valor do campo it-codigo
               retorna valor do campo it-fornec
               retorna valor do campo licenca
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE int-licenca-softphone.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-fornec LIKE int-licenca-softphone.it-fornec NO-UNDO.
    DEFINE OUTPUT PARAMETER plicenca LIKE int-licenca-softphone.licenca NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pit-fornec = RowObject.it-fornec
           plicenca = RowObject.licenca.

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
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
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
  Purpose:     Reposiciona registro com base no °ndice ch-primario
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo it-fornec
               recebe valor do campo licenca
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE int-licenca-softphone.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pit-fornec LIKE int-licenca-softphone.it-fornec NO-UNDO.
    DEFINE INPUT PARAMETER plicenca LIKE int-licenca-softphone.licenca NO-UNDO.

    FIND FIRST bfint-licenca-softphone WHERE 
        bfint-licenca-softphone.it-codigo = pit-codigo AND 
        bfint-licenca-softphone.it-fornec = pit-fornec AND 
        bfint-licenca-softphone.licenca = plicenca NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfint-licenca-softphone THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfint-licenca-softphone)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByLicenca DBOProgram 
PROCEDURE openQueryByLicenca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} USE-INDEX ch-licenca NO-LOCK
                                WHERE {&TableName}.licenca <= v-licenca-ini
                                  AND {&TableName}.licenca <= v-licenca-fin INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNotaFiscal DBOProgram 
PROCEDURE openQueryByNotaFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} USE-INDEX ch-nota-fiscal NO-LOCK
                                WHERE {&TableName}.cod-estabel = v-cod-estabel
                                  AND {&TableName}.serie       = v-serie
                                  AND {&TableName}.nr-nota-fis = v-nr-nota-fis INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByPedido DBOProgram 
PROCEDURE openQueryByPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} USE-INDEX ch-pedido NO-LOCK
                                WHERE {&TableName}.nome-abrev = v-nome-abrev
                                  AND {&TableName}.nr-pedcli  = v-nr-pedcli INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltro DBOProgram 
PROCEDURE openQueryFiltro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} USE-INDEX ch-primario NO-LOCK
                                WHERE {&TableName}.it-codigo   >= v-it-codigo-ini
                                  AND {&TableName}.it-codigo   <= v-it-codigo-fin
                                  AND {&TableName}.it-fornec   >= v-it-fornec-ini
                                  AND {&TableName}.it-fornec   <= v-it-fornec-fin
                                  AND {&TableName}.licenca     >= v-licenca-ini
                                  AND {&TableName}.licenca     <= v-licenca-fin
                                  AND {&TableName}.nome-abrev  >= v-nome-abrev-ini
                                  AND {&TableName}.nome-abrev  <= v-nome-abrev-fin
                                  AND {&TableName}.nr-pedcli   >= v-nr-pedcli-ini
                                  AND {&TableName}.nr-pedcli   <= v-nr-pedcli-fin
                                  AND {&TableName}.cod-estabel >= v-cod-estabel-ini
                                  AND {&TableName}.cod-estabel <= v-cod-estabel-fin
                                  AND {&TableName}.serie       >= v-serie-ini
                                  AND {&TableName}.serie       <= v-serie-fin
                                  AND {&TableName}.nr-nota-fis >= v-nr-nota-fis-ini
                                  AND {&TableName}.nr-nota-fis <= v-nr-nota-fis-fin INDEXED-REPOSITION.

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
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByLicenca DBOProgram 
PROCEDURE setConstraintByLicenca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pLicencaIni LIKE {&TableName}.licenca NO-UNDO.
    DEFINE INPUT  PARAMETER pLicencaFin LIKE {&TableName}.licenca NO-UNDO.

    ASSIGN v-licenca-ini = pLicencaIni
           v-licenca-fin = pLicencaFin.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNotaFiscal DBOProgram 
PROCEDURE setConstraintByNotaFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pCodEstabel LIKE {&TableName}.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER pSerie      LIKE {&TableName}.serie       NO-UNDO.
    DEFINE INPUT  PARAMETER pNrNotaFis  LIKE {&TableName}.nr-nota-fis NO-UNDO.

    ASSIGN v-cod-estabel = pCodEstabel
           v-serie       = pSerie
           v-nr-nota-fis = pNrNotaFis.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByPedido DBOProgram 
PROCEDURE setConstraintByPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNomeAbrev LIKE {&TableName}.nome-abrev NO-UNDO.
    DEFINE INPUT  PARAMETER pNrPedcli  LIKE {&TableName}.nr-pedcli  NO-UNDO.

    ASSIGN v-nome-abrev = pNomeAbrev
           v-nr-pedcli  = pNrPedcli.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltro DBOProgram 
PROCEDURE setConstraintFiltro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-it-codigo-ini   LIKE {&TableName}.it-codigo   NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo-fin   LIKE {&TableName}.it-codigo   NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-fornec-ini   LIKE {&TableName}.it-fornec   NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-fornec-fin   LIKE {&TableName}.it-fornec   NO-UNDO.
    DEFINE INPUT  PARAMETER p-licenca-ini     LIKE {&TableName}.licenca     NO-UNDO.
    DEFINE INPUT  PARAMETER p-licenca-fin     LIKE {&TableName}.licenca     NO-UNDO.
    DEFINE INPUT  PARAMETER p-nome-abrev-ini  LIKE {&TableName}.nome-abrev  NO-UNDO.
    DEFINE INPUT  PARAMETER p-nome-abrev-fin  LIKE {&TableName}.nome-abrev  NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedcli-ini   LIKE {&TableName}.nr-pedcli   NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedcli-fin   LIKE {&TableName}.nr-pedcli   NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel-ini LIKE {&TableName}.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel-fin LIKE {&TableName}.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER p-serie-ini       LIKE {&TableName}.serie       NO-UNDO.
    DEFINE INPUT  PARAMETER p-serie-fin       LIKE {&TableName}.serie       NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-nota-fis-ini LIKE {&TableName}.nr-nota-fis NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-nota-fis-fin LIKE {&TableName}.nr-nota-fis NO-UNDO.

    ASSIGN v-it-codigo-ini   = p-it-codigo-ini
           v-it-codigo-fin   = p-it-codigo-fin
           v-it-fornec-ini   = p-it-fornec-ini
           v-it-fornec-fin   = p-it-fornec-fin
           v-licenca-ini     = p-licenca-ini
           v-licenca-fin     = p-licenca-fin
           v-nome-abrev-ini  = p-nome-abrev-ini
           v-nome-abrev-fin  = p-nome-abrev-fin
           v-nr-pedcli-ini   = p-nr-pedcli-ini
           v-nr-pedcli-fin   = p-nr-pedcli-fin
           v-cod-estabel-ini = p-cod-estabel-ini
           v-cod-estabel-fin = p-cod-estabel-fin
           v-serie-ini       = p-serie-ini
           v-serie-fin       = p-serie-fin
           v-nr-nota-fis-ini = p-nr-nota-fis-ini
           v-nr-nota-fis-fin = p-nr-nota-fis-fin.

    RETURN "OK":U.

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
    IF pType = "Create":U THEN DO:
        IF RowObject.licenca = "":U THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17677"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Licenáa'"}
        END.

        FIND FIRST bf{&TableName}
            WHERE bf{&TableName}.licenca = RowObject.licenca NO-LOCK NO-ERROR.

        IF AVAILABLE bf{&TableName} THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Licenáa do Softphone j† cadastrado'"}
        END.

        FIND FIRST item
            WHERE item.it-codigo = RowObject.it-codigo NO-LOCK NO-ERROR.

        IF NOT AVAILABLE item THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Item'"}
        END.
    END.

    IF pType = "Create":U OR
       pType = "Update":U THEN DO:
        IF RowObject.nome-abrev <> "":U THEN DO:
            FIND FIRST emitente
                WHERE emitente.nome-abrev = RowObject.nome-abrev NO-LOCK NO-ERROR.

            IF NOT AVAILABLE emitente THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Cliente'"}
            END.
        END.

        IF RowObject.nome-abrev <> "":U OR RowObject.nr-pedcli <> "":U THEN DO:
            FIND FIRST ped-venda
                WHERE ped-venda.nome-abrev = RowObject.nome-abrev
                  AND ped-venda.nr-pedcli  = RowObject.nr-pedcli NO-LOCK NO-ERROR.

            IF NOT AVAILABLE ped-venda THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Pedido'"}
            END.
        END.

        IF RowObject.cod-estabel <> "":U THEN DO:
            FIND FIRST estabelec
                WHERE estabelec.cod-estabel = RowObject.cod-estabel NO-LOCK NO-ERROR.

            IF NOT AVAILABLE estabelec THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Estabelecimento'"}
            END.
        END.

        IF RowObject.cod-estabel <> "":U OR RowObject.serie <> "":U OR RowObject.nr-nota-fis <> "":U THEN DO:
            FIND FIRST nota-fiscal
                WHERE nota-fiscal.cod-estabel = RowObject.cod-estabel
                  AND nota-fiscal.serie       = RowObject.serie
                  AND nota-fiscal.nr-nota-fis = RowObject.nr-nota-fis NO-LOCK NO-ERROR.

            IF NOT AVAILABLE nota-fiscal THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Nota Fiscal'"}
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

