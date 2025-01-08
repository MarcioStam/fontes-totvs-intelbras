&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESWSO0004C 2.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESWSO0004C
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE page0Widgets   btOK btCancel BtFile fiFile


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define {1} temp-table MsgErro no-undo
    field SeqErro as integer
    field DescErro as character
        index idErro is primary unique SeqErro.

/*-------------------------------------------------------------------*/ 
/*     LAYOUT RESPOSTA AO WEB SERVICE QUE SE COMUNICA COM A VTEX     */
/*-------------------------------------------------------------------*/
DEF TEMP-TABLE ttResultado NO-UNDO XML-NODE-NAME "Resultado" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN' 
   FIELD sucesso AS LOG.

DEF TEMP-TABLE ttErro NO-UNDO XML-NODE-NAME "Erro"
   FIELD idm            AS INT XML-NODE-TYPE 'HIDDEN' 
   FIELD SeqErro        AS INT XML-NODE-TYPE 'HIDDEN' 
   FIELD codigoErro     AS INTEGER
   FIELD detalhe        AS CHAR
   FIELD mensagem       AS CHAR.

DEFINE DATASET mensagemr XML-NODE-TYPE 'hidden' FOR ttResultado, ttErro
    DATA-RELATION FOR ttResultado, ttErro RELATION-FIELDS (idm, idm) NESTED.


/*---------------------------------------------*/ 
/*     LAYOUT PROVENIENTE DO XML DE PEDIDO     */
/*---------------------------------------------*/ 
DEFINE TEMP-TABLE ttPedido XML-NODE-NAME "Pedido" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'                                                           
   FIELD numeroPedido         AS CHAR
   FIELD sequenciaPedido      AS CHAR
   FIELD codigoLoja           AS CHAR
   FIELD marketplace          AS CHAR
   FIELD statusPedido         AS CHAR
   FIELD dataCriacao          AS DATE
   FIELD totalFrete           AS DEC
   FIELD totalTaxas           AS DEC
   FIELD totalItens           AS DEC
   FIELD totalPedido          AS DEC
   FIELD totalDesconto        AS DEC
   FIELD condicaoPagamento    AS CHAR
   FIELD valorPagamento       AS DEC
   FIELD parcelas             AS INT
   FIELD dataPagamento        AS DATE
   FIELD moedaCorrente        AS CHAR
   FIELD descontoMarketplace  AS DEC.

DEFINE TEMP-TABLE ttCondicaoPagamento XML-NODE-NAME "CondicaoPagamento" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD formaPagamento     AS CHAR
   FIELD dataCaptura        AS DATE
   FIELD quantidadeParcelas AS INT
   FIELD valorTotal         AS DEC
   FIELD finalCartao        AS IN
   FIELD idAutorizacao      AS CHAR
   FIELD nsu                AS CHAR
   FIELD numeroReferencia AS CHAR
   FIELD tid AS CHAR.


DEFINE TEMP-TABLE ttItem XML-NODE-NAME "Item" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN' 
   FIELD codigoItem           AS CHAR
   FIELD quantidade           AS DEC
   FIELD precoItem            AS DEC
   FIELD valorDesconto        AS DEC
   FIELD precoFinal           AS DEC
   FIELD estabelecimento      AS CHAR
   FIELD codigoTransportadora AS CHAR.
                                                            



/*----------------------------------------------------------*/ 
/*                  LAYOUT XML PESSOA F÷SCA                 */
/*----------------------------------------------------------*/ 
DEFINE TEMP-TABLE ttPessoaFisica XML-NODE-NAME "PessoaFisica" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD dataNascimento        AS DATE
   FIELD genero                AS CHAR
   FIELD nome                  AS CHAR
   FIELD nomeMae               AS CHAR
   FIELD paisNascimento        AS CHAR
   FIELD funcaoPessoaFisica    AS CHAR
   FIELD estadoCivil           AS CHAR 
   FIELD municioNascimento     AS CHAR
   FIELD siglaEstadoNascimento AS CHAR.
   
/*----------------------------------------------------------*/ 
/*                  LAYOUT XML PESSOA JURIDICA              */
/*----------------------------------------------------------*/ 
DEFINE TEMP-TABLE ttPessoaJuridica XML-NODE-NAME "PessoaJuridica" 
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD dataAbertura          AS DATE
   FIELD nomeFantasia          AS CHAR
   FIELD razaoSocial           AS CHAR
   FIELD funcaoPessoaJuridica  AS CHAR
   FIELD grupoCliente          AS CHAR.   

