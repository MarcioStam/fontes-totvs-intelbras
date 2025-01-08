&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESSDCV007 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{upc/btb910za-upc.i}

/* Parameters Definitions ---                                           */

/* Global Variable Definitions ---                                      */
DEFINE NEW GLOBAL SHARED VARIABLE gc-plano  AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gc-ccusto AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-acomp      AS   HANDLE                    NO-UNDO.
DEFINE VARIABLE cdesc-ccusto LIKE emscad.ccusto.des_tit_ctbl  NO-UNDO.
DEFINE VARIABLE cdesc-conta  LIKE cta_ctbl.des_tit_ctbl     NO-UNDO.
DEFINE VARIABLE cdesc-UN     LIKE unid_negoc.des_unid_negoc NO-UNDO.
DEFINE VARIABLE v_num_row_a  AS   INTEGER                   NO-UNDO.
DEFINE VARIABLE c-file-log   AS   CHARACTER FORMAT 'x(100)' NO-UNDO.

/* Temp Table Definitions ---                                           */
DEFINE TEMP-TABLE ttconta NO-UNDO LIKE criter_distrib_cta_ctbl
    FIELD marca AS CHAR.

DEFINE TEMP-TABLE ttccusto NO-UNDO LIKE emscad.ccusto
    FIELD marca AS CHAR.

DEFINE TEMP-TABLE ttplano-aux NO-UNDO LIKE ext_plano_conta.

DEFINE TEMP-TABLE ttunid-negoc NO-UNDO LIKE cc_uni_estab
    FIELD marca AS CHAR.

/*---[ Utilizdas na integra‡Æo com o OBC ]---------------------------------------------------------*/
DEFINE TEMP-TABLE tt-exp-conta NO-UNDO
    FIELD marca              AS   CHAR FORMAT "x(01)"
    FIELD cod_plano_cta_ctbl LIKE plano_cta_ctbl.cod_plano_cta_ctbl
    FIELD cod_cta_ctbl       LIKE cta_ctbl.cod_cta_ctbl
    FIELD des_cta_ctbl       LIKE cta_ctbl.des_tit_ctbl .

DEFINE TEMP-TABLE tt-exp-ccusto NO-UNDO
    FIELD cod_plano_ccusto   LIKE plano_ccusto.cod_plano_ccusto 
    FIELD cod_unid_negoc     LIKE cc_uni_estab.cod_unid_negoc
    FIELD cod_ccusto         LIKE emscad.ccusto.cod_ccusto
    FIELD des_ccusto         LIKE emscad.ccusto.des_tit_ctbl
    FIELD cod_estab          LIKE cc_uni_estab.cod_estab
    INDEX ch-id IS UNIQUE cod_plano_ccusto cod_unid_negoc cod_ccusto cod_estab.

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

/* Defini‡Æo da temp-table ttRawTabela */
{esp/sdcv/essdcv001api.i}

/* Defini‡Æo das procedure internas pi-cria-mensagem e
   pi-cria-mensagem-pela-RowErrors */
{esp/sdcv/essdcv003rp.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME brCriterioCta

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttconta ttplano-aux ttunid-negoc

/* Definitions for BROWSE brCriterioCta                                 */
&Scoped-define FIELDS-IN-QUERY-brCriterioCta ttconta.marca NO-LABEL ttconta.cod_estab ttconta.cod_cta_ctbl fnDescricao("conta":U, ttconta.cod_cta_ctbl) @ cdesc-conta   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brCriterioCta   
&Scoped-define SELF-NAME brCriterioCta
&Scoped-define QUERY-STRING-brCriterioCta FOR EACH ttconta BY ttconta.cod_cta_ctbl
&Scoped-define OPEN-QUERY-brCriterioCta OPEN QUERY {&SELF-NAME} FOR EACH ttconta BY ttconta.cod_cta_ctbl.
&Scoped-define TABLES-IN-QUERY-brCriterioCta ttconta
&Scoped-define FIRST-TABLE-IN-QUERY-brCriterioCta ttconta


/* Definitions for BROWSE brPlanoCta                                    */
&Scoped-define FIELDS-IN-QUERY-brPlanoCta caps(ttplano-aux.cod_unid_negoc) ttplano-aux.cod_ccusto fnDescricao("ccusto":U, ttplano-aux.cod_ccusto) @ cdesc-ccusto ttplano-aux.cod_estab ttplano-aux.cod_cta_ctbl fnDescricao("conta":U, ttplano-aux.cod_cta_ctbl) @ cdesc-conta   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPlanoCta   
&Scoped-define SELF-NAME brPlanoCta
&Scoped-define QUERY-STRING-brPlanoCta FOR EACH ttplano-aux BY ttplano-aux.cod_ccusto
&Scoped-define OPEN-QUERY-brPlanoCta OPEN QUERY {&SELF-NAME} FOR EACH ttplano-aux BY ttplano-aux.cod_ccusto.
&Scoped-define TABLES-IN-QUERY-brPlanoCta ttplano-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brPlanoCta ttplano-aux


/* Definitions for BROWSE brUN                                          */
&Scoped-define FIELDS-IN-QUERY-brUN ttunid-negoc.marca NO-LABEL ttunid-negoc.cod_estab ttunid-negoc.cod_ccusto CAPS(ttunid-negoc.cod_unid_negoc) fnDescUN(ttunid-negoc.cod_unid_negoc) @ cdesc-UN   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brUN   
&Scoped-define SELF-NAME brUN
&Scoped-define QUERY-STRING-brUN FOR EACH ttunid-negoc BY ttunid-negoc.cod_ccusto                                               BY ttunid-negoc.cod_unid_negoc
&Scoped-define OPEN-QUERY-brUN OPEN QUERY {&SELF-NAME} FOR EACH ttunid-negoc BY ttunid-negoc.cod_ccusto                                               BY ttunid-negoc.cod_unid_negoc.
&Scoped-define TABLES-IN-QUERY-brUN ttunid-negoc
&Scoped-define FIRST-TABLE-IN-QUERY-brUN ttunid-negoc


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-brCriterioCta}~
    ~{&OPEN-QUERY-brPlanoCta}~
    ~{&OPEN-QUERY-brUN}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ccod-estabel-ini ccod-estabel-fim ~
c_cod_cta_inicial c_cod_cta_final bt-seleciona bt-marca-cta bt-all-cta ~
bt-nenhum-cta c_UN_ini c_UN_fim c_cod_ccusto_ini-2 c_cod_ccusto_fim-2 ~
bt-seleciona-4 bt-marca-un bt-all-un bt-nenhum-un bt-add bt-del btExporta ~
btInativaCC btDelPlano brCriterioCta brUN brPlanoCta rt-button IMAGE-6 ~
IMAGE-7 IMAGE-1 IMAGE-3 RECT-10 IMAGE-12 IMAGE-13 RECT-15 RECT-6 RECT-7 ~
RECT-9 RECT-13 IMAGE-14 IMAGE-15 
&Scoped-Define DISPLAYED-OBJECTS ccod-estabel-ini ccod-estabel-fim ~
c_cod_cta_inicial c_cod_cta_final c_UN_ini c_UN_fim c_cod_ccusto_ini-2 ~
c_cod_ccusto_fim-2 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescUN w-livre 
FUNCTION fnDescUN RETURNS CHARACTER
  ( cCodUN AS CHAR )  FORWARD.

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
DEFINE BUTTON bt-add 
     IMAGE-UP FILE "image/toolbar/im-com.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-com.bmp":U
     LABEL "" 
     SIZE 10 BY 1.38 TOOLTIP "&Monta Plano".

