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
{include/i-prgvrs.i BOES436 2.00.00.000}                               
/*--------------------------------------------------------------------------
    File       : 
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
&GLOBAL-DEFINE DBOName  BOES436
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  item-estab-b2c
&GLOBAL-DEFINE TableLabel  Item X Estab B2C              
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
{esbo/boes436.i RowObject}
 
 
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Definiá∆o de vari†veis *********************** */
define variable v-it-codigo         as character   no-undo.
define variable v-ind-aceita-saldao as logical     no-undo.
define variable v-cod-estabel       as character   no-undo.
define variable c-cod-estabel-ini   as character   no-undo.
define variable c-cod-estabel-fim   as character   no-undo.
define variable c-it-codigo-ini     as character   no-undo.
define variable c-it-codigo-fim     as character   no-undo.
 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 
 
/* ********************  Preprocessor Definitions  ******************** */
 
&Scoped-define PROCEDURE-TYPE DBOProgram
 
 
 
/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME
 
 
 
/* *********************** Procedure Settings ************************ */
 
&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram Template
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
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard */
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
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    CASE pType:
         WHEN "Create" THEN DO:
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.it-codigo = RowObject.it-codigo
                 AND bf{&TableName}.ind-aceita-saldao = RowObject.ind-aceita-saldao) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

         END.
         WHEN "Update" THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.it-codigo = RowObject.it-codigo
                 AND bf{&TableName}.ind-aceita-saldao = RowObject.ind-aceita-saldao) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

         END.
         WHEN "Delete" THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.it-codigo = RowObject.it-codigo
                 AND bf{&TableName}.ind-aceita-saldao = RowObject.ind-aceita-saldao) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

         END.
    END CASE.

    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
   if (pType = 'Create') then do:
      if not can-find (first estabelec
                       where estabelec.cod-estabel = RowObject.cod-estabel) then do:
         {method/svc/errors/inserr.i
             &ErrorNumber="17006"
             &ErrorType="EMS"
             &ErrorSubType="ERROR"
             &ErrorParameters="'Estabelecimento n∆o cadastrado'"
         }
      end.
   
      if not can-find (first item
                       where item.it-codigo = RowObject.it-codigo) then do:
         {method/svc/errors/inserr.i
             &ErrorNumber="17006"
             &ErrorType="EMS"
             &ErrorSubType="ERROR"
             &ErrorParameters="'Item n∆o cadastrado'"
         }
      end.
   end.

   if (pType = 'Create') or (pType = 'Update') then do:
      if (RowObject.vl-por > 0) and (RowObject.vl-por > RowObject.vl-cheio) then do:
         {method/svc/errors/inserr.i
             &ErrorNumber="17006"
             &ErrorType="EMS"
             &ErrorSubType="ERROR"
             &ErrorParameters="'Valor Por n∆o pode ser maior que Valor Cheio'"
         }
      end.
   end.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram                                                                  
PROCEDURE getCharField :                                                                                                            
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.                                                                       

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "caracteristica":U THEN ASSIGN pFieldValue = RowObject.caracteristica.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nome-produto":U THEN ASSIGN pFieldValue = RowObject.nome-produto.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram                                                                   
PROCEDURE getIntField :                                                                                                             
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.                                                                         

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "qt-maxima-venda":U THEN ASSIGN pFieldValue = RowObject.qt-maxima-venda.
        WHEN "qt-minima":U THEN ASSIGN pFieldValue = RowObject.qt-minima.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram                                                                   
PROCEDURE getDecField :                                                                                                             
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.                                                                         

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "vl-cheio":U THEN ASSIGN pFieldValue = RowObject.vl-cheio.
        WHEN "vl-por":U THEN ASSIGN pFieldValue = RowObject.vl-por.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram                                                                   
PROCEDURE getLogField :                                                                                                             
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.                                                                         

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ativo":U THEN ASSIGN pFieldValue = RowObject.ativo.
        WHEN "ind-aceita-saldao":U THEN ASSIGN pFieldValue = RowObject.ind-aceita-saldao.
        WHEN "presente":U THEN ASSIGN pFieldValue = RowObject.presente.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram                                                             
