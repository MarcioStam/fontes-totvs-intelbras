&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
{include/i-prgvrs.i esflg007 2.00.00.000}


CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE VARIABLE h-api AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.
DEFINE VARIABLE cTransacao AS CHARACTER FORMAT "X(15)"  NO-UNDO.
DEFINE VARIABLE hprogramzoom AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_tit_ap  AS RECID FORMAT ">>>>>>>9" INITIAL ? NO-UNDO.
/*{cdp/cd0666.i}*/

DEF VAR i-situacao      AS INTEGER NO-UNDO.
def temp-table tt-erro-aux no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".


DEFINE TEMP-TABLE tt-operacao        NO-UNDO LIKE int-operacao
    FIELD r-operacao AS ROWID 
    FIELD nome-moeda AS CHAR FORMAT "x(30)"
    FIELD nome-banco AS CHAR FORMAT "x(30)".

DEFINE TEMP-TABLE tt-operacao-lancto NO-UNDO LIKE int-operacao-lancto
    FIELD periodo-formatado AS CHAR FORMAT "x(7)"
    FIELD rowid-lancto      AS ROWID.

def new global shared var h-facelift as handle no-undo.

IF NOT VALID-HANDLE(h-facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h-facelift.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta  AS LOGICAL.

DEF VAR h-acomp AS HANDLE NO-UNDO.

DEF VAR i-cor AS INT NO-UNDO.

{utp/ut-glob.i}
{esp/es0018.i}

DEFINE VARIABLE v_win_original_width  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_win_original_height AS DECIMAL     NO-UNDO.

DEFINE VARIABLE v_column AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_asc    AS LOGICAL     NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_rec_tit_ap AS RECID format ">>>>>>9" INITIAL ? NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_tit_acr AS RECID format ">>>>>>9" INITIAL ? NO-UNDO.

DEF NEW GLOBAL SHARED VAR gr-ped-venda AS ROWID NO-UNDO.

DEF STREAM s-1.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

DEFINE VARIABLE c-grp-fin  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-grp-ctbl AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-lancto

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-operacao-lancto tt-operacao

/* Definitions for BROWSE br-lancto                                     */
&Scoped-define FIELDS-IN-QUERY-br-lancto tt-operacao-lancto.periodo-formatado tt-operacao-lancto.tp-lancto tt-operacao-lancto.variacao tt-operacao-lancto.cotacao tt-operacao-lancto.num_lote_ctbl   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-lancto   
&Scoped-define SELF-NAME br-lancto
&Scoped-define QUERY-STRING-br-lancto FOR EACH tt-operacao-lancto BY tt-operacao-lancto.periodo DESC                                                     BY tt-operacao-lancto.tp-lancto
&Scoped-define OPEN-QUERY-br-lancto OPEN QUERY {&SELF-NAME} FOR EACH tt-operacao-lancto BY tt-operacao-lancto.periodo DESC                                                     BY tt-operacao-lancto.tp-lancto.
&Scoped-define TABLES-IN-QUERY-br-lancto tt-operacao-lancto
&Scoped-define FIRST-TABLE-IN-QUERY-br-lancto tt-operacao-lancto


/* Definitions for BROWSE br-operacao                                   */
&Scoped-define FIELDS-IN-QUERY-br-operacao tt-operacao.operacao tt-operacao.cod-banco tt-operacao.dt-fechamento tt-operacao.dt-vencimento tt-operacao.Cotacao tt-operacao.val-operacao tt-operacao.nome-moeda   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-operacao   
&Scoped-define SELF-NAME br-operacao
&Scoped-define QUERY-STRING-br-operacao FOR EACH tt-operacao BY tt-operacao.operacao  DESC
&Scoped-define OPEN-QUERY-br-operacao OPEN QUERY {&SELF-NAME} FOR EACH tt-operacao BY tt-operacao.operacao  DESC.
&Scoped-define TABLES-IN-QUERY-br-operacao tt-operacao
&Scoped-define FIRST-TABLE-IN-QUERY-br-operacao tt-operacao


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-lancto}~
    ~{&OPEN-QUERY-br-operacao}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-operacao-ini fi-operacao-fim fi-banco-ini ~
