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
{include/i-prgvrs.i escpp108a 2.00.00.000}

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

DEF INPUT-OUTPUT PARAM p-cod-estabel-ini    AS CHAR. 
DEF INPUT-OUTPUT PARAM p-cod-estabel-fim    AS CHAR. 
DEF INPUT-OUTPUT PARAM p-nr-ord-produ-ini   AS INT. 
DEF INPUT-OUTPUT PARAM p-nr-ord-produ-fim   AS INT. 
DEF INPUT-OUTPUT PARAM p-it-codigo-ini      AS CHAR. 
DEF INPUT-OUTPUT PARAM p-it-codigo-fim      AS CHAR. 
DEF INPUT-OUTPUT PARAM p-dt-faturamento-ini AS DATE. 
DEF INPUT-OUTPUT PARAM p-dt-faturamento-fim AS DATE. 
DEF INPUT-OUTPUT PARAM p-dt-recebimento-ini AS DATE. 
DEF INPUT-OUTPUT PARAM p-dt-recebimento-fim AS DATE. 
DEF INPUT-OUTPUT PARAM p-dt-emissao-ini AS DATE. 
DEF INPUT-OUTPUT PARAM p-dt-emissao-fim AS DATE. 

/* DEF INPUT-OUTPUT PARAM p-tg-nao-iniciada    AS LOG. */
/* DEF INPUT-OUTPUT PARAM p-tg-liberada        AS LOG. */
/* DEF INPUT-OUTPUT PARAM p-tg-reservada       AS LOG. */
/* DEF INPUT-OUTPUT PARAM p-tg-separada        AS LOG. */
/* DEF INPUT-OUTPUT PARAM p-tg-requisitada     AS LOG. */
/* DEF INPUT-OUTPUT PARAM p-tg-iniciada        AS LOG. */
/* DEF INPUT-OUTPUT PARAM p-tg-finalizada      AS LOG. */
/* DEF INPUT-OUTPUT PARAM p-tg-terminada       AS LOG. */
                                                  
DEF INPUT-OUTPUT PARAM p-tg-status-0 AS LOG.
DEF INPUT-OUTPUT PARAM p-tg-status-1 AS LOG.
DEF INPUT-OUTPUT PARAM p-tg-status-2 AS LOG.

DEF OUTPUT PARAM l-openquery      AS LOG.

ASSIGN l-openquery = NO.

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
&Scoped-Define ENABLED-OBJECTS rt-button IMAGE-1 IMAGE-2 IMAGE-7 IMAGE-8 ~
IMAGE-9 IMAGE-10 IMAGE-13 IMAGE-14 RECT-11 RECT-10 IMAGE-15 IMAGE-16 ~
IMAGE-21 IMAGE-22 c-cod-estabel-ini c-cod-estabel-fim i-nr-ord-produ-ini ~
i-nr-ord-produ-fim c-it-codigo-ini c-it-codigo-fim d-dt-faturamento-ini ~
d-dt-faturamento-fim d-dt-recebimento-ini d-dt-recebimento-fim ~
d-dt-emissao-ini d-dt-emissao-fim tg-status-0 tg-status-1 tg-status-2 bt-ok ~
bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel-ini c-cod-estabel-fim ~
i-nr-ord-produ-ini i-nr-ord-produ-fim c-it-codigo-ini c-it-codigo-fim ~
d-dt-faturamento-ini d-dt-faturamento-fim d-dt-recebimento-ini ~
d-dt-recebimento-fim d-dt-emissao-ini d-dt-emissao-fim tg-status-0 ~
tg-status-1 tg-status-2 

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

DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelec" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo-fim AS CHARACTER FORMAT "X(16)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-emissao-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-emissao-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Emissao OP" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-faturamento-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-faturamento-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Faturamento" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-recebimento-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-recebimento-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Recebimento" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-ord-produ-fim AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-ord-produ-ini AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Ordem" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
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
     SIZE 40 BY 3.46.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 94 BY 9.25.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 95 BY 1.38
     BGCOLOR 7 .

