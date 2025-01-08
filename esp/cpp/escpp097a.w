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
{include/i-prgvrs.i ESCPP097A 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP097A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-pesquisa ~
                              rs-pesquisa ~
                              fiMotivo ~
                              btConfigImpr ~
                              btOK ~
                              btCancel ~
                              btHelp2 
                              

/* Local Temp-Table Definitions ---                                     */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp  AS HANDLE      NO-UNDO.

DEFINE VARIABLE l-arquivo     AS LOGICAL NO-UNDO INIT NO.
/* Global Shared Variable Definitions ---                               */

DEFINE NEW GLOBAL SHARED VARIABLE v_nom_disposit_so AS CHARACTER   NO-UNDO.
DEFINE TEMP-TABLE tt-lista-ns
    FIELD num-serie     AS CHAR FORMAT "X(13)".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-15 RECT-16 rs-pesquisa ~
fi-pesquisa fiMotivo btConfigImpr fiPrinter btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS rs-pesquisa fi-pesquisa f-id f-nr-serie ~
f-chave fiMotivo fiPrinter 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Sair" 
     SIZE 10 BY 1.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image/im-cfprt":U
     LABEL "Configuraá∆o da impressora" 
     SIZE 4 BY 1 TOOLTIP "Configuraá∆o da impressora".

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Reimprimir" 
     SIZE 10 BY 1.

DEFINE VARIABLE fiMotivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256 SCROLLBAR-VERTICAL
     SIZE 44 BY 3.88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 44 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-chave AS CHARACTER FORMAT "X(256)":U 
     LABEL "Chave" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE f-id AS CHARACTER FORMAT "X(256)":U 
     LABEL "ID" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE f-nr-serie AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nr Serie" 
     VIEW-AS FILL-IN 
     SIZE 15.57 BY .79 NO-UNDO.

DEFINE VARIABLE fi-pesquisa AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 23 BY .79 NO-UNDO.

DEFINE VARIABLE rs-pesquisa AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "ID", 1,
"QR Code", 2,
"Nr. SÇrie", 3
     SIZE 24.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27 BY 2.75.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 2.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 75 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     rs-pesquisa AT ROW 2.08 COL 22.86 NO-LABEL WIDGET-ID 2
     fi-pesquisa AT ROW 3.25 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     f-id AT ROW 4.92 COL 25 COLON-ALIGNED WIDGET-ID 12
     f-nr-serie AT ROW 4.92 COL 44.43 COLON-ALIGNED WIDGET-ID 16
     f-chave AT ROW 5.88 COL 25 COLON-ALIGNED WIDGET-ID 14
     fiMotivo AT ROW 8 COL 21 HELP
          "Motivo da Reimpress∆o" NO-LABEL
     btConfigImpr AT ROW 11.92 COL 65 HELP
          "Configuraá∆o da impressora"
     fiPrinter AT ROW 12 COL 21 NO-LABEL NO-TAB-STOP 
     btOK AT ROW 13.46 COL 2 HELP
          "Reimprimir"
     btCancel AT ROW 13.46 COL 13.14 HELP
          "Sair do Programa"
     btHelp2 AT ROW 13.46 COL 64.14 HELP
          "Ajuda"
     "Pesquisar por:" VIEW-AS TEXT
          SIZE 9.72 BY .54 AT ROW 1.33 COL 21.86 WIDGET-ID 8
     "Impressora:" VIEW-AS TEXT
          SIZE 8 BY .63 AT ROW 10.42 COL 12.43
     "Motivo Reimpress∆o:" VIEW-AS TEXT
          SIZE 14.29 BY .63 AT ROW 7.25 COL 34.29 RIGHT-ALIGNED
     rtToolBar AT ROW 13.21 COL 1
     RECT-15 AT ROW 1.75 COL 21 WIDGET-ID 6
     RECT-16 AT ROW 4.71 COL 21 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.04
         SIZE 75.14 BY 13.63
         FONT 1.


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
         HEIGHT             = 13.75
         WIDTH              = 75.43
         MAX-HEIGHT         = 14.5
         MAX-WIDTH          = 96.86
         VIRTUAL-HEIGHT     = 14.5
         VIRTUAL-WIDTH      = 96.86
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
/* SETTINGS FOR FILL-IN f-chave IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-id IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nr-serie IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR TEXT-LITERAL "Motivo Reimpress∆o:"
          SIZE 14.29 BY .63 AT ROW 7.25 COL 34.29 RIGHT-ALIGNED         */

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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Sair */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wWindow
ON CHOOSE OF btConfigImpr IN FRAME fpage0 /* Configuraá∆o da impressora */
DO:
    RUN piSelectPrinter IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Reimprimir */
DO:
    IF l-arquivo = NO 
    THEN DO:
        RUN piExecute IN THIS-PROCEDURE.
    
        IF RETURN-VALUE = "NOK":U THEN
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Etiqueta n∆o foi reimpressa!":U).
        ELSE DO:
    
    
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 15825,
                               INPUT "Etiqueta reimpressa com sucesso!":U).
    
            assign fi-pesquisa:screen-value in frame fPage0 = "".
    
            apply "entry":U to fi-pesquisa in frame fPage0.
    
        END. 
    END.
    ELSE DO:
        RUN piExecuteARQ IN THIS-PROCEDURE.
    
        IF RETURN-VALUE = "NOK":U THEN
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Etiqueta n∆o foi reimpressa!":U).
        ELSE DO:
    
    
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 15825,
                               INPUT "Etiqueta reimpressa com sucesso!":U).
    
            assign fi-pesquisa:screen-value in frame fPage0 = "".
    
            apply "entry":U to fi-pesquisa in frame fPage0.
    
        END. 
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-pesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-pesquisa wWindow
ON LEAVE OF fi-pesquisa IN FRAME fpage0
DO:
    ASSIGN INPUT FRAME fPage0 rs-pesquisa
                              fi-pesquisa
                              fiPrinter
                              fiMotivo.

    /*RUN piValidateParam IN THIS-PROCEDURE (INPUT rs-pesquisa,
                                           INPUT fi-pesquisa,
                                           INPUT fiPrinter,
                                           INPUT fiMotivo). */

    CASE rs-pesquisa:
        WHEN 1 THEN DO: /* ID*/
            FIND num-serie NO-LOCK
                WHERE num-serie.ID = INPUT fi-pesquisa NO-ERROR.

            IF AVAIL num-serie THEN
            ASSIGN f-id:screen-value       in frame fpage0 = STRING(num-serie.ID)
                   f-chave:screen-value    in frame fpage0 = STRING(num-serie.ch-acesso)
                   f-nr-serie:screen-value in frame fpage0 = STRING(num-serie.n-serie).            
        END.
        WHEN 2 THEN DO: /* QR-CODE */
            FIND FIRST num-serie NO-LOCK
                WHERE num-serie.ch-acesso = substr(INPUT fi-pesquisa, 10, 6) 
                  AND num-serie.id        = substr(INPUT fi-pesquisa,  1, 9) NO-ERROR.

            IF AVAIL num-serie THEN
            ASSIGN f-id:screen-value       in frame fpage0 = STRING(num-serie.ID)
                   f-chave:screen-value    in frame fpage0 = STRING(num-serie.ch-acesso)
                   f-nr-serie:screen-value in frame fpage0 = STRING(num-serie.n-serie). 
        END.
        WHEN 3 THEN DO: /* NÈMERO DE SêRIE */
            FIND FIRST num-serie NO-LOCK
                WHERE num-serie.n-serie = INPUT fi-pesquisa NO-ERROR.

            IF AVAIL num-serie THEN
            ASSIGN f-id:screen-value       in frame fpage0 = STRING(num-serie.ID)
                   f-chave:screen-value    in frame fpage0 = STRING(num-serie.ch-acesso)
                   f-nr-serie:screen-value in frame fpage0 = STRING(num-serie.n-serie). 
        END.
    END CASE.
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




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wWindow 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Reimpress∆o de etiquetas...":U).

    ASSIGN INPUT FRAME fPage0 rs-pesquisa
                              fi-pesquisa
                              fiPrinter
                              fiMotivo.

    RUN piValidateParam IN THIS-PROCEDURE (INPUT rs-pesquisa,
                                           INPUT fi-pesquisa,
                                           INPUT fiPrinter,
                                           INPUT fiMotivo).

    IF RETURN-VALUE = "NOK":U THEN DO:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-finalizar IN h-acomp.

        IF VALID-HANDLE(h-acomp) THEN
            DELETE PROCEDURE h-acomp.

        ASSIGN h-acomp = ?.

        RETURN "NOK":U.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Preparando para reimpress∆o...":U).


    IF  NOT AVAIL num-serie THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "N∆o existe etiqueta a ser impressa com o n£mero de sÇrie informado.").
    
        RETURN "NOK":U.
    END.

    RUN piImprimirEtiqueta IN THIS-PROCEDURE (INPUT num-serie.n-serie,
                                              INPUT num-serie.it-codigo,
                                              INPUT fiMotivo,
                                              INPUT caps(num-serie.id),
                                              INPUT caps(num-serie.ch-acesso)).

    IF RETURN-VALUE = "NOK":U THEN DO:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-finalizar IN h-acomp.

        IF VALID-HANDLE(h-acomp) THEN
            DELETE PROCEDURE h-acomp.

        ASSIGN h-acomp = ?.

        RETURN "NOK":U.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecuteARQ wWindow 
