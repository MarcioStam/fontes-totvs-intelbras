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

{esp/es0018.i}

DEF TEMP-TABLE tt-etiqueta NO-UNDO
    FIELD seq-pallet    AS INT
    FIELD cod-pallet    AS CHAR
    FIELD seq-caixa     AS INT
    FIELD cod-caixa     AS CHAR
    FIELD seq-produto   AS INT
    FIELD cod-produto   AS CHAR.

DEF VAR c-anterior      AS CHAR     NO-UNDO.
DEF VAR c-caixa-atu     AS CHAR     NO-UNDO.
DEF VAR c-caixa         AS CHAR     NO-UNDO.
DEF VAR i-quant-cx      AS INT      NO-UNDO.
DEF VAR i-quant-pt      AS INT      NO-UNDO.
DEF VAR i-cont          AS INT      NO-UNDO.
DEF VAR i-contEtiq      AS INT      NO-UNDO.
DEF VAR l-erro          AS LOG      NO-UNDO.
DEF VAR c-acao          AS CHAR     NO-UNDO.
DEF VAR l-ok            AS LOG      NO-UNDO.
DEF VAR l-reincorpora   AS LOG      NO-UNDO. 

DEFINE VARIABLE v-it-codigo LIKE item.it-codigo NO-UNDO.

DEF BUFFER b-ns-volume FOR ns-volume.
   
DEFINE TEMP-TABLE tt-consulta-etiqueta NO-UNDO
    FIELD volume-pai   LIKE ns-volume.volume-pai
    FIELD volume-filho LIKE ns-volume.volume-filho.

DEFINE NEW GLOBAL SHARED VARIABLE g-escpp002-etiqueta AS CHAR NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar AS CHARACTER NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-seg-usuario     AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-dun-14 AS CHARACTER FORMAT "x(14)"  NO-UNDO.

DEFINE VARIABLE i-aux    AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-celula AS CHARACTER   NO-UNDO.

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
&Scoped-define FIELDS-IN-QUERY-br-etiqueta tt-etiqueta.cod-pallet tt-etiqueta.cod-caixa tt-etiqueta.cod-produto   
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
&Scoped-Define ENABLED-OBJECTS btRetrabalho br-etiqueta btExit btHelp btAdd ~
btCancel btRelatorio RECT-17 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS i-qt-it-cx fi-aviso c-etiqueta 

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
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-E"
       MENU-ITEM miCancela      LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       MENU-ITEM miRetrabalho   LABEL "&Retrabalhar"   ACCELERATOR "CTRL-HOME"
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre"        .

DEFINE MENU MbMain MENUBAR
       SUB-MENU  m_Arquivo      LABEL "&Arquivo"      
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\ii-can":U
     LABEL "Cancela" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE BUTTON btRelatorio 
     IMAGE-UP FILE "image/excel.bmp":U
     IMAGE-INSENSITIVE FILE "image/excel.bmp":U
     LABEL "Relatorio" 
     SIZE 4 BY 1.25 TOOLTIP "Relatorio"
     FONT 4.

DEFINE BUTTON btRetrabalho 
     IMAGE-UP FILE "image/im-lay.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-lay.bmp":U
     LABEL "Retrabalho" 
     SIZE 4 BY 1.25 TOOLTIP "Retrabalho"
     FONT 4.

