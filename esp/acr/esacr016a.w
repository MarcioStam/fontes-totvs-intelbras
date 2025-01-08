&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f-main
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f-main 
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE tt_tit_acr NO-UNDO LIKE tit_acr
    FIELD l-marcado AS LOGICAL FORMAT "*/ "
    INDEX id IS PRIMARY cod_estab cod_espec_docto cod_ser_docto cod_tit_acr cod_parcela dat_vencto_tit_acr.

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt_tit_acr.
DEFINE OUTPUT       PARAMETER l-ok AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main
&Scoped-define BROWSE-NAME BROWSE-6

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt_tit_acr

/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 tt_tit_acr.l-marcado tt_tit_acr.cod_estab tt_tit_acr.cod_espec_docto tt_tit_acr.cod_ser_docto tt_tit_acr.cod_tit_acr tt_tit_acr.cod_parcela tt_tit_acr.cdn_cliente tt_tit_acr.nom_abrev tt_tit_acr.dat_vencto_origin_tit_acr tt_tit_acr.val_origin_tit_acr   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 tt_tit_acr.dat_vencto_origin_tit_acr tt_tit_acr.val_origin_tit_acr   
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-6 tt_tit_acr
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-6 tt_tit_acr
&Scoped-define SELF-NAME BROWSE-6
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH tt_tit_acr
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 tt_tit_acr
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 tt_tit_acr


/* Definitions for DIALOG-BOX f-main                                    */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-main ~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-11 BROWSE-6 bt-todos bt-nenhum Btn_OK ~
Btn_Cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-nenhum 
     LABEL "Nenhum" 
     SIZE 13 BY 1.

DEFINE BUTTON bt-todos 
     LABEL "Todos" 
     SIZE 13 BY 1.

DEFINE BUTTON Btn_Cancel AUTO-GO 
     LABEL "Cancel" 
     SIZE 11 BY 1.13.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 11 BY 1.13
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 67 BY 1.63
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-6 FOR 
      tt_tit_acr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 f-main _FREEFORM
  QUERY BROWSE-6 DISPLAY
      tt_tit_acr.l-marcado           COLUMN-LABEL "*"
tt_tit_acr.cod_estab 
tt_tit_acr.cod_espec_docto           COLUMN-LABEL "Esp"
tt_tit_acr.cod_ser_docto             COLUMN-LABEL "Ser"
tt_tit_acr.cod_tit_acr               COLUMN-LABEL "T¡tulo" WIDTH 9
tt_tit_acr.cod_parcela               COLUMN-LABEL "/P"
tt_tit_acr.cdn_cliente               COLUMN-LABEL "Cliente"
tt_tit_acr.nom_abrev                 COLUMN-LABEL "Nome"
tt_tit_acr.dat_vencto_origin_tit_acr COLUMN-LABEL "Dat. Vencto"
tt_tit_acr.val_origin_tit_acr        COLUMN-LABEL "Valor Original"
ENABLE
tt_tit_acr.dat_vencto_origin_tit_acr
tt_tit_acr.val_origin_tit_acr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 67 BY 10.25
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     BROWSE-6 AT ROW 1.25 COL 2
     bt-todos AT ROW 11.5 COL 43
     bt-nenhum AT ROW 11.5 COL 56
     Btn_OK AT ROW 12.75 COL 3
     Btn_Cancel AT ROW 12.75 COL 14 WIDGET-ID 2
     RECT-11 AT ROW 12.5 COL 2
     SPACE(0.42) SKIP(0.07)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "T¡tulos ACR"
         DEFAULT-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f-main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-6 RECT-11 f-main */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

ASSIGN 
       BROWSE-6:COLUMN-RESIZABLE IN FRAME f-main       = TRUE
       BROWSE-6:COLUMN-MOVABLE IN FRAME f-main         = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME f-main
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-main f-main
ON WINDOW-CLOSE OF FRAME f-main /* T¡tulos ACR */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-6
&Scoped-define SELF-NAME BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-6 f-main
ON MOUSE-SELECT-DBLCLICK OF BROWSE-6 IN FRAME f-main
DO:
    IF AVAIL tt_tit_acr THEN
        IF tt_tit_acr.l-marcado:SCREEN-VALUE IN BROWSE BROWSE-6 = "":U THEN
            ASSIGN tt_tit_acr.l-marcado:SCREEN-VALUE IN BROWSE BROWSE-6 = "*":U
                   tt_tit_acr.l-marcado = YES.
        ELSE
            ASSIGN tt_tit_acr.l-marcado:SCREEN-VALUE IN BROWSE BROWSE-6 = "":U
                   tt_tit_acr.l-marcado = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-6 f-main
ON ROW-LEAVE OF BROWSE-6 IN FRAME f-main
DO:
    IF AVAIL tt_tit_acr THEN
        ASSIGN INPUT BROWSE BROWSE-6 tt_tit_acr.dat_vencto_origin_tit_acr
               INPUT BROWSE BROWSE-6 tt_tit_acr.val_origin_tit_acr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum f-main
ON CHOOSE OF bt-nenhum IN FRAME f-main /* Nenhum */
DO:
    FOR EACH tt_tit_acr:
        ASSIGN tt_tit_acr.l-marcado = NO.
    END.

    BROWSE-6:REFRESH() NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos f-main
ON CHOOSE OF bt-todos IN FRAME f-main /* Todos */
DO:
    FOR EACH tt_tit_acr:
        ASSIGN tt_tit_acr.l-marcado = YES.
    END.

    BROWSE-6:REFRESH() NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel f-main
ON CHOOSE OF Btn_Cancel IN FRAME f-main /* Cancel */
DO:
    ASSIGN l-ok = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK f-main
ON CHOOSE OF Btn_OK IN FRAME f-main /* OK */
DO:
    ASSIGN l-ok = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f-main 


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

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f-main  _DEFAULT-DISABLE
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
  HIDE FRAME f-main.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f-main  _DEFAULT-ENABLE
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
  ENABLE RECT-11 BROWSE-6 bt-todos bt-nenhum Btn_OK Btn_Cancel 
      WITH FRAME f-main.
  VIEW FRAME f-main.
  {&OPEN-BROWSERS-IN-QUERY-f-main}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

