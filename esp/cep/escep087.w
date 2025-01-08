&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgintelbras      PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-item-estab-depos NO-UNDO LIKE int-item-estab-depos
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-int-item-estab-depos-pv NO-UNDO LIKE int-item-estab-depos-pv
       FIELD r-Rowid AS ROWID.



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

/* Chamada a include do gerenciador de licen»as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m½dulo>:  Informar qual o m½dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m½dulo>}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escep087
&GLOBAL-DEFINE Version        3.00.00.000

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Gerais,Prev.Vendas

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

&GLOBAL-DEFINE ttTable        tt-int-item-estab-depos
&GLOBAL-DEFINE hDBOTable      hesbo928
&GLOBAL-DEFINE DBOTable       int-item-estab-depos

&GLOBAL-DEFINE ttSon2         tt-int-item-estab-depos-pv
&GLOBAL-DEFINE hDBOSon2       hesbo929
&GLOBAL-DEFINE DBOSon2Table   int-item-estab-depos-pv
&GLOBAL-DEFINE DBOSon2Destroy YES

&GLOBAL-DEFINE page0KeyFields tt-int-item-estab-depos.cod-estabel tt-int-item-estab-depos.cod-depos tt-int-item-estab-depos.it-codigo
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    tt-int-item-estab-depos.classif-abc tt-int-item-estab-depos.log-estoq-minimo tt-int-item-estab-depos.politica tt-int-item-estab-depos.estoque-minimo tt-int-item-estab-depos.tipo-est-seg tt-int-item-estab-depos.quant-segur tt-int-item-estab-depos.tempo-segur
&GLOBAL-DEFINE page2Fields    

&GLOBAL-DEFINE page2Browse      brPV

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}  AS HANDLE NO-UNDO.

//DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.

DEFINE VARIABLE hDBOWm-estabel  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOWm-deposito AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bosc044       AS HANDLE NO-UNDO.
DEFINE VARIABLE hSonProgram     AS HANDLE NO-UNDO.
//DEFINE VARIABLE cProgram        AS CHARACTER   NO-UNDO.
//DEFINE VARIABLE h-window        AS HANDLE NO-UNDO.

DEFINE VARIABLE epc-rowid2      AS ROWID     NO-UNDO.
DEFINE VARIABLE rSon            AS ROWID     NO-UNDO.
DEFINE VARIABLE rCurrentParent  AS ROWID       NO-UNDO.
DEFINE VARIABLE c-arquivo       AS CHARACTER FORMAT "x(50)" LABEL "Nome Arquivo:" NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brPV

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-item-estab-depos-pv

/* Definitions for BROWSE brPV                                          */
&Scoped-define FIELDS-IN-QUERY-brPV tt-int-item-estab-depos-pv.ano ~
tt-int-item-estab-depos-pv.quant-previsao-venda[1] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[2] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[3] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[4] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[5] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[6] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[7] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[8] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[9] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[10] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[11] ~
tt-int-item-estab-depos-pv.quant-previsao-venda[12] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPV 
&Scoped-define QUERY-STRING-brPV FOR EACH tt-int-item-estab-depos-pv NO-LOCK
&Scoped-define OPEN-QUERY-brPV OPEN QUERY brPV FOR EACH tt-int-item-estab-depos-pv NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brPV tt-int-item-estab-depos-pv
&Scoped-define FIRST-TABLE-IN-QUERY-brPV tt-int-item-estab-depos-pv


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brPV}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-int-item-estab-depos.cod-estabel ~
tt-int-item-estab-depos.cod-depos tt-int-item-estab-depos.it-codigo 
&Scoped-define ENABLED-TABLES tt-int-item-estab-depos
&Scoped-define FIRST-ENABLED-TABLE tt-int-item-estab-depos
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btExcel btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-int-item-estab-depos.cod-estabel ~
tt-int-item-estab-depos.cod-depos tt-int-item-estab-depos.it-codigo 
&Scoped-define DISPLAYED-TABLES tt-int-item-estab-depos
&Scoped-define FIRST-DISPLAYED-TABLE tt-int-item-estab-depos
&Scoped-Define DISPLAYED-OBJECTS c-des-estabel c-des-deposito c-des-item 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-2 tt-int-item-estab-depos.quant-segur ~
tt-int-item-estab-depos.tipo-est-seg tt-int-item-estab-depos.tempo-segur 
&Scoped-define List-3 tt-int-item-estab-depos.quant-segur ~
tt-int-item-estab-depos.tipo-est-seg tt-int-item-estab-depos.tempo-segur 

