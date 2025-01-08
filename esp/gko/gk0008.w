&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GK0008 2.00.06.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        GK0008
&GLOBAL-DEFINE Version        2.00.06.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Folder1

&GLOBAL-DEFINE page0Widgets   v-cod-estab-ini v-cod-estab-fim v-cod-nat-oper-ini v-cod-nat-oper-fim ~
                              v-cod-unid-ini v-cod-unid-fim v-cdn-canal-ini v-cdn-canal-fim v-cdn-ct-codigo-ini v-cdn-ct-codigo-fim ~
                              v-cdn-ccusto-ini v-cdn-ccusto-fim bt-fil bt-inc bt-mod bt-del bt-can bt-sal bt-del br-contas btExit

&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.

{upc/btb910za-upc.i} /* Defini‡Æo da vari vel New Global Shared "v_cod_estab_usuar" */

DEFINE VARIABLE wh-pesquisa                    AS HANDLE      NO-UNDO.
DEFINE VARIABLE v-row-gko-param-contab-totvs11 AS ROWID       NO-UNDO.

/* Temp Table Definitions ---                                          */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-contas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gko-param-contab-totvs11

/* Definitions for BROWSE br-contas                                     */
&Scoped-define FIELDS-IN-QUERY-br-contas ~
gko-param-contab-totvs11.cod-estabel gko-param-contab-totvs11.nat-operacao ~
gko-param-contab-totvs11.cod-unid-negoc ~
gko-param-contab-totvs11.cod-canal-venda gko-param-contab-totvs11.ct-codigo ~
gko-param-contab-totvs11.sc-codigo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-contas 
&Scoped-define QUERY-STRING-br-contas FOR EACH gko-param-contab-totvs11 ~
      WHERE gko-param-contab-totvs11.cod-estabel >= v-cod-estab-ini ~
 and gko-param-contab-totvs11.cod-estabel <= v-cod-estab-fim  ~
 and gko-param-contab-totvs11.nat-operacao >= v-cod-nat-oper-ini ~
 and gko-param-contab-totvs11.nat-operacao <= v-cod-nat-oper-fim ~
 and ((v-cod-unid-ini <> ? ~
 and gko-param-contab-totvs11.cod-unid-negoc >= v-cod-unid-ini ~
 and gko-param-contab-totvs11.cod-unid-negoc <= v-cod-unid-fim) ~
  OR gko-param-contab-totvs11.cod-unid-negoc = ?) ~
 and ((v-cdn-canal-ini <> ? ~
 and gko-param-contab-totvs11.cod-canal-venda >= v-cdn-canal-ini ~
 and gko-param-contab-totvs11.cod-canal-venda <= v-cdn-canal-fim) ~
  or gko-param-contab-totvs11.cod-canal-venda = ?) ~
 AND gko-param-contab-totvs11.ct-codigo >= v-cdn-ct-codigo-ini ~
 AND gko-param-contab-totvs11.ct-codigo <= v-cdn-ct-codigo-fim ~
 AND gko-param-contab-totvs11.sc-codigo >= v-cdn-ccusto-ini ~
 AND gko-param-contab-totvs11.sc-codigo <= v-cdn-ccusto-fim NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-contas OPEN QUERY br-contas FOR EACH gko-param-contab-totvs11 ~
      WHERE gko-param-contab-totvs11.cod-estabel >= v-cod-estab-ini ~
 and gko-param-contab-totvs11.cod-estabel <= v-cod-estab-fim  ~
 and gko-param-contab-totvs11.nat-operacao >= v-cod-nat-oper-ini ~
 and gko-param-contab-totvs11.nat-operacao <= v-cod-nat-oper-fim ~
 and ((v-cod-unid-ini <> ? ~
 and gko-param-contab-totvs11.cod-unid-negoc >= v-cod-unid-ini ~
 and gko-param-contab-totvs11.cod-unid-negoc <= v-cod-unid-fim) ~
  OR gko-param-contab-totvs11.cod-unid-negoc = ?) ~
 and ((v-cdn-canal-ini <> ? ~
 and gko-param-contab-totvs11.cod-canal-venda >= v-cdn-canal-ini ~
 and gko-param-contab-totvs11.cod-canal-venda <= v-cdn-canal-fim) ~
  or gko-param-contab-totvs11.cod-canal-venda = ?) ~
 AND gko-param-contab-totvs11.ct-codigo >= v-cdn-ct-codigo-ini ~
 AND gko-param-contab-totvs11.ct-codigo <= v-cdn-ct-codigo-fim ~
 AND gko-param-contab-totvs11.sc-codigo >= v-cdn-ccusto-ini ~
 AND gko-param-contab-totvs11.sc-codigo <= v-cdn-ccusto-fim NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-contas gko-param-contab-totvs11
