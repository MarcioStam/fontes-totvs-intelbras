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
&GLOBAL-DEFINE DBOName BOES657
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName aponta-mqa
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
{esbo/boes657.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VAR v-cod-estab-ini AS CHAR NO-UNDO.
DEFINE VAR v-cod-estab-fim AS CHAR NO-UNDO.
DEFINE VAR v-data-ini      AS DATE FORMAT "99/99/9999" NO-UNDO.
DEFINE VAR v-data-fim      AS DATE FORMAT "99/99/9999" NO-UNDO.
DEFINE VAR v-nr-linha-ini  AS INT NO-UNDO.
DEFINE VAR v-nr-linha-fim  AS INT NO-UNDO.

DEFINE VARIABLE i-cor AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-total-apont AS DECIMAL     NO-UNDO.    

{cdp/cd0666.i}
{esapi/esapi010tt.i}

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 14.67
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
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-cor AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-falha AS CHARACTER   NO-UNDO.
    
    /* MQA extrapolado vermelho ou amarelo */
    IF (i-cor = 12 OR i-cor = 14) THEN DO:

        IF i-cor = 12 THEN
            ASSIGN c-cor = "Vermelho".
        ELSE
            ASSIGN c-cor = "Amarelo".

        EMPTY TEMP-TABLE tt-mail.

        FIND FIRST int-lin-prod-mqa NO-LOCK
             WHERE int-lin-prod-mqa.cod-estabel = RowObject.cod-estabel
               AND int-lin-prod-mqa.nr-linha    = RowObject.nr-linha NO-ERROR.
        IF AVAIL int-lin-prod-mqa THEN DO:

            FIND FIRST falha-mqa NO-LOCK
                 WHERE falha-mqa.cod-falha = RowObject.cod-falha NO-ERROR.
            IF AVAIL falha-mqa THEN
                ASSIGN c-falha = falha-mqa.descricao.
            ELSE
                ASSIGN c-falha = "".            

            CREATE tt-mail.
            ASSIGN tt-mail.Destinatario  = int-lin-prod-mqa.ds-email-extrapolacao
                   tt-mail.Assunto       = "MQA Aviso extrapolaá∆o [" + c-cor + "]"                   
                   tt-mail.Arquivo       = ""       
                   tt-mail.Remetente     = "ems@intelbras.com.br".

            ASSIGN tt-mail.Mensagem      = "Estabelecimento: " + RowObject.cod-estabel + CHR(10) + 
                                           "Data: " + string(RowObject.data) + CHR(10) +
                                           "Prod: " + STRING(RowObject.cod-prod) + CHR(10) +
                                           "Origem: " + STRING(RowObject.origem-falha) + CHR(10) +
                                           "Local: " + STRING(RowObject.local-montag) + CHR(10) +
                                           "Falha: " + c-falha + CHR(10) + 
                                           "Total: " + string(de-total-apont).

            RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                                  OUTPUT TABLE tt-erro).
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaUltimaPlaca DBOProgram 
PROCEDURE buscaUltimaPlaca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel    LIKE RowObject.cod-estabel    NO-UNDO.
    DEFINE INPUT PARAMETER p-data           LIKE RowObject.data           NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-prod       LIKE RowObject.cod-prod       NO-UNDO.    
    DEFINE OUTPUT PARAMETER p-seq           LIKE RowObject.sequencia      NO-UNDO.
    
    ASSIGN p-seq = 1.

    FOR LAST  aponta-mqa USE-INDEX placa NO-LOCK
        WHERE aponta-mqa.cod-estabel  = p-cod-estabel
        AND   aponta-mqa.data         = p-data
        AND   aponta-mqa.cod-prod     = p-cod-prod.

        ASSIGN p-seq = aponta-mqa.nr-placa-seq + 1.
    END.
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaUltimaSeq DBOProgram 
PROCEDURE buscaUltimaSeq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-estabel    LIKE RowObject.cod-estabel    NO-UNDO.
    DEFINE INPUT PARAMETER p-data           LIKE RowObject.data           NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-prod       LIKE RowObject.cod-prod       NO-UNDO.
    DEFINE INPUT PARAMETER p-local-montag   LIKE RowObject.local-montag   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-falha      LIKE RowObject.cod-falha      NO-UNDO.
    DEFINE OUTPUT PARAMETER p-seq           LIKE RowObject.sequencia      NO-UNDO.
    

    ASSIGN p-seq = 1.

    FOR LAST bf{&TableName} NO-LOCK USE-INDEX pr
        WHERE bf{&TableName}.cod-estabel  = p-cod-estabel
        AND   bf{&TableName}.data         = p-data
        AND   bf{&TableName}.cod-prod     = p-cod-prod
        AND   bf{&TableName}.local-montag = p-local-montag
        AND   bf{&TableName}.cod-falha    = p-cod-falha:

        ASSIGN p-seq = bf{&TableName}.sequencia + 1.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcularMQA DBOProgram 
