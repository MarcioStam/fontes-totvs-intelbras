&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
{include/i-prgvrs.i esesb005 2.00.00.001}  /*** 010002 ***/
/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* TMS {vfp/vfcfgtrp.i}*/

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esesb005
&GLOBAL-DEFINE Version        2.00.00.001
&GLOBAL-DEFINE VersionLayout  2.00           

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   ParÉmetros, Digitaá∆o, Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO


&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution

&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page0Widgets   btCancel btOk  
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page5Fields    brDigita rs-selecao fi-canal fi-nome bt-selecionado bt-todos
&GLOBAL-DEFINE page4Fields    fi-ultimo cb-trimestre cb-ano rs-tipo da-transacao
&GLOBAL-DEFINE page6Fields    cFile 

DEF VAR adm-broker-hdl AS HANDLE NO-UNDO.

def new global shared var h-facelift as handle no-undo.

IF NOT VALID-HANDLE(h-facelift) THEN
  RUN btb/btb901zo.p PERSISTENT SET h-facelift.

/* Parameters Definitions ---                                           */

define temp-table tt-param no-undo
    FIELD destino     AS INTEGER
    FIELD arquivo     AS CHAR format "x(35)"
    FIELD usuario     AS CHAR format "x(12)"
    FIELD data-exec   AS DATE
    FIELD hora-exec   AS INTEGER
    FIELD ano         AS INTEGER
    FIELD trimestre   AS INTEGER
    FIELD rs-tipo     AS INTEGER
    FIELD rs-acao     AS INTEGER
    FIELD da-transacao AS DATE.

define temp-table tt-digita 
    FIELD canal-central AS INTEGER .

define buffer b-tt-digita for tt-digita.


/* Transfer Definitions */
def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.


DEF TEMP-TABLE tt-canal
    FIELD canal         AS INTEGER
    FIELD nome          AS CHAR FORMAT "X(50)"
    FIELD nome-abrev    AS CHAR FORMAT "X(16)"
    FIELD cgc           AS CHAR FORMAT "X(20)"
    FIELD dt-adesao     AS DATE FORMAT "99/99/9999"
    FIELD exclusividade AS LOG  FORMAT "SIM/N«O"
    FIELD guid-class    AS CHAR FORMAT "X(36)"
    FIELD r-rowid      AS ROWID
    INDEX idx_primary IS PRIMARY UNIQUE canal.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

def stream s-imp.


DEF VAR i-mes AS INTEGER NO-UNDO.
DEF VAR i-ano AS INTEGER NO-UNDO.

DEF VAR da-per-ini AS DATE NO-UNDO.
DEF VAR da-per-fim AS DATE NO-UNDO.

DEF VAR c-meses AS CHAR FORMAT "10" INIT "Janeiro,Abril,Julho,Outubro".

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

/* Definiá∆o da tt-central-filial */ 
                 
{esp/esb/esesbapi005.i}

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
&Scoped-define INTERNAL-TABLES tt-canal

/* Definitions for BROWSE brDigita                                      */
&Scoped-define FIELDS-IN-QUERY-brDigita tt-canal.canal tt-canal.nome-abrev tt-canal.nome tt-canal.cgc tt-canal.dt-adesao tt-canal.exclusividade   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita   
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-canal
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY {&SELF-NAME} FOR EACH tt-canal.
&Scoped-define TABLES-IN-QUERY-brDigita tt-canal
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita tt-canal