&Scoped-define FIRST-TABLE-IN-QUERY-br-contas gko-param-contab-totvs11


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-contas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-fil br-contas bt-sal bt-del btExit ~
v-cod-estab-ini v-cod-estab-fim v-cod-nat-oper-ini v-cod-nat-oper-fim ~
v-cod-unid-ini v-cod-unid-fim v-cdn-canal-ini v-cdn-canal-fim ~
v-cod-estab-man v-cod-nat-oper-man v-cod-unid-neg-man v-cdn-canal-man ~
v-cod-conta-man v-cod-ccusto-man v-des-estab v-des-natur v-des-canal ~
v-des-unid v-des-conta v-des-ccusto bt-inc bt-mod bt-can ~
v-cdn-ct-codigo-ini v-cdn-ct-codigo-fim v-cdn-ccusto-ini v-cdn-ccusto-fim ~
RECT-1 RECT-2 IMAGE-9 IMAGE-10 IMAGE-17 IMAGE-18 IMAGE-19 IMAGE-20 IMAGE-21 ~
IMAGE-22 IMAGE-23 IMAGE-24 IMAGE-25 IMAGE-26 
&Scoped-Define DISPLAYED-OBJECTS v-cod-estab-ini v-cod-estab-fim ~
v-cod-nat-oper-ini v-cod-nat-oper-fim v-cod-unid-ini v-cod-unid-fim ~
v-cdn-canal-ini v-cdn-canal-fim v-cod-estab-man v-cod-nat-oper-man ~
v-cod-unid-neg-man v-cdn-canal-man v-cod-conta-man v-cod-ccusto-man ~
v-des-estab v-des-natur v-des-canal v-des-unid v-des-conta v-des-ccusto ~
v-cdn-ct-codigo-ini v-cdn-ct-codigo-fim v-cdn-ccusto-ini v-cdn-ccusto-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-can 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancelar" 
     SIZE 4 BY 1.25 TOOLTIP "Cancelar"
     FONT 4.

DEFINE BUTTON bt-del 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Eliminar" 
     SIZE 4 BY 1.25 TOOLTIP "Eliminar"
     FONT 4.

DEFINE BUTTON bt-fil 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Filtrar" 
     SIZE 4 BY 1 TOOLTIP "Filtrar lista de CEP utilizando a faixa informada"
     FONT 4.

DEFINE BUTTON bt-inc 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Incluir" 
     SIZE 4 BY 1.25 TOOLTIP "Incluir"
     FONT 4.

DEFINE BUTTON bt-mod 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Modificar" 
     SIZE 4 BY 1.25 TOOLTIP "Modificar"
     FONT 4.

DEFINE BUTTON bt-sal 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Salvar" 
     SIZE 4 BY 1.25 TOOLTIP "Salvar faixa de CEP"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25 TOOLTIP "Sair"
     FONT 4.

