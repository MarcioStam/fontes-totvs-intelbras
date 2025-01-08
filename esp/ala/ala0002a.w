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
def new global shared var h-facelift as handle no-undo.

DEFINE INPUT-OUTPUT PARAM p_request_company_name_ini  LIKE int_solicitacao_alatur.request_company_name. 
DEFINE INPUT-OUTPUT PARAM p_request_company_name_fim  LIKE int_solicitacao_alatur.request_company_name.
DEFINE INPUT-OUTPUT PARAM p_request_number_arb_ini    LIKE int_solicitacao_alatur.request_number_arb.
DEFINE INPUT-OUTPUT PARAM p_request_number_arb_fim    LIKE int_solicitacao_alatur.request_number_arb.
DEFINE INPUT-OUTPUT PARAM p_advance_include_date_ini  LIKE int_solicitacao_alatur.advance_include_date.
DEFINE INPUT-OUTPUT PARAM p_advance_include_date_fim  LIKE int_solicitacao_alatur.advance_include_date.
DEFINE INPUT-OUTPUT PARAM p_vencimeto_ini    LIKE int_solicitacao_alatur.advance_final_date.
DEFINE INPUT-OUTPUT PARAM p_vencimeto_fim    LIKE int_solicitacao_alatur.advance_final_date.
DEFINE INPUT-OUTPUT PARAM p_dat_pay_ad_ini            LIKE int_solicitacao_alatur.dat_pay_ad.
DEFINE INPUT-OUTPUT PARAM p_dat_pay_ad_fim            LIKE int_solicitacao_alatur.dat_pay_ad.
DEFINE INPUT-OUTPUT PARAM p_dat_pay_pc_ini            LIKE int_solicitacao_alatur.dat_pay_pc.
DEFINE INPUT-OUTPUT PARAM p_dat_pay_pc_fim            LIKE int_solicitacao_alatur.dat_pay_pc.
DEFINE INPUT-OUTPUT PARAM p_request_passenger_CPF_ini LIKE int_solicitacao_alatur.request_passenger_CPF.
DEFINE INPUT-OUTPUT PARAM p_request_passenger_CPF_fim LIKE int_solicitacao_alatur.request_passenger_CPF.
DEFINE INPUT-OUTPUT PARAM p_viagem_nacional           AS LOG.
DEFINE INPUT-OUTPUT PARAM p_cartao_credito            AS LOG.
DEFINE INPUT-OUTPUT PARAM p_prestacao_contas          AS LOG.
DEFINE OUTPUT       PARAM p_ok                        AS LOG INITIAL NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 ~
IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 ~
IMAGE-14 RECT-34 RECT-35 RECT-33 request_company_name_ini ~
request_company_name_fim request_number_arb_ini request_number_arb_fim ~
advance_include_date_ini advance_include_date_fim vencimeto_ini ~
vencimeto_fim dat_pay_ad_ini dat_pay_ad_fim dat_pay_pc_ini dat_pay_pc_fim ~
request_passenger_CPF_ini request_passenger_CPF_fim tg-viagem-nacional ~
tg-cartao-credito tg-prestacao-contas tg-todas Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS request_company_name_ini ~
request_company_name_fim request_number_arb_ini request_number_arb_fim ~
advance_include_date_ini advance_include_date_fim vencimeto_ini ~
vencimeto_fim dat_pay_ad_ini dat_pay_ad_fim dat_pay_pc_ini dat_pay_pc_fim ~
request_passenger_CPF_ini request_passenger_CPF_fim tg-viagem-nacional ~
tg-cartao-credito tg-prestacao-contas tg-todas 

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

