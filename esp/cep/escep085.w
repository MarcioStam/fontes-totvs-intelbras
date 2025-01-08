&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/***********************************************************************
**  Programa..: esp/cep/escep085.w
**  Autor.....: Nicolas Martinez
**  Data......: Outubro/2020 - Desenvolvimento
**  Descricao.: Relatorio estoque sem movimento
**  Versao....: 001 14/10/2020
**                  Desenvolvimento Programa
************************************************************************/
{include/i-prgvrs.i escep085 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escep085
&GLOBAL-DEFINE Version        1.00.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Parƒmetro,Digita‡Æo,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            YES

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2

&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page4Widgets   tg-entradas tg-saidas

&GLOBAL-DEFINE page5Widgets   brDigita ~
                              btAdd ~
                              btUpdate ~
                              btDelete ~
                              btSave ~
                              btOpen
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              l-habilitaRtf ~
                              btModelRtf

&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo text-rtf text-ModelRtf
&GLOBAL-DEFINE page2Fields    fl-data-ini fl-data-fim fl-item-ini fl-item-fim ~
                              fl-cod-estabel-ini fl-cod-estabel-fim fl-cod-depos-ini fl-cod-depos-fim ~
                              fl-ge-ini fl-ge-fim fl-fm-codigo-ini fl-fm-codigo-fim
&GLOBAL-DEFINE page4Fields     
&GLOBAL-DEFINE page6Fields    cFile cModelRTF

/* Parameters Definitions ---                                           */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)":U
    FIELD usuario          AS CHAR FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD modelo           AS CHAR FORMAT "x(35)":U
    FIELD item-ini         AS CHAR
    FIELD item-fim         AS CHAR
    FIELD data-ini         AS DATE
    FIELD data-fim         AS DATE
    FIELD cod-estabel-ini  AS CHAR
    FIELD cod-estabel-fim  AS CHAR
    FIELD cod-depos-ini    AS CHAR
    FIELD cod-depos-fim    AS CHAR
    FIELD ge-ini           AS INTE
    FIELD ge-fim           AS INTE
    FIELD fm-codigo-ini    AS CHAR
    FIELD fm-codigo-fim    AS CHAR
    FIELD entradas         AS LOG 
    FIELD saidas           AS LOG
    FIELD l-habilitaRtf    AS LOG
    .

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD esp-docto   AS CHAR
    FIELD esp-docto-i AS INTE
    FIELD descricao   AS CHAR
        INDEX id esp-docto.

{upc/btb910za-upc.i}

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

