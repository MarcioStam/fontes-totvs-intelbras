&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-unid-comerc NO-UNDO LIKE unid-comerc
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
{include/i-prgvrs.i ESCDP026 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP026
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Tab Pre‡o

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

&GLOBAL-DEFINE ttTable        tt-unid-comerc
&GLOBAL-DEFINE hDBOTable      h-boes568
&GLOBAL-DEFINE DBOTable       unid-comerc

&GLOBAL-DEFINE page0KeyFields tt-unid-comerc.cd-unid-comerc
&GLOBAL-DEFINE page0Fields    tt-unid-comerc.ds-unid-comerc

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE {&hDBOTable}   AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-ds-tabpre    AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-crm-un-tb-preco NO-UNDO
    FIELD cd-unid-negoc   LIKE crm-un-tb-preco.cd-unid-negoc
    FIELD nr-tabpre       LIKE crm-un-tb-preco.nr-tabpre
    FIELD dt-vigencia-ini LIKE crm-un-tb-preco.dt-vigencia-ini
    FIELD dt-vigencia-fim LIKE crm-un-tb-preco.dt-vigencia-fim
    FIELD linha           AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES crm-un-tb-preco

/* Definitions for BROWSE brSon                                         */
&Scoped-define FIELDS-IN-QUERY-brSon crm-un-tb-preco.nr-tabpre ~
fnDsTabPreco(crm-un-tb-preco.nr-tabpre) @ c-ds-tabpre ~
crm-un-tb-preco.dt-vigencia-ini crm-un-tb-preco.dt-vigencia-fim 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon 
&Scoped-define QUERY-STRING-brSon FOR EACH crm-un-tb-preco ~
      WHERE crm-un-tb-preco.cd-unid-negoc = INPUT FRAME fPage0 tt-unid-comerc.cd-unid-comerc NO-LOCK ~
    BY crm-un-tb-preco.dt-vigencia-ini
&Scoped-define OPEN-QUERY-brSon OPEN QUERY brSon FOR EACH crm-un-tb-preco ~
      WHERE crm-un-tb-preco.cd-unid-negoc = INPUT FRAME fPage0 tt-unid-comerc.cd-unid-comerc NO-LOCK ~
    BY crm-un-tb-preco.dt-vigencia-ini.
&Scoped-define TABLES-IN-QUERY-brSon crm-un-tb-preco
&Scoped-define FIRST-TABLE-IN-QUERY-brSon crm-un-tb-preco


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-unid-comerc.cd-unid-comerc ~
tt-unid-comerc.ds-unid-comerc 
&Scoped-define ENABLED-TABLES tt-unid-comerc
&Scoped-define FIRST-ENABLED-TABLE tt-unid-comerc
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btQueryJoins btReportsJoins btExit btHelp btImportar btLayout 
&Scoped-Define DISPLAYED-FIELDS tt-unid-comerc.cd-unid-comerc ~
tt-unid-comerc.ds-unid-comerc 
&Scoped-define DISPLAYED-TABLES tt-unid-comerc
&Scoped-define FIRST-DISPLAYED-TABLE tt-unid-comerc


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDsTabPreco wMaintenance 
FUNCTION fnDsTabPreco RETURNS CHARACTER
  ( pNr-tabpre AS CHARACTER )  FORWARD.

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

DEFINE BUTTON btImportar 
     LABEL "Importar" 
     SIZE 8 BY 1 TOOLTIP "Importar dados do Excel".

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btLayout 
     LABEL "Layout" 
     SIZE 8 BY 1 TOOLTIP "Exemplo de Layout para Importa‡Æo".

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

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 111 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 111 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddSon 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopySon 
     LABEL "Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon FOR 
      crm-un-tb-preco SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon wMaintenance _STRUCTURED
  QUERY brSon NO-LOCK DISPLAY
      crm-un-tb-preco.nr-tabpre COLUMN-LABEL "Tabela Pre‡os" FORMAT "x(08)":U
            WIDTH 16
      fnDsTabPreco(crm-un-tb-preco.nr-tabpre) @ c-ds-tabpre COLUMN-LABEL "Descri‡Æo" FORMAT "x(50)":U
            WIDTH 44.86
      crm-un-tb-preco.dt-vigencia-ini COLUMN-LABEL "Dt Vig Inicial" FORMAT "99/99/9999":U
            WIDTH 18
      crm-un-tb-preco.dt-vigencia-fim FORMAT "99/99/9999":U WIDTH 18.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 102.86 BY 9.13
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
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz altera‡äes"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma altera‡äes"
     btQueryJoins AT ROW 1.13 COL 95.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 99.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 103.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 107.57 HELP
          "Ajuda"
     btImportar AT ROW 1.25 COL 78.57 HELP
          "Importar os dados de uma Planilha Excel" WIDGET-ID 12
     btLayout AT ROW 1.25 COL 86.72 HELP
          "Exemplo de Layout para Importa‡Æo" WIDGET-ID 4
     tt-unid-comerc.cd-unid-comerc AT ROW 3.33 COL 33 COLON-ALIGNED WIDGET-ID 8
          LABEL "Unidade Comercial"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-unid-comerc.ds-unid-comerc AT ROW 3.33 COL 38.29 COLON-ALIGNED NO-LABEL WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 44.72 BY .88
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 111 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brSon AT ROW 1.17 COL 2
     btAddSon AT ROW 10.33 COL 2
     btCopySon AT ROW 10.33 COL 12.14 WIDGET-ID 2
     btUpdateSon AT ROW 10.33 COL 22.29
     btDeleteSon AT ROW 10.33 COL 32.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.38
         SIZE 105.14 BY 10.63
         FONT 1 WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-unid-comerc T "?" NO-UNDO mgesp unid-comerc
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
         TITLE              = "Unidade de Neg¢cio x Tabela de Pre‡o"
         HEIGHT             = 17
         WIDTH              = 111
         MAX-HEIGHT         = 27.54
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 27.54
         VIRTUAL-WIDTH      = 182.86
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
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-unid-comerc.cd-unid-comerc IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon 1 fPage1 */
ASSIGN 
       brSon:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon
/* Query rebuild information for BROWSE brSon
     _TblList          = "mgesp.crm-un-tb-preco"
     _Options          = "NO-LOCK"
     _OrdList          = "mgesp.crm-un-tb-preco.dt-vigencia-ini|yes"
     _Where[1]         = "mgesp.crm-un-tb-preco.cd-unid-negoc = INPUT FRAME fPage0 tt-unid-comerc.cd-unid-comerc"
     _FldNameList[1]   > mgesp.crm-un-tb-preco.nr-tabpre
"crm-un-tb-preco.nr-tabpre" "Tabela Pre‡os" ? "character" ? ? ? ? ? ? no ? no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fnDsTabPreco(crm-un-tb-preco.nr-tabpre) @ c-ds-tabpre" "Descri‡Æo" "x(50)" ? ? ? ? ? ? ? no ? no no "44.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > mgesp.crm-un-tb-preco.dt-vigencia-ini
"crm-un-tb-preco.dt-vigencia-ini" "Dt Vig Inicial" ? "date" ? ? ? ? ? ? no ? no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > mgesp.crm-un-tb-preco.dt-vigencia-fim
"crm-un-tb-preco.dt-vigencia-fim" ? ? "date" ? ? ? ? ? ? no ? no no "18.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon */
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

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance /* Unidade de Neg¢cio x Tabela de Pre‡o */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance /* Unidade de Neg¢cio x Tabela de Pre‡o */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon wMaintenance
ON MOUSE-SELECT-DBLCLICK OF brSon IN FRAME fPage1
DO:
    APPLY "CHOOSE" TO btUpdateSon IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon wMaintenance
ON CHOOSE OF btAddSon IN FRAME fPage1 /* Incluir */
DO:
    ASSIGN INPUT FRAME fPage0 tt-unid-comerc.cd-unid-comerc.

    RUN esp/cdp/escdp026a.w (INPUT "Create":U,
                             INPUT tt-unid-comerc.cd-unid-comerc,
                             INPUT ?).

    RUN repositionRecord IN THIS-PROCEDURE(INPUT tt-unid-comerc.r-rowid).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCopySon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon wMaintenance
ON CHOOSE OF btCopySon IN FRAME fPage1 /* Copiar */
DO:
    ASSIGN INPUT FRAME fPage0 tt-unid-comerc.cd-unid-comerc.

    RUN esp/cdp/escdp026a.w (INPUT "Copy":U,
                             INPUT tt-unid-comerc.cd-unid-comerc,
                             INPUT IF AVAIL crm-un-tb-preco THEN ROWID(crm-un-tb-preco) ELSE ?).

    RUN repositionRecord IN THIS-PROCEDURE(INPUT tt-unid-comerc.r-rowid).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon wMaintenance
ON CHOOSE OF btDeleteSon IN FRAME fPage1 /* Eliminar */
DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 550,
                       INPUT "":U).

    IF  RETURN-VALUE = "YES" THEN DO:
        FIND CURRENT crm-un-tb-preco EXCLUSIVE-LOCK NO-ERROR.
        IF  AVAIL  crm-un-tb-preco THEN
            DELETE crm-un-tb-preco.
    END.

    RUN repositionRecord IN THIS-PROCEDURE(INPUT tt-unid-comerc.r-rowid).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImportar wMaintenance
