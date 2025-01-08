&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttwm-inventario-etiqueta NO-UNDO LIKE wm-inventario-etiqueta
       field r-RowId as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/********************************************************************************
** Copyright SCM (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da SCM, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i ESWMP010 2.00.01.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ESWMP010 MWM}
&ENDIF

/********************************************************************************
** Copyright SCM (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da SCM, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESWMP010
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           NO
&GLOBAL-DEFINE Search         NO

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        ttwm-inventario-etiqueta
&GLOBAL-DEFINE hDBOTable      hBOwm-inventario-etiqueta
&GLOBAL-DEFINE DBOTable       wm-inventario-etiqueta

&GLOBAL-DEFINE page0KeyFields 
&GLOBAL-DEFINE page0Fields    ttwm-inventario-etiqueta.cod-estabel ttwm-inventario-etiqueta.cod-local fi-nom-estabel fi-nom-local ~
                              ttwm-inventario-etiqueta.dt-inventario ttwm-inventario-etiqueta.num-seq-invent ttwm-inventario-etiqueta.id-etiqueta

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}        AS HANDLE                                             NO-UNDO.
DEFINE VARIABLE hDBOSon1            AS HANDLE                                             NO-UNDO.

DEFINE VARIABLE h-bosc030           AS HANDLE                                             NO-UNDO.
DEFINE VARIABLE h-bosc058           AS HANDLE                                             NO-UNDO.

DEFINE VARIABLE c-cod-estabel       LIKE wm-inventario-endereco.cod-estabel    INITIAL ""    NO-UNDO.
DEFINE VARIABLE c-cod-local         LIKE wm-inventario-endereco.cod-local      INITIAL ""    NO-UNDO.
DEFINE VARIABLE d-dt-invent         LIKE wm-inventario-endereco.dt-invent      INITIAL TODAY NO-UNDO.
DEFINE VARIABLE i-num-seq           LIKE wm-inventario-endereco.num-seq-invent INITIAL 0     NO-UNDO.
DEFINE VARIABLE l-nao-iniciado      AS   LOGICAL                INITIAL YES    NO-UNDO.
DEFINE VARIABLE l-em-processo       AS   LOGICAL                INITIAL YES    NO-UNDO.
DEFINE VARIABLE l-concluido         AS   LOGICAL                INITIAL YES    NO-UNDO.
DEFINE VARIABLE l-atualizado        AS   LOGICAL                INITIAL YES    NO-UNDO.
DEFINE VARIABLE l-primeira          AS   LOGICAL                INITIAL YES    NO-UNDO.
DEFINE VARIABLE l-segunda           AS   LOGICAL                INITIAL YES    NO-UNDO.
DEFINE VARIABLE l-terceira          AS   LOGICAL                INITIAL YES    NO-UNDO.

DEF BUFFER bfwm-inventario          FOR wm-inventario-etiqueta.
DEF BUFFER bfwm-box                 FOR wm-box.

/***************************************************************************
** Include que define a variavel global gr-wm-box (rowid). Esta variavel  **
** sera utilizada no programa wmp/wm0402c.w para posicionar no registro   **
** selecionado no browse. Programa wm0402c e chamado pelo botao Etiquetas **
***************************************************************************/
{include/i-vrtab.i wm-inventario-etiqueta}
{cdp/cdcfgmat.i}

DEFINE TEMP-TABLE ttwm-inventario
       FIELD id-etiqueta    LIKE wm-inventario-etiqueta.id-etiqueta         
       FIELD id-box         LIKE wm-inventario-etiqueta.id-box
       FIELD cod-item       LIKE wm-inventario-item.cod-item
       FIELD endereco       AS CHAR FORMAT "x(20)" COLUMN-LABEL "Endere‡o"
       FIELD usuario        LIKE wm-inventario-endereco.usuario[1]
       FIELD num-seq-invent LIKE wm-inventario-etiqueta.num-seq-invent 
       FIELD num-seq-item   LIKE wm-inventario-etiqueta.num-seq-item 
       FIELD qtd-apurada    LIKE wm-inventario-etiqueta.qtd-apurada
       FIELD dt-leitura     LIKE wm-inventario-endereco.dt-leitura[1]
       FIELD dt-inventario  LIKE wm-inventario-etiqueta.dt-inventario.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brEtiqueta

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttwm-inventario

