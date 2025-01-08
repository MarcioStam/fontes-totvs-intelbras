&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-estrut-astec NO-UNDO LIKE estrut-astec
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttitem NO-UNDO LIKE item
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESENP014 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESENP014
&GLOBAL-DEFINE Version        1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Engenharia,Astec

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        ttitem
&GLOBAL-DEFINE hDBOTable      hDBOitem
&GLOBAL-DEFINE DBOTable       ITEM

&GLOBAL-DEFINE page0KeyFields 
&GLOBAL-DEFINE page0Fields    ttitem.it-codigo ttitem.desc-item tgPermiteOS tgTroca f-garantia
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields

&GLOBAL-DEFINE page1Widgets btSave2 btGarantiaEstr btVendaEstrut btGarantia btVenda btPermiteOS btTrocaObrig btIntervTecnica btSerieObrig
&GLOBAL-DEFINE page2Widgets br-astec bt-incluir-astec bt-modificar-astec bt-eliminar-astec

/* Parameters Definitions ---                                           */


/* Local Variable Definitions ---                                       */
{upc/btb910za-upc.i}

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEF VAR wh-pesquisa AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.

def var c-familia   as char.
def var i-tot       as int      no-undo.
def var i-conta     as int.
def var i-nivel     as int.
DEF VAR c-tipo      AS CHAR.
DEF VAR c-nodeinfo AS CHAR.

DEFINE TEMP-TABLE tt-estrutura-integra NO-UNDO
    FIELD CodigoProduto LIKE estrutura.it-codigo.

DEF VAR raw-param   AS RAW  NO-UNDO.

DEFINE VARIABLE iGarantia AS INTEGER     NO-UNDO.
DEFINE VARIABLE lVenda    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lRetorno  AS LOGICAL     NO-UNDO.

/* Buffers de tabelas ---                                               */

def buffer b-e      for estrutura.
def buffer b-item   for item.


DEF TEMP-TABLE tt-estrut
    FIELD it-codigo      LIKE ITEM.it-codigo
    FIELD sequencia      LIKE estrutura.sequencia
    FIELD es-codigo      LIKE ITEM.it-codigo
    FIELD desc-item      LIKE ITEM.desc-item
    FIELD data-inicio    LIKE estrutura.data-inicio
    FIELD data-termino   LIKE estrutura.data-termino
    FIELD garantia       LIKE int-estrutura.garantia
    FIELD venda          LIKE int-estrutura.venda
    FIELD desc-alt       LIKE int-estrutura.desc-alt
    FIELD r-rowid        AS ROWID.

DEF TEMP-TABLE tt-astec-tela
    LIKE tt-estrut.

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF BUFFER btt-estrut FOR tt-estrut.

{esp/es0018.i}

DEFINE VARIABLE h-boes727 AS HANDLE NO-UNDO.
DEFINE VARIABLE iRowsReturned AS INTEGER     NO-UNDO.

DEFINE VARIABLE c-estabelecimentos AS CHARACTER  INIT "101,104" NO-UNDO.
DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-fat-estabs AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-lai02 AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-astec02 AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-arq-excel AS CHARACTER   NO-UNDO.
DEFINE VARIABLE chexcel AS COM-HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-excel NO-UNDO
    FIELD it-codigo         AS CHAR
    FIELD sequencia         AS INT
    FIELD es-codigo         AS CHAR
    FIELD descricao         AS CHAR
    FIELD garantia          AS INT
    FIELD venda             AS LOG
    FIELD val-lai02         AS DEC
    FIELD val-astec         AS DEC
    FIELD status-garantia   AS CHAR
    FIELD status-venda      AS CHAR.

DEFINE TEMP-TABLE tt-est-excel NO-UNDO
    FIELD cod-estabel       AS CHAR
    FIELD it-codigo         AS CHAR
    FIELD fatura            AS LOG.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-astec

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-astec-tela tt-estrut

/* Definitions for BROWSE br-astec                                      */
&Scoped-define FIELDS-IN-QUERY-br-astec tt-astec-tela.it-codigo tt-astec-tela.sequencia tt-astec-tela.es-codigo tt-astec-tela.desc-item tt-astec-tela.garantia tt-astec-tela.venda tt-astec-tela.desc-alt   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-astec tt-astec-tela.garantia tt-astec-tela.venda tt-astec-tela.desc-alt   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-astec tt-astec-tela
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-astec tt-astec-tela
&Scoped-define SELF-NAME br-astec
&Scoped-define QUERY-STRING-br-astec FOR EACH tt-astec-tela
&Scoped-define OPEN-QUERY-br-astec OPEN QUERY {&SELF-NAME} FOR EACH tt-astec-tela.
&Scoped-define TABLES-IN-QUERY-br-astec tt-astec-tela
&Scoped-define FIRST-TABLE-IN-QUERY-br-astec tt-astec-tela


/* Definitions for BROWSE britem                                        */
&Scoped-define FIELDS-IN-QUERY-britem tt-estrut.es-codigo tt-estrut.desc-item tt-estrut.garantia tt-estrut.venda tt-estrut.desc-alt tt-estrut.data-inicio tt-estrut.data-termino   
&Scoped-define ENABLED-FIELDS-IN-QUERY-britem tt-estrut.garantia tt-estrut.venda tt-estrut.desc-alt   
&Scoped-define ENABLED-TABLES-IN-QUERY-britem tt-estrut
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-britem tt-estrut
&Scoped-define SELF-NAME britem
&Scoped-define QUERY-STRING-britem FOR EACH tt-estrut
&Scoped-define OPEN-QUERY-britem OPEN QUERY {&SELF-NAME} FOR EACH tt-estrut.
&Scoped-define TABLES-IN-QUERY-britem tt-estrut
&Scoped-define FIRST-TABLE-IN-QUERY-britem tt-estrut


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-britem}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-br-astec}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttitem.it-codigo ttitem.desc-item 
&Scoped-define ENABLED-TABLES ttitem
&Scoped-define FIRST-ENABLED-TABLE ttitem
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btUpdate btSave bt-valida bt-altern btQueryJoins ~
btReportsJoins btExit btHelp f-garantia tgPermiteOS tgTroca 
&Scoped-Define DISPLAYED-FIELDS ttitem.it-codigo ttitem.desc-item 
&Scoped-define DISPLAYED-TABLES ttitem
&Scoped-define FIRST-DISPLAYED-TABLE ttitem
&Scoped-Define DISPLAYED-OBJECTS f-garantia tgPermiteOS tgTroca 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
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


/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE ChTreeView AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chChTreeView AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-altern 
     IMAGE-UP FILE "image/im-copy3.bmp":U
     LABEL "Alternativos" 
     SIZE 4 BY 1.25 TOOLTIP "Alternativos"
     FONT 4.

DEFINE BUTTON bt-valida 
     IMAGE-UP FILE "image/im-local.bmp":U
     LABEL "Valida‡äes" 
     SIZE 4 BY 1.25 TOOLTIP "Valida‡äes"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
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

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE f-garantia AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Garantia" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 128 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 128 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tgPermiteOS AS LOGICAL INITIAL no 
     LABEL "Permite OS" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tgTroca AS LOGICAL INITIAL no 
     LABEL "PermiteTroca" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE BUTTON btGarantia 
     LABEL "Atual. Garantia" 
     SIZE 14 BY 1.13.