DEFINE BUTTON bt-all-cta 
     IMAGE-UP FILE "image/im-todos.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "Todas".

DEFINE BUTTON bt-all-un 
     IMAGE-UP FILE "image/im-todos.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "Todas".

DEFINE BUTTON bt-del 
     IMAGE-UP FILE "image/toolbar/im-era.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-era.bmp":U
     LABEL "" 
     SIZE 10 BY 1.38 TOOLTIP "&Elimina registro".

DEFINE BUTTON bt-marca-cta 
     IMAGE-UP FILE "image/im-toggle.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-toggle.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "Marca/Desmarca".

DEFINE BUTTON bt-marca-un 
     IMAGE-UP FILE "image/im-toggle.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-toggle.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "Marca/Desmarca".

DEFINE BUTTON bt-nenhum-cta 
     IMAGE-UP FILE "image/im-nenhum.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "Nenhuma".

DEFINE BUTTON bt-nenhum-un 
     IMAGE-UP FILE "image/im-nenhum.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "Nenhuma".

DEFINE BUTTON bt-seleciona 
     IMAGE-UP FILE "image/toolbar/im-enter.bmp":U
     LABEL "" 
     SIZE 5 BY 2.04.

DEFINE BUTTON bt-seleciona-4 
     IMAGE-UP FILE "image/toolbar/im-enter.bmp":U
     LABEL "" 
     SIZE 5 BY 2.04.

DEFINE BUTTON btDelPlano 
     IMAGE-UP FILE "image/toolbar/im-cance.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-cance.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "&Exclui Plano OBC".

DEFINE BUTTON btExporta 
     IMAGE-UP FILE "image/toolbar/im-exp.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-exp.bmp":U
     LABEL "" 
     SIZE 5 BY 1.25 TOOLTIP "Exporta SDCV".

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

DEFINE VARIABLE c_cod_ccusto_fim-2 AS CHARACTER FORMAT "X(5)" INITIAL "2ZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c_cod_ccusto_ini-2 AS CHARACTER FORMAT "X(5)" INITIAL "10000" 
     LABEL "CCusto" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c_cod_cta_final AS CHARACTER FORMAT "X(8)" INITIAL "2ZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c_cod_cta_inicial AS CHARACTER FORMAT "X(8)" INITIAL "10000000" 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c_UN_fim AS CHARACTER FORMAT "X(5)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c_UN_ini AS CHARACTER FORMAT "X(5)" 
     LABEL "UN" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58.43 BY 2.25.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 6 BY 7.29
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58.14 BY 2.25.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 6 BY 13.25
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 129.43 BY 1.67
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 6 BY 13.25
     BGCOLOR 7 .

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 129.43 BY 1.46
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brCriterioCta FOR 
      ttconta SCROLLING.

DEFINE QUERY brPlanoCta FOR 
      ttplano-aux SCROLLING.

DEFINE QUERY brUN FOR 
      ttunid-negoc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brCriterioCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brCriterioCta w-livre _FREEFORM
  QUERY brCriterioCta DISPLAY
      ttconta.marca NO-LABEL WIDTH 1
      ttconta.cod_estab
    ttconta.cod_cta_ctbl
    fnDescricao("conta":U, ttconta.cod_cta_ctbl) @ cdesc-conta COLUMN-LABEL "Descri‡Æo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 58.43 BY 10.83
         FONT 1
         TITLE "Contas Especiais [ Crit‚rio: ~"NÆo Utiliza~" ]" FIT-LAST-COLUMN.

DEFINE BROWSE brPlanoCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPlanoCta w-livre _FREEFORM
  QUERY brPlanoCta DISPLAY
      caps(ttplano-aux.cod_unid_negoc)
        ttplano-aux.cod_ccusto
        fnDescricao("ccusto":U, ttplano-aux.cod_ccusto) @ cdesc-ccusto
        ttplano-aux.cod_estab
        ttplano-aux.cod_cta_ctbl
        fnDescricao("conta":U, ttplano-aux.cod_cta_ctbl) @ cdesc-conta
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 123 BY 7.29
         FONT 1
         TITLE "Plano Contas (OBC)" FIT-LAST-COLUMN.

