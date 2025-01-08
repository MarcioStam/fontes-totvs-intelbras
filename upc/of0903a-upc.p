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
DEFINE NEW GLOBAL SHARED VAR c-seg-usuario AS CHARACTER NO-UNDO.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-linha       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-linha       AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-linha-atual AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-pesquisa c-arquivo bt-importar bt-sair ~
c-editor 
&Scoped-Define DISPLAYED-OBJECTS c-arquivo c-editor 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-importar 
     LABEL "Importar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-pesquisa 
     IMAGE-UP FILE "adeicon\prevw-u.bmp":U
     LABEL "Button 5" 
     SIZE 5 BY 1.13.

DEFINE BUTTON bt-sair 
     LABEL "Sair" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE c-editor AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 96 BY 7.25 NO-UNDO.

DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 70 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     bt-pesquisa AT ROW 7 COL 83.43 HELP
          "Pesquisa arquivo" WIDGET-ID 4
     c-arquivo AT ROW 7.04 COL 11 COLON-ALIGNED WIDGET-ID 2
     bt-importar AT ROW 8.29 COL 25.29 WIDGET-ID 6
     bt-sair AT ROW 8.29 COL 52.72 WIDGET-ID 8
     c-editor AT ROW 11.04 COL 2.72 NO-LABEL WIDGET-ID 10
     "Resultado da Importa‡Æo:" VIEW-AS TEXT
          SIZE 25 BY 1.25 AT ROW 9.88 COL 3.72 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 104 BY 20.38 WIDGET-ID 100.

DEFINE FRAME fm-frame
     "Item~;Sit trib conv 57/95~;Enquadramento IPI~;Aliquota ICSM interna" VIEW-AS TEXT
          SIZE 94 BY 1.25 AT ROW 1.25 COL 2 WIDGET-ID 2
     "Ex:  1010001~;00~;99999~;12,00" VIEW-AS TEXT
          SIZE 67 BY 1 AT ROW 2.75 COL 2 WIDGET-ID 6
     "O Arquivo dever  ser em formato .csv separado por ponto e virgula." VIEW-AS TEXT
          SIZE 95 BY .75 AT ROW 4 COL 2 WIDGET-ID 14
          FONT 0
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 1.17
         SIZE 98 BY 5.33
         TITLE "Layout do Arquivo" WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Importa‡Æo de arquivo .csv"
         HEIGHT             = 17.58
         WIDTH              = 99.43
         MAX-HEIGHT         = 25.42
         MAX-WIDTH          = 104
         VIRTUAL-HEIGHT     = 25.42
         VIRTUAL-WIDTH      = 104
         RESIZE             = yes
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
/* REPARENT FRAME */
ASSIGN FRAME fm-frame:FRAME = FRAME DEFAULT-FRAME:HANDLE.

/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fm-frame
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Importa‡Æo de arquivo .csv */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Importa‡Æo de arquivo .csv */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-importar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importar C-Win
ON CHOOSE OF bt-importar IN FRAME DEFAULT-FRAME /* Importar */
DO:
    
    MESSAGE "Confirma a Importa‡Æo do Arquivo?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        TITLE "Importa‡Æo de Dados conforme planilha parametrizada" UPDATE l-conf AS LOGICAL.
    
    IF NOT l-conf THEN LEAVE.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Atualizando...").

    INPUT FROM VALUE(c-arquivo:SCREEN-VALUE) CONVERT SOURCE "iso8859-1".
    OUTPUT TO c:\temp\of0903a.lst.

    ASSIGN i-linha = 0
           i-linha-atual = 0.

    REPEAT:
        IMPORT UNFORMATTED c-linha.
        ASSIGN i-linha = i-linha + 1.
        
        RUN pi-acompanhar in h-acomp (input "Codigo"  + string(ENTRY(1, c-linha, ";") ) ).

        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = ENTRY(1, c-linha, ";") NO-ERROR.

        IF NOT AVAIL ITEM THEN DO:
            ASSIGN c-editor:SCREEN-VALUE = c-editor:SCREEN-VALUE +  "Item nao encontrado, linha " + STRING(i-linha) + " nao sera importada: " + ENTRY(1, c-linha, ";") + CHR(13).
            NEXT.
        END.

        FIND FIRST ITEM EXCLUSIVE-LOCK
            WHERE ITEM.it-codigo = ENTRY(1, c-linha,";") NO-ERROR.
        
        IF AVAIL ITEM THEN
            ASSIGN item.int-2 = INT(ENTRY(2,c-linha,";")).

        FIND FIRST item-dist EXCLUSIVE-LOCK
            WHERE item-dist.it-codigo = ENTRY(1,c-linha,";") NO-ERROR.

        IF AVAIL item-dist THEN
            ASSIGN item-dist.cod-enquad-ipi       = ENTRY(3,c-linha,";")
                   OVERLAY(item-dist.char-1,26,5) = ENTRY(4,c-linha,";").

        ELSE DO:
            CREATE item-dist.
            ASSIGN item-dist.it-codigo            = ENTRY(1,c-linha,";")
                   item-dist.cod-enquad-ipi       = ENTRY(3,c-linha,";")
                   OVERLAY(item-dist.char-1,26,5) = ENTRY(4,c-linha,";"). 
        END.

        FIND CURRENT item-dist NO-LOCK.
    
        ASSIGN i-linha-atual = i-linha-atual + 1.
    END.

    RUN pi-finalizar IN h-acomp.

    ASSIGN c-editor:SCREEN-VALUE = c-editor:SCREEN-VALUE + "Processo Finalizado " + CHR(13) +
           "Linhas Importadas  " + STRING(i-linha) +  CHR(13) + 
           "Linhas Atualizadas " + STRING(i-linha-atual) +  CHR(13).

    PUT "Processo Finalizado" SKIP.
    
    INPUT CLOSE.
    OUTPUT CLOSE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pesquisa C-Win
ON CHOOSE OF bt-pesquisa IN FRAME DEFAULT-FRAME /* Button 5 */
DO:
  DEFINE VARIABLE v-arquivo AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE OKpressed AS LOGICAL     NO-UNDO.


    SYSTEM-DIALOG GET-FILE v-arquivo  
           TITLE "Procura Arquivo"        
           FILTERS "Somente Arquivos tipo (*.csv)"   "*.csv"
           MUST-EXIST USE-FILENAME UPDATE OKpressed.

    ASSIGN c-arquivo:SCREEN-VALUE = v-arquivo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair C-Win
ON CHOOSE OF bt-sair IN FRAME DEFAULT-FRAME /* Sair */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
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
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
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
  DISPLAY c-arquivo c-editor 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE bt-pesquisa c-arquivo bt-importar bt-sair c-editor 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW FRAME fm-frame IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fm-frame}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

