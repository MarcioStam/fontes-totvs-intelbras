&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Global Shared Definitions ---                                        */

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER   NO-UNDO.

/* Include Definitions ---                                              */

{upc/btb910za-upc.i}
{esp/ShowMsg.i}
{esp/es0018.i}
DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.
/* Local Temp-Table Definitions ---                                     */
DEFINE TEMP-TABLE tt-volume-nf
    FIELD it-codigo    AS CHAR
    FIELD desc-item    AS CHAR
    FIELD cod-barra    AS CHAR
    FIELD tipo         AS CHAR
    FIELD data         AS DATE
    FIELD qtd          AS DEC
    FIELD qtd-est      AS DEC
    FIELD completo     AS LOG
    FIELD it-codigo-pai AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE lcompleto   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lvarios     AS LOGICAL     NO-UNDO.
DEFINE VARIABLE vean        AS INTEGER     NO-UNDO.
DEFINE VARIABLE pit-codigo  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-caixa     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-ok        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-selec     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-pallet    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-central   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-tipo-etiq AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-item-aux  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tipo-aux  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-barra AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-tipo       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-quantidade AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-item       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-desc-item  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-status     AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-cont-op    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-multiplo   AS DECIMAL     NO-UNDO.

/* Local Buffer Definitions ---                                         */

DEFINE BUFFER bvolume-nf        FOR volume-nf.
DEFINE BUFFER bbvolume-nf       FOR volume-nf.
DEFINE BUFFER b-volume-nf       FOR volume-nf.
DEFINE BUFFER bitem-mat         FOR item-mat.
DEFINE BUFFER bns-volume        FOR ns-volume.
DEFINE BUFFER bcaixa-ns-volume  FOR ns-volume.
DEFINE BUFFER bpallet-ns-volume FOR ns-volume.
DEFINE BUFFER bord-prod         FOR ord-prod.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER   NO-UNDO.
DEFINE VARIABLE fi-serie AS CHARACTER   NO-UNDO.
DEFINE VARIABLE fi-embalagem AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-tipo-etiqueta AS INTEGER     NO-UNDO.   /* 1 - Volume / 2 - Item/Barra */
DEFINE VARIABLE i-tp-cod-barra  AS INTEGER     NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-esapi003  AS HANDLE      NO-UNDO.

DEFINE VARIABLE i-log       AS INTE        NO-UNDO INIT 0.

{esapi/esapi003tt.i}

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
&Scoped-define INTERNAL-TABLES tt-volume-nf

