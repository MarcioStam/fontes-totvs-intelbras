&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgmov           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-matriz-rat-ordem NO-UNDO LIKE matriz-rat-ordem
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-ordem-compra NO-UNDO LIKE ordem-compra
       FIELD r-Rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esccp035A 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esccp035A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   text-ordem brOrdemCompra text-narrativa edNarrativa ~
                              text-matriz brMatrizRateioOrdemCompra ~
                              btOK btCancel btHelp2

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-num-pedido LIKE pedido-compr.num-pedido NO-UNDO.

/* New Global Shared Variable Definitions ---                           */

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE wh-pesquisa AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brMatrizRateioOrdemCompra

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-matriz-rat-ordem tt-ordem-compra

/* Definitions for BROWSE brMatrizRateioOrdemCompra                     */
&Scoped-define FIELDS-IN-QUERY-brMatrizRateioOrdemCompra ~
tt-matriz-rat-ordem.conta-contabil tt-matriz-rat-ordem.ct-codigo ~
tt-matriz-rat-ordem.sc-codigo tt-matriz-rat-ordem.perc-rateio 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brMatrizRateioOrdemCompra ~
tt-matriz-rat-ordem.ct-codigo tt-matriz-rat-ordem.sc-codigo 
&Scoped-define ENABLED-TABLES-IN-QUERY-brMatrizRateioOrdemCompra ~
tt-matriz-rat-ordem
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brMatrizRateioOrdemCompra tt-matriz-rat-ordem
&Scoped-define QUERY-STRING-brMatrizRateioOrdemCompra FOR EACH tt-matriz-rat-ordem ~
      WHERE tt-matriz-rat-ordem.numero-ordem = tt-ordem-compra.numero-ordem NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brMatrizRateioOrdemCompra OPEN QUERY brMatrizRateioOrdemCompra FOR EACH tt-matriz-rat-ordem ~
      WHERE tt-matriz-rat-ordem.numero-ordem = tt-ordem-compra.numero-ordem NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brMatrizRateioOrdemCompra ~
tt-matriz-rat-ordem
&Scoped-define FIRST-TABLE-IN-QUERY-brMatrizRateioOrdemCompra tt-matriz-rat-ordem


/* Definitions for BROWSE brOrdemCompra                                 */
&Scoped-define FIELDS-IN-QUERY-brOrdemCompra tt-ordem-compra.numero-ordem ~
tt-ordem-compra.it-codigo tt-ordem-compra.conta-contabil ~
tt-ordem-compra.ct-codigo tt-ordem-compra.sc-codigo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brOrdemCompra ~
tt-ordem-compra.it-codigo tt-ordem-compra.ct-codigo ~
tt-ordem-compra.sc-codigo 
&Scoped-define ENABLED-TABLES-IN-QUERY-brOrdemCompra tt-ordem-compra
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brOrdemCompra tt-ordem-compra
&Scoped-define QUERY-STRING-brOrdemCompra FOR EACH tt-ordem-compra NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brOrdemCompra OPEN QUERY brOrdemCompra FOR EACH tt-ordem-compra NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brOrdemCompra tt-ordem-compra
&Scoped-define FIRST-TABLE-IN-QUERY-brOrdemCompra tt-ordem-compra


