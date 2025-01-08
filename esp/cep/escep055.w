&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCEP055 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP055
&GLOBAL-DEFINE Version        2.00.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Parƒmetro,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   tgSaldo tgConsumo tg-depos-saldo-disponivel tg-depos-disponivel-oem tg-entrega-consumo tg-saldo-excesso tg-validade-item ~
                              tg-log-ativo tg-log-obsol-ord-auto tg-log-obsol-todas-ord tg-log-total-obsol tg-log-dependente tg-log-independente tg-log-forecast tg-ordens-planejadas tg-param-fornec
&GLOBAL-DEFINE page5Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    cEstabIni cEstabFim ~
                              cCompIni cCompFim ~
                              cItemIni cItemFim ~
                              fi-periodo-ini fi-periodo-fim ~
                              fi-cd-plano v-cod-fornec-ini v-cod-fornec-fim
&GLOBAL-DEFINE page3Fields     
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                  AS INTEGER
    FIELD arquivo                  AS CHAR
    FIELD arquivo-csv              AS CHAR
    FIELD usuario                  AS CHAR FORMAT "x(12)"
    FIELD data-exec                AS DATE
    FIELD hora-exec                AS INTEGER    
    FIELD estab-ini                LIKE item-uni-estab.cod-estabel
    FIELD estab-fim                LIKE item-uni-estab.cod-estabel 
    FIELD comprador-ini            LIKE item-uni-estab.cod-comprado
    FIELD comprador-fim            LIKE item-uni-estab.cod-comprado
    FIELD item-ini                 LIKE item-uni-estab.it-codigo
    FIELD item-fim                 LIKE item-uni-estab.it-codigo
    FIELD emitente-ini             LIKE emitente.cod-emitente
    FIELD emitente-fim             LIKE emitente.cod-emitente
    FIELD periodo-ini              AS DATE
    FIELD periodo-fim              AS DATE
    FIELD cd-plano                 AS INTEGER
    FIELD l-consumo                AS LOGICAL
    FIELD l-saldo                  AS LOGICAL
    FIELD l-depos-saldo-diponivel  AS LOGICAL
    FIELD l-depos-disponivel-oem   AS LOGICAL
    FIELD l-param-item             AS LOGICAL
    FIELD l-entrega-cons           AS LOGICAL
    FIELD l-saldo-excesso          AS LOGICAL
    FIELD l-validade-item          AS LOGICAL
    FIELD log-ativo                AS LOGICAL 
    FIELD log-obsol-ord-auto       AS LOGICAL 
    FIELD log-obsol-todas-ord      AS LOGICAL 
    FIELD log-total-obsol          AS LOGICAL 
    FIELD log-dependente           AS LOGICAL 
    FIELD log-independente         AS LOGICAL
    FIELD log-forecast             AS LOGICAL
    FIELD log-planejadas           AS LOGICAL
    FIELD log-param-fornec         AS LOGICAL.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE BUFFER b-tt-digita FOR tt-digita.

/* Transfer Definitions */

DEF VAR raw-param        AS RAW NO-UNDO.

DEF TEMP-TABLE tt-raw-digita
    FIELD raw-digita     AS RAW.

DEF VAR l-ok               AS LOGICAL NO-UNDO.
DEF VAR c-arq-digita       AS CHAR    NO-UNDO.
DEF VAR c-terminal         AS CHAR    NO-UNDO.
DEF VAR c-rtf              AS CHAR    NO-UNDO.
DEF VAR c-arq-layout       AS CHAR    NO-UNDO.      
DEF VAR c-arq-temp         AS CHAR    NO-UNDO.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.

DEF STREAM s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

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
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cCompFim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cCompIni AS CHARACTER FORMAT "X(12)":U 
     LABEL "Comprador" 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cEstabFim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cEstabIni AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cItemFim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cItemIni AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-cd-plano AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Plano":R7 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Per¡odo Consumo" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-fornec-fim AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-fornec-ini AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 4.25.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 3.25.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 4.25.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 4.75.

DEFINE VARIABLE tg-depos-disponivel-oem AS LOGICAL INITIAL no 
     LABEL "Dep¢sito Dispon¡vel OEM" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tg-depos-saldo-disponivel AS LOGICAL INITIAL no 
     LABEL "Dep¢sito Saldo Dispon¡vel" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-entrega-consumo AS LOGICAL INITIAL no 
     LABEL "Entregas e Consumos" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-log-ativo AS LOGICAL INITIAL no 
     LABEL "Ativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-log-dependente AS LOGICAL INITIAL no 
     LABEL "Dependente" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-log-forecast AS LOGICAL INITIAL no 
     LABEL "Forecast" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .83 NO-UNDO.

