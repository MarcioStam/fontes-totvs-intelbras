&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-reservas-ast NO-UNDO LIKE reservas-ast
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
{include/i-prgvrs.i ESPDP080 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESPDP080
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

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        tt-reservas-ast
&GLOBAL-DEFINE hDBOTable      h-boes661a
&GLOBAL-DEFINE DBOTable       reservas-ast

&GLOBAL-DEFINE page0KeyFields tt-reservas-ast.cod-estabel tt-reservas-ast.cod-depos  ~
                              tt-reservas-ast.it-codigo tt-reservas-ast.cd-usuario
&GLOBAL-DEFINE page0Fields    tt-reservas-ast.dt-reserva-altera tt-reservas-ast.data-limite ~
                              tt-reservas-ast.dt-reserva tt-reservas-ast.qt-reserva         ~
                              tt-reservas-ast.cd-usuario-altera tt-reservas-ast.obs
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-import NO-UNDO
    FIELD it-codigo   LIKE reservas-ast.it-codigo
    FIELD cod-estabel LIKE reservas-ast.cod-estabel
    FIELD cod-depos   LIKE reservas-ast.cod-depos
    FIELD qt-reserva  LIKE reservas-ast.qt-reserva
    FIELD dt-reserva  LIKE reservas-ast.dt-reserva
    FIELD data-limite LIKE reservas-ast.data-limite
    FIELD observacao    AS CHAR
    FIELD erro        AS   LOGICAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-reservas-ast.cod-estabel ~
tt-reservas-ast.cod-depos tt-reservas-ast.it-codigo ~
tt-reservas-ast.cd-usuario tt-reservas-ast.qt-reserva ~
tt-reservas-ast.dt-reserva tt-reservas-ast.dt-reserva-altera ~
tt-reservas-ast.cd-usuario-altera tt-reservas-ast.data-limite ~
tt-reservas-ast.obs 
&Scoped-define ENABLED-TABLES tt-reservas-ast
&Scoped-define FIRST-ENABLED-TABLE tt-reservas-ast
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys RECT-1 btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo ~
btCancel btSave btExporta btImporta btEliminaUsuar btElimina btQueryJoins ~
btReportsJoins btExit btHelp bt-historico 
&Scoped-Define DISPLAYED-FIELDS tt-reservas-ast.cod-estabel ~
tt-reservas-ast.cod-depos tt-reservas-ast.it-codigo ~
tt-reservas-ast.cd-usuario tt-reservas-ast.qt-reserva ~
tt-reservas-ast.dt-reserva tt-reservas-ast.dt-reserva-altera ~
tt-reservas-ast.cd-usuario-altera tt-reservas-ast.data-limite ~
tt-reservas-ast.obs 
&Scoped-define DISPLAYED-TABLES tt-reservas-ast
&Scoped-define FIRST-DISPLAYED-TABLE tt-reservas-ast
&Scoped-Define DISPLAYED-OBJECTS c-desc-estab c-desc-deposito c-desc-item 

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
DEFINE BUTTON bt-historico 
     LABEL "Hist¢rico" 
     SIZE 16.14 BY .88.

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

DEFINE BUTTON btElimina 
     IMAGE-UP FILE "image/im-clr1":U
     IMAGE-INSENSITIVE FILE "image/ii-clr1":U
     LABEL "" 
     SIZE 5.29 BY 1.25 TOOLTIP "Elimina por arquivo".

DEFINE BUTTON btEliminaUsuar 
     IMAGE-UP FILE "image/im-bt_excluir":U
     IMAGE-INSENSITIVE FILE "image/im-bt_excluir":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "Selecionar eliminaá∆o".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExporta 
     IMAGE-UP FILE "image/im-imp.bmp":U
     LABEL "Exportar" 
     SIZE 5.29 BY 1.25 TOOLTIP "Exportar".

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

DEFINE BUTTON btImporta 
     IMAGE-UP FILE "image/im-exp.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-exp.bmp":U
     LABEL "Importar" 
     SIZE 5.29 BY 1.25 TOOLTIP "Importar".

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

DEFINE VARIABLE c-desc-deposito AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98 BY 5.04.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98 BY 4.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 98 BY 1.5
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
     btAdd AT ROW 1.13 COL 30.43 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 34.43 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 38.43 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 42.43 HELP
          "Elimina ocorrància corrente"
     btUndo AT ROW 1.13 COL 46.43 HELP
          "Desfaz alteraá‰es"
     btCancel AT ROW 1.13 COL 50.43 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 54.43 HELP
          "Confirma alteraá‰es"
     btExporta AT ROW 1.13 COL 60 WIDGET-ID 70
     btImporta AT ROW 1.13 COL 65.57 WIDGET-ID 68
     btEliminaUsuar AT ROW 1.13 COL 71.14 WIDGET-ID 74
     btElimina AT ROW 1.13 COL 76.43 WIDGET-ID 72
     btQueryJoins AT ROW 1.13 COL 82.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 86.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 90.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 94.57 HELP
          "Ajuda"
     tt-reservas-ast.cod-estabel AT ROW 3 COL 18 COLON-ALIGNED WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-estab AT ROW 3 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     tt-reservas-ast.cod-depos AT ROW 3.92 COL 18 COLON-ALIGNED WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-deposito AT ROW 3.92 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     tt-reservas-ast.it-codigo AT ROW 4.83 COL 18 COLON-ALIGNED WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item AT ROW 4.83 COL 35.29 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     tt-reservas-ast.cd-usuario AT ROW 5.75 COL 18 COLON-ALIGNED WIDGET-ID 46
          LABEL "Usu†rio"
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     tt-reservas-ast.qt-reserva AT ROW 7.58 COL 18 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     tt-reservas-ast.dt-reserva AT ROW 7.58 COL 60 COLON-ALIGNED WIDGET-ID 56
          LABEL "Dt.Reserva"
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     tt-reservas-ast.dt-reserva-altera AT ROW 8.5 COL 18 COLON-ALIGNED WIDGET-ID 58
          LABEL "Dt.Res.Alterada"
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     tt-reservas-ast.cd-usuario-altera AT ROW 8.5 COL 60 COLON-ALIGNED WIDGET-ID 48
          LABEL "Usu†rio Alt."
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     tt-reservas-ast.data-limite AT ROW 9.42 COL 18 COLON-ALIGNED WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     bt-historico AT ROW 9.42 COL 62 WIDGET-ID 66
     tt-reservas-ast.obs AT ROW 10.42 COL 16.43 WIDGET-ID 80
          VIEW-AS FILL-IN 
          SIZE 58 BY .88
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
     RECT-1 AT ROW 7.21 COL 1 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 98.57 BY 11.67
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-reservas-ast T "?" NO-UNDO mgesp reservas-ast
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
         HEIGHT             = 11.71
         WIDTH              = 98.86
         MAX-HEIGHT         = 27.5
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.5
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
/* SETTINGS FOR FILL-IN c-desc-deposito IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-reservas-ast.cd-usuario IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-reservas-ast.cd-usuario-altera IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-reservas-ast.dt-reserva IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-reservas-ast.dt-reserva-altera IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-reservas-ast.obs IN FRAME fpage0
   ALIGN-L                                                              */
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


&Scoped-define SELF-NAME bt-historico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-historico wMaintenance
ON CHOOSE OF bt-historico IN FRAME fpage0 /* Hist¢rico */
DO:
    DO WITH FRAME f-main:
        RUN esp/pdp/espdp080b.w(INPUT tt-reservas-ast.it-codigo:SCREEN-VALUE,
                                INPUT tt-reservas-ast.cod-estabel:SCREEN-VALUE,
                                INPUT tt-reservas-ast.cod-depos:SCREEN-VALUE,
                                INPUT tt-reservas-ast.cd-usuario:SCREEN-VALUE).
    END.
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


&Scoped-define SELF-NAME btElimina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btElimina wMaintenance
ON CHOOSE OF btElimina IN FRAME fpage0
DO:
    RUN piEliminar.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEliminaUsuar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEliminaUsuar wMaintenance
ON CHOOSE OF btEliminaUsuar IN FRAME fpage0
DO:
    RUN esp/pdp/espdp080a.w.  
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


&Scoped-define SELF-NAME btExporta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExporta wMaintenance
ON CHOOSE OF btExporta IN FRAME fpage0 /* Exportar */
DO:
    RUN piExportacao.  
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


&Scoped-define SELF-NAME btImporta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImporta wMaintenance
ON CHOOSE OF btImporta IN FRAME fpage0 /* Importar */
DO:
    RUN piImportacao.  
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
    {method/zoomreposition.i &ProgramZoom="eszoom/z01es661a.w"}

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


&Scoped-define SELF-NAME tt-reservas-ast.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-reservas-ast.cod-depos wMaintenance
ON F5 OF tt-reservas-ast.cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                       &campo="tt-reservas-ast.cod-depos"
                       &campozoom="cod-depos"
                       &frame="fPage0"
                       &campo2="c-desc-deposito"
                       &campozoom2="nome"
                       &frame2="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-reservas-ast.cod-depos wMaintenance
ON LEAVE OF tt-reservas-ast.cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:
    FOR FIRST deposito FIELDS(nome) NO-LOCK
        WHERE deposito.cod-depos = INPUT FRAME fPage0 tt-reservas-ast.cod-depos:

        ASSIGN c-desc-deposito:SCREEN-VALUE IN FRAME fPage0 = deposito.nome.
    END.

    IF NOT AVAIL deposito THEN
        ASSIGN c-desc-deposito:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-reservas-ast.cod-depos wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-reservas-ast.cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-reservas-ast.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-reservas-ast.cod-estabel wMaintenance
ON F5 OF tt-reservas-ast.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in661.w"
                       &campo="tt-reservas-ast.cod-estabel"
                       &campozoom="cod-estabel"
                       &frame="fPage0"
                       &campo2="c-desc-estab"
                       &campozoom2="nome"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-reservas-ast.cod-estabel wMaintenance
ON LEAVE OF tt-reservas-ast.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    FOR FIRST estabelec FIELDS(nome) NO-LOCK
        WHERE estabelec.cod-estabel = tt-reservas-ast.cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME}:

        ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = estabelec.nome.
    END.

    IF NOT AVAIL estabelec THEN
        ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-reservas-ast.cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-reservas-ast.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-reservas-ast.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-reservas-ast.it-codigo wMaintenance
