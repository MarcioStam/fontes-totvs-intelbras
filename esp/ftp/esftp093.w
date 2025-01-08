&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME wFormation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttembarque NO-UNDO LIKE embarque
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttnota-fiscal NO-UNDO LIKE nota-fiscal
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttnota-fiscal-quarentena NO-UNDO LIKE nota-fiscal
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wFormation 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp093 2.06.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          esftp093
&GLOBAL-DEFINE Version          2.06.00.000

&GLOBAL-DEFINE First            NO
&GLOBAL-DEFINE Prev             NO
&GLOBAL-DEFINE Next             NO
&GLOBAL-DEFINE Last             NO
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE DelTarget        YES
&GLOBAL-DEFINE AddTarget        YES
&GLOBAL-DEFINE DelAllTarget     YES
&GLOBAL-DEFINE AddAllTarget     YES

&GLOBAL-DEFINE UpdateTarget     NO

&GLOBAL-DEFINE ttParent         ttembarque              
&GLOBAL-DEFINE hDBOParent       hDBOParent              
&GLOBAL-DEFINE DBOParentTable   embarque                
                                                        
&GLOBAL-DEFINE ttSource         ttnota-fiscal           
&GLOBAL-DEFINE hDBOSource       hDBOSource              
&GLOBAL-DEFINE DBOSourceTable   nota-fiscal             
                                                        
&GLOBAL-DEFINE ttTarget         ttnota-fiscal-quarentena
&GLOBAL-DEFINE hDBOTarget       hDBOTarget              
&GLOBAL-DEFINE DBOTargetTable   nota-fiscal             

&GLOBAL-DEFINE page0Fields      ttembarque.cdd-embarq ttembarque.nome-transp
&GLOBAL-DEFINE page1Fields      btDetail btparam-source btparam-source-2 d-dt-emis-source-fim d-dt-emis-source-ini d-dt-emis-target-fim d-dt-emis-target-ini

&GLOBAL-DEFINE SourceBrowse      brSource
&GLOBAL-DEFINE TargetBrowse      brTarget

&GLOBAL-DEFINE NumRowsReturnedSource 9999999
&GLOBAL-DEFINE NumRowsReturnedTarget 9999999

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{utp/ut-glob.i}
{upc/btb910za-upc.i} /* v_cod_estab_usuar */
{esp/es0018.i}
DEFINE VARIABLE l-cli-difer     AS LOGICAL FORMAT "*/ " NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSource} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTarget} AS HANDLE NO-UNDO.

DEFINE VARIABLE i-num-row-a      AS INTEGER NO-UNDO.
DEFINE VARIABLE i-num-select-row AS INTEGER NO-UNDO.
DEFINE VARIABLE l-volta          AS LOGICAL NO-UNDO.
DEFINE VARIABLE iRowid           AS INTEGER NO-UNDO.

/* Temp-tables Definitions ---                                          */
DEF TEMP-TABLE tt-prog-ponto-tmp
   FIELD nome-programa    LIKE ponto-programa.nome-programa
   FIELD ponto            LIKE ponto-programa.ponto
   FIELD sequencia        LIKE conteudo-programa.sequencia 
   FIELD conteudo         LIKE conteudo-programa.conteudo
   INDEX seq-campo nome-programa ponto sequencia.

DEFINE VARIABLE i-nome-programa  AS   CHARACTER NO-UNDO.
DEFINE VARIABLE i-ponto          AS   INTEGER   NO-UNDO.
DEFINE VARIABLE i-sequencia      AS   INTEGER   NO-UNDO.
DEFINE VARIABLE i-conteudo       AS   CHARACTER NO-UNDO.
DEFINE VARIABLE lchamadamanual   AS   LOGICAL   NO-UNDO.
DEFINE VARIABLE i-qtd-volume     LIKE volume-nf.nr-volume NO-UNDO.

DEFINE BUFFER   b-ponto-programa FOR ponto-programa.

DEFINE VARIABLE c-serie-ini       AS CHARACTER INIT "":U EXTENT 2 NO-UNDO.
DEFINE VARIABLE c-serie-fim       AS CHARACTER INIT "ZZZZZ":U EXTENT 2 NO-UNDO.
DEFINE VARIABLE c-nr-nota-fis-ini AS CHARACTER INIT "":U EXTENT 2 NO-UNDO.
DEFINE VARIABLE c-nr-nota-fis-fim AS CHARACTER INIT "ZZZZZZZZZZZZZZZZ":U EXTENT 2 NO-UNDO.
DEFINE VARIABLE d-dt-emis-ini     AS DATE FORMAT "99/99/9999":U EXTENT 2 NO-UNDO.
DEFINE VARIABLE d-dt-emis-fim     AS DATE FORMAT "99/99/9999":U EXTENT 2 NO-UNDO.
DEFINE VARIABLE l-bt-press        AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Formation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSource

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttnota-fiscal ttnota-fiscal-quarentena

/* Definitions for BROWSE brSource                                      */
&Scoped-define FIELDS-IN-QUERY-brSource ttnota-fiscal.cod-estabel ttnota-fiscal.serie ttnota-fiscal.nr-nota-fis ttnota-fiscal.dt-emis-nota ttnota-fiscal.nome-ab-cli fnQtdeVolume(ttnota-fiscal.cod-estabel,ttnota-fiscal.serie,ttnota-fiscal.nr-nota-fis) @ i-qtd-volume fnClienteDifer(ttnota-fiscal.cod-emitente) @ l-cli-difer   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSource   
&Scoped-define SELF-NAME brSource
&Scoped-define QUERY-STRING-brSource FOR EACH ttnota-fiscal NO-LOCK BY ttnota-fiscal.nr-nota-fis
&Scoped-define OPEN-QUERY-brSource OPEN QUERY {&SELF-NAME} FOR EACH ttnota-fiscal NO-LOCK BY ttnota-fiscal.nr-nota-fis.
&Scoped-define TABLES-IN-QUERY-brSource ttnota-fiscal
&Scoped-define FIRST-TABLE-IN-QUERY-brSource ttnota-fiscal