DEFINE VARIABLE tg-status-0 AS LOGICAL INITIAL no 
     LABEL "NÆo Iniciada" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE tg-status-1 AS LOGICAL INITIAL no 
     LABEL "Faturada" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-status-2 AS LOGICAL INITIAL no 
     LABEL "Reportada" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     c-cod-estabel-ini AT ROW 1.5 COL 20 COLON-ALIGNED WIDGET-ID 110
     c-cod-estabel-fim AT ROW 1.5 COL 53.14 COLON-ALIGNED NO-LABEL WIDGET-ID 108
     i-nr-ord-produ-ini AT ROW 2.5 COL 20 COLON-ALIGNED WIDGET-ID 70
     i-nr-ord-produ-fim AT ROW 2.5 COL 53.14 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     c-it-codigo-ini AT ROW 3.5 COL 20 COLON-ALIGNED WIDGET-ID 4
     c-it-codigo-fim AT ROW 3.5 COL 53.14 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     d-dt-faturamento-ini AT ROW 4.5 COL 20 COLON-ALIGNED WIDGET-ID 36
     d-dt-faturamento-fim AT ROW 4.5 COL 53.14 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     d-dt-recebimento-ini AT ROW 5.5 COL 20 COLON-ALIGNED WIDGET-ID 28
     d-dt-recebimento-fim AT ROW 5.5 COL 53.14 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     d-dt-emissao-ini AT ROW 6.5 COL 20 COLON-ALIGNED WIDGET-ID 134
     d-dt-emissao-fim AT ROW 6.5 COL 53.14 COLON-ALIGNED NO-LABEL WIDGET-ID 132
     tg-status-0 AT ROW 11.71 COL 4 WIDGET-ID 104
     tg-status-1 AT ROW 12.71 COL 4 WIDGET-ID 102
     tg-status-2 AT ROW 13.71 COL 4 WIDGET-ID 106
     bt-ok AT ROW 15.21 COL 3
     bt-cancela AT ROW 15.21 COL 14
     bt-ajuda AT ROW 15.21 COL 69
     "Status" VIEW-AS TEXT
          SIZE 6 BY .67 AT ROW 11 COL 3 WIDGET-ID 100
     rt-button AT ROW 15 COL 2
     IMAGE-1 AT ROW 3.5 COL 36.86 WIDGET-ID 6
     IMAGE-2 AT ROW 3.5 COL 52.29 WIDGET-ID 8
     IMAGE-7 AT ROW 5.5 COL 36.86 WIDGET-ID 30
     IMAGE-8 AT ROW 5.5 COL 52.29 WIDGET-ID 32
     IMAGE-9 AT ROW 4.5 COL 36.86 WIDGET-ID 38
     IMAGE-10 AT ROW 4.5 COL 52.29 WIDGET-ID 40
     IMAGE-13 AT ROW 2.5 COL 36.86 WIDGET-ID 72
     IMAGE-14 AT ROW 2.5 COL 52.29 WIDGET-ID 74
     RECT-11 AT ROW 1.25 COL 2 WIDGET-ID 82
     RECT-10 AT ROW 11.33 COL 2 WIDGET-ID 98
     IMAGE-15 AT ROW 1.5 COL 36.86 WIDGET-ID 112
     IMAGE-16 AT ROW 1.5 COL 52.29 WIDGET-ID 114
     IMAGE-21 AT ROW 6.5 COL 36.86 WIDGET-ID 136
     IMAGE-22 AT ROW 6.5 COL 52.29 WIDGET-ID 138
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.14 ROW 1
         SIZE 96.29 BY 15.42 WIDGET-ID 100.


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
         HEIGHT             = 15.71
         WIDTH              = 96.43
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
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
    ASSIGN l-openquery = YES.
    ASSIGN p-cod-estabel-ini    = c-cod-estabel-ini      :SCREEN-VALUE IN FRAME f-cad 
           p-cod-estabel-fim    = c-cod-estabel-fim      :SCREEN-VALUE IN FRAME f-cad 
           p-nr-ord-produ-ini   = int(i-nr-ord-produ-ini :SCREEN-VALUE IN FRAME f-cad)
           p-nr-ord-produ-fim   = int(i-nr-ord-produ-fim :SCREEN-VALUE IN FRAME f-cad)
           p-it-codigo-ini      = c-it-codigo-ini     :SCREEN-VALUE IN FRAME f-cad
           p-it-codigo-fim      = c-it-codigo-fim     :SCREEN-VALUE IN FRAME f-cad
           p-dt-faturamento-ini = date(d-dt-faturamento-ini:SCREEN-VALUE IN FRAME f-cad)
           p-dt-faturamento-fim = date(d-dt-faturamento-fim:SCREEN-VALUE IN FRAME f-cad)
           p-dt-recebimento-ini = date(d-dt-recebimento-ini:SCREEN-VALUE IN FRAME f-cad)
           p-dt-recebimento-fim = date(d-dt-recebimento-fim:SCREEN-VALUE IN FRAME f-cad)
           p-dt-emissao-ini = date(d-dt-emissao-ini:SCREEN-VALUE IN FRAME f-cad)
           p-dt-emissao-fim = date(d-dt-emissao-fim:SCREEN-VALUE IN FRAME f-cad)
                                
