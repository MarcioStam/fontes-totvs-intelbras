&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME eswmp008
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS eswmp008 
{include/i-prgvrs.i esacr071 2.00.00.000}


CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* GLOBAIS */
DEFINE NEW GLOBAL SHARED VARIABLE hBrowser           AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta         AS LOGICAL.
DEFINE NEW GLOBAL SHARED VARIABLE h-facelift         AS HANDLE NO-UNDO.

DEF VAR hProgramZoom AS HANDLE NO-UNDO.
DEF VAR wh-pesquisa AS HANDLE NO-UNDO.

/* Local Variable Definitions --- */

DEFINE STREAM s.
DEFINE STREAM r.

DEF TEMP-TABLE tt-esp-wm-equipamento-transp NO-UNDO LIKE esp-wm-equipamento-transp.
DEF TEMP-TABLE tt-transporte NO-UNDO
    FIELD cod-transp  AS INTEGER 
    FIELD nome-abrev AS CHAR FORMAT "x(12)".


IF NOT VALID-HANDLE(h-facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h-facelift.

{utp/ut-glob.i}

DEF STREAM s-1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME brSource

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-transporte tt-esp-wm-equipamento-transp

/* Definitions for BROWSE brSource                                      */
&Scoped-define FIELDS-IN-QUERY-brSource tt-transporte.cod-transp tt-transporte.nome-abrev   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSource   
&Scoped-define SELF-NAME brSource
&Scoped-define QUERY-STRING-brSource FOR EACH tt-transporte NO-LOCK
&Scoped-define OPEN-QUERY-brSource OPEN QUERY {&SELF-NAME} FOR EACH tt-transporte NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSource tt-transporte
&Scoped-define FIRST-TABLE-IN-QUERY-brSource tt-transporte


/* Definitions for BROWSE BrTarget                                      */
&Scoped-define FIELDS-IN-QUERY-BrTarget tt-esp-wm-equipamento-transp.cod-transp tt-esp-wm-equipamento-transp.nome-abrev   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrTarget   
&Scoped-define SELF-NAME BrTarget
&Scoped-define QUERY-STRING-BrTarget FOR EACH tt-esp-wm-equipamento-transp NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrTarget OPEN QUERY {&SELF-NAME} FOR EACH tt-esp-wm-equipamento-transp NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrTarget tt-esp-wm-equipamento-transp
&Scoped-define FIRST-TABLE-IN-QUERY-BrTarget tt-esp-wm-equipamento-transp


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-brSource}~
    ~{&OPEN-QUERY-BrTarget}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-cod-equipamento bt-vai brSource BrTarget ~
fi-desc-equipamento btAddAllTarget btAddTarget btDelTarget btDelAllTarget ~
bt-exporta-solicitacao bt-ok rt-button rtParent rtParent-2 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-equipamento fi-desc-equipamento 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR eswmp008 AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-exporta-solicitacao 
     IMAGE-UP FILE "image/excel.jpg":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Exportar Conta Corrente para Excel".

DEFINE BUTTON bt-ok AUTO-GO 
     IMAGE-UP FILE "adeicon/cueexit.bmp":U
     LABEL "&Fechar" 
     SIZE 4.29 BY 1.25 TOOLTIP "Sair do programa"
     BGCOLOR 8 .

DEFINE BUTTON bt-vai 
     IMAGE-UP FILE "image\im-enter":U
     LABEL "Button 1" 
     SIZE 7 BY 1.25.

DEFINE BUTTON btAddAllTarget 
     IMAGE-UP FILE "image\add-all":U
     IMAGE-INSENSITIVE FILE "image\ii-add-all":U
     LABEL "" 
     SIZE 7 BY 1.25 TOOLTIP "Inclui Todos".

DEFINE BUTTON btAddTarget 
     IMAGE-UP FILE "adeicon\next-au":U
     IMAGE-INSENSITIVE FILE "adeicon\next-ai":U
     LABEL "" 
     SIZE 7 BY 1.25 TOOLTIP "Inclui".

DEFINE BUTTON btDelAllTarget 
     IMAGE-UP FILE "image\del-all":U
     IMAGE-INSENSITIVE FILE "image\ii-del-all":U
     LABEL "" 
     SIZE 7 BY 1.25 TOOLTIP "Retira Todos".

