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
{include/i-prgvrs.i esclt003 2.06.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esclt003
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-etiq-volume fi-ean13 bt-sair
                              
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */


/* Local Variable Definitions ---                                       */
DEFINE VARIABLE lvarios           AS   LOGICAL                          NO-UNDO.
DEFINE VARIABLE lcompleto         AS   LOGICAL                          NO-UNDO.
DEFINE VARIABLE vean              AS   INTEGER                          NO-UNDO.
DEFINE VARIABLE pit-codigo        AS   CHARACTER                        NO-UNDO.
DEFINE VARIABLE fi-cod-estabel    LIKE nota-fiscal.cod-estabel          NO-UNDO.
DEFINE VARIABLE fi-serie          LIKE nota-fiscal.serie                NO-UNDO.
DEFINE VARIABLE c-selec           AS   CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-pallet          AS   CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-caixa           AS   CHARACTER                        NO-UNDO.
DEFINE VARIABLE l-ok              AS   LOGICAL FORMAT "SIM/NÇO" INIT NO NO-UNDO.
DEFINE VARIABLE l-nota-exportacao AS   LOGICAL                          NO-UNDO.
DEFINE VARIABLE c-tipo-aux        AS   CHARACTER                        NO-UNDO.
DEFINE VARIABLE i_conta_registros AS   INTEGER                          NO-UNDO.
DEFINE VARIABLE h-esapi021        AS HANDLE      NO-UNDO.

/* Buffers Definitions ---                                              */


/* Temp-tables Definitions ---                                          */


{esapi/esapi021.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-19 rec-v RECT-21 RECT-22 fi-etiq-volume ~
fi-ean13 bt-sair 
&Scoped-Define DISPLAYED-OBJECTS fi-etiq-volume fi-nr-nota-fis fi-nr-volume ~
fi-it-codigo fi-desc-item fi-qtd fi-qtd-col fi-ean13 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-item-rastr wWindow 
FUNCTION f-item-rastr RETURNS LOGICAL
  ( INPUT p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wWindow 
FUNCTION fnDescItem RETURNS CHARACTER
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

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 259 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-ean13 AS CHARACTER FORMAT "X(20)":U 
     LABEL "Barras" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 210 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-etiq-volume AS CHARACTER FORMAT "X(21)":U 
     LABEL "Volume" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 140 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 82 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-nr-nota-fis AS CHARACTER FORMAT "X(16)" 
     LABEL "Nr Nota" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 119 BY 21
     FONT 4.

DEFINE VARIABLE fi-nr-volume AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Nr.Vol" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 49 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-qtd AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 84 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-qtd-col AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Coletado" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 84 BY 21
     FONT 4 NO-UNDO.

DEFINE RECTANGLE rec-v
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE-PIXELS 50 BY 46.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 315 BY 58.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 315 BY 82.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 315 BY 34.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-etiq-volume AT Y 12 X 35 COLON-ALIGNED WIDGET-ID 4
     fi-nr-nota-fis AT Y 36 X 35 COLON-ALIGNED WIDGET-ID 8
     fi-nr-volume AT Y 36 X 190 COLON-ALIGNED WIDGET-ID 20
     fi-it-codigo AT Y 78 X 35 COLON-ALIGNED WIDGET-ID 34
     fi-desc-item AT Y 102 X 35 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     fi-qtd AT Y 126 X 35 COLON-ALIGNED WIDGET-ID 36
     fi-qtd-col AT Y 126 X 210 COLON-ALIGNED WIDGET-ID 38
     fi-ean13 AT Y 168 X 35 COLON-ALIGNED WIDGET-ID 30
     bt-sair AT Y 253 X 248 WIDGET-ID 40
     "F5 - Volumes da Nota Fiscal" VIEW-AS TEXT
          SIZE-PIXELS 151 BY 13 AT Y 263 X 7 WIDGET-ID 46
          FONT 4
     RECT-19 AT Y 6 X 0 WIDGET-ID 14
     rec-v AT Y 12 X 257 WIDGET-ID 26
     RECT-21 AT Y 72 X 0 WIDGET-ID 28
     RECT-22 AT Y 162 X 0 WIDGET-ID 42
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

/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nr-nota-fis IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nr-volume IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qtd IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qtd-col IN FRAME fpage0
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair wWindow
ON F5 OF bt-sair IN FRAME fpage0 /* Sair(esc) */
DO:

    APPLY "F5" TO fi-ean13.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ean13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ean13 wWindow
ON F5 OF fi-ean13 IN FRAME fpage0 /* Barras */
DO:

    {&WINDOW-NAME}:SENSITIVE = NO.
    {&WINDOW-NAME}:HIDDEN    = YES.
    RUN esp/clt/esclt003b.w (INPUT fi-cod-estabel,
                             INPUT fi-serie,
                             INPUT fi-nr-nota-fis).
    {&WINDOW-NAME}:HIDDEN    = NO.
    {&WINDOW-NAME}:SENSITIVE = YES.

    APPLY "entry":U TO fi-ean13 IN FRAME fPage0.
    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ean13 wWindow
ON RETURN OF fi-ean13 IN FRAME fpage0 /* Barras */
DO:

    /*APPLY "RETURN" TO fi-etiq-volume.*/

    RUN pi-coleta.

    RETURN NO-APPLY.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-etiq-volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-etiq-volume wWindow
ON F5 OF fi-etiq-volume IN FRAME fpage0 /* Volume */
DO:

    APPLY "F5" TO fi-ean13.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-etiq-volume wWindow
ON RETURN OF fi-etiq-volume IN FRAME fpage0 /* Volume */
DO:

    RUN esapi/esapi021.p PERSISTENT SET  h-esapi021.    

    RUN pi-carga-volume IN h-esapi021 (INPUT fi-etiq-volume:SCREEN-VALUE,
                                       OUTPUT l-nota-exportacao,
                                       OUTPUT fi-cod-estabel,
                                       OUTPUT fi-serie,
                                       OUTPUT fi-nr-nota-fis,
                                       OUTPUT fi-nr-volume,
                                       OUTPUT lvarios,
                                       OUTPUT lcompleto,
                                       OUTPUT fi-it-codigo,
                                       OUTPUT fi-desc-item,
                                       OUTPUT fi-qtd,
                                       OUTPUT fi-qtd-col,
                                       OUTPUT TABLE tt-erro).

    IF RETURN-VALUE = "NOK" THEN DO:

        DELETE PROCEDURE h-esapi021.
        ASSIGN h-esapi021 = ?.

        FOR EACH tt-erro:
        
            {&WINDOW-NAME}:SENSITIVE = FALSE.

            RUN esp/clt/esclt006.w (INPUT tt-erro.erro,
                                    INPUT tt-erro.pergunta).
    
            {&WINDOW-NAME}:SENSITIVE = TRUE.

        END.

        RETURN NO-APPLY.

    END.

    DELETE PROCEDURE h-esapi021.
    ASSIGN h-esapi021 = ?.

    DISP fi-etiq-volume 
         fi-nr-nota-fis
         fi-nr-volume
         fi-it-codigo
         fi-desc-item
         fi-qtd      
         fi-qtd-col  
         WITH FRAME fpage0.
    
    IF  lcompleto THEN DO:
        CLEAR FRAME fPage0 ALL.
        assign fi-ean13:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               /* verde */
               rec-v:FGCOLOR = 2
               rec-v:BGCOLOR = 2.

        DISP fi-etiq-volume 
             fi-nr-nota-fis
             fi-nr-volume
             WITH FRAME fpage0.

        APPLY "entry" TO fi-etiq-volume IN FRAME fPage0.
    END. /* IF  lcompleto THEN */
    ELSE DO:
        assign fi-etiq-volume:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               fi-ean13:SENSITIVE       IN FRAME {&FRAME-NAME} = YES
               /* vermelho */ 
               rec-v:FGCOLOR = 12
               rec-v:BGCOLOR = 12.
        APPLY "entry" TO fi-ean13 IN FRAME fPage0.
    END. /* ELSE DO: */

    RETURN NO-APPLY.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-coleta wWindow 
PROCEDURE pi-coleta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:

        ASSIGN fi-ean13
               fi-nr-nota-fis
               fi-nr-volume
               fi-it-codigo
               fi-desc-item
               fi-qtd
               fi-qtd-col.

    END.

    RUN esapi/esapi021.p PERSISTENT SET  h-esapi021.    

    RUN pi-coleta IN h-esapi021 (INPUT fi-ean13,
                                 INPUT fi-cod-estabel,
                                 INPUT fi-serie,
                                 INPUT fi-nr-nota-fis,
                                 INPUT fi-nr-volume,
                                 OUTPUT lcompleto,
                                 INPUT-OUTPUT fi-it-codigo,
                                 INPUT-OUTPUT fi-desc-item,
                                 INPUT-OUTPUT fi-qtd,
                                 INPUT-OUTPUT fi-qtd-col,
                                 OUTPUT TABLE tt-erro).

    IF RETURN-VALUE = "NOK" THEN DO:

        DELETE PROCEDURE h-esapi021.
        ASSIGN h-esapi021 = ?.

        FOR EACH tt-erro:

            {&WINDOW-NAME}:SENSITIVE = FALSE.

            RUN esp/clt/esclt006.w (INPUT tt-erro.erro,
                                    INPUT tt-erro.pergunta).

            {&WINDOW-NAME}:SENSITIVE = TRUE.

        END.

        ASSIGN fi-ean13 = "":U.
        DISPLAY fi-ean13 WITH FRAME fpage0.

        RETURN "NOK":u.

    END.

    DELETE PROCEDURE h-esapi021.
    ASSIGN h-esapi021 = ?.

    ASSIGN fi-ean13 = "":U.
    DISPLAY fi-ean13 WITH FRAME fpage0.

    IF  lcompleto THEN DO:
        ASSIGN fi-it-codigo = ""
               fi-desc-item = ""
               fi-qtd       = 0
               fi-qtd-col   = 0.

        DISP fi-it-codigo fi-desc-item fi-qtd fi-qtd-col WITH FRAME fpage0.

        ASSIGN fi-etiq-volume:SENSITIVE IN FRAME fPage0 = YES
               fi-ean13:SENSITIVE IN FRAME fpage0       = NO
               rec-v:FGCOLOR                            = 2 /* verde */
               rec-v:BGCOLOR                            = 2 /* verde */ .
        APPLY "ENTRY":U TO fi-etiq-volume IN FRAME fPage0.
    END. /* IF  lcompleto */
    ELSE DO:

        DISP fi-it-codigo fi-desc-item fi-qtd fi-qtd-col WITH FRAME fpage0.

        ASSIGN rec-v:FGCOLOR = 12 /* vermelho */
               rec-v:BGCOLOR = 12 /* vermelho */ .
        APPLY "ENTRY":U TO fi-ean13 IN FRAME fPage0.
    END. /* ELSE DO: */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-item-rastr wWindow 
FUNCTION f-item-rastr RETURNS LOGICAL
  ( INPUT p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST item-rast FIELDS(it-codigo data-ini data-fim) NO-LOCK 
        WHERE item-rast.it-codigo  = p-it-codigo
        AND   item-rast.data-ini  <= TODAY
        AND   item-rast.data-fim   > TODAY:

        RETURN TRUE.

    END.


    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wWindow 
FUNCTION fnDescItem RETURNS CHARACTER
  ( c-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST ITEM NO-LOCK
        WHERE  ITEM.it-codigo = c-it-codigo NO-ERROR.
    IF  AVAIL ITEM 
    THEN RETURN ITEM.desc-item.
    ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