DEF TEMP-TABLE ttTelefone XML-NODE-NAME "Telefone"
    FIELD idm           AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD ddd           AS CHAR
    FIELD telefone      AS CHAR
    FIELD tipo          AS CHAR.

DEF TEMP-TABLE ttEmail XML-NODE-NAME "Email"
    FIELD idm       AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD endereco  AS CHAR
    FIELD tipo      AS CHAR.

DEF TEMP-TABLE ttEndereco XML-NODE-NAME "Endereco"
    FIELD idm            AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD identificador  AS CHAR
    FIELD bairro         AS CHAR
    FIELD cep            AS CHAR
    FIELD complemento    AS CHAR
    FIELD logradouro     AS CHAR
    FIELD municipio      AS CHAR
    FIELD numero         AS CHAR
    FIELD siglaEstado    AS CHAR
    FIELD siglaPais      AS CHAR
    FIELD tipo           AS CHAR.

DEF TEMP-TABLE ttDocumento XML-NODE-NAME "Documento"
    FIELD idm      AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD tipoDocumento   AS CHAR
    FIELD numeroDocumento AS CHAR.

DEF TEMP-TABLE ttPedidoPJ            XML-NODE-NAME "Pedido"            LIKE ttPedido.
DEF TEMP-TABLE ttPessoaJuridicaPJ    XML-NODE-NAME "PessoaJuridica"    LIKE ttPessoaJuridica.
DEF TEMP-TABLE ttCondicaoPagamentoPJ XML-NODE-NAME "CondicaoPagamento" LIKE ttCondicaoPagamento.
DEF TEMP-TABLE ttItemPJ              XML-NODE-NAME "Item"              LIKE ttItem.
DEF TEMP-TABLE ttTelefonePJ          XML-NODE-NAME "Telefone"          LIKE ttTelefone.
DEF TEMP-TABLE ttEmailPJ             XML-NODE-NAME "Email"             LIKE ttEmail.
DEF TEMP-TABLE ttEnderecoPJ          XML-NODE-NAME "Endereco"          LIKE ttEndereco.
DEF TEMP-TABLE ttDocumentoPJ         XML-NODE-NAME "Documento"         LIKE ttDocumento.

DEFINE DATASET mensagem XML-NODE-TYPE 'hidden' FOR ttPedido, ttCondicaoPagamento, ttItem, ttTelefone, ttEmail, ttEndereco, ttDocumento, ttPessoaFisica, ttPessoaJuridica
    DATA-RELATION FOR ttPedido, ttItem              RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPedido, ttCondicaoPagamento RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPedido, ttPessoaFisica      RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaFisica, ttTelefone    RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaFisica, ttEmail       RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaFisica, ttDocumento   RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaFisica, ttEndereco    RELATION-FIELDS (idm, idm) NESTED.

DEFINE DATASET mensagemPJ XML-NODE-TYPE 'hidden' FOR ttPedidoPJ, ttCondicaoPagamentoPJ, ttItemPJ, ttTelefonePJ, ttEmailPJ, ttEnderecoPJ, ttDocumentoPJ, ttPessoaJuridicaPJ
    DATA-RELATION FOR ttPedidoPJ, ttItemPJ              RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPedidoPJ, ttCondicaoPagamentoPJ RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPedidoPJ, ttPessoaJuridicaPJ    RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaJuridicaPJ, ttTelefonePJ  RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaJuridicaPJ, ttEmailPJ     RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaJuridicaPJ, ttDocumentoPJ RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR ttPessoaJuridicaPJ, ttEnderecoPJ  RELATION-FIELDS (idm, idm) NESTED.

/* -------------------------------------------------------------------------*/
/*         TEMP-TABLES PARA CRIAÄ«O DO CLIENTE PESSOAL F÷SICA NO TOTVS      */
/* -------------------------------------------------------------------------*/
DEF TEMP-TABLE tt-prog-ponto-tmp NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

define temp-table tt-emitente no-UNDO like emitente
   field cod-maq-origem as int format "9999"
   field num-processo   as int format ">>>>>>>>9" init 0
   field num-sequencia  as int format ">>>>>9"    init 0
   field ind-tipo-movto as int format "99"        init 1
   index ch-codigo is primary cod-maq-origem num-processo num-sequencia.

define temp-table tt-dist-emitente no-UNDO like dist-emitente
   field cod-maq-origem   as   integer format "9999"
   field num-processo     as   integer format ">>>>>>>>9" initial 0
   field num-sequencia    as   integer format ">>>>>9"    initial 0
   field ind-tipo-movto   as   integer format "99"        initial 1
   index ch-codigo is primary cod-maq-origem num-processo num-sequencia.

