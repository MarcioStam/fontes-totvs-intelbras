&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-nota-conhec NO-UNDO LIKE int-nota-conhec
       field dat-emissao  as date
       field dat-saida    like nota-fiscal.dt-saida
       field nome-transp  like nota-fiscal.nome-transp
       field cep          like nota-fiscal.cep
       field vl-mercad    like nota-fiscal.vl-mercad
       field nat-operacao like nota-fiscal.nat-operacao
       field row-int-nota  as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESGTP012 2.00.04.002}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESGTP012
&GLOBAL-DEFINE Version        2.00.04.002

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Folder1

&GLOBAL-DEFINE page0Widgets   v-cod-estab-ini v-cod-estab-fim v-dat-ini v-dat-fim v-dat-ger-etiq-ini v-dat-ger-etiq-fim v-cod-cc-ini v-cod-cc-fim v-cod-user-ini v-cod-user-fim bt-fil br-correios btExit tg-pac tg-sedex tg-esedex tg-reimpressao bt-loc v-cod-objeto v-dt-saida bt-fil-dt-saida bt-excel bt-arq bt-imp bt-salva v-cod-arquivo bt-excel-2

&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE v-dat-tmp    AS DATE        NO-UNDO.
DEFINE VARIABLE v-row-objeto AS ROWID       NO-UNDO.

DEFINE VARIABLE cCampoSearch AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-linha  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lDesc        AS LOGICAL     NO-UNDO INITIAL NO.
DEFINE VARIABLE cQuery       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iContReg     AS INTEGER     NO-UNDO.


/* Temp Table Definitions ---                                          */

DEFINE TEMP-TABLE tt-dados-excel NO-UNDO
    FIELD nome-transp LIKE nota-fiscal.nome-transp
    FIELD nr-cartao   LIKE int-nota-conhec.nr-cartao
    FIELD nr-conhec   LIKE int-nota-conhec.nr-conhec
    FIELD cep         LIKE nota-fiscal.cep
    FIELD peso-bruto  LIKE int-nota-conhec.peso-bruto
    FIELD vl-mercad   LIKE nota-fiscal.vl-mercad
    INDEX chNomeTransp IS PRIMARY
        nome-transp.

DEFINE TEMP-TABLE tt-objetos NO-UNDO
    FIELD cod-objeto  AS CHAR
    FIELD val-cobrado AS DEC
    INDEX id-objeto
            cod-objeto.

DEFINE VAR c-formato AS CHAR NO-UNDO.
DEFINE VAR c-formato-estab AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-correios

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-nota-conhec

/* Definitions for BROWSE br-correios                                   */
&Scoped-define FIELDS-IN-QUERY-br-correios tt-int-nota-conhec.cod-estabel ~
tt-int-nota-conhec.nr-nota-fis tt-int-nota-conhec.serie ~
tt-int-nota-conhec.nat-operacao @ tt-int-nota-conhec.nat-operacao ~
tt-int-nota-conhec.nr-volume tt-int-nota-conhec.nr-conhec ~
tt-int-nota-conhec.centro-custo-frete tt-int-nota-conhec.peso-bruto ~
tt-int-nota-conhec.val-frete-previsto tt-int-nota-conhec.dec-1 ~
tt-int-nota-conhec.nr-cartao ~
tt-int-nota-conhec.nome-transp @ tt-int-nota-conhec.nome-transp ~
tt-int-nota-conhec.dat-emissao @ tt-int-nota-conhec.dat-emissao ~
tt-int-nota-conhec.dat-saida @ tt-int-nota-conhec.dat-saida ~
tt-int-nota-conhec.dat-1 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-correios 
&Scoped-define QUERY-STRING-br-correios FOR EACH tt-int-nota-conhec NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-correios OPEN QUERY br-correios FOR EACH tt-int-nota-conhec NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-correios tt-int-nota-conhec
&Scoped-define FIRST-TABLE-IN-QUERY-br-correios tt-int-nota-conhec


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-correios}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tg-reimpressao v-cod-estab-ini ~
v-cod-estab-fim v-dat-ini v-dat-fim v-dat-ger-etiq-ini v-dat-ger-etiq-fim ~
v-cod-cc-ini v-cod-cc-fim tg-pac tg-sedex tg-esedex bt-fil v-cod-objeto ~
bt-loc v-dt-saida bt-fil-dt-saida bt-excel btExit br-correios v-cod-arquivo ~
bt-arq bt-imp bt-salva v-cod-user-ini v-cod-user-fim bt-excel-2 RECT-1 ~
RECT-2 RECT-3 RECT-11 RECT-12 
&Scoped-Define DISPLAYED-OBJECTS tg-reimpressao v-cod-estab-ini ~
v-cod-estab-fim v-dat-ini v-dat-fim v-dat-ger-etiq-ini v-dat-ger-etiq-fim ~
v-cod-cc-ini v-cod-cc-fim tg-pac tg-sedex tg-esedex v-cod-objeto v-dt-saida ~
v-cod-arquivo v-cod-user-ini v-cod-user-fim 

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

DEFINE MENU pmn-br-correios 
       MENU-ITEM miExcluir      LABEL "&Excluir Registro(s)"
       RULE
       MENU-ITEM miMoverColuna  LABEL "&Mover Coluna?"
              TOGGLE-BOX.


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arq 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Localizar arquivo de fatura".

DEFINE BUTTON bt-excel 
     IMAGE-UP FILE "image/excel.bmp":U
     LABEL "Gerar Relat¢rio de Embarque" 
     SIZE 4 BY 1.13 TOOLTIP "Gerar Relat¢rio de Embarque no Excel".

DEFINE BUTTON bt-excel-2 
     IMAGE-UP FILE "image/excel.bmp":U
     LABEL "Gerar Relat¢rio de Embarque" 
     SIZE 4 BY 1.13 TOOLTIP "Gerar Relat¢rio do Grid Abaixo em Excel".

DEFINE BUTTON bt-fil 
     IMAGE-UP FILE "image/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-enter.bmp":U
     LABEL "Filtrar" 
     SIZE 4 BY 1 TOOLTIP "Filtrar objetos expedidos pelos Correios"
     FONT 4.

