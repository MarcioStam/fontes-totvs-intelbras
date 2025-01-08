&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*---------------------------------------------------------------------- */

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

{include/i-prgvrs.i ESFTP0527 2.06.00.000}
{utp/ut-glob.i}
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
DEFINE VARIABLE hProgramZoom AS HANDLE      NO-UNDO.
/*zoom smart*/
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE l-implanta AS LOGICAL     NO-UNDO.

DEFINE VARIABLE r-tt-digita     as rowid no-undo.
DEFINE VARIABLE h-acomp         as handle              no-undo.
DEFINE VARIABLE raw-param       AS RAW NO-UNDO.
DEFINE VARIABLE c-arq-old       AS CHARACTER   NO-UNDO.
DEF VAR v-cod-prog-gerado       AS CHAR      NO-UNDO.
DEF VAR v-cod-extens-arq        AS CHAR      NO-UNDO INITIAL "pdf".
DEFINE VARIABLE c-diretorio-xml AS CHARACTER   NO-UNDO.
DEFINE VARIABLE tp-integ        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-sit-nf-eletro AS CHARACTER   NO-UNDO.



DEF TEMP-TABLE ttNotas NO-UNDO
    FIELD lok          AS LOG FORMAT ' X/ ' COLUMN-LABEL 'Impr.'
    FIELD limp         AS LOG INITIAL NO
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD nr-nota-fis       LIKE nota-fiscal.nr-nota-fis
    FIELD cod-emitente      LIKE nota-fiscal.cod-emitente
    FIELD nome              LIKE emitente.nome-abrev
    FIELD cdd-embarq        like nota-fiscal.cdd-embarq COLUMN-LABEL "Embarque"
    FIELD estado            LIKE nota-fiscal.estado
    FIELD serie             like nota-fiscal.serie
    FIELD nome-transp       LIKE nota-fiscal.nome-transp
    FIELD cd-oper           LIKE atendente.cd-oper
    FIELD nm-oper           LIKE atendente.nm-oper
    FIELD dt-emis-nota      LIKE nota-fiscal.dt-emis-nota
    FIELD idi-sit-nf-eletro LIKE nota-fiscal.idi-sit-nf-eletro 
    FIELD nat-operacao      LIKE nota-fiscal.nat-operacao
    FIELD r-rowid      AS ROWID.

{cdp/cdcfgdis.i}
/* Parameters Definitions ---                                           */

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD serie             like nota-fiscal.serie
    FIELD nr-nota-fis       LIKE nota-fiscal.nr-nota-fis
    FIELD cdd-embarq        like nota-fiscal.cdd-embarq COLUMN-LABEL "Embarque".

def temp-table tt-param-aux
    field destino              as integer
    field destino-bloq         as integer
    field arquivo              as char
    field arquivo-bloq         as char
    field usuario              as char
    field data-exec            as date
    field hora-exec            as integer
    field parametro            as logical
    field formato              as integer
    field cod-layout           as character
    field des-layout           as character
    field log-impr-dados       as logical  
    field v_num_tip_aces_usuar as integer
&IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo            LIKE mgcad.empresa.ep-codigo
&ELSE
    field ep-codigo            as integer
&ENDIF
    field da-dt-saida          like movdis.nota-fiscal.dt-saida
    field c-hr-saida           AS CHAR FORMAT "xx:xx:xx":U INITIAL "000000"
    field banco                as integer
    field cod-febraban         as integer      
    field cod-portador         as integer      
    field prox-bloq            as char         
    field c-instrucao          as char extent 5
    field imprime-bloq         as logical
    field rs-imprime           as integer
    FIELD impressora-so        AS CHAR
    FIELD impressora-so-bloq   AS CHAR
    FIELD nr-copias            AS INTEGER
    FIELD l-gera-danfe-xml     AS LOGICAL
    FIELD c-dir-hist-xml       AS CHARACTER
    FIELD ind-execucao         AS INT
    FIELD data-ini             AS DATE
    FIELD data-fim             AS DATE
    FIELD nr-nota-fis          AS CHAR
    FIELD serie                AS CHAR
    FIELD cod-estabel          AS CHAR. 

DEF TEMP-TABLE tt-raw-digita
   FIELD raw-digita AS RAW.

def new global shared var h-facelift as handle no-undo.

IF NOT VALID-HANDLE(h-facelift) THEN
  RUN btb/btb901zo.p PERSISTENT SET h-facelift.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brNotas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttNotas

/* Definitions for BROWSE brNotas                                       */
&Scoped-define FIELDS-IN-QUERY-brNotas ttNotas.lok ttNotas.nr-nota-fis ttNotas.serie ttNotas.dt-emis-not ttNotas.cod-emitente ttNotas.nome ttNotas.cdd-embarq ttNotas.estado ttNotas.nat-operacao ttNotas.nome-transp ttNotas.cd-oper ttNotas.nm-oper fnSitNfEltro(ttNotas.idi-sit-nf-eletro) @ c-sit-nf-eletro   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brNotas   
&Scoped-define SELF-NAME brNotas
&Scoped-define QUERY-STRING-brNotas FOR EACH ttNotas     BY ttNotas.dt-emis-not     BY ttNotas.nr-nota-fis     BY ttNotas.serie
&Scoped-define OPEN-QUERY-brNotas OPEN QUERY {&SELF-NAME} FOR EACH ttNotas     BY ttNotas.dt-emis-not     BY ttNotas.nr-nota-fis     BY ttNotas.serie.
&Scoped-define TABLES-IN-QUERY-brNotas ttNotas
&Scoped-define FIRST-TABLE-IN-QUERY-brNotas ttNotas


