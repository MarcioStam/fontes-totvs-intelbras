&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttint-item-fornec NO-UNDO LIKE int-item-fornec
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttint-item-fornec-aux NO-UNDO LIKE int-item-fornec
       field altera as logical.
DEFINE TEMP-TABLE ttitem-fornec NO-UNDO LIKE item-fornec
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
{include/i-prgvrs.i ESREP015 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESREP015
&GLOBAL-DEFINE Version        2.04.00.001

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Atualiza,Item,Fornecedor

&GLOBAL-DEFINE First          NO
&GLOBAL-DEFINE Prev           NO
&GLOBAL-DEFINE Next           NO
&GLOBAL-DEFINE Last           NO
&GLOBAL-DEFINE GoTo           NO
&GLOBAL-DEFINE Search         NO

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        ttint-item-fornec
&GLOBAL-DEFINE hDBOTable      hboes328
&GLOBAL-DEFINE DBOTable       int-item-fornec

&GLOBAL-DEFINE page0KeyFields 
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    ttint-item-fornec.cod-emitente ttint-item-fornec.it-codigo ttint-item-fornec.obs-rec
&GLOBAL-DEFINE page2Fields    ttint-item-fornec.it-codigo ttint-item-fornec.obs-rec
&GLOBAL-DEFINE page3Fields    ttint-item-fornec.cod-emitente ttint-item-fornec.obs-rec
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

def temp-table tt-item-obs no-undo
    field it-codigo like item.it-codigo.
    
def temp-table tt-fornec-obs no-undo
    field cod-emitente like emitente.cod-emitente.    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
def var hboin178 as handle no-undo.
def var hboin172 as handle no-undo.
def var hboad098 as handle no-undo.
def var i-folder as int no-undo.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
def var c-obs as char no-undo.
def var iRowsReturned as int no-undo.
def var i-aux as int no-undo.

&scoped-define button_labels Altera Todos,Altera Nenhum

def buffer b-ttint-item-fornec-aux for ttint-item-fornec-aux.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brItemFornec

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttint-item-fornec-aux

/* Definitions for BROWSE brItemFornec                                  */
&Scoped-define FIELDS-IN-QUERY-brItemFornec ttint-item-fornec-aux.altera ttint-item-fornec-aux.cod-emitente ttint-item-fornec-aux.obs-rec   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brItemFornec ttint-item-fornec-aux.altera   
&Scoped-define ENABLED-TABLES-IN-QUERY-brItemFornec ttint-item-fornec-aux
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brItemFornec ttint-item-fornec-aux
&Scoped-define SELF-NAME brItemFornec
&Scoped-define QUERY-STRING-brItemFornec FOR EACH ttint-item-fornec-aux NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brItemFornec OPEN QUERY {&SELF-NAME} FOR EACH ttint-item-fornec-aux NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brItemFornec ttint-item-fornec-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brItemFornec ttint-item-fornec-aux


/* Definitions for BROWSE brItemFornec-2                                */
&Scoped-define FIELDS-IN-QUERY-brItemFornec-2 ttint-item-fornec-aux.altera ttint-item-fornec-aux.it-codigo ttint-item-fornec-aux.obs-rec   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brItemFornec-2 ttint-item-fornec-aux.altera   
&Scoped-define ENABLED-TABLES-IN-QUERY-brItemFornec-2 ttint-item-fornec-aux
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brItemFornec-2 ttint-item-fornec-aux
&Scoped-define SELF-NAME brItemFornec-2
&Scoped-define QUERY-STRING-brItemFornec-2 FOR EACH ttint-item-fornec-aux NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brItemFornec-2 OPEN QUERY {&SELF-NAME} FOR EACH ttint-item-fornec-aux NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brItemFornec-2 ttint-item-fornec-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brItemFornec-2 ttint-item-fornec-aux


/* Definitions for FRAME fPage2                                         */

/* Definitions for FRAME fPage3                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btUpdate btUndo btCancel btSave ~
btQueryJoins btReportsJoins btExit btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
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
DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image\im-undo":U
     IMAGE-INSENSITIVE FILE "image\ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 52.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-emit AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 41.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 4.33.

DEFINE BUTTON btAtualiza DEFAULT 
     LABEL "Button 1" 
     SIZE 15 BY 1.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 9.25.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 4.25.

DEFINE BUTTON btAtualiza-2 DEFAULT 
     LABEL "btatualiza 2" 
     SIZE 15 BY 1.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 4.25.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 9.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brItemFornec FOR 
      ttint-item-fornec-aux SCROLLING.

DEFINE QUERY brItemFornec-2 FOR 
      ttint-item-fornec-aux SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brItemFornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brItemFornec wMaintenance _FREEFORM
  QUERY brItemFornec NO-LOCK DISPLAY
      ttint-item-fornec-aux.altera COLUMN-LABEL "Alt?" FORMAT "Sim/NÆo":U width 3.0
      ttint-item-fornec-aux.cod-emitente COLUMN-LABEL "Fornecedor" FORMAT ">>>>>9":U
      ttint-item-fornec-aux.obs-rec COLUMN-LABEL "Observa‡Æo Atual" FORMAT "x(200)":U
      enable
      ttint-item-fornec-aux.altera
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-BOX NO-ASSIGN NO-AUTO-VALIDATE NO-ROW-MARKERS SEPARATORS NO-VALIDATE NO-TAB-STOP SIZE 77 BY 7.25
         FONT 1 NO-EMPTY-SPACE.

DEFINE BROWSE brItemFornec-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brItemFornec-2 wMaintenance _FREEFORM
  QUERY brItemFornec-2 NO-LOCK DISPLAY
      ttint-item-fornec-aux.altera COLUMN-LABEL "Alt?" FORMAT "Sim/NÆo":U width 3.0
      ttint-item-fornec-aux.it-codigo COLUMN-LABEL "Item" FORMAT "x(16)":U
      ttint-item-fornec-aux.obs-rec COLUMN-LABEL "Observa‡Æo Atual" FORMAT "x(200)":U
      enable
      ttint-item-fornec-aux.altera
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-BOX NO-ASSIGN NO-AUTO-VALIDATE NO-ROW-MARKERS SEPARATORS NO-VALIDATE NO-TAB-STOP SIZE 77 BY 7.25
         FONT 1 NO-EMPTY-SPACE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btUpdate AT ROW 1.13 COL 1.57 HELP
          "Altera ocorrˆncia corrente"
     btUndo AT ROW 1.13 COL 5.57 HELP
          "Desfaz altera‡äes"
     btCancel AT ROW 1.13 COL 9.57 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 13.57 HELP
          "Confirma altera‡äes"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 20.29
         FONT 1.

DEFINE FRAME fPage3
     ttint-item-fornec.cod-emitente AT ROW 1.17 COL 10.57 COLON-ALIGNED WIDGET-ID 6
          LABEL "Fornecedor"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-nome-emit AT ROW 1.17 COL 19.29 COLON-ALIGNED HELP
          "Nome Completo do Emitente" NO-LABEL WIDGET-ID 8 FORMAT "X(40)"
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88 NO-TAB-STOP 
     ttint-item-fornec.obs-rec AT ROW 3.25 COL 5 NO-LABEL WIDGET-ID 22
          VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 200 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 77 BY 3.25
     brItemFornec-2 AT ROW 7.75 COL 5 WIDGET-ID 500
     btAtualiza-2 AT ROW 15.04 COL 5 WIDGET-ID 20
     "Observa‡Æo" VIEW-AS TEXT
          SIZE 9 BY .67 AT ROW 2.5 COL 5 WIDGET-ID 14
     RECT-3 AT ROW 2.75 COL 3 WIDGET-ID 12
     RECT-5 AT ROW 7.25 COL 3 WIDGET-ID 16
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.13
         SIZE 84.43 BY 16.13
         FONT 1 WIDGET-ID 300.

DEFINE FRAME fPage2
     ttint-item-fornec.it-codigo AT ROW 1.17 COL 10.57 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     fi-desc-item AT ROW 1.17 COL 28.57 COLON-ALIGNED NO-LABEL WIDGET-ID 4 FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 52.14 BY .88 NO-TAB-STOP 
     ttint-item-fornec.obs-rec AT ROW 3.25 COL 5 NO-LABEL WIDGET-ID 22
          VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 200 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 77 BY 3.25
     brItemFornec AT ROW 7.75 COL 5 WIDGET-ID 400
     btAtualiza AT ROW 15.04 COL 5 WIDGET-ID 20
     "Observa‡Æo" VIEW-AS TEXT
          SIZE 9 BY .67 AT ROW 2.5 COL 5 WIDGET-ID 18
     RECT-2 AT ROW 7.25 COL 3 WIDGET-ID 12
     RECT-4 AT ROW 2.75 COL 3 WIDGET-ID 16
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.13
         SIZE 84.43 BY 16.13
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage1
     ttint-item-fornec.it-codigo AT ROW 1.17 COL 10.57 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     fi-desc-item AT ROW 1.17 COL 28.57 COLON-ALIGNED NO-LABEL WIDGET-ID 4 NO-TAB-STOP 
     ttint-item-fornec.cod-emitente AT ROW 2.17 COL 10.57 COLON-ALIGNED WIDGET-ID 6
          LABEL "Fornecedor"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-nome-emit AT ROW 2.17 COL 19.29 COLON-ALIGNED HELP
          "Nome Completo do Emitente" NO-LABEL WIDGET-ID 8 NO-TAB-STOP 
     ttint-item-fornec.obs-rec AT ROW 4.25 COL 5 NO-LABEL WIDGET-ID 16
          VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 200 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 77 BY 3.25
     "Observa‡Æo" VIEW-AS TEXT
          SIZE 12 BY .67 AT ROW 3.5 COL 5 WIDGET-ID 14
     RECT-1 AT ROW 3.67 COL 3 WIDGET-ID 12
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.13
         SIZE 84.43 BY 16.13
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttint-item-fornec T "?" NO-UNDO mgesp int-item-fornec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttint-item-fornec-aux T "?" NO-UNDO mgesp int-item-fornec
      ADDITIONAL-FIELDS:
          field altera as logical
      END-FIELDS.
      TABLE: ttitem-fornec T "?" NO-UNDO mgcad item-fornec
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
         HEIGHT             = 20.29
         WIDTH              = 90
         MAX-HEIGHT         = 20.29
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 20.29
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
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
ASSIGN 
       btCancel:PRIVATE-DATA IN FRAME fpage0     = 
                "60".

ASSIGN 
       btSave:PRIVATE-DATA IN FRAME fpage0     = 
                "88".

ASSIGN 
       btUndo:PRIVATE-DATA IN FRAME fpage0     = 
                "32".

ASSIGN 
       btUpdate:PRIVATE-DATA IN FRAME fpage0     = 
                "4".

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN ttint-item-fornec.cod-emitente IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nome-emit IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brItemFornec obs-rec fPage2 */
ASSIGN 
       btAtualiza:PRIVATE-DATA IN FRAME fPage2     = 
                "1".

/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brItemFornec-2 obs-rec fPage3 */
ASSIGN 
       btAtualiza-2:PRIVATE-DATA IN FRAME fPage3     = 
                "1".

/* SETTINGS FOR FILL-IN ttint-item-fornec.cod-emitente IN FRAME fPage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fi-nome-emit IN FRAME fPage3
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brItemFornec
/* Query rebuild information for BROWSE brItemFornec
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttint-item-fornec-aux NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is NOT OPENED
*/  /* BROWSE brItemFornec */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brItemFornec-2
/* Query rebuild information for BROWSE brItemFornec-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttint-item-fornec-aux NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is NOT OPENED
*/  /* BROWSE brItemFornec-2 */
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


&Scoped-define BROWSE-NAME brItemFornec
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME brItemFornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brItemFornec wMaintenance
ON ROW-LEAVE OF brItemFornec IN FRAME fPage2
DO:
    assign input browse brItemFornec ttint-item-fornec-aux.altera.
    
    if not can-find(first b-ttint-item-fornec-aux
                    where b-ttint-item-fornec-aux.altera ne ttint-item-fornec-aux.altera) then do:
        btAtualiza:private-data in frame fPage2 = if ttint-item-fornec-aux.altera then "2" else "1".
        run piUpdateButtonLabel (input btAtualiza:handle).
    end.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brItemFornec-2
&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME brItemFornec-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brItemFornec-2 wMaintenance
ON ROW-LEAVE OF brItemFornec-2 IN FRAME fPage3
DO:
    assign input browse brItemFornec-2 ttint-item-fornec-aux.altera.
  
    if not can-find(first b-ttint-item-fornec-aux
                    where b-ttint-item-fornec-aux.altera ne ttint-item-fornec-aux.altera) then do:
        btAtualiza-2:private-data in frame fPage3 = if ttint-item-fornec-aux.altera then "2" else "1".
        run piUpdateButtonLabel (input btAtualiza-2:handle).
    end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAtualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualiza wMaintenance
ON CHOOSE OF btAtualiza IN FRAME fPage2 /* Button 1 */
DO:
  case self:label:
    when entry(1, "{&button_labels}") then 
        for each ttint-item-fornec-aux:
            ttint-item-fornec-aux.altera = yes.
        end.     
    when entry(2, "{&button_labels}") then 
        for each ttint-item-fornec-aux:
            ttint-item-fornec-aux.altera = no.
        end.     
  end.      

  OPEN QUERY brItemFornec FOR EACH ttint-item-fornec-aux NO-LOCK INDEXED-REPOSITION.  
  
  run piUpdateButtonLabel (input self).
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btAtualiza-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualiza-2 wMaintenance
ON CHOOSE OF btAtualiza-2 IN FRAME fPage3 /* btatualiza 2 */
DO:
  case self:label:
    when entry(1, "{&button_labels}") then 
        for each ttint-item-fornec-aux:
            ttint-item-fornec-aux.altera = yes.
        end.     
    when entry(2, "{&button_labels}") then 
        for each ttint-item-fornec-aux:
            ttint-item-fornec-aux.altera = no.
        end.     
  end.      

  OPEN QUERY brItemFornec-2 FOR EACH ttint-item-fornec-aux NO-LOCK INDEXED-REPOSITION.  
        
  run piUpdateButtonLabel (input self).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
    run setEnabled in hFolder(1, yes).
    run setEnabled in hFolder(2, yes).
    run setEnabled in hFolder(3, yes).
    case i-folder:
        when 1 then do:
            clear frame fPage1.
            clear frame fPage2.
            clear frame fPage3.
            ASSIGN ttint-item-fornec.obs-rec:SCREEN-VALUE IN FRAME fPage1 = "" 
                   ttint-item-fornec.obs-rec:SCREEN-VALUE IN FRAME fPage2 = ""
                   ttint-item-fornec.obs-rec:SCREEN-VALUE IN FRAME fPage3 = "".
        end.
        when 2 then do:
            clear frame fPage2.
            ASSIGN ttint-item-fornec.obs-rec:SCREEN-VALUE IN FRAME fPage2 = "".
            empty temp-table ttint-item-fornec-aux.
            OPEN QUERY brItemFornec FOR EACH ttint-item-fornec-aux NO-LOCK INDEXED-REPOSITION.                                              
        end.
        when 3 then do:
            clear frame fPage3.
            ASSIGN ttint-item-fornec.obs-rec:SCREEN-VALUE IN FRAME fPage3 = "". 
            empty temp-table ttint-item-fornec-aux.
            OPEN QUERY brItemFornec-2 FOR EACH ttint-item-fornec-aux NO-LOCK INDEXED-REPOSITION.                                              
        end.
    end case.
    disable btAtualiza with frame fPage2.
    disable btAtualiza-2 with frame fPage3.
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


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
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
    RUN saveRecordCustom IN THIS-PROCEDURE.
    IF return-value = "OK" then do:
        case i-folder:
            when 1 then DO:
                
                clear frame fPage1.

                ASSIGN ttint-item-fornec.obs-rec:SCREEN-VALUE IN FRAME fPage1 = "" 
                       ttint-item-fornec.obs-rec:SCREEN-VALUE IN FRAME fPage2 = ""
                       ttint-item-fornec.obs-rec:SCREEN-VALUE IN FRAME fPage3 = "".

            END.
            when 2 then do:
                clear frame fPage2.
                ASSIGN ttint-item-fornec.obs-rec:SCREEN-VALUE IN FRAME fPage2 = "". 
                empty temp-table ttint-item-fornec-aux.
                OPEN QUERY brItemFornec FOR EACH ttint-item-fornec-aux NO-LOCK INDEXED-REPOSITION.                                              
                disable btAtualiza with frame fPage2.
            end.
            when 3 then do:
                clear frame fPage3.
                ASSIGN ttint-item-fornec.obs-rec:SCREEN-VALUE IN FRAME fPage3 = "". 
                empty temp-table ttint-item-fornec-aux.
                OPEN QUERY brItemFornec-2 FOR EACH ttint-item-fornec-aux NO-LOCK INDEXED-REPOSITION.                                              
                disable btAtualiza-2 with frame fPage3.
            end.
        end case.
    end.
    else do:
        case i-folder:
            when 1 then 
                apply "entry" to ttint-item-fornec.it-codigo in frame fPage1.
            when 2 then 
                apply "entry" to ttint-item-fornec.it-codigo in frame fPage2.
            when 3 then 
                apply "entry" to ttint-item-fornec.cod-emitente in frame fPage3.
        end case.
        return no-apply.
    end.    
            
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE.
    if VALID-HANDLE(hFolder) then
        run getCurrentFolder in hFolder(output i-folder).
    case i-folder:
        when 1 then do:
            apply "entry" to ttint-item-fornec.it-codigo in frame fPage1.
            run setEnabled in hFolder(1, yes).
            run setEnabled in hFolder(2, no).
            run setEnabled in hFolder(3, no).
        end.    
        when 2 then do:
            apply "entry" to ttint-item-fornec.it-codigo in frame fPage2.
            run setEnabled in hFolder(2, yes).
            run setEnabled in hFolder(1, no).
            run setEnabled in hFolder(3, no).
        end.    
        when 3 then do:
            apply "entry" to ttint-item-fornec.cod-emitente in frame fPage3.
            run setEnabled in hFolder(3, yes).
            run setEnabled in hFolder(1, no).
            run setEnabled in hFolder(2, no).
        end.    
    end case.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME ttint-item-fornec.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item-fornec.cod-emitente wMaintenance
ON F5 OF ttint-item-fornec.cod-emitente IN FRAME fPage3 /* Fornecedor */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad098"
                       &campo="fi-nome-emit"
                       &campozoom="nome-emit"
                       &frame="fPage3"
                       &campo2="ttint-item-fornec.cod-emitente"
                       &campozoom2="cod-emitente"
                       &frame2="fPage3"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item-fornec.cod-emitente wMaintenance
ON LEAVE OF ttint-item-fornec.cod-emitente IN FRAME fPage3 /* Fornecedor */
DO:
    disp "" @ fi-nome-emit with frame fPage3.

    &scoped-define BOVERSION 1.1
    {method/ReferenceFields.i &HandleDBOLeave="hboad098"
                              &KeyValue1="ttint-item-fornec.cod-emitente:SCREEN-VALUE IN FRAME fPage3"
                              &FieldName1="nome-emit"
                              &FieldScreen1="fi-nome-emit"
                              &Frame1="fPage3"
                              &FindMethod="findCodigo"}
    &undefine BOVERSION                          
    
    /*if return-value = "OK" then do:                              */
        empty temp-table ttint-item-fornec-aux.
        run setConstraintByFornec in {&hDBOTable} 
            (input ttint-item-fornec.cod-emitente:SCREEN-VALUE IN FRAME fPage3).
        RUN openQueryStatic IN {&hDBOTable} (INPUT "ByFornec":U).  
        
        RUN getBatchRecords IN {&hDBOTable} ( INPUT ?,
                                              INPUT ?,
                                              INPUT ?,
                                              OUTPUT iRowsReturned,
                                              OUTPUT TABLE ttint-item-fornec).
                                              
        if iRowsReturned > 0 then 
            for each ttint-item-fornec
                where ttint-item-fornec.obs-rec ne "":
                create ttint-item-fornec-aux.                                             
                buffer-copy ttint-item-fornec to ttint-item-fornec-aux.                                              
            end.    
                                              
        OPEN QUERY brItemFornec-2 FOR EACH ttint-item-fornec-aux NO-LOCK INDEXED-REPOSITION.                                              
        
        btAtualiza-2:private-data in frame fPage3 = "1".
        run piUpdateButtonLabel (input btAtualiza-2:handle).
        btAtualiza-2:sensitive in frame fPage3 = browse brItemFornec-2:num-iterations > 0.                                            
    
    /*end.    */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item-fornec.cod-emitente wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttint-item-fornec.cod-emitente IN FRAME fPage3 /* Fornecedor */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttint-item-fornec.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item-fornec.cod-emitente wMaintenance
ON F5 OF ttint-item-fornec.cod-emitente IN FRAME fPage1 /* Fornecedor */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad098"
                       &campo="fi-nome-emit"
                       &campozoom="nome-emit"
                       &frame="fPage1"
                       &campo2="ttint-item-fornec.cod-emitente"
                       &campozoom2="cod-emitente"
                       &frame2="fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item-fornec.cod-emitente wMaintenance
ON LEAVE OF ttint-item-fornec.cod-emitente IN FRAME fPage1 /* Fornecedor */
DO:
    disp "" @ fi-nome-emit with frame fPage1.

    &scoped-define BOVERSION 1.1
    {method/ReferenceFields.i &HandleDBOLeave="hboad098"
                              &KeyValue1="ttint-item-fornec.cod-emitente:SCREEN-VALUE IN FRAME fPage1"
                              &FieldName1="nome-emit"
                              &FieldScreen1="fi-nome-emit"
                              &Frame1="fPage1"
                              &FindMethod="findCodigo"}
    &undefine BOVERSION                          
    
    run setConstraintOnde-compra in {&hDBOTable}
        (input input frame fPage1 ttint-item-fornec.it-codigo,
         input input frame fPage1 ttint-item-fornec.cod-emitente).
         
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Onde-compra":U).   
    run getCharField IN {&hDBOTable} (input "obs-rec", output c-obs).
    if return-value ne "NOK" then
        ASSIGN ttint-item-fornec.obs-rec:SCREEN-VALUE IN frame fPage1 = c-obs.
    else         
        ASSIGN ttint-item-fornec.obs-rec:SCREEN-VALUE IN frame fPage1 = "".


        DO WITH FRAME fpage1:

        APPLY "Selection" TO ttint-item-fornec.obs-rec.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item-fornec.cod-emitente wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttint-item-fornec.cod-emitente IN FRAME fPage1 /* Fornecedor */
DO:
  apply "f5" to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME ttint-item-fornec.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item-fornec.it-codigo wMaintenance
ON F5 OF ttint-item-fornec.it-codigo IN FRAME fPage2 /* Item */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z04in172"
                       &campo="fi-desc-item"
                       &campozoom="desc-item"
                       &frame="fPage2"
                       &campo2="ttint-item-fornec.it-codigo"
                       &campozoom2="it-codigo"
                       &frame2="fPage2"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item-fornec.it-codigo wMaintenance
ON LEAVE OF ttint-item-fornec.it-codigo IN FRAME fPage2 /* Item */
DO:
    disp "" @ fi-desc-item with frame fPage2.
    
    {method/ReferenceFields.i &HandleDBOLeave="hboin172"
                              &KeyValue1="ttint-item-fornec.it-codigo:SCREEN-VALUE IN FRAME fPage2"
                              &FieldName1="desc-item"
                              &FieldScreen1="fi-desc-item"
                              &Frame1="fPage2"}
                              
    if return-value = "OK" then do:                              
        empty temp-table ttint-item-fornec-aux.
        run setConstraintByItem in {&hDBOTable} 
            (input ttint-item-fornec.it-codigo:SCREEN-VALUE IN FRAME fPage2).
        RUN openQueryStatic IN {&hDBOTable} (INPUT "ByItem":U).  
        
        RUN getBatchRecords IN {&hDBOTable} ( INPUT ?,
                                              INPUT ?,
                                              INPUT ?,
                                              OUTPUT iRowsReturned,
                                              OUTPUT TABLE ttint-item-fornec).
                                              
        if iRowsReturned > 0 then 
            for each ttint-item-fornec
                where ttint-item-fornec.obs-rec ne "":
                create ttint-item-fornec-aux.                                             
                buffer-copy ttint-item-fornec to ttint-item-fornec-aux.                                              
            end.    
                                              
        OPEN QUERY brItemFornec FOR EACH ttint-item-fornec-aux NO-LOCK INDEXED-REPOSITION.  
        
        btAtualiza:private-data in frame fPage2 = "1".
        run piUpdateButtonLabel (input btAtualiza:handle).
        btAtualiza:sensitive in frame fPage2 = browse brItemFornec:num-iterations > 0.                                            
        
    end.    
        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item-fornec.it-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttint-item-fornec.it-codigo IN FRAME fPage2 /* Item */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttint-item-fornec.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item-fornec.it-codigo wMaintenance
ON F5 OF ttint-item-fornec.it-codigo IN FRAME fPage1 /* Item */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z04in172"
                       &campo="fi-desc-item"
                       &campozoom="desc-item"
                       &frame="fPage1"
                       &campo2="ttint-item-fornec.it-codigo"
                       &campozoom2="it-codigo"
                       &frame2="fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item-fornec.it-codigo wMaintenance
ON LEAVE OF ttint-item-fornec.it-codigo IN FRAME fPage1 /* Item */
DO:
    disp "" @ fi-desc-item with frame fPage1.

    {method/ReferenceFields.i &HandleDBOLeave="hboin172"
                              &KeyValue1="ttint-item-fornec.it-codigo:SCREEN-VALUE IN FRAME fPage1"
                              &FieldName1="desc-item"
                              &FieldScreen1="fi-desc-item"
                              &Frame1="fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item-fornec.it-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttint-item-fornec.it-codigo IN FRAME fPage1 /* Item */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brItemFornec
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterinitializeInterface wMaintenance 
PROCEDURE AfterinitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    do with frame fPage0:
        assign btCancel:x = int(btCancel:private-data) 
               btSave:x   = int(btSave:private-data) 
               btUndo:x   = int(btUndo:private-data)
               btUpdate:x = int(btUpdate:private-data).
        enable btUpdate.       
    end.       
    ttint-item-fornec.cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
    ttint-item-fornec.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
    ttint-item-fornec.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
    ttint-item-fornec.cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage3.
    
    ttint-item-fornec-aux.altera:help in browse brItemFornec = 
        "Digite S(im) se deseja alterar a observa‡Æo atual".
        
    enable brItemFornec with frame fPage2.        
    enable brItemFornec-2 with frame fPage3.   
    apply "choose" to btAtualiza in frame fPage2.
    apply "choose" to btAtualiza-2 in frame fPage3.
        
    view frame fPage0.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroyInterface wMaintenance 
PROCEDURE beforeDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if valid-handle(hboin178) then
        run Destroy in hboin178.
    if valid-handle(hboin172) then
        run Destroy in hboin172.
    if valid-handle(hboad098) then do:
        delete procedure hboad098.
        hboad098 = ?.
    end.    
        
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
       {&hDBOTable}:FILE-NAME <> "esbo/boes328.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes328.p YES}
        {btb/btb008za.i2 esbo/boes328.p '' {&hDBOTable}}
    END.
    
/*     RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR. */
/*    */
    IF NOT VALID-HANDLE(hboin178) OR
       hboin178:TYPE <> "PROCEDURE":U OR
       hboin178:FILE-NAME <> "inbo/boin178.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin178.p YES}
        {btb/btb008za.i2 inbo/boin178.p '' hboin178}
    END.

    IF NOT VALID-HANDLE(hboin172) OR
       hboin172:TYPE <> "PROCEDURE":U OR
       hboin172:FILE-NAME <> "inbo/boin172.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin172.p YES}
        {btb/btb008za.i2 inbo/boin172.p '' hboin172}
    END.
    
    RUN openQueryStatic IN hboin172 (INPUT "Main":U) NO-ERROR.
    
    IF NOT VALID-HANDLE(hboad098) OR
       hboad098:TYPE <> "PROCEDURE":U OR
       hboad098:FILE-NAME <> "adbo/boad098.p":U THEN DO:
        {btb/btb008za.i1 adbo/boad098.p YES}
        {btb/btb008za.i2 adbo/boad098.p '' hboad098}
    END.
    
    RUN openQueryStatic IN hboad098 (INPUT "Main":U) NO-ERROR.
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piUpdateButtonLabel wMaintenance 
PROCEDURE piUpdateButtonLabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pButton as widget-handle no-undo.
    
    assign pButton:label = entry(int(pButton:private-data), "{&button_labels}")
           i-aux = (int(pButton:private-data) + 1) mod 2
           pButton:private-data = string(if i-aux = 0 then 2 else i-aux).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecordCustom wMaintenance 
PROCEDURE saveRecordCustom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find first ttint-item-fornec no-error.
    if not avail ttint-item-fornec then create ttint-item-fornec. /* dummy */

    case i-folder:
        when 1 then do:
            run emptyRowErrors in {&hDBOTable}.
            find first ttint-item-fornec no-error.
            assign input frame fPage1 ttint-item-fornec.cod-emitente 
                                      ttint-item-fornec.it-codigo 
                                      ttint-item-fornec.obs-rec.
            run goToKey in {&hDBOTable} (input ttint-item-fornec.it-codigo,
                                         input ttint-item-fornec.cod-emitente).
            if return-value = "OK" then do:
                run setRecord in {&hDBOTable} (input table ttint-item-fornec).
                run updateRecord in {&hDBOTable}.                          
            end.    
            else do:                                           
                RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U).                          
                run setRecord in {&hDBOTable} (input table ttint-item-fornec).
                run createRecord in {&hDBOTable}.                          
            end.
            run getRowErrors in {&hDBOTable} (output table RowErrors).
            IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN do:
                {method/ShowMessage.i1}
                {method/ShowMessage.i2 &Modal="YES"}
                return "NOK".
            end.    
        end.
        when 2 then do:
            run emptyRowErrors in {&hDBOTable}.
            find first ttint-item-fornec no-error.
            assign input frame fPage2 ttint-item-fornec.it-codigo 
                                      ttint-item-fornec.obs-rec.
            empty temp-table tt-fornec-obs.
            for each ttint-item-fornec-aux
                where ttint-item-fornec-aux.altera:
                create tt-fornec-obs.
                tt-fornec-obs.cod-emitente = ttint-item-fornec-aux.cod-emitente.
            end.                              
            run UpdateByItem in {&hDBOTable} (input ttint-item-fornec.it-codigo,
                                              input ttint-item-fornec.obs-rec,
                                              input table tt-fornec-obs).                                      
            run getRowErrors in {&hDBOTable} (output table RowErrors).
            IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN do:
                {method/ShowMessage.i1}
                {method/ShowMessage.i2 &Modal="YES"}
                return "NOK".
            end.    
        end.
        when 3 then do:
            run emptyRowErrors in {&hDBOTable}.
            find first ttint-item-fornec no-error.
            assign input frame fPage3 ttint-item-fornec.cod-emitente 
                                      ttint-item-fornec.obs-rec.
            empty temp-table tt-item-obs.
            for each ttint-item-fornec-aux
                where ttint-item-fornec-aux.altera:
                create tt-item-obs.
                tt-item-obs.it-codigo = ttint-item-fornec-aux.it-codigo.
            end.                              
            run UpdateByFornec in {&hDBOTable} (input ttint-item-fornec.cod-emitente,                         
                                                input ttint-item-fornec.obs-rec,
                                                input table tt-item-obs).                                      
            run getRowErrors in {&hDBOTable} (output table RowErrors).
            IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN do:
                {method/ShowMessage.i1}
                {method/ShowMessage.i2 &Modal="YES"}
                return "NOK".
            end.    
        end.
    end case.
    return "OK".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

