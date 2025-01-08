&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-emitente NO-UNDO LIKE emitente
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-vpc NO-UNDO LIKE vpc
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESUTP061 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          ESUTP061
&GLOBAL-DEFINE Version          2.04.00.000

&GLOBAL-DEFINE Folder           yes
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     VPC

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        NO
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     NO
&GLOBAL-DEFINE DeleteParent     NO

&GLOBAL-DEFINE AddSon1          NO
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       NO

&GLOBAL-DEFINE ttParent         tt-emitente
&GLOBAL-DEFINE hDBOParent       h-boad098
&GLOBAL-DEFINE DBOParentTable   emitente
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           tt-vpc
&GLOBAL-DEFINE hDBOSon1         h-boes455
&GLOBAL-DEFINE DBOSon1Table     vpc
&GLOBAL-DEFINE DBOSon1Destroy   YES
&GLOBAL-DEFINE NumRowsReturned  25

&GLOBAL-DEFINE page0Fields      tt-emitente.cod-emitente tt-emitente.nome-emit 

&GLOBAL-DEFINE page1Fields      br-rateio
&GLOBAL-DEFINE page1Browse      brSon1 
   
&global-define VALUE-CHANGED1    yes
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.

DEFINE VARIABLE de-saldo      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-situacao    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-forma-pagto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tipo-acordo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tipo-verba  AS CHARACTER   NO-UNDO.

DEFINE VARIABLE l-filtro-bloqueadas  AS LOGICAL  INITIAL YES   NO-UNDO.
DEFINE VARIABLE l-filtro-liberadas   AS LOGICAL  INITIAL YES   NO-UNDO.
DEFINE VARIABLE l-filtro-finalizadas AS LOGICAL  INITIAL YES   NO-UNDO.
DEFINE VARIABLE l-filtro-canceladas  AS LOGICAL  INITIAL YES   NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-aux NO-UNDO LIKE tt-vpc.

def new global shared var v_rec_tit_ap as RECID format ">>>>>>9":U initial ? no-undo.

def new shared temp-table tt_log_erros_atualiz no-undo 
      field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
      field tta_cod_refer                    as character format "x(10)" label "Referºncia" column-label "Referºncia" 
      field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequºncia" column-label "Seq" 
      field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Número" column-label "Número Mensagem" 
      field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistºncia" 
      field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda" 
      field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac" 
      field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento".

def temp-table tt_log_erros_tit_ap_alteracao no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    field ttv_des_msg_ajuda_1              as character format "x(250)"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME br-rateio

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES vpc-rateio tt-vpc

/* Definitions for BROWSE br-rateio                                     */
&Scoped-define FIELDS-IN-QUERY-br-rateio vpc-rateio.cod-unid-negoc ~
vpc-rateio.cod_ccusto vpc-rateio.valor 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-rateio 
&Scoped-define QUERY-STRING-br-rateio FOR EACH vpc-rateio ~
      WHERE vpc-rateio.nr-vpc = fnNrVpc() NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-rateio OPEN QUERY br-rateio FOR EACH vpc-rateio ~
      WHERE vpc-rateio.nr-vpc = fnNrVpc() NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-rateio vpc-rateio
&Scoped-define FIRST-TABLE-IN-QUERY-br-rateio vpc-rateio