DEFINE VARIABLE c-etiqueta AS CHARACTER FORMAT "X(20)":U 
     LABEL "Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-aviso AS CHARACTER FORMAT "X(256)":U INITIAL "* * * * DESVINCULAÄ«O * * * *" 
      VIEW-AS TEXT 
     SIZE 14.72 BY .67
     FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE i-qt-it-cx AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Qtd Item Caixa" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

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
      tt-etiqueta.cod-pallet   COLUMN-LABEL "Pallet"   FORMAT "x(30)"
    tt-etiqueta.cod-caixa    COLUMN-LABEL "Caixa"    FORMAT "x(30)"
    tt-etiqueta.cod-produto  COLUMN-LABEL "Produto"  FORMAT "x(30)" WIDTH 20
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 12.25
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btRetrabalho AT ROW 1.13 COL 40.72 HELP
          "Reimpress∆o" WIDGET-ID 30
     i-qt-it-cx AT ROW 3.08 COL 52.72 COLON-ALIGNED HELP
          "Qtd Item Caixa"
     fi-aviso AT ROW 3.08 COL 62.14 COLON-ALIGNED NO-LABEL
     c-etiqueta AT ROW 3.08 COL 13.57 COLON-ALIGNED HELP
          "Registre a Etiqueta" AUTO-RETURN 
     br-etiqueta AT ROW 4.5 COL 1
     btExit AT ROW 1.17 COL 82.43 HELP
          "Sair"
     btHelp AT ROW 1.17 COL 86.43 HELP
          "Ajuda"
     btAdd AT ROW 1.17 COL 2 HELP
          "Inclui nova ocorrància"
     btCancel AT ROW 1.17 COL 13.86 HELP
          "Elimina ocorrància corrente"
     btRelatorio AT ROW 1.13 COL 49 HELP
          "Reimpress∆o" WIDGET-ID 32
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
         TITLE              = "ESCPP002.W - 2.04.001 - Relacionamento Pallet X Caixa X Produto"
         HEIGHT             = 15.79
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
/* SETTINGS FOR FILL-IN c-etiqueta IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-aviso IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       fi-aviso:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN i-qt-it-cx IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
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
ON END-ERROR OF C-Win /* ESCPP002.W - 2.04.001 - Relacionamento Pallet X Caixa X Produto */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* ESCPP002.W - 2.04.001 - Relacionamento Pallet X Caixa X Produto */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd C-Win
ON CHOOSE OF btAdd IN FRAME DEFAULT-FRAME /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:

    ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "Caixa".

    DISABLE btAdd 
            btRetrabalho
            WITH FRAME {&FRAME-NAME}.
    ENABLE c-etiqueta 
           
           WITH FRAME {&FRAME-NAME}. 
    ASSIGN fi-aviso:HIDDEN = YES
           btCancel:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

    EMPTY TEMP-TABLE tt-etiqueta.        

    EMPTY TEMP-TABLE tt-consulta-etiqueta.

    ASSIGN c-anterior = ""
           c-acao     = "Inclui"
           c-dun-14   = "".

    {&OPEN-QUERY-{&BROWSE-NAME}}

    APPLY "entry" TO c-etiqueta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME DEFAULT-FRAME /* Cancela */
OR CHOOSE OF MENU-ITEM miCancela IN MENU mbMain DO:

    IF c-acao = "Retrabalho" THEN DO:

        FOR EACH tt-consulta-etiqueta.

            IF NOT CAN-FIND(FIRST tt-etiqueta
                            WHERE tt-etiqueta.cod-produto = tt-consulta-etiqueta.volume-filho) THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17242,
                                   INPUT "Existem etiquetas que n∆o foram verificadas ~~ o Processo de verificaá∆o ser† cancelado.").
                ASSIGN l-erro = YES.
                LEAVE.
            END.
        END.
    END.

    ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "Etiqueta".

    ASSIGN i-qt-it-cx = 0
           c-etiqueta = "":U.

    
    DISPLAY i-qt-it-cx
            c-etiqueta
            
        WITH FRAME {&FRAME-NAME}.

    ENABLE btAdd 
           
           btRetrabalho
           WITH FRAME {&FRAME-NAME}.
    DISABLE c-etiqueta 
            
            WITH FRAME {&FRAME-NAME}. 

    ASSIGN fi-aviso:HIDDEN = YES
           btCancel:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    EMPTY TEMP-TABLE tt-etiqueta.

    EMPTY TEMP-TABLE tt-consulta-etiqueta.

    ASSIGN c-anterior = "".

    {&OPEN-QUERY-{&BROWSE-NAME}}    
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


&Scoped-define SELF-NAME btRelatorio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRelatorio C-Win
ON CHOOSE OF btRelatorio IN FRAME DEFAULT-FRAME /* Relatorio */
DO:
    RUN esp/cpp/escpp002a.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRetrabalho
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRetrabalho C-Win
ON CHOOSE OF btRetrabalho IN FRAME DEFAULT-FRAME /* Retrabalho */
OR CHOOSE OF MENU-ITEM miRetrabalho in MENU mbMain DO:
      
    ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "N£mero de SÇrie".

    DISABLE btAdd 
            
            btRetrabalho
            WITH FRAME {&FRAME-NAME}.

    ENABLE c-etiqueta 
           WITH FRAME {&FRAME-NAME}. 

    ASSIGN fi-aviso:HIDDEN = YES
           btCancel:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

    EMPTY TEMP-TABLE tt-etiqueta.        

    EMPTY TEMP-TABLE tt-consulta-etiqueta.

    ASSIGN c-anterior = ""
           c-acao     = "Retrabalho".

    {&OPEN-QUERY-{&BROWSE-NAME}}

    APPLY "entry" TO c-etiqueta.

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 15825,
                       INPUT "Bipe as etiquetas dos produtos(NS)").   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-etiqueta C-Win