DEFINE BUTTON btDelTarget 
     IMAGE-UP FILE "adeicon\prev-au":U
     IMAGE-INSENSITIVE FILE "adeicon\prev-ai":U
     LABEL "" 
     SIZE 7 BY 1.25 TOOLTIP "Retira".

DEFINE VARIABLE fi-cod-equipamento AS CHARACTER FORMAT "X(8)":U 
     LABEL "Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-equipamento AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 88 BY 1.46
     BGCOLOR 7 .

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 2.5.

DEFINE RECTANGLE rtParent-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 12.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSource FOR 
      tt-transporte SCROLLING.

DEFINE QUERY BrTarget FOR 
      tt-esp-wm-equipamento-transp SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSource eswmp008 _FREEFORM
  QUERY brSource NO-LOCK DISPLAY
      tt-transporte.cod-transp FORMAT ">>,>>9":U  COLUMN-LABEL "Cod. Transportador"
      tt-transporte.nome-abrev FORMAT "X(12)":U   COLUMN-LABEL "Nm. Abrev"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 36 BY 11.5
         FONT 1
         TITLE "Transportadoras" FIT-LAST-COLUMN.

DEFINE BROWSE BrTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrTarget eswmp008 _FREEFORM
  QUERY BrTarget NO-LOCK DISPLAY
      tt-esp-wm-equipamento-transp.cod-transp FORMAT "->,>>>,>>9":U COLUMN-LABEL "Cod. Transportador"  
      tt-esp-wm-equipamento-transp.nome-abrev FORMAT "x(12)":U      COLUMN-LABEL "Nm. Abrev"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 36 BY 11.5
         FONT 1
         TITLE "Relaciona Equipamento x Transportadora" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     fi-cod-equipamento AT ROW 3.67 COL 14 COLON-ALIGNED WIDGET-ID 18
     bt-vai AT ROW 3.46 COL 76 WIDGET-ID 28
     brSource AT ROW 6 COL 3 WIDGET-ID 100
     BrTarget AT ROW 6 COL 52.72 WIDGET-ID 200
     fi-desc-equipamento AT ROW 3.67 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 26 NO-TAB-STOP 
     btAddAllTarget AT ROW 8.79 COL 42.57 WIDGET-ID 372
     btAddTarget AT ROW 10.38 COL 42.57 WIDGET-ID 374
     btDelTarget AT ROW 11.96 COL 42.57 WIDGET-ID 378
     btDelAllTarget AT ROW 13.5 COL 42.57 WIDGET-ID 376
     bt-exporta-solicitacao AT ROW 1.17 COL 42.43 HELP
          "Exportar Conta Corrente para Excel" WIDGET-ID 106
     bt-ok AT ROW 1.13 COL 85.29 HELP
          "Sair do programa" WIDGET-ID 242
     rt-button AT ROW 1.04 COL 2
     rtParent AT ROW 2.92 COL 2 WIDGET-ID 370
     rtParent-2 AT ROW 5.75 COL 2 WIDGET-ID 380
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.72 BY 17
         BGCOLOR 15 FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW eswmp008 ASSIGN
         HIDDEN             = YES
         TITLE              = "Relaciona Equipamento x Transportadora"
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 28.67
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.67
         VIRTUAL-WIDTH      = 195.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB eswmp008 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW eswmp008
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB brSource bt-vai f-cad */
/* BROWSE-TAB BrTarget brSource f-cad */
ASSIGN 
       fi-desc-equipamento:READ-ONLY IN FRAME f-cad        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(eswmp008)
