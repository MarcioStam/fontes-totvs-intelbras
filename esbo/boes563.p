&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
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
&GLOBAL-DEFINE DBOName BOES563
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName correios
&GLOBAL-DEFINE TableLabel 
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

{esbo/boes563.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i}
{upc/btb910za-upc.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

define variable v-cod-estabel as character no-undo.
define variable v-mes-ref     as character no-undo.
define variable v-nr-contrato as character no-undo.
define variable v-nr-fatura   as character no-undo.
define variable v-cod-cli     as integer   no-undo.
define variable v-nr-cartao   as character no-undo.
define variable v-cc-codigo   as character no-undo. 
define variable v-servico     as character no-undo.
define variable v-dt-postagem as DATE      no-undo. 
define variable v-nr-docto    as character no-undo.
                          
define variable v-cod-estabel-ini as character no-undo.
define variable v-cod-estabel-fim as character no-undo.
define variable v-mes-ref-ini     as character no-undo.
define variable v-mes-ref-fim     as character no-undo.
define variable v-nr-contrato-ini as character no-undo.
define variable v-nr-contrato-fim as character no-undo.
define variable v-nr-fatura-ini   as character no-undo.
define variable v-nr-fatura-fim   as character no-undo.
define variable v-cod-cli-ini     as integer   no-undo.
define variable v-cod-cli-fim     as integer   no-undo.
define variable v-nr-cartao-ini   as character no-undo.
define variable v-nr-cartao-fim   as character no-undo.
define variable v-cc-codigo-ini   as character no-undo. 
define variable v-cc-codigo-fim   as character no-undo.
define variable v-servico-ini     as character no-undo.
define variable v-servico-fim     as character no-undo.
define variable v-dt-postagem-ini as DATE      no-undo. 
define variable v-dt-postagem-fim as DATE      no-undo.
define variable v-nr-docto-ini    as character no-undo.
define variable v-nr-docto-fim    as character no-undo.

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
   Type: DBOProgram
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
/* DBO 2.0 Wizard (DELETE)*/
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
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cc-codigo":U THEN ASSIGN pFieldValue = RowObject.cc-codigo.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "mes-ref":U THEN ASSIGN pFieldValue = RowObject.mes-ref.
        WHEN "nr-cartao":U THEN ASSIGN pFieldValue = RowObject.nr-cartao.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-docto":U THEN ASSIGN pFieldValue = RowObject.nr-docto.
        WHEN "nr-fatura":U THEN ASSIGN pFieldValue = RowObject.nr-fatura.
        WHEN "origem-postagem":U THEN ASSIGN pFieldValue = RowObject.origem-postagem.
        WHEN "servico":U THEN ASSIGN pFieldValue = RowObject.servico.
        WHEN "servico-adicional":U THEN ASSIGN pFieldValue = RowObject.servico-adicional.
        WHEN "un-postagem":U THEN ASSIGN pFieldValue = RowObject.un-postagem.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt-postagem":U THEN ASSIGN pFieldValue = RowObject.dt-postagem.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
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
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-cliente":U THEN ASSIGN pFieldValue = RowObject.cod-cliente.
        WHEN "cod-destino":U THEN ASSIGN pFieldValue = RowObject.cod-destino.
        WHEN "peso":U THEN ASSIGN pFieldValue = RowObject.peso.
        WHEN "qtde":U THEN ASSIGN pFieldValue = RowObject.qtde.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ch-correios
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo mes-ref
               retorna valor do campo nr-contrato
               retorna valor do campo nr-fatura
               retorna valor do campo cod-cliente
               retorna valor do campo nr-cartao
               retorna valor do campo servico
               retorna valor do campo dt-postagem
               retorna valor do campo nr-docto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE correios.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pmes-ref LIKE correios.mes-ref NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-contrato LIKE correios.nr-contrato NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-fatura LIKE correios.nr-fatura NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-cliente LIKE correios.cod-cliente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-cartao LIKE correios.nr-cartao NO-UNDO.
    DEFINE OUTPUT PARAMETER pservico LIKE correios.servico NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-postagem LIKE correios.dt-postagem NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-docto LIKE correios.nr-docto NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pmes-ref = RowObject.mes-ref
           pnr-contrato = RowObject.nr-contrato
           pnr-fatura = RowObject.nr-fatura
           pcod-cliente = RowObject.cod-cliente
           pnr-cartao = RowObject.nr-cartao
           pservico = RowObject.servico
           pdt-postagem = RowObject.dt-postagem
           pnr-docto = RowObject.nr-docto.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecidField DBOProgram 
PROCEDURE getRecidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo recid
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RECID NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ch-correios
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo mes-ref
               recebe valor do campo nr-contrato
               recebe valor do campo nr-fatura
               recebe valor do campo cod-cliente
               recebe valor do campo nr-cartao
               recebe valor do campo servico
               recebe valor do campo dt-postagem
               recebe valor do campo nr-docto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE correios.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pmes-ref LIKE correios.mes-ref NO-UNDO.
    DEFINE INPUT PARAMETER pnr-contrato LIKE correios.nr-contrato NO-UNDO.
    DEFINE INPUT PARAMETER pnr-fatura LIKE correios.nr-fatura NO-UNDO.
    DEFINE INPUT PARAMETER pcod-cliente LIKE correios.cod-cliente NO-UNDO.
    DEFINE INPUT PARAMETER pnr-cartao LIKE correios.nr-cartao NO-UNDO.
    DEFINE INPUT PARAMETER pservico LIKE correios.servico NO-UNDO.
    DEFINE INPUT PARAMETER pdt-postagem LIKE correios.dt-postagem NO-UNDO.
    DEFINE INPUT PARAMETER pnr-docto LIKE correios.nr-docto NO-UNDO.

    FIND FIRST bfcorreios WHERE 
        bfcorreios.cod-estabel = pcod-estabel AND 
        bfcorreios.mes-ref = pmes-ref AND 
        bfcorreios.nr-contrato = pnr-contrato AND 
        bfcorreios.nr-fatura = pnr-fatura AND 
        bfcorreios.cod-cliente = pcod-cliente AND 
        bfcorreios.nr-cartao = pnr-cartao AND 
        bfcorreios.servico = pservico AND 
        bfcorreios.dt-postagem = pdt-postagem AND 
        bfcorreios.nr-docto = pnr-docto NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcorreios THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcorreios)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Openquery DBOProgram 
