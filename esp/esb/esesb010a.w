&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME esesb010A
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS esesb010A 
{include/i-prgvrs.i esesb010a 2.00.00.000}

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.


{esp/esb/esesbapi008.i}
DEF TEMP-TABLE tt-portador NO-UNDO
    FIELD portador AS CHAR 
    FIELD carteira AS CHAR.
    
/* Defini‡Æo da tt-central */                       
{esp/esb/esesbapi005.i}
{esp/es0018.i}
DEF TEMP-TABLE tt-br-titulo LIKE tt-titulo-acr
    FIELD cod_portador    LIKE tit_acr.cod_portador
    FIELD vl-saldo-titulo AS DEC 
    FIELD dt-vencto       AS DATE FORMAT "99/99/9999"
    INDEX idx-valor valor.

DEF BUFFER b-tt-br-titulo FOR tt-br-titulo.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

def temp-table tt-erro-aux no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF  INPUT PARAM p-canal     AS INTEGER NO-UNDO.
DEF  INPUT PARAM p-valor     AS DEC NO-UNDO.
DEF OUTPUT PARAM p-transacao AS DATE NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-titulo-acr.
DEF OUTPUT PARAM TABLE FOR tt-erro.

def new global shared var v_cod_empres_usuar as CHARACTER format "x(3)" label "Empresa" column-label "Empresa" no-undo.

def new global shared var h-facelift as handle no-undo.