DEFINE BUTTON bt-fil-dt-saida 
     IMAGE-UP FILE "image/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-enter.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Atualizar data de sa°da na Nota Fiscal".

DEFINE BUTTON bt-imp 
     IMAGE-UP FILE "image/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-enter.bmp":U
     LABEL "Filtrar" 
     SIZE 4 BY 1 TOOLTIP "Importar arquivo de faturas informado"
     FONT 4.

DEFINE BUTTON bt-loc 
     IMAGE-UP FILE "image/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-enter.bmp":U
     LABEL "Localizar" 
     SIZE 4 BY 1 TOOLTIP "Localizar frete atravÇs do c¢digo do objeto"
     FONT 4.

DEFINE BUTTON bt-salva 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1 TOOLTIP "Salvar valores importados"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Sair" 
     SIZE 4 BY 1.13 TOOLTIP "Sair do programa"
     FONT 4.

DEFINE VARIABLE v-cod-arquivo AS CHARACTER FORMAT "X(100)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 59 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-cc-fim AS CHARACTER FORMAT "X(10)":U INITIAL "99999999" 
     LABEL "AtÇ" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-cc-ini AS CHARACTER FORMAT "X(10)":U 
     LABEL "C.Custo" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-estab-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     LABEL "AtÇ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-estab-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-objeto AS CHARACTER FORMAT "X(14)":U 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-user-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     LABEL "AtÇ" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-user-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE v-dat-fim AS DATE FORMAT "99/99/9999":U 
     LABEL "AtÇ" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE v-dat-ger-etiq-fim AS DATE FORMAT "99/99/9999" 
     LABEL "AtÇ" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88.

DEFINE VARIABLE v-dat-ger-etiq-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Geraá∆o Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88.

DEFINE VARIABLE v-dat-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Emiss∆o Nota" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE v-dt-saida AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61.57 BY 6.17.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 1.75.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 5 BY 6.17.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21.29 BY 2.67.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21.29 BY 2.67.

DEFINE VARIABLE tg-esedex AS LOGICAL INITIAL yes 
     LABEL "E-SEDEX" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-pac AS LOGICAL INITIAL yes 
     LABEL "PAC" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-reimpressao AS LOGICAL INITIAL no 
     LABEL "Reimpress∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sedex AS LOGICAL INITIAL yes 
     LABEL "SEDEX" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-correios FOR 
      tt-int-nota-conhec SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-correios
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-correios wWindow _STRUCTURED
  QUERY br-correios NO-LOCK DISPLAY
      tt-int-nota-conhec.cod-estabel COLUMN-LABEL "Est" FORMAT "X(3)":U
            WIDTH 3.43
      tt-int-nota-conhec.nr-nota-fis FORMAT "X(12)":U WIDTH 8.86
      tt-int-nota-conhec.serie FORMAT "X(5)":U WIDTH 3.29
      tt-int-nota-conhec.nat-operacao @ tt-int-nota-conhec.nat-operacao
      tt-int-nota-conhec.nr-volume COLUMN-LABEL "Vol." FORMAT ">>>>>>>9":U
            WIDTH 3.57
      tt-int-nota-conhec.nr-conhec COLUMN-LABEL "Objeto" FORMAT "x(20)":U
            WIDTH 17
      tt-int-nota-conhec.centro-custo-frete COLUMN-LABEL "C Custo" FORMAT "x(8)":U
      tt-int-nota-conhec.peso-bruto COLUMN-LABEL "Peso" FORMAT "->>,>>9.999":U
            WIDTH 7
      tt-int-nota-conhec.val-frete-previsto COLUMN-LABEL "R$ Previsto" FORMAT ">>>,>>9.99":U
      tt-int-nota-conhec.dec-1 COLUMN-LABEL "R$ Cobrado" FORMAT ">>>,>>9.99":U
            WIDTH 10.86
      tt-int-nota-conhec.nr-cartao COLUMN-LABEL "Cart∆o" FORMAT "x(15)":U
            WIDTH 12.29
      tt-int-nota-conhec.nome-transp @ tt-int-nota-conhec.nome-transp COLUMN-LABEL "Transp" FORMAT "x(12)":U
      tt-int-nota-conhec.dat-emissao @ tt-int-nota-conhec.dat-emissao COLUMN-LABEL "Emiss∆o" FORMAT "99/99/9999":U
      tt-int-nota-conhec.dat-saida @ tt-int-nota-conhec.dat-saida COLUMN-LABEL "Sa°da" FORMAT "99/99/9999":U
      tt-int-nota-conhec.dat-1 COLUMN-LABEL "Geraá∆o Etiq" FORMAT "99/99/9999":U
            WIDTH 9.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 89 BY 13.38
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tg-reimpressao AT ROW 6 COL 46 WIDGET-ID 72
     v-cod-estab-ini AT ROW 1.83 COL 14.29 COLON-ALIGNED HELP
          "Estabelecimento Inicial"
     v-cod-estab-fim AT ROW 1.83 COL 30.43 COLON-ALIGNED HELP
          "Estabelecimento Final"
     v-dat-ini AT ROW 2.83 COL 14.29 COLON-ALIGNED HELP
          "Data de Emiss∆o da Nota Fiscal Inicial"
     v-dat-fim AT ROW 2.83 COL 30.43 COLON-ALIGNED HELP
          "Data de Emiss∆o da Nota Fiscal Final"
     v-dat-ger-etiq-ini AT ROW 3.83 COL 14.29 COLON-ALIGNED HELP
          "Data de Geraá∆o da Etiqueta Inicial"
     v-dat-ger-etiq-fim AT ROW 3.83 COL 30.43 COLON-ALIGNED HELP
          "Data de Geraá∆o da Etiqueta Final"
     v-cod-cc-ini AT ROW 4.83 COL 14.29 COLON-ALIGNED HELP
          "Centro de Custo Inicial"
     v-cod-cc-fim AT ROW 4.83 COL 30.43 COLON-ALIGNED HELP
          "Centro de Custo Final"
     tg-pac AT ROW 3 COL 46 HELP
          "PAC"
     tg-sedex AT ROW 4 COL 46 HELP
          "SEDEX"
     tg-esedex AT ROW 5 COL 46 HELP
          "E-SEDEX"
     bt-fil AT ROW 6 COL 59 HELP
          "Filtrar objetos expedidos pelos Correios"
     v-cod-objeto AT ROW 2.29 COL 62.86 COLON-ALIGNED HELP
          "C¢digo do Objeto" NO-LABEL
     bt-loc AT ROW 2.21 COL 80.43 HELP
          "Localizar frete atravÇs do c¢digo do objeto"
     v-dt-saida AT ROW 5.58 COL 63 COLON-ALIGNED HELP
          "Data Sa°da" NO-LABEL
     bt-fil-dt-saida AT ROW 5.5 COL 80.57 HELP
          "Atualizar data de sa°da na Nota Fiscal"
     bt-excel AT ROW 6 COL 86.43 HELP
          "Gerar Relat¢rio de Embarque no Excel"
     btExit AT ROW 1.42 COL 86.43 HELP
          "Sair do programa"
     br-correios AT ROW 10.25 COL 2
     v-cod-arquivo AT ROW 8.63 COL 9 COLON-ALIGNED WIDGET-ID 4
     bt-arq AT ROW 8.54 COL 70.29 HELP
          "Localiza Arquivo" WIDGET-ID 6
     bt-imp AT ROW 8.54 COL 74.43 HELP
          "Filtrar objetos expedidos pelos Correios" WIDGET-ID 46
     bt-salva AT ROW 8.54 COL 78.57 HELP
          "Confirma alteraá‰es" WIDGET-ID 50
     v-cod-user-ini AT ROW 6 COL 14 COLON-ALIGNED HELP
          "Centro de Custo Inicial" WIDGET-ID 66
     v-cod-user-fim AT ROW 6 COL 30.14 COLON-ALIGNED HELP
          "Centro de Custo Final" WIDGET-ID 64
     bt-excel-2 AT ROW 8.5 COL 83 HELP
          "Gerar Relat¢rio de Embarque no Excel" WIDGET-ID 68
     " Filtro" VIEW-AS TEXT
          SIZE 5 BY .67 AT ROW 1 COL 2.57
     " Localizar Objeto" VIEW-AS TEXT
          SIZE 12 BY .67 AT ROW 1.08 COL 65
     " Gera Data Sa°da" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 4.5 COL 65
     " Importaá∆o Fatura" VIEW-AS TEXT
          SIZE 14 BY .67 AT ROW 7.75 COL 3 WIDGET-ID 60
     RECT-1 AT ROW 1.33 COL 2
     RECT-2 AT ROW 1.33 COL 64
     RECT-3 AT ROW 4.75 COL 64
     RECT-11 AT ROW 8.04 COL 2 WIDGET-ID 2
     RECT-12 AT ROW 1.33 COL 86 WIDGET-ID 62
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 22.92
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-int-nota-conhec T "?" NO-UNDO mgesp int-nota-conhec
      ADDITIONAL-FIELDS:
          field dat-emissao  as date
          field dat-saida    like nota-fiscal.dt-saida
          field nome-transp  like nota-fiscal.nome-transp
          field cep          like nota-fiscal.cep
          field vl-mercad    like nota-fiscal.vl-mercad
          field nat-operacao like nota-fiscal.nat-operacao
          field row-int-nota  as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 22.92
         WIDTH              = 90.43
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
/* BROWSE-TAB br-correios btExit fpage0 */
ASSIGN 
       br-correios:POPUP-MENU IN FRAME fpage0             = MENU pmn-br-correios:HANDLE
       br-correios:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE
       br-correios:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-correios