/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-vpc.nr-vpc ~
fn-tot-rat(tt-vpc.nr-vpc) @ tt-vpc.valor fn-saldo(tt-vpc.nr-vpc) @ de-saldo ~
tt-vpc.cod-estabel fn-situacao(tt-vpc.situacao) @ c-situacao ~
fn-forma-pagto(tt-vpc.forma-pagto) @ c-forma-pagto ~
fn-tipo-acordo(tt-vpc.tipo-acordo) @ c-tipo-acordo ~
fn-tipo-verba(tt-vpc.tipo-verba) @ c-tipo-verba tt-vpc.data-evento ~
tt-vpc.data-vencto tt-vpc.data-trans tt-vpc.usuario-trans 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-vpc NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-vpc NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-vpc
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-vpc


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-rateio}~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-emitente.cod-emitente ~
tt-emitente.nome-emit 
&Scoped-define ENABLED-TABLES tt-emitente
&Scoped-define FIRST-ENABLED-TABLE tt-emitente
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btFirst btPrev btNext ~
btLast btGoTo btSearch btVpc btVpcSit btFiltro btQueryJoins btReportsJoins ~
btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-emitente.cod-emitente ~
tt-emitente.nome-emit 
&Scoped-define DISPLAYED-TABLES tt-emitente
&Scoped-define FIRST-DISPLAYED-TABLE tt-emitente


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-forma-pagto wMasterDetail 
FUNCTION fn-forma-pagto RETURNS CHARACTER (INPUT p-forma-pagto AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-saldo wMasterDetail 
FUNCTION fn-saldo RETURNS DECIMAL
  (INPUT p-nr-vpc AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-situacao wMasterDetail 
FUNCTION fn-situacao RETURNS CHARACTER (INPUT p-situacao AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-tipo-acordo wMasterDetail 
FUNCTION fn-tipo-acordo RETURNS CHARACTER (INPUT p-tipo-acordo AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-tipo-verba wMasterDetail 
FUNCTION fn-tipo-verba RETURNS CHARACTER (INPUT p-tipo-verba AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-tot-rat wMasterDetail 
FUNCTION fn-tot-rat RETURNS DECIMAL
  (INPUT p-nr-vpc AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNrVpc wMasterDetail 
FUNCTION fnNrVpc RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image/im-fil.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25 TOOLTIP "Filtrar registros browse"
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btVpc 
     IMAGE-UP FILE "image/im-local.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "VPC" 
     SIZE 4 BY 1.25 TOOLTIP "Posiciona VPC"
     FONT 4.

DEFINE BUTTON btVpcSit 
     IMAGE-UP FILE "image/im-movto.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25 TOOLTIP "Listar Verbas"
     FONT 4.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 9 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 9 BY 1.

DEFINE BUTTON btUpdateSon1 
     LABEL "Detalhar" 
     SIZE 9 BY 1.

DEFINE VARIABLE fi-total AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 TOOLTIP "Valor Total VPC" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-rateio FOR 
      vpc-rateio SCROLLING.

DEFINE QUERY brSon1 FOR 
      tt-vpc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-rateio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-rateio wMasterDetail _STRUCTURED
  QUERY br-rateio NO-LOCK DISPLAY
      vpc-rateio.cod-unid-negoc COLUMN-LABEL "Unidade Neg¢cio" FORMAT "x(03)":U
            WIDTH 12
      vpc-rateio.cod_ccusto COLUMN-LABEL "Centro de Custo" FORMAT "x(5)":U
            WIDTH 13
      vpc-rateio.valor FORMAT "->>>,>>9.99":U WIDTH 17.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 47 BY 5.5
         FONT 1
         TITLE "Rateio" ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.

DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      tt-vpc.nr-vpc FORMAT ">>>>>>>9":U WIDTH 6.43
      fn-tot-rat(tt-vpc.nr-vpc) @ tt-vpc.valor
      fn-saldo(tt-vpc.nr-vpc) @ de-saldo COLUMN-LABEL "Saldo" FORMAT "->>>,>>9.99":U
            WIDTH 9.86
      tt-vpc.cod-estabel FORMAT "X(3)":U WIDTH 3.29
      fn-situacao(tt-vpc.situacao) @ c-situacao COLUMN-LABEL "Situaá∆o" FORMAT "x(10)":U
            WIDTH 10
      fn-forma-pagto(tt-vpc.forma-pagto) @ c-forma-pagto COLUMN-LABEL "Forma Pagto" FORMAT "x(15)":U
            WIDTH 14.43
      fn-tipo-acordo(tt-vpc.tipo-acordo) @ c-tipo-acordo COLUMN-LABEL "Tipo Acordo" FORMAT "x(15)":U
            WIDTH 15.72
      fn-tipo-verba(tt-vpc.tipo-verba) @ c-tipo-verba COLUMN-LABEL "Tipo Verba" FORMAT "x(15)":U
            WIDTH 17.43
      tt-vpc.data-evento FORMAT "99/99/9999":U WIDTH 11.14
      tt-vpc.data-vencto FORMAT "99/99/9999":U WIDTH 10.57
      tt-vpc.data-trans FORMAT "99/99/9999":U WIDTH 11.43
      tt-vpc.usuario-trans FORMAT "x(12)":U WIDTH 7.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 85 BY 9.63
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btVpc AT ROW 1.13 COL 25.57 HELP
          "Posiciona VPC" WIDGET-ID 26
     btVpcSit AT ROW 1.13 COL 37.29 HELP
          "Listar Verbas" WIDGET-ID 30
     btFiltro AT ROW 1.13 COL 47.14 HELP
          "Filtrar registros browse" WIDGET-ID 28
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-emitente.cod-emitente AT ROW 3 COL 14 COLON-ALIGNED WIDGET-ID 24
          LABEL "Fornecedor":R10
          VIEW-AS FILL-IN 
          SIZE 8.72 BY .88
     tt-emitente.nome-emit AT ROW 3 COL 22.86 COLON-ALIGNED NO-LABEL WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 58.14 BY .88
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.71 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 22.58
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.38 COL 2
     btAddSon1 AT ROW 11.29 COL 60
     btDeleteSon1 AT ROW 11.29 COL 68.86
     btUpdateSon1 AT ROW 11.29 COL 77.86
     br-rateio AT ROW 11.5 COL 2 WIDGET-ID 300
     fi-total AT ROW 17.17 COL 35.14 COLON-ALIGNED WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.43 ROW 6.29
         SIZE 87.29 BY 17.21
         FONT 1 WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-emitente T "?" NO-UNDO mgcad emitente
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-vpc T "?" NO-UNDO mgesp vpc
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 22.58
         WIDTH              = 90
         MAX-HEIGHT         = 23.17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 23.17
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-emitente.cod-emitente IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
/* BROWSE-TAB br-rateio btUpdateSon1 fPage1 */
ASSIGN 
       btAddSon1:HIDDEN IN FRAME fPage1           = TRUE.

ASSIGN 
       btDeleteSon1:HIDDEN IN FRAME fPage1           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-rateio
/* Query rebuild information for BROWSE br-rateio
     _TblList          = "mgesp.vpc-rateio"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgesp.vpc-rateio.nr-vpc = fnNrVpc()"
     _FldNameList[1]   > mgesp.vpc-rateio.cod-unid-negoc
"vpc-rateio.cod-unid-negoc" "Unidade Neg¢cio" ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgesp.vpc-rateio.cod_ccusto
"vpc-rateio.cod_ccusto" "Centro de Custo" ? "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > mgesp.vpc-rateio.valor
"vpc-rateio.valor" ? ? "decimal" ? ? ? ? ? ? no ? no no "17.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-rateio */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.tt-vpc"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-vpc.nr-vpc
"tt-vpc.nr-vpc" ? ? "integer" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fn-tot-rat(tt-vpc.nr-vpc) @ tt-vpc.valor" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fn-saldo(tt-vpc.nr-vpc) @ de-saldo" "Saldo" "->>>,>>9.99" ? ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-vpc.cod-estabel
"tt-vpc.cod-estabel" ? ? "character" ? ? ? ? ? ? no ? no no "3.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fn-situacao(tt-vpc.situacao) @ c-situacao" "Situaá∆o" "x(10)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fn-forma-pagto(tt-vpc.forma-pagto) @ c-forma-pagto" "Forma Pagto" "x(15)" ? ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fn-tipo-acordo(tt-vpc.tipo-acordo) @ c-tipo-acordo" "Tipo Acordo" "x(15)" ? ? ? ? ? ? ? no ? no no "15.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fn-tipo-verba(tt-vpc.tipo-verba) @ c-tipo-verba" "Tipo Verba" "x(15)" ? ? ? ? ? ? ? no ? no no "17.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-vpc.data-evento
"tt-vpc.data-evento" ? ? "date" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-vpc.data-vencto
"tt-vpc.data-vencto" ? ? "date" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-vpc.data-trans
"tt-vpc.data-trans" ? ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-vpc.usuario-trans
"tt-vpc.usuario-trans" ? ? "character" ? ? ? ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON MOUSE-SELECT-CLICK OF brSon1 IN FRAME fPage1
DO:
  {&OPEN-QUERY-br-rateio}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON ROW-DISPLAY OF brSon1 IN FRAME fPage1
DO:
    IF AVAIL tt-vpc THEN DO:
         CASE tt-vpc.situacao:
             WHEN 0 THEN RUN pi-muda-cor(INPUT ? , INPUT ?).
             WHEN 1 THEN RUN pi-muda-cor(INPUT 3 , INPUT 15).
             WHEN 2 THEN RUN pi-muda-cor(INPUT 9 , INPUT 15).
             WHEN 3 THEN RUN pi-muda-cor(INPUT 12, INPUT ?).
             OTHERWISE RUN pi-muda-cor(INPUT ?, INPUT ?).
         END CASE.
     END.
     ELSE DO:
        RUN pi-muda-cor(INPUT ?, INPUT ?).
     END.
     {&OPEN-QUERY-br-rateio}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON VALUE-CHANGED OF brSon1 IN FRAME fPage1
DO:
    RUN pi-verifica-permissao.
    {&OPEN-QUERY-br-rateio}
    IF  AVAIL tt-vpc THEN
        ASSIGN fi-total:SCREEN-VALUE IN FRAME fpage1 = string(tt-vpc.valor).
    ELSE
        ASSIGN fi-total:SCREEN-VALUE IN FRAME fpage1 = "0".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="esp/utp/esutp022a.w"
                           &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    IF AVAIL tt-vpc AND tt-vpc.situacao = 0 THEN DO: 
        {masterdetail/deleteson.i &PageNumber="1"}
    END.
    ELSE DO:
        MESSAGE "Verba n∆o pode ser eliminada, pois j† foi liberada!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RUN pi-verifica-permissao.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wMasterDetail
ON CHOOSE OF btFiltro IN FRAME fPage0 /* Filtro */
DO:
    DEFINE VARIABLE iRowsReturned AS INTEGER     NO-UNDO.

    DEFINE BUTTON btFiltroCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btFiltroOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtFiltroButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 48 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rFiltro AS ROWID NO-UNDO.
    
    DEFINE VARIABLE i-cod-emitente LIKE tt-vpc.cod-emitente NO-UNDO.

    DEFINE VARIABLE tg-bloqueadas AS LOGICAL
         LABEL "Bloqueadas" 
         VIEW-AS TOGGLE-BOX
         SIZE 20 BY .83 NO-UNDO.
    DEFINE VARIABLE tg-liberadas AS LOGICAL
         LABEL "Liberadas" 
         VIEW-AS TOGGLE-BOX
         SIZE 20 BY .83 NO-UNDO.
    DEFINE VARIABLE tg-finalizadas AS LOGICAL
         LABEL "Finalizadas" 
         VIEW-AS TOGGLE-BOX
         SIZE 20 BY .83 NO-UNDO.
    DEFINE VARIABLE tg-canceladas AS LOGICAL
         LABEL "Canceladas" 
         VIEW-AS TOGGLE-BOX
         SIZE 20 BY .83 NO-UNDO.

    DEFINE FRAME fFiltroVpc
        tg-bloqueadas       AT ROW 1.21 COL 7.00 COLON-ALIGNED
        tg-liberadas        AT ROW 2.21 COL 7.00 COLON-ALIGNED
        tg-finalizadas      AT ROW 3.21 COL 7.00 COLON-ALIGNED
        tg-canceladas       AT ROW 4.21 COL 7.00 COLON-ALIGNED
        btFiltroOK          AT ROW 5.63 COL 2.14
        btFiltroCancel      AT ROW 5.63 COL 13
        rtFiltroButton      AT ROW 5.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Filtro" FONT 1
             DEFAULT-BUTTON btFiltroOK CANCEL-BUTTON btFiltroCancel.
    
    ASSIGN tg-bloqueadas  = l-filtro-bloqueadas 
           tg-liberadas   = l-filtro-liberadas  
           tg-finalizadas = l-filtro-finalizadas
           tg-canceladas  = l-filtro-canceladas.

    DISP tg-bloqueadas 
         tg-liberadas  
         tg-finalizadas
         tg-canceladas WITH FRAME fFiltroVpc.


/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fFiltroVpc:Handle).
    {utp/ut-liter.i "Filtro"}
    ASSIGN FRAME fFiltroVpc:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btFiltroOK IN FRAME fFiltroVpc DO:
        ASSIGN tg-bloqueadas tg-liberadas tg-finalizadas tg-canceladas.
        
        ASSIGN i-cod-emitente       = INT(tt-emitente.cod-emitente:SCREEN-VALUE IN FRAME fPage0)
               l-filtro-bloqueadas  = tg-bloqueadas 
               l-filtro-liberadas   = tg-liberadas  
               l-filtro-finalizadas = tg-finalizadas
               l-filtro-canceladas  = tg-canceladas.
        /*
        RUN setConstraintPrincipal IN {&hDBOSon1} (INPUT i-cod-emitente,
                                                   INPUT l-filtro-bloqueadas,
                                                   INPUT l-filtro-liberadas,
                                                   INPUT l-filtro-finalizadas,
                                                   INPUT l-filtro-canceladas) NO-ERROR.

        RUN openQueryStatic IN {&hDBOSon1} (INPUT "Principal":U) NO-ERROR.

        FOR EACH tt-vpc:
            DELETE tt-vpc.
        END.

        RUN getBatchRecords IN {&hDBOSon1}(INPUT ?,
                                           INPUT ?,
                                           INPUT ?,
                                           OUTPUT iRowsReturned,
                                           OUTPUT TABLE tt-vpc).

        {&OPEN-QUERY-brSon1}*/

        RUN openQueriesSon.

        APPLY "GO":U TO FRAME fFiltroVpc.
    END.
    
    ENABLE tg-bloqueadas tg-liberadas tg-finalizadas tg-canceladas
           btFiltroOK btFiltroCancel 
        WITH FRAME fFiltroVpc. 
    
    WAIT-FOR "GO":U OF FRAME fFiltroVpc.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    DEFINE VARIABLE cStatus AS CHAR NO-UNDO.
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.   

    {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                       &campo="tt-emitente.cod-emitente"    
                       &campo2="tt-emitente.nome-emit"
                       &campozoom="cod-emitente"
                       &campozoom2="nome-emit"
                       &frame="fpage0"
                       &frame2="fpage0"}

      
    IF VALID-HANDLE(wh-pesquisa) THEN
        WAIT-FOR CLOSE OF wh-pesquisa.

    RUN goToKey IN {&hDBOParent} (INPUT FRAME fPage0 tt-emitente.cod-emitente ).
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Emitente":U).
        RETURN NO-APPLY.
    END.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Detalhar */
DO:
    {masterdetail/updateson.i &ProgramSon="esp/utp/esutp061a.w"
                              &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btVpc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVpc wMasterDetail
ON CHOOSE OF btVpc IN FRAME fPage0 /* VPC */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
    RUN goToVpc IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVpcSit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVpcSit wMasterDetail
ON CHOOSE OF btVpcSit IN FRAME fPage0 /* Filtro */
DO:
    DEFINE VARIABLE cStatus AS CHAR NO-UNDO.
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.   

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es455.w"
                         &FieldZoom1="cod-emitente"
                         &FieldScreen1="tt-emitente.cod-emitente"
                         &Frame1="fPage0"
                         &EnableImplant="NO"}
                         
    IF VALID-HANDLE(hProgramZoom) THEN
        WAIT-FOR CLOSE OF hProgramZoom.

    RUN goToKey IN {&hDBOParent} (INPUT FRAME fPage0 tt-emitente.cod-emitente).
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Emitente x Verba":U).
        RETURN NO-APPLY.
    END.
    
    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
    
    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
    
    RUN openQueriesSon.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-rateio
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN btVpc:SENSITIVE IN FRAME fPage0 = YES
           btFiltro:SENSITIVE IN FRAME fPage0 = YES 
           btVpcSit:SENSITIVE IN FRAME fPage0 = YES 
           btUpdateSon1:LABEL IN FRAME fPage1 = "Detalhar"
           br-rateio:SENSITIVE IN FRAME fpage1 = YES.


    APPLY "value-changed" TO brSon1 IN FRAME fPage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-cod-emitente LIKE {&ttParent}.cod-emitente NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-cod-emitente     AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 9  BY .88
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Fornecedores" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Fornecedores"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-emitente.
        
        RUN goToKey IN {&hDBOParent} (INPUT c-cod-emitente).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "emitente":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-emitente btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToVpc wMasterDetail 
PROCEDURE goToVpc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE i-nr-vpc       LIKE tt-vpc.nr-vpc NO-UNDO.
    DEFINE VARIABLE i-cod-emitente LIKE tt-vpc.cod-emitente NO-UNDO.

    DEFINE FRAME fGoToVpc
        i-nr-vpc     AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 9  BY .88
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para VPC" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    DEFINE VARIABLE i-reg AS INTEGER     NO-UNDO.
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToVpc:Handle).
    {utp/ut-liter.i "V†_Para_VPC"}
    ASSIGN FRAME fGoToVpc:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToVpc DO:
        ASSIGN i-nr-vpc.




        RUN openQueryStatic IN {&hDBOSon1} (INPUT "Main":U) NO-ERROR.

       RUN goToKey IN {&hDBOSon1} (INPUT i-nr-vpc).
       IF RETURN-VALUE = "NOK":U THEN DO:
           RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "VPC":U).

           RETURN NO-APPLY.
       END.

       RUN getIntField IN {&hDBOSon1} (INPUT "cod-emitente", OUTPUT i-cod-emitente).

       /*:T Retorna rowid do registro corrente do DBO */
       RUN goToKey IN {&hDBOParent} (INPUT i-cod-emitente).
       IF RETURN-VALUE = "NOK":U THEN DO:
           RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "emitente":U).

           RETURN NO-APPLY.
       END.

       /*:T Retorna rowid do registro corrente do DBO */
       RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).

       /*:T Reposiciona registro com base em um rowid */
       RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).




        /**/
        /**/
        RUN setConstraintVpcEmitente IN {&hDBOSon1} (INPUT INT(tt-emitente.cod-emitente:SCREEN-VALUE IN FRAME fPage0),
                                                     INPUT l-filtro-bloqueadas,
                                                     INPUT l-filtro-liberadas,
                                                     INPUT l-filtro-finalizadas,
                                                     INPUT l-filtro-canceladas) NO-ERROR.

        /**/
        RUN openQueryStatic IN {&hDBOSon1} (INPUT "VpcEmitente":U) NO-ERROR.

        RUN goToKey IN {&hDBOSon1} (INPUT i-nr-vpc).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "VPC":U).

            RETURN NO-APPLY.
        END.

         run getrowid in {&hDBOSon1} (output rGoTo).  

         run getbatchrecords in {&hDBOSon1} 
                                (input rGoto,
                                 input no,
                                 input 40,
                                 output i-reg,
                                 output table tt-vpc).
         {&OPEN-QUERY-{&BROWSE-NAME}} .

        APPLY "value-changed" TO brSon1 IN FRAME fPage1.
        APPLY "GO":U TO FRAME fGoToVpc.
    END.
    
    ENABLE i-nr-vpc btGoToOK btGoToCancel 
        WITH FRAME fGoToVpc. 
    
    WAIT-FOR "GO":U OF FRAME fGoToVpc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "adbo/boad098na.p":U THEN DO:
        {btb/btb008za.i1 adbo/boad098na.p YES}
        {btb/btb008za.i2 adbo/boad098na.p '' {&hDBOParent}} 
    END.
    