fi-banco-fim fi-fechamento-ini fi-fechamento-fim fi-vencimento-ini ~
fi-vencimento-fim fi-moeda-ini fi-moeda-fim bt-filtrar bt-exportar ~
br-lancto bt-ok rt-button RECT-157 IMAGE-25 IMAGE-26 IMAGE-27 IMAGE-28 ~
IMAGE-33 IMAGE-34 IMAGE-35 IMAGE-36 IMAGE-37 IMAGE-38 RECT-158 br-operacao 
&Scoped-Define DISPLAYED-OBJECTS fi-operacao-ini fi-operacao-fim ~
fi-banco-ini fi-banco-fim fi-fechamento-ini fi-fechamento-fim ~
fi-vencimento-ini fi-vencimento-fim fi-moeda-ini fi-moeda-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-calcula 
     IMAGE-UP FILE "image/im-calc3.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Calcular Operaá∆o".

DEFINE BUTTON bt-contabiliza 
     IMAGE-UP FILE "image/im-lote.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Contabilizar Operaá∆o".

DEFINE BUTTON bt-eliminar 
     IMAGE-UP FILE "image/im-era.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Eliminar Operaá∆o".

DEFINE BUTTON bt-eliminar-2 
     IMAGE-UP FILE "image/im-era.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Eliminar Operaá∆o".

DEFINE BUTTON bt-exportar 
     IMAGE-UP FILE "image/excel.jpg":U
     LABEL "" 
     SIZE 4 BY 1.13 TOOLTIP "Exportar para Excel as informaá‰es em tela".

DEFINE BUTTON bt-filtrar 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "Buscar Solicitaá‰es".

DEFINE BUTTON bt-incluir 
     IMAGE-UP FILE "image/im-add.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Incluir Operaá∆o".

DEFINE BUTTON bt-modificar 
     IMAGE-UP FILE "image/im-mod.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Modificar Operaá∆o".

DEFINE BUTTON bt-ok AUTO-GO 
     IMAGE-UP FILE "image/im-exi.bmp":U
     LABEL "&Fechar" 
     SIZE 4 BY 1.13 TOOLTIP "Sair do programa"
     BGCOLOR 8 .

DEFINE VARIABLE fi-banco-fim AS CHARACTER FORMAT "x(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 TOOLTIP "Banco" NO-UNDO.

DEFINE VARIABLE fi-banco-ini AS CHARACTER FORMAT "x(8)":U 
     LABEL "Banco" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 TOOLTIP "Banco" NO-UNDO.

DEFINE VARIABLE fi-fechamento-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/2050 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 TOOLTIP "Fechamento" NO-UNDO.

DEFINE VARIABLE fi-fechamento-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Contrataá∆o" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 TOOLTIP "Contrataá∆o" NO-UNDO.

DEFINE VARIABLE fi-moeda-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 TOOLTIP "Moeda" NO-UNDO.

DEFINE VARIABLE fi-moeda-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Moeda" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 TOOLTIP "Moeda" NO-UNDO.

DEFINE VARIABLE fi-operacao-fim AS CHARACTER FORMAT "X(15)":U INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 TOOLTIP "Operaá∆o" NO-UNDO.

DEFINE VARIABLE fi-operacao-ini AS CHARACTER FORMAT "X(15)":U 
     LABEL "Operaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 TOOLTIP "Operaá∆o" NO-UNDO.

DEFINE VARIABLE fi-vencimento-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/2050 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 TOOLTIP "Vencimento" NO-UNDO.

DEFINE VARIABLE fi-vencimento-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 TOOLTIP "Vencimento" NO-UNDO.

DEFINE IMAGE IMAGE-25
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-33
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-34
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-35
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-36
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-37
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-38
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-157
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 110 BY 6.79.

DEFINE RECTANGLE RECT-158
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 110 BY 9.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 110 BY 1.38
     BGCOLOR 8 FGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-lancto FOR 
      tt-operacao-lancto SCROLLING.

DEFINE QUERY br-operacao FOR 
      tt-operacao SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-lancto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-lancto w-cadsim _FREEFORM
  QUERY br-lancto DISPLAY
      tt-operacao-lancto.periodo-formatado              COLUMN-LABEL "Per°odo"         WIDTH 8
      tt-operacao-lancto.tp-lancto                      COLUMN-LABEL "Tipo"            WIDTH 4
      tt-operacao-lancto.variacao                       COLUMN-LABEL "Variaá∆o"        WIDTH 14
      tt-operacao-lancto.cotacao                        COLUMN-LABEL "Cotaá∆o"         WIDTH 17
      tt-operacao-lancto.num_lote_ctbl                  COLUMN-LABEL "Lote"            WIDTH 15
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 103 BY 8.42
         FONT 7
         TITLE "LANÄAMENTOS" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN TOOLTIP "Lanáamentos da operaá∆o".