/* Query rebuild information for BROWSE br-correios
     _TblList          = "Temp-Tables.tt-int-nota-conhec"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-int-nota-conhec.cod-estabel
"tt-int-nota-conhec.cod-estabel" "Est" ? "character" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-int-nota-conhec.nr-nota-fis
"tt-int-nota-conhec.nr-nota-fis" ? ? "character" ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-int-nota-conhec.serie
"tt-int-nota-conhec.serie" ? ? "character" ? ? ? ? ? ? no ? no no "3.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"tt-int-nota-conhec.nat-operacao @ tt-int-nota-conhec.nat-operacao" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-int-nota-conhec.nr-volume
"tt-int-nota-conhec.nr-volume" "Vol." ? "integer" ? ? ? ? ? ? no ? no no "3.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-int-nota-conhec.nr-conhec
"tt-int-nota-conhec.nr-conhec" "Objeto" ? "character" ? ? ? ? ? ? no ? no no "17" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-int-nota-conhec.centro-custo-frete
"tt-int-nota-conhec.centro-custo-frete" "C Custo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-int-nota-conhec.peso-bruto
"tt-int-nota-conhec.peso-bruto" "Peso" ? "decimal" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-int-nota-conhec.val-frete-previsto
"tt-int-nota-conhec.val-frete-previsto" "R$ Previsto" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-int-nota-conhec.dec-1
"tt-int-nota-conhec.dec-1" "R$ Cobrado" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-int-nota-conhec.nr-cartao
"tt-int-nota-conhec.nr-cartao" "Cart∆o" ? "character" ? ? ? ? ? ? no ? no no "12.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"tt-int-nota-conhec.nome-transp @ tt-int-nota-conhec.nome-transp" "Transp" "x(12)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"tt-int-nota-conhec.dat-emissao @ tt-int-nota-conhec.dat-emissao" "Emiss∆o" "99/99/9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"tt-int-nota-conhec.dat-saida @ tt-int-nota-conhec.dat-saida" "Sa°da" "99/99/9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.tt-int-nota-conhec.dat-1
"tt-int-nota-conhec.dat-1" "Geraá∆o Etiq" ? "date" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-correios */
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