DEFINE BROWSE brUN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brUN w-livre _FREEFORM
  QUERY brUN DISPLAY
      ttunid-negoc.marca NO-LABEL WIDTH 1
      ttunid-negoc.cod_estab
      ttunid-negoc.cod_ccusto
      CAPS(ttunid-negoc.cod_unid_negoc)
      fnDescUN(ttunid-negoc.cod_unid_negoc) @ cdesc-UN COLUMN-LABEL "Descri‡Æo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 58.14 BY 10.83
         FONT 1
         TITLE "Unid.Neg. x Estabel. x CCusto" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     ccod-estabel-ini AT ROW 13.67 COL 27.29 COLON-ALIGNED HELP
          "Estabelecimento" WIDGET-ID 46
     ccod-estabel-fim AT ROW 13.67 COL 41.57 COLON-ALIGNED HELP
          "Estabelecimento" NO-LABEL WIDGET-ID 48
     c_cod_cta_inicial AT ROW 14.67 COL 35.29 RIGHT-ALIGNED HELP
          "Conta" WIDGET-ID 108
     c_cod_cta_final AT ROW 14.67 COL 41.57 COLON-ALIGNED HELP
          "Conta" NO-LABEL WIDGET-ID 106
     bt-seleciona AT ROW 13.58 COL 54 WIDGET-ID 104
     bt-marca-cta AT ROW 2.63 COL 60.29 WIDGET-ID 24
     bt-all-cta AT ROW 4 COL 60.29 WIDGET-ID 22
     bt-nenhum-cta AT ROW 5.38 COL 60.29 WIDGET-ID 26
     c_UN_ini AT ROW 13.67 COL 103.29 RIGHT-ALIGNED HELP
          "Unidade de Neg¢cio" WIDGET-ID 194
     c_UN_fim AT ROW 13.67 COL 109.57 COLON-ALIGNED HELP
          "Unidade de Neg¢cio" NO-LABEL WIDGET-ID 192
     c_cod_ccusto_ini-2 AT ROW 14.67 COL 103.29 RIGHT-ALIGNED HELP
          "Centro Custo" WIDGET-ID 164
     c_cod_ccusto_fim-2 AT ROW 14.67 COL 109.57 COLON-ALIGNED HELP
          "Centro Custo" NO-LABEL WIDGET-ID 162
     bt-seleciona-4 AT ROW 13.58 COL 118.86 WIDGET-ID 160
     bt-marca-un AT ROW 2.63 COL 125 WIDGET-ID 186
     bt-all-un AT ROW 4 COL 125 WIDGET-ID 184
     bt-nenhum-un AT ROW 5.38 COL 125 WIDGET-ID 188
     bt-add AT ROW 16 COL 58.86 WIDGET-ID 134
     bt-del AT ROW 16 COL 69.29 WIDGET-ID 136
     btExporta AT ROW 20.54 COL 125 WIDGET-ID 154
     btInativaCC AT ROW 22 COL 125 WIDGET-ID 156
     btDelPlano AT ROW 23.46 COL 125 WIDGET-ID 158
     brCriterioCta AT ROW 2.5 COL 1 WIDGET-ID 200
     brUN AT ROW 2.5 COL 66 WIDGET-ID 500
     brPlanoCta AT ROW 17.58 COL 1 WIDGET-ID 400
     rt-button AT ROW 1 COL 1
     IMAGE-6 AT ROW 13.67 COL 36.72 WIDGET-ID 42
     IMAGE-7 AT ROW 13.67 COL 40.57 WIDGET-ID 44
     IMAGE-1 AT ROW 14.67 COL 36.72 WIDGET-ID 110
     IMAGE-3 AT ROW 14.67 COL 40.57 WIDGET-ID 112
     RECT-10 AT ROW 13.5 COL 1 WIDGET-ID 114
     IMAGE-12 AT ROW 14.67 COL 104.72 WIDGET-ID 166
     IMAGE-13 AT ROW 14.67 COL 108.57 WIDGET-ID 168
     RECT-15 AT ROW 13.5 COL 66 WIDGET-ID 170
     RECT-6 AT ROW 2.5 COL 59.72 WIDGET-ID 28
     RECT-7 AT ROW 15.83 COL 1 WIDGET-ID 172
     RECT-9 AT ROW 2.5 COL 124.43 WIDGET-ID 182
     RECT-13 AT ROW 17.58 COL 124.43 WIDGET-ID 190
     IMAGE-14 AT ROW 13.67 COL 104.72 WIDGET-ID 196
     IMAGE-15 AT ROW 13.67 COL 108.57 WIDGET-ID 198
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 129.72 BY 24
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "ESSDCV007"
         HEIGHT             = 24
         WIDTH              = 130
         MAX-HEIGHT         = 26.33
         MAX-WIDTH          = 172
         VIRTUAL-HEIGHT     = 26.33
         VIRTUAL-WIDTH      = 172
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
/* BROWSE-TAB brCriterioCta btDelPlano f-cad */
/* BROWSE-TAB brUN brCriterioCta f-cad */
/* BROWSE-TAB brPlanoCta brUN f-cad */
/* SETTINGS FOR FILL-IN c_cod_ccusto_ini-2 IN FRAME f-cad
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c_cod_cta_inicial IN FRAME f-cad
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c_UN_ini IN FRAME f-cad
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brCriterioCta
/* Query rebuild information for BROWSE brCriterioCta
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttconta BY ttconta.cod_cta_ctbl.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brCriterioCta */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPlanoCta
/* Query rebuild information for BROWSE brPlanoCta
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttplano-aux BY ttplano-aux.cod_ccusto.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brPlanoCta */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brUN
/* Query rebuild information for BROWSE brUN
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttunid-negoc BY ttunid-negoc.cod_ccusto
                                              BY ttunid-negoc.cod_unid_negoc.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brUN */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* ESSDCV007 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* ESSDCV007 */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brCriterioCta
&Scoped-define SELF-NAME brCriterioCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brCriterioCta w-livre
ON MOUSE-SELECT-DBLCLICK OF brCriterioCta IN FRAME f-cad /* Contas Especiais [ Crit‚rio: "NÆo Utiliza" ] */
DO:
    DO  v_num_row_a = 1 TO brCriterioCta:num-selected-rows IN FRAME {&FRAME-NAME}:
        if  brCriterioCta:fetch-selected-row(v_num_row_a) IN FRAME {&FRAME-NAME} then do:       

            IF  AVAIL ttconta THEN DO:
                IF  ttconta.marca = "*" THEN DO:
                    ASSIGN ttconta.marca = "".
                END.
                ELSE DO:
                    ASSIGN ttconta.marca = "*".
                END.
                
                self:refresh().
            END. /* IF  AVAIL ttconta THEN DO: */
        END. /* if  brCriterioCta:fetch-selected-row(v_num_row_a) ... */
    END. /* do  v_num_row_a = 1 to browse brCriterioCta:num-selected-rows: ... */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brUN
&Scoped-define SELF-NAME brUN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brUN w-livre
ON MOUSE-SELECT-DBLCLICK OF brUN IN FRAME f-cad /* Unid.Neg. x Estabel. x CCusto */
DO:
    DO  v_num_row_a = 1 to brUN:num-selected-rows IN FRAME {&FRAME-NAME}:
        if  brUN:fetch-selected-row(v_num_row_a) IN FRAME {&FRAME-NAME} then do:

            IF  AVAIL ttunid-negoc THEN DO:
                IF  ttunid-negoc.marca = "*" THEN DO:
                    ASSIGN ttunid-negoc.marca = "".
                END.
                ELSE DO:
                    ASSIGN ttunid-negoc.marca = "*".
                END.
                
                self:refresh().
            END. /* IF  AVAIL ttunid-negoc THEN DO: */
        END. /* if  brUN:fetch-selected-row(v_num_row_a) then do: */
    END. /* do  v_num_row_a = 1 to browse brUN:num-selected-rows: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add w-livre
ON CHOOSE OF bt-add IN FRAME f-cad
DO:
    FOR EACH ttconta WHERE ttconta.marca = "*":

        FOR EACH  ttunid-negoc 
            WHERE ttunid-negoc.marca = "*"
            AND   ttunid-negoc.cod_estab = ttconta.cod_estab:

            IF  NOT CAN-FIND(FIRST ttplano-aux
                             WHERE ttplano-aux.cod_plano_cta_ctbl = ttconta.cod_plano_cta_ctbl
                             AND   ttplano-aux.cod_cta_ctbl       = ttconta.cod_cta_ctbl
                             AND   ttplano-aux.cod_estab          = ttconta.cod_estab
                             AND   ttplano-aux.cod_unid_negoc     = ttunid-negoc.cod_unid_negoc
                             AND   ttplano-aux.cod_plano_ccusto   = p_cod_plano_ccusto
                             AND   ttplano-aux.cod_ccusto         = ttunid-negoc.cod_ccusto) THEN DO:
                CREATE ttplano-aux.
                ASSIGN ttplano-aux.cod_plano_cta_ctbl = ttconta.cod_plano_cta_ctbl 
                       ttplano-aux.cod_cta_ctbl       = ttconta.cod_cta_ctbl       
                       ttplano-aux.cod_estab          = ttconta.cod_estab          
                       ttplano-aux.cod_unid_negoc     = ttunid-negoc.cod_unid_negoc
                       ttplano-aux.cod_plano_ccusto   = p_cod_plano_ccusto  
                       ttplano-aux.cod_ccusto         = ttunid-negoc.cod_ccusto.

/*                 MESSAGE 'ttplano-aux.cod_plano_cta_ctbl ' ttplano-aux.cod_plano_cta_ctbl skip                               */
/*                         'ttplano-aux.cod_cta_ctbl       ' ttplano-aux.cod_cta_ctbl       skip                               */
/*                         'ttplano-aux.cod_estab          ' ttplano-aux.cod_estab          skip                               */
/*                         'ttplano-aux.cod_unid_negoc     ' ttplano-aux.cod_unid_negoc     skip                               */
/*                         'ttplano-aux.cod_plano_ccusto   ' ttplano-aux.cod_plano_ccusto   skip                               */
/*                         'ttplano-aux.cod_ccusto         ' ttplano-aux.cod_ccusto         VIEW-AS ALERT-BOX INFO BUTTONS OK. */
            END. /* IF  NOT CAN-FIND(FIRST ttplano-aux */
        END. /* FOR EACH ttccusto WHERE ttccusto.marca = "*": */
    END. /* FOR EACH ttconta WHERE ttconta.marca = "*": */

    IF  CAN-FIND(FIRST ttplano-aux) THEN DO:
        {&OPEN-QUERY-brPlanoCta}
    END. /* IF  CAN-FIND(FIRST ttplano-aux) THEN DO: */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-all-cta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-all-cta w-livre
