&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
compile \\tsclient\c\fontes\esp\cqp\escqp006.w save into c:\temp\esp\cqp.
*******************************************************************************/
{include/i-prgvrs.i escqp006 2.04.000.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escqp006
&GLOBAL-DEFINE Version        2.04.000.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Item,Narrativa,AE,Destino

&GLOBAL-DEFINE page0Widgets   btExit btHelp btConfirma btCancela
&GLOBAL-DEFINE page1Widgets   cb-retira fi-cod-depos-ent fi-cod-depos-sai ~
                              fi-codigo-rejei fi-cod-localiz-entrada ~
                              fi-cod-localiz-saida fi-contenedor ~
                              fi-dt-fabricacao fi-it-codigo ~
                              fi-nr-ficha fi-qt-apr-cond ~
                              fi-qt-aprovada fi-qt-rejeitada ~
                              btAprovar btCondicional btRejeitar fi-quantidade ~
                              fi-observacao cb-local
&GLOBAL-DEFINE page2Widgets   fi-narrativa
&GLOBAL-DEFINE page3Widgets   brItem btInicio btParcial btTudo fi-quant
&GLOBAL-DEFINE page4Widgets   fiPrinter btConfigImpr

/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR gs-nr-ficha LIKE ficha-cq.nr-ficha NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cPrinter      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAuxFile      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLayout       AS CHARACTER NO-UNDO.

DEFINE VARIABLE h_esapi020    AS HANDLE    NO-UNDO.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEF VAR i-opcao AS INTEGER NO-UNDO.
DEF VAR l-perm AS LOGICAL NO-UNDO.
def var data-validade    as date format "99/99/9999" NO-UNDO.
def var i-qt-aprovada  as INT NO-UNDO.     
def var i-qt-rejeitada as INT NO-UNDO.     
def var i-qt-apr-cond  as INT NO-UNDO.  
DEF VAR l-erro AS LOGICAL NO-UNDO.
DEF VAR h-api AS HANDLE NO-UNDO.

&SCOPED-DEFINE DEPOSITOS-REJEICAO dev,for,fal,ret,tra,rtb
{esapi/esapi013.i}
{esp/es0478.i "new"}
{upc/btb910za-upc.i}
{esp/es0018.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brItem

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ae

/* Definitions for BROWSE brItem                                        */
&Scoped-define FIELDS-IN-QUERY-brItem tt-ae except tipo qtd-par data roteiro nf cod-emitente   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brItem   
&Scoped-define SELF-NAME brItem
&Scoped-define QUERY-STRING-brItem FOR EACH tt-ae
&Scoped-define OPEN-QUERY-brItem OPEN QUERY {&SELF-NAME} FOR EACH tt-ae.
&Scoped-define TABLES-IN-QUERY-brItem tt-ae
&Scoped-define FIRST-TABLE-IN-QUERY-brItem tt-ae


/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brItem}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btExit btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 btAprovar btCondicional btRejeitar 
&Scoped-define List-2 fi-it-codigo fi-nr-ficha fi-cod-depos-sai ~
fi-cod-localiz-saida fi-cod-depos-ent fi-quantidade fi-contenedor 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-valida-operacao wWindow 
FUNCTION fn-valida-operacao RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
DEFINE BUTTON btCancela 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Cancela"
     FONT 4.

DEFINE BUTTON btConfirma 
     IMAGE-UP FILE "image/im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sav.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Confirma"
     FONT 4.

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

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAprovar 
     LABEL "&Aprovar" 
     SIZE 10 BY 1.

DEFINE BUTTON btCondicional 
     LABEL "&Condicional" 
     SIZE 10 BY 1.

DEFINE BUTTON btRejeitar 
     LABEL "&Rejeitar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-local AS CHARACTER FORMAT "XXX":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "EQF","SUP","MEC","P&D","MKT","DOC","INJ","IP","FAL","ANA" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE cb-retira AS LOGICAL FORMAT "Aprovada/Condicional":U INITIAL NO 
     LABEL "Retira De" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "yes","no" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fi-cod-depos-ent AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢sito Entrada" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-depos-sai AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢sito Sa°da" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-localiz-entrada AS CHARACTER FORMAT "x(10)" 
     LABEL "Local Entrada":R14 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE fi-cod-localiz-saida AS CHARACTER FORMAT "x(10)" 
     LABEL "Local Sa°da":R14 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE fi-codigo-rejei AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "C¢digo Rejeiá∆o" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-contenedor AS DECIMAL FORMAT ">>>,>>9":U INITIAL 1 
     LABEL "Contenedor" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(30)" 
     VIEW-AS FILL-IN 
     SIZE 30.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao-2 AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 30.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-fabricacao AS DATE FORMAT "99/99/9999" 
     LABEL "Data Fabricaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-2 AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-ficha AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 
     LABEL "Roteiro" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-observacao AS CHARACTER FORMAT "X(50)" 
     LABEL "Observaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 50.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qt-apr-cond AS DECIMAL FORMAT ">>>>,>>9.9999" INITIAL 0 
     LABEL "Qtde Aprovada Condicional" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 0 NO-UNDO.

DEFINE VARIABLE fi-qt-aprovada AS DECIMAL FORMAT ">>>>>,>>9.9999" INITIAL 0 
     LABEL "Qtde Aprovada" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 0 NO-UNDO.

DEFINE VARIABLE fi-qt-rejeitada AS DECIMAL FORMAT ">>>>>,>>9.9999" INITIAL 0 
     LABEL "Qtde Rejeitada" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 0 NO-UNDO.

DEFINE VARIABLE fi-quantidade AS DECIMAL FORMAT ">>>>>,>>9.9999" INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 3.75.

DEFINE VARIABLE fi-narrativa AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
     SIZE 80 BY 10
     BGCOLOR 15  NO-UNDO.

DEFINE BUTTON btInicio 
     LABEL "&÷nicio-Fim" 
     SIZE 10 BY 1.

DEFINE BUTTON btParcial 
     LABEL "&Parcial" 
     SIZE 10 BY 1.

DEFINE BUTTON btTudo 
     LABEL "&Tudo" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-quant AS INTEGER FORMAT ">>,>>>,>>9" INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "Configuraá∆o da impressora" 
     SIZE 4 BY 1 TOOLTIP "Configuraá∆o da impressora".

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 44 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 2.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brItem FOR 
      tt-ae SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brItem wWindow _FREEFORM
  QUERY brItem NO-LOCK DISPLAY
      tt-ae except tipo qtd-par data roteiro nf cod-emitente
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 83 BY 10
         FONT 1 TOOLTIP "Duplo-clique para marcar ou desmarcar".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btCancela AT ROW 1.13 COL 1.72 HELP
          "Sair"
     btConfirma AT ROW 1.13 COL 5.72 HELP
          "Sair"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda" NO-TAB-STOP 
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.33
         FONT 1.

DEFINE FRAME fPage1
     btAprovar AT ROW 1.17 COL 21.29
     btCondicional AT ROW 1.17 COL 31.29
     btRejeitar AT ROW 1.17 COL 41.29
     fi-it-codigo AT ROW 2.17 COL 19 COLON-ALIGNED HELP
          "C¢digo do Item"
     fi-desc-item AT ROW 2.17 COL 82 RIGHT-ALIGNED NO-LABEL NO-TAB-STOP 
     fi-nr-ficha AT ROW 3.17 COL 19 COLON-ALIGNED HELP
          "N£mero do Roteiro de Inspeá∆o"
     fi-cod-depos-sai AT ROW 4.17 COL 19 COLON-ALIGNED
     fi-nome-2 AT ROW 4.17 COL 24.72 COLON-ALIGNED HELP
          "Descriá∆o do Dep¢sito" NO-LABEL NO-TAB-STOP 
     fi-cod-localiz-saida AT ROW 5.17 COL 19 COLON-ALIGNED
     fi-descricao-2 AT ROW 5.17 COL 31.72 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fi-codigo-rejei AT ROW 6.17 COL 19 COLON-ALIGNED
     fi-descricao AT ROW 6.17 COL 23.29 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fi-cod-depos-ent AT ROW 7.17 COL 19 COLON-ALIGNED
     fi-nome AT ROW 7.17 COL 24.72 COLON-ALIGNED HELP
          "Descriá∆o do Dep¢sito" NO-LABEL NO-TAB-STOP 
     fi-observacao AT ROW 8.17 COL 19 COLON-ALIGNED
     fi-cod-localiz-entrada AT ROW 9.17 COL 19 COLON-ALIGNED HELP
          "Digite a localizaá∆o ou seleciona na caixa ao lado"
     cb-local AT ROW 9.17 COL 31.72 COLON-ALIGNED NO-LABEL
     fi-qt-aprovada AT ROW 10.17 COL 82 RIGHT-ALIGNED HELP
          "Quantidade aprovada pelo controle de qualidade" NO-TAB-STOP 
     cb-retira AT ROW 10.25 COL 18 COLON-ALIGNED
     fi-quantidade AT ROW 11.17 COL 19 COLON-ALIGNED HELP
          "Quantidade aprovada pelo controle de qualidade"
     fi-qt-apr-cond AT ROW 11.17 COL 82 RIGHT-ALIGNED HELP
          "Quantidade aprovada Condicionalmente pelo CQ" NO-TAB-STOP 
     fi-dt-fabricacao AT ROW 12.17 COL 19 COLON-ALIGNED
     fi-qt-rejeitada AT ROW 12.17 COL 82 RIGHT-ALIGNED HELP
          "Quantidade rejeitada pelo controle de qualidade" NO-TAB-STOP 
     fi-contenedor AT ROW 13.17 COL 19 COLON-ALIGNED
     "Quantidades" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 9.54 COL 49
     RECT-21 AT ROW 9.75 COL 47
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.6 ROW 3.7 SCROLLABLE 
         FONT 1.

DEFINE FRAME fPage4
     btConfigImpr AT ROW 3.79 COL 62.57 HELP
          "Configuraá∆o da impressora" WIDGET-ID 32
     fiPrinter AT ROW 3.88 COL 18 NO-LABEL WIDGET-ID 34 NO-TAB-STOP 
     "Destino:" VIEW-AS TEXT
          SIZE 7.29 BY .54 AT ROW 3 COL 12.72 WIDGET-ID 28
     RECT-4 AT ROW 3.21 COL 11 WIDGET-ID 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.6 ROW 3.71
         SIZE 84.4 BY 12.75
         FONT 1.

DEFINE FRAME fPage3
     brItem AT ROW 2.5 COL 2 HELP
          "T = Tudo  I = In°cio-Fim  P = Parcial"
     btTudo AT ROW 12.5 COL 2
     btInicio AT ROW 12.5 COL 12
     btParcial AT ROW 12.5 COL 22
     fi-quant AT ROW 12.5 COL 84.01 RIGHT-ALIGNED NO-TAB-STOP 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.6 ROW 3.7
         SIZE 84 BY 13.25
         FONT 1.

DEFINE FRAME fpage2
     fi-narrativa AT ROW 2.5 COL 2 NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE 
         AT COL 3.6 ROW 3.7
         SIZE 84 BY 13.25
         BGCOLOR 8 FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.33
         WIDTH              = 90
         MAX-HEIGHT         = 27.17
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.17
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{esp/ShowMsg.i}
{window/window.i}
{esp/eslib.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fpage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btCancela IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btConfirma IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
   Size-to-Fit                                                          */
ASSIGN 
       FRAME fPage1:SCROLLABLE       = FALSE.

/* SETTINGS FOR BUTTON btAprovar IN FRAME fPage1
   1                                                                    */
/* SETTINGS FOR BUTTON btCondicional IN FRAME fPage1
   1                                                                    */
/* SETTINGS FOR BUTTON btRejeitar IN FRAME fPage1
   1                                                                    */
/* SETTINGS FOR COMBO-BOX cb-local IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-retira IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-depos-ent IN FRAME fPage1
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-cod-depos-sai IN FRAME fPage1
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-cod-localiz-entrada IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-localiz-saida IN FRAME fPage1
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-contenedor IN FRAME fPage1
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fPage1
   NO-ENABLE ALIGN-R                                                    */
ASSIGN 
       fi-desc-item:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-descricao IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       fi-descricao:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-descricao-2 IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       fi-descricao-2:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME fPage1
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-nome IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       fi-nome:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-nome-2 IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       fi-nome-2:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-nr-ficha IN FRAME fPage1
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-observacao IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qt-apr-cond IN FRAME fPage1
   NO-ENABLE ALIGN-R                                                    */
ASSIGN 
       fi-qt-apr-cond:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-qt-aprovada IN FRAME fPage1
   NO-ENABLE ALIGN-R                                                    */
ASSIGN 
       fi-qt-aprovada:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-qt-rejeitada IN FRAME fPage1
   NO-ENABLE ALIGN-R                                                    */
ASSIGN 
       fi-qt-rejeitada:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-quantidade IN FRAME fPage1
   2                                                                    */
/* SETTINGS FOR FRAME fpage2
                                                                        */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brItem 1 fPage3 */
/* SETTINGS FOR FILL-IN fi-quant IN FRAME fPage3
   NO-ENABLE ALIGN-R                                                    */
ASSIGN 
       fi-quant:READ-ONLY IN FRAME fPage3        = TRUE.

/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR BUTTON btConfigImpr IN FRAME fPage4
   NO-ENABLE                                                            */
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fPage4        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brItem
/* Query rebuild information for BROWSE brItem
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ae.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _Query            is OPENED
*/  /* BROWSE brItem */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage2
/* Query rebuild information for FRAME fpage2
     _Query            is NOT OPENED
*/  /* FRAME fpage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
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


&Scoped-define BROWSE-NAME brItem
&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME brItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brItem wWindow
ON i OF brItem IN FRAME fPage3
OR "I" OF brItem DO:
  APPLY "choose" TO btInicio.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brItem wWindow
ON MOUSE-SELECT-DBLCLICK OF brItem IN FRAME fPage3
DO:
  IF fn-valida-operacao() THEN DO:
      BROWSE brItem:FETCH-SELECTED-ROW(1).
      tt-ae.c-selecionado = NOT tt-ae.c-selecionado.
      DISP tt-ae.c-selecionado WITH BROWSE brItem.
      IF tt-ae.c-selecionado THEN
          fi-quant = fi-quant + tt-ae.quantidade.
      ELSE
          fi-quant = fi-quant - tt-ae.quantidade.
      DISP fi-quant WITH FRAME fpage3.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brItem wWindow
ON p OF brItem IN FRAME fPage3
OR "P" OF brItem DO:
  APPLY "choose" TO btParcial.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brItem wWindow
ON t OF brItem IN FRAME fPage3
OR "T" OF brItem DO:
  APPLY "choose" TO btTudo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAprovar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAprovar wWindow
ON CHOOSE OF btAprovar IN FRAME fPage1 /* Aprovar */
DO:
  APPLY "choose" TO btCancela IN FRAME fpage0.
  ENABLE {&List-2} fi-dt-fabricacao WITH FRAME fpage1.
  ENABLE fi-narrativa WITH FRAME fpage2.
  ENABLE btConfirma btCancela WITH FRAME fpage0.
  SELF:SENSITIVE = NO.
  /*
  CLEAR FRAME fpage1 ALL.
  CLEAR FRAME fpage3 ALL.
  fi-narrativa:screen-value in frame fpage2 = "".
  */
  DISP "alm" @ fi-cod-depos-ent WITH FRAME fpage1.
  APPLY "entry" TO fi-cod-depos-ent IN FRAME fpage1.
  APPLY "entry" TO fi-it-codigo IN FRAME fpage1.
  i-opcao = 1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancela wWindow
ON CHOOSE OF btCancela IN FRAME fpage0
DO:
    i-opcao = 0.
    DISABLE ALL WITH FRAME fpage1.
    DISABLE ALL WITH FRAME fpage2.
    DISABLE ALL WITH FRAME fpage3.
    DISABLE btConfirma btCancela WITH FRAME fpage0.
    RUN setEnabled IN hFolder (INPUT 3, INPUT NO).
    ENABLE {&List-1} WITH FRAME fpage1.

    ASSIGN fi-it-codigo             = ""
           fi-nr-ficha              = 0
           fi-cod-depos-sai         = ""
           fi-cod-localiz-saida     = ""
           fi-codigo-rejei          = 0
           fi-cod-depos-ent         = ""
           fi-observacao            = ""
           fi-cod-localiz-entrada   = ""
           cb-retira                = FALSE
           fi-quantidade            = 0
           fi-dt-fabricacao         = ?
           fi-contenedor            = 1
           fi-qt-aprovada           = 0
           fi-qt-apr-cond           = 0
           fi-qt-rejeitada          = 0.


    DISP fi-it-codigo          
         fi-nr-ficha           
         fi-cod-depos-sai      
         fi-cod-localiz-saida  
         fi-codigo-rejei       
         fi-cod-depos-ent      
         fi-observacao         
         fi-cod-localiz-entrada
         cb-retira             
         fi-quantidade         
         fi-dt-fabricacao      
         fi-contenedor         
         fi-qt-aprovada        
         fi-qt-apr-cond        
         fi-qt-rejeitada         
        WITH FRAME fPage1.

    ASSIGN fi-narrativa = "".

    DISP fi-narrativa 
        WITH FRAME fPage2.

    FOR EACH tt-ae:
        DELETE tt-ae.
    END.

    {&open-query-brItem}



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCondicional
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCondicional wWindow
ON CHOOSE OF btCondicional IN FRAME fPage1 /* Condicional */
DO:
    APPLY "choose" TO btCancela IN FRAME fpage0.
    ENABLE {&List-2} fi-codigo-rejei fi-dt-fabricacao WITH FRAME fpage1.
    ENABLE fi-narrativa WITH FRAME fpage2.
    ENABLE btConfirma btCancela WITH FRAME fpage0.
    SELF:SENSITIVE = NO.
    /*
    CLEAR FRAME fpage1 ALL.
    CLEAR FRAME fpage3 ALL.
    fi-narrativa:screen-value in frame fpage2 = "".
    */
    DISP "alm" @ fi-cod-depos-ent WITH FRAME fpage1.
    APPLY "entry" TO fi-cod-depos-ent IN FRAME fpage1.
    APPLY "entry" TO fi-it-codigo IN FRAME fpage1.
    i-opcao = 2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wWindow
ON CHOOSE OF btConfigImpr IN FRAME fPage4 /* Configuraá∆o da impressora */
DO:
    RUN piSelectPrinter IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btConfirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfirma wWindow
ON CHOOSE OF btConfirma IN FRAME fpage0
DO:
    RUN esapi/esapi013.p PERSISTENT SET h-api.
   
    RUN piRegra.
   
    RUN piFinaliza IN h-api.
    IF VALID-HANDLE(hWindowStyles) THEN
        DELETE PROCEDURE hWindowStyles.
    DELETE PROCEDURE h-api.
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


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btInicio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInicio wWindow
ON CHOOSE OF btInicio IN FRAME fPage3 /* ÷nicio-Fim */
DO:
    RUN piInicioFim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btParcial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParcial wWindow
ON CHOOSE OF btParcial IN FRAME fPage3 /* Parcial */
DO:
  IF fn-valida-operacao() THEN DO:
      BROWSE brItem:FETCH-SELECTED-ROW(1).
      RUN piParcial.  
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btRejeitar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRejeitar wWindow
ON CHOOSE OF btRejeitar IN FRAME fPage1 /* Rejeitar */
DO:
    APPLY "choose" TO btCancela IN FRAME fpage0.
    ENABLE {&List-2} fi-codigo-rejei cb-retira WITH FRAME fpage1.
    ENABLE fi-narrativa WITH FRAME fpage2.
    ENABLE btConfirma btCancela WITH FRAME fpage0.
    SELF:SENSITIVE = NO.
    /*
    CLEAR FRAME fpage1 ALL.
    CLEAR FRAME fpage3 ALL.
    fi-narrativa:screen-value in frame fpage2 = "".
    */
    i-opcao = 3.
    /*
    RUN ShowMessage (2, "Atená∆o", "Para rejeiá‰es parciais, deve-se informar a quantidade que vai ser retirada de cada AE/SeqÅància").
    */
    APPLY "entry" TO fi-it-codigo IN FRAME fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btTudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTudo wWindow
ON CHOOSE OF btTudo IN FRAME fPage3 /* Tudo */
DO:
    assign fi-quant = 0.
    for each tt-ae:
        assign tt-ae.c-selecionado = yes
               fi-quant = fi-quant + tt-ae.quantidade.
    end.
    DISP fi-quant WITH FRAME fpage3.
    BROWSE brItem:REFRESH().

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-local wWindow
ON VALUE-CHANGED OF cb-local IN FRAME fPage1
DO:
  DISP cb-local:SCREEN-VALUE @ fi-cod-localiz-entrada WITH FRAME fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-retira
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-retira wWindow
ON VALUE-CHANGED OF cb-retira IN FRAME fPage1 /* Retira De */
DO:
    IF INPUT cb-retira THEN
        DISP ficha-cq.qt-aprovada @ fi-quantidade WITH FRAME fpage1.
    ELSE
        DISP ficha-cq.qt-apr-cond @ fi-quantidade WITH FRAME fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-depos-ent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-ent wWindow
ON ENTRY OF fi-cod-depos-ent IN FRAME fPage1 /* Dep¢sito Entrada */
DO:
  SELF:PRIVATE-DATA = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-ent wWindow
ON F5 OF fi-cod-depos-ent IN FRAME fPage1 /* Dep¢sito Entrada */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in084"
                       &campo="fi-nome"
                       &campozoom="nome"
                       &frame="fPage1"
                       &campo2="fi-cod-depos-ent"
                       &campozoom2="cod-depos"
                       &frame2="fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-ent wWindow
ON LEAVE OF fi-cod-depos-ent IN FRAME fPage1 /* Dep¢sito Entrada */
DO:
    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=fi-nome
                     &where="deposito.cod-depos = fi-cod-depos-ent:screen-value in frame fPage1"}
    IF AVAIL deposito THEN DO:
        IF i-opcao = 3 THEN do:
            IF deposito.cod-depos = "dev" or
               deposito.cod-depos = "RTB" THEN DO:
                ENABLE fi-cod-localiz-entrada cb-local fi-dt-fabricacao WITH FRAME fpage1.
                IF SELF:PRIVATE-DATA NE SELF:SCREEN-VALUE THEN
                    cb-local:SCREEN-VALUE IN FRAME fpage1 = cb-local:ENTRY(1).
                APPLY "entry" TO fi-cod-localiz-entrada IN FRAME fpage1.
            END.
            ELSE DO:
                DISABLE fi-cod-localiz-entrada cb-local fi-dt-fabricacao WITH FRAME fpage1.
                APPLY "entry" TO cb-retira IN FRAME fpage1.
            END.
        END.
        IF LOOKUP(deposito.cod-depos, "dev,fal,for,tra,rtb") > 0 THEN DO:
            ENABLE fi-observacao WITH FRAME fpage1.
            APPLY "entry" TO fi-observacao IN FRAME fpage1.
        END.
        ELSE DO:
            DISABLE fi-observacao WITH FRAME fpage1.
        END.
        IF fi-observacao:SENSITIVE IN FRAME fpage1
        OR i-opcao = 3 THEN RETURN NO-APPLY.
    END.
                     
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-ent wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos-ent IN FRAME fPage1 /* Dep¢sito Entrada */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-depos-sai
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-sai wWindow
ON ENTRY OF fi-cod-depos-sai IN FRAME fPage1 /* Dep¢sito Sa°da */
DO:
  SELF:PRIVATE-DATA = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-sai wWindow
ON F5 OF fi-cod-depos-sai IN FRAME fPage1 /* Dep¢sito Sa°da */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in084"
                       &campo="fi-nome"
                       &campozoom="nome"
                       &frame="fPage1"
                       &campo2="fi-cod-depos-sai"
                       &campozoom2="cod-depos"
                       &frame2="fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-sai wWindow
ON LEAVE OF fi-cod-depos-sai IN FRAME fPage1 /* Dep¢sito Sa°da */
DO:
    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=fi-nome-2
                     &where="deposito.cod-depos = fi-cod-depos-sai:screen-value in frame fPage1"}
                     
    IF AVAIL deposito THEN DO:
        IF i-opcao = 3 AND deposito.cod-depos = "alm" 
        OR i-opcao NE 3 AND ( deposito.cod-depos = "dev"  OR  
                              deposito.cod-depos = "tra"  or
                              deposito.cod-depos = "RTB") THEN DO:
            IF fi-nr-ficha:PRIVATE-DATA NE fi-nr-ficha:SCREEN-VALUE
            OR fi-it-codigo:PRIVATE-DATA NE fi-it-codigo:SCREEN-VALUE 
            OR SELF:PRIVATE-DATA NE SELF:SCREEN-VALUE THEN DO:
                EMPTY TEMP-TABLE tt-ae.
                for each ae-item no-lock
                   where ae-item.cod-estabel = v_cod_estab_usuar
                     and ae-item.it-codigo = INPUT FRAME fpage1 fi-it-codigo
                     and ae-item.roteiro   = INPUT FRAME fpage1 fi-nr-ficha
                     and ae-item.situacao  = no
                     and ae-item.cod-depos = deposito.cod-depos:
                     find ficha-cq where ficha-cq.nr-ficha = ae-item.roteiro no-lock no-error.
                     create tt-ae.
                     assign tt-ae.nr-ae        = ae-item.nr-ae
                            tt-ae.sequencia    = ae-item.sequencia
                            tt-ae.quantidade   = ae-item.quantidade
                            tt-ae.localizacao  = ae-item.localizacao
                            tt-ae.qtd-par      = ae-item.quantidade
                            tt-ae.data         = ae-item.data
                            tt-ae.roteiro      = ae-item.roteiro
                            tt-ae.nf           = ae-item.nf
                            tt-ae.cod-emitente = ficha-cq.cod-emitente WHEN avail ficha-cq.
                 end.
                 fi-quant = 0.
                 DISP fi-quant WITH FRAME fpage3.
                 {&OPEN-QUERY-brItem}
            END.
            RUN setEnabled IN hFolder (INPUT 3, INPUT YES).
            ENABLE brItem btInicio btParcial btTudo WITH FRAME fpage3.
        END.
        ELSE DO:
            RUN setEnabled IN hFolder (INPUT 3, INPUT NO).
            DISABLE ALL WITH FRAME fpage3.
        END.
    END.
                     
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-sai wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos-sai IN FRAME fPage1 /* Dep¢sito Sa°da */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-localiz-entrada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz-entrada wWindow
ON LEAVE OF fi-cod-localiz-entrada IN FRAME fPage1 /* Local Entrada */
DO:
  IF cb-local:LOOKUP(self:INPUT-VALUE) = 0 THEN DO:
      DISP "" @ fi-cod-localiz-entrada WITH FRAME fpage1.
      RETURN.
  END.
  ELSE do:
      cb-local:SCREEN-VALUE = caps(self:SCREEN-VALUE).
      APPLY "entry" TO cb-retira IN FRAME fpage1.
      RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-localiz-saida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz-saida wWindow