DEFINE VARIABLE tg-log-independente AS LOGICAL INITIAL no 
     LABEL "Independente" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-log-obsol-ord-auto AS LOGICAL INITIAL no 
     LABEL "Obsoleto Ordens Autom ticas" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE tg-log-obsol-todas-ord AS LOGICAL INITIAL no 
     LABEL "Obsoleto Todas as Ordens" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-log-total-obsol AS LOGICAL INITIAL no 
     LABEL "Totalmente Obsoletos" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ordens-planejadas AS LOGICAL INITIAL no 
     LABEL "Ordens Planejadas" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-param-fornec AS LOGICAL INITIAL no 
     LABEL "An lise Parƒmentros Fornecedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE tg-saldo-excesso AS LOGICAL INITIAL no 
     LABEL "Saldos e Excessos" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-validade-item AS LOGICAL INITIAL no 
     LABEL "Validade Item" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE tgConsumo AS LOGICAL INITIAL no 
     LABEL "Itens com Consumo" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tgSaldo AS LOGICAL INITIAL no 
     LABEL "Itens com Saldo" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

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


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     tgSaldo AT ROW 1.83 COL 47 WIDGET-ID 70
     tg-log-ativo AT ROW 2.25 COL 8 WIDGET-ID 80
     tgConsumo AT ROW 2.58 COL 47 WIDGET-ID 72
     tg-log-obsol-ord-auto AT ROW 3 COL 8 WIDGET-ID 82
     tg-depos-saldo-disponivel AT ROW 3.33 COL 47 WIDGET-ID 110
     tg-log-obsol-todas-ord AT ROW 3.75 COL 8 WIDGET-ID 84
     tg-depos-disponivel-oem AT ROW 4.08 COL 47 WIDGET-ID 112
     tg-log-total-obsol AT ROW 4.5 COL 8 WIDGET-ID 86
     tg-entrega-consumo AT ROW 6.63 COL 8
     tg-log-dependente AT ROW 6.63 COL 47 WIDGET-ID 88
     tg-saldo-excesso AT ROW 7.38 COL 8
     tg-log-independente AT ROW 7.38 COL 47 WIDGET-ID 90
     tg-validade-item AT ROW 8.13 COL 8 WIDGET-ID 78
     tg-log-forecast AT ROW 8.88 COL 8 WIDGET-ID 104
     tg-ordens-planejadas AT ROW 9.67 COL 8 WIDGET-ID 106
     tg-param-fornec AT ROW 9.79 COL 47 WIDGET-ID 108
     " Listar" VIEW-AS TEXT
          SIZE 5.14 BY .54 AT ROW 5.75 COL 6.86
     " Demanda" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 5.88 COL 44 WIDGET-ID 100
     " Considera Apenas" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 1.25 COL 44 WIDGET-ID 98
     " Situa‡Æo" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.25 COL 6 WIDGET-ID 96
     RECT-28 AT ROW 1.5 COL 5 WIDGET-ID 46
     RECT-29 AT ROW 6 COL 43 WIDGET-ID 48
     RECT-30 AT ROW 1.5 COL 43 WIDGET-ID 66
     RECT-31 AT ROW 6 COL 5 WIDGET-ID 76
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 10.46
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     cEstabIni AT ROW 2 COL 5 WIDGET-ID 24
     cEstabFim AT ROW 2 COL 54 NO-LABEL WIDGET-ID 22
     v-cod-fornec-ini AT ROW 3 COL 15 COLON-ALIGNED WIDGET-ID 106
     v-cod-fornec-fim AT ROW 3 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 108
     cCompIni AT ROW 4 COL 8.86 WIDGET-ID 20
     cCompFim AT ROW 4 COL 54 NO-LABEL WIDGET-ID 18
     cItemIni AT ROW 5 COL 13.28 WIDGET-ID 28
     cItemFim AT ROW 5 COL 54 NO-LABEL WIDGET-ID 26
     fi-periodo-ini AT ROW 6 COL 15 COLON-ALIGNED WIDGET-ID 36
     fi-periodo-fim AT ROW 6 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     fi-cd-plano AT ROW 7 COL 15 COLON-ALIGNED WIDGET-ID 34
     IMAGE-1 AT ROW 2 COL 37 WIDGET-ID 30
     IMAGE-2 AT ROW 2 COL 51 WIDGET-ID 32
     IMAGE-3 AT ROW 4 COL 37 WIDGET-ID 6
     IMAGE-4 AT ROW 4 COL 51 WIDGET-ID 8
     IMAGE-5 AT ROW 5 COL 37 WIDGET-ID 14
     IMAGE-6 AT ROW 5 COL 51 WIDGET-ID 16
     IMAGE-13 AT ROW 6 COL 37 WIDGET-ID 40
     IMAGE-14 AT ROW 6 COL 51 WIDGET-ID 42
     IMAGE-17 AT ROW 3 COL 37 WIDGET-ID 110
     IMAGE-18 AT ROW 3 COL 51 WIDGET-ID 112
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configura‡Æo da impressora"
     rsExecution AT ROW 5.75 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.25 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
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
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = "Listagem Parƒmetros Itens"
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 32.5
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 32.5
         VIRTUAL-WIDTH      = 205.72
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
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN cCompFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cCompIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cEstabFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cEstabIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cItemFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cItemIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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
ON END-ERROR OF wReport /* Listagem Parƒmetros Itens */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport /* Listagem Parƒmetros Itens */
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define FRAME-NAME fPage6
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
        /*Alterado 15/02/2005 - tech1007 - Condi‡Æo removida pois RTF nÆo ‚ mais um destino
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tg-depos-disponivel-oem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-depos-disponivel-oem wReport
ON VALUE-CHANGED OF tg-depos-disponivel-oem IN FRAME fPage4 /* Dep¢sito Dispon¡vel OEM */
DO:
  ASSIGN tg-depos-saldo-disponivel:CHECKED = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-depos-saldo-disponivel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-depos-saldo-disponivel wReport
