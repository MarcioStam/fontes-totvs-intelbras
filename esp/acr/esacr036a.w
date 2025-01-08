&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
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
DEFINE INPUT  PARAMETER pIndicador AS INTEGER     NO-UNDO. /* 1- Parƒmentros  2- Classe */


/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-param-supcard NO-UNDO
    FIELD sequencia              LIKE int-param-supcard.sequencia
    FIELD dat-alteracao          LIKE int-param-supcard.dat-alteracao
    FIELD cod-usuar              LIKE int-param-supcard.cod-usuar
    FIELD diretorio-remessa-de   LIKE int-param-supcard.diretorio-remessa
    FIELD diretorio-remessa-para LIKE int-param-supcard.diretorio-remessa
    FIELD diretorio-retorno-de   LIKE int-param-supcard.diretorio-retorno
    FIELD diretorio-retorno-para LIKE int-param-supcard.diretorio-retorno
    FIELD qtd-dias-atraso-de     LIKE int-param-supcard.qtd-dias-atraso
    FIELD qtd-dias-atraso-para   LIKE int-param-supcard.qtd-dias-atraso
    FIELD val-min-trans-de       LIKE int-param-supcard.val-min-trans
    FIELD val-min-parc-de        LIKE int-param-supcard.val-min-parc
    FIELD val-min-trans-para     LIKE int-param-supcard.val-min-trans
    FIELD val-min-parc-para      LIKE int-param-supcard.val-min-parc.

DEFINE BUFFER bf-int-param-supcard FOR int-param-supcard.


DEFINE TEMP-TABLE tt-int-classe-cli-supcard NO-UNDO
    FIELD sequencia                LIKE int-classe-cli-supcard.sequencia
    FIELD dat-alteracao            LIKE int-classe-cli-supcard.dat-alteracao
    FIELD cod-usuar                LIKE int-classe-cli-supcard.cod-usuar
    FIELD des-classe-de            LIKE int-classe-cli-supcard.des-classe
    FIELD des-classe-para          LIKE int-classe-cli-supcard.des-classe
    FIELD val-limite-ini-de        LIKE int-classe-cli-supcard.val-limite-ini
    FIELD val-limite-ini-para      LIKE int-classe-cli-supcard.val-limite-ini
    FIELD val-limite-fin-de        LIKE int-classe-cli-supcard.val-limite-fin
    FIELD val-limite-fin-para      LIKE int-classe-cli-supcard.val-limite-fin
    FIELD val-taxa-adm-de          LIKE int-classe-cli-supcard.val-taxa-adm
    FIELD val-taxa-adm-para        LIKE int-classe-cli-supcard.val-taxa-adm
    FIELD val-taxa-canc-devol-de   LIKE int-classe-cli-supcard.val-taxa-canc-devol
    FIELD val-taxa-canc-devol-para LIKE int-classe-cli-supcard.val-taxa-canc-devol
    FIELD val-taxa-prorrog-de      LIKE int-classe-cli-supcard.val-taxa-prorrog
    FIELD val-taxa-prorrog-para    LIKE int-classe-cli-supcard.val-taxa-prorrog
    FIELD cod-cond-pag-de          LIKE int-classe-cli-supcard.cod-cond-pag
    FIELD cod-cond-pag-para        LIKE int-classe-cli-supcard.cod-cond-pag.

DEFINE BUFFER bf-int-classe-cli-supcard FOR int-classe-cli-supcard.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brHistoricoClasse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-classe-cli-supcard tt-param-supcard

/* Definitions for BROWSE brHistoricoClasse                             */
&Scoped-define FIELDS-IN-QUERY-brHistoricoClasse tt-int-classe-cli-supcard.sequencia tt-int-classe-cli-supcard.dat-alteracao tt-int-classe-cli-supcard.cod-usuar tt-int-classe-cli-supcard.des-classe-de tt-int-classe-cli-supcard.des-classe-para tt-int-classe-cli-supcard.val-limite-ini-de tt-int-classe-cli-supcard.val-limite-ini-para tt-int-classe-cli-supcard.val-limite-fin-de tt-int-classe-cli-supcard.val-limite-fin-para tt-int-classe-cli-supcard.val-taxa-adm-de tt-int-classe-cli-supcard.val-taxa-adm-para tt-int-classe-cli-supcard.val-taxa-canc-devol-de tt-int-classe-cli-supcard.val-taxa-canc-devol-para tt-int-classe-cli-supcard.val-taxa-prorrog-de tt-int-classe-cli-supcard.val-taxa-prorrog-para tt-int-classe-cli-supcard.cod-cond-pag-de tt-int-classe-cli-supcard.cod-cond-pag-para   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brHistoricoClasse   
&Scoped-define SELF-NAME brHistoricoClasse
&Scoped-define QUERY-STRING-brHistoricoClasse FOR EACH tt-int-classe-cli-supcard BY tt-int-classe-cli-supcard.sequencia DESC
&Scoped-define OPEN-QUERY-brHistoricoClasse OPEN QUERY {&SELF-NAME} FOR EACH tt-int-classe-cli-supcard BY tt-int-classe-cli-supcard.sequencia DESC.
&Scoped-define TABLES-IN-QUERY-brHistoricoClasse tt-int-classe-cli-supcard
&Scoped-define FIRST-TABLE-IN-QUERY-brHistoricoClasse tt-int-classe-cli-supcard