IF NOT VALID-HANDLE(h-facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h-facelift.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta  AS LOGICAL.

DEF VAR h-acomp AS HANDLE NO-UNDO.

DEF VAR i-cor AS INT NO-UNDO.

{utp/ut-glob.i}

DEFINE VARIABLE v_win_original_width  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_win_original_height AS DECIMAL     NO-UNDO.

DEFINE VARIABLE v_column AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_asc    AS LOGICAL     NO-UNDO.

DEF VAR de-ja-fechado AS DEC NO-UNDO.

DEF VAR de-saldo-final AS DEC NO-UNDO.
DEF VAR de-tot-comprometido AS DEC NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-titulo

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-br-titulo

/* Definitions for BROWSE br-titulo                                     */
&Scoped-define FIELDS-IN-QUERY-br-titulo tt-br-titulo.cod_estab tt-br-titulo.canal-filial tt-br-titulo.cod_espec_docto tt-br-titulo.cod_ser_docto tt-br-titulo.cod_tit_acr tt-br-titulo.cod_parcela tt-br-titulo.cod_portador tt-br-titulo.dt-vencto tt-br-titulo.vl-saldo-titulo tt-br-titulo.valor   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-titulo tt-br-titulo.valor   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-titulo tt-br-titulo
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-titulo tt-br-titulo
&Scoped-define SELF-NAME br-titulo
&Scoped-define QUERY-STRING-br-titulo FOR EACH tt-br-titulo BY tt-br-titulo.cod_tit_acr DESC
&Scoped-define OPEN-QUERY-br-titulo OPEN QUERY {&SELF-NAME} FOR EACH tt-br-titulo BY tt-br-titulo.cod_tit_acr DESC.
&Scoped-define TABLES-IN-QUERY-br-titulo tt-br-titulo
&Scoped-define FIRST-TABLE-IN-QUERY-br-titulo tt-br-titulo


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-titulo}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button IMAGE-29 IMAGE-30 IMAGE-31 ~
IMAGE-32 RECT-147 RECT-148 RECT-149 RECT-151 RECT-152 RECT-150 RECT-153 ~
RECT-154 fi-estab-ini fi-estab-fim bt-add fi-transacao fi-dt-vencto-ini ~
fi-dt-vencto-fim br-titulo bt-limpar bt-ok bt-cancela fi-ok 
&Scoped-Define DISPLAYED-OBJECTS fi-canal fi-nome fi-estab-ini fi-estab-fim ~
fi-transacao fi-tot-apb fi-tot-acr fi-ok 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnAbatido esesb010A 
FUNCTION fnAbatido RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR esesb010A AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-add 
     IMAGE-UP FILE "adeicon/filt-u95.bmp":U
     LABEL "" 
     SIZE 5 BY 1.5 TOOLTIP "Selecionar T¡tulos".

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancela" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-limpar 
     IMAGE-UP FILE "adeicon/export-u.bmp":U
     LABEL "" 
     SIZE 4 BY 1.21 TOOLTIP "Limpar Abatimentos Selecionados".

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE fi-canal AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-dt-vencto-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/2050 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-vencto-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-fim AS CHARACTER FORMAT "x(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-ini AS CHARACTER FORMAT "x(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .79 NO-UNDO.

DEFINE VARIABLE fi-ok AS CHARACTER FORMAT "X(256)":U INITIAL "Aguardando Sele‡Æo..." 
      VIEW-AS TEXT 
     SIZE 23.72 BY .67
     FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE fi-tot-acr AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Saldo Contas a Pagar" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-apb AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Saldo Contas a Pagar" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-transacao AS DATE FORMAT "99/99/9999":U 
     LABEL "Data de Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 TOOLTIP "Data de Transa‡Æo" NO-UNDO.

DEFINE IMAGE IMAGE-29
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-32
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-147
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52 BY 2.5.

DEFINE RECTANGLE RECT-148
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 105 BY 1.29.

DEFINE RECTANGLE RECT-149
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34.29 BY 2.5.

DEFINE RECTANGLE RECT-150
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 105 BY 9.88.

DEFINE RECTANGLE RECT-151
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35 BY 2.5.

DEFINE RECTANGLE RECT-152
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34.29 BY 2.5.

DEFINE RECTANGLE RECT-153
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32.43 BY 2.5.

DEFINE RECTANGLE RECT-154
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19 BY 2.5.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 105.14 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-titulo FOR 
      tt-br-titulo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-titulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-titulo esesb010A _FREEFORM
  QUERY br-titulo DISPLAY
      tt-br-titulo.cod_estab        COLUMN-LABEL "Estabel"          WIDTH 8
      tt-br-titulo.canal-filial     COLUMN-LABEL "Canal"            WIDTH 8
      tt-br-titulo.cod_espec_docto  COLUMN-LABEL "Esp‚cie"          WIDTH 8
      tt-br-titulo.cod_ser_docto    COLUMN-LABEL "S‚rie"            WIDTH 8  FORMAT "X(15)"
      tt-br-titulo.cod_tit_acr      COLUMN-LABEL "T¡tulo"           WIDTH 10 FORMAT "X(15)"
      tt-br-titulo.cod_parcela      COLUMN-LABEL "Parcela"          WIDTH 8 FORMAT "X(10)" 
      tt-br-titulo.cod_portador      COLUMN-LABEL "Portador"        WIDTH 10
      tt-br-titulo.dt-vencto        COLUMN-LABEL "Vencimento"       WIDTH 11 FORMAT "99/99/9999"
      tt-br-titulo.vl-saldo-titulo  COLUMN-LABEL "Saldo T¡tulo"     WIDTH 11 FORMAT ">>,>>>>,>>9.99"
      tt-br-titulo.valor            COLUMN-LABEL "Utilizar"        WIDTH 12 FORMAT ">>>>,>>9.99"
      ENABLE
           tt-br-titulo.valor
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 99.43 BY 9
         FONT 7
         TITLE "Status" ROW-HEIGHT-CHARS .6 FIT-LAST-COLUMN TOOLTIP "Seleciona para detalhamento".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     fi-canal AT ROW 1.46 COL 23 COLON-ALIGNED WIDGET-ID 138
     fi-nome AT ROW 1.46 COL 33.57 COLON-ALIGNED NO-LABEL WIDGET-ID 140
     fi-estab-ini AT ROW 3.29 COL 22.14 COLON-ALIGNED WIDGET-ID 66
     fi-estab-fim AT ROW 3.29 COL 38.14 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     bt-add AT ROW 3.54 COL 95 HELP
          "Filtrar T¡tulos" WIDGET-ID 132
     fi-transacao AT ROW 3.75 COL 70.14 COLON-ALIGNED WIDGET-ID 176
     fi-dt-vencto-ini AT ROW 4.29 COL 18 COLON-ALIGNED WIDGET-ID 144
     fi-dt-vencto-fim AT ROW 4.29 COL 38.14 COLON-ALIGNED NO-LABEL WIDGET-ID 148
     br-titulo AT ROW 6.25 COL 2.57 WIDGET-ID 200
     bt-limpar AT ROW 7.13 COL 102.29 HELP
          "Limpar Abatimentos Selecionados" WIDGET-ID 172
     fi-tot-apb AT ROW 16.58 COL 17 COLON-ALIGNED WIDGET-ID 134
     fi-tot-acr AT ROW 16.58 COL 52 COLON-ALIGNED WIDGET-ID 168
     bt-ok AT ROW 18.79 COL 3
     bt-cancela AT ROW 18.79 COL 96.29
     fi-ok AT ROW 16.63 COL 72.29 COLON-ALIGNED NO-LABEL WIDGET-ID 164
     "Status:" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 15.58 COL 74 WIDGET-ID 170
     "Sele‡Æo:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 2.75 COL 3.14 WIDGET-ID 182
     "Parƒmetro Integra‡Æo:" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 2.75 COL 56 WIDGET-ID 184
     rt-button AT ROW 18.58 COL 1.86
     IMAGE-29 AT ROW 3.29 COL 31.72 WIDGET-ID 68
     IMAGE-30 AT ROW 3.29 COL 36.57 WIDGET-ID 70
     IMAGE-31 AT ROW 4.29 COL 31.72 WIDGET-ID 150
     IMAGE-32 AT ROW 4.29 COL 36.57 WIDGET-ID 152
     RECT-147 AT ROW 3 COL 2 WIDGET-ID 154
     RECT-148 AT ROW 1.25 COL 2 WIDGET-ID 156
     RECT-149 AT ROW 15.83 COL 2 WIDGET-ID 158
     RECT-151 AT ROW 15.83 COL 72 WIDGET-ID 162
     RECT-152 AT ROW 15.83 COL 37 WIDGET-ID 166
     RECT-150 AT ROW 5.75 COL 2 WIDGET-ID 174
     RECT-153 AT ROW 3 COL 54.86 WIDGET-ID 178
     RECT-154 AT ROW 3 COL 88 WIDGET-ID 180
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1.04
         SIZE 106.57 BY 19.08
         FONT 7.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW esesb010A ASSIGN
         HIDDEN             = YES
         TITLE              = "Encontro de Contas"
         HEIGHT             = 19.13
         WIDTH              = 106.57
         MAX-HEIGHT         = 28.38
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.38
         VIRTUAL-WIDTH      = 195.14
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB esesb010A 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW esesb010A
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB br-titulo fi-dt-vencto-fim f-cad */
ASSIGN 
       br-titulo:ALLOW-COLUMN-SEARCHING IN FRAME f-cad = TRUE
       br-titulo:COLUMN-RESIZABLE IN FRAME f-cad       = TRUE.

ASSIGN 
       bt-cancela:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FILL-IN fi-canal IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       fi-canal:READ-ONLY IN FRAME f-cad        = TRUE.

/* SETTINGS FOR FILL-IN fi-dt-vencto-fim IN FRAME f-cad
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN fi-dt-vencto-ini IN FRAME f-cad
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN fi-nome IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       fi-nome:READ-ONLY IN FRAME f-cad        = TRUE.

/* SETTINGS FOR FILL-IN fi-tot-acr IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       fi-tot-acr:READ-ONLY IN FRAME f-cad        = TRUE.

/* SETTINGS FOR FILL-IN fi-tot-apb IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       fi-tot-apb:READ-ONLY IN FRAME f-cad        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esesb010A)
THEN esesb010A:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-titulo
/* Query rebuild information for BROWSE br-titulo
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-br-titulo BY tt-br-titulo.cod_tit_acr DESC
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-titulo */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME esesb010A
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esesb010A esesb010A
ON END-ERROR OF esesb010A /* Encontro de Contas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esesb010A esesb010A
ON WINDOW-CLOSE OF esesb010A /* Encontro de Contas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-titulo
&Scoped-define SELF-NAME br-titulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-titulo esesb010A
ON START-SEARCH OF br-titulo IN FRAME f-cad /* Status */
DO:
  
    DEFINE VARIABLE i_count AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i_index AS INTEGER     NO-UNDO.

    SELF:CLEAR-SORT-ARROWS().

    IF SELF:CURRENT-COLUMN:TABLE = "":U OR
       SELF:CURRENT-COLUMN:TABLE = ?    THEN
        RETURN NO-APPLY.

    IF v_column <> SELF:CURRENT-COLUMN:NAME THEN
        ASSIGN v_column = SELF:CURRENT-COLUMN:NAME
               v_asc    = YES.
    ELSE
        ASSIGN v_asc = NOT v_asc.

    IF v_asc THEN
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME).
    ELSE
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC":U).
            
    DO i_count = 1 TO SELF:NUM-COLUMNS:
        IF SELF:CURRENT-COLUMN = SELF:GET-BROWSE-COLUMN(i_count) THEN
            ASSIGN i_index = i_count.
    END.

    SELF:SET-SORT-ARROW(i_index, v_asc).

    SELF:QUERY:QUERY-OPEN().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-titulo esesb010A
