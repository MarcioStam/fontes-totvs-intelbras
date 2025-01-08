&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP086 2.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP086
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-copias btConfigImpr fi-imei btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-imeis
    FIELD cod-imei  AS CHAR.

DEFINE VARIABLE i-cont-imeis AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-esapi016 AS HANDLE      NO-UNDO.

{esapi/esapi016.i}
{cdp/cd0666.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-imeis

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-imeis

/* Definitions for BROWSE br-imeis                                      */
&Scoped-define FIELDS-IN-QUERY-br-imeis tt-imeis.cod-imei   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-imeis   
&Scoped-define SELF-NAME br-imeis
&Scoped-define QUERY-STRING-br-imeis FOR EACH tt-imeis
&Scoped-define OPEN-QUERY-br-imeis OPEN QUERY {&SELF-NAME} FOR EACH tt-imeis.
&Scoped-define TABLES-IN-QUERY-br-imeis tt-imeis
&Scoped-define FIRST-TABLE-IN-QUERY-br-imeis tt-imeis


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-imeis}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-1 RECT-4 ~
btQueryJoins btReportsJoins btExit btHelp fi-copias btConfigImpr fiPrinter ~
fi-imei br-imeis btOK btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-copias fiPrinter fi-imei 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "Configuraá∆o da impressora" 
     SIZE 4 BY 1 TOOLTIP "Configuraá∆o da impressora".

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

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Imprimir" 
     SIZE 10 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 44 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fi-copias AS INTEGER FORMAT ">>>,>>9":U INITIAL 2 
     LABEL "C¢pias" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-imei AS CHARACTER FORMAT "X(256)":U 
     LABEL "IMEI" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 2.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-imeis FOR 
      tt-imeis SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-imeis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-imeis wWindow _FREEFORM
  QUERY br-imeis DISPLAY
      tt-imeis.cod-imei COLUMN-LABEL "IMEI" FORMAT "X(20)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88 BY 8.75
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     fi-copias AT ROW 3 COL 25.14 COLON-ALIGNED WIDGET-ID 6
     btConfigImpr AT ROW 3.96 COL 71.14 HELP
          "Configuraá∆o da impressora" WIDGET-ID 22
     fiPrinter AT ROW 4 COL 27.14 NO-LABEL WIDGET-ID 24 NO-TAB-STOP 
     fi-imei AT ROW 5.75 COL 25 COLON-ALIGNED WIDGET-ID 28
     br-imeis AT ROW 7.25 COL 2 WIDGET-ID 200
     btOK AT ROW 16.75 COL 2
     btHelp2 AT ROW 16.75 COL 80
     "Impressora:" VIEW-AS TEXT
          SIZE 8 BY .63 AT ROW 4.17 COL 19 WIDGET-ID 30
          FONT 1
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16.54 COL 1
     RECT-1 AT ROW 2.75 COL 2 WIDGET-ID 2
     RECT-4 AT ROW 5.5 COL 2 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-imeis fi-imei fpage0 */
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-imeis
/* Query rebuild information for BROWSE br-imeis
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-imeis.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-imeis */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wWindow
ON CHOOSE OF btConfigImpr IN FRAME fpage0 /* Configuraá∆o da impressora */
DO:
    RUN piSelectPrinter IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Imprimir */
DO:

    RUN pi-copia.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-imei
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-imei wWindow
ON RETURN OF fi-imei IN FRAME fpage0 /* IMEI */
DO:

    IF LENGTH(SELF:SCREEN-VALUE) <> 15 THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Etiqueta coletada n∆o Ç de IMEI.").
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.


    IF NOT CAN-FIND(FIRST tt-imeis
                    WHERE tt-imeis.cod-imei = SELF:SCREEN-VALUE) THEN DO:

        CREATE tt-imeis.
        ASSIGN tt-imeis.cod-imei = SELF:SCREEN-VALUE.
    
        {&open-query-br-imeis}

    END.
    ELSE DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "N£mero de IMEI j† foi coletado.").

    END.

    ASSIGN SELF:SCREEN-VALUE = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-imeis
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copia wWindow 
PROCEDURE pi-copia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Impress∆o de Etiquetas").

    RUN esapi/esapi016.p PERSISTENT SET h-esapi016.
    
    RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Etiquetas").

    EMPTY TEMP-TABLE tt-lista-ns.

    FOR EACH tt-imeis:

        CREATE tt-lista-ns.
        ASSIGN tt-lista-ns.num-serie = tt-imeis.cod-imei.

    END.

    RUN piCopiaImei IN h-esapi016 (INPUT INPUT FRAME fPage0 fi-copias,
                                   INPUT INPUT FRAME fPage0 fiPrinter,
                                   INPUT TABLE tt-lista-ns).

    IF RETURN-VALUE <> "OK":U THEN DO:

        EMPTY TEMP-TABLE tt-erro.

        RUN piRetornaErros IN h-esapi016 (OUTPUT TABLE tt-erro).

        RUN pi-finalizar IN h-acomp.

        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        DELETE PROCEDURE h-esapi016.

        RETURN "NOK":U.

    END.

    RUN pi-finalizar IN h-acomp.

    DELETE PROCEDURE h-esapi016.


    EMPTY TEMP-TABLE tt-imeis.
    {&open-query-br-imeis}

    APPLY "ENTRY" TO fi-imei IN FRAME fPage0.


    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelectPrinter wWindow 
PROCEDURE piSelectPrinter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTempFile AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cAuxFile  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cPrev     AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME fPage0 fiPrinter.

    ASSIGN cPrev     = fiPrinter
           cTempFile = REPLACE(fiPrinter, ":":U, ",":U).

    IF fiPrinter <> "":U THEN DO:
        IF NUM-ENTRIES(cTempFile) = 4 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile) + ":":U + ENTRY(4, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 3 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 2 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = "":U.
    END.

    RUN utp/ut-impr.w (INPUT-OUTPUT cPrinter,
                       INPUT-OUTPUT cLayout,
                       INPUT-OUTPUT cAuxFile).

    IF cAuxFile = "":U THEN
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout.
    ELSE
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout + ":":U + cAuxFile.

    IF fiPrinter = ":":U THEN
        ASSIGN fiPrinter = cPrev.

    DISPLAY fiPrinter
        WITH FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

