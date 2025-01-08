&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE tt-supervisor
    FIELD cod-assistente        LIKE int-portfolio-repres-canal.cod-assistente     
    FIELD nm-oper               LIKE atendente.nm-oper                             
    FIELD cod-representante     LIKE int-portfolio-repres-canal.cod-representante  
    FIELD nome-abrev            LIKE repres.nome-abrev                             
    FIELD cod-unid-neg          LIKE int-portfolio-repres-canal.cod-unid-neg       
    FIELD cod-supervisor-ems    LIKE int-portfolio-repres-canal.cod-supervisor-ems 
    FIELD nome                  LIKE gerente.nome                                  
    FIELD guid-portfolio-repres LIKE int-portfolio-repres-canal.guid-portfolio-repres.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-supervisor

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table tt-supervisor.cod-assistente tt-supervisor.nm-oper tt-supervisor.cod-representante tt-supervisor.nome-abrev tt-supervisor.cod-unid-neg tt-supervisor.cod-supervisor-ems tt-supervisor.nome tt-supervisor.guid-portfolio-repres   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define QUERY-STRING-br-table FOR EACH tt-supervisor NO-LOCK     ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-table OPEN QUERY {&SELF-NAME} FOR EACH tt-supervisor NO-LOCK     ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-table tt-supervisor
&Scoped-define FIRST-TABLE-IN-QUERY-br-table tt-supervisor


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 ~
IMAGE-6 IMAGE-7 IMAGE-8 RECT-1 RECT-2 i-cod-rep-ini i-cod-rep-fim ~
bt-confirma i-cod-assist-ini i-cod-assist-fim bt-exi c-unid-negoc-ini ~
c-unid-negoc-fim c-supervisor-ini c-supervidor-fim br-table 
&Scoped-Define DISPLAYED-OBJECTS i-cod-rep-ini i-cod-rep-fim ~
i-cod-assist-ini i-cod-assist-fim c-unid-negoc-ini c-unid-negoc-fim ~
c-supervisor-ini c-supervidor-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image\im-sav":U
     LABEL "Button 1" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-exi 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exi" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE c-supervidor-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE c-supervisor-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Supervisor" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE c-unid-negoc-fim AS CHARACTER FORMAT "x(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE c-unid-negoc-ini AS CHARACTER FORMAT "x(3)" 
     LABEL "Unidade de Negocio" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE i-cod-assist-fim AS INTEGER FORMAT ">9" INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1 NO-UNDO.

DEFINE VARIABLE i-cod-assist-ini AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Atendente" 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1 NO-UNDO.

DEFINE VARIABLE i-cod-rep-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-rep-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\ii-las":U
     SIZE 2.86 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\ii-las":U
     SIZE 2.86 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\ii-las":U
     SIZE 2.86 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\ii-las":U
     SIZE 2.86 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 4.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 12.38.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      tt-supervisor SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table W-Win _FREEFORM
  QUERY br-table NO-LOCK DISPLAY
      tt-supervisor.cod-assistente        FORMAT ">9":U        COLUMN-LABEL 'Atendente'
    tt-supervisor.nm-oper               FORMAT "x(20)":U     COLUMN-LABEL 'Nome'
    tt-supervisor.cod-representante     FORMAT ">>>>>>>>9":U COLUMN-LABEL 'Repres'
    tt-supervisor.nome-abrev            FORMAT "x(20)":U
    tt-supervisor.cod-unid-neg          FORMAT "x(3)":U      COLUMN-LABEL 'Unid. Neg.'
    tt-supervisor.cod-supervisor-ems    FORMAT "x(8)":U
    tt-supervisor.nome                  FORMAT "X(20)"       COLUMN-LABEL 'Nome'
    tt-supervisor.guid-portfolio-repres FORMAT "x(36)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 77 BY 12.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     i-cod-rep-ini AT ROW 1.33 COL 22 COLON-ALIGNED HELP
          "Codigo Representante" WIDGET-ID 8
     i-cod-rep-fim AT ROW 1.33 COL 45.57 COLON-ALIGNED HELP
          "Codigo Representante" NO-LABEL WIDGET-ID 6
     bt-confirma AT ROW 1.33 COL 75 WIDGET-ID 4
     i-cod-assist-ini AT ROW 2.33 COL 30.43 COLON-ALIGNED HELP
          "C¢digo Assistente" WIDGET-ID 16
     i-cod-assist-fim AT ROW 2.33 COL 45.57 COLON-ALIGNED HELP
          "C¢digo Assistente" NO-LABEL WIDGET-ID 14
     bt-exi AT ROW 2.67 COL 75 HELP
          "Sair" WIDGET-ID 46
     c-unid-negoc-ini AT ROW 3.33 COL 29.43 COLON-ALIGNED HELP
          "Unidade de Negocio" WIDGET-ID 24
     c-unid-negoc-fim AT ROW 3.33 COL 45.57 COLON-ALIGNED HELP
          "Unidade de Negocio" NO-LABEL WIDGET-ID 22
     c-supervisor-ini AT ROW 4.33 COL 24.43 COLON-ALIGNED HELP
          "C¢digo Supervisor EMS" WIDGET-ID 32
     c-supervidor-fim AT ROW 4.33 COL 45.57 COLON-ALIGNED HELP
          "C¢digo Supervisor EMS" NO-LABEL WIDGET-ID 30
     br-table AT ROW 5.67 COL 2.57 WIDGET-ID 200
     IMAGE-1 AT ROW 1.33 COL 35.86 WIDGET-ID 10
     IMAGE-2 AT ROW 1.33 COL 44.14 WIDGET-ID 12
     IMAGE-3 AT ROW 2.33 COL 35.86 WIDGET-ID 18
     IMAGE-4 AT ROW 2.33 COL 44.14 WIDGET-ID 20
     IMAGE-5 AT ROW 3.33 COL 35.86 WIDGET-ID 26
     IMAGE-6 AT ROW 3.33 COL 44.14 WIDGET-ID 28
     IMAGE-7 AT ROW 4.33 COL 35.86 WIDGET-ID 34
     IMAGE-8 AT ROW 4.33 COL 44.14 WIDGET-ID 36
     RECT-1 AT ROW 1 COL 1 WIDGET-ID 38
     RECT-2 AT ROW 5.63 COL 1 WIDGET-ID 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Portfolio Representante"
         HEIGHT             = 17
         WIDTH              = 80
         MAX-HEIGHT         = 29.38
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 29.38
         VIRTUAL-WIDTH      = 195.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB br-table c-supervidor-fim F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-supervisor NO-LOCK
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "mgesp.int-portfolio-repres-canal.cod-assistente = 0"
     _Query            is NOT OPENED
