&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-ped-item-vtex NO-UNDO LIKE int-ped-item-vtex.
DEFINE TEMP-TABLE tt-int-pedido-vtex NO-UNDO LIKE int-pedido-vtex.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i eswso0004a 2.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.
define new global shared var wh-dt-entrega-pd4000  as widget-handle no-undo.
DEFINE INPUT PARAM TABLE FOR tt-int-pedido-vtex.
DEFINE INPUT PARAM p-editar AS LOG.
DEFINE VARIABLE h-pd4000      AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-ped-venda      AS ROWID         NO-UNDO.
DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.
{esp/wso/in/wso0003.i}

{utp/ut-glob.i}

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-wt-docto NO-UNDO LIKE wt-docto
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-wt-it-docto NO-UNDO LIKE wt-it-docto
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-wt-nota-embal NO-UNDO LIKE wt-nota-embal
       field r-rowid as rowid.

/* Local Variable Definitions ---                                       */
def var h-bodi317            as handle no-undo.
def var h-bodi317ef          as handle no-undo.
def var h-bodi317pr          as handle no-undo.
def var h-bodi317sd          as handle no-undo.
def var h-bodi317im1bra      as handle no-undo.
def var h-bodi317va          as handle no-undo.
def var h-bodi317in          as handle no-undo.
def var h-bodi317int         as handle no-undo.
def var i-seq-wt-docto       as int    no-undo.
def var l-proc-ok-aux        as log    no-undo.
def var c-ultimo-metodo-exec as char   no-undo.

/* Definiá∆o da vari†veis */
def var c-cod-estabel        as char   no-undo.
def var c-serie              as char   no-undo.
def var da-dt-emis-nota      as date   no-undo.
def var da-dt-base-dup       as date   no-undo.
def var da-dt-prvenc         as date   no-undo.
def var c-seg-usuario        as char   no-undo.
def var c-nome-abrev         as char   no-undo.   
def var c-nr-pedcli          as char   no-undo.
def var c-nat-operacao       as char   no-undo.
def var c-cod-canal-venda    as char   no-undo.
DEF VAR de-vl-preco          AS DEC    NO-UNDO.
DEFINE VARIABLE d-aliq-ipi             AS DECIMAL     NO-UNDO.

/*{ftp/ft4015.i1} /* Definiá∆o tt-documentos */*/
def temp-table tt-documentos no-undo
    field seq-wt-docto as int
    index codigo
          seq-wt-docto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-itens

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-ped-item-vtex tt-int-pedido-vtex

/* Definitions for BROWSE br-itens                                      */
&Scoped-define FIELDS-IN-QUERY-br-itens tt-int-ped-item-vtex.cod-estabel tt-int-ped-item-vtex.it-codigo tt-int-ped-item-vtex.quantidade tt-int-ped-item-vtex.vl-preco-item tt-int-ped-item-vtex.cod-transp fnDescItem(tt-int-ped-item-vtex.it-codigo) @ c-desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-itens   
&Scoped-define SELF-NAME br-itens
&Scoped-define QUERY-STRING-br-itens FOR EACH tt-int-ped-item-vtex
&Scoped-define OPEN-QUERY-br-itens OPEN QUERY {&SELF-NAME} FOR EACH tt-int-ped-item-vtex.
&Scoped-define TABLES-IN-QUERY-br-itens tt-int-ped-item-vtex
&Scoped-define FIRST-TABLE-IN-QUERY-br-itens tt-int-ped-item-vtex