ON VALUE-CHANGED OF tg-depos-saldo-disponivel IN FRAME fPage4 /* Dep¢sito Saldo Dispon¡vel */
DO:
  ASSIGN tg-depos-disponivel-oem:CHECKED = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-log-forecast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-log-forecast wReport
ON VALUE-CHANGED OF tg-log-forecast IN FRAME fPage4 /* Forecast */
DO:
    IF  tg-log-forecast:CHECKED IN FRAME fpage4 = YES
    THEN DO:
        ASSIGN tgConsumo                 = YES
               tgSaldo                   = NO
               tg-depos-disponivel-oem   = NO
               tg-depos-saldo-disponivel = NO
               tg-entrega-consumo        = YES
               tg-saldo-excesso          = NO
               tg-validade-item          = NO
               tg-log-ativo              = YES     
               tg-log-obsol-ord-auto     = YES
               tg-log-obsol-todas-ord    = YES
               tg-log-total-obsol        = YES
               tg-log-dependente         = YES
               tg-log-independente       = NO.

        DISPLAY tgConsumo tgSaldo tg-depos-disponivel-oem tg-depos-saldo-disponivel tg-entrega-consumo tg-saldo-excesso tg-validade-item tg-log-ativo 
                tg-log-obsol-ord-auto tg-log-obsol-todas-ord tg-log-total-obsol tg-log-dependente tg-log-independente
                WITH FRAME fpage4.

        DISABLE tg-entrega-consumo tg-saldo-excesso tg-validade-item WITH FRAME fpage4.
    END.
    ELSE
        ENABLE tg-entrega-consumo tg-saldo-excesso tg-validade-item WITH FRAME fpage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

on 'leave' of fi-cd-plano  do:

    if INPUT FRAME fPage2 fi-cd-plano <> 0 then do:
        assign cEstabFim:screen-value in FRAME fPage2 = INPUT FRAME fPage2 cEstabIni
               cEstabFim:sensitive in FRAME fPage2    = no. 
    end.
    else
        assign cEstabFim:sensitive in FRAME fPage2    = yes.


end.

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
    ASSIGN fi-periodo-ini = TODAY
           fi-periodo-fim = TODAY.

    DISP fi-periodo-ini
         fi-periodo-fim
        WITH FRAME fPage2.
    
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

DEFINE VAR r-tt-digita AS ROWID NO-UNDO.

