&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/ 
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos   Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESPDP091d 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESPDP091d
&GLOBAL-DEFINE Version        1
&GLOBAL-DEFINE VersionLayout  1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          no
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution
&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo
&GLOBAL-DEFINE page2Fields    fi-Atendente-ini br-EstabDepos fi-Atendente-fim fi-Atendente-mestre-ini fi-Atendente-mestre-fim fi-Cod-repres-ini fi-Cod-repres-fim       ~
                              fi-dt-entrega-ini fi-dt-entrega-fim fi-nr-pedcli-ini fi-nr-pedcli-fim fi-dt-implant-ini fi-dt-implant-fim fi-cond-pagto-ini ~
                              fi-cond-pagto-fim fi-prioridade-ini fi-prioridade-fim fi-cod-grupo-ini fi-cod-grupo-fim l-libera-item-parcial ~
                              cb-unid-neg l-fatura-total l-alocLibFat l-alocFat fi-Estabel-ini fi-Estabel-fim v-cod-localiz
                              
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page6Fields    cFile


/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VAR v_cod_estab_usuar AS CHARACTER NO-UNDO.
{esp/pdp/espdp091d.i}

/* Transfer Definitions */

def var raw-param        as raw no-undo.

DEFINE BUFFER b-conteudo-programa FOR conteudo-programa.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

def stream s-imp.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-EstabDepos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE br-EstabDepos                                 */
&Scoped-define FIELDS-IN-QUERY-br-EstabDepos tt-digita.cod-estab tt-digita.cod-depos   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-EstabDepos tt-digita.cod-depos   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-EstabDepos tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-EstabDepos tt-digita
&Scoped-define SELF-NAME br-EstabDepos
&Scoped-define QUERY-STRING-br-EstabDepos FOR EACH tt-digita     WHERE tt-digita.cod-estab >= fi-Estabel-ini:SCREEN-VALUE IN FRAME fPage2       AND tt-digita.cod-estab <= fi-Estabel-fim:SCREEN-VALUE IN FRAME fPage2 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-EstabDepos OPEN QUERY {&SELF-NAME} FOR EACH tt-digita     WHERE tt-digita.cod-estab >= fi-Estabel-ini:SCREEN-VALUE IN FRAME fPage2       AND tt-digita.cod-estab <= fi-Estabel-fim:SCREEN-VALUE IN FRAME fPage2 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-EstabDepos tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-br-EstabDepos tt-digita


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-br-EstabDepos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK-2 btCancel-2 btCancel-3 btOK ~
btCancel btDesbloqueio btHelp2 

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

DEFINE BUTTON btCancel-2 
     IMAGE-UP FILE "image/im-las.bmp":U
     LABEL "Fechar" 
     SIZE 4 BY 1.

DEFINE BUTTON btCancel-3 
     IMAGE-UP FILE "image/im-las.bmp":U
     LABEL "Fechar" 
     SIZE 4 BY 1.

DEFINE BUTTON btDesbloqueio 
     LABEL "Libera Execu‡Æo" 
     SIZE 14 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK-2 
     IMAGE-UP FILE "image/im-faixa.bmp":U
     LABEL "Executar" 
     SIZE 6 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 83 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE cb-unid-neg AS CHARACTER FORMAT "X(256)":U 
     LABEL "Un Neg" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fi-Atendente-fim AS CHARACTER FORMAT "X(2)":U INITIAL "00" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Atendente-ini AS CHARACTER FORMAT "X(2)":U INITIAL "0" 
     LABEL "Atendente" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Atendente-mestre-fim AS CHARACTER FORMAT "X(2)":U INITIAL "99" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Atendente-mestre-ini AS CHARACTER FORMAT "X(2)":U 
     LABEL "Atendente Mestre" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-grupo-fim AS INTEGER FORMAT ">9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 4 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-grupo-ini AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Grupo Cliente" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-Repres-fim AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-repres-ini AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cond-pagto-fim AS INTEGER FORMAT ">>9":U INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cond-pagto-ini AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Cond Pagto" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-dt-entrega-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/2999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-dt-entrega-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1900 
     LABEL "Prev.Fatur" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-dt-implant-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/2999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-dt-implant-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1900 
     LABEL "Dt.Implanta‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Estabel-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Estabel-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-nr-pedcli-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-nr-pedcli-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Pedido Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-prioridade-fim AS CHARACTER FORMAT "X(02)":U INITIAL "01" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .79 NO-UNDO.

