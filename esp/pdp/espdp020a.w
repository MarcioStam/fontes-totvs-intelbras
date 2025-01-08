&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-copias NO-UNDO LIKE controle-copias
       FIELD r-rowid AS ROWID
       .



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
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
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-acao      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-it-codigo AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER c-it-retorno AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
def new Global shared var l-implanta           as logical    init no.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar c-it-codigo c-item btSalvar ~
btCancelar btHelp2 
&Scoped-Define DISPLAYED-OBJECTS c-it-codigo fi-desc-item c-item ~
fi-desc-altern 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancelar 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btSalvar 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "x(12)" 
     LABEL "Item Venda" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-item AS CHARACTER FORMAT "x(12)" 
     LABEL "Alternativo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-desc-altern AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 73 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-it-codigo AT ROW 1.63 COL 9.29 COLON-ALIGNED WIDGET-ID 72
     fi-desc-item AT ROW 1.63 COL 19.43 COLON-ALIGNED NO-LABEL WIDGET-ID 68 NO-TAB-STOP 
     c-item AT ROW 2.71 COL 9.29 COLON-ALIGNED WIDGET-ID 92
     fi-desc-altern AT ROW 2.71 COL 19.43 COLON-ALIGNED NO-LABEL WIDGET-ID 90 NO-TAB-STOP 
     btSalvar AT ROW 4.71 COL 2
     btCancelar AT ROW 4.71 COL 12.14 WIDGET-ID 22
     btHelp2 AT ROW 4.75 COL 63.57
     rtToolBar AT ROW 4.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.14 BY 5.04
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-copias T "?" NO-UNDO mgesp controle-copias
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
          
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "ESPDP020A- Itens Alternativos"
         COLUMN             = 44.86
         ROW                = 14.21
         HEIGHT             = 5.04
         WIDTH              = 73.14
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 142.29
         VIRTUAL-HEIGHT     = 27.96
         VIRTUAL-WIDTH      = 142.29
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-desc-altern IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* ESPDP020A- Itens Alternativos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  ASSIGN c-it-retorno = "".
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* ESPDP020A- Itens Alternativos */
DO:
  /* This event will close the window and terminate the procedure.  */
  ASSIGN c-it-retorno = "".
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancelar wWindow
ON CHOOSE OF btCancelar IN FRAME fpage0 /* Cancelar */
DO:
    ASSIGN c-it-retorno = "".
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSalvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalvar wWindow
ON CHOOSE OF btSalvar IN FRAME fpage0 /* Salvar */
DO:
    ASSIGN INPUT FRAME fPage0 c-it-codigo c-item.
                     
    FIND FIRST ITEM NO-LOCK 
         WHERE ITEM.it-codigo = c-it-codigo NO-ERROR.
    IF NOT AVAIL ITEM THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Item Venda inv†lido!":U).
        RETURN NO-APPLY.
    END.

    FIND FIRST ITEM NO-LOCK 
         WHERE ITEM.it-codigo = c-item NO-ERROR.
    IF NOT AVAIL ITEM THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Item Alternativo inv†lido!":U).
        RETURN NO-APPLY.
    END.

    FIND FIRST it-altern NO-LOCK 
         WHERE it-altern.it-codigo = c-item NO-ERROR.
    IF AVAIL it-altern THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Item Alternativo j† cadastrado como Item de Venda!":U).
        RETURN NO-APPLY.
    END.

    FIND FIRST it-altern NO-LOCK 
         WHERE it-altern.it-codigo = c-it-codigo 
           AND it-altern.it-altern = c-item NO-ERROR.
    IF AVAIL it-altern THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Item Alternativo j† cadastrado para esse Item de venda!":U).
        RETURN NO-APPLY.
    END.

    IF p-acao = "venda" THEN DO:
        FIND FIRST it-altern NO-LOCK 
             WHERE it-altern.it-codigo = c-it-codigo NO-ERROR.
        IF AVAIL it-altern THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Item Venda j† cadastrado!":U).
            RETURN NO-APPLY.
        END.

        /*IF item.compr-fabric = 1 THEN DO:   /* comprado */
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Item Venda n∆o pode ser comprado!":U).
            RETURN NO-APPLY.
        END.*/
    END.

    CREATE it-altern.
    ASSIGN it-altern.it-codigo = c-it-codigo 
           it-altern.it-altern = c-item
           c-it-retorno        = c-it-codigo.

    APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON F5 OF c-it-codigo IN FRAME fpage0 /* Item Venda */
DO:
     {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                        &campo="c-it-codigo"
                        &campozoom="it-codigo"
                        &frame="fPage0"
                        &campo2="fi-desc-item"
                        &campozoom2="desc-item"
                        &frame2="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON LEAVE OF c-it-codigo IN FRAME fpage0 /* Item Venda */
DO:
    IF c-it-codigo:SENSITIVE IN FRAME fPage0 THEN DO:
        ASSIGN INPUT FRAME fPage0 c-it-codigo.

        ASSIGN fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = "".
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = c-it-codigo NO-ERROR.
        IF AVAIL ITEM THEN
            ASSIGN fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = ITEM.desc-item.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF c-it-codigo IN FRAME fpage0 /* Item Venda */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item wWindow
ON F5 OF c-item IN FRAME fpage0 /* Alternativo */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo="c-item"
                       &campozoom="it-codigo"
                       &frame="fPage0"
                       &campo2="fi-desc-altern"
                       &campozoom2="desc-item"
                       &frame2="fPage0"}  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item wWindow
ON LEAVE OF c-item IN FRAME fpage0 /* Alternativo */
DO:
    ASSIGN INPUT FRAME fPage0 c-item.

    ASSIGN fi-desc-altern:SCREEN-VALUE IN FRAME fPage0 = "".
    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = c-item NO-ERROR.
    IF AVAIL ITEM THEN
        ASSIGN fi-desc-altern:SCREEN-VALUE IN FRAME fPage0 = ITEM.desc-item.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item wWindow
ON MOUSE-SELECT-DBLCLICK OF c-item IN FRAME fpage0 /* Alternativo */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN enable_UI.

  c-it-codigo:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fpage0.
  c-item:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fpage0.

  RUN pi-inicio.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow 
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow 
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
  VIEW FRAME fPage0 IN WINDOW wWindow.

  ENABLE {&ENABLED-OBJECTS} WITH FRAME fPage0.

  DISP {&DISPLAYED-OBJECTS} WITH FRAME fPage0.

  DISP {&DISPLAYED-FIELDS} WITH FRAME fPage0.

  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicio wWindow 
PROCEDURE pi-inicio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN c-it-codigo:SENSITIVE IN FRAME fPage0 = p-acao = "venda".
           
    IF p-acao = "altern" THEN DO:
        ASSIGN c-it-codigo = p-it-codigo
               c-it-codigo:SCREEN-VALUE IN FRAME fPage0 = p-it-codigo.
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = c-it-codigo NO-ERROR.
        IF NOT AVAIL ITEM THEN DO:
            MESSAGE "Item Venda Inv†lido, processo cancelado"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY "close" TO THIS-PROCEDURE.
        END.
        ASSIGN fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = ITEM.desc-item.
    END.
    ELSE DO:
        ASSIGN c-it-codigo:SCREEN-VALUE IN FRAME fPage0 = "".
    END.
        
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