/* Definitions for FRAME f-cad                                          */
&Scoped-define FIELDS-IN-QUERY-f-cad tt-int-pedido-vtex.dt-integracao ~
tt-int-pedido-vtex.hr-integracao tt-int-pedido-vtex.cod-loja ~
tt-int-pedido-vtex.marketplace tt-int-pedido-vtex.nr-pedido ~
tt-int-pedido-vtex.vl-tot-pedido tt-int-pedido-vtex.forma-pagto ~
tt-int-pedido-vtex.id-autorizacao tt-int-pedido-vtex.vl-tot-itens ~
tt-int-pedido-vtex.qtd-parcelas tt-int-pedido-vtex.nsu-cartao ~
tt-int-pedido-vtex.vl-tot-frete tt-int-pedido-vtex.dt-pagto ~
tt-int-pedido-vtex.reference-number tt-int-pedido-vtex.vl-tot-desc ~
tt-int-pedido-vtex.vl-tot-pagto tt-int-pedido-vtex.tid ~
tt-int-pedido-vtex.nome tt-int-pedido-vtex.endereco ~
tt-int-pedido-vtex.numero tt-int-pedido-vtex.email ~
tt-int-pedido-vtex.complemento tt-int-pedido-vtex.cep ~
tt-int-pedido-vtex.tipo-docto tt-int-pedido-vtex.bairro ~
tt-int-pedido-vtex.estado tt-int-pedido-vtex.num-docto ~
tt-int-pedido-vtex.cidade tt-int-pedido-vtex.ins-estadual 
&Scoped-define ENABLED-FIELDS-IN-QUERY-f-cad ~
tt-int-pedido-vtex.vl-tot-pedido tt-int-pedido-vtex.forma-pagto ~
tt-int-pedido-vtex.id-autorizacao tt-int-pedido-vtex.vl-tot-itens ~
tt-int-pedido-vtex.qtd-parcelas tt-int-pedido-vtex.nsu-cartao ~
tt-int-pedido-vtex.vl-tot-frete tt-int-pedido-vtex.dt-pagto ~
tt-int-pedido-vtex.reference-number tt-int-pedido-vtex.vl-tot-desc ~
tt-int-pedido-vtex.vl-tot-pagto tt-int-pedido-vtex.tid ~
tt-int-pedido-vtex.nome tt-int-pedido-vtex.endereco ~
tt-int-pedido-vtex.numero tt-int-pedido-vtex.email ~
tt-int-pedido-vtex.complemento tt-int-pedido-vtex.cep ~
tt-int-pedido-vtex.tipo-docto tt-int-pedido-vtex.bairro ~
tt-int-pedido-vtex.estado tt-int-pedido-vtex.num-docto ~
tt-int-pedido-vtex.cidade tt-int-pedido-vtex.ins-estadual 
&Scoped-define ENABLED-TABLES-IN-QUERY-f-cad tt-int-pedido-vtex
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-f-cad tt-int-pedido-vtex
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-itens}
&Scoped-define QUERY-STRING-f-cad FOR EACH tt-int-pedido-vtex SHARE-LOCK
&Scoped-define OPEN-QUERY-f-cad OPEN QUERY f-cad FOR EACH tt-int-pedido-vtex SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-f-cad tt-int-pedido-vtex
&Scoped-define FIRST-TABLE-IN-QUERY-f-cad tt-int-pedido-vtex


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-int-pedido-vtex.vl-tot-pedido ~
tt-int-pedido-vtex.forma-pagto tt-int-pedido-vtex.id-autorizacao ~
tt-int-pedido-vtex.vl-tot-itens tt-int-pedido-vtex.qtd-parcelas ~
tt-int-pedido-vtex.nsu-cartao tt-int-pedido-vtex.vl-tot-frete ~
tt-int-pedido-vtex.dt-pagto tt-int-pedido-vtex.reference-number ~
tt-int-pedido-vtex.vl-tot-desc tt-int-pedido-vtex.vl-tot-pagto ~
tt-int-pedido-vtex.tid tt-int-pedido-vtex.nome tt-int-pedido-vtex.endereco ~
tt-int-pedido-vtex.numero tt-int-pedido-vtex.email ~
tt-int-pedido-vtex.complemento tt-int-pedido-vtex.cep ~
tt-int-pedido-vtex.tipo-docto tt-int-pedido-vtex.bairro ~
tt-int-pedido-vtex.estado tt-int-pedido-vtex.num-docto ~
tt-int-pedido-vtex.cidade tt-int-pedido-vtex.ins-estadual 
&Scoped-define ENABLED-TABLES tt-int-pedido-vtex
&Scoped-define FIRST-ENABLED-TABLE tt-int-pedido-vtex
&Scoped-Define ENABLED-OBJECTS rt-button RECT-1 RECT-2 RECT-3 fi-vl-tot-ped ~
br-itens bt-ok bt-pd4000 bt-recalcula bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-FIELDS tt-int-pedido-vtex.dt-integracao ~
tt-int-pedido-vtex.hr-integracao tt-int-pedido-vtex.cod-loja ~
tt-int-pedido-vtex.marketplace tt-int-pedido-vtex.nr-pedido ~
tt-int-pedido-vtex.vl-tot-pedido tt-int-pedido-vtex.forma-pagto ~
tt-int-pedido-vtex.id-autorizacao tt-int-pedido-vtex.vl-tot-itens ~
tt-int-pedido-vtex.qtd-parcelas tt-int-pedido-vtex.nsu-cartao ~
tt-int-pedido-vtex.vl-tot-frete tt-int-pedido-vtex.dt-pagto ~
tt-int-pedido-vtex.reference-number tt-int-pedido-vtex.vl-tot-desc ~
tt-int-pedido-vtex.vl-tot-pagto tt-int-pedido-vtex.tid ~
tt-int-pedido-vtex.nome tt-int-pedido-vtex.endereco ~
tt-int-pedido-vtex.numero tt-int-pedido-vtex.email ~
tt-int-pedido-vtex.complemento tt-int-pedido-vtex.cep ~
tt-int-pedido-vtex.tipo-docto tt-int-pedido-vtex.bairro ~
tt-int-pedido-vtex.estado tt-int-pedido-vtex.num-docto ~
tt-int-pedido-vtex.cidade tt-int-pedido-vtex.ins-estadual 
&Scoped-define DISPLAYED-TABLES tt-int-pedido-vtex
&Scoped-define FIRST-DISPLAYED-TABLE tt-int-pedido-vtex
&Scoped-Define DISPLAYED-OBJECTS v-dt-implant fi-vl-tot-ped 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem w-cadsim 
FUNCTION fnDescItem RETURNS CHARACTER
  ( p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Fechar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&Reenviar Pedido" 
     SIZE 17 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-pd4000 
     LABEL "PD4000" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-recalcula AUTO-GO 
     LABEL "&Recalcula" 
     SIZE 11 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE fi-vl-tot-ped AS CHARACTER FORMAT "X(256)":U 
     LABEL "Vl Tot Ped" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE v-dt-implant AS CHARACTER FORMAT "X(256)":U 
     LABEL "Dt Implantaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 115 BY 4.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 115 BY 5.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 115 BY 5.75.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 117 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-itens FOR 
      tt-int-ped-item-vtex SCROLLING.

DEFINE QUERY f-cad FOR 
      tt-int-pedido-vtex SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-itens w-cadsim _FREEFORM
  QUERY br-itens DISPLAY
      tt-int-ped-item-vtex.cod-estabel 
    tt-int-ped-item-vtex.it-codigo 
    tt-int-ped-item-vtex.quantidade 
    tt-int-ped-item-vtex.vl-preco-item 
    tt-int-ped-item-vtex.cod-transp
    fnDescItem(tt-int-ped-item-vtex.it-codigo) @ c-desc-item FORMAT "x(40)" COLUMN-LABEL "Descriá∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 114 BY 4.5
         TITLE "Itens do Pedido" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     v-dt-implant AT ROW 1.67 COL 36 COLON-ALIGNED WIDGET-ID 2
     tt-int-pedido-vtex.dt-integracao AT ROW 2.67 COL 36 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-int-pedido-vtex.hr-integracao AT ROW 2.67 COL 50.29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-int-pedido-vtex.cod-loja AT ROW 3.67 COL 36 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-int-pedido-vtex.marketplace AT ROW 3.67 COL 62.86 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-int-pedido-vtex.nr-pedido AT ROW 4.67 COL 36 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 41 BY .88
     tt-int-pedido-vtex.vl-tot-pedido AT ROW 7.04 COL 16.14 COLON-ALIGNED WIDGET-ID 22
          LABEL "Vlr Total Pedido"
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     tt-int-pedido-vtex.forma-pagto AT ROW 7.04 COL 48.72 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-int-pedido-vtex.id-autorizacao AT ROW 7.04 COL 76 COLON-ALIGNED WIDGET-ID 38
          LABEL "ID"
          VIEW-AS FILL-IN 
          SIZE 35 BY .88
     tt-int-pedido-vtex.vl-tot-itens AT ROW 8.04 COL 16.14 COLON-ALIGNED WIDGET-ID 24
          LABEL "Vlr Total Itens"
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     tt-int-pedido-vtex.qtd-parcelas AT ROW 8.04 COL 48.72 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-int-pedido-vtex.nsu-cartao AT ROW 8.04 COL 76 COLON-ALIGNED WIDGET-ID 40
          LABEL "NSU"
          VIEW-AS FILL-IN 
          SIZE 35 BY .88
     tt-int-pedido-vtex.vl-tot-frete AT ROW 9.04 COL 16.14 COLON-ALIGNED WIDGET-ID 26
          LABEL "Vlr Frete"
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     tt-int-pedido-vtex.dt-pagto AT ROW 9.04 COL 76 COLON-ALIGNED WIDGET-ID 42
          LABEL "Dt Pagto"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-int-pedido-vtex.reference-number AT ROW 10 COL 76 COLON-ALIGNED WIDGET-ID 74
          LABEL "Proc. Ref. Num."
          VIEW-AS FILL-IN 
          SIZE 35 BY .88
     tt-int-pedido-vtex.vl-tot-desc AT ROW 10.04 COL 16.14 COLON-ALIGNED WIDGET-ID 28
          LABEL "Vlr Desconto"
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     tt-int-pedido-vtex.vl-tot-pagto AT ROW 10.04 COL 48.72 COLON-ALIGNED WIDGET-ID 36
          LABEL "VlR Total Pago"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-int-pedido-vtex.tid AT ROW 11 COL 76 COLON-ALIGNED WIDGET-ID 76
          VIEW-AS FILL-IN 
          SIZE 35 BY .88
     fi-vl-tot-ped AT ROW 11.04 COL 48.72 COLON-ALIGNED WIDGET-ID 84
     tt-int-pedido-vtex.nome AT ROW 12.92 COL 13.14 COLON-ALIGNED WIDGET-ID 48
          LABEL "Nome"
          VIEW-AS FILL-IN 
          SIZE 31 BY .88
     tt-int-pedido-vtex.endereco AT ROW 12.92 COL 58 COLON-ALIGNED WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 31 BY .88
     tt-int-pedido-vtex.numero AT ROW 12.92 COL 96 COLON-ALIGNED WIDGET-ID 64
          LABEL "Num"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-int-pedido-vtex.email AT ROW 13.92 COL 13.14 COLON-ALIGNED WIDGET-ID 50
          LABEL "E-mail"
          VIEW-AS FILL-IN 
          SIZE 31 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 117.29 BY 24.08 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-cad
     tt-int-pedido-vtex.complemento AT ROW 13.92 COL 58 COLON-ALIGNED WIDGET-ID 58
          LABEL "Complem."
          VIEW-AS FILL-IN 
          SIZE 31 BY .88
     tt-int-pedido-vtex.cep AT ROW 13.92 COL 96 COLON-ALIGNED WIDGET-ID 66
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-int-pedido-vtex.tipo-docto AT ROW 14.92 COL 13.14 COLON-ALIGNED WIDGET-ID 52
          LABEL "Documento"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-int-pedido-vtex.bairro AT ROW 14.92 COL 58 COLON-ALIGNED WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 31 BY .88
     tt-int-pedido-vtex.estado AT ROW 14.92 COL 96 COLON-ALIGNED WIDGET-ID 68
          LABEL "UF"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-int-pedido-vtex.num-docto AT ROW 15.92 COL 13.14 COLON-ALIGNED WIDGET-ID 54
          LABEL "N£mero"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-int-pedido-vtex.cidade AT ROW 15.92 COL 58 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 31 BY .88
     tt-int-pedido-vtex.ins-estadual AT ROW 17 COL 13.14 COLON-ALIGNED WIDGET-ID 78
          LABEL "Insc Estadual"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     br-itens AT ROW 18.5 COL 3 WIDGET-ID 200
     bt-ok AT ROW 23.71 COL 2
     bt-pd4000 AT ROW 23.71 COL 19.29 WIDGET-ID 72
     bt-recalcula AT ROW 23.71 COL 29.72 WIDGET-ID 80
     bt-cancela AT ROW 23.71 COL 41.14
     bt-ajuda AT ROW 23.71 COL 107.14
     "Dados do Cliente" VIEW-AS TEXT
          SIZE 15.43 BY .67 AT ROW 12.21 COL 3.57 WIDGET-ID 46
     "Dados do Pagamento" VIEW-AS TEXT
          SIZE 19.43 BY .67 AT ROW 6.25 COL 3.57 WIDGET-ID 30
     "Registro Integraá∆o" VIEW-AS TEXT
          SIZE 17.43 BY .67 AT ROW 1.13 COL 3.57 WIDGET-ID 18
     rt-button AT ROW 23.5 COL 1
     RECT-1 AT ROW 1.38 COL 2 WIDGET-ID 16
     RECT-2 AT ROW 6.5 COL 2 WIDGET-ID 20
     RECT-3 AT ROW 12.5 COL 2 WIDGET-ID 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 117.29 BY 24.08 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Temp-Tables and Buffers:
      TABLE: tt-int-ped-item-vtex T "?" NO-UNDO mgesp int-ped-item-vtex
      TABLE: tt-int-pedido-vtex T "?" NO-UNDO mgesp int-pedido-vtex
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manutená∆o <Insira o complemento>"
         HEIGHT             = 24.08
         WIDTH              = 117.29
         MAX-HEIGHT         = 24.08
         MAX-WIDTH          = 117.29
         VIRTUAL-HEIGHT     = 24.08
         VIRTUAL-WIDTH      = 117.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB br-itens ins-estadual f-cad */
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.cod-loja IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.complemento IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.dt-integracao IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.dt-pagto IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.email IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.estado IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.hr-integracao IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.id-autorizacao IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.ins-estadual IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.marketplace IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.nome IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.nr-pedido IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.nsu-cartao IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.num-docto IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.numero IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.reference-number IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.tipo-docto IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN v-dt-implant IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.vl-tot-desc IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.vl-tot-frete IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.vl-tot-itens IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.vl-tot-pagto IN FRAME f-cad
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-pedido-vtex.vl-tot-pedido IN FRAME f-cad
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-itens
/* Query rebuild information for BROWSE br-itens
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-ped-item-vtex.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-itens */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-cad
/* Query rebuild information for FRAME f-cad
     _TblList          = "Temp-Tables.tt-int-pedido-vtex"
     _Query            is OPENED
*/  /* FRAME f-cad */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manutená∆o <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manutená∆o <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-cadsim
ON CHOOSE OF bt-ajuda IN FRAME f-cad /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-cadsim
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Fechar */
DO:
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* Reenviar Pedido */
DO:
   IF AVAIL tt-int-pedido-vtex THEN DO:
       
       
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.vl-tot-pedido.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.vl-tot-itens.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.vl-tot-frete.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.vl-tot-desc.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.forma-pagto.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.qtd-parcelas.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.vl-tot-pagto.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.id-autorizacao.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.nsu-cartao.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.dt-pagto.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.nome.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.email.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.tipo-docto.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.num-docto.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.ins-estadual.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.endereco.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.complemento.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.bairro.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.cidade.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.numero.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.cep.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.estado.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.tid.
       ASSIGN INPUT FRAME f-cad tt-int-pedido-vtex.reference-number .
       
       RUN pi-reintegra.
   END.

   APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pd4000
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pd4000 w-cadsim
ON CHOOSE OF bt-pd4000 IN FRAME f-cad /* PD4000 */
DO:
    IF  VALID-HANDLE(wh-dt-entrega-pd4000) AND NOT VALID-HANDLE(h-pd4000) THEN DO:
        run utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Atená∆o, j† existe uma Tela do PD4000 aberta em sua sess∆o EMS, favor fechar a tela recÇm aberta. ~~ " + 
                                 "Por restriá‰es tÇcnicas, n∆o Ç poss°vel trabalhar com mais de uma tela do PD4000 na mesma sess∆o do EMS.").

        RETURN "OK".

    END.
    
    IF AVAIL ped-venda THEN DO:
        ASSIGN gr-ped-venda = ROWID(ped-venda).
        IF NOT VALID-HANDLE(h-pd4000) THEN DO:
            RUN pdp/pd4000.w PERSISTENT SET h-pd4000.
            RUN dispatch IN h-pd4000 ('initialize') no-error.
            RUN repositionRecord IN h-pd4000 (INPUT gr-ped-venda).
        END.
        ELSE
            RUN repositionRecord IN h-pd4000 (INPUT gr-ped-venda).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-recalcula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-recalcula w-cadsim
