&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-esp-ext-ser-estab NO-UNDO LIKE esp-ext-ser-estab
       FIELD r-rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i espnfse2040 3.00.00.000}
/**ATUALIZACAO: 17/09/2012**/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        espnfse2040
&GLOBAL-DEFINE Version        3.00.00.000

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   NFS-e,Imp/Exp

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

&GLOBAL-DEFINE ttTable        tt-esp-ext-ser-estab
&GLOBAL-DEFINE hDBOTable      h-boesp900
&GLOBAL-DEFINE DBOTable       esp-ext-ser-estab

&GLOBAL-DEFINE page0KeyFields {&ttTable}.serie {&ttTable}.cod-estabel
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    {&ttTable}.nat-op-fora {&ttTable}.nat-op-dentro {&ttTable}.cod-prestador 
&GLOBAL-DEFINE page2Fields    {&ttTable}.dir-padrao-exp {&ttTable}.dir-padrao-imp

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR c-nom-dir   AS CHAR                    NO-UNDO.
DEF VAR l-cancela   AS LOG                     NO-UNDO.
DEF VAR vSerie      LIKE ser-estab.serie       NO-UNDO.
DEF VAR vCodEstabel LIKE ser-estab.cod-estabel NO-UNDO.
DEF VAR vGoTo       AS ROWID                   NO-UNDO.
DEF VAR wh-pesquisa AS WIDGET-HANDLE           NO-UNDO.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.

/* TRATAMENTO CLIENTES ORACLE */
{include\i_dbtype.i}
&IF "{&ems_dbType}":U = "ORACLE":U &THEN
    DEF NEW GLOBAL SHARED VAR h-rsocial    AS HANDLE  NO-UNDO.
    DEF NEW GLOBAL SHARED VAR l-achou-prog AS LOGICAL NO-UNDO.
&ENDIF

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-esp-ext-ser-estab.serie ~
tt-esp-ext-ser-estab.cod-estabel 
&Scoped-define ENABLED-TABLES tt-esp-ext-ser-estab
&Scoped-define FIRST-ENABLED-TABLE tt-esp-ext-ser-estab
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btImp btQueryJoins btReportsJoins btExit btHelp fiDescEstab 
&Scoped-Define DISPLAYED-FIELDS tt-esp-ext-ser-estab.serie ~
tt-esp-ext-ser-estab.cod-estabel 
&Scoped-define DISPLAYED-TABLES tt-esp-ext-ser-estab
&Scoped-define FIRST-DISPLAYED-TABLE tt-esp-ext-ser-estab
&Scoped-Define DISPLAYED-OBJECTS fiDescEstab 

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

DEFINE BUTTON btImp 
     IMAGE-UP FILE "image/im-carga.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-carga.bmp":U
     LABEL "Imp" 
     SIZE 4 BY 1.25 TOOLTIP "Importar relacionamento Serie x Estabelecimento (FT0114)"
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

DEFINE VARIABLE fiDescEstab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE rdEnderecoTom AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Nota Fiscal", 1,
"Cadastro Emitente", 2
     SIZE 34 BY .92 NO-UNDO.

DEFINE VARIABLE rdPadrao AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Cidade do Estabelecimento", 1,
"Cidade do Cliente", 2
     SIZE 23 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 2.75.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 1.58.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 3.58.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 4.83.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 3.58.

DEFINE VARIABLE tgAgrupaItens AS LOGICAL INITIAL no 
     LABEL "Agrupa Itens" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .83 NO-UNDO.

DEFINE VARIABLE tgDescItem AS LOGICAL INITIAL no 
     LABEL "Imprime Desc do Item" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tgEmiteFatura AS LOGICAL INITIAL no 
     LABEL "Imprime Fatura" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE tgEmiteRps AS LOGICAL INITIAL no 
     LABEL "Emite RPS" 
     VIEW-AS TOGGLE-BOX
     SIZE 10 BY .83 NO-UNDO.