ON RETURN OF c-etiqueta IN FRAME DEFAULT-FRAME /* Etiqueta */
DO: 
    ASSIGN INPUT FRAME {&FRAME-NAME} c-etiqueta .  

    RUN pi-valida-etiqueta.
    IF RETURN-VALUE = "NOK" THEN
        RETURN NO-APPLY.
  
    /***************************** Inicia processamento dos botoes *******************************/
    IF  c-acao = "Inclui" THEN DO:

        RUN pi-acao-inclui.

        IF RETURN-VALUE = "NOK" THEN
            RETURN NO-APPLY.

    END.
    ELSE IF c-acao = "Delete" THEN DO:
        
        RUN pi-acao-delete.
        IF RETURN-VALUE = "NOK" THEN
            RETURN NO-APPLY.
    END.
    ELSE IF c-acao = "Retrabalho" THEN DO:
        RUN pi-acao-retrabalho.
        IF RETURN-VALUE = "NOK" THEN DO:

            ASSIGN l-erro = YES.

            RETURN NO-APPLY.
        END.
    END.

   

    {&OPEN-QUERY-{&BROWSE-NAME}}

    ASSIGN c-etiqueta:SCREEN-VALUE = "".

   
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
  ASSIGN fi-aviso:HIDDEN = YES
         btCancel:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
         c-anterior = "".
    
  {&OPEN-QUERY-{&BROWSE-NAME}}

  
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscar-etiqueta-caixa C-Win 
PROCEDURE buscar-etiqueta-caixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAM p-etiqueta AS CHAR NO-UNDO.

FOR FIRST tt-etiqueta.

    ASSIGN p-etiqueta = tt-etiqueta.cod-caixa.    
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
  DISPLAY i-qt-it-cx fi-aviso c-etiqueta 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE btRetrabalho br-etiqueta btExit btHelp btAdd btCancel btRelatorio 
         RECT-17 rtToolBar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-acao-delete C-Win 
PROCEDURE pi-acao-delete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST ns-volume NO-LOCK
         WHERE ns-volume.volume-pai = c-etiqueta NO-ERROR.                         
    IF NOT AVAIL ns-volume THEN DO:
       FIND FIRST ns-volume WHERE ns-volume.volume-filho = c-etiqueta
                            NO-LOCK NO-ERROR.
       IF NOT AVAIL ns-volume THEN DO:
           MESSAGE "Etiqueta nao registrada para ser desvinculada."
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
           RETURN "NOK".
       END.
    END.
    IF SUBSTRING(c-etiqueta,1,3) = "EPA" THEN DO:
       IF ns-volume.nr-nota-fis <> "" THEN DO:
           MESSAGE "Pallet relacionado a Nota Fiscal. Imposs°vel desvincular caixas deste pallet."
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
           RETURN "NOK".
       END.
       MESSAGE "Deseja realmente desvincular todas as caixas deste Pallet?" 
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-ok.
       IF NOT l-ok THEN DO:
          ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
          RETURN "NOK".
       END.
       FOR EACH ns-volume WHERE ns-volume.volume-pai = c-etiqueta:
          DELETE ns-volume.
       END.
    END.
    ELSE IF SUBSTRING(c-etiqueta,1,3) = "ECO" THEN DO:
       FIND FIRST ns-volume WHERE ns-volume.volume-pai = c-etiqueta
                            NO-LOCK NO-ERROR.
       IF ns-volume.nr-nota-fis <> "" THEN DO:
           MESSAGE "Caixa relacionada a Nota Fiscal. Imposs°vel desvincular esta caixa."
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
           RETURN "NOK".
       END.
       MESSAGE "Deseja realmente desvincular esta caixa do Pallet?" 
               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-ok.
       IF NOT l-ok THEN DO:
          ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
          RETURN "NOK".
       END.
       FOR EACH ns-volume WHERE ns-volume.volume-filho = c-etiqueta:
           DELETE ns-volume.
       END.
    END.
    ELSE DO:
        
       FIND FIRST ns-volume WHERE ns-volume.volume-filho = c-etiqueta
                            NO-LOCK NO-ERROR.
       IF ns-volume.nr-nota-fis <> "" THEN DO:
           MESSAGE "Produto relacionado a Nota Fiscal. Imposs°vel desvincular produtos de uma caixa."
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
           ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
           RETURN "NOK".
       END.
       MESSAGE "Deseja realmente desvincular este produto da Caixa?" 
               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-ok.
       IF NOT l-ok THEN DO:
          ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
          RETURN "NOK".
       END.
       
       FIND FIRST ns-volume WHERE ns-volume.volume-filho = c-etiqueta NO-LOCK.
       ASSIGN c-caixa = ns-volume.volume-pai.
      
       FOR EACH ns-volume WHERE ns-volume.volume-pai = c-caixa:
           ASSIGN ns-volume.volume-pai = "ECO-INDEFINIDA".
       END.
       FOR EACH ns-volume WHERE ns-volume.volume-filho = c-caixa:
           DELETE ns-volume.
       END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-acao-inclui C-Win 