ON CHOOSE OF bt-all-cta IN FRAME f-cad
DO:
    IF brCriterioCta:NUM-ITERATIONS > 0 THEN brCriterioCta:SELECT-ALL().
    APPLY "MOUSE-SELECT-DBLCLICK":U TO BROWSE brCriterioCta.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-all-un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-all-un w-livre
ON CHOOSE OF bt-all-un IN FRAME f-cad
DO:
    IF brUN:NUM-ITERATIONS > 0 THEN brUN:SELECT-ALL().
    APPLY "MOUSE-SELECT-DBLCLICK":U TO BROWSE brUN.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del w-livre
ON CHOOSE OF bt-del IN FRAME f-cad
DO:
    DO  v_num_row_a = 1 to brPlanoCta:num-selected-rows IN FRAME {&FRAME-NAME}:
        IF  brPlanoCta:fetch-selected-row(v_num_row_a) IN FRAME {&FRAME-NAME} THEN DO:

            IF  AVAIL ttplano-aux THEN DO:
                DELETE ttplano-aux.
            END. /* IF  AVAIL ttplano-aux THEN DO: */

        END. /* if  brPlanoCta:fetch-selected-row(v_num_row_a) then do: */
    END. /* do  v_num_row_a = 1 to browse brPlanoCta:num-selected-rows: */

    {&OPEN-QUERY-brPlanoCta}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca-cta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca-cta w-livre
ON CHOOSE OF bt-marca-cta IN FRAME f-cad
DO:
    APPLY "MOUSE-SELECT-DBLCLICK":U TO BROWSE brCriterioCta.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca-un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca-un w-livre
ON CHOOSE OF bt-marca-un IN FRAME f-cad
DO:
    APPLY "MOUSE-SELECT-DBLCLICK":U TO BROWSE brUN.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum-cta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum-cta w-livre
ON CHOOSE OF bt-nenhum-cta IN FRAME f-cad
DO:
    FOR EACH  ttconta:
        ASSIGN ttconta.marca = " ".
    END. /* FOR EACH ttconta */

    {&OPEN-QUERY-brCriterioCta}
    
    IF brCriterioCta:NUM-SELECTED-ROWS > 0 THEN brCriterioCta:DESELECT-ROWS().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum-un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum-un w-livre
ON CHOOSE OF bt-nenhum-un IN FRAME f-cad
DO:
    FOR EACH  ttunid-negoc:
        ASSIGN ttunid-negoc.marca = " ".
    END. /* FOR EACH ttunid-negoc */

    {&OPEN-QUERY-brUN}
    
    IF brUN:NUM-SELECTED-ROWS > 0 THEN brUN:DESELECT-ROWS().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-seleciona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-seleciona w-livre
