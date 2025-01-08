&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esccp050 9.99.99.999}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esccp050 MCC}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.

def temp-table tthistorico no-undo
    FIELD data          LIKE int-item-tab.data
    FIELD hora          LIKE int-item-tab.hora
    FIELD cod-usuario   LIKE int-item-tab.cod-usuario
    FIELD nome-usuario  AS CHAR FORMAT "X(30)"
    FIELD tipo          AS CHAR FORMAT "x(10)" 
    FIELD pr-item-atual LIKE int-item-tab.pr-item-atual
    FIELD pr-item-novo  LIKE int-item-tab.pr-item-novo
    FIELD cod-moeda     AS INTEGER
    FIELD quant-min     LIKE int-item-tab.quant-min
    FIELD un-med-tab    AS CHAR FORMAT "x(2)"
    FIELD un-med        AS CHAR FORMAT "x(2)"
    FIELD cod-emitente  AS INTEGER 
    FIELD cond-pagto    AS INTEGER
    FIELD nr-tab        LIKE tb-pr-cc.Nr-tab
    FIELD descricao     LIKE tb-pr-cc.descricao
    FIELD situacao      AS CHAR FORMAT "x(7)"
    FIELD dt-inicio     LIKE tb-pr-cc.dt-inicio
    FIELD dt-termino    LIKE tb-pr-cc.dt-termino
    FIELD data-limite   LIKE int-item-tab.data_limite
    FIELD justificativa LIKE int-item-tab.justificativa
    FIELD it-codigo     LIKE ITEM.it-codigo
    FIELD desc-item     LIKE ITEM.desc-item.

DEFINE TEMP-TABLE tt-estrutura NO-UNDO LIKE estrutura.


DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

DEF VAR c-preco-atual AS CHAR FORMAT "x(18)".
DEF VAR h-acomp       as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brhistorico

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tthistorico

/* Definitions for BROWSE brhistorico                                   */
&Scoped-define FIELDS-IN-QUERY-brhistorico tthistorico.it-codigo tthistorico.desc-item tthistorico.data tthistorico.hora tthistorico.cod-usuario tthistorico.nome-usuario tthistorico.tipo (IF tthistorico.pr-item-atual = ? THEN 0 ELSE tthistorico.pr-item-atual) tthistorico.pr-item-novo tthistorico.cod-moeda tthistorico.quant-min tthistorico.un-med-tab tthistorico.un-med tthistorico.cod-emitente tthistorico.cond-pagto tthistorico.nr-tab tthistorico.descricao tthistorico.situacao tthistorico.dt-inicio tthistorico.dt-termino tthistorico.data-limite tthistorico.justificativa   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brhistorico   
&Scoped-define SELF-NAME brhistorico
&Scoped-define QUERY-STRING-brhistorico FOR EACH tthistorico indexed-reposition
&Scoped-define OPEN-QUERY-brhistorico OPEN QUERY {&SELF-NAME} FOR EACH tthistorico indexed-reposition.
&Scoped-define TABLES-IN-QUERY-brhistorico tthistorico
&Scoped-define FIRST-TABLE-IN-QUERY-brhistorico tthistorico


