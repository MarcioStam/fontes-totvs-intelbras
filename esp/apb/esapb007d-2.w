&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME frame-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS frame-2 
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
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

def temp-table tt_repres
    field cdn_repres     LIKE representante.cdn_repres
    FIELD nom_repres     LIKE representante.nom_abrev
    FIELD nom_fornec     LIKE fornecedor.nom_abrev.

/* Parameters Definitions ---                                           */
DEF INPUT PARAM p_cdn_fornec AS INTEGER NO-UNDO.

/* Local Variable Definitions ---                                       */

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHARACTER FORMAT "x(3)":U  LABEL "Empresa" COLUMN-LABEL "Empresa" NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frame-2
&Scoped-define BROWSE-NAME br-repres

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt_repres

/* Definitions for BROWSE br-repres                                    */
&Scoped-define FIELDS-IN-QUERY-br-repres cdn_repres nom_repres nom_fornec   
&Scoped-define SELF-NAME br-repres
&Scoped-define QUERY-STRING-br-repres FOR EACH tt_repres
&Scoped-define OPEN-QUERY-br-repres OPEN QUERY {&SELF-NAME} FOR EACH tt_repres.
&Scoped-define TABLES-IN-QUERY-br-repres tt_repres
&Scoped-define FIRST-TABLE-IN-QUERY-br-repres tt_repres


/* Definitions for DIALOG-BOX frame-2                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-frame-2 ~
    ~{&OPEN-QUERY-br-repres}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-33 br-repres BT-OK bt-cancela 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "OK" 
     SIZE 14 BY 1.13
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 76 BY 9.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-repres FOR 
      tt_repres SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-repres
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-repres frame-2 _FREEFORM
  QUERY br-repres NO-LOCK DISPLAY
        cdn_repres
        nom_repres
        nom_fornec
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SEPARATORS SIZE 74 BY 7.75
         FONT 1 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frame-2
     br-repres AT ROW 1.75 COL 3
     bt-cancela AT ROW 9.79 COL 62.86
     RECT-33 AT ROW 1.5 COL 2
     SPACE(0.85) SKIP(0.16)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Representantes"
         DEFAULT-BUTTON bt-cancela.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX frame-2
                                                                        */
/* BROWSE-TAB br-repres RECT-33 frame-2 */
ASSIGN 
       FRAME frame-2:SCROLLABLE       = FALSE
       FRAME frame-2:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-repres
/* Query rebuild information for BROWSE br-repres
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt_repres BY tt_repres.tta_dat_transacao.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Where[1]         = "mgesp.comis-deb-cred.cod-rep = p_cdn_repres
 AND mgesp.comis-deb-cred.dt-movto >= p_data_ini
 AND mgesp.comis-deb-cred.dt-movto <= p_data_fim
 AND mgesp.comis-deb-cred.base-final
"
     _Query            is OPENED
*/  /* BROWSE br-repres */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME frame-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frame-2 frame-2
ON WINDOW-CLOSE OF FRAME frame-2 /* Antecipa‡Æo */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-repres
&Scoped-define SELF-NAME br-repres
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-repres frame-2
ON MOUSE-MOVE-DBLCLICK OF br-repres IN FRAME frame-2
DO:
   APPLY "return" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  RUN pi-atualiza-browse.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI frame-2  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME frame-2.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI frame-2  _DEFAULT-ENABLE
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
  ENABLE RECT-33 br-repres bt-cancela 
      WITH FRAME frame-2.
  VIEW FRAME frame-2.
  {&OPEN-BROWSERS-IN-QUERY-frame-2}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-browse frame-2 
PROCEDURE pi-atualiza-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt_repres:
        DELETE tt_repres.
    END.
    FIND FIRST fornecedor NO-LOCK
        WHERE fornecedor.cod_empresa = v_cod_empres_usuar
        AND   fornecedor.cdn_fornec  = p_cdn_fornec NO-ERROR.
    IF AVAIL fornecedor THEN DO:
       FOR EACH representante NO-LOCK
           WHERE representante.cod_empresa = fornecedor.cod_empresa
             AND representante.num_pessoa  = fornecedor.num_pessoa:
           CREATE tt_repres.
           ASSIGN tt_repres.cdn_repres = representante.cdn_repres
                  tt_repres.nom_repres = representante.nom_abrev
                  tt_repres.nom_fornec = fornecedor.nom_abrev.
       END.
    END.

    {&OPEN-QUERY-{&BROWSE-NAME}}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
