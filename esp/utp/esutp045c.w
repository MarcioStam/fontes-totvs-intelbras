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
    FIELD selecionado   AS LOGICAL FORMAT "x/"
    FIELD num-id-movto  LIKE movto-acordo-fatur.num-id-movto   
    FIELD num-id-titulo LIKE movto-acordo-fatur.num-id-titulo  
    FIELD num-id-fatur  LIKE movto-acordo-fatur.num-id-fatur   
    FIELD cod-estabel   LIKE acordo-fatur.cod-estabel
    FIELD serie         LIKE acordo-fatur.serie
    FIELD nr-nota-fis   LIKE acordo-fatur.nr-nota-fis
    FIELD nr-nota-dev   LIKE acordo-fatur.nr-nota-dev
    FIELD cod-unid-neg  LIKE acordo-fatur.cod-unid-neg
    FIELD periodo       LIKE acordo-fatur.periodo   
    FIELD per-acordo    LIKE acordo-fatur.per-acordo
    FIELD tipo-acordo   AS CHARACTER FORMAT "x(30)"
    FIELD usuario       LIKE movto-acordo-fatur.usuario
    FIELD data          LIKE movto-acordo-fatur.data
    FIELD hora          LIKE movto-acordo-fatur.hora
    FIELD valor         LIKE movto-acordo-fatur.valor.

def new global shared var v_cod_usuar_corren as CHARACTER format "x(12)":U label "Usuario Corrente"     column-label "Usuario Corrente" no-undo.

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
&Scoped-define FIELDS-IN-QUERY-br-movimentos tt-movimentos.selecionado tt-movimentos.cod-estabel tt-movimentos.serie tt-movimentos.nr-nota-fis tt-movimentos.cod-unid-neg tt-movimentos.periodo tt-movimentos.tipo-acordo tt-movimentos.per-acordo tt-movimentos.usuario tt-movimentos.data tt-movimentos.hora tt-movimentos.valor   
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
&Scoped-Define ENABLED-OBJECTS rtToolBar br-movimentos btMarcaTodos ~
btDesmarcaTodos ed-motivo-cancel btSalvar btFechar btHelp2 
&Scoped-Define DISPLAYED-OBJECTS ed-motivo-cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btDesmarcaTodos 
     LABEL "Desmarca Todos" 
     SIZE 14 BY 1.

DEFINE BUTTON btFechar 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btMarcaTodos 
     LABEL "Marca Todos" 
     SIZE 11.29 BY 1.

DEFINE BUTTON btSalvar 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE ed-motivo-cancel AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 109.43 BY 3.54 NO-UNDO.

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
      tt-movimentos.selecionado   COLUMN-LABEL ""                            
      tt-movimentos.cod-estabel   COLUMN-LABEL "Est"            WIDTH 3      
      tt-movimentos.serie         COLUMN-LABEL "Ser"            WIDTH 3      
      tt-movimentos.nr-nota-fis   COLUMN-LABEL "Nota Fiscal"    WIDTH 8      
      tt-movimentos.cod-unid-neg  COLUMN-LABEL "Unid.Neg."      WIDTH 7  
      tt-movimentos.periodo       COLUMN-LABEL "Per°odo"        WIDTH 8      
      tt-movimentos.tipo-acordo   COLUMN-LABEL "Tipo Acordo"    WIDTH 22   
      tt-movimentos.per-acordo    COLUMN-LABEL "Perc.Acordo"    WIDTH 9    
      tt-movimentos.usuario       COLUMN-LABEL "Usu†rio"        WIDTH 8    
      tt-movimentos.data          COLUMN-LABEL "Data"           WIDTH 9    
      tt-movimentos.hora          COLUMN-LABEL "Hora"           WIDTH 6.5    
      tt-movimentos.valor         COLUMN-LABEL "Valor"          WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 110 BY 13.75
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     br-movimentos AT ROW 1.67 COL 2.72 WIDGET-ID 300
     btMarcaTodos AT ROW 15.5 COL 2.72 WIDGET-ID 8
     btDesmarcaTodos AT ROW 15.5 COL 14 WIDGET-ID 10
     ed-motivo-cancel AT ROW 16.67 COL 2.86 NO-LABEL WIDGET-ID 2
     btSalvar AT ROW 20.71 COL 2.14 WIDGET-ID 12
     btFechar AT ROW 20.71 COL 12.14
     btHelp2 AT ROW 20.71 COL 103.43
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
         TITLE              = "Cancela Baixa Notas Fiscais X T°tulo - ESUTP045C"
         COLUMN             = 25.29
         ROW                = 8.25
         HEIGHT             = 20.92
         WIDTH              = 113.43
         MAX-HEIGHT         = 39.54
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.54
         VIRTUAL-WIDTH      = 182.86
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
ON END-ERROR OF wWindow /* Cancela Baixa Notas Fiscais X T°tulo - ESUTP045C */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Cancela Baixa Notas Fiscais X T°tulo - ESUTP045C */
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
ON MOUSE-SELECT-DBLCLICK OF br-movimentos IN FRAME fpage0
DO:
    IF AVAIL tt-movimentos THEN DO:
        ASSIGN tt-movimentos.selecionado = NOT tt-movimentos.selecionado.

        br-movimentos:REFRESH().
    END.

    /*RUN pi-totaliza.*/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-movimentos wWindow
