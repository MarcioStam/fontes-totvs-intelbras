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
{include/i-prgvrs.i ESCCP027 2.06.00.001}

DEF TEMP-TABLE tt-saldos NO-UNDO
    FIELD it-codigo     LIKE ITEM.it-codigo
    FIELD desc-item     LIKE ITEM.desc-item
    FIELD un            LIKE ITEM.un
    FIELD cod-comprado  LIKE ITEM.cod-comprado
    FIELD nome-comprado AS CHAR FORMAT "x(30)"
    FIELD nome-fornec   AS CHAR FORMAT "x(30)"
    FIELD de-saldo-atu  AS DEC  FORMAT ">>,>>>,>>9.99"
    FIELD Depos         AS CHAR FORMAT "x(4)"
    FIELD Local         AS CHAR FORMAT "x(80)"
    FIELD Quantidade    LIKE saldo-estoq.qtidade-atu FORMAT ">>,>>>,>>9.99" LABEL "Quantidade"
    FIELD Soma          AS LOG FORMAT "*/ " LABEL "S"
    FIELD preco         AS DECIMAL FORMAT ">>,>>>,>>9.99"
    FIELD moeda         AS CHARACTER FORMAT "x(08)"
    FIELD num-seq-saldo AS INT
    FIELD num-pedido    LIKE pedido-compr.num-pedido
    FIELD embarque      LIKE embarque-imp.embarque
    FIELD des-pto-contr AS CHAR
    FIELD id-meio-transp LIKE historico-embarque.id-meio-transp 
    FIELD dat-entrega   AS DATE
    INDEX id-seq
            num-seq-saldo
    INDEX id-embarque
            num-pedido
            embarque
    INDEX id-entrega
            dat-entrega
            num-pedido
            depos.

{esp/imp/esimp000.i1} /*tt-emb*/

DEF TEMP-TABLE tt-emb-ja-listado NO-UNDO
    FIELD embarque LIKE embarque-imp.embarque
    INDEX id-embarque
            embarque.

DEF BUFFER b-tt-saldos FOR tt-saldos.

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCCP027
&GLOBAL-DEFINE Version        1

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
&GLOBAL-DEFINE page0Fields    ttitem.cod-comprado ttitem.desc-item ttitem.it-codigo ttitem.un c-fornec de-saldo-atu de-quant-segur c-nome-comprador c-ressup c-situacao ttitem.log-necessita-li
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR pescep003 LIKE ITEM.it-codigo NO-UNDO.

DEFINE VARIABLE {&hDBOTable}    AS HANDLE      NO-UNDO.
DEFINE VARIABLE wh-pesquisa     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE v-num-seq       AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-dat-pto-contr AS DATE        NO-UNDO.

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
&Scoped-define FIELDS-IN-QUERY-BrSaldos /* tt-saldos.it-codigo */ tt-saldos.Soma tt-saldos.Depos tt-saldos.Local tt-saldos.Quantidade tt-saldos.preco tt-saldos.moeda tt-saldos.des-pto-contr tt-saldos.id-meio-transp   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrSaldos   
&Scoped-define SELF-NAME BrSaldos
&Scoped-define QUERY-STRING-BrSaldos FOR EACH tt-saldos USE-INDEX id-entrega
&Scoped-define OPEN-QUERY-BrSaldos OPEN QUERY {&SELF-NAME}     FOR EACH tt-saldos USE-INDEX id-entrega.
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
btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp c-situacao ~
tg-inspec v-qtd-lote-min c-nome-comprador v-qtd-lote-mult v-cod-emitente ~
c-fornec de-quant-segur c-ressup de-saldo-atu cb-estabel 
&Scoped-Define DISPLAYED-FIELDS ttitem.it-codigo ttitem.desc-item ttitem.un ~
ttitem.cod-comprado ttitem.log-necessita-li 
&Scoped-define DISPLAYED-TABLES ttitem
&Scoped-define FIRST-DISPLAYED-TABLE ttitem
&Scoped-Define DISPLAYED-OBJECTS c-situacao tg-inspec v-qtd-lote-min ~
c-nome-comprador v-qtd-lote-mult v-cod-emitente c-fornec de-quant-segur ~
c-ressup de-saldo-atu cb-estabel 

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
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-comprador AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-ressup AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ressuprimento" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(50)" 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .88 NO-UNDO.