/* _UIB-PREPROCESSOR-BLOCK-END */
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

DEFINE BUTTON btExcel 
     IMAGE-UP FILE "image/excel.gif":U
     LABEL "Exporta/Importa" 
     SIZE 4 BY 1.25 TOOLTIP "Exporta/Importa Dados CSV"
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

DEFINE VARIABLE c-des-deposito AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 10.5.

DEFINE RECTANGLE rt-temp-qt-seg
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53 BY 4.

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "Excluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon1 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brPV FOR 
      tt-int-item-estab-depos-pv SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brPV
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPV wMaintenance _STRUCTURED
  QUERY brPV NO-LOCK DISPLAY
      tt-int-item-estab-depos-pv.ano FORMAT ">>>9":U
      tt-int-item-estab-depos-pv.quant-previsao-venda[1] COLUMN-LABEL "M¼s-1" FORMAT ">>>>,>>9.9999":U
      tt-int-item-estab-depos-pv.quant-previsao-venda[2] COLUMN-LABEL "M¼s-2" FORMAT ">>>>,>>9.9999":U
      tt-int-item-estab-depos-pv.quant-previsao-venda[3] COLUMN-LABEL "M¼s-3" FORMAT ">>>>,>>9.9999":U
      tt-int-item-estab-depos-pv.quant-previsao-venda[4] COLUMN-LABEL "M¼s-4" FORMAT ">>>>,>>9.9999":U
      tt-int-item-estab-depos-pv.quant-previsao-venda[5] COLUMN-LABEL "M¼s-5" FORMAT ">>>>,>>9.9999":U
      tt-int-item-estab-depos-pv.quant-previsao-venda[6] COLUMN-LABEL "M¼s-6" FORMAT ">>>>,>>9.9999":U
      tt-int-item-estab-depos-pv.quant-previsao-venda[7] COLUMN-LABEL "M¼s-7" FORMAT ">>>>,>>9.9999":U
      tt-int-item-estab-depos-pv.quant-previsao-venda[8] COLUMN-LABEL "M¼s-8" FORMAT ">>>>,>>9.9999":U
      tt-int-item-estab-depos-pv.quant-previsao-venda[9] COLUMN-LABEL "M¼s-9" FORMAT ">>>>,>>9.9999":U
      tt-int-item-estab-depos-pv.quant-previsao-venda[10] COLUMN-LABEL "M¼s-10" FORMAT ">>>>,>>9.9999":U
      tt-int-item-estab-depos-pv.quant-previsao-venda[11] COLUMN-LABEL "M¼s-11" FORMAT ">>>>,>>9.9999":U
      tt-int-item-estab-depos-pv.quant-previsao-venda[12] COLUMN-LABEL "M¼s-12" FORMAT ">>>>,>>9.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.5
         FONT 1 FIT-LAST-COLUMN.


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
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorr¼ncia"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c½pia da ocorr¼ncia corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorr¼ncia corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorr¼ncia corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz altera»„es"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela altera»„es"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma altera»„es"
     btExcel AT ROW 1.13 COL 64 HELP
          "Exporta»’o/Importa»’o" WIDGET-ID 14
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat½rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-int-item-estab-depos.cod-estabel AT ROW 3 COL 23 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-des-estabel AT ROW 3 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     tt-int-item-estab-depos.cod-depos AT ROW 4 COL 23 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-des-deposito AT ROW 4 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     tt-int-item-estab-depos.it-codigo AT ROW 5 COL 23 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 13.29 BY .88
     c-des-item AT ROW 5 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-int-item-estab-depos.classif-abc AT ROW 1.5 COL 21 COLON-ALIGNED WIDGET-ID 56 FORMAT "X"
          VIEW-AS FILL-IN 
          SIZE 3.14 BY .88
     tt-int-item-estab-depos.log-estoq-minimo AT ROW 3 COL 23 WIDGET-ID 52
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .88
     tt-int-item-estab-depos.estoque-minimo AT ROW 3 COL 55 COLON-ALIGNED WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-int-item-estab-depos.quant-segur AT ROW 5 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-int-item-estab-depos.tipo-est-seg AT ROW 5.13 COL 32 NO-LABEL WIDGET-ID 36
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Quantidade", 1,
"Tempo", 2
          SIZE 14.72 BY 1.54
     tt-int-item-estab-depos.tempo-segur AT ROW 6 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     tt-int-item-estab-depos.politica AT ROW 7 COL 30 COLON-ALIGNED WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     "Tipo Estoq Segur" VIEW-AS TEXT
          SIZE 13 BY .63 AT ROW 4 COL 25 WIDGET-ID 40
     rt-temp-qt-seg AT ROW 4.25 COL 23 WIDGET-ID 32
     RECT-34 AT ROW 1 COL 1 WIDGET-ID 46
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.25
         SIZE 84.43 BY 10.6
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     brPV AT ROW 1.75 COL 2 WIDGET-ID 300
     btAddSon1 AT ROW 10.33 COL 2 WIDGET-ID 48
     btUpdateSon1 AT ROW 10.33 COL 12 WIDGET-ID 54
     btDeleteSon1 AT ROW 10.33 COL 22 WIDGET-ID 56
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.25
         SIZE 84.43 BY 10.6
         FONT 1 WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-int-item-estab-depos T "?" NO-UNDO mgintelbras int-item-estab-depos
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-int-item-estab-depos-pv T "?" NO-UNDO mgintelbras int-item-estab-depos-pv
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
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
/* SETTINGS FOR FILL-IN c-des-deposito IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos.classif-abc IN FRAME fPage1
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos.estoque-minimo IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos.quant-segur IN FRAME fPage1
   2 3                                                                  */