/* Definitions for FRAME fpage0                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar rtkey rtOrdemCompra ~
rtMatrizRateioOrdemCompra brOrdemCompra edNarrativa ~
brMatrizRateioOrdemCompra btOK btCancel btHelp2 text-ordem text-narrativa ~
text-matriz 
&Scoped-Define DISPLAYED-OBJECTS fiNumPedido edNarrativa text-ordem ~
text-narrativa text-matriz 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE edNarrativa LIKE tt-ordem-compra.narrativa
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 85 BY 2.25 NO-UNDO.

DEFINE VARIABLE fiNumPedido LIKE pedido-compr.num-pedido
     LABEL "Pedido Compra" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE text-matriz AS CHARACTER FORMAT "X(256)":U INITIAL " Matriz Rateio Ordem Compra" 
      VIEW-AS TEXT 
     SIZE 22 BY .67 NO-UNDO.

DEFINE VARIABLE text-narrativa AS CHARACTER FORMAT "X(256)":U INITIAL " Narrativa" 
      VIEW-AS TEXT 
     SIZE 9.72 BY .58 NO-UNDO.

DEFINE VARIABLE text-ordem AS CHARACTER FORMAT "X(256)":U INITIAL " Ordem Compra" 
      VIEW-AS TEXT 
     SIZE 12 BY .67 NO-UNDO.

DEFINE RECTANGLE rtkey
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 1.25.

DEFINE RECTANGLE rtMatrizRateioOrdemCompra
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 5.17.

DEFINE RECTANGLE rtOrdemCompra
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 8.08.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brMatrizRateioOrdemCompra FOR 
      tt-matriz-rat-ordem SCROLLING.

DEFINE QUERY brOrdemCompra FOR 
      tt-ordem-compra SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brMatrizRateioOrdemCompra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brMatrizRateioOrdemCompra wWindow _STRUCTURED
  QUERY brMatrizRateioOrdemCompra NO-LOCK DISPLAY
      tt-matriz-rat-ordem.conta-contabil FORMAT "x(20)":U WIDTH 24
      tt-matriz-rat-ordem.ct-codigo COLUMN-LABEL "Conta" FORMAT "x(20)":U
            WIDTH 12
      tt-matriz-rat-ordem.sc-codigo COLUMN-LABEL "Sub-Conta" FORMAT "x(20)":U
            WIDTH 12
      tt-matriz-rat-ordem.perc-rateio FORMAT ">>9.99":U
  ENABLE
      tt-matriz-rat-ordem.ct-codigo
      tt-matriz-rat-ordem.sc-codigo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 85 BY 4.42
         FONT 1.

DEFINE BROWSE brOrdemCompra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brOrdemCompra wWindow _STRUCTURED
  QUERY brOrdemCompra NO-LOCK DISPLAY
      tt-ordem-compra.numero-ordem COLUMN-LABEL "Ordem Compra" FORMAT "zzzzz9,99":U
            WIDTH 11
      tt-ordem-compra.it-codigo FORMAT "X(16)":U WIDTH 20
      tt-ordem-compra.conta-contabil FORMAT "x(20)":U WIDTH 24
      tt-ordem-compra.ct-codigo COLUMN-LABEL "Conta" FORMAT "x(20)":U
            WIDTH 12
      tt-ordem-compra.sc-codigo COLUMN-LABEL "Sub-Conta" FORMAT "x(20)":U
            WIDTH 12
  ENABLE
      tt-ordem-compra.it-codigo
      tt-ordem-compra.ct-codigo
      tt-ordem-compra.sc-codigo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 85 BY 4.42
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiNumPedido AT ROW 1.17 COL 42 COLON-ALIGNED HELP
          "N£mero do Pedido de Compra"
          LABEL "Pedido Compra" NO-TAB-STOP 
     brOrdemCompra AT ROW 3.17 COL 2 HELP
          ""
     edNarrativa AT ROW 8.29 COL 2 HELP
          "" NO-LABEL NO-TAB-STOP 
     brMatrizRateioOrdemCompra AT ROW 11.75 COL 2 HELP
          ""
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 77
     text-ordem AT ROW 2.33 COL 2 NO-LABEL
     text-narrativa AT ROW 7.71 COL 1.72 NO-LABEL WIDGET-ID 2
     text-matriz AT ROW 10.92 COL 2 NO-LABEL
     rtToolBar AT ROW 16.54 COL 1
     rtkey AT ROW 1 COL 1
     rtOrdemCompra AT ROW 2.67 COL 1
     rtMatrizRateioOrdemCompra AT ROW 11.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87 BY 17
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-matriz-rat-ordem T "?" NO-UNDO mgmov matriz-rat-ordem
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-ordem-compra T "?" NO-UNDO mgmov ordem-compra
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
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
         HEIGHT             = 17
         WIDTH              = 87
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 87
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 87
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
   FRAME-NAME                                                           */