DEFINE VARIABLE fi-prioridade-ini AS CHARACTER FORMAT "X(02)":U INITIAL "01" 
     LABEL "Prioridade" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .79 NO-UNDO.

DEFINE VARIABLE v-cod-localiz AS CHARACTER FORMAT "X(256)":U 
     LABEL "Localiza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-11
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-13
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-14
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-15
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-16
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-17
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-18
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-19
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-20
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE VARIABLE l-alocFat AS LOGICAL INITIAL no 
     LABEL "Alocar e Faturar (Gerar Nota Fiscal)" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-alocLibFat AS LOGICAL INITIAL no 
     LABEL "Alocar e Liberar para Faturamento (Prioridade 10)" 
     VIEW-AS TOGGLE-BOX
     SIZE 36.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-fatura-total AS LOGICAL INITIAL no 
     LABEL "Somente Faturar Pedido Total" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE l-libera-item-parcial AS LOGICAL INITIAL no 
     LABEL "Faturar Item Parcial" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

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
     SIZE 46.72 BY .88
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
     SIZE 57.72 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 48 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73.86 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73.86 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-EstabDepos FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-EstabDepos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-EstabDepos wReport _FREEFORM
  QUERY br-EstabDepos NO-LOCK DISPLAY
      tt-digita.cod-estab 
      tt-digita.cod-depos
      ENABLE
      tt-digita.cod-depos
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 23.86 BY 6.21
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK-2 AT ROW 3.75 COL 44 WIDGET-ID 6
     btCancel-2 AT ROW 4 COL 44 WIDGET-ID 2
     btCancel-3 AT ROW 4 COL 48 WIDGET-ID 4
     btOK AT ROW 16.25 COL 3
     btCancel AT ROW 16.25 COL 14
     btDesbloqueio AT ROW 16.25 COL 59 HELP
          "Libera Execu‡Æo do Faturamento Autom tico do Usu rio" WIDGET-ID 40
     btHelp2 AT ROW 16.25 COL 74
     rtToolBar AT ROW 16 COL 2.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 84.86 BY 17.17
         FONT 1.