/* SETTINGS FOR FILL-IN tt-int-item-estab-depos.tempo-segur IN FRAME fPage1
   2 3                                                                  */
/* SETTINGS FOR RADIO-SET tt-int-item-estab-depos.tipo-est-seg IN FRAME fPage1
   2 3                                                                  */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brPV 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPV
/* Query rebuild information for BROWSE brPV
     _TblList          = "Temp-Tables.tt-int-item-estab-depos-pv"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-int-item-estab-depos-pv.ano
     _FldNameList[2]   > Temp-Tables.tt-int-item-estab-depos-pv.quant-previsao-venda[1]
"tt-int-item-estab-depos-pv.quant-previsao-venda[1]" "M¼s-1" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-int-item-estab-depos-pv.quant-previsao-venda[2]
"tt-int-item-estab-depos-pv.quant-previsao-venda[2]" "M¼s-2" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-int-item-estab-depos-pv.quant-previsao-venda[3]
"tt-int-item-estab-depos-pv.quant-previsao-venda[3]" "M¼s-3" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-int-item-estab-depos-pv.quant-previsao-venda[4]
"tt-int-item-estab-depos-pv.quant-previsao-venda[4]" "M¼s-4" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-int-item-estab-depos-pv.quant-previsao-venda[5]
"tt-int-item-estab-depos-pv.quant-previsao-venda[5]" "M¼s-5" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-int-item-estab-depos-pv.quant-previsao-venda[6]
"tt-int-item-estab-depos-pv.quant-previsao-venda[6]" "M¼s-6" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-int-item-estab-depos-pv.quant-previsao-venda[7]
"tt-int-item-estab-depos-pv.quant-previsao-venda[7]" "M¼s-7" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-int-item-estab-depos-pv.quant-previsao-venda[8]
"tt-int-item-estab-depos-pv.quant-previsao-venda[8]" "M¼s-8" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-int-item-estab-depos-pv.quant-previsao-venda[9]
"tt-int-item-estab-depos-pv.quant-previsao-venda[9]" "M¼s-9" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-int-item-estab-depos-pv.quant-previsao-venda[10]
"tt-int-item-estab-depos-pv.quant-previsao-venda[10]" "M¼s-10" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-int-item-estab-depos-pv.quant-previsao-venda[11]
"tt-int-item-estab-depos-pv.quant-previsao-venda[11]" "M¼s-11" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tt-int-item-estab-depos-pv.quant-previsao-venda[12]
"tt-int-item-estab-depos-pv.quant-previsao-venda[12]" "M¼s-12" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brPV */
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMaintenance
ON CHOOSE OF btAddSon1 IN FRAME fPage2 /* Incluir */
DO:

    ASSIGN  rCurrentParent  = tt-int-item-estab-depos.r-Rowid
            rSon            = ?.
    {masterdetail/addson.i &ProgramSon="esp/cep/escep087a.w"
                           &PageNumber="2"}




