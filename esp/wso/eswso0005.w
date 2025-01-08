&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttint-vtex-estab NO-UNDO LIKE int-vtex-estab
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttint-vtex-estab-depos NO-UNDO LIKE int-vtex-estab-depos
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i eswso0005 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          eswso0005
&GLOBAL-DEFINE Version          1

&GLOBAL-DEFINE Folder           NO
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Conteudo

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        YES
&GLOBAL-DEFINE CopyParent       YES
&GLOBAL-DEFINE UpdateParent     YES
&GLOBAL-DEFINE DeleteParent     YES

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE CopySon1         YES
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE ttParent         ttint-vtex-estab
&GLOBAL-DEFINE hDBOParent       HDBOttint-vtex-estab
&GLOBAL-DEFINE DBOParentTable   int-vtex-estab
&GLOBAL-DEFINE DBOParentDestroy NO

&GLOBAL-DEFINE ttSon1           ttint-vtex-estab-depos
&GLOBAL-DEFINE hDBOSon1         HDBOttint-vtex-estab-depos
&GLOBAL-DEFINE DBOSon1Table     int-vtex-estab-depos
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE page0Fields      ttint-vtex-estab.cod-estabel c-descricao  
                                
&GLOBAL-DEFINE page1Browse      brSon1  

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.

DEFINE VARIABLE c-desc-depos AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-usuar-impl    AS CHAR        NO-UNDO.

DEF NEW GLOBAL SHARED VAR lg-eswso0005-acao AS CHAR NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE g-eswso0005-cliente AS INTEGER NO-UNDO.