DEFINE FRAME fPage2
     fi-Estabel-ini AT ROW 1.46 COL 17.43 COLON-ALIGNED WIDGET-ID 72
     fi-Estabel-fim AT ROW 1.46 COL 41.43 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     fi-Atendente-ini AT ROW 2.5 COL 17.43 COLON-ALIGNED WIDGET-ID 2
     fi-Atendente-fim AT ROW 2.5 COL 41.43 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     cb-unid-neg AT ROW 3 COL 62 COLON-ALIGNED WIDGET-ID 68
     fi-Atendente-mestre-ini AT ROW 3.5 COL 17.43 COLON-ALIGNED WIDGET-ID 56
     fi-Atendente-mestre-fim AT ROW 3.5 COL 41.43 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     v-cod-localiz AT ROW 4.25 COL 62 COLON-ALIGNED WIDGET-ID 80
     fi-Cod-repres-ini AT ROW 4.5 COL 17.43 COLON-ALIGNED
     fi-Cod-Repres-fim AT ROW 4.5 COL 41.43 COLON-ALIGNED NO-LABEL
     br-EstabDepos AT ROW 5.25 COL 56 WIDGET-ID 200
     fi-dt-entrega-ini AT ROW 5.5 COL 17.43 COLON-ALIGNED
     fi-dt-entrega-fim AT ROW 5.5 COL 41.43 COLON-ALIGNED NO-LABEL
     fi-nr-pedcli-ini AT ROW 6.54 COL 17.43 COLON-ALIGNED
     fi-nr-pedcli-fim AT ROW 6.54 COL 41.43 COLON-ALIGNED NO-LABEL
     fi-dt-implant-ini AT ROW 7.54 COL 17.43 COLON-ALIGNED
     fi-dt-implant-fim AT ROW 7.54 COL 41.43 COLON-ALIGNED NO-LABEL
     fi-cond-pagto-ini AT ROW 8.5 COL 17.43 COLON-ALIGNED WIDGET-ID 22
     fi-Cond-pagto-fim AT ROW 8.5 COL 41.43 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     fi-prioridade-ini AT ROW 9.54 COL 17.43 COLON-ALIGNED WIDGET-ID 30
     fi-prioridade-fim AT ROW 9.54 COL 41.43 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     fi-cod-grupo-ini AT ROW 10.5 COL 17.43 COLON-ALIGNED WIDGET-ID 38
     fi-Cod-grupo-fim AT ROW 10.5 COL 41.43 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     l-libera-item-parcial AT ROW 11.92 COL 11 WIDGET-ID 50
     l-alocLibFat AT ROW 11.92 COL 43.57 WIDGET-ID 66
     l-fatura-total AT ROW 12.83 COL 11 WIDGET-ID 62
     l-alocFat AT ROW 12.83 COL 43.57 WIDGET-ID 64
     IMAGE-1 AT ROW 4.5 COL 38.43 WIDGET-ID 4
     IMAGE-2 AT ROW 4.5 COL 34.43 WIDGET-ID 6
     IMAGE-3 AT ROW 5.5 COL 38.43 WIDGET-ID 8
     IMAGE-4 AT ROW 5.5 COL 34.43 WIDGET-ID 10
     IMAGE-5 AT ROW 6.5 COL 38.43 WIDGET-ID 12
     IMAGE-6 AT ROW 6.5 COL 34.43 WIDGET-ID 14
     IMAGE-7 AT ROW 7.5 COL 38.43 WIDGET-ID 16
     IMAGE-8 AT ROW 7.5 COL 34.43 WIDGET-ID 18
     IMAGE-9 AT ROW 8.5 COL 38.43 WIDGET-ID 24
     IMAGE-10 AT ROW 8.5 COL 34.43 WIDGET-ID 26
     IMAGE-11 AT ROW 9.5 COL 38.43 WIDGET-ID 32
     IMAGE-12 AT ROW 9.5 COL 34.43 WIDGET-ID 34
     IMAGE-13 AT ROW 10.5 COL 38.43 WIDGET-ID 42
     IMAGE-14 AT ROW 10.5 COL 34.43 WIDGET-ID 40
     IMAGE-15 AT ROW 2.5 COL 38.43 WIDGET-ID 46
     IMAGE-16 AT ROW 2.5 COL 34.43 WIDGET-ID 48
     IMAGE-17 AT ROW 3.5 COL 38.43 WIDGET-ID 58
     IMAGE-18 AT ROW 3.5 COL 34.43 WIDGET-ID 60
     IMAGE-19 AT ROW 1.46 COL 38.43 WIDGET-ID 74
     IMAGE-20 AT ROW 1.46 COL 34.43 WIDGET-ID 76
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 80.43 BY 13
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 51 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 51 HELP
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
         AT COL 3.57 ROW 2.75
         SIZE 80.43 BY 7
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
         HEIGHT             = 17.42
         WIDTH              = 85.29
         MAX-HEIGHT         = 29.71
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 29.71
         VIRTUAL-WIDTH      = 182.86
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
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB br-EstabDepos fi-Cod-Repres-fim fPage2 */
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

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-EstabDepos
/* Query rebuild information for BROWSE br-EstabDepos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-digita
    WHERE tt-digita.cod-estab >= fi-Estabel-ini:SCREEN-VALUE IN FRAME fPage2
      AND tt-digita.cod-estab <= fi-Estabel-fim:SCREEN-VALUE IN FRAME fPage2 NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgesp.ponto-programa.cod-programa = 'espdp091'
 AND mgesp.ponto-programa.ponto = 14"
     _Query            is OPENED
*/  /* BROWSE br-EstabDepos */
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


