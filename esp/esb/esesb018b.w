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
{include/i-prgvrs.i ESESB018B 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESESB0018B
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

DEF TEMP-TABLE tt-int-benef-canal  LIKE int-benef-canal
    FIELD ds-tp-beneficio AS CHAR FORMAT "x(20)"
    FIELD des-situacao    AS CHAR FORMAT "x(20)".

DEF TEMP-TABLE tt-int-benef-canal-hist  LIKE int-benef-canal-hist
    FIELD ds-tp-beneficio AS CHAR FORMAT "x(20)"
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
&Scoped-define INTERNAL-TABLES tt-int-benef-canal tt-int-benef-canal-hist

/* Definitions for BROWSE brBeneficio                                   */
&Scoped-define FIELDS-IN-QUERY-brBeneficio tt-int-benef-canal.ds-tp-beneficio tt-int-benef-canal.dt-trans tt-int-benef-canal.cod-emitente tt-int-benef-canal.CodigoBeneficio tt-int-benef-canal.BeneficioCodigo tt-int-benef-canal.CodigoCategoria tt-int-benef-canal.CategoriaCodigo tt-int-benef-canal.CodigoUnidadeNegocio FN-STATUS(tt-int-benef-canal.CodigoStatusBeneficio) tt-int-benef-canal.CalcularVerba tt-int-benef-canal.AcumularVerba tt-int-benef-canal.PassivelSolicitacao tt-int-benef-canal.PossuiControleContaCorrente tt-int-benef-canal.des-Situacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brBeneficio   
&Scoped-define SELF-NAME brBeneficio
&Scoped-define QUERY-STRING-brBeneficio FOR EACH tt-int-benef-canal
&Scoped-define OPEN-QUERY-brBeneficio OPEN QUERY {&SELF-NAME} FOR EACH tt-int-benef-canal.
&Scoped-define TABLES-IN-QUERY-brBeneficio tt-int-benef-canal
&Scoped-define FIRST-TABLE-IN-QUERY-brBeneficio tt-int-benef-canal


/* Definitions for BROWSE brHistorico                                   */
&Scoped-define FIELDS-IN-QUERY-brHistorico tt-int-benef-canal-hist.dt-trans tt-int-benef-canal-hist.cod-emitente tt-int-benef-canal-hist.CodigoBeneficio tt-int-benef-canal-hist.BeneficioCodigo tt-int-benef-canal-hist.CodigoCategoria tt-int-benef-canal-hist.CategoriaCodigo tt-int-benef-canal-hist.CodigoUnidadeNegocio FN-STATUS(tt-int-benef-canal-hist.CodigoStatusBeneficio) tt-int-benef-canal-hist.CalcularVerba tt-int-benef-canal-hist.AcumularVerba tt-int-benef-canal-hist.PassivelSolicitacao tt-int-benef-canal-hist.PossuiControleContaCorrente tt-int-benef-canal-hist.des-Situacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brHistorico   
&Scoped-define SELF-NAME brHistorico
&Scoped-define QUERY-STRING-brHistorico FOR EACH tt-int-benef-canal-hist                                     BY tt-int-benef-canal-hist.dt-trans DESC
&Scoped-define OPEN-QUERY-brHistorico OPEN QUERY {&SELF-NAME} FOR EACH tt-int-benef-canal-hist                                     BY tt-int-benef-canal-hist.dt-trans DESC.
&Scoped-define TABLES-IN-QUERY-brHistorico tt-int-benef-canal-hist
&Scoped-define FIRST-TABLE-IN-QUERY-brHistorico tt-int-benef-canal-hist


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


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-status wWindow 
FUNCTION fn-status RETURNS CHARACTER
  ( INPUT p-status AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
     SIZE 17 BY .67 NO-UNDO.

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
      tt-int-benef-canal SCROLLING.

DEFINE QUERY brHistorico FOR 
      tt-int-benef-canal-hist SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brBeneficio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brBeneficio wWindow _FREEFORM
  QUERY brBeneficio NO-LOCK DISPLAY
      tt-int-benef-canal.ds-tp-beneficio             COLUMN-LABEL "Benef¡cio"        WIDTH 13
       tt-int-benef-canal.dt-trans                    COLUMN-LABEL "Atualiz. Vigente"  FORMAT "99/99/9999 HH:MM" WIDTH 13
       tt-int-benef-canal.cod-emitente                COLUMN-LABEL "Canal"            WIDTH 8
       tt-int-benef-canal.CodigoBeneficio             COLUMN-LABEL "Guid Benef."      WIDTH 9
       tt-int-benef-canal.BeneficioCodigo             COLUMN-LABEL "C¢digo"           WIDTH 7
       tt-int-benef-canal.CodigoCategoria             COLUMN-LABEL "Guid Categ."      WIDTH 9
       tt-int-benef-canal.CategoriaCodigo             COLUMN-LABEL "Categoria "       WIDTH 8
       tt-int-benef-canal.CodigoUnidadeNegocio        COLUMN-LABEL "Unidade"          WIDTH 6
       FN-STATUS(tt-int-benef-canal.CodigoStatusBeneficio)       COLUMN-LABEL "Status"           WIDTH 8
       tt-int-benef-canal.CalcularVerba               COLUMN-LABEL "Calc Verba"       WIDTH 8.5
       tt-int-benef-canal.AcumularVerba               COLUMN-LABEL "Acum Verba"       WIDTH 8.5
       tt-int-benef-canal.PassivelSolicitacao         COLUMN-LABEL "Pass¡vel Solic"   WIDTH 10
       tt-int-benef-canal.PossuiControleContaCorrente COLUMN-LABEL "Controle C.Corr." WIDTH 11
       tt-int-benef-canal.des-Situacao                COLUMN-LABEL "Situa‡Æo"         WIDTH 8
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 129 BY 6.75
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brHistorico wWindow _FREEFORM
  QUERY brHistorico NO-LOCK DISPLAY
      tt-int-benef-canal-hist.dt-trans                    COLUMN-LABEL "Atualiz. Vigente"  FORMAT "99/99/9999 HH:MM" WIDTH 13
       tt-int-benef-canal-hist.cod-emitente                COLUMN-LABEL "Canal"            WIDTH 8
       tt-int-benef-canal-hist.CodigoBeneficio             COLUMN-LABEL "Guid Benef."      WIDTH 9
       tt-int-benef-canal-hist.BeneficioCodigo             COLUMN-LABEL "C¢digo"           WIDTH 7
       tt-int-benef-canal-hist.CodigoCategoria             COLUMN-LABEL "Guid Categ."      WIDTH 9
       tt-int-benef-canal-hist.CategoriaCodigo             COLUMN-LABEL "Categoria "       WIDTH 8
       tt-int-benef-canal-hist.CodigoUnidadeNegocio        COLUMN-LABEL "Unidade"          WIDTH 6
       FN-STATUS(tt-int-benef-canal-hist.CodigoStatusBeneficio)       COLUMN-LABEL "Status"           WIDTH 8
       tt-int-benef-canal-hist.CalcularVerba               COLUMN-LABEL "Calc Verba"       WIDTH 8.5
       tt-int-benef-canal-hist.AcumularVerba               COLUMN-LABEL "Acum Verba"       WIDTH 8.5
       tt-int-benef-canal-hist.PassivelSolicitacao         COLUMN-LABEL "Pass¡vel Solic"   WIDTH 10
       tt-int-benef-canal-hist.PossuiControleContaCorrente COLUMN-LABEL "Controle C.Corr." WIDTH 11
       tt-int-benef-canal-hist.des-Situacao                COLUMN-LABEL "Situa‡Æo"         WIDTH 8
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
     "BENEFÖCIOS VIGENTES" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 1.25 COL 57 WIDGET-ID 36
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
         WIDTH              = 133.14
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
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-benef-canal.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brBeneficio */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brHistorico
/* Query rebuild information for BROWSE brHistorico
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-benef-canal-hist
                                    BY tt-int-benef-canal-hist.dt-trans DESC.
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
  
   IF AVAIL tt-int-benef-canal THEN
       MESSAGE "Codigo Benef¡cio: " tt-int-benef-canal.CodigoBeneficio
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
/*     IF AVAIL tt-int-benef-param THEN                          */
/*         ASSIGN r-rowid-tt-param = tt-int-benef-param.r-rowid. */
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

    EMPTY TEMP-TABLE tt-int-benef-canal-hist.

    IF  NOT AVAIL tt-int-benef-canal THEN DO:
        {&OPEN-QUERY-brHistorico}
        RETURN "OK".
    END.
        

    ED-ALT-1:SCREEN-VALUE IN FRAME fpage0 = tt-int-benef-canal.alteracoes.

    FOR EACH int-benef-canal-hist NO-LOCK
        WHERE int-benef-canal-hist.CodigoBeneficioCanal = tt-int-benef-canal.CodigoBeneficioCanal:

        CREATE tt-int-benef-canal-hist.
        BUFFER-COPY int-benef-canal-hist TO tt-int-benef-canal-hist.
        
        CASE tt-int-benef-canal-hist.BeneficioCodigo:
            WHEN 21 THEN ASSIGN tt-int-benef-canal-hist.ds-tp-beneficio = "VMC".
            WHEN 22 THEN ASSIGN tt-int-benef-canal-hist.ds-tp-beneficio = "Stock Rotation".
            WHEN 37 THEN ASSIGN tt-int-benef-canal-hist.ds-tp-beneficio = "Rebate".
            WHEN 66 THEN ASSIGN tt-int-benef-canal-hist.ds-tp-beneficio = "Rebate P¢s-Venda".
            WHEN 08 THEN ASSIGN tt-int-benef-canal-hist.ds-tp-beneficio = "Price Protection".
            WHEN 04 THEN ASSIGN tt-int-benef-canal-hist.ds-tp-beneficio = "Show Room".
            WHEN 15 THEN ASSIGN tt-int-benef-canal-hist.ds-tp-beneficio = "Stock Backup".
        END CASE.


        /* STATUS DO BENEFÖCIO */
        CASE tt-int-benef-canal-hist.Situacao:
            WHEN 0 THEN ASSIGN tt-int-benef-canal-hist.des-Situacao = "ATIVO".
            WHEN 1 THEN ASSIGN tt-int-benef-canal-hist.des-Situacao = "INATIVO".
        END CASE.

    END.

     {&OPEN-QUERY-brHistorico}

     IF  AVAIL tt-int-benef-canal-hist THEN
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
    ED-ALT-2:SCREEN-VALUE IN FRAME fpage0 = tt-int-benef-canal-hist.alteracoes.
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

    EMPTY TEMP-TABLE tt-int-benef-canal.
    
    DEF VAR i AS INTEGER NO-UNDO.

    FOR EACH int-benef-canal NO-LOCK
       , FIRST int-emitente NO-LOCK
            WHERE int-emitente.cod-guid = int-benef-canal.CodigoConta:
            
        CREATE tt-int-benef-canal.
        BUFFER-COPY int-benef-canal TO tt-int-benef-canal.


        ASSIGN tt-int-benef-canal.cod-emitente = int-emitente.cod-emitente.    

        CASE tt-int-benef-canal.BeneficioCodigo:
            WHEN 21 THEN ASSIGN tt-int-benef-canal.ds-tp-beneficio = "VMC".
            WHEN 22 THEN ASSIGN tt-int-benef-canal.ds-tp-beneficio = "Stock Rotation".
            WHEN 37 THEN ASSIGN tt-int-benef-canal.ds-tp-beneficio = "Rebate".
            WHEN 66 THEN ASSIGN tt-int-benef-canal.ds-tp-beneficio = "Rebate P¢s-Venda".
            WHEN 08 THEN ASSIGN tt-int-benef-canal.ds-tp-beneficio = "Price Protection".
            WHEN 04 THEN ASSIGN tt-int-benef-canal.ds-tp-beneficio = "Show Room".
            WHEN 15 THEN ASSIGN tt-int-benef-canal.ds-tp-beneficio = "Stock Backup".
        END CASE.

        /* STATUS DO BENEFÖCIO */
        CASE tt-int-benef-canal.Situacao:
            WHEN 0           THEN ASSIGN tt-int-benef-canal.des-Situacao = "ATIVO".
            WHEN 1           THEN ASSIGN tt-int-benef-canal.des-Situacao = "INATIVO".
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-status wWindow 
FUNCTION fn-status RETURNS CHARACTER
  ( INPUT p-status AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE p-status:
      WHEN '35fc4a26-75ed-e311-9407-00155d013d38' THEN RETURN "ATIVO".
      WHEN 'e1654a30-75ed-e311-9407-00155d013d38' THEN RETURN "SUSPENSO".
      WHEN 'e0654a30-75ed-e311-9407-00155d013d38' THEN RETURN "BLOQUEADO".
      OTHERWISE RETURN "".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

