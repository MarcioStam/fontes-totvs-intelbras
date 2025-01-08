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
&GLOBAL-DEFINE DBOName BOES643
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName int-ped-item-astec
&GLOBAL-DEFINE TableLabel Item Pedido X Ocorrància ASTEC
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
{esbo/boes643.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*:T--- Definiá∆o de vari†vel local ---*/
DEFINE VARIABLE v-nome-abrev LIKE {&TableName}.nome-abrev NO-UNDO.
DEFINE VARIABLE v-nr-pedcli  LIKE {&TableName}.nr-pedcli  NO-UNDO.

DEFINE VARIABLE v-nr-sequencia LIKE {&TableName}.nr-sequencia NO-UNDO.
DEFINE VARIABLE v-it-codigo    LIKE {&TableName}.it-codigo    NO-UNDO.

DEFINE VARIABLE v-cod-estabel LIKE {&TableName}.cod-estabel NO-UNDO.
DEFINE VARIABLE v-serie       LIKE {&TableName}.serie       NO-UNDO.
DEFINE VARIABLE v-nr-nota-fis LIKE {&TableName}.nr-nota-fis NO-UNDO.

DEFINE VARIABLE v-nr-os LIKE {&TableName}.nr-os NO-UNDO.

DEFINE VARIABLE v-nome-abrev-ini   LIKE {&TableName}.nome-abrev   NO-UNDO.
DEFINE VARIABLE v-nome-abrev-fin   LIKE {&TableName}.nome-abrev   NO-UNDO.
DEFINE VARIABLE v-nr-pedcli-ini    LIKE {&TableName}.nr-pedcli    NO-UNDO.
DEFINE VARIABLE v-nr-pedcli-fin    LIKE {&TableName}.nr-pedcli    NO-UNDO.
DEFINE VARIABLE v-nr-sequencia-ini LIKE {&TableName}.nr-sequencia NO-UNDO.
DEFINE VARIABLE v-nr-sequencia-fin LIKE {&TableName}.nr-sequencia NO-UNDO.
DEFINE VARIABLE v-it-codigo-ini    LIKE {&TableName}.it-codigo    NO-UNDO.
DEFINE VARIABLE v-it-codigo-fin    LIKE {&TableName}.it-codigo    NO-UNDO.
DEFINE VARIABLE v-nr-os-ini        LIKE {&TableName}.nr-os        NO-UNDO.
DEFINE VARIABLE v-nr-os-fin        LIKE {&TableName}.nr-os        NO-UNDO.

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
         HEIGHT             = 18.96
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-nota-fis":U THEN ASSIGN pFieldValue = RowObject.nr-nota-fis.
        WHEN "nr-os":U THEN ASSIGN pFieldValue = RowObject.nr-os.
        WHEN "nr-pedcli":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
        WHEN "vl-guid-os":U THEN ASSIGN pFieldValue = RowObject.vl-guid-os.
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
        WHEN "dat-livre-3":U THEN ASSIGN pFieldValue = RowObject.dat-livre-3.
        WHEN "dat-livre-4":U THEN ASSIGN pFieldValue = RowObject.dat-livre-4.
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
        WHEN "qt-alocada":U THEN ASSIGN pFieldValue = RowObject.qt-alocada.
        WHEN "qt-pedida":U THEN ASSIGN pFieldValue = RowObject.qt-pedida.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-livre-3":U THEN ASSIGN pFieldValue = RowObject.val-livre-3.
        WHEN "val-livre-4":U THEN ASSIGN pFieldValue = RowObject.val-livre-4.
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
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-livre-4":U THEN ASSIGN pFieldValue = RowObject.num-livre-4.
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
               retorna valor do campo nome-abrev
               retorna valor do campo nr-pedcli
               retorna valor do campo nr-sequencia
               retorna valor do campo it-codigo
               retorna valor do campo nr-os
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnome-abrev LIKE int-ped-item-astec.nome-abrev NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedcli LIKE int-ped-item-astec.nr-pedcli NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-sequencia LIKE int-ped-item-astec.nr-sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE int-ped-item-astec.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-os LIKE int-ped-item-astec.nr-os NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnome-abrev = RowObject.nome-abrev
           pnr-pedcli = RowObject.nr-pedcli
           pnr-sequencia = RowObject.nr-sequencia
           pit-codigo = RowObject.it-codigo
           pnr-os = RowObject.nr-os.

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
        WHEN "log-livre-3":U THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U THEN ASSIGN pFieldValue = RowObject.log-livre-4.
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
               recebe valor do campo nome-abrev
               recebe valor do campo nr-pedcli
               recebe valor do campo nr-sequencia
               recebe valor do campo it-codigo
               recebe valor do campo nr-os
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnome-abrev LIKE int-ped-item-astec.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedcli LIKE int-ped-item-astec.nr-pedcli NO-UNDO.
    DEFINE INPUT PARAMETER pnr-sequencia LIKE int-ped-item-astec.nr-sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE int-ped-item-astec.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pnr-os LIKE int-ped-item-astec.nr-os NO-UNDO.

    FIND FIRST bfint-ped-item-astec WHERE 
        bfint-ped-item-astec.nome-abrev = pnome-abrev AND 
        bfint-ped-item-astec.nr-pedcli = pnr-pedcli AND 
        bfint-ped-item-astec.nr-sequencia = pnr-sequencia AND 
        bfint-ped-item-astec.it-codigo = pit-codigo AND 
        bfint-ped-item-astec.nr-os = pnr-os NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfint-ped-item-astec THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfint-ped-item-astec)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToPedVenda DBOProgram 