DEFINE BUTTON btGarantiaEstr 
     LABEL "Estrut. Garantia" 
     SIZE 14 BY 1.13.

DEFINE BUTTON btSave2 
     LABEL "Salvar" 
     SIZE 14 BY 1.13.

DEFINE BUTTON btVenda 
     LABEL "Atual. Venda" 
     SIZE 14 BY 1.13.

DEFINE BUTTON btVendaEstrut 
     LABEL "Estrut. Venda" 
     SIZE 14 BY 1.13.

DEFINE BUTTON bt-eliminar-astec 
     LABEL "Eliminar" 
     SIZE 14 BY 1.13.

DEFINE BUTTON bt-incluir-astec 
     LABEL "Incluir" 
     SIZE 14 BY 1.13.

DEFINE BUTTON bt-modificar-astec 
     LABEL "Modificar" 
     SIZE 14 BY 1.13.

DEFINE BUTTON btGarantia-astec 
     LABEL "Atual. Garantia" 
     SIZE 14 BY 1.13.

DEFINE BUTTON btGarantiaEstr-astec 
     LABEL "Estrut. Garantia" 
     SIZE 14 BY 1.13.

DEFINE BUTTON btSave-astec 
     LABEL "Salvar" 
     SIZE 14 BY 1.13.

DEFINE BUTTON btVenda-astec 
     LABEL "Atual. Venda" 
     SIZE 14 BY 1.13.

DEFINE BUTTON btVendaEstrut-astec 
     LABEL "Estrut. Venda" 
     SIZE 14 BY 1.13.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-astec FOR 
      tt-astec-tela SCROLLING.

DEFINE QUERY britem FOR 
      tt-estrut SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-astec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-astec wMaintenance _FREEFORM
  QUERY br-astec DISPLAY
      tt-astec-tela.it-codigo    FORMAT "x(10)"   COLUMN-LABEL "Item Pai"
          tt-astec-tela.sequencia
tt-astec-tela.es-codigo    FORMAT "x(10)"   COLUMN-LABEL "Componente"
    tt-astec-tela.desc-item    FORMAT "x(50)" 
    tt-astec-tela.garantia
    tt-astec-tela.venda        FORMAT "Sim/NÆo"
    tt-astec-tela.desc-alt

    ENABLE tt-astec-tela.garantia tt-astec-tela.venda tt-astec-tela.desc-alt
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 122 BY 16
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE britem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS britem wMaintenance _FREEFORM
  QUERY britem DISPLAY
      tt-estrut.es-codigo    FORMAT "x(08)"   
    tt-estrut.desc-item    FORMAT "x(50)" 
    tt-estrut.garantia
    tt-estrut.venda        FORMAT "Sim/NÆo"
    tt-estrut.desc-alt
    tt-estrut.data-inicio
    tt-estrut.data-termino

    ENABLE tt-estrut.garantia tt-estrut.venda tt-estrut.desc-alt
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 75 BY 16.5
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btUpdate AT ROW 1.13 COL 50.86 HELP
          "Altera ocorrˆncia corrente" WIDGET-ID 12
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma altera‡äes" WIDGET-ID 14
     bt-valida AT ROW 1.13 COL 94.72 HELP
          "Relat¢rios relacionados" WIDGET-ID 20
     bt-altern AT ROW 1.13 COL 98.72 HELP
          "Relat¢rios relacionados" WIDGET-ID 22
     btQueryJoins AT ROW 1.13 COL 111.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 115.29 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 119.29 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 123.29 HELP
          "Ajuda"
     ttitem.it-codigo AT ROW 3.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     ttitem.desc-item AT ROW 3.25 COL 34 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 44 BY .88
     f-garantia AT ROW 3.25 COL 118.14 COLON-ALIGNED WIDGET-ID 18
     tgPermiteOS AT ROW 3.29 COL 87 WIDGET-ID 2
     tgTroca AT ROW 3.29 COL 99.14 WIDGET-ID 16
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 128.29 BY 25
         FONT 1.

DEFINE FRAME fPage2
     br-astec AT ROW 1.25 COL 2 WIDGET-ID 200
     bt-incluir-astec AT ROW 17.5 COL 2 WIDGET-ID 12
     bt-modificar-astec AT ROW 17.5 COL 16 WIDGET-ID 14
     bt-eliminar-astec AT ROW 17.5 COL 30 WIDGET-ID 16
     btGarantiaEstr-astec AT ROW 17.5 COL 51 WIDGET-ID 8
     btVendaEstrut-astec AT ROW 17.5 COL 65 WIDGET-ID 10
     btGarantia-astec AT ROW 17.5 COL 82 WIDGET-ID 6
     btVenda-astec AT ROW 17.5 COL 96 WIDGET-ID 4
     btSave-astec AT ROW 17.5 COL 110 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 6.5
         SIZE 124 BY 18.25
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     britem AT ROW 1 COL 50
     btGarantiaEstr AT ROW 17.75 COL 50 WIDGET-ID 8
     btVendaEstrut AT ROW 17.75 COL 64 WIDGET-ID 10
     btGarantia AT ROW 17.75 COL 83 WIDGET-ID 6
     btVenda AT ROW 17.75 COL 97 WIDGET-ID 4
     btSave2 AT ROW 17.75 COL 111 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 6.5
         SIZE 124 BY 18.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-estrut-astec T "?" NO-UNDO mgesp estrut-astec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttitem T "?" NO-UNDO mgcad item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 25
         WIDTH              = 128.29
         MAX-HEIGHT         = 38.88
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 38.88
         VIRTUAL-WIDTH      = 195.14
         MAX-BUTTON         = no
         RESIZE             = no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB britem 1 fPage1 */
ASSIGN 
       britem:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB br-astec 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-astec
/* Query rebuild information for BROWSE br-astec
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-astec-tela.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-astec */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE britem
/* Query rebuild information for BROWSE britem
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-estrut.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE britem */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME ChTreeView ASSIGN
       FRAME           = FRAME fPage1:HANDLE
       ROW             = 1
       COLUMN          = 1
       HEIGHT          = 17.5
       WIDTH           = 48
       HIDDEN          = no
       SENSITIVE       = yes.
/* ChTreeView OCXINFO:CREATE-CONTROL from: {6C00BE45-F188-11D2-8CE6-00A0D21A0A6B} type: TreeView4GL */
      ChTreeView:MOVE-BEFORE(britem:HANDLE IN FRAME fPage1).

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME britem
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME britem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL britem wMaintenance
ON ROW-DISPLAY OF britem IN FRAME fPage1
DO:
    IF tt-estrut.data-termino < TODAY THEN
        ASSIGN tt-estrut.es-codigo:FGCOLOR IN BROWSE britem = 12     
               tt-estrut.desc-item:FGCOLOR IN BROWSE britem = 12        
               tt-estrut.data-inicio:FGCOLOR IN BROWSE britem = 12       
               tt-estrut.data-termino:FGCOLOR IN BROWSE britem = 12.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-altern
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-altern wMaintenance
ON CHOOSE OF bt-altern IN FRAME fpage0 /* Alternativos */
DO:
    
    RUN esp/cpp/escpp095.w.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-eliminar-astec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar-astec wMaintenance
