&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
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
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE SHARED VARIABLE l-mp-n       AS LOGICAL      NO-UNDO.
DEFINE SHARED VARIABLE l-mp-s       AS LOGICAL      NO-UNDO.
DEFINE SHARED VARIABLE l-frete-n    AS LOGICAL      NO-UNDO.
DEFINE SHARED VARIABLE l-frete-s    AS LOGICAL      NO-UNDO.
DEFINE SHARED VARIABLE l-impostos-n AS LOGICAL      NO-UNDO.
DEFINE SHARED VARIABLE l-impostos-s AS LOGICAL      NO-UNDO.
DEFINE SHARED VARIABLE l-encer-n    AS LOGICAL      NO-UNDO.
DEFINE SHARED VARIABLE l-encer-s    AS LOGICAL      NO-UNDO.
DEFINE SHARED VARIABLE l-recebido-n AS LOGICAL      NO-UNDO.
DEFINE SHARED VARIABLE l-recebido-s AS LOGICAL      NO-UNDO.
DEFINE SHARED VARIABLE l-tipo-n     AS LOGICAL      NO-UNDO.
DEFINE SHARED VARIABLE l-tipo-s     AS LOGICAL      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-30 RECT-31 RECT-8 RECT-32 ~
c-usuario-ini c-usuario-fim i-transp-ini i-transp-fim c-empresa-ini ~
c-empresa-fim c-cod-estab-ini c-cod-estab-fim i-frete-ini i-frete-fim ~
i-imp-ini i-imp-fim l-tipo l-mp l-frete-sel l-recebido l-impostos-sel ~
l-encerrado c-co c-embarque Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS c-usuario-ini c-usuario-fim i-transp-ini ~
i-transp-fim c-empresa-ini c-empresa-fim c-cod-estab-ini c-cod-estab-fim ~
i-frete-ini i-frete-fim i-imp-ini i-imp-fim l-tipo l-mp l-frete-sel ~
l-recebido l-impostos-sel l-encerrado c-co c-embarque 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE {&NEW} SHARED VARIABLE l-encerrado AS CHARACTER FORMAT "X(1)":U INITIAL ? 
     LABEL "Encerrado" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","T",
                     "Abertos","A",
                     "Fechados","F"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE l-frete-sel AS CHARACTER FORMAT "X(1)":U INITIAL ? 
     LABEL "Int. AP Frete" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","T",
                     "Lan‡ados","L",
                     "NÆo Lan‡ados","N"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE l-impostos-sel AS CHARACTER FORMAT "X(1)":U INITIAL ? 
     LABEL "Int. AP Imp" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","T",
                     "Lan‡ados","L",
                     "NÆo Lan‡ados","N"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE l-mp AS CHARACTER FORMAT "X(1)":U INITIAL ? 
     LABEL "Mat‚ria Prima" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","T",
                     "MP","M",
                     "Consumo","C"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE l-recebido AS CHARACTER FORMAT "X(1)":U INITIAL ? 
     LABEL "Recebido/Env." 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","T",
                     "Recebidos","R",
                     "NÆo Recebidos","N"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE l-tipo AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","T",
                     "Sa¡da","S",
                     "Entrada","E"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE c-co AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     LABEL "Conhecimento" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE c-cod-estab-fim AS CHARACTER FORMAT "X(3)" INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE {&NEW} SHARED VARIABLE c-cod-estab-ini AS CHARACTER FORMAT "X(3)" INITIAL ? 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE {&NEW} SHARED VARIABLE c-embarque AS CHARACTER FORMAT "X(16)":U INITIAL "*" 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE c-empresa-fim AS CHARACTER FORMAT "x(30)" INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .88.

DEFINE {&NEW} SHARED VARIABLE c-empresa-ini AS CHARACTER FORMAT "x(30)" INITIAL ? 
     LABEL "Empresa" 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .88.

