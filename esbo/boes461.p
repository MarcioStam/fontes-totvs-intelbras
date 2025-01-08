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
{include/i-prgvrs.i BOES461 2.00.00.000}                               
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
&GLOBAL-DEFINE DBOName  BOES461
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  ctb-tipo-verba
&GLOBAL-DEFINE TableLabel  Contab Tipo Verba             
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
{esbo/boes461.i RowObject}
{upc/btb910za-upc.i}
{utp/ut-glob.i}
 
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Definiá∆o de vari†veis *********************** */
define variable v-codigo as integer no-undo.
define variable v-cod-estabel as character no-undo.
define variable v-cod-unid-negoc as character no-undo.
DEFINE VARIABLE v-cod-ccusto AS CHARACTER NO-UNDO.


def temp-table tt_log_erro_api_ccusto no-undo
    field ttv_num_cod_erro   as integer   format ">>>>,>>9" label "N£mero"         column-label "N£mero"
    field ttv_des_msg_ajuda  as character format "x(40)"    label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro   as character format "x(60)"    label "Mensagem Erro"  column-label "Inconsistància".

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
         HEIGHT             = 12.96
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.                                                                       

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
        WHEN "cod_ccusto":U THEN ASSIGN pFieldValue = RowObject.cod_ccusto.
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
    DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-cod-unid-negoc AS character NO-UNDO.  
    DEFINE INPUT PARAMETER p-cod-ccusto AS CHARACTER NO-UNDO.

    FIND bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.codigo = p-codigo                        
        AND bf{&TableName}.cod-estabel = p-cod-estabel                
        AND bf{&TableName}.cod-unid-negoc = p-cod-unid-negoc 
        AND bf{&TableName}.cod_ccusto = p-cod-ccusto
        NO-ERROR.
    IF NOT AVAILABLE bf{&TableName} THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToTipoVerba DBOProgram 
PROCEDURE linkToTipoVerba :
DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
   RUN getKey IN pHandle (OUTPUT v-codigo).
   
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
            RUN openQueryStatic ("Ch-principal":U).                   
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-principal DBOProgram 
PROCEDURE openQueryCh-principal :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.codigo = v-codigo                          
        AND {&TableName}.cod-estabel = v-cod-estabel                  
        AND {&TableName}.cod-unid-negoc = v-cod-unid-negoc
        AND {&TableName}.cod_ccusto = v-cod-ccusto
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCtbTipoVerba DBOProgram 
PROCEDURE openQueryCtbTipoVerba :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-principal DBOProgram 
PROCEDURE setConstraintCh-principal :
DEFINE INPUT PARAMETER p-codigo AS integer NO-UNDO.                                                                             
    DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-cod-unid-negoc AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-ccusto AS CHARACTER NO-UNDO.

    ASSIGN 
    v-codigo = p-codigo                                               
    v-cod-estabel = p-cod-estabel                                     
    v-cod-unid-negoc = p-cod-unid-negoc 
    v-cod-ccusto = p-cod-ccusto
    .
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
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE h-esapi015 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-descricao AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE h_api_ccusto AS HANDLE      NO-UNDO.

    CASE pType:
         WHEN "Create" THEN DO:
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.codigo = RowObject.codigo
                 AND bf{&TableName}.cod-estabel = RowObject.cod-estabel
                 AND bf{&TableName}.cod-unid-negoc = RowObject.cod-unid-negoc
                 AND bf{&TableName}.cod_ccusto = RowObject.cod_ccusto) THEN DO:
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
                 WHERE bf{&TableName}.codigo = RowObject.codigo
                 AND bf{&TableName}.cod-estabel = RowObject.cod-estabel
                 AND bf{&TableName}.cod-unid-negoc = RowObject.cod-unid-negoc
                 AND bf{&TableName}.cod_ccusto = RowObject.cod_ccusto) THEN DO:
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
                 WHERE bf{&TableName}.codigo = RowObject.codigo
                 AND bf{&TableName}.cod-estabel = RowObject.cod-estabel
                 AND bf{&TableName}.cod-unid-negoc = RowObject.cod-unid-negoc
                 AND bf{&TableName}.cod_ccusto = RowObject.cod_ccusto) THEN DO:
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
        IF NOT CAN-FIND(FIRST tipo-verba NO-LOCK
                        WHERE tipo-verba.codigo = RowObject.codigo) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'C¢digo Tipo Verba inv†lido.~~~~C¢digo Tipo Verba n∆o cadastrado.'"}
        END.
        /*Validaá∆o conta totvs 11*/
        EMPTY TEMP-TABLE tt_log_erro.
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        run pi_valida_conta_contabil in h_api_cta_ctbl 
                                                  (input  i-ep-codigo-usuario,                /* EMPRESA EMS2 */
                                                   input  v_cod_estab_usuar,   /* ESTABELECIMENTO EMS2 */
                                                   input  "",                      /* UNIDADE NEG‡CIO */
                                                   input  "",                      /* PLANO CONTAS */ 
                                                   input  RowObject.ct-codigo,     /* CONTA */
                                                   input  "",                      /* PLANO CCUSTO */ 
                                                   input  RowObject.cod_ccusto,     /* CCUSTO */
                                                   input  today,    /* DATA TRANSACAO */
                                                   output table tt_log_erro).      /* ERROS */
        for first tt_log_erro:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro)"}           
        end.

        if valid-handle(h_api_cta_ctbl) then
            delete object h_api_cta_ctbl.

        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Estabelecimento inv†lido.~~~~C¢digo Estabelecimento n∆o cadastrado.'"}
        END.

        IF RowObject.cod-unid-negoc = "" THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Unidade Neg¢cio inv†lida.~~~~Unidade Neg¢cio deve ser informada.'"}
        END.
        IF RowObject.cod_ccusto = "" THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Centro de Custo inv†lido..~~~~Centro de Custo deve ser informado.'"}
        END.
        IF RowObject.ct-codigo = "" THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Conta Cont†bil inv†lida..~~~~Conta Cont†bil deve ser informada.'"}
        END.

        if not valid-handle(h_api_ccusto) then 
            run prgint/utb/utb742za.py persistent set h_api_ccusto.
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (INPUT "",
                                                           INPUT "",
                                                           INPUT "",
                                                           INPUT RowObject.ct-codigo,
                                                           INPUT today,
                                                           OUTPUT p_log_ccusto,
                                                           OUTPUT TABLE tt_log_erro_api_ccusto).
        IF NOT p_log_ccusto THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Centro de Custo Inv†lido para a Conta Cont†bil..~~~~Informe um Centro de Custo V†lido.'"}
        END.
        IF VALID-HANDLE(h_api_ccusto) THEN
            ASSIGN h_api_ccusto = ?.
    
    END.    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

