&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
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
DEFINE INPUT PARAMETER p-id-titulo AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER p-id-movto  AS INTEGER NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE tt-movimentos NO-UNDO
    FIELD num-id-movto  LIKE movto-acordo-fatur.num-id-movto   
    FIELD num-id-titulo LIKE movto-acordo-fatur.num-id-titulo  
    FIELD num-id-fatur  LIKE movto-acordo-fatur.num-id-fatur   
    FIELD periodo        LIKE acordo-fatur.periodo
    FIELD cod-estabel    LIKE acordo-fatur.cod-estabel
    FIELD serie          LIKE acordo-fatur.serie
    FIELD nr-nota-fis    LIKE acordo-fatur.nr-nota-fis
    FIELD nr-nota-dev    LIKE acordo-fatur.nr-nota-dev
    FIELD tipo-acordo    AS CHARACTER FORMAT "x(30)" LABEL "Tipo Acordo"
    FIELD usuario        LIKE movto-acordo-fatur.usuario
    FIELD data           LIKE movto-acordo-fatur.data
    FIELD hora           LIKE movto-acordo-fatur.hora
    FIELD usuario-cancel LIKE movto-acordo-fatur.usuario-cancel
    FIELD data-cancel    LIKE movto-acordo-fatur.data-cancel
    FIELD hora-cancel    LIKE movto-acordo-fatur.hora-cancel
    FIELD valor          LIKE movto-acordo-fatur.valor
    FIELD motivo-cancel  LIKE movto-acordo-fatur.motivo-cancel
    FIELD observacoes    LIKE movto-acordo-fatur.observacoes.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-movimentos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-movimentos

/* Definitions for BROWSE br-movimentos                                 */
&Scoped-define FIELDS-IN-QUERY-br-movimentos tt-movimentos.cod-estabel tt-movimentos.serie tt-movimentos.nr-nota-fis tt-movimentos.nr-nota-dev tt-movimentos.periodo tt-movimentos.tipo-acordo tt-movimentos.usuario tt-movimentos.data tt-movimentos.hora tt-movimentos.valor /* tt-movimentos.usuario-cancel tt-movimentos.data-cancel tt-movimentos.hora-cancel */   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-movimentos   
&Scoped-define SELF-NAME br-movimentos
&Scoped-define QUERY-STRING-br-movimentos FOR EACH tt-movimentos
&Scoped-define OPEN-QUERY-br-movimentos OPEN QUERY {&SELF-NAME} FOR EACH tt-movimentos.
&Scoped-define TABLES-IN-QUERY-br-movimentos tt-movimentos
&Scoped-define FIRST-TABLE-IN-QUERY-br-movimentos tt-movimentos


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-movimentos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar br-movimentos ed-observacoes ~
ed-motivo-cancel btFechar btHelp2 
&Scoped-Define DISPLAYED-OBJECTS ed-observacoes fi-usuar-cancel ~
fi-data-cancel fi-hora-cancel ed-motivo-cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btFechar 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE VARIABLE ed-motivo-cancel AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 110 BY 3
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE ed-observacoes AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 110 BY 3
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fi-data-cancel AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Cancel" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hora-cancel AS CHARACTER FORMAT "X(12)":U 
     LABEL "Hora Cancel" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-usuar-cancel AS CHARACTER FORMAT "X(12)":U 
     LABEL "Usu rio Cancel" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 113 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-movimentos FOR 
      tt-movimentos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-movimentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-movimentos wWindow _FREEFORM
  QUERY br-movimentos DISPLAY
      tt-movimentos.cod-estabel     COLUMN-LABEL "Est"            WIDTH 3  
      tt-movimentos.serie           COLUMN-LABEL "Ser"            WIDTH 3
      tt-movimentos.nr-nota-fis     COLUMN-LABEL "Nota Fiscal"    WIDTH 8
      tt-movimentos.nr-nota-dev     COLUMN-LABEL "Nota Devol"     WIDTH 8
      tt-movimentos.periodo         COLUMN-LABEL "Per¡odo"        WIDTH 6
      tt-movimentos.tipo-acordo     COLUMN-LABEL "Tipo Acordo"    WIDTH 22
      tt-movimentos.usuario         COLUMN-LABEL "Usu rio"        WIDTH 8
      tt-movimentos.data            COLUMN-LABEL "Data"           WIDTH 9
      tt-movimentos.hora            COLUMN-LABEL "Hora"           WIDTH 6.5
      tt-movimentos.valor           COLUMN-LABEL "Valor"          WIDTH 12    