/* Definitions for FRAME fPage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage0 ~
    ~{&OPEN-QUERY-brNotas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-21 IMAGE-22 RECT-17 RECT-18 RECT-20 ~
RECT-21 RECT-22 RECT-93 RECT-7 RECT-101 RECT-102 RECT-103 RECT-100 ~
fiCd-oper fiEstab rsImprime fiDestinatario fiEmbarque fiDataIni fiDataFim ~
FIsERIE fiEstado fiNota BTNota fiNatureza fiUsuario tgFatur brNotas ~
bt-marca bt-desmarca bt-todos bt-des-all bt-sair bt-impr tb-gera-danfe-xml ~
bt-dir-hist-xml fi-dir-historico-xml da-dt-saida rsDestiny c-hr-saida ~
cbImpr btFile cFile i-nr-copias fiOpcao FILL-IN-8 text-destino 
&Scoped-Define DISPLAYED-OBJECTS fiCd-oper fiDesc1 fiEstab rsImprime ~
fiDestinatario fiDesc-2 fiEmbarque fiDataIni fiDataFim FIsERIE fiEstado ~
fiNota fiNatureza fiUsuario tgFatur tb-gera-danfe-xml fi-dir-historico-xml ~
da-dt-saida rsDestiny c-hr-saida cbImpr cFile i-nr-copias fiOpcao FILL-IN-8 ~
text-destino 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnimp C-Win 
FUNCTION fnimp RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnImpressora C-Win 
FUNCTION fnImpressora RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSitNfEltro C-Win 
FUNCTION fnSitNfEltro RETURNS CHARACTER
  ( p-idi-sit-nf-eletro AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-des-all 
     LABEL "Desmarcar Todos" 
     SIZE 17 BY 1.14.

DEFINE BUTTON bt-desmarca 
     LABEL "Desmarcar" 
     SIZE 18 BY 1.14.

DEFINE BUTTON bt-dir-hist-xml 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL " " 
     SIZE 4 BY 1.

DEFINE BUTTON bt-impr 
     LABEL "Imprimir" 
     SIZE 17 BY 1.14.

DEFINE BUTTON bt-marca 
     LABEL "Marcar" 
     SIZE 16 BY 1.14.

DEFINE BUTTON bt-sair 
     LABEL "Sair" 
     SIZE 12.4 BY 1.14.

DEFINE BUTTON bt-todos 
     LABEL "Marcar Todos" 
     SIZE 17 BY 1.14.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON BTNota 
     LABEL "Buscar Notas" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE cbImpr AS CHARACTER FORMAT "X(256)":U INITIAL "Sem Impressoras Cadastradas no Sistema Operacional" 
     LABEL "Impressora" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sem Impressoras Cadastradas no Sistema Operacional" 
     DROP-DOWN-LIST
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .86
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-hr-saida AS CHARACTER FORMAT "xx:xx:xx":U INITIAL "000000" 
     LABEL "Hr Sa°da":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .86
     FONT 1 NO-UNDO.

DEFINE VARIABLE da-dt-saida AS DATE FORMAT "99/99/9999" 
     LABEL "Dt Sa°da":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .86
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-dir-historico-xml AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.8 BY .86 NO-UNDO.

DEFINE VARIABLE fiCd-oper AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Atendente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .86.

DEFINE VARIABLE fiDataFim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .86 NO-UNDO.

DEFINE VARIABLE fiDataIni AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Emiss∆o NF" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .86 NO-UNDO.

DEFINE VARIABLE fiDesc-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .86 NO-UNDO.

DEFINE VARIABLE fiDesc1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .86 NO-UNDO.

DEFINE VARIABLE fiDestinatario AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Destinat†rio" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .86 NO-UNDO.

DEFINE VARIABLE fiEmbarque AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .86 NO-UNDO.

DEFINE VARIABLE fiEstab AS CHARACTER FORMAT "X(05)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .86 NO-UNDO.

DEFINE VARIABLE fiEstado AS CHARACTER FORMAT "X(02)":U 
     LABEL "UF" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .86 NO-UNDO.

DEFINE VARIABLE FILL-IN-8 AS CHARACTER FORMAT "X(256)":U INITIAL "Notas Impressas" 
      VIEW-AS TEXT 
     SIZE 12.4 BY .67 NO-UNDO.

DEFINE VARIABLE fiNatureza AS CHARACTER FORMAT "X(15)":U 
     LABEL "Natur Oper" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .86 NO-UNDO.

DEFINE VARIABLE fiNota AS CHARACTER FORMAT "X(07)":U 
     LABEL "Nr Nota Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .86 NO-UNDO.

DEFINE VARIABLE fiOpcao AS CHARACTER FORMAT "X(256)":U INITIAL "Opá∆o:" 
      VIEW-AS TEXT 
     SIZE 5.6 BY .67 NO-UNDO.

DEFINE VARIABLE FIsERIE AS CHARACTER FORMAT "X(08)":U 
     LABEL "SÇrie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .86 NO-UNDO.

DEFINE VARIABLE fiUsuario AS CHARACTER FORMAT "X(12)":U 
     LABEL "Usu†rio" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .86 NO-UNDO.

DEFINE VARIABLE i-nr-copias AS INTEGER FORMAT ">>9" INITIAL 1 
     LABEL "Nr C¢pias":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .86
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.2 BY .62
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-fir":U
     SIZE 3 BY .86.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-las":U
     SIZE 3 BY .86.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora":U, 1,
"Arquivo":U, 2,
"Terminal":U, 3
     SIZE 44 BY 1.1
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsImprime AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Impress∆o", 1,
"Reimpress∆o", 2
     SIZE 12 BY 2.38 NO-UNDO.

DEFINE RECTANGLE RECT-100
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.81.

DEFINE RECTANGLE RECT-101
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58 BY 1.48.

DEFINE RECTANGLE RECT-102
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58 BY 1.62.

DEFINE RECTANGLE RECT-103
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35 BY 3.76.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 3.24.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 115.8 BY 6.24.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 115 BY 1.76.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 1.14.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 115 BY 6.95.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 3.76.

DEFINE RECTANGLE RECT-93
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 7 BY .95
     BGCOLOR 10 FGCOLOR 10 .

DEFINE VARIABLE tb-gera-danfe-xml AS LOGICAL INITIAL no 
     LABEL "Gera DANFE a partir do XML" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .81 NO-UNDO.

DEFINE VARIABLE tgFatur AS LOGICAL INITIAL yes 
     LABEL "Faturamento Comercial" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brNotas FOR 
      ttNotas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brNotas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brNotas C-Win _FREEFORM
  QUERY brNotas DISPLAY
      ttNotas.lok
ttNotas.nr-nota-fis  WIDTH 8
ttNotas.serie  
ttNotas.dt-emis-not
ttNotas.cod-emitente
ttNotas.nome        
ttNotas.cdd-embarq  COLUMN-LABEL "Embarque" WIDTH 7
ttNotas.estado      COLUMN-LABEL "UF" WIDTH 3
ttNotas.nat-operacao COLUMN-LABEL "Nat Op" WIDTH 8
ttNotas.nome-transp 
ttNotas.cd-oper     COLUMN-LABEL "Atendente" WIDTH 8
ttNotas.nm-oper     COLUMN-LABEL "Nome" WIDTH 20
fnSitNfEltro(ttNotas.idi-sit-nf-eletro) @ c-sit-nf-eletro FORMAT "X(25)" COLUMN-LABEL "Sit."
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 115 BY 7.52
         FONT 1
         TITLE "Notas Fiscais".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     fiCd-oper AT ROW 1.67 COL 44.2 COLON-ALIGNED WIDGET-ID 8
     fiDesc1 AT ROW 1.67 COL 54.6 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     fiEstab AT ROW 1.76 COL 15.8 COLON-ALIGNED WIDGET-ID 2
     rsImprime AT ROW 2 COL 97 NO-LABEL WIDGET-ID 44
     fiDestinatario AT ROW 2.67 COL 44.2 COLON-ALIGNED WIDGET-ID 16
     fiDesc-2 AT ROW 2.67 COL 54.6 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     fiEmbarque AT ROW 2.76 COL 13 COLON-ALIGNED WIDGET-ID 4
     fiDataIni AT ROW 3.67 COL 44.2 COLON-ALIGNED WIDGET-ID 20
     fiDataFim AT ROW 3.67 COL 65.2 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     FIsERIE AT ROW 3.76 COL 13 COLON-ALIGNED WIDGET-ID 6
     fiEstado AT ROW 4.62 COL 44.2 COLON-ALIGNED WIDGET-ID 118
     fiNota AT ROW 4.76 COL 13.6 COLON-ALIGNED WIDGET-ID 114
     BTNota AT ROW 5.48 COL 95.4 WIDGET-ID 56
     fiNatureza AT ROW 5.62 COL 44.2 COLON-ALIGNED WIDGET-ID 120
     fiUsuario AT ROW 5.76 COL 13 COLON-ALIGNED WIDGET-ID 116
     tgFatur AT ROW 5.76 COL 64.8 WIDGET-ID 54
     brNotas AT ROW 7.52 COL 2 WIDGET-ID 200
     bt-marca AT ROW 15.43 COL 2.6 WIDGET-ID 64
     bt-desmarca AT ROW 15.43 COL 18.6 WIDGET-ID 26
     bt-todos AT ROW 15.43 COL 36.6 WIDGET-ID 24
     bt-des-all AT ROW 15.43 COL 53.6 WIDGET-ID 62
     bt-sair AT ROW 15.43 COL 70.6 WIDGET-ID 66
     bt-impr AT ROW 15.43 COL 83 WIDGET-ID 70
     tb-gera-danfe-xml AT ROW 17.24 COL 51.8 HELP
          "Gera danfe a partir de um arquivo XML" WIDGET-ID 110
     bt-dir-hist-xml AT ROW 17.81 COL 43.8 HELP
          "Escolha o arquivo XML" WIDGET-ID 104
     fi-dir-historico-xml AT ROW 17.86 COL 4.2 COLON-ALIGNED HELP
          "Caminho  do Reposit¢rio Arquivos XML" NO-LABEL WIDGET-ID 106
     da-dt-saida AT ROW 20.05 COL 71.8 COLON-ALIGNED WIDGET-ID 98
     rsDestiny AT ROW 20.14 COL 14.2 HELP
          "Destino de Impress∆o do Relat¢rio":U NO-LABEL WIDGET-ID 82
     c-hr-saida AT ROW 21.05 COL 71.8 COLON-ALIGNED WIDGET-ID 96
     cbImpr AT ROW 21.71 COL 12.6 COLON-ALIGNED WIDGET-ID 68
     btFile AT ROW 21.71 COL 55.2 HELP
          "Escolha do nome do arquivo":U WIDGET-ID 90
     cFile AT ROW 21.76 COL 14.6 HELP
          "Nome do arquivo de destino do relat¢rio":U NO-LABEL WIDGET-ID 92
     i-nr-copias AT ROW 22.05 COL 71.8 COLON-ALIGNED WIDGET-ID 100
     fiOpcao AT ROW 1.19 COL 94.8 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     FILL-IN-8 AT ROW 17.19 COL 85 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     text-destino AT ROW 19.19 COL 4.2 COLON-ALIGNED NO-LABEL WIDGET-ID 86
     "Reposit¢rio Arquivos XML" VIEW-AS TEXT
          SIZE 19 BY .67 AT ROW 17.05 COL 6 WIDGET-ID 112
     IMAGE-21 AT ROW 3.81 COL 58.2 WIDGET-ID 38
     IMAGE-22 AT ROW 3.81 COL 62.6 WIDGET-ID 40
     RECT-17 AT ROW 1.52 COL 95.4 WIDGET-ID 48
     RECT-18 AT ROW 1 COL 1.2 WIDGET-ID 52
     RECT-20 AT ROW 15.14 COL 2 WIDGET-ID 60
     RECT-21 AT ROW 5.62 COL 63.8 WIDGET-ID 72
     RECT-22 AT ROW 16.81 COL 2 WIDGET-ID 74
     RECT-93 AT ROW 17.05 COL 79.4 WIDGET-ID 76
     RECT-7 AT ROW 19.52 COL 4 WIDGET-ID 80
     RECT-101 AT ROW 20 COL 5 WIDGET-ID 88
     RECT-102 AT ROW 21.38 COL 5 WIDGET-ID 94
     RECT-103 AT ROW 19.52 COL 65 WIDGET-ID 102
     RECT-100 AT ROW 17.24 COL 4 WIDGET-ID 108
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 116.72 BY 23.08
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Impress∆o DANFE"
         HEIGHT             = 23.1
         WIDTH              = 116.8
         MAX-HEIGHT         = 25
         MAX-WIDTH          = 195.2
         VIRTUAL-HEIGHT     = 25
         VIRTUAL-WIDTH      = 195.2
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brNotas tgFatur fPage0 */
/* SETTINGS FOR FILL-IN fiDesc-2 IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiDesc1 IN FRAME fPage0
   NO-ENABLE                                                            */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage0     = 
                "Destino":U.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brNotas
