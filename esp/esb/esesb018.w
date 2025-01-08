&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright Exponencial TI (2010)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Exponencial, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESESB018 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESESB0018
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cDs-Beneficio    AS CHARACTER FORMAT "X(16)"  NO-UNDO.
DEFINE VARIABLE r-rowid-tt-param AS ROWID                     NO-UNDO.
DEFINE VARIABLE r-rowid-tt       AS ROWID                     NO-UNDO.
DEFINE VARIABLE r-rowid-inclusao AS ROWID                     NO-UNDO.

DEFINE VARIABLE v_column AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_asc    AS LOGICAL     NO-UNDO.

DEF TEMP-TABLE tt-beneficio  NO-UNDO
    FIELD canal                AS INTEGER
    FIELD guid-canal           AS CHAR FORMAT "X(36)"
    FIELD unid-neg             AS CHAR 
    FIELD guid-categoria       AS CHAR FORMAT "X(36)"
    FIELD guid-beneficio       AS CHAR FORMAT "X(36)"
    FIELD tipo-beneficio       AS INTEGER
    FIELD tipo-categoria       AS CHAR
    FIELD guid-class           AS CHAR FORMAT "X(36)"
    FIELD nome-class           AS CHAR FORMAT "X(50)"
    FIELD exclusividade        AS LOGICAL
    FIELD id-status            AS INT
    FIELD calcula-verba        AS LOGICAL
    /*MSG OBTER_PARAMETROS_GLOBAIS*/
    FIELD perc-global          AS DECIMAL
    /*MSG142*/
    FIELD conta-contab         AS CHAR FORMAT "X(20)" 
    FIELD centro-custo         AS CHAR FORMAT "X(20)" 
    FIELD cod-estabel          AS CHAR FORMAT "X(5)"  
    FIELD cod-especie          AS CHAR                
    FIELD tipo-fluxo           AS CHAR
    FIELD perc-custo           AS DECIMAL              /*MSG0142*/   
    FIELD perc-prov-meta       AS DECIMAL              /*MSG0142*/   
    FIELD guid-beneficio-canal AS CHAR FORMAT "X(36)"
       INDEX IDX-PRIMARY IS UNIQUE PRIMARY
            canal
            unid-neg
            tipo-beneficio.

DEF TEMP-TABLE tt-beneficio-aux LIKE tt-beneficio
    FIELD nome            AS CHAR FORMAT "X(30)"
    FIELD ds-tp-beneficio AS CHAR FORMAT "X(20)"
    FIELD c-status        AS CHAR FORMAT "X(10)" 
    FIELD r-rowid         AS ROWID.

DEFINE TEMP-TABLE tt-int-beneficio-hist NO-UNDO LIKE int-benef-canal-hist
    FIELD nome            AS CHAR FORMAT "X(30)"
    FIELD ds-tp-beneficio AS CHAR FORMAT "X(20)"
    FIELD c-status        AS CHAR FORMAT "X(10)" 
    FIELD r-rowid         AS ROWID.


DEF VAR i-canal      AS INTEGER INIT ? NO-UNDO.
DEF VAR c-nome-abrev AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brBeneficio

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-beneficio tt-int-beneficio-hist

/* Definitions for BROWSE brBeneficio                                   */
&Scoped-define FIELDS-IN-QUERY-brBeneficio tt-int-beneficio.canal tt-int-beneficio.nome tt-int-beneficio.unid-neg tt-int-beneficio.ds-tp-beneficio tt-int-beneficio.nome-class tt-int-beneficio.c-status tt-int-beneficio.Calcula-verba tt-int-beneficio.perc-global tt-int-beneficio.conta-contab tt-int-beneficio.centro-custo tt-int-beneficio.cod-especie tt-int-beneficio.cod-estab tt-int-beneficio.tipo-fluxo tt-int-beneficio.perc-custo tt-int-beneficio.perc-prov-meta tt-int-beneficio.guid-beneficio-canal   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brBeneficio   
&Scoped-define SELF-NAME brBeneficio
&Scoped-define QUERY-STRING-brBeneficio FOR EACH tt-int-beneficio
&Scoped-define OPEN-QUERY-brBeneficio OPEN QUERY {&SELF-NAME} FOR EACH tt-int-beneficio.
&Scoped-define TABLES-IN-QUERY-brBeneficio tt-int-beneficio
&Scoped-define FIRST-TABLE-IN-QUERY-brBeneficio tt-int-beneficio


