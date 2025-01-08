&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttitem NO-UNDO LIKE item
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCEP002 2.04.00.002}

DEF TEMP-TABLE tt-saldos
    FIELD it-codigo      LIKE ITEM.it-codigo
    FIELD desc-item      LIKE ITEM.desc-item
    FIELD un             LIKE ITEM.un
    FIELD cod-comprado   LIKE ITEM.cod-comprado
    FIELD nome-comprado  AS CHAR FORMAT "x(30)"
    FIELD nome-fornec    AS CHAR FORMAT "x(30)"
    FIELD de-saldo-atu   AS DEC  FORMAT ">>,>>>,>>9.99"
    FIELD Depos          AS CHAR FORMAT "x(4)"
    FIELD Local          AS CHAR FORMAT "x(93)"
    FIELD Quantidade     LIKE saldo-estoq.qtidade-atu FORMAT ">>,>>>,>>9.99" LABEL "Quantidade"
    FIELD Soma           AS LOG FORMAT "*/ " LABEL "S"
    FIELD preco          AS DECIMAL FORMAT ">>,>>9.99999"
    FIELD dt-necessidade AS DATE
    FIELD moeda          AS CHARACTER FORMAT "x(04)"
    FIELD des-pto-contr  AS CHAR
    FIELD id-meio-transp LIKE historico-embarque.id-meio-transp
    FIELD cod-estabel    LIKE estabelec.cod-estabel
    FIELD aliquota-ipi   LIKE cotacao-item.aliquota-ipi
    FIELD pre-unit-for   LIKE cotacao-item.pre-unit-for
    FIELD lote           LIKE saldo-estoq.lote
    FIELD dt-vali-lote   LIKE saldo-estoq.dt-vali-lote
    FIELD preco-fornec   LIKE cotacao-item.preco-fornec.

{esp/imp/esimp000.i1} /*tt-emb*/

DEF BUFFER b-tt-saldos FOR tt-saldos.
DEF BUFFER b-emitente  FOR emitente.

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP002
&GLOBAL-DEFINE Version        2.04.00.002

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Saldos

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        ttitem
&GLOBAL-DEFINE hDBOTable      hDBOItem
&GLOBAL-DEFINE DBOTable       ITEM

&GLOBAL-DEFINE page0KeyFields ttitem.it-codigo
&GLOBAL-DEFINE page0Fields    ttitem.cod-comprado ttitem.desc-item ttitem.it-codigo ttitem.un c-fornec de-saldo-atu de-quant-segur c-nome-comprador c-ressup c-situacao c-observacao ttitem.log-necessita-li l-antidumping c-motivo-situacao
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEF VAR wh-pesquisa AS HANDLE NO-UNDO.
DEFINE VARIABLE c-aux AS CHARACTER   NO-UNDO.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR pescep003 LIKE ITEM.it-codigo NO-UNDO.

DEFINE VARIABLE i-plano AS INTEGER FORMAT ">>>>9"
    VIEW-AS FILL-IN SIZE 5 BY .88 NO-UNDO.



DEFINE VARIABLE dt-periodo-ini AS DATE FORMAT "99/99/9999"
    VIEW-AS FILL-IN SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE dt-periodo-fim AS DATE FORMAT "99/99/9999" 
    VIEW-AS FILL-IN SIZE 10 BY .88 NO-UNDO.

ASSIGN i-plano        = 1
       dt-periodo-ini = TODAY
       dt-periodo-fim = TODAY + 365.

DEFINE IMAGE IMAGE-1 FILENAME "image\im-fir":U SIZE 3 BY .88.
DEFINE IMAGE IMAGE-2 FILENAME "image\im-las":U SIZE 3 BY .88.

DEFINE VARIABLE todosEstabel AS CHARACTER   NO-UNDO INITIAL "Todos":U.