/* Definitions for BROWSE brTarget                                      */
&Scoped-define FIELDS-IN-QUERY-brTarget ttnota-fiscal-quarentena.cod-estabel ttnota-fiscal-quarentena.serie ttnota-fiscal-quarentena.nr-nota-fis ttnota-fiscal-quarentena.dt-emis-nota ttnota-fiscal-quarentena.nome-ab-cli ttnota-fiscal-quarentena.nome-transp fnQtdeVolume(ttnota-fiscal-quarentena.cod-estabel,ttnota-fiscal-quarentena.serie,ttnota-fiscal-quarentena.nr-nota-fis) @ i-qtd-volume fnClienteDifer(ttnota-fiscal-quarentena.cod-emitente) @ l-cli-difer   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTarget   
&Scoped-define SELF-NAME brTarget
&Scoped-define QUERY-STRING-brTarget FOR EACH ttnota-fiscal-quarentena NO-LOCK                            WHERE ttnota-fiscal-quarentena.cdd-embarq    = iEmbarque-quarentena                            AND   ttnota-fiscal-quarentena.serie        >= c-serie-ini[2]                            AND   ttnota-fiscal-quarentena.serie        <= c-serie-fim[2]                            AND   ttnota-fiscal-quarentena.nr-nota-fis  >= c-nr-nota-fis-ini[2]                            AND   ttnota-fiscal-quarentena.nr-nota-fis  <= c-nr-nota-fis-fim[2]                            AND   ttnota-fiscal-quarentena.dt-emis-nota >= d-dt-emis-ini[2]                            AND   ttnota-fiscal-quarentena.dt-emis-nota <= d-dt-emis-fim[2]                            BY    ttnota-fiscal-quarentena.nr-nota-fis     INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTarget OPEN QUERY {&SELF-NAME} FOR EACH ttnota-fiscal-quarentena NO-LOCK                            WHERE ttnota-fiscal-quarentena.cdd-embarq    = iEmbarque-quarentena                            AND   ttnota-fiscal-quarentena.serie        >= c-serie-ini[2]                            AND   ttnota-fiscal-quarentena.serie        <= c-serie-fim[2]                            AND   ttnota-fiscal-quarentena.nr-nota-fis  >= c-nr-nota-fis-ini[2]                            AND   ttnota-fiscal-quarentena.nr-nota-fis  <= c-nr-nota-fis-fim[2]                            AND   ttnota-fiscal-quarentena.dt-emis-nota >= d-dt-emis-ini[2]                            AND   ttnota-fiscal-quarentena.dt-emis-nota <= d-dt-emis-fim[2]                            BY    ttnota-fiscal-quarentena.nr-nota-fis     INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTarget ttnota-fiscal-quarentena
&Scoped-define FIRST-TABLE-IN-QUERY-brTarget ttnota-fiscal-quarentena


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSource}~
    ~{&OPEN-QUERY-brTarget}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttembarque.cdd-embarq ttembarque.nome-transp 
