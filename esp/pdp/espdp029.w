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
{include/i-prgvrs.i ESPDP029 2.04.00.002}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESPDP029
&GLOBAL-DEFINE Version        2.04.00.002
&GLOBAL-DEFINE VersionLayout  1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,Importaá∆o,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution
&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page2Fields    fiIniEstabel               fiFimEstabel ~
                              fiIniTpPedido              fiFimTpPedido ~
                              fiIniDtEntrega             fiFimDtEntrega ~
                              fiIniEmitente              fiFimEmitente ~
                              fiIniItCodigo              fiFimItCodigo ~
                              fiIniUnidadedeNegocio      fiFimUnidadedeNegocio ~
                              fiIniGrpCanais             fiFimGrpCanais ~
                              fi-duplicata-ini           fi-duplicata-fim ~
                              fiIniRepre                 fiFimRepre ~
                              lista-prioridade-44        lista-atendente-34 tg-acesso-restrito tg-cancelados tg-itens-cancelados


&GLOBAL-DEFINE page4Fields    ed-layout tg-importa  fi-arquivo-imp bt-bi fi-cod-depos bt-inclui br-deposito bt-elimina rs-class

&GLOBAL-DEFINE page6Fields    cFile

{esp/pdp/espdp029tt.i}

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-temp         as char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-deposito

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE br-deposito                                   */
&Scoped-define FIELDS-IN-QUERY-br-deposito tt-digita.cod-depos   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-deposito   
&Scoped-define SELF-NAME br-deposito
&Scoped-define QUERY-STRING-br-deposito FOR EACH tt-digita
&Scoped-define OPEN-QUERY-br-deposito OPEN QUERY {&SELF-NAME} FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-br-deposito tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-br-deposito tt-digita