PROCEDURE piExecuteARQ :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Reimpress∆o de etiquetas...":U).

    ASSIGN INPUT FRAME fPage0 rs-pesquisa
                              fi-pesquisa
                              fiPrinter
                              fiMotivo.

    RUN piValidateParam IN THIS-PROCEDURE (INPUT rs-pesquisa,
                                           INPUT fi-pesquisa,
                                           INPUT fiPrinter,
                                           INPUT fiMotivo).

    IF RETURN-VALUE = "NOK":U THEN DO:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-finalizar IN h-acomp.

        IF VALID-HANDLE(h-acomp) THEN
            DELETE PROCEDURE h-acomp.

        ASSIGN h-acomp = ?.

        RETURN "NOK":U.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Preparando para reimpress∆o...":U).


    IF  NOT AVAIL num-serie THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "N∆o existe etiqueta a ser impressa com o n£mero de sÇrie informado.").
    
        RETURN "NOK":U.
    END.

    RUN piImprimirEtiquetaARQ IN THIS-PROCEDURE (INPUT num-serie.n-serie,
                                              INPUT num-serie.it-codigo,
                                              INPUT fiMotivo,
                                              INPUT caps(num-serie.id),
                                              INPUT caps(num-serie.ch-acesso)).

    IF RETURN-VALUE = "NOK":U THEN DO:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-finalizar IN h-acomp.

        IF VALID-HANDLE(h-acomp) THEN
            DELETE PROCEDURE h-acomp.

        ASSIGN h-acomp = ?.

        RETURN "NOK":U.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimirEtiqueta wWindow 