ON CHOOSE OF bt-recalcula IN FRAME f-cad /* Recalcula */
DO:

    DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
    IF NOT VALID-HANDLE(h-acomp)               OR
        h-acomp:TYPE      <> "PROCEDURE":U      OR
        h-acomp:FILE-NAME <> "utp/ut-acomp.p":U THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Recalculo":U).

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Iniciando...":U).

    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nr-pedcli = tt-int-pedido-vtex.nr-pedcli
           AND (ped-venda.cod-sit-ped = 1
             OR ped-venda.cod-sit-ped = 2
             OR ped-venda.cod-sit-ped = 5) NO-ERROR.
    IF NOT AVAIL ped-venda THEN NEXT.

    FIND FIRST tt-int-pedido-vtex NO-ERROR.

    FIND FIRST int-ped-venda EXCLUSIVE-LOCK
         WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
    IF AVAILABLE (int-ped-venda) THEN DO:
        FIND FIRST int-pedido-vtex EXCLUSIVE-LOCK
             WHERE int-pedido-vtex.nr-pedcli    = ped-venda.nr-pedcli NO-ERROR.
        IF AVAIL int-pedido-vtex THEN
            ASSIGN int-ped-venda.vl-frete = int-pedido-vtex.vl-tot-frete.
    
        FOR EACH ped-item OF ped-venda EXCLUSIVE-LOCK:

            RUN pi-acompanhar IN h-acomp (INPUT "Item: " + ped-item.it-codigo).

            FOR FIRST int-ped-item-vtex NO-LOCK
                WHERE int-ped-item-vtex.nr-pedido = tt-int-pedido-vtex.nr-pedido
                  AND int-ped-item-vtex.it-codigo = ped-item.it-codigo:
                ASSIGN ped-item.vl-pretab        = int-ped-item-vtex.vl-preco-item
                       ped-item.vl-preori        = int-ped-item-vtex.vl-preco-item
                       ped-item.vl-preuni        = int-ped-item-vtex.vl-preco-item
                       ped-item.vl-preori-un-fat = int-ped-item-vtex.vl-preco-item.
            END.
        END.
        RUN esp/api/recalculo-pedido.p (INPUT ped-venda.nr-pedido).

        RUN pi-acompanhar IN h-acomp (INPUT "Concluindo...":U).

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-finalizar IN h-acomp.
        IF VALID-HANDLE(h-acomp) THEN DO:
            DELETE PROCEDURE h-acomp.
            ASSIGN h-acomp = ?.
        END.

        RUN utp/ut-msgs.p (input "show", INPUT 17006, input "Pedido recalculado.").
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-cadsim
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-itens
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/

  {&OPEN-QUERY-f-cad}
  GET FIRST f-cad.
  DISPLAY v-dt-implant fi-vl-tot-ped 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  IF AVAILABLE tt-int-pedido-vtex THEN 
    DISPLAY tt-int-pedido-vtex.dt-integracao tt-int-pedido-vtex.hr-integracao 
          tt-int-pedido-vtex.cod-loja tt-int-pedido-vtex.marketplace 
          tt-int-pedido-vtex.nr-pedido tt-int-pedido-vtex.vl-tot-pedido 
          tt-int-pedido-vtex.forma-pagto tt-int-pedido-vtex.id-autorizacao 
          tt-int-pedido-vtex.vl-tot-itens tt-int-pedido-vtex.qtd-parcelas 
          tt-int-pedido-vtex.nsu-cartao tt-int-pedido-vtex.vl-tot-frete 
          tt-int-pedido-vtex.dt-pagto tt-int-pedido-vtex.reference-number 
          tt-int-pedido-vtex.vl-tot-desc tt-int-pedido-vtex.vl-tot-pagto 
          tt-int-pedido-vtex.tid tt-int-pedido-vtex.nome 
          tt-int-pedido-vtex.endereco tt-int-pedido-vtex.numero 
          tt-int-pedido-vtex.email tt-int-pedido-vtex.complemento 
          tt-int-pedido-vtex.cep tt-int-pedido-vtex.tipo-docto 
          tt-int-pedido-vtex.bairro tt-int-pedido-vtex.estado 
          tt-int-pedido-vtex.num-docto tt-int-pedido-vtex.cidade 
          tt-int-pedido-vtex.ins-estadual 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button RECT-1 RECT-2 RECT-3 tt-int-pedido-vtex.vl-tot-pedido 
         tt-int-pedido-vtex.forma-pagto tt-int-pedido-vtex.id-autorizacao 
         tt-int-pedido-vtex.vl-tot-itens tt-int-pedido-vtex.qtd-parcelas 
         tt-int-pedido-vtex.nsu-cartao tt-int-pedido-vtex.vl-tot-frete 
         tt-int-pedido-vtex.dt-pagto tt-int-pedido-vtex.reference-number 
         tt-int-pedido-vtex.vl-tot-desc tt-int-pedido-vtex.vl-tot-pagto 
         tt-int-pedido-vtex.tid fi-vl-tot-ped tt-int-pedido-vtex.nome 
         tt-int-pedido-vtex.endereco tt-int-pedido-vtex.numero 
         tt-int-pedido-vtex.email tt-int-pedido-vtex.complemento 
         tt-int-pedido-vtex.cep tt-int-pedido-vtex.tipo-docto 
         tt-int-pedido-vtex.bairro tt-int-pedido-vtex.estado 
         tt-int-pedido-vtex.num-docto tt-int-pedido-vtex.cidade 
         tt-int-pedido-vtex.ins-estadual br-itens bt-ok bt-pd4000 bt-recalcula 
         bt-cancela bt-ajuda 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "eswso0004a" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN dispatch  IN this-procedure ('enable-fields':U).

  IF NOT p-editar THEN
    DISABLE ALL EXCEPT bt-cancela WITH FRAME f-cad.

  FIND FIRST ped-venda NO-LOCK
       WHERE ped-venda.nr-pedcli = tt-int-pedido-vtex.nr-pedcli NO-ERROR.

  IF AVAIL ped-venda THEN
      ASSIGN v-dt-implant:SCREEN-VALUE IN FRAME f-cad = STRING(ped-venda.dt-implant,"99/99/9999")
             bt-pd4000:SENSITIVE IN FRAME f-cad = YES
             fi-vl-tot-ped:SCREEN-VALUE IN FRAME f-cad = TRIM(STRING(ped-venda.vl-tot-ped,">>>,>>>,>>9.99")).
  ELSE 
      ASSIGN bt-pd4000:SENSITIVE IN FRAME f-cad = NO
             fi-vl-tot-ped:SCREEN-VALUE IN FRAME f-cad = "".

  IF AVAIL ped-venda AND (ped-venda.cod-sit-ped < 3 OR ped-venda.cod-sit-ped = 5) THEN
      ASSIGN bt-recalcula:SENSITIVE IN FRAME f-cad = YES.
  ELSE 
      ASSIGN bt-recalcula:SENSITIVE IN FRAME f-cad = NO.

  RUN pi-carrega.
  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega w-cadsim 