ON F5 OF fi-cod-localiz-saida IN FRAME fPage1 /* Local Sa°da */
DO:
    l-implanta = NO.
    {include/zoomvar.i &prog-zoom="inzoom/z01in189"
                       &campo="fi-cod-depos-sai"
                       &campozoom="cod-depos"
                       &frame="fPage1"
                       &campo2="fi-descricao-2"
                       &campozoom2="descricao"
                       &frame2="fPage1"
                       &campo3="fi-cod-localiz-saida"
                       &campozoom3="cod-localiz"
                       &frame3="fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz-saida wWindow
ON LEAVE OF fi-cod-localiz-saida IN FRAME fPage1 /* Local Sa°da */
DO:
    {include/leave.i &tabela=mgcad.localizacao
                     &atributo-ref=descricao
                     &variavel-ref=fi-descricao-2
                     &where="localizacao.cod-localiz = fi-cod-localiz-saida:screen-value in frame fPage1
                     AND localizacao.cod-depos = fi-cod-depos-sai:screen-value in frame fPage1
                     AND localizacao.cod-estabel = v_cod_estab_usuar"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz-saida wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-localiz-saida IN FRAME fPage1 /* Local Sa°da */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-codigo-rejei
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo-rejei wWindow
ON F5 OF fi-codigo-rejei IN FRAME fPage1 /* C¢digo Rejeiá∆o */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in047"
                       &campo2="fi-codigo-rejei"
                       &campozoom2="codigo-rejei"
                       &frame2="fpage1"
                       &campo="fi-descricao"
                       &campozoom="descricao"
                       &frame="fpage1"}
                       
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo-rejei wWindow
ON LEAVE OF fi-codigo-rejei IN FRAME fPage1 /* C¢digo Rejeiá∆o */
DO:
    {include/leave.i &tabela=cod-rejeicao
                     &atributo-ref=descricao
                     &variavel-ref=fi-descricao
                     &where="cod-rejeicao.codigo-rejei = input frame fpage1 fi-codigo-rejei"}
    IF AVAIL cod-rejeicao THEN DO:
        IF cod-rejeicao.codigo-rejei = 4 THEN
            DISP "fal" @ fi-cod-depos-ent WITH FRAME fpage1.
        ELSE
            DISP "dev" @ fi-cod-depos-ent WITH FRAME fpage1.
            

            
        if v_cod_estab_usuar = "102" then
        
            DISP "rtb" @ fi-cod-depos-ent WITH FRAME fpage1.

           
            
        APPLY "leave" TO fi-cod-depos-ent IN FRAME fpage1.
        
        
        
        
    END.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo-rejei wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-codigo-rejei IN FRAME fPage1 /* C¢digo Rejeiá∆o */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON ENTRY OF fi-it-codigo IN FRAME fPage1 /* Item */
DO:
  SELF:PRIVATE-DATA = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON F5 OF fi-it-codigo IN FRAME fPage1 /* Item */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z04in172"
                       &campo="fi-desc-item"
                       &campozoom="desc-item"
                       &frame="fPage1"
                       &campo2="fi-it-codigo"
                       &campozoom2="it-codigo"
                       &frame2="fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON LEAVE OF fi-it-codigo IN FRAME fPage1 /* Item */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=fi-desc-item
                     &where="item.it-codigo = fi-it-codigo:screen-value in frame fpage1"}

    IF AVAIL ITEM THEN DO:
        IF SELF:PRIVATE-DATA NE "" AND SELF:SCREEN-VALUE NE SELF:PRIVATE-DATA THEN DO:
            fi-desc-item:PRIVATE-DATA = fi-desc-item:SCREEN-VALUE.
            fi-it-codigo:private-data = fi-it-codigo:screen-value.
            
            CLEAR FRAME fpage1 ALL.
            
            ASSIGN SELF:SCREEN-VALUE         = SELF:PRIVATE-DATA
                   fi-it-codigo:screen-value = fi-it-codigo:private-data
                   fi-desc-item:SCREEN-VALUE = fi-desc-item:PRIVATE-DATA.
        END.
        IF i-opcao NE 3 AND self:PRIVATE-DATA NE self:SCREEN-VALUE THEN
            DISP item.lote-multipl @ fi-contenedor WITH FRAME fpage1.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-it-codigo IN FRAME fPage1 /* Item */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nr-ficha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ficha wWindow