define temp-table tt-loc-entr  NO-UNDO  like loc-entr
    field cod-maq-origem        as integer 
    field num-processo          as integer format "999999999"
    field num-sequencia         as integer format "999999"
    field ind-tipo-movto        as integer format "99".

define temp-table tt-loc-entr-aux no-UNDO like tt-loc-entr
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
define temp-table tt-int-loc-entr no-UNDO like int-loc-entr.
define temp-table tt-versao-integr no-UNDO
   field cod-versao-integracao as integer format "999"
   field ind-origem-msg        as integer format "99" /* i01mp900.i */.

define temp-table tt-erros-geral no-UNDO
   field identIF-msg           as char    format "x(60)"
   field num-sequencia-erro    as integer format "999"
   field cod-erro              as integer format "99999"   
   field des-erro              as char    format "x(60)"
   field cod-maq-origem        as integer format "999"
   field num-processo          as integer format "999999999".

/* ------------------------------------------------------------------ */
/*          TEMP-TABLES PARA CRIAÄ«O DO PEDIDO NO TOTVS               */
/* -------------------------------------------------------------------*/
/** temp-tables para BO's **/
/*
define temp-table RowErrors no-undo
   field ErrorSequence    as integer
   field ErrorNumber      as integer
   field ErrorDescription as character format "x(150)"
   field ErrorParameters  as character
   field ErrorType        as character
   field ErrorHelp        as character format "x(150)"
   field ErrorSubtype     as character.
   */

define temp-table tt-ped-venda no-undo like ped-venda
   field r-rowid  as rowid.
define temp-table tt-ped-item no-undo like ped-item
   field r-rowid  as rowid.
define temp-table tt-ped-ent no-undo like ped-ent
   field r-rowid  as rowid.
define temp-table tt-ped-repre no-undo like ped-repre
   field r-rowid  as rowid.
define temp-table tt-ped-antecip no-undo like ped-antecip
   field r-rowid  as rowid.
define temp-table tt-cond-ped no-undo like cond-ped
   field r-rowid  as rowid.

define temp-table tt-ped-vendor no-undo
   field data-base    as date
   field dias-base    as integer format ">>>9"
   field cod-cond-pag as integer format ">9"
   field taxa-cliente as decimal format ">>9.9999".

define temp-table ttEstabPedido no-undo
    field cod-estabel like estabelec.cod-estabel.

define temp-table tt-ped-valid no-undo
    field PedidoCodigo as character
    FIELD contaCodigo  AS CHARACTER.

/** Temp-table maldita pra achar corretamente o preáo de um item na tabela **/
define temp-table tt-preco-item no-undo
   field nr-tabpre   like preco-item.nr-tabpre
   field it-codigo   like preco-item.it-codigo
   field cod-refer   like preco-item.cod-refer
   field dt-inival   like preco-item.dt-inival
   field quant-min   like preco-item.quant-min
   field preco-venda like preco-item.preco-venda
   field situacao    like preco-item.situacao
   field desco-quant like preco-item.desco-quant
   index ch-data     is primary dt-inival it-codigo nr-tabpre cod-refer quant-min
   index ch-itemtab  it-codigo cod-refer nr-tabpre dt-inival quant-min.

/** Temp-table do Pagador **/
define temp-table ttDadosPedido no-undo
   field CodigoAutorizacao as character
   field CodigoErro        as character
   field CodigoPagamento   as character
   field FormaPagamento    as character
   field MensagemErro      as character
   field NumeroParcelas    as character
   /*field Status            as character*/
   field Valor             as character
   field DataCancelamento  as character
   field DataPagamento     as character
   field DataPedido        as character
   field TransId           as character
   field BraspagTid        as character.


DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEF TEMP-TABLE tt-prog-ponto-aux LIKE tt-prog-ponto.