PROCEDURE setConstraintMain :                                                                                                       
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram                                                                 
PROCEDURE openQueryMain :                                                                                                           

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-item DBOProgram                                                          
PROCEDURE setConstraintCh-item :                                                                                                    
    DEFINE INPUT PARAMETER p-it-codigo AS character NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-ind-aceita-saldao AS logical NO-UNDO.                                                                  

    ASSIGN 
    v-it-codigo = p-it-codigo                                         
    v-ind-aceita-saldao = p-ind-aceita-saldao                         
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-item DBOProgram                                                              
PROCEDURE openQueryCh-item :                                                                                                        

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.it-codigo = v-it-codigo                    
        AND {&TableName}.ind-aceita-saldao = v-ind-aceita-saldao      
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-pri DBOProgram                                                           
PROCEDURE setConstraintCh-pri :                                                                                                     
    DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-it-codigo AS character NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-ind-aceita-saldao AS logical NO-UNDO.                                                                  

    ASSIGN 
    v-cod-estabel = p-cod-estabel                                     
    v-it-codigo = p-it-codigo                                         
    v-ind-aceita-saldao = p-ind-aceita-saldao                         
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-pri DBOProgram                                                               
PROCEDURE openQueryCh-pri :                                                                                                         

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-estabel = v-cod-estabel                
        AND {&TableName}.it-codigo = v-it-codigo                      
        AND {&TableName}.ind-aceita-saldao = v-ind-aceita-saldao      
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram
PROCEDURE openQuery :
    DEFINE INPUT PARAMETER iAbertura AS INTEGER NO-UNDO.

    CASE iAbertura:
        WHEN 1 THEN
            RUN openQueryStatic ("Main":U).
        WHEN 2 THEN           
            RUN openQueryStatic ("Ch-item":U).                        
        WHEN 3 THEN           
            RUN openQueryStatic ("Ch-pri":U).                         
    END CASE.
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
DEFINE INPUT PARAMETER p-cod-estabel-ini AS CHARACTER NO-UNDO.      
DEFINE INPUT PARAMETER p-cod-estabel-fim AS CHARACTER NO-UNDO.      
DEFINE INPUT PARAMETER p-it-codigo-ini   AS CHARACTER NO-UNDO.    
DEFINE INPUT PARAMETER p-it-codigo-fim   AS CHARACTER NO-UNDO.    

ASSIGN 
    c-cod-estabel-ini = p-cod-estabel-ini
    c-cod-estabel-fim = p-cod-estabel-fim
    c-it-codigo-ini   = p-it-codigo-ini  
    c-it-codigo-fim   = p-it-codigo-fim.  

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
OPEN QUERY {&queryName} 
    FOR EACH  {&TableName} NO-LOCK
       WHERE  {&TableName}.cod-estabel >= c-cod-estabel-ini
         AND  {&TableName}.cod-estabel <= c-cod-estabel-fim
         AND  {&TableName}.it-codigo   >= c-it-codigo-ini
         AND  {&TableName}.it-codigo   <= c-it-codigo-fim.
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cd-oper
  Notes:       
------------------------------------------------------------------------------*/
   define input parameter pcod-estabel       like item-estab-b2c.cod-estabel        no-undo.
   define input parameter pit-codigo         like item-estab-b2c.it-codigo          no-undo.
   define input parameter pind-aceita-saldao like item-estab-b2c.ind-aceita-saldao  no-undo.

   find bf{&TableName} no-lock
      where bf{&TableName}.cod-estabel       = pcod-estabel
        and bf{&TableName}.it-codigo         = pit-codigo
        and bf{&TableName}.ind-aceita-saldao = pind-aceita-saldao no-error.

   /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
   if not available bf{&TableName} then
      return "NOK":U.

   /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
         existam erros ser† retornada flag "NOK":U ---*/
   run repositionRecord in this-procedure (input rowid(bf{&TableName})).
   if return-value = "NOK":U then
      return "NOK":U.

   return "OK":U.
END PROCEDURE.