*/  /* BROWSE br-table */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Portfolio Representante */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Portfolio Representante */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-table
&Scoped-define SELF-NAME br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table W-Win
ON MOUSE-SELECT-DBLCLICK OF br-table IN FRAME F-Main
DO:
    RUN New-State('DblClick':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table W-Win
ON ROW-ENTRY OF br-table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
  
  run new-state('New-Line|':U + string(rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}))).
  run seta-valor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table W-Win
ON ROW-LEAVE OF br-table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   /*{src/adm/template/brsleave.i}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table W-Win
ON VALUE-CHANGED OF br-table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
  run new-state('New-Line|':U + string(rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}))).
  run new-state('Value-Changed|':U + string(this-procedure)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma W-Win
ON CHOOSE OF bt-confirma IN FRAME F-Main /* Button 1 */
DO:
    FOR EACH tt-supervisor.
        DELETE tt-supervisor.
    END.

    FOR EACH int-portfolio-repres-canal
        WHERE int-portfolio-repres-canal.cod-representante  >= INPUT FRAME f-main i-cod-rep-ini
          AND int-portfolio-repres-canal.cod-representante  <= INPUT FRAME f-main i-cod-rep-fim
          AND int-portfolio-repres-canal.cod-assistente     >= INPUT FRAME f-main i-cod-assist-ini
          AND int-portfolio-repres-canal.cod-assistente     <= INPUT FRAME f-main i-cod-assist-fim
          AND int-portfolio-repres-canal.cod-unid-neg       >= INPUT FRAME f-main c-unid-negoc-ini
          AND int-portfolio-repres-canal.cod-unid-neg       <= INPUT FRAME f-main c-unid-negoc-fim
          AND int-portfolio-repres-canal.cod-supervisor-ems >= INPUT FRAME f-main c-supervisor-ini
          AND int-portfolio-repres-canal.cod-supervisor-ems <= INPUT FRAME f-main c-supervidor-fim   NO-LOCK,
         EACH repres    WHERE repres.cod-rep    = int-portfolio-repres-canal.cod-representante  NO-LOCK,
         EACH atendente WHERE atendente.cd-oper = int-portfolio-repres-canal.cod-assistente     NO-LOCK:

        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuar = int-portfolio-repres-canal.cod-supervisor-ems NO-LOCK NO-ERROR.

        FIND FIRST tt-supervisor
            WHERE tt-supervisor.cod-assistente        = int-portfolio-repres-canal.cod-assistente     
              AND tt-supervisor.cod-representante     = int-portfolio-repres-canal.cod-representante  
              AND tt-supervisor.cod-unid-neg          = int-portfolio-repres-canal.cod-unid-neg       
              AND tt-supervisor.cod-supervisor-ems    = int-portfolio-repres-canal.cod-supervisor-ems NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-supervisor THEN DO:
            CREATE tt-supervisor.
            ASSIGN tt-supervisor.cod-assistente        = int-portfolio-repres-canal.cod-assistente       
                   tt-supervisor.nm-oper               = atendente.nm-oper                               
                   tt-supervisor.cod-representante     = int-portfolio-repres-canal.cod-representante    
                   tt-supervisor.nome-abrev            = repres.nome-abrev                               
                   tt-supervisor.cod-unid-neg          = int-portfolio-repres-canal.cod-unid-neg         
                   tt-supervisor.cod-supervisor-ems    = int-portfolio-repres-canal.cod-supervisor-ems   
                   tt-supervisor.nome                  = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuar ELSE ''
                   tt-supervisor.guid-portfolio-repres = int-portfolio-repres-canal.guid-portfolio-repres.
        END. /* IF NOT AVAIL tt-supervisor THEN DO: */

    END.

    {&OPEN-QUERY-br-table}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exi W-Win
ON CHOOSE OF bt-exi IN FRAME F-Main /* Exi */
DO:
  APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY i-cod-rep-ini i-cod-rep-fim i-cod-assist-ini i-cod-assist-fim 
          c-unid-negoc-ini c-unid-negoc-fim c-supervisor-ini c-supervidor-fim 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 RECT-1 
         RECT-2 i-cod-rep-ini i-cod-rep-fim bt-confirma i-cod-assist-ini 
         i-cod-assist-fim bt-exi c-unid-negoc-ini c-unid-negoc-fim 
         c-supervisor-ini c-supervidor-fim br-table 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-supervisor"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