DEFINE {&NEW} SHARED VARIABLE c-usuario-fim AS CHARACTER FORMAT "x(12)" INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE {&NEW} SHARED VARIABLE c-usuario-ini AS CHARACTER FORMAT "x(12)" INITIAL ? 
     LABEL "Solicitante" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE {&NEW} SHARED VARIABLE i-frete-fim AS INTEGER FORMAT ">>>,>>9" INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE {&NEW} SHARED VARIABLE i-frete-ini AS INTEGER FORMAT ">>>,>>9" INITIAL ? 
     LABEL "Fornec. Frete" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE {&NEW} SHARED VARIABLE i-imp-fim AS INTEGER FORMAT ">>>,>>9" INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE {&NEW} SHARED VARIABLE i-imp-ini AS INTEGER FORMAT ">>>,>>9" INITIAL ? 
     LABEL "Fornec. Imp" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE {&NEW} SHARED VARIABLE i-transp-fim AS INTEGER FORMAT ">>,>>9" INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE {&NEW} SHARED VARIABLE i-transp-ini AS INTEGER FORMAT ">>,>>9" INITIAL ? 
     LABEL "Transportadora" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 3.25.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 1.25.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 1.25.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 6.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     c-usuario-ini AT ROW 1.17 COL 16 COLON-ALIGNED
     c-usuario-fim AT ROW 1.17 COL 48 COLON-ALIGNED NO-LABEL
     i-transp-ini AT ROW 2.17 COL 16 COLON-ALIGNED
     i-transp-fim AT ROW 2.17 COL 48 COLON-ALIGNED NO-LABEL
     c-empresa-ini AT ROW 3.17 COL 16 COLON-ALIGNED
     c-empresa-fim AT ROW 3.17 COL 48 COLON-ALIGNED NO-LABEL
     c-cod-estab-ini AT ROW 4.17 COL 16 COLON-ALIGNED
     c-cod-estab-fim AT ROW 4.17 COL 48 COLON-ALIGNED NO-LABEL
     i-frete-ini AT ROW 5.17 COL 16 COLON-ALIGNED
     i-frete-fim AT ROW 5.17 COL 48 COLON-ALIGNED NO-LABEL
     i-imp-ini AT ROW 6.17 COL 16 COLON-ALIGNED
     i-imp-fim AT ROW 6.17 COL 48 COLON-ALIGNED NO-LABEL
     l-tipo AT ROW 7.67 COL 16 COLON-ALIGNED
     l-mp AT ROW 7.75 COL 48 COLON-ALIGNED
     l-frete-sel AT ROW 8.67 COL 16 COLON-ALIGNED
     l-recebido AT ROW 8.75 COL 48 COLON-ALIGNED
     l-impostos-sel AT ROW 9.67 COL 16 COLON-ALIGNED
     l-encerrado AT ROW 9.75 COL 48 COLON-ALIGNED
     c-co AT ROW 11.17 COL 16 COLON-ALIGNED
     c-embarque AT ROW 12.67 COL 16 COLON-ALIGNED WIDGET-ID 2
     Btn_OK AT ROW 14.25 COL 2
     Btn_Cancel AT ROW 14.25 COL 13
     "Digite * (Asterisco) para considerar todos" VIEW-AS TEXT
          SIZE 31 BY .54 AT ROW 12.75 COL 40 WIDGET-ID 6
     "Pode-se utilizar o caracter * (Asterisco) como curinga" VIEW-AS TEXT
          SIZE 37 BY .54 AT ROW 11.25 COL 40
     RECT-2 AT ROW 14 COL 1
     RECT-30 AT ROW 7.5 COL 1
     RECT-31 AT ROW 11 COL 1
     RECT-8 AT ROW 1 COL 1
     RECT-32 AT ROW 12.5 COL 1 WIDGET-ID 4
     SPACE(0.00) SKIP(2.20)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Faixa sele‡Æo Courrier - ESACR004A"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-co IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR FILL-IN c-cod-estab-fim IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR FILL-IN c-cod-estab-ini IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR FILL-IN c-embarque IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR FILL-IN c-empresa-fim IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR FILL-IN c-empresa-ini IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR FILL-IN c-usuario-fim IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR FILL-IN c-usuario-ini IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR FILL-IN i-frete-fim IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR FILL-IN i-frete-ini IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR FILL-IN i-imp-fim IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR FILL-IN i-imp-ini IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR FILL-IN i-transp-fim IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR FILL-IN i-transp-ini IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR COMBO-BOX l-encerrado IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR COMBO-BOX l-frete-sel IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR COMBO-BOX l-impostos-sel IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR COMBO-BOX l-mp IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR COMBO-BOX l-recebido IN FRAME Dialog-Frame
   SHARED                                                               */
