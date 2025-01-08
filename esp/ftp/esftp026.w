&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttcomis-deb-cred NO-UNDO LIKE comis-deb-cred
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttrepres NO-UNDO LIKE repres
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
{include/i-prgvrs.i ESFTP026 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          ESFTP026
&GLOBAL-DEFINE Version          2.04.00.001

&GLOBAL-DEFINE Folder           NO
&GLOBAL-DEFINE InitialPage      1
/*&GLOBAL-DEFINE FolderLabels     <Folder1 ,Folder 2 ,... , Folder8>*/

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        NO
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     NO
&GLOBAL-DEFINE DeleteParent     NO

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE CopySon1         YES
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE AddSon2          NO
&GLOBAL-DEFINE CopySon2         NO
&GLOBAL-DEFINE UpdateSon2       NO
&GLOBAL-DEFINE DeleteSon2       NO

&GLOBAL-DEFINE ttParent         ttrepres
&GLOBAL-DEFINE hDBOParent       boad229
&GLOBAL-DEFINE DBOParentTable   ttrepres
&GLOBAL-DEFINE DBOParentDestroy 

&GLOBAL-DEFINE ttSon1           ttcomis-deb-cred
&GLOBAL-DEFINE hDBOSon1         boes270
&GLOBAL-DEFINE DBOSon1Table     ttcomis-deb-cred
&GLOBAL-DEFINE DBOSon1Destroy   

&GLOBAL-DEFINE ttSon2           
&GLOBAL-DEFINE hDBOSon2         
&GLOBAL-DEFINE DBOSon2Table     
&GLOBAL-DEFINE DBOSon2Destroy   

&GLOBAL-DEFINE page0Fields      ttrepres.cod-rep ttrepres.nome ttrepres.nome-abrev

&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
define variable wh-pesquisa        as handle no-undo.
DEF VAR r-repres AS ROWID NO-UNDO.
DEFINE VARIABLE v-ini-dt-movto AS DATE NO-UNDO INIT 01/01/0001.
DEFINE VARIABLE v-fim-dt-movto AS DATE NO-UNDO INIT 12/31/9999.
DEFINE VARIABLE v-ini-cod-mov AS INT NO-UNDO.
DEFINE VARIABLE v-fim-cod-mov AS INT INIT 999 NO-UNDO.

{upc/btb910za-upc.i}

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
&Scoped-define INTERNAL-TABLES ttcomis-deb-cred

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttcomis-deb-cred.cod-estabel ttcomis-deb-cred.unid-neg ttcomis-deb-cred.cod-mov fn-mov-comis-descricao() ttcomis-deb-cred.dt-movto ttcomis-deb-cred.base-final ttcomis-deb-cred.deb-cred ttcomis-deb-cred.valor ttcomis-deb-cred.ct-codigo fn-conta-desc() ttcomis-deb-cred.sc-codigo fn-sc-desc() ttcomis-deb-cred.historico   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttcomis-deb-cred NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH ttcomis-deb-cred NO-LOCK .
&Scoped-define TABLES-IN-QUERY-brSon1 ttcomis-deb-cred
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttcomis-deb-cred


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttrepres.cod-rep 
&Scoped-define ENABLED-TABLES ttrepres
&Scoped-define FIRST-ENABLED-TABLE ttrepres
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btQueryJoins ~
btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS ttrepres.cod-rep ttrepres.nome-abrev ~
ttrepres.nome 
&Scoped-define DISPLAYED-TABLES ttrepres
&Scoped-define FIRST-DISPLAYED-TABLE ttrepres


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-conta-desc wMasterDetail 
FUNCTION fn-conta-desc RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-mov-comis-descricao wMasterDetail 
FUNCTION fn-mov-comis-descricao RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-sc-desc wMasterDetail 
FUNCTION fn-sc-desc RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 126 BY 2.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 126 BY 1.5
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

DEFINE BUTTON btFaixa 
     LABEL "Faixa" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon1 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttcomis-deb-cred SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      ttcomis-deb-cred.cod-estabel COLUMN-LABEL "Estab"
      ttcomis-deb-cred.unid-neg    COLUMN-LABEL "Unid.Neg."
      ttcomis-deb-cred.cod-mov FORMAT ">>9":U
      fn-mov-comis-descricao() format "X(20)" COLUMN-LABEL "Descri‡Æo"
      ttcomis-deb-cred.dt-movto FORMAT "99/99/9999":U
      ttcomis-deb-cred.base-final FORMAT "Bas/Fin":U
      ttcomis-deb-cred.deb-cred FORMAT "Deb/Cre":U
      ttcomis-deb-cred.valor FORMAT ">>>>,>>9.99":U
      ttcomis-deb-cred.ct-codigo FORMAT "99999999":U
      fn-conta-desc() format "X(15)" COLUMN-LABEL "Ct Desc"
      ttcomis-deb-cred.sc-codigo FORMAT ">>>>>":U
      fn-sc-desc() format "X(15)" COLUMN-LABEL "Sc Desc"
      ttcomis-deb-cred.historico FORMAT "x(70)":U COLUMN-LABEL "Hist¢rico"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 121 BY 13.58
         FONT 2.


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
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrˆncia corrente"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     ttrepres.cod-rep AT ROW 3 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttrepres.nome-abrev AT ROW 3 COL 34.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14 BY .88 NO-TAB-STOP 
     ttrepres.nome AT ROW 4 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 42 BY .88 NO-TAB-STOP 
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 127 BY 19.88
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     btAddSon1 AT ROW 15 COL 1
     btCopySon1 AT ROW 15 COL 11
     btUpdateSon1 AT ROW 15 COL 21
     btDeleteSon1 AT ROW 15 COL 31
     btFaixa AT ROW 15 COL 41
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.38
         SIZE 123.43 BY 15.38
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttcomis-deb-cred T "?" NO-UNDO mgesp comis-deb-cred
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttrepres T "?" NO-UNDO mgcad repres
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
         HEIGHT             = 19.88
         WIDTH              = 127
         MAX-HEIGHT         = 19.88
         MAX-WIDTH          = 127
         VIRTUAL-HEIGHT     = 19.88
         VIRTUAL-WIDTH      = 127
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
       btAdd:HIDDEN IN FRAME fPage0           = TRUE.

ASSIGN 
       btCopy:HIDDEN IN FRAME fPage0           = TRUE.

ASSIGN 
       btDelete:HIDDEN IN FRAME fPage0           = TRUE.

ASSIGN 
       btUpdate:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR FILL-IN ttrepres.nome IN FRAME fPage0
   NO-ENABLE                                                            */
ASSIGN 
       ttrepres.nome:READ-ONLY IN FRAME fPage0        = TRUE.

/* SETTINGS FOR FILL-IN ttrepres.nome-abrev IN FRAME fPage0
   NO-ENABLE                                                            */
ASSIGN 
       ttrepres.nome-abrev:READ-ONLY IN FRAME fPage0        = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttcomis-deb-cred NO-LOCK .
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    {masterdetail/AddSon.i &ProgramSon="esp/ftp/esftp026a.r"
                           &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopySon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon1 wMasterDetail
ON CHOOSE OF btCopySon1 IN FRAME fPage1 /* Copiar */
DO:
    {masterdetail/CopySon.i &ProgramSon="esp/ftp/esftp026a.r"
                            &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btFaixa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFaixa wMasterDetail
ON CHOOSE OF btFaixa IN FRAME fPage1 /* Faixa */
DO:
    RUN piFaixa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
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

    {include/zoomvar.i &prog-zoom="adzoom/z01ad229"
                       &campo3="ttrepres.nome-abrev"
                       &campozoom3="nome-abrev"
                       &frame3="fPage0"
                       &campo2="ttrepres.nome"
                       &campozoom2="nome"
                       &frame2="fPage0"
                       &campo="ttrepres.cod-rep"
                       &campozoom="cod-rep"
                       &frame="fPage0"}
                       
    wait-for close of wh-pesquisa.
    RUN gotoKey IN {&hDBOParent} (INPUT ttrepres.cod-rep:SCREEN-VALUE IN FRAME fpage0).
    IF RETURN-VALUE = "NOK" THEN RETURN NO-APPLY.
    RUN getRowid IN {&hDBOParent} (OUTPUT r-repres).
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-repres).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    {masterdetail/UpdateSon.i &ProgramSon="esp/ftp/esftp026a.r"
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDestroyInterface wMasterDetail 
PROCEDURE AfterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Destr¢i os Servidores RPC inicializados pelos DBOs ---*/
/*    {btb/btb008za.i3}
        
    /*Alteracao para deletar da mem¢ria o WindowStyles e o btb008za.p*/
    IF VALID-HANDLE(h-servid-rpc) THEN
    DO:
       DELETE PROCEDURE h-servid-rpc.
       ASSIGN h-servid-rpc = ?. /*Garantir que a vari vel nÆo vai mais apontar para nenhum handle de outro objeto - este problema apareceu na v9.1B com Windows2000*/
    END.

    IF VALID-HANDLE(hWindowStyles) THEN
        DELETE PROCEDURE hWindowStyles.
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN
        MENU-ITEM miAdd:SENSITIVE IN MENU mbMain = NO
        MENU-ITEM miCopy:SENSITIVE IN MENU mbMain = NO
        MENU-ITEM miDelete:SENSITIVE IN MENU mbMain = NO
        MENU-ITEM miUpdate:SENSITIVE IN MENU mbMain = NO
        btFaixa:SENSITIVE IN FRAME fpage1 = YES.
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
    
    DEFINE VARIABLE i-cod-rep LIKE {&ttParent}.cod-rep NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        i-cod-rep AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Representante" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-cod-rep  .
        
        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT i-cod-rep ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Representante":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-cod-rep btGoToOK btGoToCancel 
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
       {&hDBOParent}:FILE-NAME <> "adbo/boad229na.r":U THEN DO:
        {btb/btb008za.i1 adbo/boad229na.r YES}
        {btb/btb008za.i2 adbo/boad229na.r '' {&hDBOParent}} 
    END.
    
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "esbo/boes270.r":U THEN DO:
        {btb/btb008za.i1 esbo/boes270.r YES}
        {btb/btb008za.i2 esbo/boes270.r '' {&hDBOSon1}} 
    END.
    
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
    RUN setConstraintFaixa IN {&hDBOSon1} (INPUT v-ini-dt-movto,
                                           INPUT v-fim-dt-movto,
                                           INPUT v-ini-cod-mov,
                                           INPUT v-fim-cod-mov).

    {masterdetail/OpenQueriesSon.i &Parent="Repres"
                                   &Query="Faixa"
                                   &PageNumber="1"}
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFaixa wMasterDetail 
PROCEDURE piFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR iqtd AS INT NO-UNDO.

    DEFINE IMAGE IMAGE-1
         FILENAME "image\im-fir":U
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

    DEFINE VARIABLE fi-ini-dt-movto AS DATE FORMAT "99/99/9999":U 
         LABEL "Data Movimento" 
         VIEW-AS FILL-IN 
         SIZE 11 BY .88 NO-UNDO.
    
    DEFINE VARIABLE fi-fim-dt-movto AS DATE FORMAT "99/99/9999":U 
         VIEW-AS FILL-IN 
         SIZE 11 BY .88 NO-UNDO.

    DEFINE VARIABLE fi-ini-cod-mov AS INT FORMAT ">>9":U 
        LABEL "Cod Movimento"
        VIEW-AS FILL-IN 
        SIZE 5 BY .88 NO-UNDO.

    DEFINE VARIABLE fi-fim-cod-mov AS INT FORMAT ">>9":U 
        VIEW-AS FILL-IN 
        SIZE 5 BY .88 NO-UNDO.

    DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
         LABEL "Cancel" 
         SIZE 10 BY 1
         BGCOLOR 8 .

    DEFINE BUTTON Btn_OK AUTO-GO 
         LABEL "OK" 
         SIZE 10 BY 1
         BGCOLOR 8 .
    
    DEFINE RECTANGLE RECT-14
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 64.14 BY 1.5
         BGCOLOR 7 .
    
    DEFINE RECTANGLE RECT-15
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 64.14 BY 5.25.
    
    DEFINE FRAME fData
         fi-ini-dt-movto AT ROW 1.75 COL 18 COLON-ALIGNED
         IMAGE-1 AT ROW 1.75 COL 31.5
         IMAGE-2
         fi-fim-dt-movto NO-LABEL
         fi-ini-cod-mov AT ROW 2.75 COL 18 COLON-ALIGNED
         IMAGE-3 AT ROW 2.75 COL 31.5
         IMAGE-4
         fi-fim-cod-mov NO-LABEL
         Btn_OK AT ROW 5 COL 2
         Btn_Cancel AT ROW 5 COL 12
         RECT-14 AT ROW 4.75 COL 1
         RECT-15 AT ROW 1 COL 1
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1
             TITLE "Faixa"
             DEFAULT-BUTTON Btn_OK.
    
    ON CHOOSE OF Btn_OK IN FRAME fData /* OK */
    DO:
        ASSIGN v-ini-dt-movto = INPUT FRAME fData fi-ini-dt-movto
               v-fim-dt-movto = INPUT FRAME fData fi-fim-dt-movto
               v-ini-cod-mov  = INPUT FRAME fData fi-ini-cod-mov
               v-fim-cod-mov  = INPUT FRAME fData fi-fim-cod-mov.
        
        RUN setConstraintFaixa IN {&hDBOSon1} (INPUT v-ini-dt-movto,
                                               INPUT v-fim-dt-movto,
                                               INPUT v-ini-cod-mov,
                                               INPUT v-fim-cod-mov).

        RUN openQueryStatic IN {&hDBOSon1} (INPUT "Faixa":U) NO-ERROR.

        RUN getBatchRecords IN {&hDBOSon1} (INPUT ?,
                                            INPUT ?,
                                            INPUT ?,
                                            OUTPUT iqtd,
                                            OUTPUT TABLE ttcomis-deb-cred).

        OPEN QUERY brSon1 FOR EACH ttcomis-deb-cred NO-LOCK .

    END.
    
    ASSIGN fi-ini-dt-movto = v-ini-dt-movto
           fi-fim-dt-movto = v-fim-dt-movto
           fi-ini-cod-mov  = v-ini-cod-mov
           fi-fim-cod-mov  = v-fim-cod-mov.

    DISPLAY fi-ini-dt-movto fi-fim-dt-movto fi-ini-cod-mov fi-fim-cod-mov
      WITH FRAME fData.
    ENABLE fi-ini-dt-movto fi-fim-dt-movto Btn_OK Btn_Cancel 
      fi-ini-cod-mov fi-fim-cod-mov
      WITH FRAME fData.

    WAIT-FOR GO OF FRAME fData.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateCaller wMasterDetail 
PROCEDURE updateCaller :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cod-rep AS INT NO-UNDO.
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    DEF BUFFER b-{&ttSon1} FOR {&ttSon1}.

    IF NOT CAN-FIND(FIRST b-{&ttSon1}
                    WHERE b-{&ttSon1}.cod-rep = p-cod-rep) THEN DO:
        RUN setRepres IN {&hDBOSon1} (INPUT p-cod-rep).
        RUN goToKey IN {&hDBOParent} (INPUT p-cod-rep ).
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
    END.

    RUN openQueriesSon.

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-conta-desc wMasterDetail 
FUNCTION fn-conta-desc RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    ASSIGN v_cod_conta = string(ttcomis-deb-cred.ct-codigo,"99999999").

    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

    EMPTY TEMP-TABLE tt_log_erro.

    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-ep-codigo-usuario,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_conta,     /* CONTA */
                                                   input TODAY,              /* DATA TRANSACAO */   
                                                   output       v_des_titulo_conta,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUAÜ›O DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    IF VALID-HANDLE(h_api_cta_ctbl) THEN
        DELETE OBJECT h_api_cta_ctbl.

    IF CAN-FIND(FIRST tt_log_erro) THEN
        RETURN "".

    RETURN v_des_titulo_conta.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-mov-comis-descricao wMasterDetail 
FUNCTION fn-mov-comis-descricao RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND FIRST mov-comis OF ttcomis-deb-cred NO-LOCK NO-ERROR.  
  IF AVAIL mov-comis THEN
    RETURN mov-comis.descricao.   /* Function return value. */
  ELSE
    RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-sc-desc wMasterDetail 
FUNCTION fn-sc-desc RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    ASSIGN v_cod_ccusto = STRING(ttcomis-deb-cred.sc-codigo,">>>>>").

    EMPTY TEMP-TABLE tt_log_erro.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                               input  "",                  /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,        /* CCUSTO */
                                               input TODAY,                /* DATA DE TRANSACAO */
                                               output v_des_titulo_ccusto, /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro).  /* ERROS */

    IF VALID-HANDLE(h_api_ccusto) THEN
        DELETE OBJECT h_api_ccusto.

    IF CAN-FIND(FIRST tt_log_erro) THEN
        RETURN "".

    RETURN v_des_titulo_ccusto.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