PROCEDURE pi-acao-inclui :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    
    
    ASSIGN INPUT FRAME {&FRAME-NAME} c-etiqueta.  

    FIND FIRST tt-etiqueta
         WHERE tt-etiqueta.cod-produto = c-etiqueta
         OR    tt-etiqueta.cod-caixa   = c-etiqueta NO-ERROR.
    IF AVAIL tt-etiqueta THEN DO:
        MESSAGE "Etiqueta j† registrada"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
        RETURN "NOK".
    END.
    
    FIND FIRST ns-volume 
         WHERE ns-volume.volume-filho = c-etiqueta NO-LOCK NO-ERROR.
    IF AVAIL ns-volume THEN DO:
       IF ns-volume.volume-pai = "ECO-INDEFINIDA" THEN DO:
          MESSAGE "Etiqueta de produto j† registrada em caixa desmantelada."
                  "Imposs°vel relacionar a outra caixa."
                  VIEW-AS ALERT-BOX INFO BUTTONS OK.
          ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
          RETURN "NOK".
       END.
       ELSE DO:
           MESSAGE "Etiqueta cadastrada e com relacionamento."
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
           ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
           RETURN "NOK".
       END.
    END.
    ELSE DO:
        FIND FIRST ns-volume WHERE ns-volume.volume-pai = c-etiqueta NO-LOCK NO-ERROR.
        IF AVAIL ns-volume THEN DO:
           IF SUBSTRING(c-etiqueta,1,3) = "ECO" THEN DO:
              ASSIGN l-reincorpora = YES.
           END.
        END.
    END.
    
    IF c-anterior = "" THEN DO:

        IF SUBSTRING(c-etiqueta,1,3) <> "ECO" THEN DO:
            MESSAGE "Primeiro registro incluido deve ser uma CAIXA"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
            RETURN "NOK".
        END.

        /* Verifica Estabelecimento que imprimiu etiqueta Caixa */
        FIND FIRST ns-volume-estab
             WHERE ns-volume-estab.volume-pai  = c-etiqueta
        NO-LOCK NO-ERROR.

        IF NOT AVAIL ns-volume-estab THEN DO:
           MESSAGE 'Etiqueta CAIXA ainda nao foi impressa' SKIP(1)
                   'Utilizar o programa ESCPP003 para impressao da etiqueta CAIXA'
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.

           ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
           RETURN "NOK".
        END.
 
        IF ns-volume-estab.cod-estabel <> v_cod_estab_usuar  THEN DO:
           MESSAGE 'Etiqueta CAIXA foi impressa para o estabelecimento ' + ns-volume-estab.cod-estabel SKIP(1)
                   'Estabelecimento ' + v_cod_estab_usuar + ' nao pode utilizar esta etiqueta CAIXA'
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.

           ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
           RETURN "NOK".
        END.
        /**/

        CREATE tt-etiqueta.
        ASSIGN tt-etiqueta.cod-CAIXA = c-etiqueta.
    
        ASSIGN c-anterior  = "C"
               c-CAIXA-atu = c-etiqueta
               i-quant-cx  = INT(SUBSTRING(c-etiqueta,4,3))
               i-qt-it-cx  = i-quant-cx.
    
        ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "N£mero de SÇrie".
    
        DISPLAY i-qt-it-cx
            WITH FRAME {&FRAME-NAME}.

    END.
    ELSE DO:
        
        CASE SUBSTRING(c-etiqueta,1,3):
            WHEN "ECO" THEN DO:
                IF c-anterior = "C" THEN DO:
                    MESSAGE "CAIXA Inv†lida. Vocà deve cadastrar os produtos para a CAIXA previamente cadastrada."
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                    RETURN "NOK".
                END.
                ELSE 
                IF c-anterior = "E" THEN DO:
                    MESSAGE "CAIXA Inv†lida. Vocà deve cadastrar o Cod.Barras DUN14 do item ap¢s a inclus∆o dos produtos."
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                    RETURN "NOK".
                END.
                IF c-anterior = "DUN" THEN DO:
                    MESSAGE "CAIXA Inv†lida. Vocà deve cadastrar um PALLET ap¢s a inclus∆o do Cod.Barras DUN14."
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                    RETURN "NOK".
                END.
    
                CREATE tt-etiqueta.
                ASSIGN tt-etiqueta.cod-CAIXA = c-etiqueta.
    
                ASSIGN c-anterior  = "C"
                       c-CAIXA-atu = c-etiqueta
                       i-quant-cx  = INT(SUBSTRING(c-etiqueta,4,3)).
    
                ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "N£mero de SÇrie".
    
            END.
            WHEN "EPA" THEN DO:
                CASE c-anterior:
                    WHEN "C" THEN DO:
                        IF l-reincorpora = NO THEN DO:
                            MESSAGE "PALLET Inv†lido. Vocà deve cadastrar os produtos para a CAIXA previamente cadastrada."
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                            ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                            RETURN "NOK".
                        END.
                    END.
                    WHEN "P" THEN DO:
                        MESSAGE "PALLET Inv†lido. Vocà deve cadastrar uma nova CAIXA ou salvar os registros."
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                        RETURN "NOK".
                    END.
                    WHEN "E" THEN DO:
                        MESSAGE "PALLET Inv†lido. Vocà deve cadastrar o Cod.Barras DUN14 do item ap¢s a inclus∆o dos PRODUTOS."
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                        RETURN "NOK".
                    END.
                END CASE.
    
                ASSIGN i-quant-pt = INT(SUBSTRING(c-etiqueta,4,3))
                       i-cont     = 1.
    
                FOR EACH ns-volume
                    WHERE ns-volume.volume-pai = c-etiqueta:
                      ASSIGN i-cont = i-cont + 1.
                END.
    
                IF i-cont > i-quant-pt THEN DO:
                    MESSAGE "PALLET Inv†lido. Quantidade de CAIXAS excede o permitido para o PALLET."
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                    RETURN "NOK".
                END.


                /* Verifica Estabelecimento que imprimiu etiqueta Pallet */
                FIND FIRST ns-volume-estab
                     WHERE ns-volume-estab.volume-pai  = c-etiqueta
                NO-LOCK NO-ERROR.
                
                IF NOT AVAIL ns-volume-estab THEN DO:
                   MESSAGE 'Etiqueta PALLET ainda nao foi impressa' SKIP(1)
                           'Utilizar o programa ESCPP003 para impressao da etiqueta PALLET'
                       VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                
                   ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                   RETURN "NOK".
                END.
                
                IF ns-volume-estab.cod-estabel <> v_cod_estab_usuar  THEN DO:
                   MESSAGE 'Etiqueta PALLET foi impressa para o estabelecimento ' + ns-volume-estab.cod-estabel SKIP(1)
                           'Estabelecimento ' + v_cod_estab_usuar + ' nao pode utilizar esta etiqueta PALLET'
                       VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                
                   ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                   RETURN "NOK".
                END.
                /**/

                
                FOR EACH tt-etiqueta
                    WHERE tt-etiqueta.cod-PALLET = "":
                    ASSIGN tt-etiqueta.cod-PALLET = c-etiqueta.
                END.
    
                ASSIGN c-anterior = "P".
    
                ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "Caixa".
    
                RUN pi-grava-registro.
    
                ASSIGN i-qt-it-cx = 0.
    
                DISPLAY i-qt-it-cx
                    WITH FRAME {&FRAME-NAME}.
            END.
            OTHERWISE DO:
                CASE c-anterior:
                    WHEN "P" THEN DO:
                        MESSAGE "Produto Inv†lido. Vocà deve cadastrar uma CAIXA ou salvar os registros."
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                        RETURN "NOK".
                    END.
                    WHEN "C" THEN DO:
                        FIND FIRST ns-volume WHERE ns-volume.volume-pai = c-CAIXA-atu  NO-LOCK NO-ERROR.

                        //IF l-reincorpora THEN DO:
                        IF AVAIL ns-volume AND SUBSTRING(c-CAIXA-atu,1,3) = "ECO" THEN DO:
                            MESSAGE "Caixa sendo reincorporada. N∆o se pode relacionar produto." SKIP 
                                    "SN Lido: " c-etiqueta
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                            ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                            RETURN "NOK".
                        END.
                        FIND tt-etiqueta
                            WHERE tt-etiqueta.cod-CAIXA = c-CAIXA-atu NO-ERROR.
                        IF AVAIL tt-etiqueta THEN DO:
    
                            FIND FIRST num-serie
                                WHERE num-serie.n-serie = c-etiqueta NO-LOCK NO-ERROR.
    
                            IF NOT AVAILABLE num-serie THEN DO:
                                MESSAGE "Etiqueta n∆o cadastrada para um produto":U
                                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                                ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                                RETURN "NOK".
                            END.
    
                            ASSIGN tt-etiqueta.cod-produto = c-etiqueta
                                   v-it-codigo             = num-serie.it-codigo.
                        END.
    
                        ASSIGN c-anterior = "E".
                    END.
                    WHEN "E" THEN DO:
    
                        ASSIGN i-cont = 0.
                        FOR EACH tt-etiqueta
                            WHERE tt-etiqueta.cod-CAIXA    = c-CAIXA-atu
                            AND   tt-etiqueta.cod-produto <> "":
                            ASSIGN i-cont = i-cont + 1.
                        END.
    
                        IF (i-cont + 1) > i-quant-cx THEN DO:
    
                            FIND FIRST item-dun
                                WHERE item-dun.cod-dun = c-etiqueta NO-LOCK NO-ERROR.
    
                            IF AVAILABLE item-dun THEN DO:
    
                                FIND FIRST tt-etiqueta
                                    WHERE tt-etiqueta.cod-CAIXA = c-CAIXA-atu NO-ERROR.
    
                                IF AVAIL tt-etiqueta THEN DO:
    
                                    FIND FIRST num-serie
                                        WHERE num-serie.n-serie = tt-etiqueta.cod-produto NO-LOCK NO-ERROR.
    
                                    IF (AVAILABLE num-serie                        AND
                                        num-serie.it-codigo <> item-dun.it-codigo) OR
                                        NOT AVAILABLE num-serie                    THEN DO:
                                        MESSAGE "N£mero DUN14 n∆o corresponde ao item inserido na CAIXA."
                                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                        ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                                        RETURN "NOK".
                                    END.
                                    ELSE
                                        ASSIGN c-anterior  = "DUN"
                                               v-it-codigo = "":U
                                               c-dun-14    = c-etiqueta.
                                END.
                            END.
                            ELSE DO:
                                MESSAGE "Produto Inv†lido. Quantidade de produtos excede o permitido para a CAIXA."
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                                RETURN "NOK".
                            END.
                        END.
                        ELSE DO:
                            IF v-it-codigo = "":U THEN DO:
                                FIND FIRST num-serie
                                    WHERE num-serie.n-serie = c-etiqueta NO-LOCK NO-ERROR.
    
                                IF NOT AVAILABLE num-serie THEN DO:
                                    MESSAGE "Etiqueta n∆o cadastrada para um produto":U
                                        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                                    ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                                           i-cont = i-cont - 1.
                                    RETURN "NOK".
                                END.
    
                                ASSIGN v-it-codigo = num-serie.it-codigo.
                            END.
                            ELSE DO:
                                FIND FIRST num-serie
                                    WHERE num-serie.n-serie = c-etiqueta NO-LOCK NO-ERROR.
    
                                IF NOT AVAILABLE num-serie THEN DO:
                                    MESSAGE "Etiqueta n∆o cadastrada para um produto":U
                                        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                                    ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                                           i-cont = i-cont - 1.
                                    RETURN "NOK".
                                END.
    
                                IF num-serie.it-codigo <> v-it-codigo THEN DO:
                                    MESSAGE "Produto diferente do cadastrado anteriormente":U
                                        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                                    ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                                           i-cont = i-cont - 1.
                                    RETURN "NOK".
                                END.
                            END.
    
                            CREATE tt-etiqueta.
                            ASSIGN tt-etiqueta.cod-CAIXA   = c-CAIXA-atu
                                   tt-etiqueta.cod-produto = c-etiqueta.
    
                            ASSIGN c-anterior = "E".
                        END.
                    END.
                    WHEN "DUN" THEN DO:
                         MESSAGE "Pallet Inv†lido. Vocà deve agora ler o Pallet."
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                        RETURN "NOK".
                    END.
                END CASE.
    
                ASSIGN i-cont = 0.
    
                FOR EACH tt-etiqueta
                    WHERE tt-etiqueta.cod-CAIXA    = c-CAIXA-atu
                    AND   tt-etiqueta.cod-produto <> "":
                    ASSIGN i-cont = i-cont + 1.
                END.
    
                IF i-cont = i-quant-cx THEN DO:
    
                    IF c-anterior = "DUN" THEN
                        ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "Pallet".
                    ELSE 
                        ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "DUN14".
    
                END.
    
            END.
        END CASE.

        
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-acao-retrabalho C-Win 
PROCEDURE pi-acao-retrabalho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST tt-etiqueta
         WHERE tt-etiqueta.cod-produto   = c-etiqueta NO-ERROR.
    IF AVAIL tt-etiqueta THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17242,
                           INPUT "Etiqueta j† verificada").

        ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
        RETURN "NOK".
    END.    

    FIND FIRST ns-volume NO-LOCK
         WHERE ns-volume.volume-filho = c-etiqueta NO-ERROR.
    IF NOT AVAIL ns-volume THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17242,
                           INPUT "Numero de serie n∆o vinculado em nenhuma caixa").
        RETURN "NOK".
    END.
    
    IF NOT CAN-FIND(FIRST num-serie
                    WHERE num-serie.n-serie = c-etiqueta) THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17242,
                           INPUT "N£mero de sÇrie inv†lido.").
        RETURN "NOK".
    END.   

    IF NOT CAN-FIND(FIRST tt-consulta-etiqueta) THEN DO:
   
        FOR EACH  b-ns-volume NO-LOCK
            WHERE b-ns-volume.volume-pai = ns-volume.volume-pai.
        
            CREATE tt-consulta-etiqueta.
            ASSIGN tt-consulta-etiqueta.volume-pai   = b-ns-volume.volume-pai
                   tt-consulta-etiqueta.volume-filho = b-ns-volume.volume-filho.
        END.
    END.

    FIND FIRST tt-consulta-etiqueta
         WHERE tt-consulta-etiqueta.volume-pai = ns-volume.volume-pai NO-ERROR.
    IF NOT AVAIL tt-consulta-etiqueta THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 27100,
                           INPUT "Esse NS n∆o condiz a mesma etiqueta ECO ~~ Por favor bipar o NS pertencente a mesma caixa ECO. Deseja continuar o processo desconsiderando esta NS ?").
        IF RETURN-VALUE = "No" THEN DO:
            APPLY 'choose' TO btCancel IN FRAME {&FRAME-NAME}.
            RETURN "NOK".
        END.
    END.
    ELSE DO:

        CREATE tt-etiqueta.
        ASSIGN tt-etiqueta.cod-caixa   = ns-volume.volume-pai
               tt-etiqueta.cod-produto = c-etiqueta.
        
        FIND FIRST b-ns-volume NO-LOCK
             WHERE b-ns-volume.volume-filho = ns-volume.volume-pai NO-ERROR.
        IF AVAIL b-ns-volume THEN
            ASSIGN tt-etiqueta.cod-pallet = b-ns-volume.volume-pai.        

        FOR EACH tt-consulta-etiqueta.

            IF NOT CAN-FIND(FIRST tt-etiqueta
                            WHERE tt-etiqueta.cod-produto = tt-consulta-etiqueta.volume-filho) THEN DO:
                /*RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17242,
                                   INPUT "Existem etiquetas que n∆o foram verificadas ~~ o Processo de verificaá∆o ser† cancelado.").*/
                ASSIGN l-erro = YES.
                LEAVE.
            END.
        END.        
        
        IF NOT l-erro THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 15825,
                               INPUT "Todos os Produtos(NS) foram verificados com sucesso!").
        
            DO ON ERROR UNDO, LEAVE:
                ASSIGN g-escpp002-etiqueta = "".
        
                RUN buscar-etiqueta-caixa (OUTPUT g-escpp002-etiqueta).
        
                RUN esp/cpp/escpp003a.w (INPUT CURRENT-WINDOW:HANDLE).
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-registro C-Win 
PROCEDURE pi-grava-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{&OPEN-QUERY-{&BROWSE-NAME}}