{upc\btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME BrSaldos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-saldos

/* Definitions for BROWSE BrSaldos                                      */
&Scoped-define FIELDS-IN-QUERY-BrSaldos /* tt-saldos.it-codigo */ tt-saldos.Soma tt-saldos.Depos tt-saldos.Local tt-saldos.lote tt-saldos.dt-vali-lote tt-saldos.Quantidade tt-saldos.preco tt-saldos.dt-necessidade tt-saldos.moeda tt-saldos.des-pto-contr tt-saldos.id-meio-transp tt-saldos.cod-estabel tt-saldos.aliquota-ipi tt-saldos.pre-unit-for tt-saldos.preco-fornec   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrSaldos   
&Scoped-define SELF-NAME BrSaldos
&Scoped-define QUERY-STRING-BrSaldos FOR EACH tt-saldos
&Scoped-define OPEN-QUERY-BrSaldos OPEN QUERY {&SELF-NAME} FOR EACH tt-saldos.
&Scoped-define TABLES-IN-QUERY-BrSaldos tt-saldos
&Scoped-define FIRST-TABLE-IN-QUERY-BrSaldos tt-saldos


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-BrSaldos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttitem.it-codigo ttitem.desc-item ttitem.un ~
ttitem.cod-comprado ttitem.log-necessita-li 
&Scoped-define ENABLED-TABLES ttitem
&Scoped-define FIRST-ENABLED-TABLE ttitem
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btPlanejado btQueryJoins btReportsJoins btExit ~
btHelp c-situacao c-nome-comprador c-motivo-situacao bt-fornec c-fornec ~
c-ressup tg-inspec de-saldo-atu de-quant-segur de-planejado l-antidumping ~
cb-estabel lb-nec-li lb-nec-insp lb-antidumping 
&Scoped-Define DISPLAYED-FIELDS ttitem.it-codigo ttitem.desc-item ttitem.un ~
ttitem.cod-comprado ttitem.log-necessita-li 
&Scoped-define DISPLAYED-TABLES ttitem
&Scoped-define FIRST-DISPLAYED-TABLE ttitem
&Scoped-Define DISPLAYED-OBJECTS c-situacao c-nome-comprador ~
c-motivo-situacao c-fornec c-ressup tg-inspec de-saldo-atu de-quant-segur ~
de-planejado l-antidumping c-observacao cb-estabel lb-nec-li lb-nec-insp ~
lb-antidumping 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

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
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
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
DEFINE BUTTON bt-fornec 
     LABEL "Fornecedores" 
     SIZE 10 BY 1.

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

DEFINE BUTTON btPlanejado 
     IMAGE-UP FILE "image/im-fil.bmp":U
     LABEL "Planejado" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro"
     FONT 4.

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

DEFINE VARIABLE cb-estabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estabelecimento" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 10 BY 1
     FONT 0 NO-UNDO.

DEFINE VARIABLE c-fornec AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .88 NO-UNDO.

DEFINE VARIABLE c-motivo-situacao AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-comprador AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-observacao AS CHARACTER FORMAT "x(200)" 
     LABEL "Observa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 80 BY .88 NO-UNDO.

DEFINE VARIABLE c-ressup AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ressuprimento" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(50)" 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .88 NO-UNDO.

DEFINE VARIABLE de-planejado AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Consumo Plano" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE de-quant-segur AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Qt Segur" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo-atu AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Saldo" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE lb-antidumping AS CHARACTER FORMAT "X(256)":U INITIAL "Tem Antidumping" 
      VIEW-AS TEXT 
     SIZE 11.72 BY .67 NO-UNDO.

DEFINE VARIABLE lb-nec-insp AS CHARACTER FORMAT "X(256)":U INITIAL "Necessita Inspe‡Æo na Origem" 
      VIEW-AS TEXT 
     SIZE 21.72 BY .67 NO-UNDO.

DEFINE VARIABLE lb-nec-li AS CHARACTER FORMAT "X(256)":U INITIAL "Necessita LI" 
      VIEW-AS TEXT 
     SIZE 8.72 BY .67 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 114 BY 5.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 114 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE l-antidumping AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .67 NO-UNDO.

DEFINE VARIABLE tg-inspec AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

DEFINE BUTTON bt-marca 
     LABEL "Marca/Desmarca" 
     SIZE 15 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrSaldos FOR 
      tt-saldos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrSaldos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrSaldos wMaintenance _FREEFORM
  QUERY BrSaldos DISPLAY
      /*  tt-saldos.it-codigo
      */
    tt-saldos.Soma
    tt-saldos.Depos      
    tt-saldos.Local      WIDTH 58.5
    tt-saldos.lote          WIDTH 13 COLUMN-LABEL "Lote"
    tt-saldos.dt-vali-lote  WIDTH 10 COLUMN-LABEL "Dt Valid Lote"
    tt-saldos.Quantidade
    tt-saldos.preco          COLUMN-LABEL "Pre‡o Ordem"
    tt-saldos.dt-necessidade COLUMN-LABEL "Necessidade" FORMAT '99/99/9999'
    tt-saldos.moeda          COLUMN-LABEL "$"
    tt-saldos.des-pto-contr  COLUMN-LABEL "Ponto Controle Atual" FORMAT "x(40)"
    tt-saldos.id-meio-transp
    tt-saldos.cod-estabel    COLUMN-LABEL "Estabel":U
    tt-saldos.aliquota-ipi   COLUMN-LABEL "% IPI" 
    tt-saldos.pre-unit-for   COLUMN-LABEL "$ IPI"
    tt-saldos.preco-fornec   COLUMN-LABEL "Pre‡o Forn"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 106 BY 13
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
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
     btPlanejado AT ROW 1.13 COL 54 HELP
          "Consultas relacionadas" WIDGET-ID 10
     btQueryJoins AT ROW 1.13 COL 98.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 102.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 106.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 110.57 HELP
          "Ajuda"
     ttitem.it-codigo AT ROW 2.92 COL 9.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     ttitem.desc-item AT ROW 2.92 COL 22.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 59.14 BY .88
     ttitem.un AT ROW 2.92 COL 82.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     c-situacao AT ROW 2.92 COL 86.72 COLON-ALIGNED NO-LABEL
     ttitem.cod-comprado AT ROW 3.92 COL 9.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     c-nome-comprador AT ROW 3.92 COL 20.14 COLON-ALIGNED NO-LABEL
     c-motivo-situacao AT ROW 3.92 COL 86.72 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     ttitem.log-necessita-li AT ROW 4.04 COL 74 WIDGET-ID 18
          LABEL "":L15
          VIEW-AS TOGGLE-BOX
          SIZE 2 BY .83
     bt-fornec AT ROW 4.83 COL 100 WIDGET-ID 38
     c-fornec AT ROW 4.92 COL 9.86 COLON-ALIGNED
     c-ressup AT ROW 4.92 COL 48.14 COLON-ALIGNED
     tg-inspec AT ROW 5 COL 74 WIDGET-ID 12
     de-saldo-atu AT ROW 5.92 COL 9.86 COLON-ALIGNED
     de-quant-segur AT ROW 5.92 COL 30.86 COLON-ALIGNED
     de-planejado AT ROW 5.92 COL 57.43 COLON-ALIGNED WIDGET-ID 4
     l-antidumping AT ROW 6 COL 74 WIDGET-ID 28
     c-observacao AT ROW 6.92 COL 10 COLON-ALIGNED HELP
          "Observa‡Æo" WIDGET-ID 26
     cb-estabel AT ROW 8.25 COL 48 COLON-ALIGNED WIDGET-ID 2
     lb-nec-li AT ROW 4.08 COL 74.29 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     lb-nec-insp AT ROW 5.04 COL 74.29 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     lb-antidumping AT ROW 6.04 COL 74.29 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 114 BY 24
         FONT 1.

DEFINE FRAME fPage1
     BrSaldos AT ROW 1.75 COL 3
     bt-marca AT ROW 14.75 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 9.5
         SIZE 110 BY 15
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttitem T "?" NO-UNDO mgcad item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 24
         WIDTH              = 114
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-observacao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX ttitem.log-necessita-li IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB BrSaldos 1 fPage1 */
ASSIGN 
       BrSaldos:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       BrSaldos:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrSaldos
/* Query rebuild information for BROWSE BrSaldos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-saldos.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BrSaldos */
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

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrSaldos
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME BrSaldos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrSaldos wMaintenance
ON MOUSE-SELECT-DBLCLICK OF BrSaldos IN FRAME fPage1
DO:
  APPLY "return" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrSaldos wMaintenance
ON RETURN OF BrSaldos IN FRAME fPage1
DO:
    APPLY "choose" TO bt-marca IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrSaldos wMaintenance
ON ROW-DISPLAY OF BrSaldos IN FRAME fPage1
DO:
    IF  tt-saldos.dt-vali-lote <> ?
    AND tt-saldos.dt-vali-lote < TODAY THEN DO:
        ASSIGN tt-saldos.Soma          :FGCOLOR IN BROWSE BrSaldos = 12.
        ASSIGN tt-saldos.Depos         :FGCOLOR IN BROWSE BrSaldos = 12.
        ASSIGN tt-saldos.Local         :FGCOLOR IN BROWSE BrSaldos = 12.
        ASSIGN tt-saldos.lote          :FGCOLOR IN BROWSE BrSaldos = 12.
        ASSIGN tt-saldos.dt-vali-lote  :FGCOLOR IN BROWSE BrSaldos = 12.
        ASSIGN tt-saldos.Quantidade    :FGCOLOR IN BROWSE BrSaldos = 12.
        ASSIGN tt-saldos.preco         :FGCOLOR IN BROWSE BrSaldos = 12.
        ASSIGN tt-saldos.moeda         :FGCOLOR IN BROWSE BrSaldos = 12.
        ASSIGN tt-saldos.des-pto-contr :FGCOLOR IN BROWSE BrSaldos = 12.
        ASSIGN tt-saldos.id-meio-transp:FGCOLOR IN BROWSE BrSaldos = 12.
        ASSIGN tt-saldos.cod-estabel   :FGCOLOR IN BROWSE BrSaldos = 12.
        ASSIGN tt-saldos.aliquota-ipi  :FGCOLOR IN BROWSE BrSaldos = 12.
        ASSIGN tt-saldos.pre-unit-for  :FGCOLOR IN BROWSE BrSaldos = 12.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fornec wMaintenance
ON CHOOSE OF bt-fornec IN FRAME fpage0 /* Fornecedores */
DO:
    RUN esp/cep/escep002b.w (INPUT cb-estabel:SCREEN-VALUE IN FRAME fPage0,
                             INPUT ttitem.it-codigo:SCREEN-VALUE IN FRAME fPage0).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca wMaintenance
ON CHOOSE OF bt-marca IN FRAME fPage1 /* Marca/Desmarca */
DO:
    assign de-saldo-atu = 0.

    assign tt-saldos.soma = NOT tt-saldos.soma.
    
    BrSaldos:REFRESH().

    run pi-totaliza.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPlanejado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPlanejado wMaintenance
ON CHOOSE OF btPlanejado IN FRAME fpage0 /* Planejado */
DO:
    RUN pi-planejado.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    FOR EACH tt-saldos:
        ASSIGN tt-saldos.it-codigo     = INPUT FRAME fPage0 ttitem.it-codigo
               tt-saldos.desc-item     = INPUT FRAME fPage0 ttitem.desc-item
               tt-saldos.un            = INPUT FRAME fPage0 ttitem.un
               tt-saldos.cod-comprado  = INPUT FRAME fPage0 ttitem.cod-comprado
               tt-saldos.nome-comprado = INPUT FRAME fPage0 c-nome-comprador
               tt-saldos.nome-fornec   = INPUT FRAME fPage0 c-fornec
               tt-saldos.de-saldo-atu  = INPUT FRAME fPage0 de-saldo-atu.
    END.

    RUN esp/cep/escep002a.w (INPUT TABLE tt-saldos).

    BrSaldos:REFRESH() IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    DEFINE VARIABLE cStatus AS CHAR NO-UNDO.
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.   

    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo="ttitem.it-codigo"    
                       &campo2="ttitem.desc-item"
                       &campo3="ttitem.un"
                       &campo4="ttitem.cod-comprado"
                       &campozoom="it-codigo"
                       &campozoom2="desc-item"
                       &campozoom3="un"
                       &campozoom4="cod-comprado"
                       &frame="fpage0"
                       &frame2="fpage0"
                       &frame3="fpage0"
                       &frame4="fpage0"}

      
    IF VALID-HANDLE(wh-pesquisa) THEN
        WAIT-FOR CLOSE OF wh-pesquisa.

    RUN goToKey IN {&hDBOTable} (INPUT FRAME fPage0 ttitem.it-codigo ).
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Item":U).
        RETURN NO-APPLY.
    END.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-estabel wMaintenance