DEFINE VARIABLE de-quant-segur AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Qt Segur" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo-atu AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Saldo" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-emitente AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-qtd-lote-min AS DECIMAL FORMAT ">>,>>9.9999":U INITIAL 0 
     LABEL "Lote Minimo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE v-qtd-lote-mult AS DECIMAL FORMAT ">>,>>9.9999":U INITIAL 0 
     LABEL "Lote M£ltiplo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 114 BY 4.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 114 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tg-inspec AS LOGICAL INITIAL no 
     LABEL "Inspe‡Æo na Origem" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

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
    tt-saldos.Local FORMAT "x(80)"     
    tt-saldos.Quantidade
    tt-saldos.preco COLUMN-LABEL "Pre‡o"
    tt-saldos.moeda COLUMN-LABEL "Moeda"
    tt-saldos.des-pto-contr COLUMN-LABEL "Ponto Controle Atual" FORMAT "x(40)"
    tt-saldos.id-meio-transp
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 105 BY 13
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
     btQueryJoins AT ROW 1.13 COL 98.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 102.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 106.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 110.57 HELP
          "Ajuda"
     ttitem.it-codigo AT ROW 3 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     ttitem.desc-item AT ROW 3 COL 24.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 34 BY .88
     ttitem.un AT ROW 3 COL 59 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     c-situacao AT ROW 3 COL 64 COLON-ALIGNED NO-LABEL
     tg-inspec AT ROW 3 COL 93 WIDGET-ID 12
     ttitem.cod-comprado AT ROW 4 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     v-qtd-lote-min AT ROW 4 COL 78 COLON-ALIGNED WIDGET-ID 28
     ttitem.log-necessita-li AT ROW 4 COL 93 WIDGET-ID 18
          LABEL "Necessita LI"
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY .83
     c-nome-comprador AT ROW 4.08 COL 24.14 COLON-ALIGNED NO-LABEL
     v-qtd-lote-mult AT ROW 5 COL 78 COLON-ALIGNED WIDGET-ID 30
     v-cod-emitente AT ROW 5.08 COL 14.14 COLON-ALIGNED WIDGET-ID 26
     c-fornec AT ROW 5.08 COL 24.14 COLON-ALIGNED NO-LABEL
     de-quant-segur AT ROW 6 COL 78 COLON-ALIGNED
     c-ressup AT ROW 6.08 COL 14.14 COLON-ALIGNED
     de-saldo-atu AT ROW 6.08 COL 44.86 COLON-ALIGNED
     cb-estabel AT ROW 7.75 COL 48 COLON-ALIGNED WIDGET-ID 2
     rtKeys AT ROW 2.83 COL 1
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
         AT COL 3 ROW 9
         SIZE 109 BY 15
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
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
OPEN QUERY {&SELF-NAME}
    FOR EACH tt-saldos USE-INDEX id-entrega.
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
    IF  INPUT FRAME fPage0 ttitem.it-codigo <> ""
    THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        RUN pi-inicializar IN h-acomp (INPUT "Obtendo informa‡äes").
        RUN pi-acompanhar  IN h-acomp (INPUT "Aguarde...").
        RUN pi-mostra-valores.
        RUN pi-monta-browse.
        RUN pi-totaliza.  
        RUN pi-finalizar IN h-acomp.
        ASSIGN h-acomp = ?.
    END.
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
           brsaldos:SENSITIVE   IN FRAME fpage1 = YES
           bt-marca:SENSITIVE   IN FRAME fpage1 = YES.

    IF  INPUT FRAME fPage0 ttitem.it-codigo <> ""
    THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        RUN pi-inicializar IN h-acomp (INPUT "Obtendo informa‡äes").
        RUN pi-acompanhar  IN h-acomp (INPUT "Aguarde...").
        RUN pi-mostra-valores.
        RUN pi-monta-browse.
        RUN pi-totaliza.  
        RUN pi-finalizar IN h-acomp.
        ASSIGN h-acomp = ?.
    END.

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

