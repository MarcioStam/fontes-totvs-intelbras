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
&Scoped-Define ENABLED-OBJECTS IMAGE-1 IMAGE-2 IMAGE-7 IMAGE-8 IMAGE-9 ~
IMAGE-10 RECT-1 rtToolBar IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 IMAGE-15 ~
IMAGE-16 c-item-ini c-item-fim c-uf-origem-ini c-uf-origem-fim ~
c-uf-destino-ini c-uf-destino-fim c-fam-mat-ini c-fam-mat-fim c-ncm-ini ~
c-ncm-fim c-origem-ini c-origem-fim bt-ok bt-sair 
&Scoped-Define DISPLAYED-OBJECTS c-item-ini c-item-fim c-uf-origem-ini ~
c-uf-origem-fim c-uf-destino-ini c-uf-destino-fim c-fam-mat-ini ~
c-fam-mat-fim c-ncm-ini c-ncm-fim c-origem-ini c-origem-fim 

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
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-sair 
     LABEL "Sair" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE c-fam-mat-fim AS CHARACTER FORMAT "X(15)":U INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-fam-mat-ini AS CHARACTER FORMAT "X(15)":U 
     LABEL "Familia Material" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-fim AS CHARACTER FORMAT "X(256)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-ncm-fim AS CHARACTER FORMAT "X(15)":U INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-ncm-ini AS CHARACTER FORMAT "X(15)":U 
     LABEL "NCM" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-origem-fim AS INTEGER FORMAT "9":U INITIAL 8 
     VIEW-AS FILL-IN 
     SIZE 3.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-origem-ini AS INTEGER FORMAT "9":U INITIAL 0 
     LABEL "Origem" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-uf-destino-fim AS CHARACTER FORMAT "X(256)":U INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-uf-destino-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "UF Destino" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-uf-origem-fim AS CHARACTER FORMAT "X(256)":U INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-uf-origem-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "UF Origem" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-10
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

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

DEFINE IMAGE IMAGE-2
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-7
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-8
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-9
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 7.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 78 BY 1.75
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     c-item-ini AT ROW 2.17 COL 20 COLON-ALIGNED WIDGET-ID 38
     c-item-fim AT ROW 2.17 COL 48.14 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     c-uf-origem-ini AT ROW 3.17 COL 29 COLON-ALIGNED WIDGET-ID 46
     c-uf-origem-fim AT ROW 3.17 COL 48.14 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     c-uf-destino-ini AT ROW 4.17 COL 29 COLON-ALIGNED WIDGET-ID 42
     c-uf-destino-fim AT ROW 4.17 COL 48.14 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     c-fam-mat-ini AT ROW 5.17 COL 26 COLON-ALIGNED WIDGET-ID 54
     c-fam-mat-fim AT ROW 5.17 COL 48.14 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     c-ncm-ini AT ROW 6.17 COL 26 COLON-ALIGNED WIDGET-ID 62
     c-ncm-fim AT ROW 6.17 COL 48.14 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     c-origem-ini AT ROW 7.25 COL 33 COLON-ALIGNED WIDGET-ID 70
     c-origem-fim AT ROW 7.25 COL 48.14 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     bt-ok AT ROW 10.25 COL 21 WIDGET-ID 26
     bt-sair AT ROW 10.25 COL 44 WIDGET-ID 28
     "Atualiza as informa‡äes do escdp050a - Subst Trib Item" VIEW-AS TEXT
          SIZE 47 BY .67 AT ROW 1.25 COL 4 WIDGET-ID 34
     IMAGE-1 AT ROW 2.17 COL 39.86 WIDGET-ID 14
     IMAGE-2 AT ROW 2.17 COL 46.43 WIDGET-ID 16
     IMAGE-7 AT ROW 3.17 COL 39.86 WIDGET-ID 18
     IMAGE-8 AT ROW 3.17 COL 46.43 WIDGET-ID 20
     IMAGE-9 AT ROW 4.17 COL 39.86 WIDGET-ID 22
     IMAGE-10 AT ROW 4.17 COL 46.43 WIDGET-ID 24
     RECT-1 AT ROW 1.75 COL 4 WIDGET-ID 30
     rtToolBar AT ROW 10 COL 2 WIDGET-ID 32
     IMAGE-11 AT ROW 5.17 COL 39.86 WIDGET-ID 56
     IMAGE-12 AT ROW 5.17 COL 46.43 WIDGET-ID 58
     IMAGE-13 AT ROW 6.17 COL 39.86 WIDGET-ID 64
     IMAGE-14 AT ROW 6.17 COL 46.43 WIDGET-ID 66
     IMAGE-15 AT ROW 7.25 COL 39.86 WIDGET-ID 72
     IMAGE-16 AT ROW 7.25 COL 46.43 WIDGET-ID 74
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.14 BY 10.83 WIDGET-ID 100.


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
         TITLE              = "Atualiza‡Æo escdp050a"
         HEIGHT             = 10.83
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
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME DEFAULT-FRAME
   6                                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Atualiza‡Æo escdp050a */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Atualiza‡Æo escdp050a */
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
def var h-acomp      as handle no-undo.

    MESSAGE "Confirma a atualiza‡Æo conforme sele‡Æo informada?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "Atualiza‡Æo de dados no programa escdp050a" UPDATE l-conf AS LOGICAL.
    if not l-conf then leave.