/* Definitions for BROWSE brHistoricoParam                              */
&Scoped-define FIELDS-IN-QUERY-brHistoricoParam tt-param-supcard.sequencia tt-param-supcard.dat-alteracao tt-param-supcard.cod-usuar tt-param-supcard.diretorio-remessa-de tt-param-supcard.diretorio-remessa-para tt-param-supcard.diretorio-retorno-de tt-param-supcard.diretorio-retorno-para tt-param-supcard.qtd-dias-atraso-de tt-param-supcard.qtd-dias-atraso-para tt-param-supcard.val-min-trans-de tt-param-supcard.val-min-trans-para tt-param-supcard.val-min-parc-de tt-param-supcard.val-min-parc-para   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brHistoricoParam   
&Scoped-define SELF-NAME brHistoricoParam
&Scoped-define QUERY-STRING-brHistoricoParam FOR EACH tt-param-supcard BY tt-param-supcard.sequencia DESC
&Scoped-define OPEN-QUERY-brHistoricoParam OPEN QUERY {&SELF-NAME} FOR EACH tt-param-supcard BY tt-param-supcard.sequencia DESC.
&Scoped-define TABLES-IN-QUERY-brHistoricoParam tt-param-supcard
&Scoped-define FIRST-TABLE-IN-QUERY-brHistoricoParam tt-param-supcard


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-brHistoricoClasse}~
    ~{&OPEN-QUERY-brHistoricoParam}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar brHistoricoParam brHistoricoClasse ~
btOK 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btOK 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brHistoricoClasse FOR 
      tt-int-classe-cli-supcard SCROLLING.

DEFINE QUERY brHistoricoParam FOR 
      tt-param-supcard SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brHistoricoClasse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brHistoricoClasse C-Win _FREEFORM
  QUERY brHistoricoClasse DISPLAY
      tt-int-classe-cli-supcard.sequencia                 WIDTH 4
      tt-int-classe-cli-supcard.dat-alteracao             WIDTH 12
      tt-int-classe-cli-supcard.cod-usuar                 WIDTH 9
      tt-int-classe-cli-supcard.des-classe-de             WIDTH 7   COLUMN-LABEL "Classe De"
      tt-int-classe-cli-supcard.des-classe-para           WIDTH 5   COLUMN-LABEL "Para"
      tt-int-classe-cli-supcard.val-limite-ini-de         WIDTH 12  COLUMN-LABEL "Limite Ini De"
      tt-int-classe-cli-supcard.val-limite-ini-para       WIDTH 12  COLUMN-LABEL "Para"
      tt-int-classe-cli-supcard.val-limite-fin-de         WIDTH 12  COLUMN-LABEL "Limite Fim De"
      tt-int-classe-cli-supcard.val-limite-fin-para       WIDTH 12  COLUMN-LABEL "Para"
      tt-int-classe-cli-supcard.val-taxa-adm-de           WIDTH 11  COLUMN-LABEL "Tx Adm De"
      tt-int-classe-cli-supcard.val-taxa-adm-para         WIDTH 7   COLUMN-LABEL "Para"
      tt-int-classe-cli-supcard.val-taxa-canc-devol-de    WIDTH 11  COLUMN-LABEL "Tx Canc/Devol De"
      tt-int-classe-cli-supcard.val-taxa-canc-devol-para  WIDTH 7   COLUMN-LABEL "Para"
      tt-int-classe-cli-supcard.val-taxa-prorrog-de       WIDTH 11  COLUMN-LABEL "Tx Prorrog De"
      tt-int-classe-cli-supcard.val-taxa-prorrog-para     WIDTH 7   COLUMN-LABEL "Para"
      tt-int-classe-cli-supcard.cod-cond-pag-de           WIDTH 30  COLUMN-LABEL "Cond Pagto"
      tt-int-classe-cli-supcard.cod-cond-pag-para         WIDTH 30  COLUMN-LABEL "Para"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88.57 BY 12.5
         FONT 1
         TITLE "Hist¢rico das Classes dos Clientes" FIT-LAST-COLUMN.

