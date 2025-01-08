&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttint-item NO-UNDO LIKE int-item
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
{include/i-prgvrs.i cd0204a-upc 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        cd0204a-upc
&GLOBAL-DEFINE Version        2.04.00.000

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Item,Importaá∆o,Corporativo,Descriá‰es,Suframa

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

&GLOBAL-DEFINE btAlterar      YES

&GLOBAL-DEFINE ttTable        ttint-item
&GLOBAL-DEFINE hDBOTable      h-int-item
&GLOBAL-DEFINE DBOTable       int-item

&GLOBAL-DEFINE page0KeyFields ttint-item.it-codigo
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields   cb-tipo-venda ttint-item.fm-codigo-ori ttint-item.nve ttint-item.nr-ped-energia ttint-item.exIPI
&GLOBAL-DEFINE page2Fields   ttint-item.destaque ttint-item.log-gatt ttint-item.perc-gatt ttint-item.ex-tarifario ttint-item.tipo ttint-item.ato-legal ttint-item.orgao-emis ttint-item.ano ttint-item.ato-numerico 
&GLOBAL-DEFINE page3Fields   ttint-item.corporativo
&GLOBAL-DEFINE page4Fields   ttint-item.desc-venda ttint-item.desc-completa
&GLOBAL-DEFINE page5Fields   ttint-item.seq-suframa 

/* Parameters Definitions ---                                           */
DEF NEW GLOBAL SHARED VARIABLE r-row-id-item AS ROWID NO-UNDO.
/* Local Variable Definitions ---                                       */
def var c-nova as char.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE r-filho AS ROWID       NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES item-proj-suframa

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table item-proj-suframa.nr-projeto ~
item-proj-suframa.controlado 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table 
&Scoped-define QUERY-STRING-br-table FOR EACH item-proj-suframa ~
      WHERE item-proj-suframa.it-codigo = ttint-item.it-codigo:screen-value in frame fpage0 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-table OPEN QUERY br-table FOR EACH item-proj-suframa ~
      WHERE item-proj-suframa.it-codigo = ttint-item.it-codigo:screen-value in frame fpage0 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-table item-proj-suframa
&Scoped-define FIRST-TABLE-IN-QUERY-br-table item-proj-suframa


/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-br-table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttint-item.it-codigo 
&Scoped-define ENABLED-TABLES ttint-item
&Scoped-define FIRST-ENABLED-TABLE ttint-item
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS ttint-item.it-codigo 
&Scoped-define DISPLAYED-TABLES ttint-item
&Scoped-define FIRST-DISPLAYED-TABLE ttint-item


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

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE cb-tipo-venda AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo de Venda" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Nenhum","Venda","Revenda" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-categoria AS CHARACTER FORMAT "X(256)":U 
     LABEL "Categoria" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-descCategoria AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-class-fiscal AS CHARACTER FORMAT "9999.99.99" INITIAL "00000000" 
     LABEL "Classificaá∆o Fiscal":R24 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59.14 BY .88 NO-UNDO.

DEFINE BUTTON bt-alterar 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-eliminar 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-inserir 
     LABEL "Inserir" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      item-proj-suframa SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table wMaintenance _STRUCTURED
  QUERY br-table NO-LOCK DISPLAY
      item-proj-suframa.nr-projeto COLUMN-LABEL "Nr.Projeto" FORMAT ">>>9":U
            WIDTH 10.43
      item-proj-suframa.controlado FORMAT "Sim/N∆o":U WIDTH 15.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 30 BY 5.17 FIT-LAST-COLUMN.


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
     ttint-item.it-codigo AT ROW 3.5 COL 34 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.21
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     ttint-item.fm-codigo-ori AT ROW 3.04 COL 13.57 COLON-ALIGNED WIDGET-ID 16
          LABEL "Fam Material Orig"
          VIEW-AS FILL-IN 
          SIZE 10 BY .79
     cb-tipo-venda AT ROW 4 COL 13.57 COLON-ALIGNED WIDGET-ID 4
     ttint-item.nve AT ROW 5 COL 13.57 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 45 BY .88
     c-categoria AT ROW 6 COL 13.57 COLON-ALIGNED WIDGET-ID 8
     c-descCategoria AT ROW 6 COL 33.86 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     ttint-item.nr-ped-energia AT ROW 7 COL 13.57 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     ttint-item.exIPI AT ROW 8 COL 13.57 COLON-ALIGNED WIDGET-ID 14
          LABEL "Ex.IPI"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 84.43 BY 10.62
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage5
     ttint-item.seq-suframa AT ROW 2.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     br-table AT ROW 3.75 COL 30 WIDGET-ID 300
     bt-inserir AT ROW 9 COL 29.86 WIDGET-ID 2
     bt-alterar AT ROW 9 COL 40 WIDGET-ID 4
     bt-eliminar AT ROW 9 COL 50.14 WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 84.43 BY 10.62 WIDGET-ID 200.

DEFINE FRAME fPage4
     ttint-item.desc-venda AT ROW 2.17 COL 5 NO-LABEL WIDGET-ID 2
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 76 BY 3.5
     ttint-item.desc-completa AT ROW 7.21 COL 5 NO-LABEL WIDGET-ID 6
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 76 BY 3.5
     "Descriá∆o Completa do Item" VIEW-AS TEXT
          SIZE 25 BY .67 AT ROW 6.5 COL 5 WIDGET-ID 8
     "Descriá∆o Venda" VIEW-AS TEXT
          SIZE 15.86 BY .67 AT ROW 1.46 COL 5.14 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 84.43 BY 10.62 WIDGET-ID 200.

DEFINE FRAME fPage3
     ttint-item.corporativo AT ROW 3 COL 11 WIDGET-ID 4
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .83
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 84.43 BY 10.62 WIDGET-ID 200.

DEFINE FRAME fPage2
     fi-class-fiscal AT ROW 2 COL 15.43 COLON-ALIGNED WIDGET-ID 14
     ttint-item.destaque AT ROW 3 COL 15.57 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     fi-descricao AT ROW 3 COL 19.86 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     ttint-item.log-gatt AT ROW 4 COL 17.72 WIDGET-ID 8
          VIEW-AS TOGGLE-BOX
          SIZE 11.57 BY .83
     ttint-item.perc-gatt AT ROW 4 COL 36 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .88
     ttint-item.ex-tarifario AT ROW 6 COL 15.43 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     ttint-item.orgao-emis AT ROW 6 COL 52 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     ttint-item.tipo AT ROW 7 COL 15.43 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     ttint-item.ano AT ROW 7 COL 52 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     ttint-item.ato-legal AT ROW 8 COL 15.43 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     ttint-item.ato-numerico AT ROW 8 COL 52 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.38
         SIZE 84.43 BY 10.62
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttint-item T "?" NO-UNDO mgesp int-item
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
         HEIGHT             = 17.21
         WIDTH              = 90
         MAX-HEIGHT         = 17.21
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.21
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
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN ttint-item.exIPI IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttint-item.fm-codigo-ori IN FRAME fPage1
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FRAME fPage2
                                                                        */
ASSIGN 
       FRAME fPage2:HIDDEN           = TRUE.

/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB br-table seq-suframa fPage5 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _TblList          = "mgesp.item-proj-suframa"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgesp.item-proj-suframa.it-codigo = ttint-item.it-codigo:screen-value in frame fpage0"
     _FldNameList[1]   > mgesp.item-proj-suframa.nr-projeto
"item-proj-suframa.nr-projeto" "Nr.Projeto" ? "integer" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgesp.item-proj-suframa.controlado
"item-proj-suframa.controlado" ? ? "logical" ? ? ? ? ? ? no ? no no "15.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-table */
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


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME bt-alterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-alterar wMaintenance
ON CHOOSE OF bt-alterar IN FRAME fPage5 /* Alterar */
DO:
    DEFINE VARIABLE c-tipo AS CHARACTER   NO-UNDO.

    IF AVAILABLE item-proj-suframa THEN DO:
        ASSIGN r-filho = ROWID(item-proj-suframa)
               c-tipo = "alterar".

        RUN upc/cd0204v1.w (INPUT {&WINDOW-NAME},
                            INPUT ttint-item.r-rowid,
                            INPUT YES,
                            INPUT-OUTPUT r-filho,
                            INPUT c-tipo).

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
ON CHOOSE OF bt-eliminar IN FRAME fPage5 /* Eliminar */
DO:
    IF AVAILABLE item-proj-suframa THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 550,
                           INPUT "":U).

        IF RETURN-VALUE = "YES":U THEN DO:
            FIND CURRENT item-proj-suframa EXCLUSIVE-LOCK NO-ERROR.
            DELETE item-proj-suframa.
            {&OPEN-QUERY-br-table}
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-inserir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inserir wMaintenance
ON CHOOSE OF bt-inserir IN FRAME fPage5 /* Inserir */
DO:
    DEFINE VARIABLE c-tipo  AS CHARACTER   NO-UNDO.
    

    ASSIGN r-filho = ?
           c-tipo = "novo".

    RUN upc/cd0204v1.w (INPUT {&WINDOW-NAME},
                        INPUT ttint-item.r-rowid,
                        INPUT NO,
                        INPUT-OUTPUT r-filho,
                        INPUT c-tipo).

    IF RETURN-VALUE = "OK":U THEN DO:
        {&OPEN-QUERY-br-table}

        REPOSITION br-table TO ROWID r-filho NO-ERROR.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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
   {method/zoomreposition.i &ProgramZoom="eszoom/z01es372.w"}
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME ttint-item.destaque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item.destaque wMaintenance
ON F5 OF ttint-item.destaque IN FRAME fPage2 /* Destaque */
DO:
    IF fi-class-fiscal <> "" THEN DO:
        {include/zoomvar.i &prog-zoom=eszoom/z01es522.w
                           &campo=ttint-item.destaque
                           &campozoom=destaque
                           &campo2=fi-descricao
                           &campozoom2=descricao
                           &frame=fPage2
                           &parametros="run pi-seta-inicial in wh-pesquisa (input fi-class-fiscal, input fi-class-fiscal)."}.  
    END.
    ELSE DO:
        MESSAGE "Item n∆o possui Classificaá∆o Fiscal cadastrada!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item.destaque wMaintenance