DEF TEMP-TABLE tt-arquivo
    FIELD Origin                   AS CHAR 
    FIELD Order                    AS CHAR 
    FIELD Sequence                 AS CHAR 
    FIELD CreationDate             AS CHAR 
    FIELD ClientName               AS CHAR 
    FIELD ClientLastName           AS CHAR 
    FIELD ClientDocument           AS CHAR 
    FIELD Email                    AS CHAR 
    FIELD Phone                    AS CHAR 
    FIELD UF                       AS CHAR 
    FIELD City                     AS CHAR 
    FIELD AddressIdentification    AS CHAR 
    FIELD AddressType              AS CHAR 
    FIELD ReceiverName             AS CHAR 
    FIELD Street                   AS CHAR 
    FIELD Number                   AS CHAR 
    FIELD Complement               AS CHAR 
    FIELD Neighborhood             AS CHAR 
    FIELD Reference                AS CHAR 
    FIELD PostalCode               AS CHAR 
    FIELD SLAType                  AS CHAR 
    FIELD Courrier                 AS CHAR 
    FIELD EstimateDeliveryDate     AS CHAR 
    FIELD DeliveryDeadline         AS CHAR 
    FIELD cStatus                  AS CHAR 
    FIELD LastChangeDate           AS CHAR 
    FIELD UtmMedium                AS CHAR 
    FIELD UtmSource                AS CHAR 
    FIELD UtmCampaign              AS CHAR 
    FIELD Coupon                   AS CHAR 
    FIELD PaymentSystemName        AS CHAR 
    FIELD Installments             AS CHAR 
    FIELD PaymentValue             AS CHAR 
    FIELD Quantity_SKU             AS CHAR 
    FIELD ID_SKU                   AS CHAR 
    FIELD CategoryIdsSku           AS CHAR 
    FIELD ReferenceCode            AS CHAR 
    FIELD SKUName                  AS CHAR 
    FIELD SKUValue                 AS CHAR 
    FIELD SKUSellingPrice          AS CHAR 
    FIELD SKUTotalPrice            AS CHAR 
    FIELD SKUPath                  AS CHAR 
    FIELD ItemAttachments          AS CHAR 
    FIELD ListId                   AS CHAR 
    FIELD ListTypeName             AS CHAR 
    FIELD ServicePriceSellingPrice AS CHAR 
    FIELD ShippingListPrice        AS CHAR 
    FIELD ShippingValue            AS CHAR 
    FIELD TotalValue               AS CHAR 
    FIELD DiscountsTotals          AS CHAR 
    FIELD DiscountsNames           AS CHAR 
    FIELD CallCenterEmail          AS CHAR 
    FIELD CallCenterCode           AS CHAR 
    FIELD TrackingNumber           AS CHAR 
    FIELD Host                     AS CHAR 
    FIELD GiftRegistryID           AS CHAR 
    FIELD SellerName               AS CHAR 
    FIELD StatusTimeLine           AS CHAR 
    FIELD Obs                      AS CHAR 
    FIELD UtmiPart                 AS CHAR 
    FIELD UtmiCampaign             AS CHAR 
    FIELD UtmiPage                 AS CHAR 
    FIELD SellerOrderId            AS CHAR 
    FIELD Acquirer                 AS CHAR 
    FIELD AuthorizationId          AS CHAR 
    FIELD TID                      AS CHAR 
    FIELD NSU                      AS CHAR 
    FIELD CardFirstDigits          AS CHAR 
    FIELD CardLastDigits           AS CHAR 
    FIELD PaymentApprovedBy        AS CHAR 
    FIELD CancelledBy              AS CHAR 
    FIELD CancellationReason       AS CHAR 
    FIELD GiftCardName             AS CHAR 
    FIELD GiftCardCaption          AS CHAR 
    FIELD AuthorizedDate           AS CHAR 
    FIELD CorporateName            AS CHAR 
    FIELD CorporateDocument        AS CHAR 
    FIELD TransactionId            AS CHAR 
    FIELD PaymentId                AS CHAR 
    FIELD SalesChannel             AS CHAR 
    FIELD marketingTags            AS CHAR 
    FIELD Delivered                AS CHAR 
    FIELD SKURewardValue           AS CHAR 
    FIELD IsMarketplacecetified    AS CHAR 
    FIELD IsCheckedIn              AS CHAR 
    FIELD CurrencyCode             AS CHAR 
    FIELD Taxes                    AS CHAR 
    FIELD InvoiceNumbers           AS CHAR 
    FIELD Country                  AS CHAR 
    FIELD InputInvoicesNumbers     AS CHAR 
    FIELD OutputInvoicesNumbers    AS CHAR 
    FIELD Statusrawvaluetemporary  AS CHAR. 

DEFINE TEMP-TABLE tt-int-pedido-vtex LIKE int-pedido-vtex.