PROCEDURE calcularMQA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM p-cod-estabel  AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM p-data         AS DATE NO-UNDO.
    DEFINE INPUT  PARAM p-cod-prod     AS INT  NO-UNDO.
    DEFINE INPUT  PARAM p-origem       AS INT  NO-UNDO.
    DEFINE INPUT  PARAM p-local-montag AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM p-es-codigo    AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM p-cod-falha    AS INT  NO-UNDO.
    DEFINE INPUT  PARAM p-qtd-falha    AS DEC  NO-UNDO.
    DEFINE OUTPUT PARAM p-cor          AS INT  NO-UNDO.            
    
    RUN calcularTotalApontamentos (INPUT p-cod-estabel,
                                   INPUT p-data,
                                   INPUT p-cod-prod,
                                   INPUT p-origem,
                                   INPUT p-local-montag,
                                   INPUT p-cod-falha,
                                   OUTPUT de-total-apont).

    ASSIGN de-total-apont = de-total-apont + p-qtd-falha.

    FOR FIRST item-mqa NO-LOCK
        WHERE item-mqa.cod-prod    = p-cod-prod
          AND item-mqa.cod-estabel = p-cod-estabel:

        FOR FIRST estimativa-produ NO-LOCK
            WHERE estimativa-produ.cod-estabel = p-cod-estabel
            AND   estimativa-produ.data        = p-data
            AND   estimativa-produ.cod-prod    = p-cod-prod:

            FOR FIRST indice-qualid NO-LOCK
                WHERE indice-qualid.cod-estabel = p-cod-estabel
                AND   indice-qualid.it-codigo   = p-es-codigo:
                
                IF estimativa-produ.qtd-estimada < item-mqa.vl-critico THEN DO:

                    IF de-total-apont >= indice-qualid.absol-problema THEN                    
                        ASSIGN p-cor = 12.  /* Vermelho */                    
                    ELSE IF (de-total-apont > indice-qualid.absol-atencao AND
                            de-total-apont < indice-qualid.absol-problema) THEN                                                   
                            ASSIGN p-cor = 14.  /* Amarelo */
                END.
                ELSE DO:
                   IF (de-total-apont * 100 / estimativa-produ.qtd-estimada ) >= indice-qualid.relat-problema  THEN                     
                       ASSIGN p-cor = 12.  /* Vermelho */                   
                   ELSE IF ((de-total-apont * 100 / estimativa-produ.qtd-estimada ) > indice-qualid.relat-atencao AND
                          (de-total-apont * 100 / estimativa-produ.qtd-estimada ) < indice-qualid.relat-problema) THEN                          
                          ASSIGN p-cor = 14.  /* Amarelo */
                END.
            END.
        END.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcularTotalApontamentos DBOProgram 
PROCEDURE calcularTotalApontamentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAM p-cod-estabel  AS CHAR NO-UNDO.
DEFINE INPUT  PARAM p-data         AS DATE NO-UNDO.
DEFINE INPUT  PARAM p-cod-prod     AS INT  NO-UNDO.
DEFINE INPUT  PARAM p-origem       AS INT  NO-UNDO.
DEFINE INPUT  PARAM p-local-montag AS CHAR NO-UNDO.
DEFINE INPUT  PARAM p-cod-falha    AS INT  NO-UNDO.
DEFINE OUTPUT PARAM p-total-apont AS DEC  NO-UNDO.

DEFINE VARIABLE r-rowid AS ROWID       NO-UNDO.

IF AVAIL RowObject THEN
    ASSIGN r-rowid = RowObject.r-rowid.
