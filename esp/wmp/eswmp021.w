&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/***********************************************************************
**  Programa..: esp/wmp/eswmp021.w
**  Autor.....: Nicolas Martinez
**  Data......: Agosto/2020 - Desenvolvimento
**  Descricao.: Relatorio historicos de bloqueio
**  Versao....: 001 12/08/2020
**                  Desenvolvimento Programa
************************************************************************/
{include/i-prgvrs.i ESWMP021 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ESWMP021 MWM}
&ENDIF 

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESWMP021
&GLOBAL-DEFINE Version        2.00.00.001
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,Classificaá∆o,ParÉmetro,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          YES
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   rsClassif
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    c-cod-bloco-ini  ~
                              c-cod-bloco-fim  ~
                              c-cod-rua-ini    ~
                              c-cod-rua-fim    ~
                              c-cod-nivel-ini  ~
                              c-cod-nivel-fim  ~
                              c-cod-coluna-ini ~
                              c-cod-coluna-fim ~
                              c-cod-item-ini   ~
                              c-cod-item-fim
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    c-cod-local c-nom-local c-cod-estabel c-nom-estabel rsBloqueio tg-end-com-saldo rs-tipo-rel ~
                              tg-preventivo tg-estoque tg-lote tg-lancamento tg-inspecao tg-previsto
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD usuario              AS CHAR FORMAT "X(12)"
    FIELD destino              AS INTEGER
    FIELD data-exec            AS DATE
    FIELD hora-exec            AS INTEGER
    FIELD arquivo              AS CHAR FORMAT "X(35)"
    FIELD cod-bloco-ini        LIKE wm-box.cod-bloco
    FIELD cod-bloco-fim        LIKE wm-box.cod-bloco
    FIELD cod-rua-ini          LIKE wm-box.cod-rua
    FIELD cod-rua-fim          LIKE wm-box.cod-rua
    FIELD cod-nivel-ini        LIKE wm-box.cod-nivel
    FIELD cod-nivel-fim        LIKE wm-box.cod-nivel
    FIELD cod-coluna-ini       LIKE wm-box.cod-coluna
    FIELD cod-coluna-fim       LIKE wm-box.cod-coluna  
    FIELD cod-item-ini         LIKE wm-item.cod-item
    FIELD cod-item-fim         LIKE wm-item.cod-item
    FIELD classifica           AS INTEGER
    FIELD desc-classifica      AS CHARACTER FORMAT "X(40)"
    FIELD cod-estabel          LIKE wm-saldo-estoque.cod-estabel
    FIELD nom-estabel          LIKE wm-estabel.nom-estabel
    FIELD cod-local            LIKE wm-saldo-estoque.cod-local
    FIELD nom-local            LIKE wm-local.nom-local
    FIELD bloqueio             AS INTEGER
    FIELD end-com-saldo        AS LOGICAL
    field tipo-rel             AS INTE
    field l-preventivo         AS LOG
    field l-estoque            AS LOG
    field l-lote               AS LOG
    field l-lancamento         AS LOG
    field l-inspecao           AS LOG
    field l-previsto           AS LOG.

/* Transfer Definitions */
DEF VAR raw-param        AS RAW NO-UNDO.

DEF TEMP-TABLE tt-raw-digita
   FIELD raw-digita      AS RAW.

DEF VAR l-ok             AS LOGICAL NO-UNDO.
DEF VAR c-arq-digita     AS CHAR    NO-UNDO.
DEF VAR c-terminal       AS CHAR    NO-UNDO.
DEF VAR c-arq-layout     AS CHAR    NO-UNDO.      
DEF VAR c-arq-temp       AS CHAR    NO-UNDO.

DEF STREAM s-imp.

DEF VAR hDBOWm-estabel        AS HANDLE NO-UNDO.
DEF VAR hDBOWm-local          AS HANDLE NO-UNDO.
DEF VAR hDBOWm-item           AS HANDLE NO-UNDO.
DEF VAR hDBOWm-bloco          AS HANDLE NO-UNDO.
DEF VAR hDBOWm-rua            AS HANDLE NO-UNDO.
DEF VAR hDBOWm-nivel          AS HANDLE NO-UNDO.
DEF VAR hDBOWm-referencia     AS HANDLE NO-UNDO.
DEF VAR hDBOWm-coluna         AS HANDLE NO-UNDO.

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
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-cod-bloco-fim AS CHARACTER FORMAT "X(3)" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-bloco-ini AS CHARACTER FORMAT "X(3)" 
     LABEL "Bloco" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-coluna-fim AS CHARACTER FORMAT "X(3)" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-coluna-ini AS CHARACTER FORMAT "X(3)" 
     LABEL "Coluna" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-item-fim AS CHARACTER FORMAT "X(16)" 
     VIEW-AS FILL-IN 
     SIZE 22.43 BY .88.