/* Query rebuild information for BROWSE brNotas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttNotas
    BY ttNotas.dt-emis-not
    BY ttNotas.nr-nota-fis
    BY ttNotas.serie.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brNotas */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Impress∆o DANFE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Impress∆o DANFE */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brNotas
&Scoped-define SELF-NAME brNotas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNotas C-Win
ON MOUSE-SELECT-DBLCLICK OF brNotas IN FRAME fPage0 /* Notas Fiscais */
DO:
  IF NOT ttNotas.lok THEN
      APPLY "choose" TO bt-marca IN FRAME fpage0.
  ELSE 
      APPLY "choose" TO bt-desmarca IN FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNotas C-Win
ON ROW-DISPLAY OF brNotas IN FRAME fPage0 /* Notas Fiscais */
DO:
  IF AVAIL ttNotas  THEN DO:
      IF ttNotas.lImp = YES THEN
          ASSIGN 
          ttNotas.lok            :bgcolor in browse brNotas = 10
          ttNotas.nr-nota-fis    :bgcolor in browse brNotas = 10
          ttNotas.serie          :bgcolor in browse brNotas = 10
          ttNotas.dt-emis-not    :bgcolor in browse brNotas = 10
          ttNotas.cod-emitente   :bgcolor in browse brNotas = 10
          ttNotas.nome           :bgcolor in browse brNotas = 10
          ttNotas.cdd-embarq     :bgcolor in browse brNotas = 10
          ttNotas.nome-transp    :bgcolor in browse brNotas = 10
          ttNotas.cd-oper        :bgcolor in browse brNotas = 10
          ttNotas.nm-oper        :bgcolor in browse brNotas = 10
          c-sit-nf-eletro        :bgcolor in browse brNotas = 10
          ttNotas.estado         :BGCOLOR IN BROWSE brNotas = 10.

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-des-all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-des-all C-Win
ON CHOOSE OF bt-des-all IN FRAME fPage0 /* Desmarcar Todos */
DO:
    IF brNotas:NUM-SELECTED-ROWS > 0 THEN DO:

         FOR EACH ttNotas EXCLUSIVE-LOCK:

                 ASSIGN ttNotas.LOK = NO.
         END.
         {&OPEN-QUERY-brNotas}
     END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarca C-Win
