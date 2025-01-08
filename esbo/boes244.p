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
{include/i-prgvrs.i BOES244 2.00.00.000}                               
/*--------------------------------------------------------------------------
    File       : 
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
&GLOBAL-DEFINE DBOName  BOES244
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  ns-sigla
&GLOBAL-DEFINE TableLabel  Siglas                      
&GLOBAL-DEFINE QueryName qrns-sigla 
 
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
{esbo/boes244.i RowObject}
 
 
/*:T--- Include com definição da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteração da definição da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definição 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Definição de buffer que será utilizado pelo método goToKey ---*/
DEFINE BUFFER bfns-sigla FOR {&TableName}.
/* ************************* Definição de variáveis *********************** */
define variable v-codigo as integer no-undo.
DEF VAR v-ini-sigla AS CHAR NO-UNDO.
DEF VAR v-fim-sigla AS CHAR NO-UNDO.
DEF VAR c-data AS CHAR NO-UNDO.

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
         HEIGHT             = 18.25
         WIDTH              = 37.86.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsFast DBOProgram 
PROCEDURE getBatchRecordsFast :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowObject.

    GET FIRST {&QueryName} NO-LOCK.
    IF AVAIL {&TableName} THEN DO:
        EMPTY TEMP-TABLE RowObject.
        DO WHILE AVAIL {&TableName}:
            CREATE RowObject.
            BUFFER-COPY {&TableName} TO RowObject.
            RowObject.r-rowid = ROWID({&TableName}).
            GET NEXT {&QueryName} NO-LOCK.
        END.
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
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "sigla":U THEN ASSIGN pFieldValue = RowObject.sigla.
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
        WHEN "codigo":U THEN ASSIGN pFieldValue = RowObject.codigo.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
DEFINE INPUT PARAMETER p-codigo AS integer NO-UNDO.                                                                             

    FIND bfns-sigla NO-LOCK
        WHERE bfns-sigla.codigo = p-codigo                        
        NO-ERROR.
    IF NOT AVAILABLE bfns-sigla THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfns-sigla)).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToSigla DBOProgram 
PROCEDURE goToSigla :
DEFINE INPUT PARAMETER p-sigla AS CHAR NO-UNDO.                                                                             

    FIND FIRST bfns-sigla NO-LOCK
        WHERE bfns-sigla.sigla = p-sigla NO-ERROR.

    IF NOT AVAILABLE bfns-sigla THEN RETURN "NOK":U.

    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfns-sigla)).
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
            RUN openQueryStatic ("Codigo":U).                         
        WHEN 3 THEN           
            RUN openQueryStatic ("ByCod":U).                         
    END CASE.
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


OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
    WHERE {&TableName}.sigla >= v-ini-sigla
    AND   {&TableName}.sigla <= v-fim-sigla.
RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodigo DBOProgram 
PROCEDURE openQueryCodigo :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.codigo = v-codigo.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piIncluiNumerosSerie DBOProgram 
PROCEDURE piIncluiNumerosSerie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-cod-sigla like ns-sigla.codigo no-undo.
    def input param p-data as date no-undo.
    def input param p-it-codigo as char no-undo.
    def input param p-ini-numero as int no-undo.
    def input param p-fim-numero as int no-undo.
    
    def var c-data as char no-undo.
    def var l-erro as logi no-undo.
    def var i-cont as int no-undo.

    if not can-find(first item no-lock
        where item.it-codigo = p-it-codigo) then do:
        {method/svc/errors/inserr.i
            &ErrorNumber="2"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="'Item'"}
        l-erro = yes.
    end.
    
    assign c-data = substring(string(year(p-data),"9999"),3,2) + 
                            string(month(p-data),"99") +
                            string(day(p-data),"99").
    find ns-data where ns-data.data = c-data no-lock no-error.
    if not avail ns-data then do:
        RUN _insertErrorManual(INPUT 0,
                               INPUT "EMS",
                               INPUT "ERROR",
                               INPUT "Data Inválida: " + string(p-data),
                               INPUT "Data Inválida: " + string(p-data),
                               INPUT "").    
        RETURN "NOK":U.
    
    end.
    
    find first ns-numero 
         where ns-numero.numero >= p-ini-numero
           and ns-numero.numero <= p-fim-numero
           and ns-numero.cod-data = ns-data.codigo
           and ns-numero.cod-sigla = p-cod-sigla no-lock no-error.
    
    if avail ns-numero then do:
        RUN _insertErrorManual(INPUT 0,
                               INPUT "EMS",
                               INPUT "ERROR",
                               INPUT "Já existem registros de série na faixa informada",
                               INPUT "Já existem registros de série na faixa informada: " + 
                                     string(p-ini-numero) + " a " + string(p-fim-numero),
                               INPUT "").    
        RETURN "NOK":U.
    end.
    
    if not l-erro then do:
        assign p-ini-numero = min(p-ini-numero, p-fim-numero)
               p-fim-numero = max(p-ini-numero, p-fim-numero).
  
        do i-cont = p-ini-numero to p-fim-numero:
            create ns-numero.
            assign ns-numero.it-codigo = p-it-codigo
                   ns-numero.numero    = i-cont
                   ns-numero.cod-data  = ns-data.codigo
                   ns-numero.cod-sigla = p-cod-sigla.
        end.
        RETURN "OK":U.
    end.
    RETURN "NOK":U.
        
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
    
    DEF INPUT PARAM p-ini-sigla LIKE ns-sigla.sigla NO-UNDO.
    DEF INPUT PARAM p-fim-sigla LIKE ns-sigla.sigla NO-UNDO.

    ASSIGN v-ini-sigla = p-ini-sigla
           v-fim-sigla = p-fim-sigla.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodigo DBOProgram 
PROCEDURE setConstraintCodigo :
DEFINE INPUT PARAMETER p-codigo AS integer NO-UNDO.                                                                             
    ASSIGN v-codigo = p-codigo.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validações pertinentes ao DBO
  Parameters:  recebe o tipo de validação (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    CASE pType:
         /*
         WHEN "Create" THEN DO:             
             IF CAN-FIND(bfns-sigla NO-LOCK WHERE
                         bfns-sigla.sigla = RowObject.sigla) THEN DO:
                 {method/svc/errors/inserr.i
                 &ErrorNumber="2"
                 &ErrorType="outros"
                 &ErrorSubType="ERROR"
                 &ErrorDescription="Sigla já cadastrada no sistema!."}
             END.
         END.
         */
         WHEN "Update" THEN DO:
             IF NOT CAN-FIND(FIRST bfns-sigla NO-LOCK
                 WHERE bfns-sigla.codigo = RowObject.codigo) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"}
             END.
         END.
         WHEN "Delete" THEN DO:
             IF NOT CAN-FIND(FIRST bfns-sigla NO-LOCK
                 WHERE bfns-sigla.codigo = RowObject.codigo) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"}
             END.
             
             
             {method/svc/errors/inserr.i
                &ErrorNumber="2"
                &ErrorType="outros"
                &ErrorSubType="ERROR"
                &ErrorDescription="NÆo ‚ permitido exclusÆo de c‚lula."}

             
         END.
    END CASE.

    
    /*:T--- Utilize o parâmetro pType para identificar quais as validações a serem
          executadas ---*/
    /*:T--- Os valores possíveis para o parâmetro são: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, através do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validações ---*/
    
    /*:T--- Verifica ocorrência de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