PROCEDURE Openquery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER iAbertura AS INTEGER NO-UNDO.

    CASE iAbertura:
        WHEN 1 THEN
            RUN openQueryStatic ("Main":U).
        WHEN 2 THEN           
            RUN openQueryStatic ("Ch-Correios":U).                      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenqueryCh-correios DBOProgram 
PROCEDURE OpenqueryCh-correios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-estabel  =  v-cod-estabel                
          AND {&TableName}.mes-ref      =  v-mes-ref    
          AND {&TableName}.nr-contrato  =  v-nr-contrato                    
          AND {&TableName}.nr-fatura    =  v-nr-fatura  
          AND {&TableName}.cod-cli      =  v-cod-cli    
          AND {&TableName}.nr-cartao    =  v-nr-cartao  
          AND {&TableName}.servico      =  v-servico    
          AND {&TableName}.dt-postagem  =  v-dt-postagem
          AND {&TableName}.nr-docto     =  v-nr-docto.

     RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenqueryMain DBOProgram 
PROCEDURE OpenqueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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
          AND {&TableName}.mes-ref      = v-mes-ref-ini 
          AND {&TableName}.nr-cartao   >= v-nr-cartao-ini
          AND {&TableName}.nr-cartao   <= v-nr-cartao-fim
          AND {&TableName}.dt-postagem >= v-dt-postagem-ini                                              
          AND {&TableName}.dt-postagem <= v-dt-postagem-fim                                              
          AND {&TableName}.servico   MATCHES v-servico-ini.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-Correios DBOProgram 
PROCEDURE setConstraintCh-Correios :
DEFINE INPUT PARAMETER p-cod-estabel as character no-undo.  
    define input parameter p-mes-ref     as character no-undo.  
    define input parameter p-nr-contrato as character no-undo.  
    define input parameter p-nr-fatura   as character no-undo.  
    define input parameter p-cod-cli     as integer   no-undo.  
    define input parameter p-nr-cartao   as character no-undo.  
    define input parameter p-servico     as character no-undo.  
    define input parameter p-dt-postagem as DATE      no-undo.  
    define input parameter p-nr-docto    as character no-undo.  

    ASSIGN v-cod-estabel =  p-cod-estabel
           v-mes-ref     =  p-mes-ref    
           v-nr-contrato =  p-nr-contrato
           v-nr-fatura   =  p-nr-fatura  
           v-cod-cli     =  p-cod-cli    
           v-nr-cartao   =  p-nr-cartao  
           v-servico     =  p-servico    
           v-dt-postagem =  p-dt-postagem
           v-nr-docto    =  p-nr-docto.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom1 DBOProgram 
PROCEDURE setConstraintZoom1 :
DEFINE INPUT PARAMETER p-cod-estabel-ini AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-mes-ref-ini     AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-cartao-ini   AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-cartao-fim   AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-postagem-ini AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-postagem-fim AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER p-servico-ini     AS character NO-UNDO.
    
    ASSIGN  v-cod-estabel-ini   = p-cod-estabel-ini
            v-cod-estabel-fim   = p-cod-estabel-fim
            v-mes-ref-ini       = p-mes-ref-ini    
            v-nr-cartao-ini     = p-nr-cartao-ini  
            v-nr-cartao-fim     = p-nr-cartao-fim  
            v-dt-postagem-ini   = p-dt-postagem-ini
            v-dt-postagem-fim   = p-dt-postagem-fim
            v-servico-ini       = "*" + p-servico-ini + "*".

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
    
    DEFINE INPUT PARAMETER pType    AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/

      
    IF pType = "Create" OR
       pType = "Update"   
    THEN DO:
        EMPTY TEMP-TABLE tt_log_erro.
        run prgint\utb\utb742za.py persistent set h_api_ccusto.
            
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                                   input  "",                  /* CODIGO DO PLANO CCUSTO */
                                                   input  RowObject.cc-codigo, /* CCUSTO */
                                                   input  today,               /* DATA DE TRANSACAO */
                                                   output v_des_titulo_ccusto, /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro).  /* ERROS */
        
        for each tt_log_erro no-lock:
            RUN _insertErrorManual IN THIS-PROCEDURE (INPUT 17006,
                                       				  INPUT "EMS":U,
                                                      INPUT "ERROR":U,
                                                      INPUT tt_log_erro.ttv_des_msg_erro + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')',
                                                      INPUT tt_log_erro.ttv_des_msg_ajuda,
                                                      INPUT "":U).
        end.	
        
        delete object h_api_ccusto.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

