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
&GLOBAL-DEFINE DBOName BOES661a
&GLOBAL-DEFINE DBOVersion 1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName reservas-ast
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qrreservas-ast

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
      
      
{esbo/BOES661a.i RowObject}
{utp/utapi019.i}
{utp/ut-glob.i}

/*:T--- Include com definição da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteração da definição da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definição 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definição de buffer que será utilizado pelo método goToKey ---*/

DEFINE BUFFER bfreservas-ast FOR {&TableName}.

DEFINE VARIABLE c-estab-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-estab-fim AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-depos-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-depos-fim AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-item-ini  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-item-fim  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-usuar-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-usuar-fim AS CHARACTER NO-UNDO.

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
         HEIGHT             = 17.54
         WIDTH              = 50.86.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviaMail DBOProgram 
PROCEDURE enviaMail :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pRemetente      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pDestinatario   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pAssunto        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pMensagem       AS CHARACTER NO-UNDO.

DEFINE VARIABLE h-utapi019 AS HANDLE      NO-UNDO.

FOR EACH tt-envio2:
    DELETE tt-envio2.
END.

FIND FIRST param-global NO-LOCK NO-ERROR.

IF AVAIL param-global THEN DO:
    
    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao  = 1
           tt-envio2.servidor           = param-global.serv-mail
           tt-envio2.porta              = param-global.porta-mail
           tt-envio2.exchange           = param-global.log-1
           tt-envio2.remetente          = pRemetente
           tt-envio2.destino            = pDestinatario
           tt-envio2.assunto            = pAssunto
           tt-envio2.mensagem           = pMensagem
           tt-envio2.arq-anexo          = ''
           tt-envio2.importancia        = 1
           tt-envio2.log-enviada        = no
           tt-envio2.log-lida           = no
           tt-envio2.acomp              = no
           tt-envio2.formato            = 'TEXTO'.
    
END. /* IF AVAIL param-global THEN DO: */

RUN utp/utapi019.p PERSISTENT SET h-utapi019.
RUN pi-execute IN h-utapi019 (INPUT TABLE tt-envio2, OUTPUT TABLE tt-erros).
DELETE OBJECT h-utapi019.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estabel":U       THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-depos":U         THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "it-codigo":U         THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "cd-usuario":U        THEN ASSIGN pFieldValue = RowObject.cd-usuario.
        WHEN "cd-usuario-altera":U THEN ASSIGN pFieldValue = RowObject.cd-usuario-altera.
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
        WHEN "dt-resera":U         THEN ASSIGN pFieldValue = RowObject.dt-reserva.
        WHEN "dt-reserva-altera":U THEN ASSIGN pFieldValue = RowObject.dt-reserva-altera.
        WHEN "data-limite":U       THEN ASSIGN pFieldValue = RowObject.data-limite.
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
        WHEN "qt-reserva":U THEN ASSIGN pFieldValue = RowObject.qt-reserva.
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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice ch-pr
  Parameters:  
               retorna valor do campo cod-imagem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE reservas-ast.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-depos   LIKE reservas-ast.cod-depos   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-item    LIKE reservas-ast.it-codigo   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-usuario LIKE reservas-ast.cd-usuario  NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-depos   = RowObject.cod-depos
           pcod-item    = RowObject.it-codigo
           pcod-usuario = RowObject.cd-usuario.

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
  Purpose:     Reposiciona registro com base no ¡ndice ch-pr
  Parameters:  
               recebe valor do campo cod-imagem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE reservas-ast.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-depos   LIKE reservas-ast.cod-depos   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-item    LIKE reservas-ast.it-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-usuario LIKE reservas-ast.cd-usuario  NO-UNDO.

    FIND FIRST bfreservas-ast
        WHERE bfreservas-ast.cod-estabel = pcod-estabel
        AND   bfreservas-ast.cod-depos   = pcod-depos
        AND   bfreservas-ast.it-codigo   = pcod-item
        AND   bfreservas-ast.cd-usuario  = pcod-usuario NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfreservas-ast THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfreservas-ast)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCod DBOProgram 
PROCEDURE openQueryCod :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} 
    FOR EACH {&TableName}
        WHERE {&TableName}.cod-estabel >= c-estab-ini
        AND   {&TableName}.cod-estabel <= c-estab-fim
        AND   {&TableName}.cod-depos   >= c-depos-ini
        AND   {&TableName}.cod-depos   <= c-depos-fim
        AND   {&TableName}.it-codigo   >= c-item-ini
        AND   {&TableName}.it-codigo   <= c-item-fim
        AND   {&TableName}.cd-usuario  >= c-usuar-ini
        AND   {&TableName}.cd-usuario  <= c-usuar-fim NO-LOCK.

