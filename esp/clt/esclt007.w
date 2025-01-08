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
{include/i-prgvrs.i ESCLT007 2.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCLT007
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   bt-sair
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


DEF TEMP-TABLE tt-etiqueta
    FIELD seq-pallet    AS INT
    FIELD cod-pallet    AS CHAR
    FIELD seq-caixa     AS INT
    FIELD cod-caixa     AS CHAR
    FIELD seq-produto   AS INT
    FIELD cod-produto   AS CHAR.

DEF VAR c-anterior      AS CHAR.
DEF VAR c-caixa-atu     AS CHAR.
DEF VAR c-caixa         AS CHAR.
DEF VAR i-quant-cx      AS INT.
DEF VAR i-quant-pt      AS INT.
DEF VAR i-cont          AS INT.
DEF VAR i-contEtiq      AS INT.
DEF VAR l-erro          AS LOG.
DEF VAR c-acao          AS CHAR.
DEF VAR l-ok            AS LOG.
DEF VAR l-reincorpora   AS LOG.

DEFINE VARIABLE v-it-codigo LIKE item.it-codigo NO-UNDO.

DEF BUFFER b-ns-volume FOR ns-volume.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-etiqueta

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-etiqueta

/* Definitions for BROWSE br-etiqueta                                   */
&Scoped-define FIELDS-IN-QUERY-br-etiqueta tt-etiqueta.cod-produto   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-etiqueta   
&Scoped-define SELF-NAME br-etiqueta
&Scoped-define QUERY-STRING-br-etiqueta FOR EACH tt-etiqueta
&Scoped-define OPEN-QUERY-br-etiqueta OPEN QUERY {&SELF-NAME} FOR EACH tt-etiqueta.
&Scoped-define TABLES-IN-QUERY-br-etiqueta tt-etiqueta
&Scoped-define FIRST-TABLE-IN-QUERY-br-etiqueta tt-etiqueta


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-etiqueta}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-17 br-etiqueta bt-sair 
&Scoped-Define DISPLAYED-OBJECTS c-etiqueta i-qt-it-cx 

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

DEFINE VARIABLE c-etiqueta AS CHARACTER FORMAT "X(15)":U 
     LABEL "Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 189 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE i-qt-it-cx AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Qtd Item Caixa" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 42 BY 21
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 308 BY 62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-etiqueta FOR 
      tt-etiqueta SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-etiqueta wWindow _FREEFORM
  QUERY br-etiqueta DISPLAY
      tt-etiqueta.cod-produto  COLUMN-LABEL "Produto"  FORMAT "x(30)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 44 BY 8
          &ELSE SIZE-PIXELS 308 BY 186 &ENDIF
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-etiqueta AT Y 12 X 77 COLON-ALIGNED HELP
          "Registre a Etiqueta" WIDGET-ID 42 AUTO-RETURN 
     i-qt-it-cx AT Y 36 X 77 COLON-ALIGNED HELP
          "Qtd Item Caixa" WIDGET-ID 44
     br-etiqueta AT Y 72 X 7 WIDGET-ID 200
     bt-sair AT Y 258 X 252 WIDGET-ID 40
     RECT-17 AT Y 6 X 7 WIDGET-ID 46
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
/* BROWSE-TAB br-etiqueta i-qt-it-cx fpage0 */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN c-etiqueta IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-qt-it-cx IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-etiqueta
/* Query rebuild information for BROWSE br-etiqueta
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-etiqueta.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-etiqueta */
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


&Scoped-define SELF-NAME c-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-etiqueta wWindow
ON RETURN OF c-etiqueta IN FRAME fpage0 /* Etiqueta */
DO:
  
    RUN pi-leitura.

    IF RETURN-VALUE = "NOK" THEN
        RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-etiqueta
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

FOR EACH tt-etiqueta:
      DELETE tt-etiqueta.
  END.
  ASSIGN c-anterior = "".
    
  {&OPEN-QUERY-{&BROWSE-NAME}}

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

    ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "Caixa".

    ENABLE c-etiqueta 
           WITH FRAME {&FRAME-NAME}. 

    FOR EACH tt-etiqueta:
        DELETE tt-etiqueta.
    END.

    ASSIGN c-anterior = ""
           c-acao     = "Inclui".

    {&OPEN-QUERY-{&BROWSE-NAME}}

    APPLY "entry" TO c-etiqueta.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-registro wWindow 