ON CHOOSE OF bt-eliminar-astec IN FRAME fPage2 /* Eliminar */
DO:
    IF AVAIL tt-astec-tela THEN DO:
        IF tt-astec-tela.r-rowid = ? THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 17006,
                               INPUT "Elimina‡Æo de componente inv lida~~NÆo ‚ permitido eliminar o componente pois o item pai ‚ um Alternativo. Para manuten‡Æo desse alternativo, verificar em ESCPP095.").
            RETURN "NOK".
        END.

        RUN pi-elimina-astec.
    
        IF RETURN-VALUE = "OK" THEN
            RUN pi-astec-monta.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir-astec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir-astec wMaintenance
ON CHOOSE OF bt-incluir-astec IN FRAME fPage2 /* Incluir */
DO:

    wMaintenance:SENSITIVE = FALSE.

    RUN esp/enp/esenp014c.w (INPUT "CREATE",
                             INPUT INPUT FRAME fPage0 ttitem.it-codigo,
                             INPUT ?,
                             INPUT h-boes727).

    wMaintenance:SENSITIVE = TRUE.

    RUN pi-astec-monta.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-modificar-astec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar-astec wMaintenance
ON CHOOSE OF bt-modificar-astec IN FRAME fPage2 /* Modificar */
DO:

    IF AVAIL tt-astec-tela
        AND tt-astec-tela.r-rowid <> ? THEN DO:

        wMaintenance:SENSITIVE = FALSE.
    
        RUN esp/enp/esenp014c.w (INPUT "UPDATE",
                                 INPUT INPUT FRAME fPage0 ttitem.it-codigo,
                                 INPUT tt-astec-tela.r-rowid,
                                 INPUT h-boes727).
    
        wMaintenance:SENSITIVE = TRUE.
    
        RUN pi-astec-monta.

    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-valida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-valida wMaintenance
ON CHOOSE OF bt-valida IN FRAME fpage0 /* Valida‡äes */
DO:

    EMPTY TEMP-TABLE tt-excel.
    
    RUN pi-valida-estrut (INPUT INPUT FRAME fPage0 ttitem.it-codigo).

    RUN pi-valida-astec (INPUT INPUT FRAME FPage0 ttitem.it-codigo).


    /* Gera‡Æo do Arquivo */

    ASSIGN c-arq-excel = SESSION:TEMP-DIR.

    ASSIGN c-arq-excel = REPLACE(c-arq-excel, "/", "\").

    IF SUBSTRING(c-arq-excel, LENGTH(c-arq-excel), 1) <> "\" THEN
        ASSIGN c-arq-excel = c-arq-excel + "\".

    ASSIGN c-arq-excel = c-arq-excel + "esenp014-" + STRING(TIME) + ".csv".

    OUTPUT TO VALUE(c-arq-excel) NO-CONVERT.

    PUT UNFORMATTED
        "Pai;Seq;Item;Descri‡Æo;Garantia;Venda;".

    DO i-aux = 1 TO NUM-ENTRIES(c-estabelecimentos):

        PUT UNFORMATTED
            "Fat " + ENTRY(i-aux, c-estabelecimentos) + ";".

    END.

    PUT UNFORMATTED
        "Valor LAI02;Valor Astec 02;Status Garantia;Status Venda" SKIP.
    
    FOR EACH tt-excel
        BY tt-excel.it-codigo
        BY tt-excel.sequencia
        BY tt-excel.it-codigo:

        PUT UNFORMATTED 
            tt-excel.it-codigo                  ";"
            tt-excel.sequencia                  ";"
            tt-excel.es-codigo                  ";"
            tt-excel.descricao                  ";"
            tt-excel.garantia                   ";"
            string(tt-excel.venda, "Sim/NÆo")   ";".

        DO i-aux = 1 TO NUM-ENTRIES(c-estabelecimentos):

            FOR FIRST tt-est-excel
                WHERE tt-est-excel.cod-estabel = ENTRY(i-aux, c-estabelecimentos)
                AND   tt-est-excel.it-codigo   = tt-excel.es-codigo:

                PUT UNFORMATTED
                    string(tt-est-excel.fatura, "Sim/NÆo") ";".

            END.
    
        END.

        PUT UNFORMATTED
            tt-excel.val-lai02          ";"
            tt-excel.val-astec          ";"
            tt-excel.status-garantia    ";"
            tt-excel.status-venda       SKIP.

    END.

    OUTPUT CLOSE.



    /* Abertura do Arquivo */

    create "Excel.Application":U chExcel.

    chExcel:WorkBooks:Open(c-arq-excel).

    chExcel:visible = true.

    release object chExcel.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btGarantia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGarantia wMaintenance
ON CHOOSE OF btGarantia IN FRAME fPage1 /* Atual. Garantia */
DO:
    assign {&window-name}:sensitive = NO.
    RUN esp/enp/esenp014a.w (OUTPUT iGarantia,
                             OUTPUT lRetorno).
    assign {&window-name}:sensitive = YES.

    IF lRetorno THEN
        RUN pi-atualiza-garantia.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btGarantia-astec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGarantia-astec wMaintenance
ON CHOOSE OF btGarantia-astec IN FRAME fPage2 /* Atual. Garantia */
DO:
    assign {&window-name}:sensitive = NO.
    RUN esp/enp/esenp014a.w (OUTPUT iGarantia,
                             OUTPUT lRetorno).
    assign {&window-name}:sensitive = YES.

    IF lRetorno THEN
        RUN pi-atualiza-garantia-astec.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btGarantiaEstr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGarantiaEstr wMaintenance
ON CHOOSE OF btGarantiaEstr IN FRAME fPage1 /* Estrut. Garantia */
DO:
    DEFINE VAR p-NodeInfo AS CHARACTER NO-UNDO.
    p-NodeInfo = c-nodeinfo.

    assign {&window-name}:sensitive = NO.
    RUN esp/enp/esenp014a.w (OUTPUT iGarantia,
                             OUTPUT lRetorno).
    assign {&window-name}:sensitive = YES.

    IF lRetorno THEN DO:
        RUN pi-atualiza-estrut (INPUT tt-estrut.it-codigo,
                                INPUT string(iGarantia),
                                INPUT "garantia").

        RUN pi-monta (INPUT {nodeprivate.i}).   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btGarantiaEstr-astec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGarantiaEstr-astec wMaintenance
ON CHOOSE OF btGarantiaEstr-astec IN FRAME fPage2 /* Estrut. Garantia */
DO:

    assign {&window-name}:sensitive = NO.
    RUN esp/enp/esenp014a.w (OUTPUT iGarantia,
                             OUTPUT lRetorno).
    assign {&window-name}:sensitive = YES.

    IF lRetorno THEN DO:
        RUN pi-atualiza-estrut-astec (INPUT INPUT FRAME fPage0 ttitem.it-codigo,
                                      INPUT string(iGarantia),
                                      INPUT "garantia").

        /**/

        FOR EACH altern-astec NO-LOCK
            WHERE altern-astec.it-codigo = INPUT FRAME fPage0 ttitem.it-codigo:

            RUN pi-atualiza-estrut (INPUT altern-astec.it-altern,
                                    INPUT string(iGarantia),
                                    INPUT "garantia").

        END.

        RUN pi-astec-monta.   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:

    DO TRANS:
        FOR FIRST int-item EXCLUSIVE-LOCK
            WHERE int-item.it-codigo  = ttitem.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}:
    
            ASSIGN int-item.log1 = tgPermiteOS:CHECKED IN FRAME {&FRAME-NAME}
                   int-item.int2 = int(f-garantia:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
    
            IF tgTroca:CHECKED IN FRAME {&FRAME-NAME} = YES THEN
                ASSIGN overlay(int-item.char1,1,3) = "SIM".
            ELSE
                ASSIGN overlay(int-item.char1,1,3) = "NAO".
    
        END.
    
        RELEASE int-item.
    END.

    ASSIGN tgPermiteOS:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           tgTroca:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           f-garantia:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           SELF:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btSave-astec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave-astec wMaintenance
ON CHOOSE OF btSave-astec IN FRAME fPage2 /* Salvar */
DO:
    RUN pi-salva-astec.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btSave2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave2 wMaintenance
ON CHOOSE OF btSave2 IN FRAME fPage1 /* Salvar */
DO:
    RUN pi-salva.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    DEFINE VARIABLE cStatus AS CHAR NO-UNDO.
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.   

    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo="ttitem.it-codigo"    
                       &campo2="ttitem.desc-item"
                       &campozoom="it-codigo"
                       &campozoom2="desc-item"
                       &frame="fpage0"
                       &frame2="fpage0"}

      
    IF VALID-HANDLE(wh-pesquisa) THEN
        WAIT-FOR CLOSE OF wh-pesquisa.

    RUN goToKey IN {&hDBOTable} (INPUT FRAME fPage0 ttitem.it-codigo ).
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Item deve ser do grupo de estoque de produtos acabados.":U).
        RETURN NO-APPLY.
    END.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    ASSIGN tgPermiteOS:SENSITIVE IN FRAME {&FRAME-NAME} = YES
           btSave:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

    IF tgPermiteOS:CHECKED IN FRAME {&FRAME-NAME} = YES THEN
        ASSIGN tgTroca:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE
        ASSIGN tgTroca:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    IF tgTroca:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
       tgTroca:CHECKED IN FRAME {&FRAME-NAME} = YES THEN
        ASSIGN f-garantia:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE
        ASSIGN f-garantia:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btVenda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVenda wMaintenance
