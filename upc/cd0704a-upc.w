&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttint-emitente NO-UNDO LIKE int-emitente
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
{include/i-prgvrs.i cd0704a-upc 2.04.00.000}

DEFINE INPUT PARAMETER p-cod-emitente AS INTEGER NO-UNDO.

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        cd0704a-upc
&GLOBAL-DEFINE Version        2.04.00.000

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Ext. Emitente,Relacionamento

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            no
&GLOBAL-DEFINE Copy           no
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         no
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        ttint-emitente
&GLOBAL-DEFINE hDBOTable      h-boes332
&GLOBAL-DEFINE DBOTable       int-emitente

&GLOBAL-DEFINE page0KeyFields ttint-emitente.cod-emitente
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    ttint-emitente.vl-desconto-cat ttint-emitente.observacao-ped ttint-emitente.tipo-embalagem ttint-emitente.log-salesforce~
                              ttint-emitente.dispositivo-legal ttint-emitente.dt-vcto-concessao c-embarque-via c-incoterm c-local-embarque
&GLOBAL-DEFINE page2Fields    


&GLOBAL-DEFINE btAlterar      YES
 
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-nome-rep     AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c-desc-un      AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c-gr-cli       AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c-ds-categoria AS CHARACTER FORMAT "x(30)" NO-UNDO.
DEFINE VARIABLE i-cd-categoria AS INTEGER                  NO-UNDO.
DEFINE VARIABLE r-filho        AS ROWID                    NO-UNDO.


/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME br-table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES crm-relacionamento-cliente

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table crm-relacionamento-cliente.cod-rep ~
fn-nome-rep(crm-relacionamento-cliente.cod-rep) @ c-nome-rep ~
crm-relacionamento-cliente.cd-unid-negoc ~
fn-desc-un(crm-relacionamento-cliente.cd-unid-negoc) @ c-desc-un ~
crm-relacionamento-cliente.cd-categoria ~
fn-desc-categoria(crm-relacionamento-cliente.cd-categoria) @ c-ds-categoria ~
crm-relacionamento-cliente.dt-vigencia-ini ~
crm-relacionamento-cliente.dt-vigencia-fim 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table 
&Scoped-define QUERY-STRING-br-table FOR EACH crm-relacionamento-cliente ~
      WHERE crm-relacionamento-cliente.cod-emitente = ttint-emitente.cod-emitente NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-table OPEN QUERY br-table FOR EACH crm-relacionamento-cliente ~
      WHERE crm-relacionamento-cliente.cod-emitente = ttint-emitente.cod-emitente NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-table crm-relacionamento-cliente
