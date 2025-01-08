&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESEN0109 1.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESEN0109 ENP}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
def new global shared var c-en0109-upc as char no-undo.
/*:T Preprocessadores do Template de Relat¢rio                            */
/*:T Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA f-pg-cla
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG f-pg-dig
&GLOBAL-DEFINE PGIMP f-pg-imp

/* &GLOBAL-DEFINE RTF   YES */
  
/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

define temp-table tt-param no-undo
    field destino         as integer
    field arquivo         as char format "x(35)"
    field usuario         as char format "x(12)"
    field data-exec       as date
    field hora-exec       as integer
    field classifica      as integer
    field desc-classifica as char format "x(40)"
    field modelo-rtf      as char format "x(35)"
    field l-habilitaRtf   as logi
    field execucao        as inte
    field es-codigo       as char
    field es-codigo-alt   as char.

define temp-table tt-digita no-undo
    field it-codigo   as char
    field desc-item   as char
    field sequencia   as inte
    field quantidade  as deci
    field dt-inicio   as char
    field dt-termino  as char
    field ativo       as logi
    field r-estrutura as rowid
    index id is primary it-codigo
                        sequencia
    index id2 ativo.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.
                    
/* Local Variable Definitions ---                                       */
def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-modelo-default   as char    no-undo.

def var h-acomp    as handle no-undo.
def var h-digita   as handle no-undo.
def var c-mensagem as char   no-undo.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-cla
&Scoped-define BROWSE-NAME br-digita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE br-digita                                     */
&Scoped-define FIELDS-IN-QUERY-br-digita tt-digita.it-codigo tt-digita.desc-item tt-digita.sequencia tt-digita.quantidade tt-digita.dt-inicio   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-digita   
&Scoped-define SELF-NAME br-digita
&Scoped-define QUERY-STRING-br-digita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-br-digita OPEN QUERY br-digita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-br-digita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-br-digita tt-digita