DEFINE VARIABLE tgExpNotaCancel AS LOGICAL INITIAL no 
     LABEL "Exporta Notas Canceladas" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tgObsNota AS LOGICAL INITIAL no 
     LABEL "Imprime Obs da Nota" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE BUTTON btDirExp 
     IMAGE-UP FILE "image/im-open.gif":U
     LABEL "btdir 2" 
     SIZE 4.29 BY 1.

DEFINE BUTTON btDirImp 
     IMAGE-UP FILE "image/im-open.gif":U
     LABEL "btdir 2" 
     SIZE 4.29 BY 1.

DEFINE VARIABLE rdAmbiente AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Produá∆o", 1,
"Homologaá∆o", 2
     SIZE 24.14 BY .5 NO-UNDO.

DEFINE VARIABLE rdIntegraCom AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "CW NFSe", 1,
"Mastersaf V3", 2
     SIZE 13 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 3.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.75.


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
     btImp AT ROW 1.13 COL 64 HELP
          "Importar relacionamento Serie x Estabelecimento (FT0114)" WIDGET-ID 10
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-esp-ext-ser-estab.serie AT ROW 3 COL 21 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-esp-ext-ser-estab.cod-estabel AT ROW 4 COL 21 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fiDescEstab AT ROW 4 COL 29.57 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tgEmiteRps AT ROW 2.08 COL 4 WIDGET-ID 24
     tgExpNotaCancel AT ROW 3.08 COL 4 WIDGET-ID 94
     tt-esp-ext-ser-estab.cod-prestador AT ROW 4.08 COL 14 COLON-ALIGNED WIDGET-ID 84
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     rdPadrao AT ROW 6.21 COL 4 NO-LABEL WIDGET-ID 26
     rdEnderecoTom AT ROW 9.42 COL 4 NO-LABEL WIDGET-ID 102
     tgDescItem AT ROW 2.08 COL 44 WIDGET-ID 90
     tgObsNota AT ROW 3.08 COL 44 WIDGET-ID 88
     tgEmiteFatura AT ROW 4.08 COL 44 WIDGET-ID 52
     tgAgrupaItens AT ROW 2.08 COL 68 WIDGET-ID 64
     tt-esp-ext-ser-estab.nat-op-dentro AT ROW 6.63 COL 65 COLON-ALIGNED WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-esp-ext-ser-estab.nat-op-fora AT ROW 7.63 COL 65 COLON-ALIGNED WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-esp-ext-ser-estab.nat-op-especial AT ROW 8.63 COL 65 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     "Local Padr∆o Prestaá∆o de Serviáo" VIEW-AS TEXT
          SIZE 25 BY .54 AT ROW 5.46 COL 4 WIDGET-ID 36
     "Natureza de Operaá∆o Municipal" VIEW-AS TEXT
          SIZE 23 BY .54 AT ROW 5.46 COL 44 WIDGET-ID 50
     "Descriá∆o do Serviáo da RPS" VIEW-AS TEXT
          SIZE 21 BY .54 AT ROW 1.33 COL 44 WIDGET-ID 92
     "Geral" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 1.33 COL 4 WIDGET-ID 96
     "Endereáo do Tomador" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 8.71 COL 4 WIDGET-ID 100
     RECT-1 AT ROW 5.71 COL 2 WIDGET-ID 34
     RECT-2 AT ROW 1.58 COL 2 WIDGET-ID 38
     RECT-4 AT ROW 5.71 COL 42 WIDGET-ID 48
     RECT-9 AT ROW 1.58 COL 42 WIDGET-ID 86
     RECT-10 AT ROW 8.96 COL 2 WIDGET-ID 98
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7
         SIZE 84.43 BY 10
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     rdAmbiente AT ROW 7.5 COL 18.86 NO-LABEL WIDGET-ID 56
     rdIntegraCom AT ROW 6.25 COL 5 NO-LABEL WIDGET-ID 52
     tt-esp-ext-ser-estab.dir-padrao-imp AT ROW 2.58 COL 4.57 WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 59 BY .88
     btDirImp AT ROW 2.5 COL 78 WIDGET-ID 42
     tt-esp-ext-ser-estab.dir-padrao-exp AT ROW 3.58 COL 4.43 WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 59 BY .88
     btDirExp AT ROW 3.5 COL 78 WIDGET-ID 44
     "]" VIEW-AS TEXT
          SIZE 1 BY .54 AT ROW 7.46 COL 42 WIDGET-ID 66
     "Arquivos de Integraá∆o" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 1.75 COL 4 WIDGET-ID 46
     "Integraá∆o com" VIEW-AS TEXT
          SIZE 11 BY .54 AT ROW 5.5 COL 4 WIDGET-ID 50
     "[" VIEW-AS TEXT
          SIZE 1 BY .54 AT ROW 7.46 COL 18 WIDGET-ID 60
     RECT-7 AT ROW 2 COL 2 WIDGET-ID 40
     RECT-8 AT ROW 5.75 COL 2 WIDGET-ID 48
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7
         SIZE 84.43 BY 10
         FONT 1 WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-esp-ext-ser-estab T "?" NO-UNDO mgesp esp-ext-ser-estab
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
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
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
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
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
ASSIGN 
       tt-esp-ext-ser-estab.nat-op-especial:HIDDEN IN FRAME fPage1           = TRUE.