/*    RUN setConstraintMain IN {&hDBOParent}  NO-ERROR.*/
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Emitente") NO-ERROR.
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "esbo/boes455.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes455.p YES}
        {btb/btb008za.i2 esbo/boes455.p '' {&hDBOSon1}} 
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    RUN setConstraintVpcEmitente IN {&hDBOSon1} (INPUT INT(tt-emitente.cod-emitente:SCREEN-VALUE IN FRAME fPage0),
                                                 INPUT l-filtro-bloqueadas,
                                                 INPUT l-filtro-liberadas,
                                                 INPUT l-filtro-finalizadas,
                                                 INPUT l-filtro-canceladas) NO-ERROR.
                  
    {masterdetail/openqueriesson.i &Parent="Emitente"
                                   &Query="VpcEmitente"
                                   &PageNumber="1"}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-muda-cor wMasterDetail 
PROCEDURE pi-muda-cor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-bgcolor AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER p-fgcolor AS INTEGER     NO-UNDO.

    /*cor de fundo*/
    ASSIGN tt-vpc.nr-vpc:BGCOLOR         IN BROWSE brSon1 = p-bgcolor
           tt-vpc.valor:BGCOLOR          IN BROWSE brSon1 = p-bgcolor
           tt-vpc.cod-estabel:BGCOLOR    IN BROWSE brSon1 = p-bgcolor
           tt-vpc.data-evento:BGCOLOR    IN BROWSE brSon1 = p-bgcolor
           tt-vpc.data-vencto:BGCOLOR    IN BROWSE brSon1 = p-bgcolor
           tt-vpc.data-trans:BGCOLOR     IN BROWSE brSon1 = p-bgcolor
           tt-vpc.usuario-trans:BGCOLOR  IN BROWSE brSon1 = p-bgcolor
           de-saldo:BGCOLOR              IN BROWSE brSon1 = p-bgcolor
           c-situacao:BGCOLOR            IN BROWSE brSon1 = p-bgcolor
           c-forma-pagto:BGCOLOR         IN BROWSE brSon1 = p-bgcolor
           c-tipo-acordo:BGCOLOR         IN BROWSE brSon1 = p-bgcolor
           c-tipo-verba:BGCOLOR          IN BROWSE brSon1 = p-bgcolor.

    /*cor da letra*/
    ASSIGN tt-vpc.nr-vpc:FGCOLOR         IN BROWSE brSon1 = p-fgcolor
           tt-vpc.valor:FGCOLOR          IN BROWSE brSon1 = p-fgcolor
           tt-vpc.cod-estabel:FGCOLOR    IN BROWSE brSon1 = p-fgcolor
           tt-vpc.data-evento:FGCOLOR    IN BROWSE brSon1 = p-fgcolor
           tt-vpc.data-vencto:FGCOLOR    IN BROWSE brSon1 = p-fgcolor
           tt-vpc.data-trans:FGCOLOR     IN BROWSE brSon1 = p-fgcolor
           tt-vpc.usuario-trans:FGCOLOR  IN BROWSE brSon1 = p-fgcolor
           de-saldo:FGCOLOR              IN BROWSE brSon1 = p-fgcolor
           c-situacao:FGCOLOR            IN BROWSE brSon1 = p-fgcolor
           c-forma-pagto:FGCOLOR         IN BROWSE brSon1 = p-fgcolor
           c-tipo-acordo:FGCOLOR         IN BROWSE brSon1 = p-fgcolor
           c-tipo-verba:FGCOLOR          IN BROWSE brSon1 = p-fgcolor.
        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-permissao wMasterDetail 
