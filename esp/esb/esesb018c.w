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
{include/i-prgvrs.i ESESB018C 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESESB0018C
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

DEF TEMP-TABLE tt-int-benef-canal-perc  LIKE int-benef-canal-perc
    FIELD des-beneficio AS CHAR FORMAT "x(20)"
    FIELD des-situacao    AS CHAR FORMAT "x(20)".

DEF TEMP-TABLE tt-int-benef-canal-perc-hist  LIKE int-benef-canal-perc-hist
        FIELD des-beneficio AS CHAR FORMAT "x(20)"
        FIELD des-situacao    AS CHAR FORMAT "x(20)".

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
&Scoped-define INTERNAL-TABLES tt-int-benef-canal-perc ~
tt-int-benef-canal-perc-hist

/* Definitions for BROWSE brBeneficio                                   */
&Scoped-define FIELDS-IN-QUERY-brBeneficio tt-int-benef-canal-perc.CodigoParametroGlobal tt-int-benef-canal-perc.dt-trans tt-int-benef-canal-perc.NomeParametroGlobal tt-int-benef-canal-perc.CodigoUnidadeNegocio tt-int-benef-canal-perc.TipoParametroGlobal tt-int-benef-canal-perc.CodigoClassificacao tt-int-benef-canal-perc.CodigoCompromisso tt-int-benef-canal-perc.CodigoCategoria tt-int-benef-canal-perc.CategoriaCodigo tt-int-benef-canal-perc.CodigoBeneficio tt-int-benef-canal-perc.des-beneficio tt-int-benef-canal-perc.CodigoNivelPosVenda tt-int-benef-canal-perc.CodigoUnidadeNegocio tt-int-benef-canal-perc.TipoDado tt-int-benef-canal-perc.ValorParametroGlobal tt-int-benef-canal-perc.des-Situacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brBeneficio   
&Scoped-define SELF-NAME brBeneficio
&Scoped-define QUERY-STRING-brBeneficio FOR EACH tt-int-benef-canal-perc
&Scoped-define OPEN-QUERY-brBeneficio OPEN QUERY {&SELF-NAME} FOR EACH tt-int-benef-canal-perc.
&Scoped-define TABLES-IN-QUERY-brBeneficio tt-int-benef-canal-perc
&Scoped-define FIRST-TABLE-IN-QUERY-brBeneficio tt-int-benef-canal-perc


/* Definitions for BROWSE brHistorico                                   */
&Scoped-define FIELDS-IN-QUERY-brHistorico tt-int-benef-canal-perc-hist.dt-trans tt-int-benef-canal-perc-hist.NomeParametroGlobal tt-int-benef-canal-perc-hist.CodigoClassificacao tt-int-benef-canal-perc-hist.CodigoCompromisso tt-int-benef-canal-perc-hist.CodigoCategoria tt-int-benef-canal-perc-hist.CategoriaCodigo tt-int-benef-canal-perc-hist.CodigoBeneficio tt-int-benef-canal-perc-hist.des-beneficio tt-int-benef-canal-perc-hist.CodigoNivelPosVenda tt-int-benef-canal-perc-hist.CodigoUnidadeNegocio tt-int-benef-canal-perc-hist.TipoDado tt-int-benef-canal-perc-hist.ValorParametroGlobal tt-int-benef-canal-perc-hist.des-Situacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brHistorico   
&Scoped-define SELF-NAME brHistorico
&Scoped-define QUERY-STRING-brHistorico FOR EACH tt-int-benef-canal-perc-hist                                     BY tt-int-benef-canal-perc-hist.dt-trans DESC
&Scoped-define OPEN-QUERY-brHistorico OPEN QUERY {&SELF-NAME} FOR EACH tt-int-benef-canal-perc-hist                                     BY tt-int-benef-canal-perc-hist.dt-trans DESC.
&Scoped-define TABLES-IN-QUERY-brHistorico tt-int-benef-canal-perc-hist
&Scoped-define FIRST-TABLE-IN-QUERY-brHistorico tt-int-benef-canal-perc-hist


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brBeneficio}~
    ~{&OPEN-QUERY-brHistorico}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-total brBeneficio ed-alt-1 ed-alt-2 btOK ~
rtToolBar brHistorico RECT-2 RECT-4 
&Scoped-Define DISPLAYED-OBJECTS fi-total ed-alt-1 ed-alt-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btOK 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE VARIABLE ed-alt-1 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 85 BY 2.83 NO-UNDO.