ON LEAVE OF ttint-item.destaque IN FRAME fPage2 /* Destaque */
DO:
    ASSIGN fi-descricao:SCREEN-VALUE IN FRAME fPage2 = "".
    IF AVAIL ttint-item THEN DO:
        FIND FIRST destaque-classif-fisc NO-LOCK
             WHERE destaque-classif-fisc.class-fiscal = REPLACE(fi-class-fiscal:SCREEN-VALUE IN FRAME fPage2,".","")
               AND destaque-classif-fisc.destaque     = INT(ttint-item.destaque:SCREEN-VALUE IN FRAME fPage2) NO-ERROR.
        IF AVAIL destaque-classif-fisc THEN DO:
            ASSIGN fi-descricao:SCREEN-VALUE IN FRAME fPage2 = destaque-classif-fisc.descricao.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item.destaque wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttint-item.destaque IN FRAME fPage2 /* Destaque */
DO:
    APPLY "F5" TO SELF.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttint-item.log-gatt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-item.log-gatt wMaintenance
ON VALUE-CHANGED OF ttint-item.log-gatt IN FRAME fPage2 /* GATT */
DO:
    ASSIGN INPUT FRAME fPage2 ttint-item.log-gatt.

    IF NOT ttint-item.log-gatt THEN
        ASSIGN ttint-item.perc-gatt:SCREEN-VALUE IN FRAME fPage2 = "0,00"
               ttint-item.perc-gatt:SENSITIVE IN FRAME fPage2 = NO.
    ELSE
        ASSIGN ttint-item.perc-gatt:SENSITIVE IN FRAME fPage2 = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-table
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
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
        DISABLE bt-alterar
            WITH FRAME fPage5.

    DISABLE br-table
           bt-inserir
           bt-eliminar
        WITH FRAME fPage5.

    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