ON VALUE-CHANGED OF br-titulo IN FRAME f-cad /* Status */
DO: 

    IF  NOT AVAIL tt-br-titulo THEN
        RETURN "OK".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add esesb010A
ON CHOOSE OF bt-add IN FRAME f-cad
DO:
    
    ASSIGN fi-tot-acr:SCREEN-VALUE IN FRAME f-cad = "0,00".

    RUN pi-carrega-titulos.
    RUN pi-atualiza-saldo-abatimento.

    {&open-query-br-titulo}

    APPLY "value-changed" TO br-titulo IN FRAME f-cad.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela esesb010A
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancela */
DO:
  
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-limpar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-limpar esesb010A
ON CHOOSE OF bt-limpar IN FRAME f-cad
DO:

    ASSIGN fi-tot-acr:SCREEN-VALUE IN FRAME f-cad = "0,00".

    RUN pi-carrega-titulos.
    
    RUN pi-atualiza-saldo-abatimento.

    {&open-query-br-titulo}

    APPLY "value-changed" TO br-titulo IN FRAME f-cad.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok esesb010A
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:

    EMPTY TEMP-TABLE tt-titulo-acr.

    DO WITH FRAME f-cad:
        IF  DEC(fi-tot-apb:SCREEN-VALUE) > DEC(fi-tot-acr:SCREEN-VALUE)  THEN DO:
            run utp/ut-msgs.p (input "show", 
                               input 17006, 
                               input "Valor total dos t¡tulo a receber, deve ser igual o saldo a pagar").
            RETURN NO-APPLY.
        END.

        IF  DEC(fi-tot-acr:SCREEN-VALUE) = 0 THEN DO:
            run utp/ut-msgs.p (input "show", 
                               input 17006, 
                               input "Devem ser selecionados os t¡tulos para encontro de contas").
            RETURN NO-APPLY.
        END.
    END.

    run utp/ut-msgs.p (input "show", input 27100, input "Confirma o abatimento das duplicatas selecionadas?" + "~~" +
                       "Ser  efetuado o encontro de contas entre o t¡tulo a pagar do Canal e os t¡tulos selecionados. Confirma?").
    
    IF  RETURN-VALUE <> "YES" THEN 
        RETURN NO-APPLY.

    FOR EACH tt-br-titulo
        WHERE tt-br-titulo.valor > 0  /* s¢ as selecionadas */:
        CREATE tt-titulo-acr.
        ASSIGN tt-titulo-acr.cod_estab       = tt-br-titulo.cod_estab       
               tt-titulo-acr.cod_espec_docto = tt-br-titulo.cod_espec_docto 
               tt-titulo-acr.cod_ser_docto   = tt-br-titulo.cod_ser_docto   
               tt-titulo-acr.cod_tit_acr     = tt-br-titulo.cod_tit_acr     
               tt-titulo-acr.cod_parcela     = tt-br-titulo.cod_parcela   
               tt-titulo-acr.canal-filial    = tt-br-titulo.canal-filial
               tt-titulo-acr.valor           = tt-br-titulo.valor. 

    END.

    ASSIGN p-transacao = date(fi-transacao:SCREEN-VALUE IN FRAME f-cad).

    apply "close":U to this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK esesb010A 