/* Definitions for FRAME fpage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage5 ~
    ~{&OPEN-QUERY-brDigita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOk btCancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD retorna-mes wReport 
FUNCTION retorna-mes RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD retorna-mes-ext wReport 
FUNCTION retorna-mes-ext RETURNS CHARACTER
  ( i AS INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOk 
     LABEL "&Executar" 
     SIZE 15.29 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cb-ano AS CHARACTER FORMAT "X(256)":U 
     LABEL "de" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEMS "2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033","2034","2035","2036","2037","2038","2039","2040","2041","2042","2044","2045","2046","2047","2048","2049","2050" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE cb-trimestre AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "T1","T2","T3","T4" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE da-transacao AS DATE FORMAT "99/99/9999":U 
     LABEL "Transaá∆o AP" 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .79 TOOLTIP "Data de Integraá∆o APB" NO-UNDO.

DEFINE VARIABLE fi-periodo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 48 BY .88
     FGCOLOR 9 FONT 0 NO-UNDO.

DEFINE VARIABLE fi-ultimo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Èltimo Per°odo Apuraá∆o" 
      VIEW-AS TEXT 
     SIZE 58 BY .67
     FGCOLOR 9 FONT 0 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "PrÇvia (Simulaá∆o)", 1,
"Oficial", 2
     SIZE 34.43 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 2.25.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 2.25.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 2.25.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 2.25.

DEFINE BUTTON bt-add 
     IMAGE-UP FILE "adeicon/check.bmp":U
     LABEL "" 
     SIZE 4 BY 1.17 TOOLTIP "Permiss∆o de acesso a usu†rios".

DEFINE BUTTON bt-selecionado 
     LABEL "Eliminar Selecionado" 
     SIZE 16.14 BY 1.

DEFINE BUTTON bt-todos 
     LABEL "Eliminar Todos" 
     SIZE 16 BY 1.

DEFINE VARIABLE fi-canal AS CHARACTER FORMAT "X(256)":U 
     LABEL "Canal" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE rs-selecao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos os Canais", 1,
"Informar Canal (is)", 2
     SIZE 35 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-135
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 10.

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

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-canal SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-canal.canal        LABEL "Canal"
      tt-canal.nome-abrev   LABEL "Abreviado"
      tt-canal.nome         LABEL "Nome"          WIDTH 20
      tt-canal.cgc          LABEL "CNPJ"
      tt-canal.dt-adesao    LABEL "Ades∆o"
      tt-canal.exclusividade LABEL "Exclusividade"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 81 BY 6.75
         FONT 1
         TITLE "Canais" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOk AT ROW 15.71 COL 2.57
     btCancel AT ROW 15.71 COL 19.14
     rtToolBar AT ROW 15.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 16.25
         FONT 1.

DEFINE FRAME fpage5
     rs-selecao AT ROW 1.42 COL 25.43 NO-LABEL WIDGET-ID 40
     fi-canal AT ROW 3.25 COL 8 COLON-ALIGNED WIDGET-ID 2
     fi-nome AT ROW 3.25 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 4 NO-TAB-STOP 
     bt-add AT ROW 3.13 COL 79.86 HELP
          "Definir permiss∆o de acesso as funá‰es do programa" WIDGET-ID 24
     brDigita AT ROW 4.5 COL 2.86 WIDGET-ID 200
     bt-selecionado AT ROW 11.46 COL 24.57 WIDGET-ID 54
     bt-todos AT ROW 11.46 COL 42.14 WIDGET-ID 56
     "Processar Benef°cios para:" VIEW-AS TEXT
          SIZE 19 BY 1.25 AT ROW 1.25 COL 5 WIDGET-ID 50
     RECT-135 AT ROW 2.75 COL 2 WIDGET-ID 58
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.5
         SIZE 85 BY 12
         FONT 1 WIDGET-ID 300.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
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
         AT COL 3 ROW 2.5
         SIZE 85 BY 11.92
         FONT 1.

DEFINE FRAME fpage4
     cb-trimestre AT ROW 6.58 COL 4.43 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     cb-ano AT ROW 6.58 COL 16.43 COLON-ALIGNED WIDGET-ID 58
     da-transacao AT ROW 9.75 COL 57.72 COLON-ALIGNED WIDGET-ID 42
     rs-tipo AT ROW 9.92 COL 6 NO-LABEL WIDGET-ID 22
     fi-ultimo AT ROW 3.33 COL 20.86 COLON-ALIGNED WIDGET-ID 12
     fi-periodo AT ROW 6.58 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     "CµLCULO DE BENEF÷CIOS" VIEW-AS TEXT
          SIZE 19 BY .54 AT ROW 1.5 COL 32 WIDGET-ID 40
     "Integraá∆o:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 8.83 COL 47 WIDGET-ID 46
     "Apurar Trimestre:" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 5.58 COL 5 WIDGET-ID 16
     "Tipo de Execuá∆o:" VIEW-AS TEXT
          SIZE 12.86 BY .54 AT ROW 8.83 COL 6 WIDGET-ID 28
     RECT-13 AT ROW 5.79 COL 3 WIDGET-ID 14
     RECT-14 AT ROW 9.08 COL 3 WIDGET-ID 26
     RECT-16 AT ROW 9.08 COL 43 WIDGET-ID 44
     RECT-15 AT ROW 2.58 COL 3 WIDGET-ID 62
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.5
         SIZE 85 BY 11.92
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
         TITLE              = "Apuraá∆o Benef°cios Canais"
         HEIGHT             = 16.42
         WIDTH              = 90.72
         MAX-HEIGHT         = 28.38
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.38
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
ASSIGN FRAME fpage4:FRAME = FRAME fpage0:HANDLE
       FRAME fpage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fpage4
                                                                        */