&Scoped-define BROWSE-NAME br-correios
&Scoped-define SELF-NAME br-correios
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-correios wWindow
ON DELETE-CHARACTER OF br-correios IN FRAME fpage0
DO:
    IF  SESSION:SET-WAIT-STATE("general") THEN.

    IF SELF:NUM-SELECTED-ROWS > 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 46700,
                           INPUT "":U).

        IF RETURN-VALUE = "YES":U THEN DO:
            IF  SESSION:SET-WAIT-STATE("general") THEN.

            DO iContReg = 1 TO SELF:NUM-SELECTED-ROWS:
                SELF:FETCH-SELECTED-ROW(iContReg).

                IF AVAILABLE tt-int-nota-conhec THEN
                    DELETE tt-int-nota-conhec.
            END.

            {&OPEN-QUERY-br-correios}
        END.
    END.
    ELSE
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17197,
                           INPUT "ao menos um registro":U).

    IF  SESSION:SET-WAIT-STATE("") THEN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-correios wWindow
ON START-SEARCH OF br-correios IN FRAME fpage0
DO:
    IF SELF:CURRENT-COLUMN:TABLE  = "tt-int-nota-conhec":U AND
       SELF:CURRENT-COLUMN:NAME  <> ?                      AND
       SELF:CURRENT-COLUMN:NAME  <> "":U                   THEN DO:
        IF cCampoSearch = SELF:CURRENT-COLUMN:NAME THEN DO:
            ASSIGN lDesc = NOT lDesc.

            IF lDesc THEN DO:
                cQuery = "FOR EACH tt-int-nota-conhec OUTER-JOIN BY tt-int-nota-conhec.":U + SELF:CURRENT-COLUMN:NAME + " DESC INDEXED-REPOSITION":U.
            END.
            ELSE DO:
                cQuery = "FOR EACH tt-int-nota-conhec OUTER-JOIN BY tt-int-nota-conhec.":U + SELF:CURRENT-COLUMN:NAME + " INDEXED-REPOSITION":U.
            END.
        END.
        ELSE DO:
            ASSIGN cQuery       = "FOR EACH tt-int-nota-conhec OUTER-JOIN BY tt-int-nota-conhec.":U + SELF:CURRENT-COLUMN:NAME + " INDEXED-REPOSITION":U
                   cCampoSearch = SELF:CURRENT-COLUMN:NAME
                   lDesc        = NO.
        END.

        SELF:QUERY:QUERY-PREPARE(cQuery).
        SELF:QUERY:QUERY-OPEN().
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arq wWindow
ON CHOOSE OF bt-arq IN FRAME fpage0
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok        as logical init no.

    assign c-arq-conv ="".

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.csv" "*.csv"
       DEFAULT-EXTENSION "csv"
       MUST-EXIST
       USE-FILENAME
       TITLE 'Importar do arquivo'
       UPDATE l-ok.

    IF l-ok THEN DO:
        assign v-cod-arquivo = c-arq-conv.
        display v-cod-arquivo with frame {&FRAME-NAME}.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excel wWindow
ON CHOOSE OF bt-excel IN FRAME fpage0 /* Gerar Relat¢rio de Embarque */
DO:
    IF  SESSION:SET-WAIT-STATE("general") THEN.
    RUN pi-gera-excel IN THIS-PROCEDURE.
    IF  SESSION:SET-WAIT-STATE("") THEN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excel-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excel-2 wWindow
ON CHOOSE OF bt-excel-2 IN FRAME fpage0 /* Gerar Relat¢rio de Embarque */
DO:
    IF  SESSION:SET-WAIT-STATE("general") THEN.
    RUN pi-gera-excel1 IN THIS-PROCEDURE.
    IF  SESSION:SET-WAIT-STATE("") THEN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fil wWindow
ON CHOOSE OF bt-fil IN FRAME fpage0 /* Filtrar */
DO:
    ASSIGN v-cod-estab-ini    = INPUT FRAME {&FRAME-NAME} v-cod-estab-ini
           v-cod-estab-fim    = INPUT FRAME {&FRAME-NAME} v-cod-estab-fim
           v-dat-ini          = INPUT FRAME {&FRAME-NAME} v-dat-ini
           v-dat-fim          = INPUT FRAME {&FRAME-NAME} v-dat-fim
           v-cod-cc-ini       = INPUT FRAME {&FRAME-NAME} v-cod-cc-ini
           v-cod-cc-fim       = INPUT FRAME {&FRAME-NAME} v-cod-cc-fim
           v-dat-ger-etiq-ini = INPUT FRAME {&FRAME-NAME} v-dat-ger-etiq-ini
           v-dat-ger-etiq-fim = INPUT FRAME {&FRAME-NAME} v-dat-ger-etiq-fim
           v-cod-user-ini     = INPUT FRAME {&FRAME-NAME} v-cod-user-ini
           v-cod-user-fim     = INPUT FRAME {&FRAME-NAME} v-cod-user-fim.


    IF  SESSION:SET-WAIT-STATE("general") THEN.

    EMPTY TEMP-TABLE tt-int-nota-conhec.
    {&OPEN-QUERY-br-correios}

    DO v-dat-tmp = v-dat-ini TO v-dat-fim:
        bloco-nf:
        FOR EACH  nota-fiscal NO-LOCK
            WHERE nota-fiscal.dt-emis = v-dat-tmp:

            IF  nota-fiscal.dt-saida <> ? AND
                tg-reimpressao:CHECKED IN FRAME {&FRAME-NAME} = NO
            THEN
                NEXT bloco-nf.

            IF  nota-fiscal.cod-estabel < v-cod-estab-ini OR
                nota-fiscal.cod-estabel > v-cod-estab-fim
            THEN
                NEXT bloco-nf.

            IF  nota-fiscal.nome-transp               = "PAC" AND
                tg-pac:CHECKED IN FRAME {&FRAME-NAME} = NO
            THEN
                NEXT bloco-nf.

            IF  nota-fiscal.nome-transp                 = "SEDEX" AND
                tg-sedex:CHECKED IN FRAME {&FRAME-NAME} = NO
            THEN
                NEXT bloco-nf.

            IF  nota-fiscal.nome-transp                  = "E-SEDEX" AND
                tg-esedex:CHECKED IN FRAME {&FRAME-NAME} = NO
            THEN
                NEXT bloco-nf.

            FOR EACH  int-nota-conhec NO-LOCK
                WHERE int-nota-conhec.cod-estabel         = nota-fiscal.cod-estabel
                  AND int-nota-conhec.serie               = nota-fiscal.serie
                  AND int-nota-conhec.nr-nota-fis         = nota-fiscal.nr-nota-fis
                  AND int-nota-conhec.centro-custo-frete >= v-cod-cc-ini
                  AND int-nota-conhec.centro-custo-frete <= v-cod-cc-fim
                  AND int-nota-conhec.dat-1              >= v-dat-ger-etiq-ini
                  AND int-nota-conhec.dat-1              <= v-dat-ger-etiq-fim
                  AND substring(int-nota-conhec.char-1,1,10) >= v-cod-user-ini
                  AND substring(int-nota-conhec.char-1,1,10) <= v-cod-user-fim:
                CREATE tt-int-nota-conhec.
                BUFFER-COPY int-nota-conhec TO tt-int-nota-conhec.
                ASSIGN tt-int-nota-conhec.dat-emissao  = nota-fiscal.dt-emis
                       tt-int-nota-conhec.dat-saida    = nota-fiscal.dt-saida
                       tt-int-nota-conhec.nome-transp  = nota-fiscal.nome-transp
                       tt-int-nota-conhec.cep          = nota-fiscal.cep
                       tt-int-nota-conhec.vl-mercad    = nota-fiscal.vl-mercad
                       tt-int-nota-conhec.nat-operacao = nota-fiscal.nat-operacao
                       tt-int-nota-conhec.row-int-nota = ROWID(int-nota-conhec).
            END.
        END.
    END.
    IF  SESSION:SET-WAIT-STATE("") THEN.

    {&OPEN-QUERY-br-correios}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fil-dt-saida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fil-dt-saida wWindow
