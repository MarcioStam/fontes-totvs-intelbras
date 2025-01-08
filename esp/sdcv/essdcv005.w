&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESSDCV005 2.06.00.000}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Global Variable Definitions ---                                      */
DEFINE NEW GLOBAL SHARED VARIABLE gc-plano  AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gc-ccusto AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */
{upc/btb910za-upc.i}
DEFINE VARIABLE h-acomp AS HANDLE NO-UNDO.

/*---[ Temp-table definitions ]-----------------------------------------------*/
DEFINE TEMP-TABLE tt-conta NO-UNDO
    FIELD cod_plano_cta_ctbl LIKE plano_cta_ctbl.cod_plano_cta_ctbl
    FIELD cod_cta_ctbl       LIKE cta_ctbl.cod_cta_ctbl
    FIELD des_cta_ctbl       LIKE cta_ctbl.des_tit_ctbl.

DEFINE TEMP-TABLE tt-conta-aux NO-UNDO
    FIELD marca              AS   CHAR FORMAT "X(01)"
    FIELD cod_plano_cta_ctbl LIKE plano_cta_ctbl.cod_plano_cta_ctbl
    FIELD cod_cta_ctbl       LIKE cta_ctbl.cod_cta_ctbl
    FIELD des_cta_ctbl       LIKE cta_ctbl.des_tit_ctbl.

DEFINE TEMP-TABLE tt-exp-conta NO-UNDO LIKE tt-conta-aux.

DEFINE TEMP-TABLE tt-ccusto NO-UNDO
    FIELD cod_plano_ccusto   LIKE plano_ccusto.cod_plano_ccusto 
    FIELD cod_ccusto         LIKE emscad.ccusto_unid_negoc.cod_ccusto
    FIELD des_ccusto         LIKE emscad.ccusto.des_tit_ctbl
    FIELD cod_unid_negoc     LIKE emscad.ccusto_unid_negoc.cod_unid_negoc
    FIELD cod_estab          LIKE cc_uni_estab.cod_estab.

DEFINE TEMP-TABLE tt-ccusto-aux NO-UNDO LIKE tt-ccusto
    FIELD marca AS CHAR FORMAT "X(01)".

DEFINE TEMP-TABLE tt-exp-ccusto NO-UNDO
    FIELD cod_plano_ccusto LIKE plano_ccusto.cod_plano_ccusto 
    FIELD cod_unid_negoc   LIKE cc_uni_estab.cod_unid_negoc
    FIELD cod_ccusto       LIKE emscad.ccusto.cod_ccusto
    FIELD des_ccusto       LIKE emscad.ccusto.des_tit_ctbl
    FIELD cod_estab        LIKE cc_uni_estab.cod_estab
    INDEX ch-id IS UNIQUE cod_plano_ccusto cod_unid_negoc cod_ccusto cod_estab.

DEFINE TEMP-TABLE tt-plano-aux NO-UNDO
    FIELD cod_plano_cta_ctbl LIKE plano_cta_ctbl.cod_plano_cta_ctbl
    FIELD cod_cta_ctbl       LIKE cta_ctbl.cod_cta_ctbl
    FIELD cod_unid_negoc     LIKE emscad.ccusto_unid_negoc.cod_unid_negoc
    FIELD cod_plano_ccusto   LIKE plano_ccusto.cod_plano_ccusto
    FIELD cod_ccusto         LIKE emscad.ccusto_unid_negoc.cod_ccusto
    FIELD cod_estab          LIKE cc_uni_estab.cod_estab
    INDEX ch-id IS UNIQUE cod_plano_cta_ctbl cod_cta_ctbl cod_unid_negoc cod_plano_ccusto cod_ccusto cod_estab.

DEFINE TEMP-TABLE tt-exp-plano NO-UNDO
    FIELD cod_plano_cta_ctbl LIKE plano_cta_ctbl.cod_plano_cta_ctbl
    FIELD cod_cta_ctbl       LIKE cta_ctbl.cod_cta_ctbl
    FIELD cod_unid_negoc     LIKE emscad.ccusto_unid_negoc.cod_unid_negoc
    FIELD cod_ccusto         LIKE emscad.ccusto_unid_negoc.cod_ccusto
    FIELD cod_estab          LIKE cc_uni_estab.cod_estab
    INDEX ch-id IS UNIQUE cod_plano_cta_ctbl cod_cta_ctbl cod_unid_negoc cod_ccusto cod_estab.

DEFINE VARIABLE p_cod_plano_cta_ctbl LIKE plano_cta_ctbl.cod_plano_cta_ctbl NO-UNDO.
DEFINE VARIABLE p_cod_plano_ccusto   LIKE plano_ccusto.cod_plano_ccusto     NO-UNDO.

IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
IF NOT VALID-HANDLE(h_api_ccusto)   THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

IF valid-handle(h_api_ccusto) THEN RUN pi_busca_plano_ccusto_empresa IN h_api_ccusto (INPUT  "" /*v_cod_empres_usuar*/ ,
                                                                                      INPUT  TODAY,
                                                                                      OUTPUT p_cod_plano_ccusto,
                                                                                      OUTPUT TABLE tt_log_erro).

IF valid-handle(h_api_cta_ctbl) THEN RUN pi_busca_plano_cta_ctbl_empresa IN h_api_cta_ctbl (INPUT  "" /*v_cod_empres_usuar*/ ,
                                                                                            INPUT  TODAY,
                                                                                            OUTPUT p_cod_plano_cta_ctbl,
                                                                                            OUTPUT TABLE tt_log_erro).

/* Definiá∆o da temp-table ttRawTabela */
{esp/sdcv/essdcv001api.i}

/* Definiá∆o das procedure internas pi-cria-mensagem e
   pi-cria-mensagem-pela-RowErrors */
{esp/sdcv/essdcv003rp.i}

DEFINE VARIABLE i-cont-aux        AS   INTEGER                   NO-UNDO.
DEFINE VARIABLE c-file-log        AS   CHARACTER FORMAT 'x(100)' NO-UNDO.
DEFINE VARIABLE c-file-log2       AS   CHARACTER FORMAT 'x(100)' NO-UNDO.
DEFINE VARIABLE cdesc-conta       LIKE cta_ctbl.des_tit_ctbl     NO-UNDO.
DEFINE VARIABLE cdesc-ccusto      LIKE emscad.ccusto.des_tit_ctbl  NO-UNDO.
DEFINE VARIABLE ccod_cta_auxiliar LIKE cta_ctbl.cod_cta_ctbl     NO-UNDO.
DEFINE VARIABLE v_num_row_a       AS   INTEGER                   NO-UNDO.

{esp/sdcv/ESSDCV001API.I3}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-ccusto

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ccusto-aux tt-conta-aux tt-plano-aux

/* Definitions for BROWSE br-ccusto                                     */
&Scoped-define FIELDS-IN-QUERY-br-ccusto tt-ccusto-aux.marca NO-LABEL tt-ccusto-aux.cod_ccusto tt-ccusto-aux.des_ccusto tt-ccusto-aux.cod_estab tt-ccusto-aux.cod_unid_negoc tt-ccusto-aux.cod_plano_ccusto   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ccusto   
&Scoped-define SELF-NAME br-ccusto
&Scoped-define QUERY-STRING-br-ccusto FOR EACH tt-ccusto-aux BY tt-ccusto-aux.cod_ccusto BY tt-ccusto-aux.cod_estab
&Scoped-define OPEN-QUERY-br-ccusto OPEN QUERY {&SELF-NAME} FOR EACH tt-ccusto-aux BY tt-ccusto-aux.cod_ccusto BY tt-ccusto-aux.cod_estab.
&Scoped-define TABLES-IN-QUERY-br-ccusto tt-ccusto-aux
&Scoped-define FIRST-TABLE-IN-QUERY-br-ccusto tt-ccusto-aux


/* Definitions for BROWSE br-conta                                      */
&Scoped-define FIELDS-IN-QUERY-br-conta tt-conta-aux.marca NO-LABEL tt-conta-aux.cod_cta_ctbl tt-conta-aux.des_cta_ctbl   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-conta   
&Scoped-define SELF-NAME br-conta
&Scoped-define QUERY-STRING-br-conta FOR EACH  tt-conta-aux BY tt-conta-aux.cod_cta_ctbl
&Scoped-define OPEN-QUERY-br-conta OPEN QUERY {&SELF-NAME} FOR EACH  tt-conta-aux BY tt-conta-aux.cod_cta_ctbl.
&Scoped-define TABLES-IN-QUERY-br-conta tt-conta-aux
&Scoped-define FIRST-TABLE-IN-QUERY-br-conta tt-conta-aux


