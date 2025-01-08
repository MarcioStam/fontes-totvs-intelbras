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
{include/i-prgvrs.i BOES455 2.00.00.000}                               
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
&GLOBAL-DEFINE DBOName  BOES455
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  vpc
&GLOBAL-DEFINE TableLabel  VPC                           
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
{esbo/boes455.i RowObject}
 
 
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Definiá∆o de vari†veis *********************** */
define variable v-cod-estabel as character no-undo.
define variable v-cod-emitente as integer no-undo.
define variable v-tipo-acordo as integer no-undo.
define variable v-tipo-verba as integer no-undo.
define variable v-data-evento as date no-undo.
define variable v-data-vencto as date no-undo.
define variable v-situacao as integer no-undo.
define variable v-empenho as logical no-undo.
define variable v-comprovacao as logical no-undo.
define variable v-nota-debito as integer no-undo.
define variable v-nro-docto as character no-undo.
define variable v-serie-docto as character no-undo.
define variable v-cod-esp as character no-undo.
define variable v-cod-unid-negoc as character no-undo.
define variable v-nr-vpc as integer no-undo.
define variable v-usuario-trans as character no-undo.
 

define variable v-bloqueadas  as logical no-undo.
define variable v-liberadas   as logical no-undo.
define variable v-finalizadas as logical no-undo.
define variable v-canceladas  as logical no-undo.

DEFINE VARIABLE v-data-trans-ini AS DATE  NO-UNDO.
DEFINE VARIABLE v-data-trans-fim AS DATE  NO-UNDO.
DEFINE VARIABLE v-vencto-ini     AS DATE  NO-UNDO.
DEFINE VARIABLE v-vencto-fim     AS DATE  NO-UNDO.

DEFINE VARIABLE i-tipo-verba     AS INTEGER     NO-UNDO.

DEF TEMP-TABLE tt-vpc-rateio LIKE vpc-rateio.

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
         HEIGHT             = 9.46
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN RowObject.nr-vpc = NEXT-VALUE(seq_vpc).

    FOR EACH tt-vpc-rateio:
        ASSIGN tt-vpc-rateio.nr-vpc = RowObject.nr-vpc.
    END.

    
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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
        WHEN "cod_ccusto":U THEN ASSIGN pFieldValue = RowObject.cod_ccusto.
        WHEN "email-repres":U THEN ASSIGN pFieldValue = RowObject.email-repres.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "num-pagto":U THEN ASSIGN pFieldValue = RowObject.num-pagto.
        WHEN "observacoes":U THEN ASSIGN pFieldValue = RowObject.observacoes.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "usuario-liberacao":U THEN ASSIGN pFieldValue = RowObject.usuario-liberacao.
        WHEN "usuario-trans":U THEN ASSIGN pFieldValue = RowObject.usuario-trans.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.                                                                            

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-evento":U THEN ASSIGN pFieldValue = RowObject.data-evento.
        WHEN "data-liberacao":U THEN ASSIGN pFieldValue = RowObject.data-liberacao.
        WHEN "data-trans":U THEN ASSIGN pFieldValue = RowObject.data-trans.
        WHEN "data-vencto":U THEN ASSIGN pFieldValue = RowObject.data-vencto.
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
        WHEN "valor":U THEN ASSIGN pFieldValue = RowObject.valor.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "forma-pagto":U THEN ASSIGN pFieldValue = RowObject.forma-pagto.
        WHEN "id-pagto":U THEN ASSIGN pFieldValue = RowObject.id-pagto.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "nota-debito":U THEN ASSIGN pFieldValue = RowObject.nota-debito.
        WHEN "nr-vpc":U THEN ASSIGN pFieldValue = RowObject.nr-vpc.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "tipo-acordo":U THEN ASSIGN pFieldValue = RowObject.tipo-acordo.
        WHEN "tipo-verba":U THEN ASSIGN pFieldValue = RowObject.tipo-verba.
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
        WHEN "comprovacao":U THEN ASSIGN pFieldValue = RowObject.comprovacao.
        WHEN "empenho":U THEN ASSIGN pFieldValue = RowObject.empenho.
        WHEN "log1":U THEN ASSIGN pFieldValue = RowObject.log1.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