/* Definitions for BROWSE br-volume                                     */
&Scoped-define FIELDS-IN-QUERY-br-volume tt-volume-nf.it-codigo tt-volume-nf.desc-item tt-volume-nf.qtd-est tt-volume-nf.qtd //tt-volume-nf.tipo //tt-volume-nf.cod-barra   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-volume   
&Scoped-define SELF-NAME br-volume
&Scoped-define QUERY-STRING-br-volume FOR EACH tt-volume-nf NO-LOCK
&Scoped-define OPEN-QUERY-br-volume OPEN QUERY {&SELF-NAME}     FOR EACH tt-volume-nf NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-volume tt-volume-nf
&Scoped-define FIRST-TABLE-IN-QUERY-br-volume tt-volume-nf


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-volume}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-num-pedido fi-cod-barra btCancel btExit ~
RECT-1 rec-v br-volume 
&Scoped-Define DISPLAYED-OBJECTS fi-num-pedido fi-nr-ord-prod fi-it-codigo ~
fi-desc-item fi-cod-barra 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-cliente-rast wWindow 
FUNCTION f-cliente-rast RETURNS LOGICAL
  ( INPUT p-estab AS CHAR,
    INPUT p-serie  AS CHAR,
    INPUT p-nota AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-desc-item wWindow 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-item-rastr wWindow 
FUNCTION f-item-rastr RETURNS LOGICAL
  ( INPUT p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-item-solar wWindow 
FUNCTION f-item-solar RETURNS LOGICAL
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

DEFINE VARIABLE fi-cod-barra AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod.Barra" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 147 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 152 BY 21
     FONT 4.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 52 BY 21
     FONT 4.

DEFINE VARIABLE fi-nr-ord-prod AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "OP" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 61 BY 21
     FONT 4.

DEFINE VARIABLE fi-num-pedido AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ped.Venda" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 67 BY 21
     FONT 4 NO-UNDO.

DEFINE RECTANGLE rec-v
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE-PIXELS 35 BY 74.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 311 BY 81.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-volume FOR 
      tt-volume-nf SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-volume wWindow _FREEFORM
  QUERY br-volume DISPLAY
      tt-volume-nf.it-codigo    COLUMN-LABEL "Item" WIDTH 6
 tt-volume-nf.desc-item    COLUMN-LABEL "Descriá∆o"  FORMAT "X(35)" WIDTH 18
 tt-volume-nf.qtd-est      COLUMN-LABEL "Qtd Est"  FORMAT "zzzzz9.99" WIDTH 4 
 tt-volume-nf.qtd          COLUMN-LABEL "Qtd Bip"  FORMAT "zzzzz9.99" WIDTH 4 
 //tt-volume-nf.tipo         COLUMN-LABEL "Tipo"  FORMAT "X(10)" WIDTH 4
 //tt-volume-nf.cod-barra    COLUMN-LABEL "Cod. Barra" FORMAT "X(20)" WIDTH 6
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 46 BY 7
          &ELSE SIZE-PIXELS 320 BY 174 &ENDIF
         FONT 7 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-num-pedido AT Y 10 X 52 COLON-ALIGNED WIDGET-ID 34
     fi-nr-ord-prod AT Y 9 X 144 COLON-ALIGNED WIDGET-ID 36
     fi-it-codigo AT Y 33 X 52 COLON-ALIGNED WIDGET-ID 38
     fi-desc-item AT Y 33 X 107 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     fi-cod-barra AT Y 56 X 52 COLON-ALIGNED WIDGET-ID 42
     btCancel AT Y 264 X 180
     btExit AT Y 264 X 250 HELP
          "Sair"
     br-volume AT Y 90 X 0 WIDGET-ID 200
     RECT-1 AT Y 5 X 4 WIDGET-ID 28
     rec-v AT Y 8 X 277 WIDGET-ID 26
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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "esbcp006"
         HEIGHT-P           = 289
         WIDTH-P            = 320
         MAX-HEIGHT-P       = 841
         MAX-WIDTH-P        = 1536
         VIRTUAL-HEIGHT-P   = 841
         VIRTUAL-WIDTH-P    = 1536
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
/* BROWSE-TAB br-volume rec-v fpage0 */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nr-ord-prod IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-volume
/* Query rebuild information for BROWSE br-volume
     _START_FREEFORM

OPEN QUERY {&SELF-NAME}
    FOR EACH tt-volume-nf NO-LOCK.
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
ON END-ERROR OF wWindow /* esbcp006 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* esbcp006 */
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
ON ROW-DISPLAY OF br-volume IN FRAME fpage0
DO:

    IF tt-volume-nf.completo THEN
        ASSIGN tt-volume-nf.it-codigo:FGCOLOR IN BROWSE br-volume = 2
               tt-volume-nf.desc-item:FGCOLOR IN BROWSE br-volume = 2
               tt-volume-nf.qtd:FGCOLOR       IN BROWSE br-volume = 2
               tt-volume-nf.qtd-est:FGCOLOR   IN BROWSE br-volume = 2.
    ELSE 
        ASSIGN tt-volume-nf.it-codigo:FGCOLOR IN BROWSE br-volume = 12
               tt-volume-nf.desc-item:FGCOLOR IN BROWSE br-volume = 12
               tt-volume-nf.qtd:FGCOLOR       IN BROWSE br-volume = 12
               tt-volume-nf.qtd-est:FGCOLOR   IN BROWSE br-volume = 12.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar(F5) */
DO:
/*
    assign fi-etiq-volume:VISIBLE IN FRAME {&FRAME-NAME} = YES
           fi-ean13:VISIBLE IN FRAME {&FRAME-NAME} = NO.

    RUN pi_limpa.
    
    APPLY "entry" TO fi-etiq-volume IN FRAME fPage0.
*/    
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


&Scoped-define SELF-NAME fi-cod-barra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-barra wWindow
ON RETURN OF fi-cod-barra IN FRAME fpage0 /* Cod.Barra */
DO:
    //zerar variaveis
    ASSIGN c-cod-barra    = ""
           i-tp-cod-barra = 0.

    ASSIGN c-tipo-aux  = ""
           c-cod-barra = input frame fPage0 fi-cod-barra.

    IF c-cod-barra = "" 
    THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
    
        RUN esp/clt/esclt006.w (INPUT "Informe um c¢digo de barras.",
                                INPUT NO).
    
        {&WINDOW-NAME}:SENSITIVE = TRUE.
    
        ASSIGN fi-cod-barra:SCREEN-VALUE IN FRAME fPage0 = "".

        APPLY "entry" TO fi-cod-barra IN FRAME {&FRAME-NAME}.
        
        RETURN "NOK":U.
    END.

    /* EAN13 */
    FIND FIRST item-mat NO-LOCK WHERE item-mat.cod-ean = c-cod-barra NO-ERROR.
    IF  NOT AVAIL item-mat THEN DO:
        
        /* DUN14 */
        FIND FIRST item-dun NO-LOCK WHERE item-dun.cod-dun = c-cod-barra NO-ERROR.
        IF  NOT AVAIL item-dun THEN DO:
            FIND FIRST num-serie NO-LOCK WHERE num-serie.n-serie = c-cod-barra NO-ERROR.
                IF  AVAIL num-serie THEN 
                    ASSIGN c-item         = num-serie.it-codigo
                           c-tipo-aux     = "SERIAL"
                           i-tp-cod-barra = 1.
        END. 
        ELSE 
            ASSIGN c-item         = item-dun.it-codigo
                   c-tipo-aux     = "DUN14"
                   i-tp-cod-barra = 2.
    END. 
    ELSE DO:    
        ASSIGN c-item         = item-mat.it-codigo
               c-tipo-aux     = "EAN13"
               i-tp-cod-barra = 3.  

    END.

    IF c-tipo-aux = "" 
    THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
    
        RUN esp/clt/esclt006.w (INPUT "Codigo bipado n∆o tem relaá∆o com EAN, DUN ou NS.",
                                INPUT NO).
    
        {&WINDOW-NAME}:SENSITIVE = TRUE.
    
        ASSIGN fi-cod-barra:SCREEN-VALUE IN FRAME fPage0 = "".

        APPLY "entry" TO fi-cod-barra IN FRAME {&FRAME-NAME}.
        
        RETURN "NOK":U.
    END.
    ELSE DO:

        FIND FIRST estrutura WHERE
                   estrutura.it-codigo    = ord-prod.it-codigo AND
                   estrutura.es-codigo    = c-item             AND
                   estrutura.data-inicio <= TODAY              AND
                   estrutura.data-termino > TODAY
                   NO-LOCK NO-ERROR.

        IF NOT AVAIL estrutura 
        THEN DO:
            {&WINDOW-NAME}:SENSITIVE = FALSE.
            
            RUN esp/clt/esclt006.w (INPUT "Item Bipado n∆o esta dentro da estrutura.",
                                    INPUT NO).
            
            {&WINDOW-NAME}:SENSITIVE = TRUE.
            
            ASSIGN fi-cod-barra:SCREEN-VALUE IN FRAME fPage0 = "".

            APPLY "entry" TO fi-cod-barra IN FRAME {&FRAME-NAME}.
            
            RETURN "NOK":U.
        END.

        FIND LAST item-rast WHERE
                  item-rast.it-codigo = c-item
                  NO-LOCK NO-ERROR.

        IF AVAIL item-rast 
             AND item-rast.data-fim > TODAY
             AND i-tp-cod-barra <> 1
        THEN DO:
            {&WINDOW-NAME}:SENSITIVE = FALSE.
            
            RUN esp/clt/esclt006.w (INPUT "C¢digo bipado deve ser NS.",
                                    INPUT NO).
            
            {&WINDOW-NAME}:SENSITIVE = TRUE.
            
            ASSIGN fi-cod-barra:SCREEN-VALUE IN FRAME fPage0 = "".

            APPLY "entry" TO fi-cod-barra IN FRAME {&FRAME-NAME}.
            
            RETURN "NOK":U.
        END.

        
        IF i-tp-cod-barra = 1  
        THEN DO:
            FIND FIRST tt-volume-nf WHERE
                       tt-volume-nf.it-codigo = c-item
                       NO-LOCK NO-ERROR.

            IF AVAIL tt-volume-nf AND
                     tt-volume-nf.completo = YES 
            THEN DO:
                {&WINDOW-NAME}:SENSITIVE = FALSE.
                
                RUN esp/clt/esclt006.w (INPUT "Item j† foi BIPADO na QTD da estrutura.",
                                        INPUT NO).
                
                {&WINDOW-NAME}:SENSITIVE = TRUE.
                
                ASSIGN fi-cod-barra:SCREEN-VALUE IN FRAME fPage0 = "".
                
                APPLY "entry" TO fi-cod-barra IN FRAME {&FRAME-NAME}.
                
                RETURN "NOK":U.
            END.
        END.

        FIND FIRST int-col-num-serie WHERE
                   int-col-num-serie.nr-pedido = int(input frame fPage0 fi-num-pedido)
               AND int-col-num-serie.cod-barra = c-cod-barra
                   NO-LOCK NO-ERROR.

        IF AVAIL int-col-num-serie 
        THEN DO:
            {&WINDOW-NAME}:SENSITIVE = FALSE.
            
            RUN esp/clt/esclt006.w (INPUT "Codigo de barra j† gravado no Pedido.",
                                    INPUT NO).
            
            {&WINDOW-NAME}:SENSITIVE = TRUE.
            
            ASSIGN fi-cod-barra:SCREEN-VALUE IN FRAME fPage0 = "".

            APPLY "entry" TO fi-cod-barra IN FRAME {&FRAME-NAME}.
            
            RETURN "NOK":U.
        END.
        ELSE DO:
            CREATE int-col-num-serie.
            ASSIGN int-col-num-serie.nr-pedido     = int(input frame fPage0 fi-num-pedido)
                   int-col-num-serie.tp-cod-barra  = i-tp-cod-barra //Numero de Serie
                   int-col-num-serie.cod-barra     = c-cod-barra
                   int-col-num-serie.it-codigo     = c-item
                   int-col-num-serie.data          = TODAY
                   int-col-num-serie.usuario       = c-seg-usuario
                   int-col-num-serie.hora          = TIME
                   int-col-num-serie.it-codigo-pai = fi-it-codigo:SCREEN-VALUE IN FRAME fPage0.

            ASSIGN c-cod-barra    = ""
                   i-tp-cod-barra = 0
                   fi-cod-barra:SCREEN-VALUE IN FRAME fPage0 = "".
        END.
    END.

    IF i-log = 0 
    THEN RUN pi-cria-tt.
    ELSE RUN pi-cria-tt-op.

    {&OPEN-QUERY-br-volume}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nr-ord-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ord-prod wWindow
ON RETURN OF fi-nr-ord-prod IN FRAME fpage0 /* OP */
DO:
    FIND FIRST ord-prod WHERE
               ord-prod.nr-pedido    = input frame fPage0 fi-num-pedido
           AND ord-prod.nr-ord-produ = INPUT FRAME fPage0 fi-nr-ord-prod
               NO-LOCK NO-ERROR.

    IF AVAIL ord-prod 
    THEN DO:

        FIND ITEM WHERE
             ITEM.it-codigo = ord-prod.it-codigo
             NO-LOCK NO-ERROR.

        ASSIGN fi-nr-ord-prod:SCREEN-VALUE IN FRAME fpage0 = STRING(ord-prod.nr-ord-produ)
               fi-it-codigo:SCREEN-VALUE   IN FRAME fpage0 = STRING(ord-prod.it-codigo)
               fi-desc-item:SCREEN-VALUE   IN FRAME fpage0 = STRING(ITEM.desc-item).

        ASSIGN i-log = 1.

        RUN pi-cria-tt-op.
        {&OPEN-QUERY-br-volume}

        //aponta para o codigo de barras
        APPLY "ENTRY":U TO fi-cod-barra IN FRAME fpage0.
        RETURN NO-APPLY.
    END.
    ELSE DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.

        RUN esp/clt/esclt006.w (INPUT "Pedido de Venda sem OP vinculada.",
                                INPUT NO).

        {&WINDOW-NAME}:SENSITIVE = TRUE.

        APPLY "entry" TO fi-cod-barra IN FRAME {&FRAME-NAME}.

        RETURN "NOK":U.
    END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON RETURN OF fi-num-pedido IN FRAME fpage0 /* Ped.Venda */
DO:
    ASSIGN i-log = 0.

    RUN pi_limpa.
    {&OPEN-QUERY-br-volume}

    ASSIGN i-cont-op = 0.

    FOR EACH bord-prod WHERE
             bord-prod.nr-pedido = input frame fPage0 fi-num-pedido
             NO-LOCK.
        ASSIGN i-cont-op = i-cont-op + 1.
    END.

    IF i-cont-op > 1 
    THEN DO:
        
        ASSIGN fi-nr-ord-prod:SENSITIVE IN FRAME fpage0 = TRUE.

        APPLY "ENTRY":U TO fi-nr-ord-prod IN FRAME fpage0.

        RETURN NO-APPLY.

    END.
    ELSE DO:
        FIND FIRST ord-prod WHERE
                   ord-prod.nr-pedido = input frame fPage0 fi-num-pedido
                   NO-LOCK NO-ERROR.
        
        IF AVAIL ord-prod 
        THEN DO:
        
            FIND ITEM WHERE
                 ITEM.it-codigo = ord-prod.it-codigo
                 NO-LOCK NO-ERROR.
        
            ASSIGN fi-nr-ord-prod:SCREEN-VALUE IN FRAME fpage0 = STRING(ord-prod.nr-ord-produ)
                   fi-it-codigo:SCREEN-VALUE   IN FRAME fpage0 = STRING(ord-prod.it-codigo)
                   fi-desc-item:SCREEN-VALUE   IN FRAME fpage0 = STRING(ITEM.desc-item).
        
        
            RUN pi-cria-tt.
            {&OPEN-QUERY-br-volume}
        
            //aponta para o codigo de barras
            APPLY "ENTRY":U TO fi-cod-barra IN FRAME fpage0.
            RETURN NO-APPLY.
        END.
        ELSE DO:
            {&WINDOW-NAME}:SENSITIVE = FALSE.
        
            RUN esp/clt/esclt006.w (INPUT "Pedido de Venda sem OP vinculada.",
                                    INPUT NO).
        
            {&WINDOW-NAME}:SENSITIVE = TRUE.
        
            APPLY "entry" TO fi-cod-barra IN FRAME {&FRAME-NAME}.
            
            RETURN "NOK":U.
        END.  
    END.
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

  ASSIGN fi-nr-ord-prod:SENSITIVE IN FRAME fpage0 = FALSE
         fi-it-codigo:SENSITIVE   IN FRAME fpage0 = FALSE
         fi-desc-item:SENSITIVE   IN FRAME fpage0 = FALSE
         rec-v:FGCOLOR            IN FRAME fpage0 = 12
         rec-v:BGCOLOR            IN FRAME fpage0 = 12.

/*
  RUN esp/es0018p.p (INPUT "esbcp006",
                     INPUT 1,
                     INPUT 0,
                     INPUT "",
                     OUTPUT TABLE tt-prog-ponto).
  
  ASSIGN btElimina:SENSITIVE IN FRAME fPage0 = NO.

  IF CAN-FIND (FIRST tt-prog-ponto WHERE
                     tt-prog-ponto.conteudo = c-seg-usuario) 
  THEN ASSIGN btElimina:SENSITIVE IN FRAME fPage0 = YES.
*/
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

    DEF VAR d-soma AS DEC NO-UNDO.

    EMPTY TEMP-TABLE tt-volume-nf.

    ASSIGN rec-v:FGCOLOR             IN FRAME fpage0 = 12
           rec-v:BGCOLOR             IN FRAME fpage0 = 12
           fi-cod-barra:SCREEN-VALUE IN FRAME fPage0 = ""
           fi-cod-barra:SENSITIVE    IN FRAME fPage0 = YES
           fi-nr-ord-prod:SENSITIVE  IN FRAME fpage0 = FALSE.

    ASSIGN i-multiplo = 1.

    FOR EACH estrutura WHERE
             estrutura.it-codigo    = ord-prod.it-codigo AND
            // estrutura.es-codigo    = c-item             AND
             estrutura.data-inicio <= TODAY              AND
             estrutura.data-termino > TODAY
             NO-LOCK.

        FIND FIRST ped-item WHERE
                   ped-item.nr-pedcli = input frame fPage0 fi-num-pedido 
               AND ped-item.it-codigo = fi-it-codigo:SCREEN-VALUE IN FRAME fPage0
                   NO-LOCK NO-ERROR.

        IF AVAIL ped-item 
        THEN ASSIGN i-multiplo = ped-item.qt-pedida.

        FIND FIRST ITEM WHERE
                   ITEM.it-codigo = estrutura.es-codigo
                   NO-LOCK NO-ERROR.

        FIND FIRST tt-volume-nf WHERE
                   tt-volume-nf.it-codigo = estrutura.es-codigo
                   NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-volume-nf 
        THEN DO:
            CREATE tt-volume-nf.
            ASSIGN tt-volume-nf.it-codigo = estrutura.es-codigo
                   //tt-volume-nf.cod-barra = int-col-num-serie.cod-barra
                   tt-volume-nf.desc-item = ITEM.desc-item WHEN AVAIL ITEM
                   tt-volume-nf.qtd-est   = estrutura.qtd-compon * i-multiplo
                   tt-volume-nf.it-codigo-pai = fi-it-codigo:SCREEN-VALUE IN FRAME fPage0.

            FIND FIRST int-col-num-serie WHERE
                       int-col-num-serie.nr-pedido     = int(input frame fPage0 fi-num-pedido)
                   AND int-col-num-serie.it-codigo     = estrutura.es-codigo
                   AND int-col-num-serie.tp-cod-barra <> 1
                       NO-LOCK NO-ERROR.

            IF AVAIL int-col-num-serie
            THEN DO:
                ASSIGN tt-volume-nf.qtd       = 1
                       tt-volume-nf.cod-barra = int-col-num-serie.cod-barra
                       tt-volume-nf.completo  = YES
                       tt-volume-nf.qtd       = estrutura.qtd-compon * i-multiplo.

                IF int-col-num-serie.tp-cod-barra = 2 
                THEN ASSIGN tt-volume-nf.tipo = "DUN14".
                
                IF int-col-num-serie.tp-cod-barra = 3 
                THEN ASSIGN tt-volume-nf.tipo = "EAN13".
            END.
            ELSE DO:
                ASSIGN d-soma = 0.
                       
                FOR EACH int-col-num-serie WHERE
                         int-col-num-serie.nr-pedido     = int(input frame fPage0 fi-num-pedido)
                     AND int-col-num-serie.it-codigo     = estrutura.es-codigo
                         NO-LOCK.

                    ASSIGN d-soma = d-soma + 1.

                END.

                ASSIGN tt-volume-nf.qtd = d-soma
                       tt-volume-nf.tipo = "SERIAL".

                IF d-soma = 0 THEN tt-volume-nf.tipo = "".

                IF d-soma = estrutura.qtd-compon * i-multiplo 
                THEN ASSIGN tt-volume-nf.completo  = YES.
                ELSE ASSIGN tt-volume-nf.completo  = NO.

            END.
        END.
    END.

    ASSIGN lcompleto = NO.

    FOR EACH tt-volume-nf NO-LOCK.
        IF tt-volume-nf.completo = NO 
        THEN DO:
            ASSIGN lcompleto = NO.
            LEAVE.
        END.
        ELSE lcompleto = YES.
    END.

    IF lcompleto = YES 
    THEN ASSIGN rec-v:FGCOLOR             IN FRAME fpage0 = 2
                rec-v:BGCOLOR             IN FRAME fpage0 = 2
                fi-cod-barra:SCREEN-VALUE IN FRAME fPage0 = ""
                fi-cod-barra:SENSITIVE    IN FRAME fPage0 = NO.

/*
    FOR EACH int-col-num-serie WHERE
             int-col-num-serie.nr-pedido = int(input frame fPage0 fi-num-pedido)
             NO-LOCK.      

        FIND FIRST ITEM WHERE
                   ITEM.it-codigo = int-col-num-serie.it-codigo
                   NO-LOCK NO-ERROR.

        CREATE tt-volume-nf.
        ASSIGN tt-volume-nf.it-codigo = int-col-num-serie.it-codigo
               tt-volume-nf.cod-barra = int-col-num-serie.cod-barra
               tt-volume-nf.desc-item = ITEM.desc-item WHEN AVAIL ITEM
               tt-volume-nf.qtd       = 1.

        IF int-col-num-serie.tp-cod-barra = 1 
        THEN ASSIGN tt-volume-nf.tipo = "SERIAL".

        IF int-col-num-serie.tp-cod-barra = 2 
        THEN ASSIGN tt-volume-nf.tipo = "DUN14".

        IF int-col-num-serie.tp-cod-barra = 3 
        THEN ASSIGN tt-volume-nf.tipo = "EAN13".
    END.

    ASSIGN lcompleto = NO.

    FOR EACH estrutura WHERE
             estrutura.it-codigo    = ord-prod.it-codigo AND
            // estrutura.es-codigo    = c-item             AND
             estrutura.data-inicio <= TODAY              AND
             estrutura.data-termino > TODAY
             NO-LOCK.
    
        IF CAN-FIND(FIRST tt-volume-nf WHERE 
                          tt-volume-nf.it-codigo = estrutura.es-codigo AND
                          tt-volume-nf.tipo     <> "SERIAL") 
        THEN lcompleto = YES.
        ELSE DO:
            ASSIGN d-soma = 0.

            FOR EACH tt-volume-nf WHERE
                     tt-volume-nf.it-codigo = estrutura.es-codigo
                     NO-LOCK.

                ASSIGN d-soma = d-soma + tt-volume-nf.qtd.
            END.

            IF d-soma = estrutura.qtd-compon THEN
               ASSIGN lcompleto = YES.
            ELSE DO:
               ASSIGN lcompleto = NO.
               LEAVE.
            END.
        END.
    END.

    IF lcompleto = YES 
    THEN ASSIGN rec-v:FGCOLOR             IN FRAME fpage0 = 2
                rec-v:BGCOLOR             IN FRAME fpage0 = 2
                fi-cod-barra:SCREEN-VALUE IN FRAME fPage0 = ""
                fi-cod-barra:SENSITIVE    IN FRAME fPage0 = NO.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-op wWindow 
PROCEDURE pi-cria-tt-op :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR d-soma AS DEC NO-UNDO.

    EMPTY TEMP-TABLE tt-volume-nf.

    ASSIGN rec-v:FGCOLOR             IN FRAME fpage0 = 12
           rec-v:BGCOLOR             IN FRAME fpage0 = 12
           fi-cod-barra:SCREEN-VALUE IN FRAME fPage0 = ""
           fi-cod-barra:SENSITIVE    IN FRAME fPage0 = YES.
           //fi-nr-ord-prod:SENSITIVE  IN FRAME fpage0 = FALSE.

    ASSIGN i-multiplo = 1.

    FOR EACH estrutura WHERE
             estrutura.it-codigo    = ord-prod.it-codigo AND
            // estrutura.es-codigo    = c-item             AND
             estrutura.data-inicio <= TODAY              AND
             estrutura.data-termino > TODAY
             NO-LOCK.

        FIND FIRST ped-item WHERE
                   ped-item.nr-pedcli = input frame fPage0 fi-num-pedido 
               AND ped-item.it-codigo = fi-it-codigo:SCREEN-VALUE IN FRAME fPage0
                   NO-LOCK NO-ERROR.

        IF AVAIL ped-item 
        THEN ASSIGN i-multiplo = ped-item.qt-pedida.

        FIND FIRST ITEM WHERE
                   ITEM.it-codigo = estrutura.es-codigo
                   NO-LOCK NO-ERROR.

        FIND FIRST tt-volume-nf WHERE
                   tt-volume-nf.it-codigo = estrutura.es-codigo
                   NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-volume-nf 
        THEN DO:
            CREATE tt-volume-nf.
            ASSIGN tt-volume-nf.it-codigo = estrutura.es-codigo
                   //tt-volume-nf.cod-barra = int-col-num-serie.cod-barra
                   tt-volume-nf.desc-item = ITEM.desc-item WHEN AVAIL ITEM
                   tt-volume-nf.qtd-est   = estrutura.qtd-compon * i-multiplo
                   tt-volume-nf.it-codigo-pai = fi-it-codigo:SCREEN-VALUE IN FRAME fPage0.

            FIND FIRST int-col-num-serie WHERE
                       int-col-num-serie.nr-pedido     = int(input frame fPage0 fi-num-pedido)
                   AND int-col-num-serie.it-codigo     = estrutura.es-codigo
                   AND int-col-num-serie.tp-cod-barra <> 1
                       NO-LOCK NO-ERROR.

            IF AVAIL int-col-num-serie
            THEN DO:
                ASSIGN tt-volume-nf.qtd       = 1
                       tt-volume-nf.cod-barra = int-col-num-serie.cod-barra
                       tt-volume-nf.completo  = YES
                       tt-volume-nf.qtd       = estrutura.qtd-compon * i-multiplo.

                IF int-col-num-serie.tp-cod-barra = 2 
                THEN ASSIGN tt-volume-nf.tipo = "DUN14".
                
                IF int-col-num-serie.tp-cod-barra = 3 
                THEN ASSIGN tt-volume-nf.tipo = "EAN13".
            END.
            ELSE DO:
                ASSIGN d-soma = 0.
                       
                FOR EACH int-col-num-serie WHERE
                         int-col-num-serie.nr-pedido     = int(input frame fPage0 fi-num-pedido)
                     AND int-col-num-serie.it-codigo     = estrutura.es-codigo
                         NO-LOCK.

                    IF int-col-num-serie.it-codigo-pai <> fi-it-codigo:SCREEN-VALUE IN FRAME fPage0 
                    THEN NEXT.

                    ASSIGN d-soma = d-soma + 1.

                END.

                ASSIGN tt-volume-nf.qtd = d-soma
                       tt-volume-nf.tipo = "SERIAL".

                IF d-soma = 0 THEN tt-volume-nf.tipo = "".

                IF d-soma = estrutura.qtd-compon * i-multiplo 
                THEN ASSIGN tt-volume-nf.completo  = YES.
                ELSE ASSIGN tt-volume-nf.completo  = NO.

            END.
        END.
    END.

    ASSIGN lcompleto = NO.

    FOR EACH tt-volume-nf NO-LOCK.
        IF tt-volume-nf.completo = NO 
        THEN DO:
            ASSIGN lcompleto = NO.
            LEAVE.
        END.
        ELSE lcompleto = YES.
    END.

    IF lcompleto = YES 
    THEN ASSIGN rec-v:FGCOLOR             IN FRAME fpage0 = 2
                rec-v:BGCOLOR             IN FRAME fpage0 = 2
                fi-cod-barra:SCREEN-VALUE IN FRAME fPage0 = ""
                fi-cod-barra:SENSITIVE    IN FRAME fPage0 = NO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piChamaItemManual wWindow 
PROCEDURE piChamaItemManual :
/*------------------------------------------------------------------------------
  Purpose: Chama dialog para informar item e quantidade    
  Notes:   Carlos Daniel - 12/04/2016
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER p-item AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p-qtde AS INTEGER   NO-UNDO.

DEFINE VARIABLE c-item       AS CHARACTER LABEL "Item"       FORMAT "X(16)" NO-UNDO.
DEFINE VARIABLE d-quantidade AS INTEGER   LABEL "Quantidade"                NO-UNDO.

DEFINE BUTTON btItemCancel AUTO-END-KEY
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8.

DEFINE BUTTON btItemOK 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8.

DEFINE RECTANGLE rtItemButton
     EDGE-PIXELS 2 GRAPHIC-EDGE 
     SIZE 30 BY 1.42
     BGCOLOR 7.

DEFINE FRAME fItemRecord
    c-item       AT ROW 1.21 COL 7.92 COLON-ALIGNED VIEW-AS FILL-IN
    d-quantidade AT ROW 2.21 COL 7.92 COLON-ALIGNED VIEW-AS FILL-IN 

    btItemOK      AT ROW 3.63 COL 2.14
    btItemCancel  AT ROW 3.63 COL 13
    rtItemButton  AT ROW 3.38 COL 1
    SPACE(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
         THREE-D SCROLLABLE TITLE "Item" FONT 1
         DEFAULT-BUTTON btItemOK CANCEL-BUTTON btItemCancel.

/*tech1139 - FO 1338.917 - 10/07/2006  */
RUN utp/ut-trfrrp.p (input Frame fItemRecord:Handle).
{utp/ut-liter.i "Selecionar Item"}
ASSIGN FRAME fItemRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

ON "CHOOSE":U OF btItemOK IN FRAME fItemRecord DO:
    ASSIGN c-item
           d-quantidade.

    ASSIGN p-item = c-item
           p-qtde = d-quantidade.
    
    APPLY "GO":U TO FRAME fItemRecord.
END.

ENABLE c-item d-quantidade btItemCancel btItemOK
    WITH FRAME fItemRecord. 

WAIT-FOR "GO":U OF FRAME fItemRecord.

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
    EMPTY TEMP-TABLE tt-volume-nf.
    {&OPEN-QUERY-br-volume}

/*    
    ASSIGN fi-cod-estabel = ""
           fi-serie       = ""
           fi-nr-nota-fis = ""
           fi-nr-volume   = 0
           c-text1        = ""
           rec-v:FGCOLOR IN FRAME fpage0 = 12
           rec-v:BGCOLOR IN FRAME fpage0 = 12.

    DISP /*fi-cod-estabel  
         fi-serie       */
         fi-nr-volume
         fi-nr-nota-fis
         c-text1 WITH FRAME fpage0.

    EMPTY TEMP-TABLE tt-volume-nf.
    {&OPEN-QUERY-br-volume}

    APPLY "entry" TO fi-etiq-volume IN FRAME fPage0.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-cliente-rast wWindow 
FUNCTION f-cliente-rast RETURNS LOGICAL
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
    IF  AVAIL nota-fiscal THEN DO:
    
        FOR FIRST cliente-rast  NO-LOCK 
            WHERE cliente-rast.cod-emitente  = nota-fiscal.cod-emitente
            AND   cliente-rast.data-ini  <= TODAY
            AND   cliente-rast.data-fim   > TODAY:
    
            RETURN TRUE.
        END.

    END.

    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-desc-item wWindow 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = p-it-codigo:

        RETURN ITEM.desc-item.

    END.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-item-solar wWindow 
FUNCTION f-item-solar RETURNS LOGICAL
  ( INPUT p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST int-item NO-LOCK 
        WHERE int-item.it-codigo  = p-it-codigo:

        IF int-item.nr-ped-energia <> "" THEN
            RETURN TRUE.
    END.

    RETURN FALSE.   /* Function return value. */

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