if avail ttint-item and
   ttint-item.ind-tipo-venda <> 0 then 
   assign cb-tipo-venda:screen-value in frame fpage1 = {esinc/i01es372.i 04 ttint-item.ind-tipo-venda}.

else 
   assign cb-tipo-venda:screen-value in frame fpage1 = {esinc/i01es372.i 04 1}.
   
    ASSIGN fi-class-fiscal = "".
    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = ttint-item.it-codigo:screen-value in frame fpage0 NO-ERROR.
    IF AVAIL ITEM THEN DO:
        ASSIGN fi-class-fiscal = ITEM.class-fiscal.

        FIND FIRST categoria-fmcom
            WHERE categoria-fmcom.fm-cod-com = ITEM.fm-cod-com NO-LOCK NO-ERROR.
        IF AVAIL categoria-fmcom THEN DO:
            FIND FIRST categoria-produto 
                WHERE categoria-produto.cod-categoria = categoria-fmcom.cod-categoria NO-LOCK NO-ERROR.
            IF AVAIL categoria-produto THEN
                ASSIGN c-categoria    :screen-value in frame fpage1 = categoria-produto.cod-categoria 
                       c-descCategoria:screen-value in frame fpage1 = categoria-produto.desc-categoria .
            ELSE
                ASSIGN c-categoria    :screen-value in frame fpage1 = '' 
                       c-descCategoria:screen-value in frame fpage1 = ''.
        END. /* IF AVAIL categroai-fmcom THEN DO: */
        ELSE
            ASSIGN c-categoria    :screen-value in frame fpage1 = '' 
                   c-descCategoria:screen-value in frame fpage1 = ''.


    END. /* IF AVAIL ITEM THEN DO: */

    {&OPEN-QUERY-br-table}

    FIND FIRST item-proj-suframa 
         WHERE item-proj-suframa.it-codigo = ttint-item.it-codigo 
    NO-LOCK NO-ERROR.

    IF AVAIL item-proj-suframa THEN
       '{&btAlterar}' = 'YES'.
    ELSE
       '{&btAlterar}' = 'no'.

    DISP fi-class-fiscal WITH FRAME fPage2.

    APPLY "leave" TO ttint-item.destaque IN FRAME fPage2.



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

    APPLY "value-changed" TO ttint-item.log-gatt IN FRAME fPage2.

    IF ttint-item.nr-ped-energia:SCREEN-VALUE IN FRAME fPage1 <> "" THEN
        ASSIGN ttint-item.nr-ped-energia:SENSITIVE IN FRAME fPage1 = NO.

    IF '{&btAlterar}' = 'YES' THEN
        ENABLE bt-alterar
            WITH FRAME fPage5.

    ENABLE br-table
           bt-inserir
           bt-eliminar
        WITH FRAME fPage5.

    DISABLE ttint-item.fm-codigo-ori
            /*ttint-item.nr-ped-energia*/
            ttint-item.nve
            ttint-item.exIPI
            WITH FRAME fPage1.

    DISABLE ttint-item.destaque
            ttint-item.ex-tarifario
            ttint-item.ato-legal 
            ttint-item.ano
            ttint-item.tipo
            ttint-item.ato-numerico
            ttint-item.orgao-emis
            ttint-item.log-gatt
            ttint-item.perc-gatt
            WITH FRAME fPage2.

    DISABLE ttint-item.desc-venda
            ttint-item.desc-completa
            WITH FRAME fPage4.

    DISABLE ttint-item.seq-suframa
            bt-inserir
            bt-alterar
            bt-eliminar
            WITH FRAME fPage5.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenance 
