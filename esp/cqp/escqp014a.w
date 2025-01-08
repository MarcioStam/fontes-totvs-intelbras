&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
{include/i-prgvrs.i escqp014a 3.00.00.000}
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

{esp/cqp/escqp014.i}

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-parametros.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 ~
IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 RECT-10 RECT-11 RECT-12 RECT-13 IMAGE-9 ~
IMAGE-10 IMAGE-11 IMAGE-12 cod-estabel-ini cod-estabel-fim nr-ficha-cq-ini ~
nr-ficha-cq-fim dt-ficha-ini dt-ficha-fim it-codigo-ini it-codigo-fim ~
des-item-ini des-item-fim cod-depos-ini cod-depos-fim numTempoRefresh ~
logItensCriticos logSomenteWms logOriManual logSitPendente logSitTerminado ~
logOriEstoque logSitEmAnalise logSitCancelado logOriProducao ~
logSitPendenteRetorno logSitPendenteNF logOriManualMovtoEstoque bt-ok ~
bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS cod-estabel-ini cod-estabel-fim ~
nr-ficha-cq-ini nr-ficha-cq-fim dt-ficha-ini dt-ficha-fim it-codigo-ini ~
it-codigo-fim des-item-ini des-item-fim cod-depos-ini cod-depos-fim ~
numTempoRefresh logItensCriticos logSomenteWms logOriManual logSitPendente ~
logSitTerminado logOriEstoque logSitEmAnalise logSitCancelado ~
logOriProducao logSitPendenteRetorno logSitPendenteNF ~
logOriManualMovtoEstoque 

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

DEFINE VARIABLE cod-depos-fim AS CHARACTER FORMAT "X(03)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE cod-depos-ini AS CHARACTER FORMAT "X(03)":U 
     LABEL "Dep¢sito Inicial" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE cod-estabel-fim AS CHARACTER FORMAT "X(05)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE cod-estabel-ini AS CHARACTER FORMAT "X(05)":U 
     LABEL "Estabelecimento Inicial" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE des-item-fim AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE des-item-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descri‡Æo Item Inicial" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-ficha-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-ficha-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Ficha Inicial" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE it-codigo-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE it-codigo-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item Inicial" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE nr-ficha-cq-fim AS INTEGER FORMAT ">>>>>>9":U INITIAL 9999999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE nr-ficha-cq-ini AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "Ficha Inicial" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE numTempoRefresh AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Tempo Refresh (min)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

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

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 4.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 7.25.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 4.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 1.5.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 75 BY 1.38
     BGCOLOR 7 .

DEFINE VARIABLE logItensCriticos AS LOGICAL INITIAL no 
     LABEL "Itens Cr¡ticos?" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.29 BY .83 NO-UNDO.

