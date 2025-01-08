&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-window 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESWMP999 1.12.00.001}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESWMP999 MFT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE TEMP-TABLE ttintegra-mft-wms-notas LIKE integra-mft-wms-notas
       FIELD dt-integra AS DATE.


/* Local Variable Definitions ---                                       */

DEFINE BUTTON    btGoToOK     AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.

DEFINE RECTANGLE rtGoToFields  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 8.3 BGCOLOR 8.
DEFINE RECTANGLE rtGoToButton  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 72 BY 4.5 BGCOLOR 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-Integra

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttintegra-mft-wms-notas

/* Definitions for BROWSE br-Integra                                    */
&Scoped-define FIELDS-IN-QUERY-br-Integra ttintegra-mft-wms-notas.cod-integra ttintegra-mft-wms-notas.dt-integra ttintegra-mft-wms-notas.cdd-embarq ttintegra-mft-wms-notas.cod-estabel ttintegra-mft-wms-notas.serie ttintegra-mft-wms-notas.nr-nota-fis ttintegra-mft-wms-notas.nr-pedcli ttintegra-mft-wms-notas.nr-resumo ttintegra-mft-wms-notas.nr-seq-fat ttintegra-mft-wms-notas.it-codigo ttintegra-mft-wms-notas.l-fracionado ttintegra-mft-wms-notas.nome-abrev ttintegra-mft-wms-notas.qtd-integra ttintegra-mft-wms-notas.dt-cancel   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-Integra   
&Scoped-define SELF-NAME br-Integra
&Scoped-define QUERY-STRING-br-Integra FOR EACH ttintegra-mft-wms-notas NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-Integra OPEN QUERY {&SELF-NAME} FOR EACH ttintegra-mft-wms-notas NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-Integra ttintegra-mft-wms-notas
&Scoped-define FIRST-TABLE-IN-QUERY-br-Integra ttintegra-mft-wms-notas


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br-Integra}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS dt-integra-ini dt-integra-fim bt-confirma ~
cod-estabel-ini cod-estabel-fim nr-embarque-ini nr-embarque-fim ~
nr-nota-fis-ini nr-nota-fis-fim cod-integra-ini cod-integra-fim bt-ok ~
RECT-1 IMAGE-1 IMAGE-2 IMAGE-39 IMAGE-40 IMAGE-41 IMAGE-42 IMAGE-45 ~
IMAGE-46 IMAGE-47 IMAGE-48 br-Integra 
&Scoped-Define DISPLAYED-OBJECTS dt-integra-ini dt-integra-fim ~
cod-estabel-ini cod-estabel-fim nr-embarque-ini nr-embarque-fim ~
nr-nota-fis-ini nr-nota-fis-fim cod-integra-ini cod-integra-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image\im-sav":U
     LABEL "Button 1" 
     SIZE 5.2 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cod-estabel-fim AS CHARACTER FORMAT "X(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .86 NO-UNDO.

DEFINE VARIABLE cod-estabel-ini AS CHARACTER FORMAT "X(3)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .86 NO-UNDO.

DEFINE VARIABLE cod-integra-fim AS CHARACTER FORMAT "X(17)" INITIAL "ZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .86 NO-UNDO.

DEFINE VARIABLE cod-integra-ini AS CHARACTER FORMAT "X(17)" 
     LABEL "Cod Integra" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .86 NO-UNDO.

DEFINE VARIABLE dt-integra-fim AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .86 NO-UNDO.

DEFINE VARIABLE dt-integra-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Data Integra" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .86 NO-UNDO.

DEFINE VARIABLE nr-embarque-fim AS DECIMAL FORMAT ">>>>>>>>>>>>>>>9" INITIAL 999999999999999 
     VIEW-AS FILL-IN 
     SIZE 18 BY .86 NO-UNDO.

DEFINE VARIABLE nr-embarque-ini AS DECIMAL FORMAT ">>>>>>>>>>>>>>>9" INITIAL 0 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .86 NO-UNDO.

DEFINE VARIABLE nr-nota-fis-fim AS CHARACTER FORMAT "X(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .86 NO-UNDO.

DEFINE VARIABLE nr-nota-fis-ini AS CHARACTER FORMAT "X(16)" 
     LABEL "Nota Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .86 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\ii-fir":U
     SIZE 2.8 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image\ii-las":U
     SIZE 2.8 BY 1.