/* Definitions for FRAME fpage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage4 ~
    ~{&OPEN-QUERY-br-deposito}

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
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-duplicata-fim AS CHARACTER FORMAT "X(3)":U INITIAL "Z" 
     VIEW-AS FILL-IN 
     SIZE 3.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-duplicata-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Duplicata" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiFimDtEntrega AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiFimEmitente AS INTEGER FORMAT ">>>>>>>9":U INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiFimEstabel AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiFimGrpCanais AS INTEGER FORMAT "99":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 3.86 BY .88 NO-UNDO.

DEFINE VARIABLE fiFimItCodigo AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiFimRepre AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiFimTpPedido AS CHARACTER FORMAT "X(2)":U INITIAL "99" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiFimUnidadedeNegocio AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 3.86 BY .88 NO-UNDO.

DEFINE VARIABLE fiIniDtEntrega AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1900 
     LABEL "Prev. Fatur" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiIniEmitente AS INTEGER FORMAT ">>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiIniEstabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiIniGrpCanais AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Grupo de Canais" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiIniItCodigo AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiIniRepre AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiIniTpPedido AS CHARACTER FORMAT "X(2)":U 
     LABEL "Atendente" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiIniUnidadedeNegocio AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade de Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88 NO-UNDO.

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

DEFINE IMAGE IMAGE-41
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-42
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-43
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-44
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-45
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-46
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

DEFINE RECTANGLE RECT-141
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.14 BY 1.25.

DEFINE RECTANGLE RECT-143
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 9.25.

DEFINE RECTANGLE RECT-148
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.14 BY 2.29.

DEFINE VARIABLE lista-atendente-34 AS LOGICAL INITIAL no 
     LABEL "Listar Pedidos com Atendente 34 (Plano OEM)" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE lista-prioridade-44 AS LOGICAL INITIAL no 
     LABEL "Listar Pedidos com Prior. 44 (Oráamento)" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE tg-acesso-restrito AS LOGICAL INITIAL no 
     LABEL "Considerar ParÉmetros do Acesso Restrito" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .75 NO-UNDO.

DEFINE VARIABLE tg-cancelados AS LOGICAL INITIAL no 
     LABEL "Listar apenas pedidos cancelados" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-itens-cancelados AS LOGICAL INITIAL no 
     LABEL "Listar apenas Itens cancelados" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.14 BY .83 NO-UNDO.

DEFINE BUTTON bt-bi 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-elimina DEFAULT 
     IMAGE-UP FILE "adeicon/cross.bmp":U
     LABEL "" 
     SIZE 3.86 BY .92 TOOLTIP "Eliminar Exceá∆o".

DEFINE BUTTON bt-inclui DEFAULT 
     IMAGE-UP FILE "adeicon/check.bmp":U
     LABEL "INCLUI" 
     SIZE 3.86 BY .92 TOOLTIP "Incluir Exceá∆o".

DEFINE VARIABLE ed-layout AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 52.72 BY 5.08 NO-UNDO.

DEFINE VARIABLE fi-arquivo-imp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-depos AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .79 NO-UNDO.

DEFINE VARIABLE rs-class AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Nr. Pedido Cliente", 1,
"Data Implantaá∆o", 2,
"Data Prev. Faturamento", 3
     SIZE 20 BY 2.08 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 57 BY 3.04.

DEFINE RECTANGLE RECT-144
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 3.08.

DEFINE RECTANGLE RECT-147
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 1.5.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 6.5.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 57 BY 6.5.

DEFINE VARIABLE tg-importa AS LOGICAL INITIAL no 
     LABEL "Importar arquivo de Previs∆o de Produá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .83 NO-UNDO.

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

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
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
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-deposito FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-deposito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-deposito wReport _FREEFORM
  QUERY br-deposito DISPLAY
      tt-digita.cod-depos            COLUMN-LABEL "C¢digo"  WIDTH 6
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 15.57 BY 4.75
         FONT 1
         TITLE "Dep¢sito" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN TOOLTIP "Dep¢sitos".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 17
         FONT 1.

DEFINE FRAME fPage2
     tg-acesso-restrito AT ROW 1.38 COL 4 WIDGET-ID 20
     fiIniEstabel AT ROW 2.96 COL 35.71 RIGHT-ALIGNED
     fiFimEstabel AT ROW 2.96 COL 51.14 NO-LABEL
     fiIniTpPedido AT ROW 3.96 COL 35.71 RIGHT-ALIGNED
     fiFimTpPedido AT ROW 3.96 COL 51.14 NO-LABEL
     fiIniDtEntrega AT ROW 4.96 COL 35.72 RIGHT-ALIGNED
     fiFimDtEntrega AT ROW 4.96 COL 51.14 NO-LABEL
     fiIniEmitente AT ROW 5.96 COL 35.72 RIGHT-ALIGNED
     fiFimEmitente AT ROW 5.96 COL 51.14 NO-LABEL
     fiIniItCodigo AT ROW 6.96 COL 35.72 RIGHT-ALIGNED
     fiFimItCodigo AT ROW 6.96 COL 51.14 NO-LABEL
     fi-duplicata-ini AT ROW 7.96 COL 35.72 RIGHT-ALIGNED WIDGET-ID 12
     fi-duplicata-fim AT ROW 7.96 COL 51.14 NO-LABEL WIDGET-ID 16
     fiIniUnidadedeNegocio AT ROW 8.96 COL 35.72 RIGHT-ALIGNED WIDGET-ID 4
     fiFimUnidadedeNegocio AT ROW 8.96 COL 51.14 NO-LABEL WIDGET-ID 2
     fiIniGrpCanais AT ROW 9.96 COL 35.72 RIGHT-ALIGNED WIDGET-ID 392
     fiFimGrpCanais AT ROW 9.96 COL 51.14 NO-LABEL WIDGET-ID 390
     fiFimRepre AT ROW 10.88 COL 49.14 COLON-ALIGNED NO-LABEL WIDGET-ID 404
     fiIniRepre AT ROW 10.92 COL 28.29 COLON-ALIGNED WIDGET-ID 402
     lista-prioridade-44 AT ROW 12.25 COL 5 WIDGET-ID 10
     tg-cancelados AT ROW 12.25 COL 51.57 WIDGET-ID 386
     tg-itens-cancelados AT ROW 13.21 COL 51.57 WIDGET-ID 388
     lista-atendente-34 AT ROW 13.25 COL 5 WIDGET-ID 10
     "< Seleá∆o >" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 2.5 COL 40 WIDGET-ID 38
     IMAGE-1 AT ROW 2.96 COL 37
     IMAGE-2 AT ROW 2.96 COL 47.86
     IMAGE-3 AT ROW 3.96 COL 37
     IMAGE-4 AT ROW 3.96 COL 47.86
     IMAGE-5 AT ROW 4.96 COL 37
     IMAGE-6 AT ROW 4.96 COL 47.86
     IMAGE-7 AT ROW 5.96 COL 37
     IMAGE-8 AT ROW 5.96 COL 47.86
     IMAGE-9 AT ROW 6.96 COL 37
     IMAGE-10 AT ROW 6.96 COL 47.86
     IMAGE-11 AT ROW 8.96 COL 37 WIDGET-ID 8
     IMAGE-12 AT ROW 8.96 COL 47.86 WIDGET-ID 6
     IMAGE-41 AT ROW 7.96 COL 37 WIDGET-ID 14
     IMAGE-42 AT ROW 7.96 COL 47.86 WIDGET-ID 18
     RECT-141 AT ROW 1.13 COL 2.86 WIDGET-ID 22
     RECT-143 AT ROW 2.75 COL 3 WIDGET-ID 36
     RECT-148 AT ROW 12 COL 3 WIDGET-ID 40
     IMAGE-43 AT ROW 10.92 COL 37 WIDGET-ID 394
     IMAGE-44 AT ROW 10.92 COL 47.86 WIDGET-ID 396
     IMAGE-45 AT ROW 9.96 COL 37 WIDGET-ID 398
     IMAGE-46 AT ROW 9.96 COL 47.86 WIDGET-ID 400
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 84.43 BY 13.5
         FONT 1.

DEFINE FRAME fpage4
     tg-importa AT ROW 1.58 COL 4 WIDGET-ID 378
     ed-layout AT ROW 7.67 COL 30 NO-LABEL WIDGET-ID 376
     fi-cod-depos AT ROW 7.42 COL 8.14 COLON-ALIGNED WIDGET-ID 346
     bt-inclui AT ROW 7.38 COL 19.57 HELP
          "Incluir Exceá∆o" WIDGET-ID 348
     bt-elimina AT ROW 12.25 COL 20 HELP
          "Eliminar Exceá∆o" WIDGET-ID 350
     bt-bi AT ROW 4.25 COL 79.29 HELP
          "Escolha do nome do arquivo" WIDGET-ID 72
     fi-arquivo-imp AT ROW 4.33 COL 30 NO-LABEL WIDGET-ID 92
     rs-class AT ROW 3.75 COL 3.86 NO-LABEL WIDGET-ID 28
     br-deposito AT ROW 8.46 COL 3.43 WIDGET-ID 300
     "Arquivo Importaá∆o:" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 2.83 COL 30.14 WIDGET-ID 4
     "Considerar Saldo:" VIEW-AS TEXT
          SIZE 12.43 BY .54 AT ROW 6.58 COL 4 WIDGET-ID 368
     "Modelo layout Proposto .csv: item~; data previs∆o~; quantidade" VIEW-AS TEXT
          SIZE 44 BY .54 AT ROW 6.63 COL 30 WIDGET-ID 372
     "Classificar por:" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 2.92 COL 3.86 WIDGET-ID 32
     RECT-10 AT ROW 3.29 COL 28 WIDGET-ID 2
     RECT-16 AT ROW 7 COL 2 WIDGET-ID 366
     RECT-144 AT ROW 3.25 COL 2 WIDGET-ID 380
     RECT-17 AT ROW 7 COL 28 WIDGET-ID 382
     RECT-147 AT ROW 1.25 COL 2 WIDGET-ID 384
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 84.43 BY 12.75
         FONT 7 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configuraá∆o da impressora"
     rsExecution AT ROW 6 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5.25 COL 3.14 NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.5 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 84.43 BY 12.75
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
         WIDTH              = 90.43
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.14
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

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fpage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN fi-duplicata-fim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-duplicata-ini IN FRAME fPage2
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fiFimDtEntrega IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiFimEmitente IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiFimEstabel IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiFimGrpCanais IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiFimItCodigo IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiFimTpPedido IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiFimUnidadedeNegocio IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiIniDtEntrega IN FRAME fPage2
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fiIniEmitente IN FRAME fPage2
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fiIniEstabel IN FRAME fPage2
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fiIniGrpCanais IN FRAME fPage2
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fiIniItCodigo IN FRAME fPage2
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fiIniTpPedido IN FRAME fPage2
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fiIniUnidadedeNegocio IN FRAME fPage2
   ALIGN-R                                                              */
