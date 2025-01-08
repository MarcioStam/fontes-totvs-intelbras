&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-juridico-andamentos NO-UNDO LIKE juridico-andamentos
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-juridico-processos NO-UNDO LIKE juridico-processos
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
{include/i-prgvrs.i ESUTP033 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          ESUTP033
&GLOBAL-DEFINE Version          2.04.00.001

&GLOBAL-DEFINE Folder           yes
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Principal,Adicional,Andamentos

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

&GLOBAL-DEFINE AddSon3          YES
&GLOBAL-DEFINE CopySon3         YES
&GLOBAL-DEFINE UpdateSon3       YES
&GLOBAL-DEFINE DeleteSon3       YES

&GLOBAL-DEFINE ttParent         tt-juridico-processos
&GLOBAL-DEFINE hDBOParent       h-boes472
&GLOBAL-DEFINE DBOParentTable   juridico-processos
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon3           tt-juridico-andamentos
&GLOBAL-DEFINE hDBOSon3         h-boes473
&GLOBAL-DEFINE DBOSon3Table     juridico-andamentos
&GLOBAL-DEFINE DBOSon3Destroy   YES


&GLOBAL-DEFINE page0Fields      tt-juridico-processos.processo tt-juridico-processos.dt-processo

&GLOBAL-DEFINE page1Fields      tt-juridico-processos.autor tt-juridico-processos.cpf-cnpj tt-juridico-processos.cidade tt-juridico-processos.estado ~
                                tt-juridico-processos.contato tt-juridico-processos.cod-motivo tt-juridico-processos.cod-tipo ~
                                tt-juridico-processos.cod-situacao tt-juridico-processos.cod-solucao tt-juridico-processos.dt-recebimento ~
                                tt-juridico-processos.vara-judicial tt-juridico-processos.objeto-acao tt-juridico-processos.valor-acao ~
                                tt-juridico-processos.valor-danos-cobr tt-juridico-processos.valor-danos-pago

&GLOBAL-DEFINE page2Fields      tt-juridico-processos.cod-unid-negoc tt-juridico-processos.produto tt-juridico-processos.nr-serie ~
                                tt-juridico-processos.ordem-servico tt-juridico-processos.posto-autorizado tt-juridico-processos.defeito ~
                                tt-juridico-processos.data-compra

&GLOBAL-DEFINE page3Browse      brSon3
   

&global-define VALUE-CHANGED3    yes

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon3}   AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-unid-negoc NO-UNDO
    FIELD cod-unid-negoc AS CHARACTER
    FIELD descricao      AS CHARACTER.

DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE de-despesas     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-tot-despesas AS DECIMAL     NO-UNDO.

DEFINE BUFFER b-tt-andamentos FOR tt-juridico-andamentos.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-juridico-andamentos juridico-acoes

/* Definitions for BROWSE brSon3                                        */
&Scoped-define FIELDS-IN-QUERY-brSon3 tt-juridico-andamentos.dt-prevista ~
tt-juridico-andamentos.hora tt-juridico-andamentos.cod-acao ~
juridico-acoes.descricao tt-juridico-andamentos.dt-efetiva ~
fn-despesas(tt-juridico-andamentos.r-rowid) @ de-despesas 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon3 
&Scoped-define QUERY-STRING-brSon3 FOR EACH tt-juridico-andamentos NO-LOCK, ~
      FIRST juridico-acoes WHERE juridico-acoes.codigo = tt-juridico-andamentos.cod-acao NO-LOCK
&Scoped-define OPEN-QUERY-brSon3 OPEN QUERY brSon3 FOR EACH tt-juridico-andamentos NO-LOCK, ~
      FIRST juridico-acoes WHERE juridico-acoes.codigo = tt-juridico-andamentos.cod-acao NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon3 tt-juridico-andamentos juridico-acoes
&Scoped-define FIRST-TABLE-IN-QUERY-brSon3 tt-juridico-andamentos
&Scoped-define SECOND-TABLE-IN-QUERY-brSon3 juridico-acoes


