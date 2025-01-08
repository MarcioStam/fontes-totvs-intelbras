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
{include/i-prgvrs.i BOES270 2.00.00.000}                               
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
&GLOBAL-DEFINE DBOName  BOES270
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  comis-deb-cred
&GLOBAL-DEFINE TableLabel  Valor comissao Debito/Credito 
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
{esbo/boes270.i RowObject}

{upc/btb910za-upc.i} /* Definiá∆o da vari†vel New Global Shared "v_cod_estab_usuar" */
 
 
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/utapi019.i} 
{utp/ut-glob.i}
 
/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Definiá∆o de vari†veis *********************** */
define variable v-cod-rep as integer no-undo.
define variable v-cod-mov as integer no-undo.
define variable v-dt-movto as date no-undo.
DEF var v-ini-data-movto AS DATE NO-UNDO.
DEF var v-fim-data-movto AS DATE NO-UNDO.
DEF var v-ini-cod-mov AS integer NO-UNDO.                                                                            
DEF var v-fim-cod-mov AS integer NO-UNDO.

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
         HEIGHT             = 30.04
         WIDTH              = 146.29.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.                                                                       

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "historico":U THEN ASSIGN pFieldValue = RowObject.historico.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "unid-neg":U THEN ASSIGN pFieldValue = RowObject.unid-neg.
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
        WHEN "dt-movto":U THEN ASSIGN pFieldValue = RowObject.dt-movto.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.                                                                         

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "valor":U THEN ASSIGN pFieldValue = RowObject.valor.
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
        WHEN "cod-mov":U THEN ASSIGN pFieldValue = RowObject.cod-mov.
        WHEN "cod-rep":U THEN ASSIGN pFieldValue = RowObject.cod-rep.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        OTHERWISE RETURN "NOK":U.
    END CASE.
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
        WHEN "base-final":U THEN ASSIGN pFieldValue = RowObject.base-final.
        WHEN "deb-cred":U THEN ASSIGN pFieldValue = RowObject.deb-cred.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
DEFINE INPUT PARAMETER p-cod-rep AS integer NO-UNDO.                                                                            
    DEFINE INPUT PARAMETER p-cod-mov AS integer NO-UNDO.                                                                            
    DEFINE INPUT PARAMETER p-dt-movto AS date NO-UNDO.                                                                              

    FIND bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-rep = p-cod-rep                      
        AND bf{&TableName}.cod-mov = p-cod-mov                        
        AND bf{&TableName}.dt-movto = p-dt-movto                      
        NO-ERROR.
    IF NOT AVAILABLE bf{&TableName} THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
PROCEDURE afterDeleteRecord:
    DEF VAR c-texto AS CHARACTER.
    
    FIND usuar_mestre
         WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren
        NO-LOCK NO-ERROR.
    IF AVAIL usuar_mestre THEN DO:
        
        IF AVAIL rowobject THEN DO:
            FIND repres
                WHERE repres.cod-rep = rowobject.cod-rep
                NO-LOCK NO-ERROR.
            IF AVAIL repres  THEN DO:
                ASSIGN c-texto = "Registro Debito/Credito do representante " + string(rowobject.cod-rep) + " - " +
                                         repres.nome + " do dia " + string(rowobject.dt-movto) +
                                         " Valor : " + STRING(rowobject.deb-cred,"-/+") + STRING(rowobject.valor,">>>,>>>,>>9.99") +
                                         " Excluido por " + usuar_mestre.cod_usuario +
                                         " - " + usuar_mestre.nom_usuario +
                                         "Hist¢rico : " + rowobject.historico.
                RUN  piEnviaEmail (INPUT usuar_mestre.cod_e_mail_local,
                                   INPUT "sagaz@intelbras.com.br,jorge.souza@intelbras.com.br,luciano@intelbras.com.br",
                                   INPUT "Exlusao de Registro Debito/Credito de Comissoes",
                                   INPUT c-texto,
                                   INPUT "").
            END.
            ELSE DO:
                MESSAGE "Representante n∆o encontrado"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN "NOK".
            END.
        END.
        ELSE DO:
            MESSAGE "Comissao deb cred n∆o encontrado"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "NOK".
        END.
    END.
    ELSE DO:
        MESSAGE "Usuario Mestre ou Usuario Inf n∆o Encontrado"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK".
    END.