define variable h-acomp as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-7 btFile fiFile btOK btCancel ~
btHelp 
&Scoped-Define DISPLAYED-OBJECTS fiFile 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fiFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 70 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.86 BY 2.38.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFile AT ROW 2.58 COL 74.57 HELP
          "Escolha do nome do arquivo" WIDGET-ID 16
     fiFile AT ROW 2.67 COL 4 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL WIDGET-ID 18
     btOK AT ROW 4.63 COL 2.43
     btCancel AT ROW 4.63 COL 13.43
     btHelp AT ROW 4.63 COL 80.29 WIDGET-ID 20
     "Informar o arquivo para importaá∆o:" VIEW-AS TEXT
          SIZE 25 BY .67 AT ROW 1.5 COL 3.72 WIDGET-ID 8
     rtToolBar AT ROW 4.42 COL 1
     RECT-7 AT ROW 1.88 COL 2.14 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 12.29
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 5
         WIDTH              = 89.57
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wWindow
ON CHOOSE OF btFile IN FRAME fpage0
DO:
    def var c-File as char no-undo.
    def var l-ok  as logical no-undo.

    DEF VAR cModelRTF AS CHAR  NO-UNDO.
    
    SYSTEM-DIALOG GET-FILE c-File
       FILTERS "*.csv" "*.csv",
               "*.*" "*.*"
       DEFAULT-EXTENSION "csv"
       INITIAL-DIR "modelos" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    
    ASSIGN fiFile:SCREEN-VALUE IN FRAME fpage0 = c-File.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    IF  trim(fiFile:SCREEN-VALUE IN FRAME fpage0)  = ""
    OR SEARCH(input frame fpage0 fiFile:screen-value) = ? THEN DO:
        run utp/ut-msgs.p (input "show", input 17006 , input "Arquivo Inv†lido ou Inexistente.").   
        RETURN NO-APPLY.
    END.

    run utp/ut-msgs.p (input "show",
                       input 27100 ,
                       input "A importaá∆o criar† novos registros no ecommerce. " + "~~" + "Confirma a importaá∆o?").   
        
    IF  RETURN-VALUE = "YES" THEN DO:
        RUN pi-importa.
    END.
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplay wWindow 
PROCEDURE AfterDisplay :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
c-editor:SCREEN-VALUE IN FRAME fpage0 = "1) O campo de valor do rateio deve possuir do m†ximo 2 casas decimais truncadas. " + chr(10) + chr(10) +    
                                        "2) As informaá‰es dentro do arquivo devem estar separadas por ; (ponto e v°rgula) " + chr(10) + 
                                        "Os campos s∆o: C¢digo do Estabelecimento, C¢digo do Centro de Custo, C¢digo da Unidade de Neg¢cio" + CHR(10) + " e o Percentual de rateio. " + chr(10) +
                                        "Exempo de arquivo: " + chr(10) +
                                        "105;12100;NET;10,00" + chr(10) +
                                        "104;12100;CEN;12,11".
*/                                        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa wWindow 
PROCEDURE pi-importa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE c-tid AS CHAR NO-UNDO.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Iniciando").

INPUT FROM VALUE(fiFile:SCREEN-VALUE IN FRAME fpage0).

RUN pi-acompanhar in h-acomp (INPUT "Importa planilha").

REPEAT:
    CREATE tt-arquivo.
    IMPORT DELIMITER ';' tt-arquivo.
END.