DEFINE VARIABLE c-cod-item-ini AS CHARACTER FORMAT "X(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 22.43 BY .88.

DEFINE VARIABLE c-cod-nivel-fim AS CHARACTER FORMAT "X(3)" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-nivel-ini AS CHARACTER FORMAT "X(3)" 
     LABEL "N°vel" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-rua-fim AS CHARACTER FORMAT "x(3)" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-rua-ini AS CHARACTER FORMAT "x(3)" 
     LABEL "Rua" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-fir":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-fir":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-fir":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image\im-fir":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-fir":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rsClassif AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Por Item", 1
     SIZE 17.86 BY 1.92
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-cod-estabel LIKE wm-estabel.cod-estabel
     LABEL "Estabelecimento":R18 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-local AS CHARACTER FORMAT "X(3)" 
     LABEL "Local" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-nom-estabel AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88.

DEFINE VARIABLE c-nom-local AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 49.72 BY .88.

DEFINE VARIABLE rs-tipo-rel AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "End Bloqueados", 1,
"Hist¢rico", 2
     SIZE 13.86 BY 1.96 NO-UNDO.

DEFINE VARIABLE rsBloqueio AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Retirada", 1
     SIZE 15.72 BY 1.96 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21.86 BY 2.92.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30.86 BY 2.92.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16 BY 2.92.

DEFINE VARIABLE tg-end-com-saldo AS LOGICAL INITIAL yes 
     LABEL "Apenas Endereáos com Saldos" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-estoque AS LOGICAL INITIAL yes 
     LABEL "Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .83 NO-UNDO.

DEFINE VARIABLE tg-inspecao AS LOGICAL INITIAL yes 
     LABEL "Inspeá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .83 NO-UNDO.

DEFINE VARIABLE tg-lancamento AS LOGICAL INITIAL yes 
     LABEL "Aguardando lanáamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.43 BY .83 NO-UNDO.

DEFINE VARIABLE tg-lote AS LOGICAL INITIAL yes 
     LABEL "Lote recusado" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.43 BY .83 NO-UNDO.

DEFINE VARIABLE tg-preventivo AS LOGICAL INITIAL yes 
     LABEL "Preventivo" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-previsto AS LOGICAL INITIAL yes 
     LABEL "Previsto" 
     VIEW-AS TOGGLE-BOX
     SIZE 8 BY .83 NO-UNDO.

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

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
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
     SIZE 27.72 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 10.71 COL 2
     btCancel AT ROW 10.71 COL 13
     btHelp2 AT ROW 10.71 COL 80
     rtToolBar AT ROW 10.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 11.13
         FONT 1.

DEFINE FRAME fPage4
     c-cod-estabel AT ROW 1.5 COL 13.86 COLON-ALIGNED HELP
          "C¢digo do estabelecimento."
          LABEL "Estabelecimento":R18
     c-nom-estabel AT ROW 1.5 COL 22.29 COLON-ALIGNED HELP
          "Nome do estabelecimento." NO-LABEL
     c-cod-local AT ROW 2.5 COL 13.86 COLON-ALIGNED
     c-nom-local AT ROW 2.5 COL 20.29 COLON-ALIGNED HELP
          "Nome do local." NO-LABEL
     tg-preventivo AT ROW 4.17 COL 42 WIDGET-ID 14
     tg-estoque AT ROW 4.17 COL 62 WIDGET-ID 16
     rs-tipo-rel AT ROW 4.29 COL 2.57 NO-LABEL WIDGET-ID 34
     rsBloqueio AT ROW 4.29 COL 22 NO-LABEL WIDGET-ID 2
     tg-lote AT ROW 5 COL 42 WIDGET-ID 18
     tg-inspecao AT ROW 5 COL 62 WIDGET-ID 22
     tg-lancamento AT ROW 5.83 COL 41.86 WIDGET-ID 20
     tg-previsto AT ROW 5.83 COL 62 WIDGET-ID 24
     tg-end-com-saldo AT ROW 6.71 COL 18.72 WIDGET-ID 10
     "Tipo de relat¢rio:" VIEW-AS TEXT
          SIZE 12 BY .71 AT ROW 3.5 COL 3 WIDGET-ID 40
     "Tipo de Bloqueio:" VIEW-AS TEXT
          SIZE 12.57 BY .71 AT ROW 3.5 COL 43 WIDGET-ID 26
     "End Bloqueados para:" VIEW-AS TEXT
          SIZE 16.14 BY .54 AT ROW 3.5 COL 19.29 WIDGET-ID 8
     RECT-10 AT ROW 3.79 COL 18.57 WIDGET-ID 6
     RECT-35 AT ROW 3.79 COL 41.14 WIDGET-ID 28
     RECT-36 AT ROW 3.79 COL 2 WIDGET-ID 42
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 6.63
         FONT 1.

