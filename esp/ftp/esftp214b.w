&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-pv-canal NO-UNDO LIKE int-pv-canal.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp214b 2.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
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
DEFINE INPUT PARAM p-operacao AS INT /*1 - inclus∆o, 2 - alteraá∆o*/.
DEFINE INPUT PARAM TABLE FOR tt-int-pv-canal.
DEFINE VARIABLE h-pd4000      AS HANDLE NO-UNDO.
DEFINE VARIABLE dt-ini-periodo AS DATE        NO-UNDO.
DEFINE VARIABLE dt-ini        AS DATE        NO-UNDO.
DEFINE VARIABLE dt-fim        AS DATE        NO-UNDO.

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
&Scoped-define INTERNAL-TABLES tt-int-pv-canal

/* Definitions for FRAME f-cad                                          */
&Scoped-define FIELDS-IN-QUERY-f-cad tt-int-pv-canal.cod-canal ~
tt-int-pv-canal.dt-entrega-item tt-int-pv-canal.it-codigo ~
tt-int-pv-canal.qt-carteira tt-int-pv-canal.qt-meta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-f-cad ~
tt-int-pv-canal.dt-entrega-item tt-int-pv-canal.qt-meta 
&Scoped-define ENABLED-TABLES-IN-QUERY-f-cad tt-int-pv-canal
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-f-cad tt-int-pv-canal
&Scoped-define QUERY-STRING-f-cad FOR EACH tt-int-pv-canal SHARE-LOCK
&Scoped-define OPEN-QUERY-f-cad OPEN QUERY f-cad FOR EACH tt-int-pv-canal SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-f-cad tt-int-pv-canal
&Scoped-define FIRST-TABLE-IN-QUERY-f-cad tt-int-pv-canal


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-int-pv-canal.dt-entrega-item ~
tt-int-pv-canal.qt-meta 
&Scoped-define ENABLED-TABLES tt-int-pv-canal
&Scoped-define FIRST-ENABLED-TABLE tt-int-pv-canal
&Scoped-Define ENABLED-OBJECTS rt-button IMAGE-1 IMAGE-2 bt-ok bt-cancela 
&Scoped-Define DISPLAYED-FIELDS tt-int-pv-canal.cod-canal ~
tt-int-pv-canal.dt-entrega-item tt-int-pv-canal.it-codigo ~
tt-int-pv-canal.qt-carteira tt-int-pv-canal.qt-meta 
&Scoped-define DISPLAYED-TABLES tt-int-pv-canal
&Scoped-define FIRST-DISPLAYED-TABLE tt-int-pv-canal
&Scoped-Define DISPLAYED-OBJECTS fi-dt-ini-meta fi-dt-fim-meta c-desc-canal ~
c-desc-item fi-qt-faturada 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem w-cadsim 
FUNCTION fnDescItem RETURNS CHARACTER
  ( p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
     LABEL "&Fechar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&Salvar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-desc-canal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-fim-meta AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Fim" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-ini-meta AS DATE FORMAT "99/99/9999":U 
     LABEL "Data In°cio" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qt-faturada AS INTEGER FORMAT "->>>,>>>,>>9" INITIAL 0 
     LABEL "Qtd Faturada" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 81 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY f-cad FOR 
      tt-int-pv-canal SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     fi-dt-ini-meta AT ROW 2 COL 17 COLON-ALIGNED WIDGET-ID 82
     fi-dt-fim-meta AT ROW 2 COL 49.57 COLON-ALIGNED WIDGET-ID 98
     tt-int-pv-canal.cod-canal AT ROW 3 COL 17 COLON-ALIGNED WIDGET-ID 78
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-desc-canal AT ROW 3 COL 31.43 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     tt-int-pv-canal.dt-entrega-item AT ROW 4 COL 17 COLON-ALIGNED WIDGET-ID 86
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-int-pv-canal.it-codigo AT ROW 5 COL 17 COLON-ALIGNED WIDGET-ID 88
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-desc-item AT ROW 5 COL 31.43 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     tt-int-pv-canal.qt-carteira AT ROW 6 COL 17 COLON-ALIGNED WIDGET-ID 92
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fi-qt-faturada AT ROW 7 COL 17 COLON-ALIGNED WIDGET-ID 94
     tt-int-pv-canal.qt-meta AT ROW 8 COL 17 COLON-ALIGNED WIDGET-ID 96
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     bt-ok AT ROW 10.21 COL 2
     bt-cancela AT ROW 10.21 COL 12.43
     bt-ajuda AT ROW 10.25 COL 67
     rt-button AT ROW 10 COL 1
     IMAGE-1 AT ROW 2 COL 35 WIDGET-ID 10
     IMAGE-2 AT ROW 2 COL 39 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.43 BY 10.38 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-int-pv-canal T "?" NO-UNDO mgesp int-pv-canal
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manutená∆o <Insira o complemento>"
         HEIGHT             = 10.38
         WIDTH              = 81.43
         MAX-HEIGHT         = 24.08
         MAX-WIDTH          = 117.29
         VIRTUAL-HEIGHT     = 24.08
         VIRTUAL-WIDTH      = 117.29
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
/* SETTINGS FOR BUTTON bt-ajuda IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-ajuda:HIDDEN IN FRAME f-cad           = TRUE
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR FILL-IN c-desc-canal IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-int-pv-canal.cod-canal IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dt-fim-meta IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dt-ini-meta IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qt-faturada IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-int-pv-canal.it-codigo IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-int-pv-canal.qt-carteira IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-cad
/* Query rebuild information for FRAME f-cad
     _TblList          = "Temp-Tables.tt-int-pv-canal"
     _Query            is OPENED
*/  /* FRAME f-cad */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manutená∆o <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manutená∆o <Insira o complemento> */
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
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Fechar */
DO:
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* Salvar */
DO:

   ASSIGN INPUT FRAME f-cad fi-qt-faturada tt-int-pv-canal.qt-carteira tt-int-pv-canal.it-codigo tt-int-pv-canal.cod-canal tt-int-pv-canal.qt-meta tt-int-pv-canal.dt-entrega-item.

   IF p-operacao = 1 THEN DO:
       IF NOT CAN-FIND (FIRST ITEM 
                        WHERE ITEM.it-codigo = tt-int-pv-canal.it-codigo) THEN DO:

           RUN utp/ut-msgs.p (INPUT "show",
                              INPUT 17006,
                              INPUT "Item n∆o cadastrado").
           RETURN "NOK".
       END.

       IF NOT CAN-FIND (FIRST grupo-canais 
                        WHERE grupo-canais.cod-gr-canais = tt-int-pv-canal.cod-canal) THEN DO:

           RUN utp/ut-msgs.p (INPUT "show",
                              INPUT 17006,
                              INPUT "Canal n∆o cadastrado").
           RETURN "NOK".

       END.

        FIND FIRST int-pv-canal NO-LOCK
             WHERE int-pv-canal.cod-canal    = tt-int-pv-canal.cod-canal
               AND int-pv-canal.it-codigo    = tt-int-pv-canal.it-codigo
               AND int-pv-canal.dt-ini-meta  = DATE(fi-dt-ini-meta:SCREEN-VALUE IN FRAME F-Cad) 
               AND int-pv-canal.dt-fim-meta  = DATE(fi-dt-fim-meta:SCREEN-VALUE IN FRAME F-Cad)  NO-ERROR.

        IF AVAIL int-pv-canal THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                              INPUT 17006,
                              INPUT "Meta j† cadastrada!").
            RETURN "NOK".
        END.

       CREATE int-pv-canal.
       ASSIGN int-pv-canal.cod-canal    = tt-int-pv-canal.cod-canal
              int-pv-canal.it-codigo    = tt-int-pv-canal.it-codigo
              int-pv-canal.dt-ini-meta  = DATE(fi-dt-ini-meta:SCREEN-VALUE IN FRAME F-Cad)
              int-pv-canal.dt-fim-meta  = DATE(fi-dt-fim-meta:SCREEN-VALUE IN FRAME F-Cad)
              int-pv-canal.dt-entrega   = tt-int-pv-canal.dt-entrega
              int-pv-canal.qt-meta      = tt-int-pv-canal.qt-meta.

        FIND CURRENT int-pv-canal EXCLUSIVE-LOCK.

       /*
       ASSIGN dt-ini-periodo  = DATE("01/" + STRING(int-pv-canal.mes-meta) + "/" + STRING(int-pv-canal.ano-meta))
              dt-ini = dt-ini-periodo
              dt-fim = ADD-INTERVAL(dt-ini-periodo, 1, 'months') - 1.*/
       
       ASSIGN dt-ini-periodo  = int-pv-canal.dt-ini-meta
              dt-ini          = int-pv-canal.dt-ini-meta
              dt-fim          = int-pv-canal.dt-fim-meta .
       
       RUN pi-totaliza.

   END.
   ELSE DO:
       FIND FIRST int-pv-canal OF tt-int-pv-canal EXCLUSIVE-LOCK.
       ASSIGN int-pv-canal.qt-meta         = tt-int-pv-canal.qt-meta
              int-pv-canal.dt-entrega-item = tt-int-pv-canal.dt-entrega-item.
   END.

   APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-pv-canal.cod-canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-pv-canal.cod-canal w-cadsim