FOR EACH tt-arquivo 
   WHERE tt-arquivo.Origin = "Fulfillment"
     AND tt-arquivo.Statusrawvaluetemporary <> "Cancelado"
     AND tt-arquivo.Statusrawvaluetemporary <> "Cancelamento requisitado"
   BREAK BY tt-arquivo.Order:

    IF FIRST-OF(tt-arquivo.Order) THEN
        EMPTY TEMP-TABLE tt-int-pedido-vtex.

    FIND FIRST tt-int-pedido-vtex
         WHERE tt-int-pedido-vtex.nr-pedido = tt-arquivo.Order NO-ERROR.
    IF NOT AVAIL tt-int-pedido-vtex THEN DO:
        
        CREATE tt-int-pedido-vtex.                 
        ASSIGN tt-int-pedido-vtex.nr-pedido        = tt-arquivo.Order                                                                                                                       
               tt-int-pedido-vtex.seq-pedido       = tt-arquivo.Order                                                                                                                                 
               tt-int-pedido-vtex.dt-criacao       = DATE(SUBSTRING(tt-arquivo.CreationDate,9,2) + "/" + SUBSTRING(tt-arquivo.CreationDate,6,2) + "/" + SUBSTRING(tt-arquivo.CreationDate,1,4))  
               tt-int-pedido-vtex.dt-integracao    = TODAY                                                                                                                        
               tt-int-pedido-vtex.hr-integracao    = STRING(TIME,"HH:MM")                                                                                                         
               tt-int-pedido-vtex.cod-loja         = "1"                                                                                                                          
               tt-int-pedido-vtex.marketplace      = SUBSTRING(tt-arquivo.Order,1,3)                                                                                       
                                                   
               tt-int-pedido-vtex.forma-pagto      = "0"                                                                                                                                  
               tt-int-pedido-vtex.dt-pagto         = DATE(SUBSTRING(tt-arquivo.CreationDate,9,2) + "/" + SUBSTRING(tt-arquivo.CreationDate,6,2) + "/" + SUBSTRING(tt-arquivo.CreationDate,1,4))
               tt-int-pedido-vtex.qtd-parcelas     = 1                                                                                                                                
               tt-int-pedido-vtex.final-cartao     = "0"                                                                                                                              
                                                   
               tt-int-pedido-vtex.nome             = TRIM(tt-arquivo.ClientName) + " " + TRIM(tt-arquivo.ClientLastName)
              
               tt-int-pedido-vtex.telefone         = tt-arquivo.Phone
               tt-int-pedido-vtex.telefone-tipo    = "Residencial"  
               tt-int-pedido-vtex.email            = tt-arquivo.Email
               tt-int-pedido-vtex.email-tipo       = "NFe"
                                                   
               tt-int-pedido-vtex.endereco         = tt-arquivo.Street    
               tt-int-pedido-vtex.cep              = STRING(INT(REPLACE(tt-arquivo.PostalCODE,"-","")),"99999999")
               tt-int-pedido-vtex.bairro           = tt-arquivo.Neighborhood    
               tt-int-pedido-vtex.cidade           = tt-arquivo.City     
               tt-int-pedido-vtex.estado           = tt-arquivo.UF 
               tt-int-pedido-vtex.complemento      = tt-arquivo.Complement   
               tt-int-pedido-vtex.numero           = tt-arquivo.Number    
               tt-int-pedido-vtex.pais             = tt-arquivo.Country
               .

        ASSIGN c-tid = tt-arquivo.Order.

        IF c-tid BEGINS "BWW" THEN
            ASSIGN c-tid = REPLACE(c-tid,"Submarino-","")
                   c-tid = REPLACE(c-tid,"Lojas_Americanas-","").
        
        ASSIGN tt-int-pedido-vtex.id-autorizacao   = c-tid                                                                                   
               tt-int-pedido-vtex.nsu-cartao       = c-tid                                                                                   
               tt-int-pedido-vtex.reference-number = c-tid                                                                                   
               tt-int-pedido-vtex.tid              = c-tid.

        IF LENGTH(tt-arquivo.ClientDocument) <= 11 THEN DO:
            ASSIGN tt-int-pedido-vtex.ins-estadual = "ISENTO"
                   tt-int-pedido-vtex.tipo-docto   = "CPF"
                   tt-int-pedido-vtex.num-docto    = STRING(tt-arquivo.ClientDocument,"99999999999").
        END.
        ELSE DO:
            ASSIGN tt-int-pedido-vtex.ins-estadual = "ISENTO"
                   tt-int-pedido-vtex.tipo-docto   = "CNPJ"
                   tt-int-pedido-vtex.num-docto    = tt-arquivo.ClientDocument.
        END.
    END.

    ASSIGN tt-arquivo.SKUSellingPrice = REPLACE(tt-arquivo.SKUSellingPrice  ,".",",") 
           tt-arquivo.SKUTotalPrice   = REPLACE(tt-arquivo.SKUTotalPrice  ,".",",")
           tt-arquivo.TotalValue      = REPLACE(tt-arquivo.TotalValue     ,".",",")
           tt-arquivo.DiscountsTotals = REPLACE(REPLACE(tt-arquivo.DiscountsTotals,".",","),"-","")
           tt-arquivo.PaymentValue    = REPLACE(tt-arquivo.PaymentValue   ,".",",")
           tt-arquivo.ShippingValue   = REPLACE(tt-arquivo.ShippingValue  ,".",",")
           tt-arquivo.Quantity_SKU    = REPLACE(tt-arquivo.Quantity_SKU   ,".",",").

    ASSIGN tt-int-pedido-vtex.vl-tot-itens     = tt-int-pedido-vtex.vl-tot-itens + DEC(tt-arquivo.SKUTotalPrice)
           tt-int-pedido-vtex.vl-tot-pedido    = DEC(tt-arquivo.TotalValue) 
           //tt-int-pedido-vtex.vl-tot-desc      = tt-int-pedido-vtex.vl-tot-desc + DEC(tt-arquivo.DiscountsTotals )
           tt-int-pedido-vtex.vl-tot-pagto     = DEC(tt-arquivo.PaymentValue )
           tt-int-pedido-vtex.vl-tot-frete     = tt-int-pedido-vtex.vl-tot-frete + DEC(tt-arquivo.ShippingValue ).

    CREATE int-ped-item-vtex.
    ASSIGN int-ped-item-vtex.nr-pedido     = tt-int-pedido-vtex.nr-pedido 
           int-ped-item-vtex.seq-pedido    = tt-int-pedido-vtex.seq-pedido
           int-ped-item-vtex.dt-integracao = tt-int-pedido-vtex.dt-integracao
           int-ped-item-vtex.hr-integracao = tt-int-pedido-vtex.hr-integracao + "10"
           int-ped-item-vtex.it-codigo     = tt-arquivo.ID_SKU
           int-ped-item-vtex.vl-preco-item = DEC(tt-arquivo.SKUSellingPrice)
           int-ped-item-vtex.cod-estabel   = "104"
           int-ped-item-vtex.cod-transp    = 700
           int-ped-item-vtex.quantidade    = INT(tt-arquivo.Quantity_SKU)
           //int-ped-item-vtex.vl-desc-item  = DEC(tt-arquivo.DiscountsTotals)
        .

    IF LAST-OF(tt-arquivo.Order) THEN DO:
        RUN pi-reintegra.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reintegra wWindow 