ON VALUE-CHANGED OF cb-estabel IN FRAME fpage0 /* Estabelecimento */
DO: 
    RUN pi-mostra-valores.
    RUN pi-monta-browse.
    RUN pi-totaliza.  

    RUN pi-calc-planejado.

    IF tg-inspec:CHECKED IN FRAME fPage0 THEN
        ASSIGN bt-fornec:SENSITIVE IN FRAME fPage0 = YES.
    ELSE 
        ASSIGN bt-fornec:SENSITIVE IN FRAME fPage0 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/MainBlock.i}

ENABLE bt-marca
       brSaldos
       WITH FRAME fPage1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN pescep003 = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplayFields wMaintenance 
PROCEDURE AfterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN cb-estabel:SENSITIVE IN FRAME fPage0 = YES
           btPlanejado:SENSITIVE IN FRAME fPage0 = YES.

    RUN pi-mostra-valores.
    RUN pi-monta-browse.
    RUN pi-totaliza.

    RUN pi-calc-planejado.

    IF tg-inspec:CHECKED IN FRAME fPage0 THEN
        ASSIGN bt-fornec:SENSITIVE IN FRAME fPage0 = YES.
    ELSE 
        ASSIGN bt-fornec:SENSITIVE IN FRAME fPage0 = NO.

    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
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
    
    DEFINE VARIABLE c-it-codigo LIKE {&ttTable}.it-codigo NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-it-codigo       AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Item" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-it-codigo.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-it-codigo ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Item":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-it-codigo btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR rGoto AS ROWID NO-UNDO.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo\boin172q01.r":U THEN DO:
        {btb/btb008za.i1 inbo\boin172q01.r YES}
        {btb/btb008za.i2 inbo\boin172q01.r '' {&hDBOTable}}
    END.
        
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    RUN getFirst IN {&hDBOTable}.
    RUN getNext IN {&hDBOTable}.
    RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

    
    IF pescep003 <> "" THEN DO:
        RUN goToKey IN {&hDBOTable} (INPUT pescep003).
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
    END.

    RUN pi-carrega-estabel.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-posicao wMaintenance 