DEFINE FRAME fPage3
     rsClassif AT ROW 1.29 COL 2.14 HELP
          "Classificaá∆o para emiss∆o do relat¢rio" NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 6.67
         FONT 1.

DEFINE FRAME fPage2
     c-cod-bloco-ini AT ROW 1.5 COL 14 COLON-ALIGNED HELP
          "C¢digo do bloco no WMS."
     c-cod-bloco-fim AT ROW 1.5 COL 47.57 COLON-ALIGNED HELP
          "C¢digo do bloco no WMS." NO-LABEL
     c-cod-rua-ini AT ROW 2.5 COL 14 COLON-ALIGNED HELP
          "C¢digo da rua no WMS."
     c-cod-rua-fim AT ROW 2.5 COL 47.57 COLON-ALIGNED HELP
          "C¢digo da rua no WMS." NO-LABEL
     c-cod-nivel-ini AT ROW 3.5 COL 14 COLON-ALIGNED HELP
          "C¢digo do n°vel do WMS"
     c-cod-nivel-fim AT ROW 3.5 COL 47.57 COLON-ALIGNED HELP
          "C¢digo do n°vel do WMS" NO-LABEL
     c-cod-coluna-ini AT ROW 4.5 COL 14 COLON-ALIGNED HELP
          "C¢digo da coluna no WMS"
     c-cod-coluna-fim AT ROW 4.5 COL 47.57 COLON-ALIGNED HELP
          "C¢digo da coluna no WMS" NO-LABEL
     c-cod-item-ini AT ROW 5.5 COL 14 COLON-ALIGNED HELP
          "C¢digo do Item."
     c-cod-item-fim AT ROW 5.5 COL 47.57 COLON-ALIGNED HELP
          "C¢digo do Item." NO-LABEL
     IMAGE-16 AT ROW 1.5 COL 39.43
     IMAGE-4 AT ROW 1.5 COL 45.57
     IMAGE-10 AT ROW 2.5 COL 39.43
     IMAGE-15 AT ROW 2.5 COL 45.57
     IMAGE-17 AT ROW 3.5 COL 39.43
     IMAGE-18 AT ROW 3.5 COL 45.57
     IMAGE-19 AT ROW 4.5 COL 39.43
     IMAGE-20 AT ROW 4.5 COL 45.57
     IMAGE-21 AT ROW 5.5 COL 39.43
     IMAGE-22 AT ROW 5.5 COL 45.57
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 6.63
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 6.58
         FONT 1.


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
         TITLE              = ""
         HEIGHT             = 11.21
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
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
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME fPage4
   LIKE = mgscm.wm-estabel.cod-estabel EXP-LABEL EXP-SIZE               */
/* SETTINGS FOR FILL-IN c-nom-estabel IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nom-local IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

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
   DO  ON ERROR UNDO, RETURN NO-APPLY:
       RUN piExecute.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME c-cod-bloco-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-bloco-fim wReport
ON F5 OF c-cod-bloco-fim IN FRAME fPage2
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc029.w"
                         &FieldZoom1="cod-bloco"
                         &FieldScreen1="c-cod-bloco-fim"
                         &Frame1="fPage2"
                         &RunMethod="RUN openQueryStatic IN hDBOWm-bloco (INPUT 'Main')."
                         &EnableImplant="YES"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-bloco-fim wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-bloco-fim IN FRAME fPage2
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-bloco-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-bloco-ini wReport
ON F5 OF c-cod-bloco-ini IN FRAME fPage2 /* Bloco */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc029.w"
                         &FieldZoom1="cod-bloco"
                         &FieldScreen1="c-cod-bloco-ini"
                         &Frame1="fPage2"
                         &RunMethod="RUN openQueryStatic IN hDBOWm-bloco (INPUT 'Main')."
                         &EnableImplant="YES"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-bloco-ini wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-bloco-ini IN FRAME fPage2 /* Bloco */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-coluna-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-coluna-fim wReport
