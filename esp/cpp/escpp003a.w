&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
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

DEFINE INPUT  PARAMETER hProgramaPai AS HANDLE      NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE hproc AS HANDLE      NO-UNDO.

/* Global Shared Variable Definitions ---                               */

DEFINE NEW GLOBAL SHARED VARIABLE v_nom_disposit_so AS CHARACTER   NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE g-escpp002-etiqueta AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtImpressora rtEtiqueta rtToolBar fiEtiqueta ~
bt-impressora btOK btCancel text-impressora 
&Scoped-Define DISPLAYED-OBJECTS fiEtiqueta fiImpressora text-impressora 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-impressora 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Reimprimir" 
     SIZE 10 BY 1.

DEFINE VARIABLE fiImpressora AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 33 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiEtiqueta AS CHARACTER FORMAT "x(14)":U 
     LABEL "Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE text-impressora AS CHARACTER FORMAT "X(256)":U INITIAL " Impressora" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE RECTANGLE rtEtiqueta
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 4.25.

DEFINE RECTANGLE rtImpressora
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 1.71.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 60 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     fiEtiqueta AT ROW 2.67 COL 15 COLON-ALIGNED HELP
          "C¢digo da Etiqueta"
     bt-impressora AT ROW 6.04 COL 45.29 HELP
          "Configuraá∆o da impressora" NO-TAB-STOP 
     fiImpressora AT ROW 6.13 COL 12.14 HELP
          "Nome da impressora" NO-LABEL NO-TAB-STOP 
     btOK AT ROW 7.83 COL 2 HELP
          "Reimprimir"
     btCancel AT ROW 7.83 COL 13 HELP
          "Fechar programa"
     text-impressora AT ROW 5.38 COL 2 NO-LABEL
     rtImpressora AT ROW 5.71 COL 1
     rtEtiqueta AT ROW 1 COL 1
     rtToolBar AT ROW 7.58 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 60 BY 8.08
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
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Reimpress∆o de etiquetas de Caixa e Pallet - 2.04.000 - ESCPP003A"
         HEIGHT             = 8.08
         WIDTH              = 60
         MAX-HEIGHT         = 8.08
         MAX-WIDTH          = 60
         VIRTUAL-HEIGHT     = 8.08
         VIRTUAL-WIDTH      = 60
         MIN-BUTTON         = no
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
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
/* SETTINGS FOR WINDOW wWindow
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR EDITOR fiImpressora IN FRAME fPage0
   NO-ENABLE                                                            */
ASSIGN 
       fiImpressora:READ-ONLY IN FRAME fPage0        = TRUE.

/* SETTINGS FOR FILL-IN text-impressora IN FRAME fPage0
   ALIGN-L                                                              */
ASSIGN 
       text-impressora:PRIVATE-DATA IN FRAME fPage0     = 
                "Impressora".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Reimpress∆o de etiquetas de Caixa e Pallet - 2.04.000 - ESCPP003A */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Reimpress∆o de etiquetas de Caixa e Pallet - 2.04.000 - ESCPP003A */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-impressora
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-impressora wWindow
ON CHOOSE OF bt-impressora IN FRAME fPage0
DO:
    RUN pi-impressora.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fPage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fPage0 /* Reimprimir */
DO:
    DO ON ERROR UNDO, RETURN NO-APPLY:
        RUN pi-executar.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/* ***************************  Main Block  *************************** */