ON F5 OF tt-reservas-ast.it-codigo IN FRAME fpage0 /* Item */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo="tt-reservas-ast.it-codigo"
                       &campozoom="it-codigo"
                       &frame="fPage0"
                       &campo2="c-desc-item"
                       &campozoom2="desc-item"
                       &frame2="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-reservas-ast.it-codigo wMaintenance
ON LEAVE OF tt-reservas-ast.it-codigo IN FRAME fpage0 /* Item */
DO:
    FOR FIRST item FIELDS(desc-item) NO-LOCK
        WHERE item.it-codigo = INPUT FRAME fPage0 tt-reservas-ast.it-codigo:

        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage0 = item.desc-item.
    END.

    IF NOT AVAIL item THEN
        ASSIGN c-desc-item:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-reservas-ast.it-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-reservas-ast.it-codigo IN FRAME fpage0 /* Item */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}


tt-reservas-ast.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage0.
tt-reservas-ast.cod-depos  :LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage0.
tt-reservas-ast.it-codigo  :LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage0.

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
    APPLY "LEAVE" TO tt-reservas-ast.cod-estabel IN FRAME fPage0.
    APPLY "LEAVE" TO tt-reservas-ast.cod-depos   IN FRAME fPage0.
    APPLY "LEAVE" TO tt-reservas-ast.it-codigo   IN FRAME fPage0.

    ENABLE btImporta btExporta btElimina btEliminaUsuar bt-historico WITH FRAME fPage0.

    RETURN "OK":U.
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
IF cAction = "COPY" OR cAction = "ADD" THEN
    ASSIGN tt-reservas-ast.dt-reserva:SCREEN-VALUE IN FRAME fPage0 = STRING(TODAY)
           tt-reservas-ast.cd-usuario:SCREEN-VALUE                 = c-seg-usuario
           tt-reservas-ast.cd-usuario:SENSITIVE                    = NO
           tt-reservas-ast.cd-usuario-altera:SCREEN-VALUE          = ""
           tt-reservas-ast.dt-reserva-altera:SCREEN-VALUE          = "".