DEFINE VARIABLE advance_include_date_fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE advance_include_date_ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Implanta‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE dat_pay_ad_fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE dat_pay_ad_ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Pagamento" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE dat_pay_pc_fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE dat_pay_pc_ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Presta‡Æo de Contas" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE request_company_name_fim AS CHARACTER FORMAT "X(64)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE request_company_name_ini AS CHARACTER FORMAT "X(64)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE request_number_arb_fim AS CHARACTER FORMAT "X(64)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE request_number_arb_ini AS CHARACTER FORMAT "X(64)":U 
     LABEL "N£mero Solicita‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE request_passenger_CPF_fim AS CHARACTER FORMAT "X(14)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE request_passenger_CPF_ini AS CHARACTER FORMAT "X(14)":U 
     LABEL "CPF" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE vencimeto_fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE vencimeto_ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

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

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
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

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 96.72 BY 7.75.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 96.72 BY 5.5.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32 BY 4.63.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 96 BY 1.38
     BGCOLOR 7 .

DEFINE VARIABLE tg-cartao-credito AS LOGICAL INITIAL no 
     LABEL "CartÆo de Cr‚dito" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tg-prestacao-contas AS LOGICAL INITIAL no 
     LABEL "Presta‡Æo de Contas" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE tg-todas AS LOGICAL INITIAL no 
     LABEL "Todas" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-viagem-nacional AS LOGICAL INITIAL no 
     LABEL "Viagem Nacional" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     request_company_name_ini AT ROW 1.67 COL 16 WIDGET-ID 98
     request_company_name_fim AT ROW 1.67 COL 61 NO-LABEL WIDGET-ID 60
     request_number_arb_ini AT ROW 2.67 COL 14 WIDGET-ID 14
     request_number_arb_fim AT ROW 2.67 COL 61 NO-LABEL WIDGET-ID 62
     advance_include_date_ini AT ROW 3.67 COL 15.14 WIDGET-ID 22
     advance_include_date_fim AT ROW 3.67 COL 61 NO-LABEL WIDGET-ID 64
     vencimeto_ini AT ROW 4.67 COL 15.43 WIDGET-ID 30
     vencimeto_fim AT ROW 4.67 COL 61 NO-LABEL WIDGET-ID 66
     dat_pay_ad_ini AT ROW 5.67 COL 15.71 WIDGET-ID 38
     dat_pay_ad_fim AT ROW 5.67 COL 61 NO-LABEL WIDGET-ID 68
     dat_pay_pc_ini AT ROW 6.67 COL 9.28 WIDGET-ID 46
     dat_pay_pc_fim AT ROW 6.67 COL 61 NO-LABEL WIDGET-ID 70
     request_passenger_CPF_ini AT ROW 7.67 COL 24.28 WIDGET-ID 54
     request_passenger_CPF_fim AT ROW 7.67 COL 61 NO-LABEL WIDGET-ID 72
     tg-viagem-nacional AT ROW 10.33 COL 9.86 WIDGET-ID 84
     tg-cartao-credito AT ROW 11.33 COL 9.86 WIDGET-ID 86
     tg-prestacao-contas AT ROW 12.33 COL 9.86 WIDGET-ID 88
     tg-todas AT ROW 13.33 COL 9.86 WIDGET-ID 90
     Btn_OK AT ROW 15 COL 3
     Btn_Cancel AT ROW 15 COL 14
     "Tipo Solicita‡Æo" VIEW-AS TEXT
          SIZE 12 BY .54 AT ROW 9.58 COL 6 WIDGET-ID 94
     "Faixa" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 1 COL 2.14 WIDGET-ID 80
     "Filtro" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 9.04 COL 2.29 WIDGET-ID 82
     rt-button AT ROW 14.83 COL 2 WIDGET-ID 2
     IMAGE-1 AT ROW 1.67 COL 42.86 WIDGET-ID 8
     IMAGE-2 AT ROW 1.67 COL 58.14 WIDGET-ID 10
     IMAGE-3 AT ROW 2.67 COL 42.86 WIDGET-ID 16
     IMAGE-4 AT ROW 2.67 COL 58.14 WIDGET-ID 18
     IMAGE-5 AT ROW 3.67 COL 42.86 WIDGET-ID 24
     IMAGE-6 AT ROW 3.67 COL 58.14 WIDGET-ID 26
     IMAGE-7 AT ROW 4.67 COL 42.86 WIDGET-ID 32
     IMAGE-8 AT ROW 4.67 COL 58.14 WIDGET-ID 34
     IMAGE-9 AT ROW 5.67 COL 42.86 WIDGET-ID 40
     IMAGE-10 AT ROW 5.67 COL 58.14 WIDGET-ID 42
     IMAGE-11 AT ROW 6.67 COL 42.86 WIDGET-ID 50
     IMAGE-12 AT ROW 6.67 COL 58.14 WIDGET-ID 48
     IMAGE-13 AT ROW 7.67 COL 42.86 WIDGET-ID 56
     IMAGE-14 AT ROW 7.67 COL 58.14 WIDGET-ID 58
     RECT-34 AT ROW 9.25 COL 1.43 WIDGET-ID 78
     RECT-35 AT ROW 9.83 COL 5 WIDGET-ID 92
     RECT-33 AT ROW 1.25 COL 1.43 WIDGET-ID 100
     SPACE(0.56) SKIP(7.45)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 7
         TITLE "ala0002a"
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