&Scoped-define BROWSE-NAME br-EstabDepos
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME br-EstabDepos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-EstabDepos wReport
ON VALUE-CHANGED OF br-EstabDepos IN FRAME fPage2
DO:
    /* IDBA Bruno ->>  M2403-017Trava faturamento dep¢sito EXP
    DEFINE VARIABLE l-wms-estab-ativo AS LOGICAL NO-UNDO.

    IF tt-digita.cod-depos:SCREEN-VALUE IN BROWSE br-EstabDepos <> '' THEN DO:
        
        FIND CURRENT tt-digita EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL tt-digita THEN DO:
            FIND FIRST deposito WHERE deposito.cod-depos = tt-digita.cod-depos:SCREEN-VALUE IN BROWSE br-EstabDepos NO-LOCK NO-ERROR.
            IF AVAIL deposito THEN DO:

                RUN esp/wmp/eswmpapi091.p( INPUT tt-digita.cod-estab, OUTPUT l-wms-estab-ativo).
                IF  l-wms-estab-ativo 
                AND deposito.cod-depos = 'EXP' THEN DO:
                    run utp/ut-msgs.p (input "show":U, input 17091, input "Dep¢sito Inv lido!~~Dep¢sito informado nÆo pode ser utilizado no estabelecimento " + tt-digita.cod-estab + ".").
                    apply "ENTRY":U to tt-digita.cod-depos in BROWSE br-EstabDepos.
                    RETURN NO-APPLY.
                END.
                ASSIGN tt-digita.cod-depos = tt-digita.cod-depos:SCREEN-VALUE IN BROWSE br-EstabDepos.
            END.
            ELSE DO:
                run utp/ut-msgs.p (input "show":U, input 17091, input "Dep¢sito Inv lido!~~Dep¢sito informado nÆo existe.":U).
                apply "ENTRY":U to tt-digita.cod-depos in BROWSE br-EstabDepos.
                RETURN NO-APPLY.
            END.
        END.
    END.
    */
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


&Scoped-define SELF-NAME btCancel-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel-2 wReport
ON CHOOSE OF btCancel-2 IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel-3 wReport
ON CHOOSE OF btCancel-3 IN FRAME fpage0 /* Fechar */
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


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btDesbloqueio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesbloqueio wReport
ON CHOOSE OF btDesbloqueio IN FRAME fpage0 /* Libera Execu‡Æo */
DO:

    for EACH mgesp.ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "espdp091"
          AND ponto-programa.ponto         = 10,  
         EACH mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa :

        IF c-seg-usuario = ENTRY(3,conteudo-programa.conteudo, ";") THEN DO:
            FIND FIRST b-conteudo-programa EXCLUSIVE-LOCK
                 WHERE ROWID(b-conteudo-programa) = ROWID(conteudo-programa) NO-ERROR.

            DELETE b-conteudo-programa.
        END.
        ELSE DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 17091,
                       INPUT "NÆo existe execu‡Æo de Aloca‡Æo Autom tica para atendente do pedido.~~Usuario : " +  entry(3,conteudo-programa.conteudo, ";") ).     
            RETURN NO-APPLY.
        END.
    END.
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
/*     if INPUT FRAME fPage2 l-alocFat    = YES  THEN DO:                                               */
/*        RUN utp/ut-msgs.p (input "show":U, input 17091, input "Fun‡Æo temporariamente desativada":U). */
/*        RETURN NO-APPLY.                                                                              */
/*     END.                                                                                             */

    /*IF fi-Estabel-ini:SCREEN-VALUE IN FRAME fPage2 <= '104' AND fi-Estabel-fim:SCREEN-VALUE IN FRAME fPage2 >= '104' THEN DO:
        IF cb-cod-depos:SCREEN-VALUE IN FRAME fPage2 = 'EXP' THEN DO:
            IF TODAY >= 06/15/2016 THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17091,
                                   INPUT "Alocacao Bloqueada para o deposito EXP!~~Deposito bloqueado devido a implantacao do WMS, estabelecimento 104!").
                RETURN NO-APPLY.
            END. /* IF TODAY >= 06/15/2016 THEN DO: */
        END. /* IF vCod-Depos = 'EXP' THEN DO: */
    END. /* IF  vEstabel-ini >= '104' AND vEstabel-fim <= '104' THEN DO: */*/


    IF  INPUT FRAME fPage2 l-alocLibFat = NO 
    AND INPUT FRAME fPage2 l-alocFat    = NO  THEN DO:
       RUN utp/ut-msgs.p (input "show":U, input 17091, input "Escolher uma Op‡Æo:~~'Alocar e Liberar para Faturamento' ou 'Alocar e Faturar'":U).
       RETURN NO-APPLY.
    END.

   DO ON ERROR UNDO, RETURN NO-APPLY:
      RUN piExecute.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK-2 wReport
