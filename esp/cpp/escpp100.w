&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-aponta-mqa NO-UNDO LIKE aponta-mqa
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i XX9999 9.99.99.999}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escpp0100
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        tt-aponta-mqa
&GLOBAL-DEFINE hDBOTable      h-boes657
&GLOBAL-DEFINE DBOTable       aponta-mqa

&GLOBAL-DEFINE page0KeyFields tt-aponta-mqa.cod-estabel tt-aponta-mqa.data tt-aponta-mqa.local-montag tt-aponta-mqa.cod-prod tt-aponta-mqa.sequencia
                              
&GLOBAL-DEFINE page0Fields tt-aponta-mqa.nr-placa-seq
&GLOBAL-DEFINE page1Fields tt-aponta-mqa.nr-linha tt-aponta-mqa.origem-falha fi-local tt-aponta-mqa.es-codigo fi-qtd-falha tt-aponta-mqa.observacao
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-aponta-mqa.cod-estabel ~
tt-aponta-mqa.local-montag tt-aponta-mqa.data tt-aponta-mqa.nr-placa-seq ~
tt-aponta-mqa.cod-prod tt-aponta-mqa.sequencia 
&Scoped-define ENABLED-TABLES tt-aponta-mqa
&Scoped-define FIRST-ENABLED-TABLE tt-aponta-mqa
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btQueryJoins btReportsJoins btExit btHelp c-desc-estab c-desc-item 
&Scoped-Define DISPLAYED-FIELDS tt-aponta-mqa.cod-estabel ~
tt-aponta-mqa.local-montag tt-aponta-mqa.data tt-aponta-mqa.nr-placa-seq ~
tt-aponta-mqa.cod-prod tt-aponta-mqa.sequencia 
&Scoped-define DISPLAYED-TABLES tt-aponta-mqa
&Scoped-define FIRST-DISPLAYED-TABLE tt-aponta-mqa
&Scoped-Define DISPLAYED-OBJECTS c-desc-estab c-desc-item 

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
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image\im-copy":U
     IMAGE-INSENSITIVE FILE "image\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
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

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE cb-falha AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Falha" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "teste",0
     DROP-DOWN-LIST
     SIZE 38 BY 1 NO-UNDO.

DEFINE VARIABLE fi-abs-atencao AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Abs. Atená∆o" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-abs-prob AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Abs. Problema" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-compon AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-linha AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-origem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE fi-local AS CHARACTER FORMAT "X(256)":U 
     LABEL "Local" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE fi-perc-atencao AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Atená∆o" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-perc-prob AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Problema" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qtd-apont AS DECIMAL FORMAT ">,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtd Apont" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qtd-falha AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "Qtd Falha" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qtd-total AS DECIMAL FORMAT ">,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtd Total" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-status
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY 1.5.


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
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz alteraá‰es"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma alteraá‰es"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-aponta-mqa.cod-estabel AT ROW 3 COL 8 COLON-ALIGNED WIDGET-ID 2
          LABEL "Estab"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-desc-estab AT ROW 3 COL 19.14 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     tt-aponta-mqa.local-montag AT ROW 3 COL 69.86 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     tt-aponta-mqa.data AT ROW 4 COL 8 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-aponta-mqa.nr-placa-seq AT ROW 4 COL 69.86 COLON-ALIGNED WIDGET-ID 20
          LABEL "Nr Placa"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     tt-aponta-mqa.cod-prod AT ROW 5 COL 8 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-desc-item AT ROW 5 COL 19.14 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     tt-aponta-mqa.sequencia AT ROW 5 COL 69.86 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.72 BY 19.46
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-aponta-mqa.nr-linha AT ROW 1.25 COL 12.86 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fi-desc-linha AT ROW 1.25 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     fi-qtd-falha AT ROW 1.25 COL 69.29 COLON-ALIGNED WIDGET-ID 54
     tt-aponta-mqa.origem-falha AT ROW 2.25 COL 12.86 COLON-ALIGNED WIDGET-ID 70
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fi-desc-origem AT ROW 2.25 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     fi-qtd-apont AT ROW 2.25 COL 69.29 COLON-ALIGNED WIDGET-ID 56
     fi-local AT ROW 3.25 COL 12.86 COLON-ALIGNED WIDGET-ID 60
     fi-qtd-total AT ROW 3.25 COL 69.29 COLON-ALIGNED WIDGET-ID 58
     tt-aponta-mqa.es-codigo AT ROW 4.25 COL 12.86 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     fi-desc-compon AT ROW 4.25 COL 22.14 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     fi-perc-atencao AT ROW 5.25 COL 12.86 COLON-ALIGNED WIDGET-ID 38
     fi-perc-prob AT ROW 5.25 COL 39 COLON-ALIGNED WIDGET-ID 44
     fi-abs-atencao AT ROW 6.25 COL 12.86 COLON-ALIGNED WIDGET-ID 42
     fi-abs-prob AT ROW 6.25 COL 39 COLON-ALIGNED WIDGET-ID 46
     cb-falha AT ROW 7.25 COL 12.86 COLON-ALIGNED WIDGET-ID 50
     tt-aponta-mqa.observacao AT ROW 8.25 COL 14.86 NO-LABEL WIDGET-ID 36
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 69.14 BY 4.5
     rt-status AT ROW 5.5 COL 71.29 WIDGET-ID 52
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.79
         SIZE 84.43 BY 13.21
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-aponta-mqa T "?" NO-UNDO mgesp aponta-mqa
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
         HEIGHT             = 19.46
         WIDTH              = 91.72
         MAX-HEIGHT         = 20.54
         MAX-WIDTH          = 91.72
         VIRTUAL-HEIGHT     = 20.54
         VIRTUAL-WIDTH      = 91.72
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-aponta-mqa.cod-estabel IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-aponta-mqa.nr-placa-seq IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
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
    RUN BeforeSaveRecord.
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="eszoom/z01es657.w"}
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-falha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-falha wMaintenance
ON VALUE-CHANGED OF cb-falha IN FRAME fPage1 /* Falha */
DO:

    RUN pi-carrega-apontamentos.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-aponta-mqa.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.cod-estabel wMaintenance
