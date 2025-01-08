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
&GLOBAL-DEFINE DBOName BOES222
&GLOBAL-DEFINE DBOVersion 2.00.04.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName acomp-projeto
&GLOBAL-DEFINE TableLabel acomp-projeto
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
{esbo/boes222.i RowObject}
{esp/es0018.i}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR v-ini-cod-ccusto        AS CHAR NO-UNDO.
DEF VAR v-fim-cod-ccusto        AS CHAR NO-UNDO.
DEF VAR v-ini-cod-unid-negoc    AS CHAR NO-UNDO.
DEF VAR v-fim-cod-unid-negoc    AS CHAR NO-UNDO.
DEF VAR v-ini-cod-usuario       AS CHAR NO-UNDO.
DEF VAR v-fim-cod-usuario       AS CHAR NO-UNDO.
DEF VAR v-ini-periodo           AS CHAR NO-UNDO.
DEF VAR v-fim-periodo           AS CHAR NO-UNDO.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)"
    label "Empresa"
    column-label "Empresa"
    no-undo.

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
         HEIGHT             = 17
         WIDTH              = 47.14.
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
        WHEN "cod-ccusto":U THEN ASSIGN pFieldValue = RowObject.cod-ccusto.
        WHEN "cod-usuario":U THEN ASSIGN pFieldValue = RowObject.cod-usuario.
        WHEN "cod-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
        WHEN "atividade":U THEN ASSIGN pFieldValue = RowObject.atividade.
        WHEN "periodo":U THEN ASSIGN pFieldValue = RowObject.periodo.
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
        WHEN "horas-comp":U THEN ASSIGN pFieldValue = RowObject.horas-comp.
        WHEN "horas-normais":U THEN ASSIGN pFieldValue = RowObject.horas-normais.
        WHEN "horas-outras":U THEN ASSIGN pFieldValue = RowObject.horas-outras.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHorasNormais DBOProgram 
PROCEDURE getHorasNormais :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna os totais das horas
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-unid-negoc    AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-ccusto        AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-periodo           AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-horas-normais     AS DECIMAL   NO-UNDO.

    ASSIGN p-horas-normais = 0
           p-periodo       = REPLACE(p-periodo,"/","").

    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.cod-unid-negoc = p-cod-unid-negoc
         AND bf{&TableName}.cod-ccusto     = p-cod-ccusto
         AND bf{&TableName}.periodo        = p-periodo:

        ASSIGN p-horas-normais = p-horas-normais + bf{&TableName}.horas-normais.
    END.

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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice acomp-projeto
  Parameters:  
               retorna valor do campo cod-projeto
               retorna valor do campo cod-usuario
               retorna valor do campo periodo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-unid-negoc LIKE acomp-projeto.cod-unid-negoc NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-ccusto LIKE acomp-projeto.cod-ccusto NO-UNDO.        
    DEFINE OUTPUT PARAMETER pcod-usuario LIKE acomp-projeto.cod-usuario NO-UNDO.
    DEFINE OUTPUT PARAMETER pperiodo LIKE acomp-projeto.periodo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-ccusto = RowObject.cod-ccusto
           pcod-unid-negoc = RowObject.cod-unid-negoc
           pcod-usuario = RowObject.cod-usuario
           pperiodo = RowObject.periodo.

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
        WHEN "congelado":U THEN ASSIGN pFieldValue = RowObject.congelado.
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
  Purpose:     Reposiciona registro com base no °ndice acomp-projeto
  Parameters:  
               recebe valor do campo cod-projeto
               recebe valor do campo cod-usuario
               recebe valor do campo periodo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-unid-negoc  LIKE acomp-projeto.cod-unid-negoc NO-UNDO.
    DEFINE INPUT PARAMETER pcod-ccusto      LIKE acomp-projeto.cod-ccusto NO-UNDO.        
    DEFINE INPUT PARAMETER pcod-usuario     LIKE acomp-projeto.cod-usuario NO-UNDO.
    DEFINE INPUT PARAMETER pperiodo         LIKE acomp-projeto.periodo     NO-UNDO.

    FIND FIRST bfacomp-projeto WHERE                 
        bfacomp-projeto.cod-unid-negoc = pcod-unid-negoc AND
        bfacomp-projeto.cod-ccusto     = pcod-ccusto AND 
        bfacomp-projeto.cod-usuario    = pcod-usuario AND 
        bfacomp-projeto.periodo        = pperiodo     NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfacomp-projeto THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfacomp-projeto)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCod DBOProgram 
