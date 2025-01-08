&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-conta-ft NO-UNDO LIKE conta-ft
       field conta-dev-prod as character format "x(17)"
       field conta-pis      as character format "x(17)"
       field conta-cofins   as character format "x(17)"
       field l-marcado as logical
       
       
       .



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCDP017 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP017
&GLOBAL-DEFINE Version        2.04.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   CD0309

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets  fi-de-estab1 fi-de-canal-venda fi-de-ccusto fi-de-familia1 fi-de-natureza1 bt-carrega1 ~
                             fi-para-estab1 fi-para-familia1 fi-para-natureza1 ~
                             bt-atualiza1 fi-para-centrocusto1 i-cod-canal-venda ~
                             bt-todos1 bt-nenhum1 bt-marca-desmarca1 bt-delete


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-tt-conta-ft

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-conta-ft

/* Definitions for BROWSE br-tt-conta-ft                                */
&Scoped-define FIELDS-IN-QUERY-br-tt-conta-ft tt-conta-ft.l-marcado ~
tt-conta-ft.cod-estabel tt-conta-ft.cod-canal-venda tt-conta-ft.cod-gr-cli ~
tt-conta-ft.ge-codigo tt-conta-ft.fm-codigo tt-conta-ft.nat-operacao ~
tt-conta-ft.serie tt-conta-ft.ct-recven tt-conta-ft.ct-cusven ~
tt-conta-ft.cod-cta-devol-produc tt-conta-ft.cod-cta-desc ~
tt-conta-ft.cod-cta-devol-recta tt-conta-ft.ct-icms-ft ~
tt-conta-ft.cod-cta-pis tt-conta-ft.ct-icmsub-ft tt-conta-ft.ct-ipi-ft ~
tt-conta-ft.ct-iss-ft tt-conta-ft.ct-cofins-ft tt-conta-ft.ct-pis-ft ~
tt-conta-ft.cod-cta-cofins tt-conta-ft.ct-ir-ret ~
tt-conta-ft.cod-cta-inss-retid tt-conta-ft.cod-cta-retenc-csll ~
tt-conta-ft.cod-cta-retenc-pis tt-conta-ft.cod-cta-retenc-cofins ~
tt-conta-ft.cod-cta-retenc-iss 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-tt-conta-ft 
&Scoped-define QUERY-STRING-br-tt-conta-ft FOR EACH tt-conta-ft NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-tt-conta-ft OPEN QUERY br-tt-conta-ft FOR EACH tt-conta-ft NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-tt-conta-ft tt-conta-ft
&Scoped-define FIRST-TABLE-IN-QUERY-br-tt-conta-ft tt-conta-ft


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-tt-conta-ft}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar btQueryJoins ~
btReportsJoins btExit btHelp btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 fi-de-estab1 fi-de-canal-venda fi-de-familia1 ~
fi-de-natureza1 fi-para-estab1 fi-para-familia1 fi-para-natureza1 
&Scoped-define List-2 fi-de-estab1 fi-de-canal-venda fi-de-familia1 ~
fi-de-natureza1 fi-para-estab1 fi-para-familia1 fi-para-natureza1 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-atualiza1 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Atualiza Dados" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-carrega1 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Carrega" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-delete 
     LABEL "Remove" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-marca-desmarca1 
     LABEL "Marca/Desmarca" 
     SIZE 13.72 BY 1.

DEFINE BUTTON bt-nenhum1 
     LABEL "Nenhum" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-todos1 
     LABEL "Todos" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-de-canal-venda AS CHARACTER FORMAT "x(3)" 
     LABEL "Canal Vendas":R18 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fi-de-ccusto AS CHARACTER FORMAT "X(20)":U 
     LABEL "C.Custo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-de-estab1 AS CHARACTER FORMAT "x(3)" 
     LABEL "Estab":R18 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88.

DEFINE VARIABLE fi-de-familia1 AS CHARACTER FORMAT "x(8)" 
     LABEL "Fam°lia":R9 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-de-natureza1 AS CHARACTER FORMAT "x(06)" 
     LABEL "Natureza":R21 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .88.

