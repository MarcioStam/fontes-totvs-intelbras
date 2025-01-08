&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados .
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************* **********************************/
{include/i-prgvrs.i espdp056 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        espdp056
&GLOBAL-DEFINE Version        2.04.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,Digitaá∆o,Impress∆o

&GLOBAL-DEFINE PGLAY          no
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          no
&GLOBAL-DEFINE PGPAR          no
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          no

&GLOBAL-DEFINE RTF            no

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page5Widgets   brDigita btAdd btUpdate btDelete btSave btOpen
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              l-habilitaRtf ~
                              btModelRtf

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo text-rtf text-ModelRtf

&GLOBAL-DEFINE page2Fields    fi-cod-estabel fi-dt-emissao-ini fi-dt-emissao-fim fi-dt-entrega-ini fi-dt-entrega-fim ~
                              fi-nr-pedcli-ini fi-nr-pedcli-fim fi-prioridade-ini fi-prioridade-fim fi-atendente-ini fi-atendente-fim ~
                              fi-parcial fi-so-listar fi-pedidos tg-considera fi-suspensos fi-it-codigo-ini fi-it-codigo-fim fi-dt-entrega-futura rs-altera-data    
&GLOBAL-DEFINE page6Fields    cFile cModelRTF

/* Parameters Definitions ---                                           */
{esp/pdp/espdp056tt.i}
{esp/es0018.i}

DEF BUFFER b-tt-digita FOR tt-digita.
/* Transfer Definitions */

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.
DEF VAR i-cont             AS INT     NO-UNDO.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDigita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE brDigita                                      */
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.tipo-trans /*wilson a2*/ tt-digita.nr-pedcli tt-digita.it-codigo tt-digita.nr-sequencia /*wilson a2*/ tt-digita.dt-entrega-futura tt-digita.qt-pedida /*wilson a2*/ tt-digita.vl-preuni /*wilson a2*/ tt-digita.per-des-item tt-digita.nr-tabpre tt-digita.observacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.tipo-trans ~
 ~
  /*wilson a2*/ tt-digita.nr-pedcli ~
 ~
   tt-digita.it-codigo ~
 ~
   tt-digita.nr-sequencia ~
 ~
 /*wilson a2*/ tt-digita.dt-entrega-futura ~
   tt-digita.qt-pedida ~
 ~
   /*wilson a2*/ tt-digita.vl-preuni ~
 ~
   /*wilson a2*/ tt-digita.per-des-item tt-digita.nr-tabpre tt-digita.observacao   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigita tt-digita
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY brDigita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita tt-digita


/* Definitions for FRAME fpage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage5 ~
    ~{&OPEN-QUERY-brDigita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 94 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-pedidos AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 61 BY 2.63 NO-UNDO.

DEFINE VARIABLE fi-atendente-fim AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 6 BY .79 NO-UNDO.

DEFINE VARIABLE fi-atendente-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Atendente" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(3)":U INITIAL "101" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-dt-emissao-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-dt-emissao-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt.Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-dt-entrega-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-dt-entrega-futura AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt. Entrega Futura" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-entrega-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt.Prev.Fatur" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-nr-pedcli-fim AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-nr-pedcli-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pedidos" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-prioridade-fim AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 6 BY .79 NO-UNDO.

DEFINE VARIABLE fi-prioridade-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Prioridade" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .79 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
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

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
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

DEFINE VARIABLE rs-altera-data AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Alterar a data somente no cabeáalho do pedido", 1,
"Alterar datas nos itens do pedido", 2
     SIZE 35 BY 1.42 NO-UNDO.

DEFINE VARIABLE fi-parcial AS LOGICAL INITIAL yes 
     LABEL "Verificar Pedidos Atendidos Parcial" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83 NO-UNDO.

DEFINE VARIABLE fi-so-listar AS LOGICAL INITIAL no 
     LABEL "Somente Listar e n∆o atualizar a data de Prev.Fatur." 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY .83 NO-UNDO.

DEFINE VARIABLE fi-suspensos AS LOGICAL INITIAL yes 
     LABEL "Verificar Pedidos Suspensos" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-considera AS LOGICAL INITIAL yes 
     LABEL "Considerar pedidos com prioridade 44" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83 NO-UNDO.

DEFINE BUTTON btAdd 
     LABEL "Inserir" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btDelete 
     LABEL "Retirar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btOpen 
     LABEL "Recuperar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btUpdate 
     LABEL "Alterar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btModelRtf 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cModelRTF AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-ModelRtf AS CHARACTER FORMAT "X(256)":U INITIAL "Modelo:" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-rtf AS CHARACTER FORMAT "X(256)":U INITIAL "Rich Text Format(RTF)" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

DEFINE RECTANGLE rect-rtf
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 3.21.

DEFINE VARIABLE l-habilitaRtf AS LOGICAL INITIAL no 
     LABEL "RTF" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-digita.tipo-trans                 COLUMN-LABEL "Tp.Trans"               /*wilson a2*/
tt-digita.nr-pedcli                  COLUMN-LABEL "Pedido"
tt-digita.it-codigo                  COLUMN-LABEL "Item"
tt-digita.nr-sequencia               COLUMN-LABEL "Nr Seq."                /*wilson a2*/
tt-digita.dt-entrega-futura          COLUMN-LABEL "Dt.Entrega Fut"
tt-digita.qt-pedida                  COLUMN-LABEL "Qtde"                   /*wilson a2*/
tt-digita.vl-preuni                  COLUMN-LABEL "Preáo"                  /*wilson a2*/
tt-digita.per-des-item              COLUMN-LABEL "% Desconto"    
tt-digita.nr-tabpre                 COLUMN-LABEL "Tab Preco"
tt-digita.observacao                 COLUMN-LABEL "Observ."  FORMAT 'x(2000)'  
ENABLE
tt-digita.tipo-trans                    /*wilson a2*/
tt-digita.nr-pedcli                    
tt-digita.it-codigo                    
tt-digita.nr-sequencia                  /*wilson a2*/
tt-digita.dt-entrega-futura            
tt-digita.qt-pedida                     /*wilson a2*/
tt-digita.vl-preuni                     /*wilson a2*/
tt-digita.per-des-item
tt-digita.nr-tabpre
tt-digita.observacao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 89.57 BY 7
         BGCOLOR 15 FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 19.46 COL 2.14
     btCancel AT ROW 19.46 COL 13.14
     btHelp2 AT ROW 19.46 COL 84
     rtToolBar AT ROW 19.21 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 94.14 BY 19.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     fi-cod-estabel AT ROW 1.5 COL 9
     fi-dt-emissao-ini AT ROW 2.71 COL 19 COLON-ALIGNED WIDGET-ID 6
     fi-dt-emissao-fim AT ROW 2.71 COL 46 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     fi-dt-entrega-ini AT ROW 3.71 COL 19 COLON-ALIGNED WIDGET-ID 12
     fi-dt-entrega-fim AT ROW 3.71 COL 46 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     fi-nr-pedcli-ini AT ROW 4.71 COL 19 COLON-ALIGNED WIDGET-ID 20
     fi-nr-pedcli-fim AT ROW 4.71 COL 46 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     fi-prioridade-ini AT ROW 5.71 COL 19 COLON-ALIGNED WIDGET-ID 28
     fi-prioridade-fim AT ROW 5.71 COL 46 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     fi-atendente-ini AT ROW 6.71 COL 19 COLON-ALIGNED WIDGET-ID 36
     fi-atendente-fim AT ROW 6.71 COL 46 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     fi-it-codigo-ini AT ROW 7.71 COL 19 COLON-ALIGNED WIDGET-ID 64
     fi-it-codigo-fim AT ROW 7.71 COL 46 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     fi-dt-entrega-futura AT ROW 8.71 COL 19 COLON-ALIGNED WIDGET-ID 70
     fi-parcial AT ROW 9.71 COL 21 WIDGET-ID 42
     tg-considera AT ROW 9.83 COL 48 WIDGET-ID 58
     fi-so-listar AT ROW 10.58 COL 21 WIDGET-ID 44
     fi-suspensos AT ROW 11.5 COL 21 WIDGET-ID 60
     fi-pedidos AT ROW 12.46 COL 21 NO-LABEL WIDGET-ID 48
     rs-altera-data AT ROW 15.17 COL 21 NO-LABEL WIDGET-ID 76
     "   Alterar:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 15.21 COL 15 WIDGET-ID 82
     "Pedidos:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 12.58 COL 15 WIDGET-ID 50
     IMAGE-1 AT ROW 2.71 COL 33 WIDGET-ID 2
     IMAGE-2 AT ROW 2.71 COL 44 WIDGET-ID 4
     IMAGE-15 AT ROW 3.71 COL 33 WIDGET-ID 14
     IMAGE-16 AT ROW 3.71 COL 44 WIDGET-ID 16
     IMAGE-17 AT ROW 4.71 COL 33 WIDGET-ID 22
     IMAGE-18 AT ROW 4.71 COL 44 WIDGET-ID 24
     IMAGE-19 AT ROW 5.71 COL 33 WIDGET-ID 30
     IMAGE-20 AT ROW 5.71 COL 44 WIDGET-ID 32
     IMAGE-21 AT ROW 6.71 COL 33 WIDGET-ID 38
     IMAGE-22 AT ROW 6.71 COL 44 WIDGET-ID 40
     IMAGE-23 AT ROW 7.71 COL 33 WIDGET-ID 66
     IMAGE-24 AT ROW 7.71 COL 44 WIDGET-ID 68
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.57 ROW 2.75
         SIZE 91.3 BY 15.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configuraá∆o da impressora"
     l-habilitaRtf AT ROW 5.58 COL 3.14
     cModelRTF AT ROW 7.29 COL 3 HELP
          "Nome do arquivo de modelo" NO-LABEL
     btModelRtf AT ROW 7.29 COL 43 HELP
          "Escolha o arquivo de modelo"
     rsExecution AT ROW 9.5 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-rtf AT ROW 5 COL 2 COLON-ALIGNED NO-LABEL
     text-ModelRtf AT ROW 6.54 COL 2 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 8.75 COL 1.14 COLON-ALIGNED NO-LABEL
     rect-rtf AT ROW 5.29 COL 2
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 9 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.79
         SIZE 91 BY 10.17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fpage5
     brDigita AT ROW 1.38 COL 1.57 WIDGET-ID 300
     btAdd AT ROW 8.33 COL 1.43 WIDGET-ID 2
     btUpdate AT ROW 8.33 COL 20.29 WIDGET-ID 10
     btDelete AT ROW 8.33 COL 39.57 WIDGET-ID 4
     btSave AT ROW 8.33 COL 58.86 WIDGET-ID 8
     btOpen AT ROW 8.33 COL 76.29 WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.72 ROW 2.79
         SIZE 91.29 BY 15.71 WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 19.75
         WIDTH              = 94.14
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.14
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fpage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fpage5
                                                                        */
/* BROWSE-TAB brDigita 1 fpage5 */
/* SETTINGS FOR BUTTON btUpdate IN FRAME fpage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       btModelRtf:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       cModelRTF:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-ModelRtf:HIDDEN IN FRAME fPage6           = TRUE
       text-ModelRtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Modelo:".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

ASSIGN 
       text-rtf:HIDDEN IN FRAME fPage6           = TRUE
       text-rtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Rich Text Format(RTF)".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigita
/* Query rebuild information for BROWSE brDigita
     _START_FREEFORM
OPEN QUERY brDigita FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDigita */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDigita
&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON DEL OF brDigita IN FRAME fpage5
DO:
   apply 'choose' to btDelete in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON END-ERROR OF brDigita IN FRAME fpage5
ANYWHERE 
DO:
    if  brDigita:new-row in frame fPage5 then do:
        if  avail tt-digita then
            delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then. 
    end.                                                               
    else do:
        get current brDigita.
        display tt-digita.tipo-trans       
                tt-digita.nr-pedcli        
                tt-digita.it-codigo         
                tt-digita.nr-sequencia     
                tt-digita.dt-entrega-futura
                tt-digita.qt-pedida        
                tt-digita.vl-preuni  
                tt-digita.per-des-item
                tt-digita.observacao                
                 
            with browse brDigita. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ENTER OF brDigita IN FRAME fpage5
ANYWHERE
DO:
     apply 'tab' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON INS OF brDigita IN FRAME fpage5
DO:
   apply 'choose' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-END OF brDigita IN FRAME fpage5
DO:
   apply 'entry' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-HOME OF brDigita IN FRAME fpage5
DO:
  apply 'entry' to btOpen in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-ENTRY OF brDigita IN FRAME fpage5
DO:
   /*:T trigger para inicializar campos da temp table de digitaá∆o */
   if  brDigita:new-row in frame fPage5 then do:
       /*assign tt-digita.exemplo:screen-value in browse brDigita = string(today, "99/99/9999":U).*/
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fpage5
DO:
    /*:T ê aqui que a gravaá∆o da linha da temp-table Ç efetivada.
       PorÇm as validaá‰es dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment†rio */
    
    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse brDigita tt-digita.tipo-trans       
               input browse brDigita tt-digita.nr-pedcli
               input browse brDigita tt-digita.it-codigo
               input browse brDigita tt-digita.nr-sequencia     
               input browse brDigita tt-digita.dt-entrega-futura
               input browse brDigita tt-digita.qt-pedida        
               input browse brDigita tt-digita.vl-preuni
               input browse brDigita tt-digita.per-des-item 
               input browse brDigita tt-digita.observacao.             
               
        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-digita then
        DO:
            assign input browse brDigita tt-digita.tipo-trans       
                   input browse brDigita tt-digita.nr-pedcli
                   input browse brDigita tt-digita.it-codigo
                   input browse brDigita tt-digita.nr-sequencia     
                   input browse brDigita tt-digita.dt-entrega-futura
                   input browse brDigita tt-digita.qt-pedida        
                   input browse brDigita tt-digita.vl-preuni
                   input browse brDigita tt-digita.per-des-item
                   input browse brDigita tt-digita.observacao.  
        END.
    end.
           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wReport
ON CHOOSE OF btAdd IN FRAME fpage5 /* Inserir */
DO:
    assign /*btUpdate:SENSITIVE in frame fPage5 = yes*/
           btDelete:SENSITIVE in frame fPage5 = yes
           btSave:SENSITIVE   in frame fPage5 = yes.
    
    if num-results("brDigita":U) > 0 then
        brDigita:INSERT-ROW("after":U) in frame fPage5.
    else do transaction:
        create tt-digita.
        open query brDigita for each tt-digita.
        apply "entry":U to tt-digita.tipo-trans in browse brDigita. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wReport
ON CHOOSE OF btConfigImpr IN FRAME fPage6
DO:
   {report/rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wReport
ON CHOOSE OF btDelete IN FRAME fpage5 /* Retirar */
DO:
    if  brDigita:num-selected-rows > 0 then do on error undo, return no-apply:
        get current brDigita.
        delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then.
    end.
    
    if num-results("brDigita":U) = 0 then
        assign btUpdate:SENSITIVE in frame fPage5 = no
               btDelete:SENSITIVE in frame fPage5 = no
               btSave:SENSITIVE   in frame fPage5 = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wReport
ON CHOOSE OF btFile IN FRAME fPage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btModelRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModelRtf wReport
ON CHOOSE OF btModelRtf IN FRAME fPage6
DO:
    def var cFile as char no-undo.
    def var l-ok  as logical no-undo.

    assign cModelRTF = replace(input frame {&frame-name} cModelRTF, "/", "~\").
    SYSTEM-DIALOG GET-FILE cFile
       FILTERS "*.rtf" "*.rtf",
               "*.*" "*.*"
       DEFAULT-EXTENSION "rtf"
       INITIAL-DIR "modelos" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign cModelRTF:screen-value in frame {&frame-name}  = replace(cFile, "~\", "/"). 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME btOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOpen wReport
ON CHOOSE OF btOpen IN FRAME fpage5 /* Recuperar */
DO:
   //  {report/rprcd.i}

   DEF VAR cConvFile  AS CHAR NO-UNDO.

   SYSTEM-DIALOG GET-FILE cConvFile
      FILTERS "*.csv":U "*.csv":U,
              "*.*":U "*.*":U
   
   DEFAULT-EXTENSION "csv":U
   INITIAL-DIR "spool":U 
   USE-FILENAME
   UPDATE l-ok.

   IF  l-ok = YES THEN DO:

       FOR EACH tt-digita: DELETE tt-digita. END.

       ASSIGN cConvFile = REPLACE(cConvFile, "~\":U, "/":U).

       INPUT FROM VALUE(cConvFile).

       REPEAT:

           CREATE tt-digita.
           IMPORT DELIMITER ';' tt-digita.
       END.

       FOR EACH tt-digita:
           IF tt-digita.it-codigo = '' THEN 
              DELETE tt-digita.
       END.

       OPEN QUERY brDigita FOR EACH tt-digita.
   END.                                       

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wReport
ON CHOOSE OF btSave IN FRAME fpage5 /* Salvar */
DO:
   {report/rpsvd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wReport
ON CHOOSE OF btUpdate IN FRAME fpage5 /* Alterar */
DO:
   apply 'entry' to tt-digita.tipo-trans in browse brDigita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME l-habilitaRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-habilitaRtf wReport
ON VALUE-CHANGED OF l-habilitaRtf IN FRAME fPage6 /* RTF */
DO:
    &IF "{&RTF}":U = "YES":U &THEN
    RUN pi-habilitaRtf.  
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
do  with frame fPage6:
    case self:screen-value:
        when "1":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   /*Alterado 15/02/2005 - tech1007 - Alterado para suportar adequadamente com a 
                     funcionalidade de RTF*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = NO
                   l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                   l-habilitaRtf = NO
                   &endif
                   .
                   /*Fim alteracao 15/02/2005*/
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
            /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
            &IF "{&RTF}":U = "YES":U &THEN
            IF VALID-HANDLE(hWenController) THEN DO:
                ASSIGN l-habilitaRtf:sensitive  = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                       l-habilitaRtf = NO.
            END.
            &endif
            /*Fim alteracao 15/02/2005*/
        END.
        /*Alterado 15/02/2005 - tech1007 - Condiá∆o removida pois RTF n∆o Ç mais um destino
        when "4":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   text-ModelRtf:VISIBLE   = YES
                   rect-rtf:VISIBLE       = YES
                   blModelRtf:VISIBLE       = yes.
        end.
        Fim alteracao 15/02/2005*/
    end case.
end.
&IF "{&RTF}":U = "YES":U &THEN
RUN pi-habilitaRtf.  
&endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage6
DO:
   {report/rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{report/mainblock.i}

/*wilson gesplus*/
ON 'leave':U  OF tt-digita.it-codigo IN BROWSE brDigita or
   'return':U OF tt-digita.it-codigo IN BROWSE brDigita DO:
       ASSIGN tt-digita.dt-entrega-futura:SCREEN-VALUE IN BROWSE brDigita = STRING(TODAY,"99/99/9999").
       IF tt-digita.tipo-trans:SCREEN-VALUE IN BROWSE brDigita = "I" THEN DO:
           FIND FIRST ped-venda
               WHERE ped-venda.nr-pedcli = tt-digita.nr-pedcli:SCREEN-VALUE IN BROWSE brDigita
               NO-LOCK NO-ERROR.
           IF AVAIL ped-venda THEN DO:
               FIND LAST ped-item OF ped-venda NO-LOCK NO-ERROR.
               IF AVAIL ped-item THEN
                   ASSIGN tt-digita.nr-sequencia:SCREEN-VALUE IN BROWSE brDigita = STRING(ped-item.nr-sequencia + 10).
               ELSE
                   ASSIGN tt-digita.nr-sequencia:SCREEN-VALUE IN BROWSE brDigita = "10".
           END.

           Loop:
           FOR EACH b-tt-digita
               WHERE b-tt-digita.nr-pedcli  = tt-digita.nr-pedcli:SCREEN-VALUE IN BROWSE brDigita
               /*AND   b-tt-digita.it-codigo  = tt-digita.it-codigo:SCREEN-VALUE IN BROWSE brDigita -- NAO ESTAVA PREENCHENDO COM A SEQUENCIA DO ULTIMO ITEM INFORMADO*/
               AND   b-tt-digita.tipo-trans = "I"
               BREAK BY b-tt-digita.nr-sequencia DESC:

               ASSIGN tt-digita.nr-sequencia:SCREEN-VALUE IN BROWSE brDigita = string(b-tt-digita.nr-sequencia + 10).

               LEAVE Loop.                                                                                           
           END.

           FIND CURRENT tt-digita NO-ERROR.

            IF AVAIL tt-digita THEN
               ASSIGN tt-digita.nr-sequencia = INT(tt-digita.nr-sequencia:SCREEN-VALUE IN BROWSE brDigita). 
            
       END.
       IF (tt-digita.tipo-trans:SCREEN-VALUE IN BROWSE brDigita = "C" or
           tt-digita.tipo-trans:SCREEN-VALUE IN BROWSE brDigita = "A") THEN DO:
           FOR EACH ped-item
               WHERE ped-item.nr-pedcli = tt-digita.nr-pedcli:SCREEN-VALUE IN BROWSE brDigita
               AND   ped-item.it-codigo = tt-digita.it-codigo:SCREEN-VALUE IN BROWSE brDigita
               NO-LOCK
               BREAK BY ped-item.nr-sequencia.
               ASSIGN tt-digita.nr-sequencia:SCREEN-VALUE IN BROWSE brDigita = STRING(ped-item.nr-sequencia).
               LEAVE.
           END.
       END.

    
END. 

ON 'leave':U  OF tt-digita.nr-sequencia IN BROWSE brDigita or
   'return':U OF tt-digita.nr-sequencia IN BROWSE brDigita DO:
    IF tt-digita.tipo-trans:SCREEN-VALUE IN BROWSE brDigita = "A" or
       tt-digita.tipo-trans:SCREEN-VALUE IN BROWSE brDigita = "C" THEN DO:
       FIND FIRST ped-item
           WHERE ped-item.nr-pedcli    = tt-digita.nr-pedcli:SCREEN-VALUE IN BROWSE brDigita
           AND   ped-item.it-codigo    = tt-digita.it-codigo:SCREEN-VALUE IN BROWSE brDigita
           AND   ped-item.nr-sequencia = int(tt-digita.nr-sequencia:SCREEN-VALUE IN BROWSE brDigita)
           NO-LOCK NO-ERROR.
       IF NOT AVAIL ped-item THEN DO:
           RUN utp/ut-msgs.p (INPUT "show":u,
                              INPUT "17006",
                              INPUT "Item nao encontrado !~~" +
                              "Item nao encontrado para este pedido de venda, verifique!" ).
           APPLY "entry" TO tt-digita.it-codigo IN BROWSE brDigita.
           RETURN NO-APPLY.
       END.
       ELSE
           ASSIGN tt-digita.dt-entrega-futura:SCREEN-VALUE IN BROWSE brDigita = string(ped-item.dt-entrega,"99/99/9999").
    END.
    ELSE DO:
        FIND FIRST ped-item
            WHERE ped-item.nr-pedcli    = tt-digita.nr-pedcli:SCREEN-VALUE IN BROWSE brDigita
            AND   ped-item.it-codigo    = tt-digita.it-codigo:SCREEN-VALUE IN BROWSE brDigita
            AND   ped-item.nr-sequencia = int(tt-digita.nr-sequencia:SCREEN-VALUE IN BROWSE brDigita)
            NO-LOCK NO-ERROR.
        IF AVAIL ped-item THEN
            ASSIGN tt-digita.dt-entrega-futura:SCREEN-VALUE IN BROWSE brDigita = string(ped-item.dt-entrega,"99/99/9999").
    END.

    FIND CURRENT tt-digita NO-ERROR.

    IF AVAIL tt-digita THEN
       ASSIGN tt-digita.nr-sequencia = INT(tt-digita.nr-sequencia:SCREEN-VALUE IN BROWSE brDigita). 

END.
/*wilson gesplus*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializaá∆o
  correta dos componentes do RTF quando executado em ambiente local e no WebEnabler.*/
  
ASSIGN fi-dt-emissao-ini:SCREEN-VALUE IN FRAME fpage2 = string(TODAY - 60)
       fi-dt-emissao-fim:SCREEN-VALUE IN FRAME fpage2 = string(TODAY)
       fi-dt-entrega-ini:SCREEN-VALUE IN FRAME fpage2 = string(TODAY - 60)
       fi-dt-entrega-fim:SCREEN-VALUE IN FRAME fpage2 = string(TODAY)
       fi-prioridade-ini:SCREEN-VALUE IN FRAME fpage2 = "01"
       fi-prioridade-fim:SCREEN-VALUE IN FRAME fpage2 = "01"
       fi-prioridade-ini:SCREEN-VALUE IN FRAME fpage2 = "00"
       fi-prioridade-fim:SCREEN-VALUE IN FRAME fpage2 = "99"
       fi-atendente-ini:SCREEN-VALUE IN FRAME fpage2 = "00"
       fi-atendente-fim:SCREEN-VALUE IN FRAME fpage2 = "99"
       fi-nr-pedcli-fim:SCREEN-VALUE IN FRAME fpage2 = "ZZZZZZZZZZ"
       fi-so-listar:SCREEN-VALUE IN FRAME fpage2 = "no".
  
&IF "{&RTF}":U = "YES":U &THEN
IF VALID-HANDLE(hWenController) THEN DO:
    ASSIGN l-habilitaRtf:sensitive IN FRAME fPage6 = NO
           l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
           l-habilitaRtf = NO.
           
END.
RUN pi-habilitaRtf.
&endif
/*Fim alteracao 17/02/2005*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var r-tt-digita as rowid no-undo.

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "espdp079":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    /*15/02/2005 - tech1007 - Teste alterado pois RTF n∆o Ç mais opá∆o de Destino*/
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.
    
    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */
    ASSIGN i-cont = 0.
    FOR EACH tt-digita NO-LOCK:
        ASSIGN r-tt-digita = ROWID(tt-digita).
        ASSIGN i-cont = i-cont + 1.
        /*:T Validaá∆o de duplicidade de registro na temp-table tt-digita */
/*         FIND FIRST b-tt-digita                                                                            */
/*              WHERE b-tt-digita.tipo-trans = tt-digita.tipo-trans                                          */
/*                AND b-tt-digita.it-codigo  = tt-digita.it-codigo                                           */
/*                AND b-tt-digita.nr-pedcli  = tt-digita.nr-pedcli                                           */
/*                and ROWID(b-tt-digita)     <> ROWID(tt-digita)                                             */
/*             NO-LOCK NO-ERROR.                                                                             */
/*         IF  AVAIL b-tt-digita THEN DO:                                                                    */
/*             REPOSITION brDigita TO ROWID ROWID(b-tt-digita).                                              */
/*             RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Registro inserido em duplicidade ":U). */
/*             APPLY "ENTRY":U TO tt-digita.it-codigo IN BROWSE brDigita.                                    */
/*             RETURN ERROR.                                                                                 */
/*         END.                                                                                              */
/*         ELSE DO:                                                                                          */
            IF  tt-digita.tipo-trans <> "C" AND tt-digita.dt-entrega-futura < TODAY THEN DO:
                REPOSITION brDigita TO ROWID ROWID(tt-digita).
                RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                   INPUT 17006, 
                                   INPUT "Data entrega: " + STRING(tt-digita.dt-entrega-futura) + " Ç menor q a data de hoje.").
                APPLY "ENTRY":U TO tt-digita.dt-entrega-futura IN BROWSE brDigita.
                RETURN ERROR.
            END.
            /*wilson gesplus*/
            IF tt-digita.tipo-trans <> "I" and
               tt-digita.tipo-trans <> "A" and
               tt-digita.tipo-trans <> "C" THEN DO:
                REPOSITION brDigita TO ROWID ROWID(tt-digita).
                RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                   INPUT 17006, 
                                   INPUT "Tipo Transacao: " + caps(tt-digita.tipo-trans) + " deve ser I, A ou C. Verifique!").
                APPLY "ENTRY":U TO tt-digita.tipo-trans IN BROWSE brDigita.
                RETURN ERROR.
            END.
            IF tt-digita.tipo-trans = "I" and
               tt-digita.qt-pedida  <= 0 THEN DO:
                REPOSITION brDigita TO ROWID ROWID(tt-digita).
                RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                   INPUT 17006, 
                                   INPUT "Quantidade do item " + tt-digita.it-codigo + " deve ser maior que zero. Verifique!").
                APPLY "ENTRY":U TO tt-digita.tipo-trans IN BROWSE brDigita.
                RETURN ERROR.
            END.
            IF tt-digita.tipo-trans = "A" OR
               tt-digita.tipo-trans = "C" THEN DO:
                FIND FIRST ped-item
                     WHERE ped-item.nr-pedcli    = tt-digita.nr-pedcli
                       AND ped-item.it-codigo    = tt-digita.it-codigo
                       AND ped-item.nr-sequencia = tt-digita.nr-sequencia
                    NO-LOCK NO-ERROR.
                IF NOT AVAIL ped-item THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show":u,
                                       INPUT "17006",
                                       INPUT "Item nao encontrado para o pedido de venda verifique!~~" +
                                             "Pedido: " + tt-digita.nr-pedcli + CHR(13) +
                                             "Item  : " + tt-digita.it-codigo + CHR(13) +
                                             "Seq   : " + string(tt-digita.nr-sequencia) + CHR(13) +
                                             "Linha : " + STRING(i-cont)).
                    APPLY "entry" TO tt-digita.it-codigo IN BROWSE brDigita.
                    RETURN ERROR.
                END.
            END.
            /*wilson gesplus*/
/*         END. */

           IF tt-digita.tipo-trans = "I" THEN DO: //inclusao

              FIND FIRST ped-venda
                   WHERE ped-venda.nr-pedcli = tt-digita.nr-pedcli NO-LOCK NO-ERROR.

              FIND FIRST emitente NO-LOCK
                   WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
              IF AVAIL emitente  THEN DO:
                 FIND FIRST int-emitente NO-LOCK
                      WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
                 IF AVAIL int-emitente AND int-emitente.log-salesforce THEN DO:

                     FIND FIRST tt-prog-ponto
                          WHERE tt-prog-ponto.conteudo = string(emitente.cod-gr-cli) NO-ERROR.
                     IF AVAIL tt-prog-ponto THEN DO:
                         
                         IF tt-digita.nr-tabpre = "" THEN DO:
                             
                             REPOSITION brDigita TO ROWID ROWID(tt-digita).
                             RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                                INPUT 17006, 
                                                INPUT "Cliente SalesForce necessario informar tabela de preco").
                             APPLY "ENTRY":U TO tt-digita.nr-tabpre IN BROWSE brDigita.
                             RETURN ERROR.
                         END.
                         ELSE DO:
                             FIND FIRST tb-preco NO-LOCK
                                  WHERE tb-preco.nr-tabpre = tt-digita.nr-tabpre NO-ERROR.
                             IF NOT AVAIL tb-preco THEN DO:
                                 REPOSITION brDigita TO ROWID ROWID(tt-digita).
                                 RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                                    INPUT 17006, 
                                                    INPUT "Tabela de preco informada inexistente").
                                 APPLY "ENTRY":U TO tt-digita.nr-tabpre IN BROWSE brDigita.
                                 RETURN ERROR.
                             END.
                         END.
                     END.
                 END.
              END.
           END.
    END.
    
    
    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time .
    ASSIGN tt-param.cod-estabel     = input frame fPage2 fi-cod-estabel
           tt-param.dt-emissao-ini  = date(input frame fPage2 fi-dt-emissao-ini)
           tt-param.dt-emissao-fim  = date(input frame fPage2 fi-dt-emissao-fim)
           tt-param.dt-entrega-ini  = date(input frame fPage2 fi-dt-entrega-ini)
           tt-param.dt-entrega-fim  = date(input frame fPage2 fi-dt-entrega-fim).

    ASSIGN tt-param.nr-pedcli-ini   = input frame fPage2 fi-nr-pedcli-ini
           tt-param.nr-pedcli-fim   = input frame fPage2 fi-nr-pedcli-fim.
    ASSIGN tt-param.atendente-ini   = input frame fPage2 fi-atendente-ini
           tt-param.atendente-fim   = input frame fPage2 fi-atendente-fim      .

    ASSIGN tt-param.prioridade-ini  = int(input frame fPage2 fi-prioridade-ini)
           tt-param.prioridade-fim  = int(input frame fPage2 fi-prioridade-fim)
           tt-param.it-codigo-ini   = input frame fPage2 fi-it-codigo-ini
           tt-param.it-codigo-fim   = input frame fPage2 fi-it-codigo-fim
           tt-param.pedidos         = input frame fPage2 fi-pedidos.

    ASSIGN tt-param.l-suspensos     = input frame fPage2 fi-suspensos
           tt-param.l-parcial       = input frame fPage2 fi-parcial
           tt-param.l-so-listar     = input frame fPage2 fi-so-listar
           tt-param.considera       = input frame fPage2 tg-considera
           tt-param.dt-entrega-futura = INPUT FRAME fPage2 fi-dt-entrega-futura
           tt-param.i-altera-data   = INPUT FRAME fPage2 rs-altera-data.

    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/pdp/espdp056rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