DEF INPUT  PARAM p-embarque      LIKE embarque-imp.embarque NO-UNDO.

FOR EACH embarque-imp NO-LOCK
   WHERE embarque-imp.situacao = 1
     AND embarque-imp.cod-estabel = cb-estabel:SCREEN-VALUE IN FRAME fPage0
     AND embarque-imp.embarque = p-embarque:

    {esp/imp/esimp000.i}
END.


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

ASSIGN v-num-seq = 0.

FOR EACH saldo-estoq NO-LOCK
   WHERE saldo-estoq.cod-estabel = cb-estabel:SCREEN-VALUE IN FRAME fPage0
     AND saldo-estoq.it-codigo   = INPUT FRAME fPage0 ttitem.it-codigo
     AND saldo-estoq.qtidade-atu > 0
     BY  saldo-estoq.cod-depos:
    ASSIGN v-num-seq = v-num-seq + 1.
    CREATE tt-saldos.
    ASSIGN tt-saldos.num-seq-saldo = v-num-seq
           tt-saldos.depos         = saldo-estoq.cod-depos
           tt-saldos.local         = saldo-estoq.cod-localiz
           tt-saldos.quantidade    = saldo-estoq.qtidade-atu
           tt-saldos.soma          = YES
           tt-saldos.dat-entrega   = 01/01/2000
           tt-saldos.num-pedido    = 0.
END.

FOR EACH saldo-terc NO-LOCK
   WHERE saldo-terc.cod-estabel = cb-estabel:SCREEN-VALUE IN FRAME fPage0
     AND saldo-terc.it-codigo   = INPUT FRAME fPage0 ttitem.it-codigo
     AND saldo-terc.quantidade  > 0:
     FIND emitente WHERE emitente.cod-emitente = saldo-terc.cod-emitente NO-LOCK.
    ASSIGN v-num-seq = v-num-seq + 1.
    CREATE tt-saldos.
    ASSIGN tt-saldos.num-seq-saldo = v-num-seq
           tt-saldos.depos         = "3os"
           tt-saldos.local         = STRING(emitente.cod-emitente) + "-" + 
                                     emitente.nome-abrev           + " - NF:" + 
                                     STRING(saldo-terc.nro-docto) 
           tt-saldos.quantidade    = saldo-terc.quantidade
           tt-saldos.soma          = NO
           tt-saldos.dat-entrega   = 01/01/2000
           tt-saldos.num-pedido    = 0.
END.

