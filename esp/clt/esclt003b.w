&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Global Shared Definitions ---                                        */

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER   NO-UNDO.

/* Include Definitions ---                                              */

{upc/btb910za-upc.i}
{esp/ShowMsg.i}

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-volume
    FIELD cod-estabel   AS CHAR
    FIELD serie         AS CHAR
    FIELD nr-nota-fis   AS CHAR
    FIELD nr-volume     AS INTEGER
    FIELD qt-total      AS DECIMAL
    FIELD qt-coletada   AS DECIMAL.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE lcompleto  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lvarios    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE vean       AS INTEGER     NO-UNDO.
DEFINE VARIABLE pit-codigo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-caixa    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-ok       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-selec    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-pallet   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-central  AS LOGICAL     NO-UNDO.

/* Local Buffer Definitions ---                                         */

DEFINE BUFFER bvolume-nf        FOR volume-nf.
DEFINE BUFFER bbvolume-nf       FOR volume-nf.
DEFINE BUFFER b-volume-nf        FOR volume-nf.
DEFINE BUFFER bitem-mat         FOR item-mat.
DEFINE BUFFER bns-volume        FOR ns-volume.
DEFINE BUFFER bcaixa-ns-volume  FOR ns-volume.
DEFINE BUFFER bpallet-ns-volume FOR ns-volume.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.

DEFINE INPUT PARAMETER c-cod-estabel    AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER c-serie          AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER c-nr-nota-fis    AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-volume

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-volume