ON CHOOSE OF bt-fil-dt-saida IN FRAME fpage0
DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 27100,
                       INPUT "Deseja atualizar a data de sa°da das Notas Fiscais?":U).

    IF RETURN-VALUE = "NO":U THEN
        RETURN NO-APPLY.

    ASSIGN INPUT FRAME fPage0 v-dt-saida.

    IF v-dt-saida = ? THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Data de Sa°da inv†lida! Favor preencher o mesmo!":U).

        RETURN NO-APPLY.
    END.

    IF v-dt-saida <> TODAY THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 27100,
                           INPUT "Data Sa°da diferente da data atual. Deseja continuar?":U).

        IF RETURN-VALUE = "NO":U THEN
            RETURN NO-APPLY.
    END.

    FOR EACH tt-int-nota-conhec
        WHERE tt-int-nota-conhec.dat-saida  = ?
          AND tt-int-nota-conhec.nr-conhec <> "":U:
        FIND FIRST nota-fiscal
            WHERE nota-fiscal.cod-estabel = tt-int-nota-conhec.cod-estabel
              AND nota-fiscal.serie       = tt-int-nota-conhec.serie
              AND nota-fiscal.nr-nota-fis = tt-int-nota-conhec.nr-nota-fis EXCLUSIVE-LOCK NO-ERROR.

        IF AVAILABLE nota-fiscal    AND
           nota-fiscal.dt-saida = ? THEN DO:
            ASSIGN nota-fiscal.dt-saida         = v-dt-saida
                   tt-int-nota-conhec.dat-saida = nota-fiscal.dt-saida.
        END.
    END.

    {&OPEN-QUERY-br-correios}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imp wWindow
ON CHOOSE OF bt-imp IN FRAME fpage0 /* Filtrar */
DO:
    IF  SEARCH(INPUT FRAME {&FRAME-NAME} v-cod-arquivo) <> ?
    THEN DO:
        EMPTY TEMP-TABLE tt-objetos.
        ASSIGN iContReg = 0.
        INPUT FROM VALUE(SEARCH(INPUT FRAME {&FRAME-NAME} v-cod-arquivo)).

        REPEAT:
            IMPORT UNFORMATTED v-cod-linha.
            ASSIGN iContReg = iContReg + 1.

            IF  icontreg = 1 AND
                NUM-ENTRIES(v-cod-linha,";") < 16
            THEN DO:
                INPUT CLOSE.
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Arquivo n∆o possui o layout correto para importaá∆o.~~Valide o layout do arquivo junto ao departamento de TIC.").
                RETURN NO-APPLY.
            END.

            IF  icontreg = 1
            THEN
                IF  SESSION:SET-WAIT-STATE("general") THEN.

            IF  icontreg                                >  1 AND
                TRIM(ENTRY(16,v-cod-linha,";"))        <> "" AND
                LENGTH(TRIM(ENTRY(16,v-cod-linha,";"))) > 12
            THEN DO:
                CREATE tt-objetos.
                ASSIGN tt-objetos.cod-objeto  = ENTRY(16,v-cod-linha,";")
                       tt-objetos.val-cobrado = DECIMAL(ENTRY(14,v-cod-linha,";")).
            END.
        END.

        FOR EACH tt-objetos:
            FIND FIRST int-nota-conhec NO-LOCK
                WHERE  int-nota-conhec.nr-conhec = tt-objetos.cod-objeto NO-ERROR.

            IF  AVAIL int-nota-conhec
            THEN DO:
                FIND FIRST tt-int-nota-conhec EXCLUSIVE-LOCK
                    WHERE  tt-int-nota-conhec.row-int-nota = ROWID(int-nota-conhec) NO-ERROR.

                IF  AVAIL tt-int-nota-conhec
                THEN
                    ASSIGN tt-int-nota-conhec.dec-1 = tt-objetos.val-cobrado.
                ELSE DO:
                    FIND FIRST nota-fiscal NO-LOCK
                        WHERE  nota-fiscal.cod-estabel = int-nota-conhec.cod-estabel
                          AND  nota-fiscal.serie       = int-nota-conhec.serie
                          AND  nota-fiscal.nr-nota-fis = int-nota-conhec.nr-nota-fis NO-ERROR.

                    IF  AVAIL nota-fiscal 
                    THEN DO:
                        CREATE tt-int-nota-conhec.
                        BUFFER-COPY int-nota-conhec TO tt-int-nota-conhec.
                        ASSIGN tt-int-nota-conhec.dat-emissao  = nota-fiscal.dt-emis
                               tt-int-nota-conhec.dat-saida    = nota-fiscal.dt-saida
                               tt-int-nota-conhec.nome-transp  = nota-fiscal.nome-transp
                               tt-int-nota-conhec.cep          = nota-fiscal.cep
                               tt-int-nota-conhec.vl-mercad    = nota-fiscal.vl-mercad
                               tt-int-nota-conhec.nat-operacao = nota-fiscal.nat-operacao
                               tt-int-nota-conhec.row-int-nota = ROWID(int-nota-conhec)
                               tt-int-nota-conhec.dec-1        = tt-objetos.val-cobrado.
                    END.
                    ELSE DO:
                        FIND FIRST tt-int-nota-conhec NO-LOCK
                            WHERE  tt-int-nota-conhec.nr-conhec = tt-objetos.cod-objeto NO-ERROR.
                        IF  NOT AVAIL tt-int-nota-conhec
                        THEN DO:
                            CREATE tt-int-nota-conhec.
                            ASSIGN tt-int-nota-conhec.nr-conhec = tt-objetos.cod-objeto
                                   tt-int-nota-conhec.dec-1     = tt-objetos.val-cobrado.
                        END.
                    END.
                END.
            END.
            ELSE DO:
                FIND FIRST tt-int-nota-conhec NO-LOCK
                    WHERE  tt-int-nota-conhec.nr-conhec = tt-objetos.cod-objeto NO-ERROR.
                IF  NOT AVAIL tt-int-nota-conhec
                THEN DO:
                    CREATE tt-int-nota-conhec.
                    ASSIGN tt-int-nota-conhec.nr-conhec = tt-objetos.cod-objeto
                           tt-int-nota-conhec.dec-1     = tt-objetos.val-cobrado.
                END.
            END.
        END.

        IF  SESSION:SET-WAIT-STATE("") THEN.

        {&OPEN-QUERY-br-correios}
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 15825,
                           INPUT "Importaá∆o finalizada com sucesso.").
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Arquivo n∆o encontrado.").
        RETURN NO-APPLY.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-loc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-loc wWindow
