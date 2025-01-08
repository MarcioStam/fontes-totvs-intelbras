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

  Author: Francisco Almeida Franáa

  Created: Abril/2014

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
DEFINE TEMP-TABLE tt-crm-atendente LIKE crm-atendente.

DEFINE VARIABLE cod-estabel-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cod-estabel-fim AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cod-rep-ini     AS INTEGER     NO-UNDO.
DEFINE VARIABLE cod-rep-fim     AS INTEGER     NO-UNDO.
DEFINE VARIABLE unid-negoc-ini  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE unid-negoc-fim  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE categoria-ini   AS INTEGER     NO-UNDO.
DEFINE VARIABLE categoria-fim   AS INTEGER     NO-UNDO.
DEFINE VARIABLE atendente-ini   AS INTEGER     NO-UNDO.
DEFINE VARIABLE atendente-fim   AS INTEGER     NO-UNDO.
DEFINE VARIABLE gr-cli-ini      AS INTEGER     NO-UNDO.
DEFINE VARIABLE gr-cli-fim      AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 ~
IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 IMAGE-10 IMAGE-11 IMAGE-12 RECT-1 ~
fi-cod-estabel-ini fi-cod-estabel-fim fi-cod-rep-ini fi-cod-rep-fim ~
fi-unid-negoc-ini fi-unid-negoc-fim fi-categoria-ini fi-categoria-fim ~
fi-atendente-ini fi-atendente-fim fi-gr-cli-ini fi-gr-cli-fim ~
bt-excluir-faixa btCancel 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-estabel-ini fi-cod-estabel-fim ~
fi-cod-rep-ini fi-cod-rep-fim fi-unid-negoc-ini fi-unid-negoc-fim ~
fi-categoria-ini fi-categoria-fim fi-atendente-ini fi-atendente-fim ~
fi-gr-cli-ini fi-gr-cli-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-excluir-faixa 
     LABEL "EXCLUIR" 
     SIZE 10 BY 1.

DEFINE BUTTON btCancel 
     LABEL "FECHAR" 
     SIZE 10 BY 1.13.