PROCEDURE pi-carrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-int-ped-item-vtex.

    FOR EACH int-ped-item-vtex NO-LOCK
       WHERE int-ped-item-vtex.nr-pedido     = tt-int-pedido-vtex.nr-pedido     
         AND int-ped-item-vtex.seq-pedido    = tt-int-pedido-vtex.seq-pedido    
         AND int-ped-item-vtex.dt-integracao = tt-int-pedido-vtex.dt-integracao 
         AND SUBSTRING(int-ped-item-vtex.hr-integracao,1,8) = tt-int-pedido-vtex.hr-integracao:

        CREATE tt-int-ped-item-vtex.
        BUFFER-COPY int-ped-item-vtex TO tt-int-ped-item-vtex.
    END.

    {&open-query-br-itens}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-completa-pedido w-cadsim 
PROCEDURE pi-completa-pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE h-bodi159cal      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE l-erro            AS LOGICAL     NO-UNDO.

    /************************/
    /* COMPLETANDO O PEDIDO */
    /************************/
    EMPTY TEMP-TABLE RowErrors.
    RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.
    RUN completeOrder in h-bodi159cal (INPUT ROWID(ped-venda), OUTPUT TABLE RowErrors).
  
    FOR EACH RowErrors NO-LOCK
       WHERE RowErrors.ErrorNumber <> 8259 /** crÇdito n∆o aprovado **/
         AND RowErrors.ErrorSubType = 'Error':
        MESSAGE RowErrors.errorNumber SKIP RowErrors.ERRORDescription SKIP RowErrors.ErrorHelp
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

       //RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", STRING(RowErrors.errorNumber), RowErrors.ERRORDescription + " - " + RowErrors.ErrorHelp).
       ASSIGN l-erro = YES.
    END.
     
    IF  VALID-HANDLE(h-bodi159cal) AND h-bodi159cal:file-name = 'dibo/bodi159com.p' AND h-bodi159cal:type = 'procedure' THEN
        RUN destroyBO IN  h-bodi159cal.
    IF  VALID-HANDLE(h-bodi159cal) THEN DO:
        DELETE PROCEDURE h-bodi159cal.
        ASSIGN h-bodi159cal = ?.
    END.          
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reintegra w-cadsim 
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
               ttItem.codigoTransportadora = string(int-ped-item-vtex.cod-transp)
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-int-pedido-vtex"}
  {src/adm/template/snd-list.i "tt-int-ped-item-vtex"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem w-cadsim 
FUNCTION fnDescItem RETURNS CHARACTER
  ( p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

    IF AVAIL ITEM THEN
        RETURN ITEM.desc-item.
    ELSE
        RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