ASSIGN 
       fi-periodo:READ-ONLY IN FRAME fpage4        = TRUE.

ASSIGN 
       fi-ultimo:READ-ONLY IN FRAME fpage4        = TRUE.

/* SETTINGS FOR FRAME fpage5
   Custom                                                               */
/* BROWSE-TAB brDigita bt-add fpage5 */
ASSIGN 
       fi-nome:READ-ONLY IN FRAME fpage5        = TRUE.

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

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigita
/* Query rebuild information for BROWSE brDigita
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-canal.
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage4
/* Query rebuild information for FRAME fpage4
     _Query            is NOT OPENED
*/  /* FRAME fpage4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage5
/* Query rebuild information for FRAME fpage5
     _Query            is NOT OPENED
*/  /* FRAME fpage5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport /* Apuraá∆o Benef°cios Canais */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport /* Apuraá∆o Benef°cios Canais */
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME bt-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add wReport
ON CHOOSE OF bt-add IN FRAME fpage5
DO:

    DEF VAR r-row AS ROWID NO-UNDO.

    IF  RETURN-VALUE <> "OK" THEN
        RETURN NO-APPLY.

    FIND FIRST tt-central NO-ERROR.
    IF  NOT AVAIL tt-central THEN
        RETURN "NOK".

    FIND FIRST tt-canal
        WHERE tt-canal.r-rowid = tt-central.r-row-central NO-ERROR.

    IF  AVAIL tt-canal THEN
        RETURN "OK".

    FIND FIRST tt-central.
    IF  NOT AVAIL tt-central THEN
        RETURN "NOK".
                                 
    CREATE tt-canal.
    ASSIGN tt-canal.canal         = tt-central.canal-central
           tt-canal.nome          = tt-central.nome-emit-central
           tt-canal.nome-abrev    = tt-central.nome-abrev-central
           tt-canal.cgc           = tt-central.cgc-central
           tt-canal.dt-adesao     = tt-central.dt-adesao-central
           tt-canal.exclusividade = tt-central.exclusividade
           tt-canal.guid-class    = tt-central.guid-class-central
           tt-canal.r-rowid       = r-row.

    {&open-query-brDigita}

    ASSIGN fi-canal:SCREEN-VALUE IN FRAME fpage5 = ""
           fi-nome:SCREEN-VALUE  IN FRAME fpage5 = "".

    APPLY "ENTRY" TO fi-canal IN FRAME fpage5.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-selecionado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-selecionado wReport