PROCEDURE pi-busca-posicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estabel   LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER p-embarque      LIKE embarque-imp.embarque NO-UNDO.

    FOR EACH embarque-imp NO-LOCK
       WHERE embarque-imp.situacao    = 1
         AND embarque-imp.cod-estabel = p-cod-estabel
         AND embarque-imp.embarque    = p-embarque:

        {esp/imp/esimp000.i}
        
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calc-planejado wMaintenance 
PROCEDURE pi-calc-planejado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-num-calc-plano AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-meses          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dt-data-fim      AS DATE        NO-UNDO.

    ASSIGN de-planejado = 0.

    FIND FIRST pl-prod WHERE pl-prod.cd-plano = i-plano NO-LOCK NO-ERROR.
    IF AVAIL pl-prod THEN DO:
        ASSIGN i-num-calc-plano = IF AVAIL pl-prod THEN pl-prod.num-calc-plano ELSE 0.

        FOR EACH it-periodo NO-LOCK 
           WHERE it-periodo.num-calc-plano = i-num-calc-plano 
             AND (it-periodo.cod-estabel   = cb-estabel:SCREEN-VALUE IN FRAME fPage0 OR cb-estabel:SCREEN-VALUE IN FRAME fPage0 = todosEstabel)
             AND it-periodo.it-codigo      = ttitem.it-codigo:SCREEN-VALUE IN FRAME fPage0
             AND it-periodo.data          >= dt-periodo-ini
             AND it-periodo.data          <= dt-periodo-fim
             BREAK BY it-periodo.data:

            ASSIGN de-planejado = de-planejado + it-periodo.qt-res-plan
                   dt-data-fim  = it-periodo.data.
        END.

        IF dt-data-fim <> ? THEN DO:
            ASSIGN i-meses = INT((dt-data-fim - dt-periodo-ini) / 30) NO-ERROR.

            IF i-meses = ? OR i-meses = 0 THEN ASSIGN i-meses = 1.

            ASSIGN de-planejado = de-planejado / i-meses.
        END.

    END.
    ELSE DO:
        ASSIGN de-planejado = 0.
    END.
    

    DISP de-planejado WITH FRAME fPage0.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-estabel wMaintenance 
PROCEDURE pi-carrega-estabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN cb-estabel:LIST-ITEMS IN FRAME fPage0 = "".

    cb-estabel:ADD-LAST(todosEstabel) IN FRAME fPage0 NO-ERROR.

    FOR EACH estabelec NO-LOCK
       WHERE estabelec.ep-codigo <> "2"
        BY estabelec.cod-estabel:
        cb-estabel:ADD-LAST(estabelec.cod-estabel) IN FRAME fPage0 NO-ERROR.
    END.

    ASSIGN cb-estabel:SCREEN-VALUE IN FRAME fPage0 = v_cod_estab_usuar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta-browse wMaintenance 
