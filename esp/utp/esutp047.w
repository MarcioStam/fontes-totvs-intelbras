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

/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE tt-movimentos NO-UNDO
    FIELD num-id-movto  LIKE movto-acordo-fatur.num-id-movto 
    FIELD num-id-titulo LIKE movto-acordo-fatur.num-id-titulo
    FIELD num-id-fatur  LIKE movto-acordo-fatur.num-id-fatur
    FIELD matriz        LIKE acordo-fatur.matriz
    FIELD cod-emitente  LIKE acordo-fatur.cod-emitente
    FIELD cod-estabel   LIKE acordo-fatur.cod-estabel
    FIELD serie         LIKE acordo-fatur.serie
    FIELD nr-nota-fis   LIKE acordo-fatur.nr-nota-fis
    FIELD nr-nota-dev   LIKE acordo-fatur.nr-nota-dev
    FIELD tipo-acordo    AS CHARACTER FORMAT "x(30)"
    FIELD cod-unid-neg  LIKE acordo-fatur.cod-unid-neg
    FIELD per-acordo    LIKE acordo-fatur.per-acordo
    FIELD periodo       LIKE acordo-fatur.periodo
    FIELD valor-acordo  LIKE acordo-fatur.valor-acordo
    FIELD saldo         LIKE acordo-fatur.saldo.

DEFINE TEMP-TABLE tt-baixas NO-UNDO
    FIELD num-id-movto  LIKE movto-acordo-fatur.num-id-movto 
    FIELD num-id-titulo LIKE movto-acordo-fatur.num-id-titulo
    FIELD num-id-fatur  LIKE movto-acordo-fatur.num-id-fatur
    FIELD matriz        LIKE acordo-fatur.matriz
    FIELD documento     AS CHARACTER FORMAT "x(10)"
    FIELD cod-emitente  LIKE acordo-fatur.cod-emitente
    FIELD cod-estabel   LIKE acordo-fatur.cod-estabel
    FIELD serie         LIKE acordo-fatur.serie
    FIELD nr-nota-fis   LIKE acordo-fatur.nr-nota-fis
    FIELD nr-nota-dev   LIKE acordo-fatur.nr-nota-dev
    FIELD tipo-acordo    AS CHARACTER FORMAT "x(30)"
    FIELD cod-unid-neg  LIKE acordo-fatur.cod-unid-neg
    FIELD per-acordo    LIKE acordo-fatur.per-acordo
    FIELD periodo       LIKE acordo-fatur.periodo
    FIELD usuario       LIKE movto-acordo-fatur.usuario
    FIELD data          LIKE movto-acordo-fatur.data
    FIELD hora          LIKE movto-acordo-fatur.hora
    FIELD valor-baixa   LIKE movto-acordo-fatur.valor.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-baixas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-baixas tt-movimentos

/* Definitions for BROWSE br-baixas                                     */
&Scoped-define FIELDS-IN-QUERY-br-baixas tt-baixas.cod-estabel tt-baixas.serie tt-baixas.nr-nota-fis tt-baixas.matriz tt-baixas.cod-emitente tt-baixas.documento tt-baixas.periodo tt-baixas.cod-unid-neg tt-baixas.tipo-acordo tt-baixas.per-acordo tt-baixas.valor-baixa   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-baixas   
&Scoped-define SELF-NAME br-baixas
&Scoped-define QUERY-STRING-br-baixas FOR EACH tt-baixas
&Scoped-define OPEN-QUERY-br-baixas OPEN QUERY {&SELF-NAME} FOR EACH tt-baixas.
&Scoped-define TABLES-IN-QUERY-br-baixas tt-baixas
&Scoped-define FIRST-TABLE-IN-QUERY-br-baixas tt-baixas