DEFINE VARIABLE ed-alt-2 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 84 BY 2.83 NO-UNDO.

DEFINE VARIABLE fi-total AS CHARACTER FORMAT "X(256)":U 
     LABEL "Total" 
      VIEW-AS TEXT 
     SIZE 19 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 131 BY 10.21.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 131 BY 10.63.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 131 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brBeneficio FOR 
      tt-int-benef-canal-perc SCROLLING.

DEFINE QUERY brHistorico FOR 
      tt-int-benef-canal-perc-hist SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brBeneficio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brBeneficio wWindow _FREEFORM
  QUERY brBeneficio NO-LOCK DISPLAY
      tt-int-benef-canal-perc.CodigoParametroGlobal     COLUMN-LABEL "Guid Param Global"        WIDTH 14
       tt-int-benef-canal-perc.dt-trans                  COLUMN-LABEL "Atualiz. Vigente"  FORMAT "99/99/9999 HH:MM" WIDTH 13
       tt-int-benef-canal-perc.NomeParametroGlobal       COLUMN-LABEL "Nome Parametro"      WIDTH 15       tt-int-benef-canal-perc.CodigoUnidadeNegocio      COLUMN-LABEL "Unidade"          WIDTH 6
       tt-int-benef-canal-perc.TipoParametroGlobal       COLUMN-LABEL "Tipo"             WIDTH 6
       tt-int-benef-canal-perc.CodigoClassificacao       COLUMN-LABEL "Classific"        WIDTH 8
       tt-int-benef-canal-perc.CodigoCompromisso         COLUMN-LABEL "Compromisso"      WIDTH 8
       tt-int-benef-canal-perc.CodigoCategoria           COLUMN-LABEL "Cod Categoria"    WIDTH 9
       tt-int-benef-canal-perc.CategoriaCodigo           COLUMN-LABEL "Categ Cod."       WIDTH 9
       tt-int-benef-canal-perc.CodigoBeneficio           COLUMN-LABEL "Guid Benef"       WIDTH 8
       tt-int-benef-canal-perc.des-beneficio             COLUMN-LABEL "Nome"             WIDTH 12
       tt-int-benef-canal-perc.CodigoNivelPosVenda       COLUMN-LABEL "Cd N¡vel P¢sVen." WIDTH 11
       tt-int-benef-canal-perc.CodigoUnidadeNegocio      COLUMN-LABEL "Unidade"          WIDTH 7
       tt-int-benef-canal-perc.TipoDado                  COLUMN-LABEL "Tipo Dado"        WIDTH 10
       tt-int-benef-canal-perc.ValorParametroGlobal      COLUMN-LABEL "Valor"            WIDTH 10
       tt-int-benef-canal-perc.des-Situacao              COLUMN-LABEL "Situa‡Æo"         WIDTH 8
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 129 BY 6.75
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brHistorico wWindow _FREEFORM
  QUERY brHistorico NO-LOCK DISPLAY
      tt-int-benef-canal-perc-hist.dt-trans                  COLUMN-LABEL "Atualiz Anteriores"  FORMAT "99/99/9999 HH:MM" WIDTH 13
       tt-int-benef-canal-perc-hist.NomeParametroGlobal       COLUMN-LABEL "Nome Parametro"   WIDTH 15       
       tt-int-benef-canal-perc-hist.CodigoClassificacao       COLUMN-LABEL "Classific"        WIDTH 8
       tt-int-benef-canal-perc-hist.CodigoCompromisso         COLUMN-LABEL "Compromisso"      WIDTH 8
       tt-int-benef-canal-perc-hist.CodigoCategoria           COLUMN-LABEL "Cod Categoria"    WIDTH 9
       tt-int-benef-canal-perc-hist.CategoriaCodigo           COLUMN-LABEL "Categ Cod."       WIDTH 9
       tt-int-benef-canal-perc-hist.CodigoBeneficio           COLUMN-LABEL "Guid Benef"       WIDTH 8
       tt-int-benef-canal-perc-hist.des-beneficio             COLUMN-LABEL "Nome"             WIDTH 12
       tt-int-benef-canal-perc-hist.CodigoNivelPosVenda       COLUMN-LABEL "Cd N¡vel P¢sVen." WIDTH 11
       tt-int-benef-canal-perc-hist.CodigoUnidadeNegocio      COLUMN-LABEL "Unidade"          WIDTH 7
       tt-int-benef-canal-perc-hist.TipoDado                  COLUMN-LABEL "Tipo Dado"        WIDTH 10
       tt-int-benef-canal-perc-hist.ValorParametroGlobal      COLUMN-LABEL "Valor"            WIDTH 10
       tt-int-benef-canal-perc-hist.des-Situacao              COLUMN-LABEL "Situa‡Æo"         WIDTH 8
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 129 BY 6.25
         FONT 1 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-total AT ROW 11 COL 5 COLON-ALIGNED WIDGET-ID 46
     brBeneficio AT ROW 2 COL 3
     ed-alt-1 AT ROW 9 COL 47 NO-LABEL WIDGET-ID 38
     ed-alt-2 AT ROW 20 COL 48 NO-LABEL WIDGET-ID 40
     btOK AT ROW 23.25 COL 61.43
     brHistorico AT ROW 13.5 COL 3 WIDGET-ID 100
     "Hest¢rico de Atualiza‡äes:" VIEW-AS TEXT
          SIZE 19 BY .54 AT ROW 12.67 COL 4 WIDGET-ID 8
     "PAR¶METROS GLOBAIS BENEFICIOS VIGENTES  (MSG0167)" VIEW-AS TEXT
          SIZE 44.57 BY .54 AT ROW 1.25 COL 43 WIDGET-ID 36
     "éltimas Altera‡äes Ocorridas:" VIEW-AS TEXT
          SIZE 20 BY .54 AT ROW 10.13 COL 26.57 WIDGET-ID 42
     "Altera‡äes em rela‡Æo ao registro anterior:" VIEW-AS TEXT
          SIZE 29.29 BY .54 AT ROW 21.17 COL 18.72 WIDGET-ID 44
     rtToolBar AT ROW 23 COL 2
     RECT-2 AT ROW 13 COL 2 WIDGET-ID 6
     RECT-4 AT ROW 1.63 COL 2 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 133 BY 23.63
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
         HEIGHT             = 23.63
         WIDTH              = 133.29
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
/* BROWSE-TAB brBeneficio 1 fpage0 */
/* BROWSE-TAB brHistorico rtToolBar fpage0 */
ASSIGN 
       brBeneficio:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE
       brBeneficio:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

