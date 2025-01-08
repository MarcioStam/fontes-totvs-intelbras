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
{include/i-prgvrs.i esclt005a 2.06.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esclt005a
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   brVolumes bt-sair
                              
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Temp-tables Definitions ---                                          */
DEF TEMP-TABLE ttvolume-nf
    FIELD cod-estabel LIKE volume-nf.cod-estabel
    FIELD serie       LIKE volume-nf.serie
    FIELD nr-nota-fis LIKE volume-nf.nr-nota-fis
    FIELD tot-vol     LIKE volume-nf.nr-volume
    FIELD qtd-col     LIKE volume-nf.nr-volume
    INDEX ch-pri cod-estabel serie nr-nota-fis.

DEF TEMP-TABLE ttvolume NO-UNDO LIKE volume-nf
    FIELD r-rowid AS ROWID.

/* Parameters Definitions ---                                           */
DEF INPUT PARAM TABLE FOR ttvolume-nf.
DEF INPUT PARAM pFrac AS LOG NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-desc-item     LIKE ITEM.desc-item      NO-UNDO.
DEFINE VARIABLE i-nr-volume-aux LIKE volume-nf.nr-volume NO-UNDO.

/* Buffers Definitions ---                                              */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brVolumes

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttvolume

/* Definitions for BROWSE brVolumes                                     */
&Scoped-define FIELDS-IN-QUERY-brVolumes ttvolume.nr-volume ttvolume.it-codigo fnDesc-item(ttvolume.it-codigo) @ c-desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brVolumes   
&Scoped-define SELF-NAME brVolumes
&Scoped-define QUERY-STRING-brVolumes FOR EACH  ttvolume
&Scoped-define OPEN-QUERY-brVolumes OPEN QUERY {&SELF-NAME} FOR EACH  ttvolume.
&Scoped-define TABLES-IN-QUERY-brVolumes ttvolume
&Scoped-define FIRST-TABLE-IN-QUERY-brVolumes ttvolume


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brVolumes}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-sair brVolumes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDesc-item wWindow 
FUNCTION fnDesc-item RETURNS CHARACTER
  ( c-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-sair 
     LABEL "Sair(esc)" 
     SIZE-PIXELS 63 BY 27
     FONT 4.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brVolumes FOR 
      ttvolume SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brVolumes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brVolumes wWindow _FREEFORM
  QUERY brVolumes DISPLAY
      ttvolume.nr-volume COLUMN-LABEL "Volume":U WIDTH 05
      ttvolume.it-codigo COLUMN-LABEL "Item":U   WIDTH 06
      fnDesc-item(ttvolume.it-codigo) @ c-desc-item COLUMN-LABEL "Descri‡Æo":U FORMAT 'x(50)':U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 46 BY 10
          &ELSE SIZE-PIXELS 320 BY 240 &ENDIF
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-sair AT Y 261 X 249 WIDGET-ID 40
     brVolumes AT Y 6 X 0 WIDGET-ID 200
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
         WIDTH-P            = 319
         MAX-HEIGHT-P       = 320
         MAX-WIDTH-P        = 320
         VIRTUAL-HEIGHT-P   = 320
         VIRTUAL-WIDTH-P    = 320
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
   FRAME-NAME Size-to-Fit Custom                                        */
/* BROWSE-TAB brVolumes bt-sair fpage0 */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brVolumes
/* Query rebuild information for BROWSE brVolumes
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH  ttvolume
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brVolumes */
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
  /*IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.  
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


&Scoped-define BROWSE-NAME brVolumes
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

EMPTY TEMP-TABLE ttvolume NO-ERROR.

IF  CAN-FIND(FIRST ttvolume-nf) THEN
FOR EACH ttvolume-nf:
    FOR EACH  volume-nf NO-LOCK
        WHERE volume-nf.cod-estabel = ttvolume-nf.cod-estabel
        AND   volume-nf.serie       = ttvolume-nf.serie      
        AND   volume-nf.nr-nota-fis = ttvolume-nf.nr-nota-fis:

        IF pFrac = YES AND volume-nf.varios-itens = NO THEN NEXT.
        
        IF  NOT CAN-FIND(FIRST conf-volume-nf
                         WHERE conf-volume-nf.cod-estabel = volume-nf.cod-estabel
                         AND   conf-volume-nf.serie       = volume-nf.serie
                         AND   conf-volume-nf.nr-nota-fis = volume-nf.nr-nota-fis
                         AND   conf-volume-nf.nr-volume   = volume-nf.nr-volume) THEN DO:
            CREATE ttvolume.
            BUFFER-COPY volume-nf TO ttvolume
                ASSIGN ttvolume.r-rowid = ROWID(volume-nf).
        END. /* IF  NOT CAN-FIND(FIRST conf-volume-nf */
    END. /* FOR EACH  volume-nf NO-LOCK */
END. /* FOR EACH ttvolume-nf */

{&OPEN-QUERY-brVolumes}

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDesc-item wWindow 
FUNCTION fnDesc-item RETURNS CHARACTER
  ( c-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST ITEM NO-LOCK
        WHERE  ITEM.it-codigo = c-it-codigo NO-ERROR.
    IF  AVAIL  ITEM
    THEN RETURN ITEM.desc-item.
    ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