ON CHOOSE OF btVenda IN FRAME fPage1 /* Atual. Venda */
DO:
    assign {&window-name}:sensitive = NO.
    RUN esp/enp/esenp014b.w (OUTPUT lVenda,
                             OUTPUT lRetorno).
    assign {&window-name}:sensitive = YES.

    IF lRetorno THEN
        RUN pi-atualiza-venda.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btVenda-astec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVenda-astec wMaintenance
ON CHOOSE OF btVenda-astec IN FRAME fPage2 /* Atual. Venda */
DO:
    assign {&window-name}:sensitive = NO.
    RUN esp/enp/esenp014b.w (OUTPUT lVenda,
                             OUTPUT lRetorno).
    assign {&window-name}:sensitive = YES.

    IF lRetorno THEN
        RUN pi-atualiza-venda-astec.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btVendaEstrut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVendaEstrut wMaintenance
ON CHOOSE OF btVendaEstrut IN FRAME fPage1 /* Estrut. Venda */
DO:
    DEFINE VAR p-NodeInfo AS CHARACTER NO-UNDO.
    p-NodeInfo = c-nodeinfo.

    assign {&window-name}:sensitive = NO.
    RUN esp/enp/esenp014b.w (OUTPUT lVenda,
                             OUTPUT lRetorno).
    assign {&window-name}:sensitive = YES.

    IF lRetorno THEN DO:
        RUN pi-atualiza-estrut(INPUT tt-estrut.it-codigo,
                               INPUT lVenda,
                               INPUT "venda").

        RUN pi-monta (INPUT {nodeprivate.i}).    
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btVendaEstrut-astec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVendaEstrut-astec wMaintenance
ON CHOOSE OF btVendaEstrut-astec IN FRAME fPage2 /* Estrut. Venda */
DO:

    assign {&window-name}:sensitive = NO.
    RUN esp/enp/esenp014b.w (OUTPUT lVenda,
                             OUTPUT lRetorno).
    assign {&window-name}:sensitive = YES.

    IF lRetorno THEN DO:
        RUN pi-atualiza-estrut-astec (INPUT INPUT FRAME fPage0 ttitem.it-codigo,
                                      INPUT string(lVenda),
                                      INPUT "venda").

        /**/

        FOR EACH altern-astec NO-LOCK
            WHERE altern-astec.it-codigo = INPUT FRAME fPage0 ttitem.it-codigo:

            RUN pi-atualiza-estrut (INPUT altern-astec.it-altern,
                                    INPUT string(lVenda),
                                    INPUT "venda").

        END.

        RUN pi-astec-monta.   
    END.

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ChTreeView
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ChTreeView wMaintenance OCX.OnChange
PROCEDURE ChTreeView.TreeView4GL.OnChange .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Required for OCX.
    NodeInfo
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-NodeInfo AS CHARACTER NO-UNDO.

RUN pi-monta (INPUT {nodeprivate.i}).
ASSIGN c-nodeinfo = p-nodeinfo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ChTreeView wMaintenance OCX.OnExpanded
PROCEDURE ChTreeView.TreeView4GL.OnExpanded .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Required for OCX.
    NodeInfo
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-NodeInfo AS CHARACTER NO-UNDO.

RUN pi-monta (INPUT {nodeprivate.i}).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tgPermiteOS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgPermiteOS wMaintenance
ON VALUE-CHANGED OF tgPermiteOS IN FRAME fpage0 /* Permite OS */
DO:
    IF tgPermiteOS:CHECKED IN FRAME {&FRAME-NAME} = YES THEN
        ASSIGN tgTroca:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
               
    ELSE DO:
        ASSIGN tgTroca:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               tgTroca:CHECKED IN FRAME {&FRAME-NAME} = NO
               f-garantia:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               f-garantia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".

        
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgTroca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgTroca wMaintenance
ON VALUE-CHANGED OF tgTroca IN FRAME fpage0 /* PermiteTroca */
DO:
    IF tgTroca:CHECKED IN FRAME {&FRAME-NAME} = YES THEN
        ASSIGN f-garantia:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE 
        ASSIGN f-garantia:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               f-garantia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".

        
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-astec
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/MainBlock.i}

ENABLE britem
       WITH FRAME fPage1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterControlToolBar wMaintenance 
