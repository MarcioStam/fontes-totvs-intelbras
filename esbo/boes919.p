
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
{include/i-prgvrs.i boes919 2.00.00.000}                               
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
&GLOBAL-DEFINE DBOName  boes919
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  int-cond-pag-cli-det
&GLOBAL-DEFINE TableLabel  int-cond-pag-cli-det                     
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

 DEFINE TEMP-TABLE RowObject NO-UNDO LIKE int-cond-pag-cli-det
    FIELD r-Rowid AS ROWID.
 
/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Defini‡Æo de vari veis *********************** */
define variable v-cod-emitente as integer no-undo.
define variable v-cod-cond-pagto as integer no-undo.
 
{esinc\es0000.i}

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

    IF  NOT CAN-FIND(FIRST cond-pagto
                     WHERE cond-pagto.cod-cond-pag = RowObject.cod-cond-pagto) 
    AND RowObject.cod-cond-pagto <> 0 THEN DO:
        {method/svc/errors/inserr.i                                                      
            &ErrorNumber="17006"                                                             
            &ErrorType="EMS"                                                                 
            &ErrorSubType="ERROR"                                                            
            &ErrorParameters="'Condi‡Æo inexistente.~~~~NÆo encontrada condi‡Æo de pagamento no cadastro.'"}       
    END.


    CASE pType:
         WHEN "Create" THEN DO:
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-emitente   = RowObject.cod-emitente
                   AND bf{&TableName}.cod-cond-pagto = RowObject.cod-cond-pagto
                   AND bf{&TableName}.dt-ini-valid   = RowObject.dt-ini-valid) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

             IF CAN-FIND (FIRST bf{&TableName}
                          WHERE bf{&TableName}.cod-emitente    = RowObject.cod-emitente
                            AND bf{&TableName}.cod-cond-pagto  = RowObject.cod-cond-pagto
                            AND ((bf{&TableName}.dt-ini-valid <= RowObject.dt-ini-valid AND bf{&TableName}.dt-fim-valid >= RowObject.dt-ini-valid)
                              OR (bf{&TableName}.dt-ini-valid <= RowObject.dt-fim-valid AND bf{&TableName}.dt-fim-valid >= RowObject.dt-fim-valid)
                              OR (bf{&TableName}.dt-ini-valid >= RowObject.dt-ini-valid AND bf{&TableName}.dt-fim-valid <= RowObject.dt-fim-valid))) THEN DO:
                
                 {method/svc/errors/inserr.i
                     &ErrorNumber="17006"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'Conflito na faixa de datas.'"
                 }
             END.

         END.
         WHEN "Update" THEN DO:
             IF CAN-FIND (FIRST bf{&TableName}
                          WHERE bf{&TableName}.cod-emitente    = RowObject.cod-emitente
                            AND bf{&TableName}.cod-cond-pagto  = RowObject.cod-cond-pagto
                            AND ROWID(bf{&TableName})         <> RowObject.r-rowid
                            AND ((bf{&TableName}.dt-ini-valid <= RowObject.dt-ini-valid AND bf{&TableName}.dt-fim-valid >= RowObject.dt-ini-valid)
                              OR (bf{&TableName}.dt-ini-valid <= RowObject.dt-fim-valid AND bf{&TableName}.dt-fim-valid >= RowObject.dt-fim-valid)
                              OR (bf{&TableName}.dt-ini-valid >= RowObject.dt-ini-valid AND bf{&TableName}.dt-fim-valid <= RowObject.dt-fim-valid))) THEN DO:
                
                 {method/svc/errors/inserr.i
                     &ErrorNumber="17006"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'Conflito na faixa de datas.'"
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
    IF pType = "Create" 
    OR pType = "Update" THEN DO:

        
    END.

    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    ELSE DO:
        IF  pType = "Create" 
        OR  pType = "Update" THEN
            ASSIGN substr(RowObject.observacao,1988,12) = v_cod_usuar_corren.
    END.
    
    RETURN "OK":U.
END PROCEDURE.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram                                                                  
PROCEDURE getCharField :                                                                                                            
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.                                                                       
/*                                                                                */
/*     IF NOT AVAILABLE RowObject THEN                                            */
/*         RETURN "NOK":U.                                                        */
/*                                                                                */
/*     CASE pFieldName:                                                           */
/*         WHEN "observacoes":U THEN ASSIGN pFieldValue = RowObject.observacoes.  */
/*         OTHERWISE RETURN "NOK":U.                                              */
/*     END CASE.                                                                  */
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
        WHEN "cod-cond-pagto":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pagto.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram                                                                   
PROCEDURE getDecField :                                                                                                             
/*     DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.                 */
/*     DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.                 */
/*                                                                             */
/*     IF NOT AVAILABLE RowObject THEN                                         */
/*         RETURN "NOK":U.                                                     */
/*                                                                             */
/*     CASE pFieldName:                                                        */
/*         WHEN "percentual":U THEN ASSIGN pFieldValue = RowObject.percentual. */
/*         WHEN "valor-fixo":U THEN ASSIGN pFieldValue = RowObject.valor-fixo. */
/*         OTHERWISE RETURN "NOK":U.                                           */
/*     END CASE.                                                               */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-Cod-cond-pagto DBOProgram                                                        
PROCEDURE setConstraintCh-Cod-cond-pagto :                                                                                                  
    DEFINE INPUT PARAMETER p-cod-emitente   AS integer NO-UNDO.                                                                          
    DEFINE INPUT PARAMETER p-cod-cond-pagto AS integer NO-UNDO.                                                                        

    ASSIGN 
    v-cod-emitente   = p-cod-emitente                                         
    v-cod-cond-pagto = p-cod-cond-pagto                                     
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-Cod-cond-pagto DBOProgram                                                            
PROCEDURE openQueryCh-Cod-cond-pagto :                                                                                                      

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-emitente = v-cod-emitente                    
        AND {&TableName}.cod-cond-pagto = v-cod-cond-pagto                  
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
            RUN openQueryStatic ("Ch-Cod-cond-pagto":U).                      
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram
PROCEDURE goToKey :
    DEFINE INPUT PARAMETER p-cod-emitente  AS integer NO-UNDO.                                                                          
    DEFINE INPUT PARAMETER p-cod-cond-pagto AS integer NO-UNDO.                                                                        

    FIND bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-emitente = p-cod-emitente                  
        AND bf{&TableName}.cod-cond-pagto = p-cod-cond-pagto                
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryTipo DBOProgram
PROCEDURE openQueryEmitente :

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-emitente = v-cod-emitente.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