ON CHOOSE OF bt-desmarca IN FRAME fPage0 /* Desmarcar */
DO:
  
    if  brNotas:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 0 then do on error undo, return no-apply:
        DO i-cont = 1 TO brNotas:NUM-SELECTED-ROWS:
           IF brNotas:FETCH-SELECTED-ROW(i-cont) IN FRAME {&FRAME-NAME} THEN DO:
               IF AVAIL ttNotas THEN DO:
                   ASSIGN ttNotas.LOK = NO
                          r-rowid = rowid(ttNotas).
/*                     {&OPEN-QUERY-brNotas} */
                   DISPLAY ttNotas.loK WITH BROWSE brNotas.
                    REPOSITION brNotas TO ROWID r-rowid NO-ERROR.
                    brNotas:SELECT-FOCUSED-ROW().              
             END.
           END.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-dir-hist-xml
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dir-hist-xml C-Win
ON CHOOSE OF bt-dir-hist-xml IN FRAME fPage0 /*   */
DO:
   {utp/ut-liter.i Selecione_o_diret¢rio:} 
   SYSTEM-DIALOG GET-DIR c-diretorio-xml  
             INITIAL-DIR fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0      
                   TITLE RETURN-VALUE .

   ASSIGN fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 = c-diretorio-xml.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-impr C-Win
ON CHOOSE OF bt-impr IN FRAME fPage0 /* Imprimir */
DO:
   
    RUN printDocument.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca C-Win
ON CHOOSE OF bt-marca IN FRAME fPage0 /* Marcar */
DO:



    if  brNotas:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 0 then do on error undo, return no-apply:
        DO i-cont = 1 TO brNotas:NUM-SELECTED-ROWS:
           IF brNotas:FETCH-SELECTED-ROW(i-cont) IN FRAME {&FRAME-NAME} THEN DO:
               IF AVAIL ttNotas THEN DO:
                   ASSIGN ttNotas.loK = YES
                          r-rowid = rowid(ttNotas).
                    /*{&OPEN-QUERY-brNotas}*/
                   DISPLAY ttNotas.loK WITH BROWSE brNotas.
                  REPOSITION brNotas TO ROWID r-rowid NO-ERROR.               
                     brNotas:SELECT-FOCUSED-ROW().              
             END.
           END.
        END.
    END.

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair C-Win
ON CHOOSE OF bt-sair IN FRAME fPage0 /* Sair */
DO:
   
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos C-Win
ON CHOOSE OF bt-todos IN FRAME fPage0 /* Marcar Todos */
DO:
  IF brNotas:NUM-SELECTED-ROWS > 0 THEN DO:

        FOR EACH ttNotas EXCLUSIVE-LOCK:
          ASSIGN ttNotas.LOK = YES.
        END.
        {&OPEN-QUERY-brNotas}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile C-Win
ON CHOOSE OF btFile IN FRAME fPage0
DO:
/*     {report/rparq.i} */
    def var c-arq-conv  as char no-undo.
    DEF VAR l-ok        AS LOG NO-UNDO.

    assign c-arq-conv = replace(input frame fPage0 cFile, "/", CHR(92))
           c-arq-conv = SUBSTRING(c-arq-conv,1,1) + REPLACE(SUBSTRING(c-arq-conv,2),"~\~\","~\").
          
     SYSTEM-DIALOG GET-FILE c-arq-conv
        FILTERS "*.lst" "*.lst",
                "*.*" "*.*"
        ASK-OVERWRITE
        DEFAULT-EXTENSION "lst"
        INITIAL-DIR "spool"
        SAVE-AS
        USE-FILENAME
        UPDATE l-ok.
                     
    if  l-ok = yes then do:
        assign cFile = replace(c-arq-conv, CHR(92), "/").
        display cFile with frame fPage0.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BTNota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BTNota C-Win
ON CHOOSE OF BTNota IN FRAME fPage0 /* Buscar Notas */
DO:
    RUN vaidateScreen.
    IF RETURN-VALUE = "NOK" THEN
        RETURN NO-APPLY.
    RUN openQuery.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCd-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCd-oper C-Win
ON F5 OF fiCd-oper IN FRAME fPage0 /* Atendente */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es013.w"
                          &FieldZoom1="cd-oper"
                          &FieldScreen1="fiCd-oper"
                          &Frame1="fPage0"
                          &FieldZoom2="nm-oper"
                          &FieldScreen2="fiDesc1"
                          &Frame2="fPage0"
                          &EnableImplant="no"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCd-oper C-Win
ON LEAVE OF fiCd-oper IN FRAME fPage0 /* Atendente */
DO:
    if input frame fPage0 fiCd-oper <> 0 then do:
         find first atendente
               where atendente.cod = input frame fPage0 fiCd-oper no-lock no-error.

        IF AVAIL atendente THEN
            ASSIGN fiDesc1:SCREEN-VALUE IN FRAME fPage0 = atendente.nm-ope.
        ELSE 
             ASSIGN fiDesc1:SCREEN-VALUE IN FRAME fPage0 = ''.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCd-oper C-Win
ON MOUSE-SELECT-DBLCLICK OF fiCd-oper IN FRAME fPage0 /* Atendente */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiDestinatario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDestinatario C-Win
ON F5 OF fiDestinatario IN FRAME fPage0 /* Destinat†rio */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/Z01AD098.w"
                       &campo=fiDestinatario
                       &campozoom=cod-emitente
                       &frame=fPage0}
                       WAIT-FOR CLOSE  OF wh-pesquisa.
           APPLY "LEAVE" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDestinatario C-Win
ON LEAVE OF fiDestinatario IN FRAME fPage0 /* Destinat†rio */
DO:
  FIND FIRST emitente
      WHERE emitente.cod-emitente = INPUT FRAME fpage0  fiDestinatario NO-LOCK NO-ERROR.
  IF AVAIL emitente THEN
      ASSIGN fiDesc-2:SCREEN-VALUE IN frame fPage0 = emitente.nome-abrev.
  ELSE 

      ASSIGN fiDesc-2:SCREEN-VALUE IN frame fPage0 = "Destinat†rio n∆o cadastrado".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDestinatario C-Win
ON MOUSE-SELECT-DBLCLICK OF fiDestinatario IN FRAME fPage0 /* Destinat†rio */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiEstab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiEstab C-Win
ON F5 OF fiEstab IN FRAME fPage0 /* Estabelecimento */
DO:
   {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                          &campo=fiEstab
                          &campozoom=cod-estabel
                          &frame={&frame-name}}.
                       
   WAIT-FOR CLOSE  OF wh-pesquisa.
           APPLY "LEAVE" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiEstab C-Win