IF cAction = "UPDATE" THEN
    ASSIGN tt-reservas-ast.dt-reserva-altera:SCREEN-VALUE IN FRAME fPage0 = STRING(TODAY)
           tt-reservas-ast.cd-usuario-altera:SCREEN-VALUE                 = c-seg-usuario.

ASSIGN tt-reservas-ast.cd-usuario-altera:SENSITIVE = NO 
       tt-reservas-ast.dt-reserva-altera:SENSITIVE = NO /*
       tt-reservas-ast.dt-reserva       :SENSITIVE = NO*/.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterSaveFields wMaintenance 
PROCEDURE AfterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeInitializeInterface wMaintenance 
PROCEDURE BeforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME fPage0:

END.

RETURN "OK":U.
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
    
    DEFINE VARIABLE c-estab LIKE {&ttTable}.cod-estabel NO-UNDO.
    DEFINE VARIABLE c-depos LIKE {&ttTable}.cod-depos   NO-UNDO.
    DEFINE VARIABLE c-item  LIKE {&ttTable}.it-codigo   NO-UNDO.
    DEFINE VARIABLE c-usuar LIKE {&ttTable}.cd-usuario  NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-estab      AT ROW 1.21 COL 17.72 COLON-ALIGNED 
        c-depos      AT ROW 2.21 COL 17.72 COLON-ALIGNED 
        c-item       AT ROW 3.21 COL 17.72 COLON-ALIGNED 
        c-usuar      AT ROW 4.21 COL 17.72 COLON-ALIGNED 
        btGoToOK          AT ROW 6.63 COL 2.14
        btGoToCancel      AT ROW 6.63 COL 13
        rtGoToButton      AT ROW 6.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Reservas Ast" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    ASSIGN c-estab:WIDTH-CHARS IN FRAME fGoToRecord = 5
           c-depos:WIDTH-CHARS IN FRAME fGoToRecord = 5
           c-item :WIDTH-CHARS IN FRAME fGoToRecord = 15
           c-usuar:WIDTH-CHARS IN FRAME fGoToRecord = 15.

    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Reservas_Ast"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-estab c-depos c-item c-usuar.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-estab,
                                     INPUT c-depos,
                                     INPUT c-item,
                                     INPUT c-usuar).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Reservas Ast":U).
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-estab c-depos c-item c-usuar btGoToOK btGoToCancel 
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
       {&hDBOTable}:FILE-NAME <> "esbo/boes661a.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes661a.p YES}
        {btb/btb008za.i2 esbo/boes661a.p '' {&hDBOTable}}
    END.
    
    /*RUN setConstraint<Description> IN {&hDBOTable} (<pamameters>) NO-ERROR.*/
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminar wMaintenance 
PROCEDURE piEliminar :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUTTON    btGoToCancel       AUTO-END-KEY LABEL "&Cancelar" SIZE 10 BY 1    BGCOLOR 8.
DEFINE BUTTON    btGoToOK           AUTO-GO      LABEL "&OK"       SIZE 10 BY 1    BGCOLOR 8.
DEFINE BUTTON    bt-arquivo-entrada IMAGE-UP FILE "image\im-sea":U IMAGE-INSENSITIVE FILE "image\ii-sea":U LABEL "" TOOLTIP "Buscar Arquivo":U SIZE 4 BY 1.
DEFINE RECTANGLE rtGoToButton       EDGE-PIXELS 2 GRAPHIC-EDGE     SIZE 58 BY 1.42 BGCOLOR 7.
DEFINE VARIABLE  rGoTo              AS ROWID                                                            NO-UNDO.
DEFINE VARIABLE  c-arquivo-entrada  AS CHARACTER VIEW-AS EDITOR MAX-CHARS 256 SIZE 53 BY .88 BGCOLOR 15 NO-UNDO.

