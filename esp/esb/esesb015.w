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
{include/i-prgvrs.i ESESB015 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESESB0015
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


DEFINE TEMP-TABLE tt-param-nat NO-UNDO LIKE int-param-nat-oper-benef
    FIELD ds-tp-beneficio AS CHAR FORMAT "X(16)"
    FIELD r-rowid AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brParam

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-param-nat

/* Definitions for BROWSE brParam                                       */
&Scoped-define FIELDS-IN-QUERY-brParam tt-param-nat.estado-origem tt-param-nat.cidade-destino tt-param-nat.estado-destino tt-param-nat.ds-tp-beneficio tt-param-nat.nat-operacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brParam   
&Scoped-define SELF-NAME brParam
&Scoped-define QUERY-STRING-brParam FOR EACH tt-param-nat
&Scoped-define OPEN-QUERY-brParam OPEN QUERY {&SELF-NAME} FOR EACH tt-param-nat.
&Scoped-define TABLES-IN-QUERY-brParam tt-param-nat
&Scoped-define FIRST-TABLE-IN-QUERY-brParam tt-param-nat


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brParam}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 brParam btIncluir btAlterar ~
btEliminar btOK 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btAlterar 
     LABEL "&Modificar" 
     SIZE 9.72 BY 1 TOOLTIP "Eliminar E-mail".

DEFINE BUTTON btEliminar 
     LABEL "&Eliminar" 
     SIZE 9.72 BY 1 TOOLTIP "Eliminar E-mail".

DEFINE BUTTON btIncluir 
     LABEL "&Incluir" 
     SIZE 9.72 BY 1 TOOLTIP "Eliminar E-mail".

DEFINE BUTTON btOK 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 14.83.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90.43 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brParam FOR 
      tt-param-nat SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brParam wWindow _FREEFORM
  QUERY brParam NO-LOCK DISPLAY
      tt-param-nat.estado-origem
   tt-param-nat.cidade-destino
   tt-param-nat.estado-destino  COLUMN-LABEL "UF Destino"
   tt-param-nat.ds-tp-beneficio COLUMN-LABEL "Benef¡cio"
   tt-param-nat.nat-operacao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 85.14 BY 12.83
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     brParam AT ROW 1.75 COL 4.57
     btIncluir AT ROW 14.71 COL 4.43 WIDGET-ID 2
     btAlterar AT ROW 14.71 COL 14.29 WIDGET-ID 4
     btEliminar AT ROW 14.71 COL 24.14
     btOK AT ROW 16.71 COL 2.57
     rtToolBar AT ROW 16.5 COL 1.57
     RECT-1 AT ROW 1.25 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.72 BY 17
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
         HEIGHT             = 17.08
         WIDTH              = 92.14
         MAX-HEIGHT         = 17.08
         MAX-WIDTH          = 92.14
         VIRTUAL-HEIGHT     = 17.08
         VIRTUAL-WIDTH      = 92.14
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
/* BROWSE-TAB brParam RECT-1 fpage0 */
ASSIGN 
       brParam:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE
       brParam:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brParam
/* Query rebuild information for BROWSE brParam
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-param-nat.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brParam */
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


&Scoped-define BROWSE-NAME brParam
&Scoped-define SELF-NAME brParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brParam wWindow
ON MOUSE-SELECT-CLICK OF brParam IN FRAME fpage0
DO:
  IF brParam:NUM-SELECTED-ROWS > 0 THEN
        GET CURRENT brParam.

    IF AVAIL tt-param-nat THEN
        ASSIGN r-rowid-tt-param = tt-param-nat.r-rowid.
    ELSE
        ASSIGN r-rowid-tt-param = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brParam wWindow
ON MOUSE-SELECT-DBLCLICK OF brParam IN FRAME fpage0
DO:
  APPLY "CHOOSE":U TO btAlterar IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brParam wWindow
ON START-SEARCH OF brParam IN FRAME fpage0
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


&Scoped-define SELF-NAME btAlterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlterar wWindow
ON CHOOSE OF btAlterar IN FRAME fpage0 /* Modificar */
DO:

   ASSIGN r-rowid-tt = ROWID(tt-param-nat).

   RUN esp\esb\esesb015a.w (INPUT IF AVAIL tt-param-nat THEN tt-param-nat.r-rowid ELSE ?,
                            INPUT "Update",
                            OUTPUT r-rowid-inclusao).

   RUN atualizarBrowse IN THIS-PROCEDURE. 
   REPOSITION brParam TO ROWID r-rowid-tt.
   
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEliminar wWindow
ON CHOOSE OF btEliminar IN FRAME fpage0 /* Eliminar */
DO:
  
    IF r-rowid-tt-param <> ? THEN DO:

         FIND int-param-nat-oper-benef EXCLUSIVE-LOCK
            WHERE rowid(int-param-nat-oper-benef) = r-rowid-tt-param NO-ERROR.

         IF AVAIL int-param-nat-oper-benef THEN DO:

             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 27100,
                                INPUT "Confirma a elimina‡Æo do registro?").

             IF RETURN-VALUE = "YES" THEN DO:
                DELETE int-param-nat-oper-benef.

                RUN atualizarBrowse.
             END.
         END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btIncluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncluir wWindow
ON CHOOSE OF btIncluir IN FRAME fpage0 /* Incluir */
DO:
    RUN esp\esb\esesb015a.w (INPUT ?,
                             INPUT "Create",
                             OUTPUT r-rowid-inclusao).

    RUN atualizarBrowse IN THIS-PROCEDURE.


    FIND FIRST tt-param-nat NO-LOCK 
        WHERE tt-param-nat.r-rowid = r-rowid-inclusao NO-ERROR.

    IF AVAIL tt-param-nat THEN DO:

        ASSIGN r-rowid-tt = ROWID(tt-param-nat).
        REPOSITION brParam TO ROWID r-rowid-tt.
    END.
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

    ENABLE btIncluir
           brParam
        WITH FRAME fPage0.

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

    EMPTY TEMP-TABLE tt-param-nat.

    FOR EACH  int-param-nat-oper-benef NO-LOCK:

        CREATE tt-param-nat.
        BUFFER-COPY int-param-nat-oper-benef TO tt-param-nat.
        ASSIGN tt-param-nat.r-rowid = ROWID(int-param-nat-oper-benef).

        CASE int-param-nat-oper-benef.tp-beneficio:
            WHEN 21 THEN
                ASSIGN tt-param-nat.ds-tp-beneficio = "VMC".
            WHEN 22 THEN
                ASSIGN tt-param-nat.ds-tp-beneficio = "Stock Rotation".
            WHEN 37 THEN
                ASSIGN tt-param-nat.ds-tp-beneficio = "Rebate".
            WHEN 66 THEN
                ASSIGN tt-param-nat.ds-tp-beneficio = "Rebate P¢s-Venda".
            WHEN 15 THEN
                ASSIGN tt-param-nat.ds-tp-beneficio = "Show Room".
            WHEN 08 THEN
                ASSIGN tt-param-nat.ds-tp-beneficio = "Price Protection".
            WHEN 04 THEN
                ASSIGN tt-param-nat.ds-tp-beneficio = "Stock Backup".

        END CASE.
    END.
        
    {&OPEN-QUERY-brParam}

    IF  CAN-FIND(FIRST tt-param-nat) THEN
        ENABLE btAlterar btEliminar WITH FRAME fPage0.
    ELSE
        DISABLE btAlterar btEliminar WITH FRAME fPage0.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