/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brSon3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-juridico-processos.processo ~
tt-juridico-processos.dt-processo 
&Scoped-define ENABLED-TABLES tt-juridico-processos
&Scoped-define FIRST-ENABLED-TABLE tt-juridico-processos
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btAgenda btRelat ~
btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-juridico-processos.processo ~
tt-juridico-processos.dt-processo 
&Scoped-define DISPLAYED-TABLES tt-juridico-processos
&Scoped-define FIRST-DISPLAYED-TABLE tt-juridico-processos


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-despesas wMasterDetail 
FUNCTION fn-despesas RETURNS DECIMAL (INPUT p-rowid AS ROWID) FORWARD.

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

DEFINE BUTTON btAgenda 
     IMAGE-UP FILE "image/im-agen1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-agen1.bmp":U
     LABEL "Agenda" 
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

DEFINE BUTTON btRelat 
     IMAGE-UP FILE "image/im-edl.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-edl.bmp":U
     LABEL "Relat¢rio Jur¡dico" 
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
     SIZE 90 BY 2.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE fi-desc-motivo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-situacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-solucao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-tipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88 NO-UNDO.

DEFINE BUTTON btAddSon3 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopySon3 
     LABEL "Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon3 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDespesas 
     LABEL "Despesas" 
     SIZE 11.14 BY 1.