PROCEDURE piImprimirEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-serie AS CHAR        NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo AS CHAR        NO-UNDO.
    DEFINE INPUT  PARAMETER pMotivo     AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-ID        AS CHAR        NO-UNDO.
    DEFINE INPUT  PARAMETER p-ch-acesso AS CHAR        NO-UNDO.

    DEFINE VARIABLE c-cgc    AS CHAR FORMAT "99999999/9999-99" NO-UNDO. 
    DEFINE VARIABLE lastec   AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE c-qrcode AS CHAR FORMAT "x(60)" NO-UNDO.
    DEFINE VARIABLE iColuna  AS INTEGER     NO-UNDO.

    FOR FIRST item-ean NO-LOCK
        WHERE item-ean.it-codigo = p-it-codigo:
    END.
    FOR FIRST item-mat
        WHERE item-mat.it-codigo = p-it-codigo NO-LOCK:
    END.

    EMPTY TEMP-TABLE tt-lista-ns.

    CREATE tt-lista-ns.
    ASSIGN tt-lista-ns.num-serie = p-num-serie.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Reimprimindo etiqueta...":U).

    /* FAZ A IMPRESS«O. ESSA INCLUDE ê CHAMADA NA ESAPIA16 */
    {esapi/esapi016-600dpi.i}

    DO TRANS:
        FIND CURRENT num-serie EXCLUSIVE-LOCK.
    
        IF  AVAIL num-serie THEN DO:
            ASSIGN num-serie.re-impr = num-serie.re-impr + 1
                   num-serie.dt-ult-re = NOW
                   num-serie.us-ult-re = c-seg-usuario
                   num-serie.motiv-re = pMotivo.
                   num-serie.tipo-re = 1.
            FIND CURRENT num-serie NO-LOCK.
            RELEASE num-serie.
        END.
    END.

    /*
    FOR FIRST tt-lista-ns:
        FOR FIRST etiq-coletiva
            WHERE etiq-coletiva.cod-etiqueta = tt-lista-ns.num-serie EXCLUSIVE-LOCK:
    
            CREATE tt-etiq-coletiva.
            BUFFER-COPY etiq-coletiva TO tt-etiq-coletiva.
    
            ASSIGN p-qtd-embal                = etiq-coletiva.quantidade
                   etiq-coletiva.re-impr      = etiq-coletiva.re-impr + 1
                   etiq-coletiva.dt-ult-re    = NOW
                   etiq-coletiva.usuar-ult-re = c-seg-usuario.
        END.
    END.
    */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimirEtiquetaARQ wWindow 
