&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttint-cond-pag-cli NO-UNDO LIKE int-cond-pag-cli
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttint-cond-pag-cli-det NO-UNDO LIKE int-cond-pag-cli-det
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
{include/i-prgvrs.i ESACR070 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          ESACR070
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

&GLOBAL-DEFINE ttParent         ttint-cond-pag-cli
&GLOBAL-DEFINE hDBOParent       HDBOttint-cond-pag-cli
&GLOBAL-DEFINE DBOParentTable   int-cond-pag-cli
&GLOBAL-DEFINE DBOParentDestroy NO

&GLOBAL-DEFINE ttSon1           ttint-cond-pag-cli-det
&GLOBAL-DEFINE hDBOSon1         HDBOttint-cond-pag-cli-det
&GLOBAL-DEFINE DBOSon1Table     int-cond-pag-cli-det
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE page0Fields      ttint-cond-pag-cli.cod-emitente c-descricao tg-grupo tg-prazo rs-tipo 
                                
&GLOBAL-DEFINE page1Browse      brSon1  

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.

DEFINE VARIABLE c-desc-condicao  AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE c-usuar-impl     AS CHAR                                    NO-UNDO.
DEFINE VARIABLE i-cod-emit       LIKE ttint-cond-pag-cli-det.cod-emitente   NO-UNDO.
DEFINE VARIABLE i-cod-cond-pagto LIKE ttint-cond-pag-cli-det.cod-cond-pagto NO-UNDO.

DEF BUFFER b_histor_clien FOR histor_clien.

DEF NEW GLOBAL SHARED VAR lg-esacr070-acao AS CHAR NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE g-esacr070-cliente AS INTEGER NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ttint-cond-pag-cli-det

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttint-cond-pag-cli-det.cod-cond-pagto ~
fnDesc (ttint-cond-pag-cli-det.cod-cond-pag) @ c-desc-condicao ~
ttint-cond-pag-cli-det.dt-ini-valid ttint-cond-pag-cli-det.dt-fim-valid ~
fnUsuar(ttint-cond-pag-cli-det.observacao) @ c-usuar-impl ttint-cond-pag-cli-det.observacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttint-cond-pag-cli-det NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttint-cond-pag-cli-det NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 ttint-cond-pag-cli-det
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttint-cond-pag-cli-det


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttint-cond-pag-cli.cod-emitente 
&Scoped-define ENABLED-TABLES ttint-cond-pag-cli
&Scoped-define FIRST-ENABLED-TABLE ttint-cond-pag-cli
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-11 RECT-12 RECT-13 btFirst ~
btPrev btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete ~
btQueryJoins btReportsJoins btExit btHelp c-descricao tg-grupo tg-prazo ~
rs-tipo 
&Scoped-Define DISPLAYED-FIELDS ttint-cond-pag-cli.cod-emitente 
&Scoped-define DISPLAYED-TABLES ttint-cond-pag-cli
&Scoped-define FIRST-DISPLAYED-TABLE ttint-cond-pag-cli
&Scoped-Define DISPLAYED-OBJECTS c-descricao tg-grupo tg-prazo rs-tipo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDesc wMasterDetail 
FUNCTION fnDesc RETURNS CHARACTER
  ( i-cond-pagto AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUsuar wMasterDetail 
FUNCTION fnUsuar RETURNS CHARACTER
  ( c-observacao AS CHAR /* parameter-definitions */ )  FORWARD.

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
DEFINE VARIABLE tg-dia-1 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-10 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-11 AS LOGICAL INITIAL no 
     LABEL "11" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-12 AS LOGICAL INITIAL no 
     LABEL "12" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-13 AS LOGICAL INITIAL no 
     LABEL "13" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-14 AS LOGICAL INITIAL no 
     LABEL "14" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-15 AS LOGICAL INITIAL no 
     LABEL "15" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-16 AS LOGICAL INITIAL no 
     LABEL "16" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-17 AS LOGICAL INITIAL no 
     LABEL "17" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-18 AS LOGICAL INITIAL no 
     LABEL "18" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-19 AS LOGICAL INITIAL no 
     LABEL "19" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-2 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-20 AS LOGICAL INITIAL no 
     LABEL "20" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-21 AS LOGICAL INITIAL no 
     LABEL "21" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-22 AS LOGICAL INITIAL no 
     LABEL "22" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-23 AS LOGICAL INITIAL no 
     LABEL "23" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-24 AS LOGICAL INITIAL no 
     LABEL "24" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-25 AS LOGICAL INITIAL no 
     LABEL "25" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-26 AS LOGICAL INITIAL no 
     LABEL "26" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-27 AS LOGICAL INITIAL no 
     LABEL "27" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-28 AS LOGICAL INITIAL no 
     LABEL "28" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-29 AS LOGICAL INITIAL no 
     LABEL "29" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-3 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-30 AS LOGICAL INITIAL no 
     LABEL "30" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-31 AS LOGICAL INITIAL no 
     LABEL "31" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-4 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-5 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-6 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-7 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-8 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dia-9 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEF VAR l_segur_usuar AS LOG INIT NO NO-UNDO.

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

DEFINE VARIABLE rs-tipo AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Semana", 1,
"Dias Màs", 2,
"Nenhum", 3
     SIZE 9.14 BY 2.25 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 113 BY 2.25.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 113 BY 4.71.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 109 BY 2.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 114 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tg-grupo AS LOGICAL INITIAL no 
     LABEL "Utilizar Grupo Econìmico" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-prazo AS LOGICAL INITIAL no 
     LABEL "Prazo DDE" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

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
     SIZE 113 BY 8.5.

DEFINE VARIABLE tg-1 AS LOGICAL INITIAL no 
     LABEL "Segunda" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .83 NO-UNDO.

DEFINE VARIABLE tg-2 AS LOGICAL INITIAL no 
     LABEL "Teráa" 
     VIEW-AS TOGGLE-BOX
     SIZE 7 BY .83 NO-UNDO.

DEFINE VARIABLE tg-3 AS LOGICAL INITIAL no 
     LABEL "Quarta" 
     VIEW-AS TOGGLE-BOX
     SIZE 8 BY .83 NO-UNDO.

DEFINE VARIABLE tg-4 AS LOGICAL INITIAL no 
     LABEL "Quinta" 
     VIEW-AS TOGGLE-BOX
     SIZE 8 BY .83 NO-UNDO.

DEFINE VARIABLE tg-5 AS LOGICAL INITIAL no 
     LABEL "Sexta" 
     VIEW-AS TOGGLE-BOX
     SIZE 8 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttint-cond-pag-cli-det SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      ttint-cond-pag-cli-det.cod-cond-pagto FORMAT ">>9":U
      fnDesc (ttint-cond-pag-cli-det.cod-cond-pag) @ c-desc-condicao COLUMN-LABEL " Descriá∆o" FORMAT "x(80)":U
            WIDTH 52.86
      ttint-cond-pag-cli-det.dt-ini-valid FORMAT "99/99/9999":U
      ttint-cond-pag-cli-det.dt-fim-valid FORMAT "99/99/9999":U
      fnUsuar (ttint-cond-pag-cli-det.observacao) @ c-usuar-impl COLUMN-LABEL "Usu†rio Impl" FORMAT "x(12)":U
      ttint-cond-pag-cli-det.observacao COLUMN-LABEL "Observaá∆o" FORMAT "x(50)":U
            WIDTH 60
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 109 BY 6
         FONT 2
         TITLE "Condiá‰es de Pagamento relacionadas" ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
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
     btAdd AT ROW 1.13 COL 37.57 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 41.57 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 45.72 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 49.72 HELP
          "Elimina ocorrància corrente"
     btQueryJoins AT ROW 1.13 COL 98.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 102.29 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 106.29 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 110.29 HELP
          "Ajuda"
     ttint-cond-pag-cli.cod-emitente AT ROW 3.42 COL 8 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 9.57 BY .88
     c-descricao AT ROW 3.42 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     tg-grupo AT ROW 3.42 COL 62.14 WIDGET-ID 8
     tg-prazo AT ROW 5.75 COL 4 WIDGET-ID 10
     rs-tipo AT ROW 7.17 COL 4.86 NO-LABEL WIDGET-ID 168
     "< Regras de Vencimento >" VIEW-AS TEXT
          SIZE 18 BY .54 AT ROW 5.25 COL 46.86 WIDGET-ID 172
     rtToolBar AT ROW 1 COL 1
     RECT-11 AT ROW 2.75 COL 2 WIDGET-ID 164
     RECT-12 AT ROW 5.5 COL 1.86 WIDGET-ID 166
     RECT-13 AT ROW 6.92 COL 4 WIDGET-ID 174
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 114.43 BY 18.33
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.5 COL 3
     btAddSon1 AT ROW 7.96 COL 3
     btCopySon1 AT ROW 7.96 COL 13
     btUpdateSon1 AT ROW 7.96 COL 13
     btDeleteSon1 AT ROW 7.96 COL 23
     RECT-14 AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 10.63
         SIZE 113 BY 8.63
         FONT 1.

DEFINE FRAME fSemana
     tg-1 AT ROW 1.5 COL 3 WIDGET-ID 20
     tg-2 AT ROW 1.5 COL 14 WIDGET-ID 22
     tg-3 AT ROW 1.5 COL 22.57 WIDGET-ID 24
     tg-4 AT ROW 1.5 COL 32 WIDGET-ID 26
     tg-5 AT ROW 1.5 COL 42 WIDGET-ID 28
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 17.29 ROW 7.46
         SIZE 52 BY 1.75
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fMes
     tg-dia-1 AT ROW 1.83 COL 2 WIDGET-ID 30
     tg-dia-2 AT ROW 1.83 COL 5 WIDGET-ID 34
     tg-dia-3 AT ROW 1.83 COL 8 WIDGET-ID 38
     tg-dia-4 AT ROW 1.83 COL 11 WIDGET-ID 40
     tg-dia-5 AT ROW 1.83 COL 14 WIDGET-ID 42
     tg-dia-6 AT ROW 1.83 COL 17 WIDGET-ID 44
     tg-dia-7 AT ROW 1.83 COL 20 WIDGET-ID 46
     tg-dia-8 AT ROW 1.83 COL 23 WIDGET-ID 52
     tg-dia-9 AT ROW 1.83 COL 26 WIDGET-ID 54
     tg-dia-10 AT ROW 1.83 COL 29 WIDGET-ID 56
     tg-dia-11 AT ROW 1.83 COL 32 WIDGET-ID 58
     tg-dia-12 AT ROW 1.83 COL 35 WIDGET-ID 60
     tg-dia-13 AT ROW 1.83 COL 38 WIDGET-ID 48
     tg-dia-14 AT ROW 1.83 COL 41 WIDGET-ID 50
     tg-dia-15 AT ROW 1.83 COL 44 WIDGET-ID 72
     tg-dia-16 AT ROW 1.83 COL 47 WIDGET-ID 74
     tg-dia-17 AT ROW 1.83 COL 50 WIDGET-ID 62
     tg-dia-18 AT ROW 1.83 COL 53 WIDGET-ID 64
     tg-dia-19 AT ROW 1.83 COL 56 WIDGET-ID 66
     tg-dia-20 AT ROW 1.83 COL 59 WIDGET-ID 68
     tg-dia-21 AT ROW 1.83 COL 62 WIDGET-ID 70
     tg-dia-22 AT ROW 1.83 COL 65 WIDGET-ID 76
     tg-dia-23 AT ROW 1.83 COL 68 WIDGET-ID 78
     tg-dia-24 AT ROW 1.83 COL 71 WIDGET-ID 80
     tg-dia-25 AT ROW 1.83 COL 74 WIDGET-ID 82
     tg-dia-26 AT ROW 1.83 COL 77 WIDGET-ID 84
     tg-dia-27 AT ROW 1.83 COL 80 WIDGET-ID 86
     tg-dia-28 AT ROW 1.83 COL 83 WIDGET-ID 88
     tg-dia-29 AT ROW 1.83 COL 86 WIDGET-ID 90
     tg-dia-30 AT ROW 1.83 COL 88.72 WIDGET-ID 92
     tg-dia-31 AT ROW 1.83 COL 91.43 WIDGET-ID 94
     "08" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 23 WIDGET-ID 116
     "01" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 2 WIDGET-ID 100
     "09" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 26 WIDGET-ID 118
     "10" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 29 WIDGET-ID 120
     "16" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 47 WIDGET-ID 122
     "17" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 50 WIDGET-ID 124
     "22" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 65 WIDGET-ID 154
     "28" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 83 WIDGET-ID 146
     "30" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 88.72 WIDGET-ID 150
     "07" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 20 WIDGET-ID 114
     "31" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 91.43 WIDGET-ID 162
     "23" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 68 WIDGET-ID 156
     "18" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 53 WIDGET-ID 126
     "19" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 56 WIDGET-ID 128
     "20" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 59 WIDGET-ID 130
     "11" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 32 WIDGET-ID 132
     "12" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 35 WIDGET-ID 134
     "13" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 38 WIDGET-ID 136
     "14" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 41 WIDGET-ID 138
     "15" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 44 WIDGET-ID 140
     "26" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 77 WIDGET-ID 142
     "27" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 80 WIDGET-ID 144
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 17.29 ROW 7.46
         SIZE 94 BY 1.75
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fMes
     "21" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 62 WIDGET-ID 152
     "24" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 71 WIDGET-ID 158
     "29" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 86 WIDGET-ID 148
     "04" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 11 WIDGET-ID 108
     "25" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 74 WIDGET-ID 160
     "06" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 17 WIDGET-ID 112
     "03" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 8 WIDGET-ID 106
     "02" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 5 WIDGET-ID 104
     "05" VIEW-AS TEXT
          SIZE 2 BY .54 AT ROW 1.25 COL 14 WIDGET-ID 110
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 17.29 ROW 7.46
         SIZE 94 BY 1.75
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttint-cond-pag-cli T "?" NO-UNDO mgesp int-cond-pag-cli
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttint-cond-pag-cli-det T "?" NO-UNDO mgesp int-cond-pag-cli-det
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
         HEIGHT             = 18.38
         WIDTH              = 115
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
ASSIGN FRAME fMes:FRAME = FRAME fPage0:HANDLE
       FRAME fPage1:FRAME = FRAME fPage0:HANDLE
       FRAME fSemana:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fMes
   UNDERLINE                                                            */
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
ASSIGN 
       c-descricao:READ-ONLY IN FRAME fPage0        = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 RECT-14 fPage1 */
ASSIGN 
       btCopySon1:HIDDEN IN FRAME fPage1           = TRUE.

/* SETTINGS FOR FRAME fSemana
   UNDERLINE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.ttint-cond-pag-cli-det"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttint-cond-pag-cli-det.cod-cond-pagto
     _FldNameList[2]   > "_<CALC>"
"fnDesc (ttint-cond-pag-cli-det.cod-cond-pag) @ c-desc-condicao" " Descriá∆o" "x(80)" ? ? ? ? ? ? ? no ? no no "52.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.ttint-cond-pag-cli-det.dt-ini-valid
     _FldNameList[4]   = Temp-Tables.ttint-cond-pag-cli-det.dt-fim-valid
     _FldNameList[5]   > Temp-Tables.ttint-cond-pag-cli-det.observacao
"observacao" "Observaá∆o" "x(50)" "character" ? ? ? ? ? ? no "Observaáao" no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
    lg-esacr070-acao = "Inclui".
    RUN addRecord IN THIS-PROCEDURE (INPUT "esp/acr/esacr070A.w":U).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    {masterdetail/AddSon.i &ProgramSon="esp/acr/esacr070b.w"
                           &PageNumber="1"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    lg-esacr070-acao = "Copia".
    RUN copyRecord (INPUT "esp/acr/esacr070A.w":U). 
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

    FIND FIRST prog_dtsul
        WHERE prog_dtsul.cod_prog_dtsul = "esacr070a" NO-LOCK NO-ERROR.
    
    IF  AVAIL prog_dtsul THEN DO:
    
        FOR EACH usuar_grp_usuar NO-LOCK
            WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
            
            IF  NOT CAN-FIND(FIRST prog_dtsul_segur NO-LOCK
                             WHERE prog_dtsul_segur.cod_prog_dtsul = "esacr070a"
                             AND  (prog_dtsul_segur.cod_grp_usuar  = usuar_grp_usuar.cod_grp_usuar
                             OR    prog_dtsul_segur.cod_grp_usuar  = "*")) THEN DO:
    
                ASSIGN l_segur_usuar = NO.
            END.
            ELSE DO:
                ASSIGN l_segur_usuar = YES.
                LEAVE.
            END.
        END.
    
        IF  l_segur_usuar = NO THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "Usu†rio n∆o possui permiss∆o para acessar o programa esacr070a !":U).
            RETURN 'nok'.
        END.
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Programa esacr070a n∆o cadastrado no menu !":U).
        RETURN 'nok'.
    END.

    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    
    FIND FIRST prog_dtsul
        WHERE prog_dtsul.cod_prog_dtsul = "esacr070b" NO-LOCK NO-ERROR.
    
    IF  AVAIL prog_dtsul THEN DO:
    
        FOR EACH usuar_grp_usuar NO-LOCK
            WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
            
            IF  NOT CAN-FIND(FIRST prog_dtsul_segur NO-LOCK
                             WHERE prog_dtsul_segur.cod_prog_dtsul = "esacr070b"
                             AND  (prog_dtsul_segur.cod_grp_usuar  = usuar_grp_usuar.cod_grp_usuar
                             OR    prog_dtsul_segur.cod_grp_usuar  = "*")) THEN DO:
    
                ASSIGN l_segur_usuar = NO.
            END.
            ELSE DO:
                ASSIGN l_segur_usuar = YES.
                LEAVE.
            END.
        END.
    
        IF  l_segur_usuar = NO THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "Usu†rio n∆o possui permiss∆o para acessar o programa esacr070b !":U).
            RETURN 'nok'.
        END.
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Programa esacr070b n∆o cadastrado no menu !":U).
        RETURN 'nok'.
    END.

    ASSIGN i-cod-emit       = 0
           i-cod-cond-pagto = 0.

    IF  AVAIL ttint-cond-pag-cli-det THEN
        ASSIGN i-cod-emit       = ttint-cond-pag-cli-det.cod-emitente
               i-cod-cond-pagto = ttint-cond-pag-cli-det.cod-cond-pagto.

    {masterdetail/DeleteSon.i &PageNumber="1"}

    FIND FIRST int-cond-pag-cli-det
        WHERE int-cond-pag-cli-det.cod-emitente   = i-cod-emit
        AND   int-cond-pag-cli-det.cod-cond-pagto = i-cod-cond-pagto NO-LOCK NO-ERROR.

    IF  NOT AVAIL int-cond-pag-cli-det THEN DO:
        FIND FIRST emscad.cliente
            WHERE emscad.cliente.cod_empresa = "1"
            AND   emscad.cliente.cdn_cliente = i-cod-emit NO-LOCK NO-ERROR.

        IF  AVAIL emscad.cliente THEN DO:
            CREATE histor_clien. 
            ASSIGN histor_clien.cod_empresa      = emscad.cliente.cod_empresa
                   histor_clien.cdn_cliente      = emscad.cliente.cdn_cliente
                   histor_clien.dat_gerac_histor = TODAY
                   histor_clien.hra_gerac_histor = STRING(TIME,"hh:mm:ss")
                   histor_clien.cod_usuario      = v_cod_usuar_corren. 

            FIND LAST b_histor_clien NO-LOCK 
                WHERE b_histor_clien.cod_empresa = histor_clien.cod_empresa
                AND   b_histor_clien.cdn_cliente = histor_clien.cdn_cliente NO-ERROR.

            IF  AVAIL b_histor_clien THEN 
                ASSIGN histor_clien.num_seq_histor_clien = b_histor_clien.num_seq_histor_clien + 1.
            ELSE 
                ASSIGN histor_clien.num_seq_histor_clien = 1.

            ASSIGN histor_clien.des_abrev_histor_clien = "Condiá∆o de pagamento: " + string(i-cod-cond-pagto) + " exclu°da !".
                   histor_clien.des_histor_clien       = "Condiá∆o de pagamento: " + string(i-cod-cond-pagto) + " exclu°da (ESACR070) em "
                                                       + STRING(TODAY, "99/99/9999") + " pelo usu†rio "  + v_cod_usuar_corren + " ." .
        END.
    END.

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
    {method/ZoomReposition.i &ProgramZoom="eszoom/z01es904.w"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    lg-esacr070-acao = "Modifica".
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
&Scoped-define SELF-NAME rs-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo wMasterDetail
ON VALUE-CHANGED OF rs-tipo IN FRAME fPage0
DO:
    IF  AVAIL ttint-cond-pag-cli THEN
        RUN pi-mostra-frames (INPUT ttint-cond-pag-cli.vencto-fixo).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/MainBlock.i}
/*                                                                                                                */
/*     MESSAGE "MAIN"                                                                                             */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                         */
/*    IF  AVAIL ttint-cond-pag-cli THEN DO:                                                                       */
/*          FIND emitente NO-LOCK                                                                                 */
/*              WHERE emitente.cod-emitente = int(ttint-cond-pag-cli.cod-emitente:SCREEN-VALUE IN FRAME fpage0 )  */
/*                 NO-ERROR.                                                                                      */
/*          MESSAGE AVAIL ttint-cond-pag-cli                                                                      */
/*              VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                */
/*          IF  AVAIL emitente THEN                                                                               */
/*              ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = emitente.nome-emit.                             */
/*          ELSE                                                                                                  */
/*              ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = "N∆o encontrado...".                            */
/*                                                                                                                */
/*         RUN pi-mostra-frames (INPUT ttint-cond-pag-cli.vencto-fixo).                                           */
/*         RUN pi-carrega-campos.                                                                                 */
/*                                                                                                                */
/*     END.                                                                                                       */
/*                                                                                                                */
/*     MESSAGE "ttint-cond-pag-cli.cod-emitente: " ttint-cond-pag-cli.cod-emitente                                */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                     */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    IF  AVAIL ttint-cond-pag-cli THEN DO:                                                                     
          FIND emitente NO-LOCK                                                                               
              WHERE emitente.cod-emitente = int(ttint-cond-pag-cli.cod-emitente:SCREEN-VALUE IN FRAME fpage0 )
                 NO-ERROR.                                                                                   
                                                                 
          IF  AVAIL emitente THEN                                                                             
              ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = emitente.nome-emit.                           
          ELSE                                                                                                
              ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = "N∆o encontrado...".                          
                                                                                                              
         RUN pi-mostra-frames (INPUT ttint-cond-pag-cli.vencto-fixo).                                         
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

    IF  AVAIL ttint-cond-pag-cli THEN DO:  
    
          FIND emitente NO-LOCK                                                                               
              WHERE emitente.cod-emitente = int(ttint-cond-pag-cli.cod-emitente:SCREEN-VALUE IN FRAME fpage0 )
                 NO-ERROR.                                                                                   
                                                                 
          IF  AVAIL emitente THEN                                                                             
              ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = emitente.nome-emit.                           
          ELSE                                                                                                
              ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = "N∆o encontrado...".                          
                                                                                                              
         RUN pi-mostra-frames (INPUT ttint-cond-pag-cli.vencto-fixo).                                         
         RUN pi-carrega-campos.                                                                               
                                                                                                              
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
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

    DEFINE VARIABLE i-cod-emitente LIKE {&ttParent}.cod-emitente NO-UNDO.

    DEFINE FRAME fGoToRecord
        i-cod-emitente    AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE
             THREE-D SCROLLABLE TITLE "V† Para cliente" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-cod-emitente.

        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT i-cod-emitente).

        IF RETURN-VALUE = "NOK":U THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 27100,
                               INPUT "N∆o encontrado parametrizaá∆o para o cliente com c¢digo " + STRING(i-cod-emitente) + ". Deseja procurar pela matriz?").

            IF RETURN-VALUE = "YES" THEN DO:
                /*Busca emitente*/
                FIND FIRST emitente no-lock
                     WHERE emitente.cod-emitente = i-cod-emitente NO-ERROR.

                IF AVAIL emitente THEN DO:
                    /*busca matriz do emitente*/
                    FIND FIRST b-emitente NO-LOCK
                         WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-ERROR.

                    IF AVAIL b-emitente THEN DO:
                        RUN goToKey IN {&hDBOParent} (INPUT b-emitente.cod-emitente).
                        IF RETURN-VALUE = "NOK":U THEN DO:
                            RUN utp/ut-msgs.p (INPUT "show",
                                               INPUT 17006,
                                               INPUT "N∆o encontrado parametrizaá∆o para a matriz"). 
                            RETURN NO-APPLY.
                        END.
                    END.
                    ELSE 
                        RETURN NO-APPLY.
                END.
                ELSE 
                    RETURN NO-APPLY.
            END.
            ELSE 
                RETURN NO-APPLY.
        END.

        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "esbo/boes918.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes918.p YES}
        {btb/btb008za.i2 esbo/boes918.p '' {&hDBOParent}} 
    END.
    
    RUN setConstraintMain IN {&hDBOParent} NO-ERROR.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "esbo/boes919.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes919.p YES}
        {btb/btb008za.i2 esbo/boes919.p '' {&hDBOSon1}} 
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
                                   &Query="Emitente"
                                   &PageNumber="1"}
    HIDE FRAME fmes.
    HIDE FRAME fSemana.
    IF  AVAIL ttint-cond-pag-cli THEN DO:
    
        RUN pi-mostra-frames (INPUT ttint-cond-pag-cli.vencto-fixo).
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
    IF  NOT AVAIL ttint-cond-pag-cli THEN
        RETURN "OK".

    DO WITH FRAME fpage0:
        
        ASSIGN tg-grupo:CHECKED     = ttint-cond-pag-cli.grupo-econ
               tg-prazo:CHECKED     = ttint-cond-pag-cli.prazo-DDE
               rs-tipo:SCREEN-VALUE = string(ttint-cond-pag-cli.vencto-fixo).

        CASE ttint-cond-pag-cli.vencto-fixo:
            WHEN 1 THEN DO:
                ASSIGN tg-1:CHECKED IN FRAME fSemana  = ttint-cond-pag-cli.semana[1]  
                       tg-2:CHECKED IN FRAME fSemana  = ttint-cond-pag-cli.semana[2]  
                       tg-3:CHECKED IN FRAME fSemana  = ttint-cond-pag-cli.semana[3]  
                       tg-4:CHECKED IN FRAME fSemana  = ttint-cond-pag-cli.semana[4]  
                       tg-5:CHECKED IN FRAME fSemana  = ttint-cond-pag-cli.semana[5].
            END.
            WHEN 2 THEN DO:
                ASSIGN tg-dia-1:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[1]  
                       tg-dia-2:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[2]  
                       tg-dia-3:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[3]  
                       tg-dia-4:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[4]  
                       tg-dia-5:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[5]  
                       tg-dia-6:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[6]  
                       tg-dia-7:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[7]  
                       tg-dia-8:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[8]  
                       tg-dia-9:CHECKED IN FRAME fMes  = ttint-cond-pag-cli.mes[9]  
                       tg-dia-10:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[10] 
                       tg-dia-11:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[11] 
                       tg-dia-12:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[12] 
                       tg-dia-13:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[13] 
                       tg-dia-14:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[14] 
                       tg-dia-15:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[15] 
                       tg-dia-16:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[16] 
                       tg-dia-17:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[17] 
                       tg-dia-18:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[18] 
                       tg-dia-19:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[19] 
                       tg-dia-20:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[20] 
                       tg-dia-21:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[21] 
                       tg-dia-22:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[22] 
                       tg-dia-23:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[23] 
                       tg-dia-24:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[24] 
                       tg-dia-25:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[25] 
                       tg-dia-26:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[26] 
                       tg-dia-27:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[27] 
                       tg-dia-28:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[28] 
                       tg-dia-29:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[29] 
                       tg-dia-30:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[30] 
                       tg-dia-31:CHECKED IN FRAME fMes = ttint-cond-pag-cli.mes[31] .
            END.
        END.
    END.

    RUN pi-mostra-frames (INPUT ttint-cond-pag-cli.vencto-fixo).

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

     IF  g-esacr070-cliente = 0 OR g-esacr070-cliente = ? THEN
         RETURN "OK".
     DEF VAR rGoTo AS ROWID NO-UNDO.

      DEF BUFFER b-int-cond-pag-cli  FOR int-cond-pag-cli.

      FIND b-int-cond-pag-cli NO-LOCK
          WHERE b-int-cond-pag-cli.cod-emitente = g-esacr070-cliente NO-ERROR .

      IF  AVAIL b-int-cond-pag-cli THEN DO:
          RUN goToKey IN {&hDBOParent} (INPUT b-int-cond-pag-cli.cod-emitente).
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
                            input "Cliente" + string(g-esacr070-cliente) + " N∆o cadastrado no programa esacr070").
      END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDesc wMasterDetail 
FUNCTION fnDesc RETURNS CHARACTER
  ( i-cond-pagto AS INT /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  
  FIND FIRST cond-pagto NO-LOCK
      WHERE cond-pagto.cod-cond-pag = i-cond-pagto NO-ERROR.

  IF  AVAIL cond-pagto THEN
      ASSIGN c-desc-condicao = cond-pagto.descricao.

  RETURN c-desc-condicao.   /* Function return value. */

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