/* SETTINGS FOR COMBO-BOX l-tipo IN FRAME Dialog-Frame
   SHARED                                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Faixa sele‡Æo Courrier - ESACR004A */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME}
        c-empresa-fim c-empresa-ini 
        c-cod-estab-ini c-cod-estab-fim
        c-usuario-fim c-usuario-ini 
        i-imp-fim i-imp-ini 
        i-frete-fim i-frete-ini 
        i-transp-fim i-transp-ini 
        l-encerrado l-frete-sel l-impostos-sel l-mp l-recebido l-tipo
        c-co
        c-embarque.

    IF c-co = '' THEN
        ASSIGN c-co = '*'.

    IF l-mp = "T" THEN
        ASSIGN l-mp-n = NO
               l-mp-s = YES.
    IF l-mp = "M" THEN
        ASSIGN l-mp-n = YES
              l-mp-s  = YES.
    IF l-mp = "C" THEN
        ASSIGN l-mp-n = NO
              l-mp-s  = NO.

    IF l-frete-sel = "T" THEN
        ASSIGN l-frete-n = NO
               l-frete-s = YES.
    IF l-frete-sel = "L" THEN
        ASSIGN l-frete-n = YES
               l-frete-s = YES.
    IF l-frete-sel = "N" THEN
        ASSIGN l-frete-n = NO
               l-frete-s = NO.

    IF l-impostos-sel = "T" THEN
        ASSIGN l-impostos-n = NO
               l-impostos-s = YES.
    IF l-impostos-sel = "L" THEN
        ASSIGN l-impostos-n = YES
               l-impostos-s = YES.
    IF l-impostos-sel = "N" THEN
        ASSIGN l-impostos-n = NO
               l-impostos-s = NO.
               
    IF l-encerrado = "T" THEN
        ASSIGN l-encer-n = NO
               l-encer-s = YES.
    IF l-encerrado = "A" THEN
         ASSIGN l-encer-n = NO
                l-encer-s = NO.
    IF l-encerrado = "F" THEN 
        ASSIGN l-encer-n = YES
               l-encer-s = YES.

    IF l-recebido = "T" THEN
        ASSIGN l-recebido-n = NO
               l-recebido-s = YES.
    IF l-recebido = "R" THEN
        ASSIGN l-recebido-n = YES
               l-recebido-s = YES.
    IF l-recebido = "N" THEN
        ASSIGN l-recebido-n = NO
               l-recebido-s = NO.
               
    IF l-tipo = "T" THEN
        ASSIGN l-tipo-n = NO
               l-tipo-s = YES.
    IF l-tipo = "E" THEN
        ASSIGN l-tipo-n = YES
               l-tipo-s = YES.
    IF l-tipo = "S" THEN
        ASSIGN l-tipo-n = NO
               l-tipo-s = NO.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Faixa sele‡Æo Courrier - ESACR004A */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  ASSIGN c-embarque = "*".

  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY c-usuario-ini c-usuario-fim i-transp-ini i-transp-fim c-empresa-ini 
          c-empresa-fim c-cod-estab-ini c-cod-estab-fim i-frete-ini i-frete-fim 
          i-imp-ini i-imp-fim l-tipo l-mp l-frete-sel l-recebido l-impostos-sel 
          l-encerrado c-co c-embarque 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-2 RECT-30 RECT-31 RECT-8 RECT-32 c-usuario-ini c-usuario-fim 
         i-transp-ini i-transp-fim c-empresa-ini c-empresa-fim c-cod-estab-ini 
         c-cod-estab-fim i-frete-ini i-frete-fim i-imp-ini i-imp-fim l-tipo 
         l-mp l-frete-sel l-recebido l-impostos-sel l-encerrado c-co c-embarque 
         Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