/* SETTINGS FOR FILL-IN advance_include_date_fim IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN advance_include_date_ini IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN dat_pay_ad_fim IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN dat_pay_ad_ini IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN dat_pay_pc_fim IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN dat_pay_pc_ini IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN request_company_name_fim IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN request_company_name_ini IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN request_number_arb_fim IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN request_number_arb_ini IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN request_passenger_CPF_fim IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN request_passenger_CPF_ini IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN vencimeto_fim IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN vencimeto_ini IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* ala0002a */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
    ASSIGN p_request_company_name_ini  = INPUT FRAME {&FRAME-NAME} request_company_name_ini  
           p_request_company_name_fim  = INPUT FRAME {&FRAME-NAME} request_company_name_fim  
           p_request_number_arb_ini    = INPUT FRAME {&FRAME-NAME} request_number_arb_ini        
           p_request_number_arb_fim    = INPUT FRAME {&FRAME-NAME} request_number_arb_fim        
           p_advance_include_date_ini  = INPUT FRAME {&FRAME-NAME} advance_include_date_ini  
           p_advance_include_date_fim  = INPUT FRAME {&FRAME-NAME} advance_include_date_fim  
           p_vencimeto_ini    = INPUT FRAME {&FRAME-NAME} vencimeto_ini    
           p_vencimeto_fim    = INPUT FRAME {&FRAME-NAME} vencimeto_fim    
           p_dat_pay_ad_ini            = INPUT FRAME {&FRAME-NAME} dat_pay_ad_ini            
           p_dat_pay_ad_fim            = INPUT FRAME {&FRAME-NAME} dat_pay_ad_fim            
           p_dat_pay_pc_ini            = INPUT FRAME {&FRAME-NAME} dat_pay_pc_ini            
           p_dat_pay_pc_fim            = INPUT FRAME {&FRAME-NAME} dat_pay_pc_fim            
           p_request_passenger_CPF_ini = INPUT FRAME {&FRAME-NAME} request_passenger_CPF_ini 
           p_request_passenger_CPF_fim = INPUT FRAME {&FRAME-NAME} request_passenger_CPF_fim
           p_viagem_nacional           = INPUT FRAME {&FRAME-NAME} tg-viagem-nacional
           p_cartao_credito            = INPUT FRAME {&FRAME-NAME} tg-cartao-credito
           p_prestacao_contas          = INPUT FRAME {&FRAME-NAME} tg-prestacao-contas
           p_ok                        = YES. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-todas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-todas Dialog-Frame