DEFINE BROWSE br-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-operacao w-cadsim _FREEFORM
  QUERY br-operacao DISPLAY
      tt-operacao.operacao                               COLUMN-LABEL "Operaá∆o"       WIDTH 15
      tt-operacao.cod-banco                              COLUMN-LABEL "Banco"          WIDTH 5
      tt-operacao.dt-fechamento                          COLUMN-LABEL "Contrataá∆o"    WIDTH 10
      tt-operacao.dt-vencimento                          COLUMN-LABEL "Vencto Hedge"   WIDTH 10
      tt-operacao.Cotacao                                COLUMN-LABEL "Cotaá∆o"        WIDTH 11
      tt-operacao.val-operacao                           COLUMN-LABEL "Valor Operaá∆o" WIDTH 14
      tt-operacao.nome-moeda                             COLUMN-LABEL "Moeda"          WIDTH 17
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 103 BY 6.25
         FONT 1
         TITLE "OPERAÄÂES" ROW-HEIGHT-CHARS .58 FIT-LAST-COLUMN TOOLTIP "Duplo clique para Alterar".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     fi-operacao-ini AT ROW 3.13 COL 34 COLON-ALIGNED WIDGET-ID 248
     fi-operacao-fim AT ROW 3 COL 57.57 COLON-ALIGNED NO-LABEL WIDGET-ID 246
     fi-banco-ini AT ROW 4 COL 34 COLON-ALIGNED WIDGET-ID 258
     fi-banco-fim AT ROW 4 COL 57.57 COLON-ALIGNED NO-LABEL WIDGET-ID 260
     fi-fechamento-ini AT ROW 5 COL 34 COLON-ALIGNED WIDGET-ID 190
     fi-fechamento-fim AT ROW 5 COL 57.57 COLON-ALIGNED NO-LABEL WIDGET-ID 262
     fi-vencimento-ini AT ROW 6 COL 34 COLON-ALIGNED WIDGET-ID 266
     fi-vencimento-fim AT ROW 6 COL 57.57 COLON-ALIGNED NO-LABEL WIDGET-ID 264
     fi-moeda-ini AT ROW 7 COL 34 COLON-ALIGNED WIDGET-ID 160
     fi-moeda-fim AT ROW 7 COL 57.57 COLON-ALIGNED NO-LABEL WIDGET-ID 268
     bt-filtrar AT ROW 6.63 COL 75 HELP
          "Buscar Solicitaá‰es" WIDGET-ID 132
     bt-incluir AT ROW 9.75 COL 105.72 WIDGET-ID 184
     bt-modificar AT ROW 11 COL 105.72 WIDGET-ID 222
     bt-eliminar AT ROW 12.29 COL 105.72 WIDGET-ID 176
     bt-exportar AT ROW 1.13 COL 98 WIDGET-ID 106
     br-lancto AT ROW 15.71 COL 2.14 HELP
          "T°tulos abatidos atravÇs de encontro de contas" WIDGET-ID 800
     bt-calcula AT ROW 16.5 COL 106 WIDGET-ID 218
     bt-contabiliza AT ROW 17.79 COL 106 WIDGET-ID 244
     bt-ok AT ROW 1.13 COL 106.29 WIDGET-ID 242
     bt-eliminar-2 AT ROW 19.08 COL 106 WIDGET-ID 298
     br-operacao AT ROW 8.75 COL 2 WIDGET-ID 200
     "OPERAÄ«O DE HEDGE" VIEW-AS TEXT
          SIZE 16.86 BY .67 AT ROW 1.38 COL 46.14 WIDGET-ID 122
          BGCOLOR 8 FONT 1
     rt-button AT ROW 1 COL 1
     RECT-157 AT ROW 8.46 COL 1 WIDGET-ID 270
     IMAGE-25 AT ROW 6.04 COL 52 WIDGET-ID 278
     IMAGE-26 AT ROW 6.04 COL 56.14 WIDGET-ID 280
     IMAGE-27 AT ROW 7.04 COL 52 WIDGET-ID 282
     IMAGE-28 AT ROW 7.04 COL 56.14 WIDGET-ID 284
     IMAGE-33 AT ROW 5.04 COL 52 WIDGET-ID 286
     IMAGE-34 AT ROW 5.04 COL 56.14 WIDGET-ID 288
     IMAGE-35 AT ROW 3.04 COL 52 WIDGET-ID 290
     IMAGE-36 AT ROW 3.04 COL 56.14 WIDGET-ID 292
     IMAGE-37 AT ROW 4.04 COL 52 WIDGET-ID 294
     IMAGE-38 AT ROW 4.04 COL 56.14 WIDGET-ID 296
     RECT-158 AT ROW 15.5 COL 1 WIDGET-ID 300
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 134 BY 24.5
         BGCOLOR 15 FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manutená∆o <Insira o complemento>"
         HEIGHT             = 23.5
         WIDTH              = 110.43
         MAX-HEIGHT         = 28.67
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.67
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
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-lancto bt-exportar f-cad */
/* BROWSE-TAB br-operacao RECT-158 f-cad */
ASSIGN 
       br-lancto:COLUMN-RESIZABLE IN FRAME f-cad       = TRUE.

