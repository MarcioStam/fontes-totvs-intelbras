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
{include/i-prgvrs.i BOES464 2.00.00.000}                               
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
&GLOBAL-DEFINE DBOName  BOES464
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  acordo-contrato
&GLOBAL-DEFINE TableLabel  acordo-contrato                 
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
/*{esbo/boes464.i RowObject}*/

DEFINE TEMP-TABLE RowObject NO-UNDO LIKE acordo-contrato
    FIELD r-Rowid AS ROWID.
 
 
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Definiá∆o de vari†veis *********************** */
define variable v-nr-acordo as integer no-undo.
define variable v-raiz-cnpj as character no-undo.
define variable v-cod-unid-negoc as character no-undo.
define variable v-cod-estabel as character no-undo.
define variable v-fm-cod-com   as character no-undo.
define variable v-data-vigencia as date no-undo.
 
DEFINE VARIABLE i-acordo-ini  AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-acordo-fim  AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-cliente-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cliente-fim AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-raiz-cnpj AS CHARACTER   NO-UNDO.

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
         HEIGHT             = 9.25
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

    FOR EACH acordo-tipo EXCLUSIVE-LOCK
       WHERE acordo-tipo.nr-acordo = RowObject.nr-acordo:
        DELETE acordo-tipo.
    END.

    FOR EACH acordo-crescimento EXCLUSIVE-LOCK
       WHERE acordo-crescimento.nr-acordo = RowObject.nr-acordo:
        DELETE acordo-crescimento.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraAcordoNotasFiscais DBOProgram 