run utp/ut-acomp.p persistent set h-acomp.  

RUN pi-inicializar in h-acomp (input "Atualizando...").
  FOR EACH item-uf-sem-prot NO-LOCK
      WHERE item-uf-sem-prot.it-codigo       >= c-item-ini:SCREEN-VALUE
        AND item-uf-sem-prot.it-codigo       <= c-item-fim:SCREEN-VALUE   
        AND item-uf-sem-prot.cod-estado-orig >= c-uf-origem-ini:SCREEN-VALUE 
        and item-uf-sem-prot.cod-estado-orig <= c-uf-origem-fim:SCREEN-VALUE 
        AND item-uf-sem-prot.estado          >= c-uf-destino-ini:SCREEN-VALUE
        and item-uf-sem-prot.estado          <= c-uf-destino-fim:SCREEN-VALUE
        AND item-uf-sem-prot.log-1            = YES,
        FIRST ITEM NO-LOCK
           WHERE ITEM.it-codigo     = item-uf-sem-prot.it-codigo
             AND ITEM.fm-codigo    >= c-fam-mat-ini:SCREEN-VALUE
             AND ITEM.fm-codigo    <= c-fam-mat-fim:SCREEN-VALUE
             AND ITEM.class-fiscal >= c-ncm-ini:SCREEN-VALUE
             AND ITEM.class-fiscal <= c-ncm-fim:SCREEN-VALUE
             AND ITEM.codigo-orig  >= int(c-origem-ini:SCREEN-VALUE)
             AND ITEM.codigo-orig  <= int(c-origem-fim:SCREEN-VALUE):

      
      RUN pi-acompanhar in h-acomp (input "Codigo"  + item-uf-sem-prot.it-codigo ).

         FIND item-uf
              WHERE item-uf.it-codigo       = item-uf-sem-prot.it-codigo      
                AND item-uf.cod-estado-orig = item-uf-sem-prot.cod-estado-orig
                and item-uf.estado          = item-uf-sem-prot.estado         
              EXCLUSIVE-LOCK NO-ERROR.
         IF NOT AVAIL item-uf THEN DO:
             CREATE item-uf.
             ASSIGN item-uf.it-codigo       = item-uf-sem-prot.it-codigo           
                    item-uf.cod-estado-orig = item-uf-sem-prot.cod-estado-orig     
                    item-uf.estado          = item-uf-sem-prot.estado
                    item-uf.pais            = item-uf-sem-prot.pais.
         END.
         ASSIGN item-uf.per-sub-tri         = item-uf-sem-prot.per-sub-tri   
                item-uf.perc-red-sub        = item-uf-sem-prot.perc-red-sub  
                item-uf.dec-1               = item-uf-sem-prot.dec-1.
    
         FIND int-item-uf
              WHERE int-item-uf.it-codigo       = item-uf-sem-prot.it-codigo      
                AND int-item-uf.cod-estado-orig = item-uf-sem-prot.cod-estado-orig
                and int-item-uf.estado          = item-uf-sem-prot.estado         
              EXCLUSIVE-LOCK NO-ERROR.
         IF NOT AVAIL int-item-uf THEN DO:
             CREATE int-item-uf.
             ASSIGN int-item-uf.it-codigo       = item-uf-sem-prot.it-codigo           
                    int-item-uf.cod-estado-orig = item-uf-sem-prot.cod-estado-orig     
                    int-item-uf.estado          = item-uf-sem-prot.estado.
                    
         END.
    
         ASSIGN int-item-uf.perc-credito-interno = item-uf-sem-prot.perc-credito-interno
                int-item-uf.protocolo            = item-uf-sem-prot.protocolo.    
  END.

  RUN pi-finalizar in h-acomp.
  MESSAGE "Processo Efetuado"
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
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
  DISPLAY c-item-ini c-item-fim c-uf-origem-ini c-uf-origem-fim c-uf-destino-ini 
          c-uf-destino-fim c-fam-mat-ini c-fam-mat-fim c-ncm-ini c-ncm-fim 
          c-origem-ini c-origem-fim 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE IMAGE-1 IMAGE-2 IMAGE-7 IMAGE-8 IMAGE-9 IMAGE-10 RECT-1 rtToolBar 
         IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 IMAGE-15 IMAGE-16 c-item-ini 
         c-item-fim c-uf-origem-ini c-uf-origem-fim c-uf-destino-ini 
         c-uf-destino-fim c-fam-mat-ini c-fam-mat-fim c-ncm-ini c-ncm-fim 
         c-origem-ini c-origem-fim bt-ok bt-sair 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