ASSIGN {&WINDOW-NAME}:COLUMN = (hProgramaPai:COLUMN + (hProgramaPai:WIDTH  / 2)) - ({&WINDOW-NAME}:WIDTH  / 2)
       {&WINDOW-NAME}:ROW    = (hProgramaPai:ROW    + (hProgramaPai:HEIGHT / 2)) - ({&WINDOW-NAME}:HEIGHT / 2).

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

    
    IF hProgramaPai:TITLE BEGINS "ESCPP002" THEN DO:                
        
        IF g-escpp002-etiqueta NE "" THEN
            ASSIGN fiEtiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = g-escpp002-etiqueta
                   g-escpp002-etiqueta = "".
    END.


    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow  _DEFAULT-ENABLE
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
  DISPLAY fiEtiqueta fiImpressora text-impressora 
      WITH FRAME fPage0 IN WINDOW wWindow.
  ENABLE rtImpressora rtEtiqueta rtToolBar fiEtiqueta bt-impressora btOK 
         btCancel text-impressora 
      WITH FRAME fPage0 IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar wWindow 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cCapacidade AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME fPage0 fiEtiqueta
                              fiImpressora.

    IF SUBSTRING(fiEtiqueta, 1, 3) <> "ECO":U AND
       SUBSTRING(fiEtiqueta, 1, 3) <> "EPA":U THEN DO:
        
    END.

    /*
    FIND FIRST ns-volume-estab
         WHERE ns-volume-estab.volume-pai  = fiEtiqueta
    NO-LOCK NO-ERROR.

    IF NOT AVAIL ns-volume-estab THEN DO:
       MESSAGE 'Etiqueta CAIXA/PALLET ainda nao foi impressa' SKIP(1)
               'Utilizar o programa ESCPP003 para impressao da etiqueta CAIXA/PALLET'
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.

       RETURN NO-APPLY.
    END.*/

    CASE SUBSTRING(fiEtiqueta, 1, 3):
        WHEN "ECO":U THEN DO:
            FIND FIRST ns-contador
                WHERE ns-contador.codigo-contador = 1 NO-LOCK NO-ERROR.

            IF NOT AVAILABLE ns-contador THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "N∆o existe contador para a etiqueta de caixa.":U +
                                         "~~":U +
                                         "N∆o existe contador para a etiqueta de caixa. Favor verificar com a †rea de TI.":U).

                RETURN NO-APPLY.
            END.

            IF ns-contador.valor-contador < INTEGER(TRIM(SUBSTRING(fiEtiqueta, 7, 8))) THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Etiqueta n∆o foi impressa.":U +
                                         "~~":U +
                                         "Etiqueta n∆o foi impressa e portanto n∆o poder† ser reimpressa!":U).

                RETURN NO-APPLY.
            END.

            ASSIGN cCapacidade = "CAIXA - " + TRIM(SUBSTRING(fiEtiqueta, 4, 3)).
        END.
        WHEN "EPA":U THEN DO:
            FIND FIRST ns-contador
                WHERE ns-contador.codigo-contador = 2 NO-LOCK NO-ERROR.

            IF NOT AVAILABLE ns-contador THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "N∆o existe contador para a etiqueta de caixa.":U +
                                         "~~":U +
                                         "N∆o existe contador para a etiqueta de caixa. Favor verificar com a †rea de TI.":U).

                RETURN NO-APPLY.
            END.

            IF ns-contador.valor-contador < INTEGER(TRIM(SUBSTRING(fiEtiqueta, 7, 8))) THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Etiqueta n∆o foi impressa.":U +
                                         "~~":U +
                                         "Etiqueta n∆o foi impressa e portanto n∆o poder† ser reimpressa!":U).

                RETURN NO-APPLY.
            END.

            ASSIGN cCapacidade = "PALLET - " + TRIM(SUBSTRING(fiEtiqueta, 4, 3)).
        END.
        OTHERWISE DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Etiqueta deve ser de Caixa ou de Pallet.":U +
                                     "~~":U +
                                     "Etiqueta deve ser de Caixa ou de Pallet. A etiqueta n∆o ser† impressa!":U).

            RETURN NO-APPLY.
        END.
    END CASE.

    IF fiImpressora = "":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Impressora inv†lida!":U).

        RETURN NO-APPLY.
    END.

    OUTPUT TO VALUE(v_nom_disposit_so).
    PUT UNFORMATTED "^XA"                                                       SKIP
                    "^PW832"                                                    SKIP /* Novo comando para zebra 600 */
                    "^JUS"                                                      SKIP /* Novo comando para zebra 600 */
                    "^PQ"                         TRIM(STRING(1, "99999999":U)) SKIP
                    "^BY2"                                                      SKIP
                    "^FO96,40^BCN,136,N,N,N,N^SN" TRIM(fiEtiqueta)  ",1,Y^FS"   SKIP /* Codigo de Barras EAN 128 */
                    "^FO96,204^A0N,32,24^SN"      TRIM(fiEtiqueta)  ",1,Y^FS"   SKIP /* Valor do Codigo de Barras EAN128 */
                    "^FO96,240^A0N,80,80^FD"      TRIM(cCapacidade) "^FS"       SKIP /* Linha Indicativa da capacidade da Caixa/Pallet */
                    "^XZ".
    OUTPUT CLOSE.

    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 15825,
                       INPUT "Etiqueta reimpressa com sucesso!":U).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-impressora wWindow 
PROCEDURE pi-impressora :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-arquivo-temp AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-impressora   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-arq          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-layout       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-ant          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-imp-old      AS CHARACTER   NO-UNDO.

    ASSIGN c-ant          = INPUT FRAME fPage0 fiImpressora
           c-arquivo-temp = REPLACE(INPUT FRAME fPage0 fiImpressora, ":":U, ",":U).

    IF INPUT FRAME fPage0 fiImpressora <> "":U THEN DO:
        CASE NUM-ENTRIES(c-arquivo-temp):
            WHEN 2 THEN
                ASSIGN c-impressora = ENTRY(1, c-arquivo-temp)
                       c-layout     = ENTRY(2, c-arquivo-temp)
                       c-arq        = "":U.
            WHEN 3 THEN
                ASSIGN c-impressora = ENTRY(1, c-arquivo-temp)
                       c-layout     = ENTRY(2, c-arquivo-temp)
                       c-arq        = ENTRY(3, c-arquivo-temp).
            WHEN 4 THEN
                ASSIGN c-impressora = ENTRY(1, c-arquivo-temp)
                       c-layout     = ENTRY(2, c-arquivo-temp)
                       c-arq        = ENTRY(3, c-arquivo-temp) + ":":U + ENTRY(4, c-arquivo-temp).
        END CASE.
    END.

    RUN esp/utp/esut-impr01.w (INPUT-OUTPUT c-impressora,
                               INPUT-OUTPUT c-layout,
                               INPUT-OUTPUT c-arq,
                               INPUT hproc).

    IF c-arq = "":U THEN
        ASSIGN fiImpressora = c-impressora + ":":U + c-layout.
    ELSE
        ASSIGN fiImpressora = c-impressora + ":":U + c-layout + ":":U + c-arq.

    IF fiImpressora = ":":U THEN
        ASSIGN fiImpressora = c-ant.

    ASSIGN c-imp-old = fiImpressora.

    DISPLAY fiImpressora
        WITH FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