/* SETTINGS FOR FRAME fpage4
   Custom                                                               */
/* BROWSE-TAB br-deposito RECT-147 fpage4 */
ASSIGN 
       br-deposito:COLUMN-RESIZABLE IN FRAME fpage4       = TRUE.

ASSIGN 
       ed-layout:READ-ONLY IN FRAME fpage4        = TRUE.

/* SETTINGS FOR FILL-IN fi-arquivo-imp IN FRAME fpage4
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME fPage6
   ALIGN-L                                                              */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-deposito
/* Query rebuild information for BROWSE br-deposito
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-digita
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-deposito */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage4
/* Query rebuild information for FRAME fpage4
     _Query            is NOT OPENED
*/  /* FRAME fpage4 */
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


&Scoped-define BROWSE-NAME br-deposito
&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME br-deposito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-deposito wReport
ON START-SEARCH OF br-deposito IN FRAME fpage4 /* Dep¢sito */
DO:
  
/*     DEFINE VARIABLE i_count AS INTEGER     NO-UNDO.                                                                                   */
/*     DEFINE VARIABLE i_index AS INTEGER     NO-UNDO.                                                                                   */
/*                                                                                                                                       */
/*     SELF:CLEAR-SORT-ARROWS().                                                                                                         */
/*                                                                                                                                       */
/*     IF SELF:CURRENT-COLUMN:TABLE = "":U OR                                                                                            */
/*        SELF:CURRENT-COLUMN:TABLE = ?    THEN                                                                                          */
/*         RETURN NO-APPLY.                                                                                                              */
/*                                                                                                                                       */
/*     IF v_column <> SELF:CURRENT-COLUMN:NAME THEN                                                                                      */
/*         ASSIGN v_column = SELF:CURRENT-COLUMN:NAME                                                                                    */
/*                v_asc    = YES.                                                                                                        */
/*     ELSE                                                                                                                              */
/*         ASSIGN v_asc = NOT v_asc.                                                                                                     */
/*                                                                                                                                       */
/*     IF v_asc THEN                                                                                                                     */
/*         SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +                                                  */
/*                                  "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME).              */
/*     ELSE                                                                                                                              */
/*         SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +                                                  */
/*                                  "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC":U).  */
/*                                                                                                                                       */
/*     DO i_count = 1 TO SELF:NUM-COLUMNS:                                                                                               */
/*         IF SELF:CURRENT-COLUMN = SELF:GET-BROWSE-COLUMN(i_count) THEN                                                                 */
/*             ASSIGN i_index = i_count.                                                                                                 */
/*     END.                                                                                                                              */
/*                                                                                                                                       */
/*     SELF:SET-SORT-ARROW(i_index, v_asc).                                                                                              */
/*                                                                                                                                       */
/*     SELF:QUERY:QUERY-OPEN().                                                                                                          */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-bi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-bi wReport
ON CHOOSE OF bt-bi IN FRAME fpage4
DO:
    def var cArqConv  as char no-undo.

    assign cArqConv = replace(input frame fpage4 fi-arquivo-imp, "/":U, "~\":U).
    SYSTEM-DIALOG GET-FILE cArqConv
       FILTERS "*.csv":U "*.csv":U,
               "*.*":U "*.*":U
       ASK-OVERWRITE 
       DEFAULT-EXTENSION "lst":U
       INITIAL-DIR session:temp-directory
   
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then do:
        assign fi-arquivo-imp = replace(cArqConv, "~\":U, "/":U).
        display fi-arquivo-imp with frame fpage4.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-elimina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-elimina wReport
ON CHOOSE OF bt-elimina IN FRAME fpage4
DO:
    IF  AVAIL tt-digita THEN DO:
         DELETE tt-digita.
         {&OPEN-QUERY-br-deposito}
    END.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-inclui
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inclui wReport
ON CHOOSE OF bt-inclui IN FRAME fpage4 /* INCLUI */
DO:
  
    DEF VAR i-seq AS INTEGER NO-UNDO.

    FIND deposito NO-LOCK
        WHERE deposito.cod-depos = fi-cod-depos:SCREEN-VALUE IN FRAME fpage4 NO-ERROR.

    IF  NOT AVAIL deposito THEN DO:
        RUN utp/ut-msgs.p ("SHOW",
                           17006,
                           "Dep¢sito inexistente.").
        RETURN NO-APPLY.
    END.

    FIND tt-digita
        WHERE tt-digita.cod-depos = fi-cod-depos:SCREEN-VALUE IN FRAME fpage4 NO-ERROR.
    IF  AVAIL tt-digita THEN DO:
        RUN utp/ut-msgs.p ("SHOW",
                           17006,
                           "Dep¢sito j† est† sendo considerado.").
        RETURN NO-APPLY.
    END.
    ELSE DO TRANS:
        CREATE tt-digita.
        ASSIGN tt-digita.cod-depos = fi-cod-depos:SCREEN-VALUE IN FRAME fpage4.
        {&OPEN-QUERY-br-deposito}
    END.

    fi-cod-depos:SCREEN-VALUE IN FRAME fpage4 = "".

    APPLY "entry" TO fi-cod-depos IN FRAME fpage4.
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


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME fi-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos IN FRAME fpage4 /* Dep¢sito */
DO:
/*   {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"  */
/*                        &campo"fi-cod-depos"          */
/*                        &campozoom="cod-depos"        */
/*                        &frame="fpage4"             */
/*                                                      */
/*                        &campozoom2="nome"            */
/*                        &frame2="fpage4"}           */
                       
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
                   btConfigImpr:visible  = yes
                   .
                   /*Fim alteracao 15/02/2005*/
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no
                   .
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no
                   .
        END.
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tg-acesso-restrito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-acesso-restrito wReport
ON VALUE-CHANGED OF tg-acesso-restrito IN FRAME fPage2 /* Considerar ParÉmetros do Acesso Restrito */
DO:
  IF  input frame fPage2 tg-acesso-restrito =  YES THEN
      DISABLE fiIniEstabel             
              fiFimEstabel             
              fiIniTpPedido            
              fiFimTpPedido            
              fiIniDtEntrega           
              fiFimDtEntrega           
              fiIniEmitente            
              fiFimEmitente            
              fiIniItCodigo            
              fiFimItCodigo            
              fiIniUnidadedeNegocio    
              fiFimUnidadedeNegocio    
              fi-duplicata-ini         
              fi-duplicata-fim         
              lista-prioridade-44    
              lista-atendente-34 WITH FRAME fpage2.      
  ELSE
      ENABLE  fiIniEstabel             
              fiFimEstabel             
              fiIniTpPedido            
              fiFimTpPedido            
              fiIniDtEntrega           
              fiFimDtEntrega           
              fiIniEmitente            
              fiFimEmitente            
              fiIniItCodigo            
              fiFimItCodigo            
              fiIniUnidadedeNegocio    
              fiFimUnidadedeNegocio    
              fi-duplicata-ini         
              fi-duplicata-fim         
              lista-prioridade-44    
              lista-atendente-34 WITH FRAME fpage2.      

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-cancelados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-cancelados wReport
ON VALUE-CHANGED OF tg-cancelados IN FRAME fPage2 /* Listar apenas pedidos cancelados */
DO:
  DO  WITH FRAME fpage2:
      IF  tg-cancelados:CHECKED THEN
          ASSIGN tg-itens-cancelados:CHECKED = NO.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME tg-importa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-importa wReport
ON VALUE-CHANGED OF tg-importa IN FRAME fpage4 /* Importar arquivo de Previs∆o de Produá∆o */
DO:
  
    IF  tg-importa:CHECKED IN FRAME fpage4 THEN
        ASSIGN rs-class:SENSITIVE       IN FRAME fpage4 = YES
               fi-cod-depos:SENSITIVE   IN FRAME fpage4 = YES
               bt-inclui:SENSITIVE      IN FRAME fpage4 = YES
               br-deposito:SENSITIVE    IN FRAME fpage4 = YES
               bt-elimina:SENSITIVE     IN FRAME fpage4 = YES
               fi-arquivo-imp:SENSITIVE IN FRAME fpage4 = YES.
    ELSE DO:
        ASSIGN rs-class:SENSITIVE       IN FRAME fpage4 = NO 
               fi-cod-depos:SENSITIVE   IN FRAME fpage4 = NO 
               bt-inclui:SENSITIVE      IN FRAME fpage4 = NO 
               br-deposito:SENSITIVE    IN FRAME fpage4 = NO 
               bt-elimina:SENSITIVE     IN FRAME fpage4 = NO
               fi-arquivo-imp:SENSITIVE IN FRAME fpage4 = NO.
        EMPTY TEMP-TABLE tt-digita.
        {&OPEN-QUERY-br-deposito}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tg-itens-cancelados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-itens-cancelados wReport
ON VALUE-CHANGED OF tg-itens-cancelados IN FRAME fPage2 /* Listar apenas Itens cancelados */
DO:
    DO WITH FRAME fpage2:
        IF  tg-itens-cancelados:CHECKED THEN
          ASSIGN tg-cancelados:CHECKED   = NO.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{report/mainblock.i}


    ASSIGN ed-layout:SCREEN-VALUE IN FRAME fpage4 = "4030111; 02/07/2016; 10"  + CHR(10) +
                                                    "4030111; 08/07/2016; 203" + CHR(10) +
                                                    "4030112; 10/07/2016; 240".

     APPLY "Value-changed" TO tg-importa IN FRAME fpage4.

    {&OPEN-QUERY-br-deposito}

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

    APPLY "Value-changed" TO tg-importa IN FRAME fpage4.

    ASSIGN ed-layout:SCREEN-VALUE IN FRAME fpage4 = "4030111; 02/07/2016; 10"  + CHR(10) +
                                                    "4030111; 08/07/2016; 203" + CHR(10) +
                                                    "4030112; 10/07/2016; 240".


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

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    IF  tg-importa:CHECKED IN FRAME fpage4 THEN DO:

        IF  INDEX(fi-arquivo-imp:SCREEN-VALUE, ".csv") = 0 THEN DO:
            RUN utp/ut-msgs.p ("show",
                               17006,
                               "Arquivo n∆o est† no formato correto" + "~~" + "Deve ser informado um arquivo com extená∆o .CSV ").

            RETURN "NOK".
        END.
        IF  SEARCH(fi-arquivo-imp:SCREEN-VALUE) = ?  THEN DO:
            RUN utp/ut-msgs.p ("show",
                               17006,
                               "Arquivo n∆o encontrado." + "~~" + "Para executar sem a informaá∆o do arquivo deve ser desmarcada a opá∆o <Importar Arquivo Previs∆o Produá∆o>").

            RETURN "NOK".
        END.
        IF  fi-arquivo-imp:SCREEN-VALUE IN FRAME fpage4 = "" THEN DO:
            RUN utp/ut-msgs.p ("show",
                               17006,
                               "Arquivo deve ser informado." + "~~" + "Para executar sem a informaá∆o do arquivo deve ser desmarcada a opá∆o <Importar Arquivo Previs∆o Produá∆o>").
            RETURN "NOK".

        END.
        IF  NOT CAN-FIND (FIRST tt-digita) THEN DO:
            RUN utp/ut-msgs.p ("show",
                               17006,
                               "Deve ser informado ao menos 1 dep¢sito" + "~~" + "Para executar sem a informaá∆o dep¢sitos deve ser desmarcada a opá∆o <Importar Arquivo Previs∆o Produá∆o>").
            RETURN "NOK".
        END.

    END.
        
        
    CREATE tt-param.
    ASSIGN tt-param.usuario                   = c-seg-usuario
           tt-param.destino                   = INPUT FRAME fPage6 rsDestiny
           tt-param.data-exec                 = TODAY
           tt-param.hora-exec                 = TIME.
                                             
    
    ASSIGN tt-param.cod-estabel-ini           = INPUT FRAME fPage2 fiIniEstabel
           tt-param.cod-estabel-fim           = INPUT FRAME fPage2 fiFimEstabel
           tt-param.tp-pedido-ini             = INPUT FRAME fPage2 fiIniTpPedido
           tt-param.tp-pedido-fim             = INPUT FRAME fPage2 fiFimTpPedido
           tt-param.dt-entrega-ini            = INPUT FRAME fPage2 fiIniDtEntrega
           tt-param.dt-entrega-fim            = INPUT FRAME fPage2 fiFimDtEntrega
           tt-param.cod-emitente-ini          = INPUT FRAME fPage2 fiIniEmitente
           tt-param.cod-emitente-fim          = INPUT FRAME fPage2 fiFimEmitente
           tt-param.it-codigo-ini             = INPUT FRAME fPage2 fiIniItCodigo
           tt-param.it-codigo-fim             = INPUT FRAME fPage2 fiFimItCodigo
           tt-param.cod-unid-negoc-ini        = INPUT FRAME fPage2 fiIniUnidadedeNegocio
           tt-param.cod-unid-negoc-fim        = INPUT FRAME fPage2 fiFimUnidadedeNegocio
           tt-param.grupo-canais-ini          = INPUT FRAME fPage2 fiIniGrpCanais
           tt-param.grupo-canais-fim          = INPUT FRAME fPage2 fiFimGrpCanais
           tt-param.i-dup-ini                 = INPUT FRAME fPage2 fi-duplicata-ini
           tt-param.i-dup-fim                 = INPUT FRAME fPage2 fi-duplicata-fim
           tt-param.l-lista-prioridade-44     = INPUT FRAME fpage2 lista-prioridade-44
           tt-param.l-lista-atendente-34      = INPUT FRAME fpage2 lista-atendente-34
           tt-param.l-selecao-acesso-restrito = INPUT FRAME fpage2 tg-acesso-restrito
           tt-param.tg-importa                = tg-importa:CHECKED IN FRAME fpage4
           tt-param.l-cancelado               = tg-cancelados:CHECKED IN FRAME fpage2
           tt-param.l-itens-cancelado         = tg-itens-cancelados:CHECKED IN FRAME fpage2
           tt-param.fi-arquivo-imp            = fi-arquivo-imp:SCREEN-VALUE IN FRAME fpage4
           tt-param.rs-class                  = int(rs-class:SCREEN-VALUE IN FRAME fpage4)
           tt-param.i-rep-ini                 = INPUT FRAME fpage2 fiIniRepre
           tt-param.i-rep-fim                 = INPUT FRAME fpage2 fiFimRepre.

    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
    
     EMPTY TEMP-TABLE tt-raw-digita.
     FOR EACH tt-digita:
         CREATE tt-raw-digita.
         RAW-TRANSFER tt-digita TO tt-raw-digita.raw-digita.
     END.
    
    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/pdp/espdp029rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ELSE
/*:T** Importacao/Exportacao ***/
do  on error undo, return error
    on stop  undo, return error:     

    {report/rpexa.i}

    if  input frame fPage7 rsDestiny = 2 and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage7 cDestinyFile).
        if  return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "SHOW":U,
                               input 73,
                               input "":U).
            apply "ENTRY":U to cDestinyFile in frame fPage7.                   
            return error.
        end.
    end.
    
    assign file-info:file-name = input frame fPage4 cInputFile.
    if  file-info:pathname = ? and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-msgs.p (input "SHOW":U,
                           input 326,
                           input cInputFile).                               
        apply "ENTRY":U to cInputFile in frame fPage4.                
        return error.
    end. 
            
    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p†gina 
       com problemas e colocar o focus no campo com problemas             */    
         
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage7 rsDestiny
           tt-param.todos           = input frame fPage7 rsAll
           tt-param.arq-entrada     = input frame fPage4 cInputFile
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.

    if  tt-param.destino = 1 then
        assign tt-param.arq-destino = "":U.
    else
    if  tt-param.destino = 2 THEN
        assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /*:T Coloque aqui a l¢gica de gravaá∆o dos parÉmtros e seleá∆o na temp-table
       tt-param */ 

    {report/imexb.i}

    if  session:set-wait-state("GENERAL":U) then.

    {report/imrun.i xxp/xx9999rp.p}

    {report/imexc.i}

    if  session:set-wait-state("":U) then.
    
    {report/imtrm.i tt-param.arq-destino tt-param.destino}
    
end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