DEFINE FRAME fImportRecord
    c-arquivo-entrada  AT ROW 2.31 COL 01.70 HELP "Nome do arquivo para eliminaá∆o por faixa" NO-LABEL
    bt-arquivo-entrada AT ROW 2.23 COL 55.29 
    btGoToOK           AT ROW 4.63 COL 02.14
    btGoToCancel       AT ROW 4.63 COL 13.00
    rtGoToButton       AT ROW 4.38 COL 01.00
    SPACE(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
         THREE-D SCROLLABLE TITLE "Informe Arquivo para Eliminaá∆o por Faixa" FONT 1
         DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

ON  CHOOSE OF bt-arquivo-entrada IN FRAME fImportRecord DO:
    DEFINE VARIABLE c-arq-conv AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-ok       AS LOGICAL   NO-UNDO.

    ASSIGN c-arq-conv = replace(input frame fImportRecord c-arquivo-entrada, "/", "\").

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS &IF "{3}" <> "" &THEN {3} 
               &ENDIF
               &IF "{3}" = "" &THEN
               "*.csv" "*.csv",
               "*.*" "*.*"         
               &ENDIF      
       &IF 'c-arquivo-entrada' <> 'c-arquivo-entrada' &THEN
           ASK-OVERWRITE
           SAVE-AS
       &ENDIF
       DEFAULT-EXTENSION "lst"
       INITIAL-DIR "spool" 
       USE-FILENAME
       UPDATE l-ok.

    if  l-ok then do:
        assign c-arquivo-entrada = replace(c-arq-conv, "\", "/").
        display c-arquivo-entrada with frame fImportRecord.
    end. /* if  l-ok */
END. /* ON  CHOOSE OF bt-arquivo-entrada ... */

ON  CHOOSE OF btGoToOK IN FRAME fImportRecord DO:
    ASSIGN c-arquivo-entrada.

    IF  c-arquivo-entrada = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Arquivo de importaá∆o deve ser informado.":U + '~~' +
                                                              "Para prosseguir deve informar o caminho/arquivo corretamente.":U + CHR(10) + 
                                                              "Utilize o bot∆o de busca.":U).
        APPLY 'entry':U TO c-arquivo-entrada IN FRAME fImportRecord.
        RETURN NO-APPLY.
    END. /* IF  c-arquivo-entrada = "" ... */
    
    RUN piImportaParaEliminar(INPUT c-arquivo-entrada).

    APPLY "GO":U TO FRAME fImportRecord.
    
    IF  CAN-FIND(FIRST tt-import WHERE tt-import.erro = TRUE) 
    THEN RUN utp/ut-msgs.p (INPUT "show":U,
                            INPUT 15825,
                            INPUT "As inconsistàncias geraram um arquivo." + '~~' +
                                  "Pode encontra-lo no caminho: " + STRING(SESSION:TEMP-DIRECTORY + "Elimina-ReservasAST-ERROS.csv":U)).
    ELSE RUN utp/ut-msgs.p (INPUT "show":U,
                            INPUT 15825,
                            INPUT "Registros eliminados com sucesso.").
END. /* ON  CHOOSE OF btGoToOK ... */

ENABLE  c-arquivo-entrada bt-arquivo-entrada btGoToOK btGoToCancel WITH FRAME fImportRecord. 

WAIT-FOR "GO":U OF FRAME fImportRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExportacao wMaintenance 
PROCEDURE piExportacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "reservasAST-usuario-" + TRIM(c-seg-usuario) + ".csv":U) NO-CONVERT.

PUT "ITEM;ESTAB;DEPOS;QT.RESERVA;DT RESERVA;DT LIMITE;OBS" SKIP.

FOR EACH  reservas-ast NO-LOCK
    WHERE reservas-ast.cd-usuario = c-seg-usuario:
        
    PUT UNFORMATTED
        reservas-ast.it-codigo ";"
        reservas-ast.cod-estabel ";"
        reservas-ast.cod-depos ";"
        reservas-ast.qt-reserva ";" 
        reservas-ast.dt-reserva ";"
        reservas-ast.data-limite ";"
        reservas-ast.obs SKIP.
END. /* FOR EACH  reservas-ast NO-LOCK */
OUTPUT CLOSE.

RUN utp/ut-msgs.p (INPUT 'show':U,
                   INPUT 15825,
                   INPUT 'Gerado arquivo de exportaá∆o.' + '~~' +
                         'Foi gerado um arquivo dos registros de seu usu†rio no caminho: ' + CHR(10) +
                          caps(STRING(SESSION:TEMP-DIRECTORY + "reservasAST-usuario-" + TRIM(c-seg-usuario) + ".csv":U)) + CHR(10) + CHR(10) +
                          'Para utilizar o bot∆o eliminaá∆o por faixa, altere este arquivo gerado, deixando apenas os registros que deseja eliminar.').
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImportaArquivo wMaintenance 
PROCEDURE piImportaArquivo :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-arquivo-entrada AS CHARACTER NO-UNDO.

DEFINE VARIABLE i-cont  AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-linha AS CHARACTER NO-UNDO.

INPUT FROM VALUE(p-arquivo-entrada).
OUTPUT TO value(SESSION:TEMP-DIRECTORY + "ReservasAST-ERROS.csv":U) NO-CONVERT.

EMPTY TEMP-TABLE tt-import NO-ERROR.

REPEAT:
    IMPORT UNFORMATTED c-linha.

    ASSIGN i-cont = i-cont + 1.

    IF i-cont = 1 THEN
        NEXT.

    CREATE tt-import.
    ASSIGN tt-import.it-codigo   = ENTRY(1,c-linha,";")
           tt-import.cod-estabel = ENTRY(2,c-linha,";")
           tt-import.cod-depos   = ENTRY(3,c-linha,";")
           tt-import.qt-reserva  = dec(ENTRY(4,c-linha,";"))
           tt-import.dt-reserva  = DATE(ENTRY(5,c-linha,";"))
           tt-import.data-limite = DATE(ENTRY(6,c-linha,";"))
           tt-import.observacao  = ENTRY(7,c-linha,";").

   IF  NOT CAN-FIND(FIRST item 
                     WHERE item.it-codigo = tt-import.it-codigo) THEN DO:
        PUT UNFORMATTED tt-import.it-codigo ";" tt-import.cod-estabel ";" tt-import.cod-depos ";" "ERRO: Item n∆o encontrado." SKIP.
        ASSIGN tt-import.erro = TRUE.
    END. /* IF  NOT CAN-FIND(FIRST item */

    IF  NOT CAN-FIND(FIRST estabelec 
                     WHERE estabelec.cod-estabel = tt-import.cod-estabel) THEN DO:
        PUT UNFORMATTED tt-import.it-codigo ";" tt-import.cod-estabel ";" tt-import.cod-depos ";" "ERRO: Estabelecimento n∆o encontrado." SKIP.
        ASSIGN tt-import.erro = TRUE.
    END. /* IF  tt-import.dt-entrega-futura */
    
    IF  NOT CAN-FIND(FIRST deposito
                     WHERE deposito.cod-depos = tt-import.cod-depos) THEN DO:
        PUT UNFORMATTED tt-import.it-codigo ";" tt-import.cod-estabel ";" tt-import.cod-depos ";" "ERRO: Dep¢sito n∆o encontrado." SKIP.
        ASSIGN tt-import.erro = TRUE.
    END. /* IF  tt-import.dt-entrega-futura */

    IF  CAN-FIND (FIRST reservas-ast
                  WHERE reservas-ast.it-codigo   = tt-import.it-codigo
                  AND   reservas-ast.cod-estabel = tt-import.cod-estabel
                  AND   reservas-ast.cod-depos   = tt-import.cod-depos
                  AND   reservas-ast.cd-usuario  = c-seg-usuario) THEN DO:
        PUT UNFORMATTED tt-import.it-codigo ";" tt-import.cod-estabel ";" tt-import.cod-depos ";" "ERRO: J† existe o registro com a chave informada." SKIP.
        ASSIGN tt-import.erro = TRUE.
    END. /* IF  CAN-FIND (FIRST reservas-ast */
END. /* REPEAT: */
INPUT CLOSE.
OUTPUT CLOSE.

FOR EACH  tt-import
    WHERE tt-import.erro = FALSE:

    CREATE reservas-ast.
    assign reservas-ast.it-codigo         = tt-import.it-codigo
           reservas-ast.cod-estabel       = tt-import.cod-estabel
           reservas-ast.cod-depos         = tt-import.cod-depos
           reservas-ast.qt-reserva        = tt-import.qt-reserva
           reservas-ast.dt-reserva        = tt-import.dt-reserva
           reservas-ast.cd-usuario        = c-seg-usuario
           reservas-ast.dt-reserva-altera = TODAY
           reservas-ast.data-limite       = tt-import.data-limite
           reservas-ast.cd-usuario-altera = c-seg-usuario
           reservas-ast.obs               = tt-import.observacao.
           
END. /* FOR EACH  tt-import */
RELEASE reservas-ast.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImportacao wMaintenance 
PROCEDURE piImportacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUTTON    btGoToCancel       AUTO-END-KEY LABEL "&Cancelar" SIZE 10 BY 1    BGCOLOR 8.
DEFINE BUTTON    btGoToOK           AUTO-GO      LABEL "&OK"       SIZE 10 BY 1    BGCOLOR 8.
DEFINE BUTTON    bt-arquivo-entrada IMAGE-UP FILE "image\im-sea":U IMAGE-INSENSITIVE FILE "image\ii-sea":U LABEL "" TOOLTIP "Buscar Arquivo":U SIZE 4 BY 1.
DEFINE RECTANGLE rtGoToButton       EDGE-PIXELS 2 GRAPHIC-EDGE     SIZE 58 BY 1.42 BGCOLOR 7.
DEFINE VARIABLE  rGoTo              AS ROWID                                                            NO-UNDO.
DEFINE VARIABLE  c-arquivo-entrada  AS CHARACTER VIEW-AS EDITOR MAX-CHARS 256 SIZE 53 BY .88 BGCOLOR 15 NO-UNDO.

DEFINE FRAME fImportRecord
    c-arquivo-entrada  AT ROW 2.31 COL 01.70 HELP "Nome do arquivo de importaá∆o" NO-LABEL
    bt-arquivo-entrada AT ROW 2.23 COL 55.29 
    btGoToOK           AT ROW 4.63 COL 02.14
    btGoToCancel       AT ROW 4.63 COL 13.00
    rtGoToButton       AT ROW 4.38 COL 01.00
    SPACE(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
         THREE-D SCROLLABLE TITLE "Informe Arquivo de Importaá∆o" FONT 1
         DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

ON  CHOOSE OF bt-arquivo-entrada IN FRAME fImportRecord DO:
    DEFINE VARIABLE c-arq-conv AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-ok       AS LOGICAL   NO-UNDO.

    ASSIGN c-arq-conv = replace(input frame fImportRecord c-arquivo-entrada, "/", "\").

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS &IF "{3}" <> "" &THEN {3} 
               &ENDIF
               &IF "{3}" = "" &THEN
               "*.csv" "*.csv",
               "*.*" "*.*"         
               &ENDIF      
       &IF 'c-arquivo-entrada' <> 'c-arquivo-entrada' &THEN
           ASK-OVERWRITE
           SAVE-AS
       &ENDIF
       DEFAULT-EXTENSION "lst"
       INITIAL-DIR "spool" 
       USE-FILENAME
       UPDATE l-ok.

    if  l-ok then do:
        assign c-arquivo-entrada = replace(c-arq-conv, "\", "/").
        display c-arquivo-entrada with frame fImportRecord.
    end. /* if  l-ok */
END. /* ON  CHOOSE OF bt-arquivo-entrada ... */

ON  CHOOSE OF btGoToOK IN FRAME fImportRecord DO:
    ASSIGN c-arquivo-entrada.

    IF  c-arquivo-entrada = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Arquivo de importaá∆o deve ser informado.":U + '~~' +
                                                              "Para prosseguir deve informar o caminho/arquivo corretamente.":U + CHR(10) + 
                                                              "Utilize o bot∆o de busca.":U).
        APPLY 'entry':U TO c-arquivo-entrada IN FRAME fImportRecord.
        RETURN NO-APPLY.
    END. /* IF  c-arquivo-entrada = "" ... */
    
    RUN piImportaArquivo(INPUT c-arquivo-entrada).

    APPLY "GO":U TO FRAME fImportRecord.
    
    IF  CAN-FIND(FIRST tt-import WHERE tt-import.erro = TRUE) 
    THEN RUN utp/ut-msgs.p (INPUT "show":U,
                            INPUT 15825,
                            INPUT "As inconsistàncias geraram um arquivo." + '~~' +
                                  "Pode encontra-lo no caminho: " + STRING(SESSION:TEMP-DIRECTORY + "ReservasAST-ERROS.csv":U)).
    ELSE RUN utp/ut-msgs.p (INPUT "show":U,
                            INPUT 15825,
                            INPUT "Registros importados com sucesso.").
END. /* ON  CHOOSE OF btGoToOK ... */

ENABLE  c-arquivo-entrada bt-arquivo-entrada btGoToOK btGoToCancel WITH FRAME fImportRecord. 

WAIT-FOR "GO":U OF FRAME fImportRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImportaParaEliminar wMaintenance 
PROCEDURE piImportaParaEliminar :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-arquivo-entrada AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-linha AS CHARACTER NO-UNDO.

INPUT FROM VALUE(p-arquivo-entrada).
OUTPUT TO value(SESSION:TEMP-DIRECTORY + "Elimina-ReservasAST-ERROS.csv":U) NO-CONVERT.

EMPTY TEMP-TABLE tt-import NO-ERROR.

REPEAT:
    IMPORT UNFORMATTED c-linha.

    CREATE tt-import.
    ASSIGN tt-import.it-codigo   = ENTRY(1,c-linha,";")
           tt-import.cod-estabel = ENTRY(2,c-linha,";")
           tt-import.cod-depos   = ENTRY(3,c-linha,";")
           tt-import.qt-reserva  = dec(ENTRY(4,c-linha,";")).

    IF  NOT CAN-FIND(FIRST item 
                     WHERE item.it-codigo = tt-import.it-codigo) THEN DO:
        PUT UNFORMATTED tt-import.it-codigo ";" tt-import.cod-estabel ";" tt-import.cod-depos ";" "ERRO: Item n∆o encontrado." SKIP.
        ASSIGN tt-import.erro = TRUE.
    END. /* IF  NOT CAN-FIND(FIRST item */

    IF  NOT CAN-FIND(FIRST estabelec 
                     WHERE estabelec.cod-estabel = tt-import.cod-estabel) THEN DO:
        PUT UNFORMATTED tt-import.it-codigo ";" tt-import.cod-estabel ";" tt-import.cod-depos ";" "ERRO: Estabelecimento n∆o encontrado." SKIP.
        ASSIGN tt-import.erro = TRUE.
    END. /* IF  tt-import.dt-entrega-futura */
    
    IF  NOT CAN-FIND(FIRST deposito
                     WHERE deposito.cod-depos = tt-import.cod-depos) THEN DO:
        PUT UNFORMATTED tt-import.it-codigo ";" tt-import.cod-estabel ";" tt-import.cod-depos ";" "ERRO: Dep¢sito n∆o encontrado." SKIP.
        ASSIGN tt-import.erro = TRUE.
    END. /* IF  tt-import.dt-entrega-futura */

    IF  NOT CAN-FIND (FIRST reservas-ast
                      WHERE reservas-ast.it-codigo   = tt-import.it-codigo
                      AND   reservas-ast.cod-estabel = tt-import.cod-estabel
                      AND   reservas-ast.cod-depos   = tt-import.cod-depos
                      AND   reservas-ast.cd-usuario  = c-seg-usuario) THEN DO:
        PUT UNFORMATTED tt-import.it-codigo ";" tt-import.cod-estabel ";" tt-import.cod-depos ";" "ERRO: N∆o existe o registro com a chave informada para o seu usu†rio." SKIP.
        ASSIGN tt-import.erro = TRUE.
    END. /* IF  CAN-FIND (FIRST reservas-ast */
END. /* REPEAT: */
INPUT CLOSE.
OUTPUT CLOSE.

FOR EACH  tt-import
    WHERE tt-import.erro = FALSE,
    FIRST reservas-ast EXCLUSIVE-LOCK
    WHERE reservas-ast.it-codigo   = tt-import.it-codigo
    AND   reservas-ast.cod-estabel = tt-import.cod-estabel
    AND   reservas-ast.cod-depos   = tt-import.cod-depos
    AND   reservas-ast.cd-usuario  = c-seg-usuario:

    DELETE reservas-ast.
           
END. /* FOR EACH  tt-import */

RELEASE reservas-ast.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

