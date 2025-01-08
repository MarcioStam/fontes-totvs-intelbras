&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttreporte-seletivo NO-UNDO LIKE reporte-seletivo
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
{include/i-prgvrs.i ESCPP010 2.04.00.000}

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
&GLOBAL-DEFINE Program        ESCPP010
&GLOBAL-DEFINE Version        1

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

&GLOBAL-DEFINE ttTable        ttreporte-seletivo
&GLOBAL-DEFINE hDBOTable      boreporte-seletivo
&GLOBAL-DEFINE DBOTable       reporte-seletivo

/* Parameters Definitions ---                                           */
DEF INPUT PARAM p-main AS HANDLE NO-UNDO.
DEF INPUT PARAM p-bo AS HANDLE NO-UNDO.
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEF VAR l-implanta AS LOGICAL NO-UNDO.
{method/dbotterr.i}

DEF TEMP-TABLE rowerrorsext LIKE RowErrors.

DEF NEW GLOBAL SHARED VAR gs-hbrowse AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR gs-hbo AS HANDLE NO-UNDO.

DEF VAR {&hDBOTable} AS HANDLE NO-UNDO.

{&hDBOTable} = p-bo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttreporte-seletivo item

/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define FIELDS-IN-QUERY-DEFAULT-FRAME ttreporte-seletivo.it-codigo ~
ttreporte-seletivo.data-inicial ttreporte-seletivo.data-final ~
ttreporte-seletivo.quantidade ttreporte-seletivo.tipo ~
ttreporte-seletivo.es-codigo ttreporte-seletivo.qtd-unitaria 
&Scoped-define ENABLED-FIELDS-IN-QUERY-DEFAULT-FRAME ~
ttreporte-seletivo.it-codigo ttreporte-seletivo.data-inicial ~
ttreporte-seletivo.data-final ttreporte-seletivo.quantidade ~
ttreporte-seletivo.tipo ttreporte-seletivo.es-codigo ~
ttreporte-seletivo.qtd-unitaria 
&Scoped-define ENABLED-TABLES-IN-QUERY-DEFAULT-FRAME ttreporte-seletivo
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-DEFAULT-FRAME ttreporte-seletivo
&Scoped-define QUERY-STRING-DEFAULT-FRAME FOR EACH ttreporte-seletivo SHARE-LOCK, ~
      EACH item WHERE TRUE /* Join to ttreporte-seletivo incomplete */ SHARE-LOCK
&Scoped-define OPEN-QUERY-DEFAULT-FRAME OPEN QUERY DEFAULT-FRAME FOR EACH ttreporte-seletivo SHARE-LOCK, ~
      EACH item WHERE TRUE /* Join to ttreporte-seletivo incomplete */ SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-DEFAULT-FRAME ttreporte-seletivo item
&Scoped-define FIRST-TABLE-IN-QUERY-DEFAULT-FRAME ttreporte-seletivo
&Scoped-define SECOND-TABLE-IN-QUERY-DEFAULT-FRAME item


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttreporte-seletivo.it-codigo ~
ttreporte-seletivo.data-inicial ttreporte-seletivo.data-final ~
ttreporte-seletivo.quantidade ttreporte-seletivo.tipo ~
ttreporte-seletivo.es-codigo ttreporte-seletivo.qtd-unitaria 
&Scoped-define ENABLED-TABLES ttreporte-seletivo
&Scoped-define FIRST-ENABLED-TABLE ttreporte-seletivo
&Scoped-Define ENABLED-OBJECTS btCancel btHelp btOK btSave RECT-1 rtKeys ~
rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttreporte-seletivo.it-codigo ~
ttreporte-seletivo.data-inicial ttreporte-seletivo.data-final ~
ttreporte-seletivo.quantidade ttreporte-seletivo.tipo ~
ttreporte-seletivo.es-codigo ttreporte-seletivo.qtd-unitaria 
&Scoped-define DISPLAYED-TABLES ttreporte-seletivo
&Scoped-define FIRST-DISPLAYED-TABLE ttreporte-seletivo
&Scoped-Define DISPLAYED-OBJECTS fi-desc-item fi-desc-componente 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel  NO-FOCUS
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp  NO-FOCUS
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK  NO-FOCUS
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-desc-componente AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 31 BY 1.75.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 9.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY DEFAULT-FRAME FOR 
      ttreporte-seletivo, 
      item SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btCancel AT ROW 10.25 COL 24
     btHelp AT ROW 10.25 COL 80.29
     ttreporte-seletivo.it-codigo AT ROW 1.17 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     fi-desc-item AT ROW 1.17 COL 31.72 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     btOK AT ROW 10.25 COL 2
     ttreporte-seletivo.data-inicial AT ROW 2.17 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttreporte-seletivo.data-final AT ROW 3.17 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttreporte-seletivo.quantidade AT ROW 4.17 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     ttreporte-seletivo.tipo AT ROW 6 COL 16 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Entrada", yes,
