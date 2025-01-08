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
{include/i-prgvrs.i BOES918  2.00.00.000}                               
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
&GLOBAL-DEFINE DBOName  boes918
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  int-cond-pag-cli
&GLOBAL-DEFINE TableLabel  int-cond-pag-cli                 
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
/*{esbo/boes918.i RowObject}*/

DEFINE TEMP-TABLE RowObject NO-UNDO LIKE int-cond-pag-cli
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
define variable v-raiz-cnpj as character no-undo.
define variable v-cod-unid-negoc as character no-undo.
define variable v-cod-estabel as character no-undo.
define variable v-fm-cod-com   as character no-undo.
define variable v-data-vigencia as date no-undo.
 
DEFINE VARIABLE i-cod-emitente-ini  AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-emitente-fim  AS INTEGER     NO-UNDO.


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
         HEIGHT             = 9.25
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH int-cond-pag-cli-det EXCLUSIVE-LOCK
       WHERE int-cond-pag-cli-det.cod-emitente = RowObject.cod-emitente:
        DELETE int-cond-pag-cli-det.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/* DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.                         */
/*     DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.                   */
/*                                                                                 */
/*     IF NOT AVAILABLE RowObject THEN                                             */
/*         RETURN "NOK":U.                                                         */
/*                                                                                 */
/*     CASE pFieldName:                                                            */
/*         WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.  */
/*         WHEN "grupo-econ":U   THEN ASSIGN pFieldValue = RowObject.grupo-econ.   */
/*         WHEN "prazo-dde":U    THEN ASSIGN pFieldValue = RowObject.prazo-dde.    */
/*         WHEN "vencto-fixo":U  THEN ASSIGN pFieldValue = RowObject.vencto-fixo.  */
/*         WHEN "semana":U       THEN ASSIGN pFieldValue = RowObject.semana.       */
/*         WHEN "mes":U          THEN ASSIGN pFieldValue = RowObject.semana.       */
/*         OTHERWISE RETURN "NOK":U.                                               */
/*     END CASE.                                                                   */
/*     RETURN "OK":U.                                                              */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/* DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.                                      */
/*     DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.                                     */
/*                                                                                              */
/*     IF NOT AVAILABLE RowObject THEN                                                          */
/*         RETURN "NOK":U.                                                                      */
/*                                                                                              */
/*     CASE pFieldName:                                                                         */
/*         WHEN "data-vigencia":U THEN ASSIGN pFieldValue = RowObject.data-vigencia.            */
/*         WHEN "dt-vencto-contrato":U THEN ASSIGN pFieldValue = RowObject.dt-vencto-contrato.  */
/*         OTHERWISE RETURN "NOK":U.                                                            */
/*     END CASE.                                                                                */
/*     RETURN "OK":U.                                                                           */
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
        WHEN "vencto-fixo":U  THEN ASSIGN pFieldValue = RowObject.vencto-fixo.
        OTHERWISE RETURN "NOK":U.
    END CASE.
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
    DEFINE OUTPUT PARAMETER p-cod-emitente LIKE {&TableName}.cod-emitente NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN p-cod-emitente = RowObject.cod-emitente.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePonto DBOProgram 
PROCEDURE openQueryRangeEmitente:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY qr{&TableName} FOR EACH {&TableName}
                                  WHERE {&TableName}.cod-emitente >= i-cod-emitente-ini
                                  AND   {&TableName}.cod-emitente <= i-cod-emitente-fim NO-LOCK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePonto DBOProgram 
PROCEDURE setConstraintRangeEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-emitente-ini AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-emitente-fim AS INTEGER NO-UNDO.

    ASSIGN i-cod-emitente-ini = p-emitente-ini
           i-cod-emitente-fim = p-emitente-fim.

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
        WHEN "grupo-econ":U   THEN ASSIGN pFieldValue = RowObject.grupo-econ.
        WHEN "prazo-dde":U    THEN ASSIGN pFieldValue = RowObject.prazo-dde.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
DEFINE INPUT PARAMETER p-cod-emitente AS integer NO-UNDO.                                                                          

    FIND bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-emitente = p-cod-emitente                  
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
            RUN openQueryStatic ("ch-cliente":U).                      
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerych-cliente DBOProgram 
PROCEDURE openQuerych-cliente :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-emitente = v-cod-emitente                    
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom1 DBOProgram 
PROCEDURE openQueryZoom1 :
OPEN QUERY {&QueryName} 
        FOR EACH {&TableName} NO-LOCK
           WHERE {&TableName}.cod-emitente >= i-cod-emitente-ini
             AND {&TableName}.cod-emitente <= i-cod-emitente-fim.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintch-cliente DBOProgram 
PROCEDURE setConstraintch-cliente :
DEFINE INPUT PARAMETER p-cod-emitente AS integer NO-UNDO.                                                                          

    ASSIGN 
    v-cod-emitente = p-cod-emitente                                         
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintch-chave DBOProgram 
PROCEDURE setConstraintch-chave :
    DEFINE INPUT PARAMETER p-cod-emitente AS INTEGER NO-UNDO.                                                                        

    ASSIGN v-cod-emitente  = p-cod-emitente.

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

/* &ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom1 DBOProgram */
/* PROCEDURE setConstraintZoom1 :                                            */
/* DEFINE INPUT PARAMETER p-acordo-ini AS INTEGER NO-UNDO.                   */
/*     DEFINE INPUT PARAMETER p-acordo-fim AS INTEGER NO-UNDO.               */
/*     DEFINE INPUT PARAMETER p-cliente-ini AS CHARACTER NO-UNDO.            */
/*     DEFINE INPUT PARAMETER p-cliente-fim AS CHARACTER NO-UNDO.            */
/*                                                                           */
/*     ASSIGN i-cod-emitente-ini = p-acordo-ini                              */
/*            i-cod-emitente-fim = p-acordo-fim                              */
/*            c-cliente-ini = p-cliente-ini                                  */
/*            c-cliente-fim = p-cliente-fim.                                 */
/*                                                                           */
/*     RETURN "OK":U.                                                        */
/* END PROCEDURE.                                                            */
/*                                                                           */
/* /* _UIB-CODE-BLOCK-END */                                                 */
/* &ANALYZE-RESUME                                                           */

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
                 WHERE bf{&TableName}.cod-emitente = RowObject.cod-emitente) THEN DO:
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
                 WHERE bf{&TableName}.cod-emitente = RowObject.cod-emitente) THEN DO:
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
                 WHERE bf{&TableName}.cod-emitente = RowObject.cod-emitente) THEN DO:
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
        /*Valida‡äes de Campos*/

        IF  RowObject.grupo-econ AND NOT CAN-FIND(FIRST emitente 
                                                     WHERE emitente.cod-emitente = RowObject.cod-emitente
                                                       AND emitente.nome-abrev   = emitente.nome-matriz) THEN DO:
            DEF BUFFER b-emitente FOR emitente.
            DEF VAR c-matriz AS CHAR FORMAT "x(100)".
            FIND emitente NO-LOCK
                WHERE emitente.cod-emitente = RowObject.cod-emitente NO-ERROR.
            IF  AVAIL emitente THEN DO:
                FIND b-emitente NO-LOCK
                     WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-ERROR.
                IF  AVAIL b-emitente THEN
                    ASSIGN c-matriz = string(emitente.cod-emitente) + " ‚ a " + STRING(b-emitente.cod-emitente) + " - " + emitente.nome-matriz.
    
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'Cliente nÆo ‚ matriz~~~~A Matriz do cliente ' + c-matriz"}
            END.
        END.
    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