ON LEAVE OF fiEstab IN FRAME fPage0 /* Estabelecimento */
DO:
  
    IF tb-gera-danfe-xml:CHECKED IN FRAME fPage0  THEN DO:

       ENABLE fi-dir-historico-xml WITH FRAME fPage0.
       ENABLE bt-dir-hist-xml WITH FRAME fPage0.

       RUN cdp/cd0360b.p (INPUT fiEstab:SCREEN-VALUE IN FRAME fPage0,
                          INPUT "NF-e",
                          OUTPUT tp-integ).

       if  tp-integ = "TC2" then do:

           FOR FIRST param-gener NO-LOCK WHERE
                     param-gener.cod-chave-1 = "param-geral-tc":U AND
                     param-gener.cod-param   = "dir-doctos-lidos":U /*Pasta Received*/ : 

               ASSIGN fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 = param-gener.cod-valor .

               IF  SUBSTRING(fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0, LENGTH(fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0), 1) <> "\" THEN
                   ASSIGN fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 = fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 + "\".
               ASSIGN fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 = fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 + "RECEIVED\".
           END.
           IF  NOT AVAIL param-gener THEN
               ASSIGN fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 = "".

       END.
       ELSE DO:

           FIND FIRST param-nf-estab 
                WHERE param-nf-estab.cod-estabel = fiEstab:SCREEN-VALUE IN FRAME fPage0 NO-LOCK NO-ERROR.
           IF  AVAIL param-nf-estab THEN DO:               
               ASSIGN fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 = param-nf-estab.cod-caminho-xml.
           END.
           ELSE
               ASSIGN fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 = "".

       END.   
    END.    
    ELSE DO: 

       DISABLE fi-dir-historico-xml WITH FRAME fPage0.
       DISABLE bt-dir-hist-xml WITH FRAME fPage0.
       ASSIGN fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 = "".

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiEstab C-Win
ON MOUSE-SELECT-DBLCLICK OF fiEstab IN FRAME fPage0 /* Estabelecimento */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-nr-copias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-copias C-Win
ON LEAVE OF i-nr-copias IN FRAME fPage0 /* Nr C¢pias */
DO:

    IF  i-nr-copias:SCREEN-VALUE IN FRAME fPage0 = "0" OR 
        i-nr-copias:SCREEN-VALUE IN FRAME fPage0 = "?" THEN
        ASSIGN i-nr-copias:SCREEN-VALUE IN FRAME fPage0 = "1".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny C-Win
ON ANY-KEY OF rsDestiny IN FRAME fPage0
DO:
    BELL.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny C-Win
ON MOUSE-SELECT-CLICK OF rsDestiny IN FRAME fPage0
DO:
    DO WITH FRAME fPage0:
       case self:screen-value:
            when "1":U then do:
                assign cFile:sensitive         = NO 
                       cFile:visible           = NO
                       btFile:visible          = NO
                       cbImpr:visible          = YES.
            end.
            when "2":U then do:
                assign cFile:sensitive       = yes
                       cFile:visible         = yes
                       btFile:visible        = YES
                       cbImpr:visible        = NO.
            end.
            when "3":U then do:
                assign cFile:visible         = no
                       cFile:sensitive       = no
                       btFile:visible        = NO
                       cbImpr:visible        = NO.
            END.
        end case.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny C-Win
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage0
DO:
    DO WITH FRAME fPage0:
       case self:screen-value:
            when "1":U then do:
                assign cFile:sensitive         = NO 
                       cFile:visible           = NO
                       btFile:visible          = NO
                       cbImpr:visible          = YES.
            end.
            when "2":U then do:
                assign cFile:sensitive       = yes
                       cFile:visible         = yes
                       btFile:visible        = YES
                       cbImpr:visible        = NO.
            end.
            when "3":U then do:
                assign cFile:visible         = no
                       cFile:sensitive       = no
                       btFile:visible        = NO
                       cbImpr:visible        = NO.
            END.
        end case.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-gera-danfe-xml
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-gera-danfe-xml C-Win
ON VALUE-CHANGED OF tb-gera-danfe-xml IN FRAME fPage0 /* Gera DANFE a partir do XML */
DO:  
    IF fiEstab:SCREEN-VALUE IN FRAME fPage0 = "" THEN DO:
       
        run utp/ut-msgs.p (input "show":U,
                           INPUT 53327,
                           input "").
       
       ASSIGN tb-gera-danfe-xml:CHECKED IN FRAME fPage0 = NO.
       
    END. 
    ELSE 
    IF rsImprime:SCREEN-VALUE IN FRAME fPage0 = "1":U THEN DO:
         run utp/ut-msgs.p (input "show":U,
                           INPUT 53800,
                           input "").
                           
        ASSIGN tb-gera-danfe-xml:CHECKED IN FRAME fPage0 = NO.
    END.    
    ELSE DO:
          IF tb-gera-danfe-xml:CHECKED IN FRAME fPage0  THEN DO:
              
             ENABLE fi-dir-historico-xml WITH FRAME fPage0.
             ENABLE bt-dir-hist-xml WITH FRAME fPage0.

             RUN cdp/cd0360b.p (INPUT fiEstab:SCREEN-VALUE IN FRAME fPage0,
                                INPUT "NF-e",
                                OUTPUT tp-integ).
           
             if  tp-integ = "TC2" then do:
        
                 FOR FIRST param-gener NO-LOCK WHERE
                     param-gener.cod-chave-1 = "param-geral-tc":U AND
                     param-gener.cod-param   = "dir-doctos-lidos":U /*Pasta Received*/ : 
        
                     ASSIGN fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 = param-gener.cod-valor .
        
                     IF  SUBSTRING(fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0, LENGTH(fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0), 1) <> "\" THEN
                         ASSIGN fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 = fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 + "\".
                     ASSIGN fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 = fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 + "RECEIVED\".
                 END.
                 IF  NOT AVAIL param-gener THEN
                     ASSIGN fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 = "".
        
             END.
             ELSE DO:

                 FIND FIRST param-nf-estab 
                      WHERE param-nf-estab.cod-estabel = fiEstab:SCREEN-VALUE IN FRAME fPage0 NO-LOCK NO-ERROR.
                 IF AVAIL param-nf-estab THEN DO:               
                     ASSIGN fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 = param-nf-estab.cod-caminho-xml.
                                                                               
                 END.   
                 ELSE
                    ASSIGN fi-dir-historico-xml:SCREEN-VALUE IN FRAME fPage0 = "".    
             END.
          END.    
          ELSE DO:   
           
             DISABLE fi-dir-historico-xml with frame fPage0.
             DISABLE bt-dir-hist-xml with frame fPage0.
             ASSIGN fi-dir-historico-xml:screen-value in frame fPage0 = "".
             
          END.
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

