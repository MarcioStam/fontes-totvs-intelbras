&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE tt-etiqueta
    FIELD cod-pallet    LIKE ns-volume.volume-pai    COLUMN-LABEL "Pallet"
    FIELD cod-caixa     LIKE ns-volume.volume-pai    COLUMN-LABEL "Caixa"
    FIELD cod-produto   LIKE ns-volume.volume-pai    COLUMN-LABEL "Produto"
    FIELD it-codigo     LIKE ITEM.it-codigo          COLUMN-LABEL "Codigo Item"
    FIELD cod-estabel   LIKE estabelec.cod-estabel   
    FIELD usuario       AS CHAR                      COLUMN-LABEL "Usuar.Vinculo"
    FIELD data          AS CHAR                      COLUMN-LABEL "Data Vinculo"
    INDEX cd cod-pallet cod-caixa cod-produto.

DEF VAR c-anterior      AS CHAR.
DEF VAR c-caixa-atu     AS CHAR.
DEF VAR c-caixa         AS CHAR.
DEF VAR i-quant-cx      AS INT.
DEF VAR i-quant-pt      AS INT.
DEF VAR i-cont          AS INT.
DEF VAR i-contEtiq      AS INT.
DEF VAR l-erro          AS LOG.
DEF VAR c-acao          AS CHAR.
DEF VAR l-ok            AS LOG.
DEF VAR l-reincorpora   AS LOG.
DEF VAR de-nr           AS DEC.

DEF BUFFER b-volume FOR ns-volume.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME br-etiqueta

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-etiqueta

/* Definitions for BROWSE br-etiqueta                                   */
&Scoped-define FIELDS-IN-QUERY-br-etiqueta tt-etiqueta.cod-estabel tt-etiqueta.cod-pallet tt-etiqueta.cod-caixa tt-etiqueta.cod-produto tt-etiqueta.it-codigo tt-etiqueta.usuario tt-etiqueta.data   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-etiqueta   
&Scoped-define SELF-NAME br-etiqueta
&Scoped-define QUERY-STRING-br-etiqueta FOR EACH tt-etiqueta
&Scoped-define OPEN-QUERY-br-etiqueta OPEN QUERY {&SELF-NAME} FOR EACH tt-etiqueta.
&Scoped-define TABLES-IN-QUERY-br-etiqueta tt-etiqueta
&Scoped-define FIRST-TABLE-IN-QUERY-br-etiqueta tt-etiqueta


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-br-etiqueta}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-qtde c-etiqueta br-etiqueta btExit btHelp ~
RECT-17 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS c-qtde c-etiqueta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Arquivo 
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCancela      LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre"        .

DEFINE MENU MbMain MENUBAR
       SUB-MENU  m_Arquivo      LABEL "&Arquivo"      
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE c-etiqueta AS CHARACTER FORMAT "X(20)":U 
     LABEL "Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-qtde AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Qtde" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-etiqueta FOR 
      tt-etiqueta SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-etiqueta C-Win _FREEFORM
  QUERY br-etiqueta DISPLAY
      tt-etiqueta.cod-estabel