ON ENTRY OF fi-nr-ficha IN FRAME fPage1 /* Roteiro */
DO:
  SELF:PRIVATE-DATA = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ficha wWindow
ON F5 OF fi-nr-ficha IN FRAME fPage1 /* Roteiro */
DO:
    {include/zoomvar.i &prog-zoom="eszoom/z03esin124.w"
                       &campo="fi-nr-ficha"
                       &campozoom="nr-ficha"
                       &frame="fPage1"
                       &parametros="run setInitials in wh-pesquisa (input input fi-it-codigo)."}     
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ficha wWindow
ON LEAVE OF fi-nr-ficha IN FRAME fPage1 /* Roteiro */
DO:
    {include/leave.i &tabela=ficha-cq
                     &atributo-ref=nr-ficha
                     &variavel-ref=fi-nr-ficha
                     &where="ficha-cq.nr-ficha = input frame fpage1 fi-nr-ficha"}
    IF AVAIL ficha-cq THEN DO:
        fi-narrativa:SCREEN-VALUE IN FRAME fpage2 = ficha-cq.narrativa.
        disp ficha-cq.qt-aprovada  @ fi-qt-aprovada 
             ficha-cq.qt-apr-cond  @ fi-qt-apr-cond 
             ficha-cq.qt-rejeitada @ fi-qt-rejeitada
        with frame fpage1. 
        IF i-opcao NE 3 THEN
            DISP ficha-cq.qt-rejeitada @ fi-quantidade WITH FRAME fpage1.
        ELSE DO:
            if ficha-cq.qt-aprovada > 0 THEN 
                cb-retira:SCREEN-VALUE IN FRAME fpage1 = "yes".
            ELSE
                cb-retira:SCREEN-VALUE IN FRAME fpage1 = "no".
            APPLY "value-changed" TO cb-retira IN FRAME fpage1.
            IF SELF:PRIVATE-DATA NE SELF:SCREEN-VALUE
            OR fi-it-codigo:PRIVATE-DATA NE fi-it-codigo:SCREEN-VALUE THEN DO:
                DISP 0 @ fi-contenedor WITH FRAME fpage1. 
                FOR first item-fornec no-lock 
                    WHERE item-fornec.it-codigo = ficha-cq.it-codigo 
                    and   item-fornec.cod-emitente = ficha-cq.cod-emitente:
                    DISP item-fornec.lote-mul-for @ fi-contenedor WITH FRAME fpage1.
                END.
            END.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ficha wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-nr-ficha IN FRAME fPage1 /* Roteiro */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-quantidade wWindow