/* ***************************  Main Block  *************************** */


    ON 'ENTRY':U OF tt-br-titulo.valor IN BROWSE br-titulo
    DO:
        DEF VAR da-abatido AS DEC NO-UNDO.
        ASSIGN  da-abatido = fnAbatido().

        IF  da-abatido = p-valor THEN
            RETURN "OK".

        DO WITH FRAME f-cad:
            
            IF  DEC(tt-br-titulo.valor:screen-value in browse br-titulo) = tt-br-titulo.vl-saldo-titulo THEN
                RETURN "OK".

            IF  da-abatido < p-valor THEN DO:

                IF  DEC(tt-br-titulo.valor:screen-value in browse br-titulo) < tt-br-titulo.vl-saldo-titulo 
                THEN DO:

                    IF  tt-br-titulo.vl-saldo-titulo > (p-valor - da-abatido) THEN
                         ASSIGN tt-br-titulo.valor = DEC(tt-br-titulo.valor:screen-value in browse br-titulo) + (p-valor - da-abatido).
                    ELSE
                        ASSIGN tt-br-titulo.valor = tt-br-titulo.vl-saldo-titulo.

                    assign tt-br-titulo.valor:screen-value in browse br-titulo = string(tt-br-titulo.valor).
                    RUN pi-atualiza-saldo-abatimento.
                    RETURN "OK".

                END.


                IF  tt-br-titulo.vl-saldo-titulo > (p-valor - da-abatido) THEN  
                     ASSIGN tt-br-titulo.valor = (p-valor - da-abatido).
                 ELSE
                     ASSIGN tt-br-titulo.valor = tt-br-titulo.vl-saldo-titulo .

                assign tt-br-titulo.valor:screen-value in browse br-titulo = string(tt-br-titulo.valor).
                ASSIGN de-ja-fechado = tt-br-titulo.valor.
            END.

                
        END.
        RUN pi-atualiza-saldo-abatimento.

    END.
        

    ON 'LEAVE':U OF tt-br-titulo.valor IN BROWSE br-titulo
    DO:
        DEF VAR da-abatido AS DEC NO-UNDO.
        ASSIGN  da-abatido = fnAbatido().

        IF  dec(tt-br-titulo.valor:screen-value in browse br-titulo) < tt-br-titulo.valor THEN DO:
            tt-br-titulo.valor = dec(tt-br-titulo.valor:screen-value in browse br-titulo).
            RUN pi-atualiza-saldo-abatimento.
            RETURN "OK".
        END.

        ASSIGN  da-abatido = fnAbatido().

        IF  da-abatido = p-valor THEN DO:
            ASSIGN tt-br-titulo.valor:screen-value in browse br-titulo = STRING(tt-br-titulo.valor) .
            RUN pi-atualiza-saldo-abatimento.
            RETURN "OK".
        END.

        RUN pi-atualiza-saldo-abatimento.

    END.

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects esesb010A  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available esesb010A  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI esesb010A  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esesb010A)
  THEN DELETE WIDGET esesb010A.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI esesb010A  _DEFAULT-ENABLE
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
  DISPLAY fi-canal fi-nome fi-estab-ini fi-estab-fim fi-transacao fi-tot-apb 
          fi-tot-acr fi-ok 
      WITH FRAME f-cad IN WINDOW esesb010A.
  ENABLE rt-button IMAGE-29 IMAGE-30 IMAGE-31 IMAGE-32 RECT-147 RECT-148 
         RECT-149 RECT-151 RECT-152 RECT-150 RECT-153 RECT-154 fi-estab-ini 
         fi-estab-fim bt-add fi-transacao fi-dt-vencto-ini fi-dt-vencto-fim 
         br-titulo bt-limpar bt-ok bt-cancela fi-ok 
      WITH FRAME f-cad IN WINDOW esesb010A.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW esesb010A.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy esesb010A 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display esesb010A 