DEFINE VARIABLE v-cdn-canal-fim AS INTEGER FORMAT ">>9" INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cdn-canal-ini AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Canal":R15 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cdn-canal-man AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Canal":R15 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cdn-ccusto-fim AS CHARACTER FORMAT "X(20)" INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cdn-ccusto-ini AS CHARACTER FORMAT "X(20)" 
     LABEL "C.Custo":R15 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cdn-ct-codigo-fim AS CHARACTER FORMAT "X(20)" INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cdn-ct-codigo-ini AS CHARACTER FORMAT "X(20)" 
     LABEL "Conta":R15 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-ccusto-man AS CHARACTER FORMAT "x(05)" 
     LABEL "C.Custo":R15 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-conta-man AS CHARACTER FORMAT "x(08)" 
     LABEL "Conta":R15 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-estab-fim AS CHARACTER FORMAT "x(05)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-estab-ini AS CHARACTER FORMAT "x(05)" 
     LABEL "Estab":R15 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-estab-man AS CHARACTER FORMAT "x(05)" 
     LABEL "Estab":R15 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-nat-oper-fim AS CHARACTER FORMAT "x(06)" INITIAL "ZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-nat-oper-ini AS CHARACTER FORMAT "x(06)" 
     LABEL "Natureza":R15 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-nat-oper-man AS CHARACTER FORMAT "x(06)" 
     LABEL "Natureza":R15 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-unid-fim AS CHARACTER FORMAT "x(08)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-unid-ini AS CHARACTER FORMAT "x(03)" 
     LABEL "Unid Neg":R15 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-unid-neg-man AS CHARACTER FORMAT "x(03)" 
     LABEL "Unid Neg":R15 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE v-des-canal AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE v-des-ccusto AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE v-des-conta AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE v-des-estab AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE v-des-natur AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE v-des-unid AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 6.33.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 7.92.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-contas FOR 
      gko-param-contab-totvs11 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-contas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-contas wWindow _STRUCTURED
  QUERY br-contas NO-LOCK DISPLAY
      gko-param-contab-totvs11.cod-estabel FORMAT "x(5)":U
      gko-param-contab-totvs11.nat-operacao FORMAT "x(6)":U WIDTH 7
      gko-param-contab-totvs11.cod-unid-negoc FORMAT "x(3)":U
      gko-param-contab-totvs11.cod-canal-venda FORMAT ">>9":U WIDTH 4
      gko-param-contab-totvs11.ct-codigo FORMAT "x(20)":U WIDTH 9
      gko-param-contab-totvs11.sc-codigo FORMAT "x(20)":U WIDTH 9
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 52 BY 19.25
         FONT 1
         TITLE "Contas Parametrizadas" ROW-HEIGHT-CHARS .68.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-fil AT ROW 6.42 COL 39.72 HELP
          "Consultas relacionadas" WIDGET-ID 14
     br-contas AT ROW 1.25 COL 52 WIDGET-ID 200
     bt-sal AT ROW 14.79 COL 35 HELP
          "Confirma altera‡äes" WIDGET-ID 68
     bt-del AT ROW 14.79 COL 27 HELP
          "Elimina ocorrˆncia corrente" WIDGET-ID 24
     btExit AT ROW 14.79 COL 39 HELP
          "Sair"
     v-cod-estab-ini AT ROW 1.5 COL 12 COLON-ALIGNED WIDGET-ID 86
     v-cod-estab-fim AT ROW 1.5 COL 28.43 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     v-cod-nat-oper-ini AT ROW 2.5 COL 12 COLON-ALIGNED WIDGET-ID 118
     v-cod-nat-oper-fim AT ROW 2.5 COL 28.43 COLON-ALIGNED NO-LABEL WIDGET-ID 112
     v-cod-unid-ini AT ROW 3.5 COL 12 COLON-ALIGNED WIDGET-ID 126
     v-cod-unid-fim AT ROW 3.5 COL 28.43 COLON-ALIGNED NO-LABEL WIDGET-ID 120
     v-cdn-canal-ini AT ROW 4.5 COL 12 COLON-ALIGNED WIDGET-ID 134
     v-cdn-canal-fim AT ROW 4.5 COL 28.43 COLON-ALIGNED NO-LABEL WIDGET-ID 128
     v-cod-estab-man AT ROW 8.79 COL 12 COLON-ALIGNED WIDGET-ID 138
     v-cod-nat-oper-man AT ROW 9.79 COL 12 COLON-ALIGNED WIDGET-ID 142
     v-cod-unid-neg-man AT ROW 10.79 COL 12 COLON-ALIGNED WIDGET-ID 146
     v-cdn-canal-man AT ROW 11.79 COL 12 COLON-ALIGNED WIDGET-ID 136
     v-cod-conta-man AT ROW 12.79 COL 12 COLON-ALIGNED WIDGET-ID 148
     v-cod-ccusto-man AT ROW 13.79 COL 12 COLON-ALIGNED WIDGET-ID 150
     v-des-estab AT ROW 8.79 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 152
     v-des-natur AT ROW 9.79 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 154
     v-des-canal AT ROW 11.79 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 158
     v-des-unid AT ROW 10.79 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 160
     v-des-conta AT ROW 12.79 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 162
     v-des-ccusto AT ROW 13.79 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 164
     bt-inc AT ROW 14.79 COL 19 HELP
          "Inclui nova ocorrˆncia" WIDGET-ID 168
     bt-mod AT ROW 14.79 COL 23 HELP
          "Altera ocorrˆncia corrente" WIDGET-ID 170
     bt-can AT ROW 14.79 COL 31 HELP
          "Cancela altera‡äes" WIDGET-ID 172
     v-cdn-ct-codigo-ini AT ROW 5.5 COL 12 COLON-ALIGNED WIDGET-ID 180
     v-cdn-ct-codigo-fim AT ROW 5.5 COL 28.43 COLON-ALIGNED NO-LABEL WIDGET-ID 178
     v-cdn-ccusto-ini AT ROW 6.5 COL 12 COLON-ALIGNED WIDGET-ID 188
     v-cdn-ccusto-fim AT ROW 6.5 COL 28.43 COLON-ALIGNED NO-LABEL WIDGET-ID 186
     " Filtro" VIEW-AS TEXT
          SIZE 4.43 BY .67 AT ROW 1.08 COL 2.57 WIDGET-ID 72
     " Manuten‡Æo" VIEW-AS TEXT
          SIZE 10 BY .67 AT ROW 8.04 COL 3 WIDGET-ID 82
     RECT-1 AT ROW 1.42 COL 2 WIDGET-ID 62
     RECT-2 AT ROW 8.38 COL 2 WIDGET-ID 74
     IMAGE-9 AT ROW 1.5 COL 23.29 WIDGET-ID 10
     IMAGE-10 AT ROW 1.5 COL 27 WIDGET-ID 12
     IMAGE-17 AT ROW 2.5 COL 23.29 WIDGET-ID 116
     IMAGE-18 AT ROW 2.5 COL 27 WIDGET-ID 114
     IMAGE-19 AT ROW 3.5 COL 23.29 WIDGET-ID 124
     IMAGE-20 AT ROW 3.5 COL 27 WIDGET-ID 122
     IMAGE-21 AT ROW 4.5 COL 23.29 WIDGET-ID 132
     IMAGE-22 AT ROW 4.5 COL 27 WIDGET-ID 130
     IMAGE-23 AT ROW 5.5 COL 23.29 WIDGET-ID 174
     IMAGE-24 AT ROW 5.5 COL 27 WIDGET-ID 176
     IMAGE-25 AT ROW 6.5 COL 23.29 WIDGET-ID 182
     IMAGE-26 AT ROW 6.5 COL 27 WIDGET-ID 184
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 103 BY 19.88
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 19.88
         WIDTH              = 103
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.96
         VIRTUAL-WIDTH      = 195.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-contas bt-fil fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-contas