PROCEDURE pi-grava-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{&OPEN-QUERY-{&BROWSE-NAME}}


FIND FIRST tt-etiqueta.
FIND LAST b-ns-volume NO-LOCK
    WHERE b-ns-volume.volume-pai = tt-etiqueta.cod-pallet NO-ERROR.
IF NOT AVAIL b-ns-volume THEN DO:
    CREATE ns-volume.
    ASSIGN ns-volume.volume-pai   = tt-etiqueta.cod-pallet
           ns-volume.volume-filho = tt-etiqueta.cod-caixa
           ns-volume.sequencia    = 1.
END.
ELSE DO:
    CREATE ns-volume.
    ASSIGN ns-volume.volume-pai   = tt-etiqueta.cod-pallet
           ns-volume.volume-filho = tt-etiqueta.cod-caixa
           ns-volume.sequencia    = b-ns-volume.sequencia + 1.
END.

ASSIGN i-cont = 1.

FOR EACH tt-etiqueta WHERE tt-etiqueta.cod-produto <> "":
    CREATE ns-volume.
    ASSIGN ns-volume.volume-pai   = tt-etiqueta.cod-caixa
           ns-volume.volume-filho = tt-etiqueta.cod-produto
           ns-volume.sequencia    = i-cont
           i-cont                 = i-cont + 1.
END.

FOR EACH tt-etiqueta:
    DELETE tt-etiqueta.
END.

ASSIGN c-anterior = ""
       l-reincorpora = NO.

{&OPEN-QUERY-{&BROWSE-NAME}}

