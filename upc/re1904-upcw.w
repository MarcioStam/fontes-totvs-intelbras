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
{include/i-prgvrs.i re1904-upcw 2.06.000.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        re1904-upcw
&GLOBAL-DEFINE Version        2.06.000.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-entrada btOK btCancel bt-arquivo-entrada

/* Parameters Definitions ---                                           */
DEFINE OUTPUT PARAMETER p-arquivo-entrada AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-2 bt-arquivo-entrada ~
fi-entrada fi-layout BtOK BtCancel 
&Scoped-Define DISPLAYED-OBJECTS fi-entrada fi-layout 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arquivo-entrada 
     IMAGE-UP FILE "image/im-sea.gif":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE BUTTON BtCancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON BtOK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.13
     BGCOLOR 8 .

DEFINE VARIABLE fi-layout AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 54 BY 4.25 NO-UNDO.

DEFINE VARIABLE fi-entrada AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo Entrada" 
     VIEW-AS FILL-IN 
     SIZE 54 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 8.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-arquivo-entrada AT ROW 1.5 COL 75.43 WIDGET-ID 4
     fi-entrada AT ROW 1.54 COL 8.71 HELP
          "Nome do arquivo de importaá∆o" WIDGET-ID 2
     fi-layout AT ROW 2.75 COL 20.43 NO-LABEL WIDGET-ID 16
     BtOK AT ROW 10.79 COL 2 WIDGET-ID 14
     BtCancel AT ROW 10.79 COL 18 WIDGET-ID 12
     "Layout:" VIEW-AS TEXT
          SIZE 5.29 BY .54 AT ROW 2.75 COL 15 WIDGET-ID 56
     "Obs: A linha de cabeáalho deve ser informada conforme layout acima." VIEW-AS TEXT
          SIZE 53.57 BY .54 AT ROW 7.25 COL 20.43 WIDGET-ID 58
     rtToolBar AT ROW 10.63 COL 1
     RECT-2 AT ROW 1.25 COL 1.72 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 11.08
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
         HEIGHT             = 11.08
         WIDTH              = 90.29
         MAX-HEIGHT         = 28.33
         MAX-WIDTH          = 194.86
         VIRTUAL-HEIGHT     = 28.33
         VIRTUAL-WIDTH      = 194.86
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
/* SETTINGS FOR FILL-IN fi-entrada IN FRAME fpage0
   ALIGN-L                                                              */
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


&Scoped-define SELF-NAME bt-arquivo-entrada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo-entrada wWindow
ON CHOOSE OF bt-arquivo-entrada IN FRAME fpage0
DO:
    DEFINE VARIABLE c-arq-conv AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-ok       AS LOGICAL   NO-UNDO.

    ASSIGN c-arq-conv = REPLACE(fi-entrada:SCREEN-VALUE IN FRAME fPage0, "/", "~\").

    SYSTEM-DIALOG GET-FILE c-arq-conv
        FILTERS "*.csv" "*.csv",
                "*.*" "*.*"
        DEFAULT-EXTENSION "lst"
        INITIAL-DIR "spool" 
        USE-FILENAME
        UPDATE l-ok.

    IF  l-ok THEN
        ASSIGN fi-entrada:SCREEN-VALUE = REPLACE(c-arq-conv, "~\", "/").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtOK wWindow
ON CHOOSE OF BtOK IN FRAME fpage0 /* OK */
DO:
    IF  fi-entrada:SCREEN-VALUE = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Arquivo de importaá∆o deve ser informado.":U + '~~' +
                                                              "Para prosseguir deve informar o caminho/arquivo corretamente.":U + CHR(10) + 
                                                              "Utilize o bot∆o de busca.":U).

        APPLY 'entry':U TO fi-entrada IN FRAME fPage0.
        RETURN NO-APPLY.
    END.

    ASSIGN p-arquivo-entrada = fi-entrada:SCREEN-VALUE.

    APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN fi-layout:SCREEN-VALUE IN FRAME fPage0 = "Nr embarque" + CHR(13) +
                                                "123456" + CHR(13) +
                                                "123456a" + CHR(13) +
                                                "123456b".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