ON CHOOSE OF bt-loc IN FRAME fpage0 /* Localizar */
DO:
    FIND FIRST tt-int-nota-conhec NO-LOCK
        WHERE  tt-int-nota-conhec.nr-conhec = INPUT FRAME {&FRAME-NAME} v-cod-objeto NO-ERROR.

    IF  AVAIL tt-int-nota-conhec
    THEN DO:
        ASSIGN v-row-objeto = ROWID(tt-int-nota-conhec).
        REPOSITION br-correios TO ROWID(v-row-objeto).

    END.
    ELSE
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT "15825",
                           INPUT "Objeto n∆o encontrado.").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salva wWindow
ON CHOOSE OF bt-salva IN FRAME fpage0 /* Save */
DO:
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 27100,
                       INPUT "Confirma gravaá∆o dos valores importados?").

    IF  RETURN-VALUE = "yes"
    THEN DO:
        IF  SESSION:SET-WAIT-STATE("general") THEN.
        FOR EACH tt-int-nota-conhec:
            FIND int-nota-conhec EXCLUSIVE-LOCK
                WHERE ROWID(int-nota-conhec) = tt-int-nota-conhec.row-int-nota NO-ERROR.

            IF  AVAIL int-nota-conhec
            THEN DO:
                ASSIGN int-nota-conhec.dec-1 = tt-int-nota-conhec.dec-1.
                RELEASE int-nota-conhec.
            END.
        END.  
        IF  SESSION:SET-WAIT-STATE("") THEN.

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 15825,
                           INPUT "Processo finalizado com sucesso.").
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Sair */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miExcluir wWindow
ON CHOOSE OF MENU-ITEM miExcluir /* Excluir Registro(s) */
DO:
    APPLY "DELETE-CHARACTER":U TO BROWSE br-correios.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miMoverColuna
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miMoverColuna wWindow
ON VALUE-CHANGED OF MENU-ITEM miMoverColuna /* Mover Coluna? */
DO:
    ASSIGN br-correios:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = NOT MENU-ITEM miMoverColuna:CHECKED IN MENU pmn-br-correios
           br-correios:COLUMN-MOVABLE         IN FRAME fpage0 = MENU-ITEM miMoverColuna:CHECKED IN MENU pmn-br-correios.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN v-dat-ini          = TODAY - 1
           v-dat-fim          = TODAY
           v-dat-ger-etiq-ini = TODAY
           v-dat-ger-etiq-fim = TODAY
           v-dt-saida         = TODAY.

    DISPLAY v-dat-ini
            v-dat-fim
            v-dat-ger-etiq-ini
            v-dat-ger-etiq-fim
            v-dt-saida
        WITH FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-excel wWindow 