DEFINE INPUT PARAMETER p-nr-vpc AS integer NO-UNDO.                                                                             

    FIND bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.nr-vpc = p-nr-vpc                        
        NO-ERROR.
    IF NOT AVAILABLE bf{&TableName} THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToEmitente DBOProgram 
PROCEDURE linkToEmitente :
DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
   RUN getKey IN pHandle (OUTPUT v-cod-emitente).
   
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
            RUN openQueryStatic ("Ch-emitente":U).                    
        WHEN 3 THEN           
            RUN openQueryStatic ("Ch-emitente2":U).                   
        WHEN 4 THEN           
            RUN openQueryStatic ("Ch-evento":U).                      
        WHEN 5 THEN           
            RUN openQueryStatic ("Ch-sitpag":U).                      
        WHEN 6 THEN           
            RUN openQueryStatic ("Ch-sitpag2":U).                     
        WHEN 7 THEN           
            RUN openQueryStatic ("Ch-situacao":U).                    
        WHEN 8 THEN           
            RUN openQueryStatic ("Ch-titulo":U).                      
        WHEN 9 THEN           
            RUN openQueryStatic ("Ch-usuario":U).                     
        WHEN 10 THEN          
            RUN openQueryStatic ("Ch-vencimento":U).                  
        WHEN 11 THEN          
            RUN openQueryStatic ("Ch-vpc":U).                         
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-emitente DBOProgram 
PROCEDURE openQueryCh-emitente :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
        WHERE {&TableName}.cod-estabel = v-cod-estabel                
        AND {&TableName}.cod-emitente = v-cod-emitente                
        AND {&TableName}.tipo-acordo = v-tipo-acordo                  
        AND {&TableName}.tipo-verba = v-tipo-verba  INDEXED-REPOSITION                   
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-emitente2 DBOProgram 
PROCEDURE openQueryCh-emitente2 :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
        WHERE {&TableName}.cod-emitente = v-cod-emitente              
        AND {&TableName}.cod-estabel = v-cod-estabel                  
        AND {&TableName}.data-evento = v-data-evento                  
        AND {&TableName}.data-vencto = v-data-vencto  INDEXED-REPOSITION
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-evento DBOProgram 
PROCEDURE openQueryCh-evento :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
        WHERE {&TableName}.data-evento = v-data-evento                
        AND {&TableName}.cod-estabel = v-cod-estabel                  
        AND {&TableName}.tipo-acordo = v-tipo-acordo                  
        AND {&TableName}.tipo-verba = v-tipo-verba  INDEXED-REPOSITION
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-situacao DBOProgram 
PROCEDURE openQueryCh-situacao :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
        WHERE {&TableName}.situacao = v-situacao                      
        AND {&TableName}.empenho = v-empenho                          
        AND {&TableName}.comprovacao = v-comprovacao                  
        AND {&TableName}.nota-debito = v-nota-debito  INDEXED-REPOSITION
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-titulo DBOProgram 
PROCEDURE openQueryCh-titulo :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
        WHERE {&TableName}.cod-estabel = v-cod-estabel                
        AND {&TableName}.cod-emitente = v-cod-emitente                
        AND {&TableName}.nro-docto = v-nro-docto                      
        AND {&TableName}.serie-docto = v-serie-docto                  
        AND {&TableName}.cod-esp = v-cod-esp   INDEXED-REPOSITION
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-titulo2 DBOProgram 
PROCEDURE openQueryCh-titulo2 :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
        WHERE {&TableName}.nro-docto = v-nro-docto                    
        AND {&TableName}.serie-docto = v-serie-docto                  
        AND {&TableName}.cod-esp = v-cod-esp  INDEXED-REPOSITION
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-unidade DBOProgram 
PROCEDURE openQueryCh-unidade :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
        WHERE {&TableName}.cod-unid-negoc = v-cod-unid-negoc          
        AND {&TableName}.cod-estabel = v-cod-estabel                  
        AND {&TableName}.cod-emitente = v-cod-emitente                
        AND {&TableName}.nr-vpc = v-nr-vpc  INDEXED-REPOSITION
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-usuario DBOProgram 
PROCEDURE openQueryCh-usuario :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
        WHERE {&TableName}.usuario-trans = v-usuario-trans            
        AND {&TableName}.cod-estabel = v-cod-estabel  INDEXED-REPOSITION
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-vencimento DBOProgram 
PROCEDURE openQueryCh-vencimento :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
        WHERE {&TableName}.data-vencto = v-data-vencto                
        AND {&TableName}.cod-estabel = v-cod-estabel                  
        AND {&TableName}.tipo-acordo = v-tipo-acordo                  
        AND {&TableName}.tipo-verba = v-tipo-verba   INDEXED-REPOSITION
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-vpc DBOProgram 
PROCEDURE openQueryCh-vpc :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
        WHERE {&TableName}.nr-vpc = v-nr-vpc  INDEXED-REPOSITION
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySituacao DBOProgram 
PROCEDURE openQuerySituacao :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
        WHERE {&TableName}.situacao = v-situacao INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryVpcEmitente DBOProgram 
