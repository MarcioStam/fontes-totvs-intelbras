&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esclt002a 2.06.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esclt002a
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   brTarefas bt-sair
                              
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE OUTPUT PARAMETER pcod-tarefa   AS   INTEGER                    NO-UNDO.
DEFINE OUTPUT PARAMETER pdes-tarefa   AS   CHARACTER FORMAT "x(40)":U NO-UNDO.
DEFINE OUTPUT PARAMETER pnom_prog_ext LIKE prog_dtsul.nom_prog_ext    NO-UNDO.

/* Local Variable Definitions ---                                       */
{esp/es0018.i}
DEFINE VARIABLE c-programa AS CHARACTER NO-UNDO.

/* Temp-table Definitions ---                                           */
DEFINE TEMP-TABLE ttTarefas NO-UNDO
    FIELD cod-tarefa   AS   INTEGER
    FIELD cod-programa AS   CHARACTER
    FIELD des-tarefa   AS   CHARACTER FORMAT "x(40)":U
    FIELD nom_prog_ext LIKE prog_dtsul.nom_prog_ext
    INDEX ch-ind IS UNIQUE PRIMARY cod-tarefa.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTarefas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttTarefas

/* Definitions for BROWSE brTarefas                                     */
&Scoped-define FIELDS-IN-QUERY-brTarefas ttTarefas.cod-tarefa ttTarefas.cod-programa ttTarefas.des-tarefa   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTarefas   
&Scoped-define SELF-NAME brTarefas
&Scoped-define QUERY-STRING-brTarefas FOR EACH ttTarefas
&Scoped-define OPEN-QUERY-brTarefas OPEN QUERY {&SELF-NAME} FOR EACH ttTarefas.
&Scoped-define TABLES-IN-QUERY-brTarefas ttTarefas
&Scoped-define FIRST-TABLE-IN-QUERY-brTarefas ttTarefas


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brTarefas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brTarefas bt-sair 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-sair 
     LABEL "Sair(esc)" 
     SIZE 9 BY 1.13.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTarefas FOR 
      ttTarefas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTarefas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTarefas wWindow _FREEFORM
  QUERY brTarefas DISPLAY
      ttTarefas.cod-tarefa COLUMN-LABEL "Tarefa":U
    ttTarefas.cod-programa COLUMN-LABEL "Programa":U
    ttTarefas.des-tarefa COLUMN-LABEL "Descri‡Æo":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 42 BY 10
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     brTarefas AT ROW 1.42 COL 3 WIDGET-ID 200
     bt-sair AT ROW 11.88 COL 36.57 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 45.72 BY 12.5
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
         HEIGHT             = 12.5
         WIDTH              = 45.72
         MAX-HEIGHT         = 13.33
         MAX-WIDTH          = 45.72
         VIRTUAL-HEIGHT     = 13.33
         VIRTUAL-WIDTH      = 45.72
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
/* BROWSE-TAB brTarefas 1 fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTarefas
/* Query rebuild information for BROWSE brTarefas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttTarefas.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brTarefas */
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


&Scoped-define BROWSE-NAME brTarefas
&Scoped-define SELF-NAME brTarefas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTarefas wWindow
ON MOUSE-SELECT-DBLCLICK OF brTarefas IN FRAME fpage0
DO:
    APPLY "value-changed":U TO SELF.
    APPLY 'CLOSE' TO THIS-PROCEDURE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTarefas wWindow
ON RETURN OF brTarefas IN FRAME fpage0
DO:
    APPLY "mouse-select-dblclick":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTarefas wWindow
ON VALUE-CHANGED OF brTarefas IN FRAME fpage0
DO:
    IF AVAIL ttTarefas 
    THEN ASSIGN pcod-tarefa   = ttTarefas.cod-tarefa
                pdes-tarefa   = ttTarefas.des-tarefa
                pnom_prog_ext = ttTarefas.nom_prog_ext.
    ELSE ASSIGN pcod-tarefa   = 0
                pdes-tarefa   = "":U
                pnom_prog_ext = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair wWindow
ON CHOOSE OF bt-sair IN FRAME fpage0 /* Sair(esc) */
DO:
    APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    EMPTY TEMP-TABLE tt-prog-ponto NO-ERROR.
    EMPTY TEMP-TABLE ttTarefas     NO-ERROR.
    
    ASSIGN pcod-tarefa   = 0
           pdes-tarefa   = "":U
           pnom_prog_ext = "":U.

    RUN esp/es0018p.p (INPUT "esclt002", /* p-nome-programa */
                       INPUT 1,          /* p-ponto         */
                       INPUT 0,          /* p-sequencia     */
                       INPUT "",         /* p-conteudo      */
                       OUTPUT TABLE tt-prog-ponto).
    
    if  can-find(first tt-prog-ponto) then 
    for each tt-prog-ponto,
        first prog_dtsul no-lock
        where prog_dtsul.cod_prog_dtsul = entry(2, tt-prog-ponto.conteudo, ";"):
        create ttTarefas.
        assign ttTarefas.cod-tarefa   = int(entry(1, tt-prog-ponto.conteudo, ";"))
               ttTarefas.cod-programa = prog_dtsul.cod_prog_dtsul
               ttTarefas.des-tarefa   = prog_dtsul.nom_prog_dtsul_menu
               ttTarefas.nom_prog_ext = prog_dtsul.nom_prog_ext.
    end. /* for each tt-prog-ponto, */  

    {&OPEN-QUERY-brTarefas}
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

