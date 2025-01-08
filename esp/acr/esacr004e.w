&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER pRowFedex   AS ROWID   NO-UNDO.
DEFINE OUTPUT PARAMETER plOk        AS LOGICAL NO-UNDO INITIAL NO.

/* Local Variable Definitions ---                                       */

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_dwb_user AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_cta_ctbl_integr AS RECID NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_ccusto AS RECID NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_plano_ccusto AS RECID  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rsTipo Btn_OK Btn_Cancel RECT-2 RECT-8 
&Scoped-Define DISPLAYED-OBJECTS rsTipo fiIcms 

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

DEFINE VARIABLE fiIcms AS DECIMAL FORMAT ">>>,>>9.99" INITIAL 0 
     LABEL "ICMS" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE rsTipo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Impostos", 1,
"Frete", 2
     SIZE 12 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 83.43 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.43 BY 3.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     rsTipo AT ROW 1.25 COL 29 NO-LABEL
     fiIcms AT ROW 3.5 COL 27 COLON-ALIGNED
     Btn_OK AT ROW 5.25 COL 2
     Btn_Cancel AT ROW 5.25 COL 13
     RECT-2 AT ROW 5 COL 1
     RECT-8 AT ROW 1 COL 1
     SPACE(0.00) SKIP(1.75)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Cancela COURRIER - ESACR004E"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


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
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiIcms IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Cancela COURRIER - ESACR004E */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel Dialog-Frame
ON CHOOSE OF Btn_Cancel IN FRAME Dialog-Frame /* Cancel */
DO:
  ASSIGN plOk = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
/*
    if userid("mgadm") <> "el033870" and
       userid("mgadm") <> "ja031100" and
       userid("mgadm") <> "pa021105" and 
       userid("mgadm") <> "hu001147" and
       userid("mgadm") <> "adm" then do:
        message "Uso exclusivo da Controladoria" view-as alert-box.
        next.
    end.
    */
    FOR FIRST fedex EXCLUSIVE-LOCK 
        WHERE ROWID(fedex) = pRowFedex:
        IF INPUT rsTipo = 2 THEN /* Frete */
             assign fedex.dt-emis-frete   = ?
                    fedex.dt-venc-frete   = ?
                    fedex.fatura-frete    = 0
                    fedex.cod-emit-frete  = 0
                    fedex.valor-frete     = 0
                    fedex.lancado-frete   = no
                    fedex.dt-ap-frete     = ?.        
    
        ELSE assign fedex.dt-emis-imp   = ?
                    fedex.dt-venc-imp   = ?
                    fedex.fatura-imp    = 0
                    fedex.cod-emitente-imp  = 0
                    fedex.valor-imp     = 0
                    fedex.lancado-imp   = no 
                    fedex.dt-ap-imp     = ?.        
        ASSIGN fedex.icms = INPUT fiIcms.
    END.
    FIND FIRST fedex NO-LOCK NO-ERROR.
    ASSIGN plOk = YES.
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

    ENABLE fiIcms
           rsTipo
           WITH FRAME {&FRAME-NAME}.

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
  DISPLAY rsTipo fiIcms 
      WITH FRAME Dialog-Frame.
  ENABLE rsTipo Btn_OK Btn_Cancel RECT-2 RECT-8 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

