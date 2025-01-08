&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp010 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esftp010
&GLOBAL-DEFINE Version        2.00.00.001
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Parƒmetro,Digita‡Æo,ImpressÆo

&GLOBAL-DEFINE PGLAY          
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          

&GLOBAL-DEFINE page0Widgets   btOk btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page5Widgets   dtEmis-ini dtEmis-end brDigita btAdd btUpdate btDelete btSave btOpen 
&GLOBAL-DEFINE page6Widgets   rsDestiny btConfigImpr btFile rsExecution
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    iNr-embarque-ini iNr-embarque-end iNr-resumo-ini iNr-resumo-end rsRastreabilidade rsTpVolume ed-notas-desconsiderar ~
                              c-itCodigo-ini c-itCodigo-fim c-itCodigo-ini-2 c-itCodigo-fim-2
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    lReimpressao lImpr-params tg-ordenacao-item iNome-transp l-central l-estado list-estado l-class fi-uf-origem 
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino             AS INTEGER
    FIELD arquivo             AS CHARACTER FORMAT "x(35)":U
    FIELD usuario             AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec           AS DATE
    FIELD hora-exec           AS INTEGER
    FIELD nr-embarque-ini     LIKE pre-fatur.cdd-embarq
    FIELD nr-embarque-end     LIKE pre-fatur.cdd-embarq
    FIELD nr-resumo-ini       LIKE pre-fatur.nr-resumo
    FIELD nr-resumo-end       LIKE pre-fatur.nr-resumo
    FIELD rastreabilidade     AS INTEGER
    FIELD tipo-volume         AS INTEGER
    FIELD nome-transp         LIKE pre-fatur.nome-transp
    FIELD dt-emis-nf-ini      LIKE nota-fiscal.dt-emis-nota
    FIELD dt-emis-nf-end      LIKE nota-fiscal.dt-emis-nota
    FIELD it-codigo-ini       LIKE it-nota-fisc.it-codigo
    FIELD it-codigo-fim       LIKE it-nota-fisc.it-codigo
    FIELD it-codigo-ini-2     LIKE it-nota-fisc.it-codigo
    FIELD it-codigo-fim-2     LIKE it-nota-fisc.it-codigo
    FIELD l-centrais          AS LOGICAL
    FIELD reimpressao         AS LOGICAL FORMAT "Sim/NÆo":U
    FIELD impr-params         AS LOGICAL
    FIELD notas-mg            AS INTEGER
    FIELD l-estado            AS LOGICAL
    FIELD c-estado            AS CHARACTER
    FIELD l-class             AS LOG
    FIELD cod-estabel         AS CHAR
    FIELD notas-desconsiderar AS CHAR
    FIELD ordenacao-item      AS LOGICAL.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel    INITIAL '101'
    FIELD serie             LIKE nota-fiscal.serie          INITIAL '3'
    FIELD nr-nota-fis-ini   LIKE nota-fiscal.nr-nota-fis    COLUMN-LABEL 'NF Ini'
    FIELD nr-nota-fis-end   LIKE nota-fiscal.nr-nota-fis    COLUMN-LABEL 'NF Fim'
    INDEX idNotas IS PRIMARY cod-estabel serie nr-nota-fis-ini.


