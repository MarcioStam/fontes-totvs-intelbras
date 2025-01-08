&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Global Shared Definitions ---                                        */

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER   NO-UNDO.

/* Include Definitions ---                                              */

{upc/btb910za-upc.i}
{esp/ShowMsg.i}
{esp/es0018.i}
{METHOD/dbotterr.i}
{bcp/bcapi001.i}
{bcp/bcapi002.i}
{cdp/cd0666.i}

DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.
/* Local Temp-Table Definitions ---                                     */
DEFINE TEMP-TABLE tt-volume-docto NO-UNDO
    FIELD sel          AS CHAR
    FIELD cod-estabel  AS CHAR
    FIELD cod-local    AS CHAR
    FIELD nro-docto    AS CHAR 
    FIELD id-docto     AS DEC
    FIELD nr-volume    LIKE volume-nf.nr-volume
    FIELD serie        AS CHAR 
    FIELD n-serie      AS CHAR
    FIELD cod-item     AS CHAR FORMAT "x(10)"
    FIELD qtde         AS DEC
    FIELD qtde-col     AS DEC
    FIELD l-componente AS LOG
    FIELD sequencia    AS INT
    FIELD log-conferido AS LOG.

DEF BUFFER tt-volume-docto-aux  FOR tt-volume-docto .
DEF BUFFER tt-volume-docto-aux2 FOR tt-volume-docto .

DEFINE TEMP-TABLE ttitem NO-UNDO
    FIELD it-codigo LIKE item-ean.it-codigo
    FIELD desc-item AS CHARACTER FORMAT "x(60)":U
    INDEX item
        it-codigo.

def var h-acomp               as handle                 no-undo.

DEFINE BUFFER b-tt-volume-docto FOR tt-volume-docto.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE lcompleto   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lvarios     AS LOGICAL     NO-UNDO.
DEFINE VARIABLE vean        AS INTEGER     NO-UNDO.
DEFINE VARIABLE pit-codigo  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-caixa     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-ok        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-selec     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-pallet    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tipo-etiq AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-item-aux  AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-tipo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-quantidade AS DECIMAL   NO-UNDO.
DEFINE VARIABLE c-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-desc-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-status AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-numero-volumes AS INTEGER     NO-UNDO.

DEFINE VARIABLE l-finalizou AS LOGICAL     NO-UNDO.

/* Local Buffer Definitions ---                                         */

DEFINE BUFFER bvolume-nf        FOR volume-nf.
DEFINE BUFFER b-volume-nf        FOR volume-nf.
DEFINE BUFFER bitem-mat         FOR item-mat.
DEFINE BUFFER bns-volume        FOR ns-volume.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.

DEFINE VARIABLE fi-serie        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE fi-embalagem    AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-tipo-etiqueta AS INTEGER     NO-UNDO.   /* 1 - Volume / 2 - Item/Barra */

DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-esapi003  AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-volume

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-volume-docto

