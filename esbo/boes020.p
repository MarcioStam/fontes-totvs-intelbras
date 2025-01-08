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
&GLOBAL-DEFINE DBOName          BOES020
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName        banco-emit
&GLOBAL-DEFINE TableLabel       Dados Banc†rios do Fornecedor
&GLOBAL-DEFINE QueryName        qr{&TableName} 

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
{esbo/boes020.i RowObject}
{esp/es0018.i} 
{utp/ut-glob.i}
{utp/utapi019.i} 
{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

    DEFINE VARIABLE i-cod-emitente-ini AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cod-emitente-fim AS INTEGER     NO-UNDO.

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
         HEIGHT             = 7.04
         WIDTH              = 36.29.
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
        WHEN "aba[1]":U THEN ASSIGN pFieldValue = RowObject.aba[1].
        WHEN "aba[2]":U THEN ASSIGN pFieldValue = RowObject.aba[2].
        WHEN "banco[1]":U THEN ASSIGN pFieldValue = RowObject.banco[1].
        WHEN "banco[2]":U THEN ASSIGN pFieldValue = RowObject.banco[2].
        WHEN "conta[1]":U THEN ASSIGN pFieldValue = RowObject.conta[1].
        WHEN "conta[2]":U THEN ASSIGN pFieldValue = RowObject.conta[2].
        WHEN "endereco-1[1]":U THEN ASSIGN pFieldValue = RowObject.endereco-1[1].
        WHEN "endereco-1[2]":U THEN ASSIGN pFieldValue = RowObject.endereco-1[2].
        WHEN "endereco-2[1]":U THEN ASSIGN pFieldValue = RowObject.endereco-2[1].
        WHEN "endereco-2[2]":U THEN ASSIGN pFieldValue = RowObject.endereco-2[2].
        WHEN "endereco-3[1]":U THEN ASSIGN pFieldValue = RowObject.endereco-3[1].
        WHEN "endereco-3[2]":U THEN ASSIGN pFieldValue = RowObject.endereco-3[2].
        WHEN "endereco-4[1]":U THEN ASSIGN pFieldValue = RowObject.endereco-4[1].
        WHEN "endereco-4[2]":U THEN ASSIGN pFieldValue = RowObject.endereco-4[2].
        WHEN "fax[1]":U THEN ASSIGN pFieldValue = RowObject.fax[1].
        WHEN "fax[2]":U THEN ASSIGN pFieldValue = RowObject.fax[2].
        WHEN "fone[1]":U THEN ASSIGN pFieldValue = RowObject.fone[1].
        WHEN "fone[2]":U THEN ASSIGN pFieldValue = RowObject.fone[2].
        WHEN "swift[1]":U THEN ASSIGN pFieldValue = RowObject.swift[1].
        WHEN "swift[2]":U THEN ASSIGN pFieldValue = RowObject.swift[2].
        WHEN "telex[1]":U THEN ASSIGN pFieldValue = RowObject.telex[1].
        WHEN "telex[2]":U THEN ASSIGN pFieldValue = RowObject.telex[2].
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice cod-emit
  Parameters:  
               retorna valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE banco-emit.cod-emitente NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-emitente = RowObject.cod-emitente.

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
  Purpose:     Reposiciona registro com base no °ndice cod-emit
  Parameters:  
               recebe valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-emitente LIKE banco-emit.cod-emitente NO-UNDO.

    FIND FIRST bfbanco-emit WHERE 
        bfbanco-emit.cod-emitente = pcod-emitente NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfbanco-emit THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfbanco-emit)).
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
OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK.
    RETURN "ok".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom1 DBOProgram 
