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
{include/i-prgvrs.i BOES475 2.00.00.000}                               
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
&GLOBAL-DEFINE DBOName  BOES475
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  juridico-despesas
&GLOBAL-DEFINE TableLabel  Despesas Juridicas            
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
{esbo/boes475.i RowObject}
 
 
/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Defini‡Æo de vari veis *********************** */
define variable v-cod-acao as integer no-undo.
define variable v-cod-despesa as integer no-undo.
define variable v-dt-prevista as date no-undo.
define variable v-processo as character no-undo.
 
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
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    CASE pType:
         WHEN "Create" THEN DO:
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.processo = RowObject.processo
                 AND bf{&TableName}.dt-prevista = RowObject.dt-prevista
                 AND bf{&TableName}.cod-acao = RowObject.cod-acao
                 AND bf{&TableName}.cod-despesa = RowObject.cod-despesa) THEN DO:
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
                 WHERE bf{&TableName}.processo = RowObject.processo
                 AND bf{&TableName}.dt-prevista = RowObject.dt-prevista
                 AND bf{&TableName}.cod-acao = RowObject.cod-acao
                 AND bf{&TableName}.cod-despesa = RowObject.cod-despesa) THEN DO:
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
                 WHERE bf{&TableName}.processo = RowObject.processo
                 AND bf{&TableName}.dt-prevista = RowObject.dt-prevista
                 AND bf{&TableName}.cod-acao = RowObject.cod-acao
                 AND bf{&TableName}.cod-despesa = RowObject.cod-despesa) THEN DO:
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
    IF pType = "Create" OR pType = "Update" THEN DO:
        IF RowObject.processo = "" THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Processo inv lido.~~~~Processo deve ser informado.'"}
        END.

        IF RowObject.dt-prevista = ? THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Data Prevista inv lida.~~~~Data Prevista deve ser informada.'"}
        END.

        IF NOT CAN-FIND(FIRST juridico-acoes NO-LOCK
                        WHERE juridico-acoes.codigo = RowObject.cod-acao) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'C¢digo A‡Æo inv lido.~~~~C¢digo A‡Æo nÆo cadastrado.'"}
        END.

        IF NOT CAN-FIND(FIRST juridico-tp-despesa NO-LOCK
                        WHERE juridico-tp-despesa.codigo = RowObject.cod-despesa) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'C¢digo Despesa inv lido.~~~~C¢digo Despesa nÆo cadastrado.'"}
        END.

        IF RowObject.valor = ? OR RowObject.valor <= 0  THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Valor Despesa inv lido.~~~~Valor Despesa deve ser informado.'"}
        END.
    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
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
        WHEN "observacoes":U THEN ASSIGN pFieldValue = RowObject.observacoes.
        WHEN "processo":U THEN ASSIGN pFieldValue = RowObject.processo.
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
        WHEN "cod-acao":U THEN ASSIGN pFieldValue = RowObject.cod-acao.
        WHEN "cod-despesa":U THEN ASSIGN pFieldValue = RowObject.cod-despesa.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram                                                                  