THEN eswmp008:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSource
/* Query rebuild information for BROWSE brSource
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-transporte NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSource */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrTarget
/* Query rebuild information for BROWSE BrTarget
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-esp-wm-equipamento-transp NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE BrTarget */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME eswmp008
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL eswmp008 eswmp008
ON END-ERROR OF eswmp008 /* Relaciona Equipamento x Transportadora */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL eswmp008 eswmp008
ON WINDOW-CLOSE OF eswmp008 /* Relaciona Equipamento x Transportadora */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exporta-solicitacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exporta-solicitacao eswmp008
ON CHOOSE OF bt-exporta-solicitacao IN FRAME f-cad
DO:

    DEF VAR c-arquivo AS CHAR NO-UNDO.

    ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "Equip_x_Transp_" + STRING(TODAY, "99-99-9999") + "_"+ STRING(TIME) + ".csv".

    OUTPUT STREAM s-1 TO value(c-arquivo) CONVERT TARGET "iso8859-1".

    PUT STREAM s-1 "Equipamento;Desc Equip.;Cod. Transp;Nome" SKIP.

    FOR EACH esp-wm-equipamento-transp NO-LOCK
        , FIRST wm-equipamento NO-LOCK
                WHERE wm-equipamento.cod-equipamento = esp-wm-equipamento.cod-equipamento
         BY  esp-wm-equipamento-transp.cod-equipamento:
         EXPORT STREAM s-1 DELIMITER ";" esp-wm-equipamento-transp.cod-equipamento
                                         wm-equipamento.des-equipamento
                                         esp-wm-equipamento-transp.cod-transp
                                         esp-wm-equipamento-transp.nome-abrev .    
    END.

    OUTPUT STREAM s-1 CLOSE.

    DOS SILENT START excel VALUE(c-arquivo).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok eswmp008
ON CHOOSE OF bt-ok IN FRAME f-cad /* Fechar */
DO:
  RUN notify ('update-record':U).
  if return-value <> "adm-error":U then
     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-vai
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-vai eswmp008
ON CHOOSE OF bt-vai IN FRAME f-cad /* Button 1 */
DO:
  
    EMPTY TEMP-TABLE tt-esp-wm-equipamento-transp.
    EMPTY TEMP-TABLE tt-transporte.

    FIND FIRST wm-equipamento NO-LOCK
        WHERE wm-equipamento.cod-equipamento = INPUT FRAME f-cad fi-cod-equipamento NO-ERROR.
    IF  NOT avail wm-equipamento THEN DO:
        RUN utp/ut-msgs (INPUT "SHOW",
                         INPUT 17006,
                         INPUT "Equipamento n∆o cadastrado." ).
    
        RETURN NO-APPLY.
    END.

    RUN pi-carrega-equip_x_transp.

    RUN pi-carrega-transp.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddAllTarget eswmp008
ON CHOOSE OF btAddAllTarget IN FRAME f-cad
DO:
   
    DO TRANS:

        FOR EACH tt-transporte:
            CREATE esp-wm-equipamento-transp.
    
            ASSIGN esp-wm-equipamento-transp.cod-equipamento = INPUT FRAME f-cad fi-cod-equipamento
                   esp-wm-equipamento-transp.cod-trans       = tt-transporte.cod-trans
                   esp-wm-equipamento-transp.nome-abrev      = tt-transporte.nome-abrev.
        END.

        RUN pi-carrega-equip_x_transp.
    
        RUN pi-carrega-transp.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddTarget eswmp008
ON CHOOSE OF btAddTarget IN FRAME f-cad
DO:
     
    IF  AVAIL tt-transporte THEN DO TRANS:
        CREATE esp-wm-equipamento-transp.

        ASSIGN esp-wm-equipamento-transp.cod-equipamento = INPUT FRAME f-cad fi-cod-equipamento
               esp-wm-equipamento-transp.cod-trans       = tt-transporte.cod-trans
               esp-wm-equipamento-transp.nome-abrev      = tt-transporte.nome-abrev.
               
        RUN pi-carrega-equip_x_transp.
    
        RUN pi-carrega-transp.
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelAllTarget eswmp008
ON CHOOSE OF btDelAllTarget IN FRAME f-cad
DO:
    IF  AVAIL tt-esp-wm-equipamento-transp THEN DO TRANS:
        FOR EACH esp-wm-equipamento-transp EXCLUSIVE-LOCK
            WHERE esp-wm-equipamento-transp.cod-equipamento = INPUT FRAME f-cad fi-cod-equipamento    :
              
            DELETE  esp-wm-equipamento-transp.
            
        END.

        RUN pi-carrega-equip_x_transp.
        RUN pi-carrega-transp.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelTarget eswmp008
