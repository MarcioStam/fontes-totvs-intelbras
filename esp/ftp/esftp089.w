&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-num-serie NO-UNDO LIKE num-serie
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
{include/i-prgvrs.i ESFTP089 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP089
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Produá∆o,OeM,Expediá∆o,SÇrie Relac.

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        tt-num-serie
&GLOBAL-DEFINE hDBOTable      h-boes615
&GLOBAL-DEFINE DBOTable       num-serie

&GLOBAL-DEFINE page0KeyFields tt-num-serie.n-serie
&GLOBAL-DEFINE page0Fields    tt-num-serie.it-codigo
&GLOBAL-DEFINE page1Fields    tt-num-serie.cod-estabel tt-num-serie.data tt-num-serie.ns-keycode tt-num-serie.sigla tt-num-serie.usuario ~
                              tt-num-serie.re-impr tt-num-serie.dt-ult-re tt-num-serie.us-ult-re 
&GLOBAL-DEFINE page2Fields    tt-num-serie.num-pedido
&GLOBAL-DEFINE page3Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

def new global shared var gr-nota-fiscal as rowid no-undo.

DEFINE VARIABLE c-nome-usuar AS CHARACTER   NO-UNDO.

{esp/es0018.i}

DEFINE TEMP-TABLE tt-ns-rel
    FIELD n-serie       LIKE num-serie.n-serie
    FIELD it-codigo     LIKE num-serie.it-codigo
    FIELD desc-item     LIKE ITEM.desc-item.

DEFINE TEMP-TABLE tt-notas NO-UNDO
      FIELD serie       AS CHAR
      FIELD nr-nota-fis AS CHAR
      FIELD nr-volume   AS DECIMAL
      FIELD usuario     AS CHAR
      FIELD nome-usuar  AS CHAR
      FIELD data        AS DATETIME
      FIELD cod-estabel AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-rast

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-notas tt-ns-rel

/* Definitions for BROWSE br-rast                                       */
&Scoped-define FIELDS-IN-QUERY-br-rast tt-notas.serie tt-notas.nr-nota-fis tt-notas.nr-volume tt-notas.usuario tt-notas.nome-usuar @ c-nome-usuar tt-notas.data   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-rast   
&Scoped-define SELF-NAME br-rast
&Scoped-define QUERY-STRING-br-rast FOR EACH tt-notas NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-rast OPEN QUERY {&SELF-NAME} FOR EACH tt-notas NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-rast tt-notas
&Scoped-define FIRST-TABLE-IN-QUERY-br-rast tt-notas


/* Definitions for BROWSE br-serie-sec                                  */
&Scoped-define FIELDS-IN-QUERY-br-serie-sec tt-ns-rel.n-serie tt-ns-rel.it-codigo tt-ns-rel.desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-serie-sec   
&Scoped-define SELF-NAME br-serie-sec
&Scoped-define QUERY-STRING-br-serie-sec FOR EACH tt-ns-rel
&Scoped-define OPEN-QUERY-br-serie-sec OPEN QUERY {&SELF-NAME} FOR EACH tt-ns-rel.
&Scoped-define TABLES-IN-QUERY-br-serie-sec tt-ns-rel
&Scoped-define FIRST-TABLE-IN-QUERY-br-serie-sec tt-ns-rel


/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-br-rast}