PROCEDURE getDateField :                                                                                                            
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.                                                                            

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt-prevista":U THEN ASSIGN pFieldValue = RowObject.dt-prevista.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-acao DBOProgram                                                          
PROCEDURE setConstraintCh-acao :                                                                                                    
    DEFINE INPUT PARAMETER p-cod-acao AS integer NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-cod-despesa AS integer NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-dt-prevista AS date NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-processo AS character NO-UNDO.                                                                         

    ASSIGN 
    v-cod-acao = p-cod-acao                                           
    v-cod-despesa = p-cod-despesa                                     
    v-dt-prevista = p-dt-prevista                                     
    v-processo = p-processo                                           
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-acao DBOProgram                                                              
PROCEDURE openQueryCh-acao :                                                                                                        

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-acao = v-cod-acao                      
        AND {&TableName}.cod-despesa = v-cod-despesa                  
        AND {&TableName}.dt-prevista = v-dt-prevista                  
        AND {&TableName}.processo = v-processo                        
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-depesa DBOProgram                                                        
PROCEDURE setConstraintCh-depesa :                                                                                                  
    DEFINE INPUT PARAMETER p-cod-despesa AS integer NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-cod-acao AS integer NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-processo AS character NO-UNDO.                                                                         
    DEFINE INPUT PARAMETER p-dt-prevista AS date NO-UNDO.                                                                           

    ASSIGN 
    v-cod-despesa = p-cod-despesa                                     
    v-cod-acao = p-cod-acao                                           
    v-processo = p-processo                                           
    v-dt-prevista = p-dt-prevista                                     
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-depesa DBOProgram                                                            
PROCEDURE openQueryCh-depesa :                                                                                                      

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-despesa = v-cod-despesa                
        AND {&TableName}.cod-acao = v-cod-acao                        
        AND {&TableName}.processo = v-processo                        
        AND {&TableName}.dt-prevista = v-dt-prevista                  
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-prevista DBOProgram                                                      
PROCEDURE setConstraintCh-prevista :                                                                                                
    DEFINE INPUT PARAMETER p-dt-prevista AS date NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-processo AS character NO-UNDO.                                                                         
    DEFINE INPUT PARAMETER p-cod-acao AS integer NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-cod-despesa AS integer NO-UNDO.                                                                        

    ASSIGN 
    v-dt-prevista = p-dt-prevista                                     
    v-processo = p-processo                                           
    v-cod-acao = p-cod-acao                                           
    v-cod-despesa = p-cod-despesa                                     
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-prevista DBOProgram                                                          
PROCEDURE openQueryCh-prevista :                                                                                                    

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.dt-prevista = v-dt-prevista                
        AND {&TableName}.processo = v-processo                        
        AND {&TableName}.cod-acao = v-cod-acao                        
        AND {&TableName}.cod-despesa = v-cod-despesa                  
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-principal DBOProgram                                                     
PROCEDURE setConstraintCh-principal :                                                                                               
    DEFINE INPUT PARAMETER p-processo AS character NO-UNDO.                                                                         
    DEFINE INPUT PARAMETER p-dt-prevista AS date NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-cod-acao AS integer NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-cod-despesa AS integer NO-UNDO.                                                                        

    ASSIGN 
    v-processo = p-processo                                           
    v-dt-prevista = p-dt-prevista                                     
    v-cod-acao = p-cod-acao                                           
    v-cod-despesa = p-cod-despesa                                     
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-principal DBOProgram                                                         
PROCEDURE openQueryCh-principal :                                                                                                   

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.processo = v-processo                      
        AND {&TableName}.dt-prevista = v-dt-prevista                  
        AND {&TableName}.cod-acao = v-cod-acao                        
        AND {&TableName}.cod-despesa = v-cod-despesa                  
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
            RUN openQueryStatic ("Ch-acao":U).                        
        WHEN 3 THEN           
            RUN openQueryStatic ("Ch-depesa":U).                      
        WHEN 4 THEN           
            RUN openQueryStatic ("Ch-prevista":U).                    
        WHEN 5 THEN           
            RUN openQueryStatic ("Ch-principal":U).                   
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram
PROCEDURE goToKey :
    DEFINE INPUT PARAMETER p-processo AS character NO-UNDO.                                                                         
    DEFINE INPUT PARAMETER p-dt-prevista AS date NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-cod-acao AS integer NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-cod-despesa AS integer NO-UNDO.                                                                        

    FIND bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.processo = p-processo                    
        AND bf{&TableName}.dt-prevista = p-dt-prevista                
        AND bf{&TableName}.cod-acao = p-cod-acao                      
        AND bf{&TableName}.cod-despesa = p-cod-despesa                
        NO-ERROR.
    IF NOT AVAILABLE bf{&TableName} THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintAndamentos DBOProgram
PROCEDURE setConstraintAndamentos :
    DEFINE INPUT PARAMETER p-processo AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-prevista AS date NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-acao AS integer NO-UNDO.

    ASSIGN v-processo    = p-processo
           v-dt-prevista = p-dt-prevista
           v-cod-acao    = p-cod-acao.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToAndamentos DBOProgram 
PROCEDURE linkToAndamentos :
DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
   RUN getKey IN pHandle (OUTPUT v-processo,
                          OUTPUT v-dt-prevista,
                          OUTPUT v-cod-acao).
   
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDespesas DBOProgram 
PROCEDURE openQueryDespesas :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
     WHERE {&TableName}.processo    = v-processo
       AND {&TableName}.dt-prevista = v-dt-prevista
       AND {&TableName}.cod-acao    = v-cod-acao.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