END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToRepres DBOProgram 
PROCEDURE linkToRepres :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
   RUN getKey IN pHandle (OUTPUT v-cod-rep).
   
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
            RUN openQueryStatic ("Comis-deb-cred":U).                 
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryComis-deb-cred DBOProgram 
PROCEDURE openQueryComis-deb-cred :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-rep = v-cod-rep                        
        AND {&TableName}.cod-mov = v-cod-mov                          
        AND {&TableName}.dt-movto = v-dt-movto                        
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixa DBOProgram 
PROCEDURE openQueryFaixa :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK USE-INDEX ch_principal
        WHERE {&TableName}.cod-rep   = v-cod-rep
        AND   {&TableName}.dt-movto >= v-ini-data-movto
        AND   {&TableName}.dt-movto <= v-fim-data-movto
        AND   {&TableName}.cod-mov  >= v-ini-cod-mov
        AND   {&TableName}.cod-mov  <= v-fim-cod-mov
        INDEXED-REPOSITION.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRepres DBOProgram 
PROCEDURE openQueryRepres :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-rep = v-cod-rep.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintComis-deb-cred DBOProgram 
PROCEDURE setConstraintComis-deb-cred :
DEFINE INPUT PARAMETER p-cod-rep AS integer NO-UNDO.                                                                            
    DEFINE INPUT PARAMETER p-cod-mov AS integer NO-UNDO.                                                                            
    DEFINE INPUT PARAMETER p-dt-movto AS date NO-UNDO.                                                                              

    ASSIGN 
    v-cod-rep = p-cod-rep                                             
    v-cod-mov = p-cod-mov                                             
    v-dt-movto = p-dt-movto                                           
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixa DBOProgram 
PROCEDURE setConstraintFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-ini-data-movto AS DATE NO-UNDO.
    DEF INPUT PARAM p-fim-data-movto AS DATE NO-UNDO.
    DEFINE INPUT PARAMETER p-ini-cod-mov AS integer NO-UNDO.                                                                            
    DEFINE INPUT PARAMETER p-fim-cod-mov AS integer NO-UNDO.                                                                            

    ASSIGN v-ini-data-movto = p-ini-data-movto
           v-fim-data-movto = p-fim-data-movto
           v-ini-cod-mov    = p-ini-cod-mov
           v-fim-cod-mov    = p-fim-cod-mov.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRepres DBOProgram 