ON LEAVE OF tt-int-pv-canal.cod-canal IN FRAME f-cad /* C¢d. Canal */
DO:
    FIND FIRST grupo-canais NO-LOCK
         WHERE grupo-canais.cod-gr-canais = INPUT FRAME f-cad tt-int-pv-canal.cod-canal NO-ERROR.

    IF AVAIL grupo-canais THEN
        ASSIGN c-desc-canal:SCREEN-VALUE IN FRAME f-cad = grupo-canais.descricao.
    ELSE 
        ASSIGN c-desc-canal:SCREEN-VALUE IN FRAME f-cad = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-pv-canal.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-pv-canal.it-codigo w-cadsim
ON LEAVE OF tt-int-pv-canal.it-codigo IN FRAME f-cad /* C¢d. Item */
DO:
    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = INPUT FRAME f-cad tt-int-pv-canal.it-codigo NO-ERROR.

    IF AVAIL ITEM THEN
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME f-cad = ITEM.desc-item.
    ELSE 
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME f-cad = "".
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

  {&OPEN-QUERY-f-cad}
  GET FIRST f-cad.
  DISPLAY fi-dt-ini-meta fi-dt-fim-meta c-desc-canal c-desc-item fi-qt-faturada 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  IF AVAILABLE tt-int-pv-canal THEN 
    DISPLAY tt-int-pv-canal.cod-canal tt-int-pv-canal.dt-entrega-item 
          tt-int-pv-canal.it-codigo tt-int-pv-canal.qt-carteira 
          tt-int-pv-canal.qt-meta 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button IMAGE-1 IMAGE-2 tt-int-pv-canal.dt-entrega-item 
         tt-int-pv-canal.qt-meta bt-ok bt-cancela 
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

  {utp/ut9000.i "esftp214b" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN dispatch  IN this-procedure ('enable-fields':U).
  APPLY "leave" TO tt-int-pv-canal.cod-canal IN FRAME f-cad.
  APPLY "leave" TO tt-int-pv-canal.it-codigo IN FRAME f-cad.
 
  
  /*inclusao*/
  IF p-operacao = 1 THEN DO:
      
      ENABLE fi-dt-ini-meta             WITH FRAME f-cad.
      ENABLE fi-dt-fim-meta             WITH FRAME f-cad.
      ENABLE tt-int-pv-canal.cod-canal  WITH FRAME f-cad.
      ENABLE tt-int-pv-canal.it-codigo  WITH FRAME f-cad.
      ENABLE tt-int-pv-canal.qt-meta    WITH FRAME f-cad.
      ENABLE tt-int-pv-canal.dt-entrega WITH FRAME f-cad.

  END.
  ELSE 
      ASSIGN fi-dt-ini-meta:SCREEN-VALUE IN FRAME f-cad = string(tt-int-pv-canal.dt-ini-meta)
             fi-dt-fim-meta:SCREEN-VALUE IN FRAME f-cad = string(tt-int-pv-canal.dt-fim-meta) 
             fi-qt-faturada:SCREEN-VALUE IN FRAME f-cad = STRING(tt-int-pv-canal.qt-faturada).
  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-totaliza w-cadsim 
PROCEDURE pi-totaliza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE dt-aux   AS DATE        NO-UNDO.
DEFINE VARIABLE de-total AS DECIMAL     NO-UNDO.
        
DO dt-aux = dt-ini TO dt-fim:

    /*Totaliza Faturado*/
    FOR EACH it-nota-fisc NO-LOCK
       WHERE it-nota-fisc.it-codigo    = int-pv-canal.it-codigo
         AND it-nota-fisc.dt-emis-nota = dt-aux,
       FIRST nota-fiscal OF it-nota-fisc 
       WHERE nota-fiscal.idi-sit-nf-eletro = 3 NO-LOCK:

        IF nota-fiscal.emite-duplic = NO THEN 
            NEXT.

        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli
               AND ped-venda.nome-abrev = it-nota-fisc.nome-ab-cli NO-ERROR.
        
        FIND FIRST int-ped-venda NO-LOCK
             WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido no-error.
        
        FIND FIRST int-ped-venda2 NO-LOCK
             WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido
               AND int-ped-venda2.int-1     = int-pv-canal.cod-canal NO-ERROR.
        
        IF AVAIL int-ped-venda2 THEN DO:
           ASSIGN de-total = de-total +  it-nota-fisc.qt-faturada[1].
        END.
    END.
   
    /* devoluá‰es */
    FOR EACH devol-cli
       WHERE devol-cli.dt-devol        = dt-aux
         AND devol-cli.it-codigo       = int-pv-canal.it-codigo,
       FIRST nota-fiscal        
       WHERE nota-fiscal.cod-estabel   = devol-cli.cod-estabel
         AND nota-fiscal.serie         = devol-cli.serie
         AND nota-fiscal.nr-nota-fis   = devol-cli.nr-nota-fis
         AND nota-fiscal.emite-duplic,
        EACH item-doc-est FIELDS OF devol-cli NO-LOCK:

        FIND FIRST it-nota-fisc OF nota-fiscal NO-LOCK 
             WHERE it-nota-fisc.it-codigo  = item-doc-est.it-codigo 
               AND it-nota-fisc.nr-seq-fat = item-doc-est.seq-comp NO-ERROR.

        IF AVAIL it-nota-fisc THEN
           FIND FIRST ped-venda NO-LOCK 
                WHERE ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli 
                  AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
         
        FIND FIRST int-ped-venda2 NO-LOCK
             WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido
               AND int-ped-venda2.int-1     = int-pv-canal.cod-canal NO-ERROR.

        IF NOT AVAIL int-ped-venda2 THEN  
            NEXT.

        ASSIGN de-total = de-total + (item-doc-est.quantidade * -1).
    END.

    ASSIGN int-pv-canal.qt-faturada = de-total.

    /*Totaliza Carteira*/
    FOR EACH ped-item NO-LOCK
       WHERE ped-item.it-codigo     = int-pv-canal.it-codigo
         AND (ped-item.cod-sit-item <= 2 OR ped-item.cod-sit-item = 5) 
         AND ped-item.dt-entrega    = dt-aux,
       FIRST ped-venda OF ped-item NO-LOCK,
       FIRST int-ped-venda2 
       WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido 
         AND int-ped-venda2.int-1     = int-pv-canal.cod-canal NO-LOCK:

        /*considerar somente os pedidos que geram titulo*/
        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.

        IF NOT natur-oper.emite-duplic THEN
            NEXT.

        IF ped-venda.cod-priori = 44 /* oráamento */ THEN 
            NEXT.
        
        ASSIGN int-pv-canal.qt-carteira = int-pv-canal.qt-carteira + (ped-item.qt-pedida - ped-item.qt-atendida).
    END.
END.

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
  {src/adm/template/snd-list.i "tt-int-pv-canal"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem w-cadsim 
FUNCTION fnDescItem RETURNS CHARACTER
  ( p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

    IF AVAIL ITEM THEN
        RETURN ITEM.desc-item.
    ELSE
        RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