ON LEAVE OF fi-quantidade IN FRAME fPage1 /* Quantidade */
DO:
  IF i-opcao = 3 THEN
      fi-contenedor:SCREEN-VALUE = SELF:INPUT-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
fi-it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
fi-cod-depos-ent:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
fi-cod-depos-sai:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
fi-nr-ficha:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
fi-codigo-rejei:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
fi-cod-localiz-saida:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterchangePage wWindow 
PROCEDURE AfterchangePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-page AS INT NO-UNDO.

    IF NOT l-erro THEN DO:
        RUN getCurrentFolder IN hFolder (OUTPUT i-page).
        IF i-page = 1 THEN
            APPLY "entry" TO fi-it-codigo IN FRAME fpage1.
    END.
    l-erro = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterdestroyInterface wWindow 
PROCEDURE AfterdestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterinitializeInterface wWindow 
PROCEDURE AfterinitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
/*     FOR FIRST param-estoq NO-LOCK: */
/*     END. */
    
    DISABLE ALL WITH FRAME fpage1.
    DISABLE ALL WITH FRAME fpage2.
    DISABLE ALL WITH FRAME fpage3.
    DISABLE btConfirma btCancela WITH FRAME fpage0.
    RUN setEnabled IN hFolder (INPUT 3, INPUT NO).
    ENABLE {&List-1} WITH FRAME fpage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-rej wWindow 