PROCEDURE AfterControlToolBar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN esp\es0018p.p (INPUT "esenp014", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    
    IF NOT CAN-FIND(FIRST tt-prog-ponto
                    WHERE tt-prog-ponto.conteudo = c-seg-usuario) THEN DO:

        DISABLE btUpdate
            WITH FRAME fPage0.

        DISABLE btSave-astec
            WITH FRAME fPage2.
        
        ASSIGN MENU-ITEM miUpdate:SENSITIVE IN MENU mbMain = FALSE.

    END.

   

    RETURN "OK":U.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
    DELETE PROCEDURE h-boes727.
    ASSIGN h-boes727 = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplayFields wMaintenance 
PROCEDURE AfterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN pi-mostra (INPUT FRAME fPage0 ttitem.it-codigo).

    RUN pi-astec-monta.

    FOR FIRST int-item NO-LOCK
        WHERE int-item.it-codigo  = ttitem.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}:

        ASSIGN tgPermiteOS:CHECKED IN FRAME {&FRAME-NAME} = int-item.log1
               f-garantia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(int-item.int2).

        IF substring(int-item.char1,1,3) = "SIM" THEN
            ASSIGN tgTroca:CHECKED IN FRAME {&FRAME-NAME} = YES.
        ELSE
            ASSIGN tgTroca:CHECKED IN FRAME {&FRAME-NAME} = NO.

    END.

    DO WITH FRAME fPage2:

        ASSIGN br-astec:SENSITIVE = TRUE
               bt-incluir-astec:SENSITIVE = TRUE
               bt-modificar-astec:SENSITIVE = TRUE
               bt-eliminar-astec:SENSITIVE = TRUE
               btGarantiaEstr-astec:SENSITIVE = TRUE
               btVendaEstrut-astec:SENSITIVE = TRUE
               btGarantia-astec:SENSITIVE = TRUE
               btVenda-astec:SENSITIVE = TRUE
               btSave-astec:SENSITIVE = TRUE.
    END.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wMaintenance 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:

        ASSIGN bt-valida:SENSITIVE = TRUE
               bt-altern:SENSITIVE = TRUE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load wMaintenance  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "esenp014.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chChTreeView = ChTreeView:COM-HANDLE
    UIB_S = chChTreeView:LoadControls( OCXFile, "ChTreeView":U)
    ChTreeView:NAME = "ChTreeView":U
  .
  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.
END.
ELSE MESSAGE "esenp014.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
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
    
    DEFINE VARIABLE c-it-codigo LIKE {&ttTable}.it-codigo NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-it-codigo       AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Item" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-it-codigo.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-it-codigo ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Item":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-it-codigo btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo\boes172q01.r":U THEN DO:
        {btb/btb008za.i1 esbo\boes172q01.p YES}
        {btb/btb008za.i2 esbo\boes172q01.p '' {&hDBOTable}}
    END.
        
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    FOR EACH ttitem 
       WHERE ttitem.ge-codigo <> 40
         AND ttitem.ge-codigo <> 42
         AND ttitem.ge-codigo <> 45 EXCLUSIVE-LOCK:

        DELETE ttitem.
    END.

    RUN esbo/boes727.p PERSISTENT SET h-boes727.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-astec-monta wMaintenance 
PROCEDURE pi-astec-monta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-astec-tela.

    RUN pi-carga-astec-tela-por-item (INPUT INPUT FRAME fPage0 ttitem.it-codigo).

    FOR EACH altern-astec NO-LOCK
        WHERE altern-astec.it-codigo = INPUT FRAME fPage0 ttitem.it-codigo:

        FOR EACH estrutura NO-LOCK
            WHERE estrutura.it-codigo    =  altern-astec.it-altern
            AND   estrutura.data-inicio  <= TODAY 
            AND   estrutura.data-termino >  today:
            
            FOR FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = estrutura.es-codigo:
            END.
    
            CREATE tt-astec-tela.             
            ASSIGN tt-astec-tela.it-codigo    = estrutura.it-codigo
                   tt-astec-tela.sequencia    = estrutura.sequencia
                   tt-astec-tela.es-codigo    = estrutura.es-codigo
                   tt-astec-tela.desc-item    = IF AVAIL ITEM THEN ITEM.desc-item ELSE ""
                   tt-astec-tela.data-inicio  = estrutura.data-inicio
                   tt-astec-tela.data-termino = estrutura.data-termino
                   tt-astec-tela.r-rowid      = ?.
    
            FOR FIRST int-estrutura NO-LOCK
                WHERE int-estrutura.it-codigo = estrutura.it-codigo
                AND   int-estrutura.sequencia = estrutura.sequencia
                AND   int-estrutura.es-codigo = estrutura.es-codigo:
                   
                ASSIGN tt-astec-tela.garantia = int-estrutura.garantia
                       tt-astec-tela.venda    = int-estrutura.venda
                       tt-astec-tela.desc-alt = int-estrutura.desc-alt.
    
            END.
    
        END.

    END.

    {&open-query-br-astec}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-estrut wMaintenance 
PROCEDURE pi-atualiza-estrut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-it-codigo LIKE item.it-codigo NO-UNDO.
    DEF INPUT PARAMETER p-valor  AS CHAR NO-UNDO.
    DEF INPUT PARAMETER p-campo AS CHAR NO-UNDO.


    FOR each estrutura 
        WHERE estrutura.it-codigo = p-it-codigo AND
              estrutura.data-inicio <= TODAY AND
              estrutura.data-termino > today no-lock:

        FIND FIRST int-estrutura EXCLUSIVE-LOCK
            WHERE int-estrutura.it-codigo = estrutura.it-codigo
            AND   int-estrutura.sequencia = estrutura.sequencia
            AND   int-estrutura.es-codigo = estrutura.es-codigo NO-ERROR.

        IF NOT AVAIL int-estrutura THEN DO:
            CREATE int-estrutura.
            ASSIGN int-estrutura.it-codigo = estrutura.it-codigo
                   int-estrutura.es-codigo = estrutura.es-codigo
                   int-estrutura.sequencia = estrutura.sequencia.
        END.
        
        IF p-campo = "venda" THEN
            ASSIGN int-estrutura.venda = LOGICAL(p-valor).
        IF p-campo = "garantia" THEN
            ASSIGN int-estrutura.garantia = int(p-valor).

        FIND CURRENT int-estrutura NO-LOCK.
        
        RUN pi-atualiza-estrut (INPUT estrutura.es-codigo,
                                INPUT p-valor,
                                INPUT p-campo).

    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-estrut-astec wMaintenance 
PROCEDURE pi-atualiza-estrut-astec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-it-codigo LIKE item.it-codigo NO-UNDO.
    DEF INPUT PARAMETER p-valor  AS CHAR NO-UNDO.
    DEF INPUT PARAMETER p-campo  AS CHAR NO-UNDO.


    FOR each estrut-astec 
        WHERE estrut-astec.it-codigo = p-it-codigo no-lock:

        FIND FIRST int-estrutura EXCLUSIVE-LOCK
            WHERE int-estrutura.it-codigo = estrut-astec.it-codigo
            AND   int-estrutura.sequencia = estrut-astec.sequencia
            AND   int-estrutura.es-codigo = estrut-astec.es-codigo NO-ERROR.

        IF NOT AVAIL int-estrutura THEN DO:
            CREATE int-estrutura.
            ASSIGN int-estrutura.it-codigo = estrut-astec.it-codigo
                   int-estrutura.es-codigo = estrut-astec.es-codigo
                   int-estrutura.sequencia = estrut-astec.sequencia.
        END.

        IF p-campo = "venda" THEN
            ASSIGN int-estrutura.venda = LOGICAL(p-valor).
        IF p-campo = "garantia" THEN
            ASSIGN int-estrutura.garantia = int(p-valor).
        
        FIND CURRENT int-estrutura NO-LOCK.

        RUN pi-atualiza-estrut (INPUT estrut-astec.es-codigo,
                                INPUT p-valor,
                                INPUT p-campo).

    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-garantia wMaintenance 
