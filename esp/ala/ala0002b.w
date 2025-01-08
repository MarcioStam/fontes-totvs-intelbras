&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ala0002b 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.

DEFINE INPUT PARAM p_rowid AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES int_solicitacao_alatur

/* Definitions for FRAME f-cad                                          */
&Scoped-define FIELDS-IN-QUERY-f-cad ~
int_solicitacao_alatur.request_number_arb ~
int_solicitacao_alatur.cod_usuar_pay_pc ~
int_solicitacao_alatur.request_expense_status_ad ~
int_solicitacao_alatur.account_name int_solicitacao_alatur.dat_create_ad ~
int_solicitacao_alatur.request_expense_status_pc ~
int_solicitacao_alatur.advance_expense int_solicitacao_alatur.dat_create_pc ~
int_solicitacao_alatur.request_passenger_bank ~
int_solicitacao_alatur.advance_final_date int_solicitacao_alatur.dat_pay_ad ~
int_solicitacao_alatur.request_passenger_branch_number ~
int_solicitacao_alatur.advance_include_date ~
int_solicitacao_alatur.dat_pay_pc ~
int_solicitacao_alatur.request_passenger_checking_acc ~
int_solicitacao_alatur.advance_initial_date ~
int_solicitacao_alatur.hra_create_ad ~
int_solicitacao_alatur.request_passenger_CPF ~
int_solicitacao_alatur.advance_price int_solicitacao_alatur.hra_create_pc ~
int_solicitacao_alatur.request_status_ad ~
int_solicitacao_alatur.advance_quantity int_solicitacao_alatur.hra_pay_ad ~
int_solicitacao_alatur.request_status_pc ~
int_solicitacao_alatur.cod_refer_antecip_pef_pend ~
int_solicitacao_alatur.hra_pay_pc int_solicitacao_alatur.val_total_ad ~
int_solicitacao_alatur.cod_usuar_create_ad ~
int_solicitacao_alatur.num_id_tit_ap ~
int_solicitacao_alatur.val_total_devolucao_pc ~
int_solicitacao_alatur.cod_usuar_create_pc ~
int_solicitacao_alatur.request_arb_id int_solicitacao_alatur.val_total_pc ~
int_solicitacao_alatur.cod_usuar_pay_ad ~
int_solicitacao_alatur.request_company_name ~
int_solicitacao_alatur.val_total_reembolso_pc ~
int_solicitacao_alatur.advance_hitor_rateio ~
int_solicitacao_alatur.refund_histor_rateio ~
int_solicitacao_alatur.advance_note 
&Scoped-define QUERY-STRING-f-cad FOR EACH int_solicitacao_alatur SHARE-LOCK
&Scoped-define OPEN-QUERY-f-cad OPEN QUERY f-cad FOR EACH int_solicitacao_alatur SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-f-cad int_solicitacao_alatur
&Scoped-define FIRST-TABLE-IN-QUERY-f-cad int_solicitacao_alatur


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-1 RECT-2 bt-ok bt-cancela 
&Scoped-Define DISPLAYED-FIELDS int_solicitacao_alatur.request_number_arb ~
int_solicitacao_alatur.cod_usuar_pay_pc ~
int_solicitacao_alatur.request_expense_status_ad ~
int_solicitacao_alatur.account_name int_solicitacao_alatur.dat_create_ad ~
int_solicitacao_alatur.request_expense_status_pc ~
int_solicitacao_alatur.advance_expense int_solicitacao_alatur.dat_create_pc ~
int_solicitacao_alatur.request_passenger_bank ~
int_solicitacao_alatur.advance_final_date int_solicitacao_alatur.dat_pay_ad ~
int_solicitacao_alatur.request_passenger_branch_number ~
int_solicitacao_alatur.advance_include_date ~
int_solicitacao_alatur.dat_pay_pc ~
int_solicitacao_alatur.request_passenger_checking_acc ~
int_solicitacao_alatur.advance_initial_date ~
int_solicitacao_alatur.hra_create_ad ~
int_solicitacao_alatur.request_passenger_CPF ~
int_solicitacao_alatur.advance_price int_solicitacao_alatur.hra_create_pc ~
int_solicitacao_alatur.request_status_ad ~
int_solicitacao_alatur.advance_quantity int_solicitacao_alatur.hra_pay_ad ~
int_solicitacao_alatur.request_status_pc ~
int_solicitacao_alatur.cod_refer_antecip_pef_pend ~
int_solicitacao_alatur.hra_pay_pc int_solicitacao_alatur.val_total_ad ~
int_solicitacao_alatur.cod_usuar_create_ad ~
int_solicitacao_alatur.num_id_tit_ap ~
int_solicitacao_alatur.val_total_devolucao_pc ~
int_solicitacao_alatur.cod_usuar_create_pc ~
int_solicitacao_alatur.request_arb_id int_solicitacao_alatur.val_total_pc ~
int_solicitacao_alatur.cod_usuar_pay_ad ~
int_solicitacao_alatur.request_company_name ~
int_solicitacao_alatur.val_total_reembolso_pc ~
int_solicitacao_alatur.advance_hitor_rateio ~
int_solicitacao_alatur.refund_histor_rateio ~
int_solicitacao_alatur.advance_note 
&Scoped-define DISPLAYED-TABLES int_solicitacao_alatur
&Scoped-define FIRST-DISPLAYED-TABLE int_solicitacao_alatur


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 151 BY 13.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 151 BY 9.42.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 151.14 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY f-cad FOR 
      int_solicitacao_alatur SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     int_solicitacao_alatur.request_number_arb AT ROW 2.25 COL 25 COLON-ALIGNED WIDGET-ID 58
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     int_solicitacao_alatur.cod_usuar_pay_pc AT ROW 2.25 COL 73 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.request_expense_status_ad AT ROW 2.25 COL 125 COLON-ALIGNED WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     int_solicitacao_alatur.account_name AT ROW 3.25 COL 25 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     int_solicitacao_alatur.dat_create_ad AT ROW 3.25 COL 73 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.request_expense_status_pc AT ROW 3.25 COL 125 COLON-ALIGNED WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     int_solicitacao_alatur.advance_expense AT ROW 4.25 COL 25 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     int_solicitacao_alatur.dat_create_pc AT ROW 4.25 COL 73 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.request_passenger_bank AT ROW 4.25 COL 125 COLON-ALIGNED WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.advance_final_date AT ROW 5.25 COL 25 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.dat_pay_ad AT ROW 5.25 COL 73 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.request_passenger_branch_number AT ROW 5.25 COL 125 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     int_solicitacao_alatur.advance_include_date AT ROW 6.25 COL 25 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.dat_pay_pc AT ROW 6.25 COL 73 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.request_passenger_checking_acc AT ROW 6.25 COL 125 COLON-ALIGNED WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     int_solicitacao_alatur.advance_initial_date AT ROW 7.25 COL 25 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.hra_create_ad AT ROW 7.25 COL 73 COLON-ALIGNED WIDGET-ID 38 FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.request_passenger_CPF AT ROW 7.25 COL 125 COLON-ALIGNED WIDGET-ID 66
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     int_solicitacao_alatur.advance_price AT ROW 8.25 COL 25 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.hra_create_pc AT ROW 8.25 COL 73 COLON-ALIGNED WIDGET-ID 40 FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.request_status_ad AT ROW 8.25 COL 125 COLON-ALIGNED WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     int_solicitacao_alatur.advance_quantity AT ROW 9.25 COL 25 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 153 BY 25.21
         FONT 7 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-cad
     int_solicitacao_alatur.hra_pay_ad AT ROW 9.25 COL 73 COLON-ALIGNED WIDGET-ID 42 FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.request_status_pc AT ROW 9.25 COL 125 COLON-ALIGNED WIDGET-ID 70
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     int_solicitacao_alatur.cod_refer_antecip_pef_pend AT ROW 10.25 COL 25 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.hra_pay_pc AT ROW 10.25 COL 73 COLON-ALIGNED WIDGET-ID 44 FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.val_total_ad AT ROW 10.25 COL 125 COLON-ALIGNED WIDGET-ID 72
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.cod_usuar_create_ad AT ROW 11.25 COL 25 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.num_id_tit_ap AT ROW 11.25 COL 73 COLON-ALIGNED WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.val_total_devolucao_pc AT ROW 11.25 COL 125 COLON-ALIGNED WIDGET-ID 74
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.cod_usuar_create_pc AT ROW 12.25 COL 25 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.request_arb_id AT ROW 12.25 COL 73 COLON-ALIGNED WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     int_solicitacao_alatur.val_total_pc AT ROW 12.25 COL 125 COLON-ALIGNED WIDGET-ID 76
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.cod_usuar_pay_ad AT ROW 13.25 COL 25 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.request_company_name AT ROW 13.25 COL 73 COLON-ALIGNED WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     int_solicitacao_alatur.val_total_reembolso_pc AT ROW 13.25 COL 125 COLON-ALIGNED WIDGET-ID 78
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     int_solicitacao_alatur.advance_hitor_rateio AT ROW 15.25 COL 27 NO-LABEL WIDGET-ID 88
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 45 BY 4
     int_solicitacao_alatur.refund_histor_rateio AT ROW 15.25 COL 91.72 NO-LABEL WIDGET-ID 92
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 45 BY 4
     int_solicitacao_alatur.advance_note AT ROW 19.75 COL 27 NO-LABEL WIDGET-ID 96
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 110 BY 4
     bt-ok AT ROW 24.58 COL 3
     bt-cancela AT ROW 24.58 COL 14
     "Observa‡äes:" VIEW-AS TEXT
          SIZE 9.86 BY .54 AT ROW 19.75 COL 17.14 WIDGET-ID 98
     "Hist¢rico Reembolso:" VIEW-AS TEXT
          SIZE 14.43 BY .54 AT ROW 15.25 COL 77 WIDGET-ID 94
     "Hist¢rico Rateio:" VIEW-AS TEXT
          SIZE 11 BY .54 AT ROW 15.25 COL 15.43 WIDGET-ID 90
     rt-button AT ROW 24.38 COL 1.86
     RECT-1 AT ROW 1.25 COL 2 WIDGET-ID 100
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 153 BY 25.21
         FONT 7 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-cad
     RECT-2 AT ROW 14.75 COL 2 WIDGET-ID 102
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 153 BY 25.21
         FONT 7 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo <Insira o complemento>"
         HEIGHT             = 25.21
         WIDTH              = 153
         MAX-HEIGHT         = 25.21
         MAX-WIDTH          = 166.29
         VIRTUAL-HEIGHT     = 25.21
         VIRTUAL-WIDTH      = 166.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.account_name IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.advance_expense IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.advance_final_date IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR int_solicitacao_alatur.advance_hitor_rateio IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.advance_include_date IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.advance_initial_date IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR int_solicitacao_alatur.advance_note IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.advance_price IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.advance_quantity IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.cod_refer_antecip_pef_pend IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.cod_usuar_create_ad IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.cod_usuar_create_pc IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.cod_usuar_pay_ad IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.cod_usuar_pay_pc IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.dat_create_ad IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.dat_create_pc IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.dat_pay_ad IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.dat_pay_pc IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.hra_create_ad IN FRAME f-cad
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.hra_create_pc IN FRAME f-cad
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.hra_pay_ad IN FRAME f-cad
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.hra_pay_pc IN FRAME f-cad
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.num_id_tit_ap IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR int_solicitacao_alatur.refund_histor_rateio IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.request_arb_id IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.request_company_name IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.request_expense_status_ad IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.request_expense_status_pc IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.request_number_arb IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.request_passenger_bank IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.request_passenger_branch_number IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.request_passenger_checking_acc IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.request_passenger_CPF IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.request_status_ad IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.request_status_pc IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.val_total_ad IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.val_total_devolucao_pc IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.val_total_pc IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_solicitacao_alatur.val_total_reembolso_pc IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-cad
/* Query rebuild information for FRAME f-cad
     _TblList          = "mgesp.int_solicitacao_alatur"
     _Query            is OPENED
*/  /* FRAME f-cad */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-cadsim
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancelar */
DO:
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
  RUN notify ('update-record':U).
  if return-value <> "adm-error":U then
     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-f-cad}
  GET FIRST f-cad.
  IF AVAILABLE int_solicitacao_alatur THEN 
    DISPLAY int_solicitacao_alatur.request_number_arb 
          int_solicitacao_alatur.cod_usuar_pay_pc 
          int_solicitacao_alatur.request_expense_status_ad 
          int_solicitacao_alatur.account_name 
          int_solicitacao_alatur.dat_create_ad 
          int_solicitacao_alatur.request_expense_status_pc 
          int_solicitacao_alatur.advance_expense 
          int_solicitacao_alatur.dat_create_pc 
          int_solicitacao_alatur.request_passenger_bank 
          int_solicitacao_alatur.advance_final_date 
          int_solicitacao_alatur.dat_pay_ad 
          int_solicitacao_alatur.request_passenger_branch_number 
          int_solicitacao_alatur.advance_include_date 
          int_solicitacao_alatur.dat_pay_pc 
          int_solicitacao_alatur.request_passenger_checking_acc 
          int_solicitacao_alatur.advance_initial_date 
          int_solicitacao_alatur.hra_create_ad 
          int_solicitacao_alatur.request_passenger_CPF 
          int_solicitacao_alatur.advance_price 
          int_solicitacao_alatur.hra_create_pc 
          int_solicitacao_alatur.request_status_ad 
          int_solicitacao_alatur.advance_quantity 
          int_solicitacao_alatur.hra_pay_ad 
          int_solicitacao_alatur.request_status_pc 
          int_solicitacao_alatur.cod_refer_antecip_pef_pend 
          int_solicitacao_alatur.hra_pay_pc int_solicitacao_alatur.val_total_ad 
          int_solicitacao_alatur.cod_usuar_create_ad 
          int_solicitacao_alatur.num_id_tit_ap 
          int_solicitacao_alatur.val_total_devolucao_pc 
          int_solicitacao_alatur.cod_usuar_create_pc 
          int_solicitacao_alatur.request_arb_id 
          int_solicitacao_alatur.val_total_pc 
          int_solicitacao_alatur.cod_usuar_pay_ad 
          int_solicitacao_alatur.request_company_name 
          int_solicitacao_alatur.val_total_reembolso_pc 
          int_solicitacao_alatur.advance_hitor_rateio 
          int_solicitacao_alatur.refund_histor_rateio 
          int_solicitacao_alatur.advance_note 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button RECT-1 RECT-2 bt-ok bt-cancela 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "ala0002" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  FIND FIRST int_solicitacao_alatur NO-LOCK
       WHERE ROWID(int_solicitacao_alatur) = p_rowid NO-ERROR.

  IF AVAIL int_solicitacao_alatur THEN DO:
      DISPLAY int_solicitacao_alatur WITH FRAME f-cad.
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch  IN this-procedure ('enable-fields':U).

  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "int_solicitacao_alatur"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

