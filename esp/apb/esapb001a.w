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

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAM pcod_estab_ini         LIKE tit_ap.cod_estab          NO-UNDO.
DEFINE INPUT-OUTPUT PARAM pcod_estab_fim         LIKE tit_ap.cod_estab          NO-UNDO.
DEFINE INPUT-OUTPUT PARAM pcdn_fornecedor_ini    LIKE tit_ap.cdn_fornecedor     NO-UNDO.
DEFINE INPUT-OUTPUT PARAM pcdn_fornecedor_fim    LIKE tit_ap.cdn_fornecedor     NO-UNDO.
DEFINE INPUT-OUTPUT PARAM pdat_vencto_tit_ap_ini LIKE tit_ap.dat_vencto_tit_ap  NO-UNDO.
DEFINE INPUT-OUTPUT PARAM pdat_vencto_tit_ap_fim LIKE tit_ap.dat_vencto_tit_ap  NO-UNDO.
DEFINE INPUT-OUTPUT PARAM pcod_retencao_ini      LIKE compl_impto_retid_ap.cod_classif_impto NO-UNDO.
DEFINE INPUT-OUTPUT PARAM pcod_retencao_fim      LIKE compl_impto_retid_ap.cod_classif_impto NO-UNDO.
DEFINE INPUT-OUTPUT PARAM ptitulos-pagos         AS LOGICAL NO-UNDO. 



DEF VAR v-sai AS INT.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tit_ap

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define QUERY-STRING-Dialog-Frame FOR EACH tit_ap SHARE-LOCK
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH tit_ap SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame tit_ap
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame tit_ap


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-8 fi_cod_estab_ini ~
fi_cod_estab_fim fi_cdn_fornecedor_ini fi_cdn_fornecedor_fim ~
fi_dat_vencto_tit_ap_ini fi_dat_vencto_tit_ap_fim fi_cod_retencao_ini ~
fi_cod_retencao_fim tg-pagos Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS fi_cod_estab_ini fi_cod_estab_fim ~
fi_cdn_fornecedor_ini fi_cdn_fornecedor_fim fi_dat_vencto_tit_ap_ini ~
fi_dat_vencto_tit_ap_fim fi_cod_retencao_ini fi_cod_retencao_fim tg-pagos 

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

DEFINE VARIABLE fi_cdn_fornecedor_fim AS INTEGER FORMAT ">,>>>,>>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .87.

DEFINE VARIABLE fi_cdn_fornecedor_ini AS INTEGER FORMAT ">,>>>,>>9" INITIAL 0 
     LABEL "Fornecedor Inicial" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .87.

DEFINE VARIABLE fi_cod_estab_fim AS CHARACTER FORMAT "x(5)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .87.

DEFINE VARIABLE fi_cod_estab_ini AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .87.

DEFINE VARIABLE fi_cod_retencao_fim AS CHARACTER FORMAT "X(5)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .87.

DEFINE VARIABLE fi_cod_retencao_ini AS CHARACTER FORMAT "X(5)" 
     LABEL "C¢digo de reten‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .87.

DEFINE VARIABLE fi_dat_vencto_tit_ap_fim AS DATE FORMAT "99/99/9999" INITIAL 01/31/05 
     VIEW-AS FILL-IN 
     SIZE 10 BY .87.

DEFINE VARIABLE fi_dat_vencto_tit_ap_ini AS DATE FORMAT "99/99/9999" INITIAL 01/31/05 
     LABEL "Data Vencimento Inicial" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .87.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 56 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 5.6.

