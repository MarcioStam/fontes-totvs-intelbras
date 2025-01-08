&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) é um programa PROGRESS 
                 que contém a lógica de negócio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definição ---*/
&GLOBAL-DEFINE DBOName BOES652
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-mqa
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (método Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que dá acessos a todos os registros, exceto os excluídos pela constraint de segurança. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress não conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definição da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diretório do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idêntico ao nome do DBO mas com 
      extensão .i ---*/
{esbo/boes652.i RowObject}


/*:T--- Include com definição da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteração da definição da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definição 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definição de buffer que será utilizado pelo método goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-cod-prod-ini AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-cod-prod-fim AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-descricao-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-descricao-fim AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estab-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estab-fim AS CHARACTER   NO-UNDO.

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
         HEIGHT             = 10.67
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validações pertinentes ao DBO
  Parameters:  recebe o tipo de validação (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/      
    
    RUN criaRelacionamentos(Rowobject.cod-prod,
                            RowObject.cod-estabel).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN RowObject.descricao = CAPS(RowObject.descricao).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN RowObject.descricao = CAPS(RowObject.descricao).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaEstrutura DBOProgram 
PROCEDURE criaEstrutura :
/*:T------------------------------------------------------------------------------
  Purpose:     Validações pertinentes ao DBO
  Parameters:  recebe o tipo de validação (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-prod    AS INT  NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo   AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel AS CHAR NO-UNDO.   

    DEFINE VARIABLE l-descer-nivel AS LOGICAL     NO-UNDO.

    DEF BUFFER estrutura FOR estrutura.
    DEF BUFFER b-estrut  FOR estrutura.

    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo = p-it-codigo
          AND estrutura.data-inicio <= TODAY           
          AND estrutura.data-termino > TODAY:

        IF estrutura.local-montag <> "" THEN DO:          

            FOR EACH  int-local-montag NO-LOCK
                WHERE int-local-montag.it-codigo = estrutura.it-codigo
                AND   int-local-montag.sequencia = estrutura.sequencia
                AND   int-local-montag.es-codigo = estrutura.es-codigo:

                FOR FIRST estrutura-mqa EXCLUSIVE-LOCK
                    WHERE estrutura-mqa.cod-prod     = p-cod-prod
                    AND   estrutura-mqa.local-montag = int-local-montag.local-montag
                    AND   estrutura-mqa.cod-estabel  = p-cod-estabel:
                END.
                IF NOT AVAIL estrutura-mqa THEN DO:                        
            
                    CREATE estrutura-mqa.
                    ASSIGN estrutura-mqa.cod-prod     = p-cod-prod
                           estrutura-mqa.local-montag = int-local-montag.local-montag
                           estrutura-mqa.cod-estabel  = p-cod-estabel.
                END.

                ASSIGN estrutura-mqa.es-codigo = estrutura.es-codigo.

                RELEASE estrutura-mqa NO-ERROR.

                RUN criaIndiceQualidade (INPUT estrutura.es-codigo,
                                         INPUT p-cod-estabel).
                
                
            END.               
        END.       

        ASSIGN l-descer-nivel = YES.
        
        FIND FIRST item-mqa NO-LOCK
             WHERE item-mqa.cod-estabel = p-cod-estabel
               AND item-mqa.cod-prod    = p-cod-prod NO-ERROR.
        IF AVAIL item-mqa THEN DO:
            
            IF item-mqa.log-copiar-apenas-nivel THEN
                ASSIGN l-descer-nivel = NO.
        END.
        
        IF l-descer-nivel THEN
            RUN criaEstrutura (INPUT p-cod-prod,
                               INPUT estrutura.es-codigo,
                               INPUT p-cod-estabel).
    END. //for each estrutura
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaFalha DBOProgram 
PROCEDURE criaFalha :
/*:T------------------------------------------------------------------------------
  Purpose:     Validações pertinentes ao DBO
  Parameters:  recebe o tipo de validação (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p-cod-prod    AS INT NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel AS CHAR NO-UNDO.   
    /*
    FOR EACH  estrutura-mqa NO-LOCK
        WHERE estrutura-mqa.cod-prod    = p-cod-prod
          AND estrutura-mqa.cod-estabel = p-cod-estabel.

        FOR EACH falha-mqa NO-LOCK:

            IF NOT CAN-FIND(FIRST item-falha NO-LOCK 
                            WHERE item-falha.it-codigo = estrutura-mqa.es-codigo
                              AND item-falha.cod-falha = falha-mqa.cod-falha) THEN DO:

                CREATE item-falha.
                BUFFER-COPY falha-mqa TO item-falha.
                ASSIGN item-falha.it-codigo = estrutura-mqa.es-codigo.

            END.
        END.
    END.
    */
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaIndiceQualidade DBOProgram 
PROCEDURE criaIndiceQualidade :
/*:T------------------------------------------------------------------------------
  Purpose:     Validações pertinentes ao DBO
  Parameters:  recebe o tipo de validação (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-it-codigo   AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel AS CHAR NO-UNDO.

    IF NOT CAN-FIND(indice-qualid NO-LOCK WHERE indice-qualid.cod-estabel = p-cod-estabel AND
                                                indice-qualid.it-codigo   = p-it-codigo) THEN DO:
        CREATE indice-qualid.
        ASSIGN indice-qualid.cod-estabel    = p-cod-estabel
               indice-qualid.it-codigo      = p-it-codigo
               indice-qualid.relat-atencao  = 0.5 
               indice-qualid.relat-problema = 1
               indice-qualid.absol-atencao  = 4
               indice-qualid.absol-problema = 10.
               
    END. //if not can-find
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaRelacionamentos DBOProgram 
PROCEDURE criaRelacionamentos :
/*:T------------------------------------------------------------------------------
  Purpose:     Validações pertinentes ao DBO
  Parameters:  recebe o tipo de validação (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pi-cod-prod    AS INT  NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-estabel AS CHAR NO-UNDO.

    DEF BUFFER b-item-mqa FOR item-mqa.

    FIND b-item-mqa NO-LOCK WHERE b-item-mqa.cod-prod    = pi-cod-prod AND
                                  b-item-mqa.cod-estabel = pi-cod-estabel NO-ERROR.

    IF AVAIL b-item-mqa THEN DO:

        RUN criaEstrutura (INPUT b-item-mqa.cod-prod,
                           INPUT b-item-mqa.it-ref,
                           INPUT b-item-mqa.cod-estabel).        
    END.
 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "it-ref":U THEN ASSIGN pFieldValue = RowObject.it-ref.
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "date-1":U THEN ASSIGN pFieldValue = RowObject.date-1.
        WHEN "date-2":U THEN ASSIGN pFieldValue = RowObject.date-2.
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-prod":U THEN ASSIGN pFieldValue = RowObject.cod-prod.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do índice item
  Parameters:  
               retorna valor do campo cod-prod
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-prod  LIKE item-mqa.cod-prod    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estab LIKE item-mqa.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-prod  = RowObject.cod-prod
           pcod-estab = RowObject.cod-estabel.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo lógico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
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

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
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
  Purpose:     Reposiciona registro com base no índice item
  Parameters:  
               recebe valor do campo cod-prod
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-prod  LIKE item-mqa.cod-prod    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estab LIKE item-mqa.cod-estabel NO-UNDO.

    FIND FIRST bfitem-mqa WHERE 
        bfitem-mqa.cod-prod    = pcod-prod AND 
        bfitem-mqa.cod-estabel = pcod-estab NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro será retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-mqa THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query através de rowid e verifica a ocorrência de erros, caso
          existam erros será retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-mqa)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryProduto DBOProgram 
PROCEDURE openQueryProduto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
        WHERE {&TableName}.cod-prod >= i-cod-prod-ini
        AND   {&TableName}.cod-prod <= i-cod-prod-fim
        AND   {&TableName}.descricao >= c-descricao-ini
        AND   {&TableName}.descricao <= c-descricao-fim
        AND   {&TableName}.cod-estabel >= c-cod-estab-ini
        AND   {&TableName}.cod-estabel <= c-cod-estab-fim
        INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintProduto DBOProgram 
PROCEDURE setConstraintProduto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-prod-ini   AS INT     NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-prod-fim   AS INT     NO-UNDO.
    DEFINE INPUT PARAMETER p-descricao-ini  AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER p-descricao-fim  AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estab-ini  AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estab-fim  AS CHAR    NO-UNDO.


    ASSIGN i-cod-prod-ini  = p-cod-prod-ini  
           i-cod-prod-fim  = p-cod-prod-fim  
           c-descricao-ini = p-descricao-ini 
           c-descricao-fim = p-descricao-fim
           c-cod-estab-ini = p-cod-estab-ini
           c-cod-estab-fim = p-cod-estab-fim.

    RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validações pertinentes ao DBO
  Parameters:  recebe o tipo de validação (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parâmetro pType para identificar quais as validações a serem
          executadas ---*/
    /*:T--- Os valores possíveis para o parâmetro são: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, através do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validações ---*/

    IF pType = "Create" OR pType = "Update" THEN DO:

        IF NOT CAN-FIND(FIRST estabelec
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="'Estabelecimento'"}

        END.
        
        IF rowObject.it-ref = "" THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17242"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="'Item em branco'"}
        END.

        IF NOT CAN-FIND(FIRST ITEM 
                        WHERE ITEM.it-codigo = RowObject.it-ref) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="'Item'"}
        END.

        IF NOT CAN-FIND(FIRST operacao
                        WHERE operacao.it-codigo = string(rowObject.cod-prod)) THEN DO:
            
            {method/svc/errors/inserr.i &ErrorNumber="17242"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="'C�digo do produto n�o � um c�digo de reporte'"}
        END.
    END.
    
    /*:T--- Verifica ocorrência de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

