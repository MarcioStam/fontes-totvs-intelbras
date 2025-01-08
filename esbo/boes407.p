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
{include/i-prgvrs.i BOES407 2.00.00.000}                               
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
&GLOBAL-DEFINE DBOName  BOES407
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  equipamentos
&GLOBAL-DEFINE TableLabel  Equipamentos                  
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
{esbo/boes407.i RowObject}
 
 
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i} 
{upc/btb910za-upc.i}
 
/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Definiá∆o de vari†veis *********************** */
define variable v-cod-estabel as character no-undo.
define variable v-equipamento as character no-undo.
 
DEFINE VARIABLE v-estab-ini       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-estab-fim       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-equipamento-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-equipamento-fim AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-descricao-ini   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-descricao-fim   AS CHARACTER   NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH usu-equipamentos EXCLUSIVE-LOCK
       WHERE usu-equipamentos.cod-estabel = RowObject.cod-estabel
         AND usu-equipamentos.equipamento = RowObject.equipamento:
        DELETE usu-equipamentos.
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "equipamento":U THEN ASSIGN pFieldValue = RowObject.equipamento.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
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
        WHEN "val-limite":U THEN ASSIGN pFieldValue = RowObject.val-limite.
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
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
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
    DEFINE OUTPUT PARAMETER p-cod-estabel LIKE equipamentos.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER p-equipamento LIKE equipamentos.equipamento NO-UNDO.    

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN p-cod-estabel = RowObject.cod-estabel        
           p-equipamento = RowObject.equipamento.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-equipamento AS character NO-UNDO.                                                                      

    FIND bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estabel = p-cod-estabel              
        AND bf{&TableName}.equipamento = p-equipamento                
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
            RUN openQueryStatic ("Ch-chave":U).                       
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-chave DBOProgram                                                             
PROCEDURE openQueryCh-chave :                                                                                                       

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-estabel = v-cod-estabel                
        AND {&TableName}.equipamento = v-equipamento                  
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
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-estabel >= v-estab-ini
           AND {&TableName}.cod-estabel <= v-estab-fim
           AND {&TableName}.equipamento >= v-equipamento-ini
           AND {&TableName}.equipamento <= v-equipamento-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom2 DBOProgram 
PROCEDURE openQueryZoom2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-estabel >= v-estab-ini
           AND {&TableName}.cod-estabel <= v-estab-fim
           AND {&TableName}.descricao   >= v-descricao-ini
           AND {&TableName}.descricao   <= v-descricao-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-chave DBOProgram                                                         
PROCEDURE setConstraintCh-chave :                                                                                                   
    DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-equipamento AS character NO-UNDO.                                                                      

    ASSIGN 
    v-cod-estabel = p-cod-estabel                                     
    v-equipamento = p-equipamento                                     
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
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-estab-ini       AS CHARACTER. 
    DEFINE INPUT PARAMETER p-estab-fim       AS CHARACTER. 
    DEFINE INPUT PARAMETER p-equipamento-ini AS CHARACTER. 
    DEFINE INPUT PARAMETER p-equipamento-fim AS CHARACTER. 

    ASSIGN v-estab-ini       = p-estab-ini      
           v-estab-fim       = p-estab-fim      
           v-equipamento-ini = p-equipamento-ini
           v-equipamento-fim = p-equipamento-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom2 DBOProgram 
PROCEDURE setConstraintZoom2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-estab-ini       AS CHARACTER. 
    DEFINE INPUT PARAMETER p-estab-fim       AS CHARACTER. 
    DEFINE INPUT PARAMETER p-descricao-ini   AS CHARACTER. 
    DEFINE INPUT PARAMETER p-descricao-fim   AS CHARACTER. 

    ASSIGN v-estab-ini       = p-estab-ini      
           v-estab-fim       = p-estab-fim      
           v-descricao-ini   = p-descricao-ini  
           v-descricao-fim   = p-descricao-fim.

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
                 WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
                 AND bf{&TableName}.equipamento = RowObject.equipamento) THEN DO:
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
                 AND bf{&TableName}.equipamento = RowObject.equipamento) THEN DO:
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
                 AND bf{&TableName}.equipamento = RowObject.equipamento) THEN DO:
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
        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Estabelecimento inv†lido.~~~~Estabelecimento n∆o cadastrado.'"}
        END.

        IF RowObject.equipamento = "" THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Equipamento inv†lido.~~~~Equipamento deve ser informado.'"}
        END.

        IF RowObject.descricao = "" THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Descriá∆o inv†lida.~~~~Descriá∆o deve ser informada.'"}
        END.

        IF NOT CAN-FIND(FIRST tipo-equipamentos NO-LOCK
                        WHERE tipo-equipamentos.codigo = RowObject.tipo) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Tipo Equipamento inv†lido.~~~~Tipo de Equipamento n∆o cadastrado.'"}
        END.

         
         RUN prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

         FOR EACH cc-equipamentos NO-LOCK
             WHERE cc-equipamentos.cod-estabel = RowObject.cod-estabel
               AND cc-equipamentos.equipamento = RowObject.equipamento:

             EMPTY TEMP-TABLE tt_log_erro.
             RUN pi_valida_conta_contabil in h_api_cta_ctbl (input  i-ep-codigo-usuario,         /* EMPRESA EMS2 */
                                                             input  cc-equipamentos.cod-estabel, /* ESTABELECIMENTO EMS2 */
                                                             input  "",                          /* UNIDADE NEG‡CIO */
                                                             input  "",                          /* PLANO CONTAS */ 
                                                             input  RowObject.ct-codigo,         /* CONTA */
                                                             input  "",                          /* PLANO CCUSTO */ 
                                                             input  cc-equipamentos.cc-codigo,   /* CCUSTO */
                                                             input  today,                       /* DATA TRANSACAO */
                                                             output table tt_log_erro).          /* ERROS */
            for first tt_log_erro:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=tt_log_erro.ttv_des_msg_erro}
            end.
         END.

        if valid-handle(h_api_cta_ctbl) 
        then
            delete object h_api_cta_ctbl.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