DEFINE VARIABLE tg-pagos AS LOGICAL INITIAL no 
     LABEL "T¡tulos pagos" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      tit_ap SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     fi_cod_estab_ini AT ROW 1.27 COL 18 COLON-ALIGNED HELP
          "C¢digo Estabelecimento" WIDGET-ID 4
     fi_cod_estab_fim AT ROW 1.27 COL 36 COLON-ALIGNED HELP
          "C¢digo Estabelecimento" NO-LABEL WIDGET-ID 2
     fi_cdn_fornecedor_ini AT ROW 2.27 COL 18 COLON-ALIGNED HELP
          "C¢digo Fornecedor"
     fi_cdn_fornecedor_fim AT ROW 2.27 COL 36 COLON-ALIGNED HELP
          "C¢digo Fornecedor" NO-LABEL
     fi_dat_vencto_tit_ap_ini AT ROW 3.27 COL 18 COLON-ALIGNED HELP
          "Data Vencimento T¡tulo"
     fi_dat_vencto_tit_ap_fim AT ROW 3.27 COL 36 COLON-ALIGNED HELP
          "Data Vencimento T¡tulo" NO-LABEL
     fi_cod_retencao_ini AT ROW 4.27 COL 18 COLON-ALIGNED HELP
          "C¢digo de reten‡Æo"
     fi_cod_retencao_fim AT ROW 4.27 COL 36 COLON-ALIGNED HELP
          "Data Vencimento T¡tulo" NO-LABEL
     tg-pagos AT ROW 5.4 COL 20
     Btn_OK AT ROW 7.13 COL 2
     Btn_Cancel AT ROW 7.13 COL 13
     RECT-2 AT ROW 6.9 COL 1
     RECT-8 AT ROW 1 COL 1
     SPACE(0.44) SKIP(1.79)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Sele‡Æo - ESAPB001A"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
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


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "tit_ap"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Sele‡Æo - ESAPB001A */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:

    IF tg-pagos:CHECKED = NO THEN DO:
       ASSIGN v-sai = 1.    
    END.
    ELSE DO:
       ASSIGN v-sai = 2. 
    END.


    DO WITH FRAME {&FRAME-NAME}:
        IF INPUT fi_cdn_fornecedor_ini >  INPUT fi_cdn_fornecedor_fim THEN DO:
           MESSAGE 'Fornecedor INI maior do que Fornecedor FIM' VIEW-AS ALERT-BOX ERROR BUTTONS OK.
           RETURN NO-APPLY.
        END.
        IF INPUT fi_dat_vencto_tit_ap_ini >  INPUT fi_dat_vencto_tit_ap_fim THEN DO:
           MESSAGE 'Vencimento INI maior do que Vencimento FIM' VIEW-AS ALERT-BOX ERROR BUTTONS OK.
           RETURN NO-APPLY.
        END.
    END.
 



    ASSIGN pcod_estab_ini         = INPUT FRAME {&FRAME-NAME} fi_cod_estab_ini
           pcod_estab_fim         = INPUT FRAME {&FRAME-NAME} fi_cod_estab_fim
           pcdn_fornecedor_ini    = INPUT FRAME {&FRAME-NAME} fi_cdn_fornecedor_ini 
           pcdn_fornecedor_fim    = INPUT FRAME {&FRAME-NAME} fi_cdn_fornecedor_fim 
           pdat_vencto_tit_ap_ini = INPUT FRAME {&FRAME-NAME} fi_dat_vencto_tit_ap_ini
           pdat_vencto_tit_ap_fim = INPUT FRAME {&FRAME-NAME} fi_dat_vencto_tit_ap_fim
           pcod_retencao_ini      = INPUT FRAME {&FRAME-NAME} fi_cod_retencao_ini
           pcod_retencao_fim      = INPUT FRAME {&FRAME-NAME} fi_cod_retencao_fim 
           ptitulos-pagos         = INPUT FRAME {&FRAME-NAME} tg-pagos:CHECKED.               

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
    ASSIGN fi_cod_estab_ini          = pcod_estab_ini
           fi_cod_estab_fim          = pcod_estab_fim
           fi_cdn_fornecedor_ini     = pcdn_fornecedor_ini    
           fi_cdn_fornecedor_fim     = pcdn_fornecedor_fim    
           fi_dat_vencto_tit_ap_ini  = pdat_vencto_tit_ap_ini 
           fi_dat_vencto_tit_ap_fim  = pdat_vencto_tit_ap_fim.
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
  DISPLAY fi_cod_estab_ini fi_cod_estab_fim fi_cdn_fornecedor_ini 
          fi_cdn_fornecedor_fim fi_dat_vencto_tit_ap_ini 
          fi_dat_vencto_tit_ap_fim fi_cod_retencao_ini fi_cod_retencao_fim 
          tg-pagos 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-2 RECT-8 fi_cod_estab_ini fi_cod_estab_fim fi_cdn_fornecedor_ini 
         fi_cdn_fornecedor_fim fi_dat_vencto_tit_ap_ini 
         fi_dat_vencto_tit_ap_fim fi_cod_retencao_ini fi_cod_retencao_fim 
         tg-pagos Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