PROCEDURE afterSaveFields :
ASSIGN c-nova = cb-tipo-venda:SCREEN-VALUE IN FRAME fpage1 .
ASSIGN ttint-item.ind-tipo-venda  = {esinc/i01es372.i 06 c-nova}. 
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
    
    DEFINE VARIABLE c-it-codigo LIKE {&ttTable}.it-codigo NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-it-codigo  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para <Tabela>" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_int-it-codigo"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-it-codigo.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-it-codigo).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "int-item":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-it-codigo btGoToOK btGoToCancel 
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
     DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "boes372":U THEN DO:
        {btb/btb008za.i1 esbo/boes372.p YES}
        {btb/btb008za.i2 esbo/boes372.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable}  NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
        /*:T Retorna rowid do registro corrente do DBO */
        IF r-row-id-item <> ? THEN
            FIND ITEM WHERE ROWID(ITEM) = r-row-id-item
                NO-LOCK NO-ERROR.

        IF AVAIL ITEM THEN DO:
            RUN goToKey IN {&hDBOTable} (INPUT item.it-codigo).
    
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "int-item":U).
                
                RETURN NO-APPLY.
            END.
            
            /*:T Retorna rowid do registro corrente do DBO */
            RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
            
            /*:T Reposiciona registro com base em um rowid */
            RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).   
        END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