"Sa¡da", no
          SIZE 24 BY .88 TOOLTIP "Digite E para Entrada ou S para Sa¡da"
     ttreporte-seletivo.es-codigo AT ROW 7.75 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     fi-desc-componente AT ROW 7.75 COL 31.72 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     ttreporte-seletivo.qtd-unitaria AT ROW 8.75 COL 14 COLON-ALIGNED
          LABEL "Quantidade Unit ria"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     btSave AT ROW 10.25 COL 13
     RECT-1 AT ROW 5.5 COL 10
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 10 COL 1
     "Tipo:" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 5.25 COL 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 10.54
         FONT 1
         DEFAULT-BUTTON btSave CANCEL-BUTTON btCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttreporte-seletivo T "?" NO-UNDO mgesp reporte-seletivo
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
         TITLE              = "<insert window title>"
         HEIGHT             = 10.5
         WIDTH              = 90
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 16
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* SETTINGS FOR FILL-IN fi-desc-componente IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-componente:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-item:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN ttreporte-seletivo.qtd-unitaria IN FRAME DEFAULT-FRAME
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _TblList          = "Temp-Tables.ttreporte-seletivo,mgcad.item WHERE Temp-Tables.ttreporte-seletivo ..."
     _Query            is OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
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
  IF RETURN-VALUE NE "nok" THEN APPLY "entry" TO ttreporte-seletivo.es-codigo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttreporte-seletivo.es-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttreporte-seletivo.es-codigo C-Win
ON F5 OF ttreporte-seletivo.es-codigo IN FRAME DEFAULT-FRAME /* Componente */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in172.r"
                       &campo="ttreporte-seletivo.es-codigo"    
                       &campo2="fi-desc-componente"
                       &campozoom="it-codigo"
                       &campozoom2="desc-item"
                       &frame="{&frame-name}"
                       &frame2="{&frame-name}"}

    IF VALID-HANDLE(wh-pesquisa) THEN
        WAIT-FOR CLOSE OF wh-pesquisa.

    APPLY "entry" TO ttreporte-seletivo.es-codigo IN FRAME {&frame-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttreporte-seletivo.es-codigo C-Win
ON LEAVE OF ttreporte-seletivo.es-codigo IN FRAME DEFAULT-FRAME /* Componente */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=fi-desc-componente
                     &where="item.it-codigo = ttreporte-seletivo.es-codigo:screen-value in frame {&frame-name}"}
    EMPTY TEMP-TABLE rowerrorsext.                 
    RUN validaComponente.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttreporte-seletivo.es-codigo C-Win
ON MOUSE-SELECT-DBLCLICK OF ttreporte-seletivo.es-codigo IN FRAME DEFAULT-FRAME /* Componente */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttreporte-seletivo.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttreporte-seletivo.it-codigo C-Win
ON F5 OF ttreporte-seletivo.it-codigo IN FRAME DEFAULT-FRAME /* Item */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in172.r"
                       &campo="ttreporte-seletivo.it-codigo"    
                       &campo2="fi-desc-item"
                       &campozoom="it-codigo"
                       &campozoom2="desc-item"
                       &frame="{&frame-name}"
                       &frame2="{&frame-name}"}

    IF VALID-HANDLE(wh-pesquisa) THEN
        WAIT-FOR CLOSE OF wh-pesquisa.

    APPLY "entry" TO ttreporte-seletivo.it-codigo IN FRAME {&frame-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttreporte-seletivo.it-codigo C-Win
ON LEAVE OF ttreporte-seletivo.it-codigo IN FRAME DEFAULT-FRAME /* Item */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=fi-desc-item
                     &where="item.it-codigo = ttreporte-seletivo.it-codigo:screen-value in frame {&frame-name}"}
                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttreporte-seletivo.it-codigo C-Win
ON MOUSE-SELECT-DBLCLICK OF ttreporte-seletivo.it-codigo IN FRAME DEFAULT-FRAME /* Item */
DO:
    APPLY "f5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttreporte-seletivo.tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttreporte-seletivo.tipo C-Win