DEFINE BUTTON btUpdateSon3 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-total-despesas AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88
     FGCOLOR 9  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon3 FOR 
      tt-juridico-andamentos, 
      juridico-acoes SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon3 wMasterDetail _STRUCTURED
  QUERY brSon3 NO-LOCK DISPLAY
      tt-juridico-andamentos.dt-prevista COLUMN-LABEL "Dt.Prevista" FORMAT "99/99/9999":U
            WIDTH 11.43
      tt-juridico-andamentos.hora FORMAT "x(8)":U WIDTH 9.43
      tt-juridico-andamentos.cod-acao COLUMN-LABEL "A‡Æo" FORMAT ">>>>>>9":U
            WIDTH 6.43
      juridico-acoes.descricao FORMAT "x(40)":U WIDTH 25.43
      tt-juridico-andamentos.dt-efetiva COLUMN-LABEL "Dt.Efetiva" FORMAT "99/99/9999":U
            WIDTH 11.43
      fn-despesas(tt-juridico-andamentos.r-rowid) @ de-despesas COLUMN-LABEL "Vl.Despesas" FORMAT "->>,>>>,>>9.99":U
            WIDTH 12.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 7.83
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
     btAgenda AT ROW 1.13 COL 56.29 HELP
          "Agenda de Andamentos" WIDGET-ID 148
     btRelat AT ROW 1.13 COL 64.72 HELP
          "Relat¢rio Jur¡dico" WIDGET-ID 150
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-juridico-processos.processo AT ROW 2.92 COL 15 COLON-ALIGNED WIDGET-ID 30 FORMAT "x(50)"
          VIEW-AS FILL-IN 
          SIZE 45 BY .88
     tt-juridico-processos.dt-processo AT ROW 3.92 COL 15 COLON-ALIGNED WIDGET-ID 146
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.67
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     tt-juridico-processos.produto AT ROW 1.38 COL 12.43 COLON-ALIGNED WIDGET-ID 160
          VIEW-AS FILL-IN 
          SIZE 44 BY .88
     tt-juridico-processos.data-compra AT ROW 1.38 COL 70 COLON-ALIGNED WIDGET-ID 192
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-juridico-processos.nr-serie AT ROW 2.38 COL 12.43 COLON-ALIGNED WIDGET-ID 154
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-juridico-processos.ordem-servico AT ROW 3.38 COL 12.43 COLON-ALIGNED WIDGET-ID 156
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-juridico-processos.posto-autorizado AT ROW 4.38 COL 12.43 COLON-ALIGNED WIDGET-ID 158
          VIEW-AS FILL-IN 
          SIZE 44 BY .88
     tt-juridico-processos.cod-unid-negoc AT ROW 5.42 COL 12.57 COLON-ALIGNED WIDGET-ID 58
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Item 1","Item 1"
          DROP-DOWN-LIST
          SIZE 44 BY 1
     tt-juridico-processos.defeito AT ROW 6.46 COL 14.43 NO-LABEL WIDGET-ID 184
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 68 BY 7.04
          BGCOLOR 15 
     "Investiga‡Æo:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 6.54 COL 5 WIDGET-ID 188
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.29
         SIZE 84.43 BY 12.71
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage1
     tt-juridico-processos.autor AT ROW 1.5 COL 13.86 COLON-ALIGNED WIDGET-ID 126
          VIEW-AS FILL-IN 
          SIZE 59.14 BY .88
     tt-juridico-processos.cpf-cnpj AT ROW 2.5 COL 14 COLON-ALIGNED WIDGET-ID 188
          VIEW-AS FILL-IN 
          SIZE 22.57 BY .88
     tt-juridico-processos.cidade AT ROW 3.5 COL 14 COLON-ALIGNED WIDGET-ID 128
          VIEW-AS FILL-IN 
          SIZE 47 BY .88
     tt-juridico-processos.estado AT ROW 3.5 COL 68.86 COLON-ALIGNED WIDGET-ID 152
          VIEW-AS FILL-IN 
          SIZE 4.14 BY .88
     tt-juridico-processos.contato AT ROW 4.5 COL 14 COLON-ALIGNED WIDGET-ID 140
          VIEW-AS FILL-IN 
          SIZE 59 BY .88
     tt-juridico-processos.cod-motivo AT ROW 5.5 COL 14 COLON-ALIGNED WIDGET-ID 130
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-desc-motivo AT ROW 5.5 COL 22.29 COLON-ALIGNED NO-LABEL WIDGET-ID 168
     tt-juridico-processos.cod-tipo AT ROW 6.5 COL 14 COLON-ALIGNED WIDGET-ID 134
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-desc-tipo AT ROW 6.5 COL 22.29 COLON-ALIGNED NO-LABEL WIDGET-ID 170
     tt-juridico-processos.cod-situacao AT ROW 7.5 COL 14 COLON-ALIGNED WIDGET-ID 132
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-desc-situacao AT ROW 7.5 COL 22.29 COLON-ALIGNED NO-LABEL WIDGET-ID 174
     tt-juridico-processos.cod-solucao AT ROW 8.5 COL 14 COLON-ALIGNED WIDGET-ID 182
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-desc-solucao AT ROW 8.5 COL 22.29 COLON-ALIGNED NO-LABEL WIDGET-ID 180
     tt-juridico-processos.vara-judicial AT ROW 9.5 COL 14 COLON-ALIGNED WIDGET-ID 190
          VIEW-AS FILL-IN 
          SIZE 59 BY .88
     tt-juridico-processos.objeto-acao AT ROW 10.5 COL 14 COLON-ALIGNED WIDGET-ID 184
          VIEW-AS FILL-IN 
          SIZE 59.14 BY .88
     tt-juridico-processos.valor-acao AT ROW 11.5 COL 14 COLON-ALIGNED WIDGET-ID 186
          VIEW-AS FILL-IN 
          SIZE 11.14 BY .88
     tt-juridico-processos.dt-recebimento AT ROW 11.5 COL 45.72 COLON-ALIGNED WIDGET-ID 178
          VIEW-AS FILL-IN 
          SIZE 11.14 BY .88
     tt-juridico-processos.valor-danos-cobr AT ROW 12.5 COL 14 COLON-ALIGNED WIDGET-ID 192
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-juridico-processos.valor-danos-pago AT ROW 12.5 COL 45.72 COLON-ALIGNED WIDGET-ID 194
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.29
         SIZE 84.43 BY 12.71
         FONT 1 WIDGET-ID 300.

DEFINE FRAME fPage3
     brSon3 AT ROW 1.38 COL 2
     tt-juridico-andamentos.comentarios AT ROW 9.33 COL 2 NO-LABEL WIDGET-ID 2
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 82 BY 2.92
          BGCOLOR 15 
     btAddSon3 AT ROW 12.38 COL 2
     btCopySon3 AT ROW 12.38 COL 12
     btUpdateSon3 AT ROW 12.38 COL 22
     btDeleteSon3 AT ROW 12.38 COL 32
     btDespesas AT ROW 12.38 COL 58.72 WIDGET-ID 6
     fi-total-despesas AT ROW 12.42 COL 68 COLON-ALIGNED NO-LABEL WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.29
         SIZE 84.43 BY 12.71
         FONT 1 WIDGET-ID 400.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-juridico-andamentos T "?" NO-UNDO mgesp juridico-andamentos
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-juridico-processos T "?" NO-UNDO mgesp juridico-processos
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
         HEIGHT             = 18.67
         WIDTH              = 90
         MAX-HEIGHT         = 25.75
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 25.75
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
/* SETTINGS FOR FILL-IN tt-juridico-processos.processo IN FRAME fPage0
   EXP-FORMAT                                                           */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brSon3 1 fPage3 */