ON CHOOSE OF btImportar IN FRAME fPage0 /* Importar */
DO:
    DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-ok      AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-cont    AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE tt-crm-un-tb-preco.
    ASSIGN i-cont = 0.


    /* Solicita arquivo que ser  importado */
    SYSTEM-DIALOG GET-FILE c-arquivo
            TITLE      "Importar Dados"
            FILTERS    "Arquivos de texto (*.csv)" "*.csv"
            INITIAL-DIR SESSION:TEMP-DIRECTORY
            MUST-EXIST
            USE-FILENAME
            UPDATE l-ok.

    IF  NOT l-ok THEN
        RETURN "NOK":U.


    IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Importando Dados").

    /* Importa as Notas de um arquivo */
    INPUT FROM VALUE(c-arquivo) NO-ECHO.
    REPEAT:
        ASSIGN i-cont = i-cont + 1.

        RUN pi-acompanhar IN h-acomp (INPUT "Importando linha " + STRING(i-cont)).

        CREATE tt-crm-un-tb-preco.
        ASSIGN tt-crm-un-tb-preco.linha = i-cont.
        IMPORT DELIMITER ";" tt-crm-un-tb-preco.
    END.
    INPUT CLOSE.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.


    /* Efetiva‡Æo dos dados */
    /* NÆo busca o £ltimo registro criado, com as informa‡äes em branco! */
    FOR EACH  tt-crm-un-tb-preco EXCLUSIVE-LOCK
        WHERE tt-crm-un-tb-preco.linha < i-cont
        BY    tt-crm-un-tb-preco.linha:

        IF  tt-crm-un-tb-preco.cd-unid-negoc = "0" OR
            tt-crm-un-tb-preco.cd-unid-negoc = ""  THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Unidade Comercial nÆo informada."
                   rowErrors.ErrorHelp        = "C¢digo da Unidade Comercial deve ser informada! Linha: " + STRING(tt-crm-un-tb-preco.linha).
            NEXT.
        END.
        ELSE DO:
            IF  NOT CAN-FIND(FIRST unid-comerc NO-LOCK
                             WHERE unid-comerc.cd-unid-comerc = INT(tt-crm-un-tb-preco.cd-unid-negoc)) THEN DO:
                CREATE rowErrors.
                ASSIGN rowErrors.ErrorNumber      = 17006
                       rowErrors.ErrorType        = "EMS":U
                       rowErrors.ErrorSubType     = "Error"
                       rowErrors.ErrorDescription = "Unidade Comercial inv lida (" + tt-crm-un-tb-preco.cd-unid-negoc + ")!"
                       rowErrors.ErrorHelp        = "Unidade Comercial informada nÆo est  cadastrada! Linha: " + STRING(tt-crm-un-tb-preco.linha).
                NEXT.
            END.
        END.

        IF  tt-crm-un-tb-preco.nr-tabpre = "" THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Tabela de Pre‡o nÆo informada."
                   rowErrors.ErrorHelp        = "Tabela de Pre‡o deve ser informada! Linha: " + STRING(tt-crm-un-tb-preco.linha).
            NEXT.
        END.
        ELSE DO:
            IF  NOT CAN-FIND(FIRST tb-preco NO-LOCK
                             WHERE tb-preco.nr-tabpre = tt-crm-un-tb-preco.nr-tabpre) THEN DO:
                CREATE rowErrors.
                ASSIGN rowErrors.ErrorNumber      = 17006
                       rowErrors.ErrorType        = "EMS":U
                       rowErrors.ErrorSubType     = "Error"
                       rowErrors.ErrorDescription = "Tabela de Pre‡o inv lida (" + tt-crm-un-tb-preco.nr-tabpre + ")!"
                       rowErrors.ErrorHelp        = "Tabela de Pre‡o informada nÆo est  cadastrada! Linha: " + STRING(tt-crm-un-tb-preco.linha).
                NEXT.
            END.
        END.

        IF  tt-crm-un-tb-preco.dt-vigencia-ini = ? THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Vigˆncia Inicial nÆo informada!"
                   rowErrors.ErrorHelp        = "Vigˆncia Inicial deve ser informada! Linha: " + STRING(tt-crm-un-tb-preco.linha).
            NEXT.
        END.

        IF  CAN-FIND(FIRST crm-un-tb-preco NO-LOCK
                     WHERE crm-un-tb-preco.cd-unid-negoc = tt-crm-un-tb-preco.cd-unid-negoc
                     AND   crm-un-tb-preco.nr-tabpre     = tt-crm-un-tb-preco.nr-tabpre) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Relacionamento j  cadastrado!"
                   rowErrors.ErrorHelp        = "Relacionamento entre Unidade Comercial e Tabela de Pre‡o j  est  cadastrado! Linha: " + STRING(tt-crm-un-tb-preco.linha).
            NEXT.
        END.

        CREATE crm-un-tb-preco.
        BUFFER-COPY tt-crm-un-tb-preco TO crm-un-tb-preco.
    END.

    IF  CAN-FIND(FIRST rowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        {method/showmessage.i3}
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Importa‡Æo conclu¡da!":U).
    END.

    RUN displayFields IN THIS-PROCEDURE.

    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLayout wMaintenance
ON CHOOSE OF btLayout IN FRAME fPage0 /* Layout */
DO:
    DEFINE BUTTON btLayoutFechar AUTO-END-KEY 
         LABEL "&Fechar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE c-editor AS CHARACTER   NO-UNDO.

    ASSIGN c-editor = FILL("-",124)                         + CHR(13) +
                      FILL(" ",46) + "Layout de Importa‡Æo" + CHR(13) +
                      FILL("-",124)                         + CHR(13) + CHR(13) +
                      "O arquivo com os dados do relacionamento Unidade Comercial x Tabela de Pre‡o deve seguir o padrÆo abaixo:" + CHR(13) +
                      "C¢digo Unidade Comercial;Nr Tab Pre‡o;Vigˆncia Inicial;Vigˆncia Final;" + CHR(13) + CHR(13) +
                      "1;00101;01/01/2011;28/02/2011;" + CHR(13) +
                      "1;AST01;01/01/2011;31/12/2011;" + CHR(13) +
                      "5;ATM;05/02/2011;28/02/2011;"   + CHR(13).
    
    DEFINE FRAME fLayout
        c-editor        AT ROW 1.21 COL 1 COLON-ALIGNED VIEW-AS EDITOR SIZE 54 BY 6.5 NO-LABEL
        btLayoutFechar  AT ROW 8.03 COL 2
        rtGoToButton    AT ROW 7.78 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Layout de Importa‡Æo" FONT 1
              DEFAULT-BUTTON btLayoutFechar.

    DISPLAY c-editor
        WITH FRAME fLayout.

    ENABLE btLayoutFechar
        WITH FRAME fLayout. 
    
    WAIT-FOR "GO":U OF FRAME fLayout.

    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fPage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="eszoom/z01es568.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fPage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon wMaintenance
ON CHOOSE OF btUpdateSon IN FRAME fPage1 /* Alterar */
DO:
    ASSIGN INPUT FRAME fPage0 tt-unid-comerc.cd-unid-comerc.

    RUN esp/cdp/escdp026a.w (INPUT "Update":U,
                             INPUT tt-unid-comerc.cd-unid-comerc,
                             INPUT IF AVAIL crm-un-tb-preco THEN ROWID(crm-un-tb-preco) ELSE ?).

    RUN repositionRecord IN THIS-PROCEDURE(INPUT tt-unid-comerc.r-rowid).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  VALID-HANDLE({&hDBOTable}) THEN
        RUN destroy IN {&hDBOTable}.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN INPUT FRAME fPage0 tt-unid-comerc.cd-unid-comerc.

    {&OPEN-QUERY-brSon}

    IF  CAN-FIND(FIRST crm-un-tb-preco NO-LOCK
                 WHERE crm-un-tb-preco.cd-unid-negoc = STRING(tt-unid-comerc.cd-unid-comerc)) THEN DO:
        ENABLE btCopySon
               btUpdateSon
               btDeleteSon
            WITH FRAME fPage1.
    END.
    ELSE DO:
        DISABLE btCopySon
                btUpdateSon
                btDeleteSon
            WITH FRAME fPage1.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ENABLE btGoTo
           btSearch
           btImportar
           btLayout
        WITH FRAME fPage0.

    ENABLE brSon
           btAddSon
        WITH FRAME fPage1.

    APPLY "CHOOSE" TO btFirst IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
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
    
    DEFINE VARIABLE i-cd-unid-comerc LIKE {&ttTable}.cd-unid-comerc NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        i-cd-unid-comerc  AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 5 BY 0.88
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Unidade Comercial" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Unidade_Neg¢cio"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-cd-unid-comerc.
        
        RUN goToKey IN {&hDBOTable} (INPUT i-cd-unid-comerc).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Unidade Comercial":U).
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-cd-unid-comerc btGoToOK btGoToCancel 
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

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo/boes568.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes568.p YES}
        {btb/btb008za.i2 esbo/boes568.p '' {&hDBOTable}}
    END.

    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDsTabPreco wMaintenance 
FUNCTION fnDsTabPreco RETURNS CHARACTER
  ( pNr-tabpre AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST tb-preco NO-LOCK
        WHERE  tb-preco.nr-tabpre = pNr-tabpre NO-ERROR.

    ASSIGN c-ds-tabpre = IF AVAIL tb-preco THEN tb-preco.descricao ELSE "".

    RETURN c-ds-tabpre.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