ON LEAVE OF tt-aponta-mqa.cod-estabel IN FRAME fpage0 /* Estab */
DO:
    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = INPUT FRAME fPage0 tt-aponta-mqa.cod-estabel NO-ERROR.

    IF AVAIL estabelec THEN DO: 
        ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME fPage0 = estabelec.nome.
    END.
    ELSE DO:
        ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME fPage0 = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-aponta-mqa.cod-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.cod-prod wMaintenance
ON F5 OF tt-aponta-mqa.cod-prod IN FRAME fpage0 /* Produto */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es652.w"
                         &FieldZoom1="cod-prod"
                         &FieldScreen1="tt-aponta-mqa.cod-prod"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="c-desc-item"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.cod-prod wMaintenance
ON LEAVE OF tt-aponta-mqa.cod-prod IN FRAME fpage0 /* Produto */
DO:
    FIND FIRST item-mqa NO-LOCK
         WHERE item-mqa.cod-prod    = INPUT FRAME fPage0 tt-aponta-mqa.cod-prod 
           AND item-mqa.cod-estabel = INPUT FRAME fPage0 tt-aponta-mqa.cod-estabel  NO-ERROR.

    IF AVAIL item-mqa THEN DO: 
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage0 = item-mqa.descricao.
    END.
    ELSE DO:
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage0 = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.cod-prod wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-aponta-mqa.cod-prod IN FRAME fpage0 /* Produto */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-aponta-mqa.es-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.es-codigo wMaintenance
ON F5 OF tt-aponta-mqa.es-codigo IN FRAME fPage1 /* Componente */
DO:

    {method/ZoomFields.i &ProgramZoom="inzoom/z20in172.w"
                         &FieldZoom1="it-codigo"
                         &FieldScreen1="tt-aponta-mqa.es-codigo"
                         &Frame1="fPage1"
                         &FieldZoom2="desc-item"
                         &FieldScreen2="fi-desc-compon"
                         &Frame2="fPage1"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.es-codigo wMaintenance
ON LEAVE OF tt-aponta-mqa.es-codigo IN FRAME fPage1 /* Componente */
DO:

    ASSIGN fi-desc-compon:SCREEN-VALUE IN FRAME fPage1 = "".

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = INPUT FRAME fPage1 tt-aponta-mqa.es-codigo:

        ASSIGN fi-desc-compon:SCREEN-VALUE IN FRAME fPage1 = ITEM.desc-item.

    END.    

    IF RETURN-VALUE = "NOK" THEN
        RETURN.

    RUN pi-carrega-indices.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.es-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-aponta-mqa.es-codigo IN FRAME fPage1 /* Componente */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-local wMaintenance
ON F5 OF fi-local IN FRAME fPage1 /* Local */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es653.w"
                         &FieldZoom1="local-montag"
                         &FieldScreen1="fi-local"
                         &Frame1="fPage1"
                         &RunMethod="RUN setaVariable IN hProgramZoom (INPUT INPUT FRAME fPage0 tt-aponta-mqa.cod-prod)."
                         &EnableImplant="NO"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-local wMaintenance
ON LEAVE OF fi-local IN FRAME fPage1 /* Local */
DO:

    FOR FIRST estrutura-mqa NO-LOCK
        WHERE estrutura-mqa.cod-prod = INPUT FRAME fpage0 tt-aponta-mqa.cod-prod
        AND   estrutura-mqa.local-montag = fi-local:SCREEN-VALUE IN FRAME fPage1
        AND   estrutura-mqa.cod-estabel = INPUT FRAME fpage0 tt-aponta-mqa.cod-estabel:

        ASSIGN tt-aponta-mqa.es-codigo:SCREEN-VALUE IN FRAME fPage1 = estrutura-mqa.es-codigo.

        APPLY "leave" TO tt-aponta-mqa.es-codigo IN FRAME fPage1.

    END.

    RUN pi-carrega-apontamentos.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-local wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-local IN FRAME fPage1 /* Local */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-qtd-falha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-qtd-falha wMaintenance
ON LEAVE OF fi-qtd-falha IN FRAME fPage1 /* Qtd Falha */
DO:

    RUN pi-valida-quantidade.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMaintenance
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-aponta-mqa.nr-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.nr-linha wMaintenance
ON F5 OF tt-aponta-mqa.nr-linha IN FRAME fPage1 /* Linha Produá∆o */
DO:

    /*
    {method/ZoomFields.i &ProgramZoom="inzoom/z03in186.w"
                         &FieldZoom1="nr-linha"
                         &FieldScreen1="tt-aponta-mqa.nr-linha"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-linha"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
                         */

    {include/zoomvar.i &prog-zoom="inzoom/z01in186.w"
                       &campo="tt-aponta-mqa.nr-linha"
                       &campozoom="nr-linha"
                       &frame="fPage1"
                       &campo2="fi-desc-linha"
                       &campozoom2="descricao"
                       &frame2="fPage1"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.nr-linha wMaintenance
ON LEAVE OF tt-aponta-mqa.nr-linha IN FRAME fPage1 /* Linha Produá∆o */
DO:

    ASSIGN fi-desc-linha:SCREEN-VALUE IN FRAME fPage1 = "".

    FOR FIRST lin-prod NO-LOCK
        WHERE lin-prod.nr-linha = INPUT FRAME fPage1 tt-aponta-mqa.nr-linha:

        ASSIGN fi-desc-linha:SCREEN-VALUE IN FRAME fPage1 = lin-prod.descricao.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.nr-linha wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-aponta-mqa.nr-linha IN FRAME fPage1 /* Linha Produá∆o */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-aponta-mqa.origem-falha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.origem-falha wMaintenance
ON F5 OF tt-aponta-mqa.origem-falha IN FRAME fPage1 /* Origem */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es659.w"
                         &FieldZoom1="origem-falha"
                         &FieldScreen1="tt-aponta-mqa.origem-falha"
                         &Frame1="fPage1"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-origem"
                         &Frame2="fPage1"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.origem-falha wMaintenance
ON LEAVE OF tt-aponta-mqa.origem-falha IN FRAME fPage1 /* Origem */
DO:

    ASSIGN fi-desc-origem:SCREEN-VALUE IN FRAME fPage1 = "".

    FOR FIRST origem-mqa NO-LOCK
        WHERE origem-mqa.origem-falha = INPUT FRAME fPage1 tt-aponta-mqa.origem-falha:

        ASSIGN fi-desc-origem:SCREEN-VALUE IN FRAME fPage1 = origem-mqa.descricao.

        RUN pi-carrega-falha.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.origem-falha wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-aponta-mqa.origem-falha IN FRAME fPage1 /* Origem */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisableFields wMaintenance 
PROCEDURE AfterDisableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN cb-falha:SENSITIVE IN FRAME fPage1 = NO.
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
    
        ASSIGN fi-qtd-falha:SCREEN-VALUE IN FRAME fPage1 = string(tt-aponta-mqa.qtd-falha)
               fi-local:SCREEN-VALUE IN FRAME fPage1 = string(tt-aponta-mqa.local-montag).        
        
        APPLY "leave" TO tt-aponta-mqa.cod-estabel IN FRAME fPage0.
        APPLY "leave" TO tt-aponta-mqa.cod-prod IN FRAME fPage0.
        
        APPLY "leave" TO tt-aponta-mqa.nr-linha IN FRAME fPage1.
        APPLY "leave" TO tt-aponta-mqa.origem-falha IN FRAME fPage1.
        APPLY "leave" TO tt-aponta-mqa.es-codigo IN FRAME fPage1.
        APPLY "leave" TO fi-local IN FRAME fPage1.
        
        ASSIGN cb-falha:SCREEN-VALUE IN FRAME fPage1 = string(tt-aponta-mqa.cod-falha).
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterEnableFields wMaintenance 
PROCEDURE AfterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN cb-falha:SENSITIVE IN FRAME fPage1 = YES.
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
    IF tt-aponta-mqa.cod-prod:LOAD-MOUSE-POINTER ("image/lupa.cur") THEN.
END.

DO WITH FRAME fPage1:
    IF tt-aponta-mqa.nr-linha:LOAD-MOUSE-POINTER ("image/lupa.cur") THEN.
    IF tt-aponta-mqa.origem-falha:LOAD-MOUSE-POINTER ("image/lupa.cur") THEN.
    IF fi-local:LOAD-MOUSE-POINTER ("image/lupa.cur") THEN.
    IF tt-aponta-mqa.es-codigo:LOAD-MOUSE-POINTER ("image/lupa.cur") THEN.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeSaveRecord wMaintenance 
PROCEDURE BeforeSaveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN tt-aponta-mqa.local-montag = INPUT FRAME fPage1 fi-local
           tt-aponta-mqa.cod-falha    = INPUT FRAME fPage1 cb-falha
           tt-aponta-mqa.qtd-falha    = INPUT FRAME fPage1 fi-qtd-falha
           tt-aponta-mqa.nr-placa-seq = INPUT FRAME fpage0 tt-aponta-mqa.nr-placa-seq.

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
    
    DEFINE VARIABLE c-cod-estabel LIKE {&ttTable}.cod-estabel NO-UNDO.
    DEFINE VARIABLE d-data        LIKE {&ttTable}.data NO-UNDO.
    DEFINE VARIABLE cod-prod      LIKE {&ttTable}.cod-prod NO-UNDO.
    DEFINE VARIABLE local-montag  LIKE {&ttTable}.local-montag NO-UNDO.
    DEFINE VARIABLE cod-falha     LIKE {&ttTable}.cod-falha NO-UNDO.
    DEFINE VARIABLE sequencia     LIKE {&ttTable}.sequencia NO-UNDO.

    DEFINE FRAME fGoToRecord
        c-cod-estabel  view-as fill-in size 5 by 0.88 AT ROW 1.21 COL 17.72 COLON-ALIGNED
        d-data         view-as fill-in size 12 by 0.88 AT ROW 2.21 COL 17.72 COLON-ALIGNED
        cod-prod       view-as fill-in size 12 by 0.88 AT ROW 3.21 COL 17.72 COLON-ALIGNED
        local-montag   view-as fill-in size 5 by 0.88 AT ROW 4.21 COL 17.72 COLON-ALIGNED
        cod-falha      view-as fill-in size 5 by 0.88 AT ROW 5.21 COL 17.72 COLON-ALIGNED
        sequencia      view-as fill-in size 5 by 0.88 AT ROW 6.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 7.63 COL 2.14
        btGoToCancel      AT ROW 7.63 COL 13
        rtGoToButton      AT ROW 7.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Defeitos" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Falha"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-estabel d-data cod-prod local-montag cod-falha sequencia.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-cod-estabel , 
                                     INPUT d-data , 
                                     INPUT cod-prod ,
                                     INPUT local-montag ,
                                     INPUT cod-falha ,
                                     INPUT sequencia).

        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Falha":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-estabel d-data cod-prod local-montag cod-falha sequencia btGoToOK btGoToCancel 
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
       {&hDBOTable}:FILE-NAME <> "<DBOProgram>":U THEN DO:
        {btb/btb008za.i1 esbo/boes657.p YES}
        {btb/btb008za.i2 esbo/boes657.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-apontamentos wMaintenance 
PROCEDURE pi-carrega-apontamentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
    DEFINE VARIABLE d-qtd-apont AS DECIMAL     NO-UNDO.    

    DO WITH FRAME fPage0:

        ASSIGN d-qtd-apont = 0.

        ASSIGN INPUT 
            tt-aponta-mqa.cod-estabel
            tt-aponta-mqa.data
            tt-aponta-mqa.cod-prod.
    END.

    DO WITH FRAME fpage1:

        ASSIGN INPUT 
            tt-aponta-mqa.origem-falha
            fi-local
            cb-falha.           
    END.
    
    RUN calcularTotalApontamentos IN h-boes657 (INPUT tt-aponta-mqa.cod-estabel,
                                                INPUT tt-aponta-mqa.data,
                                                INPUT tt-aponta-mqa.cod-prod,
                                                INPUT tt-aponta-mqa.origem-falha,
                                                INPUT fi-local,
                                                INPUT cb-falha,
                                                OUTPUT d-qtd-apont).    
                                                
    DO WITH FRAME fpage1:
        ASSIGN fi-qtd-apont:SCREEN-VALUE = string(d-qtd-apont).
        APPLY "LEAVE" TO fi-qtd-falha.
    END.      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-falha wMaintenance 
PROCEDURE pi-carrega-falha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-LIP-falha AS CHARACTER   NO-UNDO.

    ASSIGN c-LIP-falha = ",0,".    

    FOR EACH item-falha NO-LOCK
        WHERE item-falha.it-codigo = string(INPUT FRAME fpage1 tt-aponta-mqa.origem-falha).
        
        FOR FIRST falha-mqa NO-LOCK
            WHERE falha-mqa.cod-falha = item-falha.cod-falha:

            ASSIGN c-LIP-falha = c-LIP-falha + falha-mqa.descricao + ',' + string(falha-mqa.cod-falha) + ','.
        END.
    END.      

    IF LENGTH(c-LIP-falha) > 0 THEN 
        ASSIGN c-LIP-falha = SUBSTRING(c-LIP-falha,1,LENGTH(c-LIP-falha) - 1)
               cb-falha:LIST-ITEM-PAIRS IN FRAME fPage1 = c-LIP-falha.
    ELSE DO:

        ASSIGN c-LIP-falha = ",0"
               cb-falha:LIST-ITEM-PAIRS IN FRAME fPage1 = c-LIP-falha.

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Componente n∆o possui cadastro de falha. N∆o pode ser apontado.~~Solicitar o cadastro para Engenharia Industrial.").

        APPLY "entry" TO tt-aponta-mqa.es-codigo IN FRAME fPage1.

        RETURN "NOK":U.

    END.
    RETURN "OK":U.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-indices wMaintenance 
PROCEDURE pi-carrega-indices :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR FIRST indice-qualid NO-LOCK
        WHERE indice-qualid.cod-estabel = INPUT FRAME fPage0 tt-aponta-mqa.cod-estabel
        AND   indice-qualid.it-codigo   = INPUT FRAME fPage1 tt-aponta-mqa.es-codigo:

        DO WITH FRAME fPage1:
            ASSIGN fi-perc-atencao:SCREEN-VALUE = STRING(indice-qualid.relat-atencao)
                   fi-perc-prob:SCREEN-VALUE    = STRING(indice-qualid.relat-prob)
                   fi-abs-atencao:SCREEN-VALUE  = STRING(indice-qualid.absol-atencao)
                   fi-abs-prob:SCREEN-VALUE     = STRING(indice-qualid.absol-problema).

        END.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-quantidade wMaintenance 
PROCEDURE pi-valida-quantidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE d-qtd-corte-indice AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-fator AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-problema AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-atencao AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE p-cor AS INTEGER     NO-UNDO.
    

    ASSIGN rt-status:FILLED IN FRAME fpage1 = FALSE.

    DO WITH FRAME fpage1:

        ASSIGN fi-qtd-total:SCREEN-VALUE = STRING(INPUT fi-qtd-falha + INPUT fi-qtd-apont).
    END.

    DO WITH FRAME fPage0:                

        ASSIGN INPUT
            tt-aponta-mqa.cod-estabel
            tt-aponta-mqa.data
            tt-aponta-mqa.cod-prod.            
    END.

    DO WITH FRAME fpage1:
        ASSIGN INPUT
            tt-aponta-mqa.origem-falha
            fi-local
            tt-aponta-mqa.es-codigo
            cb-falha
            fi-qtd-falha.
    END.
     
    RUN calcularMQA IN h-boes657 (INPUT tt-aponta-mqa.cod-estabel,
                                  INPUT tt-aponta-mqa.data,
                                  INPUT tt-aponta-mqa.cod-prod,
                                  INPUT tt-aponta-mqa.origem-falha,
                                  INPUT fi-local,
                                  INPUT tt-aponta-mqa.es-codigo,
                                  INPUT cb-falha,
                                  INPUT fi-qtd-falha,
                                  OUTPUT p-cor).    
    IF p-cor > 0 THEN
        ASSIGN rt-status:FILLED  = TRUE
               rt-status:BGCOLOR = p-cor.                         


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