&Scoped-define FIRST-TABLE-IN-QUERY-br-table crm-relacionamento-cliente


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-br-table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttint-emitente.cod-emitente 
&Scoped-define ENABLED-TABLES ttint-emitente
&Scoped-define FIRST-ENABLED-TABLE ttint-emitente
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS ttint-emitente.cod-emitente 
&Scoped-define DISPLAYED-TABLES ttint-emitente
&Scoped-define FIRST-DISPLAYED-TABLE ttint-emitente


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-busca-categoria wMaintenance 
FUNCTION fn-busca-categoria RETURNS INTEGER
  ( pCod-unid-negoc AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-categoria wMaintenance 
FUNCTION fn-desc-categoria RETURNS CHARACTER
  ( p-categoria AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-un wMaintenance 
FUNCTION fn-desc-un RETURNS CHARACTER
  ( p-cod_unid_negoc AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-gr-cli wMaintenance 
FUNCTION fn-gr-cli RETURNS CHARACTER
  ( p-cod-gr-cli AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-nome-rep wMaintenance 
FUNCTION fn-nome-rep RETURNS CHARACTER
  ( p-cod-rep AS INTEGER )  FORWARD.

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

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE c-embarque-via AS CHARACTER FORMAT "X(256)":U 
     LABEL "Embarque Via" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-incoterm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Incoterm" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-local-embarque AS CHARACTER FORMAT "X(256)":U 
     LABEL "Local Embarque" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 3.38.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 4.25.

DEFINE BUTTON bt-alterar 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-eliminar 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-inserir 
     LABEL "&Inserir" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      crm-relacionamento-cliente SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table wMaintenance _STRUCTURED
  QUERY br-table NO-LOCK DISPLAY
      crm-relacionamento-cliente.cod-rep COLUMN-LABEL "Rep" FORMAT ">>>>9":U
            WIDTH 4.43
      fn-nome-rep(crm-relacionamento-cliente.cod-rep) @ c-nome-rep COLUMN-LABEL "Nome" FORMAT "x(12)":U
            WIDTH 16.43
      crm-relacionamento-cliente.cd-unid-negoc FORMAT "x(3)":U
            WIDTH 6.43
      fn-desc-un(crm-relacionamento-cliente.cd-unid-negoc) @ c-desc-un COLUMN-LABEL "Descri‡Æo" FORMAT "x(40)":U
            WIDTH 13
      crm-relacionamento-cliente.cd-categoria FORMAT "9":U
      fn-desc-categoria(crm-relacionamento-cliente.cd-categoria) @ c-ds-categoria COLUMN-LABEL "Descri‡Æo" FORMAT "x(30)":U
            WIDTH 11.86
      crm-relacionamento-cliente.dt-vigencia-ini COLUMN-LABEL "Dt Vig Inicial" FORMAT "99/99/9999":U
            WIDTH 10.72
      crm-relacionamento-cliente.dt-vigencia-fim COLUMN-LABEL "Dt Vig Final" FORMAT "99/99/9999":U
            WIDTH 10.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82.43 BY 12.25
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
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttint-emitente.cod-emitente AT ROW 3.42 COL 33 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.86 BY 19.88
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     br-table AT ROW 1.17 COL 1.86
     bt-inserir AT ROW 13.58 COL 2
     bt-alterar AT ROW 13.58 COL 12
     bt-eliminar AT ROW 13.58 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.35
         SIZE 84.43 BY 14
         FONT 1.

DEFINE FRAME fPage1
     ttint-emitente.vl-desconto-cat AT ROW 1.25 COL 15 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     ttint-emitente.tipo-embalagem AT ROW 1.25 COL 43 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
    ttint-emitente.log-salesforce AT ROW 1.30 COL 58 COLON-ALIGNED WIDGET-ID 8
         VIEW-AS TOGGLE-BOX
     ttint-emitente.observacao-ped AT ROW 2.5 COL 17 NO-LABEL WIDGET-ID 4
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 63 BY 3.5
     ttint-emitente.dispositivo-legal AT ROW 7 COL 24 NO-LABEL WIDGET-ID 36
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 56 BY 2.25
     ttint-emitente.dt-vcto-concessao AT ROW 9.5 COL 22 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-incoterm AT ROW 11.5 COL 27 COLON-ALIGNED WIDGET-ID 14
     c-local-embarque AT ROW 12.5 COL 27 COLON-ALIGNED WIDGET-ID 16
     c-embarque-via AT ROW 13.5 COL 27 COLON-ALIGNED WIDGET-ID 18
     "ConcessÆo RS" VIEW-AS TEXT
          SIZE 11 BY 1 AT ROW 6 COL 5 WIDGET-ID 12
     "Exporta‡Æo" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 11 COL 5 WIDGET-ID 12
     "Dispositivo Legal:" VIEW-AS TEXT
          SIZE 12 BY 1.25 AT ROW 7.25 COL 11 WIDGET-ID 38
     "Observa‡Æo Ped:" VIEW-AS TEXT
          SIZE 13 BY 1 AT ROW 3.75 COL 3 WIDGET-ID 6
     RECT-13 AT ROW 11.25 COL 3 WIDGET-ID 10
     RECT-14 AT ROW 6.5 COL 3 WIDGET-ID 30
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.35
         SIZE 84.43 BY 14
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttint-emitente T "?" NO-UNDO mgesp int-emitente
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
         HEIGHT             = 19.88
         WIDTH              = 90.86
         MAX-HEIGHT         = 19.88
         MAX-WIDTH          = 90.86
         VIRTUAL-HEIGHT     = 19.88
         VIRTUAL-WIDTH      = 90.86
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
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE
       FRAME fPage2:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
ASSIGN 
       FRAME fPage1:HIDDEN           = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB br-table 1 fPage2 */
ASSIGN 
       FRAME fPage2:HIDDEN           = TRUE.

ASSIGN 
       br-table:COLUMN-RESIZABLE IN FRAME fPage2       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _TblList          = "mgesp.crm-relacionamento-cliente"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgesp.crm-relacionamento-cliente.cod-emitente = ttint-emitente.cod-emitente"
     _FldNameList[1]   > mgesp.crm-relacionamento-cliente.cod-rep
"crm-relacionamento-cliente.cod-rep" "Rep" ? "integer" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fn-nome-rep(crm-relacionamento-cliente.cod-rep) @ c-nome-rep" "Nome" "x(12)" ? ? ? ? ? ? ? no "Nome do Representante" no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > mgesp.crm-relacionamento-cliente.cd-unid-negoc
"crm-relacionamento-cliente.cd-unid-negoc" ? ? "character" ? ? ? ? ? ? no "C¢digo da Unidade de Neg¢cio" no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fn-desc-un(crm-relacionamento-cliente.cd-unid-negoc) @ c-desc-un" "Descri‡Æo" "x(40)" ? ? ? ? ? ? ? no "Descri‡Æo da Unidade de Neg¢cio" no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = mgesp.crm-relacionamento-cliente.cd-categoria
     _FldNameList[6]   > "_<CALC>"
"fn-desc-categoria(crm-relacionamento-cliente.cd-categoria) @ c-ds-categoria" "Descri‡Æo" "x(30)" ? ? ? ? ? ? ? no "Categoria" no no "11.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > mgesp.crm-relacionamento-cliente.dt-vigencia-ini
"crm-relacionamento-cliente.dt-vigencia-ini" "Dt Vig Inicial" ? "date" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > mgesp.crm-relacionamento-cliente.dt-vigencia-fim
"crm-relacionamento-cliente.dt-vigencia-fim" "Dt Vig Final" ? "date" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
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


&Scoped-define BROWSE-NAME br-table
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table wMaintenance
ON MOUSE-SELECT-DBLCLICK OF br-table IN FRAME fPage2
DO:
    IF "{&btAlterar}":U = "YES":U THEN
        APPLY "CHOOSE":U TO bt-alterar IN FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-alterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-alterar wMaintenance
ON CHOOSE OF bt-alterar IN FRAME fPage2 /* Alterar */
DO:
    DEFINE VARIABLE c-tipo AS CHARACTER   NO-UNDO.

    IF AVAILABLE crm-relacionamento-cliente THEN DO:
        ASSIGN r-filho = ROWID(crm-relacionamento-cliente)
               c-tipo = "alterar".

        RUN upc/cd0704-upcv21.w (INPUT {&WINDOW-NAME},
                                 INPUT ttint-emitente.r-rowid,
                                 INPUT YES,
                                 INPUT-OUTPUT r-filho,
                                 c-tipo).

        IF RETURN-VALUE = "OK":U THEN DO:
            {&OPEN-QUERY-br-table}
    
            REPOSITION br-table TO ROWID r-filho NO-ERROR.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar wMaintenance
ON CHOOSE OF bt-eliminar IN FRAME fPage2 /* Eliminar */
DO:
    IF AVAILABLE crm-relacionamento-cliente THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 550,
                           INPUT "":U).

        IF RETURN-VALUE = "YES":U THEN DO:
            FIND CURRENT crm-relacionamento-cliente EXCLUSIVE-LOCK NO-ERROR.
            DELETE crm-relacionamento-cliente.
            {&OPEN-QUERY-br-table}
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-inserir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inserir wMaintenance
ON CHOOSE OF bt-inserir IN FRAME fPage2 /* Inserir */
DO:
    DEFINE VARIABLE c-tipo AS CHARACTER   NO-UNDO.

    ASSIGN r-filho = ?
           c-tipo = "novo".

    RUN upc/cd0704-upcv21.w (INPUT {&WINDOW-NAME},
                             INPUT ttint-emitente.r-rowid,
                             INPUT NO,
                             INPUT-OUTPUT r-filho,
                             c-tipo).

    IF RETURN-VALUE = "OK":U THEN DO:
        {&OPEN-QUERY-br-table}

        REPOSITION br-table TO ROWID r-filho NO-ERROR.
    END.
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


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
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
   {method/zoomreposition.i &ProgramZoom="eszoom/z01es332.w"}
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisableFields wMaintenance 
PROCEDURE afterDisableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF '{&btAlterar}' = 'YES' THEN
        ENABLE bt-alterar
            WITH FRAME fPage2.

    ENABLE br-table
           bt-inserir
           bt-eliminar
        WITH FRAME fPage2.

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
    find int-emitente-cex
         where int-emitente-cex.cod-emitente = ttint-emitente.cod-emitente no-lock no-error.
    if avail int-emitente-cex then 
       assign c-local-embarque:screen-value in frame fpage1 = int-emitente-cex.local-embarque
              c-embarque-via:screen-value in frame fpage1   = int-emitente-cex.embarque-via.
    else
       assign c-local-embarque:screen-value in frame fpage1 = ""
              c-embarque-via:screen-value in frame fpage1   = "".
    
    find emitente-cex
         where emitente-cex.cod-emitente = ttint-emitente.cod-emitente no-lock no-error.
    if avail emitente-cex then
       assign c-incoterm:screen-value in frame fpage1       = emitente-cex.cod-incoterm-exp.
    else
       assign c-incoterm:screen-value in frame fpage1       = "".

    {&OPEN-QUERY-br-table}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenance 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF '{&btAlterar}' = 'YES' THEN
        DISABLE bt-alterar
            WITH FRAME fPage2.

    DISABLE br-table
            bt-inserir
            bt-eliminar
        WITH FRAME fPage2.

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
    IF "{&btAlterar}":U = "YES":U THEN
        ENABLE bt-alterar
            WITH FRAME fPage2.
    ELSE DO:
        DISABLE bt-alterar
            WITH FRAME fPage2.

        ASSIGN bt-eliminar:COLUMN IN FRAME fPage2 = 13.57.
    END.

    ENABLE br-table
           bt-inserir
           bt-eliminar
        WITH FRAME fPage2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenance 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find int-emitente-cex
         where int-emitente-cex.cod-emitente = ttint-emitente.cod-emitente exclusive-lock no-error.
    if not avail int-emitente-cex then do:
       create int-emitente-cex.
       assign int-emitente-cex.cod-emitente = ttint-emitente.cod-emitente.
    end.
    assign int-emitente-cex.local-embarque = input frame fPage1 c-local-embarque
           int-emitente-cex.embarque-via   = input frame fPage1 c-embarque-via.
           
    find emitente-cex
         where emitente-cex.cod-emitente = ttint-emitente.cod-emitente exclusive-lock no-error.
    if not avail emitente-cex then do:
       create emitente-cex.
       assign emitente-cex.cod-emitente = ttint-emitente.cod-emitente.
    end.
    assign emitente-cex.cod-incoterm-exp = input frame fPage1 c-incoterm.    


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
    
    DEFINE VARIABLE i-cod-emitente LIKE {&ttTable}.cod-emitente NO-UNDO.

    
    DEFINE FRAME fGoToRecord
        i-cod-emitente  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para int-emitente" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_int-emitente"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-cod-emitente.
        
        RUN goToKey IN {&hDBOTable} (INPUT i-cod-emitente).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "int-emitente":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-cod-emitente btGoToOK btGoToCancel 
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
       {&hDBOTable}:FILE-NAME <> "boes332":U THEN DO:
        {btb/btb008za.i1 esbo/boes332.p YES}
        {btb/btb008za.i2 esbo/boes332.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable}  NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = p-cod-emitente NO-ERROR.
    IF AVAIL int-emitente THEN
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(int-emitente)).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-busca-categoria wMaintenance 
FUNCTION fn-busca-categoria RETURNS INTEGER
  ( pCod-unid-negoc AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST crm-categ-un NO-LOCK
        WHERE  crm-categ-un.cd-unid-negoc = pCod-unid-negoc NO-ERROR.

    ASSIGN i-cd-categoria = IF AVAIL crm-categ-un THEN crm-categ-un.cd-categoria ELSE 0.

    RETURN i-cd-categoria.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-categoria wMaintenance 
FUNCTION fn-desc-categoria RETURNS CHARACTER
  ( p-categoria AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST crm-categoria NO-LOCK
        WHERE  crm-categoria.cd-categoria = p-categoria NO-ERROR.

    ASSIGN c-ds-categoria = IF AVAIL crm-categoria THEN crm-categoria.ds-categoria ELSE "".

    RETURN c-ds-categoria.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-un wMaintenance 
FUNCTION fn-desc-un RETURNS CHARACTER
  ( p-cod_unid_negoc AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RUN upc/cd0704a-upc-un.p (INPUT p-cod_unid_negoc).

    RETURN RETURN-VALUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-gr-cli wMaintenance 
FUNCTION fn-gr-cli RETURNS CHARACTER
  ( p-cod-gr-cli AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST gr-cli
        WHERE gr-cli.cod-gr-cli = p-cod-gr-cli NO-LOCK NO-ERROR.

    IF AVAILABLE gr-cli THEN
        RETURN gr-cli.descricao.
    ELSE
        RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-nome-rep wMaintenance 
FUNCTION fn-nome-rep RETURNS CHARACTER
  ( p-cod-rep AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST repres
        WHERE repres.cod-rep = p-cod-rep NO-LOCK NO-ERROR.

    IF AVAILABLE repres THEN
        RETURN repres.nome-abrev.
    ELSE
        RETURN "":U.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