ON CHOOSE OF bt-selecionado IN FRAME fpage5 /* Eliminar Selecionado */
DO:
  
    IF  AVAIL tt-canal THEN
        DELETE tt-canal.

    {&open-query-brDigita}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos wReport
ON CHOOSE OF bt-todos IN FRAME fpage5 /* Eliminar Todos */
DO:
    FOR EACH tt-canal:
        DELETE tt-canal.
    END.
    {&open-query-brDigita}
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


&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wReport
ON CHOOSE OF btFile IN FRAME fPage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOk wReport
ON CHOOSE OF btOk IN FRAME fpage0 /* Executar */
DO:
   
    RUN piExecute.

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME cb-ano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano wReport
ON VALUE-CHANGED OF cb-ano IN FRAME fpage4 /* de */
DO:
  RUN pi-define-trimestre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-trimestre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-trimestre wReport
ON VALUE-CHANGED OF cb-trimestre IN FRAME fpage4
DO:
  RUN pi-define-trimestre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME fi-canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal wReport
ON F5 OF fi-canal IN FRAME fpage5 /* Canal */
DO:
      {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                         &campo="fi-canal"
                         &campozoom="cod-emitente"
                         &frame="fpage5"
                         &campo2="fi-nome"
                         &campozoom2="nome-emit"
                         &frame2="fpage5"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal wReport
ON LEAVE OF fi-canal IN FRAME fpage5 /* Canal */
DO:
    DEF VAR r-row AS ROWID NO-UNDO.

    RUN pi-busca-canal (OUTPUT r-row).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal wReport
ON MOUSE-SELECT-DBLCLICK OF fi-canal IN FRAME fpage5 /* Canal */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-selecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-selecao wReport
ON VALUE-CHANGED OF rs-selecao IN FRAME fpage5
DO:

  FOR EACH tt-canal:
      DELETE tt-canal.
  END.
  {&open-query-brDigita}

  IF  SELF:SCREEN-VALUE = "2" THEN
      ASSIGN fi-canal:SENSITIVE       = YES
             brDigita:SENSITIVE       = YES
             bt-selecionado:SENSITIVE = YES
             bt-todos:SENSITIVE       = YES
             bt-add:SENSITIVE         = YES.
  ELSE
      ASSIGN fi-canal:SENSITIVE       = NO 
             brDigita:SENSITIVE       = NO 
             bt-selecionado:SENSITIVE = NO 
             bt-todos:SENSITIVE       = NO
             bt-add:SENSITIVE         = NO.

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
        when "2" then do:
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
&Scoped-define BROWSE-NAME brDigita
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*--- L¢gica para inicializaá∆o do programam ---*/

{report/mainblock.i}

  RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage4:HANDLE).
  RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage5:HANDLE ).

   APPLY "VALUE-CHANGED" TO rs-selecao IN FRAME fpage5.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDestroyInterface wReport 
PROCEDURE AfterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
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
     
      RUN pi-busca-ultima-apuracao.
    
      DEF VAR i-ano AS INTEGER NO-UNDO.
      
      ASSIGN cb-ano:SCREEN-VALUE IN FRAME fpage4 = STRING(YEAR(TODAY)).
       
      RUN pi-define-trimestre.

      ASSIGN da-transacao:SCREEN-VALUE IN FRAME fpage4 = string(TODAY).



      RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeInitializeInterface wReport 