DEFINE VARIABLE fi-para-centrocusto1 AS CHARACTER FORMAT "X(20)":U 
     LABEL "C.Custo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-para-estab1 AS CHARACTER FORMAT "x(3)" 
     LABEL "Estab":R9 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88.

DEFINE VARIABLE fi-para-familia1 AS CHARACTER FORMAT "x(8)" 
     LABEL "Fam°lia":R9 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-para-natureza1 AS CHARACTER FORMAT "x(06)" 
     LABEL "Natureza":R9 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cod-canal-venda AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Canal" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-tt-conta-ft FOR 
      tt-conta-ft SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-tt-conta-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-tt-conta-ft wWindow _STRUCTURED
  QUERY br-tt-conta-ft NO-LOCK DISPLAY
      tt-conta-ft.l-marcado COLUMN-LABEL "*" FORMAT "*/":U WIDTH 1
      tt-conta-ft.cod-estabel FORMAT "x(5)":U WIDTH 3.14
      tt-conta-ft.cod-canal-venda FORMAT ">>9":U WIDTH 4.14
      tt-conta-ft.cod-gr-cli FORMAT ">9":U WIDTH 4.43
      tt-conta-ft.ge-codigo FORMAT ">9":U WIDTH 3.14
      tt-conta-ft.fm-codigo FORMAT "x(8)":U WIDTH 7.72
      tt-conta-ft.nat-operacao FORMAT "x(06)":U WIDTH 7.43
      tt-conta-ft.serie FORMAT "x(5)":U WIDTH 3
      tt-conta-ft.ct-recven COLUMN-LABEL "Receita" FORMAT "x(20)":U
            WIDTH 15.14
      tt-conta-ft.ct-cusven COLUMN-LABEL "Custo Prod Vendidos" FORMAT "x(20)":U
            WIDTH 15.14
      tt-conta-ft.cod-cta-devol-produc COLUMN-LABEL "Devoluá∆o Produto" FORMAT "x(20)":U
      tt-conta-ft.cod-cta-desc COLUMN-LABEL "Desconto" FORMAT "x(20)":U
      tt-conta-ft.cod-cta-devol-recta COLUMN-LABEL "Estorno Receita" FORMAT "x(20)":U
      tt-conta-ft.ct-icms-ft COLUMN-LABEL "Despesa ICMS" FORMAT "x(20)":U
            WIDTH 15.14
      tt-conta-ft.cod-cta-pis FORMAT "x(20)":U
      tt-conta-ft.ct-icmsub-ft COLUMN-LABEL "Despesa ICMSUB" FORMAT "x(20)":U
            WIDTH 15.14
      tt-conta-ft.ct-ipi-ft COLUMN-LABEL "Despesa IPI" FORMAT "x(20)":U
            WIDTH 15.14
      tt-conta-ft.ct-iss-ft COLUMN-LABEL "Despesa ISS" FORMAT "x(20)":U
            WIDTH 15.14
      tt-conta-ft.ct-cofins-ft COLUMN-LABEL "Despesa Cofins" FORMAT "x(20)":U
            WIDTH 15.14
      tt-conta-ft.ct-pis-ft COLUMN-LABEL "Despesa PIS" FORMAT "x(20)":U
            WIDTH 15.14
      tt-conta-ft.cod-cta-cofins FORMAT "x(20)":U
      tt-conta-ft.ct-ir-ret FORMAT "x(20)":U
      tt-conta-ft.cod-cta-inss-retid FORMAT "x(20)":U
      tt-conta-ft.cod-cta-retenc-csll FORMAT "x(20)":U
      tt-conta-ft.cod-cta-retenc-pis FORMAT "x(20)":U
      tt-conta-ft.cod-cta-retenc-cofins FORMAT "x(20)":U
      tt-conta-ft.cod-cta-retenc-iss FORMAT "x(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.25
         FONT 1
         TITLE "Contas Faturamento - CD0309" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     btOK AT ROW 21.79 COL 2
     btCancel AT ROW 21.79 COL 13
     btHelp2 AT ROW 21.79 COL 80
     "Para filtrar todos os dados deixe os campos de pesquisa em branco" VIEW-AS TEXT
          SIZE 46 BY .54 AT ROW 3 COL 43.43 WIDGET-ID 2
          FGCOLOR 9 
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 21.58 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 22.13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     fi-de-estab1 AT ROW 1.5 COL 9.29 COLON-ALIGNED WIDGET-ID 42
     fi-de-canal-venda AT ROW 1.5 COL 27 COLON-ALIGNED WIDGET-ID 120
     fi-de-familia1 AT ROW 1.5 COL 44 COLON-ALIGNED WIDGET-ID 26
     fi-de-natureza1 AT ROW 2.5 COL 27 COLON-ALIGNED WIDGET-ID 30
     fi-de-ccusto AT ROW 2.5 COL 44 COLON-ALIGNED WIDGET-ID 122
     bt-carrega1 AT ROW 2 COL 77 HELP
          "Carrega Dados" WIDGET-ID 32
     br-tt-conta-ft AT ROW 4 COL 2 WIDGET-ID 600
     bt-todos1 AT ROW 13.33 COL 2 WIDGET-ID 94
     bt-nenhum1 AT ROW 13.33 COL 12.14 WIDGET-ID 92
     bt-marca-desmarca1 AT ROW 13.33 COL 22.29 WIDGET-ID 100
     bt-delete AT ROW 13.33 COL 36.14 WIDGET-ID 112
     fi-para-estab1 AT ROW 15 COL 6 COLON-ALIGNED WIDGET-ID 110
     fi-para-familia1 AT ROW 15 COL 18.43 COLON-ALIGNED WIDGET-ID 48
     fi-para-natureza1 AT ROW 15 COL 36.57 COLON-ALIGNED WIDGET-ID 102
     i-cod-canal-venda AT ROW 15 COL 52.29 COLON-ALIGNED WIDGET-ID 118
     fi-para-centrocusto1 AT ROW 15 COL 69.29 COLON-ALIGNED WIDGET-ID 114
     bt-atualiza1 AT ROW 14.75 COL 80 HELP
          "Confirma alteraá‰es" WIDGET-ID 52
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 3.96
         SIZE 84.43 BY 16.33
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-conta-ft T "?" NO-UNDO mgcad conta-ft
      ADDITIONAL-FIELDS:
          field conta-dev-prod as character format "x(17)"
          field conta-pis      as character format "x(17)"
          field conta-cofins   as character format "x(17)"
          field l-marcado as logical
          
          
          
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
         HEIGHT             = 22.13
         WIDTH              = 90.14
         MAX-HEIGHT         = 24.88
         MAX-WIDTH          = 90.14
         VIRTUAL-HEIGHT     = 24.88
         VIRTUAL-WIDTH      = 90.14
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* BROWSE-TAB br-tt-conta-ft bt-carrega1 fPage1 */
/* SETTINGS FOR FILL-IN fi-de-canal-venda IN FRAME fPage1
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-de-estab1 IN FRAME fPage1
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-de-familia1 IN FRAME fPage1
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-de-natureza1 IN FRAME fPage1
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-para-estab1 IN FRAME fPage1
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-para-familia1 IN FRAME fPage1
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-para-natureza1 IN FRAME fPage1
   NO-ENABLE 1 2                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-tt-conta-ft
/* Query rebuild information for BROWSE br-tt-conta-ft
     _TblList          = "Temp-Tables.tt-conta-ft"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"tt-conta-ft.l-marcado" "*" "*~~/" ? ? ? ? ? ? ? no "Marcado/Desmarcado" no no "1" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-conta-ft.cod-estabel
"tt-conta-ft.cod-estabel" ? ? "character" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-conta-ft.cod-canal-venda
"tt-conta-ft.cod-canal-venda" ? ? "integer" ? ? ? ? ? ? no ? no no "4.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-conta-ft.cod-gr-cli
"tt-conta-ft.cod-gr-cli" ? ? "integer" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-conta-ft.ge-codigo
"tt-conta-ft.ge-codigo" ? ? "integer" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-conta-ft.fm-codigo
"tt-conta-ft.fm-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-conta-ft.nat-operacao
"tt-conta-ft.nat-operacao" ? ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-conta-ft.serie
"tt-conta-ft.serie" ? ? "character" ? ? ? ? ? ? no ? no no "3" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-conta-ft.ct-recven
"tt-conta-ft.ct-recven" "Receita" ? "character" ? ? ? ? ? ? no ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-conta-ft.ct-cusven
"tt-conta-ft.ct-cusven" "Custo Prod Vendidos" ? "character" ? ? ? ? ? ? no ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-conta-ft.cod-cta-devol-produc
"tt-conta-ft.cod-cta-devol-produc" "Devoluá∆o Produto" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-conta-ft.cod-cta-desc
"tt-conta-ft.cod-cta-desc" "Desconto" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tt-conta-ft.cod-cta-devol-recta
"tt-conta-ft.cod-cta-devol-recta" "Estorno Receita" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tt-conta-ft.ct-icms-ft
"tt-conta-ft.ct-icms-ft" "Despesa ICMS" ? "character" ? ? ? ? ? ? no ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   = Temp-Tables.tt-conta-ft.cod-cta-pis
     _FldNameList[16]   > Temp-Tables.tt-conta-ft.ct-icmsub-ft
"tt-conta-ft.ct-icmsub-ft" "Despesa ICMSUB" ? "character" ? ? ? ? ? ? no ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.tt-conta-ft.ct-ipi-ft
"tt-conta-ft.ct-ipi-ft" "Despesa IPI" ? "character" ? ? ? ? ? ? no ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.tt-conta-ft.ct-iss-ft
"tt-conta-ft.ct-iss-ft" "Despesa ISS" ? "character" ? ? ? ? ? ? no ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.tt-conta-ft.ct-cofins-ft
"tt-conta-ft.ct-cofins-ft" "Despesa Cofins" ? "character" ? ? ? ? ? ? no ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.tt-conta-ft.ct-pis-ft
"tt-conta-ft.ct-pis-ft" "Despesa PIS" ? "character" ? ? ? ? ? ? no ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   = Temp-Tables.tt-conta-ft.cod-cta-cofins
     _FldNameList[22]   = Temp-Tables.tt-conta-ft.ct-ir-ret
     _FldNameList[23]   = Temp-Tables.tt-conta-ft.cod-cta-inss-retid
     _FldNameList[24]   = Temp-Tables.tt-conta-ft.cod-cta-retenc-csll
     _FldNameList[25]   = Temp-Tables.tt-conta-ft.cod-cta-retenc-pis
     _FldNameList[26]   = Temp-Tables.tt-conta-ft.cod-cta-retenc-cofins
     _FldNameList[27]   = Temp-Tables.tt-conta-ft.cod-cta-retenc-iss
     _Query            is OPENED
*/  /* BROWSE br-tt-conta-ft */
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