FIND FIRST tt-etiqueta.
FIND LAST b-ns-volume NO-LOCK
    WHERE b-ns-volume.volume-pai = tt-etiqueta.cod-pallet NO-ERROR.
IF NOT AVAIL b-ns-volume THEN DO:
    CREATE ns-volume.
    ASSIGN ns-volume.volume-pai   = tt-etiqueta.cod-pallet
           ns-volume.volume-filho = tt-etiqueta.cod-caixa
           ns-volume.sequencia    = 1.

    FIND FIRST ns-volume-estab EXCLUSIVE-LOCK 
         WHERE ns-volume-estab.volume-pai = tt-etiqueta.cod-caixa
    NO-ERROR.

    IF AVAIL ns-volume-estab THEN
       IF ns-volume-estab.usuario-vincula = '' THEN
          ASSIGN ns-volume-estab.usuario-vincula  = c-seg-usuario
                 ns-volume-estab.data-vincula = NOW. 

    RELEASE ns-volume-estab.
END.
ELSE DO:
    CREATE ns-volume.
    ASSIGN ns-volume.volume-pai   = tt-etiqueta.cod-pallet
           ns-volume.volume-filho = tt-etiqueta.cod-caixa
           ns-volume.sequencia    = b-ns-volume.sequencia + 1.

    FIND FIRST ns-volume-estab EXCLUSIVE-LOCK 
         WHERE ns-volume-estab.volume-pai = tt-etiqueta.cod-caixa
    NO-ERROR.

    IF AVAIL ns-volume-estab THEN
       IF ns-volume-estab.usuario-vincula = '' THEN
          ASSIGN ns-volume-estab.usuario-vincula  = c-seg-usuario
                 ns-volume-estab.data-vincula = NOW.       

    RELEASE ns-volume-estab.