PROCEDURE imprime-rej :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN ShowMessage (3, "Deseja imprimir roteiro rejeitado?", "").
    IF RETURN-VALUE = "yes" THEN do:
        gs-nr-ficha = INPUT FRAME fpage1 fi-nr-ficha.
        RUN esp/cqp/escqp005.w.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicioFim wWindow 
PROCEDURE piInicioFim :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btCancela 
         LABEL "&Cancelar" 
         SIZE 10 BY 1.
    
    DEFINE BUTTON btOK 
         LABEL "OK" 
         SIZE 10 BY 1.
    
    DEFINE VARIABLE fi-fim-nr-ae AS INTEGER FORMAT "9999999" INITIAL 0 
         LABEL "Nr AE Final" 
         VIEW-AS FILL-IN 
         SIZE 7.50 BY .88.
    
    DEFINE VARIABLE fi-fim-sequencia AS INTEGER FORMAT "999" INITIAL 0 
         LABEL "SeqÅància Final" 
         VIEW-AS FILL-IN 
         SIZE 4 BY .88.
    
    DEFINE VARIABLE fi-ini-nr-ae AS INTEGER FORMAT "9999999" INITIAL 0 
         LABEL "Nr AE Inicial" 
         VIEW-AS FILL-IN 
         SIZE 7.50 BY .88.
    
    DEFINE VARIABLE fi-ini-sequencia AS INTEGER FORMAT "999" INITIAL 0 
         LABEL "SeqÅància Inicial" 
         VIEW-AS FILL-IN 
         SIZE 4 BY .88.
    
    DEFINE RECTANGLE RECT-17
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 60 BY 4.25.
    
    DEFINE RECTANGLE RECT-18
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 60 BY 1.5
         BGCOLOR 7 .

    DEFINE FRAME fSelecao
         fi-ini-nr-ae AT ROW 1.17 COL 25 COLON-ALIGNED
         fi-fim-nr-ae AT ROW 2.17 COL 25 COLON-ALIGNED
         fi-ini-sequencia AT ROW 3.17 COL 25 COLON-ALIGNED
         fi-fim-sequencia AT ROW 4.17 COL 25 COLON-ALIGNED
         btOK AT ROW 5.54 COL 2
         btCancela AT ROW 5.54 COL 12
         RECT-17 AT ROW 1 COL 1
         RECT-18 AT ROW 5.25 COL 1
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1
             TITLE "Seleá∆o"
             DEFAULT-BUTTON btOK CANCEL-BUTTON btCancela.

    ON 'choose':U OF btOK IN FRAME fSelecao
    DO:
        ASSIGN INPUT FRAME fSelecao fi-ini-nr-ae fi-fim-nr-ae fi-ini-sequencia fi-fim-sequencia.
        fi-quant = 0.
        for each tt-ae
           where (tt-ae.nr-ae >= fi-ini-nr-ae
             and tt-ae.sequencia >= fi-ini-sequencia
             and tt-ae.sequencia <= fi-fim-sequencia)
             and (tt-ae.nr-ae <= fi-fim-nr-ae
             and tt-ae.sequencia >= fi-ini-sequencia
             and tt-ae.sequencia <= fi-fim-sequencia).
             assign tt-ae.c-selecionado = yes
                    fi-quant = fi-quant + tt-ae.quantidade.
        end.
        DISP fi-quant WITH FRAME fpage3.
        BROWSE brItem:REFRESH().
        APPLY "END-ERROR":U TO FRAME fSelecao.
        RETURN.
    END.

    ON 'choose':U OF btCancela IN FRAME fSelecao
    DO:
        APPLY "END-ERROR":U TO FRAME fSelecao.
        RETURN.
    END.

    ENABLE fi-ini-nr-ae fi-fim-nr-ae fi-ini-sequencia fi-fim-sequencia btOK btCancela WITH FRAME fSelecao.
    VIEW FRAME fSelecao.
    WAIT-FOR WINDOW-CLOSE OF FRAME fSelecao.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piParcial wWindow 