ON CHOOSE OF btDelTarget IN FRAME f-cad
DO:

    IF  AVAIL tt-esp-wm-equipamento-transp THEN DO TRANS:
        FIND FIRST esp-wm-equipamento-transp EXCLUSIVE-LOCK
            WHERE esp-wm-equipamento-transp.cod-equipamento = tt-esp-wm-equipamento-transp.cod-equipamento
              and esp-wm-equipamento-transp.cod-trans       = tt-esp-wm-equipamento-transp.cod-trans     NO-ERROR.

        IF  AVAIL esp-wm-equipamento-transp THEN DO:
            DELETE  esp-wm-equipamento-transp.
            
            RUN pi-carrega-equip_x_transp.
            RUN pi-carrega-transp.
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-equipamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-equipamento eswmp008
ON LEAVE OF fi-cod-equipamento IN FRAME f-cad /* Equipamento */
DO:
    FIND FIRST wm-equipamento NO-LOCK
        WHERE wm-equipamento.cod-equipamento = INPUT FRAME f-cad fi-cod-equipamento NO-ERROR.

    IF  AVAIL wm-equipamento THEN 
        ASSIGN fi-desc-equipamento:SCREEN-VALUE IN FRAME f-cad = wm-equipamento.des-equipamento.
    ELSE
        ASSIGN fi-desc-equipamento:SCREEN-VALUE IN FRAME f-cad  = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-equipamento eswmp008
ON MOUSE-SELECT-DBLCLICK OF fi-cod-equipamento IN FRAME f-cad /* Equipamento */
DO:


    {method/zoomfields.i &ProgramZoom="sczoom/z01sc092.w"
                         &FieldZoom1="cod-equipamento"
                         &FieldScreen1="fi-cod-equipamento"
                         &Frame1="f-cad"
                         &FieldZoom2="des-equipamento"
                         &FieldScreen2="fi-desc-equipamento"
                         &frame2="f-cad"
                         &EnableImplant="NO"}
  /*
  {include/zoomvar.i &prog-zoom="sczoom/z01sc092.w"
                     &campo=fi-cod-equipamento
                     &campozoom=cod-equipamento
                     &campo2=fi-desc-equipamento
                     &campozoom2=des-equipamento }.
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSource
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK eswmp008 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

fi-cod-equipamento:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-cad.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects eswmp008  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available eswmp008  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI eswmp008  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(eswmp008)
  THEN DELETE WIDGET eswmp008.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI eswmp008  _DEFAULT-ENABLE
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
  DISPLAY fi-cod-equipamento fi-desc-equipamento 
      WITH FRAME f-cad IN WINDOW eswmp008.
  ENABLE fi-cod-equipamento bt-vai brSource BrTarget fi-desc-equipamento 
         btAddAllTarget btAddTarget btDelTarget btDelAllTarget 
         bt-exporta-solicitacao bt-ok rt-button rtParent rtParent-2 
      WITH FRAME f-cad IN WINDOW eswmp008.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW eswmp008.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy eswmp008 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit eswmp008 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize eswmp008 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "eswmp008" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN dispatch  IN this-procedure ('enable-fields':U).

/*   APPLY 'value-changed'      TO br-canais IN FRAME f-cad.  */
  
 
  {include/i-inifld.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-equip_x_transp eswmp008 
PROCEDURE pi-carrega-equip_x_transp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR i AS INTEGER.

   EMPTY TEMP-TABLE tt-esp-wm-equipamento-transp.

   FOR EACH esp-wm-equipamento-transp  NO-LOCK
        WHERE esp-wm-equipamento-transp.cod-equipamento = INPUT FRAME f-cad fi-cod-equipamento :
 
           CREATE tt-esp-wm-equipamento-transp.
           BUFFER-COPY esp-wm-equipamento-transp TO tt-esp-wm-equipamento-transp.
           i = i + 1.
   END.

   {&OPEN-QUERY-brTarget}
              
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-transp eswmp008 
PROCEDURE pi-carrega-transp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   EMPTY TEMP-TABLE tt-transporte.
   DEF VAR i AS INTEGER.

   FOR EACH transporte NO-LOCK:
       IF  CAN-FIND (FIRST tt-esp-wm-equipamento-transp
                        WHERE tt-esp-wm-equipamento-transp.cod-transp = transporte.cod-transp) THEN
           NEXT.

       CREATE tt-transporte.
       ASSIGN tt-transporte.cod-transp = transporte.cod-transp
              tt-transporte.nome-abrev = transporte.nome-abrev.

       i = i + 1.
   END.


   {&open-query-brSource}
/*
    APPLY "value-changed" TO br-titulo IN FRAME f-cad.

    RUN pi-finalizar IN h-acomp.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records eswmp008  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-esp-wm-equipamento-transp"}
  {src/adm/template/snd-list.i "tt-transporte"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed eswmp008 
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