END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMaintenance
ON CHOOSE OF btDeleteSon1 IN FRAME fPage2 /* Excluir */
DO:
    {masterdetail/deleteson.i &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcel wMaintenance
ON CHOOSE OF btExcel IN FRAME fpage0 /* Exporta/Importa */
DO:
    RUN esp/cep/escep087b.w.
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
    {method/zoomreposition.i &ProgramZoom="esp/cep/escep087-z01.w"}
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
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMaintenance
ON CHOOSE OF btUpdateSon1 IN FRAME fPage2 /* Alterar */
DO:
    IF AVAIL tt-int-item-estab-depos
    THEN DO:
        ASSIGN  rCurrentParent  = tt-int-item-estab-depos.r-Rowid
                rSon            = tt-int-item-estab-depos-pv.r-Rowid.

        {masterdetail/updateson.i &ProgramSon="esp/cep/escep087a.w"
                                  &PageNumber="2"}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-int-item-estab-depos.classif-abc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos.classif-abc wMaintenance
ON LEAVE OF tt-int-item-estab-depos.classif-abc IN FRAME fPage1 /* Classif.ABC */
DO:
    ASSIGN tt-int-item-estab-depos.classif-abc:SCREEN-VALUE = UPPER(tt-int-item-estab-depos.classif-abc:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-int-item-estab-depos.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos.cod-depos wMaintenance
ON F5 OF tt-int-item-estab-depos.cod-depos IN FRAME fpage0 /* Dep½sito */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc037.w"
                         &FieldZoom1="cod-deposito"
                         &FieldScreen1="tt-int-item-estab-depos.cod-depos"
                         &Frame1="fpage0"
                         &FieldZoom2="des-deposito"
                         &FieldScreen2="c-des-deposito"
                         &Frame2="fpage0"
                         &RunMethod=" "
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos.cod-depos wMaintenance
ON LEAVE OF tt-int-item-estab-depos.cod-depos IN FRAME fpage0 /* Dep½sito */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="hDBOWm-deposito"
      &KeyValue1="tt-int-item-estab-depos.cod-depos:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="des-deposito"
      &FieldScreen1="c-des-deposito"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos.cod-depos wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-int-item-estab-depos.cod-depos IN FRAME fpage0 /* Dep½sito */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-item-estab-depos.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos.cod-estabel wMaintenance
ON F5 OF tt-int-item-estab-depos.cod-estabel IN FRAME fpage0 /* Estabel */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc041.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="tt-int-item-estab-depos.cod-estabel"
                         &Frame1="fpage0"
                         &FieldZoom2="nom-estabel"
                         &FieldScreen2="c-des-estabel"
                         &Frame2="fpage0"
                         &RunMethod="RUN openQueryStatic IN hDBOWm-estabel (INPUT 'Main')."
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos.cod-estabel wMaintenance
ON LEAVE OF tt-int-item-estab-depos.cod-estabel IN FRAME fpage0 /* Estabel */
DO:
    ASSIGN tt-int-item-estab-depos.cod-estabel:SCREEN-VALUE IN FRAME fPage0 = UPPER(tt-int-item-estab-depos.cod-estabel:SCREEN-VALUE IN FRAME fPage0).
    {method/referencefields.i &HandleDBOLeave="hDBOWm-estabel"
                              &KeyValue1="tt-int-item-estab-depos.cod-estabel:SCREEN-VALUE IN FRAME fPage0"
                              &FieldName1="nom-estabel"
                              &FieldScreen1="c-des-estabel"
                              &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos.cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-int-item-estab-depos.cod-estabel IN FRAME fpage0 /* Estabel */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-item-estab-depos.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos.it-codigo wMaintenance
ON F5 OF tt-int-item-estab-depos.it-codigo IN FRAME fpage0 /* Item */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc044.w"
                         &FieldZoom1="cod-item"
                         &FieldScreen1="tt-int-item-estab-depos.it-codigo"
                         &Frame1="fPage0"
                         &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos.it-codigo wMaintenance
ON LEAVE OF tt-int-item-estab-depos.it-codigo IN FRAME fpage0 /* Item */
DO:
    {method/referencefields.i &HandleDBOLeave="h-bosc044"
                              &KeyValue1="tt-int-item-estab-depos.it-codigo:SCREEN-VALUE IN FRAME fPage0"
                              &FieldName1="des-item"
                              &FieldScreen1="c-des-item"
                              &Frame1="fPage0"} 
                              
    IF cAction = "ADD"
    THEN DO:
        FOR FIRST item-uni-estab
            WHERE item-uni-estab.cod-estabel    = tt-int-item-estab-depos.cod-estabel:SCREEN-VALUE IN FRAME fPage0
              AND item-uni-estab.it-codigo      = tt-int-item-estab-depos.it-codigo:SCREEN-VALUE IN FRAME fPage0.

            ASSIGN  tt-int-item-estab-depos.classif-abc :SCREEN-VALUE IN FRAME fPage1 = IF item-uni-estab.classif-abc = 1 THEN "A" ELSE IF item-uni-estab.classif-abc = 2 THEN "B" ELSE "C"
                    tt-int-item-estab-depos.politica    :SCREEN-VALUE IN FRAME fPage1 = ""
                    tt-int-item-estab-depos.tipo-est-seg:SCREEN-VALUE IN FRAME fPage1 = STRING(item-uni-estab.tipo-est-seg)
                    tt-int-item-estab-depos.quant-segur :SCREEN-VALUE IN FRAME fPage1 = STRING(item-uni-estab.quant-segur)
                    tt-int-item-estab-depos.tempo-segur :SCREEN-VALUE IN FRAME fPage1 = STRING(item-uni-estab.tempo-segur)
                    .
            APPLY "value-changed" TO tt-int-item-estab-depos.tipo-est-seg   IN FRAME fPage1.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-int-item-estab-depos.log-estoq-minimo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos.log-estoq-minimo wMaintenance
ON VALUE-CHANGED OF tt-int-item-estab-depos.log-estoq-minimo IN FRAME fPage1 /* Utiliza Estoque M­nimo? */
DO:

    ASSIGN  tt-int-item-estab-depos.estoque-minimo  :SENSITIVE = tt-int-item-estab-depos.log-estoq-minimo:CHECKED
            tt-int-item-estab-depos.quant-segur     :SENSITIVE = NOT tt-int-item-estab-depos.log-estoq-minimo:CHECKED
            tt-int-item-estab-depos.tempo-segur     :SENSITIVE = NOT tt-int-item-estab-depos.log-estoq-minimo:CHECKED
            tt-int-item-estab-depos.tipo-est-seg    :SENSITIVE = NOT tt-int-item-estab-depos.log-estoq-minimo:CHECKED.
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


&Scoped-define SELF-NAME tt-int-item-estab-depos.tipo-est-seg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-item-estab-depos.tipo-est-seg wMaintenance
ON VALUE-CHANGED OF tt-int-item-estab-depos.tipo-est-seg IN FRAME fPage1
DO:
    if  input frame {&frame-name} tt-int-item-estab-depos.tipo-est-seg = 1 then do with frame {&frame-name}:
        enable tt-int-item-estab-depos.quant-segur.
        disable tt-int-item-estab-depos.tempo-segur.
    end.
    else do with frame {&frame-name}:
        enable tt-int-item-estab-depos.tempo-segur.
        disable tt-int-item-estab-depos.quant-segur.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brPV
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L½gica para inicializa»’o do programam ---*/
{maintenance/mainblock.i}

tt-int-item-estab-depos.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-int-item-estab-depos.cod-depos  :LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-int-item-estab-depos.it-codigo  :LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

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
    
    IF VALID-HANDLE({&hDBOTable}) THEN 
        RUN DESTROY IN {&hDBOTable}.

    IF VALID-HANDLE(hDBOWm-estabel) THEN
       RUN DESTROY IN hDBOWm-estabel.    
    
    IF VALID-HANDLE(hDBOWm-deposito) THEN
        RUN DESTROY IN hDBOWm-deposito.    
        
    IF VALID-HANDLE(h-bosc044) THEN
        RUN DESTROY IN h-bosc044.    

    {method/showmessage.i3}

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
    APPLY "leave":U TO tt-int-item-estab-depos.cod-estabel   IN FRAME fPage0.
    APPLY "leave":U TO tt-int-item-estab-depos.cod-depos     IN FRAME fPage0.
    APPLY "leave":U TO tt-int-item-estab-depos.it-codigo     IN FRAME fPage0.

    IF AVAIL tt-int-item-estab-depos
    THEN DO:

        RUN openQueriesSon IN THIS-PROCEDURE.

    END.
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

    APPLY "value-changed" TO tt-int-item-estab-depos.log-estoq-minimo   IN FRAME fPage1.
    APPLY "value-changed" TO tt-int-item-estab-depos.tipo-est-seg       IN FRAME fPage1.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenance 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOParentHandle wMaintenance 
PROCEDURE getDBOParentHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER pDBOHandle  AS HANDLE  NO-UNDO.
    
    ASSIGN pDBOHandle = {&hDBOSon2}.
    //ASSIGN pDBOHandle = {&hDBOTable}.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOSonHandle wMaintenance 
PROCEDURE getDBOSonHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pSonPageNumber  AS HANDLE  NO-UNDO.
    DEFINE OUTPUT PARAMETER pDBOHandle      AS HANDLE  NO-UNDO.
    
    ASSIGN pDBOHandle = {&hDBOSon2}.
    //ASSIGN pDBOHandle = {&hDBOTable}.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParentRecord wMaintenance 
PROCEDURE getParentRecord :
/*------------------------------------------------------------------------------
  Purpose:     Retorna temp-table {&ttParent} com o registro corrente
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR {&ttTable}.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de Vÿ Para
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
    
    DEFINE VARIABLE c-cod-estabel    LIKE {&ttTable}.cod-estabel  NO-UNDO.
    DEFINE VARIABLE c-cod-depos      LIKE {&ttTable}.cod-depos    NO-UNDO.
    DEFINE VARIABLE c-it-codigo             LIKE {&ttTable}.it-codigo           NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-cod-estabel  AT ROW 1.21 COL 25.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 7 BY .88
        c-cod-depos    AT ROW 2.21 COL 25.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 7 BY .88
        c-it-codigo           AT ROW 3.21 COL 25.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 16 BY .88
        btGoToOK          AT ROW 4.63 COL 2.14
        btGoToCancel      AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Vÿ Para Estab X Depos X Item " FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "Vÿ_Para_<tabela>"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-estabel c-cod-depos c-it-codigo.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-cod-estabel , INPUT c-cod-depos, INPUT c-it-codigo).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Estab X Depos X Item":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-estabel c-cod-depos c-it-codigo btGoToOK btGoToCancel 
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
    
    /*:T--- Verifica se o DBO jÿ estÿ inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo/boes928.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes928.p YES}
        {btb/btb008za.i2 esbo/boes928.p '' {&hDBOTable}}
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE({&hDBOSon2}) OR
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "esbo/boes929.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes929.p YES}
        {btb/btb008za.i2 esbo/boes929.p '' {&hDBOSon2}}
    END.
    
    RUN openQueryStatic IN {&hDBOSon2} (INPUT "Main":U) NO-ERROR.
    
    IF NOT VALID-HANDLE(hDBOWm-estabel) THEN DO:
        {btb/btb008za.i1 scbo/bosc041.p YES}
        {btb/btb008za.i2 scbo/bosc041.p '' hDBOWm-estabel}
    END.
    RUN openQueryStatic   IN hDBOWm-estabel (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(hDBOWm-deposito) THEN DO:
        {btb/btb008za.i1 scbo/bosc037.p YES}
        {btb/btb008za.i2 scbo/bosc037.p '' hDBOWm-deposito}
    END.
    RUN openQueryStatic   IN hDBOWm-deposito (INPUT "Main":U) NO-ERROR.

      /*--- Verifica se o DBO jÙ estÙ inicializado ---*/
    IF NOT VALID-HANDLE(h-bosc044) OR
       h-bosc044:TYPE <> "PROCEDURE":U OR
       h-bosc044:FILE-NAME <> "scbo/bosc044.p":U THEN DO:
       {btb/btb008za.i1 scbo/bosc044.p YES}
       {btb/btb008za.i2 scbo/bosc044.p '' h-bosc044} 
    END.

    RUN openQueryStatic IN h-bosc044 (INPUT "MAIN":U) NO-ERROR.

    ASSIGN  brPV        :SENSITIVE IN FRAME fPage2 = YES
            btAddSon1   :SENSITIVE IN FRAME fPage2 = YES
            btUpdateSon1:SENSITIVE IN FRAME fPage2 = YES
            btDeleteSon1:SENSITIVE IN FRAME fPage2 = YES
            btExcel     :SENSITIVE IN FRAME fPage0 = YES.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMaintenance 
PROCEDURE openQueriesSon :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN retornaItemEstabDepoPV IN {&hDBOSon2} (   INPUT tt-int-item-estab-depos.cod-estabel,
                                                  INPUT tt-int-item-estab-depos.cod-depos, 
                                                  INPUT tt-int-item-estab-depos.it-codigo,         
                                                  OUTPUT TABLE tt-int-item-estab-depos-pv).

    {&OPEN-QUERY-brPV}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionRecordSon wMaintenance 
PROCEDURE repositionRecordSon :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona DBO filho atravýs de um rowid
  Parameters:  recebe rowid
               recebe nßmero da p˜gina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid      AS ROWID   NO-UNDO.
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    DEFINE VARIABLE iRepositionPageNumber AS INTEGER   NO-UNDO.
    DEFINE VARIABLE rRepositionSon        AS ROWID     NO-UNDO.

    /*--- Seta vari˜vel iRepositionPageNumber com o nßmero da p˜gina na qual
          o browse filho ser˜ reposicionado ---*/
    /*--- Seta vari˜vel rRepositionSon com o rowid a ser reposicionado no 
          browse filho ---*/
    ASSIGN iRepositionPageNumber = pPageNumber
           rRepositionSon        = pRowid.
    
    /*--- Atualiza browse filho mas somente da p˜gina iRepositionPageNumber ---*/
    RUN openQueriesSon IN THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