PROCEDURE pi-verifica-permissao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*     ASSIGN btDeleteSon1:SENSITIVE   IN FRAME fPage1 = NO.                                                       */
/*                                                                                                                 */
/*                                                                                                                 */
/*     IF AVAIL tt-vpc THEN DO:                                                                                    */
/*         FIND FIRST param-vpc NO-LOCK                                                                            */
/*              WHERE param-vpc.cod-estabel = tt-vpc.cod-estabel NO-ERROR.                                         */
/*                                                                                                                 */
/*         IF tt-vpc.situacao = 0 THEN DO:                                                                         */
/*             IF AVAIL param-vpc AND LOOKUP(c-seg-usuario,param-vpc.aprovadores) <> 0 THEN DO:                    */
/*                 ASSIGN btLiberacao:SENSITIVE IN FRAME fPage1 = YES                                              */
/*                        btDeleteSon1:SENSITIVE IN FRAME fPage1 = YES. /*habilita eliminar caso seja aprovador */ */
/*             END.                                                                                                */
/*             ELSE DO:                                                                                            */
/*                 IF c-seg-usuario = tt-vpc.usuario-trans THEN /*Habilita eliminar somente pra que inclui a vpc*/ */
/*                     ASSIGN btDeleteSon1:SENSITIVE IN FRAME fPage1 = YES.                                        */
/*             END.                                                                                                */
/*         END.                                                                                                    */
/*         ELSE DO:                                                                                                */
/*             ASSIGN btTitulos:SENSITIVE      IN FRAME fPage1 = YES                                               */
/*                    btPagtoProduto:SENSITIVE IN FRAME fPage1 = YES.                                              */
/*         END.                                                                                                    */
/*                                                                                                                 */
/*         IF tt-vpc.situacao = 1 THEN DO:                                                                         */
/*             IF AVAIL param-vpc AND LOOKUP(c-seg-usuario,param-vpc.aprovadores) <> 0 THEN DO:                    */
/*                 ASSIGN btZeraSaldo:SENSITIVE    IN FRAME fPage1 = YES                                           */
/*                        btAlterVencto:SENSITIVE  IN FRAME fPage1 = YES.                                          */
/*             END.                                                                                                */
/*         END.                                                                                                    */
/*     END.                                                                                                        */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-forma-pagto wMasterDetail 
FUNCTION fn-forma-pagto RETURNS CHARACTER (INPUT p-forma-pagto AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.

    ASSIGN c-retorno = "".
    CASE p-forma-pagto:
        WHEN 0 THEN ASSIGN c-retorno = "Boleto".
        WHEN 1 THEN ASSIGN c-retorno = "Desconto".
        WHEN 2 THEN ASSIGN c-retorno = "Produto".
        WHEN 3 THEN ASSIGN c-retorno = "Dep¢sito".
    END CASE.

  RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-saldo wMasterDetail 
FUNCTION fn-saldo RETURNS DECIMAL
  (INPUT p-nr-vpc AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-saldo AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE h-esapi015 AS HANDLE      NO-UNDO.
        
    ASSIGN de-saldo = 0.
    IF AVAIL tt-vpc THEN DO:
        RUN esapi/esapi015.p PERSISTENT SET h-esapi015.
        RUN pi-retorna-saldo-titulo IN h-esapi015 (INPUT p-nr-vpc,
                                                   OUTPUT de-saldo).

        DELETE PROCEDURE h-esapi015.
    END.

    RETURN de-saldo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-situacao wMasterDetail 
FUNCTION fn-situacao RETURNS CHARACTER (INPUT p-situacao AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.

    ASSIGN c-retorno = "".
    CASE p-situacao:
        WHEN 0 THEN ASSIGN c-retorno = "Bloqueado".
        WHEN 1 THEN ASSIGN c-retorno = "Liberado".
        WHEN 2 THEN ASSIGN c-retorno = "Finalizado".
        WHEN 3 THEN ASSIGN c-retorno = "Cancelado".
    END CASE.

  RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-tipo-acordo wMasterDetail 
FUNCTION fn-tipo-acordo RETURNS CHARACTER (INPUT p-tipo-acordo AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.

    ASSIGN c-retorno = "".

    FIND FIRST tipo-acordo NO-LOCK
         WHERE tipo-acordo.codigo = p-tipo-acordo NO-ERROR.
    IF AVAIL tipo-acordo THEN
        ASSIGN c-retorno = STRING(p-tipo-acordo) + "-" +  tipo-acordo.descricao.
    ELSE
        ASSIGN c-retorno = STRING(p-tipo-acordo) + "-N∆o cadastrado".

  RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-tipo-verba wMasterDetail 
FUNCTION fn-tipo-verba RETURNS CHARACTER (INPUT p-tipo-verba AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.

    ASSIGN c-retorno = "".

    FIND FIRST tipo-verba NO-LOCK
         WHERE tipo-verba.codigo = p-tipo-verba NO-ERROR.
    IF AVAIL tipo-verba THEN
        ASSIGN c-retorno = STRING(p-tipo-verba) + "-" +  tipo-verba.descricao.
    ELSE
        ASSIGN c-retorno = STRING(p-tipo-verba) + "-N∆o cadastrado".

  RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-tot-rat wMasterDetail 
FUNCTION fn-tot-rat RETURNS DECIMAL
  (INPUT p-nr-vpc AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
        
    DEF VAR de-valor-total AS DEC NO-UNDO.

   IF  AVAIL tt-vpc THEN DO:
       FOR EACH vpc-rateio NO-LOCK
           WHERE vpc-rateio.nr-vpc = tt-vpc.nr-vpc:
           de-valor-total = de-valor-total + vpc-rateio.valor.
       END.
    END.

    RETURN de-valor-total.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNrVpc wMasterDetail 
FUNCTION fnNrVpc RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF  AVAIL tt-vpc THEN
      RETURN tt-vpc.nr-vpc.
  ELSE
      RETURN 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