ASSIGN 
       br-operacao:ALLOW-COLUMN-SEARCHING IN FRAME f-cad = TRUE
       br-operacao:COLUMN-RESIZABLE IN FRAME f-cad       = TRUE.

/* SETTINGS FOR BUTTON bt-calcula IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-contabiliza IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-eliminar IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-eliminar-2 IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-incluir IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-modificar IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-lancto
/* Query rebuild information for BROWSE br-lancto
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-operacao-lancto BY tt-operacao-lancto.periodo DESC
                                                    BY tt-operacao-lancto.tp-lancto
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-lancto */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-operacao
/* Query rebuild information for BROWSE br-operacao
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-operacao BY tt-operacao.operacao  DESC
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-operacao */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manutená∆o <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manutená∆o <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-lancto
&Scoped-define SELF-NAME br-lancto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-lancto w-cadsim
ON START-SEARCH OF br-lancto IN FRAME f-cad /* LANÄAMENTOS */
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


&Scoped-define BROWSE-NAME br-operacao
&Scoped-define SELF-NAME br-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-operacao w-cadsim
ON MOUSE-SELECT-CLICK OF br-operacao IN FRAME f-cad /* OPERAÄÂES */
DO:
  IF  NOT AVAIL tt-operacao THEN
      RETURN "OK".
  RUN pi-carrega-lanctos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-operacao w-cadsim
ON MOUSE-SELECT-DBLCLICK OF br-operacao IN FRAME f-cad /* OPERAÄÂES */
DO:
  APPLY "choose" TO bt-modificar IN FRAME f-cad.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-operacao w-cadsim
ON START-SEARCH OF br-operacao IN FRAME f-cad /* OPERAÄÂES */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-operacao w-cadsim
ON VALUE-CHANGED OF br-operacao IN FRAME f-cad /* OPERAÄÂES */
DO: 

    IF  NOT AVAIL tt-operacao THEN
        RETURN "OK".

   RUN pi-carrega-lanctos.
    
/*                                                                              */
/*     IF  AVAIL tt-conta-corrente THEN                                         */
/*         RUN pi-seta-status-crm-em-tela (INPUT tt-conta-corrente.status-crm). */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-calcula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-calcula w-cadsim
ON CHOOSE OF bt-calcula IN FRAME f-cad
DO:
 
    IF  NOT AVAIL tt-operacao THEN
        RETURN NO-APPLY.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN esp/fgl/esfgl007-calc.w (INPUT tt-operacao.operacao).
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    RUN pi-carrega-lanctos.

    RETURN "OK".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-contabiliza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-contabiliza w-cadsim
ON CHOOSE OF bt-contabiliza IN FRAME f-cad
DO:
 
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.


    DEF VAR c-conta-Passivo AS CHAR NO-UNDO.
    DEF VAR c-VC-Ativa      AS CHAR NO-UNDO.
    DEF VAR c-VC-Passiva    AS CHAR NO-UNDO.

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "esfgl007":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FOR FIRST tt-prog-ponto:
        ASSIGN c-conta-Passivo = entry(1, tt-prog-ponto.conteudo, ";")
               c-VC-Ativa      = entry(2, tt-prog-ponto.conteudo, ";")
               c-VC-Passiva    = entry(3, tt-prog-ponto.conteudo, ";").
    END.
    
    
    IF  c-conta-Passivo = "" 
    OR  c-VC-Ativa      = "" 
    OR  c-VC-Passiva    = "" THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Contas n∆o parametrizadas corretamente no ES0018. Entre em contato com a TIC").
        RETURN NO-APPLY.
    END.
    
    RUN esp/fgl/esfgl007-contab.w (INPUT tt-operacao-lancto.operacao,
                                   INPUT c-conta-Passivo,
                                   INPUT c-VC-Ativa,
                                   INPUT c-VC-Passiva).
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    RUN pi-carrega-lanctos.

    RETURN "OK".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar w-cadsim