/*            p-tg-nao-iniciada    = tg-nao-iniciada:CHECKED IN FRAME f-cad */
/*            p-tg-liberada        = tg-liberada    :CHECKED IN FRAME f-cad */
/*            p-tg-reservada       = tg-reservada   :CHECKED IN FRAME f-cad */
/*            p-tg-separada        = tg-separada    :CHECKED IN FRAME f-cad */
/*            p-tg-requisitada     = tg-requisitada :CHECKED IN FRAME f-cad */
/*            p-tg-iniciada        = tg-iniciada    :CHECKED IN FRAME f-cad */
/*            p-tg-finalizada      = tg-finalizada  :CHECKED IN FRAME f-cad */
/*            p-tg-terminada       = tg-terminada   :CHECKED IN FRAME f-cad */

           p-tg-status-0  = tg-status-0:CHECKED IN FRAME f-cad     
           p-tg-status-1  = tg-status-1:CHECKED IN FRAME f-cad     
           p-tg-status-2  = tg-status-2:CHECKED IN FRAME f-cad.     



    APPLY "close":U TO THIS-PROCEDURE.
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
  DISPLAY c-cod-estabel-ini c-cod-estabel-fim i-nr-ord-produ-ini 
          i-nr-ord-produ-fim c-it-codigo-ini c-it-codigo-fim 
          d-dt-faturamento-ini d-dt-faturamento-fim d-dt-recebimento-ini 
          d-dt-recebimento-fim d-dt-emissao-ini d-dt-emissao-fim tg-status-0 
          tg-status-1 tg-status-2 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button IMAGE-1 IMAGE-2 IMAGE-7 IMAGE-8 IMAGE-9 IMAGE-10 IMAGE-13 
         IMAGE-14 RECT-11 RECT-10 IMAGE-15 IMAGE-16 IMAGE-21 IMAGE-22 
         c-cod-estabel-ini c-cod-estabel-fim i-nr-ord-produ-ini 
         i-nr-ord-produ-fim c-it-codigo-ini c-it-codigo-fim 
         d-dt-faturamento-ini d-dt-faturamento-fim d-dt-recebimento-ini 
         d-dt-recebimento-fim d-dt-emissao-ini d-dt-emissao-fim tg-status-0 
         tg-status-1 tg-status-2 bt-ok bt-cancela bt-ajuda 
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

  {utp/ut9000.i "escpp108a" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  

    RUN dispatch  IN this-procedure ('enable-fields':U).

    ASSIGN c-cod-estabel-ini   :SCREEN-VALUE IN FRAME f-cad  = p-cod-estabel-ini        
           c-cod-estabel-fim   :SCREEN-VALUE IN FRAME f-cad  = p-cod-estabel-fim        
           i-nr-ord-produ-ini  :SCREEN-VALUE IN FRAME f-cad  = STRING(p-nr-ord-produ-ini)   
           i-nr-ord-produ-fim  :SCREEN-VALUE IN FRAME f-cad  = STRING(p-nr-ord-produ-fim)   
           c-it-codigo-ini     :SCREEN-VALUE IN FRAME f-cad  = p-it-codigo-ini        
           c-it-codigo-fim     :SCREEN-VALUE IN FRAME f-cad  = p-it-codigo-fim        
           d-dt-faturamento-ini:SCREEN-VALUE IN FRAME f-cad  = STRING(p-dt-faturamento-ini) 
           d-dt-faturamento-fim:SCREEN-VALUE IN FRAME f-cad  = STRING(p-dt-faturamento-fim) 
           d-dt-recebimento-ini:SCREEN-VALUE IN FRAME f-cad  = STRING(p-dt-recebimento-ini) 
           d-dt-recebimento-fim:SCREEN-VALUE IN FRAME f-cad  = STRING(p-dt-recebimento-fim) 
           d-dt-emissao-ini:SCREEN-VALUE IN FRAME f-cad  = STRING(p-dt-emissao-ini) 
           d-dt-emissao-fim:SCREEN-VALUE IN FRAME f-cad  = STRING(p-dt-emissao-fim) 
                                                                                        
/*            tg-nao-iniciada:CHECKED IN FRAME f-cad = p-tg-nao-iniciada */
/*            tg-liberada    :CHECKED IN FRAME f-cad = p-tg-liberada     */
/*            tg-reservada   :CHECKED IN FRAME f-cad = p-tg-reservada    */
/*            tg-separada    :CHECKED IN FRAME f-cad = p-tg-separada     */
/*            tg-requisitada :CHECKED IN FRAME f-cad = p-tg-requisitada  */
/*            tg-iniciada    :CHECKED IN FRAME f-cad = p-tg-iniciada     */
/*            tg-finalizada  :CHECKED IN FRAME f-cad = p-tg-finalizada   */
/*            tg-terminada   :CHECKED IN FRAME f-cad = p-tg-terminada */

           tg-status-0:CHECKED IN FRAME f-cad = p-tg-status-0 
           tg-status-1:CHECKED IN FRAME f-cad = p-tg-status-1 
           tg-status-2:CHECKED IN FRAME f-cad = p-tg-status-2.










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