/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-br-serie-sec}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-num-serie.n-serie tt-num-serie.it-codigo 
&Scoped-define ENABLED-TABLES tt-num-serie
&Scoped-define FIRST-ENABLED-TABLE tt-num-serie
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys RECT-1 btFirst btPrev ~
btNext btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp ~
fi-desc-item 
&Scoped-Define DISPLAYED-FIELDS tt-num-serie.n-serie tt-num-serie.it-codigo 
&Scoped-define DISPLAYED-TABLES tt-num-serie
&Scoped-define FIRST-DISPLAYED-TABLE tt-num-serie
&Scoped-Define DISPLAYED-OBJECTS fi-desc-item 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-nome-usuar wMaintenance 
FUNCTION f-nome-usuar RETURNS CHARACTER
  ( INPUT p-cod-usuario AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

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
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
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


/* Definitions of the field level widgets                               */
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

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE fi-mot-reimp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Motivo Reimpress∆o" 
     VIEW-AS FILL-IN 
     SIZE 59 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-reimp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-usuario AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 7.25.

DEFINE BUTTON bt-embarque 
     LABEL "Consulta Embarque" 
     SIZE 15 BY 1.

DEFINE VARIABLE fi-desc-fornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-pedido AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Pedido" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fornec-pedido LIKE pedido-compr.cod-emitente
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 10.

DEFINE BUTTON bt-det-nf 
     LABEL "Detalhar NF" 
     SIZE 15 BY 1.

DEFINE VARIABLE fi-op AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 29.57 BY .96
     FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-rast FOR 
      tt-notas SCROLLING.

DEFINE QUERY br-serie-sec FOR 
      tt-ns-rel SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-rast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-rast wMaintenance _FREEFORM
  QUERY br-rast NO-LOCK DISPLAY
      tt-notas.serie       FORMAT "x(3)":U   COLUMN-LABEL "SÇrie"
      tt-notas.nr-nota-fis FORMAT "x(16)":U  COLUMN-LABEL "Nota Fiscal"
      tt-notas.nr-volume   FORMAT ">>,>>9":U COLUMN-LABEL "Nr.Volume"
      tt-notas.usuario     FORMAT "x(12)":U  COLUMN-LABEL "Usu†rio"
      tt-notas.nome-usuar @ c-nome-usuar COLUMN-LABEL "Nome" FORMAT "X(30)":U
            WIDTH 30
      tt-notas.data FORMAT "99/99/9999 HH:MM:SS":U COLUMN-LABEL "Data Coleta"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.58
         FONT 1 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE br-serie-sec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-serie-sec wMaintenance _FREEFORM
  QUERY br-serie-sec NO-LOCK DISPLAY
      tt-ns-rel.n-serie       FORMAT "X(20)"
    tt-ns-rel.it-codigo FORMAT "X(10)"    
    tt-ns-rel.desc-item
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.58
         FONT 1
         TITLE "N£meros de SÇries Relacionados" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
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
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-num-serie.n-serie AT ROW 3 COL 34 COLON-ALIGNED WIDGET-ID 2 FORMAT "x(20)"
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     tt-num-serie.it-codigo AT ROW 4.75 COL 19 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-desc-item AT ROW 4.75 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
     RECT-1 AT ROW 4.5 COL 1 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.33
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     br-rast AT ROW 1.25 COL 2 WIDGET-ID 300
     bt-det-nf AT ROW 10 COL 2 WIDGET-ID 2
     fi-op AT ROW 10.04 COL 45.43 COLON-ALIGNED NO-LABEL WIDGET-ID 46
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.46
         SIZE 84.43 BY 10.62
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage2
     tt-num-serie.num-pedido AT ROW 3 COL 16 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-dt-pedido AT ROW 4 COL 16 COLON-ALIGNED WIDGET-ID 6
     fi-fornec-pedido AT ROW 5 COL 16 COLON-ALIGNED HELP
          "" WIDGET-ID 8
     fi-desc-fornec AT ROW 5 COL 27.57 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     bt-embarque AT ROW 6.75 COL 33 WIDGET-ID 10
     RECT-4 AT ROW 1.25 COL 2 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.46
         SIZE 84.43 BY 10.62
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-num-serie.cod-estabel AT ROW 1.5 COL 15 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-num-serie.data AT ROW 1.5 COL 32 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-num-serie.ns-keycode AT ROW 1.5 COL 63 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-num-serie.sigla AT ROW 2.5 COL 15 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     tt-num-serie.usuario AT ROW 2.5 COL 32 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fi-nome-usuario AT ROW 2.5 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     tt-num-serie.re-impr AT ROW 4.25 COL 20 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     tt-num-serie.dt-ult-re AT ROW 5.25 COL 20 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-num-serie.us-ult-re AT ROW 6.25 COL 20 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fi-nome-reimp AT ROW 6.25 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     fi-mot-reimp AT ROW 7.25 COL 20 COLON-ALIGNED WIDGET-ID 32
     RECT-2 AT ROW 1.25 COL 2 WIDGET-ID 16
     RECT-3 AT ROW 4 COL 2 WIDGET-ID 18
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.46
         SIZE 84.43 BY 10.62
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     br-serie-sec AT ROW 1.25 COL 2 WIDGET-ID 300
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.46
         SIZE 84.43 BY 10.62
         FONT 1 WIDGET-ID 400.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-num-serie T "?" NO-UNDO mgesp num-serie
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
         HEIGHT             = 18.33
         WIDTH              = 90
         MAX-HEIGHT         = 20.38
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 20.38
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
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-num-serie.n-serie IN FRAME fpage0
   EXP-FORMAT                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN fi-fornec-pedido IN FRAME fPage2
   LIKE = mgmov.pedido-compr.cod-emitente EXP-SIZE                      */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB br-rast 1 fPage3 */
ASSIGN 
       fi-op:READ-ONLY IN FRAME fPage3        = TRUE.

/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB br-serie-sec 1 fPage4 */
ASSIGN 
       br-serie-sec:COLUMN-RESIZABLE IN FRAME fPage4       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-rast
/* Query rebuild information for BROWSE br-rast
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-notas NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgesp.num-serie-rast.n-serie = tt-num-serie.n-serie:screen-value in frame fPage0"
     _Query            is OPENED
*/  /* BROWSE br-rast */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-serie-sec
/* Query rebuild information for BROWSE br-serie-sec
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ns-rel.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-serie-sec */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
&ANALYZE-RESUME

 



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


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME bt-det-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-det-nf wMaintenance
ON CHOOSE OF bt-det-nf IN FRAME fPage3 /* Detalhar NF */
DO:

    FIND FIRST num-serie-rast WHERE 
               num-serie-rast.n-serie = tt-num-serie.n-serie:screen-value in frame fPage0 
               NO-LOCK NO-ERROR.

    IF AVAIL num-serie-rast THEN DO:

        FOR FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = num-serie-rast.cod-estabel
            AND   nota-fiscal.serie       = num-serie-rast.serie
            AND   nota-fiscal.nr-nota-fis = num-serie-rast.nr-nota-fis:

            ASSIGN gr-nota-fiscal = ROWID(nota-fiscal).

            RUN ftp/ft0904.w.

        END.

    END. 
    ELSE DO:
        FOR FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = tt-notas.cod-estabel
            AND   nota-fiscal.serie       = tt-notas.serie
            AND   nota-fiscal.nr-nota-fis = tt-notas.nr-nota-fis:

            ASSIGN gr-nota-fiscal = ROWID(nota-fiscal).

            RUN ftp/ft0904.w.

        END.
    END.
/*
    IF AVAIL num-serie-rast THEN DO:

        FOR FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = num-serie-rast.cod-estabel
            AND   nota-fiscal.serie       = num-serie-rast.serie
            AND   nota-fiscal.nr-nota-fis = num-serie-rast.nr-nota-fis:

            ASSIGN gr-nota-fiscal = ROWID(nota-fiscal).

            RUN ftp/ft0904.w.

        END.

    END. */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-embarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-embarque wMaintenance
ON CHOOSE OF bt-embarque IN FRAME fPage2 /* Consulta Embarque */
DO:

    RUN imp/im0055.w.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="eszoom/z01es615.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-rast
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplayFields wMaintenance 
PROCEDURE AfterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL tt-num-serie THEN DO:

        RUN pi-carrega-notas.

        DO WITH FRAME fPage0:

            ASSIGN fi-desc-item:SCREEN-VALUE = "".

            FOR FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = tt-num-serie.it-codigo:
    
                ASSIGN fi-desc-item:SCREEN-VALUE = ITEM.desc-item.
    
            END.

        END.

        DO WITH FRAME fPage1:

            /*ASSIGN lb-motiv-re:SCREEN-VALUE = "Motivo Reimpress∆o:".*/

            DO WITH FRAME fPage0:

                EMPTY TEMP-TABLE tt-prog-ponto.

                RUN esp/es0018p.p (INPUT "escpp066a", 
                                   INPUT 1,
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto).

                ASSIGN fi-mot-reimp:SCREEN-VALUE = "".
        
                FOR first tt-prog-ponto
                    WHERE tt-prog-ponto.sequencia = tt-num-serie.tipo-re:
        
                    ASSIGN fi-mot-reimp:SCREEN-VALUE = tt-prog-ponto.conteudo.
        
                END.
        
            END.

            /**/

            FOR FIRST usuar_mestre NO-LOCK
                WHERE usuar_mestre.cod_usuario = tt-num-serie.usuario:
            END.

            ASSIGN fi-nome-usuario:SCREEN-VALUE = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "".

            FOR FIRST usuar_mestre NO-LOCK
                WHERE usuar_mestre.cod_usuario = tt-num-serie.us-ult-re:
            END.

            ASSIGN fi-nome-reimp:SCREEN-VALUE = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "".

        END.

        DO WITH FRAME fPage2:

            ASSIGN fi-dt-pedido:SCREEN-VALUE = ""
                   fi-fornec-pedido:SCREEN-VALUE = ""
                   fi-desc-fornec:SCREEN-VALUE = "".
            
            FOR FIRST pedido-compr NO-LOCK
                WHERE pedido-compr.num-pedido = tt-num-serie.num-pedido:

                FOR FIRST emitente NO-LOCK
                    WHERE emitente.cod-emitente = pedido-compr.cod-emitente:
                END.

                ASSIGN fi-dt-pedido:SCREEN-VALUE     = STRING(pedido-compr.data-pedido)
                       fi-fornec-pedido:SCREEN-VALUE = STRING(pedido-compr.cod-emitente)
                       fi-desc-fornec:SCREEN-VALUE   = IF AVAIL emitente THEN emitente.nome-emit ELSE "".

            END.

            ASSIGN bt-embarque:SENSITIVE = TRUE.

        END.

        DO WITH FRAME fPage3:

            {&open-query-br-rast}

            ASSIGN bt-det-nf:SENSITIVE = TRUE.

        END.

        DO WITH FRAME fPage4:

            EMPTY TEMP-TABLE tt-ns-rel.

            FOR EACH num-serie-fornec
                WHERE num-serie-fornec.n-serie = tt-num-serie.n-serie:screen-value in frame fPage0:

                FOR FIRST num-serie NO-LOCK
                    WHERE num-serie.n-serie = num-serie-fornec.n-serie-sec:

                    FOR FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = num-serie.it-codigo:

                        CREATE tt-ns-rel.
                        ASSIGN tt-ns-rel.n-serie = num-serie.n-serie
                               tt-ns-rel.it-codigo = num-serie.it-codigo
                               tt-ns-rel.desc-item = ITEM.desc-item.

                    END.

                END.

            END.

            FOR EACH num-serie-fornec
                WHERE num-serie-fornec.n-serie-sec = tt-num-serie.n-serie:screen-value in frame fPage0:

                FOR FIRST num-serie NO-LOCK
                    WHERE num-serie.n-serie = num-serie-fornec.n-serie:

                    FOR FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = num-serie.it-codigo:

                        CREATE tt-ns-rel.
                        ASSIGN tt-ns-rel.n-serie = num-serie.n-serie
                               tt-ns-rel.it-codigo = num-serie.it-codigo
                               tt-ns-rel.desc-item = ITEM.desc-item.

                    END.

                END.

            END.

            {&open-query-br-serie-sec}

        END.

    END.

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

    ASSIGN br-serie-sec:SENSITIVE IN FRAME fPage4 = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
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
    
    DEFINE VARIABLE c-n-serie LIKE {&ttTable}.n-serie FORMAT "X(20)" NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-n-serie  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para N£mero de SÇrie" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    ASSIGN c-n-serie:WIDTH-CHARS IN FRAME fGoToRecord = 22.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_N£mero_de_SÇrie"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-n-serie.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-n-serie).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "N£mero de SÇrie":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    {&open-query-br-rast}

    ENABLE c-n-serie btGoToOK btGoToCancel 
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
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo/boes615.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes615.p YES}
        {btb/btb008za.i2 esbo/boes615.p '' {&hDBOTable}}
    END.
    
    /*RUN setConstraint<Description> IN {&hDBOTable} (<pamameters>) NO-ERROR.*/
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-notas wMaintenance 
PROCEDURE pi-carrega-notas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-notas.
    
    ASSIGN fi-op:SCREEN-VALUE in frame fPage3 = "".

    FOR EACH num-serie-rast WHERE 
             num-serie-rast.n-serie = tt-num-serie.n-serie:screen-value in frame fPage0 
             NO-LOCK.
        
        CREATE tt-notas.
        ASSIGN tt-notas.serie       = num-serie-rast.serie       
               tt-notas.nr-nota-fis = num-serie-rast.nr-nota-fis 
               tt-notas.nr-volume   = num-serie-rast.nr-volume   
               tt-notas.usuario     = num-serie-rast.usuario     
               tt-notas.nome-usuar  = f-nome-usuar(num-serie-rast.usuario)
               tt-notas.data        = num-serie-rast.data
               tt-notas.cod-estabel = num-serie-rast.cod-estabel.
    END.

    IF NOT CAN-FIND(FIRST tt-notas) 
    THEN DO:
        FOR EACH int-col-num-serie WHERE
                 int-col-num-serie.cod-barra = tt-num-serie.n-serie:screen-value in frame fPage0
                 NO-LOCK.
        
            //DISP int-col-num-serie.nr-pedido
            //     int-col-num-serie.cod-barra FORMAT "x(20)".
        
            FOR EACH ord-prod WHERE
                     ord-prod.nr-pedido = STRING(int-col-num-serie.nr-pedido)
                     NO-LOCK.
                //DISP ord-prod.nr-ord-produ.
                FOR FIRST nota-fiscal USE-INDEX ch-pedido
                    WHERE nota-fiscal.nome-ab-cli = ord-prod.nome-abrev
                      AND nota-fiscal.nr-pedcli   = ord-prod.nr-pedido
                          NO-LOCK.
                  
                    CREATE tt-notas.
                    ASSIGN tt-notas.serie       = nota-fiscal.serie       
                           tt-notas.nr-nota-fis = nota-fiscal.nr-nota-fis 
                           tt-notas.nr-volume   = dec(nota-fiscal.nr-volume)
                           tt-notas.usuario     = int-col-num-serie.usuario     
                           tt-notas.nome-usuar  = f-nome-usuar(int-col-num-serie.usuario)
                          // tt-notas.data        = int-col-num-serie.data
                           tt-notas.data        = DATETIME (string(date(int-col-num-serie.data),"99/99/9999") + " " + STRING(int-col-num-serie.hora, "hh:mm:ss")).
                           tt-notas.cod-estabel = nota-fiscal.cod-estabel.

                    ASSIGN fi-op:SCREEN-VALUE in frame fPage3 = "Ord.Prod: " + STRING(ord-prod.nr-ord-produ).
                END.
            END.  
        END.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-nome-usuar wMaintenance 
FUNCTION f-nome-usuar RETURNS CHARACTER
  ( INPUT p-cod-usuario AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST usuar_mestre NO-LOCK
        WHERE usuar_mestre.cod_usuario = p-cod-usuario:

        RETURN usuar_mestre.nom_usuario.

    END.

    RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