/* BROWSE-TAB brOrdemCompra fiNumPedido fpage0 */
/* BROWSE-TAB brMatrizRateioOrdemCompra edNarrativa fpage0 */
ASSIGN 
       brMatrizRateioOrdemCompra:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       brMatrizRateioOrdemCompra:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

ASSIGN 
       brOrdemCompra:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       brOrdemCompra:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

/* SETTINGS FOR EDITOR edNarrativa IN FRAME fpage0
   LIKE = Temp-Tables.tt-ordem-compra.narrativa EXP-SIZE                */
ASSIGN 
       edNarrativa:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fiNumPedido IN FRAME fpage0
   NO-ENABLE LIKE = mgmov.pedido-compr.num-pedido EXP-LABEL EXP-HELP EXP-SIZE */
/* SETTINGS FOR FILL-IN text-matriz IN FRAME fpage0
   ALIGN-L                                                              */
ASSIGN 
       text-matriz:PRIVATE-DATA IN FRAME fpage0     = 
                "Matriz Rateio Ordem Compra".

/* SETTINGS FOR FILL-IN text-narrativa IN FRAME fpage0
   ALIGN-L                                                              */
ASSIGN 
       text-narrativa:PRIVATE-DATA IN FRAME fpage0     = 
                "Narrativa".

/* SETTINGS FOR FILL-IN text-ordem IN FRAME fpage0
   ALIGN-L                                                              */
ASSIGN 
       text-ordem:PRIVATE-DATA IN FRAME fpage0     = 
                "Ordem Compra".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brMatrizRateioOrdemCompra
/* Query rebuild information for BROWSE brMatrizRateioOrdemCompra
     _TblList          = "Temp-Tables.tt-matriz-rat-ordem"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.tt-matriz-rat-ordem.numero-ordem = tt-ordem-compra.numero-ordem"
     _FldNameList[1]   > Temp-Tables.tt-matriz-rat-ordem.conta-contabil
"tt-matriz-rat-ordem.conta-contabil" ? ? "character" ? ? ? ? ? ? no ? no no "24" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-matriz-rat-ordem.ct-codigo
"tt-matriz-rat-ordem.ct-codigo" "Conta" ? "character" ? ? ? ? ? ? yes ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-matriz-rat-ordem.sc-codigo
"tt-matriz-rat-ordem.sc-codigo" "Sub-Conta" ? "character" ? ? ? ? ? ? yes ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-matriz-rat-ordem.perc-rateio
     _Query            is NOT OPENED
*/  /* BROWSE brMatrizRateioOrdemCompra */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brOrdemCompra
/* Query rebuild information for BROWSE brOrdemCompra
     _TblList          = "Temp-Tables.tt-ordem-compra"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-ordem-compra.numero-ordem
"tt-ordem-compra.numero-ordem" "Ordem Compra" ? "integer" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-ordem-compra.it-codigo
"tt-ordem-compra.it-codigo" ? ? "character" ? ? ? ? ? ? yes ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-ordem-compra.conta-contabil
"tt-ordem-compra.conta-contabil" ? ? "character" ? ? ? ? ? ? no ? no no "24" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-ordem-compra.ct-codigo
"tt-ordem-compra.ct-codigo" "Conta" ? "character" ? ? ? ? ? ? yes ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-ordem-compra.sc-codigo
"tt-ordem-compra.sc-codigo" "Sub-Conta" ? "character" ? ? ? ? ? ? yes ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE brOrdemCompra */
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


&Scoped-define BROWSE-NAME brMatrizRateioOrdemCompra
&Scoped-define SELF-NAME brMatrizRateioOrdemCompra
&Scoped-define SELF-NAME tt-matriz-rat-ordem.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-matriz-rat-ordem.ct-codigo brMatrizRateioOrdemCompra _BROWSE-COLUMN wWindow
ON F5 OF tt-matriz-rat-ordem.ct-codigo IN BROWSE brMatrizRateioOrdemCompra /* Conta */
DO:
    ASSIGN l-implanta = YES.

    {include/zoomvar.i &prog-zoom="adzoom/z01ad047.w"
                       &campo="tt-matriz-rat-ordem.ct-codigo"
                       &campozoom="ct-codigo"
                       &browse="brMatrizRateioOrdemCompra"}

    IF VALID-HANDLE(wh-pesquisa) THEN
        WAIT-FOR CLOSE OF wh-pesquisa.

    APPLY "LEAVE":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-matriz-rat-ordem.ct-codigo brMatrizRateioOrdemCompra _BROWSE-COLUMN wWindow