PROCEDURE BeforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-canal wReport 
PROCEDURE pi-busca-canal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-row AS ROWID NO-UNDO.

    IF  fi-canal:SCREEN-VALUE IN FRAME fpage5 = "" 
    OR  fi-canal:SCREEN-VALUE IN FRAME fpage5 = "0" THEN
        RETURN "NOK".
    
    /* valida emitente canal */
    EMPTY TEMP-TABLE tt-central.
    RUN esp/esb/esesbapi005.p (INPUT  fi-canal:SCREEN-VALUE IN FRAME fpage5,
                               OUTPUT TABLE tt-central,
                               OUTPUT TABLE tt-erro).

    FIND FIRST tt-erro NO-ERROR.

    IF  RETURN-VALUE <> "OK"
    OR AVAIL tt-erro THEN DO:
        RUN utp/ut-msgs.p(input "show":U, 
                          input 17006,
                          input tt-erro.mensagem + "~~" + tt-erro.ajuda).
        APPLY "entry" TO fi-canal IN FRAME fpage5.
        RETURN "NOK".
    END.
        
    FIND FIRST tt-central 
        WHERE tt-central.canal-central = int(fi-canal:SCREEN-VALUE) NO-ERROR.

    /* VERIFICA SE O CANAL ê CENTRALIZADO, LOGO, N«O PERMITE INCLU÷LO NO BROWSER*/
    IF  NOT AVAIL tt-central THEN DO:
        RUN utp/ut-msgs.p(input "show":U, 
                          input 17006,
                          input "Este canal apura benef°cios de forma centralizada." + "~~" +
                                "A geraá∆o dos benef°cios s¢ pode ser processada para a Matriz.").
        APPLY "entry" TO fi-canal IN FRAME fpage5.
        RETURN "NOK".
    END.

    ASSIGN fi-nome:SCREEN-VALUE IN FRAME fpage5 = tt-central.nome-emit-central.

    ASSIGN p-row = tt-central.r-row-central.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-ultima-apuracao wReport 
PROCEDURE pi-busca-ultima-apuracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF VAR i-ano     AS INTEGER NO-UNDO.
    DEF VAR i-mes     AS INTEGER NO-UNDO.
    
    ASSIGN i-ano = integer(cb-ano:SCREEN-VALUE IN FRAME fpage4).

    /* BUSCAR ÈLTIMO PER÷ODO ATIVO */
    DEF VAR da-ultimo AS DATE INIT ? NO-UNDO.
    FOR EACH int-cc-benef NO-LOCK
        WHERE int-cc-benef.id-status = 2
          AND int-cc-benef.dt-periodo-fim <= TODAY
           BY int-cc-benef.dt-periodo-fim DESC :
        ASSIGN da-ultimo = int-cc-benef.dt-periodo-ini.
        LEAVE.
    END.

    IF  da-ultimo = ? THEN
        RETURN "NOK".

    IF  MONTH(da-ultimo) = 10 THEN
        ASSIGN cb-trimestre:SCREEN-VALUE IN FRAME fpage4 = "T1"                                            
                     cb-ano:SCREEN-VALUE IN FRAME fpage4 = STRING(YEAR(TODAY))                         
                  fi-ultimo:SCREEN-VALUE IN FRAME fpage4 = "T4 de " + STRING(YEAR(TODAY) - 1) + ".".       
    
    IF  MONTH(da-ultimo) = 1 THEN
        ASSIGN cb-trimestre:SCREEN-VALUE IN FRAME fpage4 = "T2"
                     cb-ano:SCREEN-VALUE IN FRAME fpage4 = STRING(YEAR(TODAY))
                  fi-ultimo:SCREEN-VALUE IN FRAME fpage4 = "T1 de " + STRING(YEAR(TODAY)) + ".".

    IF  MONTH(da-ultimo) = 4 THEN
        ASSIGN cb-trimestre:SCREEN-VALUE IN FRAME fpage4 = "T3"
                     cb-ano:SCREEN-VALUE IN FRAME fpage4 = STRING(YEAR(TODAY))
                  fi-ultimo:SCREEN-VALUE IN FRAME fpage4 = "T2 de " + STRING(YEAR(TODAY) ) + ".".

    IF  MONTH(da-ultimo) = 7 THEN
        ASSIGN cb-trimestre:SCREEN-VALUE IN FRAME fpage4 = "T4"                                                                                                                                                                                  
                     cb-ano:SCREEN-VALUE IN FRAME fpage4 = STRING(YEAR(TODAY))                                                                                                                                                                   
                  fi-ultimo:SCREEN-VALUE IN FRAME fpage4 = "T3 de " + STRING(YEAR(TODAY) ) + ".".                                                                                                                                                

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-define-trimestre wReport 
PROCEDURE pi-define-trimestre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEF VAR i-ano     AS INTEGER NO-UNDO.
    
    ASSIGN i-ano = integer(cb-ano:SCREEN-VALUE IN FRAME fpage4).

    CASE cb-trimestre:SCREEN-VALUE IN FRAME fpage4:
        WHEN "T1" THEN ASSIGN da-per-ini = DATE(01, 01, i-ano)
                              da-per-fim = DATE(03, 31, i-ano).
        WHEN "T2" THEN ASSIGN da-per-ini = DATE(04, 01, i-ano)
                              da-per-fim = DATE(06, 30, i-ano).  
        WHEN "T3" THEN ASSIGN da-per-ini = DATE(07, 01, i-ano)
                              da-per-fim = DATE(09, 30, i-ano).  
        WHEN "T4" THEN ASSIGN da-per-ini = DATE(10, 01, i-ano)
                              da-per-fim = DATE(12, 31, i-ano).  
    END CASE.

    ASSIGN fi-periodo:SCREEN-VALUE IN FRAME fpage4 = "Referente Ös Contas Correntes de " + STRING(da-per-ini) + " atÇ " + STRING(da-per-fim) + "." .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-periodo-apuracao wReport 