PROCEDURE pi-atualiza-garantia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH tt-estrut:
    ASSIGN tt-estrut.garantia = iGarantia.
END.

{&OPEN-QUERY-britem}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-garantia-astec wMaintenance 
PROCEDURE pi-atualiza-garantia-astec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH tt-astec-tela:
    ASSIGN tt-astec-tela.garantia = iGarantia.
END.

{&OPEN-QUERY-br-astec}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-venda wMaintenance 
PROCEDURE pi-atualiza-venda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH tt-estrut:
    ASSIGN tt-estrut.venda = lVenda.
END.

{&OPEN-QUERY-britem}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-venda-astec wMaintenance 
PROCEDURE pi-atualiza-venda-astec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH tt-astec-tela:
    ASSIGN tt-astec-tela.venda = lVenda.
END.

{&OPEN-QUERY-br-astec}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carga-astec-tela-por-item wMaintenance 
PROCEDURE pi-carga-astec-tela-por-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-it-codigo AS CHAR NO-UNDO.


    EMPTY TEMP-TABLE tt-estrut-astec.
    
    RUN setConstraintItem IN h-boes727 (INPUT p-it-codigo).

    RUN openQueryStatic IN h-boes727 (INPUT "Item").
    
    RUN getBatchRecords IN h-boes727 (INPUT  ?,
                                      INPUT  ?,
                                      INPUT  ?,
                                      OUTPUT iRowsReturned,
                                      OUTPUT TABLE tt-estrut-astec).

    FOR EACH tt-estrut-astec:

        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = tt-estrut-astec.es-codigo:
        END.

        CREATE tt-astec-tela.             
        ASSIGN tt-astec-tela.it-codigo    = tt-estrut-astec.it-codigo
               tt-astec-tela.sequencia    = tt-estrut-astec.sequencia
               tt-astec-tela.es-codigo    = tt-estrut-astec.es-codigo
               tt-astec-tela.desc-item    = IF AVAIL ITEM THEN ITEM.desc-item ELSE ""
               tt-astec-tela.data-inicio  = ?
               tt-astec-tela.data-termino = ?
               tt-astec-tela.r-rowid      = tt-estrut-astec.r-rowid.

        FOR FIRST int-estrutura NO-LOCK
            WHERE int-estrutura.it-codigo = tt-estrut-astec.it-codigo
            AND   int-estrutura.sequencia = tt-estrut-astec.sequencia
            AND   int-estrutura.es-codigo = tt-estrut-astec.es-codigo:
               
            ASSIGN tt-astec-tela.garantia = int-estrutura.garantia
                   tt-astec-tela.venda    = int-estrutura.venda
                   tt-astec-tela.desc-alt = int-estrutura.desc-alt.

        END.

    END.

    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-astec wMaintenance 
PROCEDURE pi-elimina-astec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL tt-astec-tela THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 550,
                           INPUT "Estrutura Astec").

        IF RETURN-VALUE <> "NO" THEN DO:

            EMPTY TEMP-TABLE RowErrors.

            RUN emptyRowErrors IN h-boes727.
    
            RUN repositionRecord IN h-boes727 (INPUT tt-astec-tela.r-rowid).
    
            RUN validateRecord IN h-boes727 (INPUT "DELETE").
    
            IF RETURN-VALUE = "NOK" THEN DO:
                RUN pi-erros.
                RETURN "NOK":U.
            END.

            EMPTY TEMP-TABLE RowErrors.

            RUN emptyRowErrors IN h-boes727.
        
            RUN deleteRecord IN h-boes727.
        
            RUN pi-erros.
        
            RETURN RETURN-VALUE.

        END.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-erros wMaintenance 
PROCEDURE pi-erros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.


    RUN getRowErrors IN h-boes727 (OUTPUT TABLE RowErrors).

  
    EMPTY temp-table tt-erro.

    FOR EACH RowErrors
        WHERE RowErrors.errortype = "EMS"
        OR    RowErrors.errortype = "Error":

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT RowErrors.ErrorNumber,
                           INPUT RowErrors.ErrorParameters).

        ASSIGN c-mensagem = RETURN-VALUE.

        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = RowErrors.ErrorSequence
               tt-erro.cd-erro  = RowErrors.ErrorNumber
               tt-erro.mensagem = c-mensagem.

    END.

    IF CAN-FIND(FIRST tt-erro) THEN DO:

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        RETURN "NOK":U.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-est wMaintenance 
PROCEDURE pi-est :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-it-codigo like item.it-codigo NO-UNDO.
    def var a as log.

    for each estrutura no-lock 
       where estrutura.it-codigo = p-it-codigo AND
             estrutura.data-inicio <= TODAY AND
             estrutura.data-termino > today:

       find first item no-lock
             where item.it-codigo = estrutura.es-codigo no-error.

       assign i-nivel = i-nivel + 1.
       
       FIND FIRST b-e NO-LOCK
           WHERE b-e.it-codigo = estrutura.es-codigo NO-ERROR.
       ASSIGN c-tipo = IF AVAIL b-e THEN "F" ELSE "N".

       chChTreeview:TreeView4GL:addnodes(string(i-nivel,"99") + "~t" + string(estrutura.es-codigo,"9999999") + "-" + 
                                            REPLACE(ITEM.desc-item, CHR(9), " ") + "~t0,1~t1~t~t" + 
                                            string(estrutura.es-codigo)  + "," + STRING(RECID(estrutura)) + "," + c-tipo).

       run pi-est(input estrutura.es-codigo).

       assign i-nivel = i-nivel - 1.
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ler wMaintenance 
PROCEDURE pi-ler :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-it-codigo like item.it-codigo NO-UNDO.
    
    chChTreeview:TreeView4GL:clear().
    chChTreeview:TreeView4GL:TreeRefresh = false.
  
    for each estrutura no-lock 
        where estrutura.it-codigo = p-it-codigo AND
              estrutura.data-inicio <= TODAY AND
              estrutura.data-termino > today,
        first item no-lock
              where item.it-codigo = estrutura.it-codigo
        break by estrutura.it-codigo:
        
        run pi-acompanhar in h-prog.

        if first-of(estrutura.it-codigo) then do:
            chChTreeview:TreeView4GL:addnodes( "0~t" + string(estrutura.it-codigo,"9999999") + "-" + 
                                               REPLACE(ITEM.desc-item, CHR(9), " ") + "~t0,1~t1~t~t" + 
                                               string(estrutura.it-codigo)  + "," + STRING(RECID(estrutura)) + ",P").
        end.

        find b-item where b-item.it-codigo = estrutura.es-codigo no-lock.

        chChTreeview:TreeView4GL:addnodes( "1~t" + string(estrutura.es-codigo,"9999999") + "-" + 
                                           REPLACE(b-item.desc-item, CHR(9), " ") + "~t0,1~t1~t~t" + 
                                           string(estrutura.es-codigo) + "," + STRING(RECID(estrutura)) + ",F").

        assign i-nivel = 1.

        run pi-est(input estrutura.es-codigo).
    end.
    chChTreeview:TreeView4GL:TreeRefresh = true.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta wMaintenance 
