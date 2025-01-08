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
&GLOBAL-DEFINE DBOName BOES006
&GLOBAL-DEFINE DBOVersion 1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ae-bloqueado
&GLOBAL-DEFINE TableLabel ae-bloqueado
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
{esbo/boes006.i RowObject}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR v-ini-nr-ae     LIKE ae-bloqueado.nr-ae     NO-UNDO.
DEF VAR v-fim-nr-ae     LIKE ae-bloqueado.nr-ae     NO-UNDO.
DEF VAR v-ini-sequencia LIKE ae-bloqueado.sequencia NO-UNDO.
DEF VAR v-fim-sequencia LIKE ae-bloqueado.sequencia NO-UNDO.
DEF VAR v-ini-it-codigo LIKE ae-bloqueado.it-codigo NO-UNDO.
DEF VAR v-fim-it-codigo LIKE ae-bloqueado.it-codigo NO-UNDO.
def var v-cod-estabel as char no-undo.

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
         HEIGHT             = 1.83
         WIDTH              = 21.86.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterdeleteRecord DBOProgram 
PROCEDURE afterdeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH ae-bloqueado EXCLUSIVE-LOCK WHERE
             ae-bloqueado.cod-estabel = v-cod-estabel and
             ae-bloqueado.nr-ae     = {&TableName}.nr-ae:     /*     AND
             ae-bloqueado.it-codigo = {&TableName}.it-codigo: */
        DELETE ae-bloqueado.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Bloqueio-AE DBOProgram 
PROCEDURE Bloqueio-AE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pi-cod-estabel as char no-undo.
    DEF INPUT PARAM p-nr-ae         LIKE ae-bloqueado.nr-ae        NO-UNDO.   
    DEF INPUT PARAM p-sequencia-ini LIKE ae-bloqueado.sequencia    NO-UNDO.
    DEF INPUT PARAM p-sequencia-fim LIKE ae-bloqueado.sequencia    NO-UNDO.
    DEF INPUT PARAM p-narrativa-1   LIKE ae-bloqueado.narrativa[1] NO-UNDO.
    DEF INPUT PARAM p-narrativa-2   LIKE ae-bloqueado.narrativa[2] NO-UNDO.
    DEF INPUT PARAM p-narrativa-3   LIKE ae-bloqueado.narrativa[3] NO-UNDO.
    DEF INPUT PARAM p-narrativa-4   LIKE ae-bloqueado.narrativa[4] NO-UNDO.
    DEF VAR i AS INT.

    FOR EACH ae-item NO-LOCK WHERE 
             ae-item.cod-estabel = pi-cod-estabel and
             ae-item.nr-ae      = p-nr-ae         AND
             ae-item.sequencia >= p-sequencia-ini AND
             ae-item.sequencia <= p-sequencia-fim AND
             ae-item.situacao  =  NO:        
        IF CAN-FIND(FIRST ae-bloqueado                          WHERE
                    ae-bloqueado.cod-estabel = ae-item.cod-estabel and
                    ae-bloqueado.nr-ae = ae-item.nr-ae          AND 
                    ae-bloqueado.sequencia = ae-item.sequencia) THEN DO:
            MESSAGE "Algum(s) item(s) desta sequància j† esta(m) bloqueado(s)" VIEW-AS ALERT-BOX INFO BUTTONS OK.
            NEXT.   
        END.
        CREATE ae-bloqueado.            
        ASSIGN ae-bloqueado.cod-estabel = ae-item.cod-estabel 
               ae-bloqueado.nr-ae     = p-nr-ae
               ae-bloqueado.it-codigo = ae-item.it-codigo
               ae-bloqueado.sequencia = ae-item.sequencia
               ae-bloqueado.narrativa[1] = p-narrativa-1
               ae-bloqueado.narrativa[2] = p-narrativa-2
               ae-bloqueado.narrativa[3] = p-narrativa-3
               ae-bloqueado.narrativa[4] = p-narrativa-4.
         CREATE RowObject.
         BUFFER-COPY ae-bloqueado TO RowObject.
         RowObject.r-rowid = ROWID(ae-bloqueado).
    END.

    RUN openQueryMain.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(ae-bloqueado)).
        IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estabel":U  THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "it-codigo":U    THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "narrativa[1]":U THEN ASSIGN pFieldValue = RowObject.narrativa[1].
        WHEN "narrativa[2]":U THEN ASSIGN pFieldValue = RowObject.narrativa[2].
        WHEN "narrativa[3]":U THEN ASSIGN pFieldValue = RowObject.narrativa[3].
        WHEN "narrativa[4]":U THEN ASSIGN pFieldValue = RowObject.narrativa[4].
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
        WHEN "nr-ae":U THEN ASSIGN pFieldValue = RowObject.nr-ae.
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
  Purpose:     Retorna valores dos campos do °ndice ae
  Parameters:  
               retorna valor do campo nr-ae
               retorna valor do campo sequencia
               retorna valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel    LIKE ae-bloqueado.cod-estabel       NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-ae          LIKE ae-bloqueado.nr-ae             NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia      LIKE ae-bloqueado.sequencia         NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo      LIKE ae-bloqueado.it-codigo         NO-UNDO.    
    

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-ae       = RowObject.nr-ae           
           psequencia   = RowObject.sequencia
           pit-codigo   = RowObject.it-codigo.
           

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
  Purpose:     Reposiciona registro com base no °ndice ae
  Parameters:  
               recebe valor do campo nr-ae
               recebe valor do campo sequencia
               recebe valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input PARAMETER pi-cod-estabel   as char                     no-undo.
    DEFINE INPUT PARAMETER pnr-ae           LIKE ae-bloqueado.nr-ae     NO-UNDO.
    DEFINE INPUT PARAMETER psequencia       LIKE ae-bloqueado.sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo       LIKE ae-bloqueado.it-codigo NO-UNDO.    
    


    FIND FIRST bfae-bloqueado WHERE 
               bfae-bloqueado.cod-estabel = pi-cod-estabel  and
               bfae-bloqueado.nr-ae       = pnr-ae          AND 
               bfae-bloqueado.sequencia   = psequencia      AND
               bfae-bloqueado.it-codigo   = pit-codigo      NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfae-bloqueado THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfae-bloqueado)).
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
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
    where {&TableName}.cod-estabel = v-cod-estabel.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCod DBOProgram 
