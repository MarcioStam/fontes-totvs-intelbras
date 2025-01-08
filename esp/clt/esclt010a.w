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
{include/i-prgvrs.i ESCLT010A 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCLT010A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   br-embal bt-sair 
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-embal NO-UNDO
    FIELD embalagem     LIKE embalag.embalagem
    FIELD sigla-emb     LIKE embalag.sigla-emb
    FIELD descricao     LIKE embalag.descricao
    FIELD peso-embal    LIKE embalag.peso-embal
    FIELD altura        LIKE embalag.altura
    FIELD largura       LIKE embalag.largura
    FIELD comprim       LIKE embalag.comprim
    FIELD qt-item       LIKE item-caixa.qt-item.


DEFINE INPUT PARAMETER p-it-codigo  AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-embal

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-embal

/* Definitions for BROWSE br-embal                                      */
&Scoped-define FIELDS-IN-QUERY-br-embal tt-embal.sigla-emb tt-embal.peso-embal tt-embal.altura tt-embal.largura tt-embal.comprim tt-embal.qt-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-embal   
&Scoped-define SELF-NAME br-embal
&Scoped-define QUERY-STRING-br-embal FOR EACH tt-embal
&Scoped-define OPEN-QUERY-br-embal OPEN QUERY {&SELF-NAME} FOR EACH tt-embal.
&Scoped-define TABLES-IN-QUERY-br-embal tt-embal
&Scoped-define FIRST-TABLE-IN-QUERY-br-embal tt-embal


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-embal}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-20 fi-it-codigo fi-desc-item br-embal ~
bt-sair 
&Scoped-Define DISPLAYED-OBJECTS fi-it-codigo fi-desc-item 

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
     SIZE-PIXELS 63 BY 27
     FONT 4.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descri‡Æo" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 217 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 70 BY 21
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 308 BY 60.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-embal FOR 
      tt-embal SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-embal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-embal wWindow _FREEFORM
  QUERY br-embal DISPLAY
      tt-embal.sigla-emb WIDTH 4
    tt-embal.peso-embal  WIDTH 7 COLUMN-LABEL "Peso Emb"
    tt-embal.altura      WIDTH 7 COLUMN-LABEL "Altura"
    tt-embal.largura     WIDTH 6 COLUMN-LABEL "Largura"
    tt-embal.comprim     WIDTH 7 COLUMN-LABEL "Compr."
    tt-embal.qt-item     WIDTH 6 COLUMN-LABEL "Qtde."
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 44 BY 8
          &ELSE SIZE-PIXELS 308 BY 180 &ENDIF
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-it-codigo AT Y 12 X 70 COLON-ALIGNED WIDGET-ID 56
     fi-desc-item AT Y 36 X 70 COLON-ALIGNED WIDGET-ID 58
     br-embal AT Y 72 X 7 WIDGET-ID 200
     bt-sair AT Y 255 X 252 WIDGET-ID 40
     RECT-20 AT Y 6 X 7 WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
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
/* BROWSE-TAB br-embal fi-desc-item fpage0 */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-embal
/* Query rebuild information for BROWSE br-embal
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-embal.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-embal */
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


&Scoped-define SELF-NAME bt-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair wWindow
ON CHOOSE OF bt-sair IN FRAME fpage0 /* Sair(esc) */
DO:
  APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-embal
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
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-embal.

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = p-it-codigo:

        DO WITH FRAME fPage0:
            ASSIGN fi-it-codigo:SCREEN-VALUE = ITEM.it-codigo
                   fi-desc-item:SCREEN-VALUE = ITEM.desc-item.
        END.

        FOR EACH item-caixa NO-LOCK
            WHERE item-caixa.it-codigo = ITEM.it-codigo:

            FOR FIRST embalag NO-LOCK
                WHERE embalag.sigla-emb = item-caixa.sigla-emb:

                CREATE tt-embal.
                BUFFER-COPY embalag TO tt-embal.
                ASSIGN tt-embal.qt-item = item-caixa.qt-item.
            END.

        END.

    END.

    {&open-query-br-embal}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