/* Definitions for BROWSE brEtiqueta                                    */
&Scoped-define FIELDS-IN-QUERY-brEtiqueta ttWm-inventario.id-etiqueta ttWm-inventario.id-box ttWm-inventario.cod-item ttWm-inventario.endereco ttWm-inventario.qtd-apurada[1] ttWm-inventario.qtd-apurada[2] ttWm-inventario.qtd-apurada[3] ttWm-inventario.usuario ttWm-inventario.num-seq-item ttWm-inventario.dt-leitura   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brEtiqueta   
&Scoped-define SELF-NAME brEtiqueta
&Scoped-define QUERY-STRING-brEtiqueta FOR EACH ttwm-inventario NO-LOCK
&Scoped-define OPEN-QUERY-brEtiqueta OPEN QUERY {&SELF-NAME} FOR EACH ttwm-inventario NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brEtiqueta ttwm-inventario
&Scoped-define FIRST-TABLE-IN-QUERY-brEtiqueta ttwm-inventario


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brEtiqueta}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttwm-inventario-etiqueta.cod-estabel ~
ttwm-inventario-etiqueta.cod-local ttwm-inventario-etiqueta.dt-inventario ~
ttwm-inventario-etiqueta.num-seq-invent ~
ttwm-inventario-etiqueta.id-etiqueta 
&Scoped-define ENABLED-TABLES ttwm-inventario-etiqueta
&Scoped-define FIRST-ENABLED-TABLE ttwm-inventario-etiqueta
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btQueryJoins btReportsJoins btExit btHelp fi-nom-estabel ~
fi-nom-local btConfirma brEtiqueta 
&Scoped-Define DISPLAYED-FIELDS ttwm-inventario-etiqueta.cod-estabel ~
ttwm-inventario-etiqueta.cod-local ttwm-inventario-etiqueta.dt-inventario ~
ttwm-inventario-etiqueta.num-seq-invent ~
ttwm-inventario-etiqueta.id-etiqueta 
&Scoped-define DISPLAYED-TABLES ttwm-inventario-etiqueta
&Scoped-define FIRST-DISPLAYED-TABLE ttwm-inventario-etiqueta
&Scoped-Define DISPLAYED-OBJECTS fi-nom-estabel fi-nom-local 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEnderecoBox wMaintenance 
FUNCTION fnEnderecoBox RETURNS CHARACTER
  ( INPUT pCodEstabel AS CHAR,
    INPUT pCodLocal AS CHAR,
    INPUT pIdBox   AS DEC )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnGetIndStatus wMaintenance 