PROCEDURE openQueryVpcEmitente :
DEFINE VARIABLE i-situacao AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-situacao AS CHARACTER   NO-UNDO.

    IF v-bloqueadas  AND 
       v-liberadas   AND
       v-finalizadas AND 
       v-canceladas  THEN DO:
        OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
             WHERE {&TableName}.cod-emitente = v-cod-emitente INDEXED-REPOSITION.
    END.
    ELSE DO:
        IF v-bloqueadas  THEN ASSIGN c-situacao = c-situacao + "0,".
        IF v-liberadas   THEN ASSIGN c-situacao = c-situacao + "1,".
        IF v-finalizadas THEN ASSIGN c-situacao = c-situacao + "2,".
        IF v-canceladas  THEN ASSIGN c-situacao = c-situacao + "3,".

        OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
             WHERE {&TableName}.cod-emitente = v-cod-emitente 
               AND LOOKUP(STRING({&TableName}.situacao),c-situacao) <> 0 INDEXED-REPOSITION.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryVpcSit DBOProgram 
PROCEDURE openQueryVpcSit :
IF v-situacao = 4 THEN DO:
        IF i-tipo-verba = ? OR i-tipo-verba = 0 THEN DO:
            /*Todas*/
            OPEN QUERY {&QueryName} 
                FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
                   WHERE {&TableName}.data-trans  >= v-data-trans-ini
                     AND {&TableName}.data-trans  <= v-data-trans-fim
                     AND {&TableName}.data-vencto >= v-vencto-ini
                     AND {&TableName}.data-vencto <= v-vencto-fim
                INDEXED-REPOSITION.
        END.
        ELSE DO:
            OPEN QUERY {&QueryName} 
                FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
                   WHERE {&TableName}.data-trans  >= v-data-trans-ini
                     AND {&TableName}.data-trans  <= v-data-trans-fim
                     AND {&TableName}.data-vencto >= v-vencto-ini
                     AND {&TableName}.data-vencto <= v-vencto-fim
                     AND {&TableName}.tipo-verba   = i-tipo-verba
                INDEXED-REPOSITION.
        END.
    END.
    ELSE DO:
        IF i-tipo-verba = ? OR i-tipo-verba = 0 THEN DO:
            OPEN QUERY {&QueryName} 
                FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
                   WHERE {&TableName}.situacao = v-situacao
                     AND {&TableName}.data-trans >= v-data-trans-ini
                     AND {&TableName}.data-trans <= v-data-trans-fim
                     AND {&TableName}.data-vencto >= v-vencto-ini
                     AND {&TableName}.data-vencto <= v-vencto-fim
                INDEXED-REPOSITION.
        END.
        ELSE DO:
            OPEN QUERY {&QueryName} 
                FOR EACH {&TableName} NO-LOCK USE-INDEX ch-vpc
                   WHERE {&TableName}.situacao = v-situacao
                     AND {&TableName}.data-trans >= v-data-trans-ini
                     AND {&TableName}.data-trans <= v-data-trans-fim
                     AND {&TableName}.data-vencto >= v-vencto-ini
                     AND {&TableName}.data-vencto <= v-vencto-fim
                     AND {&TableName}.tipo-verba   = i-tipo-verba
                INDEXED-REPOSITION.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-emitente DBOProgram 