ON ANY-PRINTABLE OF ttreporte-seletivo.tipo IN FRAME DEFAULT-FRAME
DO:
  CASE caps(keylabel(LASTKEY)):
      WHEN "E" THEN ttreporte-seletivo.tipo:SCREEN-VALUE = "yes".
      WHEN "S" THEN ttreporte-seletivo.tipo:SCREEN-VALUE = "no".
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ttreporte-seletivo.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME {&frame-name}.
ttreporte-seletivo.es-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME {&frame-name}.
ttreporte-seletivo.tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "yes".
FOR FIRST prog_dtsul FIELDS (nom_prog_dtsul_menu) NO-LOCK
    WHERE prog_dtsul.cod_prog_dtsul = "{&Program}":
    ASSIGN C-Win:TITLE = SUBSTITUTE("&1 - &2 - &3",
                                             trim(prog_dtsul.nom_prog_dtsul_menu),
                                             "ESCPP010A", "{&Version}").
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
  DISPLAY fi-desc-item fi-desc-componente 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  IF AVAILABLE ttreporte-seletivo THEN 
    DISPLAY ttreporte-seletivo.it-codigo ttreporte-seletivo.data-inicial 
          ttreporte-seletivo.data-final ttreporte-seletivo.quantidade 
          ttreporte-seletivo.tipo ttreporte-seletivo.es-codigo 
          ttreporte-seletivo.qtd-unitaria 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE btCancel btHelp ttreporte-seletivo.it-codigo btOK 
         ttreporte-seletivo.data-inicial ttreporte-seletivo.data-final 
         ttreporte-seletivo.quantidade ttreporte-seletivo.tipo 
         ttreporte-seletivo.es-codigo ttreporte-seletivo.qtd-unitaria btSave 
         RECT-1 rtKeys rtToolBar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
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
DEF VAR hShowMsg AS HANDLE NO-UNDO.
DEF VAR r-rowid AS ROWID NO-UNDO.

EMPTY TEMP-TABLE ttreporte-seletivo.
CREATE ttreporte-seletivo.
ASSIGN ttreporte-seletivo.it-codigo    = INPUT FRAME {&FRAME-NAME} ttreporte-seletivo.it-codigo     
       ttreporte-seletivo.data-inicial = INPUT FRAME {&FRAME-NAME} ttreporte-seletivo.data-inicial
       ttreporte-seletivo.data-final   = INPUT FRAME {&FRAME-NAME} ttreporte-seletivo.data-final
       ttreporte-seletivo.quantidade   = INPUT FRAME {&FRAME-NAME} ttreporte-seletivo.quantidade
       ttreporte-seletivo.tipo         = INPUT FRAME {&FRAME-NAME} ttreporte-seletivo.tipo
       ttreporte-seletivo.es-codigo    = INPUT FRAME {&FRAME-NAME} ttreporte-seletivo.es-codigo
       ttreporte-seletivo.qtd-unitaria = INPUT FRAME {&FRAME-NAME} ttreporte-seletivo.qtd-unitaria.


RUN emptyRowErrors IN {&hDBOTable} NO-ERROR.        
RUN setrecord IN {&hDBOTable} (INPUT TABLE ttreporte-seletivo).  
RUN createrecord IN {&hDBOTable}.                        
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
    RUN goToKey IN {&hDBOTable} (INPUT ttreporte-seletivo.it-codigo,
                                 INPUT ttreporte-seletivo.es-codigo,
                                 INPUT ttreporte-seletivo.data-inicial,
                                 INPUT ttreporte-seletivo.data-final,
                                 INPUT ttreporte-seletivo.tipo).
    RUN getRowid IN {&hDBOTable} (OUTPUT r-rowid).
    RUN insertNewRow IN p-main (INPUT r-rowid).
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaComponente C-Win 
PROCEDURE validaComponente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR hShowMsg AS HANDLE NO-UNDO.
    DEF VAR de-qtd-unitaria AS DECIMAL NO-UNDO.
    IF INPUT FRAME {&FRAME-NAME} ttreporte-seletivo.tipo = NO THEN DO:
        RUN emptyRowErrors IN {&hDBOTable} NO-ERROR.        
        RUN buscaQuantidadeUnitaria IN {&hDBOTable} (INPUT ttreporte-seletivo.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                                     INPUT ttreporte-seletivo.es-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                                     OUTPUT de-qtd-unitaria).

        IF RETURN-VALUE = "NOK" THEN DO:
            RUN getrowerrors IN {&hDBOTable} (OUTPUT TABLE rowerrorsext).
        END.

        DISP de-qtd-unitaria @ ttreporte-seletivo.qtd-unitaria WITH FRAME {&FRAME-NAME}.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