DEFINE IMAGE IMAGE-39
     FILENAME "image\ii-fir":U
     SIZE 2.8 BY 1.

DEFINE IMAGE IMAGE-40
     FILENAME "image\ii-las":U
     SIZE 2.8 BY 1.

DEFINE IMAGE IMAGE-41
     FILENAME "image\ii-fir":U
     SIZE 2.8 BY 1.

DEFINE IMAGE IMAGE-42
     FILENAME "image\ii-las":U
     SIZE 2.8 BY 1.

DEFINE IMAGE IMAGE-45
     FILENAME "image\ii-fir":U
     SIZE 2.8 BY 1.

DEFINE IMAGE IMAGE-46
     FILENAME "image\ii-las":U
     SIZE 2.8 BY 1.

DEFINE IMAGE IMAGE-47
     FILENAME "image\ii-fir":U
     SIZE 2.8 BY 1.

DEFINE IMAGE IMAGE-48
     FILENAME "image\ii-las":U
     SIZE 2.8 BY 1.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 104 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-Integra FOR 
      ttintegra-mft-wms-notas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-Integra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-Integra w-window _FREEFORM
  QUERY br-Integra NO-LOCK DISPLAY
      ttintegra-mft-wms-notas.cod-integra 
      ttintegra-mft-wms-notas.dt-integra COLUMN-LABEL "Dt Integra"
      ttintegra-mft-wms-notas.cdd-embarq 
      ttintegra-mft-wms-notas.cod-estabel 
      ttintegra-mft-wms-notas.serie
      ttintegra-mft-wms-notas.nr-nota-fis 
      ttintegra-mft-wms-notas.nr-pedcli 
      ttintegra-mft-wms-notas.nr-resumo 
      ttintegra-mft-wms-notas.nr-seq-fat 
      ttintegra-mft-wms-notas.it-codigo 
      ttintegra-mft-wms-notas.l-fracionado 
      ttintegra-mft-wms-notas.nome-abrev 
      ttintegra-mft-wms-notas.qtd-integra
      ttintegra-mft-wms-notas.dt-cancel
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 102.8 BY 13.76
         FONT 4 ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     dt-integra-ini AT ROW 1.29 COL 25.8 COLON-ALIGNED WIDGET-ID 44
     dt-integra-fim AT ROW 1.29 COL 59.2 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     bt-confirma AT ROW 1.29 COL 100.4 WIDGET-ID 40
     cod-estabel-ini AT ROW 2.19 COL 25.8 COLON-ALIGNED WIDGET-ID 52
     cod-estabel-fim AT ROW 2.19 COL 59.2 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     nr-embarque-ini AT ROW 3.05 COL 25.8 COLON-ALIGNED HELP
          "C¢digo - Decimal Embarque" WIDGET-ID 60
     nr-embarque-fim AT ROW 3.05 COL 59.2 COLON-ALIGNED HELP
          "C¢digo - Decimal Embarque" NO-LABEL WIDGET-ID 58
     nr-nota-fis-ini AT ROW 3.91 COL 25.8 COLON-ALIGNED WIDGET-ID 76
     nr-nota-fis-fim AT ROW 3.91 COL 59.2 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     cod-integra-ini AT ROW 4.81 COL 25.8 COLON-ALIGNED WIDGET-ID 68
     cod-integra-fim AT ROW 4.81 COL 59.2 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     bt-ok AT ROW 20.19 COL 3
     br-Integra AT ROW 6 COL 3 WIDGET-ID 200
     RECT-1 AT ROW 20 COL 2.4
     IMAGE-1 AT ROW 1.29 COL 46.4 WIDGET-ID 46
     IMAGE-2 AT ROW 1.29 COL 57.8 WIDGET-ID 48
     IMAGE-39 AT ROW 2.19 COL 46.4 WIDGET-ID 54
     IMAGE-40 AT ROW 2.19 COL 57.8 WIDGET-ID 56
     IMAGE-41 AT ROW 3.05 COL 46.4 WIDGET-ID 62
     IMAGE-42 AT ROW 3.05 COL 57.8 WIDGET-ID 64
     IMAGE-45 AT ROW 3.91 COL 46.4 WIDGET-ID 78
     IMAGE-46 AT ROW 3.91 COL 57.8 WIDGET-ID 80
     IMAGE-47 AT ROW 4.81 COL 46.4 WIDGET-ID 82
     IMAGE-48 AT ROW 4.81 COL 57.8 WIDGET-ID 84
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 106.86 BY 24.21
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert Custom SmartWindow title>"
         HEIGHT             = 20.57
         WIDTH              = 107.2
         MAX-HEIGHT         = 28.33
         MAX-WIDTH          = 195.2
         VIRTUAL-HEIGHT     = 28.33
         VIRTUAL-WIDTH      = 195.2
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-Integra IMAGE-48 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-Integra
/* Query rebuild information for BROWSE br-Integra
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttintegra-mft-wms-notas NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-Integra */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* <insert Custom SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* <insert Custom SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma w-window
ON CHOOSE OF bt-confirma IN FRAME F-Main /* Button 1 */
DO:

    EMPTY TEMP-TABLE ttintegra-mft-wms-notas.

    FOR EACH integra-mft-wms 
        WHERE integra-mft-wms.dt-integra >= INPUT FRAME {&FRAME-NAME} dt-integra-ini
          AND integra-mft-wms.dt-integra <= INPUT FRAME {&FRAME-NAME} dt-integra-fim NO-LOCK:

        FOR EACH integra-mft-wms-notas 
            WHERE integra-mft-wms-notas.cod-integra = integra-mft-wms.cod-integra 
              AND integra-mft-wms-notas.cod-estabel >= INPUT FRAME {&FRAME-NAME} cod-estabel-ini 
              AND integra-mft-wms-notas.cod-estabel <= INPUT FRAME {&FRAME-NAME} cod-estabel-fim 
              AND integra-mft-wms-notas.cdd-embarq  >= INPUT FRAME {&FRAME-NAME} nr-embarque-ini 
              AND integra-mft-wms-notas.cdd-embarq  <= INPUT FRAME {&FRAME-NAME} nr-embarque-fim
              AND integra-mft-wms-notas.nr-nota-fis >= INPUT FRAME {&FRAME-NAME} nr-nota-fis-ini 
              AND integra-mft-wms-notas.nr-nota-fis <= INPUT FRAME {&FRAME-NAME} nr-nota-fis-fim NO-LOCK:
            
            IF (integra-mft-wms-notas.cod-integra < INPUT FRAME {&FRAME-NAME} cod-integra-ini 
            OR  integra-mft-wms-notas.cod-integra > INPUT FRAME {&FRAME-NAME} cod-integra-fim) THEN NEXT.

            CREATE ttintegra-mft-wms-notas.
            BUFFER-COPY integra-mft-wms-notas TO ttintegra-mft-wms-notas.
            ASSIGN ttintegra-mft-wms-notas.dt-integra = integra-mft-wms.dt-integra.

        END. /* FOR EACH integra-mft-wms-notas */

    END. /* FOR EACH integra-mft-wms */


  {&OPEN-QUERY-br-Integra}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* Fechar */
