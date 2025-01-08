&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-acordo-contrato NO-UNDO LIKE acordo-contrato
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-acordo-crescimento NO-UNDO LIKE acordo-crescimento
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-acordo-tipo NO-UNDO LIKE acordo-tipo
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

{include/i-prgvrs.i ESUTP025 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          ESUTP025
&GLOBAL-DEFINE Version          2.04.00.001

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Contrato,Tipos,Crescimento

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

&GLOBAL-DEFINE AddSon2          YES
&GLOBAL-DEFINE CopySon2         YES
&GLOBAL-DEFINE UpdateSon2       YES
&GLOBAL-DEFINE DeleteSon2       YES

&GLOBAL-DEFINE AddSon3          YES
&GLOBAL-DEFINE CopySon3         YES
&GLOBAL-DEFINE UpdateSon3       YES
&GLOBAL-DEFINE DeleteSon3       YES

&GLOBAL-DEFINE ttParent         tt-acordo-contrato
&GLOBAL-DEFINE hDBOParent       h-boes464
&GLOBAL-DEFINE DBOParentTable   acordo-contrato
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon2           tt-acordo-tipo
&GLOBAL-DEFINE hDBOSon2         h-boes465
&GLOBAL-DEFINE DBOSon2Table     acordo-tipo
&GLOBAL-DEFINE DBOSon2Destroy   YES

&GLOBAL-DEFINE ttSon3           tt-acordo-crescimento
&GLOBAL-DEFINE hDBOSon3         h-boes466
&GLOBAL-DEFINE DBOSon3Table     acordo-crescimento
&GLOBAL-DEFINE DBOSon3Destroy   YES

&GLOBAL-DEFINE page0Fields      tt-acordo-contrato.nr-acordo tt-acordo-contrato.raiz-cnpj tt-acordo-contrato.cod-estabel ~
                                tt-acordo-contrato.cod-unid-negoc tt-acordo-contrato.fm-cod-com tt-acordo-contrato.data-vigencia tt-acordo-contrato.ativo
&GLOBAL-DEFINE page1Fields      tt-acordo-contrato.id-faturamento tt-acordo-contrato.id-devolucoes ~
                                tt-acordo-contrato.id-situacao tt-acordo-contrato.dt-vencto-contrato ~
                                tt-acordo-contrato.id-base-calculo tt-acordo-contrato.observacoes

&GLOBAL-DEFINE page2Browse      brSon2 
&GLOBAL-DEFINE page3Browse      brSon3

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon3}   AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-unid-negoc NO-UNDO
    FIELD cod-unid-negoc AS CHARACTER
    FIELD descricao      AS CHARACTER.

DEFINE BUFFER b-emitente FOR emitente.

DEFINE NEW GLOBAL SHARED VARIABLE h-esutp025 AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-esacr003 AS HANDLE NO-UNDO.

DEFINE VARIABLE c-raiz-cnpj     AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-acordo-tipo tipo-acordo ~
tt-acordo-crescimento

/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-acordo-tipo.tipo-acordo ~
tipo-acordo.descricao tt-acordo-tipo.percentual tt-acordo-tipo.valor-fixo ~
fn-forma-pagto(tt-acordo-tipo.forma-pagto) ~
fn-incidencia(tt-acordo-tipo.id-incidencia) ~
fn-pagamento(tt-acordo-tipo.id-pagto) 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-acordo-tipo NO-LOCK, ~
      FIRST tipo-acordo WHERE tipo-acordo.codigo = tt-acordo-tipo.tipo-acordo NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH tt-acordo-tipo NO-LOCK, ~
      FIRST tipo-acordo WHERE tipo-acordo.codigo = tt-acordo-tipo.tipo-acordo NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-acordo-tipo tipo-acordo
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-acordo-tipo
&Scoped-define SECOND-TABLE-IN-QUERY-brSon2 tipo-acordo


