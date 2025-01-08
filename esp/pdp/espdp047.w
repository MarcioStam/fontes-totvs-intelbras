&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttitem-estab-b2c NO-UNDO LIKE item-estab-b2c
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
{include/i-prgvrs.i espdp047 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        espdp047
&GLOBAL-DEFINE Version        2.04.00.001

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        ttitem-estab-b2c
&GLOBAL-DEFINE hDBOTable      hDBOitem-estab-b2c
&GLOBAL-DEFINE DBOTable       item-estab-b2c

&GLOBAL-DEFINE page0KeyFields ttitem-estab-b2c.cod-estabel ttitem-estab-b2c.it-codigo ttitem-estab-b2c.ind-aceita-saldao
&GLOBAL-DEFINE page0Fields    ttitem-estab-b2c.qt-minima ttitem-estab-b2c.qt-maxima-venda ~
                              ttitem-estab-b2c.vl-cheio ttitem-estab-b2c.vl-por ttitem-estab-b2c.presente ~
                              ttitem-estab-b2c.nome-produto ttitem-estab-b2c.descricao ttitem-estab-b2c.caracteristica ~
                              ttitem-estab-b2c.lg-item-pai-pedido ttitem-estab-b2c.lg-saldo-componente
    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttitem-estab-b2c.cod-estabel ~
ttitem-estab-b2c.it-codigo ttitem-estab-b2c.ind-aceita-saldao ~
ttitem-estab-b2c.qt-minima ttitem-estab-b2c.vl-cheio ~
ttitem-estab-b2c.presente ttitem-estab-b2c.qt-maxima-venda ~
ttitem-estab-b2c.vl-por ttitem-estab-b2c.nome-produto ~
ttitem-estab-b2c.descricao ttitem-estab-b2c.caracteristica ~
ttitem-estab-b2c.lg-item-pai-pedido ttitem-estab-b2c.lg-saldo-componente 
&Scoped-define ENABLED-TABLES ttitem-estab-b2c
&Scoped-define FIRST-ENABLED-TABLE ttitem-estab-b2c
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys RECT-3 btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo ~
btCancel btSave btQueryJoins btReportsJoins btExit btHelp fi-nome-estabelec ~
fi-desc-item 
&Scoped-Define DISPLAYED-FIELDS ttitem-estab-b2c.cod-estabel ~
ttitem-estab-b2c.it-codigo ttitem-estab-b2c.ind-aceita-saldao ~
ttitem-estab-b2c.qt-minima ttitem-estab-b2c.vl-cheio ~
ttitem-estab-b2c.presente ttitem-estab-b2c.qt-maxima-venda ~
ttitem-estab-b2c.vl-por ttitem-estab-b2c.nome-produto ~
ttitem-estab-b2c.descricao ttitem-estab-b2c.caracteristica ~
ttitem-estab-b2c.lg-item-pai-pedido ttitem-estab-b2c.lg-saldo-componente 
&Scoped-define DISPLAYED-TABLES ttitem-estab-b2c
&Scoped-define FIRST-DISPLAYED-TABLE ttitem-estab-b2c
&Scoped-Define DISPLAYED-OBJECTS fi-nome-estabelec fi-desc-item 

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

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-estabelec AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 53.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 3.58.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


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
     ttitem-estab-b2c.cod-estabel AT ROW 3 COL 16 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     fi-nome-estabelec AT ROW 3 COL 20.86 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     ttitem-estab-b2c.it-codigo AT ROW 4.04 COL 16 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fi-desc-item AT ROW 4.04 COL 32.43 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     ttitem-estab-b2c.ind-aceita-saldao AT ROW 5 COL 18 WIDGET-ID 16
          VIEW-AS TOGGLE-BOX
          SIZE 11 BY .83
     ttitem-estab-b2c.qt-minima AT ROW 6.5 COL 17 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 5 BY .79
     ttitem-estab-b2c.vl-cheio AT ROW 6.5 COL 33 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 11.14 BY .79
     ttitem-estab-b2c.presente AT ROW 6.5 COL 51 WIDGET-ID 38
          VIEW-AS TOGGLE-BOX
          SIZE 11.57 BY .83
     ttitem-estab-b2c.qt-maxima-venda AT ROW 7.5 COL 17 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 5 BY .79
     ttitem-estab-b2c.vl-por AT ROW 7.5 COL 33 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 11.14 BY .79
     ttitem-estab-b2c.nome-produto AT ROW 8.5 COL 17 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 44 BY .79
     ttitem-estab-b2c.descricao AT ROW 9.5 COL 19 NO-LABEL WIDGET-ID 22
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 60 BY 4
     ttitem-estab-b2c.caracteristica AT ROW 13.75 COL 19 NO-LABEL WIDGET-ID 20
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 60 BY 4
     ttitem-estab-b2c.lg-item-pai-pedido AT ROW 19 COL 30 WIDGET-ID 52
          VIEW-AS TOGGLE-BOX
          SIZE 28 BY .83
     ttitem-estab-b2c.lg-saldo-componente AT ROW 20 COL 30 WIDGET-ID 54
          VIEW-AS TOGGLE-BOX
          SIZE 27 BY .83
     "Caracter°sticas:" VIEW-AS TEXT
          SIZE 11 BY .54 AT ROW 13.88 COL 8 WIDGET-ID 42
     " Produto Composto" VIEW-AS TEXT
          SIZE 13 BY 1.25 AT ROW 17.75 COL 4 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 20.83
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     "Descriá∆o:" VIEW-AS TEXT
          SIZE 7.14 BY .54 AT ROW 9.63 COL 11.29 WIDGET-ID 40
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.75 COL 1
     RECT-3 AT ROW 18.25 COL 2 WIDGET-ID 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 20.83
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttitem-estab-b2c T "?" NO-UNDO mgesp item-estab-b2c
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
         HEIGHT             = 21.21
         WIDTH              = 90.29
         MAX-HEIGHT         = 21.21
         MAX-WIDTH          = 90.29
         VIRTUAL-HEIGHT     = 21.21
         VIRTUAL-WIDTH      = 90.29
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
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
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="eszoom/z01es436.w"}
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