PROCEDURE geraAcordoNotasFiscais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-raiz-cnpj         AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel       AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER p-serie             AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER p-nota-fiscal       AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER p-data-nota         AS DATE       NO-UNDO.
    DEFINE INPUT PARAMETER p-nota-devol        AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-unid-neg      AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER p-fm-cod-com        AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER p-data              AS DATE       NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-emitente      AS DECIMAL    NO-UNDO.
    DEFINE INPUT PARAMETER p-matriz            AS DECIMAL    NO-UNDO. 
    DEFINE INPUT PARAMETER p-valor-merc        AS DECIMAL    NO-UNDO.
    DEFINE INPUT PARAMETER p-valor-ipi         AS DECIMAL    NO-UNDO. 
    DEFINE INPUT PARAMETER p-valor-icmsub      AS DECIMAL    NO-UNDO. 

    DEFINE VARIABLE c-periodo AS CHARACTER   NO-UNDO.

    ASSIGN c-periodo = STRING(YEAR(p-data-nota),"9999") + STRING(MONTH(p-data-nota),"99").

    FIND LAST {&TableName} NO-LOCK
         WHERE {&TableName}.raiz-cnpj           = p-raiz-cnpj    /*procura pelo cnpj completo, unidade, familia*/
           AND ({&TableName}.cod-estabel        = p-cod-estabel OR {&TableName}.cod-estabel = ?)
           AND ({&TableName}.cod-unid-neg       = p-cod-unid-neg OR {&TableName}.cod-unid-neg = '1')
           AND {&TableName}.fm-cod-com          = p-fm-cod-com
           AND {&TableName}.data-vigencia      <= p-data
           /*AND {&TableName}.dt-vencto-contrato >= p-data*/
           AND {&TableName}.ativo               = YES NO-ERROR.
    IF NOT AVAILABLE ({&TableName}) THEN
        FIND LAST {&TableName} NO-LOCK
             WHERE {&TableName}.raiz-cnpj           = p-raiz-cnpj   /*procura pelo cnpj completo, unidade*/
               AND ({&TableName}.cod-estabel        = p-cod-estabel OR {&TableName}.cod-estabel = ?)
               AND ({&TableName}.cod-unid-neg       = p-cod-unid-neg OR {&TableName}.cod-unid-neg = '1')
               AND {&TableName}.fm-cod-com          = ?
               AND {&TableName}.data-vigencia      <= p-data
               /*AND {&TableName}.dt-vencto-contrato >= p-data*/
               AND {&TableName}.ativo               = YES NO-ERROR.
    IF NOT AVAILABLE ({&TableName}) THEN
        FIND LAST {&TableName} NO-LOCK
             WHERE {&TableName}.raiz-cnpj           = SUBSTRING(p-raiz-cnpj,1,8) /*procura pela raiz cnpj, unidade, familia*/
               AND ({&TableName}.cod-estabel        = p-cod-estabel OR {&TableName}.cod-estabel = ?)
               AND ({&TableName}.cod-unid-neg       = p-cod-unid-neg OR {&TableName}.cod-unid-neg = '1')
               AND {&TableName}.fm-cod-com          = p-fm-cod-com
               AND {&TableName}.data-vigencia      <= p-data
               /*AND {&TableName}.dt-vencto-contrato >= p-data*/
               AND {&TableName}.ativo               = YES NO-ERROR.
    IF NOT AVAILABLE ({&TableName}) THEN
        FIND LAST {&TableName} NO-LOCK
             WHERE {&TableName}.raiz-cnpj           = SUBSTRING(p-raiz-cnpj,1,8) /*procura pela raiz cnpj, unidade*/
               AND ({&TableName}.cod-estabel        = p-cod-estabel OR {&TableName}.cod-estabel = ?)
               AND ({&TableName}.cod-unid-neg       = p-cod-unid-neg OR {&TableName}.cod-unid-neg = '1')
               AND {&TableName}.fm-cod-com          = ?
               AND {&TableName}.data-vigencia      <= p-data
               /*AND {&TableName}.dt-vencto-contrato >= p-data*/
               AND {&TableName}.ativo               = YES NO-ERROR.
    IF AVAILABLE ({&TableName}) THEN DO:

        /* ** Desconsidera Devoluá‰es do C†lculo, paraemtrizado no esutp025 ***/
        IF  p-nota-devol               <> ""
        AND {&TableName}.id-devolucoes <> 0
            THEN RETURN "OK".

        FOR EACH acordo-tipo NO-LOCK
           WHERE acordo-tipo.nr-acordo  = {&TableName}.nr-acordo
             AND acordo-tipo.percentual > 0:
    
            FIND FIRST acordo-fatur EXCLUSIVE-LOCK
                 WHERE acordo-fatur.cod-estabel  = p-cod-estabel 
                   AND acordo-fatur.serie        = p-serie       
                   AND acordo-fatur.nr-nota-fis  = p-nota-fiscal 
                   AND acordo-fatur.nr-nota-dev  = p-nota-devol
                   AND acordo-fatur.raiz-cnpj    = {&TableName}.raiz-cnpj 
                   AND acordo-fatur.cod-unid-neg = p-cod-unid-neg
                   AND acordo-fatur.tipo-acordo  = acordo-tipo.tipo-acordo
                   AND acordo-fatur.periodo      = c-periodo NO-ERROR.
            IF NOT AVAIL acordo-fatur THEN DO:
                CREATE acordo-fatur.
                ASSIGN acordo-fatur.num-id-fatur = NEXT-VALUE(seq_acordo_fatur)
                       acordo-fatur.cod-estabel  = p-cod-estabel
                       acordo-fatur.serie        = p-serie
                       acordo-fatur.nr-nota-fis  = p-nota-fiscal
                       acordo-fatur.nr-nota-dev  = p-nota-devol
                       acordo-fatur.cod-unid-neg = p-cod-unid-neg
                       acordo-fatur.tipo-acordo  = acordo-tipo.tipo-acordo
                       acordo-fatur.raiz-cnpj    = {&TableName}.raiz-cnpj
                       acordo-fatur.per-acordo   = acordo-tipo.percentual
                       acordo-fatur.dt-emissao   = p-data-nota
                       acordo-fatur.cod-emitente = p-cod-emitente
                       acordo-fatur.matriz       = p-matriz
                       acordo-fatur.periodo      = c-periodo.
            END.

            /* ** Desconsidera valor de IPI + ICMS ST, parametrizado no programa esutp025 ***/
            IF {&TableName}.id-faturamento = 0 
               THEN ASSIGN p-valor-ipi    = 0.
            IF {&TableName}.id-base-calculo = 0 
               THEN ASSIGN p-valor-icmsub = 0.

            ASSIGN acordo-fatur.valor-acordo = acordo-fatur.valor-acordo + /*ROUND(*/ (((p-valor-merc + p-valor-ipi + p-valor-icmsub) * acordo-fatur.per-acordo / 100) * IF p-nota-devol <> "" THEN -1 ELSE 1) /*,2)*/
                   acordo-fatur.saldo        = acordo-fatur.valor-acordo
                   acordo-fatur.data-trans   = TODAY.
        END.
    END.
   
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAcordoComercial DBOProgram 
PROCEDURE getAcordoComercial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT   PARAMETER p-raiz-cnpj         LIKE {&TableName}.raiz-cnpj     NO-UNDO.
    DEFINE INPUT   PARAMETER p-cod-estabel       LIKE {&TableName}.cod-estabel   NO-UNDO.
    DEFINE INPUT   PARAMETER p-cod-unid-neg      LIKE {&TableName}.cod-unid-neg  NO-UNDO.
    DEFINE INPUT   PARAMETER p-fm-cod-com        LIKE {&TableName}.fm-cod-com    NO-UNDO.
    DEFINE INPUT   PARAMETER p-data              AS DATE                         NO-UNDO.
    DEFINE OUTPUT  PARAMETER p-id-faturamento    AS INTEGER                      NO-UNDO.
    DEFINE OUTPUT  PARAMETER p-id-base-calc      AS INTEGER                      NO-UNDO.
    DEFINE OUTPUT  PARAMETER p-id-devolucoes     AS INTEGER                      NO-UNDO.
    DEFINE OUTPUT  PARAMETER p-perc              AS DECIMAL                      NO-UNDO.

    FIND LAST {&TableName} NO-LOCK
         WHERE {&TableName}.raiz-cnpj           = p-raiz-cnpj
           AND ({&TableName}.cod-estabel        = p-cod-estabel OR {&TableName}.cod-estabel = ?)
           AND ({&TableName}.cod-unid-neg       = p-cod-unid-neg OR {&TableName}.cod-unid-neg = '1')
           AND {&TableName}.fm-cod-com          = p-fm-cod-com
           AND {&TableName}.data-vigencia      <= p-data
           /*AND {&TableName}.dt-vencto-contrato >= p-data*/
           AND {&TableName}.ativo               = YES  NO-ERROR.
    IF NOT AVAILABLE ({&TableName}) THEN
        FIND LAST {&TableName} NO-LOCK
             WHERE {&TableName}.raiz-cnpj           = p-raiz-cnpj
               AND ({&TableName}.cod-estabel        = p-cod-estabel OR {&TableName}.cod-estabel = ?)
               AND ({&TableName}.cod-unid-neg       = p-cod-unid-neg OR {&TableName}.cod-unid-neg = '1')
               AND {&TableName}.fm-cod-com          = ?
               AND {&TableName}.data-vigencia      <= p-data
               /*AND {&TableName}.dt-vencto-contrato >= p-data*/
               AND {&TableName}.ativo               = YES NO-ERROR.
    IF NOT AVAILABLE ({&TableName}) THEN
        FIND LAST {&TableName} NO-LOCK
             WHERE {&TableName}.raiz-cnpj           = SUBSTRING(p-raiz-cnpj,1,8)
               AND ({&TableName}.cod-estabel        = p-cod-estabel OR {&TableName}.cod-estabel = ?)
               AND ({&TableName}.cod-unid-neg       = p-cod-unid-neg OR {&TableName}.cod-unid-neg = '1')
               AND {&TableName}.fm-cod-com          = p-fm-cod-com
               AND {&TableName}.data-vigencia      <= p-data
               /*AND {&TableName}.dt-vencto-contrato >= p-data*/
               AND {&TableName}.ativo               = YES  NO-ERROR.
    IF NOT AVAILABLE ({&TableName}) THEN
        FIND LAST {&TableName} NO-LOCK
             WHERE {&TableName}.raiz-cnpj           = SUBSTRING(p-raiz-cnpj,1,8)
               AND ({&TableName}.cod-estabel        = p-cod-estabel OR {&TableName}.cod-estabel = ?)
               AND ({&TableName}.cod-unid-neg       = p-cod-unid-neg OR {&TableName}.cod-unid-neg = '1')
               AND {&TableName}.fm-cod-com          = ?
               AND {&TableName}.data-vigencia      <= p-data
               /*AND {&TableName}.dt-vencto-contrato >= p-data*/
               AND {&TableName}.ativo               = YES NO-ERROR.
    IF AVAILABLE ({&TableName}) THEN DO:
        FOR EACH acordo-tipo NO-LOCK
           WHERE acordo-tipo.nr-acordo  = {&TableName}.nr-acordo
             AND acordo-tipo.percentual > 0:
            ASSIGN p-perc = p-perc + acordo-tipo.percentual.
        END.
        ASSIGN p-id-faturamento = {&TableName}.id-faturamento 
               p-id-base-calc   = {&TableName}.id-base-calc
               p-id-devolucoes  = {&TableName}.id-devolucoes.   
       RETURN "OK":U.
    END.

    ASSIGN p-perc           = 0
           p-id-faturamento = 0
           p-id-base-calc   = 0
           p-id-devolucoes  = 0.

    RETURN "NOK":U.
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
        WHEN "cod-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
        WHEN "fm-cod-com":U THEN ASSIGN pFieldValue = RowObject.fm-cod-com.
        WHEN "observacoes":U THEN ASSIGN pFieldValue = RowObject.observacoes.
        WHEN "raiz-cnpj":U THEN ASSIGN pFieldValue = RowObject.raiz-cnpj.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.                                                                            

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-vigencia":U THEN ASSIGN pFieldValue = RowObject.data-vigencia.
        WHEN "dt-vencto-contrato":U THEN ASSIGN pFieldValue = RowObject.dt-vencto-contrato.
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
        WHEN "id-base-calculo":U THEN ASSIGN pFieldValue = RowObject.id-base-calculo.
        WHEN "id-devolucoes":U THEN ASSIGN pFieldValue = RowObject.id-devolucoes.
        WHEN "id-faturamento":U THEN ASSIGN pFieldValue = RowObject.id-faturamento.
        WHEN "id-situacao":U THEN ASSIGN pFieldValue = RowObject.id-situacao.
        WHEN "nr-acordo":U THEN ASSIGN pFieldValue = RowObject.nr-acordo.
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
    DEFINE OUTPUT PARAMETER p-nr-acordo LIKE {&TableName}.nr-acordo NO-UNDO.

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN p-nr-acordo = RowObject.nr-acordo.

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
        WHEN "ativo":U THEN ASSIGN pFieldValue = RowObject.ativo.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
