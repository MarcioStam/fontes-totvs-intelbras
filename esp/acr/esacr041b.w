&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD up-compras   AS LOGICAL
    FIELD transacoes   AS LOGICAL
    FIELD atu-clientes AS LOGICAL
    FIELD pagtos       AS LOGICAL
    FIELD param-compra AS LOGICAL
    FIELD motivo       AS LOGICAL
    FIELD clientes     AS LOGICAL
    FIELD compras      AS LOGICAL
    FIELD pendencias   AS LOGICAL
    FIELD limite       AS LOGICAL.


/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-param.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-4 RECT-5 tg-marcar-retorno ~
tg-marcar-envio tg-clientes tg-up-compras tg-compras tg-transacoes ~
tg-pendencias tg-atu-clientes tg-limite tg-pagtos tg-param tg-motivo ~
btSalvar btFechar text-retorno text-envio 
&Scoped-Define DISPLAYED-OBJECTS tg-marcar-retorno tg-marcar-envio ~
tg-clientes tg-up-compras tg-compras tg-transacoes tg-pendencias ~
tg-atu-clientes tg-limite tg-pagtos tg-param tg-motivo text-retorno ~
text-envio 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btFechar 
     LABEL "&Fechar" 
     SIZE 10 BY 1 TOOLTIP "Fechar".

DEFINE BUTTON btSalvar 
     LABEL "&Salvar" 
     SIZE 10 BY 1 TOOLTIP "Salvar".

DEFINE VARIABLE text-envio AS CHARACTER FORMAT "X(50)":U INITIAL "Arquivos de Envio (Exporta‡Æo)" 
      VIEW-AS TEXT 
     SIZE 21.86 BY .67 NO-UNDO.

DEFINE VARIABLE text-retorno AS CHARACTER FORMAT "X(50)":U INITIAL "Arquivos de Retorno (Importa‡Æo)" 
      VIEW-AS TEXT 
     SIZE 23.14 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 6.75.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 6.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 82.29 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-atu-clientes AS LOGICAL INITIAL no 
     LABEL "Atualiza‡Æo de Clientes (Layout 8.6)" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.86 BY .75 TOOLTIP "Layout 8.6 - Programa ESACR037" NO-UNDO.

DEFINE VARIABLE tg-clientes AS LOGICAL INITIAL no 
     LABEL "Carga de Clientes (Layout 8.1)" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .75 TOOLTIP "Layout 8.1 - Programa ESACR033" NO-UNDO.

DEFINE VARIABLE tg-compras AS LOGICAL INITIAL no 
     LABEL "Upload de Compras (Layout 8.2)" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .75 TOOLTIP "Layout 8.2 - Programa ESACR040" NO-UNDO.

DEFINE VARIABLE tg-limite AS LOGICAL INITIAL no 
     LABEL "Solicita‡Æo de Limite de Cr‚dito (Layout 8.10)" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.14 BY .75 TOOLTIP "Layout 8.10 - Programa ESACR033" NO-UNDO.

DEFINE VARIABLE tg-marcar-envio AS LOGICAL INITIAL no 
     LABEL "Marcar Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.57 BY .75 NO-UNDO.

DEFINE VARIABLE tg-marcar-retorno AS LOGICAL INITIAL no 
     LABEL "Marcar Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.57 BY .75 NO-UNDO.

DEFINE VARIABLE tg-motivo AS LOGICAL INITIAL no 
     LABEL "Motivos de Retorno (Layout 8.9)" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .75 TOOLTIP "Layout 8.9 - Programa ESACR039" NO-UNDO.

DEFINE VARIABLE tg-pagtos AS LOGICAL INITIAL no 
     LABEL "Agendamento de Pagamentos (Layout 8.7)" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .75 TOOLTIP "Layout 8.7 - Programa ESACR046" NO-UNDO.

