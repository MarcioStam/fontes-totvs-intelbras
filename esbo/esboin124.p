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
{include/i-prgvrs.i ESBOIN124 2.00.00.000}                               
/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */
 
/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName  ESBOIN124
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  ficha-cq
&GLOBAL-DEFINE TableLabel  Ficha para CQ                 
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
 
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */
 
/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{esbo/esboin124.i RowObject}
 
 
/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Defini‡Æo de vari veis *********************** */
define variable v-nr-ficha as integer no-undo.
define variable v-serie-docto as character no-undo.
define variable v-nro-docto as character no-undo.
define variable v-cod-emitente as integer no-undo.
define variable v-nat-operacao as character no-undo.
define variable v-dt-ficha as date no-undo.
define variable v-dt-inspecao as date no-undo.
define variable v-cod-estabel as character no-undo.
define variable v-cod-depos as character no-undo.
define variable v-it-codigo as character no-undo.
define variable v-cod-localiz as character no-undo.
define variable v-lote as character no-undo.
define variable v-nr-ord-produ as integer no-undo.
define variable v-op-seq as integer no-undo.
define variable v-situacao as integer no-undo.
 
define variable v-ini-it-codigo as character no-undo.
define variable v-fim-it-codigo as character no-undo.
define variable v-ini-nr-ficha as integer no-undo.
define variable v-fim-nr-ficha as integer no-undo.

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
         HEIGHT             = 2
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.                                                                       

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-resp":U THEN ASSIGN pFieldValue = RowObject.cod-resp.
        WHEN "ct-destino":U THEN ASSIGN pFieldValue = RowObject.ct-destino.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "reg-lido":U THEN ASSIGN pFieldValue = RowObject.reg-lido.
        WHEN "sc-destino":U THEN ASSIGN pFieldValue = RowObject.sc-destino.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
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
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-analise":U THEN ASSIGN pFieldValue = RowObject.dt-analise.
        WHEN "dt-ficha":U THEN ASSIGN pFieldValue = RowObject.dt-ficha.
        WHEN "dt-inspecao":U THEN ASSIGN pFieldValue = RowObject.dt-inspecao.
        WHEN "dt-ult-sit":U THEN ASSIGN pFieldValue = RowObject.dt-ult-sit.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "qt-a-liberar":U THEN ASSIGN pFieldValue = RowObject.qt-a-liberar.
        WHEN "qt-apr-cond":U THEN ASSIGN pFieldValue = RowObject.qt-apr-cond.
        WHEN "qt-aprovada":U THEN ASSIGN pFieldValue = RowObject.qt-aprovada.
        WHEN "qt-consumida":U THEN ASSIGN pFieldValue = RowObject.qt-consumida.
        WHEN "qt-original":U THEN ASSIGN pFieldValue = RowObject.qt-original.
        WHEN "qt-rejeitada":U THEN ASSIGN pFieldValue = RowObject.qt-rejeitada.
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
        WHEN "codigo-rejei":U THEN ASSIGN pFieldValue = RowObject.codigo-rejei.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ficha":U THEN ASSIGN pFieldValue = RowObject.nr-ficha.
        WHEN "nr-ord-cq":U THEN ASSIGN pFieldValue = RowObject.nr-ord-cq.
        WHEN "nr-ord-dest":U THEN ASSIGN pFieldValue = RowObject.nr-ord-dest.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-ordem":U THEN ASSIGN pFieldValue = RowObject.nr-ordem.
        WHEN "op-seq":U THEN ASSIGN pFieldValue = RowObject.op-seq.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "sit-rot":U THEN ASSIGN pFieldValue = RowObject.sit-rot.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
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
        WHEN "baixa-estoq":U THEN ASSIGN pFieldValue = RowObject.baixa-estoq.
        WHEN "inspecionado":U THEN ASSIGN pFieldValue = RowObject.inspecionado.
        WHEN "liberada":U THEN ASSIGN pFieldValue = RowObject.liberada.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-com-nota":U THEN ASSIGN pFieldValue = RowObject.log-com-nota.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