/* Definitions for FRAME fpage0                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtKeys IMAGE-11 IMAGE-12 IMAGE-29 IMAGE-5 ~
rtToolBar RECT-1 IMAGE-30 IMAGE-31 bt-excel bt-ok fi-ini-it-codigo ~
fi-fim-it-codigo fi-ini-cod-emitente fi-fim-cod-emitente fi-ini-data ~
fi-fim-data btGoTo rs-situacao brhistorico ed-justificativa 
&Scoped-Define DISPLAYED-OBJECTS fi-ini-it-codigo fi-fim-it-codigo ~
fi-ini-cod-emitente fi-fim-cod-emitente fi-ini-data fi-fim-data rs-situacao ~
ed-justificativa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 fi-ini-cod-emitente fi-fim-cod-emitente fi-ini-data ~
fi-fim-data 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-excel 
     IMAGE-UP FILE "image\excel.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "Importar arquivo".

DEFINE BUTTON bt-ok AUTO-GO 
     IMAGE-UP FILE "adeicon/cueexit.bmp":U
     LABEL "&OK" 
     SIZE 4 BY 1.29
     BGCOLOR 8 .

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 5.14 BY 1.25.

DEFINE VARIABLE ed-justificativa AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 124.86 BY 3.5 NO-UNDO.

DEFINE VARIABLE fi-fim-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fim-data AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fim-it-codigo AS CHARACTER FORMAT "X(256)":U INITIAL "ZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ini-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ini-data AS DATE FORMAT "99/99/9999" INITIAL 01/01/001 
     LABEL "Per¡odo":R15 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ini-it-codigo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-situacao AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Ativa", 1,
"Inativa", 2,
"Ambas", 3
     SIZE 32.43 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 127 BY 4.17.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 127 BY 4.38.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 127 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brhistorico FOR 
      tthistorico SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brhistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brhistorico w-cadsim _FREEFORM
  QUERY brhistorico DISPLAY
      tthistorico.it-codigo     COLUMN-LABEL "Item"
      tthistorico.desc-item     COLUMN-LABEL "Descri‡Æo"    FORMAT "x(26)" 
      tthistorico.data          COLUMN-LABEL "Data da a‡Æo"
      tthistorico.hora          COLUMN-LABEL "Hora da a‡Æo" FORMAT "x(5)"
      tthistorico.cod-usuario   COLUMN-LABEL "Matr¡cula Usu rio"
      tthistorico.nome-usuario  COLUMN-LABEL "Nome Usu rio"
      tthistorico.tipo          COLUMN-LABEL "Tipo de a‡Æo"
      (IF  tthistorico.pr-item-atual = ? THEN 0 ELSE tthistorico.pr-item-atual) FORMAT ">>>,>>>,>>9.99999" COLUMN-LABEL "Pre‡o Atual"
      tthistorico.pr-item-novo  COLUMN-LABEL "Pre‡o Novo"
      tthistorico.cod-moeda     COLUMN-LABEL "Moeda Tabela Nova"
      tthistorico.quant-min     COLUMN-LABEL "Qtde M¡nima Tabela"
      tthistorico.un-med-tab    COLUMN-LABEL "Unidade Medida Tabela"
      tthistorico.un-med        COLUMN-LABEL "Unidade Medida Interna"
      tthistorico.cod-emitente  COLUMN-LABEL "Fornecedor"
      tthistorico.cond-pagto    COLUMN-LABEL "Cond. Pagto"
      tthistorico.nr-tab        COLUMN-LABEL "N£mero Tabela"
      tthistorico.descricao     COLUMN-LABEL "Descri‡Æo Tabela"
      tthistorico.situacao      COLUMN-LABEL "Situa‡Æo"
      tthistorico.dt-inicio     COLUMN-LABEL "Data In¡cio"
      tthistorico.dt-termino    COLUMN-LABEL "Data T‚rmino"
      tthistorico.data-limite   COLUMN-LABEL "Data Limite/Corte"
      tthistorico.justificativa COLUMN-LABEL "Justificativa"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS NO-VALIDATE SIZE 127 BY 10.75
         FONT 2
         TITLE "Hist¢rico de Altera‡Æo de Pre‡os".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-excel AT ROW 1.13 COL 63.86 HELP
          "Gerar Relat¢rio de Embarque no Excel" WIDGET-ID 18
     bt-ok AT ROW 1.17 COL 124.57
     fi-ini-it-codigo AT ROW 2.83 COL 13.43 COLON-ALIGNED WIDGET-ID 48
     fi-fim-it-codigo AT ROW 2.83 COL 32.14 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     fi-ini-cod-emitente AT ROW 3.83 COL 13.43 COLON-ALIGNED WIDGET-ID 34
     fi-fim-cod-emitente AT ROW 3.88 COL 32.14 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     fi-ini-data AT ROW 4.88 COL 13.43 COLON-ALIGNED WIDGET-ID 42
     fi-fim-data AT ROW 4.88 COL 32.14 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     btGoTo AT ROW 5.46 COL 88 HELP
          "V  Para" WIDGET-ID 16
     rs-situacao AT ROW 6 COL 15.57 NO-LABEL WIDGET-ID 54
     brhistorico AT ROW 7.25 COL 2 WIDGET-ID 300
     ed-justificativa AT ROW 19.13 COL 3.14 NO-LABEL WIDGET-ID 58
     "Justificativa:" VIEW-AS TEXT
          SIZE 10 BY .67 AT ROW 18.29 COL 3 WIDGET-ID 62
     rtKeys AT ROW 2.63 COL 2 WIDGET-ID 50
     IMAGE-11 AT ROW 3.88 COL 30.43 WIDGET-ID 36
     IMAGE-12 AT ROW 3.88 COL 27 WIDGET-ID 38
     IMAGE-29 AT ROW 4.88 COL 30.57 WIDGET-ID 44
     IMAGE-5 AT ROW 4.88 COL 27.14 WIDGET-ID 46
     rtToolBar AT ROW 1 COL 2 WIDGET-ID 52
     RECT-1 AT ROW 18.75 COL 2 WIDGET-ID 60
     IMAGE-30 AT ROW 2.88 COL 30.43 WIDGET-ID 66
     IMAGE-31 AT ROW 2.88 COL 27 WIDGET-ID 68
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 128.43 BY 21.92 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo <Insira o complemento>"
         HEIGHT             = 22.13
         WIDTH              = 128.43
         MAX-HEIGHT         = 22.13
         MAX-WIDTH          = 135.43
         VIRTUAL-HEIGHT     = 22.13
         VIRTUAL-WIDTH      = 135.43
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB brhistorico rs-situacao fpage0 */
ASSIGN 
       brhistorico:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       brhistorico:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