/* Definitions for BROWSE brHistorico                                   */
&Scoped-define FIELDS-IN-QUERY-brHistorico tt-int-beneficio-hist.dt-trans tt-int-beneficio-hist.nome tt-int-beneficio-hist.Unid-neg tt-int-beneficio-hist.ds-tp-beneficio tt-int-beneficio-hist.nome-class tt-int-beneficio-hist.c-status tt-int-beneficio-hist.Calcula-verba tt-int-beneficio-hist.perc-global tt-int-beneficio-hist.conta-contab tt-int-beneficio-hist.centro-custo tt-int-beneficio-hist.cod-especie tt-int-beneficio-hist.cod-estab tt-int-beneficio-hist.tipo-fluxo tt-int-beneficio-hist.perc-custo tt-int-beneficio-hist.perc-prov-meta tt-int-beneficio-hist.guid-beneficio-canal   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brHistorico   
&Scoped-define SELF-NAME brHistorico
&Scoped-define QUERY-STRING-brHistorico FOR EACH tt-int-beneficio-hist BY tt-int-beneficio-hist.dt-trans DESC
&Scoped-define OPEN-QUERY-brHistorico OPEN QUERY {&SELF-NAME} FOR EACH tt-int-beneficio-hist BY tt-int-beneficio-hist.dt-trans DESC.
&Scoped-define TABLES-IN-QUERY-brHistorico tt-int-beneficio-hist
&Scoped-define FIRST-TABLE-IN-QUERY-brHistorico tt-int-beneficio-hist


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brBeneficio}~
    ~{&OPEN-QUERY-brHistorico}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rs-filtro fi-filtro-int fi-filtro-char ~
bt-filtro cb-status btOK rtToolBar RECT-1 RECT-2 RECT-3 brBeneficio ~
brHistorico 
&Scoped-Define DISPLAYED-OBJECTS rs-filtro fi-filtro-int fi-filtro-char ~
cb-status 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-filtro 
     IMAGE-UP FILE "adeicon/browse-u.bmp":U
     LABEL "Button 1" 
     SIZE 5 BY 1.13.

DEFINE BUTTON btOK 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-status AS CHARACTER FORMAT "X(256)":U 
     LABEL "Status" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "Todos","Ativos","Bloqueados","Suspensos" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fi-filtro-char AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .79 NO-UNDO.

DEFINE VARIABLE fi-filtro-int AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .79 NO-UNDO.

DEFINE VARIABLE rs-filtro AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Canal", 1,
"Nome Abreviado", 2
     SIZE 24 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 168 BY 11.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 168 BY 6.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 1.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 166 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brBeneficio FOR 
      tt-int-beneficio SCROLLING.

