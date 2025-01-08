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
{include/i-prgvrs.i esclt005b 2.06.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esclt005b
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   br-pendentes bt-sair
                              
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
/*
DEFINE VARIABLE pit-codigo           AS   CHARACTER          NO-UNDO.
DEFINE VARIABLE lcompleto            AS   LOGICAL            NO-UNDO.
DEFINE VARIABLE i-contador           AS   INTEGER            NO-UNDO.
DEFINE VARIABLE c-nr-serie-principal LIKE num-serie.n-serie  NO-UNDO. 
DEFINE VARIABLE i-conta-serie        AS   INTEGER            NO-UNDO.
DEFINE VARIABLE c-tipo-aux           AS   CHARACTER          NO-UNDO.
DEFINE VARIABLE l-volta              AS   LOGICAL            NO-UNDO.
DEFINE VARIABLE l-retorno-astec      AS   LOGICAL            NO-UNDO.
DEFINE VARIABLE vqtd-col             LIKE volume-nf.qtde-col NO-UNDO.
DEFINE VARIABLE h-acomp              AS   HANDLE             NO-UNDO.
DEFINE VARIABLE i-volumes            AS   INTEGER            NO-UNDO.
DEFINE VARIABLE i-tot-col            AS   INTEGER            NO-UNDO.
{esp/es0018.i}
{upc/btb910za-upc.i}

*/
{esp/clt/esclt005.i} /* ttvolume-nf */

DEFINE TEMP-TABLE tt-pendentes
    FIELD cod-estabel   LIKE volume-nf.cod-estabel
    FIELD serie         LIKE volume-nf.serie
    FIELD nr-nota-fis   LIKE volume-nf.nr-nota-fis
    FIELD nr-volume     LIKE volume-nf.nr-volume.


/* Buffers Definitions ---                                              */

/* Temp-tables Definitions ---                                          */

DEFINE INPUT PARAMETER p-tot-volumes AS DECIMAL NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR ttvolume-nf.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-pendentes

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-pendentes

/* Definitions for BROWSE br-pendentes                                  */
&Scoped-define FIELDS-IN-QUERY-br-pendentes tt-pendentes.cod-estabel tt-pendentes.serie tt-pendentes.nr-nota-fis tt-pendentes.nr-volume   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-pendentes   
&Scoped-define SELF-NAME br-pendentes
&Scoped-define QUERY-STRING-br-pendentes FOR EACH tt-pendentes
&Scoped-define OPEN-QUERY-br-pendentes OPEN QUERY {&SELF-NAME} FOR EACH tt-pendentes.
&Scoped-define TABLES-IN-QUERY-br-pendentes tt-pendentes
&Scoped-define FIRST-TABLE-IN-QUERY-br-pendentes tt-pendentes


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-pendentes}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-pendentes fi-tot-volumes fi-tot-cheio ~
fi-tot-fracionado bt-sair 
&Scoped-Define DISPLAYED-OBJECTS fi-tot-volumes fi-tot-cheio ~
fi-tot-fracionado 

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

DEFINE VARIABLE fi-tot-cheio AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Vol. Unit rio" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 126 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-tot-fracionado AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Vol. Fracionado" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 126 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-tot-volumes AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Total Volumes" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 126 BY 21
     FONT 4 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-pendentes FOR 
      tt-pendentes SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-pendentes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-pendentes wWindow _FREEFORM
  QUERY br-pendentes DISPLAY
      tt-pendentes.cod-estabel
     tt-pendentes.serie
     tt-pendentes.nr-nota-fis
     tt-pendentes.nr-volume
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 44 BY 7
          &ELSE SIZE-PIXELS 308 BY 168 &ENDIF
         FONT 4
         TITLE "Volumes Incompletos" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     br-pendentes AT Y 90 X 5 WIDGET-ID 200
     fi-tot-volumes AT Y 12 X 112 COLON-ALIGNED WIDGET-ID 2
     fi-tot-cheio AT Y 36 X 112 COLON-ALIGNED WIDGET-ID 4
     fi-tot-fracionado AT Y 60 X 112 COLON-ALIGNED WIDGET-ID 6
     bt-sair AT Y 261 X 249 WIDGET-ID 40
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
   FRAME-NAME Size-to-Fit Custom                                        */
/* BROWSE-TAB br-pendentes 1 fpage0 */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-pendentes
/* Query rebuild information for BROWSE br-pendentes
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-pendentes.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-pendentes */
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


&Scoped-define BROWSE-NAME br-pendentes
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

DEFINE VARIABLE l-pendente AS LOGICAL     NO-UNDO.


EMPTY TEMP-TABLE tt-pendentes.

ASSIGN fi-tot-volumes:SCREEN-VALUE IN FRAME fPage0 = STRING(p-tot-volumes).

FOR EACH ttvolume-nf:
    
    FOR EACH  volume-nf NO-LOCK 
        WHERE volume-nf.cod-estabel = ttvolume-nf.cod-estabel 
        AND   volume-nf.serie       = ttvolume-nf.serie 
        AND   volume-nf.nr-nota-fis = ttvolume-nf.nr-nota-fis 
        BREAK BY volume-nf.nr-volume:

        IF FIRST-OF(volume-nf.nr-volume) THEN
            ASSIGN l-pendente = FALSE.

        IF  volume-nf.qtde <> volume-nf.qtde-col THEN
            ASSIGN l-pendente = TRUE.

        IF LAST-OF(volume-nf.nr-volume) THEN DO:

            IF l-pendente THEN DO:

                CREATE tt-pendentes.
                BUFFER-COPY volume-nf TO tt-pendentes.

            END.

            IF volume-nf.varios-itens THEN
                ASSIGN fi-tot-fracionado = fi-tot-fracionado + 1.
            ELSE
                ASSIGN fi-tot-cheio = fi-tot-cheio + 1.

        END.
        
    END. /* FOR EACH  bvolume-nf NO-LOCK */

END.



DISP fi-tot-fracionado
     fi-tot-cheio
    with FRAME fPage0.

{&open-query-br-pendentes}



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