PROCEDURE local-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
      
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit esesb010A 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize esesb010A 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "esesb0010B" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  FIND FIRST emitente NO-LOCK
      WHERE emitente.cod-emitente = p-canal NO-ERROR.
  IF  AVAIL emitente THEN
      ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad = emitente.nome-emit.


  DO WITH FRAME f-cad:
     ASSIGN fi-canal:SCREEN-VALUE         = STRING(p-canal)
            fi-tot-apb:SCREEN-VALUE       = STRING(p-valor)
            fi-dt-vencto-fim:SCREEN-VALUE = "31/12/2050"
            fi-dt-vencto-ini:SCREEN-VALUE = STRING(TODAY - 60)
            fi-transacao:SCREEN-VALUE     = STRING(TODAY).
  END.
    
  ASSIGN INPUT FRAME f-cad fi-tot-apb.

  RUN dispatch  IN this-procedure ('enable-fields':U).
  
  RUN dispatch  IN this-procedure ('display-fields':U).

  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-saldo-abatimento esesb010A 
PROCEDURE pi-atualiza-saldo-abatimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN fi-tot-acr:SCREEN-VALUE IN FRAME f-cad = STRING(fnAbatido()).

    IF  p-valor <> dec(fi-tot-acr:SCREEN-VALUE IN FRAME f-cad )
    OR  dec(fi-tot-acr:SCREEN-VALUE IN FRAME f-cad ) = 0 THEN 
        ASSIGN fi-ok:SCREEN-VALUE IN FRAME f-cad = "Aguardando Sele‡Æo..."
               fi-ok:FGCOLOR IN FRAME f-cad      = 1.
    ELSE
        ASSIGN fi-ok:SCREEN-VALUE IN FRAME f-cad = "Abatimento Completo."
               fi-ok:FGCOLOR IN FRAME f-cad      = 10.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-titulos esesb010A 