/* SETTINGS FOR FRAME fPage2
   Custom                                                               */
/* SETTINGS FOR FILL-IN tt-esp-ext-ser-estab.dir-padrao-exp IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN tt-esp-ext-ser-estab.dir-padrao-imp IN FRAME fPage2
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDirExp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDirExp wMaintenance
ON CHOOSE OF btDirExp IN FRAME fPage2 /* btdir 2 */
DO:
    RUN pi-get-directory ('',
                          OUTPUT c-nom-dir,
                          OUTPUT l-cancela).

    IF  NOT l-cancela THEN
        ASSIGN {&ttTable}.dir-padrao-exp:SCREEN-VALUE IN FRAME fPage2 = c-nom-dir.

    APPLY "leave" TO {&ttTable}.dir-padrao-exp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDirImp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDirImp wMaintenance
ON CHOOSE OF btDirImp IN FRAME fPage2 /* btdir 2 */
DO:
    RUN pi-get-directory ('',
                          OUTPUT c-nom-dir,
                          OUTPUT l-cancela).

    IF  NOT l-cancela THEN
        ASSIGN {&ttTable}.dir-padrao-imp:SCREEN-VALUE IN FRAME fPage2 = c-nom-dir.

    APPLY "leave" TO {&ttTable}.dir-padrao-imp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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


&Scoped-define SELF-NAME btImp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImp wMaintenance
ON CHOOSE OF btImp IN FRAME fpage0 /* Imp */
DO:
    FOR EACH ser-estab NO-LOCK:

        IF  NOT CAN-FIND(FIRST esp-ext-ser-estab
                         WHERE esp-ext-ser-estab.serie = ser-estab.serie
                           AND esp-ext-ser-estab.cod-estabel = ser-estab.cod-estabel) THEN DO:

            CREATE esp-ext-ser-estab.
            ASSIGN esp-ext-ser-estab.serie       = ser-estab.serie
                   esp-ext-ser-estab.cod-estabel = ser-estab.cod-estabel
                   vSerie                        = ser-estab.serie
                   vCodEstabel                   = ser-estab.cod-estabel.
        END.
    END.

    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RUN goToKey  IN {&hDBOTable} (INPUT vSerie, INPUT vCodEstabel).
    RUN getRowid IN {&hDBOTable} (OUTPUT vGoTo).
    RUN repositionRecord IN THIS-PROCEDURE (INPUT vGoTo).
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
    
    apply 'leave' to tt-esp-ext-ser-estab.dir-padrao-imp in frame fPage2.
    apply 'leave' to tt-esp-ext-ser-estab.dir-padrao-exp in frame fPage2.
    
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/ZoomReposition.i &ProgramZoom="eszoom\z01es900.w"}
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


&Scoped-define SELF-NAME tt-esp-ext-ser-estab.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-esp-ext-ser-estab.cod-estabel wMaintenance
ON F5 OF tt-esp-ext-ser-estab.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo={&ttTable}.cod-estabel
                       &campozoom=cod-estabel
                       &campo2=fiDescEstab
                       &campozoom2=nome
                       &frame=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-esp-ext-ser-estab.cod-estabel wMaintenance