ON ROW-DISPLAY OF br-movimentos IN FRAME fpage0
DO:
    IF AVAIL tt-movimentos THEN DO:
        IF tt-movimentos.selecionado THEN DO:
            RUN pi-muda-cor(INPUT 12 , INPUT ?).
        END.
        ELSE DO:
            RUN pi-muda-cor(INPUT ?, INPUT ?).
        END.
    END.
    ELSE RUN pi-muda-cor(INPUT ?, INPUT ?).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDesmarcaTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesmarcaTodos wWindow
ON CHOOSE OF btDesmarcaTodos IN FRAME fpage0 /* Desmarca Todos */
DO:
    FOR EACH tt-movimentos:
        ASSIGN tt-movimentos.selecionado = NO.
    END.
    br-movimentos:REFRESH().
    /*RUN pi-totaliza.*/
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


&Scoped-define SELF-NAME btMarcaTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMarcaTodos wWindow
ON CHOOSE OF btMarcaTodos IN FRAME fpage0 /* Marca Todos */
DO:
    FOR EACH tt-movimentos:
        ASSIGN tt-movimentos.selecionado = YES.
    END.
    br-movimentos:REFRESH().
    /*RUN pi-totaliza.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSalvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalvar wWindow
ON CHOOSE OF btSalvar IN FRAME fpage0 /* Salvar */
DO:
    DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.

    ASSIGN INPUT FRAME fPage0 ed-motivo-cancel.

    IF NOT CAN-FIND(FIRST tt-movimentos NO-LOCK WHERE tt-movimentos.selecionado) THEN DO:
        MESSAGE "Favor selecione algum registro para efetuar o estorno!"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.                       
        RETURN NO-APPLY.
    END.

    IF ed-motivo-cancel = "" THEN DO:
        MESSAGE "Motivo Cancelamento deve ser informado!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "entry" TO ed-motivo-cancel IN FRAME fPage0.
        RETURN NO-APPLY.
    END.
    
    ASSIGN l-erro = NO.
    BAIXA:
    DO TRANSACTION ON ERROR UNDO BAIXA, LEAVE BAIXA:
        FOR EACH tt-movimentos WHERE tt-movimentos.selecionado:
            FIND FIRST movto-acordo-fatur EXCLUSIVE-LOCK
                 WHERE movto-acordo-fatur.num-id-movto  = tt-movimentos.num-id-movto 
                   AND movto-acordo-fatur.num-id-titulo = tt-movimentos.num-id-titulo
                   AND movto-acordo-fatur.num-id-fatur  = tt-movimentos.num-id-fatur NO-ERROR.
            IF NOT AVAIL movto-acordo-fatur OR
               movto-acordo-fatur.usuario-cancel <> "" THEN DO:
                MESSAGE "Movimento n∆o encontrado ou j† cancelado por outro usu†rio, processo cancelado!"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                ASSIGN l-erro = YES.
                LEAVE.
            END.

            FIND FIRST acordo-fatur EXCLUSIVE-LOCK
                 WHERE acordo-fatur.num-id-fatur = tt-movimentos.num-id-fatur NO-ERROR.
            IF NOT AVAIL acordo-fatur THEN DO:
                MESSAGE "N∆o encontrou registro faturamento, processo cancelado!"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                ASSIGN l-erro = YES.
                LEAVE.
            END.
                
            ASSIGN acordo-fatur.saldo = acordo-fatur.saldo + tt-movimentos.valor
                   movto-acordo-fatur.data-cancel    = TODAY
                   movto-acordo-fatur.hora-cancel    = STRING(TIME,"HH:MM:SS")
                   movto-acordo-fatur.usuario-cancel = v_cod_usuar_corren
                   movto-acordo-fatur.motivo-cancel  = ed-motivo-cancel.
        END.

        IF l-erro THEN
            UNDO BAIXA, LEAVE BAIXA.
    END.

    IF NOT l-erro THEN DO:
        APPLY "close" TO THIS-PROCEDURE.
    END.
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
         AND movto-acordo-fatur.num-id-movto  = p-id-movto
         AND movto-acordo-fatur.usuario-cancel = ""
         AND movto-acordo-fatur.usuario <> "sistema"
         AND movto-acordo-fatur.usuario <> "adm",
       FIRST acordo-fatur NO-LOCK
       WHERE acordo-fatur.num-id-fatur = movto-acordo-fatur.num-id-fatur:

        FIND FIRST tipo-acordo NO-LOCK
             WHERE tipo-acordo.codigo = acordo-fatur.tipo-acordo NO-ERROR.

        CREATE tt-movimentos.
        ASSIGN tt-movimentos.num-id-titulo = movto-acordo-fatur.num-id-titulo
               tt-movimentos.num-id-movto  = movto-acordo-fatur.num-id-movto 
               tt-movimentos.num-id-fatur  = movto-acordo-fatur.num-id-fatur 
               tt-movimentos.cod-estabel   = acordo-fatur.cod-estabel   
               tt-movimentos.serie         = acordo-fatur.serie         
               tt-movimentos.nr-nota-fis   = acordo-fatur.nr-nota-fis   
               tt-movimentos.cod-unid-neg  = acordo-fatur.cod-unid-neg   
               tt-movimentos.nr-nota-dev   = acordo-fatur.nr-nota-dev
               tt-movimentos.tipo-acordo   = STRING(acordo-fatur.tipo-acordo) + "-" + IF AVAIL tipo-acordo THEN tipo-acordo.descricao ELSE "Nao cadastrado"
               tt-movimentos.periodo       = acordo-fatur.periodo
               tt-movimentos.per-acordo    = acordo-fatur.per-acordo    
               tt-movimentos.usuario       = movto-acordo-fatur.usuario 
               tt-movimentos.data          = movto-acordo-fatur.data    
               tt-movimentos.hora          = movto-acordo-fatur.hora    
               tt-movimentos.valor         = movto-acordo-fatur.valor.  
    END.

    {&open-query-br-movimentos}
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
    ASSIGN tt-movimentos.selecionado:BGCOLOR  IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.cod-estabel:BGCOLOR IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.serie:BGCOLOR       IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.nr-nota-fis:BGCOLOR IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.cod-unid-neg:BGCOLOR IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.periodo:BGCOLOR     IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.tipo-acordo:BGCOLOR IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.per-acordo:BGCOLOR  IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.usuario:BGCOLOR     IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.data:BGCOLOR        IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.hora:BGCOLOR        IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.valor:BGCOLOR       IN BROWSE br-movimentos = p-bgcolor
           .

    /*cor da letra*/
    ASSIGN tt-movimentos.selecionado:FGCOLOR IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.cod-estabel:FGCOLOR IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.serie:FGCOLOR       IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.nr-nota-fis:FGCOLOR IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.cod-unid-neg:BGCOLOR IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.periodo:BGCOLOR     IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.tipo-acordo:FGCOLOR IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.per-acordo:BGCOLOR  IN BROWSE br-movimentos = p-bgcolor
           tt-movimentos.usuario:FGCOLOR     IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.data:FGCOLOR        IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.hora:FGCOLOR        IN BROWSE br-movimentos = p-fgcolor
           tt-movimentos.valor:FGCOLOR       IN BROWSE br-movimentos = p-fgcolor
           .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