PROCEDURE linkToPedVenda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-handle AS HANDLE      NO-UNDO.

    RUN getKey IN p-handle (OUTPUT v-nome-abrev,
                            OUTPUT v-nr-pedcli).

    RUN setConstraintPedVenda IN THIS-PROCEDURE (INPUT v-nome-abrev,
                                                 INPUT v-nr-pedcli).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNotaFiscal DBOProgram 
PROCEDURE openQueryNotaFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                WHERE {&TableName}.cod-estabel = v-cod-estabel
                                  AND {&TableName}.serie       = v-serie
                                  AND {&TableName}.nr-nota-fis = v-nr-nota-fis INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNrOs DBOProgram 
PROCEDURE openQueryNrOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                WHERE {&TableName}.nr-os = v-nr-os INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedItem DBOProgram 
PROCEDURE openQueryPedItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                WHERE {&TableName}.nome-abrev   = v-nome-abrev
                                  AND {&TableName}.nr-pedcli    = v-nr-pedcli
                                  AND {&TableName}.nr-sequencia = v-nr-sequencia
                                  AND {&TableName}.it-codigo    = v-it-codigo INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedItemAstec DBOProgram 
PROCEDURE openQueryPedItemAstec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                WHERE {&TableName}.nome-abrev   >= v-nome-abrev-ini
                                  AND {&TableName}.nome-abrev   <= v-nome-abrev-fin
                                  AND {&TableName}.nr-pedcli    >= v-nr-pedcli-ini
                                  AND {&TableName}.nr-pedcli    <= v-nr-pedcli-fin
                                  AND {&TableName}.nr-sequencia >= v-nr-sequencia-ini
                                  AND {&TableName}.nr-sequencia <= v-nr-sequencia-fin
                                  AND {&TableName}.it-codigo    >= v-it-codigo-ini
                                  AND {&TableName}.it-codigo    <= v-it-codigo-fin
                                  AND {&TableName}.nr-os        >= v-nr-os-ini
                                  AND {&TableName}.nr-os        <= v-nr-os-fin INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedVenda DBOProgram 
PROCEDURE openQueryPedVenda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                WHERE {&TableName}.nome-abrev = v-nome-abrev
                                  AND {&TableName}.nr-pedcli  = v-nr-pedcli INDEXED-REPOSITION.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNotaFiscal DBOProgram 
PROCEDURE setConstraintNotaFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE {&TableName}.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER p-serie       LIKE {&TableName}.serie       NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-nota-fis LIKE {&TableName}.nr-nota-fis NO-UNDO.

    ASSIGN v-cod-estabel = p-cod-estabel
           v-serie       = p-serie
           v-nr-nota-fis = p-nr-nota-fis.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNrOs DBOProgram 
PROCEDURE setConstraintNrOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nr-os LIKE {&TableName}.nr-os NO-UNDO.

    ASSIGN v-nr-os = p-nr-os.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPedItem DBOProgram 
PROCEDURE setConstraintPedItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nome-abrev   LIKE {&TableName}.nome-abrev   NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedcli    LIKE {&TableName}.nr-pedcli    NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-sequencia LIKE {&TableName}.nr-sequencia NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo    LIKE {&TableName}.it-codigo    NO-UNDO.

    ASSIGN v-nome-abrev   = p-nome-abrev
           v-nr-pedcli    = p-nr-pedcli
           v-nr-sequencia = p-nr-sequencia
           v-it-codigo    = p-it-codigo.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPedItemAstec DBOProgram 