/* Query rebuild information for BROWSE br-contas
     _TblList          = "mgesp.gko-param-contab-totvs11"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "gko-param-contab-totvs11.cod-estabel >= v-cod-estab-ini
 and gko-param-contab-totvs11.cod-estabel <= v-cod-estab-fim 
 and gko-param-contab-totvs11.nat-operacao >= v-cod-nat-oper-ini
 and gko-param-contab-totvs11.nat-operacao <= v-cod-nat-oper-fim
 and ((v-cod-unid-ini <> ?
 and gko-param-contab-totvs11.cod-unid-negoc >= v-cod-unid-ini
 and gko-param-contab-totvs11.cod-unid-negoc <= v-cod-unid-fim)
  OR gko-param-contab-totvs11.cod-unid-negoc = ?)
 and ((v-cdn-canal-ini <> ?
 and gko-param-contab-totvs11.cod-canal-venda >= v-cdn-canal-ini
 and gko-param-contab-totvs11.cod-canal-venda <= v-cdn-canal-fim)
  or gko-param-contab-totvs11.cod-canal-venda = ?)
 AND mgesp.gko-param-contab-totvs11.ct-codigo >= v-cdn-ct-codigo-ini
 AND mgesp.gko-param-contab-totvs11.ct-codigo <= v-cdn-ct-codigo-fim
 AND mgesp.gko-param-contab-totvs11.sc-codigo >= v-cdn-ccusto-ini
 AND mgesp.gko-param-contab-totvs11.sc-codigo <= v-cdn-ccusto-fim"
     _FldNameList[1]   = mgesp.gko-param-contab-totvs11.cod-estabel
     _FldNameList[2]   > mgesp.gko-param-contab-totvs11.nat-operacao
"gko-param-contab-totvs11.nat-operacao" ? ? "character" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = mgesp.gko-param-contab-totvs11.cod-unid-negoc
     _FldNameList[4]   > mgesp.gko-param-contab-totvs11.cod-canal-venda
"gko-param-contab-totvs11.cod-canal-venda" ? ? "integer" ? ? ? ? ? ? no ? no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > mgesp.gko-param-contab-totvs11.ct-codigo
"gko-param-contab-totvs11.ct-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > mgesp.gko-param-contab-totvs11.sc-codigo
"gko-param-contab-totvs11.sc-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-contas */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-contas
&Scoped-define SELF-NAME br-contas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-contas wWindow
ON VALUE-CHANGED OF br-contas IN FRAME fpage0 /* Contas Parametrizadas */
DO:
    IF  AVAIL gko-param-contab-totvs11
    THEN DO:
       DISP gko-param-contab-totvs11.cod-estabel     @ v-cod-estab-man
            gko-param-contab-totvs11.nat-operacao    @ v-cod-nat-oper-man
            gko-param-contab-totvs11.cod-canal-venda @ v-cdn-canal-man
            gko-param-contab-totvs11.cod-unid-negoc  @ v-cod-unid-neg-man
            gko-param-contab-totvs11.ct-codigo       @ v-cod-conta-man
            gko-param-contab-totvs11.sc-codigo       @ v-cod-ccusto-man
            WITH FRAME {&FRAME-NAME}.

       APPLY "leave" TO v-cod-estab-man     IN FRAME {&FRAME-NAME}.
       APPLY "leave" TO v-cod-nat-oper-man  IN FRAME {&FRAME-NAME}.
       APPLY "leave" TO v-cdn-canal-man     IN FRAME {&FRAME-NAME}.
       APPLY "leave" TO v-cod-unid-neg-man  IN FRAME {&FRAME-NAME}.
       APPLY "leave" TO v-cod-conta-man     IN FRAME {&FRAME-NAME}.
       APPLY "leave" TO v-cod-ccusto-man    IN FRAME {&FRAME-NAME}.
    END.
    ELSE
       DISP "" @ v-cod-estab-man
            "" @ v-cod-nat-oper-man
            "" @ v-cdn-canal-man
            "" @ v-cod-unid-neg-man
            "" @ v-cod-conta-man
            "" @ v-cod-ccusto-man
            "" @ v-des-estab
            "" @ v-des-natur
            "" @ v-des-canal
            "" @ v-des-unid
            "" @ v-des-conta
            "" @ v-des-ccusto
            WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-can
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-can wWindow
ON CHOOSE OF bt-can IN FRAME fpage0 /* Cancelar */
DO:
   DISP "" @ v-cod-estab-man
        "" @ v-cod-nat-oper-man
        "" @ v-cdn-canal-man
        "" @ v-cod-unid-neg-man
        "" @ v-cod-conta-man
        "" @ v-cod-ccusto-man
        "" @ v-des-estab
        "" @ v-des-natur
        "" @ v-des-canal
        "" @ v-des-unid
        "" @ v-des-conta
        "" @ v-des-ccusto
        WITH FRAME {&FRAME-NAME}.    

   DISABLE v-cod-estab-man
           v-cod-nat-oper-man
           v-cdn-canal-man
           v-cod-unid-neg-man
           v-cod-conta-man
           v-cod-ccusto-man
           WITH FRAME {&FRAME-NAME}.

   APPLY "value-changed" TO br-contas IN FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del wWindow