/*:T** Relatorio ***/
DO ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    {report/rpexa.i}

    /*15/02/2005 - tech1007 - Teste alterado pois RTF nÆo ‚ mais op‡Æo de Destino*/
    IF INPUT FRAME fPage6 rsDestiny   = 2 AND
       INPUT FRAME fPage6 rsExecution = 1 THEN DO:
        RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFile).

        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 73, INPUT "":U).
            APPLY "ENTRY":U TO cFile IN FRAME fPage6.
            RETURN ERROR.
        END.
    END.

    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */

    CREATE tt-param.
    ASSIGN tt-param.usuario                 = c-seg-usuario
           tt-param.destino                 = INPUT FRAME fPage6 rsDestiny
           tt-param.data-exec               = TODAY
           tt-param.hora-exec               = TIME
           tt-param.estab-ini               = INPUT FRAME fPage2 cEstabIni
           tt-param.estab-fim               = INPUT FRAME fPage2 cEstabFim
           tt-param.comprador-ini           = INPUT FRAME fPage2 cCompIni
           tt-param.comprador-fim           = INPUT FRAME fPage2 cCompFim
           tt-param.item-ini                = INPUT FRAME fPage2 cItemIni
           tt-param.item-fim                = INPUT FRAME fPage2 cItemFim
           tt-param.periodo-ini             = INPUT FRAME fPage2 fi-periodo-ini
           tt-param.periodo-fim             = INPUT FRAME fPage2 fi-periodo-fim
           tt-param.cd-plano                = INPUT FRAME fPage2 fi-cd-plano
           tt-param.emitente-ini            = INPUT FRAME fPage2 v-cod-fornec-ini
           tt-param.emitente-fim            = INPUT FRAME fPage2 v-cod-fornec-fim
           tt-param.l-consumo               = INPUT FRAME fPage4 tgConsumo
           tt-param.l-saldo                 = INPUT FRAME fPage4 tgSaldo
           tt-param.l-depos-saldo-diponivel = INPUT FRAME fPage4 tg-depos-saldo-disponivel
           tt-param.l-depos-disponivel-oem  = INPUT FRAME fPage4 tg-depos-disponivel-oem
           tt-param.l-param-item            = YES
           tt-param.l-entrega-cons          = INPUT FRAME fPage4 tg-entrega-consumo
           tt-param.l-saldo-excesso         = INPUT FRAME fPage4 tg-saldo-excesso
           tt-param.l-validade-item         = INPUT FRAME fPage4 tg-validade-item
           tt-param.log-ativo               = INPUT FRAME fPage4 tg-log-ativo          
           tt-param.log-obsol-ord-auto      = INPUT FRAME fPage4 tg-log-obsol-ord-auto 
           tt-param.log-obsol-todas-ord     = input frame fPage4 tg-log-obsol-todas-ord
           tt-param.log-total-obsol         = INPUT FRAME fPage4 tg-log-total-obsol    
           tt-param.log-dependente          = INPUT FRAME fPage4 tg-log-dependente     
           tt-param.log-independente        = INPUT FRAME fPage4 tg-log-independente   
           tt-param.log-forecast            = INPUT FRAME fPage4 tg-log-forecast
           tt-param.log-planejadas          = INPUT FRAME fPage4 tg-ordens-planejadas
           tt-param.log-param-fornec        = INPUT FRAME fPage4 tg-param-fornec.

    IF  tt-param.destino = 1 THEN
        ASSIGN tt-param.arquivo = "".
    ELSE
    IF  tt-param.destino = 2 THEN 
        ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
    ELSE DO:
        IF OPSYS = "UNIX" THEN
            ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-seg-usuario + "/":U + c-programa-mg97 + ".tmp".
        ELSE
            ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp".
    END.

    IF tt-param.destino <> 2 THEN DO:
        IF OPSYS = "unix":U THEN
            ASSIGN tt-param.arquivo-csv = SESSION:TEMP-DIRECTORY + c-seg-usuario + "/":U + c-programa-mg97 + ".csv":U.
        ELSE
            ASSIGN tt-param.arquivo-csv = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".csv":U.
    END.
    ELSE
        ASSIGN tt-param.arquivo-csv = REPLACE(tt-param.arquivo, ENTRY(NUM-ENTRIES(tt-param.arquivo, ".":U), tt-param.arquivo, ".":U), "csv":U).

    ASSIGN tt-param.arquivo     = REPLACE(tt-param.arquivo, "\":U, "/":U)
           tt-param.arquivo-csv = REPLACE(tt-param.arquivo-csv, "\":U, "/":U).

    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp\cep\escep055rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