&Scoped-define SELF-NAME ttitem-estab-b2c.caracteristica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-estab-b2c.caracteristica wMaintenance
ON ENTRY OF ttitem-estab-b2c.caracteristica IN FRAME fpage0
do:
   if ({&ttTable}.caracteristica:screen-value = '') then do:
      if (logical({&ttTable}.ind-aceita-saldao:screen-value)) then do:
         find item-estab-b2c no-lock
            where item-estab-b2c.cod-estabel = {&ttTable}.cod-estabel:screen-value
              and item-estab-b2c.it-codigo   = {&ttTable}.it-codigo:screen-value
              and not item-estab-b2c.ind-aceita-saldao no-error.

         if available (item-estab-b2c) and (item-estab-b2c.caracteristica <> '') then
            assign {&ttTable}.caracteristica:screen-value = item-estab-b2c.caracteristica.
      end.
   end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem-estab-b2c.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-estab-b2c.cod-estabel wMaintenance
ON LEAVE OF ttitem-estab-b2c.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    assign input frame fPage0 ttitem-estab-b2c.cod-estabel.

       {include/leave.i &tabela=estabelec
                        &atributo-ref=nome
                        &variavel-ref=fi-nome-estabelec
                        &where="estabelec.cod-estabel = ttitem-estab-b2c.cod-estabel"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem-estab-b2c.descricao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-estab-b2c.descricao wMaintenance
ON ENTRY OF ttitem-estab-b2c.descricao IN FRAME fpage0
do:
   if ({&ttTable}.descricao:screen-value = '') then do:
      if (logical({&ttTable}.ind-aceita-saldao:screen-value)) then do:
         find item-estab-b2c no-lock
            where item-estab-b2c.cod-estabel = {&ttTable}.cod-estabel:screen-value
              and item-estab-b2c.it-codigo   = {&ttTable}.it-codigo:screen-value
              and not item-estab-b2c.ind-aceita-saldao no-error.

         if available (item-estab-b2c) and (item-estab-b2c.descricao <> '') then
            assign {&ttTable}.descricao:screen-value = item-estab-b2c.descricao.
      end.
   end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem-estab-b2c.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-estab-b2c.it-codigo wMaintenance
ON F5 OF ttitem-estab-b2c.it-codigo IN FRAME fpage0 /* Item */
DO:
     {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                        &campo="ttitem-estab-b2c.it-codigo"
                        &campozoom="it-codigo"
                        &frame="fPage0"
                        &campo2="fi-desc-item"
                        &campozoom2="desc-item"
                        &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-estab-b2c.it-codigo wMaintenance
ON LEAVE OF ttitem-estab-b2c.it-codigo IN FRAME fpage0 /* Item */
DO:
    assign input frame fPage0 ttitem-estab-b2c.it-codigo.

       {include/leave.i &tabela=item
                        &atributo-ref=desc-item
                        &variavel-ref=fi-desc-item
                        &where="item.it-codigo = ttitem-estab-b2c.it-codigo"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-estab-b2c.it-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttitem-estab-b2c.it-codigo IN FRAME fpage0 /* Item */
DO:
  APPLY "F5" TO ttitem-estab-b2c.it-codigo IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem-estab-b2c.nome-produto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-estab-b2c.nome-produto wMaintenance
ON ENTRY OF ttitem-estab-b2c.nome-produto IN FRAME fpage0 /* Nome */
do:
   if ({&ttTable}.nome-produto:screen-value = '') then do:
      if (logical({&ttTable}.ind-aceita-saldao:screen-value)) then do:
         find item-estab-b2c no-lock
            where item-estab-b2c.cod-estabel = {&ttTable}.cod-estabel:screen-value
              and item-estab-b2c.it-codigo   = {&ttTable}.it-codigo:screen-value
              and not item-estab-b2c.ind-aceita-saldao no-error.

         if available (item-estab-b2c) and (item-estab-b2c.nome-produto <> '') then
            assign {&ttTable}.nome-produto:screen-value = item-estab-b2c.nome-produto + ' - Remanufaturado'.
         else
            assign {&ttTable}.nome-produto:screen-value = fi-desc-item:screen-value.
      end.
      else
         assign {&ttTable}.nome-produto:screen-value = fi-desc-item:screen-value.
   end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem-estab-b2c.qt-maxima-venda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-estab-b2c.qt-maxima-venda wMaintenance
ON ENTRY OF ttitem-estab-b2c.qt-maxima-venda IN FRAME fpage0 /* Qtde M†xima Venda */
do:
   if (integer({&ttTable}.qt-maxima-venda:screen-value) = 0) then do:
      if (logical({&ttTable}.ind-aceita-saldao:screen-value)) then do:
         find item-estab-b2c no-lock
            where item-estab-b2c.cod-estabel = {&ttTable}.cod-estabel:screen-value
              and item-estab-b2c.it-codigo   = {&ttTable}.it-codigo:screen-value
              and not item-estab-b2c.ind-aceita-saldao no-error.

         if available (item-estab-b2c) then
            assign {&ttTable}.qt-maxima-venda:screen-value = string(item-estab-b2c.qt-maxima-venda).
      end.
   end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem-estab-b2c.qt-minima
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-estab-b2c.qt-minima wMaintenance
ON ENTRY OF ttitem-estab-b2c.qt-minima IN FRAME fpage0 /* Quantidade M°nima */
do:
   if (integer({&ttTable}.qt-minima:screen-value) = 0) then do:
      if (logical({&ttTable}.ind-aceita-saldao:screen-value)) then do:
         find item-estab-b2c no-lock
            where item-estab-b2c.cod-estabel = {&ttTable}.cod-estabel:screen-value
              and item-estab-b2c.it-codigo   = {&ttTable}.it-codigo:screen-value
              and not item-estab-b2c.ind-aceita-saldao no-error.

         if available (item-estab-b2c) then
            assign {&ttTable}.qt-minima:screen-value = string(item-estab-b2c.qt-minima).
      end.
   end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem-estab-b2c.vl-cheio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-estab-b2c.vl-cheio wMaintenance
ON ENTRY OF ttitem-estab-b2c.vl-cheio IN FRAME fpage0 /* Valor Cheio */
do:
   if (decimal({&ttTable}.vl-cheio:screen-value) = 0) then do:
      if (logical({&ttTable}.ind-aceita-saldao:screen-value)) then do:
         find item-estab-b2c no-lock
            where item-estab-b2c.cod-estabel = {&ttTable}.cod-estabel:screen-value
              and item-estab-b2c.it-codigo   = {&ttTable}.it-codigo:screen-value
              and not item-estab-b2c.ind-aceita-saldao no-error.

         if available (item-estab-b2c) then
            assign {&ttTable}.vl-cheio:screen-value = string(item-estab-b2c.vl-cheio).
      end.
   end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem-estab-b2c.vl-por
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-estab-b2c.vl-por wMaintenance
ON ENTRY OF ttitem-estab-b2c.vl-por IN FRAME fpage0 /* Valor Por */
do:
   if (decimal({&ttTable}.vl-por:screen-value) = 0) then
      assign {&ttTable}.vl-por:screen-value = string({&ttTable}.vl-cheio:screen-value).
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem-estab-b2c.vl-por wMaintenance
ON LEAVE OF ttitem-estab-b2c.vl-por IN FRAME fpage0 /* Valor Por */
do:
   if (decimal({&ttTable}.vl-por:screen-value) > decimal({&ttTable}.vl-cheio:screen-value)) then do:
      message 'Valor Por n∆o pode ser maior que o Valor Cheio!'
         view-as alert-box error buttons ok.
      assign {&ttTable}.vl-por:screen-value = string({&ttTable}.vl-cheio:screen-value).
   end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
 ttitem-estab-b2c.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL ttitem-estab-b2c THEN DO:
        APPLY "leave" TO ttitem-estab-b2c.cod-estabel IN FRAME fPage0. 
        APPLY "leave" TO ttitem-estab-b2c.it-codigo IN FRAME fPage0. 
    END.
    ELSE DO:
        ASSIGN fi-nome-estabelec:SCREEN-VALUE IN FRAME fPage0 = "" 
               fi-desc-item:SCREEN-VALUE IN FRAME fPage0   = "".   
    END.


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
    
    DEFINE VARIABLE c-cod-estabel LIKE ttitem-estab-b2c.cod-estabel NO-UNDO.
    DEFINE VARIABLE c-it-codigo   LIKE ttitem-estab-b2c.it-codigo   NO-UNDO.
    define variable l-ind-aceita-saldao like ttitem-estab-b2c.ind-aceita-saldao no-undo.
    
    DEFINE FRAME fGoToRecord
        c-cod-estabel     AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 4    BY .88
        c-it-codigo       AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 16   BY .88
        l-ind-aceita-saldao at row 3.21 col 19.67 view-as toggle-box size 11 by .83
        btGoToOK          AT ROW 4.63 COL 2.14
        btGoToCancel      AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Item X Estabelecimento B2C" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V† Para Item X Estabelecimento B2C"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-estabel c-it-codigo l-ind-aceita-saldao.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-cod-estabel , INPUT c-it-codigo, input l-ind-aceita-saldao).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "item-estab-b2c":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-estabel c-it-codigo l-ind-aceita-saldao btGoToOK btGoToCancel 
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
       {&hDBOTable}:FILE-NAME <> "boes436":U THEN DO:
        {btb/btb008za.i1 esbo/boes436.p YES}
        {btb/btb008za.i2 esbo/boes436.p '' {&hDBOTable}}
    END.
    
    /*RUN setConstraint<Description> IN {&hDBOTable} (<pamameters>) NO-ERROR.*/
    RUN openQueryStatic IN {&hDBOTable} (INPUT "main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