PROCEDURE pi-reintegra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iXML AS LONGCHAR   NO-UNDO.
    DEFINE VARIABLE oXML AS LONGCHAR   NO-UNDO.

    EMPTY TEMP-TABLE ttPedido.
    EMPTY TEMP-TABLE ttCondicaoPagamento.
    EMPTY TEMP-TABLE ttpessoaFisica.
    EMPTY TEMP-TABLE ttpessoaJuridica.
    EMPTY TEMP-TABLE ttTelefone.
    EMPTY TEMP-TABLE ttEmail.
    EMPTY TEMP-TABLE ttDocumento.
    EMPTY TEMP-TABLE ttEndereco.
    EMPTY TEMP-TABLE ttItem.

    CREATE ttPedido.
    ASSIGN ttPedido.numeroPedido      = tt-int-pedido-vtex.nr-pedido
           ttPedido.sequenciaPedido   = tt-int-pedido-vtex.seq-pedido  
           ttPedido.codigoLoja        = tt-int-pedido-vtex.cod-loja  
           ttPedido.dataCriacao       = tt-int-pedido-vtex.dt-criacao
           ttPedido.totalFrete        = tt-int-pedido-vtex.vl-tot-frete  
           ttPedido.totalItens        = tt-int-pedido-vtex.vl-tot-itens  
           ttPedido.totalPedido       = tt-int-pedido-vtex.vl-tot-pedido
           ttPedido.totalDesconto     = tt-int-pedido-vtex.vl-tot-desc
           ttPedido.marketplace       = tt-int-pedido-vtex.marketplace. 


    CREATE ttCondicaoPagamento.
    ASSIGN ttCondicaoPagamento.formaPagamento      = tt-int-pedido-vtex.forma-pagto    
           ttCondicaoPagamento.dataCaptura         = tt-int-pedido-vtex.dt-pagto       
           ttCondicaoPagamento.quantidadeParcelas  = tt-int-pedido-vtex.qtd-parcelas   
           ttCondicaoPagamento.finalCartao         = int(tt-int-pedido-vtex.final-cartao)
           ttCondicaoPagamento.idAutorizacao       = tt-int-pedido-vtex.id-autorizacao 
           ttCondicaoPagamento.nsu                 = tt-int-pedido-vtex.nsu-cartao     
           ttCondicaoPagamento.valorTotal          = tt-int-pedido-vtex.vl-tot-pagto
           ttCondicaoPagamento.numeroReferencia    = tt-int-pedido-vtex.reference-number    
           ttCondicaoPagamento.tid                 = tt-int-pedido-vtex.tid.

    IF tt-int-pedido-vtex.tipo-docto = "CNPJ" THEN DO:
        CREATE ttpessoaJuridica.
        ASSIGN ttpessoaJuridica.nomeFantasia = tt-int-pedido-vtex.nome.

        CREATE ttDocumento.
        ASSIGN ttDocumento.tipoDocumento   = "inscricaoEstadual"  
               ttDocumento.numeroDocumento = tt-int-pedido-vtex.ins-estadual.
    END.
    ELSE DO:
        CREATE ttpessoaFisica.
        ASSIGN ttpessoaFisica.nome = tt-int-pedido-vtex.nome.
    END.                                                     

    CREATE ttDocumento.
    ASSIGN ttDocumento.tipoDocumento   = tt-int-pedido-vtex.tipo-docto  
           ttDocumento.numeroDocumento = tt-int-pedido-vtex.num-docto.

    CREATE ttTelefone.
    ASSIGN ttTelefone.telefone = tt-int-pedido-vtex.telefone     
           ttTelefone.tipo     = tt-int-pedido-vtex.telefone-tipo.

    CREATE ttEmail.
    ASSIGN ttEmail.endereco = tt-int-pedido-vtex.email     
           ttEmail.tipo     = tt-int-pedido-vtex.email-tipo.

    CREATE ttEndereco.
    ASSIGN ttEndereco.logradouro  = tt-int-pedido-vtex.endereco   
           ttEndereco.cep         = tt-int-pedido-vtex.cep        
           ttEndereco.bairro      = tt-int-pedido-vtex.bairro     
           ttEndereco.municipio   = tt-int-pedido-vtex.cidade     
           ttEndereco.siglaEstado = tt-int-pedido-vtex.estado     
           ttEndereco.complemento = tt-int-pedido-vtex.complemento
           ttEndereco.numero      = tt-int-pedido-vtex.numero     
           ttEndereco.siglaPais   = tt-int-pedido-vtex.pais
           ttEndereco.tipo        = "principal". 

    FOR EACH int-ped-item-vtex NO-LOCK
       WHERE int-ped-item-vtex.nr-pedido     = tt-int-pedido-vtex.nr-pedido     
         AND int-ped-item-vtex.seq-pedido    = tt-int-pedido-vtex.seq-pedido    
         AND int-ped-item-vtex.dt-integracao = tt-int-pedido-vtex.dt-integracao 
         AND SUBSTRING(int-ped-item-vtex.hr-integracao,1,8) = tt-int-pedido-vtex.hr-integracao:
        
        CREATE ttItem.
        ASSIGN ttItem.codigoItem           = int-ped-item-vtex.it-codigo          
               ttItem.precoItem            = int-ped-item-vtex.vl-preco-item      
               ttItem.estabelecimento      = int-ped-item-vtex.cod-estabel        
               ttItem.codigoTransportadora = IF int-ped-item-vtex.cod-transp = 0 THEN "" ELSE string(int-ped-item-vtex.cod-transp)
               ttItem.quantidade           = int-ped-item-vtex.quantidade
               ttItem.valorDesconto        = int-ped-item-vtex.vl-desc-item.
    END.   

    FIND FIRST ttpessoaJuridica NO-ERROR.
    IF AVAIL ttpessoaJuridica THEN DO:
        FOR EACH ttPedido:            CREATE ttPedidoPJ.            BUFFER-COPY ttPedido            TO ttPedidoPJ.            END.
        FOR EACH ttItem:              CREATE ttItemPJ.              BUFFER-COPY ttItem              TO ttItemPJ.              END.
        FOR EACH ttCondicaoPagamento: CREATE ttCondicaoPagamentoPJ. BUFFER-COPY ttCondicaoPagamento TO ttCondicaoPagamentoPJ. END.
        FOR EACH ttpessoaJuridica:    CREATE ttpessoaJuridicaPJ.    BUFFER-COPY ttpessoaJuridica    TO ttpessoaJuridicaPJ.    END.
        FOR EACH ttDocumento:         CREATE ttDocumentoPJ.         BUFFER-COPY ttDocumento         TO ttDocumentoPJ.         END.
        FOR EACH ttTelefone:          CREATE ttTelefonePJ.          BUFFER-COPY ttTelefone          TO ttTelefonePJ.          END.
        FOR EACH ttEmail:             CREATE ttEmailPJ.             BUFFER-COPY ttEmail             TO ttEmailPJ.             END.
        FOR EACH ttEndereco:          CREATE ttEnderecoPJ.          BUFFER-COPY ttEndereco          TO ttEnderecoPJ.          END.

        DATASET mensagemPJ:WRITE-XML('longchar', iXML, YES). 
    END.
    ELSE
        DATASET mensagem:WRITE-XML('longchar', iXML, YES).

    RUN esp/wso/IN/wso0003.p (INPUT iXML,
                              OUTPUT oXML).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