&Scoped-define BROWSE-NAME br-tt-conta-ft
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-tt-conta-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tt-conta-ft wWindow
ON MOUSE-SELECT-DBLCLICK OF br-tt-conta-ft IN FRAME fPage1 /* Contas Faturamento - CD0309 */
DO:
    APPLY "choose" TO bt-marca-desmarca1 IN FRAME fPage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tt-conta-ft wWindow
ON ROW-DISPLAY OF br-tt-conta-ft IN FRAME fPage1 /* Contas Faturamento - CD0309 */
DO:
    IF AVAIL tt-conta-ft THEN DO:
         IF tt-conta-ft.l-marcado THEN
             RUN pi-muda-cor1(INPUT 3 , INPUT 15).
         ELSE 
             RUN pi-muda-cor1(INPUT ?, INPUT ?).
    END.
    ELSE RUN pi-muda-cor1(INPUT ?, INPUT ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-atualiza1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atualiza1 wWindow
ON CHOOSE OF bt-atualiza1 IN FRAME fPage1 /* Atualiza Dados */
DO:
    DEFINE VARIABLE c-valor-aux   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-alterou     AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-chave       AS CHAR.
    DEFINE VARIABLE c-chave-nova  AS CHAR.

    DEF BUFFER b-inf-compl FOR inf-compl.

    ASSIGN INPUT FRAME fPage1 fi-para-estab1
           INPUT FRAME fPage1 fi-para-familia1
           INPUT FRAME fPage1 fi-para-natureza1
           INPUT FRAME fPage1 fi-para-centrocusto1
           INPUT FRAME fPage1 i-cod-canal-venda.
    
    IF  fi-para-estab1 <> "" THEN DO:
        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = fi-para-estab1 NO-ERROR.
        IF  NOT AVAIL estabelec THEN DO:
            RUN utp/ut-msgs.p ( "show",
                                17006,
                                "Estabelecimento inv†lido, favor informar um estabelecimento cadastrado.").
            APPLY "entry" TO fi-para-estab1 IN FRAME fPage1.
            RETURN NO-APPLY.
        END.
    END.
    IF  fi-para-familia1 <> "" AND fi-para-familia1 <> ? THEN DO:
        FIND FIRST familia NO-LOCK
             WHERE familia.fm-codigo = fi-para-familia1 NO-ERROR.
        IF  NOT AVAIL familia THEN DO:
            RUN utp/ut-msgs.p ( "show",
                                17006,
                                "Fam°lia Materiais inv†lida, favor informar uma fam°lia cadastrada.").
            APPLY "entry" TO fi-para-familia1 IN FRAME fPage1.
            RETURN NO-APPLY.
        END.
    END.
    IF  fi-para-natureza1 <> "" AND fi-para-natureza1 <> ? THEN DO:
        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = fi-para-natureza1 NO-ERROR.
        IF  NOT AVAIL natur-oper THEN DO:
            RUN utp/ut-msgs.p ( "show",
                                17006,
                                "Natureza inv†lida, favor informar uma natureza cadastrado.").
            APPLY "entry" TO fi-para-natureza1 IN FRAME fPage1.
            RETURN NO-APPLY.
        END.
    END.

    IF  NOT CAN-FIND(FIRST tt-conta-ft WHERE tt-conta-ft.l-marcado) THEN DO:
        RUN utp/ut-msgs.p ( "show",
                            17006,
                            "Selecione registro que deseja clonar.").
        APPLY "entry" TO br-tt-conta-ft IN FRAME fPage1.
        RETURN NO-APPLY.
    END.

    ASSIGN l-alterou = NO.

    bloco:
    DO TRANS ON ENDKEY UNDO bloco, LEAVE bloco 
             ON ERROR  UNDO bloco, LEAVE bloco:
        FOR EACH tt-conta-ft WHERE tt-conta-ft.l-marcado:
    
            FIND FIRST conta-ft NO-LOCK
                 WHERE conta-ft.cod-estabel      = (IF fi-para-estab1    <> "" THEN fi-para-estab1    ELSE tt-conta-ft.cod-estabel)
                   AND conta-ft.cod-gr-cli       = tt-conta-ft.cod-gr-cli     
                   AND conta-ft.cod-canal-venda  = (IF i-cod-canal-venda <> 0  THEN i-cod-canal-venda ELSE tt-conta-ft.cod-canal-venda)
                   AND conta-ft.ge-codigo        = tt-conta-ft.ge-codigo      
                   AND conta-ft.fm-codigo        = (IF fi-para-familia1  <> "" THEN fi-para-familia1  ELSE tt-conta-ft.fm-codigo)
                   AND conta-ft.nat-operacao     = (IF fi-para-natureza1 <> "" THEN fi-para-natureza1 ELSE tt-conta-ft.nat-operacao)
                   AND conta-ft.serie            = tt-conta-ft.serie          
                   AND conta-ft.cod-depos        = tt-conta-ft.cod-depos      
                   AND conta-ft.it-codigo        = tt-conta-ft.it-codigo NO-ERROR.
    
            IF NOT AVAIL conta-ft THEN DO:
           
                CREATE conta-ft.
                BUFFER-COPY tt-conta-ft TO conta-ft.
    
                ASSIGN l-alterou = YES.
    
                ASSIGN conta-ft.cod-estabel     = (IF fi-para-estab1    <> "" THEN fi-para-estab1    ELSE tt-conta-ft.cod-estabel)
                       conta-ft.fm-codigo       = (IF fi-para-familia1  <> "" THEN fi-para-familia1  ELSE tt-conta-ft.fm-codigo)
                       conta-ft.nat-operacao    = (IF fi-para-natureza1 <> "" THEN fi-para-natureza1 ELSE tt-conta-ft.nat-operacao)
                       conta-ft.cod-canal-venda = (IF i-cod-canal-venda <> 0  THEN i-cod-canal-venda ELSE tt-conta-ft.cod-canal-venda).
    
                IF fi-para-centrocusto1 <> "" THEN DO:
                    ASSIGN conta-ft.sc-recven                = fi-para-centrocusto1  
                           conta-ft.sc-cusven                = fi-para-centrocusto1 
                           conta-ft.cod-ccusto-devol-produc  = fi-para-centrocusto1 
                           conta-ft.cod-ccusto-desc          = fi-para-centrocusto1 
                           conta-ft.cod-ccusto-devol-recta   = fi-para-centrocusto1 
                           conta-ft.sc-pis-ft                = fi-para-centrocusto1 
                           /***
                           conta-ft.sc-pis-ft                = fi-para-centrocusto1 
                           ***/
                           conta-ft.sc-icms-ft               = fi-para-centrocusto1 
                           conta-ft.sc-icmsub-ft             = fi-para-centrocusto1 
                           conta-ft.sc-ipi-ft                = fi-para-centrocusto1 
                           conta-ft.sc-iss-ft                = fi-para-centrocusto1 
                           conta-ft.sc-cofins-ft             = fi-para-centrocusto1 
                           conta-ft.cod-ccusto-pis           = fi-para-centrocusto1 
                           conta-ft.cod-ccusto-cofins        = fi-para-centrocusto1 
                           conta-ft.sc-ir-ret                = fi-para-centrocusto1 
                           conta-ft.cod-ccusto-inss-retid    = fi-para-centrocusto1 
                           conta-ft.cod-ccusto-retenc-csll   = fi-para-centrocusto1 
                           conta-ft.cod-ccusto-retenc-pis    = fi-para-centrocusto1 
                           conta-ft.cod-ccusto-retenc-cofins = fi-para-centrocusto1 
                           conta-ft.cod-ccusto-retenc-iss    = fi-para-centrocusto1.
                END.
    
                /* Clona as contas Difal */
                ASSIGN c-chave  =  (IF tt-conta-ft.cod-estabel     = ? THEN "" ELSE TRIM(tt-conta-ft.cod-estabel))       + CHR(2) +
                                   (IF tt-conta-ft.cod-gr-cli      = ? THEN "" ELSE STRING(tt-conta-ft.cod-gr-cli))      + CHR(2) +
                                   (IF tt-conta-ft.cod-canal-venda = ? THEN "" ELSE STRING(tt-conta-ft.cod-canal-venda)) + CHR(2) +
                                   (IF tt-conta-ft.ge-codigo       = ? THEN "" ELSE STRING(tt-conta-ft.ge-codigo))       + CHR(2) +
                                   (IF tt-conta-ft.fm-codigo       = ? THEN "" ELSE TRIM(tt-conta-ft.fm-codigo))         + CHR(2) +
                                   (IF tt-conta-ft.nat-operacao    = ? THEN "" ELSE TRIM(tt-conta-ft.nat-operacao))      + CHR(2) +
                                   (IF tt-conta-ft.serie           = ? THEN "" ELSE TRIM(tt-conta-ft.serie)).
    
                FIND FIRST reg-inf-compl NO-LOCK
                    WHERE reg-inf-compl.cod-tab-inform   = "CONTA-CONTAB-CD0309"
                      AND reg-inf-compl.cod-campo-inform = "CONTA-CONTAB-CD0309" NO-ERROR.
    
                IF  NOT AVAIL reg-inf-compl THEN DO:
                    RUN utp/ut-msgs.p ( "show",
                                        17006,
                                        "N∆o foi poss°vel concluir a c¢pia, Registro origem n∆o possui contas <Difal> cadastradas.").
                    ASSIGN l-alterou = NO.
                    UNDO bloco, LEAVE bloco.
                END.


                IF  AVAIL reg-inf-compl THEN DO:
                    FIND FIRST inf-compl NO-LOCK
                        WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
                          AND inf-compl.cod-indice  = c-chave NO-ERROR.
    
                    IF  NOT AVAIL inf-compl THEN DO:
                        RUN utp/ut-msgs.p ( "show",
                                            17006,
                                            "N∆o foi poss°vel concluir a c¢pia, Registro origem n∆o possui contas <Difal> cadastradas.").
                        ASSIGN l-alterou = NO.
                        UNDO bloco, LEAVE bloco.
                    END.

                    IF  AVAIL inf-compl THEN DO:
                        IF  ENTRY(1,inf-compl.des-campo  , "#")  = ""
                        OR  ENTRY(1,inf-compl.cod-livre-1, "#")  = "" 
                        OR  ENTRY(1,inf-compl.cod-livre-2, "#")  = "" THEN DO:
                            RUN utp/ut-msgs.p ( "show",
                                                17006,
                                                "N∆o foi poss°vel concluir a c¢pia, Registro origem n∆o possui uma ou mais contas <Difal> cadastradas.").
                            ASSIGN l-alterou = NO.
                            UNDO bloco, LEAVE bloco.
                        END.

                        ASSIGN c-chave-nova  =  (IF conta-ft.cod-estabel     = ? THEN "" ELSE   TRIM(conta-ft.cod-estabel))     + CHR(2) +
                                                (IF conta-ft.cod-gr-cli      = ? THEN "" ELSE STRING(conta-ft.cod-gr-cli))      + CHR(2) +
                                                (IF conta-ft.cod-canal-venda = ? THEN "" ELSE STRING(conta-ft.cod-canal-venda)) + CHR(2) +
                                                (IF conta-ft.ge-codigo       = ? THEN "" ELSE STRING(conta-ft.ge-codigo))       + CHR(2) +
                                                (IF conta-ft.fm-codigo       = ? THEN "" ELSE   TRIM(conta-ft.fm-codigo))       + CHR(2) +
                                                (IF conta-ft.nat-operacao    = ? THEN "" ELSE   TRIM(conta-ft.nat-operacao))    + CHR(2) +
                                                (IF conta-ft.serie           = ? THEN "" ELSE   TRIM(conta-ft.serie)).
    
                        FIND FIRST b-inf-compl EXCLUSIVE-LOCK
                            WHERE b-inf-compl.cdn-identif = reg-inf-compl.cdn-identif
                              AND b-inf-compl.cod-indice  = c-chave-nova NO-ERROR.
    
                        IF  NOT AVAIL b-inf-compl THEN 
                            CREATE b-inf-compl.
    
                        BUFFER-COPY inf-compl EXCEPT cod-indice TO b-inf-compl.
                        ASSIGN b-inf-compl.cod-indice  = c-chave-nova.
                    END.
                END.
            END.
        END.
    END.
    IF l-alterou THEN
        RUN utp/ut-msgs.p ( "show",
                            15825,
                            "Registros foram clonados com sucesso!").
    ELSE
        RUN utp/ut-msgs.p ( "show",
                            17006,
                            "N∆o foi clonado nenhum registro, pode ser que informaá‰es j† existiam para paramàtros de alteraá∆o informados!").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-carrega1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-carrega1 wWindow
ON CHOOSE OF bt-carrega1 IN FRAME fPage1 /* Carrega */
DO:
    ASSIGN INPUT FRAME fPage1 fi-de-estab1
           INPUT FRAME fPage1 fi-de-familia1
           INPUT FRAME fPage1 fi-de-natureza1
           INPUT FRAME fPage1 fi-de-ccusto
           INPUT FRAME fPage1 fi-de-canal-venda.
    
    FOR EACH tt-conta-ft:
        DELETE tt-conta-ft.
    END.

    FOR EACH conta-ft NO-LOCK:
        IF fi-de-estab1    <> "" AND conta-ft.cod-estabel  <> fi-de-estab1    THEN NEXT.
        IF fi-de-familia1  <> "" AND conta-ft.fm-codigo    <> fi-de-familia1  THEN NEXT.
        IF fi-de-natureza1 <> "" AND conta-ft.nat-operacao <> fi-de-natureza1 THEN NEXT.
        IF fi-de-canal-venda <> "" AND conta-ft.cod-canal-venda <> int(fi-de-canal-venda) THEN NEXT.
        IF fi-de-ccusto <> "" AND conta-ft.sc-cusven <> fi-de-ccusto THEN NEXT.

        CREATE tt-conta-ft.
        BUFFER-COPY conta-ft TO tt-conta-ft.
        ASSIGN tt-conta-ft.conta-dev-prod = conta-ft.cod-dev-prod
               tt-conta-ft.conta-pis      = conta-ft.cod-cta-pis
               tt-conta-ft.conta-cofins   = conta-ft.cod-cta-cofins.
    END.


    {&open-query-br-tt-conta-ft}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-delete wWindow
ON CHOOSE OF bt-delete IN FRAME fPage1 /* Remove */
DO:
    FOR EACH tt-conta-ft WHERE tt-conta-ft.l-marcado:
        FIND FIRST conta-ft  EXCLUSIVE-LOCK 
             WHERE conta-ft.cod-estabel      = tt-conta-ft.cod-estabel
               AND conta-ft.cod-gr-cli       = tt-conta-ft.cod-gr-cli     
               AND conta-ft.cod-canal-venda  = tt-conta-ft.cod-canal-venda
               AND conta-ft.ge-codigo        = tt-conta-ft.ge-codigo      
               AND conta-ft.fm-codigo        = tt-conta-ft.fm-codigo
               AND conta-ft.nat-operacao     = tt-conta-ft.nat-operacao
               AND conta-ft.serie            = tt-conta-ft.serie NO-ERROR.

        IF AVAIL conta-ft THEN DO:
            DELETE conta-ft.
            DELETE tt-conta-ft.
        END.
    END.
    {&open-query-br-tt-conta-ft} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca-desmarca1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca-desmarca1 wWindow
ON CHOOSE OF bt-marca-desmarca1 IN FRAME fPage1 /* Marca/Desmarca */
DO:
    IF AVAIL tt-conta-ft THEN DO:
        ASSIGN tt-conta-ft.l-marcado = NOT tt-conta-ft.l-marcado.
        br-tt-conta-ft:REFRESH() IN FRAME fPage1.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum1 wWindow
ON CHOOSE OF bt-nenhum1 IN FRAME fPage1 /* Nenhum */
DO:
    FOR EACH tt-conta-ft NO-LOCK:
        ASSIGN tt-conta-ft.l-marcado = NO.
    END.

    br-tt-conta-ft:REFRESH() IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todos1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos1 wWindow
ON CHOOSE OF bt-todos1 IN FRAME fPage1 /* Todos */
DO:
    FOR EACH tt-conta-ft NO-LOCK:
        ASSIGN tt-conta-ft.l-marcado = YES.
    END.

    br-tt-conta-ft:REFRESH() IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
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

    ASSIGN br-tt-conta-ft:SENSITIVE IN FRAME fPage1     = YES.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-muda-cor1 wWindow 
PROCEDURE pi-muda-cor1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-bgcolor AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER p-fgcolor AS INTEGER     NO-UNDO.

/*     /*cor de fundo*/                                                                   */
/*     ASSIGN tt-conta-ft.l-marcado        :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.cod-estabel      :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.cod-canal-venda  :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.cod-gr-cli       :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.ge-codigo        :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.fm-codigo        :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.nat-operacao     :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.serie            :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.ct-recven        :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.ct-cusven        :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.conta-dev-prod   :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.ct-despesa       :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.conta-dev-rec    :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.ct-icms-ft       :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.conta-pis        :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.ct-icmsub-ft     :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.ct-ipi-ft        :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.ct-iss-ft        :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.ct-cofins-ft     :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.ct-pis-ft        :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor  */
/*            tt-conta-ft.conta-cofins     :BGCOLOR IN BROWSE br-tt-conta-ft = p-bgcolor. */
/*                                                                                        */
/*     /*cor da letra*/                                                                   */
/*     ASSIGN tt-conta-ft.l-marcado        :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.cod-estabel      :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.cod-canal-venda  :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.cod-gr-cli       :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.ge-codigo        :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.fm-codigo        :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.nat-operacao     :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.serie            :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.ct-recven        :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.ct-cusven        :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.conta-dev-prod   :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.ct-despesa       :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.conta-dev-rec    :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.ct-icms-ft       :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.conta-pis        :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.ct-icmsub-ft     :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.ct-ipi-ft        :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.ct-iss-ft        :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.ct-cofins-ft     :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.ct-pis-ft        :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor  */
/*            tt-conta-ft.conta-cofins     :FGCOLOR IN BROWSE br-tt-conta-ft = p-fgcolor. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