ON VALUE-CHANGED OF tg-todas IN FRAME Dialog-Frame /* Todas */
DO:
    IF SELF:CHECKED THEN DO:
        ASSIGN tg-viagem-nacional :CHECKED IN FRAME {&FRAME-NAME} = YES
               tg-cartao-credito  :CHECKED IN FRAME {&FRAME-NAME} = YES
               tg-prestacao-contas:CHECKED IN FRAME {&FRAME-NAME} = YES
               tg-viagem-nacional :SENSITIVE IN FRAME {&FRAME-NAME} = NO   
               tg-cartao-credito  :SENSITIVE IN FRAME {&FRAME-NAME} = NO
               tg-prestacao-contas:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE DO:
        ASSIGN tg-viagem-nacional :SENSITIVE IN FRAME {&FRAME-NAME} = YES   
               tg-cartao-credito  :SENSITIVE IN FRAME {&FRAME-NAME} = YES
               tg-prestacao-contas:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END.
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

    IF NOT VALID-HANDLE(h-facelift) THEN
        RUN btb/btb901zo.p PERSISTENT SET h-facelift.
    
    RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME Dialog-Frame:HANDLE).

    ASSIGN request_company_name_ini  = p_request_company_name_ini
           request_company_name_fim  = p_request_company_name_fim
           request_number_arb_ini    = p_request_number_arb_ini
           request_number_arb_fim    = p_request_number_arb_fim
           advance_include_date_ini  = p_advance_include_date_ini
           advance_include_date_fim  = p_advance_include_date_fim
           vencimeto_ini    = p_vencimeto_ini
           vencimeto_fim    = p_vencimeto_fim
           dat_pay_ad_ini            = p_dat_pay_ad_ini
           dat_pay_ad_fim            = p_dat_pay_ad_fim
           dat_pay_pc_ini            = p_dat_pay_pc_ini
           dat_pay_pc_fim            = p_dat_pay_pc_fim
           request_passenger_CPF_ini = p_request_passenger_CPF_ini
           request_passenger_CPF_fim = p_request_passenger_CPF_fim
           tg-viagem-nacional        = p_viagem_nacional 
           tg-cartao-credito         = p_cartao_credito  
           tg-prestacao-contas       = p_prestacao_contas.


      DISPLAY request_company_name_ini
              request_company_name_fim
              request_number_arb_ini
              request_number_arb_fim
              advance_include_date_ini
              advance_include_date_fim
              vencimeto_ini
              vencimeto_fim
              dat_pay_ad_ini
              dat_pay_ad_fim
              dat_pay_pc_ini
              dat_pay_pc_fim
              request_passenger_CPF_ini
              request_passenger_CPF_fim 
              tg-viagem-nacional 
              tg-cartao-credito  
              tg-prestacao-contas WITH FRAME Dialog-Frame.
    
      APPLY "VALUE-CHANGED" TO tg-todas IN FRAME Dialog-Frame.

    WAIT-FOR GO OF FRAME Dialog-Frame.
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
  DISPLAY request_company_name_ini request_company_name_fim 
          request_number_arb_ini request_number_arb_fim advance_include_date_ini 
          advance_include_date_fim vencimeto_ini vencimeto_fim dat_pay_ad_ini 
          dat_pay_ad_fim dat_pay_pc_ini dat_pay_pc_fim request_passenger_CPF_ini 
          request_passenger_CPF_fim tg-viagem-nacional tg-cartao-credito 
          tg-prestacao-contas tg-todas 
      WITH FRAME Dialog-Frame.
  ENABLE rt-button IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 IMAGE-7 
         IMAGE-8 IMAGE-9 IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 RECT-34 
         RECT-35 RECT-33 request_company_name_ini request_company_name_fim 
         request_number_arb_ini request_number_arb_fim advance_include_date_ini 
         advance_include_date_fim vencimeto_ini vencimeto_fim dat_pay_ad_ini 
         dat_pay_ad_fim dat_pay_pc_ini dat_pay_pc_fim request_passenger_CPF_ini 
         request_passenger_CPF_fim tg-viagem-nacional tg-cartao-credito 
         tg-prestacao-contas tg-todas Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

