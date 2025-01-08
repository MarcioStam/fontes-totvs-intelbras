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
{include/i-prgvrs.i BOES328 2.00.00.000}                               
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
&GLOBAL-DEFINE DBOName  BOES328
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  int-item-fornec
&GLOBAL-DEFINE TableLabel  int-item-fornec               
&GLOBAL-DEFINE QueryName qrint-item-fornec
 
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
{esbo/boes328.i RowObject}
 
def temp-table tt-item-obs no-undo
    field it-codigo like item.it-codigo.
    
def temp-table tt-fornec-obs no-undo
    field cod-emitente like emitente.cod-emitente.    

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bfint-item-fornec FOR {&TableName}.

/* ************************* Defini‡Æo de vari veis *********************** */
define variable v-it-codigo as character no-undo.
define variable v-cod-emitente as integer no-undo.

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
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "obs-insp":U THEN ASSIGN pFieldValue = RowObject.obs-insp.
        WHEN "obs-rec":U THEN ASSIGN pFieldValue = RowObject.obs-rec.
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
        WHEN "tempo-fabric":U THEN ASSIGN pFieldValue = RowObject.tempo-fabric.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
DEFINE INPUT PARAMETER p-it-codigo AS character NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-cod-emitente AS integer NO-UNDO.                                                                       

    FIND bfint-item-fornec NO-LOCK
        WHERE bfint-item-fornec.it-codigo = p-it-codigo                  
        AND bfint-item-fornec.cod-emitente = p-cod-emitente              
        NO-ERROR.
    IF NOT AVAILABLE bfint-item-fornec THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfint-item-fornec)).
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
            RUN openQueryStatic ("Onde-compra":U).                    
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFornec DBOProgram 
PROCEDURE openQueryByFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-emitente = v-cod-emitente                
    .
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItem DBOProgram 
PROCEDURE openQueryByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.it-codigo = v-it-codigo                    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOnde-compra DBOProgram 
PROCEDURE openQueryOnde-compra :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.it-codigo = v-it-codigo                    
        AND {&TableName}.cod-emitente = v-cod-emitente                
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByFornec DBOProgram 
PROCEDURE setConstraintByFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-emitente AS integer NO-UNDO.                                                                       

    ASSIGN 
    v-cod-emitente = p-cod-emitente                                   
    .
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByItem DBOProgram 
PROCEDURE setConstraintByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-it-codigo AS character NO-UNDO.                                                                        
    ASSIGN 
    v-it-codigo = p-it-codigo                                         
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOnde-compra DBOProgram 
PROCEDURE setConstraintOnde-compra :
DEFINE INPUT PARAMETER p-it-codigo AS character NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-cod-emitente AS integer NO-UNDO.                                                                       

    ASSIGN 
    v-it-codigo = p-it-codigo                                         
    v-cod-emitente = p-cod-emitente                                   
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UpdateByFornec DBOProgram 
PROCEDURE UpdateByFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-emitente AS integer NO-UNDO.                                                                       
    def input param p-obs as char no-undo.
    def input param table for tt-item-obs.                                                                    

    if not can-find(first emitente no-lock
       where emitente.cod-emitente = p-cod-emitente) then do:
       {utp/ut-table.i mgcad emitente 1}
        {method/svc/errors/inserr.i
            &ErrorNumber="2"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="return-value"
        }
        RETURN "NOK":U.

    end.   
    
    for each item-fornec no-lock
        where item-fornec.cod-emitente = p-cod-emitente:
        
        find first int-item-fornec of item-fornec exclusive-lock no-error.
        if not avail int-item-fornec then do:
            create int-item-fornec.
            assign int-item-fornec.cod-emitente = p-cod-emitente
                   int-item-fornec.it-codigo    = item-fornec.it-codigo
                   int-item-fornec.obs-rec      = p-obs.
        end.           
        else if can-find(first tt-item-obs 
                         where tt-item-obs.it-codigo = item-fornec.it-codigo) 
             or int-item-fornec.obs-rec = "" then do:
            ASSIGN int-item-fornec.obs-rec = /*int-item-fornec.obs-rec + "//" +*/ p-obs.
        END.
        
        release int-item-fornec.                     
    end.    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UpdateByItem DBOProgram 