/*      tt-movimentos.usuario-cancel  COLUMN-LABEL "Usuar.Cancel"   WIDTH 10
      tt-movimentos.data-cancel     COLUMN-LABEL "Data Cancel"    WIDTH 9
      tt-movimentos.hora-cancel     COLUMN-LABEL "Hora Cancel"    WIDTH 9
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 109.29 BY 9.96
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     br-movimentos AT ROW 1.46 COL 2.72 WIDGET-ID 300
     ed-observacoes AT ROW 12.25 COL 2.72 NO-LABEL WIDGET-ID 4
     fi-usuar-cancel AT ROW 15.83 COL 12.14 COLON-ALIGNED WIDGET-ID 12 NO-TAB-STOP 
     fi-data-cancel AT ROW 15.83 COL 41.57 COLON-ALIGNED WIDGET-ID 14 NO-TAB-STOP 
     fi-hora-cancel AT ROW 15.83 COL 73.14 COLON-ALIGNED WIDGET-ID 16 NO-TAB-STOP 
     ed-motivo-cancel AT ROW 17 COL 2.72 NO-LABEL WIDGET-ID 6
     btFechar AT ROW 20.71 COL 2
     btHelp2 AT ROW 20.71 COL 103.43
     "Observa‡äes:" VIEW-AS TEXT
          SIZE 10.14 BY .54 AT ROW 11.58 COL 2.86 WIDGET-ID 10
     rtToolBar AT ROW 20.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 113.43 BY 20.92
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Detalhes Notas Fiscais X T¡tulo - ESUTP045A"
         COLUMN             = 25.29
         ROW                = 7.96
         HEIGHT             = 20.92
         WIDTH              = 113.43
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 142.29
         VIRTUAL-HEIGHT     = 27.96
         VIRTUAL-WIDTH      = 142.29
         MIN-BUTTON         = no
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
/* BROWSE-TAB br-movimentos rtToolBar fpage0 */
ASSIGN 
       ed-motivo-cancel:READ-ONLY IN FRAME fpage0        = TRUE.

ASSIGN 
       ed-observacoes:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fi-data-cancel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-hora-cancel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-usuar-cancel IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-movimentos
/* Query rebuild information for BROWSE br-movimentos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-movimentos.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-movimentos */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Detalhes Notas Fiscais X T¡tulo - ESUTP045A */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Detalhes Notas Fiscais X T¡tulo - ESUTP045A */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-movimentos
&Scoped-define SELF-NAME br-movimentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-movimentos wWindow
ON MOUSE-SELECT-CLICK OF br-movimentos IN FRAME fpage0
DO:
    APPLY "value-changed" TO br-movimentos IN FRAME fPage0.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-movimentos wWindow
ON ROW-DISPLAY OF br-movimentos IN FRAME fpage0
DO:
    IF AVAIL tt-movimentos THEN DO:
        IF tt-movimentos.usuario-cancel <> "" THEN DO:
            RUN pi-muda-cor(INPUT ? , INPUT 12).
        END.
        ELSE DO:
            RUN pi-muda-cor(INPUT ?, INPUT ?).
        END.
    END.
    ELSE RUN pi-muda-cor(INPUT ?, INPUT ?).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-movimentos wWindow
ON VALUE-CHANGED OF br-movimentos IN FRAME fpage0
DO:
    IF AVAIL tt-movimentos THEN DO:
        ASSIGN ed-observacoes:SCREEN-VALUE IN FRAME fPage0   = tt-movimentos.observacoes
               ed-motivo-cancel:SCREEN-VALUE IN FRAME fPage0 = tt-movimentos.motivo-cancel
               fi-usuar-cancel:SCREEN-VALUE IN FRAME fPage0  = tt-movimentos.usuario-cancel
               fi-data-cancel:SCREEN-VALUE IN FRAME fPage0   = STRING(tt-movimentos.data-cancel,"99/99/9999")
               fi-hora-cancel:SCREEN-VALUE IN FRAME fPage0   = tt-movimentos.hora-cancel.
    END.
    ELSE DO:
        ASSIGN ed-observacoes:SCREEN-VALUE IN FRAME fPage0   = ""
               ed-motivo-cancel:SCREEN-VALUE IN FRAME fPage0 = ""
               fi-usuar-cancel:SCREEN-VALUE IN FRAME fPage0  = ""
               fi-data-cancel:SCREEN-VALUE IN FRAME fPage0   = ""
               fi-hora-cancel:SCREEN-VALUE IN FRAME fPage0   = "".

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFechar wWindow
ON CHOOSE OF btFechar IN FRAME fpage0 /* Fechar */
DO:
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

  RUN pi-carrega-dados.

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

  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-dados wWindow 
