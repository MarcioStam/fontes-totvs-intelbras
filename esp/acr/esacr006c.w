&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{esp\acr\esacr006tt.i}
/* Parameters Definitions ---                                           */
DEFINE OUTPUT PARAM pRaw AS RAW.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tit_acr

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define QUERY-STRING-Dialog-Frame FOR EACH tit_acr SHARE-LOCK
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH tit_acr SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame tit_acr
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame tit_acr


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ficdn_cliente ficod_tit_acr ficod_parcela ~
ficod_espec_docto fidat_vencto_tit_acr fival_sdo_tit_acr ficod_portador ~
ficod_cart_bcia ficdn_repres Btn_OK Btn_Cancel RECT-2 RECT-8 
&Scoped-Define DISPLAYED-OBJECTS ficdn_cliente ficod_tit_acr ficod_parcela ~
ficod_espec_docto fidat_vencto_tit_acr fival_sdo_tit_acr ficod_portador ~
ficod_cart_bcia ficdn_repres 

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

DEFINE VARIABLE ficdn_cliente AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE ficdn_repres AS INTEGER FORMAT ">>>,>>9" INITIAL 0 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE ficod_cart_bcia AS CHARACTER FORMAT "x(3)" 
     LABEL "Carteira" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE ficod_espec_docto AS CHARACTER FORMAT "x(3)" 
     LABEL "Esp‚cie Documento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE ficod_parcela AS CHARACTER FORMAT "x(02)" 
     LABEL "Parcela" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE ficod_portador AS CHARACTER FORMAT "x(5)" 
     LABEL "Portador" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE ficod_tit_acr AS CHARACTER FORMAT "x(10)" 
     LABEL "T¡tulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE fidat_vencto_tit_acr AS DATE FORMAT "99/99/9999" INITIAL 01/25/05 
     LABEL "Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fival_sdo_tit_acr AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 0 
     LABEL "Saldo T¡tulo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 77 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77 BY 9.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      tit_acr SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     ficdn_cliente AT ROW 1.17 COL 24 COLON-ALIGNED HELP
          "C¢digo Cliente"
     ficod_tit_acr AT ROW 2.17 COL 24 COLON-ALIGNED HELP
          "C¢digo T¡tulo Contas a Receber"
     ficod_parcela AT ROW 3.17 COL 24 COLON-ALIGNED HELP
          "Parcela"
     ficod_espec_docto AT ROW 4.17 COL 24 COLON-ALIGNED HELP
          "C¢digo Esp‚cie Documento"
     fidat_vencto_tit_acr AT ROW 5.17 COL 24 COLON-ALIGNED HELP
          "Data Vencimento T¡tulo"
     fival_sdo_tit_acr AT ROW 6.17 COL 24 COLON-ALIGNED HELP
          "Valor Saldo Contas a Receber"
     ficod_portador AT ROW 7.17 COL 24 COLON-ALIGNED HELP
          "C¢digo Portador"
     ficod_cart_bcia AT ROW 8.17 COL 24 COLON-ALIGNED HELP
          "Carteira Banc ria"
     ficdn_repres AT ROW 9.17 COL 24 COLON-ALIGNED HELP
          "C¢digo Representante"
     Btn_OK AT ROW 10.75 COL 2
     Btn_Cancel AT ROW 10.75 COL 13
     RECT-2 AT ROW 10.5 COL 1
     RECT-8 AT ROW 1 COL 1
     SPACE(0.28) SKIP(1.75)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Incluir Registro - ESACR006C"
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "tit_acr"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Incluir Registro - ESACR006C */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel Dialog-Frame
ON CHOOSE OF Btn_Cancel IN FRAME Dialog-Frame /* Cancel */
DO:
  ASSIGN pRaw = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
    CREATE tt-tit.
    ASSIGN tt-tit.cdn_cliente         = INPUT FRAME {&FRAME-NAME} ficdn_cliente       
           tt-tit.cdn_repres          = INPUT FRAME {&FRAME-NAME} ficdn_repres        
           tt-tit.cod_cart_bcia       = INPUT FRAME {&FRAME-NAME} ficod_cart_bcia     
           tt-tit.cod_espec_docto     = INPUT FRAME {&FRAME-NAME} ficod_espec_docto   
           tt-tit.cod_parcela         = INPUT FRAME {&FRAME-NAME} ficod_parcela       
           tt-tit.cod_portador        = INPUT FRAME {&FRAME-NAME} ficod_portador      
           tt-tit.cod_tit_acr         = INPUT FRAME {&FRAME-NAME} ficod_tit_acr       
           tt-tit.dat_vencto_tit_acr  = INPUT FRAME {&FRAME-NAME} fidat_vencto_tit_acr
           tt-tit.val_sdo_tit_acr     = INPUT FRAME {&FRAME-NAME} fival_sdo_tit_acr.
    RAW-TRANSFER tt-tit TO pRaw.
    /*
    ASSIGN da-data-ini = INPUT FRAME {&FRAME-NAME} fiDataIni
           da-data-fim = INPUT FRAME {&FRAME-NAME} fiDataFim.
    */
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
    /*
    ASSIGN fiDataIni = da-data-ini 
           fiDataFIm = da-data-fim.
    */
  RUN enable_UI.
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

  {&OPEN-QUERY-Dialog-Frame}
  GET FIRST Dialog-Frame.
  DISPLAY ficdn_cliente ficod_tit_acr ficod_parcela ficod_espec_docto 
          fidat_vencto_tit_acr fival_sdo_tit_acr ficod_portador ficod_cart_bcia 
          ficdn_repres 
      WITH FRAME Dialog-Frame.
  ENABLE ficdn_cliente ficod_tit_acr ficod_parcela ficod_espec_docto 
         fidat_vencto_tit_acr fival_sdo_tit_acr ficod_portador ficod_cart_bcia 
         ficdn_repres Btn_OK Btn_Cancel RECT-2 RECT-8 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