ON CHOOSE OF bt-eliminar IN FRAME f-cad
DO:

    IF  NOT AVAIL tt-operacao THEN
        RETURN NO-APPLY.

    RUN utp/ut-msgs.p (INPUT "show":U,
                       INPUT 27100,
                       INPUT "Confirma Eliminaá∆o da Operaá∆o?").
    IF  RETURN-VALUE = "no" THEN 
        RETURN NO-APPLY.


    /* VALIDA ELIMINAÄ«O */
    FOR EACH int-operacao-lancto NO-LOCK
        WHERE int-operacao-lancto.operacao = tt-operacao.operacao:

        FIND lote_ctbl NO-LOCK
           WHERE lote_ctbl.num_lote_ctbl = int-operacao-lancto.num_lote_ctbl NO-ERROR.
        IF  AVAIL lote_ctbl THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "J† existe lanáamento contabilizado para essa operaá∆o.").
            RETURN NO-APPLY.
        END.
    END.

    DO TRANS:
        FIND int-operacao EXCLUSIVE-LOCK
            WHERE int-operacao.operacao = tt-operacao.operacao NO-ERROR.

        FOR EACH int-operacao-lancto EXCLUSIVE-LOCK
            WHERE int-operacao-lancto.operacao = tt-operacao.operacao:
            DELETE int-operacao-lancto.
        END.

        IF  AVAIL int-operacao THEN
            DELETE int-operacao.

        APPLY "choose" TO bt-filtrar IN FRAM f-cad.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-eliminar-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar-2 w-cadsim
ON CHOOSE OF bt-eliminar-2 IN FRAME f-cad
DO:

    IF  NOT AVAIL tt-operacao-lancto THEN
        RETURN NO-APPLY.

    FIND lote_ctbl NO-LOCK
       WHERE lote_ctbl.num_lote_ctbl = tt-operacao-lancto.num_lote_ctbl NO-ERROR.
    IF  AVAIL lote_ctbl THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "O movimento existente na contabilidade.").
        RETURN NO-APPLY.
    END.

    FIND LAST int-operacao-lancto NO-LOCK
        WHERE int-operacao-lancto.operacao  = tt-operacao-lancto.operacao
          AND int-operacao-lancto.periodo   = tt-operacao-lancto.periodo 
          AND ROWID(int-operacao-lancto)   <> tt-operacao-lancto.rowid-lancto NO-ERROR.
                                                  
    IF  AVAIL int-operacao-lancto
    AND int-operacao-lancto.tp-lancto = "C" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Existe um per°odo calculado posterior ao atual." + "~~" + 
                                 "N∆o Ç poss°vel efetuar essa eliminaá∆o").
        RETURN NO-APPLY.
    END.

    FIND LAST int-operacao-lancto NO-LOCK
        WHERE int-operacao-lancto.operacao  = tt-operacao-lancto.operacao
          AND int-operacao-lancto.periodo   > tt-operacao-lancto.periodo NO-ERROR.
    
    IF  AVAIL int-operacao-lancto 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Existe um per°odo calculado posterior ao atual." + "~~" + 
                                 "N∆o Ç poss°vel efetuar essa eliminaá∆o").
        RETURN NO-APPLY.
    END.


    RUN utp/ut-msgs.p (INPUT "show":U,
                       INPUT 27100,
                       INPUT "Confirma Eliminaá∆o do Lanáamento?").
    IF  RETURN-VALUE = "no" THEN 
        RETURN NO-APPLY.

    DO TRANS:
        FIND int-operacao-lancto EXCLUSIVE-LOCK
            WHERE int-operacao-lancto.operacao  = tt-operacao-lancto.operacao
              AND int-operacao-lancto.periodo   = tt-operacao-lancto.periodo
              AND int-operacao-lancto.tp-lancto = tt-operacao-lancto.tp-lancto NO-ERROR.

        IF  AVAIL int-operacao-lancto THEN
            DELETE int-operacao-lancto.

        FIND CURRENT int-operacao-lancto NO-LOCK NO-ERROR.
           
        RELEASE int-operacao-lancto NO-ERROR.     
   
        RUN pi-carrega-lanctos.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exportar w-cadsim