DO:
  apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-Integra
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
  THEN DELETE WIDGET w-window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window  _DEFAULT-ENABLE
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
  DISPLAY dt-integra-ini dt-integra-fim cod-estabel-ini cod-estabel-fim 
          nr-embarque-ini nr-embarque-fim nr-nota-fis-ini nr-nota-fis-fim 
          cod-integra-ini cod-integra-fim 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE dt-integra-ini dt-integra-fim bt-confirma cod-estabel-ini 
         cod-estabel-fim nr-embarque-ini nr-embarque-fim nr-nota-fis-ini 
         nr-nota-fis-fim cod-integra-ini cod-integra-fim bt-ok RECT-1 IMAGE-1 
         IMAGE-2 IMAGE-39 IMAGE-40 IMAGE-41 IMAGE-42 IMAGE-45 IMAGE-46 IMAGE-47 
         IMAGE-48 br-Integra 
      WITH FRAME F-Main IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW w-window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-window 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-window 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}
  
  {utp/ut9000.i "ESWMP999" "1.12.00.001"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  ASSIGN dt-integra-ini:SCREEN-VALUE IN FRAME F-Main = STRING(TODAY)
       dt-integra-fim:SCREEN-VALUE IN FRAME F-Main = STRING(TODAY).
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ttintegra-mft-wms-notas"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-window 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

