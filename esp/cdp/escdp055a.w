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
def var h-acomp  as handle no-undo.
/* Parameters Definitions ---                                           */

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
&Scoped-Define ENABLED-OBJECTS RECT-1 rtToolBar IMAGE-13 IMAGE-14 IMAGE-15 ~
IMAGE-16 IMAGE-17 IMAGE-18 IMAGE-19 IMAGE-20 IMAGE-43 IMAGE-44 c-ncm-ini ~
c-ncm-fim c-origem-ini c-origem-fim c-uf-origem-ini c-uf-origem-fim ~
c-uf-destino-ini c-uf-destino-fim c-item-ini c-item-fim bt-ok bt-sair 
&Scoped-Define DISPLAYED-OBJECTS c-ncm-ini c-ncm-fim c-origem-ini ~
c-origem-fim c-uf-origem-ini c-uf-origem-fim c-uf-destino-ini ~
c-uf-destino-fim c-item-ini c-item-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-6 RECT-1 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ok 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-sair 
     LABEL "Sair" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-item-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-ncm-fim AS CHARACTER FORMAT "X(15)":U INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-ncm-ini AS CHARACTER FORMAT "X(15)":U 
     LABEL "NCM" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-origem-fim AS INTEGER FORMAT "9":U INITIAL 8 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-origem-ini AS INTEGER FORMAT "9":U INITIAL 0 
     LABEL "Origem" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-uf-destino-fim AS CHARACTER FORMAT "X(2)":U INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-uf-destino-ini AS CHARACTER FORMAT "X(2)":U 
     LABEL "UF Destino" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-uf-origem-fim AS CHARACTER FORMAT "X(2)":U INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-uf-origem-ini AS CHARACTER FORMAT "X(2)":U 
     LABEL "UF Origem" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-43
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-44
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 5.83.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     c-ncm-ini AT ROW 1.71 COL 37.86 RIGHT-ALIGNED WIDGET-ID 62
     c-ncm-fim AT ROW 1.71 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     c-origem-ini AT ROW 2.71 COL 37.86 RIGHT-ALIGNED WIDGET-ID 70
     c-origem-fim AT ROW 2.71 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     c-uf-origem-ini AT ROW 3.71 COL 37.86 RIGHT-ALIGNED WIDGET-ID 46
     c-uf-origem-fim AT ROW 3.71 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     c-uf-destino-ini AT ROW 4.71 COL 37.86 RIGHT-ALIGNED WIDGET-ID 42
     c-uf-destino-fim AT ROW 4.71 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     c-item-ini AT ROW 5.75 COL 37.86 RIGHT-ALIGNED WIDGET-ID 86
     c-item-fim AT ROW 5.75 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     bt-ok AT ROW 7.54 COL 3.72 WIDGET-ID 26
     bt-sair AT ROW 7.54 COL 14.14 WIDGET-ID 28
     RECT-1 AT ROW 1.25 COL 3 WIDGET-ID 30
     rtToolBar AT ROW 7.33 COL 3 WIDGET-ID 32
     IMAGE-13 AT ROW 1.71 COL 39.72 WIDGET-ID 64
     IMAGE-14 AT ROW 1.71 COL 46.29 WIDGET-ID 66
     IMAGE-15 AT ROW 2.71 COL 39.72 WIDGET-ID 72
     IMAGE-16 AT ROW 2.71 COL 46.29 WIDGET-ID 74
     IMAGE-17 AT ROW 3.71 COL 39.72 WIDGET-ID 76
     IMAGE-18 AT ROW 3.71 COL 46.29 WIDGET-ID 78
     IMAGE-19 AT ROW 4.71 COL 39.72 WIDGET-ID 80
     IMAGE-20 AT ROW 4.71 COL 46.29 WIDGET-ID 82
     IMAGE-43 AT ROW 5.75 COL 39.72 WIDGET-ID 88
     IMAGE-44 AT ROW 5.75 COL 46.29 WIDGET-ID 90
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.14 BY 8
         FONT 1 WIDGET-ID 100.


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
         TITLE              = "Exporta‡Æo de Dados para o CD0904a"
         HEIGHT             = 8.08
         WIDTH              = 80.72
         MAX-HEIGHT         = 31.08
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 31.08
         VIRTUAL-WIDTH      = 195.14
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
/* SETTINGS FOR FILL-IN c-item-ini IN FRAME DEFAULT-FRAME
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-ncm-ini IN FRAME DEFAULT-FRAME
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-origem-ini IN FRAME DEFAULT-FRAME
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-uf-destino-ini IN FRAME DEFAULT-FRAME
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-uf-origem-ini IN FRAME DEFAULT-FRAME
   ALIGN-R                                                              */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME DEFAULT-FRAME
   6                                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Exporta‡Æo de Dados para o CD0904a */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Exporta‡Æo de Dados para o CD0904a */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok C-Win
