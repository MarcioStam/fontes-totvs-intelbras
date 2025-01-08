&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER dt-pagto AS DATE        NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_tit_acr AS RECID   NO-UNDO.


DEFINE TEMP-TABLE tt-titulos-pendentes NO-UNDO
    FIELD cnpj-cliente    AS CHARACTER FORMAT "x(14)"
    FIELD dat-pagto       AS DATE      FORMAT "99/99/9999"
    FIELD num-transac     AS CHARACTER FORMAT "x(14)"
    FIELD cod-estab       AS CHARACTER FORMAT "x(3)"
    FIELD cod-espc        AS CHARACTER FORMAT "x(3)"
    FIELD cod-ser-docto   AS CHARACTER FORMAT "x(3)"
    FIELD cod-tit-acr     AS CHARACTER FORMAT "x(10)"
    FIELD cod-parcela     AS CHARACTER FORMAT "x(2)"
    FIELD val-sdo-tit-acr AS DECIMAL
    FIELD r-recid-tit-acr AS RECID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brTitPendentes

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-titulos-pendentes

/* Definitions for BROWSE brTitPendentes                                */
&Scoped-define FIELDS-IN-QUERY-brTitPendentes tt-titulos-pendentes.cnpj-cliente tt-titulos-pendentes.dat-pagto tt-titulos-pendentes.num-transac tt-titulos-pendentes.cod-estab tt-titulos-pendentes.cod-espc tt-titulos-pendentes.cod-ser-docto tt-titulos-pendentes.cod-tit-acr tt-titulos-pendentes.cod-parcela tt-titulos-pendentes.val-sdo-tit-acr   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTitPendentes   
&Scoped-define SELF-NAME brTitPendentes
&Scoped-define QUERY-STRING-brTitPendentes FOR EACH tt-titulos-pendentes
&Scoped-define OPEN-QUERY-brTitPendentes OPEN QUERY {&SELF-NAME} FOR EACH tt-titulos-pendentes.
&Scoped-define TABLES-IN-QUERY-brTitPendentes tt-titulos-pendentes
&Scoped-define FIRST-TABLE-IN-QUERY-brTitPendentes tt-titulos-pendentes


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-brTitPendentes}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar brTitPendentes btOK 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btOK 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 96 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTitPendentes FOR 
      tt-titulos-pendentes SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTitPendentes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTitPendentes C-Win _FREEFORM
  QUERY brTitPendentes DISPLAY
      tt-titulos-pendentes.cnpj-cliente      WIDTH 15  COLUMN-LABEL "CNPJ Cliente":U
      tt-titulos-pendentes.dat-pagto         WIDTH 11  COLUMN-LABEL "Data Pagto":U
      tt-titulos-pendentes.num-transac       WIDTH 15  COLUMN-LABEL "Transa‡Æo":U
      tt-titulos-pendentes.cod-estab         WIDTH 6   COLUMN-LABEL "Estab":U
      tt-titulos-pendentes.cod-espc          WIDTH 6   COLUMN-LABEL "Espec":U
      tt-titulos-pendentes.cod-ser-docto     WIDTH 6   COLUMN-LABEL "Serie":U
      tt-titulos-pendentes.cod-tit-acr       WIDTH 10  COLUMN-LABEL "T¡tulo":U
      tt-titulos-pendentes.cod-parcela       WIDTH 4   COLUMN-LABEL "Parc":U
      tt-titulos-pendentes.val-sdo-tit-acr   WIDTH 16  COLUMN-LABEL "Valor de Saldo":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 94.14 BY 14.96
         FONT 1
         TITLE "T¡tulos pendentes com saldo em aberto" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     brTitPendentes AT ROW 1.29 COL 1.86 WIDGET-ID 200
     btOK AT ROW 16.92 COL 2 WIDGET-ID 8
     rtToolBar AT ROW 16.71 COL 1 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96 BY 17.17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "T¡tulos Pendentes"
         HEIGHT             = 17.17
         WIDTH              = 96
         MAX-HEIGHT         = 30.58
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 30.58
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB brTitPendentes rtToolBar DEFAULT-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTitPendentes
/* Query rebuild information for BROWSE brTitPendentes
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-titulos-pendentes.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brTitPendentes */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* T¡tulos Pendentes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* T¡tulos Pendentes */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTitPendentes
&Scoped-define SELF-NAME brTitPendentes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTitPendentes C-Win
ON MOUSE-SELECT-DBLCLICK OF brTitPendentes IN FRAME DEFAULT-FRAME /* T¡tulos pendentes com saldo em aberto */
DO:
    IF  AVAIL tt-titulos-pendentes AND tt-titulos-pendentes.r-recid-tit-acr <> ? THEN DO:
        ASSIGN v_rec_tit_acr = tt-titulos-pendentes.r-recid-tit-acr.
        RUN prgfin/acr/acr212aa.p.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME DEFAULT-FRAME /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


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
    RUN beforeInitializeInterface.
    RUN enable_UI.
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface C-Win 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH  int-pagtos-supcard NO-LOCK
        WHERE int-pagtos-supcard.dat-pagto < dt-pagto
        AND   int-pagtos-supcard.log-lancto-futuro = NO,
        EACH  int-pagtos-supcard-ocor NO-LOCK
        WHERE int-pagtos-supcard-ocor.id-pagto = int-pagtos-supcard.id-pagto:

        /* S¢ busca os t¡tulos que tem saldo */
        FIND FIRST tit_acr NO-LOCK
            WHERE  tit_acr.cod_estab     = STRING(INT(SUBSTRING(int-pagtos-supcard-ocor.num-transac,1,4)))
            AND    tit_acr.cod_espec     = "DM"
            AND    tit_acr.cod_ser_docto = STRING(INT(SUBSTRING(int-pagtos-supcard-ocor.num-transac,5,3)))
            AND    tit_acr.cod_tit_acr   = SUBSTRING(int-pagtos-supcard-ocor.num-transac,8,7)
            AND    tit_acr.cod_parcela   = STRING(int-pagtos-supcard-ocor.num-parcela, "99") NO-ERROR.
        IF  AVAIL  tit_acr AND tit_acr.val_sdo_tit_acr <> 0 THEN DO:
            CREATE tt-titulos-pendentes.
            ASSIGN tt-titulos-pendentes.cnpj-cliente    = int-pagtos-supcard-ocor.cnpj
                   tt-titulos-pendentes.dat-pagto       = int-pagtos-supcard.dat-pagto
                   tt-titulos-pendentes.num-transac     = int-pagtos-supcard-ocor.num-transac
                   tt-titulos-pendentes.cod-estab       = tit_acr.cod_estab
                   tt-titulos-pendentes.cod-espc        = tit_acr.cod_espec
                   tt-titulos-pendentes.cod-ser-docto   = tit_acr.cod_ser_docto
                   tt-titulos-pendentes.cod-tit-acr     = tit_acr.cod_tit_acr
                   tt-titulos-pendentes.cod-parcela     = tit_acr.cod_parcela
                   tt-titulos-pendentes.val-sdo-tit-acr = tit_acr.val_sdo_tit_acr
                   tt-titulos-pendentes.r-recid-tit-acr = RECID(tit_acr).
        END.
    END.

    {&OPEN-QUERY-brTitPedentes}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  ENABLE rtToolBar brTitPendentes btOK 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