PROCEDURE pi-monta-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-saldos.

/* FIND FIRST param-estoq NO-LOCK NO-ERROR. */
/*    */
FOR EACH saldo-estoq NO-LOCK
   WHERE (saldo-estoq.cod-estabel = cb-estabel:SCREEN-VALUE IN FRAME fPage0 OR cb-estabel:SCREEN-VALUE IN FRAME fPage0 = todosEstabel)
     AND saldo-estoq.it-codigo   = INPUT FRAME fPage0 ttitem.it-codigo
     AND saldo-estoq.qtidade-atu > 0
     BY  saldo-estoq.cod-depos:

    FIND FIRST ITEM WHERE
               ITEM.it-codigo = saldo-estoq.it-codigo
               NO-LOCK NO-ERROR.
               
    CREATE tt-saldos.
    ASSIGN tt-saldos.depos        = saldo-estoq.cod-depos
           tt-saldos.local        = saldo-estoq.cod-localiz
           tt-saldos.quantidade   = saldo-estoq.qtidade-atu
           tt-saldos.soma         = YES
           tt-saldos.cod-estabel  = saldo-estoq.cod-estabel
           tt-saldos.lote         = saldo-estoq.lote
           tt-saldos.dt-vali-lote = saldo-estoq.dt-vali-lote
           tt-saldos.aliquota-ipi = item.aliquota-ipi.
END.

FOR EACH saldo-terc NO-LOCK
   WHERE (saldo-terc.cod-estabel = cb-estabel:SCREEN-VALUE IN FRAME fPage0 OR cb-estabel:SCREEN-VALUE IN FRAME fPage0 = todosEstabel)
     AND saldo-terc.it-codigo   = INPUT FRAME fPage0 ttitem.it-codigo
     AND saldo-terc.quantidade > 0:
     FIND emitente   WHERE emitente.cod-emitente   = saldo-terc.cod-emitente NO-LOCK.
     IF saldo-terc.emite-comp <> 0 THEN
        FIND b-emitente WHERE b-emitente.cod-emitente = saldo-terc.emite-comp NO-LOCK.
     ELSE 
         RELEASE b-emitente.

    CREATE tt-saldos.
    ASSIGN tt-saldos.depos        = "3os"
           tt-saldos.local        = STRING(emitente.cod-emitente) + "-" + 
                                    emitente.nome-abrev           + " - NF:" + 
                                    STRING(saldo-terc.nro-docto) 
           tt-saldos.quantidade   = saldo-terc.quantidade
           tt-saldos.soma         = NO
           tt-saldos.cod-estabel  = saldo-terc.cod-estabel.

    IF AVAIL b-emitente THEN DO:
        ASSIGN tt-saldos.local = tt-saldos.local + "-" + b-emitente.nome-abrev.
    END.
END.