PROCEDURE pi-retorna-periodo-apuracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



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

DEF VAR i-trimestre AS INTEGER NO-UNDO.
DEF VAR i-ano       AS INTEGER NO-UNDO.

CASE cb-trimestre:SCREEN-VALUE IN FRAME fpage4:
    WHEN "T1" THEN i-trimestre = 01.
    WHEN "T2" THEN i-trimestre = 02.
    WHEN "T3" THEN i-trimestre = 03.
    WHEN "T4" THEN i-trimestre = 04.
END CASE.

ASSIGN i-ano = int(cb-ano:SCREEN-VALUE IN FRAME fpage4).
/*                                                                                                                                */
/* FIND LAST int-cc-benef NO-LOCK                                                                                                 */
/*     WHERE int-cc-benef.dt-periodo-ini >= da-per-ini                                                                            */
/*       AND int-cc-benef.VerbaCalculada > 0 NO-ERROR.                                                                            */
/*                                                                                                                                */
/* IF  AVAIL int-cc-benef THEN DO:                                                                                                */
/*     RUN utp/ut-msgs.p (input "show", input 17006, input "J† existem contas ativas com Verba Calculada maior para o per°odo" ). */
/*     RETURN "NOK".                                                                                                              */
/* END.                                                                                                                           */
   

IF  da-per-fim > TODAY THEN DO:
    RUN utp/ut-msgs.p (input "show", input 17006, input "Trimestre ainda n∆o pode ser calculado." ).
    RETURN "NOK".
END.


/* Valida para que o màs/ano seja imediatamente posterior ao £timo per°odo executado */
IF  INPUT FRAME fpage4 rs-tipo = 2 THEN DO:
    
    /*CONFIRMA A EXECUÄ«O OFICIAL*/

    run utp/ut-msgs.p (input "show", input 27100, input "Atená∆o! Execuá∆o da Apuraá∆o de Benef°cios" + "~~" +
                       "Nesta Opá∆o, vocà ir† efetuar a apuraá∆o de benef°cios oficialmente para os Canais. Confirma?").
    IF  RETURN-VALUE <> "YES" THEN 
        RETURN.
END.

