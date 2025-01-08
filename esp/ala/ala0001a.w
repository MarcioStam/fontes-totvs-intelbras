&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt_int_param_alatur NO-UNDO LIKE int_param_alatur.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ala0001a 2.00.00.000}

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-hist

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt_int_param_alatur

/* Definitions for BROWSE br-hist                                       */
&Scoped-define FIELDS-IN-QUERY-br-hist ~
tt_int_param_alatur.cod_usuar_ult_atualiz ~
tt_int_param_alatur.dat_ult_atualiz tt_int_param_alatur.hra_ult_atualiz ~
tt_int_param_alatur.dat_inicio_integracao ~
tt_int_param_alatur.log_integra_an tt_int_param_alatur.log_integra_pc ~
tt_int_param_alatur.cod_estab_ad tt_int_param_alatur.cod_espec_docto_ad ~
tt_int_param_alatur.cod_ser_docto_ad tt_int_param_alatur.cod_portador_ad ~
tt_int_param_alatur.cod_tip_fluxo_financ_ad ~
tt_int_param_alatur.cod_unid_negoc_ad ~
tt_int_param_alatur.num_dias_integra_ad ~
tt_int_param_alatur.num_dias_vencto_ad ~
tt_int_param_alatur.cod_email_integracao_ad ~
tt_int_param_alatur.cod_param_ad tt_int_param_alatur.cod_param_ad_viagem ~
tt_int_param_alatur.cod_estab_cr tt_int_param_alatur.cod_espec_docto_cr ~
tt_int_param_alatur.cod_ser_docto_cr ~
tt_int_param_alatur.cod_tip_fluxo_financ_cr ~
tt_int_param_alatur.cod_unid_negoc_cr tt_int_param_alatur.cod_cta_ctbl_cr ~
tt_int_param_alatur.num_dias_integra_cr ~
tt_int_param_alatur.num_dias_vencto_cr ~
tt_int_param_alatur.cod_email_integracao_cr ~
tt_int_param_alatur.cod_param_ad_cr tt_int_param_alatur.cod_espec_docto_pc ~
tt_int_param_alatur.cod_ser_docto_pc tt_int_param_alatur.cod_portador_pc ~
tt_int_param_alatur.cod_tip_fluxo_financ_pc ~
tt_int_param_alatur.cod_forma_pagto_pc ~
tt_int_param_alatur.num_dias_integra_pc ~
tt_int_param_alatur.num_dias_vencto_pc ~
tt_int_param_alatur.cod_email_integracao_pc ~
tt_int_param_alatur.cod_param_pc tt_int_param_alatur.cod_param_pc_ad ~
tt_int_param_alatur.cod_param_pc_ad_viagem 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-hist 
&Scoped-define QUERY-STRING-br-hist FOR EACH tt_int_param_alatur NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-hist OPEN QUERY br-hist FOR EACH tt_int_param_alatur NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-hist tt_int_param_alatur
&Scoped-define FIRST-TABLE-IN-QUERY-br-hist tt_int_param_alatur


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-hist}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button br-hist bt-ok bt-cancela bt-ajuda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 151 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-hist FOR 
      tt_int_param_alatur SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-hist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-hist w-cadsim _STRUCTURED
  QUERY br-hist NO-LOCK DISPLAY
      tt_int_param_alatur.cod_usuar_ult_atualiz FORMAT "x(12)":U
      tt_int_param_alatur.dat_ult_atualiz FORMAT "99/99/9999":U
      tt_int_param_alatur.hra_ult_atualiz FORMAT "99:99:99":U
      tt_int_param_alatur.dat_inicio_integracao FORMAT "99/99/9999":U
      tt_int_param_alatur.log_integra_an FORMAT "yes/no":U
      tt_int_param_alatur.log_integra_pc FORMAT "yes/no":U
      tt_int_param_alatur.cod_estab_ad FORMAT "x(5)":U
      tt_int_param_alatur.cod_espec_docto_ad FORMAT "x(3)":U
      tt_int_param_alatur.cod_ser_docto_ad FORMAT "x(5)":U
      tt_int_param_alatur.cod_portador_ad FORMAT "x(5)":U
      tt_int_param_alatur.cod_tip_fluxo_financ_ad FORMAT "x(12)":U
      tt_int_param_alatur.cod_unid_negoc_ad FORMAT "x(3)":U
      tt_int_param_alatur.num_dias_integra_ad FORMAT "999":U WIDTH 13
      tt_int_param_alatur.num_dias_vencto_ad FORMAT "99":U WIDTH 14
      tt_int_param_alatur.cod_email_integracao_ad FORMAT "x(200)":U
            WIDTH 20
      tt_int_param_alatur.cod_param_ad FORMAT "x(30)":U
      tt_int_param_alatur.cod_param_ad_viagem FORMAT "x(30)":U
      tt_int_param_alatur.cod_estab_cr FORMAT "x(5)":U
      tt_int_param_alatur.cod_espec_docto_cr FORMAT "x(3)":U
      tt_int_param_alatur.cod_ser_docto_cr FORMAT "x(5)":U
      tt_int_param_alatur.cod_tip_fluxo_financ_cr FORMAT "x(12)":U
      tt_int_param_alatur.cod_unid_negoc_cr FORMAT "x(3)":U
      tt_int_param_alatur.cod_cta_ctbl_cr FORMAT "x(8)":U
      tt_int_param_alatur.num_dias_integra_cr FORMAT "999":U WIDTH 13
      tt_int_param_alatur.num_dias_vencto_cr FORMAT "99":U WIDTH 14
      tt_int_param_alatur.cod_email_integracao_cr FORMAT "x(200)":U
            WIDTH 20
      tt_int_param_alatur.cod_param_ad_cr FORMAT "x(30)":U
      tt_int_param_alatur.cod_espec_docto_pc FORMAT "x(3)":U
      tt_int_param_alatur.cod_ser_docto_pc FORMAT "x(5)":U
      tt_int_param_alatur.cod_portador_pc FORMAT "x(5)":U
      tt_int_param_alatur.cod_tip_fluxo_financ_pc FORMAT "x(12)":U
      tt_int_param_alatur.cod_forma_pagto_pc FORMAT "x(3)":U
      tt_int_param_alatur.num_dias_integra_pc FORMAT "999":U WIDTH 13
      tt_int_param_alatur.num_dias_vencto_pc FORMAT "99":U WIDTH 14
      tt_int_param_alatur.cod_email_integracao_pc FORMAT "x(200)":U
            WIDTH 20
      tt_int_param_alatur.cod_param_pc FORMAT "x(30)":U
      tt_int_param_alatur.cod_param_pc_ad FORMAT "x(30)":U
      tt_int_param_alatur.cod_param_pc_ad_viagem FORMAT "x(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 150 BY 19.25
         FONT 7 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     br-hist AT ROW 1.25 COL 2 WIDGET-ID 200
     bt-ok AT ROW 20.96 COL 2
     bt-cancela AT ROW 20.96 COL 13
     bt-ajuda AT ROW 20.96 COL 140
     rt-button AT ROW 20.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 151.43 BY 21.33
         FONT 7 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt_int_param_alatur T "?" NO-UNDO mgesp int_param_alatur
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo <Insira o complemento>"
         HEIGHT             = 21.33
         WIDTH              = 151.57
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 151.57
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 151.57
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
/* BROWSE-TAB br-hist rt-button f-cad */
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-hist
/* Query rebuild information for BROWSE br-hist
     _TblList          = "Temp-Tables.tt_int_param_alatur"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.tt_int_param_alatur.cod_usuar_ult_atualiz
     _FldNameList[2]   = Temp-Tables.tt_int_param_alatur.dat_ult_atualiz
     _FldNameList[3]   = Temp-Tables.tt_int_param_alatur.hra_ult_atualiz
     _FldNameList[4]   = Temp-Tables.tt_int_param_alatur.dat_inicio_integracao
     _FldNameList[5]   = Temp-Tables.tt_int_param_alatur.log_integra_an
     _FldNameList[6]   = Temp-Tables.tt_int_param_alatur.log_integra_pc
     _FldNameList[7]   = Temp-Tables.tt_int_param_alatur.cod_estab_ad
     _FldNameList[8]   = Temp-Tables.tt_int_param_alatur.cod_espec_docto_ad
     _FldNameList[9]   = Temp-Tables.tt_int_param_alatur.cod_ser_docto_ad
     _FldNameList[10]   = Temp-Tables.tt_int_param_alatur.cod_portador_ad
     _FldNameList[11]   = Temp-Tables.tt_int_param_alatur.cod_tip_fluxo_financ_ad
     _FldNameList[12]   = Temp-Tables.tt_int_param_alatur.cod_unid_negoc_ad
     _FldNameList[13]   > Temp-Tables.tt_int_param_alatur.num_dias_integra_ad
"tt_int_param_alatur.num_dias_integra_ad" ? ? "integer" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tt_int_param_alatur.num_dias_vencto_ad
"tt_int_param_alatur.num_dias_vencto_ad" ? ? "integer" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.tt_int_param_alatur.cod_email_integracao_ad
"tt_int_param_alatur.cod_email_integracao_ad" ? ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   = Temp-Tables.tt_int_param_alatur.cod_param_ad
     _FldNameList[17]   = Temp-Tables.tt_int_param_alatur.cod_param_ad_viagem
     _FldNameList[18]   = Temp-Tables.tt_int_param_alatur.cod_estab_cr
     _FldNameList[19]   = Temp-Tables.tt_int_param_alatur.cod_espec_docto_cr
     _FldNameList[20]   = Temp-Tables.tt_int_param_alatur.cod_ser_docto_cr
     _FldNameList[21]   = Temp-Tables.tt_int_param_alatur.cod_tip_fluxo_financ_cr
     _FldNameList[22]   = Temp-Tables.tt_int_param_alatur.cod_unid_negoc_cr
     _FldNameList[23]   = Temp-Tables.tt_int_param_alatur.cod_cta_ctbl_cr
     _FldNameList[24]   > Temp-Tables.tt_int_param_alatur.num_dias_integra_cr
"tt_int_param_alatur.num_dias_integra_cr" ? ? "integer" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > Temp-Tables.tt_int_param_alatur.num_dias_vencto_cr
"tt_int_param_alatur.num_dias_vencto_cr" ? ? "integer" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > Temp-Tables.tt_int_param_alatur.cod_email_integracao_cr
"tt_int_param_alatur.cod_email_integracao_cr" ? ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   = Temp-Tables.tt_int_param_alatur.cod_param_ad_cr
     _FldNameList[28]   = Temp-Tables.tt_int_param_alatur.cod_espec_docto_pc
     _FldNameList[29]   = Temp-Tables.tt_int_param_alatur.cod_ser_docto_pc
     _FldNameList[30]   = Temp-Tables.tt_int_param_alatur.cod_portador_pc
     _FldNameList[31]   = Temp-Tables.tt_int_param_alatur.cod_tip_fluxo_financ_pc
     _FldNameList[32]   = Temp-Tables.tt_int_param_alatur.cod_forma_pagto_pc
     _FldNameList[33]   > Temp-Tables.tt_int_param_alatur.num_dias_integra_pc
"tt_int_param_alatur.num_dias_integra_pc" ? ? "integer" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[34]   > Temp-Tables.tt_int_param_alatur.num_dias_vencto_pc
"tt_int_param_alatur.num_dias_vencto_pc" ? ? "integer" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[35]   > Temp-Tables.tt_int_param_alatur.cod_email_integracao_pc
"tt_int_param_alatur.cod_email_integracao_pc" ? ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[36]   = Temp-Tables.tt_int_param_alatur.cod_param_pc
     _FldNameList[37]   = Temp-Tables.tt_int_param_alatur.cod_param_pc_ad
     _FldNameList[38]   = Temp-Tables.tt_int_param_alatur.cod_param_pc_ad_viagem
     _Query            is OPENED
*/  /* BROWSE br-hist */
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


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-cadsim
ON CHOOSE OF bt-ajuda IN FRAME f-cad /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
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


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-cadsim
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-hist
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
  ENABLE rt-button br-hist bt-ok bt-cancela bt-ajuda 
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

  {utp/ut9000.i "ala0001a" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch  IN this-procedure ('enable-fields':U).

  {include/i-inifld.i}

  RUN pi-open-query.
   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-open-query w-cadsim 
PROCEDURE pi-open-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt_int_param_alatur.

    FOR EACH int_param_alatur NO-LOCK:
        CREATE tt_int_param_alatur.
        BUFFER-COPY int_param_alatur TO tt_int_param_alatur.
    END.
    {&open-query-br-hist}
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
  {src/adm/template/snd-list.i "tt_int_param_alatur"}

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