FOR EACH prazo-compra NO-LOCK
   WHERE prazo-compra.it-codigo   = INPUT FRAME fPage0 ttitem.it-codigo
     AND prazo-compra.situacao    = 2
     AND prazo-compra.quant-saldo > 0,
    EACH ordem-compra no-lock
   WHERE (ordem-compra.cod-estabel  = cb-estabel:SCREEN-VALUE IN FRAME fPage0 OR cb-estabel:SCREEN-VALUE IN FRAME fPage0 = todosEstabel)
     AND ordem-compra.numero-ordem = prazo-compra.numero-ordem,
    EACH emitente no-lock
   WHERE emitente.cod-emitente = ordem-compra.cod-emitente
      BY prazo-compra.data-entrega:
    
    CREATE tt-saldos.
    ASSIGN tt-saldos.depos       = "Ped"
           tt-saldos.local       = STRING(ordem-compra.num-pedido)                  + "-"   + 
                                   STRING(prazo-compra.numero-ordem)                 + "-"   +
                                   STRING(prazo-compra.parcela)                     + " - " +
                                   STRING(prazo-compra.data-entrega,"99/99/99")   + " - " + 
                                   emitente.nome-abrev                              + "-"   + 
                                   SUBSTRING(ordem-compra.narrativa,1,7)
                                   tt-saldos.quantidade = prazo-compra.quant-saldo
           tt-saldos.preco       = ordem-compra.pre-unit-for
           tt-saldos.cod-estabel = ordem-compra.cod-estabel.

    FOR FIRST cotacao-item OF ordem-compra NO-LOCK:
        ASSIGN tt-saldos.aliquota-ipi = cotacao-item.aliquota-ipi
               tt-saldos.pre-unit-for = cotacao-item.pre-unit-for
               tt-saldos.preco-fornec = cotacao-item.preco-fornec.
    END. /* FOR FIRST cotacao-item */

    FIND FIRST int-prazo-compra
        WHERE int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
          AND int-prazo-compra.parcela      = prazo-compra.parcela NO-LOCK NO-ERROR.

    IF  AVAILABLE int-prazo-compra
    THEN DO:
         ASSIGN tt-saldos.dt-necessidade = int-prazo-compra.data-necessidade.

         IF  int-prazo-compra.nro-docto <> "":U 
         AND int-prazo-compra.nro-docto <> ? THEN
             ASSIGN tt-saldos.local = tt-saldos.local + " - NF: ":U + int-prazo-compra.nro-docto + "/":U + int-prazo-compra.serie-docto
                    tt-saldos.depos = "Tran".
    END.

    FIND FIRST moeda NO-LOCK 
         WHERE moeda.mo-codigo = ordem-compra.mo-codigo NO-ERROR.
    IF AVAILABLE moeda THEN 
        ASSIGN tt-saldos.moeda = CAPS(moeda.sigla).
    ELSE
        ASSIGN tt-saldos.moeda = STRING(ordem-compra.mo-codigo).


    FOR EACH ordens-embarque NO-LOCK
       WHERE ordens-embarque.numero-ordem  = prazo-compra.numero-ordem
         AND ordens-embarque.parcela       = prazo-compra.parcela:
        RUN pi-busca-posicao (INPUT  ordem-compra.cod-estabel,
                              INPUT  ordens-embarque.embarque). 
        FIND FIRST tt-emb NO-ERROR.
        IF NOT AVAIL tt-emb THEN NEXT.
        
        CASE tt-emb.situacao:
            WHEN 99 THEN ASSIGN tt-saldos.depos = "Agt".
            WHEN 1  THEN ASSIGN tt-saldos.depos = "Prev".
            WHEN 2  THEN ASSIGN tt-saldos.depos = "Embar".
            WHEN 98 THEN ASSIGN tt-saldos.depos = "DI".
            WHEN 3  THEN ASSIGN tt-saldos.depos = "Desp".
            WHEN 4  THEN ASSIGN tt-saldos.depos = "NF".
            WHEN 96  THEN ASSIGN tt-saldos.depos = "Inst".
            WHEN 97  THEN ASSIGN tt-saldos.depos = "Manut".
        END CASE.


        /* acrescentado substitui‡Æo da quantidade da ordem pela do embarque 
           em 18/12/06 para identificar possiveis problemas na vincula‡Æo das ordens */
        /*Ultimo Ponto de controle efetivado*/
        FOR LAST historico-embarque NO-LOCK
           WHERE historico-embarque.cod-estabel = ordens-embarque.cod-estabel
             AND historico-embarque.embarque    = ordens-embarque.embarque
             AND historico-embarque.dt-efetiva <> ?
           BREAK BY historico-embarque.dt-efetiva:
        END.

        ASSIGN tt-saldos.quantidade     = ordens-embarque.quantidade
               tt-saldos.des-pto-contr  = tt-emb.des-ult-pto-contr
               tt-saldos.id-meio-transp = IF AVAIL historico-embarque THEN historico-embarque.id-meio-transp ELSE "".

        IF ordens-embarque.embarque <> tt-emb.conhecimento THEN /* antes de ter a informa‡Æo correta do conhecimento ‚ gravado o embarque no campo conhecimento no im0045 */
            ASSIGN tt-emb.conhecimento = tt-emb.conhecimento + "-" + ordens-embarque.embarque.
        /* C2110-0258 - para solucionar conhecimento ?
        ASSIGN tt-saldos.local = STRING(ordem-compra.num-pedido)                  + "-" +
                                 STRING(prazo-compra.numero-ordem) + "-" +
                                 STRING(prazo-compra.parcela)                     + "-" +
                                 emitente.nome-abrev                              + "-" + 
                                 tt-emb.conhecimento                              + "-" +
                                 STRING(tt-emb.dt-embarque,"99/99/99")          + "-" +
                                 STRING(prazo-compra.data-entrega,"99/99/99").*/
        IF tt-emb.conhecimento <> ? THEN
        ASSIGN tt-saldos.local = STRING(ordem-compra.num-pedido)                  + "-" +
                                 STRING(prazo-compra.numero-ordem) + "-" +
                                 STRING(prazo-compra.parcela)                     + "-" +
                                 emitente.nome-abrev                              + "-" + 
                                 tt-emb.conhecimento                              + "-" +
                                 STRING(tt-emb.dt-embarque,"99/99/99")            + "-" +
                                 STRING(prazo-compra.data-entrega,"99/99/99").
        ELSE ASSIGN tt-saldos.local = STRING(ordem-compra.num-pedido)                  + "-" +
                                 STRING(prazo-compra.numero-ordem) + "-" +
                                 STRING(prazo-compra.parcela)                     + "-" +
                                 emitente.nome-abrev                              + "-" + 
                                 //tt-emb.conhecimento                              + "-" +
                                 STRING(tt-emb.dt-embarque,"99/99/99")            + "-" +
                                 STRING(prazo-compra.data-entrega,"99/99/99").
    END.
END.