PROCEDURE openQueryByCod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY  {&QueryName} FOR EACH {&TableName} NO-LOCK     WHERE
            {&TableName}.cod-unid-negoc >= v-ini-cod-unid-negoc AND
            {&TableName}.cod-unid-negoc <= v-fim-cod-unid-negoc AND
            {&TableName}.cod-ccusto >= v-ini-cod-ccusto  AND
            {&TableName}.cod-ccusto <= v-fim-cod-ccusto  AND
            {&TableName}.cod-usuario >= v-ini-cod-usuario  AND
            {&TableName}.cod-usuario <= v-fim-cod-usuario  AND
            STRING(SUBSTRING({&TableName}.periodo,3,4),"9999") + STRING(SUBSTRING({&TableName}.periodo,1,2),"99") >= STRING(SUBSTRING(v-ini-periodo,3,4),"9999") + STRING(SUBSTRING(v-ini-periodo,1,2),"99") AND
            STRING(SUBSTRING({&TableName}.periodo,3,4),"9999") + STRING(SUBSTRING({&TableName}.periodo,1,2),"99") <= STRING(SUBSTRING(v-fim-periodo,3,4),"9999") + STRING(SUBSTRING(v-fim-periodo,1,2),"99")
    /*by {&TableName}.cod-projeto
    by {&TableName}.cod-usuario        
    by substr({&TableName}.periodo,3,4)
    by substr({&TableName}.periodo,1,2)*/ .
                
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaTotaisHoras DBOProgram 
PROCEDURE retornaTotaisHoras :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna os totais das horas
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-horas-normais AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER p-horas-compl   AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER p-horas-outras  AS DECIMAL NO-UNDO.

    ASSIGN p-horas-normais = 0
           p-horas-compl   = 0
           p-horas-outras  = 0.

    FOR EACH bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.cod-unid-negoc >= v-ini-cod-unid-negoc
         AND bf{&TableName}.cod-unid-negoc <= v-fim-cod-unid-negoc
         AND bf{&TableName}.cod-ccusto >= v-ini-cod-ccusto
         AND bf{&TableName}.cod-ccusto <= v-fim-cod-ccusto
         AND bf{&TableName}.cod-usuario >= v-ini-cod-usuario
         AND bf{&TableName}.cod-usuario <= v-fim-cod-usuario
         AND STRING(SUBSTRING(bf{&TableName}.periodo,3,4),"9999") + STRING(SUBSTRING(bf{&TableName}.periodo,1,2),"99") >= STRING(SUBSTRING(v-ini-periodo,3,4),"9999") + STRING(SUBSTRING(v-ini-periodo,1,2),"99") 
         AND STRING(SUBSTRING(bf{&TableName}.periodo,3,4),"9999") + STRING(SUBSTRING(bf{&TableName}.periodo,1,2),"99") <= STRING(SUBSTRING(v-fim-periodo,3,4),"9999") + STRING(SUBSTRING(v-fim-periodo,1,2),"99"):

        ASSIGN p-horas-normais = p-horas-normais + bf{&TableName}.horas-normais
               p-horas-compl   = p-horas-compl   + bf{&TableName}.horas-comp
               p-horas-outras  = p-horas-outras  + bf{&TableName}.horas-outras.

    END.

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

    DEF INPUT PARAM p-ini-cod-unid-negoc LIKE acomp-projeto.cod-unid-negoc NO-UNDO.
    DEF INPUT PARAM p-fim-cod-unid-negoc LIKE acomp-projeto.cod-unid-negoc NO-UNDO.
    DEF INPUT PARAM p-ini-cod-ccusto LIKE acomp-projeto.cod-ccusto  NO-UNDO.
    DEF INPUT PARAM p-fim-cod-ccusto LIKE acomp-projeto.cod-ccusto  NO-UNDO.
    DEF INPUT PARAM p-ini-cod-usuario LIKE acomp-projeto.cod-usuario  NO-UNDO.
    DEF INPUT PARAM p-fim-cod-usuario LIKE acomp-projeto.cod-usuario  NO-UNDO.
    DEF INPUT PARAM p-ini-periodo     LIKE acomp-projeto.periodo      NO-UNDO.
    DEF INPUT PARAM p-fim-periodo     LIKE acomp-projeto.periodo      NO-UNDO.


    ASSIGN v-ini-cod-ccusto = p-ini-cod-ccusto
           v-fim-cod-ccusto = p-fim-cod-ccusto
           v-ini-cod-unid-negoc = p-ini-cod-unid-negoc
           v-fim-cod-unid-negoc = p-fim-cod-unid-negoc
           v-ini-cod-usuario = p-ini-cod-usuario
           v-fim-cod-usuario = p-fim-cod-usuario
           v-ini-periodo     = p-ini-periodo
           v-fim-periodo     = p-fim-periodo.

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
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE de-horas-normais AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-msg-erro       AS CHARACTER   NO-UNDO.

    RUN esp\es0018p.p (INPUT "esenp004",
                       INPUT 2,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
    FIND FIRST tt-prog-ponto NO-ERROR.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/

    /*:T--- Inclua aqui as validaá‰es ---*/    
    IF pType = "Create" THEN DO:

        IF CAN-FIND(FIRST periodo-acomp-projeto
                    WHERE periodo-acomp-projeto.periodo = RowObject.periodo
                    AND   periodo-acomp-projeto.log-congelado = YES) THEN DO:
        
           {method/svc/errors/inserr.i
           &ErrorNumber="2"
           &ErrorType="outros"
           &ErrorSubType="ERROR"
           &ErrorDescription="Este per°odo j† foi congelado."}
        
        END.

        IF RowObject.cod-ccusto = "0" OR
           RowObject.cod-unid-negoc = "" OR
           RowObject.cod-usuario = "" OR
           RowObject.periodo     = "" THEN DO:
             {method/svc/errors/inserr.i
             &ErrorNumber="2"
             &ErrorType="outros"
             &ErrorSubType="ERROR"
             &ErrorDescription="ê obrigat¢rio preencher os campos: C¢digo do projeto, C¢digo do usu†rio e Per°odo!"}
        END.        

        IF CAN-FIND(bf{&TableName}
            WHERE bf{&TableName}.cod-unid-negoc = RowObject.cod-unid-negoc AND
                  bf{&TableName}.cod-ccusto     = RowObject.cod-ccusto AND
                  bf{&TableName}.cod-usuario    = RowObject.cod-usuario AND
                  bf{&TableName}.periodo        = RowObject.periodo)    THEN DO:
            {method/svc/errors/inserr.i
            &ErrorNumber="2"
            &ErrorType="outros"
            &ErrorSubType="ERROR"
            &ErrorDescription="Este registro j† foi cadastrado no sistema."}
        END.

        IF INT(SUBSTRING(RowObject.periodo,3,4)) < 2003 THEN DO:
            {method/svc/errors/inserr.i
            &ErrorNumber="2"
            &ErrorType="outros"
            &ErrorSubType="ERROR"
            &ErrorDescription="Ano informado inv†lido."}        
        END.

        IF RowObject.horas-comp    = 0 AND
           RowObject.horas-normais = 0 THEN DO:
            {method/svc/errors/inserr.i
            &ErrorNumber="2"
            &ErrorType="outros"
            &ErrorSubType="ERROR"
            &ErrorDescription="Obrigat¢rio informar horas trabalhadas."}                                           
        END.

        IF NOT CAN-FIND(FIRST emscad.ccusto NO-LOCK
                        WHERE emscad.ccusto.cod_ccusto = RowObject.cod-ccusto) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Centro de Custo'"}
        END.

        IF NOT CAN-FIND(FIRST emscad.ccusto NO-LOCK
                        WHERE emscad.ccusto.cod_ccusto      = RowObject.cod-ccusto
                          AND emscad.ccusto.dat_inic_valid <= TODAY
                          AND emscad.ccusto.dat_fim_valid  >= TODAY)  THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Centro de Custo fora da faixa de validade.'"}
        END.

        IF NOT can-find(FIRST unid_negoc NO-LOCK
                        WHERE unid_negoc.cod_unid_negoc = RowObject.cod-unid-negoc) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Unidade de Neg¢cio'"}
        END.
        
        IF NOT can-find(FIRST emscad.ccusto_unid_negoc NO-LOCK
                        WHERE emscad.ccusto_unid_negoc.cod_empresa    = v_cod_empres_usuar
                        AND   emscad.ccusto_unid_negoc.cod_ccusto     = RowObject.cod-ccusto 
                        AND   emscad.ccusto_unid_negoc.cod_unid_negoc = RowObject.cod-unid-negoc) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Centro de Custo n∆o relacionado a Unidade de Neg¢cio informada.'"}



        END.


        ASSIGN de-horas-normais = 0.
        FOR EACH bf{&TableName} NO-LOCK
           WHERE bf{&TableName}.cod-usuario = RowObject.cod-usuario
             AND bf{&TableName}.periodo     = RowObject.periodo:

            ASSIGN de-horas-normais = de-horas-normais + bf{&TableName}.horas-normais.
        END.

        IF de-horas-normais + RowObject.horas-normais > DECIMAL(tt-prog-ponto.conteudo) THEN DO:
            ASSIGN c-msg-erro = "Horas normais inv†lidas~~Total de horas do Colaborador e per°odo ultrapassou limite de " + tt-prog-ponto.conteudo + " horas!".

            {method/svc/errors/inserr.i
            &ErrorNumber="17006"
            &ErrorType="outros"
            &ErrorSubType="ERROR"
            &ErrorParameters=c-msg-erro}
        END.

        RUN setRecord IN THIS-PROCEDURE (INPUT TABLE RowObject).

    END.


    IF pType = "Update" THEN DO:   

        IF RowObject.horas-comp     = 0 AND
           RowObject.horas-normais  = 0 THEN DO:
            {method/svc/errors/inserr.i
            &ErrorNumber="2"
            &ErrorType="outros"
            &ErrorSubType="ERROR"
            &ErrorDescription="Obrigat¢rio informar horas trabalhadas."}                                           
        END.
        
        ASSIGN de-horas-normais = 0.
        FOR EACH bf{&TableName} NO-LOCK
           WHERE bf{&TableName}.cod-usuario = RowObject.cod-usuario
             AND bf{&TableName}.periodo     = RowObject.periodo
             AND ROWID(bf{&TableName})     <> RowObject.r-rowid:

            ASSIGN de-horas-normais = de-horas-normais + bf{&TableName}.horas-normais.
        END.

        IF de-horas-normais + RowObject.horas-normais > DECIMAL(tt-prog-ponto.conteudo) THEN DO:
            ASSIGN c-msg-erro = "Horas normais inv†lidas~~Total de horas do Colaborador e per°odo ultrapassou limite de " + tt-prog-ponto.conteudo + " horas!".

            {method/svc/errors/inserr.i
            &ErrorNumber="17006"
            &ErrorType="outros"
            &ErrorSubType="ERROR"
            &ErrorParameters=c-msg-erro}
        END.

        RUN setRecord IN THIS-PROCEDURE (INPUT TABLE RowObject).

    END.
                                                                

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

