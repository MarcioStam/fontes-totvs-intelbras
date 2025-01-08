&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
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

DEF INPUT-OUTPUT PARAM p-cod-estab-ini    LIKE int-romaneio-emb.cod-estab.
DEF INPUT-OUTPUT PARAM p-cod-estab-fim    LIKE int-romaneio-emb.cod-estab.
DEF INPUT-OUTPUT PARAM p-serie-ini        LIKE int-romaneio-emb.serie.
DEF INPUT-OUTPUT PARAM p-serie-fim        LIKE int-romaneio-emb.serie.
DEF INPUT-OUTPUT PARAM p-nr-nota-fis-ini  LIKE int-romaneio-emb.nr-nota-fis.
DEF INPUT-OUTPUT PARAM p-nr-nota-fis-fim  LIKE int-romaneio-emb.nr-nota-fis.
DEF INPUT-OUTPUT PARAM p-dt-emis-nota-ini LIKE int-romaneio-emb.dt-emis-nota.
DEF INPUT-OUTPUT PARAM p-dt-emis-nota-fim LIKE int-romaneio-emb.dt-emis-nota.
DEF INPUT-OUTPUT PARAM p-dt-romaneio-ini  LIKE int-romaneio-emb.dt-romaneio.
DEF INPUT-OUTPUT PARAM p-dt-romaneio-fim  LIKE int-romaneio-emb.dt-romaneio.
DEF INPUT-OUTPUT PARAM p-nome-transp-ini  LIKE int-romaneio-emb.nome-transp.
DEF INPUT-OUTPUT PARAM p-nome-transp-fim  LIKE int-romaneio-emb.nome-transp.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 ~
IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 IMAGE-10 IMAGE-11 IMAGE-12 RECT-1 ~
c-cod-estab-ini c-cod-estab-fim c-serie-ini c-serie-fim c-nr-nota-fis-ini ~
c-nr-nota-fis-fim d-dt-emis-nota-ini d-dt-emis-nota-fim d-dt-romaneio-ini ~
d-dt-romaneio-fim c-nome-transp-ini c-nome-transp-fim Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estab-ini c-cod-estab-fim ~
c-serie-ini c-serie-fim c-nr-nota-fis-ini c-nr-nota-fis-fim ~
d-dt-emis-nota-ini d-dt-emis-nota-fim d-dt-romaneio-ini d-dt-romaneio-fim ~
c-nome-transp-ini c-nome-transp-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-cod-estab-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estab-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-transp-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-transp-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Transp" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-nota-fis-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-nota-fis-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Nr Nota" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-emis-nota-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-emis-nota-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Emiss∆o Nota" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-romaneio-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-romaneio-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Dt. Romaneio" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 64 BY 7.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     c-cod-estab-ini AT ROW 2 COL 21 COLON-ALIGNED WIDGET-ID 4
     c-cod-estab-fim AT ROW 2 COL 40.86 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     c-serie-ini AT ROW 3 COL 21 COLON-ALIGNED WIDGET-ID 12
     c-serie-fim AT ROW 3 COL 40.86 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     c-nr-nota-fis-ini AT ROW 4 COL 11 COLON-ALIGNED WIDGET-ID 20
     c-nr-nota-fis-fim AT ROW 4 COL 40.86 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     d-dt-emis-nota-ini AT ROW 5 COL 18 COLON-ALIGNED WIDGET-ID 32
     d-dt-emis-nota-fim AT ROW 5 COL 40.86 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     d-dt-romaneio-ini AT ROW 6 COL 18 COLON-ALIGNED WIDGET-ID 34
     d-dt-romaneio-fim AT ROW 6 COL 40.86 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     c-nome-transp-ini AT ROW 7 COL 11 COLON-ALIGNED WIDGET-ID 36
     c-nome-transp-fim AT ROW 7 COL 40.86 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     Btn_OK AT ROW 9 COL 2
     Btn_Cancel AT ROW 9 COL 13
     IMAGE-1 AT ROW 2 COL 30 WIDGET-ID 6
     IMAGE-2 AT ROW 2 COL 40 WIDGET-ID 8
     IMAGE-3 AT ROW 3 COL 30 WIDGET-ID 14
     IMAGE-4 AT ROW 3 COL 40 WIDGET-ID 16
     IMAGE-5 AT ROW 4 COL 30 WIDGET-ID 22
     IMAGE-6 AT ROW 4 COL 40 WIDGET-ID 24
     IMAGE-7 AT ROW 5 COL 30 WIDGET-ID 38
     IMAGE-8 AT ROW 5 COL 40 WIDGET-ID 40
     IMAGE-9 AT ROW 6 COL 30 WIDGET-ID 42
     IMAGE-10 AT ROW 6 COL 40 WIDGET-ID 44
     IMAGE-11 AT ROW 7 COL 30 WIDGET-ID 46
     IMAGE-12 AT ROW 7 COL 40 WIDGET-ID 48
     RECT-1 AT ROW 1.29 COL 1.14 WIDGET-ID 50
     SPACE(0.00) SKIP(1.58)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 7
         TITLE "esftp122a"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


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
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* esftp122a */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
   ASSIGN p-cod-estab-ini    = INPUT FRAME Dialog-Frame c-cod-estab-ini     
          p-cod-estab-fim    = INPUT FRAME Dialog-Frame c-cod-estab-fim     
          p-serie-ini        = INPUT FRAME Dialog-Frame c-serie-ini         
          p-serie-fim        = INPUT FRAME Dialog-Frame c-serie-fim         
          p-nr-nota-fis-ini  = INPUT FRAME Dialog-Frame c-nr-nota-fis-ini   
          p-nr-nota-fis-fim  = INPUT FRAME Dialog-Frame c-nr-nota-fis-fim   
          p-dt-emis-nota-ini = INPUT FRAME Dialog-Frame d-dt-emis-nota-ini  
          p-dt-emis-nota-fim = INPUT FRAME Dialog-Frame d-dt-emis-nota-fim  
          p-dt-romaneio-ini  = INPUT FRAME Dialog-Frame d-dt-romaneio-ini   
          p-dt-romaneio-fim  = INPUT FRAME Dialog-Frame d-dt-romaneio-fim   
          p-nome-transp-ini  = INPUT FRAME Dialog-Frame c-nome-transp-ini   
          p-nome-transp-fim  = INPUT FRAME Dialog-Frame c-nome-transp-fim.  

   RETURN "FILTRAR".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


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
  ASSIGN c-cod-estab-ini   :SCREEN-VALUE IN FRAME Dialog-Frame = STRING(p-cod-estab-ini   )    
         c-cod-estab-fim   :SCREEN-VALUE IN FRAME Dialog-Frame = STRING(p-cod-estab-fim   )    
         c-serie-ini       :SCREEN-VALUE IN FRAME Dialog-Frame = STRING(p-serie-ini       )    
         c-serie-fim       :SCREEN-VALUE IN FRAME Dialog-Frame = STRING(p-serie-fim       )    
         c-nr-nota-fis-ini :SCREEN-VALUE IN FRAME Dialog-Frame = STRING(p-nr-nota-fis-ini )    
         c-nr-nota-fis-fim :SCREEN-VALUE IN FRAME Dialog-Frame = STRING(p-nr-nota-fis-fim )    
         d-dt-emis-nota-ini:SCREEN-VALUE IN FRAME Dialog-Frame = STRING(p-dt-emis-nota-ini)    
         d-dt-emis-nota-fim:SCREEN-VALUE IN FRAME Dialog-Frame = STRING(p-dt-emis-nota-fim)    
         d-dt-romaneio-ini :SCREEN-VALUE IN FRAME Dialog-Frame = STRING(p-dt-romaneio-ini )    
         d-dt-romaneio-fim :SCREEN-VALUE IN FRAME Dialog-Frame = STRING(p-dt-romaneio-fim )    
         c-nome-transp-ini :SCREEN-VALUE IN FRAME Dialog-Frame = STRING(p-nome-transp-ini )    
         c-nome-transp-fim :SCREEN-VALUE IN FRAME Dialog-Frame = STRING(p-nome-transp-fim ).    







  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY c-cod-estab-ini c-cod-estab-fim c-serie-ini c-serie-fim 
          c-nr-nota-fis-ini c-nr-nota-fis-fim d-dt-emis-nota-ini 
          d-dt-emis-nota-fim d-dt-romaneio-ini d-dt-romaneio-fim 
          c-nome-transp-ini c-nome-transp-fim 
      WITH FRAME Dialog-Frame.
  ENABLE IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 
         IMAGE-9 IMAGE-10 IMAGE-11 IMAGE-12 RECT-1 c-cod-estab-ini 
         c-cod-estab-fim c-serie-ini c-serie-fim c-nr-nota-fis-ini 
         c-nr-nota-fis-fim d-dt-emis-nota-ini d-dt-emis-nota-fim 
         d-dt-romaneio-ini d-dt-romaneio-fim c-nome-transp-ini 
         c-nome-transp-fim Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