DEFINE VARIABLE tg-param AS LOGICAL INITIAL no 
     LABEL "Parƒmetros de Compra (Layout 8.8)" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .75 TOOLTIP "Layout 8.8 - Programa ESACR038" NO-UNDO.

DEFINE VARIABLE tg-pendencias AS LOGICAL INITIAL no 
     LABEL "Upload Outras Transa‡äes (Layout 8.4)" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.86 BY .75 TOOLTIP "Layout 8.4 - Programa ESACR042" NO-UNDO.

DEFINE VARIABLE tg-transacoes AS LOGICAL INITIAL no 
     LABEL "Upload Outras Transa‡äes (Layout 8.5)" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.86 BY .75 TOOLTIP "Layout 8.5 - Programa ESACR037" NO-UNDO.

DEFINE VARIABLE tg-up-compras AS LOGICAL INITIAL no 
     LABEL "Upload de Compras (Layout 8.3)" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .75 TOOLTIP "Layout 8.3 - Programa ESACR044" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     tg-marcar-retorno AT ROW 1.13 COL 28.14 WIDGET-ID 98
     tg-marcar-envio AT ROW 1.13 COL 69 WIDGET-ID 100
     tg-clientes AT ROW 1.88 COL 43.86 WIDGET-ID 40
     tg-up-compras AT ROW 2 COL 3.14 WIDGET-ID 64
     tg-compras AT ROW 2.88 COL 43.86 WIDGET-ID 56
     tg-transacoes AT ROW 3 COL 3.14 WIDGET-ID 62
     tg-pendencias AT ROW 3.88 COL 43.86 WIDGET-ID 2
     tg-atu-clientes AT ROW 4 COL 3.14 WIDGET-ID 68
     tg-limite AT ROW 4.88 COL 43.86 WIDGET-ID 96
     tg-pagtos AT ROW 5 COL 3.14 WIDGET-ID 72
     tg-param AT ROW 6 COL 3.14 WIDGET-ID 80
     tg-motivo AT ROW 7 COL 3.14 WIDGET-ID 78
     btSalvar AT ROW 8.67 COL 2 WIDGET-ID 26
     btFechar AT ROW 8.67 COL 12.29 WIDGET-ID 54
     text-retorno AT ROW 1.13 COL 2.86 NO-LABEL WIDGET-ID 44
     text-envio AT ROW 1.13 COL 43.57 NO-LABEL WIDGET-ID 48
     rtToolBar AT ROW 8.46 COL 1 WIDGET-ID 34
     RECT-4 AT ROW 1.46 COL 2 WIDGET-ID 42
     RECT-5 AT ROW 1.46 COL 42.72 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82.29 BY 8.92
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Sele‡Æo de Layouts"
         HEIGHT             = 8.92
         WIDTH              = 82.29
         MAX-HEIGHT         = 30.58
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 30.58
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN text-envio IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN text-retorno IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Sele‡Æo de Layouts */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Sele‡Æo de Layouts */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFechar C-Win
ON CHOOSE OF btFechar IN FRAME DEFAULT-FRAME /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSalvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalvar C-Win
ON CHOOSE OF btSalvar IN FRAME DEFAULT-FRAME /* Salvar */
DO:
    RUN pi-salvar.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-marcar-envio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-marcar-envio C-Win
ON VALUE-CHANGED OF tg-marcar-envio IN FRAME DEFAULT-FRAME /* Marcar Todos */
DO:
    ASSIGN INPUT FRAME default-frame tg-marcar-envio.

    ASSIGN tg-clientes:CHECKED   IN FRAME default-frame = tg-marcar-envio
           tg-compras:CHECKED    IN FRAME default-frame = tg-marcar-envio
           tg-pendencias:CHECKED IN FRAME default-frame = tg-marcar-envio
           tg-limite:CHECKED     IN FRAME default-frame = tg-marcar-envio.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-marcar-retorno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-marcar-retorno C-Win