ON CHOOSE OF bt-ok IN FRAME DEFAULT-FRAME /* OK */
DO:
    RUN utp/ut-msgs.p (INPUT 'show',
                       INPUT 27100,
                       INPUT "Confirma a atualiza‡Æo conforme sele‡Æo informada?").
    IF RETURN-VALUE = 'no' THEN LEAVE.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Atualizando...").

    FOR EACH  ncm-origem-sem-prot NO-LOCK
        WHERE ncm-origem-sem-prot.cod-ncm     >= c-ncm-ini:SCREEN-VALUE
        AND   ncm-origem-sem-prot.cod-ncm     <= c-ncm-fim:SCREEN-VALUE
        AND   ncm-origem-sem-prot.codigo-orig >= int(c-origem-ini:SCREEN-VALUE)  
        AND   ncm-origem-sem-prot.codigo-orig <= int(c-origem-fim:SCREEN-VALUE)
        AND   ncm-origem-sem-prot.uf-origem   >= c-uf-origem-ini:SCREEN-VALUE 
        AND   ncm-origem-sem-prot.uf-origem   <= c-uf-origem-fim:SCREEN-VALUE 
        AND   ncm-origem-sem-prot.uf-destino  >= c-uf-destino-ini:SCREEN-VALUE
        AND   ncm-origem-sem-prot.uf-destino  <= c-uf-destino-fim:SCREEN-VALUE
        AND   ncm-origem-sem-prot.l-gera-of
        AND   ncm-origem-sem-prot.l-tem-st,
        EACH  ITEM NO-LOCK
        WHERE ITEM.class-fiscal = ncm-origem-sem-prot.cod-ncm
        AND   ITEM.codigo-orig  = ncm-origem-sem-prot.codigo-orig
        AND   ITEM.it-codigo   >= c-item-ini:SCREEN-VALUE
        AND   ITEM.it-codigo   <= c-item-fim:SCREEN-VALUE
        AND   ITEM.ind-item-fat:
      
        RUN pi-acompanhar IN h-acomp (input "Item: " + ITEM.it-codigo ).

        FIND item-uf EXCLUSIVE-LOCK
            WHERE item-uf.it-codigo       = ITEM.it-codigo      
            AND   item-uf.cod-estado-orig = ncm-origem-sem-prot.uf-origem
            AND   item-uf.estado          = ncm-origem-sem-prot.uf-destino NO-ERROR.
        IF  NOT AVAIL item-uf THEN DO:
            FIND unid-feder NO-LOCK
                WHERE unid-feder.estado = ncm-origem-sem-prot.uf-origem NO-ERROR.

            CREATE item-uf.
            ASSIGN item-uf.it-codigo       = ITEM.it-codigo           
                   item-uf.cod-estado-orig = ncm-origem-sem-prot.uf-origem     
                   item-uf.estado          = ncm-origem-sem-prot.uf-destino
                   item-uf.pais            = unid-feder.pais. 
        END.
        ASSIGN item-uf.per-sub-tri         = ncm-origem-sem-prot.per-sub-tri   
               item-uf.perc-red-sub        = ncm-origem-sem-prot.perc-red-sub
               item-uf.dec-1               = ncm-origem-sem-prot.perc-aliq-Interna.
    
        FIND int-item-uf EXCLUSIVE-LOCK
            WHERE int-item-uf.it-codigo       = ITEM.it-codigo      
              AND int-item-uf.cod-estado-orig = ncm-origem-sem-prot.uf-origem
              and int-item-uf.estado          = ncm-origem-sem-prot.uf-destino NO-ERROR.

        IF NOT AVAIL int-item-uf THEN DO:
            CREATE int-item-uf.
            ASSIGN int-item-uf.it-codigo       = ITEM.it-codigo           
                   int-item-uf.cod-estado-orig = ncm-origem-sem-prot.uf-origem     
                   int-item-uf.estado          = ncm-origem-sem-prot.uf-destino.                   
        END.
    
        ASSIGN int-item-uf.perc-credito-interno = ncm-origem-sem-prot.perc-credito-icms
               int-item-uf.protocolo            = ncm-origem-sem-prot.protocolo.    
    END.

    RUN pi-finalizar IN h-acomp.

    RUN utp/ut-msgs.p (INPUT 'show',
                       INPUT 15825,
                       INPUT "Processo Efetuado com Sucesso.").
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
  DISPLAY c-ncm-ini c-ncm-fim c-origem-ini c-origem-fim c-uf-origem-ini 
          c-uf-origem-fim c-uf-destino-ini c-uf-destino-fim c-item-ini 
          c-item-fim 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-1 rtToolBar IMAGE-13 IMAGE-14 IMAGE-15 IMAGE-16 IMAGE-17 IMAGE-18 
         IMAGE-19 IMAGE-20 IMAGE-43 IMAGE-44 c-ncm-ini c-ncm-fim c-origem-ini 
         c-origem-fim c-uf-origem-ini c-uf-origem-fim c-uf-destino-ini 
         c-uf-destino-fim c-item-ini c-item-fim bt-ok bt-sair 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