{&OPEN-QUERY-BrSaldos}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-valores wMaintenance 
PROCEDURE pi-mostra-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE l-sit-dif-estab AS LOGICAL NO-UNDO.
    DEFINE VARIABLE i-situacao      AS INTEGER NO-UNDO.

    ASSIGN c-motivo-situacao:FGCOLOR IN FRAME fPage0 = 12.

    find first item-fornec-estab no-lock
         where item-fornec-estab.it-codigo   = INPUT FRAME fPage0 ttitem.it-codigo
           AND (item-fornec-estab.cod-estabel = cb-estabel:SCREEN-VALUE IN FRAME fPage0 OR cb-estabel:SCREEN-VALUE IN FRAME fPage0 = todosEstabel)
           and item-fornec-estab.ativo
           AND item-fornec-estab.perc-compra > 0 no-error.
    if avail item-fornec-estab then do:
        find emitente where emitente.cod-emitente = item-fornec-estab.cod-emitente NO-LOCK NO-ERROR.
        assign c-fornec:SCREEN-VALUE IN FRAME fPage0 = emitente.nome-abrev.
    end.
    ELSE DO:
        find first item-fornec no-lock
             where item-fornec.it-codigo = INPUT FRAME fPage0 ttitem.it-codigo 
               and item-fornec.ativo
               AND item-fornec.perc-compra > 0 no-error.
        if avail item-fornec then do:
            find emitente where emitente.cod-emitente = item-fornec.cod-emitente NO-LOCK NO-ERROR.
            assign c-fornec:SCREEN-VALUE IN FRAME fPage0 = emitente.nome-abrev.
        end.
    END.

    ASSIGN c-motivo-situacao:SCREEN-VALUE = "".

    ASSIGN i-situacao      = 0
           l-sit-dif-estab = NO.
  
    /*
    FOR EACH item-uni-estab NO-LOCK 
        WHERE item-uni-estab.it-codigo = INPUT FRAME fPage0 ttitem.it-codigo:
        IF i-situacao = 0 THEN
           ASSIGN i-situacao = item-uni-estab.cod-obsoleto.
        ELSE DO:
           IF i-situacao <> item-uni-estab.cod-obsoleto THEN
              ASSIGN l-sit-dif-estab = YES.
        END.                                  
    END.*/
    
    
    FIND FIRST item-uni-estab NO-LOCK
         WHERE (item-uni-estab.cod-estabel = cb-estabel:SCREEN-VALUE IN FRAME fPage0 OR cb-estabel:SCREEN-VALUE IN FRAME fPage0 = todosEstabel)
           AND item-uni-estab.it-codigo   = INPUT FRAME fPage0 ttitem.it-codigo NO-ERROR.
    IF AVAIL item-uni-estab THEN DO:
        ASSIGN ttitem.cod-comprado:SCREEN-VALUE IN FRAME fPage0 = item-uni-estab.cod-comprado
               de-quant-segur:SCREEN-VALUE      IN FRAME fPage0 = STRING(item-uni-estab.quant-segur,">>,>>>,>>9.99")
               c-ressup:SCREEN-VALUE            IN FRAME fPage0 = STRING(item-uni-estab.res-for-comp)
               c-situacao:SCREEN-VALUE          IN FRAME fPage0 = {ininc/i17in172.i 04 item-uni-estab.cod-obsoleto}.

        ASSIGN c-observacao:SCREEN-VALUE IN FRAME fPage0 = ""
               c-observacao:FGCOLOR IN FRAME fPage0      = ?.


        IF item-uni-estab.cod-obsoleto = 2 THEN DO: /* Obsoleto Ordens Automaticas */ 
            FIND FIRST int-item-uni-estab NO-LOCK
                 WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel 
                   AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo NO-ERROR.
        
            IF AVAIL int-item-uni-estab THEN DO:
                ASSIGN c-observacao:SCREEN-VALUE IN FRAME fPage0 = int-item-uni-estab.observacao
                       c-observacao:FGCOLOR IN FRAME fPage0      = 12.
            
                CASE int-item-uni-estab.int-1:
                    WHEN 1 THEN
                       ASSIGN c-motivo-situacao:SCREEN-VALUE = "Altera‡Æo estrutura".
                    WHEN 2 THEN
                       ASSIGN c-motivo-situacao:SCREEN-VALUE = "Phase out produto".
                    WHEN 3 THEN
                       ASSIGN c-motivo-situacao:SCREEN-VALUE = "Item EOL".
                    WHEN 4 THEN
                       ASSIGN c-motivo-situacao:SCREEN-VALUE = "Bloqueado compra".
                END CASE.
            END.

            IF c-motivo-situacao:SCREEN-VALUE = "" THEN DO:
               FIND FIRST ITEM NO-LOCK
                    WHERE ITEM.it-codigo = INPUT FRAME fPage0 ttitem.it-codigo NO-ERROR.
               
               IF ITEM.cod-obsoleto = 2 THEN DO: /* Obsoleto Ordens Automaticas */ 
                  FIND FIRST int-item NO-LOCK
                       WHERE int-item.it-codigo = INPUT FRAME fPage0 ttitem.it-codigo NO-ERROR.
        
                  IF AVAIL int-item THEN DO:
                     CASE int-item.motivo-situacao:
                        WHEN 1 THEN
                           ASSIGN c-motivo-situacao:SCREEN-VALUE = "Altera‡Æo de estrutura".
                        WHEN 2 THEN
                           ASSIGN c-motivo-situacao:SCREEN-VALUE = "Phase out produto".
                        WHEN 3 THEN
                           ASSIGN c-motivo-situacao:SCREEN-VALUE = "Item EOL".
                        WHEN 4 THEN
                           ASSIGN c-motivo-situacao:SCREEN-VALUE = "Bloqueado compra".
                     END CASE.
                  END.
               END.
            END.
        END.
            

        IF item-uni-estab.cod-obsoleto = 1 THEN
            ASSIGN c-situacao:FGCOLOR IN FRAME fPage0 = ?.
        ELSE
            ASSIGN c-situacao:FGCOLOR IN FRAME fPage0 = 12.
    END.
    ELSE DO:
        ASSIGN c-situacao:SCREEN-VALUE IN FRAME fPage0 = "" 
               c-situacao:FGCOLOR      IN FRAME fPage0 = ?.        
    END.

    FIND FIRST usuar-mater NO-LOCK
        WHERE usuar-mater.cod-usuario = INPUT FRAME fPage0 ttitem.cod-comprado NO-ERROR.
    ASSIGN c-nome-comprador:SCREEN-VALUE IN FRAME fPage0 = IF AVAIL usuar-mater THEN usuar-mater.nome-usuar ELSE "".

    
    

    /**/

    DO WITH FRAME fPage0:

        ASSIGN tg-inspec:CHECKED = NO.

        FOR EACH mgesp.item-fabric no-lock
           where item-fabric.it-codigo = ttitem.it-codigo:SCREEN-VALUE:
            FOR FIRST item-fornec-estab NO-LOCK
                WHERE item-fornec-estab.it-codigo    = item-fabric.it-codigo
                AND   item-fornec-estab.item-do-forn = STRING(item-fabric.cod-fabric)
                AND   (item-fornec-estab.cod-estabel = cb-estabel:SCREEN-VALUE OR cb-estabel:SCREEN-VALUE IN FRAME fPage0 = todosEstabel),
                FIRST int-item-fornec-estab OF item-fornec-estab NO-LOCK:
                IF int-item-fornec-estab.log-nec-inspec THEN DO:
                   ASSIGN tg-inspec:CHECKED = int-item-fornec-estab.log-nec-inspec.
                   LEAVE.
                END.
            END.
        END.

        find first int-item no-lock
             where int-item.it-codigo = ttitem.it-codigo no-error.
        if avail int-item THEN DO:
            assign l-antidumping:checked = int-item.log-antidumping.
          
           
            /*
            IF int-item.motivo-situacao = 1 THEN
                ASSIGN c-motivo-situacao:SCREEN-VALUE = "Altera‡Æo de estrutura".
            ELSE IF  int-item.motivo-situacao = 2 THEN
                ASSIGN c-motivo-situacao:SCREEN-VALUE = "Phase out produto".
            ELSE 
                ASSIGN c-motivo-situacao:SCREEN-VALUE = "".*/
        END.
        else
            assign l-antidumping:checked = no.

        ASSIGN lb-nec-li:SCREEN-VALUE = "Necessita LI"
               lb-nec-insp:SCREEN-VALUE = "Necessita Inspe‡Æo na Origem"
               lb-antidumping:screen-value = "Tem Antidumping".

        IF ttitem.log-necessita-li:CHECKED THEN 
            ASSIGN lb-nec-li:FGCOLOR = 12.
        ELSE
            ASSIGN lb-nec-li:FGCOLOR = ?.

        IF tg-inspec:CHECKED THEN 
            ASSIGN lb-nec-insp:FGCOLOR = 12.
        ELSE
            ASSIGN lb-nec-insp:FGCOLOR = ?.

        IF l-antidumping:CHECKED THEN 
            ASSIGN lb-antidumping:FGCOLOR = 12.
        ELSE
            ASSIGN lb-antidumping:FGCOLOR = ?.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-planejado wMaintenance 