PROCEDURE UpdateByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-it-codigo AS character NO-UNDO.    
    def input param p-obs as char no-undo.
    def input param table for tt-fornec-obs.                                                                    

    if not can-find(first item no-lock
       where item.it-codigo = p-it-codigo) then do:
       {utp/ut-table.i mgcad item 1}
        {method/svc/errors/inserr.i
            &ErrorNumber="2"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="return-value"
        }
        RETURN "NOK":U.

    end.   
    
    for each item-fornec no-lock
        where item-fornec.it-codigo = p-it-codigo:
        
        find first int-item-fornec of item-fornec exclusive-lock no-error.
        if not avail int-item-fornec then do:
            create int-item-fornec.
            assign int-item-fornec.cod-emitente = item-fornec.cod-emitente
                   int-item-fornec.it-codigo    = p-it-codigo
                   int-item-fornec.obs-rec      = p-obs.
        end.           
        else if can-find(first tt-fornec-obs 
                         where tt-fornec-obs.cod-emitente = item-fornec.cod-emitente)  
             or int-item-fornec.obs-rec = "" then do: 
            ASSIGN int-item-fornec.obs-rec = /*int-item-fornec.obs-rec + "//" +*/ p-obs.
        END.
        
        release int-item-fornec.                     
    end.    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
    
    /*FIND FIRST RowObject NO-ERROR.

    FIND FIRST bfint-item-fornec NO-LOCK
         WHERE bfint-item-fornec.it-codigo    = RowObject.it-codigo
           AND bfint-item-fornec.cod-emitente = RowObject.cod-emitente NO-ERROR.
    IF AVAIL bfint-item-fornec THEN DO:
        ASSIGN RowObject.obs-rec = RowObject.obs-rec + " // " + bfint-item-fornec.obs-rec.
    END.*/

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
    
    def var l-erro as logical no-undo.

    CASE pType:
         WHEN "Create" THEN DO:
             IF CAN-FIND(FIRST bfint-item-fornec NO-LOCK
                 WHERE bfint-item-fornec.it-codigo = RowObject.it-codigo
                 AND bfint-item-fornec.cod-emitente = RowObject.cod-emitente) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.
             
             if not can-find(first item no-lock
                where item.it-codigo = RowObject.it-codigo) then do:
                {utp/ut-table.i mgcad item 1}
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="return-value"
                 }
                 l-erro = yes.
             end.   
             
             if not can-find(first emitente no-lock
                where emitente.cod-emitente = RowObject.cod-emitente) then do:
                {utp/ut-table.i mgcad emitente 1}
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="return-value"
                 }
                 l-erro = yes.
             end.
             
             if not l-erro
             and not can-find(first item-fornec no-lock
                where item-fornec.it-codigo = RowObject.it-codigo
                and   item-fornec.cod-emitente = RowObject.cod-emitente) then do:
                {utp/ut-table.i mgcad item-fornec 1}
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="return-value"
                 }
             end.      

         END.
         WHEN "Update" THEN DO:
             IF NOT CAN-FIND(FIRST bfint-item-fornec NO-LOCK
                 WHERE bfint-item-fornec.it-codigo = RowObject.it-codigo
                 AND bfint-item-fornec.cod-emitente = RowObject.cod-emitente) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.
             if not can-find(first item no-lock
                where item.it-codigo = RowObject.it-codigo) then do:
                {utp/ut-table.i mgcad item 1}
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="return-value"
                 }
                 l-erro = yes.
             end.   
             
             if not can-find(first emitente no-lock
                where emitente.cod-emitente = RowObject.cod-emitente) then do:
                {utp/ut-table.i mgcad emitente 1}
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="return-value"
                 }
                 l-erro = yes.
             end.
             
             if not l-erro
             and not can-find(first item-fornec no-lock
                where item-fornec.it-codigo = RowObject.it-codigo
                and   item-fornec.cod-emitente = RowObject.cod-emitente) then do:
                {utp/ut-table.i mgcad item-fornec 1}
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="return-value"
                 }
             end.
         END.
         WHEN "Delete" THEN DO:
             IF NOT CAN-FIND(FIRST bfint-item-fornec NO-LOCK
                 WHERE bfint-item-fornec.it-codigo = RowObject.it-codigo
                 AND bfint-item-fornec.cod-emitente = RowObject.cod-emitente) THEN DO:
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