APPLY "entry" TO c-etiqueta IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leitura wWindow 
PROCEDURE pi-leitura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN INPUT FRAME {&FRAME-NAME} c-etiqueta.  

    ASSIGN l-erro = NO.
    IF  SUBSTRING(c-etiqueta,1,3) <> "ECO" 
    AND SUBSTRING(c-etiqueta,1,3) <> "EPA" 
    AND (ASC(SUBSTRING(c-etiqueta, 1, 1)) < 48
     OR  ASC(SUBSTRING(c-etiqueta, 1, 1)) > 57)
    AND (ASC(SUBSTRING(c-etiqueta, 2, 1)) < 48
     OR  ASC(SUBSTRING(c-etiqueta, 2, 1)) > 57) THEN DO: /* caso seja etiqueta de produto - Numero de SÇrie */
    
        IF length(c-etiqueta) = 15 THEN DO:
            FIND imei-prod WHERE imei-prod.cod-imei = c-etiqueta NO-LOCK NO-ERROR.
            IF NOT AVAIL imei-prod THEN DO:
                {&WINDOW-NAME}:SENSITIVE = FALSE.
                RUN esp/clt/esclt006.w (INPUT "Esta etiqueta n∆o foi gerada",
                                        INPUT NO).
                {&WINDOW-NAME}:SENSITIVE = TRUE.
                ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                RETURN "NOK".   
            END.
        END.
        ELSE DO:
    
            IF length(c-etiqueta) > 13 THEN 
               ASSIGN l-erro = YES.                     /* tamanho m†ximo = 13 */
    
            DO i-contEtiq = 5 TO LENGTH(c-etiqueta) - 2:
               IF l-erro = YES THEN LEAVE.
               IF asc(SUBSTRING(c-etiqueta,i-contEtiq,1)) < 48 
               AND asc(SUBSTRING(c-etiqueta,i-contEtiq,1)) > 57 THEN      
                   ASSIGN l-erro = YES.                                               /** s¢ pode ter numeros **/
            END.
    
            IF l-erro = YES THEN DO:
               {&WINDOW-NAME}:SENSITIVE = FALSE.
               RUN esp/clt/esclt006.w (INPUT "Dado informado n∆o corresponde a etiqueta",
                                       INPUT NO).
               {&WINDOW-NAME}:SENSITIVE = TRUE.
               ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
               RETURN "NOK".
            END.
    
            FOR FIRST num-serie NO-LOCK
                WHERE num-serie.n-serie = c-etiqueta:
            END.
    
    
            IF NOT AVAIL num-serie THEN DO:                                    /* Etiqueta deve ter sido gerada */
               {&WINDOW-NAME}:SENSITIVE = FALSE.
               RUN esp/clt/esclt006.w (INPUT "Esta etiqueta n∆o foi gerada.",
                                       INPUT NO).
               {&WINDOW-NAME}:SENSITIVE = TRUE.
               ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
               RETURN "NOK".
            END.
    
        END.
    
    END.
    ELSE DO:
        ASSIGN l-erro = NO.
    
        DO i-contEtiq = 4 TO LENGTH(c-etiqueta):
            IF asc(SUBSTRING(c-etiqueta,i-contEtiq,1)) < 48 
            AND asc(SUBSTRING(c-etiqueta,i-contEtiq,1)) > 57 THEN DO:     
                ASSIGN l-erro = YES.                                        /** s¢ pode ter numeros **/
                LEAVE.
            END.
        END.
        IF l-erro = YES THEN DO:
            {&WINDOW-NAME}:SENSITIVE = FALSE.
            RUN esp/clt/esclt006.w (INPUT "Dado informado n∆o corresponde a etiqueta",
                                    INPUT NO).
            {&WINDOW-NAME}:SENSITIVE = TRUE.
            ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
            RETURN "NOK".
        END.
    END.
    
    /***************************** Inicia processamento dos botoes *******************************/
    IF  c-acao = "Inclui" THEN DO:
    
        FIND FIRST tt-etiqueta
             WHERE tt-etiqueta.cod-produto = c-etiqueta
             OR    tt-etiqueta.cod-caixa   = c-etiqueta NO-ERROR.
        IF AVAIL tt-etiqueta THEN DO:
            {&WINDOW-NAME}:SENSITIVE = FALSE.
            RUN esp/clt/esclt006.w (INPUT "Etiqueta j† registrada",
                                    INPUT NO).
            {&WINDOW-NAME}:SENSITIVE = TRUE.
            ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
            RETURN "NOK".
        END.
    
        FIND FIRST ns-volume 
             WHERE ns-volume.volume-filho = c-etiqueta NO-LOCK NO-ERROR.
        IF AVAIL ns-volume THEN DO:
           IF ns-volume.volume-pai = "ECO-INDEFINIDA" THEN DO:
              {&WINDOW-NAME}:SENSITIVE = FALSE.
              RUN esp/clt/esclt006.w (INPUT "Etiqueta de produto j† registrada em caixa desmantelada. Imposs°vel relacionar a outra caixa.",
                                      INPUT NO).
              {&WINDOW-NAME}:SENSITIVE = TRUE.
              ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
              RETURN "NOK".
           END.
           ELSE DO:
              {&WINDOW-NAME}:SENSITIVE = FALSE.
              RUN esp/clt/esclt006.w (INPUT "Etiqueta cadastrada e com relacionamento.",
                                      INPUT NO).
              {&WINDOW-NAME}:SENSITIVE = TRUE.
               ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
               RETURN "NOK".
           END.
        END.
        ELSE DO:
            FIND FIRST ns-volume WHERE ns-volume.volume-pai = c-etiqueta NO-LOCK NO-ERROR.
            IF AVAIL ns-volume THEN DO:
               IF SUBSTRING(c-etiqueta,1,3) = "ECO" THEN DO:
                  ASSIGN l-reincorpora = YES.
               END.
            END.
        END.
    
        IF c-anterior = "" THEN DO:
            IF SUBSTRING(c-etiqueta,1,3) <> "ECO" THEN DO:
                {&WINDOW-NAME}:SENSITIVE = FALSE.
                RUN esp/clt/esclt006.w (INPUT "Primeiro registro incluido deve ser uma CAIXA",
                                        INPUT NO).
                {&WINDOW-NAME}:SENSITIVE = TRUE.
                ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                RETURN "NOK".
            END.
    
            CREATE tt-etiqueta.
            ASSIGN tt-etiqueta.cod-CAIXA = c-etiqueta.
    
            ASSIGN c-anterior  = "C"
                   c-CAIXA-atu = c-etiqueta
                   i-quant-cx  = INT(SUBSTRING(c-etiqueta,4,3))
                   i-qt-it-cx  = i-quant-cx.
    
            ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "Num SÇrie".
    
            DISPLAY i-qt-it-cx
                WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
            CASE SUBSTRING(c-etiqueta,1,3):
                WHEN "ECO" THEN DO:
                    IF c-anterior = "C" THEN DO:
                        {&WINDOW-NAME}:SENSITIVE = FALSE.
                        RUN esp/clt/esclt006.w (INPUT "CAIXA Inv†lida. Vocà deve cadastrar os produtos para a CAIXA previamente cadastrada.",
                                                INPUT NO).
                        {&WINDOW-NAME}:SENSITIVE = TRUE.
                        ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                        RETURN "NOK".
                    END.
                    ELSE 
                    IF c-anterior = "E" THEN DO:
                        {&WINDOW-NAME}:SENSITIVE = FALSE.
                        RUN esp/clt/esclt006.w (INPUT "CAIXA Inv†lida. Vocà deve ler o Pallet ap¢s a inclus∆o dos produtos.",
                                                INPUT NO).
                        {&WINDOW-NAME}:SENSITIVE = TRUE.
                        ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                        RETURN "NOK".
                    END.
                    /*IF c-anterior = "DUN" THEN DO:
                        {&WINDOW-NAME}:SENSITIVE = FALSE.
                        RUN esp/clt/esclt006.w (INPUT "CAIXA Inv†lida. Vocà deve cadastrar um PALLET ap¢s a inclus∆o do Cod.Barras DUN14.",
                                                INPUT NO).
                        {&WINDOW-NAME}:SENSITIVE = TRUE.
                        ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                        RETURN "NOK".
                    END.*/
    
                    CREATE tt-etiqueta.
                    ASSIGN tt-etiqueta.cod-CAIXA = c-etiqueta.
    
                    ASSIGN c-anterior  = "C"
                           c-CAIXA-atu = c-etiqueta
                           i-quant-cx  = INT(SUBSTRING(c-etiqueta,4,3)).
    
                    ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "Num SÇrie".
    
                END.
                WHEN "EPA" THEN DO:

                    CASE c-anterior:

                        WHEN "C" THEN DO:
                            IF l-reincorpora = NO THEN DO:
                                {&WINDOW-NAME}:SENSITIVE = FALSE.
                                RUN esp/clt/esclt006.w (INPUT "PALLET Inv†lido. Vocà deve cadastrar os produtos para a CAIXA previamente cadastrada.",
                                                        INPUT NO).
                                {&WINDOW-NAME}:SENSITIVE = TRUE.
                                ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                                RETURN "NOK".
                            END.
                        END.

                        WHEN "P" THEN DO:
                            {&WINDOW-NAME}:SENSITIVE = FALSE.
                            RUN esp/clt/esclt006.w (INPUT "PALLET Inv†lido. Vocà deve cadastrar uma nova CAIXA ou salvar os registros.",
                                                    INPUT NO).
                            {&WINDOW-NAME}:SENSITIVE = TRUE.
                            ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                            RETURN "NOK".
                        END.
                        
                        /*WHEN "E" THEN DO:
                            {&WINDOW-NAME}:SENSITIVE = FALSE.
                            RUN esp/clt/esclt006.w (INPUT "PALLET Inv†lido. Vocà deve cadastrar o Cod.Barras DUN14 do item ap¢s a inclus∆o dos PRODUTOS.",
                                                    INPUT NO).
                            {&WINDOW-NAME}:SENSITIVE = TRUE.
                            ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                            RETURN "NOK".
                        END.*/

                    END CASE.
    
                    ASSIGN i-quant-pt = INT(SUBSTRING(c-etiqueta,4,3))
                           i-cont     = 1.
    
                    FOR EACH ns-volume
                        WHERE ns-volume.volume-pai = c-etiqueta:
                          ASSIGN i-cont = i-cont + 1.
                    END.
    
                    IF i-cont > i-quant-pt THEN DO:
                        {&WINDOW-NAME}:SENSITIVE = FALSE.
                        RUN esp/clt/esclt006.w (INPUT "PALLET Inv†lido. Quantidade de CAIXAS excede o permitido para o PALLET.",
                                                INPUT NO).
                        {&WINDOW-NAME}:SENSITIVE = TRUE.
                        ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                        RETURN "NOK".
                    END.
    
                    FOR EACH tt-etiqueta
                        WHERE tt-etiqueta.cod-PALLET = "":
                        ASSIGN tt-etiqueta.cod-PALLET = c-etiqueta.
                    END.
    
                    ASSIGN c-anterior = "P".
    
                    ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "Caixa".
    
                    RUN pi-grava-registro.
    
                    ASSIGN i-qt-it-cx = 0.
    
                    DISPLAY i-qt-it-cx
                        WITH FRAME {&FRAME-NAME}.
                END.
                OTHERWISE DO:
                    CASE c-anterior:
                        WHEN "P" THEN DO:
                            {&WINDOW-NAME}:SENSITIVE = FALSE.
                            RUN esp/clt/esclt006.w (INPUT "Produto Inv†lido. Vocà deve cadastrar uma CAIXA ou salvar os registros.",
                                                    INPUT NO).
                            {&WINDOW-NAME}:SENSITIVE = TRUE.
                            ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                            RETURN "NOK".
                        END.
                        WHEN "C" THEN DO:
                            IF l-reincorpora THEN DO:
                                {&WINDOW-NAME}:SENSITIVE = FALSE.
                                RUN esp/clt/esclt006.w (INPUT "Caixa sendo reincorporada. N∆o se pode relacionar produto.",
                                                        INPUT NO).
                                {&WINDOW-NAME}:SENSITIVE = TRUE.
                                ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                                RETURN "NOK".
                            END.
                            FIND tt-etiqueta
                                WHERE tt-etiqueta.cod-CAIXA = c-CAIXA-atu NO-ERROR.
                            IF AVAIL tt-etiqueta THEN DO:
    
                                FIND FIRST num-serie
                                    WHERE num-serie.n-serie = c-etiqueta NO-LOCK NO-ERROR.
    
                                IF NOT AVAILABLE num-serie THEN DO:
                                    {&WINDOW-NAME}:SENSITIVE = FALSE.
                                    RUN esp/clt/esclt006.w (INPUT "Etiqueta n∆o cadastrada para um produto":U,
                                                            INPUT NO).
                                    {&WINDOW-NAME}:SENSITIVE = TRUE.
                                    ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                                    RETURN "NOK".
                                END.
    
                                ASSIGN tt-etiqueta.cod-produto = c-etiqueta
                                       v-it-codigo             = num-serie.it-codigo.
                            END.
    
                            ASSIGN c-anterior = "E".
                        END.
                        WHEN "E" THEN DO:
    
                            ASSIGN i-cont = 0.
                            FOR EACH tt-etiqueta
                                WHERE tt-etiqueta.cod-CAIXA    = c-CAIXA-atu
                                AND   tt-etiqueta.cod-produto <> "":
                                ASSIGN i-cont = i-cont + 1.
                            END.
    
                            IF (i-cont + 1) > i-quant-cx THEN DO:
    
                                /*
                                FIND FIRST item-dun
                                    WHERE item-dun.cod-dun = c-etiqueta NO-LOCK NO-ERROR.
    
                                IF AVAILABLE item-dun THEN DO:
    
                                    FIND FIRST tt-etiqueta
                                        WHERE tt-etiqueta.cod-CAIXA = c-CAIXA-atu NO-ERROR.
    
                                    IF AVAIL tt-etiqueta THEN DO:
    
                                        FIND FIRST num-serie
                                            WHERE num-serie.n-serie = tt-etiqueta.cod-produto NO-LOCK NO-ERROR.
    
                                        IF (AVAILABLE num-serie                        AND
                                            num-serie.it-codigo <> item-dun.it-codigo) OR
                                            NOT AVAILABLE num-serie                    THEN DO:
                                            {&WINDOW-NAME}:SENSITIVE = FALSE.
                                            RUN esp/clt/esclt006.w (INPUT "N£mero DUN14 n∆o corresponde ao item inserido na CAIXA.",
                                                                    INPUT NO).
                                            {&WINDOW-NAME}:SENSITIVE = TRUE.
                                            ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                                            RETURN "NOK".
                                        END.
                                        ELSE
                                            ASSIGN c-anterior  = "DUN"
                                                   v-it-codigo = "":U.
                                    END.
                                END.
                                ELSE DO:
                                */
                                    {&WINDOW-NAME}:SENSITIVE = FALSE.
                                    RUN esp/clt/esclt006.w (INPUT "Produto Inv†lido. Quantidade de produtos excede o permitido para a CAIXA.",
                                                            INPUT NO).
                                    {&WINDOW-NAME}:SENSITIVE = TRUE.
                                    ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                                    RETURN "NOK".
                                /*END.*/
                            END.
                            ELSE DO:
                                IF v-it-codigo = "":U THEN DO:
                                    FIND FIRST num-serie
                                        WHERE num-serie.n-serie = c-etiqueta NO-LOCK NO-ERROR.
    
                                    IF NOT AVAILABLE num-serie THEN DO:
                                        {&WINDOW-NAME}:SENSITIVE = FALSE.
                                        RUN esp/clt/esclt006.w (INPUT "Etiqueta n∆o cadastrada para um produto":U,
                                                                INPUT NO).
                                        {&WINDOW-NAME}:SENSITIVE = TRUE.
                                        ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                                               i-cont = i-cont - 1.
                                        RETURN "NOK".
                                    END.
    
                                    ASSIGN v-it-codigo = num-serie.it-codigo.
                                END.
                                ELSE DO:
                                    FIND FIRST num-serie
                                        WHERE num-serie.n-serie = c-etiqueta NO-LOCK NO-ERROR.
    
                                    IF NOT AVAILABLE num-serie THEN DO:
                                        {&WINDOW-NAME}:SENSITIVE = FALSE.
                                        RUN esp/clt/esclt006.w (INPUT "Etiqueta n∆o cadastrada para um produto":U,
                                                                INPUT NO).
                                        {&WINDOW-NAME}:SENSITIVE = TRUE.
                                        ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                                               i-cont = i-cont - 1.
                                        RETURN "NOK".
                                    END.
    
                                    IF num-serie.it-codigo <> v-it-codigo THEN DO:
                                        {&WINDOW-NAME}:SENSITIVE = FALSE.
                                        RUN esp/clt/esclt006.w (INPUT "Produto diferente do cadastrado anteriormente":U,
                                                                INPUT NO).
                                        {&WINDOW-NAME}:SENSITIVE = TRUE.
                                        ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                                               i-cont = i-cont - 1.
                                        RETURN "NOK".
                                    END.
                                END.
    
                                CREATE tt-etiqueta.
                                ASSIGN tt-etiqueta.cod-CAIXA   = c-CAIXA-atu
                                       tt-etiqueta.cod-produto = c-etiqueta.
    
                                ASSIGN c-anterior = "E".
                            END.
                        END.
                        /*WHEN "DUN" THEN DO:
                             {&WINDOW-NAME}:SENSITIVE = FALSE.
                              RUN esp/clt/esclt006.w (INPUT "Pallet Inv†lido. Vocà deve agora ler o Pallet.",
                                                      INPUT NO).
                             {&WINDOW-NAME}:SENSITIVE = TRUE.
                            ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                            RETURN "NOK".
                        END.*/
                    END CASE.
    
                    ASSIGN i-cont = 0.
    
                    FOR EACH tt-etiqueta
                        WHERE tt-etiqueta.cod-CAIXA    = c-CAIXA-atu
                        AND   tt-etiqueta.cod-produto <> "":
                        ASSIGN i-cont = i-cont + 1.
                    END.
    
                    IF i-cont = i-quant-cx THEN DO:

                        ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "Pallet".
    
                        /*IF c-anterior = "DUN" THEN
                            ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "Pallet".
                        ELSE 
                            ASSIGN c-etiqueta:LABEL IN FRAME {&FRAME-NAME} = "DUN14".*/
    
                    END.
    
                END.
            END CASE.
        END.
    END.
    ELSE IF c-acao = "Delete" THEN DO:
        FIND FIRST ns-volume WHERE ns-volume.volume-pai = c-etiqueta
                             NO-LOCK NO-ERROR.
        IF NOT AVAIL ns-volume THEN DO:
           FIND FIRST ns-volume WHERE ns-volume.volume-filho = c-etiqueta
                                NO-LOCK NO-ERROR.
           IF NOT AVAIL ns-volume THEN DO:
               {&WINDOW-NAME}:SENSITIVE = FALSE.
               RUN esp/clt/esclt006.w (INPUT "Etiqueta nao registrada para ser desvinculada.",
                                       INPUT NO).
               {&WINDOW-NAME}:SENSITIVE = TRUE.
               ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
               RETURN "NOK".
           END.
        END.
        IF SUBSTRING(c-etiqueta,1,3) = "EPA" THEN DO:
           IF ns-volume.nr-nota-fis <> "" THEN DO:
               {&WINDOW-NAME}:SENSITIVE = FALSE.
               RUN esp/clt/esclt006.w (INPUT "Pallet relacionado a Nota Fiscal. Imposs°vel desvincular caixas deste pallet.",
                                       INPUT NO).
               {&WINDOW-NAME}:SENSITIVE = TRUE.
               ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
               RETURN "NOK".
           END.
           {&WINDOW-NAME}:SENSITIVE = FALSE.
           RUN esp/clt/esclt006.w (INPUT "Deseja realmente desvincular todas as caixas deste Pallet?",
                                   INPUT YES).
           {&WINDOW-NAME}:SENSITIVE = TRUE.
           ASSIGN l-ok = (RETURN-VALUE = "YES").
           IF NOT l-ok THEN DO:
              ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
              RETURN "NOK".
           END.
           FOR EACH ns-volume WHERE ns-volume.volume-pai = c-etiqueta:
              DELETE ns-volume.
           END.
        END.
        ELSE IF SUBSTRING(c-etiqueta,1,3) = "ECO" THEN DO:
           FIND FIRST ns-volume WHERE ns-volume.volume-pai = c-etiqueta
                                NO-LOCK NO-ERROR.
           IF ns-volume.nr-nota-fis <> "" THEN DO:
               {&WINDOW-NAME}:SENSITIVE = FALSE.
               RUN esp/clt/esclt006.w (INPUT "Caixa relacionada a Nota Fiscal. Imposs°vel desvincular esta caixa.",
                                       INPUT NO).
               {&WINDOW-NAME}:SENSITIVE = TRUE.
               ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
               RETURN "NOK".
           END.
           {&WINDOW-NAME}:SENSITIVE = FALSE.
           RUN esp/clt/esclt006.w (INPUT "Deseja realmente desvincular esta caixa do Pallet?",
                                   INPUT YES).
           {&WINDOW-NAME}:SENSITIVE = TRUE.
           ASSIGN l-ok = (RETURN-VALUE = "YES").
           IF NOT l-ok THEN DO:
              ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
              RETURN "NOK".
           END.
           FOR EACH ns-volume WHERE ns-volume.volume-filho = c-etiqueta:
               DELETE ns-volume.
           END.
        END.
        ELSE DO:
            
           FIND FIRST ns-volume WHERE ns-volume.volume-filho = c-etiqueta
                                NO-LOCK NO-ERROR.
           IF ns-volume.nr-nota-fis <> "" THEN DO:
               {&WINDOW-NAME}:SENSITIVE = FALSE.
               RUN esp/clt/esclt006.w (INPUT "Produto relacionado a Nota Fiscal. Imposs°vel desvincular produtos de uma caixa.",
                                       INPUT NO).
               {&WINDOW-NAME}:SENSITIVE = TRUE.
               ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
               RETURN "NOK".
           END.
           {&WINDOW-NAME}:SENSITIVE = FALSE.
           RUN esp/clt/esclt006.w (INPUT "Deseja realmente desvincular este produto da Caixa?",
                                   INPUT NO).
           {&WINDOW-NAME}:SENSITIVE = FALSE.
           ASSIGN l-ok = (RETURN-VALUE = "YES").
           IF NOT l-ok THEN DO:
              ASSIGN c-etiqueta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
              RETURN "NOK".
           END.
           
           FIND FIRST ns-volume WHERE ns-volume.volume-filho = c-etiqueta NO-LOCK.
           ASSIGN c-caixa = ns-volume.volume-pai.
          
           FOR EACH ns-volume WHERE ns-volume.volume-pai = c-caixa:
               ASSIGN ns-volume.volume-pai = "ECO-INDEFINIDA".
           END.
           FOR EACH ns-volume WHERE ns-volume.volume-filho = c-caixa:
               DELETE ns-volume.
           END.
        END.
    END.
    
    {&OPEN-QUERY-{&BROWSE-NAME}}
    
    ASSIGN c-etiqueta:SCREEN-VALUE = "".

    RETURN "OK":u.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