PROCEDURE piParcial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btCancela 
         LABEL "&Cancelar" 
         SIZE 10 BY 1.
    
    DEFINE BUTTON btOK 
         LABEL "OK" 
         SIZE 10 BY 1.
    
    DEFINE VARIABLE fi-quantidade AS INTEGER FORMAT ">>,>>>,>>9" INITIAL 0 
         LABEL "Quantidade" 
         VIEW-AS FILL-IN 
         SIZE 10.50 BY .88 NO-UNDO.
    
    DEFINE RECTANGLE RECT-17
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 60 BY 1.25.
    
    DEFINE RECTANGLE RECT-18
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 60 BY 1.5
         BGCOLOR 7 .

    DEFINE FRAME fQuantidade
         fi-quantidade AT ROW 1.17 COL 35.01 RIGHT-ALIGNED
         btOK AT ROW 2.54 COL 2
         btCancela AT ROW 2.54 COL 12
         RECT-17 AT ROW 1 COL 1
         RECT-18 AT ROW 2.25 COL 1
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1
             TITLE "Quantidade"
             DEFAULT-BUTTON btOK CANCEL-BUTTON btCancela.

    ON 'choose':U OF btOK IN FRAME fQuantidade
    DO:
        IF INPUT FRAME fQuantidade fi-quantidade >= tt-ae.quantidade THEN DO:
            RUN ShowMessage (1, "Quantidade incorreta", 
                             "Quantidade informada deve ser menor que a quantidade do AE").
            APPLY "entry" TO fi-quantidade IN FRAME fQuantidade.
            RETURN NO-APPLY.
        END.
        ASSIGN INPUT FRAME fQuantidade fi-quantidade.
        assign tt-ae.c-selecionado = yes
               tt-ae.tipo          = no
               tt-ae.qtd-par       = tt-ae.qtd-par - fi-quantidade
               tt-ae.quantidade    = fi-quantidade
               fi-quant = fi-quant + tt-ae.quantidade.
        DISP fi-quant WITH FRAME fpage3.
        BROWSE brItem:REFRESH().
        APPLY "END-ERROR":U TO FRAME fQuantidade.
        RETURN.
    END.

    ON 'choose':U OF btCancela IN FRAME fQuantidade
    DO:
        APPLY "END-ERROR":U TO FRAME fQuantidade.
        RETURN.
    END.

    ENABLE fi-quantidade btOK btCancela WITH FRAME fQuantidade.
    VIEW FRAME fQuantidade.
    WAIT-FOR WINDOW-CLOSE OF FRAME fQuantidade.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPrepara wWindow 
PROCEDURE piPrepara :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE i-nr-ae AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.
    

    ASSIGN i-nr-ae = 0
           i-sequencia = 0.

    FIND FIRST ae-inspecao                                          
        WHERE ae-inspecao.cod-estabel  = v_cod_estab_usuar         
        AND   ae-inspecao.it-codigo    = tt-transferencia.it-codigo      
        AND   ae-inspecao.nr-ficha     = tt-transferencia.nr-ficha       
        NO-LOCK NO-ERROR.        

    IF AVAIL ae-inspecao THEN DO:

        ASSIGN i-nr-ae = ae-inspecao.nr-ae.

        FIND LAST ae-item USE-INDEX it-ae-seq              
            WHERE ae-item.cod-estabel = v_cod_estab_usuar 
            AND   ae-item.it-codigo = tt-transferencia.it-codigo 
            AND   ae-item.nr-ae     = i-nr-ae              
            NO-LOCK NO-ERROR.

        IF NOT AVAIL ae-item OR
              (AVAIL ae-item AND ae-item.sequencia >= 999) THEN DO:

            ASSIGN i-nr-ae = 0
                   i-sequencia = 0.
            
        END.
    
        IF AVAIL ae-item AND ae-item.sequencia < 999 THEN
            ASSIGN i-sequencia = ae-item.sequencia + 1.

    END.

    ASSIGN tt-transferencia.nr-ae     = i-nr-ae
           tt-transferencia.sequencia = i-sequencia.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRegra wWindow 