/* Definitions for BROWSE br-volume                                     */
&Scoped-define FIELDS-IN-QUERY-br-volume tt-volume.nr-volume tt-volume.qt-total tt-volume.qt-coletada   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-volume   
&Scoped-define SELF-NAME br-volume
&Scoped-define QUERY-STRING-br-volume FOR EACH tt-volume
&Scoped-define OPEN-QUERY-br-volume OPEN QUERY {&SELF-NAME}     FOR EACH tt-volume.
&Scoped-define TABLES-IN-QUERY-br-volume tt-volume
&Scoped-define FIRST-TABLE-IN-QUERY-br-volume tt-volume


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-volume}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-volume btExit RECT-1 
&Scoped-Define DISPLAYED-OBJECTS fi-serie fi-cod-estabel fi-nr-nota-fis 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-desc-item wWindow 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-item-rastr wWindow 
FUNCTION f-item-rastr RETURNS LOGICAL
  ( INPUT p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btExit 
     LABEL "Sair(esc)" 
     SIZE-PIXELS 70 BY 24
     FONT 4.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(18)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 42 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-nr-nota-fis AS CHARACTER FORMAT "X(16)" 
     LABEL "Nr Nota" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 91 BY 21
     FONT 4.

DEFINE VARIABLE fi-serie AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 41 BY 21
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 308 BY 36.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-volume FOR 
      tt-volume SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-volume wWindow _FREEFORM
  QUERY br-volume DISPLAY
      tt-volume.nr-volume       COLUMN-LABEL "Volume"   FORMAT ">>,>>9"
          tt-volume.qt-total    COLUMN-LABEL "QT Total" FORMAT ">>>,>>9.999"
          tt-volume.qt-coletada COLUMN-LABEL "QT Coletada" FORMAT ">>>,>>9.999"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 44 BY 9
          &ELSE SIZE-PIXELS 308 BY 216 &ENDIF
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-serie AT Y 12 X 248 COLON-ALIGNED WIDGET-ID 30
     fi-cod-estabel AT Y 12 X 24 COLON-ALIGNED WIDGET-ID 4
     fi-nr-nota-fis AT Y 12 X 115 COLON-ALIGNED WIDGET-ID 8
     br-volume AT Y 48 X 0 WIDGET-ID 200
     btExit AT Y 264 X 238 HELP
          "Sair"
     RECT-1 AT Y 6 X 0 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT-P           = 300
         WIDTH-P            = 319
         MAX-HEIGHT-P       = 702
         MAX-WIDTH-P        = 1366
         VIRTUAL-HEIGHT-P   = 702
         VIRTUAL-WIDTH-P    = 1366
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 4
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Size-to-Fit Custom                                        */
/* BROWSE-TAB br-volume fi-nr-nota-fis fpage0 */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nr-nota-fis IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-serie IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-volume
/* Query rebuild information for BROWSE br-volume
     _START_FREEFORM
OPEN QUERY {&SELF-NAME}
    FOR EACH tt-volume.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-volume */
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


&Scoped-define BROWSE-NAME br-volume
&Scoped-define SELF-NAME br-volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-volume wWindow
ON F5 OF br-volume IN FRAME fpage0
DO:

    /*
    IF AVAIL tt-volume THEN DO:

        EMPTY TEMP-TABLE ttvolume-nf.

        CREATE ttvolume-nf.
        ASSIGN ttvolume-nf.cod-estabel = tt-volume.cod-estabel
               ttvolume-nf.serie       = tt-volume.serie
               ttvolume-nf.nr-nota-fis = tt-volume.nr-nota-fis
               ttvolume-nf.tot-vol     = tt-volume.qt-total
               ttvolume-nf.qtd-col     = tt-volume.qt-coletada.

        {&WINDOW-NAME}:SENSITIVE = NO.
        {&WINDOW-NAME}:HIDDEN    = YES.
        RUN esp/clt/esclt005a.w (INPUT TABLE ttvolume-nf).
        {&WINDOW-NAME}:HIDDEN    = NO.
        {&WINDOW-NAME}:SENSITIVE = YES.

    END.
    */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-volume wWindow
ON ROW-DISPLAY OF br-volume IN FRAME fpage0
DO:
    IF tt-volume.qt-total <> tt-volume.qt-coletada OR
       tt-volume.qt-total = 0 THEN
        ASSIGN tt-volume.nr-volume:FGCOLOR IN BROWSE br-volume = 12
               tt-volume.qt-total:FGCOLOR IN BROWSE br-volume = 12
               tt-volume.qt-coletada:FGCOLOR IN BROWSE br-volume = 12.
        
    ELSE
        ASSIGN tt-volume.nr-volume:FGCOLOR IN BROWSE br-volume = 9
               tt-volume.qt-total:FGCOLOR IN BROWSE br-volume = 9     
               tt-volume.qt-coletada:FGCOLOR IN BROWSE br-volume = 9.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Sair(esc) */
DO:
    APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  RUN piCarga.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow 
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow 
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  VIEW FRAME fPage0 IN WINDOW wWindow.

  ENABLE {&ENABLED-OBJECTS} WITH FRAME fPage0.

  DISP {&DISPLAYED-OBJECTS} WITH FRAME fPage0.

  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarga wWindow 
PROCEDURE piCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:

        ASSIGN fi-cod-estabel:SCREEN-VALUE = c-cod-estabel
               fi-nr-nota-fis:SCREEN-VALUE = c-nr-nota-fis
               fi-serie:SCREEN-VALUE       = c-serie.

    END.


    EMPTY TEMP-TABLE tt-volume.

    FOR EACH volume-nf NO-LOCK
        WHERE volume-nf.cod-estabel = c-cod-estabel 
        AND   volume-nf.serie       = c-serie       
        AND   volume-nf.nr-nota-fis = c-nr-nota-fis
        BREAK BY volume-nf.nr-volume:

        IF FIRST-OF(volume-nf.nr-volume) THEN DO:

            CREATE tt-volume.
            ASSIGN tt-volume.cod-estabel = volume-nf.cod-estabel
                   tt-volume.serie       = volume-nf.serie      
                   tt-volume.nr-nota-fis = volume-nf.nr-nota-fis
                   tt-volume.nr-volume   = volume-nf.nr-volume  
                   tt-volume.qt-total    = 0
                   tt-volume.qt-coletada = 0.

        END.

        ASSIGN tt-volume.qt-total    = tt-volume.qt-total    + volume-nf.qtde
               tt-volume.qt-coletada = tt-volume.qt-coletada + volume-nf.qtde-col.
        
    END.

    {&open-query-br-volume}
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-desc-item wWindow 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = p-it-codigo:

        RETURN ITEM.desc-item.

    END.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-item-rastr wWindow 
FUNCTION f-item-rastr RETURNS LOGICAL
  ( INPUT p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST item-rast FIELDS(it-codigo data-ini data-fim) NO-LOCK 
        WHERE item-rast.it-codigo  = p-it-codigo
        AND   item-rast.data-ini  <= TODAY
        AND   item-rast.data-fim   > TODAY:

        RETURN TRUE.

    END.


    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

