&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-window 
/********************************************************************************
**
*******************************************************************************/
{include/i-prgvrs.i ESCCP052B 2.04.00.000}
{utp/ut-glob.i}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE INPUT-OUTPUT PARAMETER c-estab-ini      AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER c-estab-fim      AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER c-ordem-ini      AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER c-ordem-fim      AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER dt-entrega-ini   AS DATE.
DEFINE INPUT-OUTPUT PARAMETER dt-entrega-fim   AS DATE.
DEFINE INPUT-OUTPUT PARAMETER dt-neces-ini     AS DATE.
DEFINE INPUT-OUTPUT PARAMETER dt-neces-fim     AS DATE.
DEFINE INPUT-OUTPUT PARAMETER dt-emissao-ini   AS DATE.
DEFINE INPUT-OUTPUT PARAMETER dt-emissao-fim   AS DATE.
DEFINE INPUT-OUTPUT PARAMETER c-item-ini       AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER c-item-fim       AS CHAR.
DEFINE       OUTPUT PARAMETER l-ok             AS LOG INITIAL FALSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-4 IMAGE-5 IMAGE-7 IMAGE-8 RECT-1 ~
IMAGE-11 IMAGE-12 IMAGE-19 IMAGE-20 IMAGE-21 IMAGE-22 IMAGE-23 IMAGE-24 ~
cEstabIni cEstabFim c-ord-ini c-ord-fim d-emissao-ini d-emissao-fim ~
d-neces-ini d-neces-fim d-entrega-ini d-entrega-fim f-it-codigo-ini ~
f-it-codigo-fim bt-ok bt-cancelar bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS cEstabIni cEstabFim c-ord-ini c-ord-fim ~
d-emissao-ini d-emissao-fim d-neces-ini d-neces-fim d-entrega-ini ~
d-entrega-fim f-it-codigo-ini f-it-codigo-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-ord-fim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-ord-ini AS CHARACTER FORMAT "X(20)":U 
     LABEL "Ordem Compra" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE cEstabFim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE cEstabIni AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE d-emissao-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE d-emissao-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE d-entrega-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE d-entrega-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Entrega" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE d-neces-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE d-neces-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Necessidade" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE f-it-codigo-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE f-it-codigo-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 70 BY 1.38
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cEstabIni AT ROW 1.5 COL 19 COLON-ALIGNED WIDGET-ID 40
     cEstabFim AT ROW 1.54 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     c-ord-ini AT ROW 2.5 COL 11 COLON-ALIGNED
     c-ord-fim AT ROW 2.5 COL 43 COLON-ALIGNED NO-LABEL
     d-emissao-ini AT ROW 3.5 COL 16 COLON-ALIGNED
     d-emissao-fim AT ROW 3.5 COL 43 COLON-ALIGNED NO-LABEL
     d-neces-ini AT ROW 4.5 COL 16 COLON-ALIGNED WIDGET-ID 64
     d-neces-fim AT ROW 4.5 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     d-entrega-ini AT ROW 5.5 COL 16 COLON-ALIGNED WIDGET-ID 56
     d-entrega-fim AT ROW 5.5 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     f-it-codigo-ini AT ROW 6.5 COL 10 COLON-ALIGNED WIDGET-ID 2
     f-it-codigo-fim AT ROW 6.5 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     bt-ok AT ROW 8.21 COL 2.86
     bt-cancelar AT ROW 8.21 COL 13.86
     bt-ajuda AT ROW 8.21 COL 60.86 HELP
          "Ajuda"
     IMAGE-4 AT ROW 3.5 COL 32
     IMAGE-5 AT ROW 2.5 COL 32
     IMAGE-7 AT ROW 3.5 COL 40
     IMAGE-8 AT ROW 2.5 COL 40
     RECT-1 AT ROW 8 COL 1.86
     IMAGE-11 AT ROW 6.5 COL 40 WIDGET-ID 4
     IMAGE-12 AT ROW 6.5 COL 32 WIDGET-ID 6
     IMAGE-19 AT ROW 1.54 COL 32 WIDGET-ID 50
     IMAGE-20 AT ROW 1.54 COL 40 WIDGET-ID 52
     IMAGE-21 AT ROW 5.5 COL 32 WIDGET-ID 58
     IMAGE-22 AT ROW 5.5 COL 40 WIDGET-ID 60
     IMAGE-23 AT ROW 4.5 COL 32 WIDGET-ID 66
     IMAGE-24 AT ROW 4.5 COL 40 WIDGET-ID 68
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.43 BY 8.88
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert Custom SmartWindow title>"
         HEIGHT             = 8.88
         WIDTH              = 71.43
         MAX-HEIGHT         = 21.13
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.13
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* <insert Custom SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* <insert Custom SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-window
ON CHOOSE OF bt-ajuda IN FRAME F-Main /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-window
ON CHOOSE OF bt-cancelar IN FRAME F-Main /* Cancelar */
DO:
  apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
   ASSIGN c-estab-ini      = INPUT FRAME {&FRAME-NAME} cEstabIni
          c-estab-fim      = INPUT FRAME {&FRAME-NAME} cEstabFim
          c-ordem-ini      = INPUT FRAME {&FRAME-NAME} c-ord-ini
          c-ordem-fim      = INPUT FRAME {&FRAME-NAME} c-ord-fim
          dt-entrega-ini   = DATE(INPUT FRAME {&FRAME-NAME} d-entrega-ini)
          dt-entrega-fim   = DATE(INPUT FRAME {&FRAME-NAME} d-entrega-fim)
          dt-neces-ini     = DATE(INPUT FRAME {&FRAME-NAME} d-neces-ini)
          dt-neces-fim     = DATE(INPUT FRAME {&FRAME-NAME} d-neces-fim)
          dt-emissao-ini   = DATE(INPUT FRAME {&FRAME-NAME} d-emissao-ini)
          dt-emissao-fim   = DATE(INPUT FRAME {&FRAME-NAME} d-emissao-fim)
          c-item-ini       = INPUT FRAME {&FRAME-NAME} f-it-codigo-ini
          c-item-fim       = INPUT FRAME {&FRAME-NAME} f-it-codigo-fim
          l-ok             = TRUE.
          
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
  THEN DELETE WIDGET w-window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window  _DEFAULT-ENABLE
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
  DISPLAY cEstabIni cEstabFim c-ord-ini c-ord-fim d-emissao-ini d-emissao-fim 
          d-neces-ini d-neces-fim d-entrega-ini d-entrega-fim f-it-codigo-ini 
          f-it-codigo-fim 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE IMAGE-4 IMAGE-5 IMAGE-7 IMAGE-8 RECT-1 IMAGE-11 IMAGE-12 IMAGE-19 
         IMAGE-20 IMAGE-21 IMAGE-22 IMAGE-23 IMAGE-24 cEstabIni cEstabFim 
         c-ord-ini c-ord-fim d-emissao-ini d-emissao-fim d-neces-ini 
         d-neces-fim d-entrega-ini d-entrega-fim f-it-codigo-ini 
         f-it-codigo-fim bt-ok bt-cancelar bt-ajuda 
      WITH FRAME F-Main IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW w-window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}
  
  {utp/ut9000.i "ESCCP052B" "2.04.00.000"}
  
  ASSIGN cEstabIni       = c-estab-ini
         cEstabFim       = c-estab-fim
         c-ord-ini       = c-ordem-ini    
         c-ord-fim       = c-ordem-fim    
         d-entrega-ini   = dt-entrega-ini
         d-entrega-fim   = dt-entrega-fim
         d-emissao-ini   = dt-emissao-ini 
         d-emissao-fim   = dt-emissao-fim 
         d-neces-ini     = dt-neces-ini 
         d-neces-fim     = dt-neces-fim 
         f-it-codigo-ini = c-item-ini      
         f-it-codigo-fim = c-item-fim.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this JanelaDetalhe, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-window 
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

