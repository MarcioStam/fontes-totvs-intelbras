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
&GLOBAL-DEFINE DBOName BOES400
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName cat
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
{esbo/boes400.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{esp/es0018.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE var v-cod-estabel-ini AS char    NO-UNDO.                                                                        
DEFINE var v-cod-estabel-fim AS char    NO-UNDO.                                                                        
DEFINE var v-cat-ini         AS INTEGER NO-UNDO.                                                                        
DEFINE var v-cat-fim         AS INTEGER NO-UNDO.                                                                        
DEFINE var v-sequencia-ini   AS INTEGER NO-UNDO.                                                                        
DEFINE var v-sequencia-fim   AS INTEGER NO-UNDO. 

/* ---------------------- VARIAVEIS CRIAÄ«O DE PEDIDOS CAT ---------------- */

DEFINE TEMP-TABLE tt-ped-venda no-undo like ped-venda
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-ped-item no-undo like ped-item
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-ped-ent no-undo like ped-ent
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-ped-repre no-undo like ped-repre
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-ped-antecip no-undo like ped-antecip
    field r-rowid  as rowid.
DEFINE TEMP-TABLE tt-cond-ped no-undo like cond-ped
    field r-rowid  as rowid.

def temp-table tt-ped-vendor
    field data-base    as date
    field dias-base    as int  format ">>>9"
    field cod-cond-pag as int  format ">9"
    field taxa-cliente as dec  format ">>9.9999".

def temp-table tt-erro no-undo
    field i-sequen as int
    field cd-erro  as int
    field mensagem as char format "x(255)".

def new global shared variable c-seg-usuario as char no-undo.
def var i-cliente        like emitente.cod-emitente no-undo.
def var d-vl-liq-abe     like tt-ped-item.vl-liq-abe no-undo.
def var d-vl-liq-it      like tt-ped-item.vl-liq-abe no-undo.
def var c-endereco       as char format "x(50)"  no-undo.
def var c-assunto        as char format "x(50)" no-undo.
def var i-sequencia      as i no-undo.
def var i-cont           as i.
def var d-perc           as dec init 0.
def var d-valor-min      as dec init 0.
def var c-pagto          as char format "x(20)".
def var l-primeiro       as log init yes.
def var de-vl-ipi        as dec.
def var de-vl-liq-abe    as dec.
def var de-vl-liq        as dec.
def var l-envia          as log.
def var c-prazo          as char.
def var c-obs            as char.
def var c-perm           as char.
def var c-nat-oper       like natur-oper.nat-operacao.
def var l-avalia         as log.
def var c-mail-aten      as char format "X(60)".
def var de-perc          AS DEC.
def var c-cgc-rep        like repres.cgc.
def var l-abaixo-min     as log.
DEF VAR c-desc-suspend   AS CHAR.
DEF VAR l-erro           AS LOG.
DEF VAR de-tot-cipi      AS DEC FORMAT ">>>,>>>,>>9.99".
DEF VAR de-tot-sipi      AS DEC FORMAT ">>>,>>>,>>9.99".
DEFINE VAR cRemetente    AS CHAR FORMAT 'x(60)' NO-UNDO.
DEFINE VAR CDestino      AS CHAR FORMAT 'x(60)' NO-UNDO.
DEFINE VAR CAssunto      AS CHAR FORMAT 'x(60)' NO-UNDO.
DEFINE VAR CDescEmail    AS CHAR FORMAT 'x(2000)' NO-UNDO.
DEFINE VAR CArqEmail     AS CHAR FORMAT 'x(60)' NO-UNDO.
DEF VARIABLE iCont       AS INTEGER    NO-UNDO.
def var h-bodi149        as handle no-undo.
def var h-bodi154        as handle no-undo.
def var h-bodi157        as handle no-undo.
def var h-bodi159        as handle no-undo.
def var h-bodi159cal     AS handle no-undo.
def var h-bodi159sus     as handle no-undo.
DEF VAR cArq             AS CHAR FORMAT "X(20)".
DEF VAR cArqcaminho      AS CHAR FORMAT "X(50)".
DEF VAR cArqId           AS CHAR FORMAT "X(20)".
DEF VAR c-pedido         AS CHAR FORMAT "x(12)".

/* -------------- FIM VARIAVEIS CRIAÄ«O DE PEDIDOS CAT ----------------- */





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
         HEIGHT             = 2
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
        WHEN "consertado-por":U THEN ASSIGN pFieldValue = RowObject.consertado-por.
        WHEN "defeito-constatado":U THEN ASSIGN pFieldValue = RowObject.defeito-constatado.
        WHEN "defeito-reclamado":U THEN ASSIGN pFieldValue = RowObject.defeito-reclamado.
        WHEN "nat-oper-entr":U THEN ASSIGN pFieldValue = RowObject.nat-oper-entr.
        WHEN "nr-pedcli-retorno":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli-retorno.
        WHEN "nr-pedcli-revenda":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli-revenda.
        WHEN "nr-pedcli-venda":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli-venda.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "solucao":U THEN ASSIGN pFieldValue = RowObject.solucao.
        WHEN "testado-por":U THEN ASSIGN pFieldValue = RowObject.testado-por.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-conserto":U THEN ASSIGN pFieldValue = RowObject.dt-conserto.
        WHEN "dt-teste":U THEN ASSIGN pFieldValue = RowObject.dt-teste.
        WHEN "dt-cat":U THEN ASSIGN pFieldValue = RowObject.dt-cat.
        WHEN "dt-validade":U THEN ASSIGN pFieldValue = RowObject.dt-validade.
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
        WHEN "vl-a-pagar":U THEN ASSIGN pFieldValue = RowObject.vl-a-pagar.
        WHEN "vl-acrescimo":U THEN ASSIGN pFieldValue = RowObject.vl-acrescimo.
        WHEN "vl-cat":U THEN ASSIGN pFieldValue = RowObject.vl-cat.
        WHEN "vl-desconto":U THEN ASSIGN pFieldValue = RowObject.vl-desconto.
        WHEN "vl-mao-obra":U THEN ASSIGN pFieldValue = RowObject.vl-mao-obra.
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
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "cod-cond-pagto":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pagto.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "ind-situacao":U THEN ASSIGN pFieldValue = RowObject.ind-situacao.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-cat":U THEN ASSIGN pFieldValue = RowObject.nr-cat.
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
  Purpose:     Retorna valores dos campos do °ndice ch_principal
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-cat
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE cat.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-cat LIKE cat.nr-cat NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE cat.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-cat = RowObject.nr-cat
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
  Purpose:     Reposiciona registro com base no °ndice ch_principal
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-cat
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE cat.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-cat LIKE cat.nr-cat NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE cat.sequencia NO-UNDO.

    FIND FIRST bfcat WHERE 
        bfcat.cod-estabel = pcod-estabel AND 
        bfcat.nr-cat = pnr-cat AND 
        bfcat.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcat THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcat)).
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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryRangeCat DBOProgram 
PROCEDURE OpenQueryRangeCat:

OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-estabel >= v-cod-estabel-ini
        AND {&TableName}.cod-estabel   <= v-cod-estabel-fim
        AND {&TableName}.nr-cat        >= v-cat-ini       
        AND {&TableName}.nr-cat        <= v-cat-fim
        AND {&TableName}.sequencia     >= v-sequencia-ini
        AND {&TableName}.sequencia     <= v-sequencia-fim.
    RETURN "OK":U.
END PROCEDURE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCat DBOProgram 
PROCEDURE setConstraintRangecat:

DEFINE INPUT PARAMETER p-cod-estabel-ini AS char NO-UNDO.                                                                        
DEFINE INPUT PARAMETER p-cod-estabel-fim AS char NO-UNDO.                                                                        
DEFINE INPUT PARAMETER p-cat-ini       AS integer NO-UNDO.                                                                        
DEFINE INPUT PARAMETER p-cat-fim       AS INTEGER NO-UNDO.                                                                        
DEFINE INPUT PARAMETER p-sequencia-ini AS INTEGER NO-UNDO.                                                                        
DEFINE INPUT PARAMETER p-sequencia-fim AS INTEGER NO-UNDO. 

    ASSIGN v-cod-estabel-ini = p-cod-estabel-ini
           v-cod-estabel-fim = p-cod-estabel-fim
           v-cat-ini         = p-cat-ini
           v-cat-fim         = p-cat-fim
           v-sequencia-ini   = p-sequencia-ini
           v-sequencia-fim   = p-sequencia-fim    .
    RETURN "OK":U.

END PROCEDURE.

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
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

procedure pi-cria-pedidos:
def input parameter c-cod-estabel like cat.cod-estabel.
def input parameter i-nr-cat      like cat.nr-cat.
def input parameter i-seq-cat     like cat.sequencia.
def output parameter c-nr-pedido-out     as char.
def output parameter TABLE FOR    rowerrors.
def var h-acomp      as handle no-undo.

DEF VAR  i-cond-pagto LIKE cat.cod-cond-pagto.
DEF VAR i-cod-transp LIKE cat.cod-transp .


FIND FIRST para-ped NO-LOCK.
FIND FIRST para-fat NO-LOCK.
find first param-cat no-lock.

   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
