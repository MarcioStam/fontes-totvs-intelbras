&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i esbcp000 2.06.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esbcp000
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-tarefa bt-ok bt-sair
                              
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */


/* Local Variable Definitions ---                                       */
{esp/es0018.i}
DEF VAR c-programa AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-tarefa bt-ok bt-sair 
&Scoped-Define DISPLAYED-OBJECTS fi-tarefa fi-descricao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ok 
     LABEL "Ok(ent)" 
     SIZE-PIXELS 63 BY 27
     FONT 4.

DEFINE BUTTON bt-sair 
     LABEL "Sair(esc)" 
     SIZE-PIXELS 63 BY 27
     FONT 4.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 231 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-tarefa AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Tarefa" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 42 BY 21
     FONT 4 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-tarefa AT Y 111 X 49 COLON-ALIGNED WIDGET-ID 4
     fi-descricao AT Y 135 X 49 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     bt-ok AT Y 261 X 179 WIDGET-ID 12
     bt-sair AT Y 261 X 249 WIDGET-ID 10
     "F1 - Lista Tarefas" VIEW-AS TEXT
          SIZE-PIXELS 112 BY 13 AT Y 271 X 10 WIDGET-ID 8
          FONT 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT X 0 Y 0 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


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
         HEIGHT-P           = 300
         WIDTH-P            = 320
         MAX-HEIGHT-P       = 702
         MAX-WIDTH-P        = 1366
         VIRTUAL-HEIGHT-P   = 702
         VIRTUAL-WIDTH-P    = 1366
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 4
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
   FRAME-NAME Size-to-Fit                                               */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN fi-descricao IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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
  /* IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY. */
    APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  /* APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY. */
    APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok wWindow
ON CHOOSE OF bt-ok IN FRAME fpage0 /* Ok(ent) */
DO:
    FOR EACH tt-prog-ponto: DELETE tt-prog-ponto. END.
    ASSIGN fi-descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
           c-programa = "".
    
    RUN esp/es0018p.p (INPUT "esclt002", /* p-nome-programa */
                       INPUT 1,          /* p-ponto         */
                       INPUT 0,          /* p-sequencia     */
                       INPUT "",         /* p-conteudo      */
                       OUTPUT TABLE tt-prog-ponto).
    
    IF  INPUT FRAME {&FRAME-NAME} fi-tarefa = 0 THEN DO:
        MESSAGE "Tarefa dever ser informada." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.
    END.
    
    if  can-find(first tt-prog-ponto) 
    then for first tt-prog-ponto
             where int(entry(1, tt-prog-ponto.conteudo, ";")) = INPUT FRAME {&FRAME-NAME} fi-tarefa:

             FIND FIRST prog_dtsul NO-LOCK
                 WHERE prog_dtsul.cod_prog_dtsul = entry(2, tt-prog-ponto.conteudo, ";") NO-ERROR.
             IF  AVAIL prog_dtsul 
             THEN ASSIGN fi-descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = prog_dtsul.nom_prog_dtsul_menu
                         c-programa = prog_dtsul.nom_prog_ext.
             ELSE ASSIGN fi-descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                         c-programa = "".
         end. /* for first tt-prog-ponto: */  
    else ASSIGN fi-descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                c-programa = "".
     
    IF  c-programa <> "" THEN DO:
        {&WINDOW-NAME}:SENSITIVE = NO.
        {&WINDOW-NAME}:HIDDEN    = YES.
        RUN VALUE(c-programa).
        {&WINDOW-NAME}:HIDDEN    = NO.
        {&WINDOW-NAME}:SENSITIVE = YES.
    END. /* IF  c-programa */
    ELSE MESSAGE "Programa " TRIM(c-programa) " n∆o encontrado." SKIP "Verifique o cadastro de programas do EMS." VIEW-AS ALERT-BOX ERROR BUTTONS OK.

    APPLY 'ENTRY':U TO fi-tarefa IN FRAME {&FRAME-NAME}.
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


&Scoped-define SELF-NAME fi-tarefa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tarefa wWindow
ON ENTER OF fi-tarefa IN FRAME fpage0 /* Tarefa */
DO:
    APPLY 'choose':U TO bt-ok IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tarefa wWindow
ON ENTRY OF fi-tarefa IN FRAME fpage0 /* Tarefa */
DO:
  IF  fi-tarefa:SET-SELECTION(1,200) THEN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tarefa wWindow
ON F1 OF fi-tarefa IN FRAME fpage0 /* Tarefa */
DO:
    {&WINDOW-NAME}:SENSITIVE = NO.
    {&WINDOW-NAME}:HIDDEN    = YES.
    RUN esp/bcp/esbcp000a.w(OUTPUT fi-tarefa, OUTPUT fi-descricao, OUTPUT c-programa).


    {&WINDOW-NAME}:HIDDEN    = NO.
    {&WINDOW-NAME}:SENSITIVE = YES.

    DISP fi-tarefa fi-descricao WITH FRAME fPage0.

    APPLY "ENTRY":U TO fi-tarefa IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tarefa wWindow
ON RETURN OF fi-tarefa IN FRAME fpage0 /* Tarefa */
DO:
    APPLY 'choose':U TO bt-ok IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