ON CHOOSE OF bt-exportar IN FRAME f-cad
DO:

    RUN pi-gera-excel-operacao.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtrar w-cadsim
ON CHOOSE OF bt-filtrar IN FRAME f-cad
DO:
   
    EMPTY TEMP-TABLE tt-operacao.
    EMPTY TEMP-TABLE tt-operacao-lancto.
   
    RUN pi-carrega-operacoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir w-cadsim
ON CHOOSE OF bt-incluir IN FRAME f-cad
DO:

/*     IF  NOT tt-operacao.SituacaoSolicitacaoBeneficio = 993520003 THEN DO:    */
/*         /* PENDENTE DE PAGAMENTO*/                                           */
/*         RUN utp/ut-msgs.p(input "show":U,                                    */
/*                   input 17006,                                               */
/*                   input  "Situaá∆o da Solicitaá∆o n∆o permite pagamento.").  */
/*         RETURN "NOK".                                                        */
/*     END.                                                                     */

 
/*     run utp/ut-msgs.p (input "show", input 27100, input "Confirma o Pagamento da solicitaá∆o?" + "~~" +                          */
/*                    "Ao pagar a solicitaá∆o, o saldo da conta corrente do canal estar† dispon°vel para envio ao CRM. Confirma?"). */
/*                                                                                                                                  */
/*     IF  RETURN-VALUE <> "YES" THEN                                                                                               */
/*         RETURN NO-APPLY.                                                                                                         */
/*                                                                                                                                  */

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    DEF VAR l-cancelou AS LOG INIT NO.
    RUN esp/fgl/esfgl007A.w (INPUT  ?,
                             INPUT  YES,
                             OUTPUT l-cancelou).

    IF  NOT l-cancelou THEN
        APPLY "choose" TO bt-filtrar IN FRAME f-cad.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-modificar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar w-cadsim
ON CHOOSE OF bt-modificar IN FRAME f-cad
DO:

    IF  NOT AVAIL tt-operacao THEN
        RETURN NO-APPLY.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    DEF VAR r-row-operacao  AS ROWID NO-UNDO.
    DEF VAR l-cancelou      AS LOG INIT NO NO-UNDO.

    DEF BUFFER b-tt-operacao FOR tt-operacao.

    ASSIGN r-row-operacao = rowid(tt-operacao).

    RUN esp/fgl/esfgl007A.w (INPUT  tt-operacao.r-operacao,
                             INPUT  NO,
                             OUTPUT l-cancelou).

   
    IF  NOT l-cancelou THEN DO:
        APPLY "CHOOSE" TO bt-filtrar IN FRAME f-cad.
    
        FIND FIRST b-tt-operacao
            WHERE b-tt-operacao.r-operacao = r-row-operacao NO-ERROR.
    
        REPOSITION br-operacao TO ROWID r-row-operacao.
        APPLY "value-changed"        TO br-operacao IN FRAME f-cad.
    END.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* Fechar */
