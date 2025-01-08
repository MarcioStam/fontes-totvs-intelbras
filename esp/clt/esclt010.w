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
{include/i-prgvrs.i ESCLT010 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCLT010
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-etiqueta bt-embal bt-sair
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

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
&Scoped-Define ENABLED-OBJECTS RECT-17 RECT-20 fi-etiqueta fi-it-codigo ~
fi-desc-item fi-peso-bruto fi-peso-liq fi-comprimento fi-altura fi-largura ~
bt-embal bt-sair 
&Scoped-Define DISPLAYED-OBJECTS fi-etiqueta fi-it-codigo fi-desc-item ~
fi-peso-bruto fi-peso-liq fi-comprimento fi-altura fi-largura 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-embal 
     LABEL "Embalagens(E)" 
     SIZE-PIXELS 84 BY 27
     FONT 4.

DEFINE BUTTON bt-sair 
     LABEL "Sair(esc)" 
     SIZE-PIXELS 63 BY 27
     FONT 4.

DEFINE VARIABLE fi-altura AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Altura" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 105 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-comprimento AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Comprimento" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 105 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descri‡Æo" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 217 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-etiqueta AS CHARACTER FORMAT "X(13)":U 
     LABEL "EAN" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 126 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 70 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-largura AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Largura" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 105 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-peso-bruto AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Peso Bruto" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 105 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-peso-liq AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Peso Liq" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 105 BY 21
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 308 BY 36.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 308 BY 180.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-etiqueta AT Y 12 X 70 COLON-ALIGNED WIDGET-ID 2
     fi-it-codigo AT Y 54 X 70 COLON-ALIGNED WIDGET-ID 56
     fi-desc-item AT Y 78 X 70 COLON-ALIGNED WIDGET-ID 58
     fi-peso-bruto AT Y 102 X 70 COLON-ALIGNED WIDGET-ID 60
     fi-peso-liq AT Y 126 X 70 COLON-ALIGNED WIDGET-ID 62
     fi-comprimento AT Y 150 X 70 COLON-ALIGNED WIDGET-ID 64
     fi-altura AT Y 174 X 70 COLON-ALIGNED WIDGET-ID 66
     fi-largura AT Y 198 X 70 COLON-ALIGNED WIDGET-ID 68
     bt-embal AT Y 234 X 7 WIDGET-ID 70
     bt-sair AT Y 234 X 252 WIDGET-ID 40
     RECT-17 AT Y 6 X 7 WIDGET-ID 46
     RECT-20 AT Y 48 X 7 WIDGET-ID 52
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


&Scoped-define SELF-NAME bt-embal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-embal wWindow
ON ANY-KEY OF bt-embal IN FRAME fpage0 /* Embalagens(E) */
DO:

    APPLY "ANY-KEY" TO fi-etiqueta.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-embal wWindow
ON CHOOSE OF bt-embal IN FRAME fpage0 /* Embalagens(E) */
DO:

    {&WINDOW-NAME}:SENSITIVE = NO.
    {&WINDOW-NAME}:HIDDEN    = YES.

    RUN esp/clt/esclt010a.w(INPUT INPUT FRAME fPage0 fi-it-codigo).
    
    {&WINDOW-NAME}:HIDDEN    = NO.
    {&WINDOW-NAME}:SENSITIVE = YES.

    APPLY "ENTRY" TO fi-etiqueta.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair wWindow
ON ANY-KEY OF bt-sair IN FRAME fpage0 /* Sair(esc) */
DO:

    APPLY "ANY-KEY" TO fi-etiqueta.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair wWindow
ON CHOOSE OF bt-sair IN FRAME fpage0 /* Sair(esc) */
DO:
  APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-etiqueta wWindow
ON ANY-KEY OF fi-etiqueta IN FRAME fpage0 /* EAN */
DO:

    IF LAST-EVENT:LABEL = "e" THEN DO:
        APPLY "CHOOSE" TO bt-embal.
        RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-etiqueta wWindow
ON RETURN OF fi-etiqueta IN FRAME fpage0 /* EAN */
DO:

    DO WITH FRAME fPage0:

        ASSIGN fi-it-codigo:SCREEN-VALUE = ""
               fi-desc-item:SCREEN-VALUE = ""
               fi-peso-bruto:SCREEN-VALUE = ""
               fi-peso-liq:SCREEN-VALUE = ""
               fi-comprimento:SCREEN-VALUE = ""
               fi-altura:SCREEN-VALUE = ""
               fi-largura:SCREEN-VALUE = "".

        FOR FIRST item-mat NO-LOCK
            WHERE item-mat.cod-ean = fi-etiqueta:SCREEN-VALUE:
    
            FOR FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = item-mat.it-codigo:
    
                ASSIGN fi-it-codigo:SCREEN-VALUE = ITEM.it-codigo
                       fi-desc-item:SCREEN-VALUE = ITEM.desc-item
                       fi-peso-bruto:SCREEN-VALUE = string(ITEM.peso-bruto)
                       fi-peso-liq:SCREEN-VALUE = string(ITEM.peso-liq)
                       fi-comprimento:SCREEN-VALUE = string(ITEM.comprim)
                       fi-altura:SCREEN-VALUE = string(ITEM.altura)
                       fi-largura:SCREEN-VALUE = string(ITEM.largura).
    
            END.
    
        END.

    END.

    APPLY "ENTRY" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