/* Definitions for BROWSE brSon3                                        */
&Scoped-define FIELDS-IN-QUERY-brSon3 tt-acordo-crescimento.sequencia ~
tt-acordo-crescimento.per-cresc-ini tt-acordo-crescimento.per-cresc-fim ~
tt-acordo-crescimento.per-acordo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon3 
&Scoped-define QUERY-STRING-brSon3 FOR EACH tt-acordo-crescimento NO-LOCK
&Scoped-define OPEN-QUERY-brSon3 OPEN QUERY brSon3 FOR EACH tt-acordo-crescimento NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon3 tt-acordo-crescimento
&Scoped-define FIRST-TABLE-IN-QUERY-brSon3 tt-acordo-crescimento


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brSon3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-acordo-contrato.nr-acordo ~
tt-acordo-contrato.data-vigencia tt-acordo-contrato.raiz-cnpj ~
tt-acordo-contrato.cod-estabel tt-acordo-contrato.cod-unid-negoc ~
tt-acordo-contrato.fm-cod-com tt-acordo-contrato.ativo 
&Scoped-define ENABLED-TABLES tt-acordo-contrato
&Scoped-define FIRST-ENABLED-TABLE tt-acordo-contrato
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btQueryJoins ~
btReportsJoins btExit btHelp fi-nome-emit fi-desc-estab fi-desc-familia 
&Scoped-Define DISPLAYED-FIELDS tt-acordo-contrato.nr-acordo ~
tt-acordo-contrato.data-vigencia tt-acordo-contrato.raiz-cnpj ~
tt-acordo-contrato.cod-estabel tt-acordo-contrato.cod-unid-negoc ~
tt-acordo-contrato.fm-cod-com tt-acordo-contrato.ativo 
&Scoped-define DISPLAYED-TABLES tt-acordo-contrato
&Scoped-define FIRST-DISPLAYED-TABLE tt-acordo-contrato
&Scoped-Define DISPLAYED-OBJECTS fi-nome-emit fi-desc-estab fi-desc-familia 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-forma-pagto wMasterDetail 
FUNCTION fn-forma-pagto RETURNS CHARACTER (INPUT p-forma-pagto AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-incidencia wMasterDetail 
FUNCTION fn-incidencia RETURNS CHARACTER (INPUT p-incidencia AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-pagamento wMasterDetail 
FUNCTION fn-pagamento RETURNS CHARACTER (INPUT p-pagamento AS INTEGER) FORWARD.

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

DEFINE VARIABLE fi-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-familia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-emit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37.43 BY 2.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19 BY 2.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19 BY 2.5.

DEFINE BUTTON btAddSon2 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopySon2 
     LABEL "Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon2 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon2 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-tot-perc AS DECIMAL FORMAT ">>>>9.99":U INITIAL 0 
     LABEL "Percentual" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE fi-tot-valor AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Fixo" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88
     FGCOLOR 9  NO-UNDO.

DEFINE BUTTON btAddSon3 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopySon3 
     LABEL "Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon3 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon3 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon2 FOR 
      tt-acordo-tipo, 
      tipo-acordo
    FIELDS(tipo-acordo.descricao) SCROLLING.

DEFINE QUERY brSon3 FOR 
      tt-acordo-crescimento SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      tt-acordo-tipo.tipo-acordo COLUMN-LABEL "Tp.Acordo" FORMAT ">>>>9":U
            WIDTH 9.43
      tipo-acordo.descricao FORMAT "x(40)":U WIDTH 33.43
      tt-acordo-tipo.percentual FORMAT ">9.99":U WIDTH 10.43
      tt-acordo-tipo.valor-fixo FORMAT "->>>,>>9.99":U WIDTH 10.43
      fn-forma-pagto(tt-acordo-tipo.forma-pagto) COLUMN-LABEL "Forma Pagto" FORMAT "x(20)":U
      fn-incidencia(tt-acordo-tipo.id-incidencia) COLUMN-LABEL "Incidància" FORMAT "x(20)":U
      fn-pagamento(tt-acordo-tipo.id-pagto) COLUMN-LABEL "Pagamento" FORMAT "x(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.08
         FONT 2.

DEFINE BROWSE brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon3 wMasterDetail _STRUCTURED
  QUERY brSon3 NO-LOCK DISPLAY
      tt-acordo-crescimento.sequencia COLUMN-LABEL "Sequància" FORMAT ">>9":U
            WIDTH 10.43
      tt-acordo-crescimento.per-cresc-ini COLUMN-LABEL "Crescimento Inicial" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 19.43
      tt-acordo-crescimento.per-cresc-fim COLUMN-LABEL "Crescimento Final" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 22.43
      tt-acordo-crescimento.per-acordo COLUMN-LABEL "Percentual Acordo" FORMAT ">9.99":U
            WIDTH 24.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.08
         FONT 2.


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
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rio Acordo Comercial - Cadastro"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-acordo-contrato.nr-acordo AT ROW 3 COL 19 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-acordo-contrato.data-vigencia AT ROW 3 COL 64.43 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     tt-acordo-contrato.raiz-cnpj AT ROW 4 COL 19 COLON-ALIGNED WIDGET-ID 14 FORMAT "x(14)"
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     fi-nome-emit AT ROW 4 COL 34.43 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     tt-acordo-contrato.cod-estabel AT ROW 5 COL 19 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fi-desc-estab AT ROW 5 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     tt-acordo-contrato.cod-unid-negoc AT ROW 6 COL 19 COLON-ALIGNED WIDGET-ID 58
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Item 1","Item 1"
          DROP-DOWN-LIST
          SIZE 56 BY 1
     tt-acordo-contrato.fm-cod-com AT ROW 7 COL 19 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     fi-desc-familia AT ROW 7 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     tt-acordo-contrato.ativo AT ROW 7 COL 79.72 WIDGET-ID 60
          VIEW-AS TOGGLE-BOX
          SIZE 8 BY .83
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 20.04
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     brSon3 AT ROW 1.42 COL 2
     btAddSon3 AT ROW 10.63 COL 2
     btCopySon3 AT ROW 10.63 COL 12
     btUpdateSon3 AT ROW 10.63 COL 22
     btDeleteSon3 AT ROW 10.63 COL 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 9.54
         SIZE 84.43 BY 11
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.42 COL 2
     btAddSon2 AT ROW 10.58 COL 2
     btCopySon2 AT ROW 10.58 COL 12
     btUpdateSon2 AT ROW 10.58 COL 22
     btDeleteSon2 AT ROW 10.58 COL 32
     fi-tot-perc AT ROW 10.67 COL 49.72 COLON-ALIGNED WIDGET-ID 2
     fi-tot-valor AT ROW 10.67 COL 67.72 COLON-ALIGNED WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 9.54
         SIZE 84.43 BY 11
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-acordo-contrato.id-base-calculo AT ROW 1.75 COL 21.72 NO-LABEL WIDGET-ID 42
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Sem ST", 0,
"Com ST", 1
          SIZE 15.14 BY 1.96
     tt-acordo-contrato.id-situacao AT ROW 1.79 COL 65 NO-LABEL WIDGET-ID 28
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Acordo Formal", 0,
"Provis∆o p/ VPC", 1
          SIZE 15.14 BY 1.96
     tt-acordo-contrato.id-faturamento AT ROW 1.83 COL 5.72 NO-LABEL WIDGET-ID 8
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Sem IPI", 0,
"Com IPI", 1
          SIZE 12.14 BY 1.75
     tt-acordo-contrato.id-devolucoes AT ROW 1.83 COL 44.43 NO-LABEL WIDGET-ID 24
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Considera", 0,
"N∆o Considera", 9
          SIZE 15 BY 1.75
     tt-acordo-contrato.dt-vencto-contrato AT ROW 4.29 COL 13 COLON-ALIGNED WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-acordo-contrato.observacoes AT ROW 5.33 COL 15 NO-LABEL WIDGET-ID 32
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 68 BY 6.13
     "Observaá‰es:" VIEW-AS TEXT
          SIZE 9.29 BY .54 AT ROW 5.42 COL 5.29 WIDGET-ID 34
     "Situaá∆o:" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 1.17 COL 64.29 WIDGET-ID 22
     "Devoluá‰es:" VIEW-AS TEXT
          SIZE 9.72 BY .54 AT ROW 1.13 COL 43.57 WIDGET-ID 18
     "Faturamento:" VIEW-AS TEXT
          SIZE 9.72 BY .54 AT ROW 1.13 COL 3.86 WIDGET-ID 14
     RECT-1 AT ROW 1.46 COL 2.57 WIDGET-ID 12
     RECT-2 AT ROW 1.46 COL 42.29 WIDGET-ID 16
     RECT-3 AT ROW 1.46 COL 63 WIDGET-ID 20
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 9.54
         SIZE 84.43 BY 11
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-acordo-contrato T "?" NO-UNDO mgesp acordo-contrato
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-acordo-crescimento T "?" NO-UNDO mgesp acordo-crescimento
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-acordo-tipo T "?" NO-UNDO mgesp acordo-tipo
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
         HEIGHT             = 20.04
         WIDTH              = 90
         MAX-HEIGHT         = 22.13
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 22.13
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
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE
       FRAME fPage2:FRAME = FRAME fPage0:HANDLE
       FRAME fPage3:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-acordo-contrato.raiz-cnpj IN FRAME fPage0
   EXP-FORMAT                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brSon3 1 fPage3 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.tt-acordo-tipo,mgesp.tipo-acordo WHERE Temp-Tables.tt-acordo-tipo ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST USED"
     _JoinCode[2]      = "mgesp.tipo-acordo.codigo = Temp-Tables.tt-acordo-tipo.tipo-acordo"
     _FldNameList[1]   > Temp-Tables.tt-acordo-tipo.tipo-acordo
"tt-acordo-tipo.tipo-acordo" "Tp.Acordo" ? "integer" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgesp.tipo-acordo.descricao
"tipo-acordo.descricao" ? ? "character" ? ? ? ? ? ? no ? no no "33.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-acordo-tipo.percentual
"tt-acordo-tipo.percentual" ? ? "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-acordo-tipo.valor-fixo
"tt-acordo-tipo.valor-fixo" ? ? "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fn-forma-pagto(tt-acordo-tipo.forma-pagto)" "Forma Pagto" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fn-incidencia(tt-acordo-tipo.id-incidencia)" "Incidància" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fn-pagamento(tt-acordo-tipo.id-pagto)" "Pagamento" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon3
/* Query rebuild information for BROWSE brSon3
     _TblList          = "Temp-Tables.tt-acordo-crescimento"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-acordo-crescimento.sequencia
"tt-acordo-crescimento.sequencia" "Sequància" ? "integer" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-acordo-crescimento.per-cresc-ini
"tt-acordo-crescimento.per-cresc-ini" "Crescimento Inicial" ? "decimal" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-acordo-crescimento.per-cresc-fim
"tt-acordo-crescimento.per-cresc-fim" "Crescimento Final" ? "decimal" ? ? ? ? ? ? no ? no no "22.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-acordo-crescimento.per-acordo
"tt-acordo-crescimento.per-acordo" "Percentual Acordo" ? "decimal" ? ? ? ? ? ? no ? no no "24.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon3 */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
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
    RUN addRecord IN THIS-PROCEDURE (INPUT "esp/utp/esutp025a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon2 wMasterDetail
ON CHOOSE OF btAddSon2 IN FRAME fPage2 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="esp/utp/esutp025b.w"
                           &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btAddSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon3 wMasterDetail
ON CHOOSE OF btAddSon3 IN FRAME fPage3 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="esp/utp/esutp025c.w"
                           &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord (INPUT "esp/utp/esutp025a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCopySon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon2 wMasterDetail
ON CHOOSE OF btCopySon2 IN FRAME fPage2 /* Copiar */
DO:
    {masterdetail/copyson.i &ProgramSon="esp/utp/esutp025b.w"
                            &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btCopySon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon3 wMasterDetail
ON CHOOSE OF btCopySon3 IN FRAME fPage3 /* Copiar */
DO:
    {masterdetail/copyson.i &ProgramSon="esp/utp/esutp025c.w"
                            &PageNumber="3"}
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDeleteSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon2 wMasterDetail
ON CHOOSE OF btDeleteSon2 IN FRAME fPage2 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="2"}

    RUN pi-mostra-total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btDeleteSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon3 wMasterDetail
ON CHOOSE OF btDeleteSon3 IN FRAME fPage3 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="3"}
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
    RUN pi-gera-relat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="eszoom/z01es464.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE (INPUT "esp/utp/esutp025a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btUpdateSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon2 wMasterDetail
ON CHOOSE OF btUpdateSon2 IN FRAME fPage2 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="esp/utp/esutp025b.w"
                              &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btUpdateSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon3 wMasterDetail
ON CHOOSE OF btUpdateSon3 IN FRAME fPage3 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="esp/utp/esutp025c.w"
                              &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME tt-acordo-contrato.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-acordo-contrato.cod-estabel wMasterDetail
ON LEAVE OF tt-acordo-contrato.cod-estabel IN FRAME fPage0 /* Estabelecimento */
DO:
    IF AVAIL tt-acordo-contrato THEN DO:
        IF  tt-acordo-contrato.cod-estabel = ? THEN DO:
            ASSIGN fi-desc-estab:SCREEN-VALUE IN FRAME fPage0 = "TODOS".
        END.
        ELSE DO:
            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = tt-acordo-contrato.cod-estabel NO-ERROR.
            IF AVAIL estabelec THEN
                ASSIGN fi-desc-estab:SCREEN-VALUE IN FRAME fPage0 = estabelec.nome.
            ELSE
                ASSIGN fi-desc-estab:SCREEN-VALUE IN FRAME fPage0 = "".
        END.
    END.
    ELSE DO:
        ASSIGN fi-desc-estab:SCREEN-VALUE IN FRAME fPage0 = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-acordo-contrato.fm-cod-com
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-acordo-contrato.fm-cod-com wMasterDetail
ON LEAVE OF tt-acordo-contrato.fm-cod-com IN FRAME fPage0 /* Familia */
DO:
    IF AVAIL tt-acordo-contrato THEN DO:
        IF tt-acordo-contrato.fm-cod-com = ? THEN
            ASSIGN fi-desc-familia:SCREEN-VALUE IN FRAME fPage0 = "Todas".
        ELSE DO:
            FIND FIRST fam-comerc NO-LOCK
                 WHERE fam-comerc.fm-cod-com = tt-acordo-contrato.fm-cod-com NO-ERROR.
            IF AVAILABLE(fam-comerc) THEN
                ASSIGN fi-desc-familia:SCREEN-VALUE IN FRAME fPage0 = fam-comerc.descricao.
            ELSE
                ASSIGN fi-desc-familia:SCREEN-VALUE IN FRAME fPage0 = "".
        END.
    END.
    ELSE DO:
        ASSIGN fi-desc-familia:SCREEN-VALUE IN FRAME fPage0 = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-acordo-contrato.raiz-cnpj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-acordo-contrato.raiz-cnpj wMasterDetail
ON LEAVE OF tt-acordo-contrato.raiz-cnpj IN FRAME fPage0 /* Cliente */
DO:
    IF AVAIL tt-acordo-contrato THEN DO:
        FIND FIRST emitente NO-LOCK
             WHERE emitente.cgc BEGINS tt-acordo-contrato.raiz-cnpj NO-ERROR.
        IF AVAIL emitente THEN
            ASSIGN fi-nome-emit:SCREEN-VALUE IN FRAME fPage0 = emitente.nome-emit.
        ELSE
            ASSIGN fi-nome-emit:SCREEN-VALUE IN FRAME fPage0 = "".
    END.
    ELSE DO:
        ASSIGN fi-nome-emit:SCREEN-VALUE IN FRAME fPage0 = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
ASSIGN h-esutp025 = THIS-PROCEDURE.

{masterdetail/mainblock.i}

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
    IF AVAIL tt-acordo-contrato THEN DO:
        DISP {&Page1Fields} WITH FRAME fPage1.

        IF tt-acordo-contrato.cod-unid-negoc = "" THEN DO:
            RUN pi-carrega-unidades.
        END.
    END.
        
    APPLY "leave" TO tt-acordo-contrato.raiz-cnpj       IN FRAME fPage0.
    APPLY "leave" TO tt-acordo-contrato.cod-estabel     IN FRAME fPage0.
    APPLY "leave" TO tt-acordo-contrato.fm-cod-com     IN FRAME fPage0.

    ASSIGN tt-acordo-contrato.observacoes:READ-ONLY IN FRAME fPage1 = YES.
    IF AVAIL tt-acordo-contrato THEN DO:
        ASSIGN tt-acordo-contrato.observacoes:SENSITIVE IN FRAME fPage1 = YES.
    END.
    ELSE DO:
        ASSIGN tt-acordo-contrato.observacoes:SENSITIVE IN FRAME fPage1 = NO.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMasterDetail 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-carrega-unidades.

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
    
    DEFINE VARIABLE i-nr-acordo LIKE {&ttParent}.nr-acordo NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        i-nr-acordo AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Acordo Contrato" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Acordo_Contrato"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */
                                         
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-nr-acordo .
        
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT i-nr-acordo ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Acordo Contrato":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-nr-acordo  btGoToOK btGoToCancel 
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
       {&hDBOParent}:FILE-NAME <> "esbo/boes464.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes464.p YES}
        {btb/btb008za.i2 esbo/boes464.p '' {&hDBOParent}} 
    END.

    IF VALID-HANDLE(h-esacr003) THEN DO:
        RUN piFiltraRaizCnpj IN THIS-PROCEDURE. 
        RUN setConstraintRaizCnpj IN {&hDBOParent}(INPUT c-raiz-cnpj).
        RUN openQueryStatic IN {&hDBOParent}(INPUT "RaizCnpj":U).
        ASSIGN h-esacr003 = ?.
    END.
    ELSE DO:
        RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    END.
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) OR 
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "esbo/boes465.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes465.p YES}
        {btb/btb008za.i2 esbo/boes465.p '' {&hDBOSon2}} 
    END.
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon3}) OR
       {&hDBOSon3}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon3}:FILE-NAME <> "esbo/boes466.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes466.p YES}
        {btb/btb008za.i2 esbo/boes466.p '' {&hDBOSon3}} 
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
    
    {masterdetail/openqueriesson.i &Parent="Contrato"
                                   &Query="Tipo"
                                   &PageNumber="2"}
    
    {masterdetail/openqueriesson.i &Parent="Contrato"
                                   &Query="Crescimento"
                                   &PageNumber="3"}

    RUN pi-mostra-total.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-unidades wMasterDetail 