ON LEAVE OF tt-matriz-rat-ordem.ct-codigo IN BROWSE brMatrizRateioOrdemCompra /* Conta */
DO:
    IF AVAILABLE tt-matriz-rat-ordem THEN DO:
        ASSIGN INPUT BROWSE brMatrizRateioOrdemCompra tt-matriz-rat-ordem.ct-codigo.

        ASSIGN tt-matriz-rat-ordem.conta-contab = TRIM(tt-matriz-rat-ordem.ct-codigo) + TRIM(tt-matriz-rat-ordem.sc-codigo).

        DISPLAY tt-matriz-rat-ordem.conta-contab
            WITH BROWSE brMatrizRateioOrdemCompra.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-matriz-rat-ordem.ct-codigo brMatrizRateioOrdemCompra _BROWSE-COLUMN wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-matriz-rat-ordem.ct-codigo IN BROWSE brMatrizRateioOrdemCompra /* Conta */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-matriz-rat-ordem.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-matriz-rat-ordem.sc-codigo brMatrizRateioOrdemCompra _BROWSE-COLUMN wWindow
ON F5 OF tt-matriz-rat-ordem.sc-codigo IN BROWSE brMatrizRateioOrdemCompra /* Sub-Conta */
DO:
    ASSIGN l-implanta = YES.

    {include/zoomvar.i &prog-zoom="adzoom/z01ad246.w"
                       &campo="tt-matriz-rat-ordem.sc-codigo"
                       &campozoom="sc-codigo"
                       &browse="brMatrizRateioOrdemCompra"}

    IF VALID-HANDLE(wh-pesquisa) THEN
        WAIT-FOR CLOSE OF wh-pesquisa.

    APPLY "LEAVE":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-matriz-rat-ordem.sc-codigo brMatrizRateioOrdemCompra _BROWSE-COLUMN wWindow
ON LEAVE OF tt-matriz-rat-ordem.sc-codigo IN BROWSE brMatrizRateioOrdemCompra /* Sub-Conta */
DO:
    IF AVAILABLE tt-matriz-rat-ordem THEN DO:
        ASSIGN INPUT BROWSE brMatrizRateioOrdemCompra tt-matriz-rat-ordem.sc-codigo.

        ASSIGN tt-matriz-rat-ordem.conta-contab = TRIM(tt-matriz-rat-ordem.ct-codigo) + TRIM(tt-matriz-rat-ordem.sc-codigo).

        DISPLAY tt-matriz-rat-ordem.conta-contab
            WITH BROWSE brMatrizRateioOrdemCompra.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-matriz-rat-ordem.sc-codigo brMatrizRateioOrdemCompra _BROWSE-COLUMN wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-matriz-rat-ordem.sc-codigo IN BROWSE brMatrizRateioOrdemCompra /* Sub-Conta */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brOrdemCompra
&Scoped-define SELF-NAME brOrdemCompra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOrdemCompra wWindow
ON VALUE-CHANGED OF brOrdemCompra IN FRAME fpage0
DO:
    IF AVAILABLE tt-ordem-compra THEN
        ASSIGN edNarrativa = tt-ordem-compra.narrativa.
    ELSE
        ASSIGN edNarrativa = "":U.

    DISPLAY edNarrativa
        WITH FRAME fPage0.

    {&OPEN-QUERY-brMatrizRateioOrdemCompra}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-ordem-compra.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ordem-compra.it-codigo brOrdemCompra _BROWSE-COLUMN wWindow