PROCEDURE openQueryZoom1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&queryName} 
    FOR EACH  banco-emit NO-LOCK
       WHERE  banco-emit.cod-emitente >= i-cod-emitente-ini
         AND  banco-emit.cod-emitente <= i-cod-emitente-fim.
         




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
RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom1 DBOProgram 
PROCEDURE setConstraintZoom1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-cod-emitente-ini AS integer NO-UNDO.      
DEFINE INPUT PARAMETER p-cod-emitente-fim AS integer NO-UNDO.      


   ASSIGN 
       i-cod-emitente-ini = p-cod-emitente-ini
       i-cod-emitente-fim = p-cod-emitente-fim.
    
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
                 WHERE bf{&TableName}.cod-emitente = RowObject.cod-emitente) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

         END.
         WHEN "Update" THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-emitente = RowObject.cod-emitente) THEN DO:
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
                 WHERE bf{&TableName}.cod-emitente = RowObject.cod-emitente) THEN DO:
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
    
    /*:T--- Verifica ocorrància de erros ---*/
    
    IF pType = "create"  OR pType = "update" THEN DO:
        IF NOT CAN-FIND (FIRST emitente NO-LOCK
                         WHERE emitente.cod-emitente = rowobject.cod-emitente) THEN DO:
            {METHOD/svc/errors/inserr.i
                            &errornumber="17006"
                            &errortype="EMS"
                            &errorsubtype="ERROR"
                            &ErrorParameters="'Emitente inv†lido.~~~~C¢digo do emitente n∆o cadastrado.'"}
        END.

    END.
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    

    IF  pType = "create"  OR pType = "update" THEN DO:
        DEFINE VAR cRemetente    AS CHAR FORMAT 'x(60)'   NO-UNDO.
        DEFINE VAR CDestino      AS CHAR FORMAT 'x(60)'   NO-UNDO.
        DEFINE VAR CAssunto      AS CHAR FORMAT 'x(60)'   NO-UNDO.
        DEFINE VAR CDescEmail    AS CHAR FORMAT 'x(2000)' NO-UNDO.
        DEFINE VAR CArqEmail     AS CHAR FORMAT 'x(60)'   NO-UNDO.

        IF  PROGRAM-NAME(1)  MATCHES "*esccp021*" OR PROGRAM-NAME(2)  MATCHES "*esccp021*" OR PROGRAM-NAME(3)  MATCHES "*esccp021*" OR
            PROGRAM-NAME(4)  MATCHES "*esccp021*" OR PROGRAM-NAME(5)  MATCHES "*esccp021*" OR PROGRAM-NAME(6)  MATCHES "*esccp021*" OR
            PROGRAM-NAME(7)  MATCHES "*esccp021*" OR PROGRAM-NAME(8)  MATCHES "*esccp021*" OR PROGRAM-NAME(9)  MATCHES "*esccp021*" OR
            PROGRAM-NAME(10) MATCHES "*esccp021*" OR PROGRAM-NAME(11) MATCHES "*esccp021*" THEN DO:
        
            EMPTY TEMP-TABLE tt-prog-ponto.
        
            FIND emitente NO-LOCK
                WHERE emitente.cod-emitente = rowobject.cod-emitente NO-ERROR.

            RUN esp/es0018p.p (INPUT "wad098", /* Nome do programa */
                               INPUT 2,         /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        
            FIND FIRST tt-prog-ponto
                WHERE ENTRY(1, tt-prog-ponto.conteudo, ";") = STRING(emitente.cod-gr-forn).
        
            IF  AVAIL tt-prog-ponto THEN DO:
            
                ASSIGN cDestino   = ENTRY(2, tt-prog-ponto.conteudo, ";")
                       cDescEmail = "Cadastro/Alteraá∆o banc†ria do fornecedor " + STRING(emitente.cod-emitente) + " -  " + emitente.nome-emit + 
                                    " em " + STRING(TODAY,"99/99/9999") + " Ös " + STRING(TIME,"HH:MM:ss") +
                                    "Por: "  + v_cod_usuar_corren
                       cAssunto   = "ESCCP021 - Cadastro banc†rio fornecedor " + STRING(emitente.cod-emitente) + " - " + emitente.nome-abrev 
                       cRemetente = "ems@intelbras.com.br"
                       cArqEmail  = "".
            
                RUN piEnviaEmail(INPUT cRemetente,
                                 INPUT cDestino,
                                 INPUT cAssunto,
                                 INPUT cDescEmail,
                                 INPUT cArqEmail).
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


PROCEDURE piEnviaEmail:

    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    FOR EACH tt-mail:
        DELETE tt-mail.
    END.
    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK:
    END.

    CREATE tt-mail.
    ASSIGN tt-mail.Remetente     = pRemetente
           tt-mail.Destinatario  = pdestino
           tt-mail.Assunto       = pAssunto
           tt-mail.Arquivo       = IF pArquivo <> "" then
                                      SEARCH(pArquivo) 
                                   ELSE
                                       "" 
           tt-mail.Mensagem      = pDescEmail.

       RUN utp/utapi019.p PERSISTENT SET h-utapi019.

       FOR EACH tt-mail:

           FOR EACH tt-envio2.   DELETE tt-envio2.   END.
           FOR EACH tt-mensagem. DELETE tt-mensagem. END.

           CREATE tt-envio2.
           ASSIGN tt-envio2.versao-integracao = 1
                  tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
                  tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
                  tt-envio2.destino           = tt-mail.Destinatario     /* Destinat†rio       */ 
                  tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */ 
                  tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
                  tt-envio2.arq-anexo         = tt-mail.Arquivo          /* Arquivo Tempor†rio */
                  tt-envio2.formato           = "TEXTO".

           CREATE tt-mensagem.
           ASSIGN tt-mensagem.seq-mensagem = 1
                  tt-mensagem.mensagem     = tt-mail.Mensagem + CHR(13). /* Mensagem           */
           RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                          INPUT  TABLE tt-mensagem,
                                          OUTPUT TABLE tt-erros).
   
           FIND FIRST tt-erros NO-LOCK NO-ERROR.
           IF AVAIL tt-erros THEN
               OUTPUT TO erros-comerc.LOG APPEND.

           FOR EACH tt-erros:
               DISP tt-erros.cod-erro
                    tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
           END.
           OUTPUT CLOSE.
       END.

       IF  VALID-HANDLE(h-utapi019)
       THEN
           DELETE PROCEDURE h-utapi019.
       ASSIGN h-utapi019 = ?.
END PROCEDURE.