DEFINE VARIABLE logOriEstoque AS LOGICAL INITIAL no 
     LABEL "Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE logOriManual AS LOGICAL INITIAL no 
     LABEL "Manual" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE logOriManualMovtoEstoque AS LOGICAL INITIAL no 
     LABEL "Manual Movimento Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE logOriProducao AS LOGICAL INITIAL no 
     LABEL "Produ‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE logSitCancelado AS LOGICAL INITIAL no 
     LABEL "Cancelado" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE logSitEmAnalise AS LOGICAL INITIAL no 
     LABEL "Em An lise" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE logSitPendente AS LOGICAL INITIAL no 
     LABEL "Pendente" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE logSitPendenteNF AS LOGICAL INITIAL no 
     LABEL "Pendente NF" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE logSitPendenteRetorno AS LOGICAL INITIAL no 
     LABEL "Pendente Retorno" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE logSitTerminado AS LOGICAL INITIAL no 
     LABEL "Terminado" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE logSomenteWms AS LOGICAL INITIAL no 
     LABEL "Somente WMS" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.29 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     cod-estabel-ini AT ROW 1.75 COL 23 COLON-ALIGNED WIDGET-ID 88
     cod-estabel-fim AT ROW 1.75 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     nr-ficha-cq-ini AT ROW 2.75 COL 23 COLON-ALIGNED WIDGET-ID 2
     nr-ficha-cq-fim AT ROW 2.75 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     dt-ficha-ini AT ROW 3.75 COL 23 COLON-ALIGNED WIDGET-ID 6
     dt-ficha-fim AT ROW 3.75 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     it-codigo-ini AT ROW 4.75 COL 23 COLON-ALIGNED WIDGET-ID 10
     it-codigo-fim AT ROW 4.75 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     des-item-ini AT ROW 5.75 COL 23 COLON-ALIGNED WIDGET-ID 14
     des-item-fim AT ROW 5.75 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     cod-depos-ini AT ROW 6.75 COL 23 COLON-ALIGNED WIDGET-ID 76
     cod-depos-fim AT ROW 6.75 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     numTempoRefresh AT ROW 8.5 COL 22.14 COLON-ALIGNED HELP
          "A unidade de tempo ‚ em minutos" WIDGET-ID 68
     logItensCriticos AT ROW 8.5 COL 40.72 WIDGET-ID 70
     logSomenteWms AT ROW 8.5 COL 58.72 WIDGET-ID 92
     logOriManual AT ROW 10.75 COL 9 WIDGET-ID 38
     logSitPendente AT ROW 11 COL 43 WIDGET-ID 52
     logSitTerminado AT ROW 11 COL 60 WIDGET-ID 58
     logOriEstoque AT ROW 11.5 COL 9 WIDGET-ID 40
     logSitEmAnalise AT ROW 11.75 COL 43 WIDGET-ID 54
     logSitCancelado AT ROW 11.75 COL 60 WIDGET-ID 60
     logOriProducao AT ROW 12.25 COL 9 WIDGET-ID 42
     logSitPendenteRetorno AT ROW 12.5 COL 43 WIDGET-ID 56
     logSitPendenteNF AT ROW 12.5 COL 60 WIDGET-ID 62
     logOriManualMovtoEstoque AT ROW 13 COL 9 WIDGET-ID 44
     bt-ok AT ROW 14.71 COL 3
     bt-cancela AT ROW 14.71 COL 14
     bt-ajuda AT ROW 14.71 COL 65
     "Situa‡Æo" VIEW-AS TEXT
          SIZE 7.14 BY .67 AT ROW 10 COL 41 WIDGET-ID 66
     "Origem:" VIEW-AS TEXT
          SIZE 7.14 BY .67 AT ROW 10 COL 3.43 WIDGET-ID 50
     rt-button AT ROW 14.5 COL 2
     IMAGE-1 AT ROW 2.75 COL 40 WIDGET-ID 22
     IMAGE-2 AT ROW 2.75 COL 45 WIDGET-ID 24
     IMAGE-3 AT ROW 3.75 COL 40 WIDGET-ID 26
     IMAGE-4 AT ROW 3.75 COL 45 WIDGET-ID 28
     IMAGE-5 AT ROW 4.75 COL 40 WIDGET-ID 30
     IMAGE-6 AT ROW 4.75 COL 45 WIDGET-ID 32
     IMAGE-7 AT ROW 5.75 COL 40 WIDGET-ID 34
     IMAGE-8 AT ROW 5.75 COL 45 WIDGET-ID 36
     RECT-10 AT ROW 10.25 COL 2 WIDGET-ID 46
     RECT-11 AT ROW 1 COL 2 WIDGET-ID 48
     RECT-12 AT ROW 10.25 COL 40 WIDGET-ID 64
     RECT-13 AT ROW 8.25 COL 2 WIDGET-ID 72
     IMAGE-9 AT ROW 6.75 COL 40 WIDGET-ID 78
     IMAGE-10 AT ROW 6.75 COL 45 WIDGET-ID 80
     IMAGE-11 AT ROW 1.75 COL 40 WIDGET-ID 82
     IMAGE-12 AT ROW 1.75 COL 45 WIDGET-ID 84
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 76.43 BY 15.08 WIDGET-ID 100.


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
         TITLE              = "Parƒmetros"
         HEIGHT             = 15.21
         WIDTH              = 76.57
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 126.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 126.29
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
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Parƒmetros */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Parƒmetros */
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
    ASSIGN  tt-parametros.cod-estabel-ini           = cod-estabel-ini           :SCREEN-VALUE
            tt-parametros.cod-estabel-fim           = cod-estabel-fim           :SCREEN-VALUE
            tt-parametros.nr-ficha-ini              = INTE(nr-ficha-cq-ini      :SCREEN-VALUE)
            tt-parametros.nr-ficha-fim              = INTE(nr-ficha-cq-fim      :SCREEN-VALUE)
            tt-parametros.dt-ficha-ini              = DATE(dt-ficha-ini         :SCREEN-VALUE)
            tt-parametros.dt-ficha-fim              = DATE(dt-ficha-fim         :SCREEN-VALUE)
            tt-parametros.it-codigo-ini             = it-codigo-ini             :SCREEN-VALUE
            tt-parametros.it-codigo-fim             = it-codigo-fim             :SCREEN-VALUE
            tt-parametros.desc-item-ini             = des-item-ini              :SCREEN-VALUE
            tt-parametros.desc-item-fim             = des-item-fim              :SCREEN-VALUE
            tt-parametros.cod-depos-ini             = cod-depos-ini             :SCREEN-VALUE
            tt-parametros.cod-depos-fim             = cod-depos-fim             :SCREEN-VALUE
            tt-parametros.numTempoRefresh           = INTE(numTempoRefresh      :SCREEN-VALUE)
            tt-parametros.logItensCriticos          = logItensCriticos          :CHECKED
            tt-parametros.logOriEstoque             = logOriEstoque             :CHECKED
            tt-parametros.logOriManual              = logOriManual              :CHECKED
            tt-parametros.logOriManualMovtoEstoque  = logOriManualMovtoEstoque  :CHECKED
            tt-parametros.logOriProducao            = logOriProducao            :CHECKED
            tt-parametros.logSitCancelado           = logSitCancelado           :CHECKED
            tt-parametros.logSitEmAnalise           = logSitEmAnalise           :CHECKED
            tt-parametros.logSitPendente            = logSitPendente            :CHECKED
            tt-parametros.logSitPendenteNF          = logSitPendenteNF          :CHECKED
            tt-parametros.logSitPendenteRetorno     = logSitPendenteRetorno     :CHECKED
            tt-parametros.logSitTerminado           = logSitTerminado           :CHECKED
            tt-parametros.logSomenteWms             = logSomenteWms             :CHECKED
            .

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
  DISPLAY cod-estabel-ini cod-estabel-fim nr-ficha-cq-ini nr-ficha-cq-fim 
          dt-ficha-ini dt-ficha-fim it-codigo-ini it-codigo-fim des-item-ini 
          des-item-fim cod-depos-ini cod-depos-fim numTempoRefresh 
          logItensCriticos logSomenteWms logOriManual logSitPendente 
          logSitTerminado logOriEstoque logSitEmAnalise logSitCancelado 
          logOriProducao logSitPendenteRetorno logSitPendenteNF 
          logOriManualMovtoEstoque 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 IMAGE-7 
         IMAGE-8 RECT-10 RECT-11 RECT-12 RECT-13 IMAGE-9 IMAGE-10 IMAGE-11 
         IMAGE-12 cod-estabel-ini cod-estabel-fim nr-ficha-cq-ini 
         nr-ficha-cq-fim dt-ficha-ini dt-ficha-fim it-codigo-ini it-codigo-fim 
         des-item-ini des-item-fim cod-depos-ini cod-depos-fim numTempoRefresh 
         logItensCriticos logSomenteWms logOriManual logSitPendente 
         logSitTerminado logOriEstoque logSitEmAnalise logSitCancelado 
         logOriProducao logSitPendenteRetorno logSitPendenteNF 
         logOriManualMovtoEstoque bt-ok bt-cancela bt-ajuda 
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

    {utp/ut9000.i "escqp014a" "3.00.00.000"}

  /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    FIND FIRST tt-parametros NO-ERROR.
    ASSIGN  
            cod-estabel-ini         :SCREEN-VALUE   = tt-parametros.cod-estabel-ini
            cod-estabel-fim         :SCREEN-VALUE   = tt-parametros.cod-estabel-fim
            nr-ficha-cq-ini         :SCREEN-VALUE   = STRING(tt-parametros.nr-ficha-ini)
            nr-ficha-cq-fim         :SCREEN-VALUE   = STRING(tt-parametros.nr-ficha-fim)
            dt-ficha-ini            :SCREEN-VALUE   = STRING(tt-parametros.dt-ficha-ini)
            dt-ficha-fim            :SCREEN-VALUE   = STRING(tt-parametros.dt-ficha-fim)
            it-codigo-ini           :SCREEN-VALUE   = tt-parametros.it-codigo-ini
            it-codigo-fim           :SCREEN-VALUE   = tt-parametros.it-codigo-fim
            des-item-ini            :SCREEN-VALUE   = tt-parametros.desc-item-ini
            des-item-fim            :SCREEN-VALUE   = tt-parametros.desc-item-fim
            cod-depos-ini           :SCREEN-VALUE   = tt-parametros.cod-depos-ini
            cod-depos-fim           :SCREEN-VALUE   = tt-parametros.cod-depos-fim
            numTempoRefresh         :SCREEN-VALUE   = STRING(tt-parametros.numTempoRefresh)
            logItensCriticos        :CHECKED        = tt-parametros.logItensCriticos
            logOriEstoque           :CHECKED        = tt-parametros.logOriEstoque
            logOriManual            :CHECKED        = tt-parametros.logOriManual
            logOriManualMovtoEstoque:CHECKED        = tt-parametros.logOriManualMovtoEstoque
            logOriProducao          :CHECKED        = tt-parametros.logOriProducao
            logSitCancelado         :CHECKED        = tt-parametros.logSitCancelado
            logSitEmAnalise         :CHECKED        = tt-parametros.logSitEmAnalise
            logSitPendente          :CHECKED        = tt-parametros.logSitPendente
            logSitPendenteNF        :CHECKED        = tt-parametros.logSitPendenteNF
            logSitPendenteRetorno   :CHECKED        = tt-parametros.logSitPendenteRetorno
            logSitTerminado         :CHECKED        = tt-parametros.logSitTerminado
            logSomenteWms           :CHECKED        = tt-parametros.logSomenteWms
            .
        

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