ASSIGN 
       ed-justificativa:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fi-fim-cod-emitente IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-fim-data IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-ini-cod-emitente IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-ini-data IN FRAME fpage0
   1                                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brhistorico
/* Query rebuild information for BROWSE brhistorico
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tthistorico indexed-reposition.
     _END_FREEFORM
     _Query            is NOT OPENED
*/  /* BROWSE brhistorico */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brhistorico
&Scoped-define SELF-NAME brhistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brhistorico w-cadsim
ON ITERATION-CHANGED OF brhistorico IN FRAME fpage0 /* Hist¢rico de Altera‡Æo de Pre‡os */
DO:
  
    ASSIGN ed-justificativa:SCREEN-VALUE IN FRAME fpage0 = "".
 IF  AVAIL tthistorico THEN
     ASSIGN ed-justificativa:SCREEN-VALUE IN FRAME fpage0 = tthistorico.justificativa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brhistorico w-cadsim
ON MOUSE-SELECT-CLICK OF brhistorico IN FRAME fpage0 /* Hist¢rico de Altera‡Æo de Pre‡os */
DO:
       ASSIGN ed-justificativa:SCREEN-VALUE IN FRAME fpage0 = "".
    IF  AVAIL tthistorico THEN
        ASSIGN ed-justificativa:SCREEN-VALUE IN FRAME fpage0 = tthistorico.justificativa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brhistorico w-cadsim
ON ROW-DISPLAY OF brhistorico IN FRAME fpage0 /* Hist¢rico de Altera‡Æo de Pre‡os */
DO:
     ASSIGN ed-justificativa:SCREEN-VALUE IN FRAME fpage0 = "".
    IF  AVAIL tthistorico THEN
        ASSIGN ed-justificativa:SCREEN-VALUE IN FRAME fpage0 = tthistorico.justificativa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brhistorico w-cadsim