ON LEAVE OF tt-esp-ext-ser-estab.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=fiDescEstab
                     &where="estabelec.cod-estabel = input frame fPage0 {&ttTable}.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-esp-ext-ser-estab.cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-esp-ext-ser-estab.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt-esp-ext-ser-estab.dir-padrao-exp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-esp-ext-ser-estab.dir-padrao-exp wMaintenance
ON LEAVE OF tt-esp-ext-ser-estab.dir-padrao-exp IN FRAME fPage2 /* Diret¢rio Exportaá∆o */
DO:

    ASSIGN INPUT {&ttTable}.dir-padrao-exp.

    IF  {&ttTable}.dir-padrao-exp <> "" THEN DO:

        IF  SUBSTRING({&ttTable}.dir-padrao-exp,LENGTH({&ttTable}.dir-padrao-exp),1) <> "\" AND
            SUBSTRING({&ttTable}.dir-padrao-exp,LENGTH({&ttTable}.dir-padrao-exp),1) <> "/" THEN
            OVERLAY({&ttTable}.dir-padrao-exp,LENGTH({&ttTable}.dir-padrao-exp) + 1,1) = "\".

        DISP {&ttTable}.dir-padrao-exp WITH FRAME fPage2.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-esp-ext-ser-estab.dir-padrao-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-esp-ext-ser-estab.dir-padrao-imp wMaintenance
ON LEAVE OF tt-esp-ext-ser-estab.dir-padrao-imp IN FRAME fPage2 /* Diret¢rio Importaá∆o */
DO:
    
    ASSIGN INPUT {&ttTable}.dir-padrao-imp.

    IF  {&ttTable}.dir-padrao-imp <> "" THEN DO:

        IF  SUBSTRING({&ttTable}.dir-padrao-imp,LENGTH({&ttTable}.dir-padrao-imp),1) <> "\" AND
            SUBSTRING({&ttTable}.dir-padrao-imp,LENGTH({&ttTable}.dir-padrao-imp),1) <> "/" THEN
            OVERLAY({&ttTable}.dir-padrao-imp,LENGTH({&ttTable}.dir-padrao-imp) + 1,1) = "\".

        DISP {&ttTable}.dir-padrao-imp WITH FRAME fPage2.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rdIntegraCom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rdIntegraCom wMaintenance
ON VALUE-CHANGED OF rdIntegraCom IN FRAME fPage2
DO:
    IF  SELF:SENSITIVE THEN DO:

        IF  SELF:SCREEN-VALUE = "1" THEN
            DISABLE rdAmbiente WITH FRAME fPage2.
        ELSE
            ENABLE rdAmbiente WITH FRAME fPage2.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-esp-ext-ser-estab.serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-esp-ext-ser-estab.serie wMaintenance
ON F5 OF tt-esp-ext-ser-estab.serie IN FRAME fpage0 /* Serie */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in407.w
                       &campo={&ttTable}.serie
                       &campozoom=serie
                       &frame=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-esp-ext-ser-estab.serie wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-esp-ext-ser-estab.serie IN FRAME fpage0 /* Serie */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/MainBlock.i}

/***************************** Mostra diretÛrios ****************************/
PROCEDURE SHBrowseForFolder EXTERNAL "shell32.dll":
    DEF INPUT  PARAM lpbi                              AS LONG.
    DEF RETURN PARAM lpItemIDList                      AS LONG.
END PROCEDURE. /* SHBrowseForFolder */

/******************************** Busca Path ********************************/
PROCEDURE SHGetPathFromIDList EXTERNAL "shell32.dll":
    DEF INPUT  PARAM v_cdn_lista                       AS LONG.
    DEF OUTPUT PARAM pszPath                           AS CHARACTER.
END PROCEDURE. /* SHGetPathFromIDList */

