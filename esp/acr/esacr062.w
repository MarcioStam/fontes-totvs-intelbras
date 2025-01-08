&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
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

DEFINE TEMP-TABLE tt_param NO-UNDO
    FIELD arquivo            AS CHARACTER
    FIELD dat_emis_docto_ini LIKE tit_acr.dat_emis_docto
    FIELD dat_emis_docto_fim LIKE tit_acr.dat_emis_docto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tit_acr

/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define QUERY-STRING-DEFAULT-FRAME FOR EACH tit_acr SHARE-LOCK
&Scoped-define OPEN-QUERY-DEFAULT-FRAME OPEN QUERY DEFAULT-FRAME FOR EACH tit_acr SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-DEFAULT-FRAME tit_acr
&Scoped-define FIRST-TABLE-IN-QUERY-DEFAULT-FRAME tit_acr


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-8 RECT-7 RECT-2 IMAGE-9 IMAGE-10 ~
dat_emis_docto_ini dat_emis_docto_fim c_arquivo bt-imprime bt-salva text-1 
&Scoped-Define DISPLAYED-OBJECTS dat_emis_docto_ini dat_emis_docto_fim ~
c_arquivo text-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-imprime 
     LABEL "Imprimir" 
     SIZE 11.13 BY 1 TOOLTIP "Imprimir"
     FONT 1.

DEFINE BUTTON bt-salva 
     LABEL "Fechar" 
     SIZE 11.13 BY 1 TOOLTIP "Fechar/Salvar"
     FONT 1.

DEFINE VARIABLE c_arquivo AS CHARACTER FORMAT "X(100)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 54.88 BY .87 TOOLTIP "Destino"
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE dat_emis_docto_fim AS DATE FORMAT "99/99/9999" INITIAL 10/08/13 
     VIEW-AS FILL-IN 
     SIZE 9.25 BY .87.

DEFINE VARIABLE dat_emis_docto_ini AS DATE FORMAT "99/99/9999" INITIAL 10/08/13 
     LABEL "Data  Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 10.88 BY .87.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(256)":U INITIAL "O arquivo ser† gerado no formato ~".csv~", separado por ~"~;~" (ponto e v°rgula)." 
      VIEW-AS TEXT 
     SIZE 56.63 BY .67 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 2.75 BY .73.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 2.75 BY .73.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 65.5 BY 1.53
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 2.83.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 2.87.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY DEFAULT-FRAME FOR 
      tit_acr SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     dat_emis_docto_ini AT ROW 2.5 COL 14.13 COLON-ALIGNED HELP
          "Data Emiss∆o Documento" WIDGET-ID 24
     dat_emis_docto_fim AT ROW 2.5 COL 44.38 COLON-ALIGNED HELP
          "Data Emiss∆o Documento" NO-LABEL WIDGET-ID 26
     c_arquivo AT ROW 6.9 COL 2.5 HELP
          "Destino" WIDGET-ID 8
     bt-imprime AT ROW 8.97 COL 2.25 WIDGET-ID 14
     bt-salva AT ROW 8.97 COL 14 WIDGET-ID 16
     text-1 AT ROW 5.8 COL 4.75 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     " Seleá∆o" VIEW-AS TEXT
          SIZE 8 BY .53 AT ROW 1.13 COL 3.38 WIDGET-ID 4
          FONT 6
     "  Impress∆o" VIEW-AS TEXT
          SIZE 10.63 BY .53 AT ROW 5.03 COL 2.88 WIDGET-ID 12
          FONT 6
     RECT-8 AT ROW 1.5 COL 1.25 WIDGET-ID 2
     RECT-7 AT ROW 5.4 COL 1.25 WIDGET-ID 10
     RECT-2 AT ROW 8.7 COL 1 WIDGET-ID 18
     IMAGE-9 AT ROW 2.57 COL 28.25 WIDGET-ID 30
     IMAGE-10 AT ROW 2.57 COL 42.75 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65.5 BY 9.27
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
         TITLE              = "Antecipaá∆o por Abatimento - ESACR062"
         HEIGHT             = 9.27
         WIDTH              = 65.5
         MAX-HEIGHT         = 33.5
         MAX-WIDTH          = 240
         VIRTUAL-HEIGHT     = 33.5
         VIRTUAL-WIDTH      = 240
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
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c_arquivo IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _TblList          = "tit_acr"
     _Query            is OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Antecipaá∆o por Abatimento - ESACR062 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Antecipaá∆o por Abatimento - ESACR062 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprime C-Win
ON CHOOSE OF bt-imprime IN FRAME DEFAULT-FRAME /* Imprimir */
DO:
    ASSIGN INPUT FRAME default-frame c_arquivo
           INPUT FRAME default-frame dat_emis_docto_ini
           INPUT FRAME default-frame dat_emis_docto_fim.

    IF  dat_emis_docto_ini > dat_emis_docto_fim  THEN DO:
        MESSAGE "Per°odo de datas inv†lido!" SKIP
                "Data inicial deve ser menor ou igual a data final!"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Per°odo Inv†lido!".

        RETURN "NOK":U.
    END.

    IF  c_arquivo = "" THEN DO:
        MESSAGE "Arquivo de impress∆o deve ser informado!"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Arquivo Inv†lido!".

        RETURN "NOK":U.
    END.

    EMPTY TEMP-TABLE tt_param.

    CREATE tt_param.
    ASSIGN tt_param.arquivo            = c_arquivo
           tt_param.dat_emis_docto_ini = dat_emis_docto_ini
           tt_param.dat_emis_docto_fim = dat_emis_docto_fim.

    RUN esp/acr/esacr062rp.p (INPUT TABLE tt_param).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salva C-Win
ON CHOOSE OF bt-salva IN FRAME DEFAULT-FRAME /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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

    ASSIGN c_arquivo = SESSION:TEMP-DIRECTORY + "esacr062.csv".

    ASSIGN dat_emis_docto_ini = TODAY
           dat_emis_docto_fim = TODAY.

    DISP dat_emis_docto_ini
         dat_emis_docto_fim
         c_arquivo
        WITH FRAME default-frame.

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

  {&OPEN-QUERY-DEFAULT-FRAME}
  GET FIRST DEFAULT-FRAME.
  DISPLAY dat_emis_docto_ini dat_emis_docto_fim c_arquivo text-1 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-8 RECT-7 RECT-2 IMAGE-9 IMAGE-10 dat_emis_docto_ini 
         dat_emis_docto_fim c_arquivo bt-imprime bt-salva text-1 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