ON CHOOSE OF bt-del IN FRAME fpage0 /* Eliminar */
DO:
    IF  AVAIL gko-param-contab-totvs11
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 27100,
                           INPUT "Eliminar configura‡Æo de conta?").

        IF  RETURN-VALUE = "yes"
        THEN DO:
            FIND CURRENT gko-param-contab-totvs11 EXCLUSIVE-LOCK NO-ERROR.

            DELETE gko-param-contab-totvs11.
            APPLY "value-changed" TO br-contas IN FRAME {&FRAME-NAME}.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fil wWindow
ON CHOOSE OF bt-fil IN FRAME fpage0 /* Filtrar */
DO:
   ASSIGN v-cod-estab-ini     = INPUT FRAME {&FRAME-NAME} v-cod-estab-ini   
          v-cod-estab-fim     = INPUT FRAME {&FRAME-NAME} v-cod-estab-fim   
          v-cod-nat-oper-ini  = INPUT FRAME {&FRAME-NAME} v-cod-nat-oper-ini
          v-cod-nat-oper-fim  = INPUT FRAME {&FRAME-NAME} v-cod-nat-oper-fim
          v-cod-unid-ini      = INPUT FRAME {&FRAME-NAME} v-cod-unid-ini 
          v-cod-unid-fim      = INPUT FRAME {&FRAME-NAME} v-cod-unid-fim 
          v-cdn-canal-ini     = INPUT FRAME {&FRAME-NAME} v-cdn-canal-ini   
          v-cdn-canal-fim     = INPUT FRAME {&FRAME-NAME} v-cdn-canal-fim
          v-cdn-canal-ini     = INPUT FRAME {&FRAME-NAME} v-cdn-canal-ini
          v-cdn-canal-fim     = INPUT FRAME {&FRAME-NAME} v-cdn-canal-fim
          v-cdn-ct-codigo-ini = INPUT FRAME {&FRAME-NAME} v-cdn-ct-codigo-ini 
          v-cdn-ct-codigo-fim = INPUT FRAME {&FRAME-NAME} v-cdn-ct-codigo-fim 
          v-cdn-ccusto-ini    = INPUT FRAME {&FRAME-NAME} v-cdn-ccusto-ini    
          v-cdn-ccusto-fim    = INPUT FRAME {&FRAME-NAME} v-cdn-ccusto-fim       
          .

    {&OPEN-QUERY-br-contas}
    APPLY "value-changed" TO br-contas IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-inc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inc wWindow
ON CHOOSE OF bt-inc IN FRAME fpage0 /* Incluir */
DO:
   DISP "" @ v-cod-estab-man
        "" @ v-cod-nat-oper-man
        "" @ v-cdn-canal-man
        "" @ v-cod-unid-neg-man
        "" @ v-cod-conta-man
        "" @ v-cod-ccusto-man
        "" @ v-des-estab
        "" @ v-des-natur
        "" @ v-des-canal
        "" @ v-des-unid
        "" @ v-des-conta
        "" @ v-des-ccusto
        WITH FRAME {&FRAME-NAME}.    

   ENABLE v-cod-estab-man
          v-cod-nat-oper-man
          v-cdn-canal-man
          v-cod-unid-neg-man
          v-cod-conta-man
          v-cod-ccusto-man
          WITH FRAME {&FRAME-NAME}.

   /*aqui*/

   APPLY "entry" TO v-cod-estab-man IN FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-mod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-mod wWindow
ON CHOOSE OF bt-mod IN FRAME fpage0 /* Modificar */
DO:
   IF  AVAIL gko-param-contab-totvs11
   THEN DO:
       ENABLE v-cod-conta-man
              v-cod-ccusto-man
              WITH FRAME {&FRAME-NAME}.
                             /*aqui*/
       APPLY "entry" TO v-cod-conta-man IN FRAME {&FRAME-NAME}.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sal wWindow