ON CHOOSE OF bt-seleciona IN FRAME f-cad
DO:
    IF  CAN-FIND(FIRST ttconta) THEN DO:
        ASSIGN INPUT FRAME {&FRAME-NAME} ccod-estabel-ini ccod-estabel-fim c_cod_cta_inicial c_cod_cta_final.
    
        OPEN QUERY brCriterioCta FOR EACH ttconta
                                    WHERE ttconta.cod_cta_ctbl >= c_cod_cta_inicial
                                    AND   ttconta.cod_cta_ctbl <= c_cod_cta_final
                                    AND   ttconta.cod_estab    >= ccod-estabel-ini
                                    AND   ttconta.cod_estab    <= ccod-estabel-fim
                                    BY    ttconta.cod_cta_ctbl.

    END. /* IF  CAN-FIND(FIRST ttconta) THEN DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-seleciona-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-seleciona-4 w-livre
ON CHOOSE OF bt-seleciona-4 IN FRAME f-cad
DO:
    IF  CAN-FIND(FIRST ttUnid-negoc) THEN DO:
        ASSIGN INPUT FRAME {&FRAME-NAME} c_cod_ccusto_fim-2 c_cod_ccusto_ini-2 c_UN_fim c_UN_ini.
    
        OPEN QUERY brUN FOR EACH ttUnid-negoc
                           WHERE ttUnid-negoc.cod_unid_negoc >= c_UN_ini 
                           AND   ttUnid-negoc.cod_unid_negoc <= c_UN_fim 
                           AND   ttUnid-negoc.cod_ccusto     >= c_cod_ccusto_ini-2 
                           AND   ttUnid-negoc.cod_ccusto     <= c_cod_ccusto_fim-2
                           BY    ttunid-negoc.cod_ccusto
                           BY    ttunid-negoc.cod_unid_negoc.

    END. /* IF  CAN-FIND(FIRST ttUnid-negoc) THEN DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelPlano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelPlano w-livre
ON CHOOSE OF btDelPlano IN FRAME f-cad
DO:
    RUN utp/ut-msgs.p (INPUT "show":U, 
                       INPUT 27100, 
                       INPUT "Confirma a elimina‡Æo?" + "~~" + 
                             "Ser  eliminado no OBC o relacionamento entre conta cont bil e centro de custo(plano conta) conforme estes registros.").
    IF  RETURN-VALUE = "YES" THEN DO:
        
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        RUN pi-inicializar IN h-acomp (INPUT "Carregando ...").

        IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Exp Plano Contas...":U).
    
        EMPTY TEMP-TABLE ttRawTabela.
        EMPTY TEMP-TABLE tt-exp-plano.
    
        FOR EACH ttplano-aux:
            IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Conta Cont bil: ":U + TRIM(ttplano-aux.cod_cta_ctbl) + " | " + TRIM(ttplano-aux.cod_ccusto)).
    
            IF  NOT CAN-FIND(FIRST tt-exp-plano
                             WHERE tt-exp-plano.cod_plano_cta_ctbl = ttplano-aux.cod_plano_cta_ctbl  
                             AND   tt-exp-plano.cod_cta_ctbl       = ttplano-aux.cod_cta_ctbl        
                             AND   tt-exp-plano.cod_unid_negoc     = ttplano-aux.cod_unid_negoc      
                             AND   tt-exp-plano.cod_ccusto         = ttplano-aux.cod_ccusto          
                             AND   tt-exp-plano.cod_estab          = ttplano-aux.cod_estab) THEN DO: 
                CREATE tt-exp-plano.
                ASSIGN tt-exp-plano.cod_plano_cta_ctbl = ttplano-aux.cod_plano_cta_ctbl
                       tt-exp-plano.cod_cta_ctbl       = ttplano-aux.cod_cta_ctbl
                       tt-exp-plano.cod_unid_negoc     = caps(ttplano-aux.cod_unid_negoc)
                       tt-exp-plano.cod_ccusto         = ttplano-aux.cod_ccusto
                       tt-exp-plano.cod_estab          = ttplano-aux.cod_estab.
            END. /* IF  NOT CAN-FIND(FIRST tt-exp-plano */
        END. /* FOR EACH ttplano-aux: */
    
        OUTPUT TO c:\temp\elimina-plano.txt NO-CONVERT.
        FOR EACH tt-exp-plano:
            IF  VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Cta.:" + string(tt-exp-plano.cod_cta_ctbl) + " UN: " + string(tt-exp-plano.cod_unid_negoc) + " CCusto: " + string(tt-exp-plano.cod_ccusto)).
    
            PUT UNFORMATTED
                tt-exp-plano.cod_plano_cta_ctbl ";"
                tt-exp-plano.cod_cta_ctbl       ";"
                tt-exp-plano.cod_unid_negoc     ";"
                tt-exp-plano.cod_ccusto         ";"
                tt-exp-plano.cod_estab          SKIP.
    
            CREATE ttRawTabela.
            RAW-TRANSFER tt-exp-plano TO ttRawTabela.rawTabela.
        END. /* FOR EACH tt-exp-plano: */
        OUTPUT CLOSE.
    
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
            FOR EACH ttPlano-aux:
                FIND FIRST ext_plano_conta EXCLUSIVE-LOCK
                     WHERE ext_plano_conta.cod_plano_cta_ctbl = ttPlano-aux.cod_plano_cta_ctbl
                     AND   ext_plano_conta.cod_cta_ctbl       = ttPlano-aux.cod_cta_ctbl      
                     AND   ext_plano_conta.cod_estab          = ttPlano-aux.cod_estab         
                     AND   ext_plano_conta.cod_unid_negoc     = ttPlano-aux.cod_unid_negoc    
                     AND   ext_plano_conta.cod_plano_ccusto   = ttPlano-aux.cod_plano_ccusto  
                     AND   ext_plano_conta.cod_ccusto         = ttPlano-aux.cod_ccusto NO-ERROR.
                IF  AVAIL ext_plano_conta THEN DO:
                    DELETE ext_plano_conta.
                END. /* IF  AVAIL ext_plano_conta THEN ... */

                FOR EACH  int-integrado-obc EXCLUSIVE-LOCK
                    WHERE int-integrado-obc.cod-tabela = "PLANO_CONTA"
                    AND   trim(ENTRY(1, int-integrado-obc.chave-tabela, ";")) = ttPlano-aux.cod_unid_negoc /* Unid.Neg.*/
                    AND   trim(ENTRY(2, int-integrado-obc.chave-tabela, ";")) = ttPlano-aux.cod_ccusto     /* CCusto   */
                    AND   trim(ENTRY(3, int-integrado-obc.chave-tabela, ";")) = ttPlano-aux.cod_estab      /* Estabel. */ 
                    AND   trim(ENTRY(4, int-integrado-obc.chave-tabela, ";")) = ttPlano-aux.cod_cta_ctbl:  /* CtaCtbl. */ 
                    DELETE int-integrado-obc.
                END. /* FOR EACH int-integrado-obc EXCLUSIVE-LOCK */

            END. /* FOR EACH ttPlano-aux: */
        END. /* ELSE DO: */
    
        RUN pi-finalizar IN h-acomp.

        RUN utp/ut-msgs.p (INPUT 'show', INPUT 15825, INPUT "Elimina‡Æo de Plano(OBC) executada com sucesso.").

        RUN pi-LimpaTela.

        RETURN "OK":U.

    END. /* IF  RETURN-VALUE = "YES" THEN DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExporta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExporta w-livre
ON CHOOSE OF btExporta IN FRAME f-cad
DO:
    RUN utp/ut-msgs.p (INPUT "show":U, 
                       INPUT 27100, 
                       INPUT "Confirma as informa‡äes?" + "~~" + 
                             "Estes dados serÆo registrados na tabela em banco de dados. Ap¢s isso serÆo enviados ao OBC.").
    IF  RETURN-VALUE = "YES" THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        RUN pi-inicializar IN h-acomp (INPUT "Carregando ...").

        FOR EACH ttPlano-aux:

            RUN pi-acompanhar IN h-acomp (INPUT "Conta: " + STRING(ttPlano-aux.cod_cta_ctbl) + " CC: " + STRING(ttPlano-aux.cod_ccusto)).

            IF  NOT CAN-FIND(FIRST ext_plano_conta
                             WHERE ext_plano_conta.cod_plano_cta_ctbl = ttPlano-aux.cod_plano_cta_ctbl
                             AND   ext_plano_conta.cod_cta_ctbl       = ttPlano-aux.cod_cta_ctbl      
                             AND   ext_plano_conta.cod_estab          = ttPlano-aux.cod_estab         
                             AND   ext_plano_conta.cod_unid_negoc     = ttPlano-aux.cod_unid_negoc    
                             AND   ext_plano_conta.cod_plano_ccusto   = ttPlano-aux.cod_plano_ccusto  
                             AND   ext_plano_conta.cod_ccusto         = ttPlano-aux.cod_ccusto) THEN DO:
                
                CREATE ext_plano_conta.
                ASSIGN ext_plano_conta.cod_plano_cta_ctbl = ttPlano-aux.cod_plano_cta_ctbl
                       ext_plano_conta.cod_cta_ctbl       = ttPlano-aux.cod_cta_ctbl
                       ext_plano_conta.cod_estab          = ttPlano-aux.cod_estab
                       ext_plano_conta.cod_unid_negoc     = caps(ttPlano-aux.cod_unid_negoc)
                       ext_plano_conta.cod_plano_ccusto   = ttPlano-aux.cod_plano_ccusto
                       ext_plano_conta.cod_ccusto         = ttPlano-aux.cod_ccusto.
            END. /* IF  NOT CAN-FIND(FIRST ext_plano_conta ... */
        END. /* FOR EACH ttPlano-aux: */

        IF valid-handle(h-acomp) THEN RUN pi-finalizar IN h-acomp.

        RUN pi-ExportaOBC.
    
    END. /* IF  RETURN-VALUE = "YES" THEN DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btInativaCC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInativaCC w-livre
ON CHOOSE OF btInativaCC IN FRAME f-cad
DO:
    RUN utp/ut-msgs.p (INPUT "show":U, 
                       INPUT 27100, 
                       INPUT "Confirma a inativa‡Æo?" + "~~" + 
                             "SerÆo inativados todos estes centros de custos no OBC. Com isso, nÆo ser  poss¡vel movimentar o mesmo nem as contas a ele relacionadas NO OBC.").
    IF  RETURN-VALUE = "YES" THEN DO:    

        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        RUN pi-inicializar IN h-acomp (INPUT "Carregando ...").

        IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Exp Centro Custo...":U).
    
        /* Somente os centros de custos marcados na tela */
        EMPTY TEMP-TABLE ttRawTabela.
        EMPTY TEMP-TABLE tt-exp-ccusto.
    
        FOR EACH ttplano-aux:
            IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Centro Custo: ":U + TRIM(ttplano-aux.cod_ccusto) + "     " + STRING(TIME, "HH:MM:SS")).
    
            IF NOT CAN-FIND(FIRST tt-exp-ccusto
                            WHERE tt-exp-ccusto.cod_plano_ccusto = ttplano-aux.cod_plano_ccusto
                            and   tt-exp-ccusto.cod_unid_negoc   = ttplano-aux.cod_unid_negoc  
                            and   tt-exp-ccusto.cod_ccusto       = ttplano-aux.cod_ccusto      
                            and   tt-exp-ccusto.cod_estab        = ttplano-aux.cod_estab) THEN DO:
    
                CREATE tt-exp-ccusto.
                ASSIGN tt-exp-ccusto.cod_plano_ccusto = ttplano-aux.cod_plano_ccusto
                       tt-exp-ccusto.cod_unid_negoc   = caps(ttplano-aux.cod_unid_negoc)
                       tt-exp-ccusto.cod_estab        = ttplano-aux.cod_estab
                       tt-exp-ccusto.cod_ccusto       = ttplano-aux.cod_ccusto
                       tt-exp-ccusto.des_ccusto       = fnDescricao("ccusto":U, ttplano-aux.cod_ccusto).
            
            END. /* IF NOT CAN-FIND(FIRST tt-exp-ccusto */
        END. /* FOR EACH ttplano-aux: */
        
        OUTPUT TO c:\temp\pi-inat-centro-custo-essdcv007.txt NO-CONVERT.
        FOR EACH tt-exp-ccusto:
            PUT UNFORMATTED
                tt-exp-ccusto.cod_plano_ccusto ";"
                tt-exp-ccusto.cod_unid_negoc ";"
                tt-exp-ccusto.cod_ccusto     ";"
                tt-exp-ccusto.des_ccusto     ";"
                tt-exp-ccusto.cod_estab      SKIP.
    
            CREATE ttRawTabela.
            RAW-TRANSFER tt-exp-ccusto TO ttRawTabela.rawTabela.
        END.
        OUTPUT CLOSE.
    
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

        RUN utp/ut-msgs.p (INPUT 'show', INPUT 15825, INPUT "Inativa‡Æo Centro de Custo(OBC) executada com sucesso.").

        RUN pi-LimpaTela.

        RETURN "OK":U.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-livre
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
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


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-livre
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
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


