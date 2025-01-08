&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
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
DEFINE INPUT  PARAMETER p-window-parent          AS HANDLE      NO-UNDO.
DEFINE INPUT  PARAMETER r-int-classe-cli-supcard AS ROWID       NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hShowMsg  AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-usuario AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-seq     AS INTEGER     NO-UNDO.

{method/dbotterr.i}

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES int-classe-cli-supcard

/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define QUERY-STRING-DEFAULT-FRAME FOR EACH int-classe-cli-supcard SHARE-LOCK
&Scoped-define OPEN-QUERY-DEFAULT-FRAME OPEN QUERY DEFAULT-FRAME FOR EACH int-classe-cli-supcard SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-DEFAULT-FRAME int-classe-cli-supcard
&Scoped-define FIRST-TABLE-IN-QUERY-DEFAULT-FRAME int-classe-cli-supcard


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 rtToolBar c-des-classe ~
de-val-limite-ini de-val-limite-fin btPesquisar de-taxa-adm ~
de-taxa-canc-devol de-taxa-prorrog btOK btCancel text-classes 
&Scoped-Define DISPLAYED-OBJECTS i-cod-classe c-des-classe ~
de-val-limite-ini de-val-limite-fin de-taxa-adm c-cod-cond-pag ~
de-taxa-canc-devol de-taxa-prorrog text-classes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Salvar" 
     SIZE 10 BY 1.

DEFINE BUTTON btPesquisar 
     IMAGE-UP FILE "image/im-sea.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sea.bmp":U
     LABEL "&Pesquisar" 
     SIZE 4 BY 1.13.

DEFINE VARIABLE c-cod-cond-pag LIKE int-classe-cli-supcard.cod-cond-pag
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-classe AS CHARACTER FORMAT "x(10)" 
     VIEW-AS FILL-IN 
     SIZE 42.72 BY .88 TOOLTIP "Descriá∆o da Classe" NO-UNDO.

DEFINE VARIABLE de-taxa-adm AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Taxa Administrativa" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 TOOLTIP "Valor da Taxa Administrativa" NO-UNDO.

DEFINE VARIABLE de-taxa-canc-devol AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Taxa Cancel/Devol" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 TOOLTIP "Valor da Taxa de Cancelamento/Devoluá∆o" NO-UNDO.

DEFINE VARIABLE de-taxa-prorrog AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Taxa Prorrogaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 TOOLTIP "Valor da Taxa de Prorrogaá∆o" NO-UNDO.

DEFINE VARIABLE de-val-limite-fin AS DECIMAL FORMAT "->>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Limite Final" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-limite-ini AS DECIMAL FORMAT "->>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Limite Inicial" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-classe AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Classe" 
     VIEW-AS FILL-IN 
     SIZE 6.29 BY .88 NO-UNDO.

DEFINE VARIABLE text-classes AS CHARACTER FORMAT "X(20)":U INITIAL "Classes do Cliente" 
      VIEW-AS TEXT 
     SIZE 12.72 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.86 BY 6.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.72 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY DEFAULT-FRAME FOR 
      int-classe-cli-supcard SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     i-cod-classe AT ROW 2.13 COL 19.72 COLON-ALIGNED HELP
          "C¢digo da Classe" WIDGET-ID 2
     c-des-classe AT ROW 2.13 COL 26.29 COLON-ALIGNED HELP
          "Descriá∆o da Classe" NO-LABEL WIDGET-ID 4
     de-val-limite-ini AT ROW 3.13 COL 19.72 COLON-ALIGNED HELP
          "Valor da faixa de Limite Inicial" WIDGET-ID 6
     de-val-limite-fin AT ROW 3.13 COL 55 COLON-ALIGNED HELP
          "Valor da faixa de Limite Final" WIDGET-ID 8
     btPesquisar AT ROW 4 COL 84.14
     de-taxa-adm AT ROW 4.13 COL 19.72 COLON-ALIGNED HELP
          "Valor da taxa administrativa" WIDGET-ID 36
     c-cod-cond-pag AT ROW 4.13 COL 55 COLON-ALIGNED HELP
          "C¢digos das Condiá‰es de Pagamento V†lidas por Classe Cliente"
     de-taxa-canc-devol AT ROW 5.13 COL 19.72 COLON-ALIGNED HELP
          "Valor da taxa de cancelamento/devoluá∆o" WIDGET-ID 38
     de-taxa-prorrog AT ROW 6.13 COL 19.72 COLON-ALIGNED HELP
          "Valor da taxa de prorrogaá∆o" WIDGET-ID 40
     btOK AT ROW 8.04 COL 2 WIDGET-ID 26
     btCancel AT ROW 8.04 COL 12.29 WIDGET-ID 22
     text-classes AT ROW 1.08 COL 39.57 NO-LABEL WIDGET-ID 12
     RECT-3 AT ROW 1.5 COL 2 WIDGET-ID 10
     rtToolBar AT ROW 7.79 COL 1 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.72 BY 8.25
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
         TITLE              = "Inclus∆o de Classe de Cliente"
         HEIGHT             = 8.25
         WIDTH              = 89.72
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 99.43
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 99.43
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
/* SETTINGS FOR FILL-IN c-cod-cond-pag IN FRAME DEFAULT-FRAME
   NO-ENABLE LIKE = mgesp.int-classe-cli-supcard.cod-cond-pag EXP-SIZE */