/* ************************  Function Prototypes ********************** */

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
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.esp-docto tt-digita.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.esp-docto   
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


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-esp-docto-cod wReport 
FUNCTION fn-esp-docto-cod RETURNS CHARACTER
  ( pEsp-Docto AS INTE /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-esp-docto-desc wReport 
FUNCTION fn-esp-docto-desc RETURNS CHARACTER
  ( pEspecie AS CHAR /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-esp-docto-int wReport 
FUNCTION fn-esp-docto-int RETURNS INTEGER
  ( pEspecie AS CHAR /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

DEFINE VARIABLE fl-cod-depos-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fl-cod-depos-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fl-cod-estabel-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fl-cod-estabel-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fl-data-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE fl-data-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE fl-fm-codigo-fim AS CHARACTER FORMAT "X(10)":U INITIAL "ZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fl-fm-codigo-ini AS CHARACTER FORMAT "X(10)":U 
     LABEL "Fam¡lia" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fl-ge-fim AS INTEGER FORMAT ">9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE fl-ge-ini AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Grupo Estoque" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE fl-item-fim AS CHARACTER FORMAT "X(10)":U INITIAL "ZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fl-item-ini AS CHARACTER FORMAT "X(10)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

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

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
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

DEFINE RECTANGLE RECT-44
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19 BY 2.75.

DEFINE VARIABLE tg-entradas AS LOGICAL INITIAL yes 
     LABEL "Entradas" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-saidas AS LOGICAL INITIAL yes 
     LABEL "Sa¡das" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE BUTTON btAdd 
     LABEL "Inserir" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btDelete 
     LABEL "Retirar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btOpen 
     LABEL "Recuperar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btUpdate 
     LABEL "Carrega Todos" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btModelRtf 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cModelRTF AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-ModelRtf AS CHARACTER FORMAT "X(256)":U INITIAL "Modelo:" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-rtf AS CHARACTER FORMAT "X(256)":U INITIAL "Rich Text Format(RTF)" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

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

DEFINE RECTANGLE rect-rtf
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 3.21.

DEFINE VARIABLE l-habilitaRtf AS LOGICAL INITIAL no 
     LABEL "RTF" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-digita.esp-docto FORMAT "x(6)"  COLUMN-LABEL "Esp"
tt-digita.descricao       FORMAT "x(100)" COLUMN-LABEL "Descri‡Æo"
ENABLE
tt-digita.esp-docto
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 8.75
         BGCOLOR 15 FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.96
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1
     btAdd AT ROW 10 COL 1
     btDelete AT ROW 10 COL 16
     btSave AT ROW 10 COL 31
     btOpen AT ROW 10 COL 46
     btUpdate AT ROW 10 COL 61
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configura‡Æo da impressora"
     l-habilitaRtf AT ROW 5.58 COL 3.14
     cModelRTF AT ROW 7.29 COL 3 HELP
          "Nome do arquivo de modelo" NO-LABEL
     btModelRtf AT ROW 7.29 COL 43 HELP
          "Escolha o arquivo de modelo"
     rsExecution AT ROW 9.5 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-rtf AT ROW 5 COL 2 COLON-ALIGNED NO-LABEL
     text-ModelRtf AT ROW 6.54 COL 2 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 8.75 COL 1.14 COLON-ALIGNED NO-LABEL
     rect-rtf AT ROW 5.29 COL 2
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 9 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     fl-item-ini AT ROW 1.75 COL 23 COLON-ALIGNED WIDGET-ID 6
     fl-item-fim AT ROW 1.75 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     fl-data-ini AT ROW 2.75 COL 23 COLON-ALIGNED WIDGET-ID 2
     fl-data-fim AT ROW 2.75 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     fl-cod-estabel-ini AT ROW 3.75 COL 27.86 COLON-ALIGNED WIDGET-ID 16
     fl-cod-estabel-fim AT ROW 3.75 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     fl-cod-depos-ini AT ROW 4.75 COL 27.86 COLON-ALIGNED WIDGET-ID 24
     fl-cod-depos-fim AT ROW 4.75 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     fl-ge-ini AT ROW 5.75 COL 29.86 COLON-ALIGNED WIDGET-ID 32
     fl-ge-fim AT ROW 5.75 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     fl-fm-codigo-ini AT ROW 6.75 COL 23 COLON-ALIGNED WIDGET-ID 40
     fl-fm-codigo-fim AT ROW 6.75 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     IMAGE-1 AT ROW 1.75 COL 35
     IMAGE-2 AT ROW 1.75 COL 51
     IMAGE-5 AT ROW 2.75 COL 35 WIDGET-ID 10
     IMAGE-6 AT ROW 2.75 COL 51 WIDGET-ID 12
     IMAGE-7 AT ROW 3.75 COL 35 WIDGET-ID 18
     IMAGE-8 AT ROW 3.75 COL 51 WIDGET-ID 20
     IMAGE-9 AT ROW 4.75 COL 35 WIDGET-ID 26
     IMAGE-10 AT ROW 4.75 COL 51 WIDGET-ID 28
     IMAGE-11 AT ROW 5.75 COL 35 WIDGET-ID 36
     IMAGE-12 AT ROW 5.75 COL 51 WIDGET-ID 34
     IMAGE-13 AT ROW 6.75 COL 35 WIDGET-ID 42
     IMAGE-14 AT ROW 6.75 COL 51 WIDGET-ID 44
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     tg-saidas AT ROW 2.25 COL 5 WIDGET-ID 44
     tg-entradas AT ROW 3.25 COL 5 WIDGET-ID 42
     "Movimentos" VIEW-AS TEXT
          SIZE 9.29 BY .54 AT ROW 1.42 COL 4.72 WIDGET-ID 40
     RECT-44 AT ROW 1.75 COL 3 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
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
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.96
         WIDTH              = 90
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.21
         VIRTUAL-WIDTH      = 195.14
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
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita 1 fPage5 */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       btModelRtf:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       cModelRTF:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-ModelRtf:HIDDEN IN FRAME fPage6           = TRUE
       text-ModelRtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Modelo:".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

ASSIGN 
       text-rtf:HIDDEN IN FRAME fPage6           = TRUE
       text-rtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Rich Text Format(RTF)".

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
/*    if  brDigita:new-row in frame fPage5 then do:
        if  avail tt-digita then
            delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then. 
    end.                                                               
    else do:
        get current brDigita.
        display tt-digita.it-codigo
                tt-digita.descricao with browse brDigita. 
    end.
    return no-apply. */
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
ON ROW-ENTRY OF brDigita IN FRAME fPage5
DO:
   /*:T trigger para inicializar campos da temp table de digita‡Æo */
    /*
    IF AVAIL tt-digita THEN DO:
    
       if  brDigita:new-row in frame fPage5 then do:

           FIND ITEM NO-LOCK
               WHERE ITEM.it-codigo = tt-digita.it-codigo NO-ERROR.
    
            ASSIGN tt-digita.descricao:screen-value in browse brDigita = ITEM.desc-item.
       end. 
    END. */

 /*     IF brDigita:NEW-ROW IN FRAME fPage5 THEN DO:
        IF AVAILABLE tt-digita THEN DO:
            FIND FIRST item
                WHERE item.it-codigo = INPUT BROWSE brDigita tt-digita.it-codigo NO-LOCK NO-ERROR.
            
            ASSIGN tt-digita.descricao = IF AVAILABLE item THEN item.desc-item ELSE "":U.

            DISPLAY tt-digita.descricao
                WITH BROWSE brDigita.
        END.
    END.    */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5
/*DO:
    /*:T  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */
    IF AVAIL tt-digita THEN DO:

        FIND item where 
             item.it-codigo = input browse brDigita tt-digita.it-codigo no-lock no-error. 
        if avail item then 
            tt-digita.descricao:screen-value in browse brDigita = item.desc-item.
        else                
            tt-digita.descricao:screen-value in browse brDigita = "".
    END.
    
    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse brDigita tt-digita.it-codigo
               input browse brDigita tt-digita.descricao.

        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.

    else do transaction on error undo, return no-apply:
        if avail tt-digita then
            assign input browse brDigita tt-digita.it-codigo
                   input browse brDigita tt-digita.descricao.
    end.
END. */



DO:
    /*:T  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */

    IF brDigita:NEW-ROW IN FRAME fPage5 THEN DO TRANSACTION ON ERROR UNDO, RETURN NO-APPLY:
        CREATE tt-digita.
        ASSIGN INPUT BROWSE brDigita tt-digita.esp-docto
               INPUT BROWSE brDigita tt-digita.descricao.

        brDigita:CREATE-RESULT-LIST-ENTRY() IN FRAME fPage5.

     /*   FIND FIRST item
            WHERE item.it-codigo = INPUT BROWSE brDigita tt-digita.it-codigo NO-LOCK NO-ERROR.

        ASSIGN tt-digita.descricao = IF AVAILABLE item THEN item.desc-item ELSE "":U. */

        DISPLAY tt-digita.descricao
            WITH BROWSE brDigita.

        ASSIGN INPUT BROWSE brDigita tt-digita.descricao.
    END.
    ELSE DO TRANSACTION ON ERROR UNDO, RETURN NO-APPLY:
        IF AVAILABLE tt-digita THEN DO:
          /*  FIND FIRST item
                WHERE item.it-codigo = INPUT BROWSE brDigita tt-digita.it-codigo NO-LOCK NO-ERROR.
            
            ASSIGN tt-digita.descricao = IF AVAILABLE item THEN item.desc-item ELSE "":U.
*/
            DISPLAY tt-digita.descricao
                WITH BROWSE brDigita.

            ASSIGN INPUT BROWSE brDigita tt-digita.esp-docto
                   INPUT BROWSE brDigita tt-digita.descricao.
        END.
    END.
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
        
        apply "entry":U to tt-digita.esp-docto in browse brDigita. 
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
        assign btUpdate:SENSITIVE in frame fPage5 = YES
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


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btModelRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModelRtf wReport
ON CHOOSE OF btModelRtf IN FRAME fPage6
DO:
    def var cFile as char no-undo.
    def var l-ok  as logical no-undo.

    assign cModelRTF = replace(input frame {&frame-name} cModelRTF, "/", "~\").
    SYSTEM-DIALOG GET-FILE cFile
       FILTERS "*.rtf" "*.rtf",
               "*.*" "*.*"
       DEFAULT-EXTENSION "rtf"
       INITIAL-DIR "modelos" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign cModelRTF:screen-value in frame {&frame-name}  = replace(cFile, "~\", "/"). 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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
ON CHOOSE OF btUpdate IN FRAME fPage5 /* Carrega Todos */
DO:
  // apply 'entry' to tt-digita.esp-docto in browse brDigita. 
    RUN pi-cria-especies.

    open query brDigita for each tt-digita.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME l-habilitaRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-habilitaRtf wReport
ON VALUE-CHANGED OF l-habilitaRtf IN FRAME fPage6 /* RTF */
DO:
    &IF "{&RTF}":U = "YES":U &THEN
    RUN pi-habilitaRtf.  
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
                   /*Alterado 15/02/2005 - tech1007 - Alterado para suportar adequadamente com a 
                     funcionalidade de RTF*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = NO
                   l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                   l-habilitaRtf = NO
                   &endif
                   .
                   /*Fim alteracao 15/02/2005*/
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
            /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
            &IF "{&RTF}":U = "YES":U &THEN
            IF VALID-HANDLE(hWenController) THEN DO:
                ASSIGN l-habilitaRtf:sensitive  = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                       l-habilitaRtf = NO.
            END.
            &endif
            /*Fim alteracao 15/02/2005*/
        END.
        /*Alterado 15/02/2005 - tech1007 - Condi‡Æo removida pois RTF nÆo ‚ mais um destino
        when "4":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   text-ModelRtf:VISIBLE   = YES
                   rect-rtf:VISIBLE       = YES
                   blModelRtf:VISIBLE       = yes.
        end.
        Fim alteracao 15/02/2005*/
    end case.
end.
&IF "{&RTF}":U = "YES":U &THEN
RUN pi-habilitaRtf.  
&endif
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
/*
ON 'LEAVE':U OF tt-digita.descricao IN BROWSE brDigita DO:
     FIND item where 
             item.it-codigo = input browse brDigita tt-digita.it-codigo no-lock no-error. 
        if avail item then 
            tt-digita.descricao:screen-value in browse brDigita = item.desc-item.
        else                
            tt-digita.descricao:screen-value in browse brDigita = "".
    RETURN.

    
END.*/

{report/mainblock.i}

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
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializa‡Æo
  correta dos componentes do RTF quando executado em ambiente local e no WebEnabler.*/
&IF "{&RTF}":U = "YES":U &THEN
IF VALID-HANDLE(hWenController) THEN DO:
    ASSIGN l-habilitaRtf:sensitive IN FRAME fPage6 = NO
           l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
           l-habilitaRtf = NO.
           
END.
RUN pi-habilitaRtf.
&endif
/*Fim alteracao 17/02/2005*/

//ASSIGN btUpdate:VISIBLE in frame fPage5 = no.

RUN pi-cria-especies.

open query brDigita for each tt-digita.

ASSIGN fl-data-ini = TODAY
       fl-data-fim = TODAY.

DISPLAY fl-data-ini
        fl-data-fim WITH FRAME fPage2.

//APPLY "VALUE-CHANGED":U TO tg-habilita-email IN FRAME fPage4.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-especies wReport 
PROCEDURE pi-cria-especies :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-cont AS INTE NO-UNDO.

    EMPTY TEMP-TABLE tt-digita.

    DO i-cont = 1 TO 38:
        CREATE tt-digita.
        ASSIGN tt-digita.esp-docto   = fn-esp-docto-cod(i-cont)
               tt-digita.esp-docto-i = fn-esp-docto-int(tt-digita.esp-docto)
               tt-digita.descricao   = fn-esp-docto-desc(tt-digita.esp-docto).
    END.
   /* CREATE tt-digita.
    ASSIGN tt-digita.esp-docto   = fn-esp-docto-cod(i-cont)
           tt-digita.esp-docto-i = fn-esp-docto-int("ACA")
           tt-digita.descricao   = fn-esp-docto-desc("ACA").*/

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

    /*15/02/2005 - tech1007 - Teste alterado pois RTF nÆo ‚ mais op‡Æo de Destino*/
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.
    
    /*16/02/2005 - tech1007 - Teste alterado para validar o modelo informado quando for RTF*/
    &IF "{&RTF}":U = "YES":U &THEN
    IF ( input frame fPage6 cModelRTF = "" AND
         input frame fPage6 l-habilitaRtf = YES ) OR
       ( SEARCH(INPUT FRAME fPage6 cModelRTF) = ? AND
         input frame fPage6 rsExecution = 1 AND
         input frame fPage6 l-habilitaRtf = YES )
         THEN DO:
        run utp/ut-msgs.p (input "show":U, input 73, input "":U).
        /*30/12/2004 - tech1007 - Evento removido pois causa problemas no WebEnabler*/
        /*apply "CHOOSE":U to blModelRtf in frame fPage6.*/
        return error.
    END.
    &endif
 
    /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/

    &IF "{&PGDIG}":U = "YES":U &THEN
        /*BROWSE brDigita:SET-REPOSITIONED-ROW(BROWSE brDigita:DOWN, "ALWAYS":U).*/

        FOR EACH tt-digita NO-LOCK:
            ASSIGN r-tt-digita = ROWID(tt-digita).

            /*:T Valida‡Æo de duplicidade de registro na temp-table tt-digita */
            FIND FIRST b-tt-digita
                WHERE b-tt-digita.esp-docto = tt-digita.esp-docto
                  AND ROWID(b-tt-digita)   <> ROWID(tt-digita) NO-LOCK NO-ERROR.

            IF AVAILABLE b-tt-digita THEN DO:
                REPOSITION brDigita TO ROWID ROWID(b-tt-digita).
                RUN setFolder IN hFolder (INPUT 3).

                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 108,
                                   INPUT "":U).

                APPLY "ENTRY":U TO tt-digita.esp-docto IN BROWSE brDigita.

                RETURN ERROR.
            END.

            /*:T As demais valida‡äes devem ser feitas aqui */
           /* FIND FIRST item
                WHERE item.it-codigo = tt-digita.esp-docto NO-LOCK NO-ERROR.

            IF NOT AVAILABLE item THEN DO:
                RUN setFolder IN hFolder (INPUT 3).

                ASSIGN BROWSE brDigita:CURRENT-COLUMN = tt-digita.it-codigo:HANDLE IN BROWSE brDigita.

                REPOSITION brDigita TO ROWID r-tt-digita.

                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 2,
                                   INPUT "Item":U).

                APPLY "ENTRY":U TO tt-digita.it-codigo IN BROWSE brDigita.

                RETURN ERROR.
            END. */
        END.

        &ENDIF    
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
           tt-param.data-ini        = INPUT FRAME fPage2 fl-data-ini
           tt-param.data-fim        = INPUT FRAME fPage2 fl-data-fim
           tt-param.item-ini        = INPUT FRAME fPage2 fl-item-ini
           tt-param.item-fim        = INPUT FRAME fPage2 fl-item-fim
           tt-param.cod-estabel-ini = INPUT FRAME fPage2 fl-cod-estabel-ini
           tt-param.cod-estabel-fim = INPUT FRAME fPage2 fl-cod-estabel-fim
           tt-param.cod-depos-ini   = INPUT FRAME fPage2 fl-cod-depos-ini
           tt-param.cod-depos-fim   = INPUT FRAME fPage2 fl-cod-depos-fim
           tt-param.ge-ini          = INPUT FRAME fPage2 fl-ge-ini
           tt-param.ge-fim          = INPUT FRAME fPage2 fl-ge-fim
           tt-param.fm-codigo-ini   = INPUT FRAME fPage2 fl-fm-codigo-ini
           tt-param.fm-codigo-fim   = INPUT FRAME fPage2 fl-fm-codigo-fim
           tt-param.entradas        = INPUT FRAME fPage4 tg-entradas
           tt-param.saidas          = INPUT FRAME fPage4 tg-saidas
           .
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/cep/escep085rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-esp-docto-cod wReport 
FUNCTION fn-esp-docto-cod RETURNS CHARACTER
  ( pEsp-Docto AS INTE /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    CASE pEsp-Docto:
        when 1  THEN RETURN "ACA".
        when 2  THEN RETURN "ACT".
        when 3  THEN RETURN "CAC".
        when 4  THEN RETURN "DD" .
        when 5  THEN RETURN "DEV".
        when 6  THEN RETURN "DIV".
        when 7  THEN RETURN "DRM".
        when 8  THEN RETURN "EAC".
        when 9  THEN RETURN "EGF".
        when 10 THEN RETURN "BEM".
        when 11 THEN RETURN "EPR".
        when 12 THEN RETURN "TSL".
        when 13 THEN RETURN "GTN".
        when 14 THEN RETURN "ICM".
        when 15 THEN RETURN "INV".
        when 16 THEN RETURN "IPL".
        when 17 THEN RETURN "MOB".
        when 18 THEN RETURN "NC" .
        when 19 THEN RETURN "NF" .
        when 20 THEN RETURN "NFD".
        when 21 THEN RETURN "NFE".
        when 22 THEN RETURN "NFS".
        when 23 THEN RETURN "NFT".
        when 24 THEN RETURN "PRA".
        when 25 THEN RETURN "REF".
        when 26 THEN RETURN "RCS".
        when 27 THEN RETURN "RDD".
        when 28 THEN RETURN "REQ".
        when 29 THEN RETURN "RFS".
        when 30 THEN RETURN "RM" .
        when 31 THEN RETURN "RRQ".
        when 32 THEN RETURN "STR".
        when 33 THEN RETURN "TRA".
        when 34 THEN RETURN "ZZZ".
        when 35 THEN RETURN "SOB".
        when 36 THEN RETURN "EDD".
        when 37 THEN RETURN "VAR".
        when 38 THEN RETURN "ROP".

    END CASE.
  //RETURN ""   /* Function return value */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-esp-docto-desc wReport 
FUNCTION fn-esp-docto-desc RETURNS CHARACTER
  ( pEspecie AS CHAR /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    CASE pEspecie:

        when "ACA" /* " */ THEN RETURN "Reporte da produ‡Æo".
        when "ACT" /* " */ THEN RETURN "Acerto autom tico gerado pelo c lculo do pre‡o m‚dio".
        when "CAC" /* " */ THEN RETURN "Implementa‡Æo futura".
        when "DD"  /* " */ THEN RETURN "Implanta‡Æo de saldos em ordens de produ‡Æo".
        when "DEV" /* " */ THEN RETURN "Devolu‡Æo de requisi‡Æo de materiais".
        when "DIV" /* " */ THEN RETURN "Transa‡äes diversas".
        when "DRM" /* " */ THEN RETURN "Devolu‡Æo de requisi‡Æo de material eletr“nica".
        when "EAC" /* " */ THEN RETURN "Estorno de reporte de produ‡Æo".
        when "EGF" /* " */ THEN RETURN "Implementa‡Æo futura".
        when "BEM" /* " */ THEN RETURN "Implementa‡Æo futura".
        when "EPR" /* " */ THEN RETURN "Entrada produtos rurais".
        when "TSL" /* " */ THEN RETURN "Transferˆncia de saldo entre itens".
        when "GTN" /* " */ THEN RETURN "Goods transfer note ou Nota de transferˆncia".
        when "ICM" /* " */ THEN RETURN "Imposto de circula‡Æo de mercadorias".
        when "INV" /* " */ THEN RETURN "Invent rio".
        when "IPL" /* " */ THEN RETURN "Implanta‡Æo de saldo".
        when "MOB" /* " */ THEN RETURN "Contabiliza‡Æo de mÆo-de-obra".
        when "NC"  /* " */ THEN RETURN "Nota complementar Exemplo: Despesa acess¢ria na NFE - Nota fiscal de entrada e Nota de rateio".
        when "NF"  /* " */ THEN RETURN "Nota fiscal".
        when "NFD" /* " */ THEN RETURN "Nota fiscal de devolu‡Æo".
        when "NFE" /* " */ THEN RETURN "Nota fiscal de entrada".
        when "NFS" /* " */ THEN RETURN "Nota fiscal de sa¡da".
        when "NFT" /* " */ THEN RETURN "Nota fiscal de transferˆncia entre estabelecimentos".
        when "PRA" /* " */ THEN RETURN "Purchase return aknowledgment ou NFD - Nota devolu‡Æo de compra".
        when "REF" /* " */ THEN RETURN "Refugo".
        when "RCS" /* " */ THEN RETURN "Requisi‡Æo de consignado".
        when "RDD" /* " */ THEN RETURN "Requisi‡Æo de d‚bito direto".
        when "REQ" /* " */ THEN RETURN "Requisi‡Æo".
        when "RFS" /* " */ THEN RETURN "Requisi‡Æo de item f¡sico".
        when "RM"  /* " */ THEN RETURN "Requisi‡Æo de material eletr“nica".
        when "RRQ" /* " */ THEN RETURN "Retorno de requisi‡Æo, via produ‡Æo".
        when "STR" /* " */ THEN RETURN "Substitui‡Æo tribut ria".
        when "TRA" /* " */ THEN RETURN "Transferˆncia entre dep¢sitos".
        when "ZZZ" /* " */ THEN RETURN "Implementa‡Æo futura".
        when "SOB" /* " */ THEN RETURN "Sobra".
        when "EDD" /* " */ THEN RETURN "Estorno de implanta‡Æo de saldo em ordens de produ‡Æo".
        when "VAR" /* " */ THEN RETURN "Varia‡Æo de custo padrÆo".
        when "ROP" /* " */ THEN RETURN "Refugo por opera‡Æo".

    END CASE.
 // RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-esp-docto-int wReport 
FUNCTION fn-esp-docto-int RETURNS INTEGER
  ( pEspecie AS CHAR /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    CASE pEspecie:
        when "ACA" /* " */ THEN RETURN 1.  
        when "ACT" /* " */ THEN RETURN 2.  
        when "CAC" /* " */ THEN RETURN 3.  
        when "DD"  /* " */ THEN RETURN 4.  
        when "DEV" /* " */ THEN RETURN 5.  
        when "DIV" /* " */ THEN RETURN 6.  
        when "DRM" /* " */ THEN RETURN 7.  
        when "EAC" /* " */ THEN RETURN 8.  
        when "EGF" /* " */ THEN RETURN 9.  
        when "BEM" /* " */ THEN RETURN 10. 
        when "EPR" /* " */ THEN RETURN 11. 
        when "TSL" /* " */ THEN RETURN 12. 
        when "GTN" /* " */ THEN RETURN 13. 
        when "ICM" /* " */ THEN RETURN 14. 
        when "INV" /* " */ THEN RETURN 15. 
        when "IPL" /* " */ THEN RETURN 16. 
        when "MOB" /* " */ THEN RETURN 17. 
        when "NC"  /* " */ THEN RETURN 18. 
        when "NF"  /* " */ THEN RETURN 19. 
        when "NFD" /* " */ THEN RETURN 20. 
        when "NFE" /* " */ THEN RETURN 21. 
        when "NFS" /* " */ THEN RETURN 22. 
        when "NFT" /* " */ THEN RETURN 23. 
        when "PRA" /* " */ THEN RETURN 24. 
        when "REF" /* " */ THEN RETURN 25. 
        when "RCS" /* " */ THEN RETURN 26. 
        when "RDD" /* " */ THEN RETURN 27. 
        when "REQ" /* " */ THEN RETURN 28. 
        when "RFS" /* " */ THEN RETURN 29. 
        when "RM"  /* " */ THEN RETURN 30. 
        when "RRQ" /* " */ THEN RETURN 31. 
        when "STR" /* " */ THEN RETURN 32. 
        when "TRA" /* " */ THEN RETURN 33. 
        when "ZZZ" /* " */ THEN RETURN 34. 
        when "SOB" /* " */ THEN RETURN 35. 
        when "EDD" /* " */ THEN RETURN 36. 
        when "VAR" /* " */ THEN RETURN 37. 
        when "ROP" /* " */ THEN RETURN 38. 
    END CASE.

   // RETURN 0.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