PROCEDURE setConstraintCh-emitente :
DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-cod-emitente AS integer NO-UNDO.                                                                       
    DEFINE INPUT PARAMETER p-tipo-acordo AS integer NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-tipo-verba AS integer NO-UNDO.                                                                         

    ASSIGN 
    v-cod-estabel = p-cod-estabel                                     
    v-cod-emitente = p-cod-emitente                                   
    v-tipo-acordo = p-tipo-acordo                                     
    v-tipo-verba = p-tipo-verba                                       
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-emitente2 DBOProgram 
PROCEDURE setConstraintCh-emitente2 :
DEFINE INPUT PARAMETER p-cod-emitente AS integer NO-UNDO.                                                                       
    DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-data-evento AS date NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-data-vencto AS date NO-UNDO.                                                                           

    ASSIGN 
    v-cod-emitente = p-cod-emitente                                   
    v-cod-estabel = p-cod-estabel                                     
    v-data-evento = p-data-evento                                     
    v-data-vencto = p-data-vencto                                     
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-evento DBOProgram 
PROCEDURE setConstraintCh-evento :
DEFINE INPUT PARAMETER p-data-evento AS date NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-tipo-acordo AS integer NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-tipo-verba AS integer NO-UNDO.                                                                         

    ASSIGN 
    v-data-evento = p-data-evento                                     
    v-cod-estabel = p-cod-estabel                                     
    v-tipo-acordo = p-tipo-acordo                                     
    v-tipo-verba = p-tipo-verba                                       
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-situacao DBOProgram 
PROCEDURE setConstraintCh-situacao :
DEFINE INPUT PARAMETER p-situacao AS integer NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-empenho AS logical NO-UNDO.                                                                            
    DEFINE INPUT PARAMETER p-comprovacao AS logical NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-nota-debito AS integer NO-UNDO.                                                                        

    ASSIGN 
    v-situacao = p-situacao                                           
    v-empenho = p-empenho                                             
    v-comprovacao = p-comprovacao                                     
    v-nota-debito = p-nota-debito                                     
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-titulo DBOProgram 
PROCEDURE setConstraintCh-titulo :
DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-cod-emitente AS integer NO-UNDO.                                                                       
    DEFINE INPUT PARAMETER p-nro-docto AS character NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-serie-docto AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-cod-esp AS character NO-UNDO.                                                                          

    ASSIGN 
    v-cod-estabel = p-cod-estabel                                     
    v-cod-emitente = p-cod-emitente                                   
    v-nro-docto = p-nro-docto                                         
    v-serie-docto = p-serie-docto                                     
    v-cod-esp = p-cod-esp                                             
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-titulo2 DBOProgram 
PROCEDURE setConstraintCh-titulo2 :
DEFINE INPUT PARAMETER p-nro-docto AS character NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-serie-docto AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-cod-esp AS character NO-UNDO.                                                                          

    ASSIGN 
    v-nro-docto = p-nro-docto                                         
    v-serie-docto = p-serie-docto                                     
    v-cod-esp = p-cod-esp                                             
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-unidade DBOProgram 
PROCEDURE setConstraintCh-unidade :
DEFINE INPUT PARAMETER p-cod-unid-negoc AS character NO-UNDO.                                                                   
    DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-cod-emitente AS integer NO-UNDO.                                                                       
    DEFINE INPUT PARAMETER p-nr-vpc AS integer NO-UNDO.                                                                             

    ASSIGN 
    v-cod-unid-negoc = p-cod-unid-negoc                               
    v-cod-estabel = p-cod-estabel                                     
    v-cod-emitente = p-cod-emitente                                   
    v-nr-vpc = p-nr-vpc                                               
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-usuario DBOProgram 
PROCEDURE setConstraintCh-usuario :
DEFINE INPUT PARAMETER p-usuario-trans AS character NO-UNDO.                                                                    
    DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      

    ASSIGN 
    v-usuario-trans = p-usuario-trans                                 
    v-cod-estabel = p-cod-estabel                                     
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-vencimento DBOProgram 
PROCEDURE setConstraintCh-vencimento :
DEFINE INPUT PARAMETER p-data-vencto AS date NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-tipo-acordo AS integer NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-tipo-verba AS integer NO-UNDO.                                                                         

    ASSIGN 
    v-data-vencto = p-data-vencto                                     
    v-cod-estabel = p-cod-estabel                                     
    v-tipo-acordo = p-tipo-acordo                                     
    v-tipo-verba = p-tipo-verba                                       
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-vpc DBOProgram 
PROCEDURE setConstraintCh-vpc :
DEFINE INPUT PARAMETER p-nr-vpc AS integer NO-UNDO.                                                                             

    ASSIGN 
    v-nr-vpc = p-nr-vpc                                               
    .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSituacao DBOProgram 
