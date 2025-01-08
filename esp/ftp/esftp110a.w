&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-faturamento-segmento-ordem NO-UNDO LIKE faturamento-segmento-ordem
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
{include/i-prgvrs.i ESFTP110A 2.04.00.000}

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
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP110
&GLOBAL-DEFINE Version        1

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 fl-unid-neg fl-segmento tg-exportar fl-periodo
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

&GLOBAL-DEFINE ttTable        tt-faturamento-segmento-ordem
&GLOBAL-DEFINE hDBOTable      bofaturamento-segmento-ordem
&GLOBAL-DEFINE DBOTable       faturamento-segmento-ordem

/* Parameters Definitions ---                                           */

DEFINE INPUT PARAM p-main  AS HANDLE    NO-UNDO.
DEFINE INPUT PARAM p-bo    AS HANDLE    NO-UNDO.
DEFINE INPUT PARAM p-acao  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAM p-rowid AS ROWID     NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE VARIABLE hProgramZoom AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEF VAR l-implanta AS LOGICAL NO-UNDO.

{method/dbotterr.i}
{upc/btb910za-upc.i} /*Defini‡Æo do estabelecimento do usu rio */

DEF TEMP-TABLE rowerrorsext LIKE RowErrors.

DEF NEW GLOBAL SHARED VAR gs-hbrowse AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR gs-hbo AS HANDLE NO-UNDO.

DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEFINE VARIABLE v-sequencia  AS INTEGER NO-UNDO.
DEFINE VARIABLE d-aux        AS DATE NO-UNDO.

DEFINE VARIABLE dt-ini AS DATE.
DEFINE VARIABLE dt-fim AS DATE.

DEFINE VARIABLE iqtd         AS INTEGER NO-UNDO.
DEFINE VARIABLE c-acao       AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-sel        AS LOGICAL NO-UNDO.

DEFINE BUFFER b-faturamento FOR faturamento.

DEFINE TEMP-TABLE tt-faturamento
    FIELD periodo AS CHAR.


{&hDBOTable} = p-bo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-faturamento-segmento-ordem

/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define FIELDS-IN-QUERY-DEFAULT-FRAME ~
tt-faturamento-segmento-ordem.ordem tt-faturamento-segmento-ordem.mercado 
&Scoped-define ENABLED-FIELDS-IN-QUERY-DEFAULT-FRAME ~
tt-faturamento-segmento-ordem.ordem tt-faturamento-segmento-ordem.mercado 
&Scoped-define ENABLED-TABLES-IN-QUERY-DEFAULT-FRAME ~
tt-faturamento-segmento-ordem
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-DEFAULT-FRAME tt-faturamento-segmento-ordem
&Scoped-define QUERY-STRING-DEFAULT-FRAME FOR EACH tt-faturamento-segmento-ordem SHARE-LOCK
&Scoped-define OPEN-QUERY-DEFAULT-FRAME OPEN QUERY DEFAULT-FRAME FOR EACH tt-faturamento-segmento-ordem SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-DEFAULT-FRAME tt-faturamento-segmento-ordem
&Scoped-define FIRST-TABLE-IN-QUERY-DEFAULT-FRAME tt-faturamento-segmento-ordem


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-faturamento-segmento-ordem.ordem ~
tt-faturamento-segmento-ordem.mercado 
&Scoped-define ENABLED-TABLES tt-faturamento-segmento-ordem
&Scoped-define FIRST-ENABLED-TABLE tt-faturamento-segmento-ordem
&Scoped-Define ENABLED-OBJECTS fl-periodo-fim fl-periodo-ini tg-exportar ~
fl-segmento fl-unid-neg btOK btSave btHelp btCancel rtKeys rtToolBar ~
RECT-46 IMAGE-3 IMAGE-2 
&Scoped-Define DISPLAYED-FIELDS tt-faturamento-segmento-ordem.ordem ~
tt-faturamento-segmento-ordem.mercado 
&Scoped-define DISPLAYED-TABLES tt-faturamento-segmento-ordem
&Scoped-define FIRST-DISPLAYED-TABLE tt-faturamento-segmento-ordem
&Scoped-Define DISPLAYED-OBJECTS fl-periodo-fim fl-periodo-ini tg-exportar ~
fl-segmento fl-unid-neg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp  NO-FOCUS
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fl-periodo-fim AS CHARACTER FORMAT "9999/99":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fl-periodo-ini AS CHARACTER FORMAT "9999/99":U 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fl-segmento AS CHARACTER FORMAT "X(30)":U 
     LABEL "Segmento" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE fl-unid-neg AS CHARACTER FORMAT "X(20)":U 
     LABEL "Unid Neg" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 2.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 8.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 63 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-exportar AS LOGICAL INITIAL no 
     LABEL "Exportar Valores Para Faturamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY DEFAULT-FRAME FOR 
      tt-faturamento-segmento-ordem SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     fl-periodo-fim AT ROW 8 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     fl-periodo-ini AT ROW 8 COL 18 COLON-ALIGNED WIDGET-ID 34
     tg-exportar AT ROW 7 COL 10 WIDGET-ID 30
     fl-segmento AT ROW 4 COL 16 COLON-ALIGNED WIDGET-ID 28
     fl-unid-neg AT ROW 5.25 COL 16 COLON-ALIGNED WIDGET-ID 26
     btOK AT ROW 10 COL 2
     btSave AT ROW 10 COL 12
     btHelp AT ROW 10 COL 53
     btCancel AT ROW 10 COL 22
     tt-faturamento-segmento-ordem.ordem AT ROW 1.5 COL 16 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-faturamento-segmento-ordem.mercado AT ROW 2.75 COL 16 COLON-ALIGNED NO-LABEL WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     "Mercado:" VIEW-AS TEXT
          SIZE 7 BY .75 AT ROW 2.75 COL 11 WIDGET-ID 22
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 9.75 COL 1
     RECT-46 AT ROW 6.75 COL 7 WIDGET-ID 32
     IMAGE-3 AT ROW 8 COL 28 WIDGET-ID 36
     IMAGE-2 AT ROW 8 COL 36 WIDGET-ID 38
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 63.43 BY 10.38
         FONT 1
         CANCEL-BUTTON btCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Temp-Tables and Buffers:
      TABLE: tt-faturamento-segmento-ordem T "?" NO-UNDO mgesp faturamento-segmento-ordem
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "esftp110a"
         HEIGHT             = 10.46
         WIDTH              = 63.86
         MAX-HEIGHT         = 28.33
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.33
         VIRTUAL-WIDTH      = 195.14
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME Custom                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _TblList          = "Temp-Tables.tt-faturamento-segmento-ordem"
     _Query            is OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* esftp110a */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* esftp110a */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME DEFAULT-FRAME /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp C-Win