fiEstab:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
fiDestinatario:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
fiCd-oper:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  RUN getPrinter.
  ASSIGN fiDataIni:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 10,'99/99/9999')
         fiDataFim:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,'99/99/9999').

    ASSIGN cbImpr:LIST-ITEMS   IN FRAME fPage0 = SESSION:GET-PRINTERS() NO-ERROR. /* Localiza Impressoras do Windows */
    ASSIGN cbImpr:SCREEN-VALUE IN FRAME fPage0 = SESSION:PRINTER-NAME NO-ERROR. /* Impressora default como padr∆o  */
    IF  cbImpr:SCREEN-VALUE IN FRAME fPage0 = ""
    OR  cbImpr:SCREEN-VALUE IN FRAME fPage0 = ? THEN
        ASSIGN cbImpr:SCREEN-VALUE IN FRAME fPage0 = ENTRY(1,cbImpr:LIST-ITEMS IN FRAME fPage0) NO-ERROR.
      /*cbImpr:LIST-ITEMS = fnImpressora().*/
  
  APPLY "value-changed" TO rsDestiny IN FRAME {&FRAME-NAME}.
  

  /*da-dt-saida:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,'99/99/9999').
  c-hr-saida:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TIME,'HH:MM:SS').*/

  ASSIGN  v-cod-prog-gerado = "FT0527":U.
  find usuar_mestre where usuar_mestre.cod_usuario = c-seg-usuario no-lock no-error.
  IF NOT CAN-FIND(FIRST funcao NO-LOCK
                  WHERE funcao.cd-funcao = "spp-danfe"
                  AND   funcao.ativo) THEN DO:
      if avail usuar_mestre then
          assign cFile:SCREEN-VALUE IN FRAME fPage0 = if length(usuar_mestre.nom_subdir_spool) <> 0
              then caps(replace(usuar_mestre.nom_dir_spool, "~\", "~/") + "~/" + replace(usuar_mestre.nom_subdir_spool, "~\", "~/") + "~/" + v-cod-prog-gerado + "~." + v-cod-extens-arq)
              else caps(replace(usuar_mestre.nom_dir_spool, "~\", "~/") + "~/" + v-cod-prog-gerado + "~." + v-cod-extens-arq).
      else
          assign cFile:SCREEN-VALUE IN FRAME fPage0 = caps("spool~/" + v-cod-prog-gerado + "~." + v-cod-extens-arq).
  END.
  ELSE DO:
      if avail usuar_mestre then
          assign cFile:SCREEN-VALUE IN FRAME fPage0 = if length(usuar_mestre.nom_subdir_spool) <> 0
              then caps(replace(usuar_mestre.nom_dir_spool, "~\", "~/") + "~/" + replace(usuar_mestre.nom_subdir_spool, "~\", "~/") + "~/" + v-cod-prog-gerado + string(RANDOM(1,9999999)) + "~." + v-cod-extens-arq)
              else caps(replace(usuar_mestre.nom_dir_spool, "~\", "~/") + "~/" + v-cod-prog-gerado + string(RANDOM(1,9999999)) + "~." + v-cod-extens-arq).
      else
          assign cFile:SCREEN-VALUE IN FRAME fPage0 = caps("spool~/" + v-cod-prog-gerado + string(RANDOM(1,9999999)) + "~." + v-cod-extens-arq).
  END.

  IF VALID-HANDLE (h-facelift) THEN
    RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage0:HANDLE).

  c-arq-old = cFile.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY fiCd-oper fiDesc1 fiEstab rsImprime fiDestinatario fiDesc-2 fiEmbarque 
          fiDataIni fiDataFim FIsERIE fiEstado fiNota fiNatureza fiUsuario 
          tgFatur tb-gera-danfe-xml fi-dir-historico-xml da-dt-saida rsDestiny 
          c-hr-saida cbImpr cFile i-nr-copias fiOpcao FILL-IN-8 text-destino 
      WITH FRAME fPage0 IN WINDOW C-Win.
  ENABLE IMAGE-21 IMAGE-22 RECT-17 RECT-18 RECT-20 RECT-21 RECT-22 RECT-93 
         RECT-7 RECT-101 RECT-102 RECT-103 RECT-100 fiCd-oper fiEstab rsImprime 
         fiDestinatario fiEmbarque fiDataIni fiDataFim FIsERIE fiEstado fiNota 
         BTNota fiNatureza fiUsuario tgFatur brNotas bt-marca bt-desmarca 
         bt-todos bt-des-all bt-sair bt-impr tb-gera-danfe-xml bt-dir-hist-xml 
         fi-dir-historico-xml da-dt-saida rsDestiny c-hr-saida cbImpr btFile 
         cFile i-nr-copias fiOpcao FILL-IN-8 text-destino 
      WITH FRAME fPage0 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPrinter C-Win 
PROCEDURE getPrinter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery C-Win 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* MESSAGE  "INPUT FRAME fPage0 fiEstab            " INPUT FRAME fPage0 fiEstab            SKIP */
/*          "INPUT FRAME fPage0 fiDataIni          " INPUT FRAME fPage0 fiDataIni          SKIP */
/*          "INPUT FRAME fPage0 fiDataFim          " INPUT FRAME fPage0 fiDataFim          SKIP */
/*          "INPUT FRAME fPage0 fiDestinatario     " INPUT FRAME fPage0 fiDestinatario     SKIP */
/*          "INPUT FRAME fPage0 FIsERIE            " INPUT FRAME fPage0 FIsERIE            SKIP */
/*          "INPUT FRAME fPage0 fiEmbarque         " INPUT FRAME fPage0 fiEmbarque         SKIP */
/*          "INPUT frame fPage0 fiCd-oper          " INPUT frame fPage0 fiCd-oper          SKIP */
/*          "INPUT tgFatur:checked in frame fpage0 " INPUT tgFatur:checked in frame fpage0 SKIP */
/*          "INPUT FRAME fPage0 rsImprime          " INPUT FRAME fPage0 rsImprime          SKIP */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                       */

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
EMPTY TEMP-TABLE ttNotas.
RUN pi-inicializar in h-acomp (input "Selecioando Notas").

 FOR EACH nota-fiscal FIELDS (user-calc idi-sit-nf-eletro dt-emis-not cod-emitente ind-sit-nota serie cdd-embarq  nome-transp nr-nota-fis nr-pedcli nome-ab-cli cod-estabel idi-forma-emis-nf-eletro estado nat-operacao) USE-INDEX nfftrm-20 NO-LOCK
    WHERE nota-fiscal.cod-estabel   = INPUT FRAME fPage0 fiEstab
      AND nota-fiscal.dt-emis-nota >= INPUT FRAME fPage0 fiDataIni
      AND nota-fiscal.dt-emis-nota <= INPUT FRAME fPage0 fiDataFim:

     IF  INPUT FRAME fPage0 fiNota <> ""
     AND INPUT FRAME fPage0 fiNota <> nota-fiscal.nr-nota-fis THEN
         NEXT.

     IF  INPUT FRAME fPage0 fiUsuario <> ""
     AND INPUT FRAME fPage0 fiusuario <> nota-fiscal.user-calc THEN
         NEXT.

     IF  INPUT FRAME fPage0 fiEstado <> ""
     AND INPUT FRAME fPage0 fiEstado <> nota-fiscal.estado THEN
         NEXT.

     IF  INPUT FRAME fPage0 fiNatureza <> ""
     AND INPUT FRAME fPage0 fiNatureza <> nota-fiscal.nat-operacao THEN
         NEXT.


     IF nota-fiscal.idi-sit-nf-eletro = 0  THEN
         NEXT.

     IF (nota-fiscal.idi-forma-emis-nf-eletro  = 1        /* Tipo de Emissío   = Normal                  */
         AND nota-fiscal.idi-sit-nf-eletro        <> 3 )      /* Situaá∆o da nota <> Uso Autorizado          */
         OR (nota-fiscal.idi-forma-emis-nf-eletro  = 4        /* Tipo de Emiss∆o   = Contingencia DPEC       */
         AND nota-fiscal.idi-sit-nf-eletro        <> 15       /* Situaá∆o da nota <> DPEC recebido pelo SCE  */
         AND nota-fiscal.idi-sit-nf-eletro        <> 3 )      /* Situaá∆o da nota <> Uso Autorizado          */
         OR (nota-fiscal.idi-forma-emis-nf-eletro <> 1        /* Tipo de Emiss∆o  <> Normal                  */
         AND nota-fiscal.idi-forma-emis-nf-eletro <> 4        /* Tipo de Emiss∆o  <> Contingencia DPEC       */
         AND nota-fiscal.idi-sit-nf-eletro         = 5 ) THEN /* Situaá∆o da nota  = Documento Rejeitado     */
            NEXT.

     IF INPUT FRAME fPage0 fiDestinatario <> 0 THEN DO:
         IF nota-fiscal.cod-emitente <> INPUT FRAME fPage0 fiDestinatario THEN NEXT.
     END.
     FIND FIRST emitente WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.

     IF INPUT FRAME fPage0 FIsERIE <> '' THEN DO:
        IF nota-fiscal.serie <> INPUT FRAME fPage0 FIsERIE THEN NEXT.
     END.

     IF INPUT FRAME fPage0 fiEmbarque <> 0 THEN DO:
        IF nota-fiscal.cdd-embarq <> INPUT FRAME fPage0 fiEmbarque THEN NEXT.
     END.

     if input frame fPage0 fiCd-oper <> 0 then do:
    
        FIND FIRST atendente
             WHERE atendente.cod = input frame fPage0 fiCd-oper no-lock no-error.
        
        FIND FIRST ped-venda
             WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli  
               AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli 
               AND int(ped-venda.tp-pedido) = input frame fPage0 fiCd-oper NO-LOCK NO-ERROR.

        IF AVAIL ped-venda THEN DO:
            FIND FIRST mgesp.atendente
                WHERE atendente.cd-oper = int(ped-venda.tp-pedido) NO-LOCK NO-ERROR.
        END.
        Else next.
       
     end.
     ELSE DO:

        find first atendente
               where atendente.cod = input frame fPage0 fiCd-oper no-lock no-error.

     END.

     IF INPUT FRAME fPage0 rsImprime = 1 THEN DO:
         IF nota-fiscal.ind-sit-nota > 1 THEN NEXT.
     END.
     ELSE DO:
          IF nota-fiscal.ind-sit-nota < 2 THEN NEXT.
     END.

     run pi-acompanhar in h-acomp (input "Nota fiscal: " + nota-fiscal.nr-nota-fis).

     FIND FIRST ped-venda NO-LOCK
          WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli  
            AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.

     IF AVAIL ped-venda THEN DO:
        IF NOT INPUT tgFatur:CHECKED IN FRAME fpage0 THEN
            NEXT.
     END.
     ELSE DO:
         IF INPUT tgFatur:CHECKED IN FRAME fpage0 THEN
            NEXT.
     END.

     FIND FIRST atendente NO-LOCK
          WHERE atendente.cd-oper = INT(ped-venda.tp-pedido) NO-ERROR.

     CREATE ttNotas.
     ASSIGN ttNotas.lok          = NO
            ttNotas.limp         = IF nota-fiscal.ind-sit-nota > 1 THEN YES ELSE NO
            ttNotas.cod-estabel  = nota-fiscal.cod-estabel
            ttNotas.nr-nota-fis  = nota-fiscal.nr-nota-fis
            ttNotas.cod-emitente = nota-fiscal.cod-emitente
            ttNotas.nome         = IF AVAIL emitente THEN emitente.nome-abrev ELSE ''
            ttNotas.cdd-embarq   = nota-fiscal.cdd-embarq 
            ttNotas.serie        = nota-fiscal.serie
            ttNotas.dt-emis-nota = nota-fiscal.dt-emis-nota
            ttNotas.nome-transp  = nota-fiscal.nome-transp
            ttNotas.idi-sit-nf-eletro  = nota-fiscal.idi-sit-nf-eletro
            ttNotas.cd-oper      = if avail atendente then  atendente.cd-oper ELSE 0
            ttNotas.nm-oper      = if avail atendente then  atendente.nm-oper else ''
            ttNotas.estado       = nota-fiscal.estado
            ttNotas.nat-operacao = nota-fiscal.nat-operacao.
 END.

RUN pi-finalizar IN h-acomp.

{&OPEN-QUERY-brNotas}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE printDocument C-Win 
PROCEDURE printDocument :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 IF brNotas:NUM-SELECTED-ROWS IN FRAME fPage0 > 0 THEN DO:
     
     IF NOT CAN-FIND(FIRST ttNotas 
                     WHERE ttNotas.LOK = YES) THEN DO:

         RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "N∆o foram selecionadas notas para a impress∆o!":U).

         RETURN "NOK".

     END.
     if input frame fPage0 rsDestiny = 2 then
            do:
                run utp/ut-vlarq.p (input input frame fPage0 cFile).
                if return-value = "NOK":U then
                do:
                    run utp/ut-msgs.p (input "show":U,
                                       input 73,
                                       input "":U).
                    apply "ENTRY":U to cFile in frame fPage0.
                    return error.
                END.
     END.

     /*Cria tt-param*/
     EMPTY TEMP-TABLE tt-param-aux.
     
     CREATE tt-param-aux.
     ASSIGN tt-param-aux.usuario              = c-seg-usuario
            tt-param-aux.destino              = input frame fPage0 rsDestiny
            tt-param-aux.data-exec            = today
            tt-param-aux.hora-exec            = time
            tt-param-aux.v_num_tip_aces_usuar = v_num_tip_aces_usuar
            tt-param-aux.ep-codigo            = i-ep-codigo-usuario
            tt-param-aux.da-dt-saida          = input frame fPage0 da-dt-saida
            tt-param-aux.c-hr-saida           = input frame fPage0 c-hr-saida
            tt-param-aux.nr-copias            = input frame fPage0 i-nr-copias
            tt-param-aux.imprime-bloq         = NO
            tt-param-aux.rs-imprime           = input frame fPage0 rsImprime
            tt-param-aux.impressora-so        = cbImpr:SCREEN-VALUE IN FRAME fPage0
            tt-param-aux.impressora-so-bloq   = ''
            tt-param-aux.l-gera-danfe-xml     = logical(tb-gera-danfe-xml:screen-value in frame fPage0)
            tt-param-aux.c-dir-hist-xml       = fi-dir-historico-xml:screen-value in frame fPage0
            tt-param-aux.ind-execucao         = 1. /*online*/
 
     FIND FIRST ser-estab NO-LOCK
          WHERE ser-estab.cod-estabel  = fiEstab:SCREEN-VALUE IN FRAME fPage0
            AND ser-estab.serie        = FIsERIE:SCREEN-VALUE IN FRAME fPage0 NO-ERROR.
     
     IF  AVAIL ser-estab THEN DO:

         IF &if "{&bf_dis_versao_ems}"  >=  "2.07":U &then
                ser-estab.idi-format-emis-danfe = 1 OR 
                ser-estab.idi-format-emis-danfe = 2 
            &else
                INT(SUBSTRING(ser-estab.char-1,4,01)) = 1 OR
                INT(SUBSTRING(ser-estab.char-1,4,01)) = 2  
            &endif
         THEN DO:
            run utp/ut-msgs.p (input "show",
                                INPUT 52042,
                                input "").
            return error.
         end.

         &if "{&bf_dis_versao_ems}"  >=  "2.07":U &then
            IF ser-estab.idi-format-emis-danfe = 1 THEN
                 ASSIGN tt-param-aux.cod-layout = "DANFE-Mod.1":U.
            ELSE
                IF ser-estab.idi-format-emis-danfe = 2 THEN
                     ASSIGN tt-param-aux.cod-layout = "DANFE-Mod.2":U.
         &else
            IF INT(SUBSTRING(ser-estab.char-1,4,01)) = 1 THEN
                ASSIGN tt-param-aux.cod-layout = "DANFE-Mod.1":U.
            ELSE
                IF INT(SUBSTRING(ser-estab.char-1,4,01)) = 2 THEN
                    ASSIGN tt-param-aux.cod-layout = "DANFE-Mod.2":U.
        &endif
     END.

     IF tt-param-aux.cod-layout = "" THEN
        ASSIGN tt-param-aux.cod-layout = "DANFE-Mod.1":U.


     if  tt-param-aux.destino = 2 then
         assign tt-param-aux.arquivo = input frame fPage0 cFile.
     else
         IF NOT CAN-FIND(FIRST funcao NO-LOCK
             WHERE funcao.cd-funcao = "spp-danfe":U
             AND   funcao.ativo) THEN
             assign tt-param-aux.arquivo = session:temp-directory + "FT0527":U + REPLACE(STRING(TODAY,"99/99/99"),"/","") + REPLACE(STRING(TIME,"HH:MM:SS"),":","") + "." + v-cod-extens-arq.
         ELSE
             assign tt-param-aux.arquivo = session:temp-directory + "FT0527":U + REPLACE(STRING(TODAY,"99/99/99"),"/","") + REPLACE(STRING(TIME,"HH:MM:SS"),":","") + string(RANDOM(1,9999999)) + "." + v-cod-extens-arq.
     
     ASSIGN raw-param = ?.
     raw-transfer tt-param-aux to raw-param.

     /**Cria tt-digita**/
     EMPTY TEMP-TABLE tt-digita.
     FOR EACH ttNotas 
         WHERE ttNotas.LOK = YES
         BREAK  BY ttNotas.dt-emis-not
                BY ttNotas.nr-nota-fis
                BY ttNotas.serie:

         CREATE tt-digita.            
         ASSIGN tt-digita.cod-estabel = ttNotas.cod-estabel
                tt-digita.serie       = ttNotas.serie      
                tt-digita.nr-nota-fis = ttNotas.nr-nota-fis
                tt-digita.cdd-embarq  = ttNotas.cdd-embarq.
     END.

     EMPTY TEMP-TABLE tt-raw-digita.
     FOR EACH tt-digita:
         CREATE tt-raw-digita.
         RAW-TRANSFER tt-digita to tt-raw-digita.raw-digita.
     END. 

     run esp/ftp/esftp0527rp.p (input raw-param, input table tt-raw-digita).

     FOR EACH tt-digita:
         FIND FIRST nota-fiscal NO-LOCK 
              WHERE nota-fiscal.cod-estabel = tt-digita.cod-estabel     
                AND nota-fiscal.nr-nota-fis = tt-digita.nr-nota-fis     
                AND nota-fiscal.serie       = tt-digita.serie NO-ERROR.

         FIND FIRST ttNotas NO-LOCK 
              WHERE ttNotas.cod-estabel = tt-digita.cod-estabel     
                AND ttNotas.nr-nota-fis = tt-digita.nr-nota-fis     
                AND ttNotas.serie       = tt-digita.serie NO-ERROR.

         IF AVAIL  nota-fiscal THEN DO:
             IF nota-fiscal.ind-sit-nota > 1 THEN 
                 ASSIGN  ttNotas.lImp = YES.
         END.
     END.
END.

IF CAN-FIND (FIRST   ttNotas )THEN
 {&OPEN-QUERY-brNotas}



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE vaidateScreen C-Win 
PROCEDURE vaidateScreen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF INPUT FRAME fPage0 fiEstab = '' THEN DO:


    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Estabelecimento deve ser informado!":U).

    APPLY "ENTRY" TO fiEstab IN FRAME fPage0.
    RETURN "NOK".


END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnimp C-Win 
FUNCTION fnimp RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-lista AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-layout AS CHARACTER   NO-UNDO.
FOR FIRST imprsor_usuar no-lock
        where imprsor_usuar.cod_usuario  = c-seg-usuario:
    find FIRST impressora  of imprsor_usuar no-lock no-error.
    IF AVAIL impressora THEN DO:
        ASSIGN c-layout = ''.
        for FIRST layout_impres no-lock 
             where layout_impres.nom_impressora = imprsor_usuar.nom_impressora:
             assign c-layout =  layout_impres.cod_layout_impres.
        END.
        assign c-lista = c-lista + trim(impressora.nom_impressora) + ":" + c-layout.
   end.

/*     assign c-lista = trim(imprsor_usuar.nom_disposit_so).  */
END.

    
    return c-lista.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnImpressora C-Win 
FUNCTION fnImpressora RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-lista AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-layout AS CHARACTER   NO-UNDO.
FOR EACH imprsor_usuar no-lock
        where imprsor_usuar.cod_usuario  = c-seg-usuario:
    find FIRST impressora  of imprsor_usuar no-lock no-error.
    IF AVAIL impressora THEN
/*     assign c-lista = c-lista + trim(imprsor_usuar.nom_disposit_so) + ",".  */

   for FIRST layout_impres no-lock where layout_impres.nom_impressora = imprsor_usuar.nom_impressora:
      assign c-layout =  layout_impres.cod_layout_impres.
    end.
    assign c-lista = c-lista + trim(impressora.nom_impressora) + ":" + c-layout + ",".

END.

    

    assign c-lista = substring(c-lista,1,length(c-lista) - 1).

    return c-lista.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSitNfEltro C-Win 
FUNCTION fnSitNfEltro RETURNS CHARACTER
  ( p-idi-sit-nf-eletro AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-return AS CHARACTER   NO-UNDO.

  ASSIGN c-return = {diinc/i01di135.i 04 p-idi-sit-nf-eletro}.

  RETURN c-return.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