DEFINE BROWSE brHistoricoParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brHistoricoParam C-Win _FREEFORM
  QUERY brHistoricoParam DISPLAY
      tt-param-supcard.sequencia              WIDTH 4
      tt-param-supcard.dat-alteracao          WIDTH 12
      tt-param-supcard.cod-usuar              WIDTH 9
      tt-param-supcard.diretorio-remessa-de   WIDTH 14 COLUMN-LABEL "Dir Remessa De"
      tt-param-supcard.diretorio-remessa-para WIDTH 14 COLUMN-LABEL "Para"
      tt-param-supcard.diretorio-retorno-de   WIDTH 14 COLUMN-LABEL "Dir Retorno De"
      tt-param-supcard.diretorio-retorno-para WIDTH 14 COLUMN-LABEL "Para"
      tt-param-supcard.qtd-dias-atraso-de     WIDTH 10 COLUMN-LABEL "Dias Atras. De"
      tt-param-supcard.qtd-dias-atraso-para   WIDTH 10  COLUMN-LABEL "Para"
      tt-param-supcard.val-min-trans-de       WIDTH 14 COLUMN-LABEL "Val Min. Trans. De"
      tt-param-supcard.val-min-trans-para     WIDTH 14 COLUMN-LABEL "Para"
      tt-param-supcard.val-min-parc-de        WIDTH 14 COLUMN-LABEL "Val Min. Parc. De"
      tt-param-supcard.val-min-parc-para      WIDTH 14 COLUMN-LABEL "Para"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88.57 BY 12.5
         FONT 1
         TITLE "Hist¢rico dos Parƒmetros da SupplierCard" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     brHistoricoParam AT ROW 1.25 COL 1.86 WIDGET-ID 200
     brHistoricoClasse AT ROW 1.25 COL 1.86 WIDGET-ID 300
     btOK AT ROW 14.21 COL 2 WIDGET-ID 8
     rtToolBar AT ROW 14 COL 1 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.42
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
         TITLE              = "Hist¢rico de Altera‡äes"
         HEIGHT             = 14.42
         WIDTH              = 90
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 91
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 91
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
/* BROWSE-TAB brHistoricoParam rtToolBar DEFAULT-FRAME */
/* BROWSE-TAB brHistoricoClasse brHistoricoParam DEFAULT-FRAME */
ASSIGN 
       brHistoricoClasse:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE.

ASSIGN 
       brHistoricoParam:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brHistoricoClasse