DEFINE QUERY brHistorico FOR 
      tt-int-beneficio-hist SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brBeneficio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brBeneficio wWindow _FREEFORM
  QUERY brBeneficio NO-LOCK DISPLAY
      tt-int-beneficio.canal                 COLUMN-LABEL "Canal"         WIDTH 7
   tt-int-beneficio.nome                  COLUMN-LABEL "NomeAbrev"     WIDTH 12
   tt-int-beneficio.unid-neg              COLUMN-LABEL "Unid Negoc"    WIDTH 7
   tt-int-beneficio.ds-tp-beneficio       COLUMN-LABEL "Benef°cio"     WIDTH 11
   tt-int-beneficio.nome-class            COLUMN-LABEL "Classificacao" WIDTH 15
   tt-int-beneficio.c-status              COLUMN-LABEL "Status"        WIDTH 10
   tt-int-beneficio.Calcula-verba         COLUMN-LABEL "Calc Verba?"   WIDTH 7
   tt-int-beneficio.perc-global           COLUMN-LABEL "% Global"      WIDTH 6
   tt-int-beneficio.conta-contab          COLUMN-LABEL "Conta"         WIDTH 8
   tt-int-beneficio.centro-custo          COLUMN-LABEL "CC"            WIDTH 6
   tt-int-beneficio.cod-especie           COLUMN-LABEL "Espec"         WIDTH 6
   tt-int-beneficio.cod-estab             COLUMN-LABEL "Estab"         WIDTH 6
   tt-int-beneficio.tipo-fluxo            COLUMN-LABEL "Tp-fluxo"      WIDTH 6
   tt-int-beneficio.perc-custo            COLUMN-LABEL "% Custo"       WIDTH 6
   tt-int-beneficio.perc-prov-meta        COLUMN-LABEL "% ProvMeta"    WIDTH 8
   tt-int-beneficio.guid-beneficio-canal  COLUMN-LABEL "GUID Benef Canal" FORMAT "X(42)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 165 BY 8.25
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brHistorico wWindow _FREEFORM
  QUERY brHistorico NO-LOCK DISPLAY
      tt-int-beneficio-hist.dt-trans             COLUMN-LABEL "Dt Atualizaá∆o"     WIDTH 14.5
   tt-int-beneficio-hist.nome                 COLUMN-LABEL "NomeAbrev"     WIDTH 10
   tt-int-beneficio-hist.Unid-neg             COLUMN-LABEL "Unid Negoc"    WIDTH 7
   tt-int-beneficio-hist.ds-tp-beneficio      COLUMN-LABEL "Benef°cio"     WIDTH 11
   tt-int-beneficio-hist.nome-class           COLUMN-LABEL "Classificacao" WIDTH 15
   tt-int-beneficio-hist.c-status             COLUMN-LABEL "Status"        WIDTH 12
   tt-int-beneficio-hist.Calcula-verba        COLUMN-LABEL "Calc Verba?"   WIDTH 7
   tt-int-beneficio-hist.perc-global          COLUMN-LABEL "% Global"      WIDTH 6
   tt-int-beneficio-hist.conta-contab         COLUMN-LABEL "Conta"         WIDTH 8
   tt-int-beneficio-hist.centro-custo         COLUMN-LABEL "CC"            WIDTH 6
   tt-int-beneficio-hist.cod-especie          COLUMN-LABEL "Espec"         WIDTH 6
   tt-int-beneficio-hist.cod-estab            COLUMN-LABEL "Estab"         WIDTH 6
   tt-int-beneficio-hist.tipo-fluxo           COLUMN-LABEL "Tp-fluxo"      WIDTH 6
   tt-int-beneficio-hist.perc-custo           COLUMN-LABEL "% Custo"       WIDTH 6
   tt-int-beneficio-hist.perc-prov-meta       COLUMN-LABEL "% ProvMeta"    WIDTH 8
   tt-int-beneficio-hist.guid-beneficio-canal COLUMN-LABEL "GUID Benef Canal" FORMAT "X(42)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 165 BY 5.5
         FONT 1 ROW-HEIGHT-CHARS .54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     rs-filtro AT ROW 1.92 COL 15 NO-LABEL WIDGET-ID 10
     fi-filtro-int AT ROW 1.92 COL 37.29 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     fi-filtro-char AT ROW 1.92 COL 37.29 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     bt-filtro AT ROW 1.75 COL 80.43 WIDGET-ID 20
     cb-status AT ROW 1.79 COL 148.72 COLON-ALIGNED WIDGET-ID 24
     btOK AT ROW 19.75 COL 81
     brBeneficio AT ROW 3.5 COL 4
     brHistorico AT ROW 13.25 COL 4 WIDGET-ID 100
     "Procurar por:" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 2 COL 5 WIDGET-ID 14
     "HIST‡RICO DE ATUALIZAÄÂES" VIEW-AS TEXT
          SIZE 25 BY .54 AT ROW 12.5 COL 4 WIDGET-ID 8
     rtToolBar AT ROW 19.5 COL 2
     RECT-1 AT ROW 1.25 COL 2
     RECT-2 AT ROW 12.75 COL 2 WIDGET-ID 6
     RECT-3 AT ROW 1.5 COL 4 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 169.57 BY 20.13
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
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 20.13
         WIDTH              = 169.57
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
/* BROWSE-TAB brBeneficio RECT-3 fpage0 */
/* BROWSE-TAB brHistorico brBeneficio fpage0 */
ASSIGN 
       brBeneficio:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE
       brBeneficio:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

ASSIGN 
       brHistorico:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE
       brHistorico:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brBeneficio
/* Query rebuild information for BROWSE brBeneficio
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-beneficio.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brBeneficio */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brHistorico
/* Query rebuild information for BROWSE brHistorico
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-beneficio-hist BY tt-int-beneficio-hist.dt-trans DESC.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brHistorico */
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


&Scoped-define BROWSE-NAME brBeneficio
&Scoped-define SELF-NAME brBeneficio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brBeneficio wWindow
ON MOUSE-SELECT-CLICK OF brBeneficio IN FRAME fpage0
DO:
  IF brBeneficio:NUM-SELECTED-ROWS > 0 THEN
        GET CURRENT brBeneficio.

    IF AVAIL tt-int-beneficio THEN
        ASSIGN r-rowid-tt-param = tt-int-beneficio.r-rowid.
    ELSE
        ASSIGN r-rowid-tt-param = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brBeneficio wWindow