ON CHOOSE OF btHelp IN FRAME DEFAULT-FRAME /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME DEFAULT-FRAME /* OK */
DO:

    IF tg-exportar:CHECKED THEN DO:

        RUN pi-registro.

    END.

    RUN saveRecord.
    IF RETURN-VALUE NE "nok" THEN APPLY "Close" TO THIS-PROCEDURE.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave C-Win
ON CHOOSE OF btSave IN FRAME DEFAULT-FRAME /* Salvar */
DO:
  RUN saveRecord.
  /*IF RETURN-VALUE NE "nok" THEN APPLY "entry" TO ttitem-tipo-loc.cod-depos. */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-exportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-exportar C-Win
ON VALUE-CHANGED OF tg-exportar IN FRAME DEFAULT-FRAME /* Exportar Valores Para Faturamento */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        CASE SELF:SCREEN-VALUE:
            WHEN "YES":U THEN DO:
            ASSIGN fl-periodo-ini:VISIBLE  = YES 
                   fl-periodo-fim:VISIBLE  = YES
                   IMAGE-2:VISIBLE         = YES
                   IMAGE-3:VISIBLE         = YES.

        END.
            WHEN "NO":U then do:
            ASSIGN fl-periodo-ini:VISIBLE  = NO
                   fl-periodo-fim:VISIBLE  = NO
                   IMAGE-2:VISIBLE         = NO
                   IMAGE-3:VISIBLE         = NO.
            
            END.
        END CASE.
    
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
FOR FIRST prog_dtsul FIELDS (nom_prog_dtsul_menu) NO-LOCK
    WHERE prog_dtsul.cod_prog_dtsul = "{&Program}":
    ASSIGN C-Win:TITLE = SUBSTITUTE("&1 - &2 - &3",
                                             trim(prog_dtsul.nom_prog_dtsul_menu),
                                             "ESFTP110A", "{&Version}").