PROCEDURE setRepres :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-rep AS integer NO-UNDO.                                                                            

    ASSIGN 
    v-cod-rep = p-cod-rep                                             
    .
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
                 WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
                 AND bf{&TableName}.unid-neg = RowObject.unid-neg
                 AND bf{&TableName}.cod-rep = RowObject.cod-rep
                 AND bf{&TableName}.cod-mov = RowObject.cod-mov
                 AND bf{&TableName}.dt-movto = RowObject.dt-movto) THEN DO:

                 {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

             IF NOT can-find(estabelec NO-LOCK
                             where estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:

                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'Estabelecimento'"
                 }
             END.

             IF NOT can-find(repres NO-LOCK
                             where repres.cod-rep = RowObject.cod-rep) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'Representante'"
                 }
             END.

             IF NOT can-find(mov-comis NO-LOCK
                             where mov-comis.cod-mov = RowObject.cod-mov) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'Movimentos de comis'"
                 }
             END.

             if month(today) > 1 then do:
                if (month(RowObject.dt-movto) < month(today) - 1 
                AND year(RowObject.dt-movto) = year(today)) 
                OR  year(RowObject.dt-movto) < year(today) then do:
                RUN _insertErrorManual 
                    (INPUT 0,
                     INPUT "EMS",
                     INPUT "ERROR",
                     INPUT "Data informada n∆o pode ser inferior ao màs corrente",
                     INPUT "Data informada n∆o pode ser inferior ao màs corrente",
                     INPUT "").
                end.
             end.

             IF RowObject.valor <= 0 THEN DO:
                 RUN _insertErrorManual 
                     (INPUT 0,
                      INPUT "EMS",
                      INPUT "ERROR",
                      INPUT "Valor n∆o pode ser zeros",
                      INPUT "Valor n∆o pode ser zeros",
                      INPUT "").
             END.
         END.
         WHEN "Update" THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
                 AND bf{&TableName}.unid-neg = RowObject.unid-neg
                 AND bf{&TableName}.cod-rep = RowObject.cod-rep
                 AND bf{&TableName}.cod-mov = RowObject.cod-mov
                 AND bf{&TableName}.dt-movto = RowObject.dt-movto) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

             IF RowObject.valor <= 0 THEN DO:
                 RUN _insertErrorManual 
                     (INPUT 0,
                      INPUT "EMS",
                      INPUT "ERROR",
                      INPUT "Valor n∆o pode ser zeros",
                      INPUT "Valor n∆o pode ser zeros",
                      INPUT "").
             END.
         END.
         WHEN "Delete" THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
                 AND bf{&TableName}.unid-neg = RowObject.unid-neg
                 AND bf{&TableName}.cod-rep = RowObject.cod-rep
                 AND bf{&TableName}.cod-mov = RowObject.cod-mov
                 AND bf{&TableName}.dt-movto = RowObject.dt-movto) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

         END.
    END CASE.

    IF  pType = "Create" OR pType = "Update" THEN DO:
        IF  RowObject.cod-mov NE 4 AND 
            RowObject.cod-mov NE 10 THEN DO:

            IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
                RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

            RUN pi_valida_conta_contabil in h_api_cta_ctbl (INPUT  "",                 /* EMPRESA EMS2 */
                                                            INPUT  "",                 /* ESTABELECIMENTO EMS2 */
                                                            INPUT  "",                 /* UNIDADE NEGπCIO */
                                                            INPUT  "",                 /* PLANO CONTAS */ 
                                                            INPUT  STRING(RowObject.ct-codigo, ">>>>>>>>"),        /* CONTA */
                                                            INPUT  "",                 /* PLANO CCUSTO */ 
                                                            INPUT  STRING(RowObject.sc-codigo, ">>>>>"),        /* CCUSTO */
                                                            INPUT  TODAY,              /* DATA TRANSACAO */
                                                            OUTPUT TABLE tt_log_erro). /* ERROS */
            DELETE OBJECT h_api_cta_ctbl.

            FOR EACH tt_log_erro:
                {method/svc/errors/inserr.i
                         &ErrorNumber="17006"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="tt_log_erro.ttv_des_msg_erro + '~~~~' + tt_log_erro.ttv_des_msg_ajuda"}
            END.
        END.
    END.

    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE piEnviaEmail :
    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)'  NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)'  NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)'  NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(250)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)'  NO-UNDO.

    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK: END.    

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = pdestino                 /* Destinat†rio       */ 
           tt-envio2.remetente         = pRemetente               /* Remetente          */ 
           tt-envio2.assunto           = pAssunto                 /* Assunto            */
           tt-envio2.arq-anexo         = pArquivo                 /* Arquivo Tempor†rio */
           tt-envio2.formato           = "TEXTO".
    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = pDescEmail.          /* Mensagem           */


    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    /*
    for each tt-erros:
        put tt-erros.desc-erro.
    end.*/
END PROCEDURE.