/* Query rebuild information for BROWSE brHistoricoClasse
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-classe-cli-supcard BY tt-int-classe-cli-supcard.sequencia DESC.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brHistoricoClasse */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brHistoricoParam
/* Query rebuild information for BROWSE brHistoricoParam
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-param-supcard BY tt-param-supcard.sequencia DESC.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brHistoricoParam */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Hist¢rico de Altera‡äes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Hist¢rico de Altera‡äes */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME DEFAULT-FRAME /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brHistoricoClasse
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
    RUN initializeObject.
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
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
  ENABLE rtToolBar brHistoricoParam brHistoricoClasse btOK 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject C-Win 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  pIndicador = 1 /* Parƒmetros SupplierCard */ THEN DO:
        FOR EACH int-param-supcard NO-LOCK:
            CREATE tt-param-supcard.
            ASSIGN tt-param-supcard.sequencia              = int-param-supcard.sequencia
                   tt-param-supcard.dat-alteracao          = int-param-supcard.dat-alteracao
                   tt-param-supcard.cod-usuar              = int-param-supcard.cod-usuar
                   tt-param-supcard.diretorio-remessa-para = int-param-supcard.diretorio-remessa
                   tt-param-supcard.diretorio-retorno-para = int-param-supcard.diretorio-retorno
                   tt-param-supcard.val-min-trans-para     = int-param-supcard.val-min-trans
                   tt-param-supcard.val-min-parc-para      = int-param-supcard.val-min-parc
                   tt-param-supcard.qtd-dias-atraso-para   = int-param-supcard.qtd-dias-atraso.
    
            FIND LAST bf-int-param-supcard NO-LOCK
                WHERE bf-int-param-supcard.sequencia < int-param-supcard.sequencia NO-ERROR.
            IF  AVAIL bf-int-param-supcard THEN
                ASSIGN tt-param-supcard.diretorio-remessa-de = bf-int-param-supcard.diretorio-remessa
                       tt-param-supcard.diretorio-retorno-de = bf-int-param-supcard.diretorio-retorno
                       tt-param-supcard.val-min-trans-de     = bf-int-param-supcard.val-min-trans
                       tt-param-supcard.val-min-parc-de      = bf-int-param-supcard.val-min-parc
                       tt-param-supcard.qtd-dias-atraso-de   = bf-int-param-supcard.qtd-dias-atraso.
            ELSE
                ASSIGN tt-param-supcard.diretorio-remessa-de = ""
                       tt-param-supcard.diretorio-retorno-de = ""
                       tt-param-supcard.val-min-trans-de     = 0
                       tt-param-supcard.val-min-parc-de      = 0
                       tt-param-supcard.qtd-dias-atraso-de   = 0.
        END.
    
        {&OPEN-QUERY-brHistoricoParam}
    
        ASSIGN brHistoricoParam:VISIBLE  IN FRAME default-frame = YES
               brHistoricoClasse:VISIBLE IN FRAME default-frame = NO.
    END.
    ELSE DO:
        FOR EACH int-classe-cli-supcard NO-LOCK:
            CREATE tt-int-classe-cli-supcard.
            ASSIGN tt-int-classe-cli-supcard.sequencia                = int-classe-cli-supcard.sequencia
                   tt-int-classe-cli-supcard.dat-alteracao            = int-classe-cli-supcard.dat-alteracao
                   tt-int-classe-cli-supcard.cod-usuar                = int-classe-cli-supcard.cod-usuar
                   tt-int-classe-cli-supcard.des-classe-para          = int-classe-cli-supcard.des-classe
                   tt-int-classe-cli-supcard.val-limite-ini-para      = int-classe-cli-supcard.val-limite-ini
                   tt-int-classe-cli-supcard.val-limite-fin-para      = int-classe-cli-supcard.val-limite-fin
                   tt-int-classe-cli-supcard.val-taxa-adm-para        = int-classe-cli-supcard.val-taxa-adm
                   tt-int-classe-cli-supcard.val-taxa-canc-devol-para = int-classe-cli-supcard.val-taxa-canc-devol
                   tt-int-classe-cli-supcard.val-taxa-prorrog-para    = int-classe-cli-supcard.val-taxa-prorrog
                   tt-int-classe-cli-supcard.cod-cond-pag-para        = int-classe-cli-supcard.cod-cond-pag.
    
            FIND LAST bf-int-classe-cli-supcard NO-LOCK
                WHERE bf-int-classe-cli-supcard.sequencia  < int-classe-cli-supcard.sequencia
                AND   bf-int-classe-cli-supcard.des-classe = int-classe-cli-supcard.des-classe NO-ERROR.
            IF  AVAIL bf-int-classe-cli-supcard THEN
                ASSIGN tt-int-classe-cli-supcard.des-classe-de          = bf-int-classe-cli-supcard.des-classe
                       tt-int-classe-cli-supcard.val-limite-ini-de      = bf-int-classe-cli-supcard.val-limite-ini
                       tt-int-classe-cli-supcard.val-limite-fin-de      = bf-int-classe-cli-supcard.val-limite-fin
                       tt-int-classe-cli-supcard.val-taxa-adm-de        = bf-int-classe-cli-supcard.val-taxa-adm
                       tt-int-classe-cli-supcard.val-taxa-canc-devol-de = bf-int-classe-cli-supcard.val-taxa-canc-devol
                       tt-int-classe-cli-supcard.val-taxa-prorrog-de    = bf-int-classe-cli-supcard.val-taxa-prorrog
                       tt-int-classe-cli-supcard.cod-cond-pag-de        = bf-int-classe-cli-supcard.cod-cond-pag.
            ELSE
                ASSIGN tt-int-classe-cli-supcard.des-classe-de          = ""
                       tt-int-classe-cli-supcard.val-limite-ini-de      = 0
                       tt-int-classe-cli-supcard.val-limite-fin-de      = 0
                       tt-int-classe-cli-supcard.val-taxa-adm-de        = 0
                       tt-int-classe-cli-supcard.val-taxa-canc-devol-de = 0
                       tt-int-classe-cli-supcard.val-taxa-prorrog-de    = 0
                       tt-int-classe-cli-supcard.cod-cond-pag-de        = "".
        END.
    
        {&OPEN-QUERY-brHistoricoClasse}
    
        ASSIGN brHistoricoParam:VISIBLE  IN FRAME default-frame = NO
               brHistoricoClasse:VISIBLE IN FRAME default-frame = YES.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