{&ttTable}.serie:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
{&ttTable}.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

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

    DISABLE tgEmiteRPS
            tgEmiteFatura
            tgAgrupaItens
            tgDescItem
            tgObsNota
            tgExpNotaCancel
            rdPadrao
            rdEnderecoTom
        WITH FRAME fPage1.

    DISABLE btDirImp
            btDirExp
            rdIntegraCom
            rdAmbiente
        WITH FRAME fPage2.

    ENABLE btImp
        WITH FRAME fPage0.

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

    /*display dos campos que n∆o s∆o DB_FIELD*/
    IF  AVAIL {&ttTable} THEN DO:

        ASSIGN tgEmiteRPS:CHECKED         IN FRAME fPage1 = {&ttTable}.emite-rps
               tgEmiteFatura:CHECKED      IN FRAME fPage1 = {&ttTable}.log-1
               tgAgrupaItens:CHECKED      IN FRAME fPage1 = {&ttTable}.log-2
               rdPadrao:SCREEN-VALUE      IN FRAME fPage1 = STRING({&ttTable}.local-padrao-prest-serv)
               rdEnderecoTom:SCREEN-VALUE IN FRAME fPage1 = IF SUBSTRING({&ttTable}.char-1,4,1) = ""
                                                               THEN "1"
                                                               ELSE SUBSTRING({&ttTable}.char-1,4,1).

        ASSIGN rdIntegraCom:SCREEN-VALUE  IN FRAME fPage2 = IF SUBSTRING({&ttTable}.char-1,5,1) = ""
                                                               THEN "1"
                                                               ELSE SUBSTRING({&ttTable}.char-1,5,1).

        ASSIGN rdAmbiente:SCREEN-VALUE  IN FRAME fPage2 = IF SUBSTRING({&ttTable}.char-1,6,1) = ""
                                                             THEN "2"
                                                             ELSE SUBSTRING({&ttTable}.char-1,6,1).
        /*Imprime Descricao do Item*/
        ASSIGN tgDescItem:CHECKED IN FRAME fPage1 = SUBSTRING({&ttTable}.char-1,1,1) = "S".
        
        /*Imprime Observacao da Nota*/
        ASSIGN tgObsNota:CHECKED IN FRAME fPage1 = SUBSTRING({&ttTable}.char-1,2,1) = "S".

        /*Exporta Notas Canceladas*/
        ASSIGN tgExpNotaCancel:CHECKED IN FRAME fPage1 = SUBSTRING({&ttTable}.char-1,3,1) = "S".
    END.

    APPLY "leave" TO {&ttTable}.cod-estabel IN FRAME fPage0.
    APPLY "value-changed" TO rdIntegraCom IN FRAME fPage2.

    RETURN "OK":U.
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

    ENABLE tgEmiteRPS
           tgEmiteFatura
           tgAgrupaItens
           tgDescItem
           tgObsNota
           tgExpNotaCancel
           rdPadrao
           rdEnderecoTom
        WITH FRAME fPage1.

    ENABLE btDirImp
           btDirExp
           rdIntegraCom
           rdAmbiente
        WITH FRAME fPage2.

    DISABLE btImp
        WITH FRAME fPage0.

    APPLY "value-changed" TO rdIntegraCom IN FRAME fPage2.

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

    ENABLE btImp WITH FRAME fPage0.

    RETURN "OK":U.
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

    /*gravando campos que n∆o s∆o DB_FIELD*/
    IF  AVAIL {&ttTable} THEN DO:

        ASSIGN {&ttTable}.emite-rps = tgEmiteRPS:CHECKED IN FRAME fPage1
               {&ttTable}.log-1     = tgEmiteFatura:CHECKED IN FRAME fPage1
               {&ttTable}.log-2     = tgAgrupaItens:CHECKED IN FRAME fPage1
               {&ttTable}.local-padrao-prest-serv = INT(rdPadrao:SCREEN-VALUE IN FRAME fPage1).

        /*Imprime Descricao do Item*/
        OVERLAY({&ttTable}.char-1,1,1) = IF  tgDescItem:CHECKED IN FRAME fPage1
                                         THEN "S"
                                         ELSE "N".

        /*Imprime Observacao da Nota*/
        OVERLAY({&ttTable}.char-1,2,1) = IF  tgObsNota:CHECKED IN FRAME fPage1
                                         THEN "S"
                                         ELSE "N".

        /*Exporta Notas Canceladas*/
        OVERLAY({&ttTable}.char-1,3,1) = IF  tgExpNotaCancel:CHECKED IN FRAME fPage1
                                         THEN "S"
                                         ELSE "N".

        /*Endereco do Tomador*/
        OVERLAY({&ttTable}.char-1,4,1) = rdEnderecoTom:SCREEN-VALUE IN FRAME fPage1.

        /*Integraá∆o com Sistema CW NFSe ou Mastersaf V3*/
        OVERLAY({&ttTable}.char-1,5,1) = rdIntegraCom:SCREEN-VALUE IN FRAME fPage2.

        /*Quando integracao Mastersaf V3, define o tipo de ambiente 1 Producao, 2 Homologacao*/
        OVERLAY({&ttTable}.char-1,6,1) = rdAmbiente:SCREEN-VALUE IN FRAME fPage2.
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
         SIZE 40 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE cSerie       LIKE {&ttTable}.Serie       NO-UNDO.
    DEFINE VARIABLE cCod-estabel LIKE {&ttTable}.Cod-estabel NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        cSerie            AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 8 BY .88
        cCod-estabel      AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 8 BY .88
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Esp-SÇrie-Estabel" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cSerie cCod-estabel.
        
        RUN goToKey IN {&hDBOTable} (INPUT cSerie, INPUT cCod-estabel).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Esp-Serie-Estabel":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cSerie cCod-estabel btGoToOK btGoToCancel 
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
       {&hDBOTable}:FILE-NAME <> "esbo\boes900.p":U THEN DO:
        
        RUN esbo\boes900.p PERSISTENT SET {&hDBOTable} NO-ERROR.
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-directory wMaintenance 
PROCEDURE pi-get-directory :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /************************ Parameter Definition Begin ************************/

    def Input param p_des_titulo
        as character
        format "x(40)":U
        no-undo.
    def output param p_nom_path
        as character
        format "x(50)":U
        no-undo.
    def output param p_log_cancdo
        as logical
        format "Sim/N„o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cdn_lista_item
        as Integer
        format ">>>,>>9":U
        no-undo.
    def var v_mmp_browse
        as MemPtr
        no-undo.
    def var v_mmp_mostra_nom
        as MemPtr
        no-undo.
    def var v_mmp_title_pointer
        as MemPtr
        no-undo.


    /************************** Variable Definition End *************************/

    set-size(v_mmp_browse)        = 32.
    set-size(v_mmp_mostra_nom)    = 260.
    set-size(v_mmp_title_pointer) = length(p_des_titulo) + 1.

    put-string(v_mmp_title_pointer,1) = p_des_titulo.

    put-long(v_mmp_browse, 1) = 0.
    put-long(v_mmp_browse, 5) = 0.
    put-long(v_mmp_browse, 9) = get-pointer-value(v_mmp_mostra_nom).
    put-long(v_mmp_browse,13) = get-pointer-value(v_mmp_title_pointer).
    put-long(v_mmp_browse,17) = 1.
    put-long(v_mmp_browse,21) = 0.
    put-long(v_mmp_browse,25) = 0.
    put-long(v_mmp_browse,29) = 0.

    run SHBrowseForFolder( input  get-pointer-value(v_mmp_browse), 
                           output v_cdn_lista_item).

    /* parse the result: */
    if v_cdn_lista_item = 0 then do:
       p_log_cancdo   = yes.
       p_nom_path = "".
    end.
    else do:
       assign p_log_cancdo = No
              p_nom_path = fill(" ", 260).
       run SHGetPathFromIDList(v_cdn_lista_item, output p_nom_path).
       assign p_nom_path = trim(p_nom_path).
    end.   

    /* free memory: */
    set-size(v_mmp_browse) = 0.
    set-size(v_mmp_mostra_nom) = 0.
    set-size(v_mmp_title_pointer) = 0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