DEFINE INPUT PARAMETER p-nr-ficha AS integer NO-UNDO.                                                                           

    FIND bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.nr-ficha = p-nr-ficha                    
        NO-ERROR.
    IF NOT AVAILABLE bf{&TableName} THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
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
            RUN openQueryStatic ("Ch-ficha":U).                       
        WHEN 3 THEN           
            RUN openQueryStatic ("Documento":U).                      
        WHEN 4 THEN           
            RUN openQueryStatic ("Dt-ficha":U).                       
        WHEN 5 THEN           
            RUN openQueryStatic ("Dt-insp":U).                        
        WHEN 6 THEN           
            RUN openQueryStatic ("Estab-depos":U).                    
        WHEN 7 THEN           
            RUN openQueryStatic ("Fornec-item":U).                    
        WHEN 8 THEN           
            RUN openQueryStatic ("Item-ficha":U).                     
        WHEN 9 THEN           
            RUN openQueryStatic ("Item-fornec":U).                    
        WHEN 10 THEN          
            RUN openQueryStatic ("Ord-oper":U).                       
        WHEN 11 THEN          
            RUN openQueryStatic ("Situacao":U).                       
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-ficha DBOProgram 
PROCEDURE openQueryCh-ficha :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.nr-ficha = v-nr-ficha                      
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDocumento DBOProgram 
PROCEDURE openQueryDocumento :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.serie-docto = v-serie-docto                
        AND {&TableName}.nro-docto = v-nro-docto                      
        AND {&TableName}.cod-emitente = v-cod-emitente                
        AND {&TableName}.nat-operacao = v-nat-operacao                
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDt-ficha DBOProgram 
PROCEDURE openQueryDt-ficha :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.dt-ficha = v-dt-ficha                      
        AND {&TableName}.nr-ficha = v-nr-ficha                        
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDt-insp DBOProgram 
PROCEDURE openQueryDt-insp :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.dt-inspecao = v-dt-inspecao                
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEstab-depos DBOProgram 
PROCEDURE openQueryEstab-depos :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-estabel = v-cod-estabel                
        AND {&TableName}.cod-depos = v-cod-depos                      
        AND {&TableName}.it-codigo = v-it-codigo                      
        AND {&TableName}.cod-localiz = v-cod-localiz                  
        AND {&TableName}.lote = v-lote                                
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFornec-item DBOProgram 
PROCEDURE openQueryFornec-item :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-emitente = v-cod-emitente              
        AND {&TableName}.it-codigo = v-it-codigo                      
        AND {&TableName}.dt-inspecao = v-dt-inspecao                  
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItem-ficha DBOProgram 
PROCEDURE openQueryItem-ficha :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.it-codigo = v-it-codigo                    
        AND {&TableName}.nr-ficha >= v-ini-nr-ficha
        AND {&TableName}.nr-ficha <= v-fim-nr-ficha 
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItem-fornec DBOProgram 
PROCEDURE openQueryItem-fornec :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.it-codigo = v-it-codigo                    
        AND {&TableName}.cod-emitente = v-cod-emitente                
        AND {&TableName}.dt-inspecao = v-dt-inspecao                  
    .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrd-oper DBOProgram 