do trans:
    FIND FIRST cat
        WHERE cat.nr-cat = i-nr-cat
        AND cat.cod-cond-pagto <> 0
        NO-LOCK NO-ERROR.
    IF AVAIL cat THEN 
        ASSIGN i-cond-pagto = cat.cod-cond-pagto
               i-cod-transp = cat.cod-transp.
    
    for each cat exclusive-lock
        where cat.cod-estabel = c-cod-estabel
          and cat.nr-cat      = i-nr-cat,
         each cat-item exclusive-lock
        where cat-item.cod-estabel = cat.cod-estabel
          and cat-item.nr-cat      = cat.nr-cat
          and cat-item.sequencia   = cat.sequencia
          and cat-item.vl-tot-item > 0
        break by cat-item.ind-tipo-faturamento
              by cat-item.sequencia:
              
           RUN pi-acompanhar IN h-acomp (INPUT "Criando Pedido:" + string(cat.nr-cat) + " - " + string(cat.sequencia)).
    
        

        
        if first-of(cat-item.ind-tipo-faturamento) then do:
    
              assign d-vl-liq-abe = 0
                     d-vl-liq-it  = 0
                     i-sequencia  = 0
                     l-abaixo-min = no
                     c-desc-suspend = ""
                     l-erro = NO.
    
              RUN pi-zerar-temporarias.
    
              find emitente no-lock
                   where emitente.cod-emitente = cat.cod-emitente
                   no-error.
    
              IF NOT AVAIL emitente THEN DO:
                 create rowerrors.
                 assign rowerrors.errordescription = "Cliente " + string(cat.cod-emitente) + " nao cadastrado ".
                 LEAVE.
              END.

              RUN esp/es0018p.p (INPUT "Rakuten":U,
                                 INPUT 1,
                                 INPUT 0,
                                 INPUT "":U,
                                 OUTPUT TABLE tt-prog-ponto).

              FIND FIRST tt-prog-ponto NO-ERROR.

              IF AVAIL tt-prog-ponto THEN DO:
                  find repres no-lock where
                       repres.cod-rep = int(tt-prog-ponto.conteudo) no-error.
              END.
              ELSE DO:
                  find repres no-lock where
                       repres.cod-rep = emitente.cod-rep no-error.
              END.
    
              IF NOT AVAIL repres THEN DO:
                 create rowerrors.
                 assign rowerrors.errordescription = "Representante " + string(emitente.cod-rep) + " do cliente nío cadastrado.".
                 LEAVE.
              END.
    
              find first repres-atend no-lock
                 where  repres-atend.cod-estabel = cat.cod-estabel AND  
                        repres-atend.cod-rep    = emitente.cod-rep  AND
                        repres-atend.cod-gr-cli = emitente.cod-gr-cli no-error.
    
              IF NOT AVAIL repres-atend THEN DO:
                 create rowerrors.
                 assign rowerrors.errordescription = "Atendente do Representante " + string(emitente.cod-rep) + " e grupo de cliente " + string(emitente.cod-gr-cli) + " nío cadastrado.".
                 LEAVE.
              END.
    
              find first loc-entr no-lock use-index ch-entrega
                  WHERE loc-entr.cod-entrega = "padrao"
                    AND loc-entr.nome-abrev  = emitente.nome-abrev no-error.
    
              IF NOT AVAIL loc-entr THEN DO:
                 create rowerrors.
                 assign rowerrors.errordescription = "Local de entrega do cliente " + string(emitente.cod-emitente) + " nío cadastrado.".
                 LEAVE.
              END.
    
              FIND FIRST transporte
                  WHERE transporte.cod-transp = cat.cod-transp
                  NO-LOCK NO-ERROR.
    
              IF NOT AVAIL transporte THEN DO:
                  FIND FIRST transporte
                      WHERE transporte.cod-transp = i-cod-transp
                      NO-LOCK NO-ERROR.
                  IF NOT AVAIL transporte THEN DO:
                     create rowerrors.
                     assign rowerrors.errordescription = "Transportador do cat nao cadastrado no local de entrega.".
                     LEAVE.
                  END.
              END.
                
              find cond-pagto no-lock where
                   cond-pagto.cod-cond-pag = cat.cod-cond-pag no-error.
    
              IF NOT AVAIL cond-pagto THEN DO:
                  find cond-pagto no-lock where
                       cond-pagto.cod-cond-pag = i-cond-pagto no-error.
                 IF NOT AVAIL cond-pagto THEN DO:
                     create rowerrors.
                     assign rowerrors.errordescription = "Condicao de pagamento " + string(cat.cod-cond-pag) + " nao cadastrado.".
                  
                     LEAVE.
                 END.
              END.
              
              find estabelec
                   where estabelec.cod-estabel = cat.cod-estabel no-lock no-error.          
                
              if cat-item.ind-tipo-faturamento = 1 then /* Retorno */
                 if estabelec.estado = emitente.estado then
                    assign c-nat-oper = param-cat.nat-oper-retorno-de.
                 else
                    assign c-nat-oper = param-cat.nat-oper-retorno-fe.
              else
                  if cat-item.ind-tipo-faturamento = 2 then /* Venda */
                     if estabelec.estado = emitente.estado then
                        assign c-nat-oper = param-cat.nat-oper-venda-de.
                     else
                        assign c-nat-oper = param-cat.nat-oper-venda-fe.
                  else
                      if cat-item.ind-tipo-faturamento = 3 then /* Revenda */
                         if estabelec.estado = emitente.estado then
                            assign c-nat-oper = param-cat.nat-oper-revenda-de.
                         else
                            assign c-nat-oper = param-cat.nat-oper-revenda-fe.
              
    
              find natur-oper no-lock where
                   natur-oper.nat-operacao = c-nat-oper no-error.
    
              IF NOT AVAIL natur-oper THEN DO:
                 create rowerrors.
                 assign rowerrors.errordescription = "Natureza de operacao " + c-nat-oper + "Nao Encontrada".
                 LEAVE.
              END.
    
              create tt-ped-venda.
    
              /* find last ped-venda USE-INDEX ch-pedido no-lock no-error. */
    
              assign tt-ped-venda.nr-pedido = NEXT-VALUE(seq-nr-pedido)
                     tt-ped-venda.nome-abrev = emitente.nome-abrev.
    
              ASSIGN c-pedido = string(tt-ped-venda.nr-pedido).
    
              ASSIGN tt-ped-venda.nr-pedcli = c-pedido.
              assign c-nr-pedido-out = c-nr-pedido-out + " / " + c-pedido.
    
              assign tt-ped-venda.cod-estabel    = cat.cod-estabel
                     tt-ped-venda.dt-emissao     = today
                     tt-ped-venda.no-ab-reppri   = repres.nome-abrev
                     tt-ped-venda.dt-implant     = today
                     tt-ped-venda.nome-transp    = transporte.nome-abrev
                     tt-ped-venda.cod-emitente   = emitente.cod-emitente
                     tt-ped-venda.nat-operacao   = natur-oper.nat-operacao
                     tt-ped-venda.cod-mensagem   = natur-oper.cod-mensagem
                     tt-ped-venda.cod-cond-pag   = if cat-item.ind-tipo-faturamento = 1 then 0 else cat.cod-cond-pag
                     tt-ped-venda.nr-tab-fin     = cond-pagto.nr-tab-finan
                     tt-ped-venda.nr-ind-finan   = cond-pagto.nr-ind-finan
                     tt-ped-venda.tp-pedido      = string(repres-atend.cd-oper)
                     tt-ped-venda.e-mail         = emitente.e-mail
                     tt-ped-venda.cod-sit-aval   = 1   /* Credito nao Avaliado */
                     tt-ped-venda.mo-codigo      = 0
                     tt-ped-venda.cod-gr-cli     = emitente.cod-gr-cli
                     tt-ped-venda.tp-faturam     = 1
                     tt-ped-venda.origem         = 6
                     tt-ped-venda.atendido       = no
                     tt-ped-venda.cd-origem      = 2
                     tt-ped-venda.user-impl      = c-seg-usuario
                     tt-ped-venda.dt-userimp     = today
                     tt-ped-venda.tip-cob-desp   = para-fat.tip-cob-desp
                     tt-ped-venda.observacoes    = cat.observacao
                     tt-ped-venda.cond-espec     = ""
                     tt-ped-venda.esp-ped        = 1
                     tt-ped-venda.cod-priori     = 01
                     tt-ped-venda.cod-rota       = ""
                     tt-ped-venda.cod-canal-venda  = if natur-oper.cod-canal-venda <> 0 then
                                                        natur-oper.cod-canal-venda
                                                     else emitente.cod-canal-venda
                     tt-ped-venda.ind-ent-completa = YES
                     tt-ped-venda.dsp-pre-fat      = YES
                     tt-ped-venda.log-usa-tabela-desconto = NO
                     tt-ped-venda.ind-lib-nota     = para-ped.ind-lib-nota WHEN avail para-ped.
              if cat-item.ind-tipo-faturamento <> 1 THEN
                  IF tt-ped-venda.cod-cond-pag = 0 THEN
                     ASSIGN tt-ped-venda.cod-cond-pag = i-cond-pagto.
                  
              if natur-oper.consum-final then
                 assign tt-ped-venda.cod-des-merc = 2.
              else
                 assign tt-ped-venda.cod-des-merc = 1.
    
             assign tt-ped-venda.dt-entrega = today
                    tt-ped-venda.dt-entorig = today.
    
             if  avail loc-entr then
                 ASSIGN tt-ped-venda.local-entreg = loc-entr.endereco
                        tt-ped-venda.bairro       = loc-entr.bairro
                        tt-ped-venda.cidade       = loc-entr.cidade
                        tt-ped-venda.pais         = loc-entr.pais
                        tt-ped-venda.estado       = loc-entr.estado
                        tt-ped-venda.cep          = loc-entr.cep
                        tt-ped-venda.caixa-postal = loc-entr.caixa-postal
                        tt-ped-venda.cgc          = loc-entr.cgc
                        tt-ped-venda.ins-estadual = loc-entr.ins-estadual
                        tt-ped-venda.cod-entrega  = loc-entr.cod-entrega
                        tt-ped-venda.cidade-cif   = "".
             else
                 if  avail emitente then
                     ASSIGN tt-ped-venda.local-entreg = emitente.endereco
                            tt-ped-venda.bairro       = emitente.bairro
                            tt-ped-venda.cidade       = emitente.cidade
                            tt-ped-venda.pais         = emitente.pais
                            tt-ped-venda.estado       = emitente.estado
                            tt-ped-venda.cep          = emitente.cep
                            tt-ped-venda.caixa-postal = emitente.caixa-postal
                            tt-ped-venda.cgc          = emitente.cgc
                            tt-ped-venda.ins-estadual = emitente.ins-estadual
                            tt-ped-venda.cidade-cif   = emitente.cidade.
    
              assign tt-ped-venda.ind-fat-par = no.
              /***** CRIACAO DO PED-REPRE ******* */
              find first tt-ped-repre where
                   tt-ped-repre.nr-pedido = tt-ped-venda.nr-pedido and
                   tt-ped-repre.nome-ab-rep = repres.nome-abrev no-error.
    
              assign c-cgc-rep = repres.cgc.
    
              if not avail tt-ped-repre then do:
                find first comis-rep no-lock where
                     comis-rep.cod-gr-cli = emitente.cod-gr-cli and
                     comis-rep.cod-rep = repres.cod-rep and
                     comis-rep.dt-ini <= today and
                     comis-rep.dt-fim >= today no-error.
    
                assign de-perc = 0.
                if not avail comis-rep then do:
                   assign c-desc-suspend = " Repres " + string(repres.cod-rep,">>>>9") +
                                 " sem comissao cadastrada".
                end.
                else
                   assign de-perc = comis-rep.perc.
    
                 create tt-ped-repre.
                 assign tt-ped-repre.nr-pedido = tt-ped-venda.nr-pedido
                        tt-ped-repre.ind-repbase = yes
                        tt-ped-repre.perc-comis =  de-perc
                        tt-ped-repre.nome-ab-rep = repres.nome-abrev.
              end.
    
    
            /*** Atribuir Portador conforme o cadastro do cliente ***/
              if emitente.portador <> 0 then
                 assign tt-ped-venda.cod-portador = emitente.portador
                        tt-ped-venda.modalidade   = emitente.modalidade.
              else
                 assign tt-ped-venda.cod-portador = 999
                        tt-ped-venda.modalidade   = 6.
    
        end.
    
    
    /*************** ITENS DO PEDIDO   ****************** */
    
    
        find item no-lock where
             item.it-codigo = cat-item.it-codigo no-error.
    
        if not avail item then do:         
            create rowerrors.
            assign rowerrors.errordescription = "Item " + cat-item.it-codigo + "Nao Encontrado".
            undo, return.
        end.
    
        FIND FIRST classif-fisc NO-LOCK
             WHERE classif-fisc.class-fiscal = ITEM.class-fisc NO-ERROR.
    
        IF NOT AVAIL classif-fisc OR item.class-fisc = "" THEN DO:
            create rowerrors.
            assign rowerrors.errordescription = "Classificacao fiscal " + item.class-fisc + "Nao Encontrado ou em branco no cadastro de itens".
            undo, return.
        end.         
    
        find repres no-lock where
             repres.nome-abrev = tt-ped-venda.no-ab-reppri no-error.
    
        find first tt-ped-item exclusive-lock
             where tt-ped-item.nome-abrev = tt-ped-venda.nome-abrev
               and tt-ped-item.nr-pedcli = tt-ped-venda.nr-pedcli
               and tt-ped-item.it-codigo = item.it-codigo
               and tt-ped-item.vl-preori = cat-item.vl-unitario no-error.
        if avail tt-ped-item then do:
           find tt-ped-ent of tt-ped-item exclusive-lock no-error.
           assign tt-ped-item.qt-pedida = tt-ped-item.qt-pedida + cat-item.quantidade
                  tt-ped-ent.qt-pedida  = tt-ped-item.qt-pedida.
        end.
        else do:

                /* ATRIBUIR SEQUENCIA AO ITEM */
              assign i-sequencia = i-sequencia + 10.        
                
              create tt-ped-item.    
              assign tt-ped-item.aliquota-ipi     = item.aliquota-ipi when avail item
                     tt-ped-item.nr-pedcli        = tt-ped-venda.nr-pedcli
                     tt-ped-item.cod-entrega      = tt-ped-venda.cod-entrega
                     tt-ped-item.dt-entrega       = tt-ped-venda.dt-entrega
                     substr(tt-ped-item.char-2,1,8) = ITEM.class-fiscal.
                     
              assign tt-ped-item.nr-sequencia = i-sequencia.               
          
              assign tt-ped-item.qt-pedida        = cat-item.quantidade
                     tt-ped-item.cod-sit-item     = tt-ped-venda.cod-sit-ped
                     tt-ped-item.cod-sit-pre      = tt-ped-venda.cod-sit-pre
                     tt-ped-item.dt-entorig       = tt-ped-venda.dt-entorig
                     tt-ped-item.dt-userimp       = tt-ped-venda.dt-userimp
                     tt-ped-item.esp-ped          = 1
                     tt-ped-item.it-codigo        = item.it-codigo when avail item
                     tt-ped-item.nat-operacao     = natur-oper.nat-operacao
                     tt-ped-item.nome-abrev       = tt-ped-venda.nome-abrev
                     tt-ped-item.per-des-icms     = natur-oper.per-des-icms
                     tt-ped-item.tp-adm-lote      = 1
                     tt-ped-item.tp-preco         = 0
                     tt-ped-item.user-impl        = tt-ped-venda.user-impl
                     tt-ped-item.vl-pretab        = cat-item.vl-unitario
                     tt-ped-item.vl-preori        = cat-item.vl-unitario
                     tt-ped-item.des-pct-desconto = string(cat-item.perc-desconto)
                     tt-ped-item.log-usa-tabela-desconto = NO
                     tt-ped-item.observacao    = ""
                     tt-ped-item.per-minfat   = if  avail emitente
                                             then emitente.per-minfat
                                             else tt-ped-item.per-minfat
                     tt-ped-item.cd-origem    = 2
                     tt-ped-item.tipo-atend   = IF tt-ped-venda.ind-fat-par THEN
                                                   2
                                                ELSE
                                                    1.
          
              /*** DEFINICAO DO VALOR UNITARIO COM DESCONTO ZFM ** */
          
              if natur-oper.per-des-icm > 0 then
                 assign tt-ped-item.vl-preuni = tt-ped-item.vl-preori -
                                            (tt-ped-item.vl-preori *
                                            (natur-oper.per-des-icm / 100))
                                            when avail natur-oper.
              else
                 assign tt-ped-item.vl-preuni = tt-ped-item.vl-preori.
              create tt-ped-ent.
              assign tt-ped-ent.nr-pedcli        = tt-ped-item.nr-pedcli
                     tt-ped-ent.cod-sit-ent      = tt-ped-item.cod-sit-item
                     tt-ped-ent.cod-sit-pre      = tt-ped-item.cod-sit-pre
                     tt-ped-ent.dt-entorig       = tt-ped-item.dt-entorig
                     tt-ped-ent.dt-entrega       = tt-ped-item.dt-entrega
                     tt-ped-ent.dt-userimp       = tt-ped-item.dt-userimp
                     tt-ped-ent.it-codigo        = tt-ped-item.it-codigo
                     tt-ped-ent.nome-abrev       = tt-ped-item.nome-abrev
                     tt-ped-ent.qt-pedida        = tt-ped-item.qt-pedida
                     tt-ped-ent.user-impl        = tt-ped-item.user-impl
                     tt-ped-ent.nr-sequencia     = tt-ped-item.nr-sequencia.
                 
        end.
        assign tt-ped-item.vl-liq-it   = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
               tt-ped-item.vl-merc-abe = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
               tt-ped-ent.vl-liq-it        = tt-ped-item.vl-liq-it         
               tt-ped-ent.vl-liq-abe       = tt-ped-item.vl-liq-abe.
    
        /*** TRATAMENTO IPI ** */
        if item.cd-trib-ipi = 1 and  /*** tributado *** */
          (natur-oper.cd-trib-ipi = 1 or      /**** tributado *** */
           natur-oper.cd-trib-ipi = 4) then  /**** Reduzido **** */
           assign tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it +
                                       (tt-ped-item.vl-liq-it *
                                        tt-ped-item.aliquota-ipi / 100).
        else
           assign tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it.
    
        assign tt-ped-item.vl-tot-it = tt-ped-item.vl-liq-abe.
    

    
    
        /* ATRIBUICAO DE VALORES TOTAIS DO PEDIDO */
        assign d-vl-liq-it  = d-vl-liq-it  + tt-ped-item.vl-liq-it
               d-vl-liq-abe = d-vl-liq-abe + tt-ped-item.vl-liq-abe.
     
        /* CASO ENCONTRE ALGUM ERRO, ENVIA E-MAIL E VAI PARA O PROXIMO ARQUIVO **** */
        IF l-erro  THEN
           NEXT.
    
        ASSIGN tt-ped-venda.nat-operacao = natur-oper.nat-operacao
               tt-ped-venda.cod-mensagem = natur-oper.cod-mensagem
               tt-ped-venda.cod-canal-venda  = if natur-oper.cod-canal-venda <> 0 then
                                                  natur-oper.cod-canal-venda
                                               else emitente.cod-canal-venda.
        if natur-oper.consum-final then
           assign tt-ped-venda.cod-des-merc = 2.
        else
           assign tt-ped-venda.cod-des-merc = 1.
    
        assign tt-ped-venda.vl-tot-ped = d-vl-liq-abe
               tt-ped-venda.vl-liq-abe = d-vl-liq-abe
               tt-ped-venda.vl-mer-abe = d-vl-liq-it
               tt-ped-venda.vl-liq-ped = d-vl-liq-it.
    
        find first repres no-lock
             where repres.nome-abrev = tt-ped-venda.no-ab-reppri no-error.
    
        /**** A COBRANCA DO FRETE SO ACONTECE PARA A UNIDADE DE CENTRAIS
              PARA PEDIDO COM VALOR ABAIXO DE R$ 3000,00
              NO CADASTRO DE LOCAIS DE ENTREGA CIDADE CIF = BRANCO
              IDENTIFICA SE CONTROLA FRETE CIF E FOB ******* */
    
        if emitente.cod-gr-cli = 22 OR emitente.cod-gr-cli = 23 or
           emitente.cod-gr-cli = 24 OR emitente.cod-gr-cli = 26 THEN DO:
           IF TT-ped-venda.vl-tot-ped > 3000 then
              assign tt-ped-venda.cidade-cif = tt-ped-venda.cidade.
           else
              assign tt-ped-venda.cidade-cif = "".
        END.
    
        if l-abaixo-min then do:
           assign tt-ped-venda.observacoes = tt-ped-venda.observacoes +  " CONTEM ITENS ABAIXO DO MINIMO. ".
        end.
    
        IF tt-ped-venda.observacoes <> "" THEN
           ASSIGN c-desc-suspend = c-desc-suspend + tt-ped-venda.observacoes.
    
        IF tt-ped-venda.cond-espec <> "" THEN
           ASSIGN c-desc-suspend = c-desc-suspend + tt-ped-venda.cond-espec.
    
        IF c-desc-suspend <> "" THEN
            ASSIGN tt-ped-venda.cod-priori = 99.       
        
        assign cat.ind-situacao = 2
               cat.dt-encerramento = today.
        if cat-item.ind-tipo-faturamento = 1 then
           assign cat.nr-pedcli-retorno  = c-pedido.
        else
           if cat-item.ind-tipo-faturamento = 2 then        
              assign cat.nr-pedcli-venda = c-pedido.
           else
               if cat-item.ind-tipo-faturamento = 3 then                   
                  assign cat.nr-pedcli-revenda = c-pedido.
        
        if last-of(cat-item.ind-tipo-faturamento) then do:
            ASSIGN l-erro = NO.
             RUN pi-executar-bos (INPUT c-desc-suspend,
                                  OUTPUT l-erro).
             IF l-erro THEN
                undo, leave.        
        end.
    end.  
    
 