&Scoped-define BROWSE-NAME brCriterioCta
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
       RUN set-position IN h_p-exihel ( 1.13 , 114.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             btDelPlano:HANDLE IN FRAME f-cad , 'AFTER':U ).
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
  DISPLAY ccod-estabel-ini ccod-estabel-fim c_cod_cta_inicial c_cod_cta_final 
          c_UN_ini c_UN_fim c_cod_ccusto_ini-2 c_cod_ccusto_fim-2 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE ccod-estabel-ini ccod-estabel-fim c_cod_cta_inicial c_cod_cta_final 
         bt-seleciona bt-marca-cta bt-all-cta bt-nenhum-cta c_UN_ini c_UN_fim 
         c_cod_ccusto_ini-2 c_cod_ccusto_fim-2 bt-seleciona-4 bt-marca-un 
         bt-all-un bt-nenhum-un bt-add bt-del btExporta btInativaCC btDelPlano 
         brCriterioCta brUN brPlanoCta rt-button IMAGE-6 IMAGE-7 IMAGE-1 
         IMAGE-3 RECT-10 IMAGE-12 IMAGE-13 RECT-15 RECT-6 RECT-7 RECT-9 RECT-13 
         IMAGE-14 IMAGE-15 
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

  {utp/ut9000.i "ESSDCV007" "1.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN pi-monta-TTs.

  run pi-after-initialize.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exp-centro-custo w-livre 
PROCEDURE pi-exp-centro-custo :
/*------------------------------------------------------------------------------
  Purpose:     Exportar as informa‡äes de centros de custo cadastrados no sistema.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pAcao-ccusto AS CHARACTER NO-UNDO.
    
    IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Exp Centro Custo...":U).

    /* Somente os centros de custos marcados na tela */
    EMPTY TEMP-TABLE ttRawTabela.
    EMPTY TEMP-TABLE tt-exp-ccusto.

    FOR EACH ttplano-aux:
        IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Centro Custo: ":U + TRIM(ttplano-aux.cod_ccusto) + "     " + STRING(TIME, "HH:MM:SS")).

        IF NOT CAN-FIND(FIRST tt-exp-ccusto
                        WHERE tt-exp-ccusto.cod_plano_ccusto = ttplano-aux.cod_plano_ccusto
                        and   tt-exp-ccusto.cod_unid_negoc   = ttplano-aux.cod_unid_negoc  
                        and   tt-exp-ccusto.cod_ccusto       = ttplano-aux.cod_ccusto      
                        and   tt-exp-ccusto.cod_estab        = ttplano-aux.cod_estab) THEN DO:

            CREATE tt-exp-ccusto.
            ASSIGN tt-exp-ccusto.cod_plano_ccusto = ttplano-aux.cod_plano_ccusto
                   tt-exp-ccusto.cod_unid_negoc   = caps(ttplano-aux.cod_unid_negoc)
                   tt-exp-ccusto.cod_estab        = ttplano-aux.cod_estab
                   tt-exp-ccusto.cod_ccusto       = ttplano-aux.cod_ccusto
                   tt-exp-ccusto.des_ccusto       = fnDescricao("ccusto":U, ttplano-aux.cod_ccusto).
        
        END. /* IF NOT CAN-FIND(FIRST tt-exp-ccusto */
    END. /* FOR EACH ttplano-aux: */
    
    OUTPUT TO c:\temp\pi-exp-centro-custo-essdcv007.txt NO-CONVERT.
    FOR EACH tt-exp-ccusto:
        PUT UNFORMATTED
            tt-exp-ccusto.cod_plano_ccusto ";"
            tt-exp-ccusto.cod_unid_negoc ";"
            tt-exp-ccusto.cod_ccusto     ";"
            tt-exp-ccusto.des_ccusto     ";"
            tt-exp-ccusto.cod_estab      SKIP.

        CREATE ttRawTabela.
        RAW-TRANSFER tt-exp-ccusto TO ttRawTabela.rawTabela.
    END.
    OUTPUT CLOSE.

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
  Purpose:     Exportar as informa‡äes de contas cont beis cadastrados no sistema.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pAcao-ctactbl AS CHARACTER NO-UNDO.

    IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Exp Conta Cont bil...":U).

    EMPTY TEMP-TABLE ttRawTabela.
    EMPTY TEMP-TABLE tt-exp-conta.

    FOR EACH ttplano-aux:
        IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Conta Cont bil: ":U + TRIM(ttplano-aux.cod_cta_ctbl) + "     " + STRING(TIME, "HH:MM:SS")).

        IF  NOT CAN-FIND(FIRST tt-exp-conta
                         WHERE tt-exp-conta.cod_plano_cta_ctbl = ttplano-aux.cod_plano_cta_ctbl
                         AND   tt-exp-conta.cod_cta_ctbl       = ttplano-aux.cod_cta_ctbl) THEN DO:
            CREATE tt-exp-conta.
            ASSIGN tt-exp-conta.marca              = "*"
                   tt-exp-conta.cod_plano_cta_ctbl = ttplano-aux.cod_plano_cta_ctbl
                   tt-exp-conta.cod_cta_ctbl       = ttplano-aux.cod_cta_ctbl
                   tt-exp-conta.des_cta_ctbl = fnDescricao("conta":U, ttplano-aux.cod_cta_ctbl).
        END. /* IF  NOT CAN-FIND(FIRST tt-exp-conta */
    END. /* FOR EACH ttplano-aux: */

    OUTPUT TO c:\temp\tt-exp-conta-essdcv007.txt NO-CONVERT.
    FOR EACH tt-exp-conta WHERE tt-exp-conta.marca = "*":
        IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Conta Cont bil: ":U + TRIM(tt-exp-conta.cod_cta_ctbl) + "     " + STRING(TIME, "HH:MM:SS")).

        PUT UNFORMATTED
            tt-exp-conta.marca              ";"
            tt-exp-conta.cod_plano_cta_ctbl ";"
            tt-exp-conta.cod_cta_ctbl       ";"
            tt-exp-conta.des_cta_ctbl       SKIP.

        CREATE ttRawTabela.
        RAW-TRANSFER tt-exp-conta TO ttRawTabela.rawTabela.
    END. /* FOR EACH tt-exp-conta */
    OUTPUT CLOSE.

    RUN esp/sdcv/essdcv001api.p (INPUT  "conta-contab":U,
                                 INPUT  pAcao-ctactbl,
                                 INPUT  TABLE ttRawTabela,
                                 OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) 
    THEN RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Conta Cont bil":U).

    RETURN "OK":U.

END PROCEDURE. /* PROCEDURE pi-exp-conta-contabil */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exp-plano-contas w-livre 
PROCEDURE pi-exp-plano-contas :
/*------------------------------------------------------------------------------
  Purpose:     Exportar as informa‡äes de planos de conta cadastrados no sistema.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN RUN pi-seta-titulo IN h-acomp (INPUT "Exp Plano Contas...":U).

    EMPTY TEMP-TABLE ttRawTabela.
    EMPTY TEMP-TABLE tt-exp-plano.

    FOR EACH ttplano-aux:
        IF VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Conta Cont bil: ":U + TRIM(ttplano-aux.cod_cta_ctbl) + " | " + TRIM(ttplano-aux.cod_ccusto)).

        IF  NOT CAN-FIND(FIRST tt-exp-plano
                         WHERE tt-exp-plano.cod_plano_cta_ctbl = ttplano-aux.cod_plano_cta_ctbl  
                         AND   tt-exp-plano.cod_cta_ctbl       = ttplano-aux.cod_cta_ctbl        
                         AND   tt-exp-plano.cod_unid_negoc     = ttplano-aux.cod_unid_negoc      
                         AND   tt-exp-plano.cod_ccusto         = ttplano-aux.cod_ccusto          
                         AND   tt-exp-plano.cod_estab          = ttplano-aux.cod_estab) THEN DO: 
            CREATE tt-exp-plano.
            ASSIGN tt-exp-plano.cod_plano_cta_ctbl = ttplano-aux.cod_plano_cta_ctbl
                   tt-exp-plano.cod_cta_ctbl       = ttplano-aux.cod_cta_ctbl
                   tt-exp-plano.cod_unid_negoc     = caps(ttplano-aux.cod_unid_negoc)
                   tt-exp-plano.cod_ccusto         = ttplano-aux.cod_ccusto
                   tt-exp-plano.cod_estab          = ttplano-aux.cod_estab.
        END. /* IF  NOT CAN-FIND(FIRST tt-exp-plano */
    END. /* FOR EACH ttplano-aux: */

    OUTPUT TO c:\temp\tt-exp-plano-essdcv007.txt NO-CONVERT.
    FOR EACH tt-exp-plano:
        IF  VALID-HANDLE(h-acomp) THEN RUN pi-acompanhar IN h-acomp (INPUT "Cta.:" + string(tt-exp-plano.cod_cta_ctbl) + " UN: " + string(tt-exp-plano.cod_unid_negoc) + " CCusto: " + string(tt-exp-plano.cod_ccusto)).

        PUT UNFORMATTED
            tt-exp-plano.cod_plano_cta_ctbl ";"
            tt-exp-plano.cod_cta_ctbl       ";"
            caps(tt-exp-plano.cod_unid_negoc)     ";"
            tt-exp-plano.cod_ccusto         ";"
            tt-exp-plano.cod_estab          SKIP.

        CREATE ttRawTabela.
        RAW-TRANSFER tt-exp-plano TO ttRawTabela.rawTabela.
    END. /* FOR EACH tt-exp-plano: */
    OUTPUT CLOSE.

    IF  VALID-HANDLE(h-acomp) THEN do:
        RUN pi-seta-titulo IN h-acomp (INPUT "Enviando para API ...":U).
        RUN pi-acompanhar  IN h-acomp (INPUT "").
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ExportaOBC w-livre 
PROCEDURE pi-ExportaOBC :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    ASSIGN c-file-log = session:TEMP-DIRECTORY + "essdcv007_" + TRIM(replace(STRING(TODAY) + STRING(TIME),"/","")) + ".csv"
           c-file-log = REPLACE(c-file-log, "\", "/").
    
    OUTPUT TO VALUE(c-file-log) NO-CONVERT.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT 'Exportando ...').

    /* Enviar os Centros de Custos envolvidos ... */
    RUN pi-exp-centro-custo (INPUT "I":U).  /* Passando pAcao que ser  usado na API */
    
    /* Enviar as Contas Cont beis envolvidas ... */
    RUN pi-exp-conta-contabil (INPUT "I":U). /* Passando pAcao que ser  usado na API */
    
    /* Enviar os Planos de Contas envolvidos ... */
    RUN pi-exp-plano-contas.
    
    PUT UNFORMATTED "Unid.Neg;Centro Custo;T¡tulo Cont bil;Estab;Conta Cont bil;T¡tulo Cont bil" SKIP.
    FOR EACH ttplano-aux:
        PUT UNFORMATTED 
            ttplano-aux.cod_unid_negoc                       ";"
            ttplano-aux.cod_ccusto                           ";"
            fnDescricao("ccusto":U, ttplano-aux.cod_ccusto)  ";"
            ttplano-aux.cod_estab                            ";"
            ttplano-aux.cod_cta_ctbl                         ";"
            fnDescricao("conta":U, ttplano-aux.cod_cta_ctbl) SKIP.
    END. /* FOR EACH ttplano-aux: */

    IF valid-handle(h-acomp) THEN RUN pi-finalizar IN h-acomp.

    OUTPUT CLOSE.

    RUN utp/ut-msgs.p (INPUT "show":U, 
                       INPUT 15825,
                       INPUT "Arquivo de acompanhamento gerado." + "~~" +
                             "Foi gerado o arquivo " + c-file-log + " para conferˆncia do que foi enviado ao OutbuyCenter(SDCV).").

    RUN pi-LimpaTela.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-LimpaTela w-livre 
PROCEDURE pi-LimpaTela :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    /* Reiniciando browses ... */
    APPLY "CHOOSE":U TO bt-nenhum-cta IN FRAME {&FRAME-NAME}.
    APPLY "CHOOSE":U TO bt-nenhum-un  IN FRAME {&FRAME-NAME}.

    EMPTY TEMP-TABLE ttplano-aux  NO-ERROR.
    {&OPEN-QUERY-brPlanoCta}

    /* Reiniciando fill-ins ... */
    ASSIGN c_cod_cta_inicial:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "40000000":U
           c_cod_cta_final:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = "4ZZZZZZZ":U
           ccod-estabel-ini:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = "":U
           ccod-estabel-fim:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = "ZZZ":U
           c_cod_ccusto_ini-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "10000":U 
           c_cod_ccusto_fim-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "2ZZZZ":U 
           c_UN_ini:SCREEN-VALUE           IN FRAME {&FRAME-NAME} = "":U
           c_UN_fim:SCREEN-VALUE           IN FRAME {&FRAME-NAME} = "ZZZ":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta-TTs w-livre 
PROCEDURE pi-monta-TTs :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE ttconta  NO-ERROR.
    EMPTY TEMP-TABLE ttccusto NO-ERROR.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Carregando ...").

    FOR EACH  criter_distrib_cta_ctbl NO-LOCK
        WHERE criter_distrib_cta_ctbl.ind_criter_distrib = "NÆo Utiliza":U:

        RUN pi-acompanhar IN h-acomp (INPUT "Conta: " + STRING(criter_distrib_cta_ctbl.cod_cta_ctbl) + " Estab.: " + STRING(criter_distrib_cta_ctbl.cod_estab)).

        IF   criter_distrib_cta_ctbl.dat_inic_valid > TODAY           
        OR   criter_distrib_cta_ctbl.dat_fim_valid  < TODAY THEN NEXT.

/*         IF  NOT CAN-FIND(FIRST ext_plano_conta                                                                  */
/*                          WHERE ext_plano_conta.cod_plano_cta_ctbl = criter_distrib_cta_ctbl.cod_plano_cta_ctbl  */
/*                          AND   ext_plano_conta.cod_cta_ctbl       = criter_distrib_cta_ctbl.cod_cta_ctbl        */
/*                          AND   ext_plano_conta.cod_estab          = criter_distrib_cta_ctbl.cod_estab) THEN DO: */

            CREATE ttconta.
            BUFFER-COPY criter_distrib_cta_ctbl TO ttconta.

            
/*         END. /* IF  NOT CAN-FIND(FIRST ext_plano_conta */  */
    END. /* FOR EACH criter_distrib_cta_ctbl NO-LOCK */

    IF CAN-FIND(FIRST ttconta) THEN DO:
       {&OPEN-QUERY-brCriterioCta}
    END.

    FOR EACH  emscad.ccusto NO-LOCK:
        
       RUN pi-acompanhar IN h-acomp (INPUT "CCusto: " + STRING(emscad.ccusto.cod_ccusto)).
    
       IF   ccusto.dat_inic_valid > TODAY           
       OR   ccusto.dat_fim_valid  < TODAY THEN NEXT.
    
       IF  NOT CAN-FIND(FIRST ttccusto
                        WHERE ttccusto.cod_plano_ccusto = emscad.ccusto.cod_plano_ccusto
                        AND   ttccusto.cod_ccusto       = emscad.ccusto.cod_ccusto) THEN DO:
           CREATE ttccusto.
           BUFFER-COPY emscad.ccusto TO ttccusto.
       END. /* IF  NOT CAN-FIND(FIRST ttccusto */
    
    END. /* FOR EACH  emscad.ccusto NO-LOCK: */
    
    IF CAN-FIND(FIRST ttccusto) THEN DO:
      {&OPEN-QUERY-brCcusto}
    END.

    FOR EACH  cc_uni_estab NO-LOCK:
        
       RUN pi-acompanhar IN h-acomp (INPUT "UN: " + STRING(cc_uni_estab.cod_unid_negoc)).
       
       IF  NOT CAN-FIND(FIRST ttunid-negoc
                        WHERE ttunid-negoc.cod_ccusto     = cc_uni_estab.cod_ccusto
                        AND   ttunid-negoc.cod_unid_negoc = cc_uni_estab.cod_unid_negoc
                        AND   ttunid-negoc.cod_estab      = cc_uni_estab.cod_estab) THEN DO:
           CREATE ttunid-negoc.
           BUFFER-COPY cc_uni_estab TO ttunid-negoc.
       END. /* IF  NOT CAN-FIND(FIRST ttunid-negoc */
    
    END. /* FOR EACH  cc_uni_estab NO-LOCK: */
    
    IF CAN-FIND(FIRST ttunid-negoc) THEN DO:
      {&OPEN-QUERY-brUN}
    END.

    RUN pi-finalizar IN h-acomp.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-montaTT-plano w-livre 
PROCEDURE pi-montaTT-plano :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    FOR EACH ttconta WHERE ttconta.marca <> "" :
        FOR EACH ttccusto WHERE ttccusto.marca <> "":

        END.
    END.

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
  {src/adm/template/snd-list.i "ttunid-negoc"}
  {src/adm/template/snd-list.i "ttplano-aux"}
  {src/adm/template/snd-list.i "ttconta"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescUN w-livre 
FUNCTION fnDescUN RETURNS CHARACTER
  ( cCodUN AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST unid_negoc NO-LOCK
        WHERE  unid_negoc.cod_unid_negoc = cCodUN NO-ERROR.
    IF  AVAIL unid_negoc
    THEN RETURN unid_negoc.des_unid_negoc.
    ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

