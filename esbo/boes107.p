&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) é um programa PROGRESS 
                 que contém a lógica de negócio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definição ---*/
&GLOBAL-DEFINE DBOName BOES107
&GLOBAL-DEFINE DBOVersion 1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-ean
&GLOBAL-DEFINE TableLabel item-ean
&GLOBAL-DEFINE QueryName qritem-ean 

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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (método Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que dá acessos a todos os registros, exceto os excluídos pela constraint de segurança. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress não conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definição da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diretório do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idêntico ao nome do DBO mas com 
      extensão .i ---*/
      
      
{esbo/boes107.i RowObject}
      
        

/*:T--- Include com definição da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteração da definição da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definição 
      manual da query ---*/
{method/dboqry.i}

/*:T--- Definição de buffer que será utilizado pelo método goToKey ---*/

DEFINE BUFFER bfitem-ean FOR {&TableName}.

DEF VAR v-ini-descricao     LIKE item-ean.descricao     NO-UNDO.
DEF VAR v-fim-descricao     LIKE item-ean.descricao     NO-UNDO.
DEF VAR v-ini-it-codigo     LIKE item-ean.it-codigo     NO-UNDO.
DEF VAR v-fim-it-codigo     LIKE item-ean.it-codigo     NO-UNDO.

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
         HEIGHT             = 17.54
         WIDTH              = 50.86.
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:        
        WHEN "char-1":U      THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U      THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "char-3":U      THEN ASSIGN pFieldValue = RowObject.char-3.
        WHEN "descricao":U   THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "flash":U       THEN ASSIGN pFieldValue = RowObject.flash.
        WHEN "fone":U        THEN ASSIGN pFieldValue = RowObject.fone.
        WHEN "homolog":U     THEN ASSIGN pFieldValue = RowObject.homolog.
        WHEN "it-codigo":U   THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "linha[1]":U    THEN ASSIGN pFieldValue = RowObject.linha[1].
        WHEN "linha[2]":U    THEN ASSIGN pFieldValue = RowObject.linha[2].
        WHEN "linha[3]":U    THEN ASSIGN pFieldValue = RowObject.linha[3].
        WHEN "texto[1]":U    THEN ASSIGN pFieldValue = RowObject.texto[1].
        WHEN "texto[2]":U    THEN ASSIGN pFieldValue = RowObject.texto[2].
        WHEN "texto[3]":U    THEN ASSIGN pFieldValue = RowObject.texto[3].
        WHEN "texto[4]":U    THEN ASSIGN pFieldValue = RowObject.texto[4].
        WHEN "texto[5]":U    THEN ASSIGN pFieldValue = RowObject.texto[5].
        WHEN "texto[6]":U    THEN ASSIGN pFieldValue = RowObject.texto[6].
        WHEN "texto[7]":U    THEN ASSIGN pFieldValue = RowObject.texto[7].
        WHEN "texto[8]":U    THEN ASSIGN pFieldValue = RowObject.texto[8].
        WHEN "texto[9]":U    THEN ASSIGN pFieldValue = RowObject.texto[9].
        WHEN "texto[10]":U   THEN ASSIGN pFieldValue = RowObject.texto[10].
        WHEN "texto[11]":U   THEN ASSIGN pFieldValue = RowObject.texto[11].
        WHEN "texto[12]":U   THEN ASSIGN pFieldValue = RowObject.texto[12].
        WHEN "texto[13]":U   THEN ASSIGN pFieldValue = RowObject.texto[13].
        WHEN "texto[14]":U   THEN ASSIGN pFieldValue = RowObject.texto[14].
        WHEN "texto[15]":U   THEN ASSIGN pFieldValue = RowObject.texto[15].
        WHEN "info-tec[1]":U THEN ASSIGN pFieldValue = RowObject.info-tec[1].
        WHEN "info-tec[2]":U THEN ASSIGN pFieldValue = RowObject.info-tec[2].
        WHEN "info-tec[3]":U THEN ASSIGN pFieldValue = RowObject.info-tec[3].
        WHEN "nc":U           THEN ASSIGN pFieldValue = RowObject.nc.
        WHEN "modulo":U       THEN ASSIGN pFieldValue = RowObject.modulo.
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "qtd-mac":U THEN ASSIGN pFieldValue = RowObject.qtd-mac.
        WHEN "qtd-ns":U THEN ASSIGN pFieldValue = RowObject.qtd-ns.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do índice ae
  Parameters:  
               retorna valor do campo nr-ae
               retorna valor do campo sequencia
               retorna valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-ean.it-codigo NO-UNDO.    

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo lógico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "lmarcador[1]":U  THEN ASSIGN pFieldValue = RowObject.lmarcador[1].
        WHEN "lmarcador[2]":U  THEN ASSIGN pFieldValue = RowObject.lmarcador[2].
        WHEN "lmarcador[3]":U  THEN ASSIGN pFieldValue = RowObject.lmarcador[3].
        WHEN "lmarcador[4]":U  THEN ASSIGN pFieldValue = RowObject.lmarcador[4].
        WHEN "lmarcador[5]":U  THEN ASSIGN pFieldValue = RowObject.lmarcador[5].
        WHEN "lmarcador[6]":U  THEN ASSIGN pFieldValue = RowObject.lmarcador[6].
        WHEN "lmarcador[7]":U  THEN ASSIGN pFieldValue = RowObject.lmarcador[7].
        WHEN "lmarcador[8]":U  THEN ASSIGN pFieldValue = RowObject.lmarcador[8].
        WHEN "lmarcador[9]":U  THEN ASSIGN pFieldValue = RowObject.lmarcador[9].
        WHEN "lmarcador[10]":U THEN ASSIGN pFieldValue = RowObject.lmarcador[10].
        WHEN "lmarcador[11]":U THEN ASSIGN pFieldValue = RowObject.lmarcador[11].
        WHEN "lmarcador[12]":U THEN ASSIGN pFieldValue = RowObject.lmarcador[12].
        WHEN "lmarcador[13]":U THEN ASSIGN pFieldValue = RowObject.lmarcador[13].
        WHEN "lmarcador[14]":U THEN ASSIGN pFieldValue = RowObject.lmarcador[14].
        WHEN "lmarcador[15]":U THEN ASSIGN pFieldValue = RowObject.lmarcador[15].
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
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
  Purpose:     Reposiciona registro com base no índice ae
  Parameters:  
               recebe valor do campo 
               recebe valor do campo 
               recebe valor do campo 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-ean.it-codigo  NO-UNDO.    

    FIND FIRST bfitem-ean                        WHERE 
               bfitem-ean.it-codigo BEGINS pit-codigo 
               NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro será retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-ean THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query através de rowid e verifica a ocorrência de erros, caso
          existam erros será retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-ean)).
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


OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
     {&TableName}.it-codigo >= v-ini-it-codigo AND
     {&TableName}.it-codigo <= v-fim-it-codigo AND
     {&TableName}.descricao >= v-ini-descricao and
     {&TableName}.descricao <= v-fim-descricao.
/*      {&TableName}.descricao MATCHES("*" + v-ini-descricao + "*") AND */
/*      {&TableName}.descricao MATCHES("*" + v-fim-descricao + "*"). */
    
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

    DEF INPUT PARAM p-ini-it-codigo    LIKE item-ean.it-codigo NO-UNDO.
    DEF INPUT PARAM p-fim-it-codigo    LIKE item-ean.it-codigo NO-UNDO.
    DEF INPUT PARAM p-ini-descricao    LIKE item-ean.descricao NO-UNDO.
    DEF INPUT PARAM p-fim-descricao    LIKE item-ean.descricao NO-UNDO.

    ASSIGN v-ini-it-codigo = p-ini-it-codigo
           v-fim-it-codigo = p-fim-it-codigo
           v-ini-descricao = p-ini-descricao
           v-fim-descricao = p-fim-descricao.

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
  Purpose:     Validações pertinentes ao DBO
  Parameters:  recebe o tipo de validação (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parâmetro pType para identificar quais as validações a serem
          executadas ---*/
    /*:T--- Os valores possíveis para o parâmetro são: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, através do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validações ---*/

    CASE pType:
         WHEN "Create" THEN DO:
             IF NOT CAN-FIND(FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = RowObject.it-codigo) THEN DO:
                 {method/svc/errors/inserr.i
                       &ErrorNumber="1"
                       &ErrorType="Outros"
                       &ErrorSubType="ERROR"
                       &ErrorDescription="Item nÆo Cadastrado no EMS"
                       &ErrorHelp="Item deve ser cadastrado no EMS. Depois ser  poss¡vel cadastrar EAN"}
             END.
             
         END.
    END.

    
    
    /*:T--- Verifica ocorrência de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