ASSIGN 
       brHistorico:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE
       brHistorico:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

ASSIGN 
       ed-alt-1:READ-ONLY IN FRAME fpage0        = TRUE.

ASSIGN 
       ed-alt-2:READ-ONLY IN FRAME fpage0        = TRUE.

ASSIGN 
       fi-total:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brBeneficio
/* Query rebuild information for BROWSE brBeneficio
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-benef-canal-perc.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brBeneficio */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brHistorico
/* Query rebuild information for BROWSE brHistorico
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-benef-canal-perc-hist
                                    BY tt-int-benef-canal-perc-hist.dt-trans DESC.
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
ON LEFT-MOUSE-DBLCLICK OF brBeneficio IN FRAME fpage0
DO:
  
   IF AVAIL tt-int-benef-canal-perc THEN
       MESSAGE "Codigo Benef¡cio: " tt-int-benef-canal-perc.CodigoBeneficio
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brBeneficio wWindow
ON MOUSE-SELECT-CLICK OF brBeneficio IN FRAME fpage0
DO:
/*   IF brBeneficio:NUM-SELECTED-ROWS > 0 THEN                 */
/*         GET CURRENT brBeneficio.                            */
/*                                                             */
/*     IF AVAIL tt-int-benef-canal-perc THEN                          */
/*         ASSIGN r-rowid-tt-param = tt-int-benef-canal-perc.r-rowid. */
/*     ELSE                                                    */
/*         ASSIGN r-rowid-tt-param = ?.                        */
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

    EMPTY TEMP-TABLE tt-int-benef-canal-perc-hist.

    IF  NOT AVAIL tt-int-benef-canal-perc THEN
        RETURN "OK".

    ED-ALT-1:SCREEN-VALUE IN FRAME fpage0 = tt-int-benef-canal-perc.alteracoes.

    FOR EACH int-benef-canal-perc-hist NO-LOCK
        WHERE int-benef-canal-perc-hist.CodigoParametroGlobal = tt-int-benef-canal-perc.CodigoParametroGlobal
        /*
          AND int-benef-canal-perc-hist.dt-trans        >= DATETIME(dt-alt-ini:SCREEN-VALUE IN FRAME fpage0)
          AND int-benef-canal-perc-hist.dt-trans        <= DATETIME(dt-alt-fim:SCREEN-VALUE IN FRAME fpage0)
          */:

        CREATE tt-int-benef-canal-perc-hist.
        BUFFER-COPY int-benef-canal-perc-hist TO tt-int-benef-canal-perc-hist.
        
        CASE tt-int-benef-canal-perc-hist.BeneficioCodigo:
            WHEN 21 THEN ASSIGN tt-int-benef-canal-perc-hist.des-beneficio = "VMC".
            WHEN 22 THEN ASSIGN tt-int-benef-canal-perc-hist.des-beneficio = "Stock Rotation".
            WHEN 37 THEN ASSIGN tt-int-benef-canal-perc-hist.des-beneficio = "Rebate".
            WHEN 66 THEN ASSIGN tt-int-benef-canal-perc-hist.des-beneficio = "Rebate P¢s-Venda".
            WHEN 08 THEN ASSIGN tt-int-benef-canal-perc-hist.des-beneficio = "Price Protection".
            WHEN 04 THEN ASSIGN tt-int-benef-canal-perc-hist.des-beneficio = "Show Room".
            WHEN 15 THEN ASSIGN tt-int-benef-canal-perc-hist.des-beneficio = "Stock Backup".
        END CASE.


        /* STATUS DO BENEFÖCIO */
        CASE tt-int-benef-canal-perc-hist.Situacao:
            WHEN 0 THEN ASSIGN tt-int-benef-canal-perc-hist.des-Situacao = "ATIVO".
            WHEN 1 THEN ASSIGN tt-int-benef-canal-perc-hist.des-Situacao = "INATIVO".
        END CASE.

    END.

   {&OPEN-QUERY-brHistorico}
        
   IF  AVAIL tt-int-benef-canal-perc-hist THEN 
        APPLY "value-changed" TO brHistorico IN FRAME fpage0.
    
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brHistorico wWindow
ON VALUE-CHANGED OF brHistorico IN FRAME fpage0
DO:
    ED-ALT-2:SCREEN-VALUE IN FRAME fpage0 = tt-int-benef-canal-perc-hist.alteracoes.
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