PROCEDURE openQueryByCod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
     {&TableName}.cod-estabel = v-cod-estabel and
     {&TableName}.nr-ae     >= v-ini-nr-ae     AND
     {&TableName}.nr-ae     <= v-fim-nr-ae     AND
     {&TableName}.sequencia >= v-ini-sequencia AND
     {&TableName}.sequencia <= v-fim-sequencia AND
     {&TableName}.it-codigo >= v-ini-it-codigo AND
     {&TableName}.it-codigo <= v-fim-it-codigo.
     

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

OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
    where {&TableName}.cod-estabel = v-cod-estabel. 
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByCod DBOProgram 
PROCEDURE setConstraintByCod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pi-cod-estabel as char no-undo.
    DEF INPUT PARAM p-ini-nr-ae      LIKE ae-bloqueado.nr-ae     NO-UNDO.
    DEF INPUT PARAM p-fim-nr-ae      LIKE ae-bloqueado.nr-ae     NO-UNDO.
    DEF INPUT PARAM p-ini-sequencia  LIKE ae-bloqueado.sequencia NO-UNDO.
    DEF INPUT PARAM p-fim-sequencia  LIKE ae-bloqueado.sequencia NO-UNDO.
    DEF INPUT PARAM p-ini-it-codigo  LIKE ae-bloqueado.it-codigo NO-UNDO.
    DEF INPUT PARAM p-fim-it-codigo  LIKE ae-bloqueado.it-codigo NO-UNDO.
    

    ASSIGN v-cod-estabel   = pi-cod-estabel
           v-ini-nr-ae     = p-ini-nr-ae
           v-fim-nr-ae     = p-fim-nr-ae
           v-ini-sequencia = p-ini-sequencia
           v-fim-sequencia = p-fim-sequencia
           v-ini-it-codigo = p-ini-it-codigo
           v-fim-it-codigo = p-fim-it-codigo.
           

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
    def input param pi-cod-estabel as char no-undo.

    ASSIGN v-cod-estabel   = pi-cod-estabel.
    
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
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    DEFINE VAR i-sequencia AS INTEGER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    

    IF pType = "Create" THEN DO:
        IF CAN-FIND(bf{&TableName}
            WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel and
                  bf{&TableName}.nr-ae     = RowObject.nr-ae      AND
                  bf{&TableName}.sequencia = RowObject.sequencia) AND
                  bf{&TableName}.it-codigo = RowObject.it-codigo  THEN DO:
            {method/svc/errors/inserr.i
            &ErrorNumber="2"
            &ErrorType="outros"
            &ErrorSubType="ERROR"
            &ErrorDescription="Este registro j† foi cadastrado no sistema."}
        END.
        IF CAN-FIND(bf{&TableName}
            WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel and
                  bf{&TableName}.nr-ae     = 0   AND
                  bf{&TableName}.sequencia = 0   AND
                  bf{&TableName}.it-codigo = "")  THEN DO:
            {method/svc/errors/inserr.i
            &ErrorNumber="2"
            &ErrorType="outros"
            &ErrorSubType="ERROR"
            &ErrorDescription="ê obrigat¢rio preencher os campos: Nr AE, Item e Sequància."}
        END.
        RUN setRecord IN THIS-PROCEDURE (INPUT TABLE RowObject).
    END.


    /*RUN createRecord IN THIS-PROCEDURE.    */    


    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