PROCEDURE piRegra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF i-opcao > 0 THEN DO WITH FRAME fpage1:
        STATUS DEFAULT.
        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = INPUT fi-it-codigo NO-ERROR.
        IF NOT AVAIL ITEM THEN DO:
            RUN ShowMessage (1, "Item n∆o cadastrado", "").
            l-erro = YES.
            run setFolder IN hFolder (input 1).
            APPLY "entry" TO fi-it-codigo IN FRAME fpage1.
            RETURN NO-APPLY.
        END.
        find FIRST ficha-cq NO-LOCK
            WHERE ficha-cq.nr-ficha    = INPUT fi-nr-ficha no-error.
        IF NOT AVAIL ficha-cq THEN DO:
            RUN ShowMessage (1, "Roteiro n∆o cadastrado", "").
            l-erro = YES.
            run setFolder IN hFolder (input 1).
            APPLY "entry" TO fi-nr-ficha IN FRAME fpage1.
            RETURN NO-APPLY.
        END.
        find ficha-cq NO-LOCK
            WHERE ficha-cq.it-codigo = INPUT fi-it-codigo 
            and ficha-cq.nr-ficha    = INPUT fi-nr-ficha no-error.
        if not avail ficha-cq then do:
            RUN ShowMessage (1, "Roteiro n∆o pertence ao item informado", "").
            l-erro = YES.
            run setFolder IN hFolder (input 1).
            APPLY "entry" TO fi-nr-ficha IN FRAME fpage1.
            RETURN NO-APPLY.
        end.     
        IF NOT CAN-FIND(deposito NO-LOCK
                        WHERE deposito.cod-depos = INPUT fi-cod-depos-sai) THEN DO:
            RUN ShowMessage (1, "Dep¢sito n∆o cadastrado", "").
            l-erro = YES.
            run setFolder IN hFolder (input 1).
            APPLY "entry" TO fi-cod-depos-sai IN FRAME fpage1.
            RETURN NO-APPLY.
        END.

        run esp/es0590a.p (input "escqp006", 
                           input INPUT fi-cod-depos-sai,
                           input no, /*saida */
                           INPUT c-seg-usuario,
                           output l-perm).
        IF NOT l-perm THEN do:
            l-erro = YES.
            run setFolder IN hFolder (input 1).
            APPLY "entry" TO fi-cod-depos-sai IN FRAME fpage1.
            RETURN NO-APPLY.
        END.
        run esp/es0590a.p (input "escqp006", 
                           input INPUT fi-cod-depos-ent,
                           input yes, /*ent*/
                           INPUT c-seg-usuario,
                           output l-perm).
        IF NOT l-perm THEN do:
            l-erro = YES.
            run setFolder IN hFolder (input 1).
            APPLY "entry" TO fi-cod-depos-ent IN FRAME fpage1.
            RETURN NO-APPLY.
        END.

        IF congelado(input v_cod_estab_usuar,
                     input input fi-it-codigo,
                     input input fi-cod-depos-sai,
                     input input fi-cod-localiz-saida) then do:

            RUN ShowMessage (1, "Item/Dep¢sito/Localizaá∆o de Origem Congelada para Invent†rio", "").
            l-erro = YES.
            run setFolder IN hFolder (input 1).
            APPLY "entry" TO fi-cod-depos-sai IN FRAME fpage1.
            RETURN NO-APPLY.

        end.

        IF congelado(input v_cod_estab_usuar,
                     input input fi-it-codigo,
                     input input fi-cod-depos-ent,
                     input ?) then do:

            RUN ShowMessage (1, "Item/Dep¢sito/Localizaá∆o de Destino Congelada para Invent†rio", "").
            l-erro = YES.
            run setFolder IN hFolder (input 1).
            APPLY "entry" TO fi-cod-depos-ent IN FRAME fpage1.
            RETURN NO-APPLY.

        end.

        APPLY "leave" TO fi-quantidade IN FRAME fpage1.

        EMPTY TEMP-TABLE tt-transferencia.
        CREATE tt-transferencia.
        ASSIGN tt-transferencia.it-codigo       = INPUT fi-it-codigo
               tt-transferencia.nr-ficha        = INPUT fi-nr-ficha
               tt-transferencia.cod-depos-sai   = INPUT fi-cod-depos-sai
               tt-transferencia.cod-localiz-sai = INPUT fi-cod-localiz-saida
               tt-transferencia.codigo-rejei    = INPUT fi-codigo-rejei
               tt-transferencia.cod-depos-ent   = INPUT fi-cod-depos-ent
               tt-transferencia.observacao      = INPUT fi-observacao
               tt-transferencia.cod-localiz-ent = INPUT fi-cod-localiz-entrada
               tt-transferencia.retira-de       = INPUT cb-retira
               tt-transferencia.quantidade      = INPUT fi-quantidade
               tt-transferencia.contenedor      = INPUT fi-contenedor
               tt-transferencia.narrativa       = INPUT FRAME fpage2 fi-narrativa
               tt-transferencia.impressora      = INPUT FRAME fpage4 fiPrinter.

        EMPTY TEMP-TABLE tt-ae-raw.
        FOR EACH tt-ae:
            CREATE tt-ae-raw.
            RAW-TRANSFER tt-ae TO tt-ae-raw.ae-raw.
        END.

        CASE i-opcao:
            WHEN 1 OR WHEN 2 THEN DO:
                IF LOOKUP(INPUT fi-cod-depos-sai, "{&DEPOSITOS-REJEICAO}") = 0 THEN DO:
                    RUN ShowMessage (1, "O dep¢sito deve ser de rejeiá∆o", 
                                     substitute("Escolha entre os dep¢sitos: &1",
                                                caps(REPLACE("{&DEPOSITOS-REJEICAO}", ",", "  ")))).
                    l-erro = YES.
                    run setFolder IN hFolder (input 1).
                    APPLY "entry" TO fi-cod-depos-sai IN FRAME fpage1.
                    RETURN NO-APPLY.
                END.
                IF INPUT fi-quantidade = 0 THEN DO:
                    RUN ShowMessage (1, "Quantidade informada incorreta", "Quantidade deve ser maior que zero").
                    l-erro = YES.
                    run setFolder IN hFolder (input 1).
                    APPLY "entry" TO fi-quantidade IN FRAME fpage1.
                    RETURN NO-APPLY.
                END.
                IF INPUT fi-quantidade > ficha-cq.qt-rejeitada THEN DO:
                    RUN ShowMessage (1, "Quantidade informada excede rejeitada", "Quantidade deve ser igual ou menor a rejeitada").
                    l-erro = YES.
                    run setFolder IN hFolder (input 1).
                    APPLY "entry" TO fi-quantidade IN FRAME fpage1.
                    RETURN NO-APPLY.
                END.
                RUN piValidaDataFabric.
                IF RETURN-VALUE = "NOK" THEN RETURN NO-APPLY.
                
                IF i-opcao = 1 THEN
                    assign i-qt-aprovada  = input fi-qt-aprovada + input fi-quantidade
                           i-qt-rejeitada = input fi-qt-rejeitada - input fi-quantidade
                           i-qt-apr-cond  = input fi-qt-apr-cond.
                ELSE
                    assign i-qt-aprovada  = input fi-qt-aprovada
                           i-qt-rejeitada = input fi-qt-rejeitada - input fi-quantidade
                           i-qt-apr-cond  = input fi-qt-apr-cond + input fi-quantidade.
                           
                ASSIGN  tt-transferencia.qt-aprovada  = i-qt-aprovada 
                        tt-transferencia.qt-rejeitada = i-qt-rejeitada
                        tt-transferencia.qt-apr-cond  = i-qt-apr-cond 
                        tt-transferencia.dt-validade  = data-validade.

                RUN piPrepara.
                
                APPLY "choose" TO btCancela IN FRAME fpage0.
                STATUS DEFAULT "Processando a transferància. Aguarde...".
                SESSION:SET-WAIT-STATE("GENERAL":U).
                RUN piAprovaAlm IN h-api (input v_cod_estab_usuar,
                                          INPUT TABLE tt-transferencia,
                                          INPUT TABLE tt-ae-raw).
                STATUS DEFAULT.
                SESSION:SET-WAIT-STATE("":U).
                IF RETURN-VALUE = "NOK" THEN DO:
                    ENABLE {&List-2} WITH FRAME fpage1.
                    ENABLE ALL WITH FRAME fpage2.
                    IF i-opcao = 1 THEN
                        APPLY "choose" TO btAprovar IN FRAME fpage1.
                    ELSE
                        APPLY "choose" TO btCondicional IN FRAME fpage1.
                    IF CAN-FIND(FIRST tt-ae) THEN DO:
                        RUN setEnabled IN hFolder (INPUT 3, INPUT YES).
                        ENABLE ALL WITH FRAME fpage3.
                    END.
                    l-erro = YES.
                    run setFolder IN hFolder (input 1).
                    APPLY "leave" TO fi-cod-depos-ent IN FRAME fpage1.
                    APPLY "entry" to fi-it-codigo IN FRAME fpage1.
                    RETURN NO-APPLY.
                END.
                IF i-opcao = 2 THEN run imprime-rej.

            END.
            WHEN 3 THEN DO:
                IF NOT CAN-FIND(cod-rejeicao NO-LOCK
                            WHERE cod-rejeicao.codigo-rejei = INPUT fi-codigo-rejei) THEN DO:
                    RUN ShowMessage (1, "C¢digo de rejeiá∆o n∆o cadastrado", "").
                    l-erro = YES.
                    run setFolder IN hFolder (input 1).
                    APPLY "entry" TO fi-codigo-rejei IN FRAME fpage1.
                    RETURN NO-APPLY.
                END.
                IF LOOKUP(INPUT fi-cod-depos-sai, "{&DEPOSITOS-REJEICAO}") = 1
                OR LOOKUP(INPUT fi-cod-depos-sai, "{&DEPOSITOS-REJEICAO}") = 3  THEN DO:
                    RUN ShowMessage (1, "O dep¢sito n∆o deve ser de rejeiá∆o", 
                                     substitute("Escolha um dep¢sito diferente de: &1 &2",
                                                caps(ENTRY(1,"{&DEPOSITOS-REJEICAO}")),
                                                CAPS(ENTRY(3,"{&DEPOSITOS-REJEICAO}")))).
                    l-erro = YES.
                    run setFolder IN hFolder (input 1).
                    APPLY "entry" TO fi-cod-depos-sai IN FRAME fpage1.
                    RETURN NO-APPLY.
                END.
                IF INPUT fi-quantidade > IF INPUT cb-retira THEN ficha-cq.qt-aprovada ELSE ficha-cq.qt-apr-cond THEN DO:
                    RUN ShowMessage (1, substitute("Quantidade informada excede &1", IF INPUT cb-retira THEN "aprovada" ELSE "aprovada condicional"), 
                                     substitute("Quantidade deve ser igual ou menor a &1", IF INPUT cb-retira THEN "aprovada" ELSE "aprovada condicional")).
                    l-erro = YES.
                    run setFolder IN hFolder (input 1).
                    APPLY "entry" TO fi-quantidade IN FRAME fpage1.
                    RETURN NO-APPLY.
                END.
                IF INPUT fi-cod-depos-ent = "dev" or
                   INPUT fi-cod-depos-ent = "rtb"
                THEN DO:
                    IF INPUT fi-cod-localiz-entrada = "" THEN DO:
                        RUN ShowMessage (1, "Localizaá∆o n∆o informada", 
                                         "Informe uma localizaá∆o").
                        l-erro = YES.
                        run setFolder IN hFolder (input 1).
                        APPLY "entry" to fi-cod-localiz-entrada IN FRAME fpage1.
                        RETURN NO-APPLY.
                    END.
                END.
                RUN piValidaDataFabric.
                IF RETURN-VALUE = "NOK" THEN RETURN NO-APPLY.
                if INPUT cb-retira then 
                    assign i-qt-aprovada = input fi-qt-aprovada - input fi-quantidade
                           i-qt-rejeitada = input fi-qt-rejeitada + input fi-quantidade
                           i-qt-apr-cond  = input fi-qt-apr-cond.
                else
                    assign i-qt-aprovada = input fi-qt-aprovada
                           i-qt-rejeitada = input fi-qt-rejeitada + input fi-quantidade
                           i-qt-apr-cond  = input fi-qt-apr-cond - input fi-quantidade.

                ASSIGN  tt-transferencia.qt-aprovada  = i-qt-aprovada 
                        tt-transferencia.qt-rejeitada = i-qt-rejeitada
                        tt-transferencia.qt-apr-cond  = i-qt-apr-cond 
                        tt-transferencia.dt-validade  = data-validade.

                RUN piPrepara.

                IF INPUT fi-cod-depos-sai NE "alm" THEN DO:
                    APPLY "choose" TO btCancela IN FRAME fpage0.
                    STATUS DEFAULT "Processando a transferància. Aguarde...".
                    SESSION:SET-WAIT-STATE("GENERAL":U).
                    RUN piRejeitaOutros IN h-api (INPUT v_cod_estab_usuar,
                                                  INPUT TABLE tt-transferencia,
                                                  INPUT TABLE tt-ae-raw).
                    STATUS DEFAULT.
                    SESSION:SET-WAIT-STATE("":U).
                END.
                ELSE do:
                    if INPUT FRAME fpage3 fi-quant NE INPUT fi-quantidade then do:
                        RUN ShowMessage (1, "Quantidade de etiquetas incorreta", 
                                         SUBSTITUTE("A quantidade de etiquetas selecionadas difere da informada: &1", trim(string(INPUT fi-quantidade)))).
                        l-erro = YES.
                        run setFolder IN hFolder (input 1).
                        APPLY "entry" to fi-quantidade IN FRAME fpage1.
                        RETURN NO-APPLY.
                    end.
                    APPLY "choose" TO btCancela IN FRAME fpage0.
                    STATUS DEFAULT "Processando a transferància. Aguarde...".
                    SESSION:SET-WAIT-STATE("GENERAL":U).
                    RUN piRejeitaAlm IN h-api (input v_cod_estab_usuar,
                                               INPUT TABLE tt-transferencia,
                                               INPUT TABLE tt-ae-raw).
                    STATUS DEFAULT.
                    SESSION:SET-WAIT-STATE("":U).
                END.
                IF RETURN-VALUE = "NOK" THEN DO:
                    ENABLE {&List-2} WITH FRAME fpage1.
                    ENABLE ALL WITH FRAME fpage2.
                    APPLY "choose" TO btRejeitar IN FRAME fpage1.
                    IF CAN-FIND(FIRST tt-ae) THEN DO:
                        RUN setEnabled IN hFolder (INPUT 3, INPUT YES).
                        ENABLE ALL WITH FRAME fpage3.
                    END.
                    l-erro = YES.
                    run setFolder IN hFolder (input 1).
                    APPLY "leave" TO fi-cod-depos-ent IN FRAME fpage1.
                    APPLY "entry" to fi-it-codigo IN FRAME fpage1.
                    RETURN NO-APPLY.
                END.
                run imprime-rej.
            END.
        END CASE.
        FOR FIRST ficha-cq FIELDS (qt-aprovada qt-apr-cond qt-rejeitada) NO-LOCK
            WHERE ficha-cq.nr-ficha = INPUT FRAME fpage1 fi-nr-ficha:
            disp ficha-cq.qt-aprovada  @ fi-qt-aprovada 
                 ficha-cq.qt-apr-cond  @ fi-qt-apr-cond 
                 ficha-cq.qt-rejeitada @ fi-qt-rejeitada WITH FRAME fpage1.
        END.

        STATUS DEFAULT "Transferància executada com sucesso".
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelectPrinter wWindow 
PROCEDURE piSelectPrinter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTempFile AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cAuxFile  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cPrev     AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME fPage4 fiPrinter.

    ASSIGN cPrev     = fiPrinter
           cTempFile = REPLACE(fiPrinter, ":":U, ",":U).

    IF fiPrinter <> "":U THEN DO:
        IF NUM-ENTRIES(cTempFile) = 4 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile) + ":":U + ENTRY(4, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 3 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 2 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = "":U.
    END.

    RUN utp/ut-impr.w (INPUT-OUTPUT cPrinter,
                       INPUT-OUTPUT cLayout,
                       INPUT-OUTPUT cAuxFile).

    IF cAuxFile = "":U THEN
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout.
    ELSE
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout + ":":U + cAuxFile.

    IF fiPrinter = ":":U THEN
        ASSIGN fiPrinter = cPrev.

    DISPLAY fiPrinter
        WITH FRAME fPage4.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaDataFabric wWindow 
PROCEDURE piValidaDataFabric :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-dias-val AS INTEGER NO-UNDO.
    DO WITH FRAME fpage1:
        IF input fi-dt-fabricacao = ? THEN DO:
            RUN ShowMessage (1, "Data de fabricaá∆o n∆o informada", 
                             "Informe uma data igual ou menor a data corrente").
            l-erro = YES.
            run setFolder IN hFolder (input 1).
            APPLY "entry" TO fi-dt-fabricacao in frame fpage1.
            RETURN "NOK".
        END.
        IF input fi-dt-fabricacao > TODAY THEN DO:
            RUN ShowMessage (1, "Data de fabricaá∆o superior a data corrente", 
                             "Data de fabricaá∆o deve ser igual ou menor a data corrente").
            l-erro = YES.
            run setFolder IN hFolder (input 1).
            APPLY "entry" TO fi-dt-fabricacao in frame fpage1.
            RETURN "NOK".
        END.
        FOR first familia no-lock 
            WHERE familia.fm-codigo = item.fm-codigo:
            assign i-dias-val = 1.
            FOR int-familia of familia NO-LOCK:
                assign i-dias-val = int-familia.meses-validade * 30.
            END.
        END.

        assign data-validade  = input fi-dt-fabricacao + i-dias-val.

        if data-validade <= today then do:
            RUN ShowMessage (3, "Item com prazo de validade vencido", 
                             "O item est† com o prazo de validade vencido. Continua?").
            IF RETURN-VALUE = "no" THEN DO:
                data-validade = ?.
                run setFolder IN hFolder (input 1).
                RETURN "NOK".
            END.
         end.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-valida-operacao wWindow 
FUNCTION fn-valida-operacao RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RETURN BROWSE brItem:NUM-ITERATIONS > 0 AND BROWSE brItem:NUM-SELECTED-ROWS > 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