END.

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
  
  IF p-rowid NE ? THEN DO:

      RUN repositionRecord IN p-bo (INPUT p-rowid).
      RUN getRecord IN p-bo (OUTPUT TABLE tt-faturamento-segmento-ordem).
      
      FOR FIRST tt-faturamento-segmento-ordem:
          
          ASSIGN fl-segmento = tt-faturamento-segmento-ordem.segmento 
                 fl-unid-neg = tt-faturamento-segmento-ordem.unid-neg
                 fl-periodo-ini:VISIBLE  = NO
                 fl-periodo-fim:VISIBLE  = NO
                 IMAGE-3:VISIBLE = NO
                 IMAGE-2:VISIBLE = NO.
          
          DISPLAY tt-faturamento-segmento-ordem.ordem
                  fl-segmento
                  fl-unid-neg
                  tt-faturamento-segmento-ordem.mercado WITH FRAME {&FRAME-NAME}.

          APPLY "LEAVE" TO tt-faturamento-segmento-ordem.ordem    IN FRAME {&FRAME-NAME}.
          APPLY "LEAVE" TO tt-faturamento-segmento-ordem.mercado  IN FRAME {&FRAME-NAME}. 
          APPLY "LEAVE" TO fl-segmento                            IN FRAME {&FRAME-NAME}. 
          APPLY "LEAVE" TO fl-unid-neg                            IN FRAME {&FRAME-NAME}.
          APPLY "VALUE-CHANGED" TO tg-exportar                    IN FRAME {&FRAME-NAME}.
          APPLY "LEAVE" TO fl-periodo-ini                         IN FRAME {&FRAME-NAME}.  
          
          APPLY "ENTRY" TO tt-faturamento-segmento-ordem.ordem    IN FRAME {&FRAME-NAME}.
          APPLY "ENTRY" TO tt-faturamento-segmento-ordem.mercado  IN FRAME {&FRAME-NAME}.
          APPLY "ENTRY" TO fl-segmento                            IN FRAME {&FRAME-NAME}.
          APPLY "ENTRY" TO fl-unid-neg                            IN FRAME {&FRAME-NAME}.
          APPLY "ENTRY" TO fl-periodo-fim                         IN FRAME {&FRAME-NAME}. 
      END.
  
  END.

  APPLY "ENTRY" TO tt-faturamento-segmento-ordem.ordem    IN FRAME {&FRAME-NAME}.
  APPLY "ENTRY" TO tt-faturamento-segmento-ordem.mercado  IN FRAME {&FRAME-NAME}.
  APPLY "ENTRY" TO fl-segmento                            IN FRAME {&FRAME-NAME}.   
  APPLY "ENTRY" TO fl-unid-neg                            IN FRAME {&FRAME-NAME}.
  APPLY "VALUE-CHANGED" TO tg-exportar                    IN FRAME {&FRAME-NAME}.
  APPLY "ENTRY" TO fl-periodo-fim                         IN FRAME {&FRAME-NAME}. 
  
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

  {&OPEN-QUERY-DEFAULT-FRAME}
  GET FIRST DEFAULT-FRAME.
  DISPLAY fl-periodo-fim fl-periodo-ini tg-exportar fl-segmento fl-unid-neg 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  IF AVAILABLE tt-faturamento-segmento-ordem THEN 
    DISPLAY tt-faturamento-segmento-ordem.ordem 
          tt-faturamento-segmento-ordem.mercado 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE fl-periodo-fim fl-periodo-ini tg-exportar fl-segmento fl-unid-neg btOK 
         btSave btHelp btCancel tt-faturamento-segmento-ordem.ordem 
         tt-faturamento-segmento-ordem.mercado rtKeys rtToolBar RECT-46 IMAGE-3 
         IMAGE-2 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-registro C-Win 
PROCEDURE pi-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH b-faturamento NO-LOCK
    WHERE b-faturamento.periodo >= INPUT FRAME {&FRAME-NAME} fl-periodo-ini
      AND b-faturamento.periodo <= INPUT FRAME {&FRAME-NAME} fl-periodo-fim:

    CREATE tt-faturamento.
    ASSIGN tt-faturamento.periodo = b-faturamento.periodo.
    
END.