ON ROW-ENTRY OF brhistorico IN FRAME fpage0 /* Hist¢rico de Altera‡Æo de Pre‡os */
DO:
  
    ASSIGN ed-justificativa:SCREEN-VALUE IN FRAME fpage0 = "".
    IF  AVAIL tthistorico THEN
        ASSIGN ed-justificativa:SCREEN-VALUE IN FRAME fpage0 = tthistorico.justificativa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excel w-cadsim
ON CHOOSE OF bt-excel IN FRAME fpage0
DO:
    
    DEF VAR c-arquivo AS CHAR NO-UNDO.
    DEF BUFFER b-tthistorico FOR tthistorico.

    IF  NOT CAN-FIND(FIRST b-tthistorico) THEN
        RETURN "NOK".

    ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "AltPre‡oItem_" + STRING(fi-ini-it-codigo:SCREEN-VALUE IN FRAME fpage0) + "-" + STRING(fi-fim-it-codigo:SCREEN-VALUE IN FRAME fpage0) + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
    OUTPUT TO VALUE (c-arquivo) CONVERT TARGET "iso8859-1".
    PUT "Item;Descri‡Æo;Data da a‡Æo;Hora da a‡Æo;Matr¡cula Usu rio;Nome Usu rio;Tipo de a‡Æo;Pre‡o Atual;Pre‡o Novo;Moeda Tabela Nova;Qtde M¡nima Tabela;Unid. Medida Tabela;Un Medida Interna;Fornecedor;Cond. Pagto;N£mero Tabela;Descri‡Æo Tabela;Situa‡Æo;Data In¡cio;Data T‚rmino;Data Limite/Corte;Justificativa" SKIP.
    
    FOR EACH tthistorico:
        PUT tthistorico.it-codigo      ";"
            tthistorico.desc-item      ";"
            tthistorico.data           ";"
            tthistorico.hora FORMAT "x(5)"          ";"
            tthistorico.cod-usuario    ";"
            tthistorico.nome-usuario   ";"
            tthistorico.tipo           ";"
            tthistorico.pr-item-atual  ";"
            tthistorico.pr-item-novo   ";"
            tthistorico.cod-moeda      ";"
            tthistorico.quant-min      ";"
            tthistorico.un-med-tab     ";"
            tthistorico.un-med         ";"
            tthistorico.cod-emitente   ";"
            tthistorico.cond-pagto     ";"
            tthistorico.nr-tab         ";"
            tthistorico.descricao      ";"
            tthistorico.situacao       ";"
            tthistorico.dt-inicio      ";"
            tthistorico.dt-termino     ";"
            tthistorico.data-limite    ";"
            replace(replace(tthistorico.justificativa, CHR(13), " "), chr(10), "")   ";" SKIP.
    END.
    OUTPUT CLOSE.

    DOS SILENT START excel VALUE(c-arquivo).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME fpage0 /* OK */