end.       
   run pi-finalizar in h-acomp.
end procedure.

PROCEDURE pi-zerar-temporarias:
    FOR EACH tt-ped-venda:
        DELETE tt-ped-venda.
    END.

    FOR EACH tt-ped-item:
        DELETE tt-ped-item.
    END.


    FOR EACH tt-ped-ent:
        DELETE tt-ped-ent.
    END.

    FOR EACH tt-ped-repre:
        DELETE tt-ped-repre.
    END.

    for each tt-ped-vendor:
        delete tt-ped-vendor.
    end.

/*    FOR EACH tt-item-cli:
        DELETE tt-item-cli.
    END.
  */

/*    FOR EACH RowErrors:
        DELETE RowErrors.
    END.
  */
END PROCEDURE.





PROCEDURE pi-executar-bos.
    DEF INPUT PARAMETER p-desc-suspend AS CHAR.
    DEFINE OUTPUT PARAM l-erro         AS LOG NO-UNDO.
    
    bloco:
    DO  TRANSACTION ON ERROR  UNDO bloco, LEAVE bloco
                    ON ENDKEY UNDO bloco, LEAVE bloco:

        run dibo/bodi159.p persistent set h-bodi159.

        run openQueryStatic in h-bodi159(input "Main":U).
        run setRecord       in h-bodi159(input table tt-ped-venda).
        RUN inputRowVendor  IN h-bodi159(INPUT TABLE tt-ped-vendor).
        run emptyRowErrors in h-bodi159.
        run createMPLog    in h-bodi159(input no).
        RUN createRecord   in h-bodi159.
        run getRowErrors   in h-bodi159(output table RowErrors).

        if can-find (first RowErrors
                    where RowErrors.ErrorType   <> "INTERNAL":U
                        and RowErrors.ErrorSubType = "Error") then do:
                        for each rowerrors:
                        message "1 - erro " rowerrors.errornumber skip rowerrors.errordescription view-as alert-box.
                        end.
           undo, return.            
  
        END.
        IF l-erro  THEN
           UNDO bloco, LEAVE bloco.

        run destroyBO in h-bodi159.

        delete procedure h-bodi159.

        run dibo/bodi157.p persistent set h-bodi157.

        FOR EACH tt-ped-repre:
            run openQueryStatic in h-bodi157(input "Default":U).
            run emptyRowErrors in h-bodi157.
            run setRecord in h-bodi157(input table tt-ped-repre).
            run createMPLog  in h-bodi157(input no).
            run createRecord in h-bodi157.
            run getRowErrors in h-bodi157(output table RowErrors).

            if can-find (first RowErrors
                        where RowErrors.ErrorType   <> "INTERNAL":U
                            and RowErrors.ErrorSubType = "Error") then do:
                        message "2 - erro " view-as alert-box.                            
               undo, return.            
      
            END.
            DELETE tt-ped-repre.
        END.

        delete procedure h-bodi157.

        IF l-erro  THEN
           UNDO bloco, LEAVE bloco.

        run dibo/bodi154.p persistent set h-bodi154.

        FOR EACH tt-ped-item:
            run openQueryStatic in h-bodi154(input "Default":U).
            run emptyRowErrors in h-bodi154.
            run setRecord in h-bodi154(input table tt-ped-item).
            run createMPLog  in h-bodi154(input no).
            run createRecord in h-bodi154.
            run getRowErrors in h-bodi154(output table RowErrors).

            if can-find (first RowErrors
                        where RowErrors.ErrorType   <> "INTERNAL":U
                            and RowErrors.ErrorSubType = "Error") then do:
                        message "3 - erro " view-as alert-box.                            
               undo, return.            
      
            END.
            DELETE tt-ped-item.
        END.
        run destroyBO in h-bodi154.
        delete procedure h-bodi154.

        IF l-erro  THEN do:
                                message "4 - erro " view-as alert-box.
           UNDO bloco, LEAVE bloco.
        end.           


        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nr-pedcli = tt-ped-venda.nr-pedcli
               AND ped-venda.nome-abrev = tt-ped-venda.nome-abrev NO-ERROR.


        run dibo/bodi159com.p persistent set h-bodi159cal.
        
    
        run completeOrder in h-bodi159cal (input rowid(ped-venda),
                                           OUTPUT TABLE rowerrors).

        if can-find (first RowErrors
                    where RowErrors.ErrorType   <> "INTERNAL":U
                        and RowErrors.ErrorSubType = "Error") then do:
            FOR EACH rowerrors:
                MESSAGE rowerrors.errordescription SKIP
                    "Tipo " RowErrors.ErrorType
                    "Pedido " tt-ped-venda.nr-pedcli
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
        END.

        delete procedure h-bodi159cal.

        IF l-erro  THEN do:
                        message "6 - erro " view-as alert-box.        
           UNDO bloco, LEAVE bloco.
        end.
