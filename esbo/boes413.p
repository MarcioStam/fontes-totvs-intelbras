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
{include/i-prgvrs.i BOES413 2.00.00.000}                               
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
&GLOBAL-DEFINE DBOName  BOES413
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  fatura-equipamentos
&GLOBAL-DEFINE TableLabel  Fatura Equipamentos           
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
{esbo/boes413.i RowObject}
 
 
/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Defini‡Æo de vari veis *********************** */
define variable v-cod-estabel as character no-undo.
define variable v-equipamento as character no-undo.
define variable v-fornecedor as integer no-undo.
define variable v-mes-ref as character no-undo.
define variable v-nr-fatura as character no-undo.
 

define variable v-cod-estabel-ini as character no-undo.
define variable v-cod-estabel-fim as character no-undo.
define variable v-equipamento-ini  as character no-undo.
define variable v-equipamento-fim  as character no-undo.
define variable v-fornecedor-ini  as integer no-undo.
define variable v-fornecedor-fim  as integer no-undo.
define variable v-mes-ref-ini  as character no-undo.
define variable v-mes-ref-fim  as character no-undo.
define variable v-nr-fatura-ini  as character no-undo.
define variable v-nr-fatura-fim  as character no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPeriodoContab DBOProgram 
FUNCTION fnPeriodoContab RETURNS LOGICAL
  ( INPUT c-mes-ref AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 14.46
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "equipamento":U THEN ASSIGN pFieldValue = RowObject.equipamento.
        WHEN "mes-ref":U THEN ASSIGN pFieldValue = RowObject.mes-ref.
        WHEN "nr-fatura":U THEN ASSIGN pFieldValue = RowObject.nr-fatura.
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
        WHEN "val-fatura":U THEN ASSIGN pFieldValue = RowObject.val-fatura.
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
        WHEN "fornecedor":U THEN ASSIGN pFieldValue = RowObject.fornecedor.
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
        WHEN "manual":U THEN ASSIGN pFieldValue = RowObject.manual.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-equipamento AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-fornecedor AS integer NO-UNDO.                                                                         
    DEFINE INPUT PARAMETER p-mes-ref AS character NO-UNDO.                                                                          
    DEFINE INPUT PARAMETER p-nr-fatura AS character NO-UNDO.                                                                        

    FIND bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estabel = p-cod-estabel              
        AND bf{&TableName}.equipamento = p-equipamento                
        AND bf{&TableName}.fornecedor = p-fornecedor                  
        AND bf{&TableName}.mes-ref = p-mes-ref                        
        AND bf{&TableName}.nr-fatura = p-nr-fatura                    
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
            RUN openQueryStatic ("Ch-fatura":U).                      
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-fatura DBOProgram 
PROCEDURE openQueryCh-fatura :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-estabel = v-cod-estabel                
        AND {&TableName}.equipamento = v-equipamento                  
        AND {&TableName}.fornecedor = v-fornecedor                    
        AND {&TableName}.mes-ref = v-mes-ref                          
        AND {&TableName}.nr-fatura = v-nr-fatura                      
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
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-estabel >= v-cod-estabel-ini
          AND {&TableName}.cod-estabel <= v-cod-estabel-fim
          AND {&TableName}.equipamento >= v-equipamento-ini
          AND {&TableName}.equipamento <= v-equipamento-fim
          AND {&TableName}.fornecedor  >= v-fornecedor-ini
          AND {&TableName}.fornecedor  <= v-fornecedor-fim
          AND {&TableName}.mes-ref     >= v-mes-ref-ini
          AND {&TableName}.mes-ref     <= v-mes-ref-fim
          AND {&TableName}.nr-fatura   >= v-nr-fatura-ini
          AND {&TableName}.nr-fatura   <= v-nr-fatura-fim
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-fatura DBOProgram 
PROCEDURE setConstraintCh-fatura :
DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-equipamento AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-fornecedor AS integer NO-UNDO.                                                                         
    DEFINE INPUT PARAMETER p-mes-ref AS character NO-UNDO.                                                                          
    DEFINE INPUT PARAMETER p-nr-fatura AS character NO-UNDO.                                                                        

    ASSIGN 
    v-cod-estabel = p-cod-estabel                                     
    v-equipamento = p-equipamento                                     
    v-fornecedor = p-fornecedor                                       
    v-mes-ref = p-mes-ref                                             
    v-nr-fatura = p-nr-fatura                                         
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom1 DBOProgram 
PROCEDURE setConstraintZoom1 :
DEFINE INPUT PARAMETER p-cod-estabel-ini AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-equipamento-ini  AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-equipamento-fim  AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-fornecedor-ini  AS integer NO-UNDO.
    DEFINE INPUT PARAMETER p-fornecedor-fim  AS integer NO-UNDO.
    DEFINE INPUT PARAMETER p-mes-ref-ini  AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-mes-ref-fim  AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-fatura-ini  AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-fatura-fim  AS character NO-UNDO.

    ASSIGN 
    v-cod-estabel-ini = p-cod-estabel-ini
    v-cod-estabel-fim = p-cod-estabel-fim
    v-equipamento-ini = p-equipamento-ini
    v-equipamento-fim = p-equipamento-fim
    v-fornecedor-ini  = p-fornecedor-ini
    v-fornecedor-fim  = p-fornecedor-fim
    v-mes-ref-ini     = p-mes-ref-ini
    v-mes-ref-fim     = p-mes-ref-fim
    v-nr-fatura-ini   = p-nr-fatura-ini
    v-nr-fatura-fim   = p-nr-fatura-fim
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
                 WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
                 AND bf{&TableName}.equipamento = RowObject.equipamento
                 AND bf{&TableName}.fornecedor = RowObject.fornecedor
                 AND bf{&TableName}.mes-ref = RowObject.mes-ref
                 AND bf{&TableName}.nr-fatura = RowObject.nr-fatura) THEN DO:
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
                 WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
                 AND bf{&TableName}.equipamento = RowObject.equipamento
                 AND bf{&TableName}.fornecedor = RowObject.fornecedor
                 AND bf{&TableName}.mes-ref = RowObject.mes-ref
                 AND bf{&TableName}.nr-fatura = RowObject.nr-fatura) THEN DO:
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
                 WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
                 AND bf{&TableName}.equipamento = RowObject.equipamento
                 AND bf{&TableName}.fornecedor = RowObject.fornecedor
                 AND bf{&TableName}.mes-ref = RowObject.mes-ref
                 AND bf{&TableName}.nr-fatura = RowObject.nr-fatura) THEN DO:
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
        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Estabelecimento inv lido.~~~~Estabelecimento nÆo cadastrado.'"}
        END.

        IF NOT CAN-FIND(FIRST equipamentos NO-LOCK
                        WHERE equipamentos.equipamento = RowObject.equipamento) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Equipamento inv lido.~~~~Equipamento nÆo cadastrado.'"}
        END.
    END.

    IF CAN-FIND(FIRST integra-equipamentos NO-LOCK
                WHERE integra-equipamentos.tipo    = 0
                  AND integra-equipamentos.mes-ref = RowObject.mes-ref) THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="17006"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="'Per¡odo j  contabilizado.~~~~NÆo ‚ poss¡vel Incluir, Alterar ou Eliminar registros desse per¡odo.'"}
    END.
    ELSE IF CAN-FIND(FIRST integra-equipamentos NO-LOCK
                     WHERE integra-equipamentos.tipo    = 0
                       AND integra-equipamentos.mes-ref >= RowObject.mes-ref) THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="17006"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="'Per¡odo inferior a £ltimo per¡odo contabilizado.~~~~NÆo ‚ permitido manuten‡Æo em per¡odos anteriores ao £ltimo contabilizado.'"}
    END.

    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPeriodoContab DBOProgram 
FUNCTION fnPeriodoContab RETURNS LOGICAL
  ( INPUT c-mes-ref AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Verifica se per¡odo est  contabilizado
    Notes:  Carlos Daniel - 14/01/2016
------------------------------------------------------------------------------*/
IF CAN-FIND(FIRST integra-equipamentos
            WHERE integra-equipamentos.tipo    = 0
            AND   integra-equipamentos.mes-ref = c-mes-ref NO-LOCK) THEN
    RETURN YES.   /* Function return value. */
ELSE
    RETURN NO.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