ON F5 OF tt-ordem-compra.it-codigo IN BROWSE brOrdemCompra /* Item */
DO:
    ASSIGN l-implanta = YES.

    {include/zoomvar.i &prog-zoom="inzoom/z01in172.w"
                       &campo="tt-ordem-compra.it-codigo"
                       &campozoom="it-codigo"
                       &browse="brOrdemCompra"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ordem-compra.it-codigo brOrdemCompra _BROWSE-COLUMN wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-ordem-compra.it-codigo IN BROWSE brOrdemCompra /* Item */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-ordem-compra.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ordem-compra.ct-codigo brOrdemCompra _BROWSE-COLUMN wWindow
ON F5 OF tt-ordem-compra.ct-codigo IN BROWSE brOrdemCompra /* Conta */
DO:
    ASSIGN l-implanta = YES.

    {include/zoomvar.i &prog-zoom="adzoom/z01ad047.w"
                       &campo="tt-ordem-compra.ct-codigo"
                       &campozoom="ct-codigo"
                       &browse="brOrdemCompra"}

    IF VALID-HANDLE(wh-pesquisa) THEN
        WAIT-FOR CLOSE OF wh-pesquisa.

    APPLY "LEAVE":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ordem-compra.ct-codigo brOrdemCompra _BROWSE-COLUMN wWindow
ON LEAVE OF tt-ordem-compra.ct-codigo IN BROWSE brOrdemCompra /* Conta */
DO:
    IF AVAILABLE tt-ordem-compra THEN DO:
        ASSIGN INPUT BROWSE brOrdemCompra tt-ordem-compra.ct-codigo.

        ASSIGN tt-ordem-compra.conta-contab = TRIM(tt-ordem-compra.ct-codigo) + TRIM(tt-ordem-compra.sc-codigo).

        DISPLAY tt-ordem-compra.conta-contab
            WITH BROWSE brOrdemCompra.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ordem-compra.ct-codigo brOrdemCompra _BROWSE-COLUMN wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-ordem-compra.ct-codigo IN BROWSE brOrdemCompra /* Conta */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-ordem-compra.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ordem-compra.sc-codigo brOrdemCompra _BROWSE-COLUMN wWindow
ON F5 OF tt-ordem-compra.sc-codigo IN BROWSE brOrdemCompra /* Sub-Conta */
DO:
    ASSIGN l-implanta = YES.

    {include/zoomvar.i &prog-zoom="adzoom/z01ad246.w"
                       &campo="tt-ordem-compra.sc-codigo"
                       &campozoom="sc-codigo"
                       &browse="brOrdemCompra"}

    IF VALID-HANDLE(wh-pesquisa) THEN
        WAIT-FOR CLOSE OF wh-pesquisa.

    APPLY "LEAVE":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ordem-compra.sc-codigo brOrdemCompra _BROWSE-COLUMN wWindow
ON LEAVE OF tt-ordem-compra.sc-codigo IN BROWSE brOrdemCompra /* Sub-Conta */
DO:
    IF AVAILABLE tt-ordem-compra THEN DO:
        ASSIGN INPUT BROWSE brOrdemCompra tt-ordem-compra.sc-codigo.

        ASSIGN tt-ordem-compra.conta-contab = TRIM(tt-ordem-compra.ct-codigo) + TRIM(tt-ordem-compra.sc-codigo).

        DISPLAY tt-ordem-compra.conta-contab
            WITH BROWSE brOrdemCompra.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ordem-compra.sc-codigo brOrdemCompra _BROWSE-COLUMN wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-ordem-compra.sc-codigo IN BROWSE brOrdemCompra /* Sub-Conta */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 26650,
                       INPUT "altera‡äes":U).

    IF RETURN-VALUE = "NO":U THEN
        RETURN NO-APPLY.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
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
    RUN piExecutar IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brMatrizRateioOrdemCompra
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
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
    IF tt-ordem-compra.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brOrdemCompra THEN.
    IF tt-ordem-compra.ct-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brOrdemCompra THEN.
    IF tt-ordem-compra.sc-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brOrdemCompra THEN.
    IF tt-matriz-rat-ordem.ct-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brMatrizRateioOrdemCompra THEN.
    IF tt-matriz-rat-ordem.sc-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brMatrizRateioOrdemCompra THEN.

    ASSIGN fiNumPedido = p-num-pedido.

    RUN piCarregarTempTables IN THIS-PROCEDURE.

    DISPLAY fiNumPedido
        WITH FRAME fPage0.

    APPLY "ENTRY":U TO brOrdemCompra IN FRAME fPage0.
    APPLY "VALUE-CHANGED":U TO brOrdemCompra IN FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregarTempTables wWindow 