ON CHOOSE OF bt-sal IN FRAME fpage0 /* Salvar */
DO:
    IF  v-cod-estab-man:SENSITIVE IN FRAME {&FRAME-NAME}
    THEN DO:
        FIND estabelec NO-LOCK
            WHERE estabelec.cod-estabel = INPUT FRAME {&FRAME-NAME} v-cod-estab-man NO-ERROR.
        IF  NOT AVAIL estabelec
        THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 2,
                               INPUT "estabelecimento").
            APPLY "entry" TO v-cod-estab-man IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.

        FIND natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = INPUT FRAME {&FRAME-NAME} v-cod-nat-oper-man NO-ERROR.
        IF  NOT AVAIL natur-oper
        THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 2,
                               INPUT "natureza de opera‡Æo").
            APPLY "entry" TO v-cod-nat-oper-man IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.

        IF INPUT FRAME {&FRAME-NAME} v-cod-unid-neg-man <> ? THEN DO:
            FIND unid_negoc NO-LOCK
                WHERE unid_negoc.cod_unid_negoc = INPUT FRAME {&FRAME-NAME} v-cod-unid-neg-man NO-ERROR.
            IF  NOT AVAIL unid_negoc
            THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 2,
                                   INPUT "unidade de neg¢cio").
                APPLY "entry" TO v-cod-unid-neg-man IN FRAME {&FRAME-NAME}.
                RETURN NO-APPLY.
            END.
        END.

        IF  INPUT FRAME {&FRAME-NAME} v-cdn-canal-man <> ? THEN DO:
            FIND canal-venda NO-LOCK
                WHERE canal-venda.cod-canal-venda = INPUT FRAME {&FRAME-NAME} v-cdn-canal-man NO-ERROR.
            IF  NOT AVAIL canal-venda
            THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 2,
                                   INPUT "canal de venda").
                APPLY "entry" TO v-cdn-canal-man IN FRAME {&FRAME-NAME}.
                RETURN NO-APPLY.
            END.
        END.
    END. /* IF  v-cod-estab-man:SENSITIVE IN FRAME {&FRAME-NAME} */

    IF  v-cod-conta-man:SENSITIVE IN FRAME {&FRAME-NAME}
    THEN DO:
        EMPTY TEMP-TABLE tt_log_erro.
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        run pi_valida_conta_contabil in h_api_cta_ctbl (input  i-ep-codigo-usuario,                        /* EMPRESA EMS2 */
                                                        input  INPUT FRAME {&FRAME-NAME} v-cod-estab-man,                          /* ESTABELECIMENTO EMS2 */
                                                        input  "",                                         /* UNIDADE NEGàCIO */
                                                        input  "",                                         /* PLANO CONTAS */ 
                                                        input  INPUT FRAME {&FRAME-NAME} v-cod-conta-man,  /* CONTA */
                                                        input  "",                                         /* PLANO CCUSTO */ 
                                                        input  INPUT FRAME {&FRAME-NAME} v-cod-ccusto-man, /* CCUSTO */
                                                        input  today,                                      /* DATA TRANSACAO */
                                                        output table tt_log_erro).                         /* ERROS */
        if valid-handle(h_api_cta_ctbl) 
        then
            delete object h_api_cta_ctbl.

        IF  CAN-FIND(FIRST tt_log_erro)
        THEN DO:
            FOR EACH tt_log_erro NO-LOCK:
                RUN utp/ut-msgs.p (INPUT "show",
                   INPUT 27100,
                   INPUT "Conta com Problema : " + string(ttv_num_cod_erro) + " " + ttv_des_msg_erro).
            END.
            APPLY "entry" TO v-cod-conta-man IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.
    END. /* IF  v-cod-conta-man:SENSITIVE IN FRAME {&FRAME-NAME} */


    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 27100,
                       INPUT "Salvar configura‡Æo de conta?").

    IF  RETURN-VALUE = "yes"
    THEN DO:
        FIND gko-param-contab-totvs11 EXCLUSIVE-LOCK
            WHERE gko-param-contab-totvs11.cod-estabel     = INPUT FRAME {&FRAME-NAME} v-cod-estab-man   
              AND gko-param-contab-totvs11.nat-operacao    = INPUT FRAME {&FRAME-NAME} v-cod-nat-oper-man
              AND gko-param-contab-totvs11.cod-unid-negoc  = INPUT FRAME {&FRAME-NAME} v-cod-unid-neg-man 
              AND gko-param-contab-totvs11.cod-canal-venda = INPUT FRAME {&FRAME-NAME} v-cdn-canal-man NO-ERROR. 

        IF  v-cod-estab-man:SENSITIVE IN FRAME {&FRAME-NAME} AND
            AVAIL gko-param-contab-totvs11
        THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 1,
                               INPUT "parametriza‡Æo de conta").
            APPLY "entry" TO v-cod-estab-man IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.

        IF  NOT AVAIL gko-param-contab-totvs11
        THEN DO:
            CREATE gko-param-contab-totvs11.
            ASSIGN gko-param-contab-totvs11.cod-estabel     = INPUT FRAME {&FRAME-NAME} v-cod-estab-man   
                   gko-param-contab-totvs11.nat-operacao    = INPUT FRAME {&FRAME-NAME} v-cod-nat-oper-man
                   gko-param-contab-totvs11.cod-canal-venda = INPUT FRAME {&FRAME-NAME} v-cdn-canal-man
                   gko-param-contab-totvs11.cod-unid-negoc  = INPUT FRAME {&FRAME-NAME} v-cod-unid-neg-man
                   gko-param-contab-totvs11.ct-codigo       = INPUT FRAME {&FRAME-NAME} v-cod-conta-man
                   gko-param-contab-totvs11.sc-codigo       = INPUT FRAME {&FRAME-NAME} v-cod-ccusto-man
                   v-row-gko-param-contab-totvs11           = ROWID(gko-param-contab-totvs11).

            {&OPEN-QUERY-br-contas}
            REPOSITION br-contas TO ROWID(v-row-gko-param-contab-totvs11).
        END.
        ELSE DO:
            ASSIGN gko-param-contab-totvs11.ct-codigo = INPUT FRAME {&FRAME-NAME} v-cod-conta-man
                   gko-param-contab-totvs11.sc-codigo = INPUT FRAME {&FRAME-NAME} v-cod-ccusto-man.

            br-contas:REFRESH().
        END.

        DISABLE v-cod-estab-man
                v-cod-nat-oper-man
                v-cdn-canal-man
                v-cod-unid-neg-man
                v-cod-conta-man
                v-cod-ccusto-man
                WITH FRAME {&FRAME-NAME}.
        APPLY "value-changed" TO br-contas IN FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-cdn-canal-man
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cdn-canal-man wWindow
ON F5 OF v-cdn-canal-man IN FRAME fpage0 /* Canal */
DO:
    {include/zoomvar.i &prog-zoom=dizoom/z01di232.w
                       &campo=v-cdn-canal-man
                       &campozoom=cod-canal-venda
                       &frame=fPage0}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cdn-canal-man wWindow