ASSIGN 
       tt-juridico-andamentos.comentarios:READ-ONLY IN FRAME fPage3        = TRUE.

ASSIGN 
       fi-total-despesas:READ-ONLY IN FRAME fPage3        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon3
/* Query rebuild information for BROWSE brSon3
     _TblList          = "Temp-Tables.tt-juridico-andamentos,mgesp.juridico-acoes WHERE Temp-Tables.tt-juridico-andamentos ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _JoinCode[2]      = "mgesp.juridico-acoes.codigo = Temp-Tables.tt-juridico-andamentos.cod-acao"
     _FldNameList[1]   > Temp-Tables.tt-juridico-andamentos.dt-prevista
"tt-juridico-andamentos.dt-prevista" "Dt.Prevista" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.tt-juridico-andamentos.hora
"tt-juridico-andamentos.hora" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" ""
     _FldNameList[3]   > Temp-Tables.tt-juridico-andamentos.cod-acao
"tt-juridico-andamentos.cod-acao" "A‡Æo" ? "integer" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" ""
     _FldNameList[4]   > mgesp.juridico-acoes.descricao
"juridico-acoes.descricao" ? ? "character" ? ? ? ? ? ? no ? no no "25.43" yes no no "U" "" ""
     _FldNameList[5]   > Temp-Tables.tt-juridico-andamentos.dt-efetiva
"tt-juridico-andamentos.dt-efetiva" "Dt.Efetiva" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" ""
     _FldNameList[6]   > "_<CALC>"
"fn-despesas(tt-juridico-andamentos.r-rowid) @ de-despesas" "Vl.Despesas" "->>,>>>,>>9.99" ? ? ? ? ? ? ? no "Valor Despesas Andamentos" no no "12.43" yes no no "U" "" ""
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


&Scoped-define BROWSE-NAME brSon3
&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon3 wMasterDetail
ON VALUE-CHANGED OF brSon3 IN FRAME fPage3
DO:
    {masterdetail/ValueChanged.i &PageNumber="3"}

    IF AVAIL tt-juridico-andamentos THEN DO:
        ASSIGN tt-juridico-andamentos.comentarios:SCREEN-VALUE IN FRAME fPage3 = tt-juridico-andamentos.comentarios.
    END.
    ELSE DO:
        ASSIGN tt-juridico-andamentos.comentarios:SCREEN-VALUE IN FRAME fPage3 = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE (INPUT "esp/utp/esutp033a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btAddSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon3 wMasterDetail
ON CHOOSE OF btAddSon3 IN FRAME fPage3 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="esp/utp/esutp033b.w"
                           &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btAgenda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAgenda wMasterDetail
ON CHOOSE OF btAgenda IN FRAME fPage0 /* Agenda */
DO:
    DEFINE VARIABLE cStatus AS CHAR NO-UNDO.
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.   

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es473.w"
                         &FieldZoom1="processo"
                         &FieldScreen1="tt-juridico-processos.processo"
                         &Frame1="fPage0"
                         &EnableImplant="NO"}
                         
    IF VALID-HANDLE(hProgramZoom) THEN
        WAIT-FOR CLOSE OF hProgramZoom.

    RUN goToKey IN {&hDBOParent} (INPUT FRAME fPage0 tt-juridico-processos.processo).
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Processo":U).
        RETURN NO-APPLY.
    END.
    
    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
    
    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
    
    RUN openQueriesSon.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord (INPUT "esp/utp/esutp033a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btCopySon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon3 wMasterDetail
ON CHOOSE OF btCopySon3 IN FRAME fPage3 /* Copiar */
DO:
    {masterdetail/copyson.i &ProgramSon="esp/utp/esutp033b.w"
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


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btDeleteSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon3 wMasterDetail
ON CHOOSE OF btDeleteSon3 IN FRAME fPage3 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDespesas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDespesas wMasterDetail
ON CHOOSE OF btDespesas IN FRAME fPage3 /* Despesas */
DO:
    IF AVAIL tt-juridico-andamentos THEN DO:
        RUN esp/utp/esutp033c.w (INPUT tt-juridico-andamentos.processo,
                                 INPUT tt-juridico-andamentos.dt-prevista,
                                 INPUT tt-juridico-andamentos.cod-acao).

        RUN openQueriesSon.
    END.
    ELSE DO:
        MESSAGE "Selecione o andamento que deseja incluir as despesas!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
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


&Scoped-define SELF-NAME btRelat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRelat wMasterDetail
ON CHOOSE OF btRelat IN FRAME fPage0 /* Relat¢rio Jur¡dico */
DO:
    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.

    IF AVAIL tt-juridico-processos THEN DO:
        ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "processoJuridico.txt".

        FIND FIRST juridico-processos NO-LOCK
             WHERE juridico-processos.processo = tt-juridico-processos.processo NO-ERROR.
        IF AVAIL juridico-processos THEN DO:

            FIND FIRST juridico-tipos NO-LOCK
                WHERE juridico-tipos.codigo = juridico-processos.cod-tipo NO-ERROR.

            OUTPUT TO VALUE(c-arquivo) CONVERT TARGET "iso8859-1".

            PUT UNFORMATTED 
                "PROCESSO: "      TO 20 juridico-processos.processo + " - " + (IF juridico-processos.dt-processo = ? THEN "" ELSE STRING(juridico-processos.dt-processo,"99/99/9999")) SKIP(1)
                "CONTATO: "       TO 20 STRING(juridico-processos.autor) +  " - "  + STRING(juridico-processos.contato)  SKIP(1)
                "TIPO: "          TO 20 STRING(juridico-processos.cod-tipo) + (IF AVAIL juridico-tipos THEN " - " + juridico-tipos.descricao ELSE "") SKIP(1)
                "CIDADE: "        TO 20 juridico-processos.cidade + " - " + juridico-processos.estado SKIP(1)
                "DATA COMPRA: "   TO 20 IF juridico-processos.data-compra = ? THEN "" ELSE STRING(juridico-processos.data-compra,"99/99/9999") SKIP(1)
                "OBJETIVO A€ÇO: " TO 20 juridico-processos.objeto-acao SKIP(1)
                "VALOR A€ÇO: "    TO 20 TRIM(STRING(juridico-processos.valor-acao,"->>>,>>>,>>9.99")) SKIP(1)
                "ANDAMENTO: "     TO 20 .


            FOR EACH juridico-andamentos OF juridico-processos NO-LOCK
               WHERE (juridico-andamentos.cod-acao = 2 OR juridico-andamentos.cod-acao = 4) ,
               FIRST juridico-acoes NO-LOCK
               WHERE juridico-acoes.codigo = juridico-andamentos.cod-acao:
                PUT UNFORMATTED
                    STRING(juridico-acoes.descricao) + " - " + 
                    (IF juridico-andamentos.dt-prevista = ? THEN "" ELSE STRING(juridico-andamentos.dt-prevista,"99/99/9999")) + " - " + 
                    STRING(juridico-andamentos.hora) + " - " +
                    (IF juridico-andamentos.dt-efetiva = ? THEN "" ELSE STRING(juridico-andamentos.dt-efetiva,"99/99/9999")) AT 21 SKIP.
            END.
            PUT UNFORMATTED SKIP(1).

            PUT UNFORMATTED 
                "ASTEC: "              TO 20 juridico-processos.posto-autorizado SKIP
                "ORDEM DE SERVI€O: "   TO 20 juridico-processos.ordem-servico    SKIP
                "EQUIPAMENTO: "        TO 20 juridico-processos.produto          SKIP
                "NS: "                 TO 20 juridico-processos.nr-serie         SKIP
                "INVESTIGA€ÇO: "       TO 20 SKIP 
                juridico-processos.defeito   SKIP.

            OUTPUT CLOSE.

            OS-COMMAND NO-WAIT notepad VALUE(c-arquivo).

        END.
    END.
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
    {method/zoomreposition.i &ProgramZoom="eszoom/z01es472.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE (INPUT "esp/utp/esutp033a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btUpdateSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon3 wMasterDetail
ON CHOOSE OF btUpdateSon3 IN FRAME fPage3 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="esp/utp/esutp033b.w"
                              &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-juridico-processos.cod-motivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-motivo wMasterDetail
ON LEAVE OF tt-juridico-processos.cod-motivo IN FRAME fPage1 /* C¢d. Motivo */
DO:
    IF AVAIL tt-juridico-processos THEN DO:
        FIND FIRST juridico-motivos NO-LOCK
             WHERE juridico-motivos.codigo = tt-juridico-processos.cod-motivo NO-ERROR.
        IF AVAIL juridico-motivos THEN
            ASSIGN fi-desc-motivo:SCREEN-VALUE IN FRAME fPage1 = juridico-motivos.descricao.
        ELSE
            ASSIGN fi-desc-motivo:SCREEN-VALUE IN FRAME fPage1 = "".
    END.
    ELSE DO:
        ASSIGN fi-desc-motivo:SCREEN-VALUE IN FRAME fPage1 = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-juridico-processos.cod-situacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-situacao wMasterDetail
ON LEAVE OF tt-juridico-processos.cod-situacao IN FRAME fPage1 /* C¢d. Situa‡Æo */
DO:
    IF AVAIL tt-juridico-processos THEN DO:
        FIND FIRST juridico-situacoes NO-LOCK
             WHERE juridico-situacoes.codigo = tt-juridico-processos.cod-situacao NO-ERROR.
        IF AVAIL juridico-situacoes THEN
            ASSIGN fi-desc-situacao:SCREEN-VALUE IN FRAME fPage1 = juridico-situacoes.descricao.
        ELSE
            ASSIGN fi-desc-situacao:SCREEN-VALUE IN FRAME fPage1 = "".
    END.
    ELSE DO:
        ASSIGN fi-desc-situacao:SCREEN-VALUE IN FRAME fPage1 = "".
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-juridico-processos.cod-solucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-solucao wMasterDetail
ON LEAVE OF tt-juridico-processos.cod-solucao IN FRAME fPage1 /* C¢d. Solu‡Æo */
DO:
    IF AVAIL tt-juridico-processos THEN DO:
        FIND FIRST juridico-solucoes NO-LOCK
             WHERE juridico-solucoes.codigo = tt-juridico-processos.cod-solucao NO-ERROR.
        IF AVAIL juridico-solucoes THEN
            ASSIGN fi-desc-solucao:SCREEN-VALUE IN FRAME fPage1 = juridico-solucoes.descricao.
        ELSE
            ASSIGN fi-desc-solucao:SCREEN-VALUE IN FRAME fPage1 = "".
    END.
    ELSE DO:
        ASSIGN fi-desc-solucao:SCREEN-VALUE IN FRAME fPage1 = "".
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-juridico-processos.cod-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-juridico-processos.cod-tipo wMasterDetail
ON LEAVE OF tt-juridico-processos.cod-tipo IN FRAME fPage1 /* C¢d. Tipo */
DO:
    IF AVAIL tt-juridico-processos THEN DO:
        FIND FIRST juridico-tipos NO-LOCK
             WHERE juridico-tipos.codigo = tt-juridico-processos.cod-tipo NO-ERROR.
        IF AVAIL juridico-tipos THEN
            ASSIGN fi-desc-tipo:SCREEN-VALUE IN FRAME fPage1 = juridico-tipos.descricao.
        ELSE
            ASSIGN fi-desc-tipo:SCREEN-VALUE IN FRAME fPage1 = "".
    END.
    ELSE DO:
        ASSIGN fi-desc-tipo:SCREEN-VALUE IN FRAME fPage1 = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
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

    IF AVAIL tt-juridico-processos THEN DO:
        DISP {&page1Fields} WITH FRAME fPage1.
        DISP {&page2Fields} WITH FRAME fPage2.

        apply 'leave' to tt-juridico-processos.cod-motivo   IN FRAME fPage1.
        APPLY "leave" TO tt-juridico-processos.cod-tipo     IN FRAME fPage1.
        APPLY "leave" TO tt-juridico-processos.cod-situacao IN FRAME fPage1.
        APPLY "leave" TO tt-juridico-processos.cod-solucao  IN FRAME fPage1.
    END.
    ELSE DO:
        ASSIGN tt-juridico-processos.cod-motivo:SCREEN-VALUE IN FRAME fPage1    = "0" 
               tt-juridico-processos.cod-tipo:SCREEN-VALUE IN FRAME fPage1      = "0"
               tt-juridico-processos.cod-situacao:SCREEN-VALUE IN FRAME fPage1  = "0"
               tt-juridico-processos.cod-solucao:SCREEN-VALUE IN FRAME fPage1   = "0"
               fi-desc-motivo:SCREEN-VALUE IN FRAME fPage1                      = ""
               fi-desc-tipo:SCREEN-VALUE IN FRAME fPage1                        = ""
               fi-desc-situacao:SCREEN-VALUE IN FRAME fPage1                    = ""
               fi-desc-solucao:SCREEN-VALUE IN FRAME fPage1                     = "".
    END.

    ENABLE btAgenda btRelat WITH FRAME fPage0.

    ENABLE btDespesas fi-total-despesas WITH FRAME fPage3.

    ASSIGN tt-juridico-andamentos.comentarios:READ-ONLY IN FRAME fPage3 = YES
           tt-juridico-andamentos.comentarios:SENSITIVE IN FRAME fPage3 = YES
           tt-juridico-processos.defeito:READ-ONLY IN FRAME fPage2 = YES
           tt-juridico-processos.defeito:SENSITIVE IN FRAME fPage2 = YES.

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
    DEFINE VARIABLE c-desc AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-esapi015 AS HANDLE      NO-UNDO.

    FOR EACH tt-unid-negoc:
        DELETE tt-unid-negoc.
    END.
    
    RUN esapi/esapi015.p PERSISTENT SET h-esapi015.
    RUN pi-retorna-unidade IN h-esapi015 (OUTPUT TABLE tt-unid-negoc).
    DELETE PROCEDURE h-esapi015.

    ASSIGN tt-juridico-processos.cod-unid-negoc:LIST-ITEM-PAIRS IN FRAME fPage2 = ",".

    FOR EACH tt-unid-negoc BY tt-unid-negoc.cod-unid-negoc:
        ASSIGN c-desc = tt-unid-negoc.cod-unid-negoc + "-" + tt-unid-negoc.descricao.

        tt-juridico-processos.cod-unid-negoc:add-last(c-desc, tt-unid-negoc.cod-unid-negoc) IN FRAME fPage2 NO-ERROR.
    END.

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
    
    DEFINE VARIABLE c-processo LIKE {&ttParent}.processo NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-processo     AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 20 BY .88
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Processo Jur¡dico" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Processo_Jur¡dico"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-processo.
        
        RUN goToKey IN {&hDBOParent} (INPUT c-processo).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "equipamentos":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-processo btGoToOK btGoToCancel 
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
       {&hDBOParent}:FILE-NAME <> "esbo/boes472.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes472.p YES}
        {btb/btb008za.i2 esbo/boes472.p '' {&hDBOParent}} 
    END.
    
/*    RUN setConstraintMain IN {&hDBOParent}  NO-ERROR.*/
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon3}) OR 
       {&hDBOSon3}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon3}:FILE-NAME <> "esbo/boes473.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes473.p YES}
        {btb/btb008za.i2 esbo/boes473.p '' {&hDBOSon3}} 
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

    {masterdetail/openqueriesson.i &Parent="Processos"
                                   &Query="Andamentos"
                                   &PageNumber="3"}

    ASSIGN de-tot-despesas = 0.
    IF AVAIL tt-juridico-processos THEN DO:
        RUN retornaDespesasProcesso IN {&hDBOParent}(INPUT tt-juridico-processos.processo,
                                                     OUTPUT de-tot-despesas).
    END.
         
    ASSIGN fi-total-despesas:SCREEN-VALUE IN FRAME fPage3 = STRING(de-tot-despesas,"->>,>>>,>>9.99").
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-despesas wMasterDetail 
FUNCTION fn-despesas RETURNS DECIMAL (INPUT p-rowid AS ROWID):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE de-retorno AS DECIMAL   NO-UNDO.

    IF VALID-HANDLE({&hDBOSon3}) THEN DO:
        RUN retornaDespesasAndamento IN {&hDBOSon3} (INPUT p-rowid,
                                                     OUTPUT de-retorno).
    END.

    RETURN de-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