RETURN "OK".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaSaldo DBOProgram 
PROCEDURE piValidaSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE l-mail    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE de-saldo  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE cmensagem AS CHARACTER   NO-UNDO.

ASSIGN l-mail = YES.

FOR EACH saldo-estoq
    WHERE saldo-estoq.cod-estabel = RowObject.cod-estabel
    AND   saldo-estoq.cod-depos   = RowObject.cod-depos
    AND   saldo-estoq.it-codigo   = RowObject.it-codigo NO-LOCK:

    ASSIGN de-saldo = de-saldo + (saldo-estoq.qtidade-atu  -
                                 (saldo-estoq.qt-alocada   +
                                  saldo-estoq.qt-aloc-prod +
                                  saldo-estoq.qt-aloc-ped  )).

    IF de-saldo >= RowObject.qt-reserva THEN DO:
        ASSIGN l-mail = NO.
        RETURN "NOK".
    END.
END.

IF l-mail THEN DO:
    ASSIGN cMensagem = cMensagem + '~nReserva Gerada: Estab: ' + RowObject.cod-estabel  + 
                                   ', Dep¢sito: ' + RowObject.cod-depos                 + 
                                   ', ITEM: ' + RowObject.it-codigo                     +
                                   ', Usu rio: ' + RowObject.cd-usuario                 + '~n'.

     /** Manda e-mail **/
     if (cMensagem <> '') THEN DO:

         FOR FIRST ponto-programa
             WHERE ponto-programa.nome-programa = "espdp080"
             AND   ponto-programa.ponto         = 1,
             EACH conteudo-programa
             WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa EXCLUSIVE-LOCK:

             RUN enviaMail (INPUT 'ems@intelbras.com.br',
                            INPUT conteudo-programa.conteudo,
                            INPUT 'Reserva AST',
                            INPUT cMensagem).
         END. /* FOR FIRST ponto-programa */
     END. /* if (cMensagem <> '') THEN DO: */
END. /* IF l-mail THEN DO: */

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCod DBOProgram 
PROCEDURE setConstraintCod :
/*------------------------------------------------------------------------------
 Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-cod-estab-ini AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-cod-estab-fim AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-cod-depos-ini AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-cod-depos-fim AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-cod-item-ini  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-cod-item-fim  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-cod-usuar-ini AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-cod-usuar-fim AS CHARACTER NO-UNDO.

ASSIGN c-estab-ini = p-cod-estab-ini
       c-estab-fim = p-cod-estab-fim
       c-depos-ini = p-cod-depos-ini
       c-depos-fim = p-cod-depos-fim
       c-item-ini  = p-cod-item-ini 
       c-item-fim  = p-cod-item-fim 
       c-usuar-ini = p-cod-usuar-ini
       c-usuar-fim = p-cod-usuar-fim.


RETURN "OK":U.
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
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/

    IF pType = "Create" THEN DO:
            IF CAN-FIND(FIRST reservas-ast
                    WHERE reservas-ast.cod-estabel = RowObject.cod-estabel
                    AND   reservas-ast.cod-depos   = RowObject.cod-depos
                    AND   reservas-ast.it-codigo   = RowObject.it-codigo
                    AND   reservas-ast.cd-usuario  = RowObject.cd-usuario) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="'J  existe reserva cadastrada com os dados informados.'"}
        END.

        IF  NOT CAN-FIND(FIRST item
                         WHERE item.it-codigo = RowObject.it-codigo) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="'Item'"}
        END.

        IF  NOT CAN-FIND(FIRST estabelec
                         WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="'Estabelecimento'"}
        END.

        IF  NOT CAN-FIND(FIRST deposito
                         WHERE deposito.cod-depos = RowObject.cod-depos) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="'Dep¢sito'"}
        END.
    END.

    IF pType = "Create" OR
       pType = "Update" THEN DO:

        IF  NOT CAN-FIND(FIRST usuar_mestre
                         WHERE usuar_mestre.cod_usuario = RowObject.cd-usuario) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="'Usu rio'"}
        END.

        /*RUN piValidaSaldo.
        IF RETURN-VALUE <> "OK" THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="'Quantidade dispon¡vel!.~~H , em estoque, quantidade dispon¡vel para atender esta reserva.'"}                                        
        END.*/
    END.

    IF RowObject.cd-usuario <> c-seg-usuario THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="'NÆo ‚ permitida qualquer a‡Æo em registro que nÆo seja de seu usu rio.'"}  
    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