FUNCTION fnGetIndStatus RETURNS CHARACTER
  ( INPUT pIndStatus AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnGetIndStatusSaldo wMaintenance 
FUNCTION fnGetIndStatusSaldo RETURNS CHARACTER
  ( INPUT pIndSituacao AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnGetQuantidadeBloq wMaintenance 
FUNCTION fnGetQuantidadeBloq RETURNS DECIMAL
  ( INPUT p-qtd-item-bloq AS DECIMAL,
    INPUT p-qtd-item-alocad AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnGetStatusArm wMaintenance 
FUNCTION fnGetStatusArm RETURNS LOGICAL
  ( INPUT pCodEstabel AS CHAR,
    INPUT pCodLocal   AS CHAR,
    INPUT pIdBox      AS DEC )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnGetStatusRet wMaintenance 
FUNCTION fnGetStatusRet RETURNS LOGICAL
  ( INPUT pCodEstabel AS CHAR,
    INPUT pCodLocal   AS CHAR,
    INPUT pIdBox      AS DEC )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr½ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&‚ltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&Vÿ Para"       ACCELERATOR "CTRL-T"
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
       MENU-ITEM miReportsJoins LABEL "&Relat½rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conteœdo"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btConfirma 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.

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

DEFINE VARIABLE fi-nom-estabel AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 67 BY .88.

DEFINE VARIABLE fi-nom-local AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 69.29 BY .88.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.86 BY 3.38.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brEtiqueta FOR 
      ttwm-inventario SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brEtiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brEtiqueta wMaintenance _FREEFORM
  QUERY brEtiqueta DISPLAY
      ttWm-inventario.id-etiqueta  WIDTH 14
    ttWm-inventario.id-box  
    ttWm-inventario.cod-item
    ttWm-inventario.endereco       WIDTH 12 
    ttWm-inventario.qtd-apurada[1] COLUMN-LABEL "Qtd Apurada 1"
    ttWm-inventario.qtd-apurada[2] COLUMN-LABEL "Qtd Apurada 2"
    ttWm-inventario.qtd-apurada[3] COLUMN-LABEL "Qtd Apurada 3"
    ttWm-inventario.usuario       
    ttWm-inventario.num-seq-item   
    ttWm-inventario.dt-leitura
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 90 BY 10.67
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorr¼ncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorr¼ncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr½xima ocorr¼ncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "‚ltima ocorr¼ncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "Vÿ Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat½rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttwm-inventario-etiqueta.cod-estabel AT ROW 2.83 COL 12.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-nom-estabel AT ROW 2.83 COL 20.86 COLON-ALIGNED HELP
          "Nome do estabelecimento." NO-LABEL
     ttwm-inventario-etiqueta.cod-local AT ROW 3.83 COL 12.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-nom-local AT ROW 3.83 COL 18.72 COLON-ALIGNED HELP
          "Nome do local." NO-LABEL
     ttwm-inventario-etiqueta.dt-inventario AT ROW 4.83 COL 12.29 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     ttwm-inventario-etiqueta.num-seq-invent AT ROW 4.83 COL 35.14 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttwm-inventario-etiqueta.id-etiqueta AT ROW 4.83 COL 55 COLON-ALIGNED WIDGET-ID 2
          LABEL "Id Etiqueta":R11
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     btConfirma AT ROW 4.83 COL 72.43 HELP
          "Vÿ Para" WIDGET-ID 4
     brEtiqueta AT ROW 6.21 COL 1
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttwm-inventario-etiqueta T "?" NO-UNDO mgcad wm-inventario-etiqueta
      ADDITIONAL-FIELDS:
          field r-RowId as rowid
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
         HEIGHT             = 16.08
         WIDTH              = 90
         MAX-HEIGHT         = 27.71
         MAX-WIDTH          = 194.86
         VIRTUAL-HEIGHT     = 27.71
         VIRTUAL-WIDTH      = 194.86
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
/* BROWSE-TAB brEtiqueta btConfirma fpage0 */
/* SETTINGS FOR BUTTON btGoTo IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btGoTo:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR BUTTON btSearch IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btSearch:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN ttwm-inventario-etiqueta.id-etiqueta IN FRAME fpage0
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brEtiqueta
/* Query rebuild information for BROWSE brEtiqueta
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttwm-inventario NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brEtiqueta */
&ANALYZE-RESUME

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


&Scoped-define SELF-NAME btConfirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfirma wMaintenance
ON CHOOSE OF btConfirma IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN piCarregaDados (INPUT ttwm-inventario-etiqueta.cod-estabel   :SCREEN-VALUE IN FRAME fPage0,
                        INPUT ttwm-inventario-etiqueta.cod-local     :SCREEN-VALUE IN FRAME fPage0,
                        INPUT ttwm-inventario-etiqueta.dt-inventario :SCREEN-VALUE IN FRAME fPage0,
                        INPUT ttwm-inventario-etiqueta.num-seq-invent:SCREEN-VALUE IN FRAME fPage0,
                        INPUT ttwm-inventario-etiqueta.id-etiqueta   :SCREEN-VALUE IN FRAME fPage0).
    {&OPEN-QUERY-{&BROWSE-NAME}}
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


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    /*--- Executa programa de pesquisa ---*/
    RUN sczoom/z01sc118.w PERSISTENT SET hProgramZoom.
    
    IF VALID-HANDLE(hProgramZoom) THEN DO:
        /*--- Seta, no programa de pesquisa, os campos que devem ser retornados
              Neste caso serÿ retornado o ROWID do registro selecionado ---*/
        RUN setFieldNamesHandles IN hProgramZoom (INPUT "ROWID":U, INPUT STRING(THIS-PROCEDURE)).

        RUN pi-inventario IN hProgramZoom (INPUT c-cod-estabel,
                                           INPUT c-cod-local,
                                           INPUT DATE(ttwm-inventario-etiqueta.dt-inventario:SCREEN-VALUE IN FRAME fPage0),
                                           INPUT INT(ttwm-inventario-etiqueta.num-seq-invent:SCREEN-VALUE IN FRAME fPage0),
                                           INPUT l-nao-iniciado,
                                           INPUT l-em-processo,
                                           INPUT l-concluido,
                                           INPUT l-atualizado,
                                           INPUT l-primeira,
                                           INPUT l-segunda,
                                           INPUT l-terceira).
            
        /*--- Inicializa programa de pesquisa ---*/
        RUN initializeInterface IN hProgramZoom.
    END.
  /*  {method/zoomreposition.i &ProgramZoom="sczoom/z01sc118.w"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brEtiqueta
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*--- Logica para inicializacao do programam ---*/
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
    IF VALID-HANDLE(hDBOSon1) THEN DO:
        DELETE PROCEDURE hDBOSon1 NO-ERROR.
        ASSIGN hDBOSon1 = ?.
    END.

    IF VALID-HANDLE(h-bosc030) THEN DO:
        DELETE PROCEDURE h-bosc030 NO-ERROR.
        ASSIGN h-bosc030 = ?.
    END.

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
    DEFINE VARIABLE h-proxy124         AS HANDLE   NO-UNDO.
    DEFINE VARIABLE l-aloca-wms        AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE l-saldo-disp       AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE l-existe           AS LOGICAL  NO-UNDO.

    ENABLE ttwm-inventario-etiqueta.cod-estabel
           ttwm-inventario-etiqueta.cod-local
           ttwm-inventario-etiqueta.id-etiqueta
           ttwm-inventario-etiqueta.dt-inventario 
           ttwm-inventario-etiqueta.num-seq-invent
           btConfirma
           brEtiqueta
           WITH FRAME fPage0.
           
    ASSIGN  c-cod-estabel = {&ttTable}.cod-estabel:screen-value IN FRAME fpage0
            c-cod-local   = {&ttTable}.cod-local:screen-value   IN FRAME fpage0.

    RUN getNomEstabel IN h-bosc058 (INPUT  c-cod-estabel,
                                    OUTPUT fi-nom-estabel).
    IF  RETURN-VALUE = "OK":U THEN
        DISPLAY fi-nom-estabel WITH FRAME fPage0.
    ELSE
        ASSIGN fi-nom-estabel:screen-value IN FRAME fpage0 = "":U.

    RUN getNomLocal IN h-bosc058 (INPUT  c-cod-local,
                                  OUTPUT fi-nom-local).
    IF  RETURN-VALUE = "OK":U THEN
        DISPLAY fi-nom-local WITH FRAME fPage0.
    ELSE
        ASSIGN fi-nom-local:screen-value IN FRAME fpage0 = "":U.

    RUN piCarregaDados (INPUT ttwm-inventario-etiqueta.cod-estabel   :SCREEN-VALUE IN FRAME fPage0,
                        INPUT ttwm-inventario-etiqueta.cod-local     :SCREEN-VALUE IN FRAME fPage0,
                        INPUT ttwm-inventario-etiqueta.dt-inventario :SCREEN-VALUE IN FRAME fPage0,
                        INPUT ttwm-inventario-etiqueta.num-seq-invent:SCREEN-VALUE IN FRAME fPage0,
                        INPUT ttwm-inventario-etiqueta.id-etiqueta   :SCREEN-VALUE IN FRAME fPage0).
    {&OPEN-QUERY-{&BROWSE-NAME}}

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

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenance 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
  Purpose:     Exibe dialog de Va Para
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
    
    DEFINE VARIABLE cCodEstabel   LIKE {&ttTable}.cod-estabel    VIEW-AS FILL-IN SIZE  8    BY 0.88 NO-UNDO.
    DEFINE VARIABLE cCodLocal     LIKE {&ttTable}.cod-local      VIEW-AS FILL-IN SIZE  6    BY 0.88 NO-UNDO.    
    DEFINE VARIABLE dDtInventario LIKE {&ttTable}.dt-inventario  VIEW-AS FILL-IN SIZE  11   BY 0.88 NO-UNDO.    
    DEFINE VARIABLE iNumSeqInvent LIKE {&ttTable}.num-seq-invent VIEW-AS FILL-IN SIZE  8    BY 0.88 NO-UNDO.    
    DEFINE VARIABLE cIdEtiqueta   LIKE {&ttTable}.id-etiqueta    VIEW-AS FILL-IN SIZE  18   BY 0.88 NO-UNDO.    
    
    DEFINE FRAME fGoToRecord
        cCodEstabel       AT ROW 1.21 COL 17.72 COLON-ALIGNED
        cCodLocal         AT ROW 2.21 COL 17.72 COLON-ALIGNED
        dDtInventario     AT ROW 3.21 COL 17.72 COLON-ALIGNED
        iNumSeqInvent     AT ROW 4.21 COL 17.72 COLON-ALIGNED
        cIdEtiqueta       AT ROW 5.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 6.63 COL 2.14
        btGoToCancel      AT ROW 6.63 COL 13
        rtGoToButton      AT ROW 6.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Invent rio Etiqueta" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Invent rio_Etiqueta"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE
           cCodEstabel   = INPUT FRAME fPage0 ttwm-inventario-etiqueta.cod-estabel   
           cCodLocal     = INPUT FRAME fPage0 ttwm-inventario-etiqueta.cod-local     
           dDtInventario = INPUT FRAME fPage0 ttwm-inventario-etiqueta.dt-inventario 
           iNumSeqInvent = INPUT FRAME fPage0 ttwm-inventario-etiqueta.num-seq-invent.

    DISP cCodEstabel    
         cCodLocal     
         dDtInventario 
         iNumSeqInvent WITH FRAME fGoToRecord.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cCodEstabel cCodLocal dDtInventario iNumSeqInvent cIdEtiqueta.
        
        FOR FIRST wm-inventario-etiqueta 
            WHERE wm-inventario-etiqueta.cod-estabel    = cCodEstabel   AND
                  wm-inventario-etiqueta.cod-local      = cCodLocal     AND
                  wm-inventario-etiqueta.dt-inventario  = dDtInventario AND
                  wm-inventario-etiqueta.num-seq-invent = iNumSeqInvent AND 
                  wm-inventario-etiqueta.id-etiqueta    = cIdEtiqueta   NO-LOCK.
        END.
        ASSIGN rGoTo = IF AVAIL wm-inventario-etiqueta THEN ROWID(wm-inventario-etiqueta) ELSE ?. 

        IF NOT AVAIL wm-inventario-etiqueta THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Invent rio_Etiqueta" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).            
            RETURN NO-APPLY.
        END.
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    ENABLE cCodEstabel cCodLocal dDtInventario iNumSeqInvent cIdEtiqueta btGoToOK btGoToCancel 
           WITH FRAME fGoToRecord. 

    WAIT-FOR "GO":U OF FRAME fGoToRecord.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/    
    /*--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
        {btb/btb008za.i1 scbo/bosc120.p YES}
        {btb/btb008za.i2 scbo/bosc120.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic   IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-bosc030) THEN DO:
        {btb/btb008za.i1 scbo/bosc030.p YES}
        {btb/btb008za.i2 scbo/bosc030.p '' h-bosc030}
    END.
    RUN openQueryStatic IN h-bosc030 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-bosc058) THEN DO:
        {btb/btb008za.i1 scbo/bosc058.p YES}
        {btb/btb008za.i2 scbo/bosc058.p '' h-bosc058}
    END.
    RUN openQueryStatic IN h-bosc058 (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaDados wMaintenance 
PROCEDURE piCarregaDados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodEstabel   LIKE wm-inventario-etiqueta.cod-estabel    NO-UNDO.   
DEFINE INPUT PARAMETER pCodLocal     LIKE wm-inventario-etiqueta.cod-local      NO-UNDO.     
DEFINE INPUT PARAMETER pDtInventario LIKE wm-inventario-etiqueta.dt-inventario  NO-UNDO. 
DEFINE INPUT PARAMETER pNumSeqInvent LIKE wm-inventario-etiqueta.num-seq-invent NO-UNDO.
DEFINE INPUT PARAMETER pIdEtiqueta   LIKE wm-inventario-etiqueta.id-etiqueta    NO-UNDO.

DEFINE VARIABLE cEnd AS CHARACTER FORMAT "x(20)" NO-UNDO.

DEFINE BUFFER bfwm-inventario FOR wm-inventario-etiqueta.
    
FOR EACH ttwm-inventario. DELETE ttwm-inventario. END.

FOR FIRST wm-inventario 
    WHERE wm-inventario.cod-estabel    = pCodEstabel   AND
          wm-inventario.cod-local      = pCodLocal     AND
          wm-inventario.dt-inventario  = pDtInventario AND
          wm-inventario.num-seq-invent = pNumSeqInvent NO-LOCK.
END.                                       
IF NOT AVAIL wm-inventario THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Invent rio Etiqueta").            
    RETURN NO-APPLY.
END.

FOR EACH wm-inventario-etiqueta 
   WHERE wm-inventario-etiqueta.id-etiqueta = pIdEtiqueta NO-LOCK.

    FIND FIRST wm-box
         WHERE wm-box.id-box = wm-inventario-etiqueta.id-box NO-LOCK NO-ERROR.

    FIND FIRST wm-inventario-endereco OF wm-inventario NO-LOCK NO-ERROR.

    ASSIGN cEnd = wm-box.cod-bloco  + "/" +
                  wm-box.cod-rua    + "/" +
                  wm-box.cod-nivel  + "/" +
                  wm-box.cod-coluna.

    FOR EACH  bfwm-inventario
        WHERE bfwm-inventario.id-box            = wm-inventario-etiqueta.id-box,
        FIRST wm-inventario-item NO-LOCK
        WHERE wm-inventario-item.cod-estabel    = bfwm-inventario.cod-estabel   
          AND wm-inventario-item.cod-local      = bfwm-inventario.cod-local     
          AND wm-inventario-item.dt-inventario  = bfwm-inventario.dt-inventario 
          AND wm-inventario-item.num-seq-invent = bfwm-inventario.num-seq-invent
          AND wm-inventario-item.id-box         = bfwm-inventario.id-box        
          AND wm-inventario-item.num-seq-item   = bfwm-inventario.num-seq-item:

        CREATE ttwm-inventario.
        ASSIGN ttWm-inventario.id-etiqueta    = bfwm-inventario.id-etiqueta         
               ttWm-inventario.id-box         = bfwm-inventario.id-box
               ttWm-inventario.cod-item       = wm-inventario-item.cod-item
               ttWm-inventario.endereco       = cEnd 
               ttWm-inventario.usuario        = wm-inventario-endereco.usuario[1]
               ttWm-inventario.num-seq-invent = bfwm-inventario.num-seq-invent 
               ttWm-inventario.num-seq-item   = bfwm-inventario.num-seq-item 
               ttWm-inventario.qtd-apurada    = bfwm-inventario.qtd-apurada
               ttWm-inventario.dt-leitura     = wm-inventario-endereco.dt-leitura[1]
               ttWm-inventario.dt-inventario  = bfwm-inventario.dt-inventario.
    END.    
END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEnderecoBox wMaintenance 
FUNCTION fnEnderecoBox RETURNS CHARACTER
  ( INPUT pCodEstabel AS CHAR,
    INPUT pCodLocal AS CHAR,
    INPUT pIdBox   AS DEC ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR c-cod-endereco AS CHAR NO-UNDO.
    

    RUN retornaEnderecoBox4 IN h-bosc030 (INPUT pCodEstabel,
                                         INPUT pCodLocal ,
                                         INPUT pIdBox,
                                         OUTPUT c-cod-endereco).

    RETURN c-cod-endereco.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnGetIndStatus wMaintenance 
FUNCTION fnGetIndStatus RETURNS CHARACTER
  ( INPUT pIndStatus AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-status AS CHARACTER FORMAT "X(20)" NO-UNDO.

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.        
        ASSIGN cAuxTraducao001 = {scinc/i01sc030.i 04 pIndStatus}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN  c-status = RETURN-VALUE.
    &else
        ASSIGN c-status = {scinc/i01sc030.i 04 pIndStatus}.
    &endif
    RETURN c-status.   
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnGetIndStatusSaldo wMaintenance 
FUNCTION fnGetIndStatusSaldo RETURNS CHARACTER
  ( INPUT pIndSituacao AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-ind-status AS CHARACTER FORMAT "X(20)" NO-UNDO.

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao002 = {scinc/i01sc035.i 04 pIndSituacao}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN  c-ind-status = RETURN-VALUE.
    &else
        ASSIGN c-ind-status = {scinc/i01sc035.i 04 pIndSituacao}.
    &endif
    RETURN c-ind-status.   
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnGetQuantidadeBloq wMaintenance 
FUNCTION fnGetQuantidadeBloq RETURNS DECIMAL
  ( INPUT p-qtd-item-bloq AS DECIMAL,
    INPUT p-qtd-item-alocad AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RETURN p-qtd-item-bloq + p-qtd-item-alocad.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnGetStatusArm wMaintenance 
FUNCTION fnGetStatusArm RETURNS LOGICAL
  ( INPUT pCodEstabel AS CHAR,
    INPUT pCodLocal   AS CHAR,
    INPUT pIdBox      AS DEC ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FOR FIRST bfwm-box 
        WHERE bfwm-box.cod-estabel = pCodEstabel AND
              bfwm-box.cod-local   = pCodLocal   AND
              bfwm-box.id-box      = pIdBox      NO-LOCK.
    END.

    RETURN bfwm-box.log-bloq-armaz.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnGetStatusRet wMaintenance 
FUNCTION fnGetStatusRet RETURNS LOGICAL
  ( INPUT pCodEstabel AS CHAR,
    INPUT pCodLocal   AS CHAR,
    INPUT pIdBox      AS DEC ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FOR FIRST bfwm-box 
        WHERE bfwm-box.cod-estabel = pCodEstabel AND
              bfwm-box.cod-local   = pCodLocal   AND
              bfwm-box.id-box      = pIdBox      NO-LOCK.
    END.

    RETURN bfwm-box.log-bloq-retir.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