PROCEDURE pi-gera-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE ch-Excel     AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE c-arq-modelo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iPagina      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iLinha       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cArqTemp     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cPrimPasta   AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME fPage0 v-dt-saida.

    IF v-dt-saida = ? THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Data de Sa°da inv†lida! Favor preencher o mesmo!":U).

        RETURN NO-APPLY.
    END.

    IF v-dt-saida <> TODAY THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 27100,
                           INPUT "Data Sa°da diferente da data atual. Deseja continuar?":U).

        IF RETURN-VALUE = "NO":U THEN
            RETURN NO-APPLY.
    END.

    ASSIGN c-arq-modelo = SEARCH("esp/gtp/esgtp012.xls":U).

    IF c-arq-modelo = ? THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Arquivo modelo do Excel n∆o encontrado!":U).

        RETURN NO-APPLY.
    END.

    ASSIGN cArqTemp = SESSION:TEMP-DIRECTORY + "esgtp012":U + "-":U + REPLACE(STRING(TODAY, "99/99/9999":U), "/":U, ".":U) + "-":U + REPLACE(STRING(TIME, "hh:mm:ss":U), ":":U, ".":U) + ".xls":U.

    OS-DELETE VALUE(cArqTemp) NO-ERROR.
    OS-COPY VALUE(c-arq-modelo) VALUE(cArqTemp).

    ASSIGN c-arq-modelo = cArqTemp.

    IF  SESSION:SET-WAIT-STATE("general") THEN.

    ASSIGN cPrimPasta = "":U.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FOR EACH tt-int-nota-conhec
        /*WHERE tt-int-nota-conhec.dat-saida = v-dt-saida*/
        BREAK BY tt-int-nota-conhec.nome-transp:
        IF FIRST(tt-int-nota-conhec.nome-transp) THEN DO:
            CREATE "Excel.Application " ch-Excel CONNECT NO-ERROR.

            IF ERROR-STATUS:ERROR THEN
                CREATE "Excel.Application" ch-Excel NO-ERROR.

            IF ERROR-STATUS:ERROR THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Erro ao executar o Microsoft Excel.":U +
                                         "~~":U +
                                         "Verifique se o mesmo est† instalado na m†quina.":U).

                IF  SESSION:SET-WAIT-STATE("") THEN.

                RETURN NO-APPLY.
            END.

            ch-Excel:DisplayAlerts = FALSE.
            ch-Excel:Visible = NO.
            ch-Excel:Workbooks:Open(c-arq-modelo).

            ASSIGN iPagina = 1
                   iLinha  = 1.
        END.

        IF FIRST-OF(tt-int-nota-conhec.nome-transp) THEN DO:
            ASSIGN iPagina = 1
                   iLinha  = 1.
        END.

        FIND FIRST nota-fiscal
             WHERE nota-fiscal.cod-estabel = tt-int-nota-conhec.cod-estabel 
               AND nota-fiscal.serie       = tt-int-nota-conhec.serie       
               AND nota-fiscal.nr-nota-fis = tt-int-nota-conhec.nr-nota-fis NO-LOCK NO-ERROR.
        IF AVAIL nota-fiscal THEN
            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

        IF emitente.natureza = 1 then 
          ASSIGN c-formato = param-global.formato-id-pessoal.
        ELSE
          assign c-formato = param-global.formato-id-federal.
       
        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.
        IF AVAIL estabelec THEN
            ASSIGN c-formato-estab = param-global.formato-id-federal.

        IF iLinha = 1 THEN DO:
            ch-Excel:Sheets:Item(1).
            ch-Excel:Sheets:Item("Plan1":U):activate.
            ch-Excel:Sheets("Plan1":U):Copy(ch-Excel:Sheets(1)).
            ch-Excel:Sheets("Plan1 (2)":U):Name = tt-int-nota-conhec.nome-transp + " - Pag. ":U + TRIM(STRING(iPagina)).
            ch-Excel:Sheets(tt-int-nota-conhec.nome-transp + " - Pag. ":U + TRIM(STRING(iPagina))):Select.
            ch-Excel:Sheets(tt-int-nota-conhec.nome-transp + " - Pag. ":U + TRIM(STRING(iPagina))):activate.

            IF cPrimPasta = "":U THEN
                ASSIGN cPrimPasta = tt-int-nota-conhec.nome-transp + " - Pag. ":U + TRIM(STRING(iPagina)).

            ch-Excel:Sheets:Item(1):Cells( 3, "A":U):Value = "LISTA DE POSTAGEM ENCOMENDAS A FATURAR (":U + tt-int-nota-conhec.nome-transp + ")":U.
            ch-Excel:Sheets:Item(1):Cells( 4, "I":U):Value = tt-int-nota-conhec.dat-saida.
            ch-Excel:Sheets:Item(1):Cells(57, "I":U):Value = "P†gina ":U + TRIM(STRING(iPagina)).
            ch-Excel:Sheets:Item(1):Cells(58, "C":U):Value = string(estabelec.cgc,c-formato-estab).
            ch-Excel:Sheets:Item(1):Cells(59, "C":U):Value = TODAY.
        END.

        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "B":U):Value = tt-int-nota-conhec.nr-cartao.

        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "C":U):Value = string(emitente.cgc,c-formato).

        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "E":U):Value = tt-int-nota-conhec.nr-conhec.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "F":U):Value = tt-int-nota-conhec.cep.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "G":U):Value = tt-int-nota-conhec.peso-bruto.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "I":U):NumberFormat = "@":U.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "I":U):Value = TRIM(STRING(tt-int-nota-conhec.nr-nota-fis, "9999999":U)).
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "J":U):Value = tt-int-nota-conhec.serie.
        ch-Excel:Sheets:Item(1):Cells(5, "H":U):Value          = iLinha.

        IF LAST-OF(tt-int-nota-conhec.nome-transp) OR
           iLinha = 42                             THEN DO:
            ch-Excel:Sheets(tt-int-nota-conhec.nome-transp + " - Pag. ":U + TRIM(STRING(iPagina))):MOVE(ch-Excel:Sheets("Plan1":U)).

            ch-Excel:Sheets:Item(1):Cells(58, "C":U):Value = string(estabelec.cgc,c-formato-estab).
            ch-Excel:Sheets:Item(1):Cells(59, "C":U):Value = TODAY.

            ASSIGN iPagina = iPagina + 1
                   iLinha  = 1.
        END.
        ELSE
            ASSIGN iLinha = iLinha + 1.

        IF LAST(tt-int-nota-conhec.nome-transp) THEN DO:

            ch-Excel:Sheets:Item(1):Cells(58, "C":U):Value = string(estabelec.cgc,c-formato-estab).
            ch-Excel:Sheets:Item(1):Cells(59, "C":U):Value = TODAY.

            ch-Excel:Application:DisplayAlerts = False.
            ch-Excel:Sheets("Plan1"):Select.
            ch-Excel:ActiveWindow:SelectedSheets:Delete.

            ch-Excel:Sheets(cPrimPasta):Select.
            ch-Excel:Sheets(cPrimPasta):activate.

            ch-Excel:Application:DisplayAlerts = TRUE.

            ch-Excel:Visible = YES.

            IF VALID-HANDLE(ch-Excel) THEN
                RELEASE OBJECT ch-Excel NO-ERROR.
        END.
    END.

    IF  SESSION:SET-WAIT-STATE("") THEN.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-excel1 wWindow 