/*         IF p-desc-suspend <> "" THEN DO: */
/*             run dibo/bodi159sus.p persistent set h-bodi159sus. */
/*    */
/*             FOR EACH RowErrors: */
/*                 DELETE RowErrors. */
/*             END. */
/*    */
/*             run ValidateSuspension in h-bodi159sus (input rowid(ped-venda), */
/*                                                     OUTPUT TABLE RowErrors). */
/*             if can-find (first RowErrors */
/*                         where RowErrors.ErrorType   <> "INTERNAL":U */
/*                             and RowErrors.ErrorSubType = "Error") then do: */
/*                         message "7 - erro " view-as alert-box. */
/*                undo, return. */
/*    */
/*             END. */
/*             IF l-erro THEN */
/*                 UNDO bloco, LEAVE bloco. */
/*    */
/*             run UpdateSuspension in h-bodi159sus(input rowid(ped-venda), */
/*                                                  INPUT p-desc-suspend). */
/*             IF RETURN-VALUE <> "no":U AND */
/*                RETURN-VALUE <> "ok":U THEN DO: */
/*                         message "8 - erro " view-as alert-box. */
/*                 create rowerrors. */
/*                 assign rowerrors.errordescription = "Problema de integraªío entre B2B e EMS(CONFIRMA-SUSPENSAO)" + */
/*                                 " Cliente: " + ped-venda.nome-abrev + " Pedido: " + ped-venda.nr-pedcli. */
/*    */
/*                UNDO bloco, LEAVE bloco. */
/*             END. */
/*    */
/*             delete procedure h-bodi159sus. */
/*         END. */
    END.
    
        
    
END PROCEDURE.