def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-lista            AS CHAR    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
def stream s-imp.
{upc/btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDigita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE brDigita                                      */
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.cod-estab tt-digita.serie tt-digita.nr-nota-fis-ini tt-digita.nr-nota-fis-end   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.cod-estab ~
tt-digita.serie ~
tt-digita.nr-nota-fis-ini ~
tt-digita.nr-nota-fis-end   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigita tt-digita
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY brDigita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita tt-digita


/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brDigita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE ed-notas-desconsiderar AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 51 BY 4.42 NO-UNDO.

DEFINE VARIABLE c-itCodigo-fim AS CHARACTER FORMAT "X(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE c-itCodigo-fim-2 AS CHARACTER FORMAT "X(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE c-itCodigo-ini AS CHARACTER FORMAT "X(16)" 
     LABEL "Itens":R11 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE c-itCodigo-ini-2 AS CHARACTER FORMAT "X(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     LABEL "Itens Ignorar":R11 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE iNr-embarque-end AS INTEGER FORMAT ">>>>,>>9" INITIAL 9999999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE iNr-embarque-ini AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 
     LABEL "Embarque":R10 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE iNr-resumo-end AS INTEGER FORMAT ">>>>,>>9" INITIAL 9999999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE iNr-resumo-ini AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 
     LABEL "Nr Resumo":R11 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rsRastreabilidade AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Com Rastreabilidade", 1,
"Sem Rastreabilidade", 2,
"Ambos", 3
     SIZE 43.72 BY .88 NO-UNDO.

DEFINE VARIABLE rsTpVolume AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Fracionada", 1,
"Fechada", 2,
"Ambos", 3
     SIZE 33.14 BY .88 NO-UNDO.

DEFINE VARIABLE iNome-transp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Transportador" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE fi-uf-origem AS CHARACTER FORMAT "x(4)" 
     LABEL "UF Origem" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .88
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.72 BY 3.5.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.72 BY 1.58.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.72 BY 1.58.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40.29 BY 4.75.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37.43 BY 4.75.

DEFINE VARIABLE list-estado AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     SIZE 36 BY 3.83 TOOLTIP "Para selecionar mais de um estado deixe o CTRL pressionado" NO-UNDO.

DEFINE VARIABLE l-central AS LOGICAL INITIAL no 
     LABEL "Imprime as Centrais Telef“nicas" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE l-class AS LOGICAL INITIAL no 
     LABEL "Classificar por estado" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE l-estado AS LOGICAL INITIAL no 
     LABEL "Considera somente estados selecionados" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE lImpr-params AS LOGICAL INITIAL no 
     LABEL "Imprime sele‡Æo/parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY .58
     FONT 1 NO-UNDO.

DEFINE VARIABLE lReimpressao AS LOGICAL INITIAL no 
     LABEL "ReimpressÆo (Aten‡Æo ! A ReimpressÆo ‚ do ESTADO e NÇO do EMBARQUE !)" 
     VIEW-AS TOGGLE-BOX
     SIZE 74 BY .58
     FONT 1 NO-UNDO.

DEFINE VARIABLE tg-ordenacao-item AS LOGICAL INITIAL yes 
     LABEL "Respeitar Ordena‡Æo dos Itens" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .58 NO-UNDO.

DEFINE BUTTON btAdd 
     LABEL "Inserir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDelete 
     LABEL "Retirar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOpen 
     LABEL "Recuperar" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdate 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE VARIABLE dtEmis-end AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE dtEmis-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data de emissÆo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-digita.cod-estab
      tt-digita.serie
      tt-digita.nr-nota-fis-ini
      tt-digita.nr-nota-fis-end
    ENABLE
      tt-digita.cod-estab
      tt-digita.serie
      tt-digita.nr-nota-fis-ini
      tt-digita.nr-nota-fis-end
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 6.5
         BGCOLOR 15 FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage2
     iNr-embarque-ini AT ROW 2 COL 25.86 COLON-ALIGNED HELP
          "Embarque"
     iNr-embarque-end AT ROW 2 COL 51 COLON-ALIGNED HELP
          "Embarque" NO-LABEL
     iNr-resumo-ini AT ROW 3 COL 25.86 COLON-ALIGNED HELP
          "N£mero da chave do resumo gerado para o calculo de notas fiscais"
     iNr-resumo-end AT ROW 3 COL 51 COLON-ALIGNED HELP
          "N£mero da chave do resumo gerado para o calculo de notas fiscais" NO-LABEL
     c-itCodigo-ini AT ROW 4 COL 16.86 COLON-ALIGNED HELP
          "Item a ser considerado" WIDGET-ID 8
     c-itCodigo-fim AT ROW 4 COL 51 COLON-ALIGNED HELP
          "Item a ser considerado" NO-LABEL WIDGET-ID 6
     c-itCodigo-ini-2 AT ROW 5 COL 16.86 COLON-ALIGNED HELP
          "Item a ser considerado" WIDGET-ID 12
     c-itCodigo-fim-2 AT ROW 5 COL 51 COLON-ALIGNED HELP
          "Item a ser considerado" NO-LABEL WIDGET-ID 10
     rsRastreabilidade AT ROW 6.13 COL 27.86 NO-LABEL
     rsTpVolume AT ROW 7.08 COL 27.86 NO-LABEL
     ed-notas-desconsiderar AT ROW 8.17 COL 27 NO-LABEL
     "Informe as notas separadas por virgula  ou por ifens quando for uma faixa." VIEW-AS TEXT
          SIZE 50 BY 1.25 AT ROW 12.5 COL 5
     "Itens:" VIEW-AS TEXT
          SIZE 4 BY .54 AT ROW 6.25 COL 23.72
     "Volumes:" VIEW-AS TEXT
          SIZE 6.57 BY .54 AT ROW 7.21 COL 21.14
     "Notas a Desconsiderar:" VIEW-AS TEXT
          SIZE 16 BY 1 AT ROW 7.83 COL 10
     "Ex: 5300-5400,5725,5800,6000-6100" VIEW-AS TEXT
          SIZE 28 BY 1.25 AT ROW 12.5 COL 56
     IMAGE-1 AT ROW 2 COL 40.43
     IMAGE-2 AT ROW 2 COL 49
     IMAGE-3 AT ROW 3 COL 40.43
     IMAGE-4 AT ROW 3 COL 49
     IMAGE-9 AT ROW 4 COL 40.43 WIDGET-ID 2
     IMAGE-10 AT ROW 4 COL 49 WIDGET-ID 4
     IMAGE-11 AT ROW 5 COL 40.43 WIDGET-ID 16
     IMAGE-12 AT ROW 5 COL 49 WIDGET-ID 14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.86 ROW 2.83
         SIZE 84 BY 13.17
         FONT 1.

DEFINE FRAME fPage4
     lReimpressao AT ROW 1.83 COL 5
     lImpr-params AT ROW 2.79 COL 5
     tg-ordenacao-item AT ROW 3.75 COL 5 HELP
          "Respeitar Ordena‡Æo dos Itens do programa ESFTP080"
     list-estado AT ROW 5.75 COL 5 HELP
          "Para selecionar mais de um estado deixe o CTRL pressionado" NO-LABEL
     l-estado AT ROW 7 COL 47
     l-class AT ROW 8.25 COL 77 RIGHT-ALIGNED
     fi-uf-origem AT ROW 10.25 COL 14 COLON-ALIGNED HELP
          "Unidade da Federa‡Æo"
     iNome-transp AT ROW 10.25 COL 38 COLON-ALIGNED
     l-central AT ROW 12.25 COL 5
     "Sele‡Æo de Estados" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 5 COL 4
     RECT-11 AT ROW 1.33 COL 2.72
     RECT-12 AT ROW 9.92 COL 2.72
     RECT-13 AT ROW 11.79 COL 2.72
     RECT-16 AT ROW 5 COL 2.72
     RECT-17 AT ROW 5 COL 43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.86 ROW 2.83
         SIZE 84 BY 13.17
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.86 ROW 2.83
         SIZE 84 BY 13.17
         FONT 1.

DEFINE FRAME fPage5
     dtEmis-ini AT ROW 2.17 COL 21.86 COLON-ALIGNED
     dtEmis-end AT ROW 2.17 COL 45.29 COLON-ALIGNED NO-LABEL
     brDigita AT ROW 3.33 COL 1.57
     btAdd AT ROW 9.83 COL 1.57
     btUpdate AT ROW 9.83 COL 11.86
     btDelete AT ROW 9.83 COL 22.14
     btSave AT ROW 9.83 COL 32.43
     btOpen AT ROW 9.83 COL 42.72
     "Incluir tamb‚m as seguintes Notas Fiscais nÆo pertencentes a embarques:" VIEW-AS TEXT
          SIZE 53.72 BY .54 AT ROW 1.33 COL 2.14
     IMAGE-7 AT ROW 2.17 COL 34.72
     IMAGE-8 AT ROW 2.17 COL 43.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.86 ROW 2.83
         SIZE 84 BY 13.17
         FONT 1.


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
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{Report\Report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR TOGGLE-BOX l-class IN FRAME fPage4
   ALIGN-R                                                              */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita dtEmis-end fPage5 */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigita
/* Query rebuild information for BROWSE brDigita
     _START_FREEFORM
OPEN QUERY brDigita FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDigita */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage5
/* Query rebuild information for FRAME fPage5
     _Query            is NOT OPENED
*/  /* FRAME fPage5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDigita
&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON DEL OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btDelete in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON END-ERROR OF brDigita IN FRAME fPage5
ANYWHERE 
DO:
    if  brDigita:new-row in frame fPage5 then do:
        if  avail tt-digita then
            delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then. 
    end.                                                               
    else do:
        get current brDigita.
        display tt-digita.cod-estab tt-digita.serie tt-digita.nr-nota-fis-ini tt-digita.nr-nota-fis-end with browse brDigita. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ENTER OF brDigita IN FRAME fPage5
ANYWHERE
DO:
  apply 'tab' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON INS OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-END OF brDigita IN FRAME fPage5
DO:
   apply 'entry' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-HOME OF brDigita IN FRAME fPage5
DO:
  apply 'entry' to btOpen in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5
DO:
    /*:T  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */
    
    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse brDigita tt-digita.cod-estab tt-digita.serie tt-digita.nr-nota-fis-ini tt-digita.nr-nota-fis-end.

        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-digita then
            assign input browse brDigita tt-digita.cod-estab tt-digita.serie tt-digita.nr-nota-fis-ini tt-digita.nr-nota-fis-end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wReport
ON CHOOSE OF btAdd IN FRAME fPage5 /* Inserir */
DO:
    assign btUpdate:SENSITIVE in frame fPage5 = yes
           btDelete:SENSITIVE in frame fPage5 = yes
           btSave:SENSITIVE   in frame fPage5 = yes.

    if num-results("brDigita":U) > 0 then
        brDigita:INSERT-ROW("after":U) in frame fPage5.
    else do transaction:
        create tt-digita.
        
        open query brDigita for each tt-digita.
        
        apply "entry":U to tt-digita.cod-estab in browse brDigita. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wReport
ON CHOOSE OF btConfigImpr IN FRAME fPage6
DO:
   {report/rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wReport
ON CHOOSE OF btDelete IN FRAME fPage5 /* Retirar */
DO:
    if  brDigita:num-selected-rows > 0 then do on error undo, return no-apply:
        get current brDigita.
        delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then.
    end.
    
    if num-results("brDigita":U) = 0 then
        assign btUpdate:SENSITIVE in frame fPage5 = no
               btDelete:SENSITIVE in frame fPage5 = no
               btSave:SENSITIVE   in frame fPage5 = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wReport
ON CHOOSE OF btFile IN FRAME fPage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOpen wReport
ON CHOOSE OF btOpen IN FRAME fPage5 /* Recuperar */
DO:
    {report/rprcd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wReport
ON CHOOSE OF btSave IN FRAME fPage5 /* Salvar */
DO:
   {report/rpsvd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wReport
ON CHOOSE OF btUpdate IN FRAME fPage5 /* Alterar */
DO:
   apply 'entry' to tt-digita.cod-estab in browse brDigita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME fi-uf-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-uf-origem wReport
ON ENTRY OF fi-uf-origem IN FRAME fPage4 /* UF Origem */
DO:
  self:private-data = self:screen-value.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-uf-origem wReport
ON F5 OF fi-uf-origem IN FRAME fPage4 /* UF Origem */
DO:
  {include/zoomvar.i &prog-zoom="unzoom/z01un007.w"
                     &campo=fi-uf-origem
                     &campozoom=estado}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-uf-origem wReport
ON LEAVE OF fi-uf-origem IN FRAME fPage4 /* UF Origem */
DO:
  if self:private-data ne self:screen-value then do:
    assign fi-uf-origem = input fi-uf-origem
           c-lista      = "".
/*     FOR EACH transporte NO-LOCK                                 */
/*         where transporte.estado = fi-uf-origem:                 */
/*         ASSIGN c-lista = c-lista + transporte.nome-abrev + ",". */
/*     END.                                                        */
/*                                                                 */
/*     ASSIGN c-lista = SUBSTRING(c-lista,1,LENGTH(c-lista) - 1)   */
/*            iNome-transp:LIST-ITEMS IN FRAME fPage4 = c-lista.   */
           


    ASSIGN c-lista = "".

    FOR EACH transporte NO-LOCK
        where transporte.estado = fi-uf-origem:
        ASSIGN c-lista = c-lista + transporte.nome-abrev + "," + transporte.nome-abrev + ",".
    END.
    


    ASSIGN c-lista = SUBSTRING(c-lista,1,LENGTH(c-lista) - 1)
           iNome-transp:LIST-ITEM-PAIRS IN FRAME fPage4 = c-lista. 




    self:screen-value = fi-uf-origem.       
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-uf-origem wReport
ON MOUSE-SELECT-DBLCLICK OF fi-uf-origem IN FRAME fPage4 /* UF Origem */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
do  with frame fPage6:
    case self:screen-value:
        when "1":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes.
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no.
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage6
DO:
   {report/rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
fi-uf-origem:load-mouse-pointer ("image\lupa.cur") in frame fPage4.
/* find first para-ped no-lock no-error. */
find first estabelec no-lock 
    where estabelec.cod-estabel = v_cod_estab_usuar no-error.
fi-uf-origem = estabelec.estado.    
FOR EACH transporte NO-LOCK
    where transporte.estado = estabelec.estado:
    ASSIGN c-lista = c-lista + transporte.nome-abrev + "," + transporte.nome-abrev + ",".
END.

ASSIGN c-lista = SUBSTRING(c-lista,1,LENGTH(c-lista) - 1)
       iNome-transp:LIST-ITEM-PAIRS IN FRAME fPage4 = c-lista. 


ON 'LEAVE':U OF tt-digita.nr-nota-fis-ini IN BROWSE brDigita DO:

    IF INPUT BROWSE brDigita tt-digita.nr-nota-fis-end = '' THEN
        DISPLAY INPUT BROWSE brDigita tt-digita.nr-nota-fis-ini @ tt-digita.nr-nota-fis-end
            WITH BROWSE brDigita.

END.


{report/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterEnableFields wReport 
PROCEDURE AfterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME fPage4:
    FOR EACH unid-feder
        WHERE unid-feder.pais = "brasil":
      list-estado:ADD-LAST(unid-feder.estado + " - " + unid-feder.no-estado).
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wReport 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN dtEmis-ini        = TODAY
           dtEmis-end        = TODAY
           rsRastreabilidade = 1
           rsTpVolume        = 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define var r-tt-digita as rowid no-undo.

/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}
    
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.


/*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.l-estado        = INPUT FRAME fPage4 l-estado
           tt-param.l-class         = INPUT FRAME fPage4 l-class
           tt-param.c-estado        = list-estado:SCREEN-VALUE IN FRAME fPage4
           tt-param.it-codigo-ini   = INPUT FRAME fPage2 c-itCodigo-ini
           tt-param.it-codigo-fim   = INPUT FRAME fPage2 c-itCodigo-fim
           tt-param.it-codigo-ini-2 = INPUT FRAME fPage2 c-itCodigo-ini-2
           tt-param.it-codigo-fim-2 = INPUT FRAME fPage2 c-itCodigo-fim-2.     

    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    ASSIGN tt-param.cod-estabel         = v_cod_estab_usuar
           tt-param.nr-embarque-ini     = INPUT FRAME fPage2 iNr-embarque-ini
           tt-param.nr-embarque-end     = INPUT FRAME fPage2 iNr-embarque-end
           tt-param.nr-resumo-ini       = INPUT FRAME fPage2 iNr-resumo-ini
           tt-param.nr-resumo-end       = INPUT FRAME fPage2 iNr-resumo-end
           tt-param.rastreabilidade     = INPUT FRAME fPage2 rsRastreabilidade
           tt-param.tipo-volume         = INPUT FRAME fPage2 rsTpVolume
           tt-param.dt-emis-nf-ini      = INPUT FRAME fPage5 dtEmis-ini
           tt-param.dt-emis-nf-end      = INPUT FRAME fPage5 dtEmis-end
           tt-param.l-centrais          = INPUT FRAME fPage4 l-central
           tt-param.reimpressao         = INPUT FRAME fPage4 lReimpressao
           tt-param.impr-params         = INPUT FRAME fPage4 lImpr-params
           tt-param.nome-transp         = INPUT FRAME fPage4 iNome-transp
           tt-param.notas-desconsiderar = INPUT FRAME fpage2 ed-notas-desconsiderar
           tt-param.ordenacao-item      = INPUT FRAME fPage4 tg-ordenacao-item.
           

    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/ftp/esftp010rp.p} 
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