PROCEDURE pi-carrega-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt-movimentos:
        DELETE tt-movimentos.
    END.

    FOR EACH movto-acordo-fatur NO-LOCK
       WHERE movto-acordo-fatur.num-id-titulo = p-id-titulo
         AND movto-acordo-fatur.num-id-movto  = p-id-movto,
       FIRST acordo-fatur NO-LOCK
       WHERE acordo-fatur.num-id-fatur = movto-acordo-fatur.num-id-fatur:

        FIND FIRST tipo-acordo NO-LOCK
             WHERE tipo-acordo.codigo = acordo-fatur.tipo-acordo NO-ERROR.

        CREATE tt-movimentos.
        ASSIGN tt-movimentos.num-id-movto   = movto-acordo-fatur.num-id-titulo
               tt-movimentos.num-id-titulo  = movto-acordo-fatur.num-id-movto 
               tt-movimentos.cod-estabel    = acordo-fatur.cod-estabel   
               tt-movimentos.serie          = acordo-fatur.serie         
               tt-movimentos.nr-nota-fis    = acordo-fatur.nr-nota-fis   
               tt-movimentos.nr-nota-dev    = acordo-fatur.nr-nota-dev
               tt-movimentos.periodo        = acordo-fatur.periodo
               tt-movimentos.tipo-acordo    = STRING(acordo-fatur.tipo-acordo) + "-" + IF AVAIL tipo-acordo THEN tipo-acordo.descricao ELSE "Nao cadastrado"
               tt-movimentos.usuario        = movto-acordo-fatur.usuario 
               tt-movimentos.data           = movto-acordo-fatur.data    
               tt-movimentos.hora           = movto-acordo-fatur.hora    
               tt-movimentos.valor          = movto-acordo-fatur.valor
               tt-movimentos.usuario-cancel = movto-acordo-fatur.usuario-cancel
               tt-movimentos.data-cancel    = movto-acordo-fatur.data-cancel
               tt-movimentos.hora-cancel    = movto-acordo-fatur.hora-cancel
               tt-movimentos.motivo-cancel  = movto-acordo-fatur.motivo-cancel
               tt-movimentos.observacoes    = movto-acordo-fatur.observacoes.  
    END.

    {&open-query-br-movimentos}

    APPLY "value-changed" TO br-movimentos IN FRAME fPage0.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-muda-cor wWindow 
PROCEDURE pi-muda-cor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-bgcolor AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER p-fgcolor AS INTEGER     NO-UNDO.

    /*cor de fundo*/
    ASSIGN tt-movimentos.cod-estabel:BGCOLOR    IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.serie:BGCOLOR          IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.nr-nota-fis:BGCOLOR    IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.nr-nota-dev:BGCOLOR    IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.tipo-acordo:BGCOLOR    IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.usuario:BGCOLOR        IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.data:BGCOLOR           IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.hora:BGCOLOR           IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.valor:BGCOLOR          IN BROWSE br-movimentos = p-bgcolor
        /*   tt-movimentos.usuario-cancel:BGCOLOR IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.data-cancel:BGCOLOR    IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.hora-cancel:BGCOLOR    IN BROWSE br-movimentos = p-bgcolor*/
           .

    /*cor da letra*/
    ASSIGN tt-movimentos.cod-estabel:FGCOLOR    IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.serie:FGCOLOR          IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.nr-nota-fis:FGCOLOR    IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.nr-nota-dev:FGCOLOR    IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.tipo-acordo:FGCOLOR    IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.usuario:FGCOLOR        IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.data:FGCOLOR           IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.hora:FGCOLOR           IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.valor:FGCOLOR          IN BROWSE br-movimentos = p-fgcolor
           /*tt-movimentos.usuario-cancel:FGCOLOR IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.data-cancel:FGCOLOR    IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.hora-cancel:FGCOLOR    IN BROWSE br-movimentos = p-fgcolor*/
        .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