PROCEDURE pi-gera-excel1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE ch-Excel     AS COM-HANDLE  NO-UNDO.
    DEFINE VARIABLE c-arq-modelo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iPagina      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iLinha       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cArqTemp     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cPrimPasta   AS CHARACTER   NO-UNDO.

def var h-acomp      as handle no-undo.

run utp/ut-acomp.p persistent set h-acomp.  

RUN pi-inicializar in h-acomp (input "Imprimindo...").
/*                                                                                              */
/*     ASSIGN INPUT FRAME fPage0 v-dt-saida.                                                    */
/*                                                                                              */
/*     IF v-dt-saida = ? THEN DO:                                                               */
/*         RUN utp/ut-msgs.p (INPUT "SHOW":U,                                                   */
/*                            INPUT 17006,                                                      */
/*                            INPUT "Data de Sa°da inv†lida! Favor preencher o mesmo!":U).      */
/*                                                                                              */
/*         RETURN NO-APPLY.                                                                     */
/*     END.                                                                                     */
/*                                                                                              */
/*     IF v-dt-saida <> TODAY THEN DO:                                                          */
/*         RUN utp/ut-msgs.p (INPUT "SHOW":U,                                                   */
/*                            INPUT 27100,                                                      */
/*                            INPUT "Data Sa°da diferente da data atual. Deseja continuar?":U). */
/*                                                                                              */
/*         IF RETURN-VALUE = "NO":U THEN                                                        */
/*             RETURN NO-APPLY.                                                                 */
/*     END.                                                                                     */
/*                                                                                              */
    ASSIGN c-arq-modelo = SEARCH("esp/gtp/esgtp012_2.xls":U).

    IF c-arq-modelo = ? THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Arquivo modelo do Excel n∆o encontrado!":U).

        RETURN NO-APPLY.
    END.

    ASSIGN cArqTemp = SESSION:TEMP-DIRECTORY + "esgtp012":U + "-":U + REPLACE(STRING(TODAY, "99/99/9999":U), "/":U, ".":U) + "-":U + REPLACE(STRING(TIME, "hh:mm:ss":U), ":":U, ".":U) + ".xls":U.

     OS-DELETE VALUE(cArqTemp) NO-ERROR.          
     OS-COPY VALUE(c-arq-modelo) VALUE(cArqTemp). 

    ASSIGN c-arq-modelo = cArqTemp. 

    IF  SESSION:SET-WAIT-STATE("general") THEN.

    ASSIGN cPrimPasta = "":U.

    CREATE "Excel.Application " ch-Excel CONNECT NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        CREATE "Excel.Application" ch-Excel NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Erro ao executar o Microsoft Excel.":U +
                                 "~~":U +
                                 "Verifique se o mesmo est† instalado na m†quina.":U).

        IF  SESSION:SET-WAIT-STATE("") THEN.

        RETURN NO-APPLY.
    END.

    ch-Excel:DisplayAlerts = FALSE.
    ch-Excel:Visible = NO.
    ch-Excel:Workbooks:Open(c-arq-modelo).

    ch-Excel:Sheets:Item(1).
    ch-Excel:Sheets:Item("Plan1":U):activate.
    ch-Excel:Sheets("Plan1":U):Copy(ch-Excel:Sheets(1)).
    ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "A":U):Value = "ESTAB".
    ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "B":U):Value = "SERIE".
    ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "C":U):Value = "NOTA" .
    ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "D":U):Value = "NATUREZA" .
    ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "E":U):Value = "VOLUME" .
    ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "F":U):Value = "OBJETO" .
    ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "G":U):Value = "CCUSTO".
    ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "H":U):Value = "PESO".
    ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "I":U):Value = "FRETE PREV".
    ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "J":U):Value = "VLR COBRADO".
    ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "K":U):Value = "CARTAO".
    ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "L":U):Value = "TRANSPORTADORA".
    ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "M":U):Value = "EMISSAO".
    ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "N":U):Value = "SAIDA".
    ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "O":U):Value = "CEP".

    ASSIGN iPagina = 1
           iLinha  = 1.

    FOR EACH tt-int-nota-conhec:


        RUN pi-acompanhar in h-acomp (input "Linha "  + string(iLinha ) ).




        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "A":U):Value = tt-int-nota-conhec.cod-estabel.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "B":U):Value = tt-int-nota-conhec.serie.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "C":U):Value = tt-int-nota-conhec.nr-nota-fis.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "D":U):Value = tt-int-nota-conhec.nat-operacao.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "E":U):Value = tt-int-nota-conhec.nr-volume.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "F":U):Value = tt-int-nota-conhec.nr-conhec.


        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "G":U):Value = tt-int-nota-conhec.centro-custo-frete.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "H":U):Value = tt-int-nota-conhec.peso-bruto.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "I":U):Value = tt-int-nota-conhec.val-frete-previsto.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "J":U):Value = tt-int-nota-conhec.dec-1.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "K":U):Value = tt-int-nota-conhec.nr-cartao.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "L":U):Value = tt-int-nota-conhec.nome-transp.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "M":U):Value = tt-int-nota-conhec.dat-emissao.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "N":U):Value = tt-int-nota-conhec.dat-saida.
        ch-Excel:Sheets:Item(1):Cells(iLinha + 6, "O":U):Value = tt-int-nota-conhec.cep.
        ch-Excel:Sheets:Item(1):Cells(5, "H":U):Value          = iLinha.

       
            ASSIGN iLinha = iLinha + 1.


    END.

    RUN pi-finalizar in h-acomp.
    
    ch-Excel:Application:DisplayAlerts = False.
    
    ch-Excel:Sheets("Plan1"):Select.  
    
    ch-Excel:ActiveWindow:SelectedSheets:Delete.
    
                              /*
    ch-Excel:Sheets(cPrimPasta):Select.
    MESSAGE 5
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    ch-Excel:Sheets(cPrimPasta):activate.
    MESSAGE 6
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                */
    ch-Excel:Application:DisplayAlerts = TRUE.

    ch-Excel:Visible = YES.

    IF VALID-HANDLE(ch-Excel) THEN
        RELEASE OBJECT ch-Excel NO-ERROR.

    IF  SESSION:SET-WAIT-STATE("") THEN.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