DEFINE BUFFER b-emitente FOR emitente.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttint-vtex-estab-depos

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttint-vtex-estab-depos.cod-depos ~
fnDesc (ttint-vtex-estab-depos.cod-depos) @ c-desc-depos 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttint-vtex-estab-depos NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttint-vtex-estab-depos NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 ttint-vtex-estab-depos
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttint-vtex-estab-depos


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttint-vtex-estab.cod-estabel 
&Scoped-define ENABLED-TABLES ttint-vtex-estab
&Scoped-define FIRST-ENABLED-TABLE ttint-vtex-estab
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-11 btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btQueryJoins ~
btReportsJoins btExit btHelp c-descricao 
&Scoped-Define DISPLAYED-FIELDS ttint-vtex-estab.cod-estabel 
&Scoped-define DISPLAYED-TABLES ttint-vtex-estab
&Scoped-define FIRST-DISPLAYED-TABLE ttint-vtex-estab
&Scoped-Define DISPLAYED-OBJECTS c-descricao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDesc wMasterDetail 
FUNCTION fnDesc RETURNS CHARACTER
  ( c-dep AS CHAR /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUsuar wMasterDetail 
FUNCTION fnUsuar RETURNS CHARACTER
  ( c-observacao AS char /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
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

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopySon1 
     LABEL "Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon1 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 8.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttint-vtex-estab-depos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      ttint-vtex-estab-depos.cod-depos FORMAT "x(3)":U
      fnDesc (ttint-vtex-estab-depos.cod-depos) @ c-desc-depos COLUMN-LABEL " Descri‡Æo" FORMAT "x(80)":U
            WIDTH 52.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 70 BY 6
         FONT 2
         TITLE "Dep¢sitos Relacionados" ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 37.57 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 41.57 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 45.72 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 49.72 HELP
          "Elimina ocorrˆncia corrente"
     btQueryJoins AT ROW 1.13 COL 63.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 67.29 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 71.29 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 75.29 HELP
          "Ajuda"
     ttint-vtex-estab.cod-estabel AT ROW 3.42 COL 10 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 9.57 BY .88
     c-descricao AT ROW 3.42 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     rtToolBar AT ROW 1 COL 1
     RECT-11 AT ROW 2.75 COL 2 WIDGET-ID 164
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.14 BY 13.17
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.5 COL 3
     btAddSon1 AT ROW 7.96 COL 3
     btDeleteSon1 AT ROW 7.96 COL 13.29
     btCopySon1 AT ROW 8 COL 53
     btUpdateSon1 AT ROW 8 COL 63
     RECT-14 AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 5.25
         SIZE 79 BY 8.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttint-vtex-estab T "?" NO-UNDO mgesp int-vtex-estab
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttint-vtex-estab-depos T "?" NO-UNDO mgesp int-vtex-estab-depos
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 13.08
         WIDTH              = 80.57
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
ASSIGN 
       c-descricao:READ-ONLY IN FRAME fPage0        = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 RECT-14 fPage1 */
ASSIGN 
       btCopySon1:HIDDEN IN FRAME fPage1           = TRUE.

ASSIGN 
       btUpdateSon1:HIDDEN IN FRAME fPage1           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.ttint-vtex-estab-depos"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttint-vtex-estab-depos.cod-depos
     _FldNameList[2]   > "_<CALC>"
"fnDesc (ttint-vtex-estab-depos.cod-depos) @ c-desc-depos" " Descri‡Æo" "x(80)" ? ? ? ? ? ? ? no ? no no "52.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon1 */
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

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
    lg-eswso0005-acao = "Inclui".
    RUN addRecord IN THIS-PROCEDURE (INPUT "esp/wso/eswso0005A.w":U).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    {masterdetail/AddSon.i &ProgramSon="esp/wso/eswso0005b.w"
                           &PageNumber="1"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    lg-eswso0005-acao = "Copia".
    RUN copyRecord (INPUT "esp/wso/eswso0005a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCopySon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon1 wMasterDetail
ON CHOOSE OF btCopySon1 IN FRAME fPage1 /* Copiar */
DO:

    RETURN NO-APPLY.
    {masterdetail/CopySon.i &ProgramSon="esp/es0018b.w"
                            &PageNumber="1"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    {masterdetail/DeleteSon.i &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/ZoomReposition.i &ProgramZoom="eszoom/z01es906.w"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    lg-eswso0005-acao = "Modifica".
    RUN updateRecord IN THIS-PROCEDURE (INPUT "esp/acr/esacr070A.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO: 
    {masterdetail/UpdateSon.i &ProgramSon="esp/acr/esacr070b.w"
                              &PageNumber="1"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/MainBlock.i}
/*                                                                                                                */
/*     MESSAGE "MAIN"                                                                                             */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                         */
/*    IF  AVAIL ttint-vtex-estab THEN DO:                                                                       */
/*          FIND emitente NO-LOCK                                                                                 */
/*              WHERE emitente.cod-emitente = int(ttint-vtex-estab.cod-estabel:SCREEN-VALUE IN FRAME fpage0 )  */
/*                 NO-ERROR.                                                                                      */
/*          MESSAGE AVAIL ttint-vtex-estab                                                                      */
/*              VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                */
/*          IF  AVAIL emitente THEN                                                                               */
/*              ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = emitente.nome-emit.                             */
/*          ELSE                                                                                                  */
/*              ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = "NÆo encontrado...".                            */
/*                                                                                                                */
/*         RUN pi-mostra-frames (INPUT ttint-vtex-estab.vencto-fixo).                                           */
/*         RUN pi-carrega-campos.                                                                                 */
/*                                                                                                                */
/*     END.                                                                                                       */
/*                                                                                                                */
/*     MESSAGE "ttint-vtex-estab.cod-estabel: " ttint-vtex-estab.cod-estabel                                */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                     */

btUpdate:SENSITIVE IN FRAME fpage0 = NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aftercontroltoolbar wMasterDetail 
PROCEDURE aftercontroltoolbar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN btUpdate:SENSITIVE IN FRAME fpage0 = NO.
           btCopy:SENSITIVE IN FRAME fpage0 = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
IF  AVAIL ttint-vtex-estab THEN DO:                                                                     
      FIND estabelec NO-LOCK                                                                               
          WHERE estabelec.cod-estabel = ttint-vtex-estab.cod-estabel:SCREEN-VALUE IN FRAME fpage0
             NO-ERROR.                                                                                   
                                                             
      IF  AVAIL estabelec THEN                                                                             
          ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = estabelec.nome.                           
      ELSE                                                                                                
          ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = "NÆo encontrado...".                          
                                                                                                          
     VIEW FRAME fSemana.
     RUN pi-carrega-campos.                                                                               
                                                                                                          
 END.        



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializaInterface wMasterDetail 
PROCEDURE AfterInitializaInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF  AVAIL ttint-vtex-estab THEN DO:                                                                     
      FIND estabelec NO-LOCK                                                                               
          WHERE estabelec.cod-emitente = int(ttint-vtex-estab.cod-estabel:SCREEN-VALUE IN FRAME fpage0 ) NO-ERROR.                                                                                   
                                                             
      IF  AVAIL estabelec THEN                                                                             
          ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = estabelec.nome.                           
      ELSE                                                                                                
          ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = "NÆo encontrado...".                          
                                                                                                          
     VIEW FRAME fsemana.
     RUN pi-carrega-campos.                                                                               
                                                                                                          
 END. 



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
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

    DEFINE VARIABLE c-cod-estabel LIKE {&ttParent}.cod-estabel NO-UNDO.

    DEFINE FRAME fGoToRecord
        c-cod-estabel    AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE
             THREE-D SCROLLABLE TITLE "V  Para cliente" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-estabel.

        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT c-cod-estabel).

        IF RETURN-VALUE = "NOK":U THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "NÆo encontrado estabelecimento com c¢digo " + STRING(c-cod-estabel)).
                RETURN NO-APPLY.
        END.

        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).

        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        APPLY "GO":U TO FRAME fGoToRecord.

        VIEW FRAME fpage0.
    END.

    ENABLE c-cod-estabel btGoToOK btGoToCancel
        WITH FRAME fGoToRecord.

    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "esbo/boes924.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes924.p YES}
        {btb/btb008za.i2 esbo/boes924.p '' {&hDBOParent}} 
    END.
    
    RUN setConstraintMain IN {&hDBOParent} NO-ERROR.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "esbo/boes923.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes923.p YES}
        {btb/btb008za.i2 esbo/boes923.p '' {&hDBOSon1}} 
    END.
    
    RUN pi-reposiciona-cliente.   

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    {masterdetail/OpenQueriesSon.i &Parent="Emitente"
                                   &Query="Estabelec"
                                   &PageNumber="1"}
    VIEW FRAME fSemana.
    IF  AVAIL ttint-vtex-estab THEN DO:
    
        VIEW FRAME fSemana.
        RUN pi-carrega-campos.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-campos wMasterDetail 
PROCEDURE pi-carrega-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  NOT AVAIL ttint-vtex-estab THEN
        RETURN "OK".

    /*
    DO WITH FRAME fpage0:
        
        ASSIGN tg-grupo:CHECKED     = ttint-vtex-estab.grupo-econ
               tg-prazo:CHECKED     = ttint-vtex-estab.prazo-DDE
               rs-tipo:SCREEN-VALUE = string(ttint-vtex-estab.vencto-fixo).

        CASE ttint-vtex-estab.vencto-fixo:
            WHEN 1 THEN DO:
                ASSIGN tg-1:CHECKED IN FRAME fSemana  = ttint-vtex-estab.semana[1]  
                       tg-2:CHECKED IN FRAME fSemana  = ttint-vtex-estab.semana[2]  
                       tg-3:CHECKED IN FRAME fSemana  = ttint-vtex-estab.semana[3]  
                       tg-4:CHECKED IN FRAME fSemana  = ttint-vtex-estab.semana[4]  
                       tg-5:CHECKED IN FRAME fSemana  = ttint-vtex-estab.semana[5].
            END.
            WHEN 2 THEN DO:
                ASSIGN tg-dia-1:CHECKED IN FRAME fMes  = ttint-vtex-estab.mes[1]  
                       tg-dia-2:CHECKED IN FRAME fMes  = ttint-vtex-estab.mes[2]  
                       tg-dia-3:CHECKED IN FRAME fMes  = ttint-vtex-estab.mes[3]  
                       tg-dia-4:CHECKED IN FRAME fMes  = ttint-vtex-estab.mes[4]  
                       tg-dia-5:CHECKED IN FRAME fMes  = ttint-vtex-estab.mes[5]  
                       tg-dia-6:CHECKED IN FRAME fMes  = ttint-vtex-estab.mes[6]  
                       tg-dia-7:CHECKED IN FRAME fMes  = ttint-vtex-estab.mes[7]  
                       tg-dia-8:CHECKED IN FRAME fMes  = ttint-vtex-estab.mes[8]  
                       tg-dia-9:CHECKED IN FRAME fMes  = ttint-vtex-estab.mes[9]  
                       tg-dia-10:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[10] 
                       tg-dia-11:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[11] 
                       tg-dia-12:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[12] 
                       tg-dia-13:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[13] 
                       tg-dia-14:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[14] 
                       tg-dia-15:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[15] 
                       tg-dia-16:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[16] 
                       tg-dia-17:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[17] 
                       tg-dia-18:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[18] 
                       tg-dia-19:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[19] 
                       tg-dia-20:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[20] 
                       tg-dia-21:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[21] 
                       tg-dia-22:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[22] 
                       tg-dia-23:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[23] 
                       tg-dia-24:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[24] 
                       tg-dia-25:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[25] 
                       tg-dia-26:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[26] 
                       tg-dia-27:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[27] 
                       tg-dia-28:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[28] 
                       tg-dia-29:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[29] 
                       tg-dia-30:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[30] 
                       tg-dia-31:CHECKED IN FRAME fMes = ttint-vtex-estab.mes[31] .
            END.
        END.
    END.
    */

    VIEW FRAME fSemana.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-frames wMasterDetail 
PROCEDURE pi-mostra-frames :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-vencto-fixo AS INTEGER NO-UNDO.

    CASE p-vencto-fixo:
        WHEN 1 THEN DO:
            HIDE FRAME fMes.
            VIEW FRAME fSemana.
        END.
        WHEN 2 THEN DO:
            HIDE FRAME fSemana.
            VIEW FRAME fMes.
        END.
        WHEN 3 THEN DO:
            HIDE FRAME fSemana.
            HIDE FRAME fMes.
        END.
        OTHERWISE  DO:
            HIDE FRAME fSemana.
            HIDE FRAME fMes.
        END.
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reposiciona-cliente wMasterDetail 
PROCEDURE pi-reposiciona-cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     /*
     IF  g-eswso0005-cliente = 0 OR g-eswso0005-cliente = ? THEN
         RETURN "OK".
     DEF VAR rGoTo AS ROWID NO-UNDO.

      DEF BUFFER b-int-vtex-estab  FOR int-vtex-estab.

      FIND b-int-vtex-estab NO-LOCK
          WHERE b-int-vtex-estab.cod-estabel = g-eswso0005-cliente NO-ERROR .

      IF  AVAIL b-int-vtex-estab THEN DO:
          RUN goToKey IN {&hDBOParent} (INPUT b-int-vtex-estab.cod-estabel).
          IF RETURN-VALUE = "NOK":U THEN DO:
              RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Cliente":U).

              RETURN NO-APPLY.
          END.

          RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).

          RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
      END.
      ELSE DO:
          RUN utp/ut-msgs.p(input "show":U, 
                            input 17006,
                            input "Cliente" + string(g-eswso0005-cliente) + " NÆo cadastrado no programa esacr070").
      END.
     */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDesc wMasterDetail 
FUNCTION fnDesc RETURNS CHARACTER
  ( c-dep AS CHAR /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  
  FIND FIRST deposito NO-LOCK
      WHERE deposito.cod-depos = c-dep NO-ERROR.

  IF  AVAIL deposito THEN
      ASSIGN c-desc-depos = deposito.nome.

  RETURN c-desc-depos.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUsuar wMasterDetail 
FUNCTION fnUsuar RETURNS CHARACTER
  ( c-observacao AS char /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  ASSIGN c-usuar-impl = substr(c-observacao,1988,12).

  RETURN c-usuar-impl.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

