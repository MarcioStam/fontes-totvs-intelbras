&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i esclt006 2.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esclt006
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   bt-yes bt-no
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE INPUT PARAMETER p-mensagem   AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p-pergunta   AS LOGICAL  NO-UNDO.

/* Comandos para emiss∆o de Som */
&GLOB SND_ASYNC 1
&GLOB SND_NODEFAULT 2
&GLOB SND_LOOP 8
&GLOB SND_PURGE 64
&GLOB SND_APPLICATION 128
&GLOB SND_ALIAS 65536
&GLOB SND_FILENAME 131072
&GLOB SND_RESOURCE 262148
 
PROCEDURE PlaySoundA EXTERNAL "winmm.dll" PERSISTENT :
  DEFINE INPUT PARAMETER  pszSound    AS LONG.
  DEFINE INPUT PARAMETER  hmod        AS LONG.
  DEFINE INPUT PARAMETER  fdwSound    AS LONG.
  DEFINE RETURN PARAMETER ReturnValue AS LONG.
END PROCEDURE.
   
DEFINE VARIABLE ReturnValue AS INTEGER NO-UNDO.
DEFINE VARIABLE szSound     AS MEMPTR  NO-UNDO.
DEFINE VARIABLE wavfile     AS CHARACTER    NO-UNDO.
 
wavfile = "c:\windows\media\corte.wav".
SET-SIZE(szSound) = LENGTH(wavfile, "raw":U) + 1.
PUT-STRING(szSound,1) = wavfile.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar ed-mensagem bt-yes bt-no 
&Scoped-Define DISPLAYED-OBJECTS ed-mensagem 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-no 
     LABEL "N∆o (n)" 
     SIZE-PIXELS 70 BY 24
     FONT 4.

DEFINE BUTTON bt-yes 
     LABEL "OK (o)" 
     SIZE-PIXELS 70 BY 24
     FONT 4.

DEFINE VARIABLE ed-mensagem AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE-PIXELS 301 BY 144
     FONT 4 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE-PIXELS 315 BY 34
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ed-mensagem AT Y 6 X 7 NO-LABEL WIDGET-ID 2
     bt-yes AT Y 161 X 7
     bt-no AT Y 161 X 82 WIDGET-ID 4
     rtToolBar AT Y 156 X 0
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
         HEIGHT-P           = 192
         WIDTH-P            = 315
         MAX-HEIGHT-P       = 408
         MAX-WIDTH-P        = 630
         VIRTUAL-HEIGHT-P   = 408
         VIRTUAL-WIDTH-P    = 630
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


&Scoped-define SELF-NAME bt-no
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-no wWindow
ON ALT-F4 OF bt-no IN FRAME fpage0 /* N∆o (n) */
DO:

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-no wWindow
ON ANY-KEY OF bt-no IN FRAME fpage0 /* N∆o (n) */
DO:

    IF p-pergunta THEN DO:

        IF LAST-EVENT:LABEL = "s" THEN
            APPLY "CHOOSE" TO bt-yes.
    
        IF LAST-EVENT:LABEL = "n" THEN
            APPLY "CHOOSE" TO bt-no.

    END.
    ELSE DO:

        IF LAST-EVENT:LABEL = "o" THEN
            APPLY "CHOOSE" TO bt-yes.

    END.

    IF LAST-EVENT:LABEL = " " THEN DO:
        PAUSE(1).
        RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-no wWindow
ON CHOOSE OF bt-no IN FRAME fpage0 /* N∆o (n) */
DO:

    APPLY "CLOSE":U TO THIS-PROCEDURE.

    IF p-pergunta THEN
        RETURN "NO".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-no wWindow
ON END-ERROR OF bt-no IN FRAME fpage0 /* N∆o (n) */
DO:

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-no wWindow
ON RETURN OF bt-no IN FRAME fpage0 /* N∆o (n) */
DO:

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-yes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-yes wWindow
ON ALT-F4 OF bt-yes IN FRAME fpage0 /* OK (o) */
DO:

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-yes wWindow
ON ANY-KEY OF bt-yes IN FRAME fpage0 /* OK (o) */
DO:

    IF p-pergunta THEN DO:

        IF LAST-EVENT:LABEL = "s" THEN
            APPLY "CHOOSE" TO bt-yes.
    
        IF LAST-EVENT:LABEL = "n" THEN
            APPLY "CHOOSE" TO bt-no.

    END.
    ELSE DO:

        IF LAST-EVENT:LABEL = "o" THEN
            APPLY "CHOOSE" TO bt-yes.

    END.

    IF LAST-EVENT:LABEL = " " THEN DO:
        PAUSE(1).
        RETURN NO-APPLY.
    END.


  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-yes wWindow
ON CHOOSE OF bt-yes IN FRAME fpage0 /* OK (o) */
DO:

    APPLY "CLOSE":U TO THIS-PROCEDURE.

    IF p-pergunta THEN
        RETURN "YES".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-yes wWindow
ON END-ERROR OF bt-yes IN FRAME fpage0 /* OK (o) */
DO:

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-yes wWindow
ON RETURN OF bt-yes IN FRAME fpage0 /* OK (o) */
DO:

    RETURN NO-APPLY.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE wh-label AS WIDGET-HANDLE      NO-UNDO.

    DO WITH FRAME fPage0:
    
        ASSIGN ed-mensagem:SCREEN-VALUE = p-mensagem.

        IF NOT p-pergunta THEN
            ASSIGN bt-no:VISIBLE = FALSE.
        ELSE 
            ASSIGN bt-yes:LABEL = "Sim (s)".
    
    END.

    RUN PlaySoundA (GET-POINTER-VALUE(szSound), 
                    0, 
                    {&SND_FILENAME} + {&SND_ASYNC},
                    OUTPUT ReturnValue). 
    SET-SIZE(szSound) = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