FOR EACH  int-pedido-compr NO-LOCK
    WHERE int-pedido-compr.cod-produto-ckd = INPUT FRAME fPage0 ttitem.it-codigo:

    bloco-ordem-compra:
    FOR EACH  ordem-compra NO-LOCK
        WHERE ordem-compra.num-pedido  = int-pedido-compr.num-pedido
          AND ordem-compra.cod-estabel = cb-estabel:SCREEN-VALUE IN FRAME fPage0
          AND ordem-compra.situacao    = 2: /* Confirmada */

        FOR EACH prazo-compra OF ordem-compra NO-LOCK
           WHERE prazo-compra.situacao    = 2
             AND prazo-compra.quant-saldo > 0,
            EACH emitente no-lock
           WHERE emitente.cod-emitente = ordem-compra.cod-emitente
              BY prazo-compra.data-entrega:
            ASSIGN v-num-seq = v-num-seq + 1.
            CREATE tt-saldos.
            ASSIGN tt-saldos.num-seq-saldo = v-num-seq
                   tt-saldos.depos         = "Ped"
                   tt-saldos.local         =  STRING(ordem-compra.num-pedido)                  + "-"   + 
                                              SUBSTRING(STRING(prazo-compra.numero-ordem),1,6) + "-"   +
                                              STRING(prazo-compra.parcela)                     + " - " +
                                              STRING(prazo-compra.data-entrega,"99/99/9999")   + " - " + 
                                              emitente.nome-abrev                              + "-"   + 
                                              SUBSTRING(ordem-compra.narrativa,1,7)
                   tt-saldos.quantidade    = int-pedido-compr.qtd-pedido-ckd
                   tt-saldos.preco         = ordem-compra.pre-unit-for * prazo-compra.quantidade
                   tt-saldos.num-pedido    = ordem-compra.num-pedido
                   tt-saldos.dat-entrega   = prazo-compra.data-entrega.

            FIND FIRST int-prazo-compra
                WHERE int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                  AND int-prazo-compra.parcela      = prazo-compra.parcela NO-LOCK NO-ERROR.

            IF AVAILABLE int-prazo-compra         AND
               int-prazo-compra.nro-docto <> "":U THEN
                ASSIGN tt-saldos.local = tt-saldos.local + " - NF: ":U + int-prazo-compra.nro-docto + "/":U + int-prazo-compra.serie-docto.

            FIND FIRST moeda NO-LOCK 
                 WHERE moeda.mo-codigo = ordem-compra.mo-codigo NO-ERROR.
            IF AVAILABLE moeda THEN 
                ASSIGN tt-saldos.moeda = CAPS(moeda.descricao).
            ELSE
                ASSIGN tt-saldos.moeda = STRING(ordem-compra.mo-codigo).

            FOR EACH ordens-embarque NO-LOCK
               WHERE ordens-embarque.numero-ordem  = prazo-compra.numero-ordem
                 AND ordens-embarque.parcela       = prazo-compra.parcela:
                RUN pi-busca-posicao (INPUT  ordens-embarque.embarque). 
                FIND FIRST tt-emb NO-ERROR.
                IF NOT AVAIL tt-emb THEN NEXT.

                /*Ultimo Ponto de controle efetivado*/
                FOR LAST historico-embarque NO-LOCK
                   WHERE historico-embarque.cod-estabel = ordens-embarque.cod-estabel
                     AND historico-embarque.embarque    = ordens-embarque.embarque
                     AND historico-embarque.dt-efetiva <> ?
                   BREAK BY historico-embarque.dt-efetiva:
                END.

                ASSIGN tt-saldos.embarque       = ordens-embarque.embarque
                       tt-saldos.des-pto-contr  = tt-emb.des-ult-pto-cont
                       tt-saldos.id-meio-transp = IF AVAIL historico-embarque THEN historico-embarque.id-meio-transp ELSE "".

                CASE tt-emb.situacao:
                    WHEN 1  THEN ASSIGN tt-saldos.depos = "Prev".
                    WHEN 99 THEN ASSIGN tt-saldos.depos = "Agt".
                    WHEN 2  THEN ASSIGN tt-saldos.depos = "Embar".
                    WHEN 98 THEN ASSIGN tt-saldos.depos = "DI".
                    WHEN 3  THEN ASSIGN tt-saldos.depos = "Desp".
                    WHEN 4  THEN ASSIGN tt-saldos.depos = "NF".
                    WHEN 96  THEN ASSIGN tt-saldos.depos = "Inst".
                    WHEN 97  THEN ASSIGN tt-saldos.depos = "Manut".
                END CASE.

                IF ordens-embarque.embarque <> tt-emb.conhecimento /* antes de ter a informa‡Æo correta do conhecimento ‚ gravado o embarque no campo conhecimento no im0045 */
                THEN
                    ASSIGN tt-emb.conhecimento = tt-emb.conhecimento + "-" + ordens-embarque.embarque.
                ELSE
                    ASSIGN tt-emb.conhecimento = "-" + ordens-embarque.embarque.

                ASSIGN tt-saldos.local = STRING(ordem-compra.num-pedido)                  + "-" +
                                         emitente.nome-abrev                              + "-" + 
                                         tt-emb.conhecimento                              + "-" +
                                         STRING(tt-emb.dt-embarque,"99/99/9999")          + "-" +
                                         STRING(prazo-compra.data-entrega,"99/99/9999").
            END. /* FOR EACH ordens-embarque NO-LOCK */
        END. /* FOR EACH prazo-compra OF ordem-compra NO-LOCK */
    END. /* FOR EACH  ordem-compra NO-LOCK */