END.

IF NOT CAN-FIND(FIRST ns-volume-prod
                WHERE ns-volume-prod.volume-pai   = tt-etiqueta.cod-pallet
                  AND ns-volume-prod.sequencia    = 1
                  AND ns-volume-prod.volume-filho = tt-etiqueta.cod-caixa) THEN DO:

    CREATE ns-volume-prod.
    ASSIGN ns-volume-prod.volume-pai    = tt-etiqueta.cod-pallet
           ns-volume-prod.sequencia     = 1
           ns-volume-prod.volume-filho  = tt-etiqueta.cod-caixa
           ns-volume-prod.datahora      = NOW
           ns-volume-prod.cod-usuario   = c-seg-usuario
           ns-volume-prod.dun-14        = c-dun-14
           ns-volume-prod.cd-recid      = RECID(ns-volume).           

    FIND FIRST num-serie NO-LOCK
         WHERE num-serie.n-serie = tt-etiqueta.cod-produto NO-ERROR.
    IF AVAIL num-serie THEN
        ASSIGN ns-volume-prod.it-codigo = num-serie.it-codigo.
END.

ASSIGN i-cont = 1.

FOR EACH tt-etiqueta WHERE tt-etiqueta.cod-produto <> "":
    CREATE ns-volume.
    ASSIGN ns-volume.volume-pai   = tt-etiqueta.cod-caixa
           ns-volume.volume-filho = tt-etiqueta.cod-produto
           ns-volume.sequencia    = i-cont
           i-cont                 = i-cont + 1.

    IF NOT CAN-FIND(FIRST ns-volume-prod
                    WHERE ns-volume-prod.volume-pai   = tt-etiqueta.cod-caixa
                      AND ns-volume-prod.sequencia    = i-cont
                      AND ns-volume-prod.volume-filho = tt-etiqueta.cod-produto) THEN DO:

        CREATE ns-volume-prod.
        ASSIGN ns-volume-prod.volume-pai    = tt-etiqueta.cod-caixa
               ns-volume-prod.sequencia     = ns-volume.sequencia
               ns-volume-prod.volume-filho  = tt-etiqueta.cod-produto
               ns-volume-prod.datahora      = NOW
               ns-volume-prod.cod-usuario   = c-seg-usuario
               ns-volume-prod.dun-14        = c-dun-14
               ns-volume-prod.cd-recid      = RECID(ns-volume).

        FIND FIRST num-serie NO-LOCK
             WHERE num-serie.n-serie = tt-etiqueta.cod-produto NO-ERROR.
        IF AVAIL num-serie THEN
            ASSIGN ns-volume-prod.it-codigo = num-serie.it-codigo.

    END.