ON LEAVE OF v-cdn-canal-man IN FRAME fpage0 /* Canal */
DO:
    FIND canal-venda NO-LOCK WHERE 
         canal-venda.cod-canal-venda = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN v-des-canal = IF AVAIL canal-venda THEN canal-venda.descricao ELSE "".
    DISPLAY v-des-canal WITH FRAME {&FRAME-NAME}.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cdn-canal-man wWindow
ON MOUSE-SELECT-DBLCLICK OF v-cdn-canal-man IN FRAME fpage0 /* Canal */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-cod-ccusto-man
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-ccusto-man wWindow
ON F5 OF v-cod-ccusto-man IN FRAME fpage0 /* C.Custo */
DO:
    run prgint/utb/utb742za.py persistent set h_api_ccusto.

    assign v_ind_finalid_cta = "(nenhum)".

    EMPTY TEMP-TABLE tt_log_erro.
    run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_titulo_ccusto,
                                        OUTPUT TABLE tt_log_erro).

    if valid-handle(h_api_ccusto) then delete object h_api_ccusto.     

    IF  NOT CAN-FIND(FIRST tt_log_erro) 
    THEN
        ASSIGN v-cod-ccusto-man:SCREEN-VALUE = v_cod_ccusto
               v-des-ccusto:SCREEN-VALUE     = v_des_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-ccusto-man wWindow
ON LEAVE OF v-cod-ccusto-man IN FRAME fpage0 /* C.Custo */
DO:
    RUN prgint/utb/utb742za.py persistent set h_api_ccusto.

    ASSIGN v_cod_ccusto = INPUT FRAME {&FRAME-NAME} v-cod-ccusto-man.

    EMPTY TEMP-TABLE tt_log_erro.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input TODAY,              /* DATA DE TRANSACAO */
                                               output v_des_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */
    IF VALID-HANDLE(h_api_ccusto) THEN
        DELETE OBJECT h_api_ccusto.

    DISP v_des_titulo_ccusto @ v-des-ccusto WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-ccusto-man wWindow
ON MOUSE-SELECT-DBLCLICK OF v-cod-ccusto-man IN FRAME fpage0 /* C.Custo */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-cod-conta-man
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-conta-man wWindow
ON F5 OF v-cod-conta-man IN FRAME fpage0 /* Conta */
DO:
    RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    EMPTY TEMP-TABLE tt_log_erro.

    assign v_ind_finalid_cta = "(nenhum)".
    
    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT i-ep-codigo-usuario,
                                                  INPUT "CEP",
                                                  INPUT "",
                                                  INPUT v_ind_finalid_cta,
                                                  INPUT TODAY,
                                                  OUTPUT v_cod_conta,
                                                  OUTPUT v_des_titulo_conta,
                                                  OUTPUT v_ind_finalid_cta,
                                                  OUTPUT TABLE tt_log_erro).
    if valid-handle(h_api_cta_ctbl) 
    then 
        delete object h_api_cta_ctbl.  
    
    IF  NOT CAN-FIND(FIRST tt_log_erro) 
    THEN DO:
        ASSIGN SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_conta
               v-des-conta:SCREEN-VALUE                 = v_des_titulo_conta.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-conta-man wWindow
