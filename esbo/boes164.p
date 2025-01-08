&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
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
&GLOBAL-DEFINE DBOName BOES164
&GLOBAL-DEFINE DBOVersion 1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName reporte-seletivo
&GLOBAL-DEFINE TableLabel reporte-seletivo 
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
{esbo/boes164.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEF var v-ini-it-codigo    LIKE reporte-seletivo.it-codigo NO-UNDO.
DEF var v-ini-es-codigo    LIKE reporte-seletivo.es-codigo NO-UNDO.
DEF var v-ini-data-inicial LIKE reporte-seletivo.data-inicial NO-UNDO.
DEF var v-ini-data-final   LIKE reporte-seletivo.data-final NO-UNDO.
DEF var v-ini-tipo         LIKE reporte-seletivo.tipo NO-UNDO.
DEF var v-fim-it-codigo    LIKE reporte-seletivo.it-codigo NO-UNDO.
DEF var v-fim-es-codigo    LIKE reporte-seletivo.es-codigo NO-UNDO.
DEF var v-fim-data-inicial LIKE reporte-seletivo.data-inicial NO-UNDO.
DEF var v-fim-data-final   LIKE reporte-seletivo.data-final NO-UNDO.
DEF var v-fim-tipo         LIKE reporte-seletivo.tipo NO-UNDO.
DEF VAR h-boin111 AS HANDLE NO-UNDO.

DEF TEMP-TABLE ttestrutura NO-UNDO LIKE estrutura 
    FIELD r-rowid AS ROWID.

DEF TEMP-TABLE ttestrutura-ext LIKE ttestrutura.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN RowObject.quantidade   = RowObject.qtd-unitaria * RowObject.quantidade
           RowObject.quant-saldo  = RowObject.qtd-unitaria * RowObject.quantidade.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaQuantidadeUnitaria DBOProgram 
PROCEDURE buscaQuantidadeUnitaria :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-it-codigo AS CHAR NO-UNDO.
    DEF INPUT PARAM p-es-codigo AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-qtd-unit AS DECIMAL NO-UNDO.

    IF NOT VALID-HANDLE(h-boin111) OR
       h-boin111:TYPE <> "PROCEDURE":U OR
       h-boin111:FILE-NAME <> "inbo/boin111.p":U THEN DO:
        RUN inbo/boin111.p PERSISTENT SET h-boin111.
    END.
    
    run buscaQuantidadeUnitariaExt (INPUT p-it-codigo,
                                    INPUT p-es-codigo,
                                    INPUT-OUTPUT p-qtd-unit).

    RUN Destroy IN h-boin111.
    ASSIGN h-boin111   = ?.

    if p-qtd-unit = 0 then do:
        CREATE RowErrors.
        ASSIGN RowErrors.errorsequence = 0
               RowErrors.errornumber   = 0
               RowErrors.errordescription = "Item nÆo utilizado na estrutura"
               RowErrors.errortype = "error"
               RowErrors.ErrorSubType = "ERROR":U
               RowErrors.errorhelp = substitute("O componente informado nÆo pertence a estrutura do item &1", TRIM(p-it-codigo)).
        RETURN "NOK".
    end.       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaQuantidadeUnitariaExt DBOProgram 
PROCEDURE buscaQuantidadeUnitariaExt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-it-codigo AS CHAR NO-UNDO.
    DEF INPUT PARAM p-es-codigo AS CHAR NO-UNDO.
    DEF INPUT-OUTPUT PARAM p-qtd-unit AS DECIMAL NO-UNDO.

    DEF VAR iRowsReturned AS INTEGER NO-UNDO.

    RUN setConstraintItCodigo IN h-boin111 (p-it-codigo) NO-ERROR.
    RUN openQueryStatic IN h-boin111 (INPUT "ItCodigo":U) NO-ERROR.
    RUN getBatchRecords IN h-boin111 (INPUT ?,
                                      INPUT NO,
                                      ?,
                                      OUTPUT iRowsReturned,
                                      OUTPUT TABLE ttestrutura).

    FOR EACH ttestrutura:
        IF NOT CAN-FIND(ttestrutura-ext
                        WHERE ttestrutura-ext.it-codigo = ttestrutura.it-codigo
                        AND   ttestrutura-ext.sequencia = ttestrutura.sequencia
                        AND   ttestrutura-ext.es-codigo = ttestrutura.es-codigo) THEN DO:
            CREATE ttestrutura-ext.
            BUFFER-COPY ttestrutura TO ttestrutura-ext.
        END.
    END.


    for each ttestrutura-ext 
       where ttestrutura-ext.it-codigo    = p-it-codigo
         AND ttestrutura-ext.data-inicio <= today
         and ttestrutura-ext.data-termino > today:

        if ttestrutura-ext.fantasma then 
            run buscaQuantidadeUnitariaExt (INPUT ttestrutura-ext.es-codigo,
                                            INPUT p-es-codigo,
                                            INPUT-OUTPUT p-qtd-unit).
        else
           if ttestrutura-ext.es-codigo = p-es-codigo then 
               ASSIGN p-qtd-unit = p-qtd-unit +  ttestrutura-ext.quant-usada.
        
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaReportes DBOProgram 
PROCEDURE eliminaReportes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each {&TableName} EXCLUSIVE-LOCK
       where {&TableName}.data-final < today:
       delete {&TableName}.
    end.
    for each {&TableName} EXCLUSIVE-LOCK
       where {&TableName}.quant-saldo <= 0:
       delete {&TableName}.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe it-codigo do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.
    CASE pFieldName:
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "es-codigo":U THEN ASSIGN pFieldValue = RowObject.es-codigo.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
        WHEN "motivo[1]":U THEN ASSIGN pFieldValue = RowObject.motivo[1].
        WHEN "motivo[2]":U THEN ASSIGN pFieldValue = RowObject.motivo[2].
        WHEN "motivo[3]":U THEN ASSIGN pFieldValue = RowObject.motivo[3].
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-inicial":U THEN ASSIGN pFieldValue = RowObject.data-inicial.
        WHEN "data-final":U THEN ASSIGN pFieldValue = RowObject.data-final.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "quant-atend":U THEN ASSIGN pFieldValue = RowObject.quant-atend.
        WHEN "quant-saldo":U THEN ASSIGN pFieldValue = RowObject.quant-saldo.
        WHEN "qtd-unitaria":U THEN ASSIGN pFieldValue = RowObject.qtd-unitaria.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice codigo
  Parameters:  
               retorna valor do campo cd-oper
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-it-codigo LIKE reporte-seletivo.it-codigo NO-UNDO.
    DEF OUTPUT PARAM p-es-codigo LIKE reporte-seletivo.es-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN p-it-codigo = RowObject.it-codigo
           p-es-codigo = RowObject.es-codigo.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice codigo
  Parameters:  
               recebe valor do campo cd-oper
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-it-codigo    LIKE reporte-seletivo.it-codigo NO-UNDO.
    DEF INPUT PARAM p-es-codigo    LIKE reporte-seletivo.es-codigo NO-UNDO.
    DEF INPUT PARAM p-data-inicial LIKE reporte-seletivo.data-inicial NO-UNDO.
    DEF INPUT PARAM p-data-final   LIKE reporte-seletivo.data-final NO-UNDO.
    DEF INPUT PARAM p-tipo         LIKE reporte-seletivo.tipo NO-UNDO.

    FIND FIRST bfreporte-seletivo 
        WHERE bfreporte-seletivo.it-codigo    = p-it-codigo
        AND   bfreporte-seletivo.es-codigo    = p-es-codigo 
        AND   bfreporte-seletivo.data-inicial = p-data-inicial
        AND   bfreporte-seletivo.data-final   = p-data-final  
        AND   bfreporte-seletivo.tipo         = p-tipo        
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfreporte-seletivo THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfreporte-seletivo)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaItem DBOProgram 
PROCEDURE openQueryFaixaItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
    WHERE {&TableName}.es-codigo >= v-ini-es-codigo
    AND   {&TableName}.es-codigo <= v-fim-es-codigo
    AND   {&TableName}.it-codigo >= v-ini-it-codigo
    AND   {&TableName}.it-codigo <= v-fim-it-codigo
    AND   {&TableName}.data-inicial >= v-ini-data-inicial
    AND   {&TableName}.data-inicial <= v-fim-data-inicial
    AND   {&TableName}.data-final >= v-ini-data-final
    AND   {&TableName}.data-final <= v-fim-data-final
    AND   {&TableName}.tipo >= v-ini-tipo
    AND   {&TableName}.tipo <= v-fim-tipo.

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

OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaItem DBOProgram 
PROCEDURE setConstraintFaixaItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-ini-it-codigo    LIKE reporte-seletivo.it-codigo NO-UNDO.
def input param p-fim-it-codigo    LIKE reporte-seletivo.it-codigo NO-UNDO.
def input param p-ini-es-codigo    LIKE reporte-seletivo.es-codigo NO-UNDO.
def input param p-fim-es-codigo    LIKE reporte-seletivo.es-codigo NO-UNDO.
def input param p-ini-data-inicial LIKE reporte-seletivo.data-inicial NO-UNDO.
def input param p-fim-data-inicial LIKE reporte-seletivo.data-inicial NO-UNDO.
def input param p-ini-data-final   LIKE reporte-seletivo.data-final NO-UNDO.
def input param p-fim-data-final   LIKE reporte-seletivo.data-final NO-UNDO.
def input param p-ini-tipo         LIKE reporte-seletivo.tipo NO-UNDO.
def input param p-fim-tipo         LIKE reporte-seletivo.tipo NO-UNDO.

ASSIGN v-ini-it-codigo    = p-ini-it-codigo   
       v-fim-it-codigo    = p-fim-it-codigo   
       v-ini-es-codigo    = p-ini-es-codigo   
       v-fim-es-codigo    = p-fim-es-codigo   
       v-ini-data-inicial = p-ini-data-inicial
       v-fim-data-inicial = p-fim-data-inicial
       v-ini-data-final   = p-ini-data-final  
       v-fim-data-final   = p-fim-data-final  
       v-ini-tipo         = p-ini-tipo        
       v-fim-tipo         = p-fim-tipo.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
    DEF VAR i-sequencia AS INTEGER NO-UNDO.

    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/

    CASE pType:
        WHEN "Create" THEN DO:
            IF CAN-FIND(FIRST {&TableName} NO-LOCK
                        WHERE {&TableName}.es-codigo    = RowObject.es-codigo
                        AND   {&TableName}.data-inicial = RowObject.data-inicial
                        AND   {&TableName}.data-final   = RowObject.data-final
                        AND   {&TableName}.tipo         = RowObject.tipo
                        AND   {&TableName}.it-codigo    = RowObject.it-codigo) THEN DO:
                RUN utp/ut-msgs.p (INPUT "msg",
                                   INPUT 1,
                                   INPUT 'Reporte Seletivo').
                CREATE RowErrors.
                ASSIGN i-sequencia = i-sequencia + 1
                       RowErrors.errorsequence = i-sequencia
                       RowErrors.errornumber   = 1
                       RowErrors.errordescription = RETURN-VALUE
                       RowErrors.errortype = "error"
                       RowErrors.ErrorSubType = "ERROR":U
                       RowErrors.errorhelp = RETURN-VALUE.
            END.

            IF CAN-FIND(FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = RowObject.it-codigo) = NO THEN DO:
                RUN utp/ut-msgs.p (INPUT "msg",
                                   INPUT 2,
                                   INPUT 'Item').
                CREATE RowErrors.
                ASSIGN i-sequencia = i-sequencia + 1
                       RowErrors.errorsequence = i-sequencia
                       RowErrors.errornumber   = 2
                       RowErrors.errordescription = RETURN-VALUE
                       RowErrors.errortype = "error"
                       RowErrors.ErrorSubType = "ERROR":U
                       RowErrors.errorhelp = RETURN-VALUE.
            END.

            IF RowObject.data-inicial < TODAY THEN DO:
                CREATE RowErrors.
                ASSIGN i-sequencia = i-sequencia + 1
                       RowErrors.errorsequence = i-sequencia
                       RowErrors.errornumber   = 0
                       RowErrors.errordescription = "Data inicial anterior a atual"
                       RowErrors.errortype = "error"
                       RowErrors.ErrorSubType = "ERROR":U
                       RowErrors.errorhelp = "A data inicial deve ser maior ou igual a data atual".
            END.

            IF RowObject.data-inicial > RowObject.data-final THEN DO:
                CREATE RowErrors.
                ASSIGN i-sequencia = i-sequencia + 1
                       RowErrors.errorsequence = i-sequencia
                       RowErrors.errornumber   = 0
                       RowErrors.errordescription = "Data inicial incorreta"
                       RowErrors.errortype = "error"
                       RowErrors.ErrorSubType = "ERROR":U
                       RowErrors.errorhelp = "A data inicial deve ser menor ou igual a data final".
            END.

            IF RowObject.quantidade <= 0 THEN DO:
                CREATE RowErrors.
                ASSIGN i-sequencia = i-sequencia + 1
                       RowErrors.errorsequence = i-sequencia
                       RowErrors.errornumber   = 0
                       RowErrors.errordescription = "Quantidade incorreta"
                       RowErrors.errortype = "error"
                       RowErrors.ErrorSubType = "ERROR":U
                       RowErrors.errorhelp = "A quantidade deve ser maior que zero".
            END.

            IF CAN-FIND(FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = RowObject.es-codigo) = NO THEN DO:
                RUN utp/ut-msgs.p (INPUT "msg",
                                   INPUT 2,
                                   INPUT 'Item').
                CREATE RowErrors.
                ASSIGN i-sequencia = i-sequencia + 1
                       RowErrors.errorsequence = i-sequencia
                       RowErrors.errornumber   = 2
                       RowErrors.errordescription = RETURN-VALUE
                       RowErrors.errortype = "error"
                       RowErrors.ErrorSubType = "ERROR":U
                       RowErrors.errorhelp = RETURN-VALUE.
            END.

            IF RowObject.qtd-unitaria <= 0 THEN DO:
                CREATE RowErrors.
                ASSIGN i-sequencia = i-sequencia + 1
                       RowErrors.errorsequence = i-sequencia
                       RowErrors.errornumber   = 0
                       RowErrors.errordescription = "Quantidade unit ria incorreta"
                       RowErrors.errortype = "error"
                       RowErrors.ErrorSubType = "ERROR":U
                       RowErrors.errorhelp = "A quantidade deve ser maior que zero".
            END.

        END.
        WHEN "Update" THEN DO:
        END.
    END CASE.
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) 
    OR RowObject.es-codigo = "" THEN RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

