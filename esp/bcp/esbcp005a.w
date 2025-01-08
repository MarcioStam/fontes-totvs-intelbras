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

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esclt008a
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   bt-no fi-it-codigo fi-quantidade
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE OUTPUT PARAMETER p-item       AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p-quantidade AS INTEGER   NO-UNDO.

/* Comandos para emissÆo de Som */
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
&Scoped-Define ENABLED-OBJECTS rtToolBar fi-it-codigo fi-quantidade bt-no 
&Scoped-Define DISPLAYED-OBJECTS fi-it-codigo fi-quantidade 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-no 
     LABEL "Cancelar (F5)" 
     SIZE-PIXELS 70 BY 24
     FONT 4.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 91 BY 21 TOOLTIP "Item"
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-quantidade AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 91 BY 21 TOOLTIP "Quantidade"
     FONT 4 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE-PIXELS 315 BY 34
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-it-codigo AT Y 19 X 64 COLON-ALIGNED HELP
          "Item" WIDGET-ID 6
     fi-quantidade AT Y 41 X 64 COLON-ALIGNED HELP
          "Quantidade" WIDGET-ID 8
     bt-no AT Y 85 X 7 WIDGET-ID 4
     rtToolBar AT Y 80 X 0
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
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
         HEIGHT-P           = 114
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
ON F5 OF wWindow
DO:
    APPLY "CHOOSE" TO bt-no IN FRAME fPage0.
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
ON CHOOSE OF bt-no IN FRAME fpage0 /* Cancelar (F5) */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.

    ASSIGN p-item = "CANCELAR".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-no wWindow
ON END-ERROR OF bt-no IN FRAME fpage0 /* Cancelar (F5) */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-no wWindow
ON F5 OF bt-no IN FRAME fpage0 /* Cancelar (F5) */
DO:
    APPLY "CHOOSE" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-no wWindow
ON RETURN OF bt-no IN FRAME fpage0 /* Cancelar (F5) */
DO:
    APPLY "CHOOSE" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON F5 OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:
    APPLY "CHOOSE" TO bt-no IN FRAME fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON RETURN OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:
    APPLY "ENTRY" TO fi-quantidade IN FRAME fPage0.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-quantidade wWindow
ON F5 OF fi-quantidade IN FRAME fpage0 /* Quantidade */
DO:
    APPLY "CHOOSE" TO bt-no IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-quantidade wWindow
ON RETURN OF fi-quantidade IN FRAME fpage0 /* Quantidade */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.

    ASSIGN p-item       = INPUT FRAME fPage0 fi-it-codigo
           p-quantidade = INPUT FRAME fPage0 fi-quantidade.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE wh-label AS WIDGET-HANDLE      NO-UNDO.

    RUN PlaySoundA (GET-POINTER-VALUE(szSound), 
                    0, 
                    {&SND_FILENAME} + {&SND_ASYNC},
                    OUTPUT ReturnValue). 
    SET-SIZE(szSound) = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