PROCEDURE piImprimirEtiquetaARQ :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-serie AS CHAR        NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo AS CHAR        NO-UNDO.
    DEFINE INPUT  PARAMETER pMotivo     AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-ID        AS CHAR        NO-UNDO.
    DEFINE INPUT  PARAMETER p-ch-acesso AS CHAR        NO-UNDO.

    DEFINE VARIABLE c-cgc    AS CHAR FORMAT "99999999/9999-99" NO-UNDO. 
    DEFINE VARIABLE lastec   AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE c-qrcode AS CHAR FORMAT "x(60)" NO-UNDO.
    DEFINE VARIABLE iColuna  AS INTEGER     NO-UNDO.

    FOR FIRST item-ean NO-LOCK
        WHERE item-ean.it-codigo = p-it-codigo:
    END.
    FOR FIRST item-mat
        WHERE item-mat.it-codigo = p-it-codigo NO-LOCK:
    END.

    EMPTY TEMP-TABLE tt-lista-ns.

    CREATE tt-lista-ns.
    ASSIGN tt-lista-ns.num-serie = p-num-serie.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Reimprimindo etiqueta...":U).

    /* FAZ A IMPRESS«O. ESSA INCLUDE ê CHAMADA NA ESAPIA16 */
    {esapi/esapi016-600dpi.i}
/*
    DO TRANS:
        FIND CURRENT num-serie EXCLUSIVE-LOCK.
    
        IF  AVAIL num-serie THEN DO:
            ASSIGN num-serie.re-impr = num-serie.re-impr + 1
                   num-serie.dt-ult-re = NOW
                   num-serie.us-ult-re = c-seg-usuario
                   num-serie.motiv-re = pMotivo.
                   num-serie.tipo-re = 1.
            FIND CURRENT num-serie NO-LOCK.
            RELEASE num-serie.
        END.
    END. */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelectPrinter wWindow 