PROCEDURE setConstraintSituacao :
DEFINE INPUT PARAMETER p-situacao AS integer NO-UNDO.                                                                           

    ASSIGN v-situacao = p-situacao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintVpcEmitente DBOProgram 
PROCEDURE setConstraintVpcEmitente :
DEFINE INPUT PARAMETER p-cod-emitente AS integer NO-UNDO.
    DEFINE INPUT PARAMETER p-bloqueadas   AS logical NO-UNDO.
    DEFINE INPUT PARAMETER p-liberadas    AS logical NO-UNDO.
    DEFINE INPUT PARAMETER p-finalizadas  AS logical NO-UNDO.
    DEFINE INPUT PARAMETER p-canceladas   AS logical NO-UNDO.

    ASSIGN v-cod-emitente = p-cod-emitente
           v-bloqueadas   = p-bloqueadas
           v-liberadas    = p-liberadas
           v-finalizadas  = p-finalizadas
           v-canceladas   = p-canceladas.  

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintVpcSit DBOProgram 
PROCEDURE setConstraintVpcSit :
DEFINE INPUT PARAMETER p-data-trans-ini AS DATE NO-UNDO.
    DEFINE INPUT PARAMETER p-data-trans-fim AS DATE NO-UNDO.
    DEFINE INPUT PARAMETER p-vencto-ini     AS DATE NO-UNDO.
    DEFINE INPUT PARAMETER p-vencto-fim     AS DATE NO-UNDO.
    DEFINE INPUT PARAMETER p-situacao       AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-tipo-verba     AS INTEGER NO-UNDO.
    

    ASSIGN v-data-trans-ini = p-data-trans-ini
           v-data-trans-fim = p-data-trans-fim
           v-vencto-ini     = p-vencto-ini
           v-vencto-fim     = p-vencto-fim
           v-situacao       = p-situacao
           i-tipo-verba     = p-tipo-verba.

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

    CASE pType:
         WHEN "Create" THEN DO:
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.nr-vpc = RowObject.nr-vpc) THEN DO:
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
                 WHERE bf{&TableName}.nr-vpc = RowObject.nr-vpc) THEN DO:
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
                 WHERE bf{&TableName}.nr-vpc = RowObject.nr-vpc) THEN DO:
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

    IF pType = "Create" OR pType = "Update" THEN DO:


        /*Validaá‰es de Campos*/
        IF NOT CAN-FIND(FIRST emitente NO-LOCK
                        WHERE emitente.cod-emitente = RowObject.cod-emitente
                          AND emitente.identific <> 1) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Fornecedor inv†lido.~~~~Fornecedor n∆o cadastrado.'"}
        END.

        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Estabelecimento inv†lido.~~~~Estabelecimento n∆o cadastrado.'"}
        END.
        IF NOT CAN-FIND(FIRST tipo-acordo NO-LOCK
                        WHERE tipo-acordo.codigo = RowObject.tipo-acordo) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Tipo Acordo inv†lido.~~~~Tipo Acordo n∆o cadastrado.'"}
        END.
        IF NOT CAN-FIND(FIRST tipo-verba NO-LOCK
                        WHERE tipo-verba.codigo = RowObject.tipo-verba) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Tipo Verba inv†lido.~~~~Tipo Verba n∆o cadastrado.'"}
        END.
        IF RowObject.data-evento = ? THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Data Evento inv†lida.~~~~Data Evento deve ser informada.'"}
        END.
        IF RowObject.data-vencto = ? THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Data Vencimento inv†lida.~~~~Data Vencimento deve ser informada.'"}
        END.
        IF RowObject.email-repres = "" THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Email Representante inv†lido.~~~~Email representante deve ser informado.'"}
        END.
        IF RowObject.valor <= 0 OR RowObject.valor = ? THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Valor VPC inv†lido.~~~~Valor VPC deve ser informado.'"}
        END.

        IF  NOT CAN-FIND(FIRST tt-vpc-rateio) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Rateio n∆o informado.~~~~Deve ser informado rateio para compìr o valor da VPC.'"}
        END.

        FOR EACH tt-vpc-rateio:
            IF  NOT can-find(FIRST unid-negoc
                               WHERE unid-negoc.cod-unid-negoc = tt-vpc-rateio.cod-unid-negoc) THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'Unidade Neg¢cio ' + tt-vpc-rateio.cod-unid-negoc + ' Inv†lida.~~~~Unidade Neg¢cio deve ser informada.'"}
            END.
            IF NOT can-find(FIRST centro-custo
                                WHERE centro-custo.cc-codigo = tt-vpc-rateio.cod_ccusto) THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'Centro de Custo ' + string(tt-vpc-rateio.cod_ccusto) + ' Inv†lido.~~~~Centro de Custo deve ser informado.'"}
            END.
        END.

        IF RowObject.observacoes = "" THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Observaá∆o inv†lida.~~~~Observaá∆o deve ser informada.'"}
        END.

        FOR EACH tt-vpc-rateio:
            FIND ctb-tipo-verba NO-LOCK
                WHERE ctb-tipo-verba.codigo = RowObject.tipo-verba
                  AND ctb-tipo-verba.cod-estabel = RowObject.cod-estabel
                  AND ctb-tipo-verba.cod-unid-negoc = tt-vpc-rateio.cod-unid-negoc
                  AND ctb-tipo-verba.cod_ccusto = tt-vpc-rateio.cod_ccusto
                NO-ERROR.
            IF NOT AVAIL ctb-tipo-verba THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'ParÉmetro Cont†bil Tipo de Verba Inv†lido!.~~~~ParÉmetro Cont†bil Tipo de Verba n∆o cadastrado NO Programa ESUTP022'"}
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintVpcSit DBOProgram 
PROCEDURE setVPCRateio :
    DEFINE INPUT PARAMETER TABLE FOR tt-vpc-rateio.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintVpcSit DBOProgram 
PROCEDURE GetVPCRateio :
    DEFINE OUTPUT PARAMETER TABLE FOR tt-vpc-rateio.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