PROCEDURE pi-carrega-titulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-erro-aux.
    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE tt-central.
    IF  NOT VALID-HANDLE(h-acomp) THEN                                  
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp. 

    /* CANAIS ESTRUTURA CENTRAL - FILIAIS COM BASE NA DIGITA€ÇO DO USUµRIO */
    RUN esp/esb/esesbapi005.p (INPUT STRING(p-canal),
                               OUTPUT TABLE tt-central,
                               OUTPUT TABLE tt-erro).

    IF  RETURN-VALUE <> "OK" 
    OR  CAN-FIND (FIRST tt-erro) THEN DO:

        IF  CAN-FIND (FIRST tt-erro) THEN DO:
            FOR EACH tt-erro:
                ASSIGN i = i + 10.
                CREATE tt-erro-aux.
                ASSIGN tt-erro-aux.i-sequen = i
                       tt-erro-aux.cd-erro  = tt-erro.codigo
                       tt-erro-aux.mensagem = tt-erro.mensagem + CHR(10) + "Detalhe: " + tt-erro.ajuda.
            END.

            IF  CAN-FIND (FIRST tt-erro-aux) THEN DO:
                RUN cdp/cd0666.w (INPUT TABLE tt-erro-aux).
                IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.

               RETURN NO-APPLY.
            END.
        END.

        RETURN "NOK".

    END.

    /************** Desconsiderar determinados portadores/carteira ****************/
    DEF VAR c-lista-portador AS CHAR FORMAT "X(300)" NO-UNDO.
    DEF VAR i                AS INTEGER.
    DEF VAR c-carteira       AS CHAR NO-UNDO.
    DEF VAR c-portador       AS CHAR NO-UNDO.
    DEF VAR c-aux            AS CHAR NO-UNDO.
    DEF VAR i-position       AS INTEGER NO-UNDO.
    
    EMPTY TEMP-TABLE tt-prog-ponto.
    EMPTY TEMP-TABLE tt-portador.

    RUN esp/es0018p.p (INPUT  "esesb010a":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto.
    IF  AVAIL tt-prog-ponto THEN
        ASSIGN c-lista-portador = tt-prog-ponto.conteudo.
    
    DO  i = 1 TO NUM-ENTRIES(c-lista-portador, ";"):

        ASSIGN c-aux      = ENTRY(i, c-lista-portador, ";")
               i-position = INDEX(c-aux, "-").

        ASSIGN c-portador = ""
               c-carteira = "".

        IF  length(c-aux) > 0 THEN DO:
        
            ASSIGN c-portador = SUBSTRING(c-aux, 1, i-position - 1)
                   c-carteira = SUBSTRING(c-aux, i-position + 1, LENGTH(c-aux)).

            CREATE tt-portador.
            ASSIGN tt-portador.portador = c-portador
                   tt-portador.carteira = c-carteira.
        END.

    END.
    /********************************************************************************/

    /* LISTAGEM DOS TÖTULOS */
    EMPTY TEMP-TABLE tt-br-titulo.    
        
    ASSIGN de-saldo-final    = 0
           de-tot-comprometido = 0.

    IF  VALID-HANDLE(h-acomp) THEN                                      
        RUN pi-inicializar IN h-acomp (INPUT "Gerando Apura‡Æo").

    def buffer b_item_lote_liquidac_acr for item_lote_liquidac_acr.
    def buffer b_item_renegoc_acr for item_renegoc_acr.
    def buffer b_relacto_pend_tit_acr for relacto_pend_tit_acr.
    def buffer b_renegoc_acr for renegoc_acr.

    FOR EACH estabelecimento
        WHERE estabelecimento.cod_empresa = "1" /* v_cod_empres_usuar */
          AND estabelecimento.cod_estab >= fi-estab-ini:SCREEN-VALUE IN FRAME f-cad
          AND estabelecimento.cod_estab <= fi-estab-fim:SCREEN-VALUE IN FRAME f-cad NO-LOCK
        ,EACH tt-central
        , EACH tit_acr 
            WHERE tit_acr.cod_estab            = estabelecimento.cod_estab
              AND tit_acr.cdn_cliente          = tt-central.canal-filial
              AND tit_acr.ind_tip_espec_docto  = "Normal"
              AND tit_acr.dat_vencto_tit_acr   >= date(fi-dt-vencto-ini:SCREEN-VALUE IN FRAME f-cad)
              AND tit_acr.dat_vencto_tit_acr   <= date(fi-dt-vencto-fim:SCREEN-VALUE IN FRAME f-cad)
              AND tit_acr.dat_transacao        <= DATE(fi-transacao:SCREEN-VALUE IN FRAME f-cad)
              AND tit_acr.log_sdo_tit_acr      = YES NO-LOCK:

            IF  CAN-FIND(tt-portador
                            WHERE tt-portador.portador = tit_acr.cod_portador
                              AND tt-portador.carteira = tit_acr.cod_cart_bcia) THEN DO:
                NEXT.
            END.
            assign de-tot-comprometido = 0.

            IF  VALID-HANDLE(h-acomp) THEN                                      
                RUN pi-acompanhar IN h-acomp (INPUT "Bucando t¡tulos, vencimento: " + STRING(tit_acr.dat_vencto_tit_acr)).

            FOR EACH b_item_lote_liquidac_acr FIELDS(cod_estab cod_espec_docto cod_ser_docto cod_tit_acr cod_parcela val_liquidac_orig) USE-INDEX  itmltlqd_tit_acr NO-LOCK 
               WHERE b_item_lote_liquidac_acr.cod_estab      = tit_acr.cod_estab
                AND b_item_lote_liquidac_acr.cod_espec_docto = tit_acr.cod_espec_docto
                AND b_item_lote_liquidac_acr.cod_ser_docto   = tit_acr.cod_ser_docto
                AND b_item_lote_liquidac_acr.cod_tit_acr     = tit_acr.cod_tit_acr
                AND b_item_lote_liquidac_acr.cod_parcela     = tit_acr.cod_parcela:
                IF  (AVAIL  item_lote_liquidac_acr AND RECID(b_item_lote_liquidac_acr) <> RECID (item_lote_liquidac_acr))
                OR  NOT AVAIL  item_lote_liquidac_acr THEN 
                    ASSIGN de-tot-comprometido = de-tot-comprometido + b_item_lote_liquidac_acr.val_liquidac_orig.
            END.

            FOR EACH b_relacto_pend_tit_acr FIELDS (cod_estab_tit_acr_pai num_id_tit_acr_pai val_relacto_tit_acr) USE-INDEX rlctpnda_tit_acr NO-LOCK 
                WHERE b_relacto_pend_tit_acr.cod_estab_tit_acr_pai = tit_acr.cod_estab
                  AND b_relacto_pend_tit_acr.num_id_tit_acr_pai    = tit_acr.num_id_tit_acr:
                  IF (AVAIL  relacto_pend_tit_acr and RECID(b_relacto_pend_tit_acr) <> RECID(relacto_pend_tit_acr))
                  OR  NOT AVAIL relacto_pend_tit_acr THEN 
                    ASSIGN de-tot-comprometido = de-tot-comprometido + b_relacto_pend_tit_acr.val_relacto_tit_acr.
            END.

            FOR EACH b_item_renegoc_acr NO-LOCK 
                WHERE b_item_renegoc_acr.cod_estab_tit_acr    = tit_acr.cod_estab
                  AND b_item_renegoc_acr.num_id_tit_acr       = tit_acr.num_id_tit_acr use-index itmrngcc_tit_acr
                ,
                FIRST b_renegoc_acr NO-LOCK 
                   WHERE b_renegoc_acr.cod_estab               = b_item_renegoc_acr.cod_estab
                     AND b_renegoc_acr.num_renegoc_cobr_acr    = b_item_renegoc_acr.num_renegoc_cobr_acr
                     AND b_renegoc_acr.ind_sit_renegoc_acr    <> "Atualizado" /*l_atualizado*/ :

                IF (AVAIL item_renegoc_acr AND RECID(b_item_renegoc_acr) <> RECID(item_renegoc_acr))
                OR (NOT AVAIL item_renegoc_acr) THEN 
                   ASSIGN de-tot-comprometido = de-tot-comprometido + tit_acr.val_sdo_tit_acr.
            END.

            ASSIGN de-saldo-final = tit_acr.val_sdo_tit_acr - de-tot-comprometido.

            if  de-saldo-final <= 0 THEN NEXT.
            
            /* T¡tulo em opera‡Æo financeira */
            FIND FIRST operac_financ_acr
                 WHERE operac_financ_acr.cod_estab             = tit_acr.cod_estab_bord
                 AND operac_financ_acr.cod_movto_operac_financ = tit_acr.cod_movto_operac_financ NO-ERROR.
            IF AVAIL operac_financ_acr then
               NEXT.

            /* Valida se o t­tulo est  em um border"*/
            FIND FIRST item_bord_acr
                 WHERE item_bord_acr.cod_estab       = tit_acr.cod_estab
                 AND   item_bord_acr.cod_ser_docto   = tit_acr.cod_ser_docto
                 AND   item_bord_acr.cod_espec_docto = tit_acr.cod_espec_docto
                 AND   item_bord_acr.cod_tit_acr     = tit_acr.cod_tit_acr
                 AND   item_bord_acr.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
            IF  AVAIL item_bord_acr THEN 
                NEXT.

            IF  tit_acr.log_tit_acr_cobr_bcia = YES THEN DO:
                FIND LAST movto_ocor_bcia USE-INDEX mvtcrbc_id
                    WHERE movto_ocor_bcia.cod_estab             = tit_acr.cod_estab
                    AND movto_ocor_bcia.num_id_tit_acr          = tit_acr.num_id_tit_acr
                    AND movto_ocor_bcia.ind_ocor_bcia_remes_ret = "Remessa" /*l_remessa*/
                    AND (movto_ocor_bcia.ind_tip_ocor_bcia      = "Implanta‡Æo" /*l_implantacao*/
                    OR  movto_ocor_bcia.ind_tip_ocor_bcia       = "Envio Planilha" /*l_envio_planilha*/ )
                    AND movto_ocor_bcia.cod_portador            = tit_acr.cod_portador
                    AND movto_ocor_bcia.cod_cart_bcia           = tit_acr.cod_cart_bcia
                    AND movto_ocor_bcia.log_movto_envdo_bco     = YES  NO-LOCK NO-ERROR .
                IF  AVAIL movto_ocor_bcia AND movto_ocor_bcia.log_confir_movto_envdo_bco = NO 
                AND (movto_ocor_bcia.num_id_movto_ocor_confir   = 0 OR movto_ocor_bcia.num_id_movto_ocor_confir = ?) THEN 
                    NEXT.
            END.

            CREATE tt-br-titulo.
            ASSIGN tt-br-titulo.cod_estab        = tit_acr.cod_estab      
                   tt-br-titulo.cod_espec_docto  = tit_acr.cod_espec_docto
                   tt-br-titulo.cod_ser_docto    = tit_acr.cod_ser_docto  
                   tt-br-titulo.cod_tit_acr      = tit_acr.cod_tit_acr    
                   tt-br-titulo.cod_parcela      = tit_acr.cod_parcela    
                   tt-br-titulo.vl-saldo-titulo  = tit_acr.val_sdo_tit_acr         
                   tt-br-titulo.dt-vencto        = tit_acr.dat_vencto_tit_acr
                   tt-br-titulo.cod_portador     = tit_acr.cod_portador
                   tt-br-titulo.canal-filial     = tt-central.canal-filial.
     END.

     IF  VALID-HANDLE(h-acomp) THEN
         RUN pi-finalizar IN h-acomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-saldo-comprometido esesb010A 
PROCEDURE pi-verifica-saldo-comprometido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF BUFFER b_item_lote_liquidac_acr FOR item_lote_liquidac_acr.
    DEF BUFFER b_item_renegoc_acr       FOR item_renegoc_acr.
    DEF BUFFER b_relacto_pend_tit_acr   FOR relacto_pend_tit_acr.
    DEF BUFFER b_renegoc_acr            FOR renegoc_acr.
    
    assign de-tot-comprometido = 0.
            
    FOR EACH b_item_lote_liquidac_acr FIELDS (cod_estab cod_espec_docto cod_ser_docto cod_tit_acr cod_parcela val_liquidac_orig) USE-INDEX  itmltlqd_tit_acr NO-LOCK 
       WHERE b_item_lote_liquidac_acr.cod_estab       = tit_acr.cod_estab
         AND b_item_lote_liquidac_acr.cod_espec_docto = tit_acr.cod_espec_docto
         AND b_item_lote_liquidac_acr.cod_ser_docto   = tit_acr.cod_ser_docto
         AND b_item_lote_liquidac_acr.cod_tit_acr     = tit_acr.cod_tit_acr
         AND b_item_lote_liquidac_acr.cod_parcela     = tit_acr.cod_parcela:
         IF (AVAIL item_lote_liquidac_acr AND RECID(b_item_lote_liquidac_acr) <> RECID(item_lote_liquidac_acr))
         OR NOT AVAIL item_lote_liquidac_acr then
             ASSIGN de-tot-comprometido = de-tot-comprometido + b_item_lote_liquidac_acr.val_liquidac_orig.
    END.

    FOR EACH b_relacto_pend_tit_acr FIELDS (cod_estab_tit_acr_pai num_id_tit_acr_pai val_relacto_tit_acr) USE-INDEX rlctpnda_tit_acr NO-LOCK 
        WHERE b_relacto_pend_tit_acr.cod_estab_tit_acr_pai = tit_acr.cod_estab
          AND b_relacto_pend_tit_acr.num_id_tit_acr_pai    = tit_acr.num_id_tit_acr:
          IF (AVAIL relacto_pend_tit_acr AND RECID(b_relacto_pend_tit_acr) <> RECID(relacto_pend_tit_acr))
          OR  NOT AVAIL relacto_pend_tit_acr THEN 
              ASSIGN de-tot-comprometido = de-tot-comprometido + b_relacto_pend_tit_acr.val_relacto_tit_acr.
    END.

    FOR EACH b_item_renegoc_acr no-lock
        WHERE b_item_renegoc_acr.cod_estab_tit_acr    = tit_acr.cod_estab
        AND   b_item_renegoc_acr.num_id_tit_acr       = tit_acr.num_id_tit_acr USE-INDEX itmrngcc_tit_acr,
        FIRST b_renegoc_acr NO-LOCK 
           WHERE b_renegoc_acr.cod_estab               = b_item_renegoc_acr.cod_estab
           AND b_renegoc_acr.num_renegoc_cobr_acr    = b_item_renegoc_acr.num_renegoc_cobr_acr
           AND b_renegoc_acr.ind_sit_renegoc_acr    <> "Atualizado" /*l_atualizado*/ :

        IF (AVAIL item_renegoc_acr AND RECID(b_item_renegoc_acr) <> RECID(item_renegoc_acr))
        OR (NOT AVAIL item_renegoc_acr) THEN 
           ASSIGN de-tot-comprometido = de-tot-comprometido + tit_acr.val_sdo_tit_acr.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records esesb010A  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-br-titulo"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed esesb010A 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnAbatido esesb010A 
FUNCTION fnAbatido RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR de-abat AS DEC NO-UNDO.

  FOR EACH b-tt-br-titulo
      WHERE b-tt-br-titulo.valor > 0:
      de-abat = de-abat + b-tt-br-titulo.valor.
  END.


  RETURN de-abat.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