ELSE
    ASSIGN r-rowid = ?.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estabel  = p-cod-estabel
        AND   bf{&TableName}.data         = p-data
        AND   bf{&TableName}.cod-prod     = p-cod-prod
        AND   bf{&TableName}.origem       = p-origem
        AND   bf{&TableName}.local-montag = p-local-montag
        AND   bf{&TableName}.cod-falha    = p-cod-falha
        AND   ROWID(bf{&TableName})       NE RowObject.r-rowid:
    
        ASSIGN p-total-apont = p-total-apont + bf{&TableName}.qtd-falha.
    END.

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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-usuario":U THEN ASSIGN pFieldValue = RowObject.cod-usuario.
        WHEN "es-codigo":U THEN ASSIGN pFieldValue = RowObject.es-codigo.
        WHEN "local-montag":U THEN ASSIGN pFieldValue = RowObject.local-montag.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
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
        WHEN "data":U THEN ASSIGN pFieldValue = RowObject.data.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "qtd-falha":U THEN ASSIGN pFieldValue = RowObject.qtd-falha.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
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
        WHEN "cod-falha":U THEN ASSIGN pFieldValue = RowObject.cod-falha.
        WHEN "cod-prod":U THEN ASSIGN pFieldValue = RowObject.cod-prod.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.
        WHEN "origem-falha":U THEN ASSIGN pFieldValue = RowObject.origem-falha.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice pr
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo data
               retorna valor do campo cod-prod
               retorna valor do campo local-montag
               retorna valor do campo cod-falha
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE aponta-mqa.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pdata LIKE aponta-mqa.data NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-prod LIKE aponta-mqa.cod-prod NO-UNDO.
    DEFINE OUTPUT PARAMETER plocal-montag LIKE aponta-mqa.local-montag NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-falha LIKE aponta-mqa.cod-falha NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE aponta-mqa.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pdata = RowObject.data
           pcod-prod = RowObject.cod-prod
           plocal-montag = RowObject.local-montag
           pcod-falha = RowObject.cod-falha
           psequencia = RowObject.sequencia.

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
  Purpose:     Reposiciona registro com base no °ndice pr
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo data
               recebe valor do campo cod-prod
               recebe valor do campo local-montag
               recebe valor do campo cod-falha
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE aponta-mqa.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pdata LIKE aponta-mqa.data NO-UNDO.
    DEFINE INPUT PARAMETER pcod-prod LIKE aponta-mqa.cod-prod NO-UNDO.
    DEFINE INPUT PARAMETER plocal-montag LIKE aponta-mqa.local-montag NO-UNDO.
    DEFINE INPUT PARAMETER pcod-falha LIKE aponta-mqa.cod-falha NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE aponta-mqa.sequencia NO-UNDO.

    FIND FIRST bfaponta-mqa WHERE 
        bfaponta-mqa.cod-estabel = pcod-estabel AND 
        bfaponta-mqa.data = pdata AND 
        bfaponta-mqa.cod-prod = pcod-prod AND 
        bfaponta-mqa.local-montag = plocal-montag AND 
        bfaponta-mqa.cod-falha = pcod-falha AND
        bfaponta-mqa.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfaponta-mqa THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaponta-mqa)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryMain DBOProgram 
PROCEDURE OpenQueryMain :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryZoom DBOProgram 
PROCEDURE OpenQueryZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
         WHERE {&TableName}.cod-estabel >= v-cod-estab-ini
           AND {&TableName}.cod-estabel <= v-cod-estab-fim
           AND {&TableName}.data        >= v-data-ini
           AND {&TableName}.data        <= v-data-fim
           AND {&TableName}.nr-linha    >= v-nr-linha-ini
           AND {&TableName}.nr-linha    <= v-nr-linha-fim INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom DBOProgram 