DEFINE INPUT PARAMETER p-nr-acordo AS integer NO-UNDO.                                                                          

    FIND bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.nr-acordo = p-nr-acordo                  
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
            RUN openQueryStatic ("Ch-acordo":U).                      
        WHEN 3 THEN           
            RUN openQueryStatic ("ch-chave":U).
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-acordo DBOProgram 
PROCEDURE openQueryCh-acordo :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.nr-acordo = v-nr-acordo                    
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerych-chave DBOProgram 
PROCEDURE openQuerych-chave :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.raiz-cnpj      = v-raiz-cnpj                    
           AND {&TableName}.cod-unid-negoc = v-cod-unid-negoc            
           AND {&TableName}.cod-estabel    = v-cod-estabel                  
           AND {&TableName}.fm-cod-com     = v-fm-cod-com                  
           AND {&TableName}.data-vigencia  = v-data-vigencia.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRaizCnpj DBOProgram 
PROCEDURE openQueryRaizCnpj :
OPEN QUERY {&QueryName} 
        FOR EACH {&TableName} NO-LOCK
           WHERE {&TableName}.raiz-cnpj = c-raiz-cnpj.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom1 DBOProgram 
PROCEDURE openQueryZoom1 :
OPEN QUERY {&QueryName} 
        FOR EACH {&TableName} NO-LOCK
           WHERE {&TableName}.nr-acordo >= i-acordo-ini
             AND {&TableName}.nr-acordo <= i-acordo-fim
             AND {&TableName}.raiz-cnpj >= c-cliente-ini
             AND {&TableName}.raiz-cnpj <= c-cliente-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-acordo DBOProgram 