/* Definitions for BROWSE brExp                                         */
&Scoped-define FIELDS-IN-QUERY-brExp tt-plano-aux.cod_unid_negoc tt-plano-aux.cod_estab tt-plano-aux.cod_cta_ctbl fnDescricao("conta":U, tt-plano-aux.cod_cta_ctbl) @ cdesc-conta tt-plano-aux.cod_ccusto fnDescricao("ccusto":U, tt-plano-aux.cod_ccusto) @ cdesc-ccusto   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brExp   
&Scoped-define SELF-NAME brExp
&Scoped-define QUERY-STRING-brExp FOR EACH tt-plano-aux
&Scoped-define OPEN-QUERY-brExp OPEN QUERY {&SELF-NAME} FOR EACH tt-plano-aux.
&Scoped-define TABLES-IN-QUERY-brExp tt-plano-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brExp tt-plano-aux


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-ccusto}~
    ~{&OPEN-QUERY-br-conta}~
    ~{&OPEN-QUERY-brExp}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ccod-estabel-ini ccod-estabel-fim ~
c_cod_ccusto_inicial c_cod_ccusto_final bt-gera bt-marca-cc bt-all-cc ~
bt-nenhum-cc btCtaCtbl c_cod_cta_inicial c_cod_cta_final bt-seleciona ~
bt-marca bt-all bt-nenhum br-conta brExp btExporta btInativaCC btDelPlano ~
bt-del rt-button RECT-6 IMAGE-6 IMAGE-7 RECT-7 RECT-9 RECT-2 IMAGE-1 ~
IMAGE-3 RECT-1 IMAGE-4 IMAGE-5 br-ccusto 
&Scoped-Define DISPLAYED-OBJECTS ccod-estabel-ini ccod-estabel-fim ~
c_cod_ccusto_inicial c_cod_ccusto_final c_cod_cta_inicial c_cod_cta_final 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricao w-livre 
FUNCTION fnDescricao RETURNS CHARACTER
  ( ccampo AS CHAR, ccod-linha AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-programa 
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
              DISABLED
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
              DISABLED
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  mi-programa    LABEL "Menu"          
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-all 
     IMAGE-UP FILE "image/im-todos.bmp":U
     LABEL "" 
     SIZE 5 BY 1.33 TOOLTIP "Todas".

DEFINE BUTTON bt-all-cc 
     IMAGE-UP FILE "image/im-todos.bmp":U
     LABEL "" 
     SIZE 5 BY 1.33 TOOLTIP "Todas".

DEFINE BUTTON bt-del 
     IMAGE-UP FILE "image/toolbar/im-era.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-era.bmp":U
     LABEL "" 
     SIZE 5 BY 1.38 TOOLTIP "&Elimina registro".

DEFINE BUTTON bt-gera 
     IMAGE-UP FILE "image/toolbar/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-enter.bmp":U
     LABEL "" 
     SIZE 5 BY 2.29 TOOLTIP "Carrega Centros de Custo".

DEFINE BUTTON bt-marca 
     IMAGE-UP FILE "image/im-toggle.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-toggle.bmp":U
     LABEL "" 
     SIZE 5 BY 1.33 TOOLTIP "Marca/Desmarca".

DEFINE BUTTON bt-marca-cc 
     IMAGE-UP FILE "image/im-toggle.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-toggle.bmp":U
     LABEL "" 
     SIZE 5 BY 1.33 TOOLTIP "Marca/Desmarca".

DEFINE BUTTON bt-nenhum 
     IMAGE-UP FILE "image/im-nenhum.bmp":U
     LABEL "" 
     SIZE 5 BY 1.33 TOOLTIP "Nenhuma".

DEFINE BUTTON bt-nenhum-cc 
     IMAGE-UP FILE "image/im-nenhum.bmp":U
     LABEL "" 
     SIZE 5 BY 1.33 TOOLTIP "Nenhuma".

DEFINE BUTTON bt-seleciona 
     IMAGE-UP FILE "image/toolbar/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-enter.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25.

DEFINE BUTTON btCtaCtbl 
     IMAGE-UP FILE "image/toolbar/im-estru.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-estru.bmp":U
     LABEL "" 
     SIZE 5 BY 1.33 TOOLTIP "Carrega Contas Cont†beis".

DEFINE BUTTON btDelPlano 
     IMAGE-UP FILE "image/toolbar/im-cance.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-cance.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "&Exclui Plano OBC".

DEFINE BUTTON btExporta 
     IMAGE-UP FILE "image/toolbar/im-exp.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-exp.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "Exporta SDCV":U.

DEFINE BUTTON btInativaCC 
     IMAGE-UP FILE "image/toolbar/im-exc.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-exc.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "&Inativa Centro Custo".

DEFINE VARIABLE ccod-estabel-fim AS CHARACTER FORMAT "x(05)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-estabel-ini AS CHARACTER FORMAT "x(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c_cod_ccusto_final AS CHARACTER FORMAT "X(5)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c_cod_ccusto_inicial AS CHARACTER FORMAT "X(5)" 
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c_cod_cta_final AS CHARACTER FORMAT "X(8)" INITIAL "4ZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c_cod_cta_inicial AS CHARACTER FORMAT "X(8)" INITIAL "40000000" 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 1.42.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 6 BY 10.79
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 6 BY 9.83
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 57.14 BY 2.42.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 6 BY 7.96
     BGCOLOR 7 .

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 137.72 BY 1.46
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-ccusto FOR 
      tt-ccusto-aux SCROLLING.

DEFINE QUERY br-conta FOR 
      tt-conta-aux SCROLLING.

DEFINE QUERY brExp FOR 
      tt-plano-aux SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ccusto w-livre _FREEFORM
  QUERY br-ccusto DISPLAY
      tt-ccusto-aux.marca                      NO-LABEL
      tt-ccusto-aux.cod_ccusto     COLUMN-LABEL "Centro Custo   " WIDTH 5
    tt-ccusto-aux.des_ccusto     COLUMN-LABEL "T°tulo CC"
    tt-ccusto-aux.cod_estab
    tt-ccusto-aux.cod_unid_negoc
tt-ccusto-aux.cod_plano_ccusto
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 51 BY 9.83
         FONT 1
         TITLE "Centro Custo" FIT-LAST-COLUMN.

DEFINE BROWSE br-conta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-conta w-livre _FREEFORM
  QUERY br-conta DISPLAY
      tt-conta-aux.marca                      NO-LABEL
    tt-conta-aux.cod_cta_ctbl   COLUMN-LABEL "Conta   " WIDTH 8
    tt-conta-aux.des_cta_ctbl   COLUMN-LABEL "T°tulo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 74 BY 10.79
         FONT 1
         TITLE "Conta Cont†bil" FIT-LAST-COLUMN.

DEFINE BROWSE brExp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brExp w-livre _FREEFORM
  QUERY brExp DISPLAY
      tt-plano-aux.cod_unid_negoc
        tt-plano-aux.cod_estab
        tt-plano-aux.cod_cta_ctbl
        fnDescricao("conta":U, tt-plano-aux.cod_cta_ctbl) @ cdesc-conta
        tt-plano-aux.cod_ccusto
        fnDescricao("ccusto":U, tt-plano-aux.cod_ccusto) @ cdesc-ccusto
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 131.43 BY 7.96
         FONT 1
         TITLE "Dados a Exportar para SDCV" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     ccod-estabel-ini AT ROW 2.83 COL 17.86 COLON-ALIGNED HELP
          "Estabelecimento" WIDGET-ID 46
     ccod-estabel-fim AT ROW 2.83 COL 35.86 COLON-ALIGNED HELP
          "Estabelecimento" NO-LABEL WIDGET-ID 48
     c_cod_ccusto_inicial AT ROW 3.83 COL 17.86 COLON-ALIGNED HELP
          "Centro Custo" WIDGET-ID 120
     c_cod_ccusto_final AT ROW 3.83 COL 35.86 COLON-ALIGNED HELP
          "Centro Custo" NO-LABEL WIDGET-ID 118
     bt-gera AT ROW 2.63 COL 53.14
     bt-marca-cc AT ROW 5.21 COL 53.14 WIDGET-ID 24
     bt-all-cc AT ROW 6.63 COL 53.14 WIDGET-ID 22
     bt-nenhum-cc AT ROW 8.04 COL 53.14 WIDGET-ID 26
     btCtaCtbl AT ROW 9.46 COL 53.14 WIDGET-ID 90
     c_cod_cta_inicial AT ROW 2.83 COL 79.14 COLON-ALIGNED HELP
          "Conta" WIDGET-ID 108
     c_cod_cta_final AT ROW 2.83 COL 100.14 COLON-ALIGNED HELP
          "Conta" NO-LABEL WIDGET-ID 106
     bt-seleciona AT ROW 2.67 COL 133.43 WIDGET-ID 104
     bt-marca AT ROW 4.25 COL 133.43 WIDGET-ID 84
     bt-all AT ROW 5.67 COL 133.43 WIDGET-ID 82
     bt-nenhum AT ROW 7.08 COL 133.43 WIDGET-ID 86
     br-conta AT ROW 4.13 COL 58.86 WIDGET-ID 400
     brExp AT ROW 15.17 COL 1 WIDGET-ID 300
     btExporta AT ROW 18.79 COL 133.43 WIDGET-ID 6
     btInativaCC AT ROW 20.25 COL 133.43 WIDGET-ID 156
     btDelPlano AT ROW 21.71 COL 133.43 WIDGET-ID 158
     bt-del AT ROW 15.38 COL 133.43 WIDGET-ID 136
     br-ccusto AT ROW 5.08 COL 51.43 RIGHT-ALIGNED WIDGET-ID 200
     rt-button AT ROW 1 COL 1.29
     RECT-6 AT ROW 5.08 COL 52.57 WIDGET-ID 28
     IMAGE-6 AT ROW 2.83 COL 27.14 WIDGET-ID 42
     IMAGE-7 AT ROW 2.83 COL 34.72 WIDGET-ID 44
     RECT-7 AT ROW 2.58 COL 1.43 WIDGET-ID 50
     RECT-9 AT ROW 15.17 COL 132.86 WIDGET-ID 80
     RECT-2 AT ROW 4.13 COL 132.86 WIDGET-ID 102
     IMAGE-1 AT ROW 2.83 COL 91.57 WIDGET-ID 110
     IMAGE-3 AT ROW 2.83 COL 99.14 WIDGET-ID 112
     RECT-1 AT ROW 2.58 COL 58.86 WIDGET-ID 114
     IMAGE-4 AT ROW 3.83 COL 27.14 WIDGET-ID 122
     IMAGE-5 AT ROW 3.83 COL 34.72 WIDGET-ID 124
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 138.29 BY 22.38
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "Atualizaá∆o Contas SDCV"
         HEIGHT             = 22.54
         WIDTH              = 138.14
         MAX-HEIGHT         = 24.83
         MAX-WIDTH          = 163.86
         VIRTUAL-HEIGHT     = 24.83
         VIRTUAL-WIDTH      = 163.86
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-livre.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-conta bt-nenhum f-cad */
/* BROWSE-TAB brExp br-conta f-cad */
/* BROWSE-TAB br-ccusto IMAGE-5 f-cad */
/* SETTINGS FOR BROWSE br-ccusto IN FRAME f-cad
   ALIGN-R                                                              */
ASSIGN 
       br-ccusto:COLUMN-RESIZABLE IN FRAME f-cad       = TRUE
       br-ccusto:COLUMN-MOVABLE IN FRAME f-cad         = TRUE.

ASSIGN 
       br-conta:COLUMN-RESIZABLE IN FRAME f-cad       = TRUE
       br-conta:COLUMN-MOVABLE IN FRAME f-cad         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ccusto
/* Query rebuild information for BROWSE br-ccusto
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ccusto-aux BY tt-ccusto-aux.cod_ccusto BY tt-ccusto-aux.cod_estab.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-ccusto */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-conta
/* Query rebuild information for BROWSE br-conta
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH  tt-conta-aux BY tt-conta-aux.cod_cta_ctbl.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-conta */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brExp
/* Query rebuild information for BROWSE brExp
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-plano-aux.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brExp */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Atualizaá∆o Contas SDCV */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Atualizaá∆o Contas SDCV */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-ccusto
&Scoped-define SELF-NAME br-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ccusto w-livre
ON MOUSE-SELECT-DBLCLICK OF br-ccusto IN FRAME f-cad /* Centro Custo */
DO:
  APPLY "return" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ccusto w-livre
ON RETURN OF br-ccusto IN FRAME f-cad /* Centro Custo */
DO:
    DO  i-cont-aux = 1 TO br-ccusto:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF  br-ccusto:FETCH-SELECTED-ROW(i-cont-aux) IN FRAME {&FRAME-NAME} THEN DO:

            IF  AVAIL tt-ccusto-aux THEN DO:
                if  tt-ccusto-aux.marca = "*" THEN DO:
                    assign tt-ccusto-aux.marca = "" .
                END.
                ELSE DO:
                    assign tt-ccusto-aux.marca = "*".
               END.

                self:refresh().
            END.  /* IF  AVAIL tt-ccusto-aux THEN DO: */
        END. /* IF  br-ccusto:FETCH-SELECTED-ROW(i-cont-aux) */
    END. /* DO  i-cont-aux = 1 TO br-ccusto: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-conta
&Scoped-define SELF-NAME br-conta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-conta w-livre
ON MOUSE-SELECT-CLICK OF br-conta IN FRAME f-cad /* Conta Cont†bil */
DO:
    APPLY "value-changed":U TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-conta w-livre
ON MOUSE-SELECT-DBLCLICK OF br-conta IN FRAME f-cad /* Conta Cont†bil */
DO:
  APPLY "return" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-conta w-livre
ON RETURN OF br-conta IN FRAME f-cad /* Conta Cont†bil */
DO:
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Buscando ...").

    IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Montando plano conta ...":U).

    DO  i-cont-aux = 1 TO br-conta:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF  br-conta:FETCH-SELECTED-ROW(i-cont-aux) IN FRAME {&FRAME-NAME} THEN DO:

            IF  AVAIL tt-conta-aux THEN DO:
                if  tt-conta-aux.marca = "*" THEN DO:
                    assign tt-conta-aux.marca = "" .
                    
                    FOR EACH  tt-plano-aux 
                        WHERE tt-plano-aux.cod_cta_ctbl = tt-conta-aux.cod_cta_ctbl:
                        DELETE tt-plano-aux.
                    END. /* FOR EACH  tt-plano-aux */
                END. /* if  tt-conta-aux.marca = "*" THEN ... */
                ELSE DO:
                    assign tt-conta-aux.marca = "*".
                    RUN pi-monta-plano.
                END. /* ELSE DO: */
                
                self:refresh().
            END.  /* IF  AVAIL tt-conta-aux THEN DO: */
        END. /* IF  br-conta:FETCH-SELECTED-ROW(i-cont-aux) */
    END. /* DO  i-cont-aux = 1 TO br-conta: */

    RUN pi-finalizar IN h-acomp.

    {&OPEN-QUERY-brExp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-all w-livre
ON CHOOSE OF bt-all IN FRAME f-cad
/* DO:                                                                                                                                    */
/*     FOR EACH tt-conta-aux                                                                                                              */
/*         WHERE tt-conta-aux.cod_cta_ctbl >= c_cod_cta_inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME}                                       */
/*         AND   tt-conta-aux.cod_cta_ctbl <= c_cod_cta_final:SCREEN-VALUE   IN FRAME {&FRAME-NAME}:                                      */
/*         ASSIGN tt-conta-aux.marca    = "*"                                                                                             */
/*                ccod_cta_auxiliar = tt-conta-aux.cod_cta_ctbl.                                                                          */
/*     END. /* FOR EACH tt-conta-aux */                                                                                                   */
/*                                                                                                                                        */
/*     OPEN QUERY br-conta FOR EACH tt-conta-aux WHERE tt-conta-aux.cod_cta_ctbl >= c_cod_cta_inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME} */
/*                                           AND   tt-conta-aux.cod_cta_ctbl <= c_cod_cta_final:SCREEN-VALUE   IN FRAME {&FRAME-NAME}.    */
/*                                                                                                                                        */
/* END.                                                                                                                                   */


DO:
    IF br-conta:NUM-ITERATIONS > 0 THEN br-conta:SELECT-ALL().
    APPLY "return" TO BROWSE br-conta.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-all-cc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-all-cc w-livre
ON CHOOSE OF bt-all-cc IN FRAME f-cad
DO:
    IF br-ccusto:NUM-ITERATIONS > 0 THEN br-ccusto:SELECT-ALL().
    APPLY "return" TO BROWSE br-ccusto.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del w-livre
ON CHOOSE OF bt-del IN FRAME f-cad
DO:
    DO  v_num_row_a = 1 to brExp:num-selected-rows IN FRAME {&FRAME-NAME}:
        IF  brExp:fetch-selected-row(v_num_row_a) IN FRAME {&FRAME-NAME} THEN DO:

            IF  AVAIL tt-plano-aux THEN DO:
                DELETE tt-plano-aux.
            END. /* IF  AVAIL tt-plano-aux THEN DO: */

        END.
    END.

    {&OPEN-QUERY-brExp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-gera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-gera w-livre
ON CHOOSE OF bt-gera IN FRAME f-cad
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} ccod-estabel-ini ccod-estabel-fim c_cod_ccusto_inicial c_cod_ccusto_final.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT 'Carregando ...').

    EMPTY TEMP-TABLE tt-ccusto-aux NO-ERROR.
    EMPTY TEMP-TABLE tt-ccusto     NO-ERROR.

    /* Carrega a tt-ccusto-aux com todos os CC*/
    FOR EACH  emscad.ccusto NO-LOCK
        WHERE emscad.ccusto.cod_empresa      = v_cod_empres_usuar
        AND   emscad.ccusto.cod_plano_ccusto = p_cod_plano_ccusto
        AND   emscad.ccusto.cod_ccusto      >= c_cod_ccusto_inicial
        AND   emscad.ccusto.cod_ccusto      <= c_cod_ccusto_final,
        EACH  cc_uni_estab NO-LOCK
        WHERE cc_uni_estab.cod_ccusto  = emscad.ccusto.cod_ccusto
        AND   cc_uni_estab.cod_estab  >= ccod-estabel-ini
        AND   cc_uni_estab.cod_estab  <= ccod-estabel-fim,
        EACH  emscad.ccusto_unid_negoc NO-LOCK
        WHERE emscad.ccusto_unid_negoc.cod_ccusto = cc_uni_estab.cod_ccusto:
        
        IF   emscad.ccusto.dat_inic_valid > TODAY
        OR   emscad.ccusto.dat_fim_valid  < TODAY THEN NEXT.

        IF  VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Centro Custo: " + string(emscad.ccusto.cod_ccusto)).
    
        IF  NOT CAN-FIND(FIRST tt-ccusto
                         WHERE tt-ccusto.cod_plano_ccusto = emscad.ccusto_unid_negoc.cod_plano_ccusto
                         AND   tt-ccusto.cod_ccusto       = emscad.ccusto.cod_ccusto
                         AND   tt-ccusto.des_ccusto       = emscad.ccusto.des_tit_ctbl
                         AND   tt-ccusto.cod_unid_negoc   = emscad.ccusto_unid_negoc.cod_unid_negoc
                         AND   tt-ccusto.cod_estab        = cc_uni_estab.cod_estab) THEN DO:
            CREATE tt-ccusto.
            ASSIGN tt-ccusto.cod_plano_ccusto = emscad.ccusto_unid_negoc.cod_plano_ccusto
                   tt-ccusto.cod_ccusto       = emscad.ccusto.cod_ccusto
                   tt-ccusto.des_ccusto       = emscad.ccusto.des_tit_ctbl
                   tt-ccusto.cod_unid_negoc   = emscad.ccusto_unid_negoc.cod_unid_negoc
                   tt-ccusto.cod_estab        = cc_uni_estab.cod_estab.
        END. /* IF  NOT CAN-FIND(FIRST tt-ccusto ... */
    END. /* FOR FIRST plano_ccusto */

    IF  CAN-FIND(FIRST tt-ccusto) THEN
    FOR EACH  tt-ccusto
        WHERE tt-ccusto.cod_ccusto >= c_cod_ccusto_inicial
        AND   tt-ccusto.cod_ccusto <= c_cod_ccusto_final:
/*         IF  NOT CAN-FIND(FIRST tt-ccusto-aux                                             */
/*                          WHERE tt-ccusto-aux.cod_ccusto = tt-ccusto.cod_ccusto) THEN DO: */
            CREATE tt-ccusto-aux.
            BUFFER-COPY tt-ccusto TO tt-ccusto-aux NO-ERROR.
/*         END. /* IF  NOT CAN-FIND(FIRST tt-ccusto-aux */  */
    END. /* FOR EACH tt-ccusto: */

    {&OPEN-QUERY-br-ccusto}

    RUN pi-finalizar IN h-acomp.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca w-livre
ON CHOOSE OF bt-marca IN FRAME f-cad
DO:
    APPLY "return" TO BROWSE br-conta.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca-cc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca-cc w-livre
ON CHOOSE OF bt-marca-cc IN FRAME f-cad
DO:
    APPLY "return" TO BROWSE br-ccusto.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum w-livre
ON CHOOSE OF bt-nenhum IN FRAME f-cad
DO:
    FOR EACH  tt-conta-aux
        WHERE tt-conta-aux.cod_cta_ctbl >= c_cod_cta_inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        AND   tt-conta-aux.cod_cta_ctbl <= c_cod_cta_final:SCREEN-VALUE   IN FRAME {&FRAME-NAME}:

        ASSIGN tt-conta-aux.marca = " ".

        FOR EACH tt-plano-aux WHERE tt-plano-aux.cod_cta_ctbl = tt-conta-aux.cod_cta_ctbl:
            DELETE tt-plano-aux.
        END. /* FOR EACH tt-plano-aux ... */

    END. /* FOR EACH  tt-conta-aux ... */

    {&OPEN-QUERY-brExp}

    OPEN QUERY br-conta FOR EACH  tt-conta-aux 
                            WHERE tt-conta-aux.cod_cta_ctbl >= c_cod_cta_inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                            AND   tt-conta-aux.cod_cta_ctbl <= c_cod_cta_final:SCREEN-VALUE   IN FRAME {&FRAME-NAME}
                            BY tt-conta-aux.cod_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum-cc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum-cc w-livre
ON CHOOSE OF bt-nenhum-cc IN FRAME f-cad
DO:
    FOR EACH  tt-ccusto-aux
        WHERE tt-ccusto-aux.cod_ccusto >= c_cod_ccusto_inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        AND   tt-ccusto-aux.cod_ccusto <= c_cod_ccusto_final:SCREEN-VALUE   IN FRAME {&FRAME-NAME}:

        ASSIGN tt-ccusto-aux.marca = " ".

        FOR EACH tt-plano-aux WHERE tt-plano-aux.cod_ccusto = tt-ccusto-aux.cod_ccusto:
            DELETE tt-plano-aux.
        END. /* FOR EACH tt-plano-aux ... */
        
        FOR EACH tt-conta-aux:
            DELETE tt-conta-aux.
        END. /* FOR EACH tt-conta-aux: */
    END. /* FOR EACH  tt-ccusto-aux ... */


    OPEN QUERY br-ccusto FOR EACH tt-ccusto-aux 
                            WHERE tt-ccusto-aux.cod_ccusto >= c_cod_ccusto_inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                            AND   tt-ccusto-aux.cod_ccusto <= c_cod_ccusto_final:SCREEN-VALUE   IN FRAME {&FRAME-NAME}
                            BY tt-ccusto-aux.cod_ccusto BY tt-ccusto-aux.cod_estab.

    {&OPEN-QUERY-br-conta}
    {&OPEN-QUERY-brExp}
    IF br-ccusto:NUM-SELECTED-ROWS > 0 THEN br-ccusto:DESELECT-ROWS().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-seleciona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-seleciona w-livre
ON CHOOSE OF bt-seleciona IN FRAME f-cad
DO:
    IF  CAN-FIND(FIRST tt-conta-aux) THEN DO:
        ASSIGN INPUT FRAME {&FRAME-NAME} c_cod_cta_inicial c_cod_cta_final.
    
        OPEN QUERY br-conta FOR EACH  tt-conta-aux
                                WHERE tt-conta-aux.cod_cta_ctbl >= c_cod_cta_inicial
                                AND   tt-conta-aux.cod_cta_ctbl <= c_cod_cta_final
                                BY    tt-conta-aux.cod_cta_ctbl.

    END. /* IF  CAN-FIND(FIRST tt-conta-aux) THEN DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCtaCtbl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCtaCtbl w-livre
ON CHOOSE OF btCtaCtbl IN FRAME f-cad
DO:
    DO  i-cont-aux = 1 TO br-ccusto:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF  br-ccusto:FETCH-SELECTED-ROW(i-cont-aux) IN FRAME {&FRAME-NAME} THEN DO:   
            
            IF  AVAIL tt-ccusto-aux
            AND tt-ccusto-aux.marca <> "" 
            THEN RUN piCarregaCta-nova(INPUT tt-ccusto-aux.cod_ccusto).

        END. /* IF  br-ccusto:FETCH-SELECTED-ROW... */
    END. /* DO  i-cont-aux = 1 TO ... */

    IF  CAN-FIND(FIRST tt-conta) THEN
    FOR EACH tt-conta:

        IF  NOT CAN-FIND(FIRST tt-conta-aux
                         WHERE tt-conta-aux.cod_cta_ctbl = tt-conta.cod_cta_ctbl) THEN DO:
            CREATE tt-conta-aux.
            BUFFER-COPY tt-conta TO tt-conta-aux NO-ERROR.
        END. /* IF  NOT CAN-FIND(FIRST tt-conta-aux */
    END. /* FOR EACH tt-conta: */

    {&OPEN-QUERY-br-conta}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelPlano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelPlano w-livre
ON CHOOSE OF btDelPlano IN FRAME f-cad
DO:
    RUN utp/ut-msgs.p (INPUT "show":U, 
                       INPUT 27100, 
                       INPUT "Confirma a eliminaá∆o?" + "~~" + 
                             "Ser† eliminado no OBC o relacionamento entre conta cont†bil e centro de custo(plano conta) conforme estes registros.").
    IF  RETURN-VALUE = "YES" THEN DO:
        
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        RUN pi-inicializar IN h-acomp (INPUT "Carregando ...").

        IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Exp Plano Contas...":U).
    
        EMPTY TEMP-TABLE ttRawTabela.
        EMPTY TEMP-TABLE tt-exp-plano.
    
        FOR EACH tt-plano-aux:
            IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Conta Cont†bil: ":U + TRIM(tt-plano-aux.cod_cta_ctbl) + " | " + TRIM(tt-plano-aux.cod_ccusto)).
    
            IF  NOT CAN-FIND(FIRST tt-exp-plano
                             WHERE tt-exp-plano.cod_plano_cta_ctbl = tt-plano-aux.cod_plano_cta_ctbl  
                             AND   tt-exp-plano.cod_cta_ctbl       = tt-plano-aux.cod_cta_ctbl        
                             AND   tt-exp-plano.cod_unid_negoc     = tt-plano-aux.cod_unid_negoc      
                             AND   tt-exp-plano.cod_ccusto         = tt-plano-aux.cod_ccusto          
                             AND   tt-exp-plano.cod_estab          = tt-plano-aux.cod_estab) THEN DO: 
                CREATE tt-exp-plano.
                ASSIGN tt-exp-plano.cod_plano_cta_ctbl = tt-plano-aux.cod_plano_cta_ctbl
                       tt-exp-plano.cod_cta_ctbl       = tt-plano-aux.cod_cta_ctbl
                       tt-exp-plano.cod_unid_negoc     = tt-plano-aux.cod_unid_negoc
                       tt-exp-plano.cod_ccusto         = tt-plano-aux.cod_ccusto
                       tt-exp-plano.cod_estab          = tt-plano-aux.cod_estab.
            END. /* IF  NOT CAN-FIND(FIRST tt-exp-plano */
        END. /* FOR EACH tt-plano-aux: */
    
        /*OUTPUT TO c:\temp\elimina-plano-essdcv005.txt NO-CONVERT.*/
        FOR EACH tt-exp-plano:
            IF  VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Cta.:" + string(tt-exp-plano.cod_cta_ctbl) + " UN: " + string(tt-exp-plano.cod_unid_negoc) + " CCusto: " + string(tt-exp-plano.cod_ccusto)).
    
            /*PUT UNFORMATTED
                tt-exp-plano.cod_plano_cta_ctbl ";"
                tt-exp-plano.cod_cta_ctbl       ";"
                tt-exp-plano.cod_unid_negoc     ";"
                tt-exp-plano.cod_ccusto         ";"
                tt-exp-plano.cod_estab          SKIP.*/
    
            CREATE ttRawTabela.
            RAW-TRANSFER tt-exp-plano TO ttRawTabela.rawTabela.
        END. /* FOR EACH tt-exp-plano: */
        /*OUTPUT CLOSE.*/
    
        IF  VALID-HANDLE(h-acomp) THEN do:
            RUN pi-seta-titulo IN h-acomp (INPUT "Enviando para API ...":U).
            RUN pi-acompanhar  IN h-acomp (INPUT "").
        END.

        ASSIGN gc-plano = "APAGA":U.
        
        RUN esp/sdcv/essdcv001api.p (INPUT  "plano-conta-conta-contabil":U,
                                     INPUT  "E",
                                     INPUT  TABLE ttRawTabela,
                                     OUTPUT TABLE RowErrors).
        
        ASSIGN gc-plano = "":U.
    
        IF  CAN-FIND(FIRST RowErrors) 
        THEN RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Plano Contas":U).
        ELSE DO:
            FOR EACH tt-plano-aux:
                FIND FIRST ext_plano_conta EXCLUSIVE-LOCK
                     WHERE ext_plano_conta.cod_plano_cta_ctbl = tt-plano-aux.cod_plano_cta_ctbl
                     AND   ext_plano_conta.cod_cta_ctbl       = tt-plano-aux.cod_cta_ctbl      
                     AND   ext_plano_conta.cod_estab          = tt-plano-aux.cod_estab         
                     AND   ext_plano_conta.cod_unid_negoc     = tt-plano-aux.cod_unid_negoc    
                     AND   ext_plano_conta.cod_plano_ccusto   = tt-plano-aux.cod_plano_ccusto  
                     AND   ext_plano_conta.cod_ccusto         = tt-plano-aux.cod_ccusto NO-ERROR.
                IF  AVAIL ext_plano_conta THEN DO:
                    DELETE ext_plano_conta.
                END. /* IF  AVAIL ext_plano_conta THEN ... */

                FOR EACH  int-integrado-obc EXCLUSIVE-LOCK
                    WHERE int-integrado-obc.cod-tabela = "PLANO_CONTA"
                    AND   trim(ENTRY(1, int-integrado-obc.chave-tabela, ";")) = tt-Plano-aux.cod_unid_negoc /* Unid.Neg.*/
                    AND   trim(ENTRY(2, int-integrado-obc.chave-tabela, ";")) = tt-Plano-aux.cod_ccusto     /* CCusto   */
                    AND   trim(ENTRY(3, int-integrado-obc.chave-tabela, ";")) = tt-Plano-aux.cod_estab      /* Estabel. */ 
                    AND   trim(ENTRY(4, int-integrado-obc.chave-tabela, ";")) = tt-Plano-aux.cod_cta_ctbl:  /* CtaCtbl. */ 
                    DELETE int-integrado-obc.
                END. /* FOR EACH int-integrado-obc EXCLUSIVE-LOCK */

            END. /* FOR EACH tt-plano-aux: */
        END. /* ELSE DO: */
    
        RUN pi-finalizar IN h-acomp.

        RUN piReinicia_Tela.

    END. /* IF  RETURN-VALUE = "YES" THEN DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExporta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExporta w-livre
ON CHOOSE OF btExporta IN FRAME f-cad
DO:
    ASSIGN c-file-log = session:TEMP-DIRECTORY + "essdcv005_" + TRIM(replace(STRING(TODAY) + STRING(TIME),"/","")) + ".csv"
           c-file-log = REPLACE(c-file-log, "\", "/").


    OUTPUT TO VALUE(c-file-log) NO-CONVERT.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT 'Exportando ...').

    ASSIGN INPUT FRAME {&FRAME-NAME} ccod-estabel-ini ccod-estabel-fim.

    /* Enviar os Centros de Custos envolvidos ... */
    RUN pi-exp-centro-custo (INPUT "I":U).  /* Passando pAcao que ser† usado na API */
    
    /* Enviar as Contas Cont†beis envolvidas ... */
    RUN pi-exp-conta-contabil (INPUT "I":U). /* Passando pAcao que ser† usado na API */
    
    /* Enviar os Planos de Contas envolvidos ... */
    RUN pi-exp-plano-contas.
    
    PUT UNFORMATTED 
        "Unid.Neg;Estab;Conta Cont†bil;T°tulo Cont†bil;Centro Custo;T°tulo Cont†bil" SKIP.
    FOR EACH tt-plano-aux:
        PUT UNFORMATTED 
            tt-plano-aux.cod_unid_negoc ";"
            tt-plano-aux.cod_estab ";"
            tt-plano-aux.cod_cta_ctbl ";"
            fnDescricao("conta":U, tt-plano-aux.cod_cta_ctbl) ";"
            tt-plano-aux.cod_ccusto ";"
            fnDescricao("ccusto":U, tt-plano-aux.cod_ccusto) SKIP.
    END.

    RUN pi-finalizar IN h-acomp.

    OUTPUT CLOSE.

    RUN utp/ut-msgs.p (INPUT "show":U, 
                       INPUT 15825,
                       INPUT "Arquivo de acompanhamento gerado." + "~~" +
                             "Foi gerado o arquivo " + c-file-log + " para conferància do que foi enviado ao OutbuyCenter(SDCV).").


    /* Reiniciando browses ... */
    RUN piReinicia_Tela.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btInativaCC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInativaCC w-livre
ON CHOOSE OF btInativaCC IN FRAME f-cad
DO:
    RUN utp/ut-msgs.p (INPUT "show":U, 
                       INPUT 27100, 
                       INPUT "Confirma a inativaá∆o?" + "~~" + 
                             "Ser∆o inativados todos estes centros de custos no OBC. Com isso, n∆o ser† poss°vel movimentar o mesmo nem as contas a ele relacionadas NO OBC.").
    IF  RETURN-VALUE = "YES" THEN DO:    

        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        RUN pi-inicializar IN h-acomp (INPUT "Carregando ...").

        IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Exp Centro Custo...":U).
    
        /* Somente os centros de custos marcados na tela */
        EMPTY TEMP-TABLE ttRawTabela.
        EMPTY TEMP-TABLE tt-exp-ccusto.
    
        FOR EACH tt-plano-aux:
            IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Centro Custo: ":U + TRIM(tt-plano-aux.cod_ccusto) + "     " + STRING(TIME, "HH:MM:SS")).
    
            IF NOT CAN-FIND(FIRST tt-exp-ccusto
                            WHERE tt-exp-ccusto.cod_plano_ccusto = tt-plano-aux.cod_plano_ccusto
                            and   tt-exp-ccusto.cod_unid_negoc   = tt-plano-aux.cod_unid_negoc  
                            and   tt-exp-ccusto.cod_ccusto       = tt-plano-aux.cod_ccusto      
                            and   tt-exp-ccusto.cod_estab        = tt-plano-aux.cod_estab) THEN DO:
    
                CREATE tt-exp-ccusto.
                ASSIGN tt-exp-ccusto.cod_plano_ccusto = tt-plano-aux.cod_plano_ccusto
                       tt-exp-ccusto.cod_unid_negoc   = tt-plano-aux.cod_unid_negoc
                       tt-exp-ccusto.cod_estab        = tt-plano-aux.cod_estab
                       tt-exp-ccusto.cod_ccusto       = tt-plano-aux.cod_ccusto
                       tt-exp-ccusto.des_ccusto       = fnDescricao("ccusto":U, tt-plano-aux.cod_ccusto).
            
            END. /* IF NOT CAN-FIND(FIRST tt-exp-ccusto */
        END. /* FOR EACH tt-plano-aux: */
        
        /*OUTPUT TO c:\temp\pi-inat-centro-custo-essdcv005.txt NO-CONVERT.*/
        FOR EACH tt-exp-ccusto:
            /*PUT UNFORMATTED
                tt-exp-ccusto.cod_plano_ccusto ";"
                tt-exp-ccusto.cod_unid_negoc ";"
                tt-exp-ccusto.cod_ccusto     ";"
                tt-exp-ccusto.des_ccusto     ";"
                tt-exp-ccusto.cod_estab      SKIP.*/
    
            CREATE ttRawTabela.
            RAW-TRANSFER tt-exp-ccusto TO ttRawTabela.rawTabela.
        END.
        /*OUTPUT CLOSE.*/
    
        ASSIGN gc-ccusto = "INATCC":U.

        RUN esp/sdcv/essdcv001api.p (INPUT  "centro-custo":U,
                                     INPUT  "A",
                                     INPUT  TABLE ttRawTabela,
                                     OUTPUT TABLE RowErrors).
        ASSIGN gc-ccusto = "":U.
    
        IF CAN-FIND(FIRST RowErrors) 
        THEN RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Centro Custo":U).
        ELSE DO:
            FOR EACH tt-exp-ccusto:
                FOR FIRST int-integrado-obc EXCLUSIVE-LOCK
                    WHERE int-integrado-obc.cod-tabela = "CENTRO_CUSTO":U
                    AND   trim(ENTRY(1, int-integrado-obc.chave-tabela, ";")) = tt-exp-ccusto.cod_unid_negoc /* Unid.Neg.*/
                    AND   trim(ENTRY(2, int-integrado-obc.chave-tabela, ";")) = tt-exp-ccusto.cod_ccusto     /* CCusto   */
                    AND   trim(ENTRY(3, int-integrado-obc.chave-tabela, ";")) = tt-exp-ccusto.cod_estab :    /* Estabel. */ 
                    ASSIGN int-integrado-obc.idi-situacao = 2. /* Inativo */
                END. /* FOR FIRST int-integrado-obc */
            END. /* FOR EACH tt-exp-ccusto: */
        END. /* ELSE DO: */
    
        RUN pi-finalizar IN h-acomp.

        RUN piReinicia_Tela.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-livre
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa w-livre
ON MENU-DROP OF MENU mi-programa /* Menu */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-livre
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-livre
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-ccusto
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.13 , 122.57 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             btExporta:HANDLE IN FRAME f-cad , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
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
  DISPLAY ccod-estabel-ini ccod-estabel-fim c_cod_ccusto_inicial 
          c_cod_ccusto_final c_cod_cta_inicial c_cod_cta_final 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE ccod-estabel-ini ccod-estabel-fim c_cod_ccusto_inicial 
         c_cod_ccusto_final bt-gera bt-marca-cc bt-all-cc bt-nenhum-cc 
         btCtaCtbl c_cod_cta_inicial c_cod_cta_final bt-seleciona bt-marca 
         bt-all bt-nenhum br-conta brExp btExporta btInativaCC btDelPlano 
         bt-del rt-button RECT-6 IMAGE-6 IMAGE-7 RECT-7 RECT-9 RECT-2 IMAGE-1 
         IMAGE-3 RECT-1 IMAGE-4 IMAGE-5 br-ccusto 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run pi-before-initialize.

  {include/win-size.i}

  {utp/ut9000.i "ESSDCV005" "2.06.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  run pi-after-initialize.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exp-centro-custo w-livre 
PROCEDURE pi-exp-centro-custo :
/*------------------------------------------------------------------------------
  Purpose:     Exportar as informaá‰es de centros de custo cadastrados no sistema.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pAcao-ccusto AS CHARACTER NO-UNDO.
    
    ASSIGN i-cont-exportado = 0.

    IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Exp Centro Custo...":U).

    /* Somente os centros de custos marcados na tela */
    EMPTY TEMP-TABLE ttRawTabela.
    EMPTY TEMP-TABLE tt-exp-ccusto.

    FOR EACH tt-plano-aux:
        IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Centro Custo: ":U + TRIM(tt-plano-aux.cod_ccusto) + "     " + STRING(TIME, "HH:MM:SS")).

        IF NOT CAN-FIND(FIRST tt-exp-ccusto
                        WHERE tt-exp-ccusto.cod_plano_ccusto = tt-plano-aux.cod_plano_ccusto
                        and   tt-exp-ccusto.cod_unid_negoc   = tt-plano-aux.cod_unid_negoc
                        and   tt-exp-ccusto.cod_ccusto       = tt-plano-aux.cod_ccusto
                        and   tt-exp-ccusto.cod_estab        = tt-plano-aux.cod_estab) THEN DO:

            CREATE tt-exp-ccusto.
            ASSIGN tt-exp-ccusto.cod_plano_ccusto = tt-plano-aux.cod_plano_ccusto
                   tt-exp-ccusto.cod_unid_negoc   = caps(tt-plano-aux.cod_unid_negoc)
                   tt-exp-ccusto.cod_estab        = tt-plano-aux.cod_estab.
                   tt-exp-ccusto.cod_ccusto       = tt-plano-aux.cod_ccusto.

            FIND FIRST emscad.ccusto NO-LOCK
                WHERE  emscad.ccusto.cod_plano_ccusto = tt-exp-ccusto.cod_plano_ccusto
                AND    emscad.ccusto.cod_ccusto       = tt-exp-ccusto.cod_ccusto NO-ERROR.
            IF  AVAIL  emscad.ccusto
            THEN ASSIGN tt-exp-ccusto.des_ccusto = emscad.ccusto.des_tit_ctbl.
            ELSE ASSIGN tt-exp-ccusto.des_ccusto = "".

        END. /* IF NOT CAN-FIND(FIRST tt-exp-ccusto */
    END. /* FOR EACH tt-plano-aux: */

    /*OUTPUT TO c:\temp\pi-exp-centro-custo.txt NO-CONVERT.*/
    FOR EACH tt-exp-ccusto:
        /*PUT UNFORMATTED
            tt-exp-ccusto.cod_plano_ccusto ";"
            tt-exp-ccusto.cod_unid_negoc ";"
            tt-exp-ccusto.cod_ccusto     ";"
            tt-exp-ccusto.des_ccusto     ";"
            tt-exp-ccusto.cod_estab      SKIP.*/

        CREATE ttRawTabela.
        RAW-TRANSFER tt-exp-ccusto TO ttRawTabela.rawTabela.
    END.
    /*OUTPUT CLOSE.*/

    RUN esp/sdcv/essdcv001api.p (INPUT  "centro-custo":U,
                                 INPUT  pAcao-ccusto,
                                 INPUT  TABLE ttRawTabela,
                                 OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors)
    THEN RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Centro Custo":U).

    RETURN "OK":U.

END PROCEDURE. /* PROCEDURE pi-exp-centro-custo */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exp-conta-contabil w-livre 
PROCEDURE pi-exp-conta-contabil :
/*------------------------------------------------------------------------------
  Purpose:     Exportar as informaá‰es de contas cont†beis cadastrados no sistema.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pAcao-ctactbl AS CHARACTER NO-UNDO.

    ASSIGN i-cont-exportado = 0.

    IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Exp Conta Cont†bil...":U).

    EMPTY TEMP-TABLE ttRawTabela.
    EMPTY TEMP-TABLE tt-exp-conta.

    FOR EACH tt-plano-aux:
        IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Conta Cont†bil: ":U + TRIM(tt-plano-aux.cod_cta_ctbl) + "     " + STRING(TIME, "HH:MM:SS")).

        IF  NOT CAN-FIND(FIRST tt-exp-conta
                         WHERE tt-exp-conta.cod_plano_cta_ctbl = tt-plano-aux.cod_plano_cta_ctbl
                         AND   tt-exp-conta.cod_cta_ctbl       = tt-plano-aux.cod_cta_ctbl) THEN DO:
            CREATE tt-exp-conta.
            ASSIGN tt-exp-conta.marca              = "*"
                   tt-exp-conta.cod_plano_cta_ctbl = tt-plano-aux.cod_plano_cta_ctbl
                   tt-exp-conta.cod_cta_ctbl       = tt-plano-aux.cod_cta_ctbl
                   tt-exp-conta.des_cta_ctbl       = fnDescricao("conta":U, tt-plano-aux.cod_cta_ctbl).
        END. /* IF  NOT CAN-FIND(FIRST tt-exp-conta */
    END. /* FOR EACH tt-plano-aux: */

    /*OUTPUT TO c:\temp\tt-exp-conta-essdcv005.txt NO-CONVERT.*/
    FOR EACH tt-exp-conta WHERE tt-exp-conta.marca = "*":
        IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Conta Cont†bil: ":U + TRIM(tt-exp-conta.cod_cta_ctbl) + "     " + STRING(TIME, "HH:MM:SS")).

        /*PUT UNFORMATTED
            tt-exp-conta.marca              ";"
            tt-exp-conta.cod_plano_cta_ctbl ";"
            tt-exp-conta.cod_cta_ctbl       ";"
            tt-exp-conta.des_cta_ctbl       SKIP.*/

        CREATE ttRawTabela.
        RAW-TRANSFER tt-exp-conta TO ttRawTabela.rawTabela.

    END. /* FOR EACH tt-exp-conta */

    /*OUTPUT CLOSE.*/

    RUN esp/sdcv/essdcv001api.p (INPUT  "conta-contab":U,
                                 INPUT  pAcao-ctactbl,
                                 INPUT  TABLE ttRawTabela,
                                 OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors)
    THEN RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Conta Cont†bil":U).

    RETURN "OK":U.

END PROCEDURE. /* PROCEDURE pi-exp-conta-contabil */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exp-plano-contas w-livre 
PROCEDURE pi-exp-plano-contas :
/*------------------------------------------------------------------------------
  Purpose:     Exportar as informaá‰es de planos de conta cadastrados no sistema.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    ASSIGN i-cont-exportado = 0.

    IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Exp Plano Contas...":U).

    EMPTY TEMP-TABLE ttRawTabela.
    EMPTY TEMP-TABLE tt-exp-plano.

    FOR EACH tt-plano-aux:
        IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Conta Cont†bil: ":U + TRIM(tt-plano-aux.cod_cta_ctbl) + " | " + TRIM(tt-plano-aux.cod_ccusto)).

        IF  NOT CAN-FIND(FIRST tt-exp-plano
                         WHERE tt-exp-plano.cod_plano_cta_ctbl = tt-plano-aux.cod_plano_cta_ctbl
                         AND   tt-exp-plano.cod_cta_ctbl       = tt-plano-aux.cod_cta_ctbl
                         AND   tt-exp-plano.cod_unid_negoc     = tt-plano-aux.cod_unid_negoc
                         AND   tt-exp-plano.cod_ccusto         = tt-plano-aux.cod_ccusto
                         AND   tt-exp-plano.cod_estab          = tt-plano-aux.cod_estab) THEN DO:
            CREATE tt-exp-plano.
            ASSIGN tt-exp-plano.cod_plano_cta_ctbl = tt-plano-aux.cod_plano_cta_ctbl
                   tt-exp-plano.cod_cta_ctbl       = tt-plano-aux.cod_cta_ctbl
                   tt-exp-plano.cod_unid_negoc     = caps(tt-plano-aux.cod_unid_negoc)
                   tt-exp-plano.cod_ccusto         = tt-plano-aux.cod_ccusto
                   tt-exp-plano.cod_estab          = tt-plano-aux.cod_estab.
        END. /* IF  NOT CAN-FIND(FIRST tt-exp-plano */
    END. /* FOR EACH tt-plano-aux: */

    FOR EACH tt-exp-plano:
        IF  VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Cta.:" + string(tt-exp-plano.cod_cta_ctbl) + " UN: " + string(tt-exp-plano.cod_unid_negoc) + " CCusto: " + string(tt-exp-plano.cod_ccusto)).
        CREATE ttRawTabela.
        RAW-TRANSFER tt-exp-plano TO ttRawTabela.rawTabela.
    END.

    IF  VALID-HANDLE(h-acomp) THEN do:
        RUN pi-seta-titulo IN h-acomp (INPUT "Enviando para API ...":U).
        RUN pi-acompanhar  IN h-acomp (INPUT "").
    END.

    /*OUTPUT TO c:\temp\teste-plano-essdcv005.txt NO-CONVERT.
    FOR EACH tt-exp-plano:
    PUT UNFORMATTED
        tt-exp-plano.cod_plano_cta_ctbl ";"
        tt-exp-plano.cod_cta_ctbl       ";"
        tt-exp-plano.cod_unid_negoc     ";"
        tt-exp-plano.cod_ccusto         ";"
        tt-exp-plano.cod_estab          SKIP.
    END.
    OUTPUT CLOSE.*/

    RUN esp/sdcv/essdcv001api.p (INPUT  "plano-conta-conta-contabil":U,
                                 INPUT  "I":U,
                                 INPUT  TABLE ttRawTabela,
                                 OUTPUT TABLE RowErrors).

    IF  CAN-FIND(FIRST RowErrors)
    THEN RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Plano Contas":U).
    
    RETURN "OK":U.

END PROCEDURE. /* PROCEDURE pi-exp-plano-contas */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta-plano w-livre 
PROCEDURE pi-monta-plano :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
/*     RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                                                        */
/*     RUN pi-inicializar IN h-acomp (INPUT "Buscando ...").                                             */
/*                                                                                                       */
/*     IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Montando plano conta ...":U). */
    
    ASSIGN INPUT FRAME {&FRAME-NAME} ccod-estabel-ini ccod-estabel-fim.
 
    ccusto_blk:
    FOR EACH tt-ccusto-aux WHERE tt-ccusto-aux.marca = "*":
        conta_blk:
        FOR EACH tt-conta-aux WHERE tt-conta-aux.marca = "*":
        
            RUN pi-acompanhar IN h-acomp (INPUT "Centro Custo: ":U + STRING(tt-ccusto-aux.cod_ccusto) + "Conta: ":U + STRING(tt-conta-aux.cod_cta_ctbl)).

            FIND FIRST criter_distrib_cta_ctbl NO-LOCK
                 WHERE criter_distrib_cta_ctbl.cod_plano_cta_ctbl = tt-conta-aux.cod_plano_cta_ctbl
                 AND   criter_distrib_cta_ctbl.cod_cta_ctbl       = tt-conta-aux.cod_cta_ctbl
                 AND   criter_distrib_cta_ctbl.cod_estab          = tt-ccusto-aux.cod_estab NO-ERROR.
            IF  AVAIL  criter_distrib_cta_ctbl THEN DO:
                IF  CAN-FIND(FIRST cc_uni_estab
                             WHERE cc_uni_estab.cod_ccusto     = tt-ccusto-aux.cod_ccusto
                             AND   cc_uni_estab.cod_unid_negoc = tt-ccusto-aux.cod_unid_negoc
                             AND   cc_uni_estab.cod_estab      = tt-ccusto-aux.cod_estab)  THEN DO:
                    CASE criter_distrib_cta_ctbl.ind_criter_distrib_ccusto: 
                        WHEN "Utiliza Todos":U THEN DO:
    
                            IF NOT CAN-FIND(FIRST tt-plano-aux
                                            WHERE tt-plano-aux.cod_plano_cta_ctbl = tt-conta-aux.cod_plano_cta_ctbl
                                            AND   tt-plano-aux.cod_cta_ctbl       = tt-conta-aux.cod_cta_ctbl      
                                            AND   tt-plano-aux.cod_unid_negoc     = tt-ccusto-aux.cod_unid_negoc   
                                            AND   tt-plano-aux.cod_plano_ccusto   = tt-ccusto-aux.cod_plano_ccusto 
                                            AND   tt-plano-aux.cod_ccusto         = tt-ccusto-aux.cod_ccusto       
                                            AND   tt-plano-aux.cod_estab          = tt-ccusto-aux.cod_estab) THEN DO:
                                CREATE tt-plano-aux.
                                ASSIGN tt-plano-aux.cod_plano_cta_ctbl = tt-conta-aux.cod_plano_cta_ctbl
                                       tt-plano-aux.cod_cta_ctbl       = tt-conta-aux.cod_cta_ctbl      
                                       tt-plano-aux.cod_unid_negoc     = tt-ccusto-aux.cod_unid_negoc
                                       tt-plano-aux.cod_plano_ccusto   = tt-ccusto-aux.cod_plano_ccusto
                                       tt-plano-aux.cod_ccusto         = tt-ccusto-aux.cod_ccusto
                                       tt-plano-aux.cod_estab          = tt-ccusto-aux.cod_estab.
                                
                            END. /* IF NOT can-find(FIRST tt-plano-aux */
                        END. /* WHEN "Utiliza Todos":U THEN DO: */
                        WHEN "Definidos":U THEN DO:
                            FIND FIRST item_lista_ccusto NO-LOCK
                                WHERE  item_lista_ccusto.cod_estab               = criter_distrib_cta_ctbl.cod_estab             
                                AND    item_lista_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
                                AND    item_lista_ccusto.cod_empresa             = v_cod_empres_usuar                             
                                AND    item_lista_ccusto.cod_plano_ccusto        = tt-ccusto-aux.cod_plano_ccusto
                                AND    item_lista_ccusto.cod_ccusto              = tt-ccusto-aux.cod_ccusto NO-ERROR.
                            IF  AVAIL  item_lista_ccusto THEN DO:
                                IF NOT CAN-FIND(FIRST tt-plano-aux
                                                WHERE tt-plano-aux.cod_plano_cta_ctbl = tt-conta-aux.cod_plano_cta_ctbl
                                                AND   tt-plano-aux.cod_cta_ctbl       = tt-conta-aux.cod_cta_ctbl      
                                                AND   tt-plano-aux.cod_unid_negoc     = tt-ccusto-aux.cod_unid_negoc   
                                                AND   tt-plano-aux.cod_plano_ccusto   = tt-ccusto-aux.cod_plano_ccusto 
                                                AND   tt-plano-aux.cod_ccusto         = tt-ccusto-aux.cod_ccusto       
                                                AND   tt-plano-aux.cod_estab          = tt-ccusto-aux.cod_estab) THEN DO:
                                    CREATE tt-plano-aux.
                                    ASSIGN tt-plano-aux.cod_plano_cta_ctbl = tt-conta-aux.cod_plano_cta_ctbl
                                           tt-plano-aux.cod_cta_ctbl       = tt-conta-aux.cod_cta_ctbl      
                                           tt-plano-aux.cod_unid_negoc     = tt-ccusto-aux.cod_unid_negoc   
                                           tt-plano-aux.cod_plano_ccusto   = tt-ccusto-aux.cod_plano_ccusto 
                                           tt-plano-aux.cod_ccusto         = tt-ccusto-aux.cod_ccusto       
                                           tt-plano-aux.cod_estab          = tt-ccusto-aux.cod_estab.       
                                END. /* IF NOT CAN-FIND(FIRST tt-plano-aux */
                            END. /* IF  AVAIL  item_lista_ccusto THEN DO: */
                        END. /* WHEN "Definidos":U THEN DO: */
                        OTHERWISE NEXT conta_blk.
                    END CASE. /* CASE criter_distrib_cta_ctbl.ind_criter_distrib_ccusto: */
                END. /* IF  CAN-FIND(FIRST cc_uni_estab */
            END. /* IF  AVAIL criter_distrib_cta_ctbl THEN DO: */
        END. /* FOR EACH */
    END. /* FOR EACH  tt-conta-aux NO-LOCK */
    
/*     RUN pi-finalizar IN h-acomp. */

    release criter_distrib_cta_ctbl.
    release item_lista_ccusto.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaCta-nova w-livre 
PROCEDURE piCarregaCta-nova :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pccusto LIKE emscad.ccusto.cod_ccusto NO-UNDO.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    IF  VALID-HANDLE(h-acomp) THEN RUN pi-inicializar IN h-acomp (INPUT "Buscando ...":U).

    ASSIGN INPUT FRAME {&FRAME-NAME} c_cod_cta_inicial c_cod_cta_final.

    FOR EACH  emscad.ccusto NO-LOCK
        WHERE emscad.ccusto.cod_ccusto = pccusto,
        EACH  ITEM_lista_ccusto NO-LOCK
        WHERE ITEM_lista_ccusto.cod_empresa = v_cod_empres_usuar
        AND   ITEM_lista_ccusto.cod_ccusto  = emscad.ccusto.cod_ccusto
        AND   ITEM_lista_ccusto.cod_estab  >= ccod-estabel-ini
        AND   ITEM_lista_ccusto.cod_estab  <= ccod-estabel-fim,
        EACH  criter_distrib_cta_ctbl NO-LOCK           
        WHERE criter_distrib_cta_ctbl.cod_empresa             = ITEM_lista_ccusto.cod_empresa
        AND   criter_distrib_cta_ctbl.cod_estab               = ITEM_lista_ccusto.cod_estab
        AND   criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto = item_lista_ccusto.cod_mapa_distrib_ccusto
        AND   criter_distrib_cta_ctbl.cod_cta_ctbl           >= c_cod_cta_inicial
        AND   criter_distrib_cta_ctbl.cod_cta_ctbl           <= c_cod_cta_final:
    
        RUN pi-acompanhar IN h-acomp (INPUT "Conta: " + STRING(criter_distrib_cta_ctbl.cod_cta_ctbl)).

        IF   criter_distrib_cta_ctbl.dat_inic_valid > TODAY
        OR   criter_distrib_cta_ctbl.dat_fim_valid  < TODAY THEN NEXT.
        
        CREATE tt-conta.
        ASSIGN tt-conta.cod_plano_cta_ctbl = criter_distrib_cta_ctbl.cod_plano_cta_ctbl
               tt-conta.cod_cta_ctbl       = criter_distrib_cta_ctbl.cod_cta_ctbl
               tt-conta.des_cta_ctbl       = fnDescricao("conta":U, tt-conta.cod_cta_ctbl).

    END. /* FOR EACH  emscad.ccusto NO-LOCK */

    IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piReinicia_Tela w-livre 
PROCEDURE piReinicia_Tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Reiniciando browses ... */
    EMPTY TEMP-TABLE tt-conta-aux NO-ERROR.
    EMPTY TEMP-TABLE tt-conta     NO-ERROR.
    {&OPEN-QUERY-br-conta}
    EMPTY TEMP-TABLE tt-ccusto-aux NO-ERROR.
    EMPTY TEMP-TABLE tt-ccusto     NO-ERROR.
    {&OPEN-QUERY-br-ccusto}
    EMPTY TEMP-TABLE tt-plano-aux NO-ERROR.
    {&OPEN-QUERY-brExp}

    /* Reiniciando fill-ins ... */
    ASSIGN c_cod_cta_inicial:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = "40000000":U
           c_cod_cta_final:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = "4ZZZZZZZ":U
           ccod-estabel-ini:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = "":U
           ccod-estabel-fim:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = "ZZZ":U
           c_cod_ccusto_inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U
           c_cod_ccusto_final:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = "ZZZZZ":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-plano-aux"}
  {src/adm/template/snd-list.i "tt-conta-aux"}
  {src/adm/template/snd-list.i "tt-ccusto-aux"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescricao w-livre 
FUNCTION fnDescricao RETURNS CHARACTER
  ( ccampo AS CHAR, ccod-linha AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    CASE ccampo:
        WHEN "conta":U THEN DO:
            FOR FIRST cta_ctbl NO-LOCK
                WHERE cta_ctbl.cod_cta_ctbl = ccod-linha:
                RETURN cta_ctbl.des_tit_ctbl.
            END.
        END.
        WHEN "ccusto":U THEN DO:
            FOR FIRST emscad.ccusto NO-LOCK
                WHERE emscad.ccusto.cod_ccusto = ccod-linha:
                RETURN emscad.ccusto.des_tit_ctbl.
            END.
        END.
        OTHERWISE RETURN "".
    END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