/* IF  tg-recalculo:CHECKED THEN DO:                                                                                        */
/*     FIND LAST int-cc-benef NO-LOCK NO-ERROR.                                                                             */
/*                                                                                                                          */
/*     IF  NOT AVAIL int-cc-benef THEN DO:                                                                                  */
/*         run utp/ut-msgs.p (input "show", input 17006, input "N∆o  existem dados para rec†lculo" ).                       */
/*         RETURN.                                                                                                          */
/*     END.                                                                                                                 */
/*                                                                                                                          */
/*     IF  AVAIL int-cc-benef                                                                                               */
/*     AND MONTH(int-cc-benef.dt-periodo-fim) <> i-month                                                                    */
/*     AND YEAR (int-cc-benef.dt-periodo-fim) <> i-year THEN DO:                                                            */
/*         RUN utp/ut-msgs.p (input "show", input 17006, input "Rec†lculo s¢ Ç permitido para o mes final do trimestre" ).  */
/*         RETURN.                                                                                                          */
/*     END.                                                                                                                 */
/*                                                                                                                          */
/* END.                                                                                                                     */
                                                                                             
IF  INPUT FRAME fpage5 rs-selecao = 2 
AND NOT CAN-FIND (FIRST tt-canal) THEN DO:
    RUN  utp/ut-msgs.p (input "show", input 17006, input "Nenhum canal selecionado."). 
    RETURN.
END.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN                                     
/*** Relatorio ***/                                                                          
do on error undo, return error on stop  undo, return error:                                  
    {report/rpexa.i}                                                                         
                                                                                             
    if input frame fPage6 rsDestiny = 2 and                                                  
       input frame fPage6 rsExecution = 1 then do:                                           
        run utp/ut-vlarq.p (input input frame fPage6 cFile).                                 
                                                                                             
        if return-value = "NOK":U then do:                                                   
            run utp/ut-msgs.p (input "show", input 73, input "").                            
            apply "ENTRY":U to cFile in frame fPage6.                                        
            return error.                                                                    
        end.                                                                                 
    end.                                                                                     
                                                                                             
    create tt-param.                                                                         
    assign tt-param.usuario         = c-seg-usuario                                          
           tt-param.destino         = input frame fPage6 rsDestiny                           
           tt-param.data-exec       = today                                                  
           tt-param.hora-exec       = time                                                 
           tt-param.ano             = i-ano                                              
           tt-param.trimestre       = i-trimestre
           tt-param.rs-tipo         = INPUT FRAME fpage4 rs-tipo
           tt-param.da-transacao    = INPUT FRAME fpage4 da-transacao.  
                                                                                             
    if tt-param.destino = 1                                                                  
    then                                                                                     
        assign tt-param.arquivo = "".                                                        
    else if  tt-param.destino = 2                                                            
         then assign tt-param.arquivo = input frame fPage6 cFile.                            
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U. 
                                                                                             

     EMPTY TEMP-TABLE tt-digita.
     FOR EACH tt-canal:
         CREATE tt-digita.
         ASSIGN tt-digita.canal-central = tt-canal.canal.
     END.

    /* Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados            
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */               
                                                                                             
    /* Executar do programa RP.P que ir† criar o relat¢rio */                                
    {report/rpexb.i}                                                                         
                                                                                             
    SESSION:SET-WAIT-STATE("GENERAL":U).                                                     
                                                                                             
    {report/rprun.i esp/esb/esesb005rp.p}                                                    
                                                                                             
    {report/rpexc.i}                                                                         
                                                                                             
    SESSION:SET-WAIT-STATE("":U).                                                            
                                                                                             
    {report/rptrm.i}                                                                         
end.                                                                                         
&ENDIF                                                                                       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION retorna-mes wReport 
FUNCTION retorna-mes RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/



END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION retorna-mes-ext wReport 
FUNCTION retorna-mes-ext RETURNS CHARACTER
  ( i AS INTEGER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RETURN  ENTRY(i, c-meses).
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