/* Definitions for BROWSE br-volume                                     */
&Scoped-define FIELDS-IN-QUERY-br-volume tt-volume-docto.sel tt-volume-docto.cod-item f-desc-item(tt-volume-docto.cod-item) @ c-desc-item tt-volume-docto.qtde   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-volume   
&Scoped-define SELF-NAME br-volume
&Scoped-define QUERY-STRING-br-volume FOR EACH tt-volume-docto
&Scoped-define OPEN-QUERY-br-volume OPEN QUERY {&SELF-NAME} FOR EACH tt-volume-docto .
&Scoped-define TABLES-IN-QUERY-br-volume tt-volume-docto
&Scoped-define FIRST-TABLE-IN-QUERY-br-volume tt-volume-docto


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-volume}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-cod-estabel fi-cod-local fi-nro-docto ~
fi-ean13 br-volume btCancel btExit btFinalizar btImprimir rec-v RECT-1 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-estabel c-text1 fi-cod-local ~
fi-nro-docto fi-nr-volume fi-nr-nota-fis 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-desc-item wWindow 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-nota-export wWindow 
FUNCTION f-nota-export RETURNS LOGICAL
  ( INPUT p-estab AS CHAR,
    INPUT p-serie  AS CHAR,
    INPUT p-nota AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar(F5)" 
     SIZE-PIXELS 70 BY 24
     FONT 4.

DEFINE BUTTON btExit 
     LABEL "Sair(esc)" 
     SIZE-PIXELS 70 BY 24
     FONT 4.

DEFINE BUTTON btFinalizar 
     LABEL "Finalizar(F8)" 
     SIZE-PIXELS 70 BY 24
     FONT 4.

DEFINE BUTTON btImprimir 
     LABEL "Imprimir" 
     SIZE-PIXELS 70 BY 24
     FONT 4.

DEFINE VARIABLE c-text1 AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE-PIXELS 49 BY 16
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(03)":U 
     LABEL "Estabel" 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-local AS CHARACTER FORMAT "X(03)":U 
     LABEL "Local" 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ean13 AS CHARACTER FORMAT "X(200)":U 
     LABEL "Num. SÇrie" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 193 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-nr-nota-fis AS CHARACTER FORMAT "X(16)" 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 88 BY 21
     FONT 4.

DEFINE VARIABLE fi-nr-volume AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Volume" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 53 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-nro-docto AS CHARACTER FORMAT "X(20)":U 
     LABEL "Nr Docto" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 193 BY 21
     FONT 4 NO-UNDO.

DEFINE RECTANGLE rec-v
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE-PIXELS 42 BY 78 TOOLTIP "Vermelho = Pendente | Azul = Conferido | Verde = Finalizado".

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 273 BY 78.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-volume FOR 
      tt-volume-docto SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-volume wWindow _FREEFORM
  QUERY br-volume DISPLAY
      tt-volume-docto.sel         COLUMN-LABEL "*" WIDTH 2
tt-volume-docto.cod-item    COLUMN-LABEL "Item" WIDTH 10
f-desc-item(tt-volume-docto.cod-item) @ c-desc-item COLUMN-LABEL "Descriá∆o" FORMAT "X(20)" WIDTH 25
tt-volume-docto.qtde         COLUMN-LABEL "Qtd." WIDTH 8
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 46 BY 7
          &ELSE SIZE-PIXELS 320 BY 173 &ENDIF
         FONT 7 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-cod-estabel AT ROW 1.46 COL 9.43 COLON-ALIGNED WIDGET-ID 36
     c-text1 AT Y 12 X 126 NO-LABEL WIDGET-ID 32
     fi-cod-local AT ROW 1.5 COL 29.29 COLON-ALIGNED WIDGET-ID 40
     fi-nro-docto AT Y 35 X 59 COLON-ALIGNED WIDGET-ID 4
     fi-nr-volume AT Y 59 X 199 COLON-ALIGNED WIDGET-ID 30
     fi-nr-nota-fis AT Y 59 X 59 COLON-ALIGNED WIDGET-ID 8
     fi-ean13 AT Y 35 X 59 COLON-ALIGNED WIDGET-ID 16
     br-volume AT Y 90 X 0 WIDGET-ID 200
     btCancel AT Y 264 X 180
     btExit AT Y 264 X 250 HELP
          "Sair"
     btFinalizar AT Y 264 X 109 WIDGET-ID 34
     btImprimir AT Y 264 X 38 WIDGET-ID 38
     rec-v AT Y 6 X 274 WIDGET-ID 26
     RECT-1 AT Y 6 X 0 WIDGET-ID 28
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
         TITLE              = "esbcp020"
         HEIGHT-P           = 300
         WIDTH-P            = 320
         MAX-HEIGHT-P       = 705
         MAX-WIDTH-P        = 1366
         VIRTUAL-HEIGHT-P   = 705
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Size-to-Fit Custom                                        */
/* BROWSE-TAB br-volume fi-ean13 fpage0 */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN c-text1 IN FRAME fpage0
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       c-text1:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fi-ean13 IN FRAME fpage0
   NO-DISPLAY                                                           */
ASSIGN 
       fi-ean13:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN fi-nr-nota-fis IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nr-volume IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-volume
/* Query rebuild information for BROWSE br-volume
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-volume-docto .
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-volume */
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
ON END-ERROR OF wWindow /* esbcp020 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* esbcp020 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-volume
&Scoped-define SELF-NAME br-volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-volume wWindow
ON F5 OF br-volume IN FRAME fpage0
DO:

    APPLY "CHOOSE" TO btCancel.

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-volume wWindow
ON MOUSE-SELECT-DBLCLICK OF br-volume IN FRAME fpage0
DO:
    IF AVAIL tt-volume-docto THEN DO:
        IF tt-volume-docto.sel = "*" THEN DO:
            ASSIGN tt-volume-docto.sel = "".
        END.
        ELSE DO:
            FIND FIRST tt-volume-docto-aux
                 WHERE tt-volume-docto-aux.cod-estabel = tt-volume-docto.cod-estabel 
                   AND tt-volume-docto-aux.cod-local   = tt-volume-docto.cod-local   
                   AND tt-volume-docto-aux.nro-docto   = tt-volume-docto.nro-docto   
                   AND tt-volume-docto-aux.sequencia   <> tt-volume-docto.sequencia   
                   AND tt-volume-docto-aux.sel         = "*" NO-ERROR.
            IF AVAIL tt-volume-docto-aux THEN
                ASSIGN tt-volume-docto-aux.sel = "".
        
            ASSIGN tt-volume-docto.sel = "*".
        END.
    END.

    br-volume:REFRESH().

    APPLY "ENTRY" TO fi-ean13 IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-volume wWindow
ON ROW-DISPLAY OF br-volume IN FRAME fpage0
DO:
    // Vermelho
    IF tt-volume-docto.log-conferido = NO THEN
        ASSIGN tt-volume-docto.cod-item:FGCOLOR IN BROWSE br-volume = 12
               c-desc-item:FGCOLOR IN BROWSE br-volume = 12
               tt-volume-docto.qtde:FGCOLOR IN BROWSE br-volume = 12.
        
    ELSE // Azul
        ASSIGN tt-volume-docto.cod-item:FGCOLOR IN BROWSE br-volume = 9
               c-desc-item:FGCOLOR IN BROWSE br-volume = 9
               tt-volume-docto.qtde:FGCOLOR IN BROWSE br-volume = 9.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar(F5) */
DO:

    FIND FIRST wm-docto NO-LOCK
         WHERE wm-docto.cod-estabel = fi-cod-estabel
           AND wm-docto.cod-local   = fi-cod-local
           AND wm-docto.num-docto   = fi-nro-docto
           AND wm-docto.ind-tipo-trans = 2 NO-ERROR. // Saida
    IF NOT AVAIL wm-docto THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "Documento n∆o encontrado",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        RETURN NO-APPLY.
    END.

    IF wm-docto.log-2 THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "Documento j† finalizado",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        RETURN NO-APPLY.
    END.

    FOR EACH es-wm-docto-it-serie EXCLUSIVE-LOCK
       WHERE es-wm-docto-it-serie.cod-estabel  = wm-docto.cod-estabel
         AND es-wm-docto-it-serie.cod-local    = wm-docto.cod-local
         AND es-wm-docto-it-serie.id-docto     = wm-docto.id-docto:
        DELETE es-wm-docto-it-serie.
    END.
    
    FOR EACH es-conferencia-docto EXCLUSIVE-LOCK
       WHERE es-conferencia-docto.cod-estabel   = wm-docto.cod-estabel
         AND es-conferencia-docto.cod-local     = wm-docto.cod-local
         AND es-conferencia-docto.nro-docto     = wm-docto.num-docto:
        DELETE es-conferencia-docto.
    END.

    assign fi-nro-docto:VISIBLE IN FRAME {&FRAME-NAME} = YES
           fi-ean13:VISIBLE IN FRAME {&FRAME-NAME} = NO.

    RUN pi_limpa.
    
    APPLY "entry" TO fi-cod-estabel IN FRAME fPage0.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON F5 OF btCancel IN FRAME fpage0 /* Cancelar(F5) */
DO:

    APPLY "CHOOSE" TO btCancel.

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Sair(esc) */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON F5 OF btExit IN FRAME fpage0 /* Sair(esc) */
DO:

    APPLY "CHOOSE" TO btCancel.

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFinalizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFinalizar wWindow
ON CHOOSE OF btFinalizar IN FRAME fpage0 /* Finalizar(F8) */
DO:
    DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.

    RUN pi_finalizar.

    IF i-numero-volumes = 0  THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "N£mero de volumes deve ser informado",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        RETURN NO-APPLY.
    END.

    FIND FIRST wm-docto NO-LOCK
         WHERE wm-docto.cod-estabel = fi-cod-estabel
           AND wm-docto.cod-local   = fi-cod-local
           AND wm-docto.num-docto   = fi-nro-docto
           AND wm-docto.ind-tipo-trans = 2 NO-ERROR. // Saida
    IF AVAIL wm-docto THEN DO:
        RUN esp/wmp/returnDoctoSaida.p(INPUT  ROWID(wm-docto),
                                       INPUT  i-numero-volumes,
                                       OUTPUT l-erro,
                                       OUTPUT TABLE rowErrors).
        IF CAN-FIND(FIRST rowErrors) THEN DO:
            FOR EACH rowErrors:
                 {&WINDOW-NAME}:SENSITIVE = FALSE.
                 RUN esp/clt/esclt006.w (INPUT string(rowErrors.errornumber) + " - " + rowErrors.errordescription,
                                         INPUT NO).
                 {&WINDOW-NAME}:SENSITIVE = TRUE.
    
            END.
        END.
        ELSE DO:
            IF l-erro = YES THEN DO:
                {&WINDOW-NAME}:SENSITIVE = FALSE.
                RUN esp/clt/esclt006.w (INPUT "Erro no processo de retorno",
                                        INPUT NO).
                {&WINDOW-NAME}:SENSITIVE = TRUE.

            END.
            ELSE DO:
                {&WINDOW-NAME}:SENSITIVE = FALSE.
                RUN esp/clt/esclt006.w (INPUT "Retorno enviado para o Protheus",
                                        INPUT NO).
                {&WINDOW-NAME}:SENSITIVE = TRUE.
            END.
    
        END.
    
        RUN pi_limpa.
    END.
    
    APPLY "entry" TO fi-cod-estabel IN FRAME fPage0.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFinalizar wWindow
ON F5 OF btFinalizar IN FRAME fpage0 /* Finalizar(F8) */
DO:

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimir wWindow
ON CHOOSE OF btImprimir IN FRAME fpage0 /* Imprimir */
DO:

    /*
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    {utp/ut-liter.i Imprimindo *}
    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).
    */
    ASSIGN INPUT FRAME fpage0 
        fi-cod-estabel
        fi-cod-local
        fi-nr-volume
        fi-nr-nota-fis.

    DEFINE VARIABLE iSequencia AS INTEGER     NO-UNDO.
    DEFINE VARIABLE lErro      AS LOGICAL     NO-UNDO.

    FIND FIRST wm-docto NO-LOCK
         WHERE wm-docto.cod-estabel = fi-cod-estabel
           AND wm-docto.cod-local   = fi-cod-local
           AND wm-docto.num-docto   = fi-nr-nota-fis
           AND wm-docto.ind-tipo-trans = 2 NO-ERROR. // Saida
    IF NOT AVAIL wm-docto THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "Pedido n∆o encontrado.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        RETURN NO-APPLY.
        
    END.

    // API de impress∆o de etiqueta de item
    RUN esp/wmp/eswmapi008.p(INPUT  fi-nr-volume,
                             INPUT  ROWID(wm-docto),
                             OUTPUT TABLE rowerrors).

    /*
    IF wm-docto.log-2 = NO THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "Retorno n∆o realizado.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        RETURN NO-APPLY.

    END.
    */
    
    IF VALID-HANDLE(h-acomp) THEN
        DELETE OBJECT h-acomp.

    IF CAN-FIND(FIRST rowerrors) THEN DO:
         {&WINDOW-NAME}:SENSITIVE = FALSE.
         RUN esp/clt/esclt006.w (INPUT "Nenhuma etiqueta foi impressa",
                                 INPUT NO).
         {&WINDOW-NAME}:SENSITIVE = TRUE.
        RETURN "NOK":U.
    END.
    ELSE DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "Etiquetas impressas com sucesso",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
    END.
    
    RETURN "OK":U.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimir wWindow
ON F5 OF btImprimir IN FRAME fpage0 /* Imprimir */
DO:

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wWindow
ON LEAVE OF fi-cod-estabel IN FRAME fpage0 /* Estabel */
DO:
    ASSIGN INPUT FRAME fPage0 fi-cod-estabel.

    FIND FIRST wm-local NO-LOCK
         WHERE wm-local.cod-estabel      = fi-cod-estabel
           AND wm-local.log-local-padrao = YES NO-ERROR.
    IF AVAIL wm-local THEN 
        ASSIGN fi-cod-local:SCREEN-VALUE IN FRAME fpage0 = wm-local.cod-local.
    ELSE
        ASSIGN fi-cod-local:SCREEN-VALUE IN FRAME fpage0 = "".
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wWindow
ON RETURN OF fi-cod-estabel IN FRAME fpage0 /* Estabel */
DO:

    APPLY "ENTRY" TO fi-cod-local IN FRAME fpage0.
  
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-local wWindow
ON RETURN OF fi-cod-local IN FRAME fpage0 /* Local */
DO:

    APPLY "ENTRY" TO fi-nro-docto IN FRAME fpage0.

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ean13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ean13 wWindow
ON F5 OF fi-ean13 IN FRAME fpage0 /* Num. SÇrie */
DO:
    APPLY "CHOOSE" TO btCancel.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ean13 wWindow
ON RETURN OF fi-ean13 IN FRAME fpage0 /* Num. SÇrie */
DO:
    DEF VAR c-tipo-aux AS CHAR NO-UNDO.
    DEF VAR c-item     AS CHAR NO-UNDO.
    DEFINE VARIABLE l-achou AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-nr-seq-item AS INTEGER     NO-UNDO.

    DEFINE VARIABLE i-aux       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-ean13-aux AS CHARACTER NO-UNDO.
    
    ASSIGN l-achou = NO.
    BLOCO:
    DO TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:
        ASSIGN INPUT FRAME fPage0 fi-ean13.

        ASSIGN fi-ean13:SCREEN-VALUE IN FRAME fPage0 = UPPER(fi-ean13:SCREEN-VALUE IN FRAME fPage0).

        DO i-aux = 1 TO LENGTH(fi-ean13:SCREEN-VALUE IN FRAME fPage0):
           IF  (ASC(SUBSTRING(fi-ean13:SCREEN-VALUE IN FRAME fPage0,i-aux,1)) >= 65 AND ASC(SUBSTRING(fi-ean13:SCREEN-VALUE IN FRAME fPage0,i-aux,1)) <= 90) OR    /* A - Z */
               (ASC(SUBSTRING(fi-ean13:SCREEN-VALUE IN FRAME fPage0,i-aux,1)) >= 48 AND ASC(SUBSTRING(fi-ean13:SCREEN-VALUE IN FRAME fPage0,i-aux,1)) <= 57) THEN  /* 0 - 9 */
               ASSIGN c-ean13-aux = c-ean13-aux + SUBSTRING(fi-ean13:SCREEN-VALUE IN FRAME fPage0,i-aux,1).
        END.

        IF c-ean13-aux <> '' THEN
           ASSIGN fi-ean13:SCREEN-VALUE IN FRAME fPage0 = c-ean13-aux.

        FIND FIRST tt-volume-docto-aux 
             WHERE tt-volume-docto-aux.sel = "*" NO-ERROR.
        IF AVAIL tt-volume-docto-aux THEN DO:

            ASSIGN i-nr-seq-item = tt-volume-docto-aux.sequencia.

            IF fi-ean13:SCREEN-VALUE IN FRAME fPage0 = "" THEN DO:
                {&WINDOW-NAME}:SENSITIVE = FALSE.
                RUN esp/clt/esclt006.w (INPUT "NS em branco",
                                        INPUT NO).
                {&WINDOW-NAME}:SENSITIVE = TRUE.
                RETURN NO-APPLY.
            END.

            RUN pi-trata-ean13 (INPUT tt-volume-docto-aux.cod-estabel,
                                INPUT tt-volume-docto-aux.cod-local,
                                INPUT tt-volume-docto-aux.nro-docto,
                                INPUT tt-volume-docto-aux.cod-item,
                                INPUT tt-volume-docto-aux.sequencia,
                                INPUT tt-volume-docto-aux.qtde-col,
                                INPUT tt-volume-docto-aux.id-docto).

            // Cria tabela para controle dos seriais conferidos
            IF RETURN-VALUE = "OK" THEN DO:
                FIND FIRST es-wm-docto-it-serie EXCLUSIVE-LOCK
                     WHERE es-wm-docto-it-serie.cod-estabel  = tt-volume-docto-aux.cod-estabel
                       AND es-wm-docto-it-serie.cod-local    = tt-volume-docto-aux.cod-local
                       AND es-wm-docto-it-serie.id-docto     = tt-volume-docto-aux.id-docto
                       AND es-wm-docto-it-serie.cod-item     = tt-volume-docto-aux.cod-item
                       AND es-wm-docto-it-serie.num-seq-item = tt-volume-docto-aux.sequencia
                       AND es-wm-docto-it-serie.num-serie    = fi-ean13:SCREEN-VALUE IN FRAME fPage0 NO-ERROR.
                IF NOT AVAIL es-wm-docto-it-serie THEN DO:
                    CREATE es-wm-docto-it-serie.
                    ASSIGN es-wm-docto-it-serie.cod-estabel  = tt-volume-docto-aux.cod-estabel
                           es-wm-docto-it-serie.cod-local    = tt-volume-docto-aux.cod-local  
                           es-wm-docto-it-serie.id-docto     = tt-volume-docto-aux.id-docto   
                           es-wm-docto-it-serie.cod-item     = tt-volume-docto-aux.cod-item   
                           es-wm-docto-it-serie.num-seq-item = tt-volume-docto-aux.sequencia
                           es-wm-docto-it-serie.num-serie    = fi-ean13:SCREEN-VALUE IN FRAME fPage0.
                END.
                ASSIGN es-wm-docto-it-serie.qtd-item = es-wm-docto-it-serie.qtd-item + 1.

                ASSIGN fi-ean13 = "".

                DISP fi-ean13
                    WITH FRAME fpage0.

            END.
        END.
        ELSE DO:
            {&WINDOW-NAME}:SENSITIVE = FALSE.
            RUN esp/clt/esclt006.w (INPUT "Selecione o item para conferir.",
                                    INPUT NO).
            {&WINDOW-NAME}:SENSITIVE = TRUE.
            RETURN NO-APPLY.

        END.
    END.

    RUN pi-cria-tt (INPUT NO).
    // Marca a linha que estava selecionada
    FIND FIRST tt-volume-docto
         WHERE tt-volume-docto.sequencia  = i-nr-seq-item NO-ERROR.
    IF AVAIL tt-volume-docto THEN 
        ASSIGN tt-volume-docto.sel = "*".

    {&OPEN-QUERY-br-volume}

    //br-volume:DESELECT-ROWS().

    IF l-finalizou THEN DO:
        BELL.

        ASSIGN fi-nro-docto:VISIBLE IN FRAME fPage0 = YES
               fi-ean13:VISIBLE IN FRAME fpage0     = NO
               rec-v:FGCOLOR                        = 9  /* Azul */
               rec-v:BGCOLOR                        = 9.

        APPLY "ENTRY":U TO fi-cod-estabel IN FRAME fPage0.
    END.
    ELSE DO:
        ASSIGN rec-v:FGCOLOR = 12  /* Vermelho */
               rec-v:BGCOLOR = 12.

        APPLY "ENTRY":U TO fi-ean13 IN FRAME fPage0.
    END.

    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nro-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nro-docto wWindow
ON F5 OF fi-nro-docto IN FRAME fpage0 /* Nr Docto */
DO:

    APPLY "CHOOSE" TO btCancel.

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nro-docto wWindow
ON RETURN OF fi-nro-docto IN FRAME fpage0 /* Nr Docto */
DO:
    
    ASSIGN INPUT FRAME fPage0 fi-cod-estabel fi-cod-local.
    
    IF INPUT fi-nro-docto = "" THEN RETURN NO-APPLY.
    
    ASSIGN fi-nro-docto = INPUT fi-nro-docto.

    ASSIGN c-text1:SCREEN-VALUE = "".

    FIND FIRST wm-local NO-LOCK
         WHERE wm-local.cod-estabel      = fi-cod-estabel
           AND wm-local.cod-local        = fi-cod-local NO-ERROR.
    IF NOT AVAIL wm-local THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "N∆o encontrado local padr∆o para o estabelecimento informado.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        RETURN NO-APPLY.
    END.

    FIND FIRST wm-docto NO-LOCK
         WHERE wm-docto.cod-estabel = fi-cod-estabel
           AND wm-docto.cod-local   = fi-cod-local
           AND wm-docto.num-docto   = fi-nro-docto
           AND wm-docto.ind-tipo-trans = 2 NO-ERROR. // Saida
    IF NOT AVAIL wm-docto THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "Documento de sa°da n∆o encontrado.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.

        ASSIGN fi-nro-docto = "".
        DISP fi-nro-docto WITH FRAME fPage0.
        RUN pi_limpa.
        RETURN NO-APPLY.
    END.

    /*
    IF wm-docto.ind-sit-docto <> 2 THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "Documento n∆o est† conclu°do.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.

        ASSIGN fi-nro-docto = "".
        DISP fi-nro-docto WITH FRAME fPage0.
        RUN pi_limpa.
        RETURN NO-APPLY.
    END.
    */

    ASSIGN fi-nr-nota-fis = fi-nro-docto
           fi-nr-volume   = int(SUBSTRING(wm-docto.char-2,21,6)).

    DISP fi-nr-nota-fis
        WITH FRAME fPage0.
    
    DISP fi-nro-docto 
         fi-nr-nota-fis
         fi-nr-volume
         WITH FRAME fpage0.
    
    RUN pi-cria-tt (INPUT YES).
    {&OPEN-QUERY-br-volume}

    br-volume:DESELECT-ROWS().

    IF l-finalizou = NO THEN DO:
        ASSIGN fi-nro-docto:VISIBLE IN FRAME {&FRAME-NAME} = NO
               fi-cod-estabel:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               fi-cod-local:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               fi-ean13:VISIBLE IN FRAME {&FRAME-NAME} = YES
               rec-v:FGCOLOR = 12
               rec-v:BGCOLOR = 12.
    END.
    ELSE DO:
        IF wm-docto.log-2 = NO THEN 
            ASSIGN fi-ean13:VISIBLE IN FRAME {&FRAME-NAME} = NO
                   rec-v:FGCOLOR = 9
                   rec-v:BGCOLOR = 9.
        ELSE
            ASSIGN fi-ean13:VISIBLE IN FRAME {&FRAME-NAME} = NO
                   rec-v:FGCOLOR = 2
                   rec-v:BGCOLOR = 2.
    END.

    APPLY "entry" TO fi-ean13 IN FRAME fPage0.

    FOR FIRST tt-volume-docto
        WHERE tt-volume-docto.log-conferido = NO:
        REPOSITION br-volume TO ROWID (ROWID(tt-volume-docto)).
        br-volume:SELECT-FOCUSED-ROW().
    END. 

    /*
    IF lcompleto THEN DO:
        ASSIGN fi-nro-docto = "".
        DISP fi-nro-docto with frame fPage0.
        ASSIGN fi-ean13:VISIBLE IN FRAME {&FRAME-NAME} = NO
               rec-v:FGCOLOR = 2
               rec-v:BGCOLOR = 2.
    END.
    ELSE DO:
        ASSIGN fi-nro-docto:VISIBLE IN FRAME {&FRAME-NAME} = NO
               fi-ean13:VISIBLE IN FRAME {&FRAME-NAME} = YES
               rec-v:FGCOLOR = 12
               rec-v:BGCOLOR = 12.
        APPLY "entry" TO fi-ean13 IN FRAME fPage0.
    END.
    */

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
    
  assign fi-ean13:VISIBLE = FALSE
         rec-v:FGCOLOR = 12
         rec-v:BGCOLOR = 12
         i-tipo-etiqueta = 1
         btFinalizar:SENSITIVE IN FRAME fpage0 = NO.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow 
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow 
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  VIEW FRAME fPage0 IN WINDOW wWindow.

  ENABLE {&ENABLED-OBJECTS} WITH FRAME fPage0.

  DISP {&DISPLAYED-OBJECTS} WITH FRAME fPage0.

  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt wWindow 
PROCEDURE pi-cria-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM l-carrega-tudo AS LOG.
    
    ASSIGN i-seq = 0.
    
    EMPTY TEMP-TABLE tt-volume-docto.
    FOR EACH wm-docto-itens OF wm-docto NO-LOCK:
        // Item sem controle por serie j† criado como conferido
        FIND FIRST wm-item NO-LOCK
             WHERE wm-item.cod-item = wm-docto-itens.cod-item NO-ERROR.
        IF AVAIL wm-item AND wm-item.log-2 = NO THEN DO:
            FIND FIRST es-conferencia-docto EXCLUSIVE-LOCK
                 WHERE es-conferencia-docto.cod-estabel = wm-docto-itens.cod-estabel
                   AND es-conferencia-docto.cod-local   = wm-docto-itens.cod-local  
                   AND es-conferencia-docto.nro-docto   = wm-docto.num-docto        
                   AND es-conferencia-docto.cod-item    = wm-docto-itens.cod-item 
                   AND es-conferencia-docto.nr-seq-item = wm-docto-itens.num-seq-item NO-ERROR.
            IF NOT AVAIL es-conferencia-docto THEN  DO:
                CREATE es-conferencia-docto.
                ASSIGN es-conferencia-docto.cod-estabel   = wm-docto-itens.cod-estabel
                       es-conferencia-docto.cod-local     = wm-docto-itens.cod-local
                       es-conferencia-docto.nro-docto     = wm-docto.num-docto
                       es-conferencia-docto.cod-item      = wm-docto-itens.cod-item
                       es-conferencia-docto.nr-seq-item   = wm-docto-itens.num-seq-item
                       es-conferencia-docto.log-conferido = YES
                       es-conferencia-docto.qt-conf       = wm-docto-itens.qtd-item
                       es-conferencia-docto.qt-volume     = wm-docto-itens.qtd-item
                       es-conferencia-docto.cod-usuar     = c-seg-usuario
                       es-conferencia-docto.hora          = TIME
                       es-conferencia-docto.data          = TODAY.
            END.
        END.

        FIND FIRST tt-volume-docto
             WHERE tt-volume-docto.cod-estabel = wm-docto-itens.cod-estabel
               AND tt-volume-docto.cod-local   = wm-docto-itens.cod-local
               AND tt-volume-docto.nro-docto   = wm-docto.num-docto
               AND tt-volume-docto.cod-item    = wm-docto-itens.cod-item    
               AND tt-volume-docto.sequencia   = wm-docto-itens.num-seq-item NO-ERROR.
        IF NOT AVAIL tt-volume-docto THEN DO:
            CREATE tt-volume-docto.
            ASSIGN tt-volume-docto.cod-estabel   = wm-docto-itens.cod-estabel
                   tt-volume-docto.cod-local     = wm-docto-itens.cod-local
                   tt-volume-docto.nro-docto     = wm-docto.num-docto
                   tt-volume-docto.id-docto      = wm-docto.id-docto
                   tt-volume-docto.cod-item      = wm-docto-itens.cod-item
                   tt-volume-docto.sequencia     = wm-docto-itens.num-seq-item .
        END.

        ASSIGN tt-volume-docto.qtde-col = wm-docto-itens.qtd-item.

        FIND FIRST es-conferencia-docto NO-LOCK
             WHERE es-conferencia-docto.cod-estabel = wm-docto-itens.cod-estabel
               AND es-conferencia-docto.cod-local   = wm-docto-itens.cod-local  
               AND es-conferencia-docto.nro-docto   = wm-docto.num-docto        
               AND es-conferencia-docto.cod-item    = wm-docto-itens.cod-item 
               AND es-conferencia-docto.nr-seq-item = wm-docto-itens.num-seq-item  NO-ERROR.
        IF AVAIL es-conferencia-docto THEN 
            ASSIGN tt-volume-docto.qtde          = es-conferencia-docto.qt-conf
                   tt-volume-docto.log-conferido = es-conferencia-docto.log-conferido.

        ASSIGN l-finalizou = YES.
        FOR EACH tt-volume-docto-aux:
            FIND FIRST es-conferencia-docto NO-LOCK
                 WHERE es-conferencia-docto.cod-estabel   = tt-volume-docto-aux.cod-estabel
                   AND es-conferencia-docto.cod-local     = tt-volume-docto-aux.cod-local
                   AND es-conferencia-docto.nro-docto     = tt-volume-docto-aux.nro-docto
                   AND es-conferencia-docto.cod-item      = tt-volume-docto-aux.cod-item 
                   AND es-conferencia-docto.nr-seq-item   = tt-volume-docto-aux.sequencia 
                   AND es-conferencia-docto.log-conferido = YES NO-ERROR.
            IF NOT AVAIL es-conferencia-docto THEN DO:
                ASSIGN l-finalizou = NO.
                LEAVE.
            END.
        END.

        // Verifica se todos est∆o conferidos e habilita botao para finalizar conferencia
        IF l-finalizou THEN
            ASSIGN btFinalizar:SENSITIVE IN FRAME fpage0 = YES.
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-ean13 wWindow 
PROCEDURE pi-trata-ean13 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-estab         AS CHAR NO-UNDO. 
    DEF INPUT PARAM p-local         AS CHAR NO-UNDO.
    DEF INPUT PARAM p-nro-docto     AS CHAR NO-UNDO.
    DEF INPUT PARAM p-item          AS CHAR NO-UNDO.
    DEF INPUT PARAM p-sequencia     AS INT  NO-UNDO.
    DEF INPUT PARAM p-qtde          AS INT  NO-UNDO.
    DEF INPUT PARAM p-id-docto      AS INT  NO-UNDO.

    IF CAN-FIND(FIRST es-conferencia-docto
                WHERE es-conferencia-docto.cod-estabel = p-estab    
                  AND es-conferencia-docto.cod-local   = p-local    
                  AND es-conferencia-docto.nro-docto   = p-nro-docto 
                  AND es-conferencia-docto.char-1      = fi-ean13:SCREEN-VALUE IN FRAME fPage0) THEN DO:

        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "NS j† conferido neste Documento(Conferencia)",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        RETURN NO-APPLY.

    END.

    IF CAN-FIND(FIRST es-wm-docto-it-serie
                WHERE es-wm-docto-it-serie.cod-estabel  = p-estab
                  AND es-wm-docto-it-serie.cod-local    = p-local
                  AND es-wm-docto-it-serie.id-docto     = p-id-docto
                  AND es-wm-docto-it-serie.num-serie    = fi-ean13:SCREEN-VALUE IN FRAME fPage0) THEN DO:

        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "NS j† conferido neste Documento(Serie)",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        RETURN NO-APPLY.
    END.

    FIND FIRST es-conferencia-docto EXCLUSIVE-LOCK
         WHERE es-conferencia-docto.cod-estabel = p-estab    
           AND es-conferencia-docto.cod-local   = p-local    
           AND es-conferencia-docto.nro-docto   = p-nro-docto
           AND es-conferencia-docto.cod-item    = p-item     
           AND es-conferencia-docto.nr-seq-item = p-sequencia NO-ERROR.
    IF AVAIL es-conferencia-docto THEN DO:
        IF es-conferencia-docto.log-conferido THEN DO:
            {&WINDOW-NAME}:SENSITIVE = FALSE.
            RUN esp/clt/esclt006.w (INPUT "Item Conferido.",
                                    INPUT NO).
            {&WINDOW-NAME}:SENSITIVE = TRUE.
            RETURN NO-APPLY.
        END.
    END.
    ELSE DO:

        CREATE es-conferencia-docto.
        ASSIGN es-conferencia-docto.cod-estabel   = p-estab    
               es-conferencia-docto.cod-local     = p-local    
               es-conferencia-docto.nro-docto     = p-nro-docto
               es-conferencia-docto.cod-item      = p-item
               es-conferencia-docto.nr-seq-item   = p-sequencia
               es-conferencia-docto.qt-volume     = p-qtde
               es-conferencia-docto.char-1        = fi-ean13:SCREEN-VALUE IN FRAME fPage0.
    END.

    ASSIGN es-conferencia-docto.qt-conf = es-conferencia-docto.qt-conf + 1.

    ASSIGN tt-volume-docto.qtde = es-conferencia-docto.qt-conf
           tt-volume-docto.qtde:SCREEN-VALUE IN BROWSE br-volume = string(es-conferencia-docto.qt-conf).

    IF es-conferencia-docto.qt-conf = es-conferencia-docto.qt-volume THEN
        ASSIGN es-conferencia-docto.log-conferido     = YES
               es-conferencia-docto.cod-usuar         = v_cod_usuar_corren
               es-conferencia-docto.hora              = TIME
               es-conferencia-docto.data              = TODAY.

    ASSIGN l-finalizou = YES.
    FOR EACH tt-volume-docto-aux2:
        FIND FIRST es-conferencia-docto EXCLUSIVE-LOCK
             WHERE es-conferencia-docto.cod-estabel   = tt-volume-docto-aux2.cod-estabel
               AND es-conferencia-docto.cod-local     = tt-volume-docto-aux2.cod-local
               AND es-conferencia-docto.nro-docto     = tt-volume-docto-aux2.nro-docto
               AND es-conferencia-docto.cod-item      = tt-volume-docto-aux2.cod-item 
               AND es-conferencia-docto.log-conferido = NO NO-ERROR.
        IF AVAIL es-conferencia-docto THEN DO:
            ASSIGN l-finalizou = NO.
            LEAVE.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInformaVolume wWindow 
PROCEDURE piInformaVolume :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE i-num-volume      AS INT FORMAT ">>>9" LABEL "Qtd Volumes" NO-UNDO.
   
    DEFINE FRAME fGoToRecord
        i-num-volume      AT ROW 1.61 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 9 BY 0.88
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Informe Quantidade de Volumes" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "Informe_Quantidade_de_Volumes"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-num-volume.
        
        ASSIGN i-numero-volumes = i-num-volume.

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-num-volume btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_finalizar wWindow 
PROCEDURE pi_finalizar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN i-numero-volumes = 0.
    
    RUN piInformaVolume.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_limpa wWindow 
PROCEDURE pi_limpa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN fi-cod-estabel = ""
           fi-cod-local   = ""
           fi-serie       = ""
           fi-nr-nota-fis = ""
           fi-nro-docto   = ""
           fi-nr-volume   = 0
           c-text1        = ""
           rec-v:FGCOLOR IN FRAME fpage0 = 12
           rec-v:BGCOLOR IN FRAME fpage0 = 12
           fi-cod-estabel = ""
           fi-cod-estabel:SENSITIVE IN FRAME {&FRAME-NAME} = YES
           fi-cod-local:SENSITIVE IN FRAME {&FRAME-NAME} = YES
           btFinalizar:SENSITIVE IN FRAME fpage0 = NO.

    DISP fi-cod-estabel
         fi-cod-local
         fi-nro-docto
         fi-nr-volume
         fi-nr-nota-fis
         c-text1 WITH FRAME fpage0.

    ASSIGN fi-ean13:VISIBLE IN FRAME {&FRAME-NAME} = NO.

    EMPTY TEMP-TABLE tt-volume-docto.
    {&OPEN-QUERY-br-volume}

    APPLY "entry" TO fi-cod-estabel IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-desc-item wWindow 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST wm-item NO-LOCK
        WHERE wm-item.cod-item = p-it-codigo:

        RETURN wm-item.des-item.

    END.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-nota-export wWindow 
FUNCTION f-nota-export RETURNS LOGICAL
  ( INPUT p-estab AS CHAR,
    INPUT p-serie  AS CHAR,
    INPUT p-nota AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = p-estab
          AND nota-fiscal.serie       = p-serie
          AND nota-fiscal.nr-nota-fis = p-nota NO-ERROR.
    IF  AVAIL nota-fiscal AND SUBSTR(nota-fiscal.nat-operacao,1,1) = "7" THEN DO: /*Exportacao*/
    
        RETURN TRUE.

    END.

    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