PROCEDURE setConstraintZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-cod-estab-ini AS CHAR.
    DEFINE INPUT PARAM p-cod-estab-fim AS CHAR.
    DEFINE INPUT PARAM p-data-ini      AS DATE.
    DEFINE INPUT PARAM p-data-fim      AS DATE.
    DEFINE INPUT PARAM p-nr-linha-ini  AS INT.
    DEFINE INPUT PARAM p-nr-linha-fim  AS INT.

    ASSIGN v-cod-estab-ini = p-cod-estab-ini
           v-cod-estab-fim = p-cod-estab-fim
           v-data-ini      = p-data-ini     
           v-data-fim      = p-data-fim     
           v-nr-linha-ini  = p-nr-linha-ini     
           v-nr-linha-fim  = p-nr-linha-fim.
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

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    IF RowObject.cod-prod = 0 THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="'Produto n∆o informado.'"}
    END.

    IF RowObject.nr-linha = 0 THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="'Linha n∆o pode ser 0.'"}
    END.

    IF NOT CAN-FIND(FIRST estabelec
                    WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="'Estabelecimento'"}

    END.

    IF NOT CAN-FIND(FIRST lin-prod
                    WHERE lin-prod.nr-linha = RowObject.nr-linha) THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="'Linha Produá∆o'"}

    END.

    FIND FIRST item-mqa NO-LOCK
         WHERE item-mqa.cod-prod    = RowObject.cod-prod
           AND item-mqa.cod-estabel = RowObject.cod-estabel NO-ERROR.
    IF NOT AVAIL item-mqa THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="'Produto'"}

    END.
    ELSE DO:
        IF item-mqa.log-1 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="'Produto desativado para apontamentos.'"}
        END.
    END.

    IF RowObject.origem-falha = 0 THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="'Origem'"}


    END.
    ELSE DO:        
        FIND FIRST origem-mqa NO-LOCK
             WHERE origem-mqa.origem-falha = rowobject.origem-falha NO-ERROR.
        IF NOT AVAIL origem-mqa THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="'Origem'"}
        END.
        ELSE DO:
            IF origem-mqa.log-1 THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="Error"
                                            &ErrorParameters="'Origem Mqa Desativada'"}
            END.
        END.        
    END.

    IF NOT CAN-FIND(FIRST estrutura-mqa
                    WHERE estrutura-mqa.cod-prod = RowObject.cod-prod
                      AND estrutura-mqa.local-montag = RowObject.local-montag
                      AND estrutura-mqa.cod-estabel = RowObject.cod-estabel) THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="'Local'"}

    END.

    IF NOT CAN-FIND(FIRST ITEM
                    WHERE ITEM.it-codigo = RowObject.es-codigo) THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="'Componente'"}

    END.

    IF RowObject.cod-falha = 0 THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="'Falha'"}


    END.
    ELSE DO:
        FIND FIRST falha-mqa NO-LOCK
             WHERE falha-mqa.cod-falha = rowobject.cod-falha NO-ERROR.
        IF NOT AVAIL falha-mqa THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="'Falha'"}
        END.
        ELSE DO:
            IF falha-mqa.log-1 THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="Error"
                                            &ErrorParameters="'Falha Mqa Desativada'"}
            END.
        END.
    END.

    IF RowObject.qtd-falha = 0 THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="'Quantidade informada deve ser superior a zero.'"}


    END.

    IF NOT can-find(FIRST estimativa-produ
                    WHERE estimativa-produ.cod-estabel = RowObject.cod-estabel
                      AND estimativa-produ.data        = RowObject.data
                      AND estimativa-produ.cod-prod    = RowObject.cod-prod) THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="'Estimativa de Produá∆o n∆o cadastrada. ~~~~ Solicite o cadastro da Estimativa de Produá∆o para a l°der da linha de produá∆o.'"}
    END.

    IF NOT can-find(FIRST indice-qualid NO-LOCK
                    WHERE indice-qualid.cod-estabel = RowObject.cod-estabel
                      AND indice-qualid.it-codigo   = RowObject.es-codigo) THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="'Indice de Qualidade n∆o cadastrado. ~~~~ Solicite o cadastro do ÷ndice de Qualidade para a Engenharia Industrial.'"}
    END.       

    RUN calcularMQA (INPUT RowObject.cod-estabel,
                     INPUT RowObject.data,
                     INPUT RowObject.cod-prod,
                     INPUT RowObject.origem-falha,
                     INPUT RowObject.local-montag,
                     INPUT RowObject.es-codigo,
                     INPUT RowObject.cod-falha,
                     INPUT RowObject.qtd-falha,
                     OUTPUT i-cor).

    
    IF i-cor = 12 THEN DO:
        IF RowObject.observacao = "" THEN DO:            
                    
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="'Extrapolaá∆o do ÷ndice de Qualidade: Observaá∆o em branco. ~~~~ Favor informar o n£mero do Cart∆o aberto.'"}                       
        END.
    END.

        
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