tt-etiqueta.cod-pallet  WIDTH 13
tt-etiqueta.cod-caixa   WIDTH 13 
tt-etiqueta.cod-produto WIDTH 19  FORMAT 'x(20)'
tt-etiqueta.it-codigo
tt-etiqueta.usuario WIDTH 10
tt-etiqueta.data FORMAT 'x(25)'
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 12.25
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     c-qtde AT ROW 3.25 COL 78 COLON-ALIGNED
     c-etiqueta AT ROW 3.08 COL 12 COLON-ALIGNED HELP
          "Registre a Etiqueta" AUTO-RETURN 
     br-etiqueta AT ROW 4.5 COL 1
     btExit AT ROW 1.17 COL 82.43 HELP
          "Sair"
     btHelp AT ROW 1.17 COL 86.43 HELP
          "Ajuda"
     RECT-17 AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.86 BY 16
         FONT 1.


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
         TITLE              = "ESCPP005.W - 2.04.000 - Consulta Pallet X Caixa X Produto"
         HEIGHT             = 15.92
         WIDTH              = 90.29
         MAX-HEIGHT         = 30.04
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 30.04
         VIRTUAL-WIDTH      = 146.29
         MIN-BUTTON         = no
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-etiqueta c-etiqueta DEFAULT-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-etiqueta
/* Query rebuild information for BROWSE br-etiqueta
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-etiqueta.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-etiqueta */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* ESCPP005.W - 2.04.000 - Consulta Pallet X Caixa X Produto */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* ESCPP005.W - 2.04.000 - Consulta Pallet X Caixa X Produto */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit C-Win
ON CHOOSE OF btExit IN FRAME DEFAULT-FRAME /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp C-Win
ON CHOOSE OF btHelp IN FRAME DEFAULT-FRAME /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-etiqueta C-Win
ON RETURN OF c-etiqueta IN FRAME DEFAULT-FRAME /* Etiqueta */
DO: 

    DEF VAR cont AS INT.
    ASSIGN cont = 0.


    ASSIGN INPUT FRAME {&FRAME-NAME} c-etiqueta.  

    ASSIGN l-erro = NO.

    IF SUBSTRING(c-etiqueta,1,3) <> "ECO" AND
       SUBSTRING(c-etiqueta,1,3) <> "EPA" THEN DO: /* caso seja etiqueta de produto */
       
       IF length(c-etiqueta) = 15 THEN
           ASSIGN l-erro = NO.
       ELSE DO:
            
           /*
           IF length(c-etiqueta) > 13 THEN 
              ASSIGN l-erro = YES.                  /* tamanho m†ximo = 13 */
           DO i-contEtiq = 5 TO LENGTH(c-etiqueta) - 2:
              IF l-erro = YES THEN 
                 LEAVE.
              IF asc(SUBSTRING(c-etiqueta,i-contEtiq,1)) < 48 AND
                 asc(SUBSTRING(c-etiqueta,i-contEtiq,1)) > 57 THEN      
                 ASSIGN l-erro = YES.                                                /** s¢ pode ter numeros **/
           END. */  
           
       END.

       /*
       IF l-erro = YES THEN DO:
          MESSAGE "Dado informado n∆o corresponde a etiqueta"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
          RETURN NO-APPLY.
       END. */

       FIND FIRST ns-volume WHERE
                  ns-volume.volume-filho = c-etiqueta NO-LOCK NO-ERROR.
       IF NOT AVAIL ns-volume THEN DO:
          MESSAGE "Etiqueta de produto sem relacionamento com caixa."
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
          RETURN NO-APPLY.
       END.

    END.
    ELSE DO:
        DO i-contEtiq = 4 TO LENGTH(c-etiqueta):
           IF asc(SUBSTRING(c-etiqueta,i-contEtiq,1)) < 48 AND
              asc(SUBSTRING(c-etiqueta,i-contEtiq,1)) > 57 THEN DO:     
              ASSIGN l-erro = YES.                                               /** s¢ pode ter numeros **/
              LEAVE.
           END.
        END.

        IF l-erro = YES THEN DO:
           MESSAGE "Dado informado n∆o corresponde a etiqueta."
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
           RETURN NO-APPLY.
        END.

        FIND FIRST ns-volume WHERE 
                   ns-volume.volume-pai = c-etiqueta NO-LOCK NO-ERROR.
        IF NOT AVAIL ns-volume THEN DO:
           MESSAGE "Etiqueta de caixa/pallet sem relacionamentos com produto/caixa"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
           RETURN NO-APPLY.
        END.
    END.
  

  /***************************** Inicia processamento dos botoes *******************************/
    EMPTY TEMP-TABLE tt-etiqueta.
    IF SUBSTRING(c-etiqueta,1,3) <> "ECO" AND
       SUBSTRING(c-etiqueta,1,3) <> "EPA" THEN DO: /* caso seja etiqueta de produto */
       FIND FIRST ns-volume WHERE 
                  ns-volume.volume-filho = c-etiqueta NO-LOCK NO-ERROR.
       CREATE tt-etiqueta.
       ASSIGN tt-etiqueta.cod-produto = c-etiqueta.

       ASSIGN cont = 1.

       FIND b-volume WHERE 
            b-volume.volume-filho = ns-volume.volume-pai NO-LOCK NO-ERROR.
       IF NOT AVAIL b-volume THEN DO:
          IF ns-volume.volume-pai = "ECO-INDEFINIDA" THEN DO:
             ASSIGN tt-etiqueta.cod-caixa = "** Desvinculado **".
          END.
          ELSE DO:
             ASSIGN tt-etiqueta.cod-caixa = ns-volume.volume-pai.
          END.
          ASSIGN tt-etiqueta.cod-pallet = "** Desvinculado **".
       END.
       ELSE DO:
          ASSIGN tt-etiqueta.cod-pallet = b-volume.volume-pai
                 tt-etiqueta.cod-caixa  = IF ns-volume.volume-pai = "ECO-INDEFINIDA" THEN
                                             "** Desvinculado **"
                                          ELSE ns-volume.volume-pai.
       END.
       RUN pi-retorna-item (ns-volume.volume-filho, OUTPUT tt-etiqueta.it-codigo).
    END.
    ELSE 
        IF c-etiqueta BEGINS "ECO" THEN DO:
           FIND FIRST b-volume WHERE
                      b-volume.volume-filho = c-etiqueta NO-LOCK NO-ERROR.
           FOR EACH ns-volume WHERE 
                    ns-volume.volume-pai = c-etiqueta NO-LOCK:

               ASSIGN cont = cont + 1.

               CREATE tt-etiqueta.
               ASSIGN tt-etiqueta.cod-pallet  = (IF NOT AVAIL b-volume THEN
                                                    "** Desvinculado **"
                                                 ELSE
                                                    b-volume.volume-pai)
                      tt-etiqueta.cod-caixa   = c-etiqueta
                      tt-etiqueta.cod-produto = ns-volume.volume-filho.

               RUN pi-retorna-item (ns-volume.volume-filho, OUTPUT tt-etiqueta.it-codigo).
           END.
        END.
        ELSE
           IF c-etiqueta BEGINS "EPA" THEN DO:
              FOR EACH ns-volume WHERE 
                       ns-volume.volume-pai = c-etiqueta NO-LOCK:
                  FOR EACH b-volume WHERE 
                           b-volume.volume-pai = ns-volume.volume-filho NO-LOCK:

                      ASSIGN cont = cont + 1.

                      CREATE tt-etiqueta.
                      ASSIGN tt-etiqueta.cod-pallet  = c-etiqueta
                             tt-etiqueta.cod-caixa   = ns-volume.volume-filho
                             tt-etiqueta.cod-produto = b-volume.volume-filho.

                      RUN pi-retorna-item (b-volume.volume-filho, OUTPUT tt-etiqueta.it-codigo).
                  END.
              END.
           END.

    FOR EACH tt-etiqueta:
        FIND FIRST ns-volume-estab NO-LOCK 
             WHERE ns-volume-estab.volume-pai = tt-etiqueta.cod-caixa
        NO-ERROR.

        IF AVAIL ns-volume-estab THEN
           ASSIGN tt-etiqueta.cod-estabel = ns-volume-estab.cod-estabel
                  tt-etiqueta.usuario     = ns-volume-estab.usuario-vincula
                  tt-etiqueta.data        = STRING(ns-volume-estab.data-vincula).
    END.


    {&OPEN-QUERY-{&BROWSE-NAME}}

    ASSIGN c-etiqueta:SCREEN-VALUE = "". 

    ASSIGN c-qtde:SCREEN-VALUE = string(cont).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-etiqueta
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

  RUN enable_UI.

  FOR EACH tt-etiqueta:
      DELETE tt-etiqueta.
  END.
    
  {&OPEN-QUERY-{&BROWSE-NAME}}

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.

  c-qtde:SENSITIVE = FALSE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  DISPLAY c-qtde c-etiqueta 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE c-qtde c-etiqueta br-etiqueta btExit btHelp RECT-17 rtToolBar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-registro C-Win 
PROCEDURE pi-grava-registro :
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-item C-Win 
PROCEDURE pi-retorna-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      DEF INPUT PARAM c-etiq-produto AS CHAR.
      DEF OUTPUT PARAM c-it-codigo AS CHAR.


      FOR FIRST num-serie NO-LOCK
          WHERE num-serie.n-serie = c-etiq-produto:
      END.

      IF AVAIL num-serie THEN DO:

          ASSIGN c-it-codigo = num-serie.it-codigo.

      END.
      ELSE DO:

          FIND imei-prod WHERE imei-prod.cod-imei = c-etiq-produto NO-LOCK NO-ERROR.
          IF NOT AVAIL imei-prod THEN
              ASSIGN c-it-codigo = "* Sem Relaá‰es *".
          ELSE
              ASSIGN c-it-codigo = imei-prod.it-codigo.
                                                       
      END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