ON VALUE-CHANGED OF tg-marcar-retorno IN FRAME DEFAULT-FRAME /* Marcar Todos */
DO:
    ASSIGN INPUT FRAME default-frame tg-marcar-retorno.

    ASSIGN tg-up-compras:CHECKED   IN FRAME default-frame = tg-marcar-retorno
           tg-transacoes:CHECKED   IN FRAME default-frame = tg-marcar-retorno
           tg-atu-clientes:CHECKED IN FRAME default-frame = tg-marcar-retorno
           tg-pagtos:CHECKED       IN FRAME default-frame = tg-marcar-retorno
           tg-param:CHECKED        IN FRAME default-frame = tg-marcar-retorno
           tg-motivo:CHECKED       IN FRAME default-frame = tg-marcar-retorno.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


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
    RUN beforeInitializeInterface.
    RUN enable_UI.
    RUN afterInitializeInterface.
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface C-Win 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST tt-param NO-LOCK NO-ERROR.
    IF  AVAIL tt-param THEN DO:
        IF  tt-param.up-compras   AND tt-param.transacoes AND
            tt-param.atu-clientes AND tt-param.pagtos     AND
            tt-param.param-compra AND tt-param.motivo     THEN
            ASSIGN tg-marcar-retorno:CHECKED IN FRAME default-frame = YES.

        IF  tt-param.clientes   AND tt-param.compras AND
            tt-param.pendencias AND tt-param.limite  THEN
            ASSIGN tg-marcar-envio:CHECKED IN FRAME default-frame = YES.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface C-Win 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST tt-param NO-LOCK NO-ERROR.
    IF  AVAIL tt-param THEN DO:
        ASSIGN tg-up-compras   = tt-param.up-compras
               tg-transacoes   = tt-param.transacoes
               tg-atu-clientes = tt-param.atu-clientes
               tg-pagtos       = tt-param.pagtos
               tg-param        = tt-param.param-compra
               tg-motivo       = tt-param.motivo
               tg-clientes     = tt-param.clientes
               tg-compras      = tt-param.compras
               tg-pendencias   = tt-param.pendencias
               tg-limite       = tt-param.limite.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY tg-marcar-retorno tg-marcar-envio tg-clientes tg-up-compras tg-compras 
          tg-transacoes tg-pendencias tg-atu-clientes tg-limite tg-pagtos 
          tg-param tg-motivo text-retorno text-envio 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE rtToolBar RECT-4 RECT-5 tg-marcar-retorno tg-marcar-envio tg-clientes 
         tg-up-compras tg-compras tg-transacoes tg-pendencias tg-atu-clientes 
         tg-limite tg-pagtos tg-param tg-motivo btSalvar btFechar text-retorno 
         text-envio 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvar C-Win 
PROCEDURE pi-salvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN INPUT FRAME default-frame tg-up-compras
           INPUT FRAME default-frame tg-transacoes
           INPUT FRAME default-frame tg-atu-clientes
           INPUT FRAME default-frame tg-pagtos
           INPUT FRAME default-frame tg-param
           INPUT FRAME default-frame tg-motivo
           INPUT FRAME default-frame tg-clientes
           INPUT FRAME default-frame tg-compras
           INPUT FRAME default-frame tg-pendencias
           INPUT FRAME default-frame tg-limite.

    FIND FIRST tt-param EXCLUSIVE-LOCK NO-ERROR.
    IF  NOT AVAIL tt-param THEN
        CREATE tt-param.

    ASSIGN tt-param.up-compras   = tg-up-compras
           tt-param.transacoes   = tg-transacoes
           tt-param.atu-clientes = tg-atu-clientes
           tt-param.pagtos       = tg-pagtos
           tt-param.param-compra = tg-param
           tt-param.motivo       = tg-motivo
           tt-param.clientes     = tg-clientes
           tt-param.compras      = tg-compras
           tt-param.pendencias   = tg-pendencias
           tt-param.limite       = tg-limite.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