ON F5 OF c-cod-coluna-fim IN FRAME fPage2
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc036.w"
                         &FieldZoom1="cod-coluna"
                         &FieldScreen1="c-cod-coluna-fim"
                         &Frame1="fPage2"
                         &RunMethod="RUN openQueryStatic IN hDBOWm-coluna (INPUT 'Main')."
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-coluna-fim wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-coluna-fim IN FRAME fPage2
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-coluna-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-coluna-ini wReport
ON F5 OF c-cod-coluna-ini IN FRAME fPage2 /* Coluna */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc036.w"
                         &FieldZoom1="cod-coluna"
                         &FieldScreen1="c-cod-coluna-ini"
                         &Frame1="fPage2"
                         &RunMethod="RUN openQueryStatic IN hDBOWm-coluna (INPUT 'Main')."
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-coluna-ini wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-coluna-ini IN FRAME fPage2 /* Coluna */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON F5 OF c-cod-estabel IN FRAME fPage4 /* Estabelecimento */
DO:
  {method/zoomfields.i &ProgramZoom="sczoom/z01sc047.w"
                       &FieldZoom1="cod-estabel"
                       &FieldScreen1="c-cod-estabel"
                       &Frame1="fPage4"
                       &FieldZoom2="nom-estabel"
                       &FieldScreen2="c-nom-estabel"
                       &Frame2="fPage4"
                       &FieldZoom3="cod-local"
                       &FieldScreen3="c-cod-local"
                       &Frame3="fPage4"
                       &FieldZoom4="nom-local"
                       &FieldScreen4="c-nom-local"
                       &Frame4="fPage4"
                       &RunMethod="RUN openQueryStatic IN hDBOWm-local (INPUT 'Main')."
                       &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON LEAVE OF c-cod-estabel IN FRAME fPage4 /* Estabelecimento */
DO:
    RUN getNomEstabel IN hDBOwm-local (INPUT  c-cod-estabel:SCREEN-VALUE IN FRAME fPage4,
                                                OUTPUT c-nom-estabel).
    IF  RETURN-VALUE = "OK":U THEN
        DISPLAY c-nom-estabel WITH FRAME fPage4.
    ELSE
        ASSIGN c-nom-estabel:SCREEN-VALUE IN FRAME fPage4 = "":U.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME fPage4 /* Estabelecimento */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME c-cod-item-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-item-fim wReport
ON F5 OF c-cod-item-fim IN FRAME fPage2
DO:
  {method/zoomfields.i &ProgramZoom="sczoom/z01sc044.w"
                       &FieldZoom1="cod-item"
                       &FieldScreen1="c-cod-item-fim"
                       &Frame1="fPage2"
                       &RunMethod="RUN openQueryStatic IN hDBOWm-item (INPUT 'Main')."
                       &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-item-fim wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-item-fim IN FRAME fPage2
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-item-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-item-ini wReport
ON F5 OF c-cod-item-ini IN FRAME fPage2 /* Item */
DO:
  {method/zoomfields.i &ProgramZoom="sczoom/z01sc044.w"
                       &FieldZoom1="cod-item"
                       &FieldScreen1="c-cod-item-ini"
                       &Frame1="fPage2"
                       &RunMethod="RUN openQueryStatic IN hDBOWm-item (INPUT 'Main')."
                       &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-item-ini wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-item-ini IN FRAME fPage2 /* Item */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME c-cod-local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-local wReport
ON F5 OF c-cod-local IN FRAME fPage4 /* Local */
DO:
  {method/zoomfields.i &ProgramZoom="sczoom/z01sc047.w"
                       &FieldZoom1="cod-estabel"
                       &FieldScreen1="c-cod-estabel"
                       &Frame1="fPage4"
                       &FieldZoom2="nom-estabel"
                       &FieldScreen2="c-nom-estabel"
                       &Frame2="fPage4"
                       &FieldZoom3="cod-local"
                       &FieldScreen3="c-cod-local"
                       &Frame3="fPage4"
                       &FieldZoom4="nom-local"
                       &FieldScreen4="c-nom-local"
                       &Frame4="fPage4"
                       &RunMethod="RUN openQueryStatic IN hDBOWm-local (INPUT 'Main')."
                       &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-local wReport
ON LEAVE OF c-cod-local IN FRAME fPage4 /* Local */
DO:


    RUN getNomLocal IN hDBOwm-local (INPUT c-cod-estabel:SCREEN-VALUE IN FRAME fPage4,   
                                              INPUT c-cod-local:SCREEN-VALUE IN FRAME fPage4,
                                              OUTPUT c-nom-local).
    IF  RETURN-VALUE = "OK":U THEN
        DISPLAY c-nom-local WITH FRAME fPage4.
    ELSE
        ASSIGN c-nom-local:SCREEN-VALUE IN FRAME fpage4 = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-local wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-local IN FRAME fPage4 /* Local */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME c-cod-nivel-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-nivel-fim wReport
ON F5 OF c-cod-nivel-fim IN FRAME fPage2
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc049.w"
                         &FieldZoom1="cod-nivel"
                         &FieldScreen1="c-cod-nivel-fim"
                         &Frame1="fPage2"
                         &RunMethod="RUN openQueryStatic IN hDBOWm-nivel (INPUT 'Main')."
                         &EnableImplant="YES"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-nivel-fim wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-nivel-fim IN FRAME fPage2
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-nivel-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-nivel-ini wReport
ON F5 OF c-cod-nivel-ini IN FRAME fPage2 /* N°vel */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc049.w"
                         &FieldZoom1="cod-nivel"
                         &FieldScreen1="c-cod-nivel-ini"
                         &Frame1="fPage2"
                         &RunMethod="RUN openQueryStatic IN hDBOWm-nivel (INPUT 'Main')."
                         &EnableImplant="YES"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-nivel-ini wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-nivel-ini IN FRAME fPage2 /* N°vel */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-rua-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-rua-fim wReport
ON F5 OF c-cod-rua-fim IN FRAME fPage2
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc057.w"
                         &FieldZoom1="cod-rua"
                         &FieldScreen1="c-cod-rua-fim"
                         &Frame1="fPage2"
                         &RunMethod="RUN openQueryStatic IN hDBOWm-rua (INPUT 'Main')."
                         &EnableImplant="YES"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-rua-fim wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-rua-fim IN FRAME fPage2
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-rua-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-rua-ini wReport
ON F5 OF c-cod-rua-ini IN FRAME fPage2 /* Rua */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc057.w"
                         &FieldZoom1="cod-rua"
                         &FieldScreen1="c-cod-rua-ini"
                         &Frame1="fPage2"
                         &RunMethod="RUN openQueryStatic IN hDBOWm-rua (INPUT 'Main')."
                         &EnableImplant="YES"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-rua-ini wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-rua-ini IN FRAME fPage2 /* Rua */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME rs-tipo-rel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo-rel wReport
ON VALUE-CHANGED OF rs-tipo-rel IN FRAME fPage4
DO:
    /*
  IF INPUT FRAME fPage4 rs-tipo-rel = 2
  THEN RUN utp/ut-msgs.p (INPUT 'show',
                          INPUT 17006,
                          INPUT "Aviso!"
                                + "~~" +
                                "Opá∆o de hist¢rico n∆o filtra item, isso porque o hist¢rico de bloqueio Ç por Endereáo").
                                */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsBloqueio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsBloqueio wReport
ON VALUE-CHANGED OF rsBloqueio IN FRAME fPage4
DO:
    IF INPUT FRAME fPage4 rsBloqueio = 1
    THEN DO:
        ASSIGN tg-preventivo:SENSITIVE IN FRAME fpage4 = NO
               tg-estoque:SENSITIVE    IN FRAME fpage4 = NO
               tg-lote:SENSITIVE       IN FRAME fpage4 = NO
               tg-lancamento:SENSITIVE IN FRAME fpage4 = NO
               tg-inspecao:SENSITIVE   IN FRAME fpage4 = NO
               tg-previsto:SENSITIVE   IN FRAME fpage4 = NO.
    END.   
    ELSE DO:
        ASSIGN tg-preventivo:SENSITIVE IN FRAME fpage4 = YES
               tg-estoque:SENSITIVE    IN FRAME fpage4 = YES
               tg-lote:SENSITIVE       IN FRAME fpage4 = YES
               tg-lancamento:SENSITIVE IN FRAME fpage4 = YES
               tg-inspecao:SENSITIVE   IN FRAME fpage4 = YES
               tg-previsto:SENSITIVE   IN FRAME fpage4 = YES.
    END.  
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
        when "1" then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes.
        end.
        when "2" OR when "4" then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no.
        end.
        when "3" then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no.
        end.
    end case.
end.
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


/*--- L¢gica para inicializaá∆o do programam ---*/
{report/mainblock.i}

MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:


    ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
    DO:
        RUN pi-change-rs-destino.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wReport 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(hDBOWm-estabel) THEN 
        RUN destroy IN hDBOWm-estabel.
    
    IF VALID-HANDLE(hDBOWm-local) THEN
        RUN destroy IN hDBOWm-local.

    IF VALID-HANDLE(hDBOwm-local) THEN
        RUN destroy IN hDBOwm-local.
    
    IF VALID-HANDLE(hDBOWm-item) THEN
        RUN destroy IN hDBOWm-item.
    
    IF VALID-HANDLE(hDBOWm-bloco) THEN
        RUN destroy IN hDBOWm-bloco.
    
    IF VALID-HANDLE(hDBOWm-rua) THEN
        RUN destroy IN hDBOWm-rua.
    
    IF VALID-HANDLE(hDBOWm-nivel) THEN
        RUN destroy IN hDBOWm-nivel.

    IF VALID-HANDLE(hDBOWm-referencia) THEN
        RUN destroy IN hDBOWm-referencia.

    IF VALID-HANDLE(hDBOWm-coluna) THEN
        RUN destroy IN hDBOWm-coluna.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR pcod-estabel LIKE wm-local.cod-estabel NO-UNDO.
    DEF VAR pcod-local   LIKE wm-local.cod-local   NO-UNDO.


    RUN initializeDBOs.
    
    RUN getEstabelLocalPad IN hDBOWm-local (OUTPUT pcod-estabel, 
                                            OUTPUT pcod-local).
    
    ASSIGN c-cod-estabel:SCREEN-VALUE    IN FRAME fPage4 = pcod-estabel
           c-cod-local:SCREEN-VALUE      IN FRAME fPage4 = pcod-local
           c-nom-estabel:SENSITIVE       IN FRAME fPage4 = NO
           c-nom-local:SENSITIVE         IN FRAME fPage4 = NO
           c-cod-bloco-fim:SCREEN-VALUE  IN FRAME fPage2 = "ZZZ":U
           c-cod-rua-fim:SCREEN-VALUE    IN FRAME fPage2 = "ZZZ":U
           c-cod-nivel-fim:SCREEN-VALUE  IN FRAME fPage2 = "ZZZ":U
           c-cod-coluna-fim:SCREEN-VALUE IN FRAME fPage2 = "ZZZ":U
           c-cod-item-fim:SCREEN-VALUE   IN FRAME fPage2 = "ZZZZZZZZZZZZZZZZ":U.
    
/*    ASSIGN tg-preventivo:SENSITIVE IN FRAME fpage4 = NO
           tg-estoque:SENSITIVE    IN FRAME fpage4 = NO
           tg-lote:SENSITIVE       IN FRAME fpage4 = NO
           tg-lancamento:SENSITIVE IN FRAME fpage4 = NO
           tg-inspecao:SENSITIVE   IN FRAME fpage4 = NO
           tg-previsto:SENSITIVE   IN FRAME fpage4 = NO. */

    ASSIGN tg-end-com-saldo:SENSITIVE IN FRAME fpage4 = NO.
                
    c-cod-bloco-ini:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage2.
    c-cod-bloco-fim:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage2.
    c-cod-rua-ini:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fPage2.
    c-cod-rua-fim:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fPage2.
    c-cod-nivel-ini:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage2.
    c-cod-nivel-fim:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage2.
    c-cod-coluna-ini:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
    c-cod-coluna-fim:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
    c-cod-item-ini:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage2.
    c-cod-item-fim:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage2.
    c-cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fPage4.
    c-cod-local:LOAD-MOUSE-POINTER("image/lupa.cur":U)      IN FRAME fPage4.

    APPLY "LEAVE" TO c-cod-estabel IN FRAME fPage4.
    APPLY "LEAVE" TO c-cod-local   IN FRAME fPage4.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wReport 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT VALID-HANDLE(hDBOWm-estabel) THEN DO:
        {btb/btb008za.i1 scbo/bosc041.p YES}
        {btb/btb008za.i2 scbo/bosc041.p '' hDBOWm-estabel}
    END.
    
    IF NOT VALID-HANDLE(hDBOWm-local) THEN DO:
        {btb/btb008za.i1 scbo/bosc047.p YES}
        {btb/btb008za.i2 scbo/bosc047.p '' hDBOWm-local}
    END.
    
    IF NOT VALID-HANDLE(hDBOWm-item) THEN DO:
        {btb/btb008za.i1 scbo/bosc044.p YES}
        {btb/btb008za.i2 scbo/bosc044.p '' hDBOWm-item}
    END.
    
    IF NOT VALID-HANDLE(hDBOWm-bloco) THEN DO:
        {btb/btb008za.i1 scbo/bosc029.p YES}
        {btb/btb008za.i2 scbo/bosc029.p '' hDBOWm-bloco}
    END.
    
    IF NOT VALID-HANDLE(hDBOWm-rua) THEN DO:
        {btb/btb008za.i1 scbo/bosc057.p YES}
        {btb/btb008za.i2 scbo/bosc057.p '' hDBOWm-rua}
    END.
    
    IF NOT VALID-HANDLE(hDBOWm-nivel) THEN DO:
        {btb/btb008za.i1 scbo/bosc049.p YES}
        {btb/btb008za.i2 scbo/bosc049.p '' hDBOWm-nivel}
    END.
            
    IF NOT VALID-HANDLE(hDBOWm-coluna) THEN DO:
        {btb/btb008za.i1 scbo/bosc030.p YES}
        {btb/btb008za.i2 scbo/bosc030.p '' hDBOWm-coluna}
    END.

    IF NOT VALID-HANDLE(hDBOWm-referencia) THEN DO:
        {btb/btb008za.i1 scbo/bosc052.p YES}
        {btb/btb008za.i2 scbo/bosc052.p '' hDBOWm-referencia}
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-change-rs-destino wReport 
PROCEDURE pi-change-rs-destino :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
CASE rsDestiny:SCREEN-VALUE IN FRAME  fPage6:

when "1":U then do:
        assign cFile:sensitive       = no
               cFile:visible         = yes
               btFile:visible        = no
               btConfigImpr:visible  = yes.
               /*Fim alteracao 15/02/2005*/
end.
when "2":U then do:
    assign cFile = substr( cFile, 1, index(cFile, ".") )+ "LST"
           cFile:SCREEN-VALUE IN FRAME fPage6 = cFile
           cFile:sensitive       = yes
           cFile:visible         = yes
           btFile:visible        = yes
           btConfigImpr:visible  = no.
end.
when "3":U then do:
    assign cFile:visible         = no
           cFile:sensitive       = no
           btFile:visible        = no
           btConfigImpr:visible  = no.
    /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
    /*Fim alteracao 15/02/2005*/
END.
end case.

RETURN "OK":U.
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

&IF DEFINED(PGIMP) <> 0 &THEN
/*** Relatorio ***/
DO ON ERROR UNDO, RETURN ERROR ON STOP  UNDO, RETURN ERROR:
    {report/rpexa.i}
    
    IF INPUT FRAME fPage6 rsDestiny = 2 AND 
       INPUT FRAME fPage6 rsExecution = 1 THEN DO:
        RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFile).
        
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 73, INPUT "":U).
            APPLY "ENTRY":U TO cFile IN FRAME fPage6.
            RETURN ERROR.
        END.
    END.
    
    /* Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
       o focus no campo com problemas */
    
    
    /* Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */
    
    IF (c-cod-bloco-ini:SCREEN-VALUE IN FRAME fPage2) >  
       (c-cod-bloco-fim:SCREEN-VALUE IN FRAME fPage2) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-codigo-bloco AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "C¢digo_Bloco" *}
        ASSIGN c-lbl-liter-codigo-bloco = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 515, INPUT c-lbl-liter-codigo-bloco + "~~" + c-lbl-liter-codigo-bloco ). 
        RUN setFolder IN hFolder (INPUT 1).
        APPLY "ENTRY" TO c-cod-bloco-ini IN FRAME fPage2.
        RETURN "NOK":U.
                
    END.
    IF (c-cod-rua-ini:SCREEN-VALUE IN FRAME fPage2) >  
       (c-cod-rua-fim:SCREEN-VALUE IN FRAME fPage2) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-codigo-rua AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "C¢digo_Rua" *}
        ASSIGN c-lbl-liter-codigo-rua = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 515, INPUT c-lbl-liter-codigo-rua + "~~" + c-lbl-liter-codigo-rua ). 
        RUN setFolder IN hFolder (INPUT 1).
        APPLY "ENTRY" TO c-cod-rua-ini IN FRAME fPage2.
        RETURN "NOK":U.
                
    END.
    IF (c-cod-nivel-ini:SCREEN-VALUE IN FRAME fPage2) >  
       (c-cod-nivel-fim:SCREEN-VALUE IN FRAME fPage2) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-codigo-nivel AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "C¢digo_N°vel" *}
        ASSIGN c-lbl-liter-codigo-nivel = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 515, INPUT c-lbl-liter-codigo-nivel + "~~" + c-lbl-liter-codigo-nivel ). 
        RUN setFolder IN hFolder (INPUT 1).
        APPLY "ENTRY" TO c-cod-nivel-ini IN FRAME fPage2.
        RETURN "NOK":U.
                
    END.
    IF (c-cod-item-ini:SCREEN-VALUE IN FRAME fPage2) >  
       (c-cod-item-fim:SCREEN-VALUE IN FRAME fPage2) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-codigo-item AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "C¢digo_Item" *}
        ASSIGN c-lbl-liter-codigo-item = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 515, INPUT c-lbl-liter-codigo-item + "~~" + c-lbl-liter-codigo-item ). 
        RUN setFolder IN hFolder (INPUT 1).
        APPLY "ENTRY" TO c-cod-item-ini IN FRAME fPage2.
        RETURN "NOK":U.
                
    END.
    IF (c-cod-coluna-ini:SCREEN-VALUE IN FRAME fPage2) >  
       (c-cod-coluna-fim:SCREEN-VALUE IN FRAME fPage2) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-codigo-coluna AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "C¢digo_Coluna" *}
        ASSIGN c-lbl-liter-codigo-coluna = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 515, INPUT c-lbl-liter-codigo-coluna + "~~" + c-lbl-liter-codigo-coluna ). 
        RUN setFolder IN hFolder (INPUT 1).
        APPLY "ENTRY" TO c-cod-coluna-ini IN FRAME fPage2.
        RETURN "NOK":U.
                
    END.

                                                                      
    RUN getNomEstabel IN hDBOwm-local (INPUT  c-cod-estabel:SCREEN-VALUE IN FRAME fPage4,
                                       OUTPUT c-nom-estabel).

    IF  RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estabelecimento" *}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 47, INPUT RETURN-VALUE).
        RUN setFolder IN hFolder (INPUT 3).
        APPLY "ENTRY" TO c-cod-estabel IN FRAME fPage4.
        RETURN "NOK":U.
    END.    
                    
    IF TRIM(c-cod-local:SCREEN-VALUE IN FRAME fPage4) = "":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Local" *}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 366, INPUT RETURN-VALUE).
        RUN setFolder IN hFolder (INPUT 3).
        APPLY "ENTRY" TO c-cod-local IN FRAME fPage4.
        RETURN "NOK":U.
    END.
    
    RUN getNomLocal IN hDBOwm-local (INPUT c-cod-estabel:SCREEN-VALUE IN FRAME fPage4,   
                                     INPUT c-cod-local:SCREEN-VALUE   IN FRAME fPage4,
                                     OUTPUT c-nom-local).
    IF  RETURN-VALUE = "NOK":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 25765, INPUT "":U).
        RUN setFolder IN hFolder (INPUT 3).
        APPLY "ENTRY" TO c-cod-local IN FRAME fPage4.
        RETURN "NOK":U.
    END.  
    
    
    /* Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */

    CREATE tt-param.
    ASSIGN tt-param.usuario              = c-seg-usuario
           tt-param.destino              = INPUT FRAME fPage6 rsDestiny
           tt-param.data-exec            = TODAY
           tt-param.hora-exec            = TIME
           tt-param.cod-bloco-ini        = c-cod-bloco-ini:SCREEN-VALUE  IN FRAME fPage2
           tt-param.cod-bloco-fim        = c-cod-bloco-fim:SCREEN-VALUE  IN FRAME fPage2
           tt-param.cod-rua-ini          = c-cod-rua-ini:SCREEN-VALUE    IN FRAME fPage2
           tt-param.cod-rua-fim          = c-cod-rua-fim:SCREEN-VALUE    IN FRAME fPage2
           tt-param.cod-nivel-ini        = c-cod-nivel-ini:SCREEN-VALUE  IN FRAME fPage2
           tt-param.cod-nivel-fim        = c-cod-nivel-fim:SCREEN-VALUE  IN FRAME fPage2
           tt-param.cod-coluna-ini       = c-cod-coluna-ini:SCREEN-VALUE IN FRAME fPage2
           tt-param.cod-coluna-fim       = c-cod-coluna-fim:SCREEN-VALUE IN FRAME fPage2
           tt-param.cod-item-ini         = c-cod-item-ini:SCREEN-VALUE   IN FRAME fPage2
           tt-param.cod-item-fim         = c-cod-item-fim:SCREEN-VALUE   IN FRAME fPage2
           tt-param.cod-estabel          = c-cod-estabel:SCREEN-VALUE    IN FRAME fPage4
           tt-param.nom-estabel          = c-nom-estabel:SCREEN-VALUE    IN FRAME fPage4
           tt-param.cod-local            = c-cod-local:SCREEN-VALUE      IN FRAME fPage4
           tt-param.nom-local            = c-nom-local:SCREEN-VALUE      IN FRAME fPage4
           tt-param.classifica           = INPUT FRAME fPage3 rsClassif
           tt-param.desc-classifica      = ENTRY((tt-param.classifica - 1) * 2 + 1, 
                                           rsClassif:RADIO-BUTTONS IN FRAME fPage3)
           tt-param.bloqueio             = INPUT FRAME fPage4 rsBloqueio
           tt-param.end-com-saldo        = INPUT FRAME fPage4 tg-end-com-saldo
           tt-param.tipo-rel             = INPUT FRAME fPage4 rs-tipo-rel
           tt-param.l-preventivo         = INPUT FRAME fPage4 tg-preventivo
           tt-param.l-estoque            = INPUT FRAME fPage4 tg-estoque
           tt-param.l-lote               = INPUT FRAME fPage4 tg-lote
           tt-param.l-lancamento         = INPUT FRAME fPage4 tg-lancamento
           tt-param.l-inspecao           = INPUT FRAME fPage4 tg-inspecao
           tt-param.l-previsto           = INPUT FRAME fPage4 tg-previsto
           .

    IF tt-param.destino = 1 
    THEN ASSIGN tt-param.arquivo = "":U.
    ELSE IF  tt-param.destino = 2 OR tt-param.destino = 4
         THEN ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
         ELSE ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.
    
    /* Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */        
    
    /* Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/wmp/eswmp021rp.p} 
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
END.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