END. /* FOR EACH  int-pedido-compr NO-LOCK */

/* Agrupar ordens do mesmo pedido/embarque */

FOR EACH tt-saldos
    BREAK BY tt-saldos.num-pedido
          BY tt-saldos.embarque:

    IF  FIRST-OF(tt-saldos.embarque)
    THEN DO:
        FOR EACH  b-tt-saldos
            WHERE b-tt-saldos.num-pedido     = tt-saldos.num-pedido
              AND b-tt-saldos.embarque       = tt-saldos.embarque
              AND b-tt-saldos.num-seq-saldo <> tt-saldos.num-seq-saldo: 

            ASSIGN tt-saldos.preco = tt-saldos.preco + b-tt-saldos.preco.
        END.
    END.
    ELSE
        DELETE tt-saldos.
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

     DISP 0 @ v-cod-emitente 
          0 @ v-qtd-lote-min
          0 @ v-qtd-lote-mult WITH FRAME fpage0.

    find first item-fornec-estab no-lock
         where item-fornec-estab.it-codigo   = INPUT FRAME fPage0 ttitem.it-codigo
           AND item-fornec-estab.cod-estabel = cb-estabel:SCREEN-VALUE IN FRAME fPage0
           and item-fornec-estab.ativo       = YES no-error.
    if avail item-fornec-estab then do:
        DISP item-fornec-estab.cod-emitente @ v-cod-emitente 
             item-fornec-estab.lote-minimo  @ v-qtd-lote-min
             item-fornec-estab.lote-mul-for @ v-qtd-lote-mult WITH FRAME fpage0.

        find emitente where emitente.cod-emitente = item-fornec-estab.cod-emitente NO-LOCK NO-ERROR.
        assign c-fornec:SCREEN-VALUE IN FRAME fPage0 = emitente.nome-abrev.
    end.
    ELSE DO:
        find first item-fornec no-lock
             where item-fornec.it-codigo = INPUT FRAME fPage0 ttitem.it-codigo 
               and item-fornec.ativo     = YES no-error.
        if avail item-fornec then do:
             DISP item-fornec.cod-emitente @ v-cod-emitente 
                  item-fornec.lote-minimo  @ v-qtd-lote-min
                  item-fornec.lote-mul-for @ v-qtd-lote-mult WITH FRAME fpage0.
            find emitente where emitente.cod-emitente = item-fornec.cod-emitente NO-LOCK NO-ERROR.
            assign c-fornec:SCREEN-VALUE IN FRAME fPage0 = emitente.nome-abrev.
        end.
    END.

    FIND FIRST item-uni-estab NO-LOCK
         WHERE item-uni-estab.cod-estabel = cb-estabel:SCREEN-VALUE IN FRAME fPage0
           AND item-uni-estab.it-codigo   = INPUT FRAME fPage0 ttitem.it-codigo NO-ERROR.
    IF AVAIL item-uni-estab THEN DO:
        ASSIGN ttitem.cod-comprado:SCREEN-VALUE IN FRAME fPage0 = item-uni-estab.cod-comprado
               de-quant-segur:SCREEN-VALUE      IN FRAME fPage0 = STRING(item-uni-estab.quant-segur,">>,>>>,>>9.99")
               c-ressup:SCREEN-VALUE            IN FRAME fPage0 = STRING(item-uni-estab.res-for-comp)
               c-situacao:SCREEN-VALUE          IN FRAME fPage0 = {ininc/i17in172.i 04 item-uni-estab.cod-obsoleto}.

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

        FOR FIRST int-item-fornec-estab NO-LOCK
            WHERE int-item-fornec-estab.it-codigo = ttitem.it-codigo:SCREEN-VALUE
            AND   int-item-fornec-estab.cod-emitente = emitente.cod-emitente
            AND   int-item-fornec-estab.cod-estabel = cb-estabel:SCREEN-VALUE:
        END.

        ASSIGN tg-inspec:CHECKED = IF AVAIL int-item-fornec-estab THEN int-item-fornec-estab.log-nec-inspec ELSE FALSE.
    END.

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