ON START-SEARCH OF brBeneficio IN FRAME fpage0
DO:
  DEFINE VARIABLE i_count AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i_index AS INTEGER     NO-UNDO.

    SELF:CLEAR-SORT-ARROWS().

    IF SELF:CURRENT-COLUMN:TABLE = "":U OR
       SELF:CURRENT-COLUMN:TABLE = ?    THEN
        RETURN NO-APPLY.

    IF v_column <> SELF:CURRENT-COLUMN:NAME THEN
        ASSIGN v_column = SELF:CURRENT-COLUMN:NAME
               v_asc    = YES.
    ELSE
        ASSIGN v_asc = NOT v_asc.

    IF v_asc THEN
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME).
    ELSE
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC":U).
            
    DO i_count = 1 TO SELF:NUM-COLUMNS:
        IF SELF:CURRENT-COLUMN = SELF:GET-BROWSE-COLUMN(i_count) THEN
            ASSIGN i_index = i_count.
    END.

    SELF:SET-SORT-ARROW(i_index, v_asc).

    SELF:QUERY:QUERY-OPEN().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brBeneficio wWindow
ON VALUE-CHANGED OF brBeneficio IN FRAME fpage0
DO:

    IF  NOT AVAIL tt-int-beneficio THEN
        RETURN "OK".

    EMPTY TEMP-TABLE tt-int-beneficio-hist.

    FOR EACH int-beneficio-hist NO-LOCK
        WHERE int-beneficio-hist.canal          = tt-int-beneficio.canal
          AND int-beneficio-hist.unid-neg       = tt-int-beneficio.unid-neg
          AND int-beneficio-hist.tipo-beneficio = tt-int-beneficio.tipo-beneficio:

        CREATE tt-int-beneficio-hist.
        BUFFER-COPY int-beneficio-hist TO tt-int-beneficio-hist.

        ASSIGN tt-int-beneficio-hist.nome             = tt-int-beneficio.nome           
               tt-int-beneficio-hist.ds-tp-beneficio  = tt-int-beneficio.ds-tp-beneficio
               tt-int-beneficio-hist.c-status         = tt-int-beneficio.c-status       
               tt-int-beneficio-hist.r-rowid          = ROWID(int-beneficio-hist).      

    END.

     {&OPEN-QUERY-brHistorico}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brHistorico
&Scoped-define SELF-NAME brHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brHistorico wWindow
ON START-SEARCH OF brHistorico IN FRAME fpage0
DO:
  DEFINE VARIABLE i_count AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i_index AS INTEGER     NO-UNDO.

    SELF:CLEAR-SORT-ARROWS().

    IF SELF:CURRENT-COLUMN:TABLE = "":U OR
       SELF:CURRENT-COLUMN:TABLE = ?    THEN
        RETURN NO-APPLY.

    IF v_column <> SELF:CURRENT-COLUMN:NAME THEN
        ASSIGN v_column = SELF:CURRENT-COLUMN:NAME
               v_asc    = YES.
    ELSE
        ASSIGN v_asc = NOT v_asc.

    IF v_asc THEN
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME).
    ELSE
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC":U).
            
    DO i_count = 1 TO SELF:NUM-COLUMNS:
        IF SELF:CURRENT-COLUMN = SELF:GET-BROWSE-COLUMN(i_count) THEN
            ASSIGN i_index = i_count.
    END.

    SELF:SET-SORT-ARROW(i_index, v_asc).

    SELF:QUERY:QUERY-OPEN().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro wWindow
ON CHOOSE OF bt-filtro IN FRAME fpage0 /* Button 1 */
DO: 
    IF  fi-filtro-int:SCREEN-VALUE IN FRAME fpage0 <> ""
    AND fi-filtro-int:SCREEN-VALUE IN FRAME fpage0 <> ?
    AND fi-filtro-int:SCREEN-VALUE IN FRAME fpage0 <> "0" THEN DO:
        ASSIGN i-canal      = INT(fi-filtro-int:SCREEN-VALUE IN FRAME fpage0).
    END.
    ELSE
        ASSIGN i-canal       = ?
               c-nome-abrev  = ?.

    IF  i-canal <> ? THEN DO:
        FIND FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = i-canal NO-ERROR.
        IF  NOT AVAIL emitente THEN DO:
            run utp/ut-msgs.p (input "show":U, input 17006, input "C¢digo de Emitente n∆o cadastrado"). 
            RETURN "OK".
        END.
        ELSE i-canal = emitente.cod-emitente.
    END.


    IF  fi-filtro-char:SCREEN-VALUE IN FRAME fpage0 <> ""
    AND fi-filtro-char:SCREEN-VALUE IN FRAME fpage0 <> ? THEN DO:
        ASSIGN c-nome-abrev = fi-filtro-char:SCREEN-VALUE IN FRAME fpage0.
    END.
    ELSE
        ASSIGN c-nome-abrev  = ?.
    
    IF  c-nome-abrev <> ? THEN do:
        FIND FIRST emitente NO-LOCK
            WHERE emitente.nome-abrev = c-nome-abrev NO-ERROR.
        IF  NOT AVAIL emitente THEN DO:
            run utp/ut-msgs.p (input "show":U, input 17006, input "Nome Abreviado de Emitente n∆o cadastrado"). 
            RETURN "OK".
        END.
        ELSE i-canal = emitente.cod-emitente.

    END.

    RUN atualizarBrowse IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-status
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-status wWindow
ON VALUE-CHANGED OF cb-status IN FRAME fpage0 /* Status */
DO:
  RUN atualizarBrowse IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-filtro wWindow