DEFINE VARIABLE fi-atendente-fim AS INTEGER FORMAT "99" INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-atendente-ini AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Atendente" 
     VIEW-AS FILL-IN 
     SIZE 6.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-categoria-fim AS INTEGER FORMAT "999" INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-categoria-ini AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Categoria" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel-fim AS CHARACTER FORMAT "x(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel-ini AS CHARACTER FORMAT "x(3)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-rep-fim AS INTEGER FORMAT "99999" INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-rep-ini AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-gr-cli-fim AS INTEGER FORMAT "99" INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-gr-cli-ini AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Grupo Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-fim AS CHARACTER FORMAT "x(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-ini AS CHARACTER FORMAT "x(3)" 
     LABEL "Unid Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 10.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage1
     fi-cod-estabel-ini AT ROW 4 COL 26.29 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento" WIDGET-ID 92
     fi-cod-estabel-fim AT ROW 4 COL 45.14 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento" NO-LABEL WIDGET-ID 90
     fi-cod-rep-ini AT ROW 5 COL 23.29 COLON-ALIGNED HELP
          "C¢digo do Representante" WIDGET-ID 96
     fi-cod-rep-fim AT ROW 5 COL 45.14 COLON-ALIGNED HELP
          "C¢digo do Representante" NO-LABEL WIDGET-ID 94
     fi-unid-negoc-ini AT ROW 6 COL 23.29 COLON-ALIGNED HELP
          "C¢digo da Unidade de Neg¢cio" WIDGET-ID 104
     fi-unid-negoc-fim AT ROW 6 COL 45.14 COLON-ALIGNED HELP
          "C¢digo da Unidade de Neg¢cio" NO-LABEL WIDGET-ID 102
     fi-categoria-ini AT ROW 7 COL 23.29 COLON-ALIGNED HELP
          "C¢digo da Categoria" WIDGET-ID 88
     fi-categoria-fim AT ROW 7 COL 45.29 COLON-ALIGNED HELP
          "C¢digo da Categoria" NO-LABEL WIDGET-ID 86
     fi-atendente-ini AT ROW 8 COL 27 COLON-ALIGNED HELP
          "C¢digo do Atendente" WIDGET-ID 84
     fi-atendente-fim AT ROW 8 COL 45.14 COLON-ALIGNED HELP
          "C¢digo do Atendente" NO-LABEL WIDGET-ID 82
     fi-gr-cli-ini AT ROW 9 COL 23.29 COLON-ALIGNED HELP
          "C¢digo do Grupo de Cliente" WIDGET-ID 100
     fi-gr-cli-fim AT ROW 9 COL 45.29 COLON-ALIGNED HELP
          "C¢digo do Grupo de Cliente" NO-LABEL WIDGET-ID 98
     bt-excluir-faixa AT ROW 12 COL 35 WIDGET-ID 78
     btCancel AT ROW 14.5 COL 61 WIDGET-ID 80
     IMAGE-1 AT ROW 4 COL 35.29 WIDGET-ID 34
     IMAGE-2 AT ROW 4 COL 44.14 WIDGET-ID 36
     IMAGE-3 AT ROW 5 COL 35.29 WIDGET-ID 40
     IMAGE-4 AT ROW 5 COL 44.14 WIDGET-ID 42
     IMAGE-5 AT ROW 6 COL 35.29 WIDGET-ID 52
     IMAGE-6 AT ROW 6 COL 44.14 WIDGET-ID 54
     IMAGE-7 AT ROW 7 COL 35.29 WIDGET-ID 56
     IMAGE-8 AT ROW 7 COL 44.29 WIDGET-ID 58
     IMAGE-9 AT ROW 8 COL 35.29 WIDGET-ID 60
     IMAGE-10 AT ROW 8 COL 44.29 WIDGET-ID 62
     IMAGE-11 AT ROW 9 COL 35.29 WIDGET-ID 66
     IMAGE-12 AT ROW 9 COL 44.29 WIDGET-ID 64
     RECT-1 AT ROW 3.25 COL 7 WIDGET-ID 106
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 15.21
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "ESCDP037a - Exclus∆o por Faixa de Seleá∆o"
         HEIGHT             = 15.96
         WIDTH              = 80
         MAX-HEIGHT         = 28.92
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.92
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
/* SETTINGS FOR FRAME fPage1
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* ESCDP037a - Exclus∆o por Faixa de Seleá∆o */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* ESCDP037a - Exclus∆o por Faixa de Seleá∆o */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excluir-faixa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excluir-faixa C-Win
ON CHOOSE OF bt-excluir-faixa IN FRAME fPage1 /* EXCLUIR */
DO:
    
message 'Confirma exclusao?' view-as alert-box question buttons yes-no
  update l-confirma as logical format 'Sim/Nao'.
     if l-confirma then do:
        RUN pi-excluir-faixa.
     end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME fPage1 /* FECHAR */
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
  DISPLAY fi-cod-estabel-ini fi-cod-estabel-fim fi-cod-rep-ini fi-cod-rep-fim 
          fi-unid-negoc-ini fi-unid-negoc-fim fi-categoria-ini fi-categoria-fim 
          fi-atendente-ini fi-atendente-fim fi-gr-cli-ini fi-gr-cli-fim 
      WITH FRAME fPage1 IN WINDOW C-Win.
  ENABLE IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 
         IMAGE-9 IMAGE-10 IMAGE-11 IMAGE-12 RECT-1 fi-cod-estabel-ini 
         fi-cod-estabel-fim fi-cod-rep-ini fi-cod-rep-fim fi-unid-negoc-ini 
         fi-unid-negoc-fim fi-categoria-ini fi-categoria-fim fi-atendente-ini 
         fi-atendente-fim fi-gr-cli-ini fi-gr-cli-fim bt-excluir-faixa btCancel 
      WITH FRAME fPage1 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fPage1}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-excluir-faixa C-Win 
PROCEDURE pi-excluir-faixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var h-acomp as handle no-undo.
run utp/ut-acomp.p persistent set h-acomp.

DEF VAR l-encontra AS LOGICAL NO-UNDO.
RUN pi-verificar-faixa(OUTPUT l-encontra).

RUN pi-inicializar IN h-acomp (INPUT "Excluindo faixa selecionada":U).

IF l-encontra = YES THEN DO:
    FOR EACH crm-atendente 
       WHERE crm-atendente.cod-estabel   >= INPUT FRAME fPage1 fi-cod-estabel-ini
         AND crm-atendente.cod-estabel   <= INPUT FRAME fPage1 fi-cod-estabel-fim 
         AND crm-atendente.cod-rep       >= INPUT FRAME fPage1 fi-cod-rep-ini
         AND crm-atendente.cod-rep       <= INPUT FRAME fpage1 fi-cod-rep-fim
         AND crm-atendente.cd-unid-negoc >= INPUT FRAME fPage1 fi-unid-negoc-ini
         AND crm-atendente.cd-unid-negoc <= INPUT FRAME fPage1 fi-unid-negoc-fim
         AND crm-atendente.cd-categoria  >= INPUT FRAME fPage1 fi-categoria-ini 
         AND crm-atendente.cd-categoria  <= INPUT FRAME fPage1 fi-categoria-fim 
         AND crm-atendente.cd-atend      >= INPUT FRAME fPage1 fi-atendente-ini 
         AND crm-atendente.cd-atend      <= INPUT FRAME fPage1 fi-atendente-fim 
         AND crm-atendente.cod-gr-cli    >= INPUT FRAME fPage1 fi-gr-cli-ini 
         AND crm-atendente.cod-gr-cli    <= INPUT FRAME fPage1 fi-gr-cli-fim EXCLUSIVE-LOCK:
     
         /*CREATE tt-crm-atendente.               
         ASSIGN tt-crm-atendente.cod-estabel   = crm-atendente.cod-estabel
                tt-crm-atendente.cod-rep       = crm-atendente.cod-rep
                tt-crm-atendente.cd-unid-negoc = crm-atendente.cd-unid-negoc
                tt-crm-atendente.cd-categoria  = crm-atendente.cd-categoria
                tt-crm-atendente.cd-atend      = crm-atendente.cd-atend
                tt-crm-atendente.cod-gr-cli    = crm-atendente.cod-gr-cli.
    
         ASSIGN cod-estabel-ini = INPUT FRAME fPage1 fi-cod-estabel-ini  
                cod-estabel-fim = INPUT FRAME fPage1 fi-cod-estabel-fim  
                cod-rep-ini     = INPUT FRAME fPage1 fi-cod-rep-ini      
                cod-rep-fim     = INPUT FRAME fpage1 fi-cod-rep-fim      
                unid-negoc-ini  = INPUT FRAME fPage1 fi-unid-negoc-ini   
                unid-negoc-fim  = INPUT FRAME fPage1 fi-unid-negoc-fim   
                categoria-ini   = INPUT FRAME fPage1 fi-categoria-ini    
                categoria-fim   = INPUT FRAME fPage1 fi-categoria-fim    
                atendente-ini   = INPUT FRAME fPage1 fi-atendente-ini    
                atendente-fim   = INPUT FRAME fPage1 fi-atendente-fim    
                gr-cli-ini      = INPUT FRAME fPage1 fi-gr-cli-ini       
                gr-cli-fim      = INPUT FRAME fPage1 fi-gr-cli-fim.*/      
    
         RUN pi-acompanhar IN h-acomp (INPUT "Excluindo faixa selecionada":U).
         
         DELETE crm-atendente.
    END.
    
    RUN pi-finalizar IN h-acomp.
        if valid-handle(h-acomp) then
           delete object h-acomp.  
    
    MESSAGE "Registros Exclu°dos com sucesso."
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.
ELSE DO:
    RUN pi-finalizar IN h-acomp.
        if valid-handle(h-acomp) then
           delete object h-acomp.
END.

/*DISABLE bt-excluir-faixa WITH FRAME fPage1.*/
/*ENABLE bt-reverter WITH FRAME fPage1.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reverter C-Win 
PROCEDURE pi-reverter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var h-acomp as handle no-undo.
run utp/ut-acomp.p persistent set h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Revertendo £ltima exclus∆o...":U).

FOR EACH tt-crm-atendente 
   WHERE tt-crm-atendente.cod-estabel   >= cod-estabel-ini
     AND tt-crm-atendente.cod-estabel   <= cod-estabel-fim 
     AND tt-crm-atendente.cod-rep       >= cod-rep-ini
     AND tt-crm-atendente.cod-rep       <= cod-rep-fim
     AND tt-crm-atendente.cd-unid-negoc >= unid-negoc-ini
     AND tt-crm-atendente.cd-unid-negoc <= unid-negoc-fim
     AND tt-crm-atendente.cd-categoria  >= categoria-ini 
     AND tt-crm-atendente.cd-categoria  <= categoria-fim 
     AND tt-crm-atendente.cd-atend      >= atendente-ini 
     AND tt-crm-atendente.cd-atend      <= atendente-fim 
     AND tt-crm-atendente.cod-gr-cli    >= gr-cli-ini 
     AND tt-crm-atendente.cod-gr-cli    <= gr-cli-fim NO-LOCK:

     CREATE crm-atendente.
     ASSIGN crm-atendente.cod-estabel   = tt-crm-atendente.cod-estabel   
            crm-atendente.cod-rep       = tt-crm-atendente.cod-rep      
            crm-atendente.cd-unid-negoc = tt-crm-atendente.cd-unid-negoc
            crm-atendente.cd-categoria  = tt-crm-atendente.cd-categoria 
            crm-atendente.cd-atend      = tt-crm-atendente.cd-atend     
            crm-atendente.cod-gr-cli    = tt-crm-atendente.cod-gr-cli.

     RUN pi-acompanhar IN h-acomp (INPUT "Revertendo £ltima exclus∆o...":U).

END.

RUN pi-finalizar IN h-acomp.
    if  valid-handle(h-acomp) then
        delete object h-acomp.

/*DISABLE bt-reverter WITH FRAME fPage1.*/

MESSAGE "Foram restaurados os registros" + CHR(13) + "da £ltima exclus∆o."
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verificar-faixa C-Win 
PROCEDURE pi-verificar-faixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var h-acomp as handle no-undo.
run utp/ut-acomp.p persistent set h-acomp.

DEFINE OUTPUT PARAMETER l-encontra AS LOGICAL NO-UNDO.

DEFINE VARIABLE i-contador AS INTEGER     NO-UNDO.
ASSIGN i-contador = 0.

RUN pi-inicializar IN h-acomp (INPUT "Validando faixa selecionada":U).

FOR EACH crm-atendente 
   WHERE crm-atendente.cod-estabel   >= INPUT FRAME fPage1 fi-cod-estabel-ini
     AND crm-atendente.cod-estabel   <= INPUT FRAME fPage1 fi-cod-estabel-fim 
     AND crm-atendente.cod-rep       >= INPUT FRAME fPage1 fi-cod-rep-ini
     AND crm-atendente.cod-rep       <= INPUT FRAME fpage1 fi-cod-rep-fim
     AND crm-atendente.cd-unid-negoc >= INPUT FRAME fPage1 fi-unid-negoc-ini
     AND crm-atendente.cd-unid-negoc <= INPUT FRAME fPage1 fi-unid-negoc-fim
     AND crm-atendente.cd-categoria  >= INPUT FRAME fPage1 fi-categoria-ini 
     AND crm-atendente.cd-categoria  <= INPUT FRAME fPage1 fi-categoria-fim 
     AND crm-atendente.cd-atend      >= INPUT FRAME fPage1 fi-atendente-ini 
     AND crm-atendente.cd-atend      <= INPUT FRAME fPage1 fi-atendente-fim 
     AND crm-atendente.cod-gr-cli    >= INPUT FRAME fPage1 fi-gr-cli-ini 
     AND crm-atendente.cod-gr-cli    <= INPUT FRAME fPage1 fi-gr-cli-fim NO-LOCK:
     
     RUN pi-acompanhar IN h-acomp (INPUT "Validando faixa selecionada":U).
     
     IF AVAIL crm-atendente THEN DO:
         ASSIGN i-contador = i-contador + 1.    
     END.
END.
RUN pi-finalizar IN h-acomp.
    if  valid-handle(h-acomp) then
        delete object h-acomp.  

IF i-contador = 0 THEN DO:
    MESSAGE "Registros n∆o encontrados."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    ASSIGN l-encontra = NO.
END.
ELSE DO:
    ASSIGN l-encontra = YES.
END.

RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