DO:
  RUN notify ('update-record':U).
  if return-value <> "adm-error":U then
     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo w-cadsim
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
DO:
    run utp/ut-acomp.p persistent set h-acomp.

    RUN pi-inicializar in h-acomp (input "Buscando registros...").
    /*
    RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                       INPUT 17006, 
                       INPUT "Estabelecimento inv lido~~":U +
                             "O estabelecimento informado nÆo existe.").

    apply "entry" to v-cod-estabel in frame fPage0.
    return no-apply.
    */

    DEF VAR i-situacao AS INTEGER NO-UNDO.
    IF  INPUT FRAME fpage0 rs-situacao = 1 THEN
        ASSIGN i-situacao = 1.
    ELSE
        IF  INPUT FRAME fpage0 rs-situacao = 2 THEN
            ASSIGN i-situacao = 2.
        ELSE
            ASSIGN i-situacao = 3.
    

    EMPTY TEMP-TABLE tthistorico.

    FOR EACH int-item-tab NO-LOCK
        WHERE int-item-tab.it-codigo    >= INPUT FRAME fpage0 fi-ini-it-codigo
          AND int-item-tab.it-codigo    <= INPUT FRAME fpage0 fi-fim-it-codigo
          AND int-item-tab.cod-emitente >= INPUT FRAME fpage0 fi-ini-cod-emitente
          AND int-item-tab.cod-emitente <= INPUT FRAME fpage0 fi-fim-cod-emitente
          AND int-item-tab.data         >= INPUT FRAME fpage0 fi-ini-data
          AND int-item-tab.data         <= INPUT FRAME fpage0 fi-fim-data
           BY int-item-tab.data
           BY int-item-tab.hora
           BY int-item-tab.cod-emitente
           BY int-item-tab.nr-tab:
        
        run pi-acompanhar in h-acomp (input 'Data: ' + STRING(int-item-tab.data) ).
        FIND FIRST item-tab OF int-item-tab NO-LOCK NO-ERROR.

        FIND FIRST tb-pr-cc NO-LOCK
            WHERE tb-pr-cc.cod-emitente = int-item-tab.cod-emitente
              AND tb-pr-cc.cdn-fabrican = int-item-tab.cdn-fabrican
              AND tb-pr-cc.cod-cond-pag = int-item-tab.cod-cond-pag
              AND tb-pr-cc.nr-tab       = int-item-tab.nr-tab
              AND tb-pr-cc.dt-inicio    = int-item-tab.dt-inicio NO-ERROR.

        IF  AVAIL tb-pr-cc THEN DO:
            IF  tb-pr-cc.situacao = 1 AND i-situacao = 2 THEN
                NEXT.
            IF  tb-pr-cc.situacao = 2 AND i-situacao = 1 THEN
                NEXT.
        END.
            
        CREATE tthistorico.

        FIND usuar_mestre NO-LOCK
            WHERE usuar_mestre.cod_usuario = int-item-tab.cod-usuario NO-ERROR.
        IF  AVAIL usuar_mestre THEN
            ASSIGN tthistorico.nome-usuario  = usuar_mestre.nom_usuario.

        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = int-item-tab.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN
            ASSIGN tthistorico.un-med    = ITEM.un
                   tthistorico.it-codigo = ITEM.it-codigo
                   tthistorico.desc-item = ITEM.desc-item.

        CASE int-item-tab.tipo:
            WHEN 1 THEN tthistorico.tipo = "InclusÆo".
            WHEN 2 THEN tthistorico.tipo = "Altera‡Æo".
            WHEN 3 THEN tthistorico.tipo = "Elimina‡Æo".
        END CASE.

        FIND FIRST item-fornec NO-LOCK
            WHERE item-fornec.it-codigo    = int-item-tab.it-codigo 
              AND item-fornec.cod-emitente = int-item-tab.cod-emitente NO-ERROR.
        IF  AVAIL item-fornec THEN 
            ASSIGN tthistorico.un-med-tab = item-fornec.unid-med-for.

        ASSIGN tthistorico.data          = int-item-tab.data
               tthistorico.hora          = int-item-tab.hora
               tthistorico.cod-usuario   = int-item-tab.cod-usuario
               tthistorico.pr-item-atual = int-item-tab.pr-item-atual
               tthistorico.pr-item-novo  = int-item-tab.pr-item-novo
               tthistorico.cod-moeda     = int-item-tab.mo-codigo
               tthistorico.quant-min     = int-item-tab.quant-min
               tthistorico.cod-emitente  = int-item-tab.cod-emitente
               tthistorico.cond-pagto    = int-item-tab.cod-cond-pag
               tthistorico.nr-tab        = int-item-tab.nr-tab
               tthistorico.descricao     = int-item-tab.descricao
               tthistorico.situacao      = IF int-item-tab.situacao = 1 then "Ativa" ELSE "Inativa"
               tthistorico.dt-inicio     = int-item-tab.dt-inicio
               tthistorico.dt-termino    = int-item-tab.dt-termino
               tthistorico.data-limite   = int-item-tab.data_limite
               tthistorico.justificativa = int-item-tab.justificativa.
    END.

    run pi-finalizar in h-acomp.

    if valid-handle(h-acomp) then
       delete object h-acomp.

    &scop QUERY-NAME brhistorico
    {&OPEN-QUERY-{&QUERY-NAME}}   
    &undef QUERY-NAME  
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-fim-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fim-it-codigo w-cadsim
ON F5 OF fi-fim-it-codigo IN FRAME fpage0
DO:
   {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                      &campo="fi-fim-it-codigo"
                      &campozoom=it-codigo
                      &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fim-it-codigo w-cadsim
ON LEAVE OF fi-fim-it-codigo IN FRAME fpage0
DO:
  /*
    FIND ITEM NO-LOCK
        WHERE ITEM.it-codigo = fi-it-codigo:SCREEN-VALUE IN FRAME fPage0 NO-ERROR.

    IF  AVAIL ITEM
    THEN
        DISP ITEM.desc-item @ fi-desc-item WITH FRAME fpage0.
    ELSE
        DISP "" @ fi-desc-item WITH FRAME fpage0. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fim-it-codigo w-cadsim
ON MOUSE-SELECT-DBLCLICK OF fi-fim-it-codigo IN FRAME fpage0
DO:
  apply "F5":U to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ini-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ini-it-codigo w-cadsim
ON F5 OF fi-ini-it-codigo IN FRAME fpage0 /* Item */
DO:
   {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                      &campo="fi-ini-it-codigo"
                      &campozoom=it-codigo
                      &frame="fPage0"}
 /*   {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                      &campo="fi-it-codigo"
                      &campozoom="it-codigo"
                      &frame="fPage0"
                      &campo2="fi-desc-item"
                      &campozoom2="desc-item"
                      &frame2="fPage0"} */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ini-it-codigo w-cadsim
ON LEAVE OF fi-ini-it-codigo IN FRAME fpage0 /* Item */
DO:
  /*
    FIND ITEM NO-LOCK
        WHERE ITEM.it-codigo = fi-it-codigo:SCREEN-VALUE IN FRAME fPage0 NO-ERROR.

    IF  AVAIL ITEM
    THEN
        DISP ITEM.desc-item @ fi-desc-item WITH FRAME fpage0.
    ELSE
        DISP "" @ fi-desc-item WITH FRAME fpage0. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ini-it-codigo w-cadsim
ON MOUSE-SELECT-DBLCLICK OF fi-ini-it-codigo IN FRAME fpage0 /* Item */
DO:
  apply "F5":U to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
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
  DISPLAY fi-ini-it-codigo fi-fim-it-codigo fi-ini-cod-emitente 
          fi-fim-cod-emitente fi-ini-data fi-fim-data rs-situacao 
          ed-justificativa 
      WITH FRAME fpage0 IN WINDOW w-cadsim.
  ENABLE rtKeys IMAGE-11 IMAGE-12 IMAGE-29 IMAGE-5 rtToolBar RECT-1 IMAGE-30 
         IMAGE-31 bt-excel bt-ok fi-ini-it-codigo fi-fim-it-codigo 
         fi-ini-cod-emitente fi-fim-cod-emitente fi-ini-data fi-fim-data btGoTo 
         rs-situacao brhistorico ed-justificativa 
      WITH FRAME fpage0 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fpage0}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "esccp050" "9.99.99.999"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  RUN dispatch  IN this-procedure ('enable-fields':U).

  {include/i-inifld.i}

  fi-ini-it-codigo:load-mouse-pointer("image/lupa.cur") IN FRAME fpage0.
  fi-fim-it-codigo:load-mouse-pointer("image/lupa.cur") IN FRAME fpage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tthistorico"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
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