&Scoped-define BROWSE-NAME brBeneficio
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
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

    ENABLE brHistorico BrBeneficio WITH FRAME fpage0.

    ASSIGN ed-alt-1:SENSITIVE = YES
           ed-alt-2:SENSITIVE = YES.
           
    RUN atualizarBrowse IN THIS-PROCEDURE.


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

    EMPTY TEMP-TABLE tt-int-benef-canal-perc.
    
    DEF VAR i AS INTEGER NO-UNDO.

    FOR EACH  int-benef-canal-perc NO-LOCK:
            
        CREATE tt-int-benef-canal-perc.
        BUFFER-COPY int-benef-canal-perc TO tt-int-benef-canal-perc.

        CASE tt-int-benef-canal-perc.beneficioCodigo:
            WHEN 21 THEN ASSIGN tt-int-benef-canal-perc.des-beneficio = "VMC".
            WHEN 22 THEN ASSIGN tt-int-benef-canal-perc.des-beneficio = "Stock Rotation".
            WHEN 37 THEN ASSIGN tt-int-benef-canal-perc.des-beneficio = "Rebate".
            WHEN 66 THEN ASSIGN tt-int-benef-canal-perc.des-beneficio = "Rebate P¢s-Venda".
            WHEN 08 THEN ASSIGN tt-int-benef-canal-perc.des-beneficio = "Price Protection".
            WHEN 04 THEN ASSIGN tt-int-benef-canal-perc.des-beneficio = "Show Room".
            WHEN 15 THEN ASSIGN tt-int-benef-canal-perc.des-beneficio = "Stock Backup".
        END CASE.

        /* STATUS DO BENEFÖCIO */
        CASE tt-int-benef-canal-perc.Situacao:
            WHEN 0           THEN ASSIGN tt-int-benef-canal-perc.des-Situacao = "ATIVO".
            WHEN 1           THEN ASSIGN tt-int-benef-canal-perc.des-Situacao = "INATIVO".
        END CASE.
        i = i + 1.
    END.
        
    ASSIGN fi-total:SCREEN-VALUE IN FRAME fpage0 = STRING(i) + " registros." .

    {&OPEN-QUERY-brBeneficio}

    APPLY "VALUE-CHANGED" TO brBeneficio IN FRAME fpage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