PROCEDURE pi-monta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER c-dados AS CHAR.
DEF VAR c-item LIKE ITEM.it-codigo.

EMPTY TEMP-TABLE tt-Estrut.

CASE ENTRY(3,c-dados,","):
    WHEN "P" THEN DO:
        FIND estrutura NO-LOCK
          WHERE RECID(estrutura) = INT(ENTRY(2,c-dados,",")).
        ASSIGN c-item = IF AVAIL estrutura THEN estrutura.it-codigo ELSE "".
    END.
    WHEN "F" THEN DO:
        FIND estrutura NO-LOCK
            WHERE RECID(estrutura) = INT(ENTRY(2,c-dados,",")) NO-ERROR.
        FIND FIRST b-e NO-LOCK
            WHERE b-e.it-codigo = estrutura.es-codigo NO-ERROR.
        ASSIGN c-item = IF AVAIL b-e THEN b-e.it-codigo ELSE "".
    END.
    WHEN "N" THEN
        ASSIGN c-item = "".
END CASE.

FOR EACH b-e 
 WHERE b-e.it-codigo = c-item AND
       b-e.data-inicio <= TODAY AND
       b-e.data-termino > today,
   FIRST ITEM NO-LOCK
   WHERE ITEM.it-codigo = b-e.es-codigo:

    CREATE tt-estrut.
    ASSIGN tt-estrut.it-codigo     = b-e.it-codigo
           tt-estrut.es-codigo     = b-e.es-codigo
           tt-estrut.sequencia     = b-e.sequencia
           tt-estrut.desc-item     = ITEM.desc-item
           tt-estrut.data-inicio   = b-e.data-inicio
           tt-estrut.data-termino  = b-e.data-termino.

    FIND FIRST int-estrutura NO-LOCK
        WHERE int-estrutura.it-codigo = b-e.it-codigo
        AND   int-estrutura.sequencia = b-e.sequencia
        AND   int-estrutura.es-codigo = b-e.es-codigo NO-ERROR.
    IF AVAIL int-estrutura THEN
        ASSIGN tt-estrut.garantia       = int-estrutura.garantia
               tt-estrut.venda          = int-estrutura.venda
               tt-estrut.desc-alt       = int-estrutura.desc-alt.
    ELSE DO:
        /** SOS 33852 - Adriana Honorato **/
        /** Se a int-estrutura nÆo existe, j  cria com ela sendo vis¡vel **/
        CREATE int-estrutura.
        ASSIGN int-estrutura.it-codigo = b-e.it-codigo
               int-estrutura.es-codigo = b-e.es-codigo
               int-estrutura.sequencia = b-e.sequencia
               int-estrutura.visivel = YES.
    END.
END.

{&OPEN-QUERY-britem}

IF num-results('britem') > 0 THEN
  ASSIGN btGarantia:SENSITIVE IN FRAME fPage1       = YES
         btVenda:SENSITIVE IN FRAME fPage1          = YES
         btSave2:SENSITIVE IN FRAME fPage1          = YES
         btVendaEstrut:SENSITIVE IN FRAME fPage1    = YES
         btGarantiaEstr:SENSITIVE IN FRAME fPage1 = YES.