FOR EACH tt-faturamento NO-LOCK:
    
    FIND FIRST faturamento EXCLUSIVE-LOCK
        WHERE faturamento.periodo = tt-faturamento.periodo
          AND faturamento.segmento = INPUT FRAME {&FRAME-NAME} fl-segmento NO-ERROR.
    
    IF AVAIL faturamento THEN DO:
        ASSIGN faturamento.periodo  = tt-faturamento.periodo                                          
               faturamento.segmento = INPUT FRAME {&FRAME-NAME} fl-segmento                           
               faturamento.unid-neg = INPUT FRAME {&FRAME-NAME} fl-unid-neg                           
               faturamento.mercado  = INPUT FRAME {&FRAME-NAME} tt-faturamento-segmento-ordem.mercado.
        
    END.
    ELSE DO:
   
        CREATE faturamento.
        ASSIGN faturamento.periodo  = tt-faturamento.periodo
               faturamento.segmento = INPUT FRAME {&FRAME-NAME} fl-segmento 
               faturamento.unid-neg = INPUT FRAME {&FRAME-NAME} fl-unid-neg 
               faturamento.mercado  = INPUT FRAME {&FRAME-NAME} tt-faturamento-segmento-ordem.mercado.

        FIND FIRST faturamento-segmento-ordem EXCLUSIVE-LOCK
            WHERE faturamento-segmento-ordem.ordem    = 0
              AND faturamento-segmento-ordem.unid-neg = INPUT FRAME {&FRAME-NAME} fl-segmento                          
              AND faturamento-segmento-ordem.segmento = INPUT FRAME {&FRAME-NAME} fl-unid-neg                          
              AND faturamento-segmento-ordem.mercado  = INPUT FRAME {&FRAME-NAME} tt-faturamento-segmento-ordem.mercado
            NO-ERROR.
        IF NOT AVAIL faturamento-segmento-ordem THEN DO:

            CREATE faturamento-segmento-ordem.
            ASSIGN faturamento-segmento-ordem.ordem    = 0 
                   faturamento-segmento-ordem.unid-neg = INPUT FRAME {&FRAME-NAME} fl-segmento                           
                   faturamento-segmento-ordem.segmento = INPUT FRAME {&FRAME-NAME} fl-unid-neg                           
                   faturamento-segmento-ordem.mercado  = INPUT FRAME {&FRAME-NAME} tt-faturamento-segmento-ordem.mercado.

        END.

    END.


END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecord C-Win 
PROCEDURE saveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hShowMsg AS HANDLE NO-UNDO.
DEFINE VARIABLE r-rowid  AS ROWID NO-UNDO.

IF p-acao = "UPDATE" THEN
    ASSIGN r-rowid  = tt-faturamento-segmento-ordem.r-rowid.

EMPTY TEMP-TABLE tt-faturamento-segmento-ordem.

CREATE tt-faturamento-segmento-ordem.
ASSIGN tt-faturamento-segmento-ordem.ordem    = INPUT FRAME {&FRAME-NAME} tt-faturamento-segmento-ordem.ordem     
       tt-faturamento-segmento-ordem.segmento = INPUT FRAME {&FRAME-NAME} fl-segmento
       tt-faturamento-segmento-ordem.unid-neg = INPUT FRAME {&FRAME-NAME} fl-unid-neg
       tt-faturamento-segmento-ordem.mercado  = INPUT FRAME {&FRAME-NAME} tt-faturamento-segmento-ordem.mercado
       tt-faturamento-segmento-ordem.r-rowid  = r-rowid.

RUN emptyRowErrors IN {&hDBOTable} NO-ERROR.
RUN setrecord IN {&hDBOTable} (INPUT TABLE tt-faturamento-segmento-ordem).

IF p-rowid NE ? AND p-acao = "UPDATE" THEN DO:
    RUN updateRecord IN {&hDBOTable}.
END.

ELSE DO:
     RUN createRecord IN {&hDBOTable}. 
END.
RUN getrowerrors IN {&hDBOTable} (OUTPUT TABLE rowerrors).
FOR FIRST rowerrorsext:
    CREATE RowErrors.
    BUFFER-COPY rowerrorsext TO RowErrors.
END.
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
    {method/ShowMessage.i1}.
    {method/ShowMessage.i2 &Modal="YES"}.
    {method/ShowMessage.i3}.
    RETURN "NOK".
END.

IF VALID-HANDLE(p-main) THEN do:
    RUN goToKey IN {&hDBOTable} (INPUT tt-faturamento-segmento-ordem.ordem,
                                 INPUT fl-segmento,
                                 INPUT fl-unid-neg,
                                 INPUT tt-faturamento-segmento-ordem.mercado).

    RUN getRowid IN {&hDBOTable} (OUTPUT r-rowid).
    IF p-rowid NE ? THEN
        RUN updateRow IN p-main (INPUT r-rowid).
    ELSE 
        RUN insertNewRow IN p-main (INPUT r-rowid).

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