PROCEDURE setConstraintPedItemAstec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nome-abrev-ini   LIKE {&TableName}.nome-abrev   NO-UNDO.
    DEFINE INPUT  PARAMETER p-nome-abrev-fin   LIKE {&TableName}.nome-abrev   NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedcli-ini    LIKE {&TableName}.nr-pedcli    NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedcli-fin    LIKE {&TableName}.nr-pedcli    NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-sequencia-ini LIKE {&TableName}.nr-sequencia NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-sequencia-fin LIKE {&TableName}.nr-sequencia NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo-ini    LIKE {&TableName}.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo-fin    LIKE {&TableName}.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-os-ini        LIKE {&TableName}.nr-os        NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-os-fin        LIKE {&TableName}.nr-os        NO-UNDO.

    ASSIGN v-nome-abrev-ini   = p-nome-abrev-ini
           v-nome-abrev-fin   = p-nome-abrev-fin
           v-nr-pedcli-ini    = p-nr-pedcli-ini
           v-nr-pedcli-fin    = p-nr-pedcli-fin
           v-nr-sequencia-ini = p-nr-sequencia-ini
           v-nr-sequencia-fin = p-nr-sequencia-fin
           v-it-codigo-ini    = p-it-codigo-ini
           v-it-codigo-fin    = p-it-codigo-fin
           v-nr-os-ini        = p-nr-os-ini
           v-nr-os-fin        = p-nr-os-fin.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPedVenda DBOProgram 
PROCEDURE setConstraintPedVenda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nome-abrev LIKE {&TableName}.nome-abrev NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedcli  LIKE {&TableName}.nr-pedcli  NO-UNDO.

    ASSIGN v-nome-abrev = p-nome-abrev
           v-nr-pedcli  = p-nr-pedcli.

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

    IF pType = "Create":U AND
       pType = "Update":U THEN DO:
        FIND FIRST emitente
            WHERE emitente.nome-abrev = RowObject.nome-abrev NO-LOCK NO-ERROR.

        IF NOT AVAILABLE emitente THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Cliente'"}
        END.

        FIND FIRST item
            WHERE item.it-codigo = RowObject.it-codigo NO-LOCK NO-ERROR.

        IF NOT AVAILABLE item THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Item'"}
        END.

        IF RowObject.nr-pedcli = "":U OR
           RowObject.nr-pedcli = ?    THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17386"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Pedido Cliente'"}
        END.

        IF RowObject.nr-sequencia = ? THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17386"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'SeqÅància'"}
        END.
        ELSE IF RowObject.nr-sequencia <= 0 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17634"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'SeqÅància'"}
        END.

        IF RowObject.nr-os = "":U OR
           RowObject.nr-os = ?    THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17386"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'N£mero OS'"}
        END.

        IF RowObject.qt-pedida = ? THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17386"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Quantidade Pedida'"}
        END.
        ELSE IF RowObject.qt-pedida <= 0 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17634"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Quantidade Pedida'"}
        END.
        ELSE IF RowObject.qt-alocada <> ? AND
                RowObject.qt-alocada  > 0 THEN DO:
            IF RowObject.qt-pedida < RowObject.qt-alocada THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Quantidade Alocada n∆o pode ser maior que a Quantidade Pedida'"}
            END.
            ELSE IF RowObject.qt-alocada <> RowObject.qt-pedida THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'N∆o Ç permitido alocaá∆o parcial do Pedido cliente X Ocorrància ASTEC'"}
            END.
        END.

        IF RowObject.cod-estabel <> "":U AND
           RowObject.cod-estabel <> ?    THEN DO:
            FIND FIRST estabelec
                WHERE estabelec.cod-estabel = RowObject.cod-estabel NO-LOCK NO-ERROR.

            IF NOT AVAILABLE estabelec THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Estabelecimento'"}
            END.

            IF RowObject.qt-alocada = 0 THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'N∆o Ç poss°vel cadastrar uma nota fiscal para esta ocorrància da ASTEC~~N∆o Ç poss°vel cadastrar uma nota fiscal para esta ocorrància pois Ç necess†rio ter quantidade alocada'"}
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