PROCEDURE piSelectPrinter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTempFile AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cAuxFile  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cPrev     AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME fPage0 fiPrinter.

    ASSIGN cPrev     = fiPrinter
           cTempFile = REPLACE(fiPrinter, ":":U, ",":U).

    IF fiPrinter <> "":U THEN DO:
        IF NUM-ENTRIES(cTempFile) = 4 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile) + ":":U + ENTRY(4, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 3 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 2 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = "":U.
    END.

    RUN utp/ut-impr.w (INPUT-OUTPUT cPrinter,
                       INPUT-OUTPUT cLayout,
                       INPUT-OUTPUT cAuxFile).


    
    IF cAuxFile = "":U THEN
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout
               l-arquivo = NO.

    ELSE
        ASSIGN fiPrinter = cAuxFile
               l-arquivo = YES.

    IF fiPrinter = ":":U THEN
        ASSIGN fiPrinter = cPrev.

    DISPLAY fiPrinter
        WITH FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidateParam wWindow 
PROCEDURE piValidateParam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pRspesquisa    AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER pFipesquisa    AS CHAR        NO-UNDO.
    DEFINE INPUT  PARAMETER pPrinter       AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pMotivo        AS CHARACTER   NO-UNDO.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Validando parÉmetros...":U).

    IF  pFipesquisa = "":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "ID, QR Code ou N£mero de SÇrie deve ser informado").

        RETURN "NOK":U.
    END.

    IF pMotivo = "":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Motivo da Reimpress∆o deve ser preenchido!":U).

        RETURN "NOK":U.
    END.

    CASE pRspesquisa:
        WHEN 1 THEN DO: /* ID*/
            FIND num-serie NO-LOCK
                WHERE num-serie.ID = pFipesquisa NO-ERROR.

            IF  NOT AVAILABLE num-serie THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "N∆o existe etiqueta a ser impressa com o ID informado.").

                RETURN "NOK":U.
            END.
        END.
        WHEN 2 THEN DO: /* QR-CODE */
            FIND FIRST num-serie NO-LOCK
                WHERE num-serie.ch-acesso = substr(pFipesquisa, 10, 6) 
                  AND num-serie.id        = substr(pFipesquisa,  1, 9) NO-ERROR.

            IF  NOT AVAILABLE num-serie THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "N∆o existe etiqueta a ser impressa com o QR Code informado.").

                RETURN "NOK":U.
            END.
        END.
        WHEN 3 THEN DO: /* NÈMERO DE SêRIE */
            FIND FIRST num-serie NO-LOCK
                WHERE num-serie.n-serie = pFipesquisa NO-ERROR.

            IF  NOT AVAILABLE num-serie THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "N∆o existe etiqueta a ser impressa com o n£mero de sÇrie informado.").

                RETURN "NOK":U.
            END.
        END.
    END CASE.
    
    IF l-arquivo = NO
    THEN DO:
        IF NUM-ENTRIES(pPrinter, ":":U) = 2 THEN DO:
            ASSIGN cPrinter = SUBSTRING(pPrinter, 1, INDEX(pPrinter, ":":U) - 1)
                   cLayout  = SUBSTRING(pPrinter, INDEX(pPrinter, ":":U) + 1, LENGTH(pPrinter) - INDEX(pPrinter, ":":U)).
    
            FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
                WHERE imprsor_usuar.nom_impressora = cPrinter
                  AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.
    
            IF NOT AVAILABLE imprsor_usuar THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 4306,
                                   INPUT c-seg-usuario).
    
                RETURN "NOK":U.
            END.
    
            FIND FIRST layout_impres
                WHERE layout_impres.nom_impressora    = cPrinter
                  AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.
    
            IF NOT AVAILABLE layout_impres THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 4306,
                                   INPUT c-seg-usuario).
    
                RETURN "NOK":U.
            END.
        END.
        ELSE DO:
            IF NUM-ENTRIES(pPrinter, ":":U) < 2 THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 4306,
                                   INPUT c-seg-usuario).
    
                RETURN "NOK":U.
            END.
    
            ASSIGN cPrinter = ENTRY(1, pPrinter, ":":U)
                   cLayout  = ENTRY(2, pPrinter, ":":U).
    
            FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
                WHERE imprsor_usuar.nom_impressora = cPrinter
                  AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.
    
            IF NOT AVAILABLE imprsor_usuar THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 4306,
                                   INPUT c-seg-usuario).
    
                RETURN "NOK":U.
            END.
    
            FIND FIRST layout_impres
                WHERE layout_impres.nom_impressora = cPrinter
                  AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.
    
            IF NOT AVAILABLE layout_impres THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 4306,
                                   INPUT c-seg-usuario).
    
                RETURN "NOK":U.
            END.
        END.
    
        ASSIGN v_nom_disposit_so = imprsor_usuar.nom_disposit_so.
    END.
    ELSE DO:
        ASSIGN v_nom_disposit_so = fiPrinter.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