ELSE
  ASSIGN btGarantia:SENSITIVE IN FRAME fPage1       = NO
         btVenda:SENSITIVE IN FRAME fPage1          = NO
         btSave2:SENSITIVE IN FRAME fPage1          = NO
         btVendaEstrut:SENSITIVE IN FRAME fPage1    = NO
         btGarantiaEstr:SENSITIVE IN FRAME fPage1 = NO.


  RUN esp\es0018p.p (INPUT "esenp014", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.


  IF NOT CAN-FIND(FIRST tt-prog-ponto
                    WHERE tt-prog-ponto.conteudo = c-seg-usuario) THEN DO:

      DISABLE btGarantiaEstr
                    btVendaEstrut
                    btGarantia
                    btVenda 
                    btSave2
                WITH FRAME fPage1.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra wMaintenance 
PROCEDURE pi-mostra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-it-codigo like item.it-codigo.

    run utp\ut-perc.p persistent set h-prog.

    assign i-tot = 0.

    for each estrutura no-lock 
       where estrutura.it-codigo = p-it-codigo AND
             estrutura.data-inicio <= TODAY AND
             estrutura.data-termino > today:
       assign i-tot = i-tot + 1.
    end.
    run pi-inicializar in h-prog(input "Criando estrutura", i-tot).

    run pi-ler (input p-it-codigo).
    run pi-finalizar in h-prog.    
    RUN pi-monta (INPUT ?).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva wMaintenance 
PROCEDURE pi-salva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH tt-estrut NO-LOCK:

    FOR FIRST int-estrutura EXCLUSIVE-LOCK
        WHERE int-estrutura.it-codigo = tt-estrut.it-codigo
          AND int-estrutura.sequencia = tt-estrut.sequencia
          AND int-estrutura.es-codigo = tt-estrut.es-codigo:
        
        IF AVAIL int-estrutura THEN DO:
            ASSIGN int-estrutura.garantia       = tt-estrut.garantia  
                   int-estrutura.venda          = tt-estrut.venda     
                   int-estrutura.desc-alt       = tt-estrut.desc-alt.
        END.
    END.
END.

{&OPEN-QUERY-britem}

EMPTY TEMP-TABLE tt-estrutura-integra.
CREATE tt-estrutura-integra.
ASSIGN tt-estrutura-integra.CodigoProduto = INPUT FRAME fPage0 ttitem.it-codigo.

RAW-TRANSFER tt-estrutura-integra TO raw-param.

RUN esp/trgw/wes727a.p (INPUT raw-param,
                        INPUT 'msg0301').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-astec wMaintenance 
PROCEDURE pi-salva-astec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH tt-astec-tela NO-LOCK:

    IF NOT CAN-FIND (FIRST int-estrutura
                     WHERE int-estrutura.it-codigo = tt-astec-tela.it-codigo
                       AND int-estrutura.sequencia = tt-astec-tela.sequencia
                       AND int-estrutura.es-codigo = tt-astec-tela.es-codigo) THEN DO:
        CREATE int-estrutura.
        ASSIGN int-estrutura.it-codigo = tt-astec-tela.it-codigo
               int-estrutura.sequencia = tt-astec-tela.sequencia
               int-estrutura.es-codigo = tt-astec-tela.es-codigo.
    END.

    FOR FIRST int-estrutura EXCLUSIVE-LOCK
        WHERE int-estrutura.it-codigo = tt-astec-tela.it-codigo
          AND int-estrutura.sequencia = tt-astec-tela.sequencia
          AND int-estrutura.es-codigo = tt-astec-tela.es-codigo:
        
        IF AVAIL int-estrutura THEN DO:
            ASSIGN int-estrutura.garantia       = tt-astec-tela.garantia  
                   int-estrutura.venda          = tt-astec-tela.venda     
                   int-estrutura.desc-alt       = tt-astec-tela.desc-alt.
        END.
    END.
END.

{&OPEN-QUERY-br-astec}

EMPTY TEMP-TABLE tt-estrutura-integra.
CREATE tt-estrutura-integra.
ASSIGN tt-estrutura-integra.CodigoProduto = INPUT FRAME fPage0 ttitem.it-codigo.

RAW-TRANSFER tt-estrutura-integra TO raw-param.

RUN esp/trgw/wes727a.p (INPUT raw-param,
                        INPUT 'msg0301').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida wMaintenance 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-it-codigo      AS CHAR     NO-UNDO.
    DEFINE INPUT PARAMETER p-sequencia      AS INT      NO-UNDO.
    DEFINE INPUT PARAMETER p-es-codigo      AS CHAR     NO-UNDO.
    DEFINE INPUT PARAMETER p-desce-estrut   AS LOGICAL  NO-UNDO.


    FOR FIRST int-estrutura NO-LOCK
        WHERE int-estrutura.it-codigo = p-it-codigo
        AND   int-estrutura.sequencia = p-sequencia
        AND   int-estrutura.es-codigo = p-es-codigo:

        IF int-estrutura.garantia > 0 OR
           int-estrutura.venda = TRUE THEN DO:

            FOR FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = p-es-codigo:

                CREATE tt-excel.
                ASSIGN tt-excel.it-codigo       = p-it-codigo
                       tt-excel.sequencia       = p-sequencia
                       tt-excel.es-codigo       = p-es-codigo
                       tt-excel.descricao       = ITEM.desc-item
                       tt-excel.garantia        = int-estrutura.garantia
                       tt-excel.venda           = int-estrutura.venda
                       tt-excel.val-lai02       = 0
                       tt-excel.val-astec       = 0
                       tt-excel.status-garantia = ""
                       tt-excel.status-venda    = "".

                ASSIGN l-fat-estabs = TRUE.

                DO i-aux = 1 TO NUM-ENTRIES(c-estabelecimentos):
    
                    IF NOT CAN-FIND (FIRST tt-est-excel
                                     WHERE tt-est-excel.cod-estabel = ENTRY(i-aux, c-estabelecimentos)
                                     AND   tt-est-excel.it-codigo   = p-es-codigo) THEN DO:
    
                        CREATE tt-est-excel.
                        ASSIGN tt-est-excel.cod-estabel = ENTRY(i-aux, c-estabelecimentos)
                               tt-est-excel.it-codigo   = p-es-codigo
                               tt-est-excel.fatura      = FALSE.
        
                        FIND FIRST item-uni-estab
                            WHERE item-uni-estab.cod-estabel = ENTRY(i-aux, c-estabelecimentos)
                            AND   item-uni-estab.it-codigo   = p-es-codigo NO-LOCK NO-ERROR.

                        IF AVAIL item-uni-estab THEN DO:
        
                            IF item-uni-estab.ind-item-fat = YES THEN
                                ASSIGN tt-est-excel.fatura = TRUE.
                            ELSE
                                ASSIGN tt-est-excel.fatura = FALSE
                                       l-fat-estabs        = FALSE.
        
                        END.
                        ELSE 
                            ASSIGN l-fat-estabs = FALSE.
    
                    END.
    
                END.

                IF int-estrutura.garantia > 0 THEN DO:
    
                    FIND LAST preco-item NO-LOCK
                        WHERE preco-item.nr-tabpre      = "LAI02"
                        AND   preco-item.it-codigo      = p-es-codigo
                        AND   preco-item.cod-refer      = ""
                        AND   preco-item.cod-unid-med   = ITEM.un
                        AND   preco-item.dt-inival      <= TODAY
                        AND   preco-item.situacao       = 1 NO-ERROR.
    
                    IF AVAIL preco-item THEN
                        ASSIGN tt-excel.val-lai02 = preco-item.preco-venda
                               l-lai02 = TRUE.
                    ELSE 
                        ASSIGN l-lai02 = FALSE.

                END.

                IF int-estrutura.venda = TRUE THEN DO:

                    FIND LAST preco-item NO-LOCK
                        WHERE preco-item.nr-tabpre      = "ASTEC 02"
                        AND   preco-item.it-codigo      = p-es-codigo
                        AND   preco-item.cod-refer      = ""
                        AND   preco-item.cod-unid-med   = ITEM.un
                        AND   preco-item.dt-inival      <= TODAY
                        AND   preco-item.situacao       = 1 NO-ERROR.
    
                    IF AVAIL preco-item THEN
                        ASSIGN tt-excel.val-astec = preco-item.preco-venda
                               l-astec02 = TRUE.
                    ELSE
                        ASSIGN l-astec02 = FALSE.

                END.

                /* Status Garantia */
                IF int-estrutura.garantia > 0 THEN DO:
                    
                    IF l-fat-estabs AND
                       l-lai02 THEN
                        ASSIGN tt-excel.status-garantia = "OK".
                    ELSE
                        ASSIGN tt-excel.status-garantia = "NOK".

                END.

                /* Status Venda */
                IF int-estrutura.venda = TRUE THEN DO:
                    
                    IF l-fat-estabs AND
                       l-astec02 THEN
                        ASSIGN tt-excel.status-venda = "OK".
                    ELSE
                        ASSIGN tt-excel.status-venda = "NOK".

                END.

            END.

        END.

    END.

    IF p-desce-estrut THEN
        RUN pi-valida-estrut (INPUT p-es-codigo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-astec wMaintenance 
PROCEDURE pi-valida-astec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-it-codigo AS CHAR NO-UNDO.


    /* Valida‡äes */


    FOR each estrut-astec 
        WHERE estrut-astec.it-codigo = p-it-codigo no-lock:

        RUN pi-valida (INPUT estrut-astec.it-codigo,
                       INPUT estrut-astec.sequencia,
                       INPUT estrut-astec.es-codigo,
                       INPUT TRUE).

    END.

    FOR EACH altern-astec NO-LOCK
        WHERE altern-astec.it-codigo = p-it-codigo:

        FOR EACH estrutura NO-LOCK
            WHERE estrutura.it-codigo    =  altern-astec.it-altern
            AND   estrutura.data-inicio  <= TODAY 
            AND   estrutura.data-termino >  today:

            RUN pi-valida (INPUT estrutura.it-codigo,
                           INPUT estrutura.sequencia,
                           INPUT estrutura.es-codigo,
                           INPUT FALSE).
    
        END.

    END.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-estrut wMaintenance 
PROCEDURE pi-valida-estrut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-it-codigo AS CHAR NO-UNDO.


    /* Valida‡äes */

    for each estrutura no-lock 
        where estrutura.it-codigo    =  p-it-codigo
        AND   estrutura.data-inicio  <= TODAY 
        AND   estrutura.data-termino >  today:

        RUN pi-valida (INPUT estrutura.it-codigo,
                       INPUT estrutura.sequencia,
                       INPUT estrutura.es-codigo,
                       INPUT TRUE).
        

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