/* Definitions for BROWSE br-movimentos                                 */
&Scoped-define FIELDS-IN-QUERY-br-movimentos tt-movimentos.cod-estabel tt-movimentos.serie tt-movimentos.nr-nota-fis tt-movimentos.nr-nota-dev tt-movimentos.matriz tt-movimentos.cod-emitente tt-movimentos.periodo tt-movimentos.cod-unid-neg tt-movimentos.tipo-acordo tt-movimentos.per-acordo tt-movimentos.valor-acordo tt-movimentos.saldo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-movimentos   
&Scoped-define SELF-NAME br-movimentos
&Scoped-define QUERY-STRING-br-movimentos FOR EACH tt-movimentos
&Scoped-define OPEN-QUERY-br-movimentos OPEN QUERY {&SELF-NAME} FOR EACH tt-movimentos.
&Scoped-define TABLES-IN-QUERY-br-movimentos tt-movimentos
&Scoped-define FIRST-TABLE-IN-QUERY-br-movimentos tt-movimentos


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-baixas}~
    ~{&OPEN-QUERY-br-movimentos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-13 btCarrega fi-cod-estabel ~
fi-nr-nota-fis br-movimentos br-baixas btFechar btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-estabel fi-nr-nota-fis ~
fi-valor-total fi-valor-saldo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCarrega 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Carrega" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btFechar 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-nr-nota-fis AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nota Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-saldo AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Saldo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-total AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Total" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 110 BY 2.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 113 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-baixas FOR 
      tt-baixas SCROLLING.

DEFINE QUERY br-movimentos FOR 
      tt-movimentos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-baixas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-baixas wWindow _FREEFORM
  QUERY br-baixas DISPLAY
      tt-baixas.cod-estabel            COLUMN-LABEL "Est"            WIDTH 2.8  
      tt-baixas.serie                  COLUMN-LABEL "Ser"            WIDTH 2.8  
      tt-baixas.nr-nota-fis            COLUMN-LABEL "Nota Fisc"      WIDTH 7  
      tt-baixas.matriz                 COLUMN-LABEL "Matriz"         WIDTH 7
      tt-baixas.cod-emitente           COLUMN-LABEL "Cliente"        WIDTH 7
      tt-baixas.documento              COLUMN-LABEL "Documento"      WIDTH 9
      tt-baixas.periodo                COLUMN-LABEL "Per¡odo"        WIDTH 6   
      tt-baixas.cod-unid-neg           COLUMN-LABEL "Un.Neg"         WIDTH 5.5
      tt-baixas.tipo-acordo            COLUMN-LABEL "Tipo Acordo"    WIDTH 22  
      tt-baixas.per-acordo             COLUMN-LABEL "% Acor"         WIDTH 5
      tt-baixas.valor-baixa            COLUMN-LABEL "Valor Baixa"    WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 110 BY 8
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE br-movimentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-movimentos wWindow _FREEFORM
  QUERY br-movimentos DISPLAY
      tt-movimentos.cod-estabel            COLUMN-LABEL "Est"            WIDTH 2.8  
      tt-movimentos.serie                  COLUMN-LABEL "Ser"            WIDTH 2.8  
      tt-movimentos.nr-nota-fis            COLUMN-LABEL "Nota Fisc"      WIDTH 7  
      tt-movimentos.nr-nota-dev            COLUMN-LABEL "Nota Devol"     WIDTH 8  
      tt-movimentos.matriz                 COLUMN-LABEL "Matriz"         WIDTH 7
      tt-movimentos.cod-emitente           COLUMN-LABEL "Cliente"        WIDTH 7
      tt-movimentos.periodo                COLUMN-LABEL "Per¡odo"        WIDTH 6   
      tt-movimentos.cod-unid-neg           COLUMN-LABEL "Un.Neg"         WIDTH 5.5
      tt-movimentos.tipo-acordo            COLUMN-LABEL "Tipo Acordo"    WIDTH 22  
      tt-movimentos.per-acordo             COLUMN-LABEL "% Acor"         WIDTH 5
      tt-movimentos.valor-acordo           COLUMN-LABEL "Valor Acordo"   WIDTH 12
      tt-movimentos.saldo                  COLUMN-LABEL "Saldo"          WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 110 BY 8
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btCarrega AT ROW 1.75 COL 108 HELP
          "V  Para" WIDGET-ID 98
     fi-cod-estabel AT ROW 2 COL 38 HELP
          "C¢digo do Estabelecimento" WIDGET-ID 76
     fi-nr-nota-fis AT ROW 2 COL 60.72 COLON-ALIGNED HELP
          "N£mero da Nota Fiscal" WIDGET-ID 16
     br-movimentos AT ROW 3.75 COL 2.72 WIDGET-ID 300
     fi-valor-total AT ROW 11.83 COL 72.72 COLON-ALIGNED WIDGET-ID 6
     fi-valor-saldo AT ROW 11.83 COL 97.43 COLON-ALIGNED WIDGET-ID 4
     br-baixas AT ROW 13.21 COL 2.72 WIDGET-ID 400
     btFechar AT ROW 21.79 COL 1.72 WIDGET-ID 14
     btHelp2 AT ROW 21.79 COL 103.43
     "Filtro:" VIEW-AS TEXT
          SIZE 4 BY .54 AT ROW 1.08 COL 4 WIDGET-ID 88
     rtToolBar AT ROW 21.58 COL 1
     RECT-13 AT ROW 1.33 COL 2.72 WIDGET-ID 86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 113.43 BY 22.04
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
         TITLE              = "Consulta Notas Acordo Comercial - ESUTP047"
         COLUMN             = 25.14
         ROW                = 8.17
         HEIGHT             = 22.04
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
/* BROWSE-TAB br-movimentos fi-nr-nota-fis fpage0 */
/* BROWSE-TAB br-baixas fi-valor-saldo fpage0 */
/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-valor-saldo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-valor-total IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-baixas
/* Query rebuild information for BROWSE br-baixas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-baixas.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-baixas */
&ANALYZE-RESUME

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
ON END-ERROR OF wWindow /* Consulta Acordo Notas Fiscais - ESUTP047 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Consulta Acordo Notas Fiscais - ESUTP047 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCarrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCarrega wWindow
ON CHOOSE OF btCarrega IN FRAME fpage0 /* Carrega */
DO:
    RUN pi-carrega-dados.
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


&Scoped-define BROWSE-NAME br-baixas
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

    DEFINE VARIABLE de-valor-total AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
    DEFINE VARIABLE de-valor-saldo AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
    DEFINE VARIABLE l-ok AS LOGICAL     NO-UNDO.

    FOR EACH tt-movimentos:
        DELETE tt-movimentos.
    END.

    FOR EACH tt-baixas:
        DELETE tt-baixas.
    END.

    ASSIGN INPUT FRAME fPage0 fi-cod-estabel fi-nr-nota-fis
           de-valor-total = 0
           de-valor-saldo = 0
           l-ok           = NO.

    FOR EACH acordo-fatur NO-LOCK
       WHERE acordo-fatur.cod-estabel    = fi-cod-estabel
         AND acordo-fatur.nr-nota-fis    = fi-nr-nota-fis:

        FIND FIRST tipo-acordo NO-LOCK
             WHERE tipo-acordo.codigo = acordo-fatur.tipo-acordo NO-ERROR.

        CREATE tt-movimentos.
        ASSIGN tt-movimentos.num-id-movto  = 0
               tt-movimentos.num-id-fatur  = acordo-fatur.num-id-fatur
               tt-movimentos.matriz        = acordo-fatur.matriz
               tt-movimentos.cod-estabel   = acordo-fatur.cod-estabel   
               tt-movimentos.num-id-titulo = acordo-fatur.num-id-titulo 
               tt-movimentos.serie         = acordo-fatur.serie         
               tt-movimentos.nr-nota-fis   = acordo-fatur.nr-nota-fis   
               tt-movimentos.matriz        = acordo-fatur.matriz   
               tt-movimentos.cod-emitente  = acordo-fatur.cod-emitente   
               tt-movimentos.nr-nota-dev   = acordo-fatur.nr-nota-dev
               tt-movimentos.cod-unid-neg  = acordo-fatur.cod-unid-neg
               tt-movimentos.tipo-acordo   = STRING(acordo-fatur.tipo-acordo) + "-" + IF AVAIL tipo-acordo THEN tipo-acordo.descricao ELSE "Nao cadastrado"
               tt-movimentos.periodo       = acordo-fatur.periodo
               tt-movimentos.per-acordo    = acordo-fatur.per-acordo    
               tt-movimentos.valor-acordo  = acordo-fatur.valor-acordo
               tt-movimentos.saldo         = acordo-fatur.saldo.

        ASSIGN de-valor-total = de-valor-total + tt-movimentos.valor-acordo
               de-valor-saldo = de-valor-saldo + tt-movimentos.saldo
               l-ok = YES.
    END.

    ASSIGN fi-valor-total:SCREEN-VALUE IN FRAME fPage0 = STRING(de-valor-total,"->>>,>>>,>>9.99")
           fi-valor-saldo:SCREEN-VALUE IN FRAME fPage0 = STRING(de-valor-saldo,"->>>,>>>,>>9.99").

    {&open-query-br-movimentos}

    FOR EACH movto-acordo-fatur NO-LOCK
       WHERE movto-acordo-fatur.data-cancel = ?,
       FIRST acordo-fatur NO-LOCK
       WHERE acordo-fatur.num-id-fatur = movto-acordo-fatur.num-id-fatur
         AND acordo-fatur.cod-estabel  = fi-cod-estabel
         AND acordo-fatur.nr-nota-fis  = fi-nr-nota-fis:

        FIND FIRST tipo-acordo NO-LOCK
             WHERE tipo-acordo.codigo = acordo-fatur.tipo-acordo NO-ERROR.

        FIND FIRST tit_ap NO-LOCK
             WHERE tit_ap.cod_estab     = acordo-fatur.cod-estabel
               AND tit_ap.num_id_tit_ap = movto-acordo-fatur.num-id-titulo NO-ERROR.

        CREATE tt-baixas.
        ASSIGN tt-baixas.num-id-titulo = movto-acordo-fatur.num-id-titulo
               tt-baixas.num-id-movto  = movto-acordo-fatur.num-id-movto 
               tt-baixas.cod-estabel   = acordo-fatur.cod-estabel   
               tt-baixas.serie         = acordo-fatur.serie         
               tt-baixas.nr-nota-fis   = acordo-fatur.nr-nota-fis   
               tt-baixas.nr-nota-dev   = acordo-fatur.nr-nota-dev
               tt-baixas.tipo-acordo   = STRING(acordo-fatur.tipo-acordo) + "-" + IF AVAIL tipo-acordo THEN tipo-acordo.descricao ELSE "Nao cadastrado"
               tt-baixas.documento     = IF AVAIL tit_ap THEN tit_ap.cod_tit_ap ELSE "nao encontrado"
               tt-baixas.matriz        = acordo-fatur.matriz   
               tt-baixas.cod-emitente  = acordo-fatur.cod-emitente   
               tt-baixas.cod-unid-neg  = acordo-fatur.cod-unid-neg
               tt-baixas.periodo       = acordo-fatur.periodo
               tt-baixas.per-acordo    = acordo-fatur.per-acordo    
               tt-baixas.usuario       = movto-acordo-fatur.usuario 
               tt-baixas.data          = movto-acordo-fatur.data    
               tt-baixas.hora          = movto-acordo-fatur.hora    
               tt-baixas.valor-baixa   = movto-acordo-fatur.valor.  
    END.

    {&open-query-br-baixas}

    IF NOT l-ok THEN
        MESSAGE "NÆo foi encontrado Nota Fiscal!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