DO:
  RUN notify ('update-record':U).
  if return-value <> "adm-error":U then
     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-lancto
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* fi-canal:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-cad. */

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
  DISPLAY fi-operacao-ini fi-operacao-fim fi-banco-ini fi-banco-fim 
          fi-fechamento-ini fi-fechamento-fim fi-vencimento-ini 
          fi-vencimento-fim fi-moeda-ini fi-moeda-fim 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE fi-operacao-ini fi-operacao-fim fi-banco-ini fi-banco-fim 
         fi-fechamento-ini fi-fechamento-fim fi-vencimento-ini 
         fi-vencimento-fim fi-moeda-ini fi-moeda-fim bt-filtrar bt-exportar 
         br-lancto bt-ok rt-button RECT-157 IMAGE-25 IMAGE-26 IMAGE-27 IMAGE-28 
         IMAGE-33 IMAGE-34 IMAGE-35 IMAGE-36 IMAGE-37 IMAGE-38 RECT-158 
         br-operacao 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
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

  IF  VALID-HANDLE(h-api) THEN
      RUN pi-destroy IN h-api.


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

  {utp/ut9000.i "ESFGL007" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN dispatch  IN this-procedure ('enable-fields':U).

  
/*   APPLY 'value-changed'      TO br-canais IN FRAME f-cad.  */
  DEF VAR da-data AS DATE NO-UNDO.

  ASSIGN da-data = DATE(MONTH(TODAY), 01, YEAR(TODAY)) - 1.
         da-data = DATE(MONTH(da-data), 01, YEAR(da-data)).

  ASSIGN fi-fechamento-ini:SCREEN-VALUE IN FRAME f-cad = STRING("31/01/2010")
         fi-vencimento-ini:SCREEN-VALUE IN FRAME f-cad = STRING(da-data)
         fi-vencimento-fim:SCREEN-VALUE IN FRAME f-cad = STRING("31/12/2050").
  
  
    {include/i-inifld.i}

    EMPTY TEMP-TABLE tt-prog-ponto.

    ASSIGN c-grp-fin  = "*"
           c-grp-ctbl = "*".
    
    RUN esp/es0018p.p (INPUT  "esfgl007",
                       INPUT  2,
                       INPUT  0,
                       INPUT  "",
                       OUTPUT TABLE tt-prog-ponto).
    
    FOR EACH tt-prog-ponto:
    
        IF  NUM-ENTRIES(tt-prog-ponto.conteudo,"#") > 1
        THEN DO:
            IF  tt-prog-ponto.conteudo BEGINS "GRPFIN" 
            THEN 
                ASSIGN c-grp-fin = TRIM(ENTRY(2,tt-prog-ponto.conteudo,"#")).
    
            IF  tt-prog-ponto.conteudo BEGINS "GRPCTBL" 
            THEN 
                ASSIGN c-grp-ctbl = TRIM(ENTRY(2,tt-prog-ponto.conteudo,"#")).
        END.
    END.

    IF  c-grp-fin <> "*"
    THEN DO:
        FOR FIRST  usuar_grp_usuar NO-LOCK
            WHERE usuar_grp_usuar.cod_usuario = c-seg-usuario
              AND INDEX(c-grp-fin,usuar_grp_usuar.cod_grp_usuar) <> 0:

            ENABLE bt-incluir bt-modificar bt-eliminar WITH FRAME {&FRAME-NAME}.
        END.
    END.
    ELSE 
        ENABLE bt-incluir bt-modificar bt-eliminar WITH FRAME {&FRAME-NAME}.


    IF  c-grp-ctbl <> "*"
    THEN DO:
        FOR FIRST  usuar_grp_usuar NO-LOCK
            WHERE usuar_grp_usuar.cod_usuario = c-seg-usuario
              AND INDEX(c-grp-ctbl,usuar_grp_usuar.cod_grp_usuar) <> 0:

            ENABLE bt-calcula bt-contabiliza bt-eliminar-2 WITH FRAME {&FRAME-NAME}.
        END.
    END.
    ELSE
        ENABLE bt-calcula bt-contabiliza bt-eliminar-2 WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-lanctos w-cadsim 
PROCEDURE pi-carrega-lanctos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    EMPTY TEMP-TABLE tt-operacao-lancto.

    {&open-query-br-lancto}


    IF  AVAIL tt-operacao THEN DO:
        
        FOR EACH int-operacao-lancto NO-LOCK
            WHERE int-operacao-lancto.operacao = tt-operacao.operacao:
    
            CREATE tt-operacao-lancto.  
            BUFFER-COPY int-operacao-lancto TO tt-operacao-lancto.
            ASSIGN tt-operacao-lancto.periodo-formatado = (substr(tt-operacao-lancto.periodo, 5,2) + "/" +
                                                           substr(tt-operacao-lancto.periodo, 1,4)   )
                   tt-operacao-lancto.rowid-lancto = ROWID(int-operacao-lancto).
        end.
        
    END.
    
    {&open-query-br-lancto}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-operacoes w-cadsim 
PROCEDURE pi-carrega-operacoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-operacao.

    DO WITH FRAME f-cad:
        FOR EACH int-operacao NO-LOCK
            WHERE int-operacao.operacao      >= fi-operacao-ini:SCREEN-VALUE
              AND int-operacao.operacao      <= fi-operacao-fim:SCREEN-VALUE
              AND int-operacao.cod-banco     >= fi-banco-ini:SCREEN-VALUE
              AND int-operacao.cod-banco     <= fi-banco-fim:SCREEN-VALUE
              AND int-operacao.dt-fechamento >= date(fi-fechamento-ini:SCREEN-VALUE)
              AND int-operacao.dt-fechamento <= date(fi-fechamento-fim:SCREEN-VALUE)
              AND int-operacao.dt-vencimento >= date(fi-vencimento-ini:SCREEN-VALUE)
              AND int-operacao.dt-vencimento <= date(fi-vencimento-fim:SCREEN-VALUE)
              AND int-operacao.cod-moeda     >= fi-moeda-ini:SCREEN-VALUE
              AND int-operacao.cod-moeda     <= fi-moeda-fim:SCREEN-VALUE
            , FIRST indic_econ NO-LOCK
                WHERE indic_econ.cod_indic_econ = int-operacao.cod-moeda
            , FIRST emscad.portador NO-LOCK
                WHERE emscad.portador.cod_portador = int-operacao.cod-banco:
            
            CREATE tt-operacao.
            BUFFER-COPY int-operacao TO tt-operacao.
    
            ASSIGN tt-operacao.r-operacao = ROWID(int-operacao)
                   tt-operacao.nome-moeda = indic_econ.des_indic_econ
                   tt-operacao.nome-banco = emscad.portador.nom_abrev.
    
        END.
    END.

    {&open-query-br-operacao}

    APPLY "value-changed" TO br-operacao IN FRAME f-cad.

    {&open-query-br-lancto}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-excel-operacao w-cadsim 
PROCEDURE pi-gera-excel-operacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

      IF  NOT AVAIL tt-operacao THEN
          RETURN "OK".

      DEF VAR c-arquivo AS CHAR NO-UNDO.

      ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "Operacao_Hedge" + "_" + STRING(TODAY, "99-99-9999") + "_" + STRING(TIME) + ".csv".

      OUTPUT STREAM s-1 TO value(c-arquivo) CONVERT TARGET "iso8859-1".

      PUT STREAM s-1 "Operaá∆o;Banco;Nome;Fechamento;Vencimento;Cotacao;Moeda;Vl Operaá∆o;Lanáamento;Tp Lancto;Variaá∆o;Cotaáao;Lote;Nr Lancto" SKIP.

      FOR EACH int-operacao
          WHERE int-operacao.operacao      >= fi-operacao-ini:SCREEN-VALUE IN FRAME f-cad            
            AND int-operacao.operacao      <= fi-operacao-fim:SCREEN-VALUE IN FRAME f-cad            
            AND int-operacao.cod-banco     >= fi-banco-ini:SCREEN-VALUE IN FRAME f-cad               
            AND int-operacao.cod-banco     <= fi-banco-fim:SCREEN-VALUE IN FRAME f-cad               
            AND int-operacao.dt-fechamento >= date(fi-fechamento-ini:SCREEN-VALUE IN FRAME f-cad)     
            AND int-operacao.dt-fechamento <= date(fi-fechamento-fim:SCREEN-VALUE IN FRAME f-cad)     
            AND int-operacao.dt-vencimento >= date(fi-vencimento-ini:SCREEN-VALUE IN FRAME f-cad)     
            AND int-operacao.dt-vencimento <= date(fi-vencimento-fim:SCREEN-VALUE IN FRAME f-cad)     
            AND int-operacao.cod-moeda     >= fi-moeda-ini:SCREEN-VALUE IN FRAME f-cad               
            AND int-operacao.cod-moeda     <= fi-moeda-fim:SCREEN-VALUE IN FRAME f-cad               
          , FIRST indic_econ NO-LOCK                                                   
              WHERE indic_econ.cod_indic_econ = int-operacao.cod-moeda                 
          , FIRST emscad.portador NO-LOCK                                                
              WHERE emscad.portador.cod_portador = int-operacao.cod-banco
          , 
              EACH int-operacao-lancto OF int-operacao
          
          BY int-operacao-lancto.operacao
          BY int-operacao-lancto.periodo DESC
          BY int-operacao-lancto.tp-lancto:

           EXPORT STREAM s-1 DELIMITER ";" int-operacao.operacao
                                           int-operacao.cod-Banco
                                           emscad.portador.nom_abrev
                                           int-operacao.dt-fechamento
                                           int-operacao.dt-vencimento
                                           int-operacao.cotacao
                                           indic_econ.des_indic_econ
                                           int-operacao.val-operacao
                                           (substr(int-operacao-lancto.periodo, 5,2) + "/" + substr(int-operacao-lancto.periodo, 1,4)   )                            
                                           int-operacao-lancto.tp-lancto        
                                           int-operacao-lancto.variacao         
                                           int-operacao-lancto.cotacao          
                                           int-operacao-lancto.num_lote_ctbl.  
      END.

      OUTPUT STREAM s-1 CLOSE.

      DOS SILENT START excel VALUE(c-arquivo).

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
  {src/adm/template/snd-list.i "tt-operacao"}
  {src/adm/template/snd-list.i "tt-operacao-lancto"}

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