/* Definitions for FRAME f-pg-dig                                       */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-pg-dig ~
    ~{&OPEN-QUERY-br-digita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rs-classif 
&Scoped-Define DISPLAYED-OBJECTS rs-classif 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE rs-classif AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Por Classificaá∆o 1", 1,
"Por Classificaá∆o 2", 2,
"Por Classificaá∆o 3", 3,
"Por Classificaá∆o 4", 4
     SIZE 49.14 BY 5.08 NO-UNDO.

DEFINE BUTTON bt-retirar 
     LABEL "Retirar" 
     SIZE 15 BY 1.

DEFINE VARIABLE fi-color AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88
     BGCOLOR 12  NO-UNDO.

DEFINE VARIABLE fi-inativos AS CHARACTER FORMAT "X(10)":U INITIAL "Inativos -" 
      VIEW-AS TEXT 
     SIZE 7 BY .88 NO-UNDO.

DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-modelo-rtf 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-modelo-rtf AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63 NO-UNDO.

DEFINE VARIABLE text-modelo-rtf AS CHARACTER FORMAT "X(256)":U INITIAL "Modelo:" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE text-rtf AS CHARACTER FORMAT "X(256)":U INITIAL "Rich Text Format(RTF)" 
      VIEW-AS TEXT 
     SIZE 20.86 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.79.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE RECTANGLE rect-rtf
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 3.54.

DEFINE VARIABLE l-habilitaRtf AS LOGICAL INITIAL no 
     LABEL "RTF" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE BUTTON bt-go 
     IMAGE-UP FILE "image/im-enter.bmp":U
     IMAGE-DOWN FILE "image/ii-enter.bmp":U
     LABEL "Go" 
     SIZE 3 BY 1.

DEFINE VARIABLE cb-obsoleto-fim AS INTEGER FORMAT "9":U INITIAL 1 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "1-Ativo",1,
                     "2-Obsoleto Ordens Autom†ticas",2,
                     "3-Obsoleto Todas as Ordens",3,
                     "4-Totalmente Obsoleto",4
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE cb-obsoleto-ini AS INTEGER FORMAT "9":U INITIAL 1 
     LABEL "Situaá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "1-Ativo",1,
                     "2-Obsoleto Ordens Autom†ticas",2,
                     "3-Obsoleto Todas as Ordens",3,
                     "4-Totalmente Obsoleto",4
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item-alt AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE fi-es-codigo AS CHARACTER FORMAT "X(16)":U 
     LABEL "Componente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 TOOLTIP "Informe o Componente" NO-UNDO.

DEFINE VARIABLE fi-es-codigo-alt AS CHARACTER FORMAT "X(16)":U 
     LABEL "Compon. Alt." 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 TOOLTIP "Informe o Componente Alternativo" NO-UNDO.

DEFINE VARIABLE fi-fm-cod-com-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fm-cod-com-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Fam°lia Comercial" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fm-codigo-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fm-codigo-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Fam°lia" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ge-codigo-fim AS INTEGER FORMAT ">9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ge-codigo-ini AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Grupo Estoque" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 6.25.

DEFINE VARIABLE c-fim-campo AS CHARACTER FORMAT "X(15)":U INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-ini-campo AS CHARACTER FORMAT "X(15)":U 
     LABEL "Campo" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-cla
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-dig
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-imp
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-par
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 11.38
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 11.21
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 11.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-digita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-digita w-relat _FREEFORM
  QUERY br-digita DISPLAY
      tt-digita.it-codigo  format "x(16)" column-label "Item"      width 13
tt-digita.desc-item  format "x(60)" column-label "Descriá∆o" width 40
tt-digita.sequencia  format ">>>>9" column-label "Seq"       width 2.5
tt-digita.quantidade format "->>,>>9.9999999999" column-label "Qtd" width 15
tt-digita.dt-inicio  format "x(8)"  column-label "In°cio"    width 7.5
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 76.57 BY 9
         BGCOLOR 15 FONT 1
         TITLE BGCOLOR 15 "Onde-se-usa".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-cla
     rs-classif AT ROW 1.29 COL 2.14 HELP
          "Classificaá∆o para emiss∆o do relat¢rio" NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.86 BY 10.31
         FONT 1 WIDGET-ID 100.

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     RECT-1 AT ROW 14.29 COL 2
     RECT-6 AT ROW 13.75 COL 2.14
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder AT ROW 2.5 COL 2
     im-pg-cla AT ROW 1.5 COL 65
     im-pg-dig AT ROW 1.5 COL 17.86
     im-pg-imp AT ROW 1.5 COL 33.57
     im-pg-par AT ROW 1.5 COL 2.14
     im-pg-sel AT ROW 1.5 COL 49.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         FONT 1
         DEFAULT-BUTTON bt-executar WIDGET-ID 100.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 1.63 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     bt-arquivo AT ROW 2.71 COL 43.29 HELP
          "Escolha do nome do arquivo"
     bt-config-impr AT ROW 2.71 COL 43.29 HELP
          "Configuraá∆o da impressora"
     c-arquivo AT ROW 2.75 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     l-habilitaRtf AT ROW 4.83 COL 3.29
     c-modelo-rtf AT ROW 6.63 COL 3 HELP
          "Nome do arquivo de modelo do relat¢rio" NO-LABEL
     bt-modelo-rtf AT ROW 6.63 COL 43 HELP
          "Escolha do nome do arquivo"
     rs-execucao AT ROW 8.88 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.04 COL 3.86 NO-LABEL
     text-rtf AT ROW 4.17 COL 1.14 COLON-ALIGNED NO-LABEL
     text-modelo-rtf AT ROW 5.96 COL 1.14 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 8.13 COL 1.14 COLON-ALIGNED NO-LABEL
     rect-rtf AT ROW 4.46 COL 2
     RECT-7 AT ROW 1.33 COL 2.14
     RECT-9 AT ROW 8.33 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10.5
         FONT 1 WIDGET-ID 100.

DEFINE FRAME f-pg-sel
     c-ini-campo AT ROW 1.25 COL 15 COLON-ALIGNED
     c-fim-campo AT ROW 1.25 COL 48.14 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 1.25 COL 31.86
     IMAGE-2 AT ROW 1.25 COL 47.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.62
         FONT 1 WIDGET-ID 100.

DEFINE FRAME f-pg-par
     fi-es-codigo AT ROW 1.5 COL 10.72 COLON-ALIGNED HELP
          "Componente" WIDGET-ID 2
     fi-desc-item AT ROW 1.5 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     fi-es-codigo-alt AT ROW 2.5 COL 10.72 COLON-ALIGNED HELP
          "Componente Alternativo" WIDGET-ID 6
     fi-desc-item-alt AT ROW 2.5 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     bt-go AT ROW 2.5 COL 72 WIDGET-ID 10
     fi-it-codigo-ini AT ROW 5.25 COL 13 COLON-ALIGNED HELP
          "Item inicial" WIDGET-ID 18
     fi-it-codigo-fim AT ROW 5.25 COL 47.86 COLON-ALIGNED HELP
          "Item final" NO-LABEL WIDGET-ID 16
     fi-fm-codigo-ini AT ROW 6.25 COL 13 COLON-ALIGNED HELP
          "Fam°lia inicial" WIDGET-ID 28
     fi-fm-codigo-fim AT ROW 6.25 COL 47.86 COLON-ALIGNED HELP
          "Familia final" NO-LABEL WIDGET-ID 34
     fi-fm-cod-com-ini AT ROW 7.25 COL 13 COLON-ALIGNED HELP
          "Fam°lia Comercial inicial" WIDGET-ID 38
     fi-fm-cod-com-fim AT ROW 7.25 COL 47.86 COLON-ALIGNED HELP
          "Familia Comercial final" NO-LABEL WIDGET-ID 36
     fi-ge-codigo-ini AT ROW 8.25 COL 13 COLON-ALIGNED HELP
          "Grupo Estoque inicial" WIDGET-ID 46
     fi-ge-codigo-fim AT ROW 8.25 COL 47.86 COLON-ALIGNED HELP
          "Grupo Estoque final" NO-LABEL WIDGET-ID 44
     cb-obsoleto-ini AT ROW 9.25 COL 13 COLON-ALIGNED WIDGET-ID 64
     cb-obsoleto-fim AT ROW 9.25 COL 47.86 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     "Seleá∆o Onde-se-usa" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 4.25 COL 4.72 WIDGET-ID 60
     IMAGE-3 AT ROW 5.25 COL 39 WIDGET-ID 20
     IMAGE-4 AT ROW 5.25 COL 47 WIDGET-ID 22
     RECT-10 AT ROW 4.5 COL 2 WIDGET-ID 24
     IMAGE-5 AT ROW 6.25 COL 39 WIDGET-ID 30
     IMAGE-6 AT ROW 6.25 COL 47 WIDGET-ID 32
     IMAGE-7 AT ROW 7.25 COL 39 WIDGET-ID 40
     IMAGE-8 AT ROW 7.25 COL 47 WIDGET-ID 42
     IMAGE-9 AT ROW 8.25 COL 39 WIDGET-ID 48
     IMAGE-10 AT ROW 8.25 COL 47 WIDGET-ID 50
     IMAGE-13 AT ROW 9.25 COL 39.14 WIDGET-ID 66
     IMAGE-14 AT ROW 9.25 COL 47 WIDGET-ID 68
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 75 BY 10
         FONT 1 WIDGET-ID 100.

DEFINE FRAME f-pg-dig
     br-digita AT ROW 1 COL 1
     bt-retirar AT ROW 10 COL 1
     fi-color AT ROW 10.04 COL 72.29 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     fi-inativos AT ROW 10.04 COL 65 COLON-ALIGNED NO-LABEL WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3.31
         SIZE 76.86 BY 10.15
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = "Inclus∆o Componentes Alternativos"
         HEIGHT             = 15
         WIDTH              = 81.14
         MAX-HEIGHT         = 41.33
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 41.33
         VIRTUAL-WIDTH      = 274.29
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-relat 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-relat
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-cla
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME f-pg-dig
                                                                        */
/* BROWSE-TAB br-digita 1 f-pg-dig */
ASSIGN 
       br-digita:COLUMN-RESIZABLE IN FRAME f-pg-dig       = TRUE.

/* SETTINGS FOR BUTTON bt-retirar IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-color IN FRAME f-pg-dig
   NO-ENABLE                                                            */
ASSIGN 
       fi-color:HIDDEN IN FRAME f-pg-dig           = TRUE.

/* SETTINGS FOR FILL-IN fi-inativos IN FRAME f-pg-dig
   NO-ENABLE                                                            */
ASSIGN 
       fi-inativos:HIDDEN IN FRAME f-pg-dig           = TRUE.

/* SETTINGS FOR FRAME f-pg-imp
                                                                        */
/* SETTINGS FOR BUTTON bt-modelo-rtf IN FRAME f-pg-imp
   NO-ENABLE                                                            */
ASSIGN 
       bt-modelo-rtf:HIDDEN IN FRAME f-pg-imp           = TRUE.

/* SETTINGS FOR EDITOR c-modelo-rtf IN FRAME f-pg-imp
   NO-ENABLE                                                            */
ASSIGN 
       c-modelo-rtf:HIDDEN IN FRAME f-pg-imp           = TRUE.

/* SETTINGS FOR TOGGLE-BOX l-habilitaRtf IN FRAME f-pg-imp
   NO-ENABLE                                                            */
ASSIGN 
       l-habilitaRtf:HIDDEN IN FRAME f-pg-imp           = TRUE.

/* SETTINGS FOR RADIO-SET rs-execucao IN FRAME f-pg-imp
   NO-ENABLE                                                            */
ASSIGN 
       rs-execucao:HIDDEN IN FRAME f-pg-imp           = TRUE.

/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modelo-rtf IN FRAME f-pg-imp
   NO-ENABLE                                                            */
ASSIGN 
       text-modelo-rtf:HIDDEN IN FRAME f-pg-imp           = TRUE
       text-modelo-rtf:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Modelo:".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execuá∆o".

/* SETTINGS FOR FILL-IN text-rtf IN FRAME f-pg-imp
   NO-ENABLE                                                            */
ASSIGN 
       text-rtf:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Rich Text Format(RTF)".

/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-item-alt IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR IMAGE im-pg-cla IN FRAME f-relat
   NO-ENABLE                                                            */
ASSIGN 
       im-pg-cla:HIDDEN IN FRAME f-relat           = TRUE.

/* SETTINGS FOR IMAGE im-pg-sel IN FRAME f-relat
   NO-ENABLE                                                            */
ASSIGN 
       im-pg-sel:HIDDEN IN FRAME f-relat           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
THEN w-relat:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-digita
/* Query rebuild information for BROWSE br-digita
     _START_FREEFORM
OPEN QUERY br-digita FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-digita */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-imp
/* Query rebuild information for FRAME f-pg-imp
     _Query            is NOT OPENED
*/  /* FRAME f-pg-imp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON END-ERROR OF w-relat /* Inclus∆o Componentes Alternativos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat /* Inclus∆o Componentes Alternativos */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-digita
&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON DEL OF br-digita IN FRAME f-pg-dig /* Onde-se-usa */
DO:
   apply 'choose':U to bt-retirar in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON END-ERROR OF br-digita IN FRAME f-pg-dig /* Onde-se-usa */
ANYWHERE 
DO:
    if  br-digita:new-row in frame f-pg-dig then do:
        if  avail tt-digita then
            delete tt-digita.
        if  br-digita:delete-current-row() in frame f-pg-dig then. 
    end.                                                               
    else do:
        get current br-digita.
        display tt-digita.it-codigo
                tt-digita.desc-item
                tt-digita.sequencia
                tt-digita.quantidade with browse br-digita. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON ENTER OF br-digita IN FRAME f-pg-dig /* Onde-se-usa */
ANYWHERE
DO:
  apply 'tab':U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON ROW-DISPLAY OF br-digita IN FRAME f-pg-dig /* Onde-se-usa */
DO:
    if tt-digita.ativo
    then assign tt-digita.it-codigo:fgcolor  in browse br-digita = ?
                tt-digita.desc-item:fgcolor  in browse br-digita = ?
                tt-digita.sequencia:fgcolor  in browse br-digita = ?
                tt-digita.quantidade:fgcolor in browse br-digita = ?
                tt-digita.dt-inicio:fgcolor  in browse br-digita = ?. 
    else assign tt-digita.it-codigo:fgcolor  in browse br-digita = 12
                tt-digita.desc-item:fgcolor  in browse br-digita = 12
                tt-digita.sequencia:fgcolor  in browse br-digita = 12
                tt-digita.quantidade:fgcolor in browse br-digita = 12
                tt-digita.dt-inicio:fgcolor  in browse br-digita = 12.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON ROW-ENTRY OF br-digita IN FRAME f-pg-dig /* Onde-se-usa */
DO:
   /*:T trigger para inicializar campos da temp table de digitaá∆o */
   if  br-digita:new-row in frame f-pg-dig then do:
/*        assign tt-digita.exemplo:screen-value in browse br-digita = string(today, "99/99/9999"). */
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON ROW-LEAVE OF br-digita IN FRAME f-pg-dig /* Onde-se-usa */
DO:
    /*:T ê aqui que a gravaá∆o da linha da temp-table Ç efetivada.
       PorÇm as validaá‰es dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment†rio */
    
    if br-digita:NEW-ROW in frame f-pg-dig then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse br-digita tt-digita.it-codigo
               input browse br-digita tt-digita.desc-item
               input browse br-digita tt-digita.sequencia
               input browse br-digita tt-digita.quantidade.
    
        br-digita:CREATE-RESULT-LIST-ENTRY() in frame f-pg-dig.
    end.
    else do transaction on error undo, return no-apply:
        assign input browse br-digita tt-digita.it-codigo
               input browse br-digita tt-digita.desc-item
               input browse br-digita tt-digita.sequencia
               input browse br-digita tt-digita.quantidade.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-relat
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo w-relat
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-relat
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
   apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr w-relat
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME bt-go
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-go w-relat
ON CHOOSE OF bt-go IN FRAME f-pg-par /* Go */
DO:
  def var h-br-digita as handle no-undo.

  apply 'leave' to fi-es-codigo in frame f-pg-par.
  
  h-digita:label = "Qtd".
  
  assign bt-retirar:sensitive in frame f-pg-dig = no
         fi-color:hidden      in frame f-pg-dig = yes
         fi-inativos:hidden   in frame f-pg-dig = yes.
  
  assign input frame f-pg-par fi-es-codigo.

  empty temp-table tt-digita.
  br-digita:refresh() no-error. 

  run pi-carrega.
  
  {&open-query-br-digita}

  if not temp-table tt-digita:has-records
  then do:
       if input frame f-pg-par fi-it-codigo-ini > input frame f-pg-par fi-it-codigo-fim
       then do:
            run utp/ut-msgs.p (input "show", input 17567, input "Item inicial maior que final!").
            apply 'entry' to fi-it-codigo-ini in frame f-pg-par.
            return no-apply.
       end.

       if input frame f-pg-par fi-fm-codigo-ini > input frame f-pg-par fi-fm-codigo-fim
       then do:
            run utp/ut-msgs.p (input "show", input 17567, input "Fam°lia inicial maior que final!").
            apply 'entry' to fi-fm-codigo-ini in frame f-pg-par.
            return no-apply.
       end.

       if input frame f-pg-par fi-fm-cod-com-ini > input frame f-pg-par fi-fm-cod-com-fim
       then do:
            run utp/ut-msgs.p (input "show", input 17567, input "Fam°lia Comercial inicial maior que final!").
            apply 'entry' to fi-fm-cod-com-ini in frame f-pg-par.
            return no-apply.
       end.

       if input frame f-pg-par fi-ge-codigo-ini > input frame f-pg-par fi-ge-codigo-fim
       then do:
            run utp/ut-msgs.p (input "show", input 17567, input "Grupo Estoque inicial maior que final!").
            apply 'entry' to fi-ge-codigo-ini in frame f-pg-par.
            return no-apply.
       end.

       if input frame f-pg-par cb-obsoleto-ini > input frame f-pg-par cb-obsoleto-fim
       then do:
            run utp/ut-msgs.p (input "show", input 17567, input "Situaá∆o inicial maior que final!").
            apply 'entry' to cb-obsoleto-ini in frame f-pg-par.
            return no-apply.
       end.

       run utp/ut-msgs.p (input "show", input 19085, input "Nenhum Onde-se-usa carregado! Revise os dados de input").
       return no-apply.
  end.
  else assign fi-color:hidden    in frame f-pg-dig = not can-find(first tt-digita use-index id2 where
                                                                        tt-digita.ativo = no)
              fi-inativos:hidden in frame f-pg-dig = fi-color:hidden in frame f-pg-dig.
  
  assign bt-retirar:sensitive in frame f-pg-dig = yes.
  apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-modelo-rtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modelo-rtf w-relat
ON CHOOSE OF bt-modelo-rtf IN FRAME f-pg-imp
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok as logical no-undo.

    assign c-modelo-rtf = replace(input frame {&frame-name} c-modelo-rtf, "/", "~\").
    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.rtf" "*.rtf",
               "*.*" "*.*"
       DEFAULT-EXTENSION "rtf"
       INITIAL-DIR "modelos" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign c-modelo-rtf:screen-value in frame {&frame-name}  = replace(c-arq-conv, "~\", "/"). 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME bt-retirar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-retirar w-relat
ON CHOOSE OF bt-retirar IN FRAME f-pg-dig /* Retirar */
DO:
/*     if  br-digita:num-selected-rows > 0 then do on error undo, return no-apply: */
/*         get current br-digita.                                                  */
/*         delete tt-digita.                                                       */
/*         if  br-digita:delete-current-row() in frame f-pg-dig then.              */
/*     end.                                                                        */

    run pi-retira.

    if num-results("br-digita":U) > 0 
    then do:
         assign fi-color:hidden    in frame f-pg-dig = not can-find(first tt-digita use-index id2 where
                                                                          tt-digita.ativo = no)
                fi-inativos:hidden in frame f-pg-dig = fi-color:hidden in frame f-pg-dig.

         get current br-digita.
    end. /* if num-results("br-digita":U) > 0 */
    else self:sensitive = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME fi-es-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-es-codigo w-relat
ON F5 OF fi-es-codigo IN FRAME f-pg-par /* Componente */
DO:
  {include/zoomvar.i &prog-zoom  = inzoom/z02in172.w
                     &campo      = fi-es-codigo
                     &campozoom  = it-codigo
                     &campo2     = fi-desc-item
                     &campozoom2 = desc-item}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-es-codigo w-relat
ON LEAVE OF fi-es-codigo IN FRAME f-pg-par /* Componente */
DO:
     assign fi-es-codigo:screen-value in frame f-pg-par = trim(input frame f-pg-par fi-es-codigo).

     {include/leave.i &tabela=item
                      &atributo-ref=desc-item
                      &variavel-ref=fi-desc-item
                      &where="item.it-codigo = input frame f-pg-par fi-es-codigo and
                              item.it-codigo <> ''"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-es-codigo w-relat
ON MOUSE-SELECT-DBLCLICK OF fi-es-codigo IN FRAME f-pg-par /* Componente */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-es-codigo w-relat
ON RETURN OF fi-es-codigo IN FRAME f-pg-par /* Componente */
DO:
  apply 'choose' to bt-go in frame f-pg-par.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-es-codigo-alt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-es-codigo-alt w-relat
ON F5 OF fi-es-codigo-alt IN FRAME f-pg-par /* Compon. Alt. */
DO:
  {include/zoomvar.i &prog-zoom  = inzoom/z02in172.w
                     &campo      = fi-es-codigo-alt
                     &campozoom  = it-codigo
                     &campo2     = fi-desc-item-alt
                     &campozoom2 = desc-item}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-es-codigo-alt w-relat
ON LEAVE OF fi-es-codigo-alt IN FRAME f-pg-par /* Compon. Alt. */
DO:
     assign fi-es-codigo-alt:screen-value in frame f-pg-par = trim(input frame f-pg-par fi-es-codigo-alt).

     {include/leave.i &tabela=item
                      &atributo-ref=desc-item
                      &variavel-ref=fi-desc-item-alt
                      &where="item.it-codigo = input frame f-pg-par fi-es-codigo-alt and
                              item.it-codigo <> ''"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-es-codigo-alt w-relat
ON MOUSE-SELECT-DBLCLICK OF fi-es-codigo-alt IN FRAME f-pg-par /* Compon. Alt. */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-es-codigo-alt w-relat
ON RETURN OF fi-es-codigo-alt IN FRAME f-pg-par /* Compon. Alt. */
DO:
  apply 'choose' to bt-go in frame f-pg-par.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-fm-cod-com-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fm-cod-com-fim w-relat
ON RETURN OF fi-fm-cod-com-fim IN FRAME f-pg-par
DO:
  apply 'choose' to bt-go in frame f-pg-par.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-fm-cod-com-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fm-cod-com-ini w-relat
ON RETURN OF fi-fm-cod-com-ini IN FRAME f-pg-par /* Fam°lia Comercial */
DO:
    apply 'entry' to fi-fm-cod-com-fim in frame f-pg-par.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-fm-codigo-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fm-codigo-fim w-relat
ON RETURN OF fi-fm-codigo-fim IN FRAME f-pg-par
DO:
  apply 'choose' to bt-go in frame f-pg-par.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-fm-codigo-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fm-codigo-ini w-relat
ON RETURN OF fi-fm-codigo-ini IN FRAME f-pg-par /* Fam°lia */
DO:
    apply 'entry' to fi-fm-codigo-fim in frame f-pg-par.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ge-codigo-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ge-codigo-fim w-relat
ON RETURN OF fi-ge-codigo-fim IN FRAME f-pg-par
DO:
  apply 'choose' to bt-go in frame f-pg-par.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ge-codigo-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ge-codigo-ini w-relat
ON RETURN OF fi-ge-codigo-ini IN FRAME f-pg-par /* Grupo Estoque */
DO:
    apply 'entry' to fi-ge-codigo-fim in frame f-pg-par.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo-fim w-relat
ON RETURN OF fi-it-codigo-fim IN FRAME f-pg-par
DO:
  apply 'choose' to bt-go in frame f-pg-par.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo-ini w-relat
ON RETURN OF fi-it-codigo-ini IN FRAME f-pg-par /* Item */
DO:
    apply 'entry' to fi-it-codigo-fim in frame f-pg-par.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-cla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-cla w-relat
ON MOUSE-SELECT-CLICK OF im-pg-cla IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-dig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-dig w-relat
ON MOUSE-SELECT-CLICK OF im-pg-dig IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp w-relat
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par w-relat
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel w-relat
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME l-habilitaRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-habilitaRtf w-relat
ON VALUE-CHANGED OF l-habilitaRtf IN FRAME f-pg-imp /* RTF */
DO:
    &IF "{&RTF}":U = "YES":U &THEN
    RUN pi-habilitaRtf.
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino w-relat
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
/*Alterado 15/02/2005 - tech1007 - Evento alterado para correto funcionamento dos novos widgets
  utilizados para a funcionalidade de RTF*/
do  with frame f-pg-imp:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo:sensitive    = no
                   bt-arquivo:visible     = no
                   bt-config-impr:visible = YES
                   /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                     verificar se o RTF est† ativo*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = NO
                   l-habilitaRtf:SCREEN-VALUE IN FRAME f-pg-imp = "No"
                   l-habilitaRtf = NO
                   &endif
                   /*Fim alteracao 17/02/2005*/
                   .
        end.
        when "2" then do:
            assign c-arquivo:sensitive     = yes
                   bt-arquivo:visible      = yes
                   bt-config-impr:visible  = NO
                   /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                     verificar se o RTF est† ativo*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   /*Fim alteracao 17/02/2005*/
                   .
        end.
        when "3" then do:
            assign c-arquivo:sensitive     = no
                   bt-arquivo:visible      = no
                   bt-config-impr:visible  = no
                   /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                     verificar se o RTF est† ativo*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   /*Fim alteracao 17/02/2005*/
                   .
            /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
            &IF "{&RTF}":U = "YES":U &THEN
            IF VALID-HANDLE(hWenController) THEN DO:
                ASSIGN l-habilitaRtf:sensitive  = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME f-pg-imp = "No"
                       l-habilitaRtf = NO.
            END.
            &endif
            /*Fim alteracao 15/02/2005*/
        end.
    end case.
end.
&IF "{&RTF}":U = "YES":U &THEN
RUN pi-habilitaRtf.
&endif
/*Fim alteracao 15/02/2005*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao w-relat
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-cla
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */
fi-es-codigo:load-mouse-pointer("image/lupa.cur") in frame f-pg-par.
fi-es-codigo-alt:load-mouse-pointer("image/lupa.cur")  in frame f-pg-par.
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "ESEN0109" "1.00.00.000"}

/*:T inicializaá‰es do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-rplbl.i}

wh-label-sel:screen-value = "".
wh-label-sel:hidden       = yes.
wh-label-cla:screen-value = "".
wh-label-cla:hidden       = yes.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    h-digita = browse br-digita:get-browse-column(4).

    assign fi-color:hidden    in frame f-pg-dig = yes
           fi-inativos:hidden in frame f-pg-dig = yes.

    if  c-en0109-upc <> ""
    then do:
         assign fi-es-codigo:screen-value in frame f-pg-par = trim(c-en0109-upc).

         apply 'leave' to fi-es-codigo in frame f-pg-par.

         assign fi-es-codigo:sensitive in frame f-pg-par = no.

         apply 'choose' to bt-go in frame f-pg-par.

         {include/i-rpmbl.i im-pg-dig}
    end.
    else do:
         {include/i-rpmbl.i im-pg-par}
    end.

    assign c-en0109-upc = "".

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-relat  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-relat  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-relat  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
  THEN DELETE WIDGET w-relat.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-relat  _DEFAULT-ENABLE
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
  ENABLE im-pg-dig im-pg-imp im-pg-par bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY c-ini-campo c-fim-campo 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE IMAGE-1 IMAGE-2 c-ini-campo c-fim-campo 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY rs-classif 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  ENABLE rs-classif 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-cla}
  DISPLAY rs-destino c-arquivo l-habilitaRtf c-modelo-rtf rs-execucao text-rtf 
          text-modelo-rtf 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  ENABLE rect-rtf RECT-7 RECT-9 rs-destino bt-arquivo bt-config-impr c-arquivo 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY fi-es-codigo fi-desc-item fi-es-codigo-alt fi-desc-item-alt 
          fi-it-codigo-ini fi-it-codigo-fim fi-fm-codigo-ini fi-fm-codigo-fim 
          fi-fm-cod-com-ini fi-fm-cod-com-fim fi-ge-codigo-ini fi-ge-codigo-fim 
          cb-obsoleto-ini cb-obsoleto-fim 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  ENABLE IMAGE-3 IMAGE-4 RECT-10 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 
         IMAGE-10 IMAGE-13 IMAGE-14 fi-es-codigo fi-es-codigo-alt bt-go 
         fi-it-codigo-ini fi-it-codigo-fim fi-fm-codigo-ini fi-fm-codigo-fim 
         fi-fm-cod-com-ini fi-fm-cod-com-fim fi-ge-codigo-ini fi-ge-codigo-fim 
         cb-obsoleto-ini cb-obsoleto-fim 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY fi-color fi-inativos 
      WITH FRAME f-pg-dig IN WINDOW w-relat.
  ENABLE br-digita 
      WITH FRAME f-pg-dig IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-dig}
  VIEW w-relat.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-relat 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega w-relat 
PROCEDURE pi-carrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if  fi-es-codigo <> ""
and can-find(first item where
                   item.it-codigo = fi-es-codigo
                   no-lock)
then.
else return "NOK".

h-digita:label = "Qtd It " + fi-es-codigo.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Carregando...").

for each estrutura fields(it-codigo es-codigo   sequencia quant-usada 
                          qtd-item  data-inicio data-termino) use-index onde-se-usa no-lock
   where estrutura.es-codigo     = input frame f-pg-par fi-es-codigo
     and estrutura.it-codigo    >= input frame f-pg-par fi-it-codigo-ini
     and estrutura.it-codigo    <= input frame f-pg-par fi-it-codigo-fim
     and estrutura.data-inicio  <= today
     and estrutura.data-termino >= today
     &IF DEFINED (bf_man_sfc_lc) &THEN
     and estrutura.cod-lista-compon = ""
     &ENDIF,
   first item fields(it-codigo desc-item) no-lock
   where item.it-codigo     = estrutura.it-codigo
     and item.fm-codigo    >= input frame f-pg-par fi-fm-codigo-ini
     and item.fm-codigo    <= input frame f-pg-par fi-fm-codigo-fim
     and item.fm-cod-com   >= input frame f-pg-par fi-fm-cod-com-ini
     and item.fm-cod-com   <= input frame f-pg-par fi-fm-cod-com-fim
     and item.ge-codigo    >= input frame f-pg-par fi-ge-codigo-ini
     and item.ge-codigo    <= input frame f-pg-par fi-ge-codigo-fim
     and item.cod-obsoleto >= input frame f-pg-par cb-obsoleto-ini
     and item.cod-obsoleto <= input frame f-pg-par cb-obsoleto-fim:
    run pi-acompanhar in h-acomp (input item.it-codigo).

    create tt-digita.
    assign tt-digita.it-codigo   = estrutura.it-codigo
           tt-digita.desc-item   = item.desc-item
           tt-digita.sequencia   = estrutura.sequencia
           tt-digita.quantidade  = estrutura.quant-usada * estrutura.qtd-item
           tt-digita.dt-inicio   = if  year(estrutura.data-inicio) > 1999 
                                   and year(estrutura.data-inicio) < 2100
                                   then string(estrutura.data-inicio,"99/99/99")
                                   else ""
           tt-digita.dt-termino  = if  year(estrutura.data-termino) > 1999 
                                   and year(estrutura.data-termino) < 2100
                                   then string(estrutura.data-termino,"99/99/99")
                                   else ""      
           tt-digita.ativo       = estrutura.data-inicio  <= today and 
                                   estrutura.data-termino >= today
           tt-digita.r-estrutura = rowid(estrutura).
end. /* for each estrutura */
find current tt-digita no-error.
release tt-digita.

run pi-finalizar in h-acomp.

return "OK".

finally:
    if valid-handle(h-acomp)
    then delete procedure h-acomp no-error.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var r-tt-digita as rowid no-undo.

apply 'leave' to fi-es-codigo     in frame f-pg-par.
apply 'leave' to fi-es-codigo-alt in frame f-pg-par.

do on error undo, return error on stop  undo, return error:
    {include/i-rpexa.i}
    /*14/02/2005 - tech1007 - Alterada condicao para n∆o considerar mai o RTF como destino*/
    if input frame f-pg-imp rs-destino = 2 and
       input frame f-pg-imp rs-execucao = 1 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "").
            
            apply "MOUSE-SELECT-CLICK":U to im-pg-imp in frame f-relat.
            apply "ENTRY":U to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.

    /*14/02/2005 - tech1007 - Teste efetuado para nao permitir modelo em branco*/
    &IF "{&RTF}":U = "YES":U &THEN
    IF ( INPUT FRAME f-pg-imp c-modelo-rtf = "" AND
         INPUT FRAME f-pg-imp l-habilitaRtf = "Yes" ) OR
       ( SEARCH(INPUT FRAME f-pg-imp c-modelo-rtf) = ? AND
         input frame f-pg-imp rs-execucao = 1 AND
         INPUT FRAME f-pg-imp l-habilitaRtf = "Yes" )
         THEN DO:
        run utp/ut-msgs.p (input "show":U, input 73, input "").        
        apply "MOUSE-SELECT-CLICK":U to im-pg-imp in frame f-relat.
        /*30/12/2004 - tech1007 - Evento removido pois causa problemas no WebEnabler*/
        /*apply "CHOOSE":U to bt-modelo-rtf in frame f-pg-imp.*/
        return error.
    END.
    &endif
    /*Fim teste Modelo*/

    /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
       o focus no campo com problemas */
    /*browse br-digita:SET-REPOSITIONED-ROW (browse br-digita:DOWN, "ALWAYS":U).*/
    
    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).
        
        /*:T Validaá∆o de duplicidade de registro na temp-table tt-digita */
        find first b-tt-digita where b-tt-digita.it-codigo = tt-digita.it-codigo and
                                     b-tt-digita.sequencia = tt-digita.sequencia and
                                     rowid(b-tt-digita) <> rowid(tt-digita) no-lock no-error.
        if avail b-tt-digita then do:
            apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
            reposition br-digita to rowid rowid(b-tt-digita).
            
            run utp/ut-msgs.p (input "show":U, input 108, input "").
            apply "ENTRY":U to tt-digita.it-codigo in browse br-digita.
            
            return error.
        end.
        
        /*:T As demais validaá‰es devem ser feitas aqui */
        if tt-digita.it-codigo = "" then do:
            assign browse br-digita:CURRENT-COLUMN = tt-digita.it-codigo:HANDLE in browse br-digita.
            
            apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
            reposition br-digita to rowid r-tt-digita.
            
            run utp/ut-msgs.p (input "show", input 17567, input "Item est† em branco!").
            apply "ENTRY":U to tt-digita.it-codigo in browse br-digita.
            
            return error.
        end.

        if tt-digita.it-codigo = input frame f-pg-par fi-es-codigo-alt
        then do:
             apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.
             run utp/ut-msgs.p (input "show", input 17567, input "Componente Alternativo n∆o pode ser igual Ö Item Pai na estrutura do Componente!").
             apply 'entry' to fi-es-codigo-alt in frame f-pg-par.
             return 'ADM-ERROR'.            
        end.        
    end.
    find first tt-digita no-error.

    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */
    if input frame f-pg-par fi-es-codigo = ""
    then do:
         apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.
         run utp/ut-msgs.p (input "show", input 17567, input "Componente deve ser informado!").
         apply 'entry' to fi-es-codigo in frame f-pg-par.
         return 'ADM-ERROR'.
    end.

    for first item 
        where item.it-codigo = input frame f-pg-par fi-es-codigo
              no-lock: end.

    if not avail item
    then do:
         apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.
         run utp/ut-msgs.p (input "show", input 17567, input "Componente n∆o cadastrado!").
         apply 'entry' to fi-es-codigo in frame f-pg-par.
         return 'ADM-ERROR'.
    end.

    if item.cod-obsoleto > 1
    then do:
         apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.
         run utp/ut-msgs.p (input "show", input 17567, input "Componente n∆o se encontra ativo!").
         apply 'entry' to fi-es-codigo in frame f-pg-par.
         return 'ADM-ERROR'.
    end.

    if fi-es-codigo <> input frame f-pg-par fi-es-codigo
    then do:
         apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.
         run utp/ut-msgs.p (input "show", input 17567, input "Componente foi modificado antes da £ltima atualizaá∆o do browse, o qual deve ser recarregado!").
         apply 'entry' to fi-es-codigo in frame f-pg-par.
         return 'ADM-ERROR'.
    end.

    if not can-find(first estrutura use-index onde-se-usa where
                          estrutura.es-codigo = fi-es-codigo
                          no-lock)
    then do:
         apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.
         run utp/ut-msgs.p (input "show", input 17567, input "Item " + fi-es-codigo + " n∆o integra nenhuma estrutura!").
         apply 'entry' to fi-es-codigo in frame f-pg-par.
         return 'ADM-ERROR'.         
    end.

    if not can-find(first tt-digita use-index id2 where
                          tt-digita.ativo = yes)
    then do:
         apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
         run utp/ut-msgs.p (input "show", input 17567, input "Nenhum Onde-se-usa ativo carregado!").
         return 'ADM-ERROR'.
    end.

    if input frame f-pg-par fi-es-codigo-alt = ""
    then do:
         apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.
         run utp/ut-msgs.p (input "show", input 17567, input "Componente Alternativo deve ser informado!").
         apply 'entry' to fi-es-codigo-alt in frame f-pg-par.
         return 'ADM-ERROR'.
    end.

    for first item 
        where item.it-codigo = input frame f-pg-par fi-es-codigo-alt
              no-lock: end.

    if not avail item
    then do:
         apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.
         run utp/ut-msgs.p (input "show", input 17567, input "Componente Alternativo n∆o cadastrado!").
         apply 'entry' to fi-es-codigo-alt in frame f-pg-par.
         return 'ADM-ERROR'.
    end.

    if item.cod-obsoleto > 1
    then do:
         apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.
         run utp/ut-msgs.p (input "show", input 17567, input "Componente Alternativo n∆o se encontra ativo!").
         apply 'entry' to fi-es-codigo-alt in frame f-pg-par.
         return 'ADM-ERROR'.
    end.

    if item.tipo-contr = 4
    then do:
         apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.
         run utp/ut-msgs.p (input "show", input 17567, input "Tipo Controle do Componente Alternativo n∆o pode ser DÇbito Direto!").
         apply 'entry' to fi-es-codigo-alt in frame f-pg-par.
         return 'ADM-ERROR'.
    end.

    if fi-es-codigo = input frame f-pg-par fi-es-codigo-alt
    then do:
         apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.
         run utp/ut-msgs.p (input "show", input 17567, input "Componente tem de ser diferente de Componente Alternativo!").
         apply 'entry' to fi-es-codigo-alt in frame f-pg-par.
         return 'ADM-ERROR'.
    end.

    if not can-find(first estrutura use-index onde-se-usa where
                          estrutura.es-codigo     = fi-es-codigo
                      and estrutura.data-inicio  <= today
                      and estrutura.data-termino >= today 
                          no-lock)
    then do:
         apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.
         run utp/ut-msgs.p (input "show", input 17567, input "Item " + fi-es-codigo + " n∆o integra nenhuma estrutura ativa!").
         apply 'entry' to fi-es-codigo in frame f-pg-par.
         return 'ADM-ERROR'.         
    end.

    assign c-mensagem = "Confirma tentativa de inclus∆o de Componente Alternativo?~~Confirma tentativa de inclus∆o de Componente Alternativo?".
    
    run utp/ut-msgs(input 'show',
                    input 27100,
                    input c-mensagem).
    
    if return-value <> 'yes'
    then return no-apply.
    
    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame f-pg-imp rs-destino
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.classifica      = input frame f-pg-cla rs-classif
           tt-param.desc-classifica = entry((tt-param.classifica - 1) * 2 + 1, 
                                            rs-classif:radio-buttons in frame f-pg-cla)
           &IF "{&RTF}":U = "YES":U &THEN
           tt-param.modelo-rtf      = INPUT FRAME f-pg-imp c-modelo-rtf
           /*Alterado 14/02/2005 - tech1007 - Armazena a informaá∆o se o RTF est† habilitado ou n∆o*/
           tt-param.l-habilitaRtf     = INPUT FRAME f-pg-imp l-habilitaRtf
           /*Fim alteracao 14/02/2005*/ 
           &endif
           .
    
    /*Alterado 14/02/2005 - tech1007 - Alterado o teste para verificar se a opá∆o de RTF est† selecionada*/
    if tt-param.destino = 1 
    then assign tt-param.arquivo = "".
    else if  tt-param.destino = 2
         then assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    /*Fim alteracao 14/02/2005*/

    /*:T Coloque aqui a/l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
    assign tt-param.execucao       = input frame f-pg-imp rs-execucao
           tt-param.es-codigo      = fi-es-codigo
           tt-param.es-codigo-alt  = input frame f-pg-par fi-es-codigo-alt.
    
    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {include/i-rpexb.i}
    
    SESSION:SET-WAIT-STATE("general":U).
    
    {include/i-rprun.i esp/enp/esen0109rp.p}
    
    {include/i-rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {include/i-rptrm.i}
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retira w-relat 
PROCEDURE pi-retira :
def var i-cont as inte no-undo.
def var i-rows as inte no-undo.

if br-digita:num-selected-rows in frame f-pg-dig = 0
then return "OK".

release b-tt-digita.

assign i-rows = br-digita:num-selected-rows in frame f-pg-dig.

do i-cont = 1 to i-rows:
    br-digita:fetch-selected-row(i-cont).
    find current tt-digita no-error.

    if i-cont = i-rows
    then do:
         find first b-tt-digita 
              where rowid(b-tt-digita) = rowid(tt-digita)
                    no-error.    
         find next b-tt-digita no-error.
    end. /* if i-cont = 1 */

    delete tt-digita.
end.

{&open-query-br-digita}

if not avail b-tt-digita
then find last b-tt-digita no-error.

if avail b-tt-digita
then do:
     browse br-digita:set-repositioned-row(1, 'CONDITIONAL').
     reposition br-digita to rowid rowid(b-tt-digita) no-error. 
     br-digita:select-focused-row().
     apply 'iteration-changed' to br-digita.
end. /* if avail b-tt-digita */

return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/*:T------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-relat  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-digita"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-relat 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  run pi-trata-state (p-issuer-hdl, p-state).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