PROCEDURE openQueryOrd-oper :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.nr-ord-produ = v-nr-ord-produ              
        AND {&TableName}.op-seq = v-op-seq                            
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySituacao DBOProgram 
PROCEDURE openQuerySituacao :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.situacao = v-situacao                      
        AND {&TableName}.nr-ficha = v-nr-ficha                        
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-ficha DBOProgram 
PROCEDURE setConstraintCh-ficha :
DEFINE INPUT PARAMETER p-nr-ficha AS integer NO-UNDO.                                                                           

    ASSIGN 
    v-nr-ficha = p-nr-ficha                                           
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDocumento DBOProgram 
PROCEDURE setConstraintDocumento :
DEFINE INPUT PARAMETER p-serie-docto AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-nro-docto AS character NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-cod-emitente AS integer NO-UNDO.                                                                       
    DEFINE INPUT PARAMETER p-nat-operacao AS character NO-UNDO.                                                                     

    ASSIGN 
    v-serie-docto = p-serie-docto                                     
    v-nro-docto = p-nro-docto                                         
    v-cod-emitente = p-cod-emitente                                   
    v-nat-operacao = p-nat-operacao                                   
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDt-ficha DBOProgram 
PROCEDURE setConstraintDt-ficha :
DEFINE INPUT PARAMETER p-dt-ficha AS date NO-UNDO.                                                                              
    DEFINE INPUT PARAMETER p-nr-ficha AS integer NO-UNDO.                                                                           

    ASSIGN 
    v-dt-ficha = p-dt-ficha                                           
    v-nr-ficha = p-nr-ficha                                           
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDt-insp DBOProgram 
PROCEDURE setConstraintDt-insp :
DEFINE INPUT PARAMETER p-dt-inspecao AS date NO-UNDO.                                                                           

    ASSIGN 
    v-dt-inspecao = p-dt-inspecao                                     
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEstab-depos DBOProgram 
PROCEDURE setConstraintEstab-depos :
DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-cod-depos AS character NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-it-codigo AS character NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-cod-localiz AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-lote AS character NO-UNDO.                                                                             

    ASSIGN 
    v-cod-estabel = p-cod-estabel                                     
    v-cod-depos = p-cod-depos                                         
    v-it-codigo = p-it-codigo                                         
    v-cod-localiz = p-cod-localiz                                     
    v-lote = p-lote                                                   
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFornec-item DBOProgram 
PROCEDURE setConstraintFornec-item :
DEFINE INPUT PARAMETER p-cod-emitente AS integer NO-UNDO.                                                                       
    DEFINE INPUT PARAMETER p-it-codigo AS character NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-dt-inspecao AS date NO-UNDO.                                                                           

    ASSIGN 
    v-cod-emitente = p-cod-emitente                                   
    v-it-codigo = p-it-codigo                                         
    v-dt-inspecao = p-dt-inspecao                                     
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItem-ficha DBOProgram 
PROCEDURE setConstraintItem-ficha :
DEF INPUT PARAM p-it-codigo AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-ini-nr-ficha AS integer NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-fim-nr-ficha AS integer NO-UNDO.                                                                           
    
    ASSIGN v-it-codigo     = p-it-codigo
           v-ini-nr-ficha  = p-ini-nr-ficha
           v-fim-nr-ficha  = p-fim-nr-ficha.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItem-fornec DBOProgram 
PROCEDURE setConstraintItem-fornec :
DEFINE INPUT PARAMETER p-it-codigo AS character NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-cod-emitente AS integer NO-UNDO.                                                                       
    DEFINE INPUT PARAMETER p-dt-inspecao AS date NO-UNDO.                                                                           

    ASSIGN 
    v-it-codigo = p-it-codigo                                         
    v-cod-emitente = p-cod-emitente                                   
    v-dt-inspecao = p-dt-inspecao                                     
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrd-oper DBOProgram 
PROCEDURE setConstraintOrd-oper :
DEFINE INPUT PARAMETER p-nr-ord-produ AS integer NO-UNDO.                                                                       
    DEFINE INPUT PARAMETER p-op-seq AS integer NO-UNDO.                                                                             

    ASSIGN 
    v-nr-ord-produ = p-nr-ord-produ                                   
    v-op-seq = p-op-seq                                               
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSituacao DBOProgram 
PROCEDURE setConstraintSituacao :
DEFINE INPUT PARAMETER p-situacao AS integer NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-nr-ficha AS integer NO-UNDO.                                                                           

    ASSIGN 
    v-situacao = p-situacao                                           
    v-nr-ficha = p-nr-ficha                                           
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    CASE pType:
         WHEN "Create" THEN DO:
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.nr-ficha = RowObject.nr-ficha) THEN DO:
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
                 WHERE bf{&TableName}.nr-ficha = RowObject.nr-ficha) THEN DO:
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
                 WHERE bf{&TableName}.nr-ficha = RowObject.nr-ficha) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

         END.
    END CASE.

    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