END.

FOR EACH tt-etiqueta:
    DELETE tt-etiqueta.
END.

ASSIGN c-anterior = ""
       l-reincorpora = NO.

{&OPEN-QUERY-{&BROWSE-NAME}}

APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-etiqueta C-Win 
PROCEDURE pi-valida-etiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN l-erro = NO.

    IF  SUBSTRING(c-etiqueta,1,3) <> "ECO" 
    AND SUBSTRING(c-etiqueta,1,3) <> "EPA" 
    AND (ASC(SUBSTRING(c-etiqueta, 1, 1)) < 48
     OR  ASC(SUBSTRING(c-etiqueta, 1, 1)) > 57)
    AND (ASC(SUBSTRING(c-etiqueta, 2, 1)) < 48
     OR  ASC(SUBSTRING(c-etiqueta, 2, 1)) > 57) THEN DO: /* caso seja etiqueta de produto - Numero de SÇrie */
    
        IF length(c-etiqueta) = 15 THEN DO:
            FIND imei-prod WHERE imei-prod.cod-imei = c-etiqueta NO-LOCK NO-ERROR.
            IF NOT AVAIL imei-prod THEN DO:
                MESSAGE "Esta etiqueta n∆o foi gerada"   /* anteriormente */
                  VIEW-AS ALERT-BOX INFO BUTTONS OK.
                ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                RETURN "NOK".   
            END.
        END.
        ELSE DO:
    
            IF length(c-etiqueta) > 13 THEN 
               ASSIGN l-erro = YES.                     /* tamanho m†ximo = 13 */
    
            DO i-contEtiq = 5 TO LENGTH(c-etiqueta) - 2:
               IF l-erro = YES THEN LEAVE.
               IF asc(SUBSTRING(c-etiqueta,i-contEtiq,1)) < 48 
               AND asc(SUBSTRING(c-etiqueta,i-contEtiq,1)) > 57 THEN      
                   ASSIGN l-erro = YES.                                               /** s¢ pode ter numeros **/
            END.
    
            IF l-erro = YES THEN DO:
               MESSAGE "Dado informado n∆o corresponde a etiqueta"
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
               ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
               RETURN "NOK".
            END.
    
            FOR FIRST num-serie NO-LOCK
                WHERE num-serie.n-serie = c-etiqueta:
            END.   
    
            IF NOT AVAIL num-serie THEN DO:                                    /* Etiqueta deve ter sido gerada */
               MESSAGE "Esta etiqueta n∆o foi gerada."                          /* anteriormente */
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
               ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
               RETURN "NOK".
            END.
    
        END.
    
    END.
    ELSE DO:
        ASSIGN l-erro = NO.
    
        DO i-contEtiq = 4 TO LENGTH(c-etiqueta):
            IF asc(SUBSTRING(c-etiqueta,i-contEtiq,1)) < 48 
            AND asc(SUBSTRING(c-etiqueta,i-contEtiq,1)) > 57 THEN DO:     
                ASSIGN l-erro = YES.                                        /** s¢ pode ter numeros **/
                LEAVE.
            END.
        END.
        IF l-erro = YES THEN DO:
            MESSAGE "Dado informado n∆o corresponde a etiqueta"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
            RETURN "NOK".
        END.
    END.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