PROCEDURE setConstraintCh-acordo :
DEFINE INPUT PARAMETER p-nr-acordo AS integer NO-UNDO.                                                                          

    ASSIGN 
    v-nr-acordo = p-nr-acordo                                         
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintch-chave DBOProgram 
PROCEDURE setConstraintch-chave :
DEFINE INPUT PARAMETER p-raiz-cnpj AS character NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-cod-unid-negoc AS character NO-UNDO.                                                                   
    DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-fm-cod-com AS character NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-data-vigencia AS date NO-UNDO.                                                                         

    ASSIGN v-raiz-cnpj      = p-raiz-cnpj                                         
           v-cod-unid-negoc = p-cod-unid-negoc                               
           v-cod-estabel    = p-cod-estabel                                     
           v-fm-cod-com     = p-fm-cod-com                                     
           v-data-vigencia  = p-data-vigencia.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRaizCnpj DBOProgram 
PROCEDURE setConstraintRaizCnpj :
DEFINE INPUT PARAMETER p-raiz-cnpj AS CHARACTER NO-UNDO.

ASSIGN c-raiz-cnpj = p-raiz-cnpj.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom1 DBOProgram 
PROCEDURE setConstraintZoom1 :
DEFINE INPUT PARAMETER p-acordo-ini AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-acordo-fim AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cliente-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cliente-fim AS CHARACTER NO-UNDO.

    ASSIGN i-acordo-ini = p-acordo-ini
           i-acordo-fim = p-acordo-fim
           c-cliente-ini = p-cliente-ini
           c-cliente-fim = p-cliente-fim.

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

    CASE pType:
         WHEN "Create" THEN DO:
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.nr-acordo = RowObject.nr-acordo) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                         WHERE bf{&TableName}.raiz-cnpj      = RowObject.raiz-cnpj
                           AND bf{&TableName}.cod-estabel    = RowObject.cod-estabel
                           AND bf{&TableName}.cod-unid-negoc = RowObject.cod-unid-negoc
                           AND bf{&TableName}.fm-cod-com     = RowObject.fm-cod-com
                           AND bf{&TableName}.data-vigencia  = RowObject.data-vigencia) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="17006"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'J† existe Acordo para Cliente/Estab/Unidade/Familia/Data.~~~~J† existe Acordo para Cliente/Estab/Unidade/Familia/Data informados.'"}
             END.
         END.
         WHEN "Update" THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.nr-acordo = RowObject.nr-acordo) THEN DO:
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
                 WHERE bf{&TableName}.nr-acordo = RowObject.nr-acordo) THEN DO:
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
        IF LENGTH(RowObject.raiz-cnpj) <> 8 AND LENGTH(RowObject.raiz-cnpj) <> 14 THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'CNPJ inv†lido.~~~~CNPJ deve conter 8 ou 14 d°gitos.'"}
        END.

        IF NOT CAN-FIND(FIRST emitente NO-LOCK
                        WHERE emitente.cgc BEGINS RowObject.raiz-cnpj
                          AND emitente.identific <> 2) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'CNPJ inv†lido.~~~~Nenhum Fornecedor cadastrado com esse CNPJ.'"}
        END.

        IF  RowObject.cod-estabel <> ?
        AND NOT CAN-FIND(FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Estabelecimento inv†lido.~~~~Estabelecimento n∆o cadastrado.'"}
        END.

        IF RowObject.cod-unid-negoc = "" THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Unidade Neg¢cio inv†lida.~~~~Unidade Neg¢cio deve ser informado.'"}
        END.

        IF RowObject.fm-cod-com = "" THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'C¢digo Familia Comercial inv†lida.~~~~Familia Comercial deve ser informada, ou utilize ? para todas.'"}
        END.

        IF RowObject.fm-cod-com <> ? AND NOT CAN-FIND(FIRST fam-comerc NO-LOCK WHERE fam-comerc.fm-cod-com = RowObject.fm-cod-com) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'C¢digo Familia Comercial inv†lida.~~~~C¢digo da Familia Comercial n∆o cadastrado.'"}
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