ON VALUE-CHANGED OF rs-filtro IN FRAME fpage0
DO:

    ASSIGN fi-filtro-int:SCREEN-VALUE  IN FRAME fpage0 = "0".
           fi-filtro-char:SCREEN-VALUE IN FRAME fpage0 = "".

    IF  rs-filtro:SCREEN-VALUE = "1" THEN
        ASSIGN fi-filtro-char:VISIBLE = NO
               fi-filtro-int:VISIBLE = YES.
               
    ELSE
        ASSIGN fi-filtro-char:VISIBLE = YES
               fi-filtro-int:VISIBLE = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brBeneficio
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

    ENABLE brBeneficio WITH FRAME fpage0.

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

    ENABLE brHistorico rs-filtro  bt-filtro cb-status fi-filtro-char fi-filtro-int WITH FRAME fpage0.

    ASSIGN cb-status:SCREEN-VALUE IN FRAME fpage0 = "Todos".

    RUN atualizarBrowse IN THIS-PROCEDURE.

    ASSIGN fi-filtro-char:VISIBLE = NO
           fi-filtro-int:VISIBLE = YES.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizarBrowse wWindow 
PROCEDURE atualizarBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-int-beneficio.
    
    DEF VAR i-status     AS INTEGER NO-UNDO.

    CASE cb-status:SCREEN-VALUE IN FRAME fpage0:
        WHEN "Todos"      THEN ASSIGN i-status = 0.
        WHEN "Ativos"     THEN ASSIGN i-status = 1.
        WHEN "Bloqueados" THEN ASSIGN i-status = 2.
        WHEN "Suspensos"  THEN ASSIGN i-status = 3.
    END CASE.


    FOR EACH  int-beneficio NO-LOCK
        WHERE (IF i-canal      = ? THEN YES ELSE int-beneficio.canal     = i-canal)
          AND (IF i-status     = 0 THEN YES ELSE int-beneficio.id-status = i-status)
        , FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = int-beneficio.canal:
            
        CREATE tt-int-beneficio.
        BUFFER-COPY int-beneficio TO tt-int-beneficio.
        ASSIGN tt-int-beneficio.r-rowid = ROWID(int-beneficio).

        CASE tt-int-beneficio.tipo-beneficio:
            WHEN 21 THEN
                ASSIGN tt-int-beneficio.ds-tp-beneficio = "VMC".
            WHEN 22 THEN
                ASSIGN tt-int-beneficio.ds-tp-beneficio = "Stock Rotation".
            WHEN 37 THEN
                ASSIGN tt-int-beneficio.ds-tp-beneficio = "Rebate".
            WHEN 66 THEN
                ASSIGN tt-int-beneficio.ds-tp-beneficio = "Rebate P¢s-Venda".
            WHEN 08 THEN
                ASSIGN tt-int-beneficio.ds-tp-beneficio = "Price Protection".
            WHEN 04 THEN
                ASSIGN tt-int-beneficio.ds-tp-beneficio = "Show Room".
            WHEN 15 THEN
                ASSIGN tt-int-beneficio.ds-tp-beneficio = "Stock Backup".

        END CASE.


        /* STATUS DO BENEF÷CIO */
        CASE tt-int-beneficio.id-status:
            WHEN 1           THEN ASSIGN tt-int-beneficio.c-status = "ATIVO".
            WHEN 2           THEN ASSIGN tt-int-beneficio.c-status = "BLOQUEADO".
            WHEN 3           THEN ASSIGN tt-int-beneficio.c-status = "SUSPENSO".
            OTHERWISE ASSIGN tt-int-beneficio.c-status = "INDEFINIDO".
        END CASE.

        ASSIGN tt-int-beneficio.nome = emitente.nome-abrev.

    END.
        
    {&OPEN-QUERY-brBeneficio}

    APPLY "VALUE-CHANGED" TO brBeneficio IN FRAME fpage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