/* SETTINGS FOR FILL-IN i-cod-classe IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN text-classes IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _TblList          = "mgesp.int-classe-cli-supcard"
     _Query            is OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Inclus∆o de Classe de Cliente */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Inclus∆o de Classe de Cliente */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME DEFAULT-FRAME /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME DEFAULT-FRAME /* Salvar */
DO:
    RUN pi-salvar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "OK":U THEN DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPesquisar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPesquisar C-Win
ON CHOOSE OF btPesquisar IN FRAME DEFAULT-FRAME /* Pesquisar */
DO:
    RUN esp/acr/esacr036b1.w (INPUT {&WINDOW-NAME},
                              INPUT c-cod-cond-pag:HANDLE IN FRAME default-frame).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-des-classe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-des-classe C-Win
ON LEAVE OF c-des-classe IN FRAME DEFAULT-FRAME
DO:
    /* Busca o c¢digo da Classe. ê sequàncial */
    FIND LAST int-classe-cli-supcard NO-LOCK
        WHERE int-classe-cli-supcard.des-classe = INPUT FRAME default-frame c-des-classe NO-ERROR.
    IF  AVAIL int-classe-cli-supcard THEN
        ASSIGN i-cod-classe = int-classe-cli-supcard.cod-classe.
    ELSE DO:
        FIND LAST int-classe-cli-supcard NO-LOCK NO-ERROR.
        ASSIGN i-cod-classe = IF AVAIL int-classe-cli-supcard THEN int-classe-cli-supcard.cod-classe + 1 ELSE 1.
    END.

    DISP i-cod-classe WITH FRAME default-frame.
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
ON CLOSE OF THIS-PROCEDURE DO:
   RUN disable_UI.
   RUN afterDestroyInterface.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN beforeInitializeInterface.
    RUN enable_UI.
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface C-Win 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(p-window-parent) THEN
        ASSIGN p-window-parent:SENSITIVE = YES.

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
    IF VALID-HANDLE(p-window-parent) THEN
        ASSIGN p-window-parent:SENSITIVE = NO.

    FIND FIRST int-classe-cli-supcard NO-LOCK
        WHERE ROWID(int-classe-cli-supcard) = r-int-classe-cli-supcard NO-ERROR.
    IF  AVAIL  int-classe-cli-supcard THEN DO:
        ASSIGN i-cod-classe       = int-classe-cli-supcard.cod-classe
               c-des-classe       = int-classe-cli-supcard.des-classe
               de-val-limite-ini  = int-classe-cli-supcard.val-limite-ini
               de-val-limite-fin  = int-classe-cli-supcard.val-limite-fin
               de-taxa-adm        = int-classe-cli-supcard.val-taxa-adm
               de-taxa-canc-devol = int-classe-cli-supcard.val-taxa-canc-devol
               de-taxa-prorrog    = int-classe-cli-supcard.val-taxa-prorrog
               c-cod-cond-pag     = int-classe-cli-supcard.cod-cond-pag.
    END.

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

  {&OPEN-QUERY-DEFAULT-FRAME}
  GET FIRST DEFAULT-FRAME.
  DISPLAY i-cod-classe c-des-classe de-val-limite-ini de-val-limite-fin 
          de-taxa-adm c-cod-cond-pag de-taxa-canc-devol de-taxa-prorrog 
          text-classes 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-3 rtToolBar c-des-classe de-val-limite-ini de-val-limite-fin 
         btPesquisar de-taxa-adm de-taxa-canc-devol de-taxa-prorrog btOK 
         btCancel text-classes 
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

    ASSIGN INPUT FRAME default-frame i-cod-classe
           INPUT FRAME default-frame c-des-classe
           INPUT FRAME default-frame de-val-limite-ini
           INPUT FRAME default-frame de-val-limite-fin
           INPUT FRAME default-frame de-taxa-adm
           INPUT FRAME default-frame de-taxa-canc-devol
           INPUT FRAME default-frame de-taxa-prorrog
           INPUT FRAME default-frame c-cod-cond-pag.

    RUN pi-validar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "NOK" THEN
        RETURN "NOK":U.

    IF  c-seg-usuario = "" THEN
        ASSIGN c-usuario = v_cod_usuar_corren.
    ELSE
        ASSIGN c-usuario = c-seg-usuario.

    FIND LAST int-classe-cli-supcard NO-LOCK NO-ERROR.
    IF AVAIL int-classe-cli-supcard THEN
        ASSIGN i-seq = int-classe-cli-supcard.sequencia + 1.
    ELSE
        ASSIGN i-seq = 1.

    IF  i-cod-classe = 0 THEN DO:
        /* Busca o c¢digo da Classe. ê sequàncial */
        FIND LAST int-classe-cli-supcard NO-LOCK
            WHERE int-classe-cli-supcard.des-classe = INPUT FRAME default-frame c-des-classe NO-ERROR.
        IF  AVAIL int-classe-cli-supcard THEN
            ASSIGN i-cod-classe = int-classe-cli-supcard.cod-classe.
        ELSE DO:
            FIND LAST int-classe-cli-supcard NO-LOCK NO-ERROR.
            ASSIGN i-cod-classe = IF AVAIL int-classe-cli-supcard THEN int-classe-cli-supcard.cod-classe + 1 ELSE 1.
        END.
    END.

    /* Sempre cria um novo registro para poder ter um hist¢rico das alteraá‰es */
    CREATE int-classe-cli-supcard.
    ASSIGN int-classe-cli-supcard.sequencia           = i-seq
           int-classe-cli-supcard.dat-alteracao       = TODAY
           int-classe-cli-supcard.cod-usuar           = c-usuario
           int-classe-cli-supcard.cod-classe          = i-cod-classe
           int-classe-cli-supcard.des-classe          = c-des-classe
           int-classe-cli-supcard.val-limite-ini      = de-val-limite-ini
           int-classe-cli-supcard.val-limite-fin      = de-val-limite-fin
           int-classe-cli-supcard.val-taxa-adm        = de-taxa-adm
           int-classe-cli-supcard.val-taxa-canc-devol = de-taxa-canc-devol
           int-classe-cli-supcard.val-taxa-prorrog    = de-taxa-prorrog
           int-classe-cli-supcard.cod-cond-pag        = c-cod-cond-pag.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar C-Win 