PROCEDURE pi-carrega-unidades :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desc AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-esapi015 AS HANDLE      NO-UNDO.

    FOR EACH tt-unid-negoc:
        DELETE tt-unid-negoc.
    END.
    
    RUN esapi/esapi015.p PERSISTENT SET h-esapi015.
    RUN pi-retorna-unidade IN h-esapi015 (OUTPUT TABLE tt-unid-negoc).
    DELETE PROCEDURE h-esapi015.

    ASSIGN tt-acordo-contrato.cod-unid-negoc:LIST-ITEM-PAIRS IN FRAME fPage0 = ",".

    ASSIGN c-desc = "? - TODAS".
    /*Ç salvo como 1 no banco de dados para todas, combobox n∆o permite ?*/
    tt-acordo-contrato.cod-unid-negoc:add-last(c-desc, '1') IN FRAME fPage0.
    FOR EACH tt-unid-negoc BY tt-unid-negoc.cod-unid-negoc:
        ASSIGN c-desc = tt-unid-negoc.cod-unid-negoc + "-" + tt-unid-negoc.descricao.

        tt-acordo-contrato.cod-unid-negoc:add-last(c-desc, tt-unid-negoc.cod-unid-negoc) IN FRAME fPage0 NO-ERROR.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-relat wMasterDetail 