&Scoped-define ENABLED-TABLES ttembarque
&Scoped-define FIRST-ENABLED-TABLE ttembarque
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent RECT-2 btGoTo btSearch ~
btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS ttembarque.cdd-embarq ~
ttembarque.nome-transp 
&Scoped-define DISPLAYED-TABLES ttembarque
&Scoped-define FIRST-DISPLAYED-TABLE ttembarque


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnClienteDifer wFormation 
FUNCTION fnClienteDifer RETURNS LOGICAL
  ( icliente AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnQtdeVolume wFormation 
FUNCTION fnQtdeVolume RETURNS INTEGER
  ( c-cod-estabel AS CHAR, c-serie AS CHAR, c-nr-nota-fis AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wFormation AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
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

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 122 BY 13.5.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 122 BY 1.42.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 122 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddAllTarget 
     IMAGE-UP FILE "image\add-all":U
     IMAGE-INSENSITIVE FILE "image\ii-add-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui Todos".

DEFINE BUTTON btAddTarget 
     IMAGE-UP FILE "adeicon\next-au":U
     IMAGE-INSENSITIVE FILE "adeicon\next-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui".

DEFINE BUTTON btDelAllTarget 
     IMAGE-UP FILE "image\del-all":U
     IMAGE-INSENSITIVE FILE "image\ii-del-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira Todos".

DEFINE BUTTON btDelTarget 
     IMAGE-UP FILE "adeicon\prev-au":U
     IMAGE-INSENSITIVE FILE "adeicon\prev-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira".

DEFINE BUTTON btDetail-Source 
     IMAGE-UP FILE "image/im-det.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "&Detalhe Cliente Diferenciado".

DEFINE BUTTON btDetail-Target 
     IMAGE-UP FILE "image/im-det.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "&Detalhe Cliente Diferenciado".

DEFINE BUTTON btparam-source 
     IMAGE-UP FILE "image/im-fil.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-fil.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "&Filtro".

DEFINE BUTTON btparam-target 
     IMAGE-UP FILE "image/im-fil.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-fil.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "&Filtro".

DEFINE VARIABLE iEmbarque-quarentena AS DECIMAL FORMAT ">>>>>>>>>>>>>>>9":U INITIAL 0 
     LABEL "Embarque Quarentena" 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53.29 BY 1.33.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53 BY 1.33.

DEFINE VARIABLE l-diferenciado AS LOGICAL INITIAL no 
     LABEL "Diferenciados" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.57 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSource FOR 
      ttnota-fiscal SCROLLING.

DEFINE QUERY brTarget FOR 
      ttnota-fiscal-quarentena SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSource wFormation _FREEFORM
  QUERY brSource NO-LOCK DISPLAY
      ttnota-fiscal.cod-estabel                                FORMAT "X(3)":U       WIDTH 03.00
      ttnota-fiscal.serie                                      FORMAT "x(5)":U       WIDTH 03.00
      ttnota-fiscal.nr-nota-fis                                                      WIDTH 09.00 COLUMN-LABEL "Nr.Nota":U
      ttnota-fiscal.dt-emis-nota                               FORMAT "99/99/9999":U WIDTH 09.00 COLUMN-LABEL "Dt.Emiss∆o":U
      ttnota-fiscal.nome-ab-cli                                FORMAT "x(12)":U      WIDTH 13.00 COLUMN-LABEL "Cliente":U
      fnQtdeVolume(ttnota-fiscal.cod-estabel,ttnota-fiscal.serie,ttnota-fiscal.nr-nota-fis) @ i-qtd-volume FORMAT ">>,>>9":U WIDTH 05.00 COLUMN-LABEL "Qt.Vol."
      fnClienteDifer(ttnota-fiscal.cod-emitente) @ l-cli-difer FORMAT "*/ ":U        WIDTH 01.50 COLUMN-LABEL "D":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SEPARATORS MULTIPLE SIZE 53.29 BY 11.29
         FONT 2.

DEFINE BROWSE brTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTarget wFormation _FREEFORM
  QUERY brTarget NO-LOCK DISPLAY
      ttnota-fiscal-quarentena.cod-estabel                                FORMAT "X(3)":U       WIDTH 03.00                             
      ttnota-fiscal-quarentena.serie                                      FORMAT "x(5)":U       WIDTH 03.00                            
      ttnota-fiscal-quarentena.nr-nota-fis                                                      WIDTH 09.00 COLUMN-LABEL "Nr.Nota":U         
      ttnota-fiscal-quarentena.dt-emis-nota                               FORMAT "99/99/9999":U WIDTH 09.00 COLUMN-LABEL "Dt.Emiss∆o":U
      ttnota-fiscal-quarentena.nome-ab-cli                                FORMAT "x(12)":U      WIDTH 13.00 COLUMN-LABEL "Cliente":U
      ttnota-fiscal-quarentena.nome-transp                                FORMAT "x(12)":U      WIDTH 13.00 COLUMN-LABEL "Transp":U
      fnQtdeVolume(ttnota-fiscal-quarentena.cod-estabel,ttnota-fiscal-quarentena.serie,ttnota-fiscal-quarentena.nr-nota-fis) @ i-qtd-volume FORMAT ">>,>>9":U WIDTH 05.00 COLUMN-LABEL "Qt.Vol."
      fnClienteDifer(ttnota-fiscal-quarentena.cod-emitente) @ l-cli-difer FORMAT "*/ ":U        WIDTH 01.50 COLUMN-LABEL "D":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 53.29 BY 11.29
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btGoTo AT ROW 1.13 COL 1.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 5.43 HELP
          "Pesquisa"
     btQueryJoins AT ROW 1.13 COL 104.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 108.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 112.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 116.86 HELP
          "Ajuda"
     ttembarque.cdd-embarq AT ROW 3 COL 17 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 22 BY .79
     ttembarque.nome-transp AT ROW 3 COL 51 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
     RECT-2 AT ROW 4.25 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 124 BY 17.67
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brSource AT ROW 2.42 COL 2 WIDGET-ID 200
     btDetail-Source AT ROW 1.17 COL 2.72 WIDGET-ID 44
     iEmbarque-quarentena AT ROW 1.25 COL 95.86 COLON-ALIGNED WIDGET-ID 14
     btparam-source AT ROW 1.17 COL 6.57 WIDGET-ID 38
     btAddAllTarget AT ROW 5 COL 58
     btAddTarget AT ROW 6.17 COL 58
     btDelTarget AT ROW 7.29 COL 58
     btDelAllTarget AT ROW 8.42 COL 58
     brTarget AT ROW 2.38 COL 68 WIDGET-ID 300
     btparam-target AT ROW 1.17 COL 72.86 WIDGET-ID 40
     btDetail-Target AT ROW 1.17 COL 69 WIDGET-ID 46
     l-diferenciado AT ROW 1.29 COL 39 WIDGET-ID 34
     RECT-3 AT ROW 1 COL 68 WIDGET-ID 16
     RECT-4 AT ROW 1.04 COL 2 WIDGET-ID 48
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.43 ROW 4.42
         SIZE 120.57 BY 13.08
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Formation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttembarque T "?" NO-UNDO mgcad embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttnota-fiscal T "?" NO-UNDO mgmov nota-fiscal
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttnota-fiscal-quarentena T "?" NO-UNDO mgmov nota-fiscal
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wFormation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.83
         WIDTH              = 123
         MAX-HEIGHT         = 21.21
         MAX-WIDTH          = 131.57
         VIRTUAL-HEIGHT     = 21.21
         VIRTUAL-WIDTH      = 131.57
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wFormation 
/* ************************* Included-Libraries *********************** */

{formation/formation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wFormation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* BROWSE-TAB brSource 1 fPage1 */
/* BROWSE-TAB brTarget btDelAllTarget fPage1 */
/* SETTINGS FOR FILL-IN iEmbarque-quarentena IN FRAME fPage1
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wFormation)
THEN wFormation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSource
/* Query rebuild information for BROWSE brSource
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttnota-fiscal NO-LOCK BY ttnota-fiscal.nr-nota-fis.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.ttnota-fiscal.nr-embarque = ttembarque.nr-embarque
 AND Temp-Tables.ttnota-fiscal.dt-embarque = ?"
     _Query            is OPENED
*/  /* BROWSE brSource */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTarget
/* Query rebuild information for BROWSE brTarget
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttnota-fiscal-quarentena NO-LOCK
                           WHERE ttnota-fiscal-quarentena.cdd-embarq    = iEmbarque-quarentena
                           AND   ttnota-fiscal-quarentena.serie        >= c-serie-ini[2]
                           AND   ttnota-fiscal-quarentena.serie        <= c-serie-fim[2]
                           AND   ttnota-fiscal-quarentena.nr-nota-fis  >= c-nr-nota-fis-ini[2]
                           AND   ttnota-fiscal-quarentena.nr-nota-fis  <= c-nr-nota-fis-fim[2]
                           AND   ttnota-fiscal-quarentena.dt-emis-nota >= d-dt-emis-ini[2]
                           AND   ttnota-fiscal-quarentena.dt-emis-nota <= d-dt-emis-fim[2]
                           BY    ttnota-fiscal-quarentena.nr-nota-fis
    INDEXED-REPOSITION
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brTarget */
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

&Scoped-define SELF-NAME wFormation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wFormation wFormation
ON END-ERROR OF wFormation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wFormation wFormation
ON WINDOW-CLOSE OF wFormation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSource
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSource wFormation
ON VALUE-CHANGED OF brSource IN FRAME fPage1
DO:
    IF  AVAIL ttnota-fiscal THEN DO:
        IF  fnClienteDifer(ttnota-fiscal.cod-emitente) THEN
            ASSIGN btDetail-Source:SENSITIVE IN FRAME fPage1 = TRUE.
        ELSE
            ASSIGN btDetail-Source:SENSITIVE IN FRAME fPage1 = FALSE.

        ASSIGN l-diferenciado:SENSITIVE  IN FRAME fPage1 = TRUE.
    END.
    ELSE
        ASSIGN l-diferenciado:SENSITIVE  IN FRAME fPage1 = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTarget
&Scoped-define SELF-NAME brTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTarget wFormation
ON MOUSE-SELECT-DBLCLICK OF brTarget IN FRAME fPage1
DO:
    APPLY "choose":U TO btDelTarget IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTarget wFormation
ON VALUE-CHANGED OF brTarget IN FRAME fPage1
DO:
    IF  AVAIL ttnota-fiscal-quarentena
    AND fnClienteDifer(ttnota-fiscal-quarentena.cod-emitente) 
    THEN ASSIGN btDetail-Target:SENSITIVE IN FRAME fPage1 = TRUE.
    ELSE ASSIGN btDetail-Target:SENSITIVE IN FRAME fPage1 = FALSE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddAllTarget wFormation
ON CHOOSE OF btAddAllTarget IN FRAME fPage1
DO:
    IF CAN-FIND(FIRST ttnota-fiscal) THEN DO:
        RUN piVerificaIntegracao.
        IF RETURN-VALUE <> "OK" THEN
            RETURN.
        brSource:SELECT-ALL().
        RUN pi-addTarget.
        ASSIGN lchamadamanual = YES.
        RUN openQueries.

        IF CAN-FIND(FIRST ttnota-fiscal-quarentena) THEN
            ENABLE  btDelAllTarget btDelTarget WITH FRAME fPage1.
        ELSE
            DISABLE btDelAllTarget btDelTarget WITH FRAME fPage1.
    END. /* IF  CAN-FIND(FIRST ttnota-fiscal) */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddTarget wFormation
ON CHOOSE OF btAddTarget IN FRAME fPage1
DO:
    IF CAN-FIND(FIRST ttnota-fiscal) THEN DO:
        RUN piVerificaIntegracao.
        IF RETURN-VALUE <> "OK" THEN
            RETURN.

        RUN pi-addTarget.
        ASSIGN lchamadamanual = YES.
        RUN openQueries.

        IF CAN-FIND(FIRST ttnota-fiscal-quarentena) THEN
            ENABLE  btDelAllTarget btDelTarget WITH FRAME fPage1.
        ELSE
            DISABLE btDelAllTarget btDelTarget WITH FRAME fPage1.
    END. /* IF  CAN-FIND(FIRST ttnota-fiscal) */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelAllTarget wFormation
ON CHOOSE OF btDelAllTarget IN FRAME fPage1
DO:
    IF CAN-FIND(FIRST ttnota-fiscal-quarentena) THEN DO:
        RUN piVerificaIntegracao.
        IF RETURN-VALUE <> "OK" THEN
            RETURN.

        brTarget:SELECT-ALL().
        RUN pi-delTarget.
        ASSIGN lchamadamanual = YES.
        RUN openQueries.

        IF CAN-FIND(FIRST ttnota-fiscal) THEN
            ENABLE btAddAllTarget btAddTarget WITH FRAME fPage1.
        ELSE
            DISABLE btAddAllTarget btAddTarget WITH FRAME fPage1.
    END. /* IF  CAN-FIND(FIRST ttnota-fiscal-quarentena) */  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelTarget wFormation
ON CHOOSE OF btDelTarget IN FRAME fPage1
DO:
    IF CAN-FIND(FIRST ttnota-fiscal-quarentena) THEN DO:
        RUN piVerificaIntegracao.
        IF RETURN-VALUE <> "OK" THEN
            RETURN.

        RUN pi-delTarget.
        ASSIGN lchamadamanual = YES.
        RUN openQueries.

        IF CAN-FIND(FIRST ttnota-fiscal) THEN
            ENABLE  btAddAllTarget btAddTarget WITH FRAME fPage1.
        ELSE
            DISABLE btAddAllTarget btAddTarget WITH FRAME fPage1.
    END. /* IF  CAN-FIND(FIRST ttnota-fiscal-quarentena) */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDetail-Source
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetail-Source wFormation
ON CHOOSE OF btDetail-Source IN FRAME fPage1
DO:
    IF  AVAIL ttnota-fiscal THEN RUN esp/ftp/esftp093a.w (INPUT ttnota-fiscal.cod-emitente).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDetail-Target
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetail-Target wFormation
ON CHOOSE OF btDetail-Target IN FRAME fPage1
DO:
    IF  AVAIL ttnota-fiscal-quarentena THEN RUN esp/ftp/esftp093a.w (INPUT ttnota-fiscal-quarentena.cod-emitente).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wFormation
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wFormation
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wFormation
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btparam-source
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btparam-source wFormation
ON CHOOSE OF btparam-source IN FRAME fPage1
DO:
    RUN esp\ftp\esftp093b.w (INPUT-OUTPUT c-serie-ini[1],
                             INPUT-OUTPUT c-serie-fim[1],
                             INPUT-OUTPUT c-nr-nota-fis-ini[1],
                             INPUT-OUTPUT c-nr-nota-fis-fim[1],
                             INPUT-OUTPUT d-dt-emis-ini[1],
                             INPUT-OUTPUT d-dt-emis-fim[1],
                             OUTPUT l-bt-press).

    IF  l-bt-press THEN DO:
        {formation/openqueriessource.i &QUERY="Nr-Embarque"
                                       &ConstraintParameters=c-serie-ini[1],c-serie-fim[1],c-nr-nota-fis-ini[1],c-nr-nota-fis-fim[1],d-dt-emis-ini[1],d-dt-emis-fim[1],ttembarque.cdd-embarq
                                       &OpenAlways="YES"}    
        APPLY "VALUE-CHANGED":U TO brSource IN FRAME fPage1.
    END. /* IF  l-bt-press */

    ASSIGN l-diferenciado:SENSITIVE IN FRAME fPage1 = CAN-FIND(FIRST ttnota-fiscal).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btparam-target
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btparam-target wFormation
ON CHOOSE OF btparam-target IN FRAME fPage1
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} iEmbarque-quarentena.

    RUN esp\ftp\esftp093b.w (INPUT-OUTPUT c-serie-ini[2],
                             INPUT-OUTPUT c-serie-fim[2],
                             INPUT-OUTPUT c-nr-nota-fis-ini[2],
                             INPUT-OUTPUT c-nr-nota-fis-fim[2],
                             INPUT-OUTPUT d-dt-emis-ini[2],
                             INPUT-OUTPUT d-dt-emis-fim[2],
                             OUTPUT l-bt-press).

    IF  l-bt-press THEN DO:

/*         {&OPEN-QUERY-brTarget} */
        RUN openQueryTarget.
        APPLY "VALUE-CHANGED":U TO brTarget IN FRAME fPage1.

    END. /* IF  l-bt-press */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wFormation
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wFormation
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wFormation
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
   {method/zoomreposition.i &ProgramZoom="dizoom/z02di041.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME l-diferenciado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-diferenciado wFormation
ON VALUE-CHANGED OF l-diferenciado IN FRAME fPage1 /* Diferenciados */
DO:
    IF  l-diferenciado:CHECKED IN FRAME fPage1 THEN DO:
        FOR EACH ttnota-fiscal:
             IF NOT fnClienteDifer(ttnota-fiscal.cod-emitente) THEN
                 DELETE ttnota-fiscal.
             ELSE
                 NEXT.
        END.
        {&OPEN-QUERY-brSource}
    END.
    ELSE DO:
        {formation/openqueriessource.i &QUERY="Nr-Embarque"
                                       &ConstraintParameters=c-serie-ini[1],c-serie-fim[1],c-nr-nota-fis-ini[1],c-nr-nota-fis-fim[1],d-dt-emis-ini[1],d-dt-emis-fim[1],ttembarque.cdd-embarq
                                       &OpenAlways="YES"} 
    END.
                                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSource
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wFormation 


/* ***************************  Main Block  *************************** */

/*:T--- L¢gica para inicializaá∆o do programam ---*/

    /*{formation/mainblock.i}*/
    
/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).

/*--- Evento de CLOSE padrío para THIS-PROCEDURE ---*/
ON CLOSE OF THIS-PROCEDURE 
   RUN destroyInterface IN THIS-PROCEDURE.

/*--- Evento de CTRL-TAB padrío para THIS-PROCEDURE ---*/
&IF "{&Folder}":U = "YES":U &THEN
    ON CTRL-TAB OF {&WINDOW-NAME} ANYWHERE
        RUN nextFolder IN hFolder.
&ENDIF

/*--- Evento de SHIFT-CTRL-TAB padrío para THIS-PROCEDURE ---*/
&IF "{&Folder}":U = "YES":U &THEN
    ON SHIFT-CTRL-TAB OF {&WINDOW-NAME} ANYWHERE
        RUN prevFolder IN hFolder.
&ENDIF

/*--- Evento de CURSOR-DOWN, PAGE-DOWN, OFF-END e END  padrío para o browse origem ---*/
&IF "{&SourceBrowse}":U <> "":U &THEN

    ON CURSOR-DOWN OF {&SourceBrowse} IN FRAME fPage1 DO:
        {formation/cursordown.i &Type="Source"}
    END.
    
    /*ON END OF {&SourceBrowse} IN FRAME fPage1 DO:
        {formation/end.i &Type="Source"} 
    END.

    ON OFF-END OF {&SourceBrowse} IN FRAME fPage1 DO:
        {formation/offend.i &Type="Source"}
    END.*/
    
    ON PAGE-DOWN OF {&SourceBrowse} IN FRAME fPage1 DO:
        {formation/pagedown.i &Type="Source"}
    END.
    
    ON CURSOR-UP OF {&SourceBrowse} IN FRAME fPage1 DO:
        {formation/cursorup.i &Type="Source"}
    END.
    
    ON HOME OF {&SourceBrowse} IN FRAME fPage1 DO:
        {formation/home.i &Type="Source"}
    END.
    
    ON OFF-HOME OF {&SourceBrowse} IN FRAME fPage1 DO:
        {formation/offhome.i &Type="Source"}
    END.
    
    ON PAGE-UP OF {&SourceBrowse} IN FRAME fPage1 DO:
        {formation/pageup.i &Type="Source"}
    END.

    ON MOUSE-SELECT-DBLCLICK OF {&SourceBrowse} IN FRAME fPage1 DO:
       IF "{&AddTarget}":U = "YES":U THEN 
           APPLY "CHOOSE":U TO BtAddTarget.
    END.

&ENDIF

/*--- Evento de CURSOR-DOWN, PAGE-DOWN, OFF-END e END padrío para o browse destino ---*/
&IF "{&TargetBrowse}":U <> "":U &THEN
    
    ON CURSOR-DOWN OF {&TargetBrowse} IN FRAME fpage1 DO:
        {formation/cursordown.i &Type="Target"}
    END.
    
    /*ON END OF {&TargetBrowse} IN FRAME fpage1 DO:
        {formation/end.i &Type="Target"}
    END.
    
    ON OFF-END OF {&TargetBrowse} IN FRAME fpage1 DO:
        {formation/offend.i &Type="Target"}
    END.*/
    
    ON PAGE-DOWN OF {&TargetBrowse} IN FRAME fpage1 DO:
        {formation/pagedown.i &Type="Target"}
    END.
    
    ON MOUSE-SELECT-DBLCLICK OF {&TargetBrowse} IN FRAME fpage1 DO:
        {formation/dblclick.i &Type="Target"}
    END.
    
    ON CURSOR-UP OF {&TargetBrowse} IN FRAME fpage1 DO:
        {formation/cursorup.i &Type="Target"}
    END.
    
    ON HOME OF {&TargetBrowse} IN FRAME fpage1 DO:
        {formation/home.i &Type="Target"}
    END.
    
    ON OFF-HOME OF {&TargetBrowse} IN FRAME fpage1 DO:
        {formation/offhome.i &Type="Target"}
    END.
    
    ON PAGE-UP OF {&TargetBrowse} IN FRAME fpage1 DO:
        {formation/pageup.i &Type="Target"}
    END.
&ENDIF 

/*--- Seta CURRENT-WINDOW como sendo a window atual ---*/
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/*--- Padrío para janelas GUI ---*/
PAUSE 0 BEFORE-HIDE.

&IF "{&UIB_is_Running}":U <> "":U &THEN
    /*--- Inicializa programa ---*/
    RUN initializeInterface IN THIS-PROCEDURE.
&ELSE
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        /*--- Inicializa programa ---*/
        RUN initializeInterface IN THIS-PROCEDURE.
&ENDIF

/*Alteracao 27/07/2005 - tech1007 - procedure para traduzir tooltips de botoes e tamb≤m de menu*/
/*RUN translate IN THIS-PROCEDURE.*/
/*Fim alteracao 27/07/2005*/

/*--- Block principal do programa ---*/
DO ON ERROR   UNDO, LEAVE
   ON END-KEY UNDO, LEAVE:
    
    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).
    
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wFormation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
ASSIGN INPUT FRAME fPage0 ttembarque.cdd-embarq.

FIND FIRST pre-fatur NO-LOCK
     WHERE pre-fatur.cdd-embarq   = ttembarque.cdd-embarq NO-ERROR.

IF AVAIL pre-fatur THEN
    ASSIGN ttembarque.nome-transp = pre-fatur.nome-transp.
ELSE 
    ASSIGN ttembarque.nome-transp = "".

DISPLAY ttembarque.nome-transp WITH FRAME fPage0.
RUN pi-busca-EmbarqueQuarentena.
ASSIGN INPUT FRAME fPage1 iEmbarque-quarentena.

EMPTY TEMP-TABLE ttnota-fiscal.
{&OPEN-QUERY-BRSOURCE}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wFormation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    FOR EACH  b-ponto-programa NO-LOCK 
        WHERE b-ponto-programa.nome-programa = "esftp010":
        RUN esp\es0018p.p (INPUT b-ponto-programa.nome-programa,
                           INPUT b-ponto-programa.ponto,
                           INPUT i-sequencia,
                           INPUT i-conteudo,
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        FOR EACH tt-prog-ponto:
            CREATE tt-prog-ponto-tmp.
            BUFFER-COPY tt-prog-ponto TO tt-prog-ponto-tmp.
        END. /* FOR EACH tt-prog-ponto: */
    END. /* FOR EACH  b-ponto-programa NO-LOCK */

    RUN pi-busca-EmbarqueQuarentena.
    
    ENABLE btparam-source btAddAllTarget btAddTarget btparam-target btDelAllTarget btDelTarget WITH FRAME fPage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wFormation 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
  Purpose:     Exibe dialog de Vˇ Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY LABEL "&Cancelar" SIZE 10 BY 1    BGCOLOR 8.
    DEFINE BUTTON btGoToOK     AUTO-GO      LABEL "&OK"       SIZE 10 BY 1    BGCOLOR 8.
    DEFINE RECTANGLE rtGoToButton EDGE-PIXELS 2 GRAPHIC-EDGE  SIZE 45 BY 1.42 BGCOLOR 7.
    DEFINE VARIABLE rGoTo         AS   ROWID NO-UNDO.
    DEFINE VARIABLE i-nr-embarque LIKE {&ttParent}.cdd-embarq NO-UNDO.

    DEFINE FRAME fGoToRecord
        i-nr-embarque     AT ROW 1.71 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 20 BY .88 
        btGoToOK          AT ROW 3.63 COL 02.14
        btGoToCancel      AT ROW 3.63 COL 13.00
        rtGoToButton      AT ROW 3.38 COL 01.00
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Embarque" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Embarque"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.

    ON  "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-nr-embarque.

        /* Posiciona query, do DBO, atraves dos valores do indice unico */
        RUN goToKey IN {&hDBOParent} (INPUT i-nr-embarque).
        IF  RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Embarque").
            RETURN NO-APPLY.
        END. /* IF  RETURN-VALUE = "NOK":U THEN */

        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).

        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END. /* ON  "CHOOSE":U OF btGoToOK */

    ENABLE i-nr-embarque btGoToOK btGoToCancel WITH FRAME fGoToRecord. 

    WAIT-FOR "GO":U OF FRAME fGoToRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wFormation 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /*---[ Embarque ]-----------------------------------------------------*/
    IF  NOT VALID-HANDLE({&hDBOParent}) THEN DO:
        {btb/btb008za.i1 dibo/bodi041-2.p}
        {btb/btb008za.i2 dibo/bodi041-2.p '' {&hDBOParent}} 
    END. /* IF  NOT VALID-HANDLE({&hDBOParent}) */

    RUN openQueryStatic IN {&hDBOParent} (INPUT "Default":U) NO-ERROR.
    
    /*:T---[ Nota-Fiscal ]------------------------------------------------*/
    IF  NOT VALID-HANDLE({&hDBOSource}) OR
        {&hDBOSource}:TYPE      <> "PROCEDURE":U OR
        {&hDBOSource}:FILE-NAME <> "esbo/esbodi135.p":U THEN DO:
        {btb/btb008za.i1 esbo/esbodi135.p YES}
        {btb/btb008za.i2 esbo/esbodi135.p '' {&hDBOSource}}
    END. /* IF  NOT VALID-HANDLE({&hDBOSource}) */

    /*:T---[ Nota-Fiscal ]------------------------------------------------*/
    IF  NOT VALID-HANDLE({&hDBOTarget}) OR
        {&hDBOTarget}:TYPE      <> "PROCEDURE":U OR
        {&hDBOTarget}:FILE-NAME <> "esbo/esbodi135.p":U THEN DO:
        {btb/btb008za.i1 esbo/esbodi135.p YES}
        {btb/btb008za.i2 esbo/esbodi135.p '' {&hDBOTarget}}
    END. /* IF  NOT VALID-HANDLE({&hDBOTarget}) */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries wFormation 
PROCEDURE openQueries :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
RUN pi-busca-EmbarqueQuarentena.
ASSIGN INPUT FRAME fPage1 iEmbarque-quarentena.

IF lchamadamanual THEN DO:
    RUN openQueryTarget.
        
    IF NOT CAN-FIND(FIRST ttnota-fiscal-quarentena) THEN
        DISABLE btDelAllTarget btDelTarget WITH FRAME fPage1.
    ELSE
        ENABLE  btDelAllTarget btDelTarget WITH FRAME fPage1.
    
        {formation/openqueriessource.i &QUERY="Nr-Embarque"
                                       &ConstraintParameters=c-serie-ini[1],c-serie-fim[1],c-nr-nota-fis-ini[1],c-nr-nota-fis-fim[1],d-dt-emis-ini[1],d-dt-emis-fim[1],ttembarque.cdd-embarq
                                       &OpenAlways="YES"}
                                   
    APPLY "VALUE-CHANGED":U TO l-diferenciado IN FRAME fPage1.
END.

ASSIGN lchamadamanual = NO.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryTarget wFormation 
PROCEDURE openQueryTarget :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE ttnota-fiscal-quarentena NO-ERROR.

    IF  l-bt-press THEN DO:
        run setConstraintEmbQtna_filtro in hDBOTarget (input iEmbarque-quarentena,
                                                       input c-serie-ini[2],      
                                                       input c-serie-fim[2],      
                                                       input c-nr-nota-fis-ini[2], 
                                                       input c-nr-nota-fis-fim[2], 
                                                       input d-dt-emis-ini[2],    
                                                       input d-dt-emis-fim[2]).   
        run openQueryStatic             in hDBOTarget (input "EmbQtna_filtro":U) no-error.
        run getBatchRecords             in hDBOTarget (input  ?,
                                                       input  no,
                                                       input  9999999,
                                                       output iRowid,
                                                       output table ttnota-fiscal-quarentena).
    END.
    ELSE DO:
        run setConstraintEmb_Quarentena in hDBOTarget (input iEmbarque-quarentena).
        run openQueryStatic             in hDBOTarget (input "Emb_Quarentena":U) no-error.
        run getBatchRecords             in hDBOTarget (input  ?,
                                                       input  no,
                                                       input  9999999,
                                                       output iRowid,
                                                       output table ttnota-fiscal-quarentena).
    END.
    {&OPEN-QUERY-brTarget}

    APPLY "VALUE-CHANGED":U TO BROWSE {&TargetBrowse}.
                   
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-addTarget wFormation 
PROCEDURE pi-addTarget :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    ASSIGN INPUT FRAME fPage1 iEmbarque-quarentena.

    ASSIGN i-num-select-row = browse brSource:num-selected-rows.
    do_blk:
    do  i-num-row-a = 1 to i-num-select-row:
        BROWSE brSource:FETCH-SELECTED-ROW(i-num-row-a).
        
        nf_blk:
        FOR EACH  nota-fiscal EXCLUSIVE-LOCK 
            WHERE nota-fiscal.cod-estabel = ttnota-fiscal.cod-estabel
            AND   nota-fiscal.serie       = ttnota-fiscal.serie
            AND   nota-fiscal.nr-nota-fis = ttnota-fiscal.nr-nota-fis
            AND   nota-fiscal.dt-cancela  = ?,
            FIRST natur-oper NO-LOCK 
            WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao:

            {esinc/es0004.i} /* ValidaNaturezasImpress∆oNFs */
            
            RUN pi-trocaEmbarque(INPUT iEmbarque-quarentena,
                                 INPUT ?, /* dt-embarque */
                                 INPUT nota-fiscal.cdd-embarq).

        END. /* FOR EACH  nota-fiscal EXCLUSIVE-LOCK */
    end. /* do  i-num-row-a = 1 to i-num-select-row */

    RELEASE nota-fiscal.
    RELEASE it-nota-fisc.
    RELEASE pre-fatur.
    RELEASE it-pre-fat.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-EmbarqueQuarentena wFormation 
PROCEDURE pi-busca-EmbarqueQuarentena :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt-prog-ponto: DELETE tt-prog-ponto. END.
    RUN esp/es0018p.p (INPUT "esftp093",
                   INPUT 1, 
                   INPUT 0,
                   INPUT "", 
                   OUTPUT TABLE tt-prog-ponto).
    
    FIND FIRST tt-prog-ponto 
        WHERE ENTRY(1, tt-prog-ponto.conteudo, ";") = v_cod_estab_usuar NO-ERROR.
    IF  AVAIL tt-prog-ponto 
    THEN ASSIGN iEmbarque-quarentena:SCREEN-VALUE IN FRAME fPage1 = STRING(ENTRY(2, tt-prog-ponto.conteudo, ";")).

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-delTarget wFormation 
PROCEDURE pi-delTarget :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    ASSIGN INPUT FRAME fPage1 iEmbarque-quarentena.

    ASSIGN i-num-select-row = browse brTarget:num-selected-rows.
    do_blk:
    do  i-num-row-a = 1 to i-num-select-row ON ERROR UNDO do_blk, LEAVE do_blk:
        BROWSE brTarget:FETCH-SELECTED-ROW(i-num-row-a).

        FIND FIRST pre-fatur NO-LOCK
             WHERE pre-fatur.cdd-embarq   = ttembarque.cdd-embarq
               AND pre-fatur.nome-transp <> ttnota-fiscal-quarentena.nome-transp NO-ERROR.

        IF AVAIL pre-fatur AND v_cod_estab_usuar = "104" THEN DO:
        
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Transferància n∆o permitida" + "~~" + "Transportadora da nota de quarentena " + ttnota-fiscal-quarentena.nome-trans + " diferente da transportadora do embarque " + pre-fatur.nome-transp).

            NEXT do_blk.
        END.
        
        nf_blk:
        FOR EACH  nota-fiscal EXCLUSIVE-LOCK 
            WHERE nota-fiscal.cod-estabel = ttnota-fiscal-quarentena.cod-estabel
            AND   nota-fiscal.serie       = ttnota-fiscal-quarentena.serie
            AND   nota-fiscal.nr-nota-fis = ttnota-fiscal-quarentena.nr-nota-fis
            AND   nota-fiscal.dt-cancela  = ?,
            FIRST natur-oper NO-LOCK 
            WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao:

            {esinc/es0004.i} /* ValidaNaturezasImpress∆oNFs */

            RUN pi-trocaEmbarque(INPUT ttembarque.cdd-embarq,
                                 INPUT ttembarque.dt-embarque,
                                 INPUT iEmbarque-quarentena).

        END. /* FOR EACH  nota-fiscal EXCLUSIVE-LOCK */
    end. /* do  i-num-row-a = 1 to i-num-select-row */

    RELEASE nota-fiscal.
    RELEASE it-nota-fisc.
    RELEASE pre-fatur.
    RELEASE it-pre-fat.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trocaEmbarque wFormation 
PROCEDURE pi-trocaEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    define input parameter pnovo-nr-embarque   like embarque.cdd-embarq    no-undo.
    define input parameter pdt-embarque        like embarque.dt-embarque    no-undo.
    define input parameter pantigo-nr-embarque like embarque.cdd-embarq    no-undo.

    FIND FIRST pre-fatur EXCLUSIVE-LOCK 
        WHERE  pre-fatur.cdd-embarq  = pantigo-nr-embarque
        AND    pre-fatur.nr-resumo   = INTEGER(nota-fiscal.nr-nota-fis) 
        AND    pre-fatur.nome-abrev  = nota-fiscal.nome-ab-cli          
        AND    pre-fatur.nr-pedcli   = nota-fiscal.nr-pedcli NO-ERROR.
    IF  NOT AVAIL pre-fatur THEN DO:
        CREATE pre-fatur.
        ASSIGN pre-fatur.cod-estabel = nota-fiscal.cod-estabel
               pre-fatur.cdd-embarq  = pnovo-nr-embarque
               pre-fatur.nr-resumo   = INTEGER(nota-fiscal.nr-nota-fis)
               pre-fatur.nome-abrev  = nota-fiscal.nome-ab-cli
               pre-fatur.nr-pedcli   = nota-fiscal.nr-pedcli
               pre-fatur.estado      = nota-fiscal.estado
               pre-fatur.dt-embarque = pdt-embarque
               pre-fatur.nome-transp = nota-fiscal.nome-transp
               pre-fatur.cod-sit-pre = 3. /*Confirmado */ 

        ASSIGN nota-fiscal.cdd-embarq  = pnovo-nr-embarque
               nota-fiscal.nr-resumo   = INTEGER(nota-fiscal.nr-nota-fis).

        FOR EACH it-nota-fisc EXCLUSIVE-LOCK OF nota-fiscal:
            FIND FIRST it-pre-fat EXCLUSIVE-LOCK
                WHERE  it-pre-fat.cdd-embarq    = pnovo-nr-embarque
                AND    it-pre-fat.nr-resumo     = INTEGER(nota-fiscal.nr-nota-fis)
                AND    it-pre-fat.nome-abrev    = it-nota-fisc.nome-ab-cli 
                AND    it-pre-fat.nr-pedcli     = it-nota-fisc.nr-pedcli
                AND    it-pre-fat.nr-sequencia  = it-nota-fisc.nr-seq-fat 
                AND    it-pre-fat.it-codigo     = it-nota-fisc.it-codigo 
                AND    it-pre-fat.cod-refer     = it-nota-fisc.cod-refer
                AND    it-pre-fat.nr-entrega    = it-nota-fisc.nr-entrega NO-ERROR.
            IF  NOT AVAIL it-pre-fat THEN DO:
                CREATE it-pre-fat.
                ASSIGN it-pre-fat.aliquota-ipi  = it-nota-fisc.aliquota-ipi
                       it-pre-fat.aliquota-tax  = it-nota-fisc.aliquota-tax
                       it-pre-fat.baixa-estoq   = it-nota-fisc.baixa-estoq
                       it-pre-fat.cd-referencia = ''
                       it-pre-fat.class-fiscal  = it-nota-fisc.class-fiscal
                       it-pre-fat.cod-refer     = it-nota-fisc.cod-refer
                       it-pre-fat.cod-tax       = it-nota-fisc.cod-tax 
                       it-pre-fat.cod-vat       = it-nota-fisc.cod-vat 
                       it-pre-fat.ct-cuscon     = it-nota-fisc.ct-cuscon 
                       it-pre-fat.dt-entrega    = it-nota-fisc.dt-emis-nota
                       it-pre-fat.dt-prev-fat   = it-nota-fisc.dt-emis-nota
                       it-pre-fat.it-codigo     = it-nota-fisc.it-codigo 
                       it-pre-fat.narrativa     = it-nota-fisc.nat-docum 
                       it-pre-fat.nat-operacao  = it-nota-fisc.nat-operacao 
                       it-pre-fat.nome-abrev    = it-nota-fisc.nome-ab-cli 
                       it-pre-fat.cdd-embarq    = pnovo-nr-embarque
                       it-pre-fat.nr-entrega    = it-nota-fisc.nr-entrega 
                       it-pre-fat.nr-pedcli     = it-nota-fisc.nr-pedcli
                       it-pre-fat.nr-resumo     = INTEGER(nota-fiscal.nr-nota-fis)
                       it-pre-fat.nr-sequencia  = it-nota-fisc.nr-seq-fat 
                       it-pre-fat.qt-alocada    = it-nota-fisc.qt-faturada[1] 
                       it-pre-fat.qt-faturada   = it-nota-fisc.qt-faturada[1] 
                       it-pre-fat.qt-rejeita    = 0
                       it-pre-fat.sc-cuscon     = it-nota-fisc.sc-cuscon 
                       it-pre-fat.tipo-atend    = it-nota-fisc.tipo-atend 
                       it-pre-fat.un            = it-nota-fisc.un-fatur[1] 
                       it-pre-fat.user-rej      = ''
                       it-pre-fat.vl-cuscontab  = it-nota-fisc.vl-cuscontab.
            END.
            ELSE ASSIGN it-pre-fat.cdd-embarq   = pnovo-nr-embarque.

            ASSIGN it-nota-fisc.cdd-embarq = pnovo-nr-embarque.
        END. /* FOR EACH it-nota-fisc EXCLUSIVE-LOCK */
    END. /* IF  NOT AVAIL pre-fatur THEN */
    ELSE DO:
        /*IF  nota-fiscal.nr-embarque = 0 THEN DO:*/
                                
            FOR EACH it-pre-fat OF pre-fatur EXCLUSIVE-LOCK:
                 ASSIGN it-pre-fat.cdd-embarq = pnovo-nr-embarque.
            END. /* FOR EACH it-pre-fat */

            FOR EACH  pre-fatur EXCLUSIVE-LOCK 
                WHERE pre-fatur.cdd-embarq  = pantigo-nr-embarque
                AND   pre-fatur.nr-resumo   = INTEGER(nota-fiscal.nr-nota-fis) 
                AND   pre-fatur.nome-abrev  = nota-fiscal.nome-ab-cli          
                AND   pre-fatur.nr-pedcli   = nota-fiscal.nr-pedcli :
            
                ASSIGN pre-fatur.cdd-embarq   = pnovo-nr-embarque.
            END.

            ASSIGN nota-fiscal.cdd-embarq = pnovo-nr-embarque.
                   
            FOR EACH it-nota-fisc OF nota-fiscal EXCLUSIVE-LOCK:
                ASSIGN it-nota-fisc.cdd-embarq = pnovo-nr-embarque.
            END. /* FOR EACH it-nota-fisc */

        /*END. /* IF  nota-fiscal.nr-embarque = 0 THEN */ */
    END. /* ELSE DO: */
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaIntegracao wFormation 
PROCEDURE piVerificaIntegracao :
/*------------------------------------------------------------------------------
  Purpose: Verifica se o embarque informado possui integraá∆o com WMS     
  Notes:   Carlos Daniel - 08/08/2016
------------------------------------------------------------------------------*/

IF CAN-FIND(FIRST integra-mft-wms-notas
            WHERE integra-mft-wms-notas.cdd-embarq = ttembarque.cdd-embarq) THEN DO:

    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 17006,
                       INPUT "Transferància n∆o permitida~~O embarque informado j† possui integraá∆o com WMS.").
    RETURN "NOK".
