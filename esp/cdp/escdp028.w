&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-crm-un-cli-tb-preco NO-UNDO LIKE crm-un-cli-tb-preco
       field r-rowid as rowid
       field selecionado as character.
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
{include/i-prgvrs.i ESCDP028 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP028
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Relacionam.

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
DEFINE VARIABLE {&hDBOTable}       AS HANDLE                              NO-UNDO.
DEFINE VARIABLE wh-pesquisa-un     AS HANDLE                              NO-UNDO.
DEFINE VARIABLE c-nm-emitente      AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-ds-tabpre        AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-cond-pagto       AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-selecionado      AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE r-row-table        AS ROWID                               NO-UNDO.
DEFINE VARIABLE i-cod-emitente-ini LIKE crm-un-cli-tb-preco.cod-emitente  NO-UNDO.
DEFINE VARIABLE i-cod-emitente-fim LIKE crm-un-cli-tb-preco.cod-emitente  NO-UNDO.
DEFINE VARIABLE c-nr-tabpre-ini    LIKE crm-un-cli-tb-preco.nr-tabpre     NO-UNDO.
DEFINE VARIABLE c-nr-tabpre-fim    LIKE crm-un-cli-tb-preco.nr-tabpre     NO-UNDO.


DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl   AS HANDLE      NO-UNDO.
DEFINE                   VARIABLE wh-pesquisa      AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta       AS LOGICAL.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_unid_negoc AS CHARACTER   NO-UNDO.

/* Definicao da Temp-tables usadas no programa ESCRM001B.p */
{esp/crm/escrm001b.i}

DEFINE BUFFER bf-tt-unid-negoc FOR tt-unid-negoc.

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
&Scoped-define INTERNAL-TABLES tt-crm-un-cli-tb-preco

/* Definitions for BROWSE brSon                                         */
&Scoped-define FIELDS-IN-QUERY-brSon ~
fnSelecao(tt-crm-un-cli-tb-preco.selecionado) @ c-selecionado ~
tt-crm-un-cli-tb-preco.cod-emitente ~
fnNmEmitente(tt-crm-un-cli-tb-preco.cod-emitente) @ c-nm-emitente ~
tt-crm-un-cli-tb-preco.nr-tabpre ~
fnDsTabPreco(tt-crm-un-cli-tb-preco.nr-tabpre) @ c-ds-tabpre ~
fnCondPagto(tt-crm-un-cli-tb-preco.cod-cond-pag) @ c-cond-pagto ~
tt-crm-un-cli-tb-preco.dt-vigencia-ini ~
tt-crm-un-cli-tb-preco.dt-vigencia-fim 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon 
&Scoped-define QUERY-STRING-brSon FOR EACH tt-crm-un-cli-tb-preco NO-LOCK ~
    BY tt-crm-un-cli-tb-preco.dt-vigencia-ini
&Scoped-define OPEN-QUERY-brSon OPEN QUERY brSon FOR EACH tt-crm-un-cli-tb-preco NO-LOCK ~
    BY tt-crm-un-cli-tb-preco.dt-vigencia-ini.
&Scoped-define TABLES-IN-QUERY-brSon tt-crm-un-cli-tb-preco
&Scoped-define FIRST-TABLE-IN-QUERY-brSon tt-crm-un-cli-tb-preco


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
btSave btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-unid-comerc.cd-unid-comerc ~
tt-unid-comerc.ds-unid-comerc 
&Scoped-define DISPLAYED-TABLES tt-unid-comerc
&Scoped-define FIRST-DISPLAYED-TABLE tt-unid-comerc


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCondPagto wMaintenance 
FUNCTION fnCondPagto RETURNS CHARACTER
  ( pCod-cond-pag AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDsTabPreco wMaintenance 
FUNCTION fnDsTabPreco RETURNS CHARACTER
  ( pNr-tabpre AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNmEmitente wMaintenance 
FUNCTION fnNmEmitente RETURNS CHARACTER
  ( pCod-emitente AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSelecao wMaintenance 
FUNCTION fnSelecao RETURNS CHARACTER
  ( pSelecionado AS CHARACTER )  FORWARD.

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

DEFINE BUTTON btDesmarcarTodos 
     LABEL "Desmarcar Todos" 
     SIZE 14 BY 1.

DEFINE BUTTON btMarcarTodos 
     LABEL "Marcar Todos" 
     SIZE 14 BY 1.

DEFINE BUTTON btSelecao 
     LABEL "Sele‡Æo" 
     SIZE 9.57 BY 1.

DEFINE BUTTON btUpdateSon 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon FOR 
      tt-crm-un-cli-tb-preco SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon wMaintenance _STRUCTURED
  QUERY brSon NO-LOCK DISPLAY
      fnSelecao(tt-crm-un-cli-tb-preco.selecionado) @ c-selecionado COLUMN-LABEL "*" FORMAT "x(2)":U
      tt-crm-un-cli-tb-preco.cod-emitente COLUMN-LABEL "Cliente" FORMAT ">>>>>>>>9":U
            WIDTH 8.43
      fnNmEmitente(tt-crm-un-cli-tb-preco.cod-emitente) @ c-nm-emitente COLUMN-LABEL "Nome" FORMAT "x(50)":U
            WIDTH 18.43
      tt-crm-un-cli-tb-preco.nr-tabpre FORMAT "x(08)":U WIDTH 12.43
      fnDsTabPreco(tt-crm-un-cli-tb-preco.nr-tabpre) @ c-ds-tabpre COLUMN-LABEL "Descri‡Æo" FORMAT "x(50)":U
            WIDTH 23.43
      fnCondPagto(tt-crm-un-cli-tb-preco.cod-cond-pag) @ c-cond-pagto COLUMN-LABEL "Condi‡Æo Pagto" FORMAT "x(100)":U
            WIDTH 16
      tt-crm-un-cli-tb-preco.dt-vigencia-ini FORMAT "99/99/9999":U
            WIDTH 14.29
      tt-crm-un-cli-tb-preco.dt-vigencia-fim FORMAT "99/99/9999":U
            WIDTH 13.72
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
     btSelecao AT ROW 10.33 COL 67 WIDGET-ID 10
     btMarcarTodos AT ROW 10.33 COL 76.72 WIDGET-ID 6
     btDesmarcarTodos AT ROW 10.33 COL 90.86 WIDGET-ID 4
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
      TABLE: tt-crm-un-cli-tb-preco T "?" NO-UNDO mgesp crm-un-cli-tb-preco
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          field selecionado as character
      END-FIELDS.
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
         TITLE              = "Unidade de Neg¢cio x Cliente x Tabela de Pre‡o"
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
     _TblList          = "Temp-Tables.tt-crm-un-cli-tb-preco"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-crm-un-cli-tb-preco.dt-vigencia-ini|yes"
     _FldNameList[1]   > "_<CALC>"
"fnSelecao(tt-crm-un-cli-tb-preco.selecionado) @ c-selecionado" "*" "x(2)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-crm-un-cli-tb-preco.cod-emitente
"tt-crm-un-cli-tb-preco.cod-emitente" "Cliente" ? "integer" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fnNmEmitente(tt-crm-un-cli-tb-preco.cod-emitente) @ c-nm-emitente" "Nome" "x(50)" ? ? ? ? ? ? ? no ? no no "18.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-crm-un-cli-tb-preco.nr-tabpre
"tt-crm-un-cli-tb-preco.nr-tabpre" ? ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fnDsTabPreco(tt-crm-un-cli-tb-preco.nr-tabpre) @ c-ds-tabpre" "Descri‡Æo" "x(50)" ? ? ? ? ? ? ? no ? no no "23.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fnCondPagto(tt-crm-un-cli-tb-preco.cod-cond-pag) @ c-cond-pagto" "Condi‡Æo Pagto" "x(100)" ? ? ? ? ? ? ? no ? no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-crm-un-cli-tb-preco.dt-vigencia-ini
"tt-crm-un-cli-tb-preco.dt-vigencia-ini" ? ? "date" ? ? ? ? ? ? no ? no no "14.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-crm-un-cli-tb-preco.dt-vigencia-fim
"tt-crm-un-cli-tb-preco.dt-vigencia-fim" ? ? "date" ? ? ? ? ? ? no ? no no "13.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON END-ERROR OF wMaintenance /* Unidade de Neg¢cio x Cliente x Tabela de Pre‡o */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance /* Unidade de Neg¢cio x Cliente x Tabela de Pre‡o */
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
    IF  AVAIL tt-crm-un-cli-tb-preco THEN DO:
        IF  tt-crm-un-cli-tb-preco.selecionado = "*" THEN
            ASSIGN tt-crm-un-cli-tb-preco.selecionado = "".
        ELSE
            ASSIGN tt-crm-un-cli-tb-preco.selecionado = "*".

        DISPLAY tt-crm-un-cli-tb-preco.selecionado @ c-selecionado
            WITH BROWSE brSon.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon wMaintenance
ON CHOOSE OF btAddSon IN FRAME fPage1 /* Incluir */
DO:
    ASSIGN INPUT FRAME fPage0 tt-unid-comerc.cd-unid-comerc.

    ASSIGN r-row-table = ?.
    RUN esp/cdp/escdp028a.w (INPUT "Create":U,
                             INPUT tt-unid-comerc.cd-unid-comerc,
                             INPUT-OUTPUT r-row-table).

    RUN pi-atualizar-browse IN THIS-PROCEDURE.
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

    ASSIGN r-row-table = IF AVAIL tt-crm-un-cli-tb-preco THEN tt-crm-un-cli-tb-preco.r-rowid ELSE ?.
    RUN esp/cdp/escdp028a.w (INPUT "Copy":U,
                             INPUT tt-unid-comerc.cd-unid-comerc,
                             INPUT-OUTPUT r-row-table).

    RUN pi-atualizar-browse IN THIS-PROCEDURE.
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
        FOR EACH  tt-crm-un-cli-tb-preco EXCLUSIVE-LOCK
            WHERE tt-crm-un-cli-tb-preco.selecionado = "*":
            FIND FIRST crm-un-cli-tb-preco EXCLUSIVE-LOCK
                WHERE  ROWID(crm-un-cli-tb-preco) = tt-crm-un-cli-tb-preco.r-rowid NO-ERROR.
            IF  AVAIL  crm-un-cli-tb-preco THEN
                DELETE crm-un-cli-tb-preco.

            DELETE tt-crm-un-cli-tb-preco.
        END.
    END.

    ASSIGN r-row-table = ?.
    RUN pi-atualizar-browse IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDesmarcarTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesmarcarTodos wMaintenance
ON CHOOSE OF btDesmarcarTodos IN FRAME fPage1 /* Desmarcar Todos */
DO:
    FOR EACH tt-crm-un-cli-tb-preco EXCLUSIVE-LOCK:
        ASSIGN tt-crm-un-cli-tb-preco.selecionado = "".
    END.

    {&OPEN-QUERY-brSon}
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


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btMarcarTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMarcarTodos wMaintenance
ON CHOOSE OF btMarcarTodos IN FRAME fPage1 /* Marcar Todos */
DO:
    FOR EACH tt-crm-un-cli-tb-preco EXCLUSIVE-LOCK:
        ASSIGN tt-crm-un-cli-tb-preco.selecionado = "*".
    END.

    {&OPEN-QUERY-brSon}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao wMaintenance
ON CHOOSE OF btSelecao IN FRAME fPage1 /* Sele‡Æo */
DO:
    ASSIGN r-row-table = ?.
    RUN esp/cdp/escdp028b.w (INPUT-OUTPUT i-cod-emitente-ini,
                             INPUT-OUTPUT i-cod-emitente-fim,
                             INPUT-OUTPUT c-nr-tabpre-ini,
                             INPUT-OUTPUT c-nr-tabpre-fim).

    RUN pi-atualizar-browse IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
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

    ASSIGN r-row-table = IF AVAIL tt-crm-un-cli-tb-preco THEN tt-crm-un-cli-tb-preco.r-rowid ELSE ?.
    RUN esp/cdp/escdp028a.w (INPUT "Update":U,
                             INPUT tt-unid-comerc.cd-unid-comerc,
                             INPUT-OUTPUT r-row-table).

    RUN pi-atualizar-browse IN THIS-PROCEDURE.
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

    ASSIGN r-row-table        = ?
           i-cod-emitente-ini = 0
           i-cod-emitente-fim = 999999999
           c-nr-tabpre-ini    = ""
           c-nr-tabpre-fim    = "ZZZZZZZZ".

    RUN pi-atualizar-browse IN THIS-PROCEDURE.

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
        WITH FRAME fPage0.

    ENABLE brSon
           btAddSon
           btSelecao
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualizar-browse wMaintenance 
PROCEDURE pi-atualizar-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-crm-un-cli-tb-preco.
    FOR EACH  crm-un-cli-tb-preco NO-LOCK
        WHERE crm-un-cli-tb-preco.cd-unid-negoc  = INPUT FRAME fPage0 tt-unid-comerc.cd-unid-comerc
        AND   crm-un-cli-tb-preco.cod-emitente  >= i-cod-emitente-ini
        AND   crm-un-cli-tb-preco.cod-emitente  <= i-cod-emitente-fim
        AND   crm-un-cli-tb-preco.nr-tabpre     >= c-nr-tabpre-ini
        AND   crm-un-cli-tb-preco.nr-tabpre     <= c-nr-tabpre-fim:
        CREATE tt-crm-un-cli-tb-preco.
        BUFFER-COPY crm-un-cli-tb-preco TO tt-crm-un-cli-tb-preco.
        ASSIGN tt-crm-un-cli-tb-preco.r-rowid = ROWID(crm-un-cli-tb-preco).

        /* Necess rio pois a tabela do browse ‚ a Temp-Table,
           e o rowid da TT ‚ diferente do rowid da tabela */
        IF  r-row-table = ROWID(crm-un-cli-tb-preco) THEN
            ASSIGN r-row-table = ROWID(tt-crm-un-cli-tb-preco).
    END.

    {&OPEN-QUERY-brSon}

    IF  r-row-table <> ? THEN
        REPOSITION brSon TO ROWID r-row-table.

    IF  CAN-FIND(FIRST tt-crm-un-cli-tb-preco) THEN DO:
        ENABLE btCopySon
               btUpdateSon
               btDeleteSon
               btMarcarTodos
               btDesmarcarTodos
            WITH FRAME fPage1.
    END.
    ELSE DO:
        DISABLE btCopySon
                btUpdateSon
                btDeleteSon
                btMarcarTodos
                btDesmarcarTodos
            WITH FRAME fPage1.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCondPagto wMaintenance 
FUNCTION fnCondPagto RETURNS CHARACTER
  ( pCod-cond-pag AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST cond-pagto NO-LOCK
        WHERE  cond-pagto.cod-cond-pag = pCod-cond-pag NO-ERROR.

    ASSIGN c-cond-pagto = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "".

    RETURN c-cond-pagto.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNmEmitente wMaintenance 
FUNCTION fnNmEmitente RETURNS CHARACTER
  ( pCod-emitente AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cod-emitente = pCod-emitente NO-ERROR.

    ASSIGN c-nm-emitente = IF AVAIL emitente THEN emitente.nome-emit ELSE "".

    RETURN c-nm-emitente.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSelecao wMaintenance 
FUNCTION fnSelecao RETURNS CHARACTER
  ( pSelecionado AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    ASSIGN c-selecionado = pSelecionado.

    RETURN c-selecionado.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