PROCEDURE piCarregarTempTables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-ordem-compra.
    EMPTY TEMP-TABLE tt-matriz-rat-ordem.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Localizando Ordens Compra...":U).

    FOR FIRST pedido-compr NO-LOCK
        WHERE pedido-compr.num-pedido = p-num-pedido,
        EACH ordem-compra NO-LOCK
        WHERE ordem-compra.num-pedido = pedido-compr.num-pedido:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Ordem Compra: ":U + TRIM(STRING(ordem-compra.numero-ordem, "zzzzz9,99":U))).

        CREATE tt-ordem-compra.
        BUFFER-COPY ordem-compra TO tt-ordem-compra.
        ASSIGN tt-ordem-compra.r-Rowid = ROWID(ordem-compra).

        FOR EACH matriz-rat-ordem NO-LOCK
            WHERE matriz-rat-ordem.numero-ordem = ordem-compra.numero-ordem:

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Ordem Compra: ":U + TRIM(STRING(matriz-rat-ordem.numero-ordem, "zzzzz9,99":U)) + " - Cta Ctbl: ":U + TRIM(matriz-rat-ordem.conta-contabil)).

            CREATE tt-matriz-rat-ordem.
            BUFFER-COPY matriz-rat-ordem TO tt-matriz-rat-ordem.
            ASSIGN tt-matriz-rat-ordem.r-Rowid = ROWID(matriz-rat-ordem).
        END.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.

    {&OPEN-QUERY-brOrdemCompra}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecutar wWindow 
PROCEDURE piExecutar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 4458,
                       INPUT "":U).

    IF RETURN-VALUE = "NO":U THEN
        RETURN "NOK":U.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Alterando Informa‡äes do Pedido...":U).

    FOR EACH tt-ordem-compra,
        FIRST ordem-compra EXCLUSIVE-LOCK
        WHERE ROWID(ordem-compra) = tt-ordem-compra.r-Rowid:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Ordem Compra: ":U + TRIM(STRING(ordem-compra.numero-ordem, "zzzzz9,99":U))).

        ASSIGN ordem-compra.it-codigo      = tt-ordem-compra.it-codigo
               ordem-compra.ct-codigo      = tt-ordem-compra.ct-codigo
               ordem-compra.sc-codigo      = tt-ordem-compra.sc-codigo
               ordem-compra.conta-contabil = tt-ordem-compra.conta-contabil.

        IF ordem-compra.it-codigo = "investi":U then do:
            FOR EACH matriz-rat-ordem EXCLUSIVE-LOCK
                WHERE matriz-rat-ordem.numero-ordem = ordem-compra.numero-ordem:
                DELETE matriz-rat-ordem.
            END.
        END.
        ELSE DO:
            FOR EACH tt-matriz-rat-ordem
                WHERE tt-matriz-rat-ordem.numero-ordem = ordem-compra.numero-ordem,
                FIRST matriz-rat-ordem EXCLUSIVE-LOCK
                WHERE ROWID(matriz-rat-ordem) = tt-matriz-rat-ordem.r-Rowid:

                ASSIGN matriz-rat-ordem.ct-codigo      = tt-matriz-rat-ordem.ct-codigo
                       matriz-rat-ordem.sc-codigo      = tt-matriz-rat-ordem.sc-codigo
                       matriz-rat-ordem.conta-contabil = tt-matriz-rat-ordem.conta-contabil.
            END.
        END.

        FOR EACH prazo-compra EXCLUSIVE-LOCK
            WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:
            ASSIGN prazo-compra.it-codigo = ordem-compra.it-codigo.
        END.

        FOR EACH cotacao-item EXCLUSIVE-LOCK
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem:
            ASSIGN cotacao-item.it-codigo = ordem-compra.it-codigo.
        END.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