ON LEAVE OF v-cod-conta-man IN FRAME fpage0 /* Conta */
DO:
    ASSIGN v_cod_conta = input frame fPage0 v-cod-conta-man.

    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    RUN prgint/utb/utb742za.py persistent set h_api_ccusto.

    EMPTY TEMP-TABLE tt_log_erro.

    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  "",                 /* EMPRESA EMS 2 */
                                                       input  "",                 /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  v_cod_conta,        /* CONTA */
                                                       input  today,              /* DT TRANSACAO */
                                                       output p_log_ccusto,       /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */
    
    
    IF  NOT p_log_ccusto 
    AND v-cod-conta-man:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
        ASSIGN v-cod-ccusto-man:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               v-cod-ccusto-man:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.
    ELSE DO:
        IF v-cod-conta-man:SENSITIVE IN FRAME {&FRAME-NAME} THEN
            ASSIGN v-cod-ccusto-man:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END.
    
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                                   input        "",                  /* PLANO DE CONTAS */
                                                   input-output v_cod_conta,         /* CONTA */
                                                   input TODAY,                      /* DATA TRANSACAO */   
                                                   output       v_des_titulo_conta,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl,  /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl,  /* SITUA›øO DA CONTA */
                                                   output       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).        /* ERROS */

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DELETE OBJECT h_api_cta_ctbl.
    IF VALID-HANDLE(h_api_ccusto)   THEN DELETE OBJECT h_api_ccusto.
 
    DISP v_des_titulo_conta @ v-des-conta WITH FRAME {&FRAME-NAME}.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-conta-man wWindow
ON MOUSE-SELECT-DBLCLICK OF v-cod-conta-man IN FRAME fpage0 /* Conta */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-cod-estab-man
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-estab-man wWindow
ON F5 OF v-cod-estab-man IN FRAME fpage0 /* Estab */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=v-cod-estab-man
                       &campozoom=cod-estabel
                       &frame=fPage0}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-estab-man wWindow
ON LEAVE OF v-cod-estab-man IN FRAME fpage0 /* Estab */
DO:
    FIND estabelec NO-LOCK WHERE 
         estabelec.cod-estabel = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN v-des-estab = IF AVAILABLE estabelec THEN estabelec.nome ELSE "".
    DISPLAY v-des-estab WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-estab-man wWindow
ON MOUSE-SELECT-DBLCLICK OF v-cod-estab-man IN FRAME fpage0 /* Estab */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-cod-nat-oper-man
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-nat-oper-man wWindow
ON F5 OF v-cod-nat-oper-man IN FRAME fpage0 /* Natureza */
DO:
/*     {include/zoomvar.i &prog-zoom=inzoom/z04in245.w */
/*                        &campo=v-cod-nat-oper-man    */
/*                        &campozoom=nat-operacao      */
/*                        &frame=fPage0}               */


    {method/zoomfields.i &ProgramZoom="inzoom/z04in245.w" 
                         &FieldZoom1="nat-operacao"
                         &FieldScreen1="v-cod-nat-oper-man"
                         &Frame1="fPage0"                                                  
                         &EnableImplant="NO"}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-nat-oper-man wWindow
ON LEAVE OF v-cod-nat-oper-man IN FRAME fpage0 /* Natureza */
DO:
    FIND natur-oper NO-LOCK WHERE 
         natur-oper.nat-operacao = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN v-des-natur = IF AVAIL natur-oper THEN natur-oper.denominacao ELSE "".
    DISPLAY v-des-natur WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-nat-oper-man wWindow
ON LEFT-MOUSE-DBLCLICK OF v-cod-nat-oper-man IN FRAME fpage0 /* Natureza */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-cod-unid-neg-man
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-unid-neg-man wWindow
ON F5 OF v-cod-unid-neg-man IN FRAME fpage0 /* Unid Neg */
DO:
    {method/ZoomFields.i &ProgramZoom="inzoom/z01in745.w"
                         &FieldZoom1="cod-unid-negoc"
                         &FieldScreen1="v-cod-unid-neg-man"
                         &Frame1="fPage0"
                         &FieldZoom2="des-unid-negoc"
                         &FieldScreen2="v-des-unid"
                         &Frame2="fPage0"
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-unid-neg-man wWindow
ON LEAVE OF v-cod-unid-neg-man IN FRAME fpage0 /* Unid Neg */
DO:
    FIND FIRST unid_negoc NO-LOCK
         WHERE unid_negoc.cod_unid_negoc = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN v-des-unid = IF AVAILABLE unid_negoc THEN unid_negoc.des_unid_negoc ELSE ''.
    DISPLAY v-des-unid WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-unid-neg-man wWindow
ON MOUSE-SELECT-DBLCLICK OF v-cod-unid-neg-man IN FRAME fpage0 /* Unid Neg */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

v-cod-estab-man:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fPage0. 
v-cod-nat-oper-man:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0. 
v-cdn-canal-man:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fPage0. 
v-cod-unid-neg-man:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0. 
v-cod-conta-man:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fPage0. 
v-cod-ccusto-man:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage0. 

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