PROCEDURE pi-planejado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR iqtd AS INT NO-UNDO.


    DEFINE BUTTON btBuscaCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btBuscaOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE FRAME fBusca
        i-plano            AT ROW 1.21 COL 8.0 COLON-ALIGNED LABEL "Plano" 
        dt-periodo-ini     AT ROW 2.21 COL 8.0 COLON-ALIGNED LABEL "Per¡odo"
        dt-periodo-fim     AT ROW 2.21 COL 27.0 COLON-ALIGNED NO-LABEL
        IMAGE-1 AT ROW 2.21 COL 20.50
        IMAGE-2 AT ROW 2.21 COL 25.50
        btBuscaOK     AT ROW 3.63 COL 2.14
        btBuscaCancel AT ROW 3.63 COL 13
        SPACE(0.48)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Consumo Planejado" FONT 1
             DEFAULT-BUTTON btBuscaOK CANCEL-BUTTON btBuscaCancel.
    
    ON "CHOOSE":U OF btBuscaOK IN FRAME fBusca DO:
        APPLY "GO":U TO FRAME fBusca.
    END.

    ON 'choose':U OF btBuscaCancel IN FRAME fBusca DO:
        APPLY "GO":U TO FRAME fBusca.
        RETURN NO-APPLY.
    END.

    ENABLE i-plano 
           dt-periodo-ini 
           dt-periodo-fim
           btBuscaOK btBuscaCancel 
        WITH FRAME fBusca. 
    
    DISP i-plano
         dt-periodo-ini
         dt-periodo-fim WITH FRAME fBusca.

    WAIT-FOR "GO":U OF FRAME fBusca.

    ASSIGN INPUT FRAME fBusca 
           i-plano
           dt-periodo-ini 
           dt-periodo-fim.

    RUN pi-calc-planejado.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-totaliza wMaintenance 
PROCEDURE pi-totaliza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

assign de-saldo-atu = 0.

for each b-tt-saldos 
   where b-tt-saldos.soma:

    assign de-saldo-atu  = de-saldo-atu  + b-tt-saldos.quantidade.
end.
disp de-saldo-atu with frame fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