ON CHOOSE OF btOK-2 IN FRAME fpage0 /* Executar */
DO:
   DO ON ERROR UNDO, RETURN NO-APPLY:
      RUN piExecute.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fi-Atendente-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Atendente-fim wReport
ON MOUSE-SELECT-DBLCLICK OF fi-Atendente-fim IN FRAME fPage2
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Atendente-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Atendente-ini wReport
ON ENTRY OF fi-Atendente-ini IN FRAME fPage2 /* Atendente */
DO:
  
    FIND FIRST mgesp.ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "pd4000"
          AND ponto-programa.ponto         = 7 NO-ERROR.
    IF AVAIL mgesp.ponto-programa THEN DO:
        IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:
            DISABLE l-alocLibFat  WITH FRAME fPage2.
        END. /* IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK */
    END. /* IF AVAIL mgesp.ponto-programa THEN DO: */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Atendente-ini wReport
ON MOUSE-SELECT-DBLCLICK OF fi-Atendente-ini IN FRAME fPage2 /* Atendente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Atendente-mestre-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Atendente-mestre-fim wReport
ON MOUSE-SELECT-DBLCLICK OF fi-Atendente-mestre-fim IN FRAME fPage2
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Atendente-mestre-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Atendente-mestre-ini wReport
ON MOUSE-SELECT-DBLCLICK OF fi-Atendente-mestre-ini IN FRAME fPage2 /* Atendente Mestre */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-grupo-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-grupo-ini wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-grupo-ini IN FRAME fPage2 /* Grupo Cliente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-repres-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-repres-ini wReport
ON MOUSE-SELECT-DBLCLICK OF fi-Cod-repres-ini IN FRAME fPage2 /* Representante */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cond-pagto-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cond-pagto-ini wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cond-pagto-ini IN FRAME fPage2 /* Cond Pagto */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Estabel-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Estabel-fim wReport
ON LEAVE OF fi-Estabel-fim IN FRAME fPage2
DO:
  {&OPEN-QUERY-br-EstabDepos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Estabel-fim wReport
ON MOUSE-SELECT-DBLCLICK OF fi-Estabel-fim IN FRAME fPage2
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Estabel-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Estabel-ini wReport
ON ENTRY OF fi-Estabel-ini IN FRAME fPage2 /* Estabelecimento */
DO:
  
    FIND FIRST mgesp.ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "pd4000"
          AND ponto-programa.ponto         = 7 NO-ERROR.
    IF AVAIL mgesp.ponto-programa THEN DO:
        IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:
            DISABLE l-alocLibFat  WITH FRAME fPage2.
        END. /* IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK */
    END. /* IF AVAIL mgesp.ponto-programa THEN DO: */

    {&OPEN-QUERY-br-EstabDepos}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Estabel-ini wReport
ON LEAVE OF fi-Estabel-ini IN FRAME fPage2 /* Estabelecimento */
DO:
  {&OPEN-QUERY-br-EstabDepos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Estabel-ini wReport
ON MOUSE-SELECT-DBLCLICK OF fi-Estabel-ini IN FRAME fPage2 /* Estabelecimento */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-alocFat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-alocFat wReport
ON VALUE-CHANGED OF l-alocFat IN FRAME fPage2 /* Alocar e Faturar (Gerar Nota Fiscal) */
DO:

    IF INPUT FRAME fPage2 l-alocFat = YES THEN
        DISABLE l-alocLibFat WITH FRAME fPage2.
    ELSE DO:
        FIND FIRST mgesp.ponto-programa NO-LOCK
            WHERE ponto-programa.nome-programa = "pd4000"
              AND ponto-programa.ponto         = 7 NO-ERROR.
        IF AVAIL mgesp.ponto-programa THEN DO:
            IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK
                    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                      AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:
                DISABLE l-alocLibFat  WITH FRAME fPage2.

            END. /* IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK */
            ELSE
                ENABLE l-alocLibFat WITH FRAME fPage2.
        END. /* IF AVAIL mgesp.ponto-programa THEN DO: */
    END.

    IF INPUT FRAME fPage2 l-alocFat = YES THEN DO:

            FIND FIRST mgesp.ponto-programa
                WHERE ponto-programa.nome-programa = "espdp091"
                  AND ponto-programa.ponto = 12 NO-LOCK NO-ERROR.
            IF AVAIL mgesp.ponto-programa THEN DO:

                IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK
                    WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa 
                      AND ENTRY(1,conteudo-programa.conteudo) = v_cod_estab_usuar) THEN DO:
                    MESSAGE "Faturamento Comercial Autom tico nÆo est  liberado para o estabelecimento " + v_cod_estab_usuar
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        ASSIGN l-alocFat:SCREEN-VALUE IN FRAME fPAge2 = 'NO'.
                        DISABLE l-alocFat    WITH FRAME fPage2.

                        FIND FIRST mgesp.ponto-programa NO-LOCK
                            WHERE ponto-programa.nome-programa = "pd4000"
                              AND ponto-programa.ponto         = 7 NO-ERROR.
                        IF AVAIL mgesp.ponto-programa THEN DO:
                            IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK
                                    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                                      AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:
                                DISABLE l-alocLibFat  WITH FRAME fPage2.

                            END. /* IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK */
                            ELSE
                                ENABLE l-alocLibFat WITH FRAME fPage2.
                        END. /* IF AVAIL mgesp.ponto-programa THEN DO: */

                    RETURN "OK".
                END.
                ELSE 
                    DISABLE l-alocLibFat WITH FRAME fPage2.

            END. /* IF AVAIL mgesp.ponto-programa THEN DO: */
    END.

    
/*     ASSIGN l-alocFat:SCREEN-VALUE IN FRAME fPage2  = "NO".  */
/*     DISABLE l-alocFat    WITH FRAME fPage2.                 */
/*     ENABLE  l-alocLibFat WITH FRAME fPage2.                 */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-alocLibFat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-alocLibFat wReport
ON VALUE-CHANGED OF l-alocLibFat IN FRAME fPage2 /* Alocar e Liberar para Faturamento (Prioridade 10) */
DO:
  
    IF INPUT FRAME fPage2 l-alocLibFat = YES THEN
        DISABLE l-alocFat WITH FRAME fPage2.
    ELSE
        ENABLE l-alocFat WITH FRAME fPage2.
    

/*     ASSIGN l-alocFat:SCREEN-VALUE IN FRAME fPage2  = "NO".  */
/*     DISABLE l-alocFat    WITH FRAME fPage2.                 */
/*     ENABLE  l-alocLibFat WITH FRAME fPage2.                 */

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


/* ***************************  Main Block  *************************** */

/*
fi-Cod-Emitente:load-mouse-pointer ("image/lupa.cur") in frame fpage2.
fi-Cod-Representante:load-mouse-pointer ("image/lupa.cur") in frame fpage2.
*/

/* Include custom  Main Block code for SmartWindows. */
/*
{src/adm/template/windowmn.i}
*/

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
    {report/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR FIRST mgesp.ponto-programa
    WHERE ponto-programa.nome-programa = "espdp091"
      AND ponto-programa.ponto = 14,
    EACH mgesp.conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

    FIND FIRST tt-digita
        WHERE  tt-digita.cod-estabel = ENTRY(1,conteudo-programa.conteudo) NO-ERROR.
    IF NOT AVAIL tt-digita THEN DO:

        CREATE tt-digita.
        ASSIGN tt-digita.cod-estabel = ENTRY(1,conteudo-programa.conteudo)
               tt-digita.cod-depos = ENTRY(2,conteudo-programa.conteudo).

    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeInitializeInterface wReport 
PROCEDURE BeforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign 
       fi-dt-entrega-ini = ADD-INTERVAL(TODAY, -6, "month")
       fi-dt-implant-ini = ADD-INTERVAL(TODAY, -6, "month")
       fi-dt-entrega-fim = TODAY
       fi-dt-implant-fim = TODAY.


ASSIGN rsExecution = 2
       rsDestiny = 2
       cFile = "ESPDP091D.LST"
       .
ASSIGN btDesbloqueio:SENSITIVE IN FRAME fpage0 = TRUE.

FOR EACH unid-negoc NO-LOCK:
    IF cb-unid-neg:LIST-ITEMS in FRAME fPage2 = ? THEN
        ASSIGN  cb-unid-neg:LIST-ITEMS in FRAME fPage2  =  "," + unid-negoc.cod-unid-negoc.
    ELSE
        ASSIGN  cb-unid-neg:LIST-ITEMS in FRAME fPage2  =  cb-unid-neg:LIST-ITEMS in FRAME fPage2  + "," + unid-negoc.cod-unid-negoc.
END.


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

DEFINE VAR r-tt-digita AS ROWID NO-UNDO.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
 
DO ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    {report/rpexa.i}
    
    IF INPUT frame fPage6 rsDestiny   = 2 AND
       INPUT frame fPage6 rsExecution = 1 THEN DO:
       RUN utp/ut-vlarq.p (input input frame fPage6 cFile).
        
       IF RETURN-VALUE = "NOK":U THEN DO:
          RUN utp/ut-msgs.p (input "show":U, input 73, input "":U).
          APPLY "ENTRY":U to cFile in frame fPage6.
          RETURN error.
       END.
    END.
    
    /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    CREATE tt-param.
    ASSIGN tt-param.usuario         = c-seg-usuario
           tt-param.destino         = INPUT frame fPage6 rsDestiny
           tt-param.data-exec       = TODAY
           tt-param.hora-exec       = TIME.

    DO WITH FRAME fPage2:
        assign tt-param.fi-Estabel-ini     = fi-Estabel-ini:SCREEN-VALUE IN FRAME fpage2
               tt-param.fi-Estabel-fim     = fi-Estabel-fim:SCREEN-VALUE IN FRAME fpage2
               tt-param.fi-Atendente-ini   = string(INPUT fi-atendente-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-Atendente-fim   = string(INPUT fi-atendente-fim:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-Atendente-mestre-ini   = string(INPUT fi-atendente-mestre-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-Atendente-mestre-fim   = string(INPUT fi-atendente-mestre-fim:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-Cod-repres-ini  = INT(INPUT fi-cod-repres-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-Cod-repres-fim  = INT(INPUT fi-cod-repres-fim:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-dt-entrega-ini  = date(INPUT fi-dt-entrega-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-dt-entrega-fim  = date(INPUT fi-dt-entrega-fim:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-nr-pedcli-ini   = string(INPUT fi-nr-pedcli-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-nr-pedcli-fim   = string(INPUT fi-nr-pedcli-fim:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-dt-implant-ini  = date(INPUT fi-dt-implant-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-dt-implant-fim  = date(INPUT fi-dt-implant-fim:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-cond-pagto-ini  = INT(INPUT fi-cond-pagto-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-cond-pagto-fim  = INT(INPUT fi-cond-pagto-fim:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-prioridade-ini  = INT(INPUT fi-prioridade-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-prioridade-fim  = INT(INPUT fi-prioridade-fim:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-cod-grupo-ini   = INT(INPUT fi-cod-grupo-ini:SCREEN-VALUE IN FRAME fpage2)
               tt-param.fi-cod-grupo-fim   = INT(INPUT fi-cod-grupo-fim:SCREEN-VALUE IN FRAME fpage2)
               tt-param.libera-item-parcial = IF INPUT l-libera-item-parcial:SCREEN-VALUE IN FRAME fpage2  = "yes" THEN YES ELSE NO
               tt-param.fatura-total        = IF INPUT l-fatura-total:SCREEN-VALUE IN FRAME fpage2  = "yes" THEN YES ELSE NO
               tt-param.cod-unid-neg        = IF INPUT cb-unid-neg:SCREEN-VALUE IN FRAME fpage2 = ? THEN '' ELSE INPUT cb-unid-neg:SCREEN-VALUE IN FRAME fpage2
               tt-param.localizacao         = v-cod-localiz:SCREEN-VALUE IN FRAME fpage2
               tt-param.l-alocLibFat        = INPUT FRAME fPage2 l-alocLibFat     
               tt-param.l-alocFat           = INPUT FRAME fPage2 l-alocFat        .

    END.

    IF tt-param.destino = 1 then 
       ASSIGN tt-param.arquivo = "":U.
    ELSE 
       IF tt-param.destino = 2 THEN
          ASSIGN tt-param.arquivo = input frame fPage6 cFile.
       ELSE
          ASSIGN tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    for each tt-raw-digita:
        delete tt-raw-digita.
    end.
    for each tt-digita:
        create tt-raw-digita.
        raw-transfer tt-digita to tt-raw-digita.raw-digita.
    end. 
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    

    {report/rprun.i esp/pdp/espdp091rp.p}
    

    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
END.


&ELSE

/*:T** Importacao/Exportacao ***/
DO ON ERROR UNDO, RETURN ERROR
   ON STOP UNDO, RETURN ERROR:     

    {report/rpexa.i}

   IF INPUT FRAME fPage7 rsDestiny   = 2 AND
      INPUT FRAME fPage7 rsExecution = 1 THEN DO:
      RUN utp/ut-vlarq.p (input input frame fPage7 cDestinyFile).
      IF RETURN-VALUE = "NOK":U then do:
         RUN utp/ut-msgs.p (input "SHOW":U,
                            input 73,
                            input "":U).
         APPLY "ENTRY":U to cDestinyFile in frame fPage7.                   
         RETURN error.
      END.
   END.
    
   ASSIGN file-info:file-name = input frame fPage4 cInputFile.
   IF FILE-INFO:pathname = ? AND
      INPUT frame fPage7 rsExecution = 1 then do:
      RUN utp/ut-msgs.p (input "SHOW":U,
                         input 326,
                         input cInputFile).                               
      APPLY "ENTRY":U to cInputFile in frame fPage4.                
      RETURN error.
   END. 
            
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p gina 
       com problemas e colocar o focus no campo com problemas             */    
         
   CREATE tt-param.
   ASSIGN tt-param.usuario         = c-seg-usuario
          tt-param.destino         = input frame fPage7 rsDestiny
          tt-param.todos           = input frame fPage7 rsAll
          tt-param.arq-entrada     = input frame fPage4 cInputFile
          tt-param.data-exec       = today
          tt-param.hora-exec       = time.

   IF tt-param.destino = 1 then
      ASSIGN tt-param.arq-destino = "":U.
   ELSE
      IF tt-param.destino = 2 then 
         ASSIGN tt-param.arq-destino = input frame fPage7 cDestinyFile.
      ELSE
         ASSIGN tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /*:T Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table tt-param */ 

   {report/imexb.i}

   IF SESSION:set-wait-state("GENERAL":U) then.

      {report/imrun.i xxp/xx9999rp.p}

   {report/imexc.i}

   IF SESSION:set-wait-state("":U) then.
    
      {report/imtrm.i tt-param.arq-destino tt-param.destino}
    
END.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