END. 

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wFormation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela formaá∆o ({&ttTarget}) com base 
               nos campos da tabela pai ({&ttParent}) e tabela origem ({&ttSource})
  Parameters:  
------------------------------------------------------------------------------*/
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnClienteDifer wFormation 
FUNCTION fnClienteDifer RETURNS LOGICAL
  ( icliente AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE l-achou AS LOGICAL     NO-UNDO.


    ASSIGN l-achou = FALSE.
    
    bl-difer:
    FOR EACH cli-difer NO-LOCK 
        WHERE  cli-difer.cod-emitente = icliente:

        IF CAN-FIND(FIRST tt-prog-ponto-tmp 
                    WHERE tt-prog-ponto-tmp.conteudo = cli-difer.cc-codigo 
                    AND   tt-prog-ponto-tmp.ponto = 4) THEN DO:

            ASSIGN l-achou = TRUE.

            LEAVE bl-difer.

        END.

    END.

    IF l-achou THEN
        RETURN TRUE.
    ELSE 
        RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnQtdeVolume wFormation 
FUNCTION fnQtdeVolume RETURNS INTEGER
  ( c-cod-estabel AS CHAR, c-serie AS CHAR, c-nr-nota-fis AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND LAST volume-nf NO-LOCK
        WHERE volume-nf.cod-estabel = c-cod-estabel
        AND   volume-nf.serie       = c-serie
        AND   volume-nf.nr-nota-fis = c-nr-nota-fis NO-ERROR.
    IF  AVAIL volume-nf 
    THEN RETURN volume-nf.nr-volume.
    ELSE RETURN 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