PROCEDURE pi-validar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  i-cod-classe = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "C¢digo da Classe inv†lido!~~C¢digo da Classe deve ser diferente de 0 (zero).":U).
        RETURN "NOK":U.
    END.

    IF  c-des-classe = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 265,
                           INPUT "Descriá∆o da Classe":U).
        RETURN "NOK":U.
    END.

    IF  de-taxa-adm = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 265,
                           INPUT "Taxa Administrativa":U).
        RETURN "NOK":U.
    END.

    IF  de-taxa-canc-devol = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 265,
                           INPUT "Taxa Cancelamento/Devoluá∆o":U).
        RETURN "NOK":U.
    END.

    IF  de-taxa-prorrog = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 265,
                           INPUT "Taxa Prorrogaá∆o":U).
        RETURN "NOK":U.
    END.

    IF  de-val-limite-ini >= de-val-limite-fin THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Faixa de valores inv†lida!~~O valor Inicial deve ser menor que o valor Final.":U).
        RETURN "NOK":U.
    END.

    IF c-cod-cond-pag = "":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 265,
                           INPUT "Condiá∆o de Pagamento":U).

        RETURN "NOK":U.
    END.

    /*IF  CAN-FIND(FIRST  int-classe-cli-supcard NO-LOCK
                 WHERE (int-classe-cli-supcard.val-limite-ini <= de-val-limite-ini AND
                        int-classe-cli-supcard.val-limite-fin >= de-val-limite-ini)
                 OR    (int-classe-cli-supcard.val-limite-ini <= de-val-limite-fin AND
                        int-classe-cli-supcard.val-limite-fin >= de-val-limite-fin)) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Faixa de Limite inv†lida.~~Faixa de limite est† entre outra faixa de limite j† cadastrada.":U).
        RETURN "NOK":U.
    END.*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