PROCEDURE pi-gera-relat :
/*:T------------------------------------------------------------------------------
  Purpose:     Relatorio
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-arquivo     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-unid-negoc  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.

    ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "esutp025.txt".

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    RUN pi-inicializar IN h-acomp (INPUT "Gerando Relat¢rio..."). 

    OUTPUT TO VALUE(c-arquivo) NO-CONVERT.

    PUT UNFORMATTED                                  
        "Nr Acordo;Raiz CNPJ;Nome;C¢d. Matriz;Matriz;Estab;UnidNeg;FamCom;Dt.Vigencia;Ativo;Dt.Vencto;Tipo Acordo;Descricao;Percentual;Valor Fixo;IPI;Devoluá‰es;Situaá∆o;Base Calculo;Forma Pagto;Incidància;Pagamento" SKIP. 

    FOR EACH acordo-contrato NO-LOCK,
       FIRST emitente NO-LOCK
       WHERE emitente.cgc BEGINS acordo-contrato.raiz-cnpj,
        EACH acordo-tipo NO-LOCK
       WHERE acordo-tipo.nr-acordo = acordo-contrato.nr-acordo,
       FIRST tipo-acordo NO-LOCK
       WHERE tipo-acordo.codigo = acordo-tipo.tipo-acordo:

        ASSIGN c-unid-negoc  = IF acordo-contrato.cod-unid-negoc = '1' THEN 'TODAS' ELSE acordo-contrato.cod-unid-negoc
               c-cod-estabel = IF acordo-contrato.cod-estabel    =  ?  THEN 'TODOS' ELSE acordo-contrato.cod-estabel.

        RUN pi-acompanhar IN h-acomp (INPUT "Acordo: " + STRING(acordo-contrato.nr-acordo) + " - " + acordo-contrato.cod-estabel).

        FIND FIRST b-emitente NO-LOCK
             WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-ERROR.

       PUT UNFORMATTED
            acordo-contrato.nr-acordo               ";"
            acordo-contrato.raiz-cnpj               ";"
            emitente.nome-emit                      ";"
            b-emitente.cod-emitente                 ";"
            emitente.nome-matriz                    ";"
            c-cod-estabel                           ";"
            c-unid-negoc                            ";"
            acordo-contrato.fm-cod-com              ";"
            acordo-contrato.data-vigencia           ";"
            STRING(acordo-contrato.ativo,"Sim/Nao") ";"
            acordo-contrato.dt-vencto-contrato      ";"
            acordo-tipo.tipo-acordo                 ";"
            tipo-acordo.descricao                   ";"
            acordo-tipo.percentual                  ";"
            acordo-tipo.valor-fixo                  ";".
            
        IF acordo-contrato.id-faturamento = 1 THEN 
            PUT UNFORMAT "Com IPI;".
        ELSE 
            PUT UNFORMAT "Sem IPI;".
        
        IF acordo-contrato.id-devolucoes = 0 THEN
            PUT UNFORMAT "Considera;".
        ELSE
            PUT UNFORMAT "N∆o Considera;".

        IF acordo-contrato.id-situacao = 0 THEN
            PUT UNFORMAT "Acordo Formal;".
        ELSE
            PUT UNFORMAT "Provis∆o p/ VPC;".

        IF acordo-contrato.id-base-calculo = 0 THEN
            PUT UNFORMAT "Sem ST;".
        ELSE
            PUT UNFORMAT "Com ST;".

        IF acordo-tipo.forma-pagto = 0 THEN
            PUT UNFORMAT "Boleto;".
        ELSE 
        IF acordo-tipo.forma-pagto = 1 THEN
            PUT UNFORMAT "Desconto;".
        ELSE 
            PUT UNFORMAT "Produto;".
            
        IF acordo-tipo.id-incidencia = 0 THEN
            PUT UNFORMAT "Nota Fiscal;".
        ELSE
        IF acordo-tipo.id-incidencia = 1 THEN
            PUT UNFORMAT "Faturamento Per°odo;".
        ELSE PUT UNFORMAT "Eventos;".

        CASE acordo-tipo.id-pagto:
           when 0 THEN PUT UNFORMAT "D + X informado" SKIP.
           when 1 THEN PUT UNFORMAT "Por NF" SKIP.
           when 2 THEN PUT UNFORMAT "Por Màs" SKIP.
           when 3 THEN PUT UNFORMAT "Por Bimestre" SKIP.
           when 4 THEN PUT UNFORMAT "Por Trimestre" SKIP.
           when 5 THEN PUT UNFORMAT "Por Semestre" SKIP.
           when 6 THEN PUT UNFORMAT "Por Ano" SKIP.
           when 7 THEN PUT UNFORMAT "Data Informada" SKIP.
        END.
    END.
    OUTPUT CLOSE.

    RUN pi-finalizar IN h-acomp.

    OS-COMMAND NO-WAIT notepad VALUE(c-arquivo).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-total wMasterDetail 
PROCEDURE pi-mostra-total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN fi-tot-perc  = 0
           fi-tot-valor = 0.

    IF AVAIL tt-acordo-contrato THEN
        RUN pi-retorna-totais IN {&hDBOSon2} (INPUT  tt-acordo-contrato.nr-acordo,
                                              OUTPUT fi-tot-perc,
                                              OUTPUT fi-tot-valor).

    DISP fi-tot-perc fi-tot-valor WITH FRAME fPage2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFiltraRaizCnpj wMasterDetail 
PROCEDURE piFiltraRaizCnpj :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


IF VALID-HANDLE(h-esacr003) THEN DO:
    RUN piFiltraRaizCnpj IN h-esacr003(OUTPUT c-raiz-cnpj).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-forma-pagto wMasterDetail 
FUNCTION fn-forma-pagto RETURNS CHARACTER (INPUT p-forma-pagto AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.

    ASSIGN c-retorno = "".
    CASE p-forma-pagto:
        WHEN 0 THEN ASSIGN c-retorno = "Boleto".
        WHEN 1 THEN ASSIGN c-retorno = "Desconto".
        WHEN 2 THEN ASSIGN c-retorno = "Produto".
    END CASE.

    ASSIGN c-retorno = STRING(p-forma-pagto) + "-" + c-retorno.

    RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-incidencia wMasterDetail 
FUNCTION fn-incidencia RETURNS CHARACTER (INPUT p-incidencia AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.

    ASSIGN c-retorno = "".
    CASE p-incidencia:
        WHEN 0 THEN ASSIGN c-retorno = "Nota Fiscal".
        WHEN 1 THEN ASSIGN c-retorno = "Faturamento Per°odo".
        WHEN 2 THEN ASSIGN c-retorno = "Eventos".
    END CASE.

    ASSIGN c-retorno = STRING(p-incidencia) + "-" + c-retorno.

    RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-pagamento wMasterDetail 
FUNCTION fn-pagamento RETURNS CHARACTER (INPUT p-pagamento AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.

    ASSIGN c-retorno = "".
    CASE p-pagamento:
        WHEN 0 THEN ASSIGN c-retorno = "D + X informado".
        WHEN 1 THEN ASSIGN c-retorno = "Por NF".
        WHEN 2 THEN ASSIGN c-retorno = "Por Màs".
        WHEN 3 THEN ASSIGN c-retorno = "Por Bimestre".
        WHEN 4 THEN ASSIGN c-retorno = "Por Trimestre".
        WHEN 5 THEN ASSIGN c-retorno = "Por Semestre".
        WHEN 6 THEN ASSIGN c-retorno = "Por Ano".
        WHEN 7 THEN ASSIGN c-retorno = "Data Informada".
    END CASE.

    ASSIGN c-retorno = STRING(p-pagamento) + "-" + c-retorno.

    RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

