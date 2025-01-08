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
{include/i-prgvrs.i BOES473 2.00.00.000}                               
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
&GLOBAL-DEFINE DBOName  BOES473
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  juridico-andamentos
&GLOBAL-DEFINE TableLabel  Andamento Juridico            
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
{esbo/boes473.i RowObject}
 
 
/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Defini‡Æo de vari veis *********************** */
define variable v-cod-acao as integer no-undo.
define variable v-dt-prevista as date no-undo.
define variable v-processo as character no-undo.
define variable v-dt-efetiva as date no-undo.
 
DEFINE VARIABLE v-dt-prevista-ini AS DATE    NO-UNDO.
DEFINE VARIABLE v-dt-prevista-fim AS DATE    NO-UNDO.
DEFINE VARIABLE v-acao           AS INTEGER     NO-UNDO.

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
                 AND bf{&TableName}.cod-acao = RowObject.cod-acao) THEN DO:
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
                 AND bf{&TableName}.cod-acao = RowObject.cod-acao) THEN DO:
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
                 AND bf{&TableName}.cod-acao = RowObject.cod-acao) THEN DO:
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

        IF NOT CAN-FIND(FIRST juridico-processos NO-LOCK
                        WHERE juridico-processos.processo = RowObject.processo) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Processo inv lido.~~~~Processo nÆo cadastrado.'"}
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
                &ErrorParameters="'A‡Æo inv lida.~~~~C¢digo A‡Æo nÆo cadastrada.'"}
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
        WHEN "comentarios":U THEN ASSIGN pFieldValue = RowObject.comentarios.
        WHEN "processo":U THEN ASSIGN pFieldValue = RowObject.processo.
        WHEN "hora":U THEN ASSIGN pFieldValue = RowObject.hora.
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
        WHEN "dt-efetiva":U THEN ASSIGN pFieldValue = RowObject.dt-efetiva.
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
    DEFINE INPUT PARAMETER p-dt-prevista AS date NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-processo AS character NO-UNDO.                                                                         

    ASSIGN 
    v-cod-acao = p-cod-acao                                           
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
        AND {&TableName}.dt-prevista = v-dt-prevista                  
        AND {&TableName}.processo = v-processo                        
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-efetiva DBOProgram                                                       
PROCEDURE setConstraintCh-efetiva :                                                                                                 
    DEFINE INPUT PARAMETER p-dt-efetiva AS date NO-UNDO.                                                                            
    DEFINE INPUT PARAMETER p-cod-acao AS integer NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-processo AS character NO-UNDO.                                                                         

    ASSIGN 
    v-dt-efetiva = p-dt-efetiva                                       
    v-cod-acao = p-cod-acao                                           
    v-processo = p-processo                                           
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-efetiva DBOProgram                                                           
PROCEDURE openQueryCh-efetiva :                                                                                                     

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.dt-efetiva = v-dt-efetiva                  
        AND {&TableName}.cod-acao = v-cod-acao                        
        AND {&TableName}.processo = v-processo                        
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-principal DBOProgram                                                     
PROCEDURE setConstraintCh-principal:                                                                                               
    DEFINE INPUT PARAMETER p-processo AS character NO-UNDO.                                                                         
    DEFINE INPUT PARAMETER p-dt-prevista AS date NO-UNDO.                                                                           
    DEFINE INPUT PARAMETER p-cod-acao AS integer NO-UNDO.                                                                           

    ASSIGN v-processo = p-processo                                           
           v-dt-prevista = p-dt-prevista                                     
           v-cod-acao = p-cod-acao.

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
            RUN openQueryStatic ("Ch-efetiva":U).                     
        WHEN 4 THEN           
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

    FIND bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.processo = p-processo                    
        AND bf{&TableName}.dt-prevista = p-dt-prevista                
        AND bf{&TableName}.cod-acao = p-cod-acao                      
        NO-ERROR.
    IF NOT AVAILABLE bf{&TableName} THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToProcessos DBOProgram 
PROCEDURE linkToProcessos :
DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
   RUN getKey IN pHandle (OUTPUT v-processo).
   
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAndamentos DBOProgram 
PROCEDURE openQueryAndamentos :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.processo = v-processo.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-processo    LIKE juridico-andamentos.processo    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-dt-prevista LIKE juridico-andamentos.dt-prevista NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cod-acao    LIKE juridico-andamentos.cod-acao    NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN p-processo    = RowObject.processo
           p-dt-prevista = RowObject.dt-prevista
           p-cod-acao    = RowObject.cod-acao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH juridico-despesas EXCLUSIVE-LOCK
       WHERE juridico-despesas.processo    = RowObject.processo
         AND juridico-despesas.dt-prevista = RowObject.dt-prevista
         AND juridico-despesas.cod-acao    = RowObject.cod-acao:
        DELETE juridico-despesas.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintAgenda DBOProgram
PROCEDURE setConstraintAgenda:
    DEFINE INPUT PARAMETER p-dt-prevista-ini AS DATE NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-prevista-fim AS DATE NO-UNDO.
    DEFINE INPUT PARAMETER p-acao            AS INTEGER NO-UNDO.

    ASSIGN v-dt-prevista-ini = p-dt-prevista-ini
           v-dt-prevista-fim = p-dt-prevista-fim
           v-acao            = p-acao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAgenda DBOProgram
PROCEDURE openQueryAgenda:

    IF v-acao = 0 THEN DO:
        OPEN QUERY {&QueryName} 
            FOR EACH {&TableName} NO-LOCK USE-INDEX ch-principal
               WHERE {&TableName}.dt-prevista >= v-dt-prevista-ini
                 AND {&TableName}.dt-prevista <= v-dt-prevista-fim
                  BY {&TableName}.dt-prevista
                  BY {&TableName}.processo.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} 
            FOR EACH {&TableName} NO-LOCK USE-INDEX ch-principal
               WHERE {&TableName}.dt-prevista >= v-dt-prevista-ini
                 AND {&TableName}.dt-prevista <= v-dt-prevista-fim
                 AND {&TableName}.cod-acao     = v-acao
                  BY {&TableName}.dt-prevista
                  BY {&TableName}.processo.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDespesasAndamento DBOProgram
PROCEDURE retornaDespesasAndamento:
    DEFINE  INPUT PARAMETER p-rowid    AS ROWID   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-despesas AS DECIMAL NO-UNDO.

    ASSIGN p-despesas = 0.
    FOR FIRST bf{&TableName} NO-LOCK
        WHERE ROWID(bf{&TableName}) = p-rowid,
         EACH juridico-despesas EXCLUSIVE-LOCK
        WHERE juridico-despesas.processo    = bf{&TableName}.processo
          AND juridico-despesas.dt-prevista = bf{&TableName}.dt-prevista
          AND juridico-despesas.cod-acao    = bf{&TableName}.cod-acao:
        ASSIGN p-despesas = p-despesas + juridico-despesas.valor.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

