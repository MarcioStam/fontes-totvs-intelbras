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
&GLOBAL-DEFINE DBOName BOES115
&GLOBAL-DEFINE DBOVersion 1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-tipo-loc
&GLOBAL-DEFINE TableLabel item-tipo-loc 
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
{esbo/boes115.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/* DEF INPUT PARAMETER vant-entreposto AS CHAR. */

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
def var v-ini-it-codigo like {&TableName}.it-codigo no-undo.
def var v-fim-it-codigo like {&TableName}.it-codigo no-undo.
def var v-ini-cod-estabel like {&TableName}.cod-estabel no-undo.
def var v-fim-cod-estabel like {&TableName}.cod-estabel no-undo.
def var v-ini-cod-depos like {&TableName}.cod-depos no-undo.
def var v-fim-cod-depos like {&TableName}.cod-depos no-undo.
def var v-ini-sequencia like {&TableName}.sequencia no-undo.
def var v-fim-sequencia like {&TableName}.sequencia no-undo.
def var v-ini-cod-tipo  like {&TableName}.cod-tipo  no-undo.
def var v-fim-cod-tipo  like {&TableName}.cod-tipo  no-undo.

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
         HEIGHT             = 10.58
         WIDTH              = 27.57.
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
               recebe it-codigo do campo
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
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.

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
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "qtd-comp":U THEN ASSIGN pFieldValue = RowObject.qtd-comp.
        WHEN "qt-max-entreposto":U THEN ASSIGN pFieldValue = RowObject.qt-max-entreposto.
        WHEN "qt-seg-entreposto":U THEN ASSIGN pFieldValue = RowObject.qt-seg-entreposto.
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
        WHEN "cod-tipo":U THEN ASSIGN pFieldValue = RowObject.cod-tipo.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo cd-oper
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-it-codigo like {&TableName}.it-codigo no-undo.
    def output param p-cod-estabel like {&TableName}.cod-estabel no-undo.
    def output param p-cod-depos like {&TableName}.cod-depos no-undo.
    def output param p-sequencia like {&TableName}.sequencia no-undo.
    def output param p-cod-tipo  like {&TableName}.cod-tipo  no-undo.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN p-it-codigo = RowObject.it-codigo
           p-cod-estabel = RowObject.cod-estabel    
           p-cod-depos = RowObject.cod-depos
           p-sequencia = RowObject.sequencia
           p-cod-tipo  = RowObject.cod-tipo.

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
        WHEN "mistura":U THEN ASSIGN pFieldValue = RowObject.mistura.
        WHEN "compartilha":U THEN ASSIGN pFieldValue = RowObject.compartilha.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextSequence DBOProgram 
PROCEDURE getNextSequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-it-codigo LIKE {&TableName}.it-codigo NO-UNDO.
    DEF INPUT PARAM p-cod-estabel LIKE {&TableName}.cod-estabel NO-UNDO.
    DEF INPUT PARAM p-cod-depos LIKE {&TableName}.cod-depos NO-UNDO.
    DEF INPUT PARAM p-cod-tipo LIKE {&TableName}.cod-tipo NO-UNDO.
    DEF OUTPUT PARAM p-sequencia LIKE {&TableName}.sequencia NO-UNDO.

    FIND LAST {&TableName} NO-LOCK
        WHERE {&TableName}.it-codigo = p-it-codigo
        AND   {&TableName}.cod-estabel = p-cod-estabel
        AND   {&TableName}.cod-depos = p-cod-depos
        AND   {&TableName}.cod-tipo = p-cod-tipo NO-ERROR.
    IF AVAIL {&TableName} THEN
        p-sequencia = {&TableName}.sequencia + 10.
    ELSE p-sequencia = 10.

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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cd-oper
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-it-codigo like {&TableName}.it-codigo no-undo.
    def input param p-cod-estabel like {&TableName}.cod-estabel no-undo.
    def input param p-cod-depos like {&TableName}.cod-depos no-undo.
    def input param p-sequencia like {&TableName}.sequencia no-undo.
    def input param p-cod-tipo  like {&TableName}.cod-tipo  no-undo.

    FIND FIRST bf{&TableName} 
        WHERE bf{&TableName}.it-codigo    = p-it-codigo
        AND   bf{&TableName}.cod-estabel  = p-cod-estabel
        AND   bf{&TableName}.cod-depos    = p-cod-depos
        AND   bf{&TableName}.sequencia    = p-sequencia
        AND   bf{&TableName}.cod-tipo     = p-cod-tipo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bf{&TableName} THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
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

OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX sequencia
    indexed-reposition.
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

OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX sequencia
    indexed-reposition.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySequencia DBOProgram 
PROCEDURE openQuerySequencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  open query qr{&tableName} for each {&tableName}
       where {&tableName}.it-codigo    >= v-ini-it-codigo
         AND {&tableName}.it-codigo    <= v-fim-it-codigo 
         and {&tableName}.cod-estabel  >= v-ini-cod-estabel
         and {&tableName}.cod-estabel  <= v-fim-cod-estabel
         and {&tableName}.cod-depos    >= v-ini-cod-depos
         and {&tableName}.cod-depos    <= v-fim-cod-depos
         and {&tableName}.sequencia    >= v-ini-sequencia
         and {&tableName}.sequencia    <= v-fim-sequencia
         and {&tableName}.cod-tipo     >= v-ini-cod-tipo
         and {&tableName}.cod-tipo     <= v-fim-cod-tipo
         no-lock 
         indexed-reposition.
         
         
  return "OK":U.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSequencia DBOProgram 
PROCEDURE setConstraintSequencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-ini-it-codigo like {&TableName}.it-codigo no-undo.
    def input param p-fim-it-codigo like {&TableName}.it-codigo no-undo.
    def input param p-ini-cod-estabel like {&TableName}.cod-estabel no-undo.
    def input param p-fim-cod-estabel like {&TableName}.cod-estabel no-undo.
    def input param p-ini-cod-depos like {&TableName}.cod-depos no-undo.
    def input param p-fim-cod-depos like {&TableName}.cod-depos no-undo.
    def input param p-ini-sequencia like {&TableName}.sequencia no-undo.
    def input param p-fim-sequencia like {&TableName}.sequencia no-undo.
    def input param p-ini-cod-tipo  like {&TableName}.cod-tipo  no-undo.
    def input param p-fim-cod-tipo  like {&TableName}.cod-tipo  no-undo.

    assign v-ini-it-codigo = p-ini-it-codigo
           v-fim-it-codigo = p-fim-it-codigo
           v-ini-cod-estabel = p-ini-cod-estabel
           v-fim-cod-estabel = p-fim-cod-estabel
           v-ini-cod-depos = p-ini-cod-depos
           v-fim-cod-depos = p-fim-cod-depos
           v-ini-sequencia = p-ini-sequencia
           v-fim-sequencia = p-fim-sequencia
           v-ini-cod-tipo  = p-ini-cod-tipo 
           v-fim-cod-tipo  = p-fim-cod-tipo. 

    return "OK":U.
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
    DEF VAR i-sequencia AS INTEGER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    CASE pType:
        WHEN "Create" THEN DO:

            IF NOT CAN-FIND(FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = RowObject.it-codigo) THEN DO:
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

            IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                            WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
                RUN utp/ut-msgs.p (INPUT "msg",
                                   INPUT 2,
                                   INPUT 'Estabelecimento').
                CREATE RowErrors.
                ASSIGN i-sequencia = i-sequencia + 1
                       RowErrors.errorsequence = i-sequencia
                       RowErrors.errornumber   = 2
                       RowErrors.errordescription = RETURN-VALUE
                       RowErrors.errortype = "error"
                       RowErrors.ErrorSubType = "ERROR":U
                       RowErrors.errorhelp = RETURN-VALUE.
            END.
            
            IF NOT CAN-FIND(FIRST deposito NO-LOCK
                        WHERE deposito.cod-depos = RowObject.cod-depos) THEN DO:
                RUN utp/ut-msgs.p (INPUT "msg",
                                   INPUT 2,
                                   INPUT 'Dep¢sito').
                CREATE RowErrors.
                ASSIGN i-sequencia = i-sequencia + 1
                       RowErrors.errorsequence = i-sequencia
                       RowErrors.errornumber   = 2
                       RowErrors.errordescription = RETURN-VALUE
                       RowErrors.errortype = "error"
                       RowErrors.ErrorSubType = "ERROR":U
                       RowErrors.errorhelp = RETURN-VALUE.
            END.

            IF NOT CAN-FIND(FIRST tipo-local NO-LOCK
                            WHERE tipo-local.cod-estabel = RowObject.cod-estabel
                              and tipo-local.cod-tipo = RowObject.cod-tipo) THEN DO:
                RUN utp/ut-msgs.p (INPUT "msg",
                                   INPUT 2,
                                   INPUT 'Tipo Local').
                CREATE RowErrors.
                ASSIGN i-sequencia = i-sequencia + 1
                       RowErrors.errorsequence = i-sequencia
                       RowErrors.errornumber   = 2
                       RowErrors.errordescription = RETURN-VALUE
                       RowErrors.errortype = "error"
                       RowErrors.ErrorSubType = "ERROR":U
                       RowErrors.errorhelp = RETURN-VALUE.
            END.

            IF CAN-FIND(FIRST {&TableName} NO-LOCK
                        WHERE {&TableName}.it-codigo   = RowObject.it-codigo
                        AND   {&TableName}.cod-estabel = RowObject.cod-estabel
                        AND   {&TableName}.cod-depos   = RowObject.cod-depos
                        AND   {&TableName}.sequencia   = RowObject.sequencia
                        AND   {&TableName}.cod-tipo    = RowObject.cod-tipo) THEN DO:
                RUN utp/ut-msgs.p (INPUT "msg",
                                   INPUT 1,
                                   INPUT 'Item-Tipo Localizaá∆o').
                CREATE RowErrors.
                ASSIGN i-sequencia = i-sequencia + 1
                       RowErrors.errorsequence = i-sequencia
                       RowErrors.errornumber   = 1
                       RowErrors.errordescription = RETURN-VALUE
                       RowErrors.errortype = "error"
                       RowErrors.ErrorSubType = "ERROR":U
                       RowErrors.errorhelp = RETURN-VALUE.
            END.

            IF RowObject.quantidade = 0 THEN DO:
                CREATE RowErrors.
                ASSIGN i-sequencia = i-sequencia + 1
                       RowErrors.errorsequence = i-sequencia
                       RowErrors.errornumber   = 0
                       RowErrors.errordescription = "Quantidade incorreta"
                       RowErrors.errortype = "error"
                       RowErrors.ErrorSubType = "ERROR":U
                       RowErrors.errorhelp = "A quantidade deve ser informada".
            END.

            IF RowObject.local-entreposto <> "" THEN DO:
                FIND FIRST local WHERE local.cod-estabel = RowObject.cod-estabel AND
                                       local.cod-depos   = RowObject.cod-depos   AND
                                       local.localizacao = RowObject.local-entreposto NO-LOCK NO-ERROR.
                IF AVAIL local AND local.entreposto = NO THEN DO:
                    CREATE RowErrors.
                    ASSIGN i-sequencia = i-sequencia + 1
                           RowErrors.errorsequence = i-sequencia
                           RowErrors.errornumber   = 0
                           RowErrors.errordescription = "Local informado n∆o Ç de entreposto."
                           RowErrors.errortype = "error"
                           RowErrors.ErrorSubType = "ERROR":U
                           RowErrors.errorhelp = "Local deve ser entreposto".
                END.
                IF NOT AVAIL local THEN DO:
                    CREATE RowErrors.
                    ASSIGN i-sequencia = i-sequencia + 1
                           RowErrors.errorsequence = i-sequencia
                           RowErrors.errornumber   = 0
                           RowErrors.errordescription = "Local n∆o cadastrado."
                           RowErrors.errortype = "error"
                           RowErrors.ErrorSubType = "ERROR":U
                           RowErrors.errorhelp = "Local n∆o cadastrado".
                END.

                FIND FIRST bf{&TableName} 
                     WHERE bf{&TableName}.it-codigo = RowObject.it-codigo
                       AND bf{&TableName}.cod-estabel      = RowObject.cod-estabel
                       AND bf{&TableName}.cod-depos        = RowObject.cod-depos 
                       AND bf{&TableName}.local-entreposto <> ""  NO-LOCK NO-ERROR.
                IF AVAIL bf{&TableName} THEN DO:
                    CREATE RowErrors.
                    ASSIGN i-sequencia = i-sequencia + 1
                           RowErrors.errorsequence = i-sequencia
                           RowErrors.errornumber   = 0
                           RowErrors.errordescription = "Item j† possui local de entreposto."
                           RowErrors.errortype = "error"
                           RowErrors.ErrorSubType = "ERROR":U
                           RowErrors.errorhelp = "Local de entreposto deste item esta no tipo " +
                                                  STRING(bf{&TableName}.cod-tipo) + " Local " + 
                                                  bf{&TableName}.local-entreposto.
                END.

            END.

        END.
        WHEN "Update" THEN DO:
            IF RowObject.local-entreposto <> "" THEN DO:
                FIND FIRST local WHERE local.cod-estabel = RowObject.cod-estabel AND
                                       local.cod-depos   = RowObject.cod-depos   AND
                                       local.localizacao = RowObject.local-entreposto NO-LOCK NO-ERROR.
                IF AVAIL local AND local.entreposto = NO THEN DO:
                    CREATE RowErrors.
                    ASSIGN i-sequencia = i-sequencia + 1
                           RowErrors.errorsequence = i-sequencia
                           RowErrors.errornumber   = 0
                           RowErrors.errordescription = "Local informado n∆o Ç de entreposto."
                           RowErrors.errortype = "error"
                           RowErrors.ErrorSubType = "ERROR":U
                           RowErrors.errorhelp = "Local deve ser entreposto".
                END.
                IF NOT AVAIL local THEN DO:
                    CREATE RowErrors.
                    ASSIGN i-sequencia = i-sequencia + 1
                           RowErrors.errorsequence = i-sequencia
                           RowErrors.errornumber   = 0
                           RowErrors.errordescription = "Local n∆o cadastrado."
                           RowErrors.errortype = "error"
                           RowErrors.ErrorSubType = "ERROR":U
                           RowErrors.errorhelp = "Local n∆o cadastrado".
                END.
                
                FIND FIRST bf{&TableName} 
                     WHERE bf{&TableName}.it-codigo        = RowObject.it-codigo
                       AND bf{&TableName}.cod-estabel      = RowObject.cod-estabel
                       AND bf{&TableName}.cod-depos        = RowObject.cod-depos
                       AND bf{&TableName}.local-entreposto <> ""
                      /* AND bf{&TableName}.local-entreposto <> RowObject.local-entreposto */ NO-LOCK NO-ERROR.
                IF AVAIL bf{&TableName} AND ROWID(bf{&TableName}) <> RowObject.r-rowid  THEN DO:
                    CREATE RowErrors.
                    ASSIGN i-sequencia = i-sequencia + 1
                           RowErrors.errorsequence = i-sequencia
                           RowErrors.errornumber   = 0
                           RowErrors.errordescription = "Item j† possui local de entreposto."
                           RowErrors.errortype = "error"
                           RowErrors.ErrorSubType = "ERROR":U
                           RowErrors.errorhelp = "Local de entreposto deste item esta no tipo " +
                                                  STRING(bf{&TableName}.cod-tipo) + " Local " + 
                                                  bf{&TableName}.local-entreposto.
                END.
                
            END.

        END.
        WHEN "Delete" THEN DO:
            IF can-find(first item-local no-lock            
                        where item-local.it-codigo = RowObject.it-codigo 
                        and   item-local.cod-estabel = RowObject.cod-estabel
                        and   item-local.cod-tipo  = RowObject.cod-tipo) THEN DO:
                RUN _insertErrorManual 
                    (INPUT 0,
                     INPUT "EMS",
                     INPUT "ERROR",
                     INPUT "Existe localizaá∆o com saldo para este item/tipo",
                     INPUT "Existe localizaá∆o com saldo para este item/tipo",
                     INPUT "").
            END.
        END.
    END CASE.
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

