&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
{include/i-prgvrs.i es5601 2.00.00.000}


CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* DEFINE VARIABLE h-api AS HANDLE NO-UNDO.  */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.
DEFINE VARIABLE cTransacao AS CHARACTER FORMAT "X(15)"  NO-UNDO.
DEFINE VARIABLE hprogramzoom AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_tit_ap  AS RECID FORMAT ">>>>>>>9" INITIAL ? NO-UNDO.

DEF BUFFER b-int-cc-benef FOR int-cc-benef.
DEF buffer b-novo         FOR int-cc-benef.
DEF BUFFER b-hist-solicit FOR int-solicitacao.
def temp-table tt-erro-aux no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEF TEMP-TABLE tt-canal
    FIELD canal       AS INTEGER
    FIELD nome        AS CHAR FORMAT "X(50)"
    FIELD nome-abrev  AS CHAR FORMAT "X(16)"
    FIELD cgc         AS CHAR FORMAT "X(20)"
    FIELD r-rowid     AS ROWID
    INDEX idx_primary IS PRIMARY canal.

DEF BUFFER b-tt-canal FOR tt-canal.

DEFINE TEMP-TABLE tt-conta-corrente NO-UNDO
    LIKE int-cc-benef
    FIELD status-crm           AS CHAR FORMAT "X(12)"
    FIELD nome-classificacao   AS CHAR FORMAT "X(25)"
    FIELD desc-tp-movto        AS CHAR FORMAT "x(25)"
    FIELD desc-beneficio       AS CHAR FORMAT "X(25)"
    FIELD de-verbatotal        AS DEC FORMAT ">>>,>>>,>>9.99"
    FIELD de-empenhadaAnalise  AS DEC FORMAT ">>>,>>>,>>9.99"
    FIELD de-empenhadaAprovada AS DEC FORMAT ">>>,>>>,>>9.99"
    FIELD de-empenhadaTotal    AS DEC FORMAT ">>>,>>>,>>9.99"
    FIELD de-reembolsado       AS DEC FORMAT ">>>,>>>,>>9.99"
    FIELD de-disponivel        AS DEC FORMAT "->>>,>>>,>>9.99"
    FIELD r-rowid              AS ROWID.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD l-provisao           AS LOG
    FIELD l-despesa            AS LOG
    FIELD l-rebate             AS LOG
    FIELD l-rebate-pos         AS LOG
    FIELD l-vmc                AS LOG
    FIELD l-stock              AS LOG
    FIELD l-backup             AS LOG
    FIELD l-showroom           AS LOG
    FIELD l-price              AS LOG
    FIELD c-unid-ini           AS CHAR
    FIELD c-unid-fim           AS CHAR
    FIELD c-class-ini          AS CHAR
    FIELD c-class-fim          AS CHAR
    FIELD l-ouro               AS LOG    
    FIELD l-prata              AS LOG
    FIELD l-bronze             AS LOG
    FIELD l-distribuidor       AS LOG
    FIELD l-Revenda-Solucoes   AS LOG
    FIELD l-Provedores         AS LOG
    FIELD l-ativo              AS LOG
    FIELD l-finalizado         AS LOG
    FIELD da-periodo-ini       AS DATE
    FIELD da-periodo-fim       AS DATE
    FIELD da-trans-ini         AS DATE
    FIELD da-trans-fim         AS DATE
    FIELD da-vencto-ini        AS DATE
    FIELD da-vencto-fim        AS DATE
    FIELD l-ok                 AS LOG.

DEF TEMP-TABLE tt-cc-transf NO-UNDO
    FIELD canal          AS INTEGER
    FIELD unid-neg       AS CHAR
    FIELD tipo-beneficio AS INTEGER
    FIELD dt-periodo-ini AS DATE
    FIELD dt-periodo-fim AS DATE
    FIELD vl-saldo       AS DEC DECIMALS 4 FORMAT "->>,>>>,>>9.99"
    FIELD r-rowid        AS ROWID.
    
DEF TEMP-TABLE tt-cc-transf-dest NO-UNDO
    FIELD canal          AS INTEGER
    FIELD unid-neg       AS CHAR
    FIELD tipo-beneficio AS INTEGER
    FIELD dt-periodo-ini AS DATE
    FIELD dt-periodo-fim AS DATE
    FIELD vl-saldo       AS DEC DECIMALS 4 FORMAT "->>,>>>,>>9.99"
    FIELD r-rowid        AS ROWID.


/********** PARA CONSULTA DE BENEF÷CIO *************/
    /* Temp-table tt-beneficio */
    {esp/esb/esesbapi004-benef.i}
    

/***************************************************/

DEF TEMP-TABLE tt-nova-cc LIKE int-cc-benef.

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

DEF NEW GLOBAL SHARED VAR r-row-canal AS ROWID  NO-UNDO.
DEF NEW GLOBAL SHARED VAR r-row-cc    AS ROWID  NO-UNDO.

DEF BUFFER b-solicitacao FOR int-solicitacao.

/*Estrutura Canais centralizados*/
{esp/esb/esesbapi005.i}

/* pi-valida-operacao-usuario */
/* {esp/esb/esesbapi003-movtos.i1}  */
    
DEF STREAM s-1.

DEF NEW GLOBAL SHARED VAR gr-solicitacao AS ROWID NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-conta-corrente AS ROWID NO-UNDO.

{esp/esb/esesbapi013-saldo.i}
{esp/esb/esesbapi013-saldo.i1}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-canais

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-canal tt-conta-corrente int-solicitacao

/* Definitions for BROWSE br-canais                                     */
&Scoped-define FIELDS-IN-QUERY-br-canais tt-canal.canal tt-canal.nome-abrev tt-canal.nome tt-canal.cgc   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-canais   
&Scoped-define SELF-NAME br-canais
&Scoped-define QUERY-STRING-br-canais FOR EACH tt-canal
&Scoped-define OPEN-QUERY-br-canais OPEN QUERY {&SELF-NAME} FOR EACH tt-canal.
&Scoped-define TABLES-IN-QUERY-br-canais tt-canal
&Scoped-define FIRST-TABLE-IN-QUERY-br-canais tt-canal


/* Definitions for BROWSE br-conta-corrente                             */
&Scoped-define FIELDS-IN-QUERY-br-conta-corrente /* tt-conta-corrente.canal */ tt-conta-corrente.desc-tp-movto tt-conta-corrente.desc-beneficio tt-conta-corrente.unid-neg tt-conta-corrente.dt-periodo-ini tt-conta-corrente.dt-periodo-fim tt-conta-corrente.nome-classificacao tt-conta-corrente.categoria (tt-conta-corrente.de-verbatotal + tt-conta-corrente.VerbaCancelada + tt-conta-corrente.VerbaAjustada) tt-conta-corrente.de-reembolsado tt-conta-corrente.de-empenhadaTotal tt-conta-corrente.de-disponivel tt-conta-corrente.dt-vencimento fnStatus(tt-conta-corrente.Id-Status)   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-conta-corrente   
&Scoped-define SELF-NAME br-conta-corrente
&Scoped-define QUERY-STRING-br-conta-corrente FOR EACH tt-conta-corrente BY tt-conta-corrente.dt-periodo-ini
&Scoped-define OPEN-QUERY-br-conta-corrente OPEN QUERY {&SELF-NAME} FOR EACH tt-conta-corrente BY tt-conta-corrente.dt-periodo-ini.
&Scoped-define TABLES-IN-QUERY-br-conta-corrente tt-conta-corrente
&Scoped-define FIRST-TABLE-IN-QUERY-br-conta-corrente tt-conta-corrente


/* Definitions for BROWSE br-movimentos                                 */
&Scoped-define FIELDS-IN-QUERY-br-movimentos IF int-solicitacao.Ajuste THEN "AJUSTE" ELSE "NORMAL" int-solicitacao.DataCriacao int-solicitacao.hora-trans int-solicitacao.desc-forma-pagto int-solicitacao.ValorSolicitado int-solicitacao.vl-empenho-pago (IF int-solicitacao.desc-forma-pagto = "PRODUTO" THEN int-solicitacao.ValorPago ELSE IF int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 THEN int-solicitacao.ValorSolicitado ELSE 0) (IF int-solicitacao.Ajuste THEN 0 ELSE IF int-solicitacao.desc-forma-pagto = "PRODUTO" THEN (int-solicitacao.ValorSolicitado - int-solicitacao.vl-empenho-pago - int-solicitacao.vl-abatido-apb) ELSE IF int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 THEN 0 ELSE int-solicitacao.ValorSolicitado ) int-solicitacao.log-historica fnStatusSolicitacao(int-solicitacao.SituacaoSolicitacaoBeneficio) int-solicitacao.log-enviada   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-movimentos   
&Scoped-define SELF-NAME br-movimentos
&Scoped-define QUERY-STRING-br-movimentos FOR EACH int-solicitacao NO-LOCK         WHERE int-solicitacao.cod-emitente                  = tt-conta-corrente.canal           AND /*int-solicitacao.CodigoUnidadeNegocio         = tt-conta-corrente.unid-neg           AND*/ int-solicitacao.tipo-beneficio               = tt-conta-corrente.tipo-beneficio           AND int-solicitacao.dt-periodo-ini               = tt-conta-corrente.dt-periodo-ini           AND int-solicitacao.dt-periodo-fim               = tt-conta-corrente.dt-periodo-fim  AND int-solicitacao.log-historica = NO            BY int-solicitacao.DataCriacao            BY int-solicitacao.hora-trans.           /*AND int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004:*/ /* Pago */
&Scoped-define OPEN-QUERY-br-movimentos OPEN QUERY {&SELF-NAME}     FOR EACH int-solicitacao NO-LOCK         WHERE int-solicitacao.cod-emitente                  = tt-conta-corrente.canal           AND /*int-solicitacao.CodigoUnidadeNegocio         = tt-conta-corrente.unid-neg           AND*/ int-solicitacao.tipo-beneficio               = tt-conta-corrente.tipo-beneficio           AND int-solicitacao.dt-periodo-ini               = tt-conta-corrente.dt-periodo-ini           AND int-solicitacao.dt-periodo-fim               = tt-conta-corrente.dt-periodo-fim    AND int-solicitacao.log-historica = NO            BY int-solicitacao.DataCriacao            BY int-solicitacao.hora-trans.           /*AND int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004:*/ /* Pago */.
&Scoped-define TABLES-IN-QUERY-br-movimentos int-solicitacao
&Scoped-define FIRST-TABLE-IN-QUERY-br-movimentos int-solicitacao


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-canais}~
    ~{&OPEN-QUERY-br-conta-corrente}

/* Definitions for FRAME fpage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage5 ~
    ~{&OPEN-QUERY-br-movimentos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-relatorio-2 ~
bt-relatorio1 fi-canal bt-exit bt-goto-emitente bt-param-cc bt-ok ~
bt-ajustes bt-novo bt-expande ~
bt-exporta-ContaCorrente rt-button Rect-Main br-canais folder-1 ~
br-conta-corrente rt-button-2 folder-4 RECT-12 folder-5 
&Scoped-Define DISPLAYED-OBJECTS fi-canal fi-nome 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-saldo-pendente w-cadsim 
FUNCTION fn-saldo-pendente RETURNS DECIMAL
  ( INPUT p-guid-canal AS CHAR ,
    INPUT p-unidade    AS char,
    INPUT p-beneficio  AS INTEGER,
    INPUT p-per-ini    AS DATE,
    INPUT p-per-fim    AS DATE  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-saldo-reembolsado w-cadsim 
FUNCTION fn-saldo-reembolsado RETURNS DECIMAL
  ( INPUT p-guid-canal AS CHAR ,
    INPUT p-unidade    AS char,
    INPUT p-beneficio  AS INTEGER,
    INPUT p-per-ini    AS DATE,
    INPUT p-per-fim    AS DATE  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnbeneficio w-cadsim 
FUNCTION fnbeneficio RETURNS CHARACTER
  (INPUT p-tipo AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMovto w-cadsim 
FUNCTION fnMovto RETURNS CHARACTER
  ( p-movto AS INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSitPedido w-cadsim 
FUNCTION fnSitPedido RETURNS CHARACTER
  ( INPUT  p-sit AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSituacao w-cadsim 
FUNCTION fnSituacao RETURNS CHARACTER
    (INPUT p-situacao AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnStatus w-cadsim 
FUNCTION fnStatus RETURNS CHARACTER
  ( p-status AS INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnStatusSolicitacao w-cadsim 
FUNCTION fnStatusSolicitacao RETURNS CHARACTER
  ( p-status AS INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTransacao w-cadsim 
FUNCTION fnTransacao RETURNS CHARACTER
  (INPUT p-tipo AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajustes 
     IMAGE-UP FILE "adeicon/editcode.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Ajuste de Saldo".

DEFINE BUTTON bt-exit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-DOWN FILE "image\ii-exi":U
     LABEL "" 
     SIZE 4 BY 1.17 TOOLTIP "Sair do programa".

DEFINE BUTTON bt-expande 
     IMAGE-UP FILE "adeicon/psend.bmp":U
     LABEL "Button 1" 
     SIZE 3.29 BY .75 TOOLTIP "Expandir Visualizaá∆o".

DEFINE BUTTON bt-exporta-ContaCorrente 
     IMAGE-UP FILE "image/excel.jpg":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Exportar Conta Corrente para Excel".

DEFINE BUTTON bt-goto-emitente 
     IMAGE-UP FILE "IMAGE/im-enter.bmp":U
     LABEL "" 
     SIZE 4 BY 1.17 TOOLTIP "Posicionar no Canal".

DEFINE BUTTON bt-novo 
     IMAGE-UP FILE "adeicon/new.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Criaá∆o de Conta Corrente manual".

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&Fechar" 
     SIZE 10 BY 1 TOOLTIP "Sair do programa"
     BGCOLOR 8 .

DEFINE BUTTON bt-param-cc 
     IMAGE-UP FILE "adeicon/filt-u95.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Filtrar Conta Corrente".

DEFINE BUTTON bt-relatorio-2 DEFAULT 
     IMAGE-UP FILE "image\excel2.jpg":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4 BY 1.17 TOOLTIP "Contas Correntes Ativas X Solicitaá‰es".

DEFINE BUTTON bt-relatorio1 DEFAULT 
     IMAGE-UP FILE "image/excel.jpg":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 4 BY 1.17 TOOLTIP "Saldo Geral Contas Correntes Ativas".

DEFINE VARIABLE fi-canal AS CHARACTER FORMAT "X(256)":U 
     LABEL "Canal" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32.86 BY .88 NO-UNDO.

DEFINE IMAGE folder-1
     FILENAME "image\ts-up110.bmp":U
     SIZE 16 BY 1.21.

DEFINE IMAGE folder-4
     FILENAME "image\ts-dn110.bmp":U
     SIZE 16 BY 1.21.

DEFINE IMAGE folder-5
     FILENAME "image\ts-dn110.bmp":U
     SIZE 16 BY 1.21.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 137.86 BY 10.42.

DEFINE RECTANGLE Rect-Main
     EDGE-PIXELS 1 GRAPHIC-EDGE    
     SIZE 137.57 BY 10.08
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 138 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE rt-button-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 137.57 BY 1.38
     BGCOLOR 7 .

DEFINE BUTTON bt-titulo 
     IMAGE-UP FILE "image/cmcac.gif":U
     LABEL "" 
     SIZE 5 BY 1.42 TOOLTIP "Consulta t°tulo APB".

DEFINE VARIABLE fi-analise AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Solicitaá‰es em An†lise" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-aprovada AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Solicitaá‰es Ö Pagar" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-beneficio AS CHARACTER FORMAT "X(256)":U 
     LABEL "Benef°cio" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .79 NO-UNDO.

DEFINE VARIABLE fi-categoria AS CHARACTER FORMAT "X(256)":U 
     LABEL "Categoria" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .79 NO-UNDO.

DEFINE VARIABLE fi-classificacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Classificaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .79 NO-UNDO.

DEFINE VARIABLE fi-dt-transacao AS DATE FORMAT "99/99/9999":U 
     LABEL "Transaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-EmpenhoTotal AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Total (7)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-especie AS CHARACTER FORMAT "X(256)":U 
     LABEL "EspÇc." 
     VIEW-AS FILL-IN 
     SIZE 7 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Finalizada-Stock-Rotation AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Verba Finalizada Stock Rot." 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-parcela AS CHARACTER FORMAT "X(256)":U 
     LABEL "Parc" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .79 NO-UNDO.

DEFINE VARIABLE fi-periodo-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-periodo-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Per°odo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Reembolsado AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Valor Reembolsado (8)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-saldo AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "∑ Pagar" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-SaldoDisponivel AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .79
     FGCOLOR 2 FONT 0 NO-UNDO.

DEFINE VARIABLE fi-serie AS CHARACTER FORMAT "X(256)":U 
     LABEL "SÇrie" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .79 NO-UNDO.

DEFINE VARIABLE fi-titulo AS CHARACTER FORMAT "X(256)":U 
     LABEL "T°tulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-tp-movto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Movto" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE fi-transacao AS DATE FORMAT "99/99/9999":U 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-unidade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidade" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE fi-vencimento AS DATE FORMAT "99/99/9999":U 
     LABEL "Vencto" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-VerbaAcumulada AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Transf. p/ Ac£m Benef. (2)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-VerbaAjustada AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Verba Ajustada (6)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-VerbaCalculada AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Calculada (1)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-VerbaCancelada AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Verba Cancelada (5)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-VerbaTotal AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Verba Total (4) -> (1 + 2 + 3)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-VerbaTransferida AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Transf. Per°odo. Anterior (3)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-vl-ating-meta AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Ating. Meta" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .79 NO-UNDO.

DEFINE VARIABLE fi-vl-base-calc AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Base C†lculo" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .79 NO-UNDO.

DEFINE VARIABLE fi-vl-beneficio AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Benef°cio" 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .79 NO-UNDO.

DEFINE VARIABLE fi-vl-custo AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Custo Prev" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35.72 BY 8.83.

DEFINE RECTANGLE RECT-51
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34.43 BY 5.

DEFINE RECTANGLE RECT-52
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34.57 BY 3.33.

DEFINE RECTANGLE RECT-56
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33.14 BY 4.83.

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 2.46.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29.43 BY 3.75.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29.43 BY 1.25.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 2.75.

DEFINE BUTTON bt-detalha-solicitacao 
     IMAGE-UP FILE "adeicon/results.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Consulta Solicitaá∆o".

DEFINE BUTTON bt-exporta-ContaCorrente-2 
     IMAGE-UP FILE "image/excel.jpg":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Exportar Conta Corrente para Excel".

DEFINE BUTTON bt-titulo-2 
     IMAGE-UP FILE "image/cmcac.gif":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Consulta t°tulo APB".

DEFINE VARIABLE ed-nota AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 72 BY 1.5 NO-UNDO.

DEFINE VARIABLE tx-nota AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .67 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-canais FOR 
      tt-canal SCROLLING.

DEFINE QUERY br-conta-corrente FOR 
      tt-conta-corrente SCROLLING.

DEFINE QUERY br-movimentos FOR 
      int-solicitacao SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-canais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-canais w-cadsim _FREEFORM
  QUERY br-canais DISPLAY
      tt-canal.canal        LABEL "Canal"
      tt-canal.nome-abrev   LABEL "Abreviado"
      tt-canal.nome         LABEL "Nome" 
      tt-canal.cgc          LABEL "CNPJ"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 128.72 BY 4.17
         TITLE "Canais" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.

DEFINE BROWSE br-conta-corrente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-conta-corrente w-cadsim _FREEFORM
  QUERY br-conta-corrente DISPLAY
      /* tt-conta-corrente.canal                       COLUMN-LABEL "Canal"      WIDTH 8 */
      tt-conta-corrente.desc-tp-movto               COLUMN-LABEL "Movto"          WIDTH 5
      tt-conta-corrente.desc-beneficio              COLUMN-LABEL "Benef°cio"      WIDTH 14 FORMAT "X(17)"
      tt-conta-corrente.unid-neg                    COLUMN-LABEL "Unidade."
      tt-conta-corrente.dt-periodo-ini              COLUMN-LABEL "Per°odo Ini"
      tt-conta-corrente.dt-periodo-fim              COLUMN-LABEL "Per°odo Fim"
      tt-conta-corrente.nome-classificacao          COLUMN-LABEL "Classificaá∆o" WIDTH 14
      tt-conta-corrente.categoria                   COLUMN-LABEL "Categoria"     WIDTH 8
      (tt-conta-corrente.de-verbatotal + tt-conta-corrente.VerbaCancelada + tt-conta-corrente.VerbaAjustada) COLUMN-LABEL "Verba"         WIDTH 8
      tt-conta-corrente.de-reembolsado              COLUMN-LABEL "Pago"          WIDTH 8
      tt-conta-corrente.de-empenhadaTotal           COLUMN-LABEL "Pendente"      WIDTH 8
      tt-conta-corrente.de-disponivel               COLUMN-LABEL "Saldo"         WIDTH 8
      tt-conta-corrente.dt-vencimento               COLUMN-LABEL "Vencto"
      fnStatus(tt-conta-corrente.Id-Status)         COLUMN-LABEL "Status"   FORMAT "X(10)" WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 128.72 BY 5.5
         TITLE "Conta Corrente Benef°cios" ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN TOOLTIP "Conta Corrente do Canal. Duplo Clique para detalhar faturamentos".

DEFINE BROWSE br-movimentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-movimentos w-cadsim _FREEFORM
  QUERY br-movimentos DISPLAY
      IF int-solicitacao.Ajuste THEN "AJUSTE" ELSE "NORMAL"             COLUMN-LABEL "Tipo" WIDTH 6
      int-solicitacao.DataCriacao                                       COLUMN-LABEL "Data" WIDTH 7.5
      int-solicitacao.hora-trans                                        COLUMN-LABEL "Hora" WIDTH 8
      int-solicitacao.desc-forma-pagto                                  COLUMN-LABEL "Forma Pagto" WIDTH 10
      int-solicitacao.ValorSolicitado                                   COLUMN-LABEL "Vl Solicitaá∆o" WIDTH 10
      int-solicitacao.vl-empenho-pago                                   COLUMN-LABEL "Pago Trim. Ant" WIDTH 10

     (IF int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 THEN
             int-solicitacao.ValorAprovado
           ELSE 
               0) COLUMN-LABEL "Pago Trim. Atual"  WIDTH 11

      (IF  int-solicitacao.Ajuste THEN 
          0 
      ELSE 
          IF   int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 THEN 
              0
          ELSE 
              int-solicitacao.ValorAprovado /*int-solicitacao.ValorSolicitado*/
                     )  COLUMN-LABEL "∑ Pagar" WIDTH 9
      int-solicitacao.log-historica                                     COLUMN-LABEL "Apenas hist¢rico" WIDTH 12
      fnStatusSolicitacao(int-solicitacao.SituacaoSolicitacaoBeneficio) COLUMN-LABEL "Situaá∆o" WIDTH 7 FORMAT "X(12)"
      int-solicitacao.log-enviada                                       COLUMN-LABEL "Env.CRM"  WIDTH 7 FORMAT "SIM/N«O"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 104 BY 6.75
         FONT 7
         TITLE "Solicitaá‰es Vinculadas a conta corrente" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-relatorio-2 AT ROW 1.13 COL 80.43 HELP
          "Contas Correntes Ativas X Solicitaá‰es" WIDGET-ID 112
     bt-relatorio1 AT ROW 1.13 COL 74.86 HELP
          "Saldo Geral Contas Correntes Ativas" WIDGET-ID 110
     fi-canal AT ROW 1.29 COL 7.14 COLON-ALIGNED WIDGET-ID 2
     fi-nome AT ROW 1.29 COL 24.72 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     bt-exit AT ROW 1.08 COL 119.57 HELP
          "Sair do programa"
     bt-goto-emitente AT ROW 1.13 COL 60.57 HELP
          "Posicionar o cursor no registro do canal" WIDGET-ID 6
     bt-param-cc AT ROW 7.25 COL 133.43 HELP
          "Filtrar Conta Corrente"
     bt-ok AT ROW 24.71 COL 53 HELP
          "Sair do programa"
     bt-ajustes AT ROW 11.54 COL 133.43 HELP
          "Ajuste de Saldo" WIDGET-ID 14
     bt-novo AT ROW 10.29 COL 133.43 HELP
          "Criaá∆o de Conta Corrente manual" WIDGET-ID 18
     bt-expande AT ROW 7.21 COL 1.14 HELP
          "Expandir µrea de Visualizaá∆o" WIDGET-ID 22
     bt-exporta-ContaCorrente AT ROW 8.5 COL 133.57 HELP
          "Exportar Conta Corrente para Excel" WIDGET-ID 106
     br-canais AT ROW 2.79 COL 4.29
     br-conta-corrente AT ROW 7.25 COL 4.29 WIDGET-ID 200
     "Detalhe Benef°cio" VIEW-AS TEXT
          SIZE 13 BY .67 AT ROW 13.46 COL 3.14
          BGCOLOR 8 FONT 7
     "Solicitaá‰es" VIEW-AS TEXT
          SIZE 8.86 BY .67 AT ROW 13.42 COL 20.72 WIDGET-ID 12
          BGCOLOR 8 FONT 7
     rt-button AT ROW 1 COL 1
     Rect-Main AT ROW 14.17 COL 1.43
     folder-1 AT ROW 13.25 COL 1.57
     rt-button-2 AT ROW 24.5 COL 1.43
     folder-4 AT ROW 13.25 COL 33.29
     RECT-12 AT ROW 2.63 COL 1.14 WIDGET-ID 8
     folder-5 AT ROW 13.25 COL 17.43 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 138.72 BY 25
         BGCOLOR 15 .

DEFINE FRAME fpage5
     br-movimentos AT ROW 1.5 COL 2 HELP
          "Solicitaá‰es Vinculadas a conta corrente"
     ed-nota AT ROW 8.5 COL 34 NO-LABEL WIDGET-ID 138
     bt-exporta-ContaCorrente-2 AT ROW 8.67 COL 2 HELP
          "Exportar Conta Corrente para Excel" WIDGET-ID 106
     bt-titulo-2 AT ROW 8.67 COL 7 WIDGET-ID 136
     bt-detalha-solicitacao AT ROW 8.67 COL 12 HELP
          "Consulta Solicitaá∆o" WIDGET-ID 64
     tx-nota AT ROW 8.96 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 142
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.29 ROW 14.79
         SIZE 105.72 BY 9.21
         BGCOLOR 15 FGCOLOR 0 FONT 7 WIDGET-ID 400.

DEFINE FRAME fPage1
     bt-titulo AT ROW 8.25 COL 130.14 WIDGET-ID 64
     fi-tp-movto AT ROW 1.71 COL 9.57 COLON-ALIGNED WIDGET-ID 20
     fi-beneficio AT ROW 2.71 COL 9.57 COLON-ALIGNED WIDGET-ID 6
     fi-periodo-ini AT ROW 3.71 COL 9.57 COLON-ALIGNED WIDGET-ID 12
     fi-periodo-fim AT ROW 3.71 COL 21.86 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     fi-unidade AT ROW 4.71 COL 9.57 COLON-ALIGNED WIDGET-ID 2
     fi-classificacao AT ROW 5.71 COL 9.57 COLON-ALIGNED WIDGET-ID 8
     fi-categoria AT ROW 6.71 COL 9.57 COLON-ALIGNED WIDGET-ID 10
     fi-dt-transacao AT ROW 7.71 COL 9.57 COLON-ALIGNED WIDGET-ID 40
     fi-cod-estabel AT ROW 6 COL 42 COLON-ALIGNED WIDGET-ID 54
     fi-especie AT ROW 9 COL 42 COLON-ALIGNED WIDGET-ID 56
     fi-serie AT ROW 7 COL 42 COLON-ALIGNED WIDGET-ID 58
     fi-titulo AT ROW 6 COL 57.72 COLON-ALIGNED WIDGET-ID 60
     fi-parcela AT ROW 8 COL 42 COLON-ALIGNED WIDGET-ID 62
     fi-saldo AT ROW 9 COL 57.72 COLON-ALIGNED WIDGET-ID 66
     fi-transacao AT ROW 7 COL 57.72 COLON-ALIGNED WIDGET-ID 68
     fi-vencimento AT ROW 8 COL 57.72 COLON-ALIGNED WIDGET-ID 70
     fi-vl-base-calc AT ROW 8.75 COL 9.57 COLON-ALIGNED WIDGET-ID 86
     fi-vl-custo AT ROW 2.71 COL 60.86 COLON-ALIGNED WIDGET-ID 88
     fi-vl-ating-meta AT ROW 1.75 COL 60.86 COLON-ALIGNED WIDGET-ID 90
     fi-vl-beneficio AT ROW 3.71 COL 61.14 COLON-ALIGNED WIDGET-ID 92
     fi-analise AT ROW 2.13 COL 122.43 COLON-ALIGNED WIDGET-ID 166
     fi-aprovada AT ROW 3.13 COL 122.43 COLON-ALIGNED WIDGET-ID 168
     fi-EmpenhoTotal AT ROW 4.13 COL 122.43 COLON-ALIGNED WIDGET-ID 188
     fi-Reembolsado AT ROW 5.71 COL 122.43 COLON-ALIGNED WIDGET-ID 190
     fi-SaldoDisponivel AT ROW 8.58 COL 107.86 COLON-ALIGNED NO-LABEL WIDGET-ID 180
     fi-VerbaCalculada AT ROW 2.08 COL 92.43 COLON-ALIGNED WIDGET-ID 206
     fi-VerbaAcumulada AT ROW 3.08 COL 92.43 COLON-ALIGNED WIDGET-ID 202
     fi-VerbaTransferida AT ROW 4.08 COL 92.43 COLON-ALIGNED WIDGET-ID 212
     fi-VerbaTotal AT ROW 5.08 COL 92.43 COLON-ALIGNED WIDGET-ID 210
     fi-VerbaCancelada AT ROW 7.13 COL 92.43 COLON-ALIGNED WIDGET-ID 208
     fi-VerbaAjustada AT ROW 8.08 COL 92.43 COLON-ALIGNED WIDGET-ID 204
     fi-Finalizada-Stock-Rotation AT ROW 9.38 COL 92.43 COLON-ALIGNED WIDGET-ID 224
     "Solicitaá‰es:" VIEW-AS TEXT
          SIZE 9.72 BY .54 AT ROW 1.21 COL 108.29 WIDGET-ID 176
     "Saldo Dispon°vel (9)->(4 - 5 + 6 - 7 - 8)" VIEW-AS TEXT
          SIZE 26.29 BY .54 AT ROW 7.25 COL 108.43 WIDGET-ID 198
     "Movimentaá‰es:" VIEW-AS TEXT
          SIZE 12 BY .54 AT ROW 6.5 COL 75.14 WIDGET-ID 218
     "Verba Original Per°odo:" VIEW-AS TEXT
          SIZE 16.86 BY .54 AT ROW 1.21 COL 73.29 WIDGET-ID 220
     "T°tulo:" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 4.92 COL 38.86 WIDGET-ID 222
     RECT-48 AT ROW 1.42 COL 1.14 WIDGET-ID 22
     RECT-51 AT ROW 5.25 COL 37.57 WIDGET-ID 36
     RECT-52 AT ROW 1.42 COL 37.43 WIDGET-ID 94
     RECT-58 AT ROW 1.5 COL 107 WIDGET-ID 170
     RECT-60 AT ROW 5.5 COL 107 WIDGET-ID 192
     RECT-61 AT ROW 7.5 COL 107 WIDGET-ID 194
     RECT-56 AT ROW 1.46 COL 73.29 WIDGET-ID 214
     RECT-57 AT ROW 6.79 COL 73.43 WIDGET-ID 216
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.29 ROW 14.79
         SIZE 135.72 BY 9.33
         BGCOLOR 15 FGCOLOR 0 FONT 7.


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
         HEIGHT             = 25
         WIDTH              = 138.57
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME f-cad:HANDLE
       FRAME fpage5:FRAME = FRAME f-cad:HANDLE.

/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-canais Rect-Main f-cad */
/* BROWSE-TAB br-conta-corrente folder-1 f-cad */
ASSIGN 
       br-conta-corrente:ALLOW-COLUMN-SEARCHING IN FRAME f-cad = TRUE
       br-conta-corrente:COLUMN-RESIZABLE IN FRAME f-cad       = TRUE.

ASSIGN 
       bt-ajustes:HIDDEN IN FRAME f-cad           = TRUE.

ASSIGN 
       bt-novo:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FILL-IN fi-nome IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       folder-4:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FILL-IN fi-analise IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-aprovada IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-beneficio IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-categoria IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-classificacao IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dt-transacao IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-EmpenhoTotal IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-especie IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-Finalizada-Stock-Rotation IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-parcela IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-fim IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-ini IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-Reembolsado IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-saldo IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-SaldoDisponivel IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-serie IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-titulo IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tp-movto IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-transacao IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-unidade IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vencimento IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-VerbaAcumulada IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-VerbaAjustada IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-VerbaCalculada IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-VerbaCancelada IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-VerbaTotal IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-VerbaTransferida IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vl-ating-meta IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vl-base-calc IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vl-beneficio IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vl-custo IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fpage5
                                                                        */
/* BROWSE-TAB br-movimentos 1 fpage5 */
/* SETTINGS FOR BUTTON bt-exporta-ContaCorrente-2 IN FRAME fpage5
   NO-ENABLE                                                            */
ASSIGN 
       bt-exporta-ContaCorrente-2:HIDDEN IN FRAME fpage5           = TRUE.

ASSIGN 
       ed-nota:READ-ONLY IN FRAME fpage5        = TRUE.

ASSIGN 
       tx-nota:READ-ONLY IN FRAME fpage5        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-canais
/* Query rebuild information for BROWSE br-canais
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-canal.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-canais */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-conta-corrente
/* Query rebuild information for BROWSE br-conta-corrente
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-conta-corrente BY tt-conta-corrente.dt-periodo-ini.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-conta-corrente */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-movimentos
/* Query rebuild information for BROWSE br-movimentos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME}
    FOR EACH int-solicitacao NO-LOCK
        WHERE int-solicitacao.CodigoConta                  = tt-conta-corrente.guid-canal
          AND int-solicitacao.CodigoUnidadeNegocio         = tt-conta-corrente.unid-neg
          AND int-solicitacao.tipo-beneficio               = tt-conta-corrente.tipo-beneficio
          AND int-solicitacao.dt-periodo-ini               = tt-conta-corrente.dt-periodo-ini
          AND int-solicitacao.dt-periodo-fim               = tt-conta-corrente.dt-periodo-fim
           BY int-solicitacao.DataCriacao
           BY int-solicitacao.hora-trans.
          /*AND int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004:*/ /* Pago */
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-movimentos */
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


&Scoped-define BROWSE-NAME br-canais
&Scoped-define SELF-NAME br-canais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-canais w-cadsim
ON MOUSE-SELECT-CLICK OF br-canais IN FRAME f-cad /* Canais */
DO:
  RUN pi-carrega-cc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-canais w-cadsim
ON VALUE-CHANGED OF br-canais IN FRAME f-cad /* Canais */
DO: 

    RUN pi-carrega-cc.
    RUN pi-carrega-detalhes.
/*     RUN pi-carrega-transf-origem. */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-conta-corrente
&Scoped-define SELF-NAME br-conta-corrente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-conta-corrente w-cadsim
ON MOUSE-SELECT-CLICK OF br-conta-corrente IN FRAME f-cad /* Conta Corrente Benef°cios */
DO:
  RUN pi-carrega-detalhes. 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-conta-corrente w-cadsim
ON MOUSE-SELECT-DBLCLICK OF br-conta-corrente IN FRAME f-cad /* Conta Corrente Benef°cios */
DO:

    IF  NOT AVAIL tt-conta-corrente THEN
        RETURN NO-APPLY.

    ASSIGN r-row-canal = ?
           r-row-cc    = tt-conta-corrente.r-rowid.

    RUN esp/esb/esesb008f.w.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-conta-corrente w-cadsim
ON ROW-DISPLAY OF br-conta-corrente IN FRAME f-cad /* Conta Corrente Benef°cios */
DO:
  /*(RUN pi-display-nota-importante.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-conta-corrente w-cadsim
ON START-SEARCH OF br-conta-corrente IN FRAME f-cad /* Conta Corrente Benef°cios */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-conta-corrente w-cadsim
ON VALUE-CHANGED OF br-conta-corrente IN FRAME f-cad /* Conta Corrente Benef°cios */
DO: 
    RUN pi-carrega-detalhes. 
    RUN pi-carrega-movimentos. 
    RUN pi-carrega-transf-origem.
    RUN pi-mostra-totais-solicitacao.

    IF  AVAIL tt-conta-corrente THEN
        RUN pi-seta-status-crm-em-tela (INPUT tt-conta-corrente.status-crm).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-movimentos
&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME br-movimentos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-movimentos w-cadsim
ON MOUSE-SELECT-DBLCLICK OF br-movimentos IN FRAME fpage5 /* Solicitaá‰es Vinculadas a conta corrente */
DO:
    IF  NOT AVAIL int-solicitacao THEN
        RETURN.

    IF  int-solicitacao.log-historica THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Solicitaá∆o foi migrada para outro trimestre. ~~" +
                          "A solicitaá∆o selecionada existe apenas para hist¢rico neste trimestre. " +
                          "A solicitaá∆o original foi transferida (empenhada) para trimestre seguinte.").
        RETURN NO-APPLY.
    END.

    ASSIGN gr-solicitacao = ROWID(int-solicitacao).
    RUN esp/es5602.w.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-movimentos w-cadsim
ON ROW-DISPLAY OF br-movimentos IN FRAME fpage5 /* Solicitaá‰es Vinculadas a conta corrente */
DO:
   
/*     i-cor = 9.                                                                  */
/*                                                                                 */
/*     CASE int-cc-benef-movto.transacao:                                          */
/*         WHEN 1 THEN i-cor = 12.                                                 */
/*         WHEN 2 THEN i-cor = 9.                                                  */
/*         WHEN 3 THEN DO:                                                         */
/*            IF  int-cc-benef-movto.hist-automatico MATCHES "*a menor*" THEN      */
/*                i-cor = 12.  /* vermelho */                                      */
/*            ELSE                                                                 */
/*                i-cor = 9.   /* azul */                                          */
/*         END.                                                                    */
/*     END CASE.                                                                   */
/*                                                                                 */
/*     ASSIGN int-cc-benef-movto.vl-movto:FGCOLOR IN BROWSE br-movimentos = i-cor. */
/*                                                                                 */

    
 
 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-movimentos w-cadsim
ON VALUE-CHANGED OF br-movimentos IN FRAME fpage5 /* Solicitaá‰es Vinculadas a conta corrente */
DO:

    /*
    RUN pi-display-nota-importante.
    */

/*   IF  NOT AVAIL int-cc-benef-movto THEN DO:                                  */
/*       DO WITH FRAME fpage5:                                                  */
/*        ASSIGN ed-hist-movto:SCREEN-VALUE = ""                                */
/*               ed-hist-user:SCREEN-VALUE  = "".                               */
/*       END.                                                                   */
/*       RETURN "OK".                                                           */
/*   END.                                                                       */
/*                                                                              */
/*                                                                              */
/*   DO WITH FRAME fpage5:                                                      */
/*      ASSIGN ed-hist-movto:SCREEN-VALUE = int-cc-benef-movto.hist-automatico  */
/*             ed-hist-user:SCREEN-VALUE  = int-cc-benef-movto.hist-usuario.    */
/*   END.                                                                       */
/*                                                                              */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME bt-ajustes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajustes w-cadsim
ON CHOOSE OF bt-ajustes IN FRAME f-cad
DO:

    DEF VAR l-ok AS LOGICAL NO-UNDO.
    DEF VAR r-row-conta AS ROWID NO-UNDO.

    IF  NOT AVAIL tt-conta-corrente THEN
        RETURN NO-APPLY.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
   
    ASSIGN r-row-conta = ROWID(tt-conta-corrente).
    RUN esp/esb/esesb008c.w (INPUT tt-conta-corrente.r-rowid,
                             OUTPUT l-ok).
   
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    IF  l-ok THEN DO:
        APPLY "VALUE-CHANGED" TO br-canais IN FRAME f-cad.

        REPOSITION br-conta-corrente TO ROWID r-row-conta.
        APPLY "value-changed"        TO br-conta-corrente IN FRAME f-cad.
        APPLY "row-display"          TO br-conta-corrente IN FRAME f-cad.
    END.
  
    RETURN "OK".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME bt-detalha-solicitacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalha-solicitacao w-cadsim
ON CHOOSE OF bt-detalha-solicitacao IN FRAME fpage5
DO:
    IF  NOT AVAIL int-solicitacao THEN
        RETURN.
    
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    ASSIGN gr-solicitacao = ROWID(int-solicitacao).
    RUN esp/es5602.w.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exit w-cadsim
ON CHOOSE OF bt-exit IN FRAME f-cad
DO:
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-expande
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-expande w-cadsim
ON CHOOSE OF bt-expande IN FRAME f-cad /* Button 1 */
DO:
    DO WITH FRAME f-cad:
    
        IF  br-conta-corrente:ROW = 2.75 THEN DO:
            ASSIGN br-conta-corrente:ROW    = 7.25
                   br-conta-corrente:HEIGHT = 5.5
                   bt-expande:ROW           = 7.29
                   bt-expande:TOOLTIP       = "Expandir".

            bt-expande:LOAD-IMAGE("adeicon/psend.bmp").
        END.
        ELSE DO:
            ASSIGN br-conta-corrente:ROW = 2.75
                   br-conta-corrente:HEIGHT = 10
                   bt-expande:ROW           = 2.79
                   bt-expande:TOOLTIP       = "Retrair".

            bt-expande:LOAD-IMAGE("adeicon/cbbtn.bmp").
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exporta-ContaCorrente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exporta-ContaCorrente w-cadsim
ON CHOOSE OF bt-exporta-ContaCorrente IN FRAME f-cad
DO:

    RUN pi-gera-excel-cc.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME bt-exporta-ContaCorrente-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exporta-ContaCorrente-2 w-cadsim
ON CHOOSE OF bt-exporta-ContaCorrente-2 IN FRAME fpage5
DO:

    RUN pi-gera-excel-solicitacao.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME bt-goto-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-goto-emitente w-cadsim
ON CHOOSE OF bt-goto-emitente IN FRAME f-cad
DO:

   RUN pi-busca-canal.
   IF  RETURN-VALUE <> "OK" THEN
       RETURN "OK".

   FIND FIRST b-tt-canal
       WHERE b-tt-canal.canal = emitente.cod-emitente NO-ERROR.

   IF  NOT AVAIL b-tt-canal THEN DO:
       RUN utp/ut-msgs.p(input "show":U, 
                         input 17006,
                         input "Cliente n∆o possui registro de conta corrente no programa de benef°cios de canais.").
       APPLY "entry" TO fi-canal IN FRAME f-cad.
       RETURN NO-APPLY.
   END.
 
   ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad = emitente.nome-emit.
   
   REPOSITION br-canais TO ROWID ROWID(b-tt-canal).
   APPLY "value-changed" TO br-canais IN FRAME f-cad.
   APPLY "row-display" TO br-canais IN FRAME f-cad.
  
   RETURN "OK".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-novo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-novo w-cadsim
ON CHOOSE OF bt-novo IN FRAME f-cad
DO:

    DEF VAR l-ok       AS LOGICAL INIT NO NO-UNDO.
    DEF VAR r-row-novo AS ROWID NO-UNDO.
    DEF VAR i-canal    AS INTEGER NO-UNDO.
    DEF BUFFER b-tt-conta-corrente FOR tt-conta-corrente.
    DEF BUFFER b-tt-canal FOR tt-canal.
    DEF BUFFER b-int-cc-benef-aux FOR int-cc-benef.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
   
    IF  AVAIL tt-canal THEN
        ASSIGN i-canal = tt-canal.canal.
        
    /* Criaá∆o de conta corrente via solicitaá∆o Manual */
    RUN esp/esb/esesb008e.w (INPUT  i-canal,
                             OUTPUT r-row-novo,
                             OUTPUT l-ok).
   
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    IF  l-ok THEN DO:

        FIND FIRST b-int-cc-benef-aux
            WHERE rowid(b-int-cc-benef-aux) = r-row-novo NO-LOCK.

        IF  AVAIL b-int-cc-benef-aux  THEN DO:
            /* REPOSICIONA NO CANAL DA CONTA QUE ACABA DE SER CRIADA */
            IF  NOT AVAIL tt-canal THEN DO:
                RUN pi-carrega-canais.

                FIND FIRST b-tt-canal
                    WHERE b-tt-canal.canal = b-int-cc-benef-aux.canal NO-ERROR.

                IF  AVAIL b-tt-canal THEN DO:
                    REPOSITION br-canais TO ROWID ROWID(b-tt-canal).
                    APPLY "value-changed" TO br-canais IN FRAME f-cad.
                    APPLY "row-display" TO br-canais IN FRAME f-cad.
                END.
                
            END.


            IF  b-int-cc-benef-aux.tp-movto = 1 THEN
                tt-param.l-provisao = YES. /*Precisa para poder carregar as provis‰es para o reposition*/

            RUN pi-carrega-cc.

            FIND FIRST b-tt-conta-corrente
                WHERE b-tt-conta-corrente.r-rowid = r-row-novo NO-ERROR.
    
            REPOSITION br-conta-corrente TO ROWID ROWID(b-tt-conta-corrente).
            APPLY "value-changed"        TO br-conta-corrente IN FRAME f-cad.
            APPLY "row-display"          TO br-conta-corrente IN FRAME f-cad.
        END.
    END.
  
    RETURN "OK".

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


&Scoped-define SELF-NAME bt-param-cc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-param-cc w-cadsim
ON CHOOSE OF bt-param-cc IN FRAME f-cad
DO:
  ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
  RUN esp/esb/esesb008a.w (INPUT-OUTPUT TABLE tt-param).
  ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

  FIND FIRST tt-param NO-ERROR.
  IF  tt-param.l-ok THEN
      RUN pi-carrega-cc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-relatorio-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-relatorio-2 w-cadsim
ON CHOOSE OF bt-relatorio-2 IN FRAME f-cad
DO:
    DEF VAR c-arquivo AS CHAR NO-UNDO.
    DEF VAR i-canal           AS INTEGER NO-UNDO.
    DEF VAR c-nome-abrev      AS CHAR    NO-UNDO.
    DEF VAR c-cgc             AS CHAR    NO-UNDO.
    DEF VAR c-nome            AS CHAR    NO-UNDO.
    DEF VAR i-beneficio       AS INTEGER NO-UNDO.
    DEF VAR c-beneficio       AS CHAR    NO-UNDO.
    DEF VAR c-unidade         AS CHAR    NO-UNDO.
    DEF VAR c-class           AS CHAR    NO-UNDO.
    DEF VAR c-categoria       AS CHAR    NO-UNDO.
    DEF VAR de-custo          AS DEC     NO-UNDO.
    DEF VAR de-benef          AS DEC     NO-UNDO.
    DEF VAR de-verba          AS DEC     NO-UNDO.
    DEF VAR de-origem-tit     AS DEC     NO-UNDO.
    DEF VAR de-tit            AS DEC     NO-UNDO.
    DEF VAR de-solicitado     AS DEC     NO-UNDO.
    DEF VAR de-pendente       AS DEC     NO-UNDO.
    DEF VAR de-pago           AS DEC     NO-UNDO.
    DEF VAR de-disponivel     AS DEC     NO-UNDO.
    DEF VAR c-user-alte       AS CHAR    NO-UNDO.
    DEF VAR c-user-reat       AS CHAR    NO-UNDO.
    DEF VAR c-natureza        AS CHAR    NO-UNDO.
    DEF VAR c-sit-ped         AS CHAR    NO-UNDO.
    DEF VAR c-nr-ped          AS CHAR    NO-UNDO.
    DEF VAR de-liq            AS DEC     NO-UNDO.
    DEF VAR de-tot-ped        AS DEC     NO-UNDO.
    DEF VAR da-solicitacao    AS DATE    NO-UNDO.
    DEF VAR c-hora            AS CHAR    NO-UNDO.
    DEF VAR l-enviado         AS LOG     NO-UNDO.
    DEF VAR c-situacao        AS CHAR    NO-UNDO.
    DEF VAR l-tem-itens       AS LOG     NO-UNDO.
    DEF VAR de-tot-analise    AS DEC     NO-UNDO.    
    DEF VAR de-tot-pendente   AS DEC     NO-UNDO.    
    DEF VAR de-tot-pagas      AS DEC     NO-UNDO.    
    DEF VAR de-tot-ajustes    AS DEC     NO-UNDO.    
    DEF VAR de-tot-geral      AS DEC     NO-UNDO.    
    DEF VAR l-tem-solicitacao AS LOG     NO-UNDO. 
    DEF VAR c-nome-nat        AS CHAR    NO-UNDO.
    DEF VAR de-abatido-apb    AS DEC     NO-UNDO.
    DEF VAR i-prioridade      AS INTEGER NO-UNDO.
    DEF VAR c-cidade          AS CHAR    NO-UNDO.
    DEF VAR c-uf              AS CHAR    NO-UNDO.
    DEF VAR c-cod-estabel     AS CHAR    NO-UNDO.
    DEF VAR l-ok              AS LOG     NO-UNDO.


    DEF VAR h-acomp           AS HANDLE  NO-UNDO.

    IF  NOT VALID-HANDLE(h-acomp) THEN                                  
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      
    IF  VALID-HANDLE(h-acomp) THEN                                      
        RUN pi-inicializar IN h-acomp (INPUT "Relat¢rio Contas X Solicitaá‰es").

    ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "Saldo_Contas_Correntes_" + STRING(TODAY, "99-99-9999") + "_"+ STRING(TIME) + ".csv".

    OUTPUT STREAM s-1 TO value(c-arquivo) CONVERT TARGET "iso8859-1".

    PUT STREAM s-1 "Canal;NomeAbrev;CGC;Nome;Cidade;UF;Tp Benef;Benef°cio;Unidade;Classif;Categoria;%Custo;%Benf°cio;VERBA INICIAL;Verba Dispon°vel;Saldo APB Original;Saldo APB Atual;Situaá∆o;Data;Hora;Solicitado;Abatido T°tulo;Sit Pedido;Estab;NrPedido;Prioridade;Natureza;Desriá∆o;ÈLT Alteraá∆o;Reativaá∆o;Liq.Pedido;Tot.Pedido;Enviado CRM" SKIP.

    FOR EACH int-cc-benef NO-LOCK
        WHERE int-cc-benef.unid-neg       >= tt-param.c-unid-ini
          AND int-cc-benef.unid-neg       <= tt-param.c-unid-fim
          AND int-cc-benef.dt-periodo-ini >= tt-param.da-periodo-ini
          AND int-cc-benef.dt-periodo-fim <= tt-param.da-periodo-fim
          AND int-cc-benef.dt-transacao   >= tt-param.da-trans-ini
          AND int-cc-benef.dt-transacao   <= tt-param.da-trans-fim
          AND int-cc-benef.dt-vencimento  >= tt-param.da-vencto-ini
          AND int-cc-benef.dt-vencimento  <= tt-param.da-vencto-fim
        ,FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = int-cc-benef.canal:

        IF NOT tt-param.l-provisao         AND int-cc-benef.tp-movto       = 1                  THEN NEXT.  
        IF NOT tt-param.l-despesa          AND int-cc-benef.tp-movto       = 2                  THEN NEXT.
        IF NOT tt-param.l-rebate           AND int-cc-benef.tipo-beneficio = 37                 THEN NEXT.
        IF NOT tt-param.l-rebate-pos       AND int-cc-benef.tipo-beneficio = 66                 THEN NEXT.
        IF NOT tt-param.l-vmc              AND int-cc-benef.tipo-beneficio = 21                 THEN NEXT.
        IF NOT tt-param.l-stock            AND int-cc-benef.tipo-beneficio = 22                 THEN NEXT.
        IF NOT tt-param.l-backup           AND int-cc-benef.tipo-beneficio = 04                 THEN NEXT.
        IF NOT tt-param.l-showroom         AND int-cc-benef.tipo-beneficio = 15                 THEN NEXT.
        IF NOT tt-param.l-price            AND int-cc-benef.tipo-beneficio = 08                 THEN NEXT.
        IF NOT tt-param.l-ouro             AND int-cc-benef.categoria      = "OURO"             THEN NEXT.
        IF NOT tt-param.l-prata            AND int-cc-benef.categoria      = "PRATA"            THEN NEXT.
        IF NOT tt-param.l-bronze           AND int-cc-benef.categoria      = "BRONZE"           THEN NEXT.
        IF NOT tt-param.l-distribuidor     AND int-cc-benef.categoria      = "DISTRIBUIDOR"     THEN NEXT.
        IF NOT tt-param.l-Revenda-Solucoes AND int-cc-benef.categoria      = "REVENDA SOLUCOES" THEN NEXT.
        IF NOT tt-param.l-Provedores       AND int-cc-benef.categoria      = "PROVEDORES"       THEN NEXT.
        IF NOT tt-param.l-ativo            AND int-cc-benef.id-status       = 1                 THEN NEXT.
        IF NOT tt-param.l-finalizado       AND int-cc-benef.id-status       = 2                 THEN NEXT.

        FIND FIRST tit_ap NO-LOCK
            WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab
              AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.
    
        ASSIGN i-canal        = 0          
               c-nome-abrev   = ""         
               c-cgc          = ""         
               c-nome         = ""         
               i-beneficio    = 0          
               c-beneficio    = ""         
               c-unidade      = ""         
               c-class        = ""         
               c-categoria    = ""         
               de-custo       = 0          
               de-benef       = 0          
               de-verba       = 0          
               de-origem-tit  = 0          
               de-tit         = 0          
               c-situacao     = ""         
               da-solicitacao = ?          
               c-hora         = "00:00:00" 
               de-solicitado  = 0          
               de-pendente    = 0          
               de-pago        = 0          
               de-disponivel  = 0          
               c-sit-ped      = ""         
               c-nr-ped       = ""         
               c-natureza     = "" 
               c-nome-nat     = ""
               c-user-alte    = ""         
               c-user-reat    = ""         
               de-liq         = 0          
               de-tot-ped     = 0          
               l-enviado      = NO
               de-abatido-apb = 0
               i-prioridade   = ?
               c-cod-estabel  = ""
               c-cidade       = ""
               c-uf           = ""
               l-ok           = NO.        
    
        RUN pi-acompanhar IN h-acomp (INPUT "Gerando Relat. Contas X Solicitaá‰es...").


        ASSIGN l-ok = NO.
        RUN esp/esb/esesbapi013-saldo.p (INPUT int-cc-benef.canal,
                                         INPUT int-cc-benef.tipo-beneficio,
                                         INPUT int-cc-benef.unid-neg,
                                         INPUT int-cc-benef.dt-periodo-ini,
                                         INPUT int-cc-benef.dt-periodo-fim,
                                         INPUT ?,
                                         INPUT ?,
                                         OUTPUT l-ok,
                                         OUTPUT TABLE tt-saldo,
                                         OUTPUT TABLE tt-erro).

        IF  RETURN-VALUE <> "OK" OR NOT l-ok 
        THEN DO:
            NEXT.
        END.

        FIND FIRST tt-saldo NO-ERROR.
        IF  NOT AVAIL tt-saldo THEN
            NEXT.

        ASSIGN  i-canal       = int-cc-benef.canal
                c-nome-abrev  = emitente.nome-abrev
                c-cgc         = emitente.cgc
                c-nome        = emitente.nome-emit
                i-beneficio   = int-cc-benef.tipo-beneficio
                c-beneficio   = fnBeneficio(int-cc-benef.tipo-beneficio) 
                c-unidade     = upper(int-cc-benef.unid-neg)
                c-class       = int-cc-benef.classific
                c-categoria   = int-cc-benef.categoria   
                de-custo      = int-cc-benef.perc-custo
                de-benef      = int-cc-benef.perc-benef
                de-verba      = tt-saldo.VerbaTotal - tt-saldo.VerbaCancelada + tt-saldo.VerbaAjustada
                de-tit        = (IF  NOT AVAIL tit_ap THEN 0 ELSE tit_ap.val_sdo_tit_ap)
                de-origem-tit = (IF  NOT AVAIL tit_ap THEN 0 ELSE tit_ap.val_origin_tit_ap)
                c-cidade      = emitente.cidade
                c-uf          = emitente.estado.
    
        ASSIGN de-tot-analise    = 0
               de-tot-pendente   = 0
               de-tot-pagas      = 0
               de-tot-ajustes    = 0
               de-tot-geral      = 0
               l-tem-solicitacao = NO.

        /*ASSIGN de-disponivel = int-cc-benef.vl-saldo .*/
        
        ASSIGN de-disponivel = tt-saldo.VerbaDisponivel.
        
        FOR EACH int-solicitacao NO-LOCK                                                          
            WHERE int-solicitacao.CodigoConta                  = int-cc-benef.guid-canal     
              AND int-solicitacao.CodigoUnidadeNegocio         = int-cc-benef.unid-neg       
              AND int-solicitacao.tipo-beneficio               = int-cc-benef.tipo-beneficio 
              AND int-solicitacao.dt-periodo-ini               = int-cc-benef.dt-periodo-ini 
              AND int-solicitacao.dt-periodo-fim               = int-cc-benef.dt-periodo-fim
              AND NOT int-solicitacao.Ajuste:

           ASSIGN l-tem-solicitacao = YES.

           CASE  int-solicitacao.SituacaoSolicitacaoBeneficio:
                 WHEN  993520003 THEN ASSIGN c-situacao       = "Pendente"
                                             de-pendente      = int-solicitacao.ValorSolicitado.
                 WHEN  993520004 THEN ASSIGN c-situacao       = "Paga"
                                             de-pago          = int-solicitacao.ValorSolicitado.
                 WHEN  993520006 THEN ASSIGN c-situacao       = "Cancelada".
                 OTHERWISE 
                     ASSIGN c-situacao       = "Aprovada"
                                             de-tot-analise   = int-solicitacao.ValorSolicitado.
            END CASE.

            ASSIGN da-solicitacao = int-solicitacao.DataCriacao
                   c-hora         = int-solicitacao.hora-trans
                   de-solicitado  = int-solicitacao.ValorSolicitado
                   de-pendente    = de-tot-pendente
                   l-enviado      = int-solicitacao.log-enviada /* Dispon°vel */
                   de-abatido-apb = int-solicitacao.ValorSolicitado * de-custo / 100.

            ASSIGN l-tem-itens = NO.
            IF  int-solicitacao.desc-forma-pagto = "Produto" 
            AND NOT int-solicitacao.Ajuste THEN
                FOR EACH int-solicitacao-item NO-LOCK
                    WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = int-solicitacao.CodigoSolicitacaoBeneficio
                    ,FIRST ped-venda NO-LOCK
                        WHERE ped-venda.nome-abrev = int-solicitacao-item.nome-abrev
                          AND ped-venda.nr-pedcli  = int-solicitacao-item.nr-pedcli
                    BREAK BY ped-venda.nome-abrev 
                          BY ped-venda.nr-pedcli:

                    IF  FIRST-OF (ped-venda.nr-pedcli) THEN DO:
                        ASSIGN c-natureza    = ped-venda.nat-operacao
                               c-sit-ped     = fnSitPedido(ped-venda.cod-sit-ped)
                               c-nr-ped      = ped-venda.nr-pedcli
                               c-user-alte   = ped-venda.user-alte
                               c-user-reat   = ped-venda.user-reat
                               de-liq        = ped-venda.vl-liq-ped
                               de-tot-ped    = ped-venda.vl-tot-ped
                               i-prioridade  = ped-venda.cod-priori
                               c-cod-estabel = ped-venda.cod-estabel.

                         FIND natur-oper NO-LOCK
                              WHERE natur-oper.nat-operacao = ped-venda.nat-operacao NO-ERROR.
                         IF  AVAIL natur-oper THEN
                             ASSIGN c-nome-nat = natur-oper.denominacao.
                         
                         EXPORT STREAM s-1 DELIMITER ";" i-canal c-nome-abrev c-cgc c-nome c-cidade c-uf i-beneficio c-beneficio c-unidade c-class c-categoria de-custo de-benef de-verba de-disponivel de-origem-tit de-tit c-situacao 
                              da-solicitacao c-hora de-solicitado de-abatido-apb c-sit-ped c-cod-estabel c-nr-ped i-prioridade c-natureza c-nome-nat c-user-alte c-user-reat de-liq  de-tot-ped l-enviado.
                    END.


                    ASSIGN l-tem-itens = YES.
                END.
        END.

        IF  NOT l-tem-solicitacao THEN DO:
            ASSIGN de-disponivel = de-verba.
            EXPORT STREAM s-1 DELIMITER ";" i-canal c-nome-abrev c-cgc c-nome c-cidade c-uf i-beneficio c-beneficio c-unidade c-class c-categoria de-custo de-benef de-verba de-disponivel de-origem-tit de-tit c-situacao 
                da-solicitacao c-hora de-solicitado de-abatido-apb c-sit-ped c-cod-estabel c-nr-ped i-prioridade c-natureza c-user-alte c-user-reat de-liq  de-tot-ped l-enviado.
        END.    

    
        PUT SKIP.
    
    END.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM s-1 CLOSE.

    DOS SILENT START excel VALUE(c-arquivo).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-relatorio1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-relatorio1 w-cadsim
ON CHOOSE OF bt-relatorio1 IN FRAME f-cad
DO:
    DEF VAR c-arquivo AS CHAR NO-UNDO.
    DEF VAR i-canal           AS INTEGER NO-UNDO.
    DEF VAR c-nome-abrev      AS CHAR    NO-UNDO.
    DEF VAR c-cgc             AS CHAR    NO-UNDO.
    DEF VAR c-nome            AS CHAR    NO-UNDO.
    DEF VAR i-beneficio       AS INTEGER NO-UNDO.
    DEF VAR c-beneficio       AS CHAR    NO-UNDO.
    DEF VAR c-unidade         AS CHAR    NO-UNDO.
    DEF VAR c-class           AS CHAR    NO-UNDO.
    DEF VAR c-categoria       AS CHAR    NO-UNDO.
    DEF VAR de-custo          AS DEC     NO-UNDO.
    DEF VAR de-benef          AS DEC     NO-UNDO.
    DEF VAR de-verba          AS DEC     NO-UNDO.
    DEF VAR de-origem-tit     AS DEC     NO-UNDO.
    DEF VAR de-tit            AS DEC     NO-UNDO.
    DEF VAR de-verba-ori      AS DEC     NO-UNDO.
    DEF VAR de-val-empenhado  AS DEC     NO-UNDO.
    DEF VAR de-val-realizado  AS DEC     NO-UNDO.
    DEF VAR de-val-disponivel AS DEC     NO-UNDO.
    DEF VAR h-acomp           AS HANDLE  NO-UNDO.
    DEF VAR c-status          AS CHAR FORMAT "x(10)" NO-UNDO.
    DEF VAR l-ok AS LOG INIT NO NO-UNDO.

    ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "Saldo_Contas_Correntes_" + STRING(TODAY, "99-99-9999") + "_"+ STRING(TIME) + ".csv".

    OUTPUT STREAM s-1 TO value(c-arquivo) CONVERT TARGET "iso8859-1".

    PUT STREAM s-1 "Canal;NomeAbrev;Nome;Tp Benef;Benef°cio;Unidade;Per°odo Ini; Per°odo Fim;Classif;Categoria;%Custo;%Benf°cio;VerbaCalculada(1);V.Acum(2);Transf.Per.Ant(3);TOTAL(4)=(1+2+3);V.Cancelada(5);Ajustes Verba(6);Empenho em An†lise;Empenho Aprov;Empenho Total(7);Realizado(8);Sdo Dispon°vel(9)=(4-5+6-7-8);Sdo.T°t.Orig;Sdo.T°t.Atual;Situaá∆o" SKIP.
    IF  NOT VALID-HANDLE(h-acomp) THEN                                  
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      
    IF  VALID-HANDLE(h-acomp) THEN                                      
        RUN pi-inicializar IN h-acomp (INPUT "Relat¢rio Contas Correntes").

    FOR EACH int-cc-benef NO-LOCK
        WHERE int-cc-benef.unid-neg       >= tt-param.c-unid-ini
          AND int-cc-benef.unid-neg       <= tt-param.c-unid-fim
          AND int-cc-benef.dt-periodo-ini >= tt-param.da-periodo-ini
          AND int-cc-benef.dt-periodo-fim <= tt-param.da-periodo-fim
          AND int-cc-benef.dt-transacao   >= tt-param.da-trans-ini
          AND int-cc-benef.dt-transacao   <= tt-param.da-trans-fim
          AND int-cc-benef.dt-vencimento  >= tt-param.da-vencto-ini
          AND int-cc-benef.dt-vencimento  <= tt-param.da-vencto-fim
        ,FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = int-cc-benef.canal:

        IF NOT tt-param.l-provisao         AND int-cc-benef.tp-movto       = 1                  THEN NEXT.  
        IF NOT tt-param.l-despesa          AND int-cc-benef.tp-movto       = 2                  THEN NEXT.
        IF NOT tt-param.l-rebate           AND int-cc-benef.tipo-beneficio = 37                 THEN NEXT.
        IF NOT tt-param.l-rebate-pos       AND int-cc-benef.tipo-beneficio = 66                 THEN NEXT.
        IF NOT tt-param.l-vmc              AND int-cc-benef.tipo-beneficio = 21                 THEN NEXT.
        IF NOT tt-param.l-stock            AND int-cc-benef.tipo-beneficio = 22                 THEN NEXT.
        IF NOT tt-param.l-backup           AND int-cc-benef.tipo-beneficio = 04                 THEN NEXT.
        IF NOT tt-param.l-showroom         AND int-cc-benef.tipo-beneficio = 15                 THEN NEXT.
        IF NOT tt-param.l-price            AND int-cc-benef.tipo-beneficio = 08                 THEN NEXT.
        IF NOT tt-param.l-ouro             AND int-cc-benef.categoria      = "OURO"             THEN NEXT.
        IF NOT tt-param.l-prata            AND int-cc-benef.categoria      = "PRATA"            THEN NEXT.
        IF NOT tt-param.l-bronze           AND int-cc-benef.categoria      = "BRONZE"           THEN NEXT.
        IF NOT tt-param.l-distribuidor     AND int-cc-benef.categoria      = "DISTRIBUIDOR"     THEN NEXT.
        IF NOT tt-param.l-Revenda-solucoes AND int-cc-benef.categoria      = "REVENDA SOLUCOES" THEN NEXT.
        IF NOT tt-param.l-provedores       AND int-cc-benef.categoria      = "PROVEDORES"       THEN NEXT.
        IF NOT tt-param.l-ativo            AND int-cc-benef.id-status       = 1                 THEN NEXT.
        IF NOT tt-param.l-finalizado       AND int-cc-benef.id-status       = 2                 THEN NEXT.


        RUN pi-acompanhar IN h-acomp ("Gerando Relat¢rio de Contas Correntes Ativas...").

        FIND FIRST tit_ap NO-LOCK
            WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab
              AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.

        ASSIGN i-canal        = 0
               c-nome-abrev   = ""
               c-cgc          = ""
               c-nome         = ""
               i-beneficio    = 0
               c-beneficio    = ""
               c-unidade      = ""
               c-class        = ""
               c-categoria    = ""
               de-custo       = 0
               de-benef       = 0
               de-origem-tit  = 0
               de-tit         = 0.

        ASSIGN l-ok = NO.
        RUN esp/esb/esesbapi013-saldo.p (INPUT int-cc-benef.canal,
                                         INPUT int-cc-benef.tipo-beneficio,
                                         INPUT int-cc-benef.unid-neg,
                                         INPUT int-cc-benef.dt-periodo-ini,
                                         INPUT int-cc-benef.dt-periodo-fim,
                                         INPUT ?,
                                         INPUT ?,
                                         OUTPUT l-ok,
                                         OUTPUT TABLE tt-saldo,
                                         OUTPUT TABLE tt-erro).

        IF  RETURN-VALUE <> "OK" OR NOT l-ok 
        THEN DO:
            NEXT.
        END.

        FIND FIRST tt-saldo NO-ERROR.
        IF  NOT AVAIL tt-saldo THEN
            NEXT.

        ASSIGN  i-canal       = int-cc-benef.canal
                c-nome-abrev  = emitente.nome-abrev
                c-cgc         = emitente.cgc
                c-nome        = emitente.nome-emit
                i-beneficio   = int-cc-benef.tipo-beneficio
                c-beneficio   = fnBeneficio(int-cc-benef.tipo-beneficio) 
                c-unidade     = upper(int-cc-benef.unid-neg)
                c-class       = int-cc-benef.classific
                c-categoria   = int-cc-benef.categoria   
                de-custo      = int-cc-benef.perc-custo
                de-benef      = int-cc-benef.perc-benef
                de-tit        = (IF  NOT AVAIL tit_ap THEN 0 ELSE tit_ap.val_sdo_tit_ap)
                de-origem-tit = (IF  NOT AVAIL tit_ap THEN 0 ELSE tit_ap.val_origin_tit_ap)
                c-status      = IF  int-cc-benef.id-status = 1 THEN "ATIVA" ELSE "INATIVA".

        EXPORT STREAM s-1  DELIMITER ";" i-canal      
                                         c-nome-abrev 
                                         c-nome       
                                         i-beneficio  
                                         c-beneficio  
                                         c-unidade    
                                         int-cc-benef.dt-periodo-ini                             
                                         int-cc-benef.dt-periodo-fim
                                         c-class      
                                         c-categoria  
                                         de-custo     
                                         de-benef     
                                         int-cc-benef.VerbaCalculada 
                                         int-cc-benef.VerbaAcumulada
                                         int-cc-benef.VerbaPeriodoAnterior
                                        (int-cc-benef.VerbaCalculada + int-cc-benef.VerbaAcumulada + int-cc-benef.VerbaPeriodoAnterior)
                                         int-cc-benef.VerbaCancelada
                                         int-cc-benef.VerbaAjustada
                                         tt-saldo.VerbaEmpenhadaAnalise
                                         tt-saldo.VerbaEmpenhadaAprovada
                                         tt-saldo.VerbaEmpenhadaTotal
                                         tt-saldo.VerbaReembolsada
                                         tt-saldo.VerbaDisponivel
                                         de-origem-tit
                                         de-tit
                                         c-status.

        PUT SKIP.

    END.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM s-1 CLOSE.

    DOS SILENT START excel VALUE(c-arquivo).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-titulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-titulo w-cadsim
ON CHOOSE OF bt-titulo IN FRAME fPage1
DO:
  
    IF  NOT AVAIL tt-conta-corrente THEN
        RETURN NO-APPLY.

    ASSIGN v_rec_tit_ap = ?.

    FIND FIRST tit_ap NO-LOCK
        WHERE tit_ap.cod_estab     = tt-conta-corrente.cod_estab
          AND tit_ap.num_id_tit_ap = tt-conta-corrente.num_id_tit_ap NO-ERROR.
                            
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    IF  AVAIL tit_ap THEN DO:
        ASSIGN v_rec_tit_ap = RECID(tit_ap).
        RUN prgfin/apb/apb222aa.p.
    END.
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME bt-titulo-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-titulo-2 w-cadsim
ON CHOOSE OF bt-titulo-2 IN FRAME fpage5
DO:
  
    IF  NOT AVAIL tt-conta-corrente THEN
        RETURN NO-APPLY.

    ASSIGN v_rec_tit_ap = ?.

    FIND FIRST tit_ap NO-LOCK
        WHERE tit_ap.cod_estab     = tt-conta-corrente.cod_estab
          AND tit_ap.num_id_tit_ap = tt-conta-corrente.num_id_tit_ap NO-ERROR.
                            
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    IF  AVAIL tit_ap THEN DO:
        ASSIGN v_rec_tit_ap = RECID(tit_ap).
        RUN prgfin/apb/apb222aa.p.
    END.
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME fi-canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal w-cadsim
ON F5 OF fi-canal IN FRAME f-cad /* Canal */
DO:
      {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                         &campo="fi-canal"
                         &campozoom="cod-emitente"
                         &frame="f-cad"
                         &campo2="fi-nome"
                         &campozoom2="nome-emit"
                         &frame2="f-cad"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal w-cadsim
ON LEAVE OF fi-canal IN FRAME f-cad /* Canal */
DO:
    RUN pi-busca-canal.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal w-cadsim
ON MOUSE-SELECT-DBLCLICK OF fi-canal IN FRAME f-cad /* Canal */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal w-cadsim
ON RETURN OF fi-canal IN FRAME f-cad /* Canal */
DO:
    RUN pi-busca-canal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME folder-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-1 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-1 IN FRAME f-cad
DO:

  folder-4:SENSITIVE = NO.

  folder-1:LOAD-IMAGE("image/ts-up110.bmp").
  folder-4:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-5:LOAD-IMAGE("image/ts-dn110.bmp").

  VIEW FRAME fPage1.
  HIDE FRAME fPage4.
  HIDE FRAME fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME folder-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-4 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-4 IN FRAME f-cad
DO:

  folder-4:SENSITIVE = NO.

  folder-1:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-4:LOAD-IMAGE("image/ts-up110.bmp").
  folder-5:LOAD-IMAGE("image/ts-dn110.bmp").
  HIDE FRAME fPage1.
  VIEW FRAME fPage4.
  HIDE FRAME fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME folder-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-5 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-5 IN FRAME f-cad
DO:

  folder-4:SENSITIVE = NO.

  folder-1:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-5:LOAD-IMAGE("image/ts-up110.bmp").
  folder-4:LOAD-IMAGE("image/ts-dn110.bmp").
  /*HIDE FRAME fPage1.*/
  HIDE FRAME fPage4.
  VIEW FRAME fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-canais
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

fi-canal:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-cad.

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
  DISPLAY fi-canal fi-nome 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE bt-relatorio-2 bt-relatorio1 fi-canal 
         bt-exit bt-goto-emitente bt-param-cc bt-ok bt-ajustes bt-novo 
         bt-expande bt-exporta-ContaCorrente rt-button 
         Rect-Main br-canais folder-1 br-conta-corrente rt-button-2 folder-4 
         RECT-12 folder-5 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  DISPLAY fi-tp-movto fi-beneficio fi-periodo-ini fi-periodo-fim fi-unidade 
          fi-classificacao fi-categoria fi-dt-transacao fi-cod-estabel 
          fi-especie fi-serie fi-titulo fi-parcela fi-saldo fi-transacao 
          fi-vencimento fi-vl-base-calc fi-vl-custo fi-vl-ating-meta 
          fi-vl-beneficio fi-analise fi-aprovada fi-EmpenhoTotal fi-Reembolsado 
          fi-SaldoDisponivel fi-VerbaCalculada fi-VerbaAcumulada 
          fi-VerbaTransferida fi-VerbaTotal fi-VerbaCancelada fi-VerbaAjustada 
          fi-Finalizada-Stock-Rotation 
      WITH FRAME fPage1 IN WINDOW w-cadsim.
  ENABLE bt-titulo RECT-48 RECT-51 RECT-52 RECT-58 RECT-60 RECT-61 RECT-56 
         RECT-57 
      WITH FRAME fPage1 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fPage1}
  DISPLAY ed-nota tx-nota 
      WITH FRAME fpage5 IN WINDOW w-cadsim.
  ENABLE br-movimentos ed-nota bt-titulo-2 bt-detalha-solicitacao tx-nota 
      WITH FRAME fpage5 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fpage5}
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
  ASSIGN r-row-canal       = ?
         r-row-cc          = ?
         gr-solicitacao    = ?
         gr-conta-corrente = ? .

/*   IF  VALID-HANDLE(h-api) THEN */
/*       RUN pi-destroy IN h-api. */
/*                                */
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
  
  ASSIGN r-row-canal       = ?
         r-row-cc          = ?
         gr-solicitacao    = ?
         gr-conta-corrente = ? .

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

  {utp/ut9000.i "es5601" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN dispatch  IN this-procedure ('enable-fields':U).

/*   /* API DE MOVIMENTAÄ«O DA CONTA CORRENTE */             */
/*   RUN esp/esb/esesbapi003-movtos.p PERSISTENT SET h-api.  */

  CREATE tt-param.
  ASSIGN tt-param.l-provisao         = NO
         tt-param.l-despesa          = YES
         tt-param.l-rebate           = YES
         tt-param.l-rebate-pos       = YES
         tt-param.l-vmc              = YES
         tt-param.l-stock            = YES
         tt-param.l-backup           = YES
         tt-param.l-showroom         = YES
         tt-param.l-price            = YES
         tt-param.c-unid-ini         = ""                       
         tt-param.c-unid-fim         = "ZZZZZZ"
         tt-param.c-class-ini        = ""
         tt-param.c-class-fim        = "ZZZZZZZZZZZZZZZZZZZZ"
         tt-param.l-ouro             = YES
         tt-param.l-prata            = YES
         tt-param.l-bronze           = YES
         tt-param.l-ativo            = YES    
         tt-param.l-distribuidor     = YES
         tt-param.l-Revenda-Solucoes = YES
         tt-param.l-Provedores       = YES
         tt-param.l-finalizado       = NO                     
         tt-param.da-periodo-ini     = 01/01/2014        
         tt-param.da-periodo-fim     = 12/31/2099
         tt-param.da-trans-ini       = 01/01/2014        
         tt-param.da-trans-fim       = 12/31/2099
         tt-param.da-vencto-ini      = 01/01/2014        
         tt-param.da-vencto-fim      = 12/31/2099.
                                                                                                
  APPLY 'mouse-select-click' TO folder-1 IN FRAME f-cad.
  
  folder-4:VISIBLE  = FALSE.
  bt-novo:VISIBLE   = FALSE.
  bt-ajustes:VISIBLE = FALSE.

  ASSIGN bt-param-cc:SENSITIVE IN FRAME f-cad = NO.
         

  IF  gr-conta-corrente <> ? THEN 
      RUN pi-reposiciona-canal-x-cc.
  ELSE DO:
      RUN pi-carrega-canais.
      APPLY 'value-changed'      TO br-canais IN FRAME f-cad.
  END.
  
  {include/i-inifld.i}

  RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage1:HANDLE ).
  /*RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage4:HANDLE ).*/

  /*RUN pi-status-alterando (INPUT NO).*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-canal w-cadsim 
PROCEDURE pi-busca-canal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   FIND FIRST emitente 
       WHERE emitente.cod-emitente = int(fi-canal:SCREEN-VALUE IN FRAME f-cad) NO-LOCK NO-ERROR.

   IF  NOT AVAIL emitente THEN DO:
       FIND FIRST emitente
           WHERE emitente.nome-abrev = fi-canal:SCREEN-VALUE IN FRAME f-cad NO-LOCK NO-ERROR.

       IF  NOT AVAIL emitente THEN DO:
           FIND FIRST emitente
               WHERE emitente.cgc = fi-canal:SCREEN-VALUE IN FRAME f-cad NO-LOCK NO-ERROR.
           IF  NOT AVAIL emitente  THEN DO:
               RUN utp/ut-msgs.p(input "show":U, 
                                 input 17006,
                                 input "Cliente inv†lido/inexistente..").
               APPLY "entry" TO fi-canal IN FRAME f-cad.
               RETURN "NOK".
           END.
       END.
   END.

   IF  fi-canal:SCREEN-VALUE IN FRAME f-cad <> ""  THEN DO:
       FIND int-emitente NO-LOCK
           WHERE int-emitente.cod-emitente = emitente.cod-emitente.
    
       IF  int-emitente.ind-participa-canais <> 993520001  THEN DO:
           RUN utp/ut-msgs.p(input "show":U, 
                             input 17006,
                             input "Cliente n∆o participa do prograna de canais.").
           APPLY "entry" TO fi-canal IN FRAME f-cad.
           RETURN "NOK".
    
        END.
    END.    

    ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad = emitente.nome-emit.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-canais w-cadsim 
PROCEDURE pi-carrega-canais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    EMPTY TEMP-TABLE tt-canal.
    
    FOR EACH int-cc-benef NO-LOCK
        , FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = int-cc-benef.canal
            BREAK BY int-cc-benef.canal:
          
        IF  FIRST-OF (int-cc-benef.canal) THEN DO:
            CREATE tt-canal.
            ASSIGN tt-canal.canal      = emitente.cod-emitente
                   tt-canal.nome       = emitente.nome-emit
                   tt-canal.nome-abrev = emitente.nome-abrev
                   tt-canal.cgc        = emitente.cgc
                   tt-canal.r-rowid    = ROWID(emitente).
        END.
    END.

    {&open-query-br-canais}

    APPLY "value-changed" TO br-canais IN FRAME f-cad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-cc w-cadsim 
PROCEDURE pi-carrega-cc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN bt-param-cc:SENSITIVE IN FRAME f-cad = NO.
    IF  NOT AVAIL tt-canal THEN
        RETURN "OK".

    ASSIGN bt-param-cc:SENSITIVE IN FRAME f-cad = YES.
    
    DEF VAR l-ok AS LOG INIT NO NO-UNDO.

    EMPTY TEMP-TABLE tt-conta-corrente.

    FOR EACH int-cc-benef NO-LOCK
        WHERE int-cc-benef.canal           = tt-canal.canal
          AND int-cc-benef.unid-neg       >= tt-param.c-unid-ini
          AND int-cc-benef.unid-neg       <= tt-param.c-unid-fim
          AND int-cc-benef.dt-periodo-ini >= tt-param.da-periodo-ini
          AND int-cc-benef.dt-periodo-fim <= tt-param.da-periodo-fim
          AND int-cc-benef.dt-transacao   >= tt-param.da-trans-ini
          AND int-cc-benef.dt-transacao   <= tt-param.da-trans-fim
          AND int-cc-benef.dt-vencimento  >= tt-param.da-vencto-ini
          AND int-cc-benef.dt-vencimento  <= tt-param.da-vencto-fim:

        IF NOT tt-param.l-provisao         AND int-cc-benef.tp-movto       = 1                  THEN NEXT.  
        IF NOT tt-param.l-despesa          AND int-cc-benef.tp-movto       = 2                  THEN NEXT.
        IF NOT tt-param.l-rebate           AND int-cc-benef.tipo-beneficio = 37                 THEN NEXT.
        IF NOT tt-param.l-rebate-pos       AND int-cc-benef.tipo-beneficio = 66                 THEN NEXT.
        IF NOT tt-param.l-vmc              AND int-cc-benef.tipo-beneficio = 21                 THEN NEXT.
        IF NOT tt-param.l-stock            AND int-cc-benef.tipo-beneficio = 22                 THEN NEXT.
        IF NOT tt-param.l-backup           AND int-cc-benef.tipo-beneficio = 04                 THEN NEXT.
        IF NOT tt-param.l-showroom         AND int-cc-benef.tipo-beneficio = 15                 THEN NEXT.
        IF NOT tt-param.l-price            AND int-cc-benef.tipo-beneficio = 08                 THEN NEXT.
        IF NOT tt-param.l-ouro             AND int-cc-benef.categoria      = "OURO"             THEN NEXT.
        IF NOT tt-param.l-prata            AND int-cc-benef.categoria      = "PRATA"            THEN NEXT.
        IF NOT tt-param.l-bronze           AND int-cc-benef.categoria      = "BRONZE"           THEN NEXT.
        IF NOT tt-param.l-distribuidor     AND int-cc-benef.categoria      = "DISTRIBUIDOR"     THEN NEXT.
        IF NOT tt-param.l-Revenda-Solucoes AND int-cc-benef.categoria      = "REVENDA SOLUCOES" THEN NEXT.
        IF NOT tt-param.l-Provedores       AND int-cc-benef.categoria      = "PROVEDORES"       THEN NEXT.
        IF NOT tt-param.l-ativo            AND int-cc-benef.id-status       = 1                  THEN NEXT.
        IF NOT tt-param.l-finalizado       AND int-cc-benef.id-status       = 2                  THEN NEXT.
        
        CREATE tt-conta-corrente.
        BUFFER-COPY int-cc-benef TO tt-conta-corrente.

        ASSIGN tt-conta-corrente.desc-tp-movto        = fnMovto(tt-conta-corrente.tp-movto)          
               tt-conta-corrente.desc-beneficio       = fnBeneficio(tt-conta-corrente.tipo-beneficio)
               tt-conta-corrente.unid-neg             = upper(tt-conta-corrente.unid-neg)            
               tt-conta-corrente.nome-classificacao   = LOWER(int-cc-benef.classificacao)
               tt-conta-corrente.r-rowid              = ROWID(int-cc-benef)
               tt-conta-corrente.de-verbatotal        = int-cc-benef.VerbaCalculada + 
                                                        int-cc-benef.VerbaAcumulada + 
                                                        int-cc-benef.VerbaPeriodoAnterior.
               

        ASSIGN l-ok = NO.
        RUN esp/esb/esesbapi013-saldo.p (INPUT int-cc-benef.canal,
                                         INPUT int-cc-benef.tipo-beneficio,
                                         INPUT int-cc-benef.unid-neg,
                                         INPUT int-cc-benef.dt-periodo-ini,
                                         INPUT int-cc-benef.dt-periodo-fim,
                                         INPUT ?,
                                         INPUT ?,
                                         OUTPUT l-ok,
                                         OUTPUT TABLE tt-saldo,
                                         OUTPUT TABLE tt-erro).

        IF  RETURN-VALUE <> "OK" OR NOT l-ok 
        THEN DO:
            NEXT.
        END.

        FIND FIRST tt-saldo NO-ERROR.
        IF  NOT AVAIL tt-saldo THEN
            NEXT.

        ASSIGN tt-conta-corrente.de-empenhadaAnalise  = tt-saldo.VerbaEmpenhadaAnalise
               tt-conta-corrente.de-empenhadaAprovada = tt-saldo.VerbaEmpenhadaAprovada
               tt-conta-corrente.de-empenhadaTotal    = tt-saldo.VerbaEmpenhadaTotal
               tt-conta-corrente.de-Reembolsado       = tt-saldo.VerbaReembolsada
               tt-conta-corrente.de-disponivel        = tt-saldo.VerbaDisponivel.
    END.

    {&open-query-br-conta-corrente}

    APPLY "value-changed" TO br-conta-corrente IN FRAME f-cad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-detalhes w-cadsim 
PROCEDURE pi-carrega-detalhes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


IF  NOT AVAIL tt-conta-corrente THEN
    RETURN "OK".

DO WITH FRAME fpage1:


    ASSIGN fi-tp-movto:SCREEN-VALUE        = fnMovto(tt-conta-corrente.tp-movto)
           fi-beneficio:SCREEN-VALUE       = fnBeneficio(tt-conta-corrente.tipo-beneficio)
           fi-periodo-ini:SCREEN-VALUE     = string(tt-conta-corrente.dt-periodo-ini)
           fi-periodo-fim:SCREEN-VALUE     = string(tt-conta-corrente.dt-periodo-fim)
           fi-unidade:SCREEN-VALUE         = tt-conta-corrente.unid-neg
           fi-classificacao:SCREEN-VALUE   = tt-conta-corrente.nome-classificacao
           fi-categoria:SCREEN-VALUE       = tt-conta-corrente.categoria
           fi-dt-transacao:SCREEN-VALUE    = string(tt-conta-corrente.dt-transacao)
           fi-vl-ating-meta:SCREEN-VALUE   = string(tt-conta-corrente.perc-prov-meta)
           fi-vl-custo:SCREEN-VALUE        = string(tt-conta-corrente.perc-custo)
           fi-vl-beneficio:SCREEN-VALUE    = string(tt-conta-corrente.perc-benef)
           fi-vl-base-calc:SCREEN-VALUE    = string(tt-conta-corrente.vl-base-calc).

    FIND FIRST tit_ap NO-LOCK
        WHERE tit_ap.cod_estab     = tt-conta-corrente.cod_estab
          AND tit_ap.num_id_tit_ap = tt-conta-corrente.num_id_tit_ap NO-ERROR.

    IF  AVAIL tit_ap THEN DO WITH FRAME fpage1:
        ASSIGN fi-cod-estabel:SCREEN-VALUE = string(tit_ap.cod_estab        ) 
               fi-serie:SCREEN-VALUE       = string(tit_ap.cod_ser_docto    ) 
               fi-parcela:SCREEN-VALUE     = string(tit_ap.cod_parcela      ) 
               fi-especie:SCREEN-VALUE     = string(tit_ap.cod_espec_docto  ) 
               fi-titulo:SCREEN-VALUE      = string(tit_ap.cod_tit_ap       ) 
               fi-transacao:SCREEN-VALUE   = string(tit_ap.dat_transacao     , "99/99/9999") 
               fi-vencimento:SCREEN-VALUE  = string(tit_ap.dat_vencto_tit_ap , "99/99/9999") 
               fi-saldo:SCREEN-VALUE       = string(tit_ap.val_sdo_tit_ap    , "->>>,>>>,>>9.99").
    END.
    ELSE DO WITH FRAME fpage1:
        ASSIGN fi-cod-estabel:SCREEN-VALUE = ""
               fi-serie:SCREEN-VALUE       = ""
               fi-parcela:SCREEN-VALUE     = "" 
               fi-especie:SCREEN-VALUE     = ""
               fi-titulo:SCREEN-VALUE      = ""
               fi-transacao:SCREEN-VALUE   = ""
               fi-vencimento:SCREEN-VALUE  = ""
               fi-saldo:SCREEN-VALUE       = "".
    END.

    ASSIGN  fi-VerbaCalculada:SCREEN-VALUE            = STRING(tt-conta-corrente.VerbaCalculada)
            fi-VerbaAcumulada:SCREEN-VALUE            = STRING(tt-conta-corrente.VerbaAcumulada)
            fi-VerbaTransferida:SCREEN-VALUE          = STRING(tt-conta-corrente.VerbaPeriodoAnterior)
            fi-VerbaCancelada:SCREEN-VALUE            = STRING(tt-conta-corrente.VerbaCancelada)
            fi-VerbaAjustada:SCREEN-VALUE             = STRING(tt-conta-corrente.VerbaAjustada)
            fi-VerbaTotal:SCREEN-VALUE                = STRING(tt-conta-corrente.VerbaCalculada +     
                                                               tt-conta-corrente.VerbaAcumulada +     
                                                               tt-conta-corrente.VerbaPeriodoAnterior)
            fi-analise:SCREEN-VALUE                   = string(tt-conta-corrente.de-empenhadaAnalise)
            fi-aprovada:SCREEN-VALUE                  = string(tt-conta-corrente.de-empenhadaAprovada)
                                                      
            fi-EmpenhoTotal:SCREEN-VALUE              = string(tt-conta-corrente.de-empenhadaTotal)
                                                      
            fi-Reembolsado:SCREEN-VALUE               = string(tt-conta-corrente.de-Reembolsado)
            fi-Finalizada-Stock-Rotation:SCREEN-VALUE = string(tt-conta-corrente.Descarte-Stock-Rotation)
            fi-SaldoDisponivel:SCREEN-VALUE           = string(tt-conta-corrente.de-disponivel).  

        
    ASSIGN tx-nota:VISIBLE  IN FRAME fpage5 = NO
           tx-nota:SCREEN-VALUE  IN FRAME fpage5 = ""
           ed-nota:VISIBLE  IN FRAME fpage5 = NO
           ed-nota:SCREEN-VALUE IN FRAME fpage5 = "".

END.

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-movimentos w-cadsim 
PROCEDURE pi-carrega-movimentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&open-query-br-movimentos}

    APPLY "value-changed" TO br-movimentos IN FRAME fpage5.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-transf-destino w-cadsim 
PROCEDURE pi-carrega-transf-destino :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*     EMPTY TEMP-TABLE tt-cc-transf-dest.                                        */
/*                                                                                */
/*     IF  NOT AVAIL tt-cc-transf THEN                                            */
/*         RETURN "OK".                                                           */
/*                                                                                */
/*     FOR EACH int-cc-benef NO-LOCK                                              */
/*         WHERE int-cc-benef.canal    = tt-cc-transf.canal                       */
/*           AND int-cc-benef.tp-movto = 2                                        */
/*           AND ROWID(int-cc-benef) <> tt-cc-transf.r-rowid :                    */
/*                                                                                */
/*         CREATE tt-cc-transf-dest.                                              */
/*         ASSIGN tt-cc-transf-dest.canal          = int-cc-benef.canal           */
/*                tt-cc-transf-dest.tipo-beneficio = int-cc-benef.tipo-beneficio  */
/*                tt-cc-transf-dest.unid-neg       = int-cc-benef.unid-neg        */
/*                tt-cc-transf-dest.dt-periodo-ini = int-cc-benef.dt-periodo-ini  */
/*                tt-cc-transf-dest.dt-periodo-fim = int-cc-benef.dt-periodo-fim  */
/*                tt-cc-transf-dest.dt-periodo-ini = int-cc-benef.dt-periodo-ini  */
/*                tt-cc-transf-dest.vl-saldo       = int-cc-benef.vl-saldo        */
/*                tt-cc-transf-dest.r-rowid        = ROWID(int-cc-benef).         */
/*     END.                                                                       */
/*                                                                                */
/*     {&open-query-br-destino}                                                   */
/*                                                                                */
/*     APPLY "value-changed" TO br-destino IN FRAME fpage4.                       */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-transf-origem w-cadsim 
PROCEDURE pi-carrega-transf-origem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*     EMPTY TEMP-TABLE tt-cc-transf.                                                      */
/*                                                                                         */
/*     IF  NOT AVAIL tt-canal THEN                                                         */
/*         RETURN "OK".                                                                    */
/*                                                                                         */
/*     IF  NOT AVAIL tt-conta-corrente THEN                                                */
/*         RETURN "OK".                                                                    */
/*                                                                                         */
/*     IF  tt-conta-corrente.tp-movto <> 2                                                 */
/*     OR  tt-conta-corrente.id-status <> 1                                                */
/*     OR  tt-conta-corrente.tipo-beneficio <> 21 THEN                                     */
/*         RETURN "OK".                                                                    */
/*                                                                                         */
/*     FIND FIRST int-cc-benef NO-LOCK                                                     */
/*         WHERE int-cc-benef.tp-movto       = tt-conta-corrente.tp-movto                  */
/*           AND int-cc-benef.canal          = tt-conta-corrente.canal                     */
/*           AND int-cc-benef.unid-neg       = tt-conta-corrente.unid-neg                  */
/*           AND int-cc-benef.tipo-beneficio = tt-conta-corrente.tipo-beneficio            */
/*           AND int-cc-benef.dt-periodo-ini = tt-conta-corrente.dt-periodo-ini            */
/*           AND int-cc-benef.dt-periodo-fim = tt-conta-corrente.dt-periodo-fim NO-ERROR.  */
/*     IF  NOT AVAIL int-cc-benef THEN                                                     */
/*         RETURN "OK".                                                                    */
/*                                                                                         */
/*     CREATE tt-cc-transf.                                                                */
/*     ASSIGN tt-cc-transf.canal          = tt-conta-corrente.canal                        */
/*            tt-cc-transf.tipo-beneficio = tt-conta-corrente.tipo-beneficio               */
/*            tt-cc-transf.unid-neg       = tt-conta-corrente.unid-neg                     */
/*            tt-cc-transf.dt-periodo-ini = tt-conta-corrente.dt-periodo-ini               */
/*            tt-cc-transf.dt-periodo-fim = tt-conta-corrente.dt-periodo-fim               */
/*            tt-cc-transf.vl-saldo       = tt-conta-corrente.vl-saldo                     */
/*            tt-cc-transf.r-rowid        = rowid(int-cc-benef).                           */
/*                                                                                         */
/*                                                                                         */
/* /*     FOR EACH int-cc-benef NO-LOCK                                         */         */
/* /*         WHERE int-cc-benef.canal          = tt-canal.canal                */         */
/* /*           AND int-cc-benef.tp-movto       = 2                             */         */
/* /*           AND int-cc-benef.id-status      = 2 /*Liberado */               */         */
/* /*           AND int-cc-benef.tipo-beneficio = 21:                           */         */
/* /*                                                                           */         */
/* /*         CREATE tt-cc-transf.                                              */         */
/* /*         ASSIGN tt-cc-transf.canal          = int-cc-benef.canal           */         */
/* /*                tt-cc-transf.tipo-beneficio = int-cc-benef.tipo-beneficio  */         */
/* /*                tt-cc-transf.unid-neg       = int-cc-benef.unid-neg        */         */
/* /*                tt-cc-transf.dt-periodo-ini = int-cc-benef.dt-periodo-ini  */         */
/* /*                tt-cc-transf.dt-periodo-fim = int-cc-benef.dt-periodo-fim  */         */
/* /*                tt-cc-transf.vl-saldo       = int-cc-benef.vl-saldo        */         */
/* /*                tt-cc-transf.r-rowid        = rowid(int-cc-benef).         */         */
/* /*     END.                                                                  */         */
/*                                                                                         */
/*     {&open-query-br-origem}                                                             */
/*                                                                                         */
/*     APPLY "value-changed" TO br-origem IN FRAME fpage4.                                 */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-consulta-beneficio w-cadsim 
PROCEDURE pi-consulta-beneficio :
/*------------------------------------------------------------------------------*/
/*                 CONSULTAR O STATUS DO BENEF÷CIO NO CRM                      */    
/*------------------------------------------------------------------------------*/
    
    DEF OUTPUT PARAM TABLE FOR tt-erro.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-excel-cc w-cadsim 
PROCEDURE pi-gera-excel-cc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

      IF  NOT AVAIL tt-canal THEN
          RETURN "OK".

      DEF VAR c-arquivo AS CHAR NO-UNDO.

      DEF BUFFER b-expor-cc FOR tt-conta-corrente.
      
      ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "Contas_Correntes_Canais_" + tt-canal.cgc + "_" + STRING(TODAY, "99-99-9999") + "_"+ STRING(TIME) + ".csv".
      
      OUTPUT STREAM s-1 TO value(c-arquivo) CONVERT TARGET "iso8859-1".
                      
      PUT STREAM s-1 "Canal;Movto;Benef°cio;Unidade;Per°odo INI;Per°odo FIM;Classificaá∆o;Categoria;Base Calc;% Prev Meta;% Custo;% Benef°cio;Verba;Realizado;Empenhado;Saldo Dispon°vel;Vencto;Status;" SKIP.
      
      FOR EACH b-expor-cc
           BY b-expor-cc.dt-periodo-fim:
        
           EXPORT STREAM s-1 DELIMITER ";"  b-expor-cc.canal                       
                                            fnMovto(b-expor-cc.tp-movto)           
                                            fnBeneficio(b-expor-cc.tipo-beneficio) 
                                            upper(b-expor-cc.unid-neg)
                                            b-expor-cc.dt-periodo-ini              
                                            b-expor-cc.dt-periodo-fim              
                                            b-expor-cc.nome-classificacao               
                                            b-expor-cc.categoria    
                                            b-expor-cc.vl-base-calc
                                            b-expor-cc.perc-prov-meta
                                            b-expor-cc.perc-custo
                                            b-expor-cc.perc-benef
                                            (b-expor-cc.de-verbatotal + b-expor-cc.VerbaCancelada + b-expor-cc.VerbaAjustada)
                                            b-expor-cc.de-reembolsado 
                                            b-expor-cc.de-empenhadaTotal 
                                            b-expor-cc.de-disponivel                   
                                            b-expor-cc.dt-vencimento               
                                            fnStatus(b-expor-cc.Id-Status).         
   
      END.

      OUTPUT STREAM s-1 CLOSE.

      DOS SILENT START excel VALUE(c-arquivo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-excel-detalhes w-cadsim 
PROCEDURE pi-gera-excel-detalhes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      IF  NOT AVAIL tt-canal THEN
          RETURN "OK".

      DEF VAR c-arquivo AS CHAR NO-UNDO.

      DEF BUFFER b-expor-cc-det FOR int-cc-benef-movto.
      
      ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "Movtos_Contas_Correntes_Canais_" + tt-canal.cgc + "_" + STRING(TODAY, "99-99-9999") + "_"+ STRING(TIME) + ".csv".
      
      OUTPUT STREAM s-1 TO value(c-arquivo) CONVERT TARGET "iso8859-1".
                      
      PUT STREAM s-1 "Canal;Benef°cio;Unidade;Per°odo Ini;Per°odo Fim;Sequencia;Transaá∆o;Valor;Data;Hora;Usu†rio" SKIP.
      
      FOR EACH b-expor-cc-det
           BY b-expor-cc-det.dt-movto
           BY b-expor-cc-det.hr-movto:
        
           EXPORT STREAM s-1 DELIMITER ";"  b-expor-cc-det.canal                      
                                            fnBeneficio(b-expor-cc-det.tipo-beneficio)
                                            b-expor-cc-det.unid-neg                   
                                            b-expor-cc-det.dt-periodo-ini             
                                            b-expor-cc-det.dt-periodo-fim             
                                            b-expor-cc-det.sequencia                  
                                            fnTransacao(b-expor-cc-det.transacao)     
                                            b-expor-cc-det.vl-movto                   
                                            b-expor-cc-det.dt-movto                   
                                            b-expor-cc-det.hr-movto                   
                                            b-expor-cc-det.usu†rio.                    
   
      END.

      OUTPUT STREAM s-1 CLOSE.

      DOS SILENT START excel VALUE(c-arquivo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-excel-solicitacao w-cadsim 
PROCEDURE pi-gera-excel-solicitacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*       IF  NOT AVAIL tt-canal                                                                                                                                        */
/*       OR NOT AVAIL tt-conta-corrente THEN                                                                                                                           */
/*           RETURN "OK".                                                                                                                                              */
/*                                                                                                                                                                     */
/*       DEF VAR c-arquivo AS CHAR NO-UNDO.                                                                                                                            */
/*                                                                                                                                                                     */
/*       DEF BUFFER b-export-solicitacao FOR int-solicitacao.                                                                                                          */
/*                                                                                                                                                                     */
/*       ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "Solicitacoes_CC_Canal_" + tt-canal.cgc + "_" + STRING(TODAY, "99-99-9999") + "_"+ STRING(TIME) + ".csv". */
/*                                                                                                                                                                     */
/*       OUTPUT STREAM s-1 TO value(c-arquivo) CONVERT TARGET "iso8859-1".                                                                                             */
/*                                                                                                                                                                     */
/*       PUT STREAM s-1 "Canal;NomeAbrev;Nome;Tipo;Data;Hora;Forma Pagto;Verba Original;Ajuste;Solicitaá∆o;Dispon°vel;Abat. T°tulo;Situaá∆o;Envio CRM" SKIP.           */
/*                                                                                                                                                                     */
/*                                                                                                                                                                     */
/*       DEF VAR de-ajuste      AS DEC NO-UNDO.                                                                                                                        */
/*       DEF VAR de-solicitacao AS DEC NO-UNDO.                                                                                                                        */
/*       DEF VAR de-a-pagar-apb AS DEC NO-UNDO.                                                                                                                        */
/*       DEF VAR de-fluxo       AS DEC NO-UNDO.                                                                                                                        */
/*                                                                                                                                                                     */
/*       ASSIGN de-fluxo = tt-conta-corrente.vl-saldo-ori.                                                                                                             */
/*                                                                                                                                                                     */
/*       FOR EACH b-export-solicitacao NO-LOCK                                                                                                                         */
/*           WHERE b-export-solicitacao.CodigoConta                  = tt-conta-corrente.guid-canal                                                                    */
/*             AND b-export-solicitacao.CodigoUnidadeNegocio         = tt-conta-corrente.unid-neg                                                                      */
/*             AND b-export-solicitacao.tipo-beneficio               = tt-conta-corrente.tipo-beneficio                                                                */
/*             AND b-export-solicitacao.dt-periodo-ini               = tt-conta-corrente.dt-periodo-ini                                                                */
/*             AND b-export-solicitacao.dt-periodo-fim               = tt-conta-corrente.dt-periodo-fim                                                                */
/*           ,FIRST emitente NO-LOCK                                                                                                                                   */
/*               WHERE emitente.cod-emitente = b-export-solicitacao.cod-emitente                                                                                       */
/*            BY b-export-solicitacao.DataCriacao                                                                                                                         */
/*            BY b-export-solicitacao.hora-trans :                                                                                                                     */
/*                                                                                                                                                                     */
/*               ASSIGN de-ajuste      = IF  b-export-solicitacao.Ajuste THEN                                                                                          */
/*                                           b-export-solicitacao.ValorSolicitado                                                                                      */
/*                                       ELSE                                                                                                                          */
/*                                           0                                                                                                                         */
/*                      de-solicitacao = IF  b-export-solicitacao.Ajuste THEN                                                                                          */
/*                                           0                                                                                                                         */
/*                                       ELSE                                                                                                                          */
/*                                           b-export-solicitacao.ValorSolicitado * (-1)                                                                               */
/*                                                                                                                                                                     */
/*                      de-a-pagar-apb = IF  b-export-solicitacao.Ajuste THEN                                                                                          */
/*                                           b-export-solicitacao.ValorSolicitado * (tt-conta-corrente.perc-custo / 100)                                               */
/*                                       ELSE                                                                                                                          */
/*                                           b-export-solicitacao.ValorAbater * (- 1).                                                                                 */
/*                                                                                                                                                                     */
/*                 IF  b-export-solicitacao.SituacaoSolicitacaoBeneficio <>  993520006 THEN                                                                            */
/*                     ASSIGN de-fluxo =  de-fluxo + de-ajuste + de-solicitacao.                                                                                       */
/*                                                                                                                                                                     */
/*                EXPORT STREAM s-1 DELIMITER ";"  emitente.cod-emitente                                                                                               */
/*                                                 emitente.nome-abrev                                                                                                 */
/*                                                 emitente.nome-emit                                                                                                  */
/*                                                 IF b-export-solicitacao.Ajuste THEN "AJUSTE" ELSE "NORMAL"                                                          */
/*                                                 b-export-solicitacao.DataCriacao                                                                                       */
/*                                                 b-export-solicitacao.hora-trans                                                                                     */
/*                                                 b-export-solicitacao.desc-forma-pagto                                                                               */
/*                                                 tt-conta-corrente.vl-saldo-ori                                                                                      */
/*                                                 de-ajuste                                                                                                           */
/*                                                 de-solicitacao                                                                                                      */
/*                                                 de-fluxo                                                                                                            */
/*                                                 de-a-pagar-apb                                                                                                      */
/*                                                 fnStatusSolicitacao(b-export-solicitacao.SituacaoSolicitacaoBeneficio)                                              */
/*                                                 b-export-solicitacao.log-enviada.                                                                                   */
/*                                                                                                                                                                     */
/*                                                                                                                                                                     */
/*       END.                                                                                                                                                          */
/*                                                                                                                                                                     */
/*       OUTPUT STREAM s-1 CLOSE.                                                                                                                                      */
/*                                                                                                                                                                     */
/*       DOS SILENT START excel VALUE(c-arquivo).                                                                                                                      */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-totais-solicitacao w-cadsim 
PROCEDURE pi-mostra-totais-solicitacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*     DEF VAR de-tot-aprovadas AS DEC NO-UNDO.                                                                                               */
/*     DEF VAR de-tot-pendente  AS DEC NO-UNDO.                                                                                               */
/*     DEF VAR de-tot-pagas     AS DEC NO-UNDO.                                                                                               */
/*     DEF VAR de-tot-ajustes   AS DEC NO-UNDO.                                                                                               */
/*     DEF VAR de-tot-geral     AS DEC NO-UNDO.                                                                                               */
/*                                                                                                                                            */
/*     FOR EACH b-solicitacao NO-LOCK                                                                                                         */
/*         WHERE b-solicitacao.CodigoConta                  = tt-conta-corrente.guid-canal                                                    */
/*           AND b-solicitacao.CodigoUnidadeNegocio         = tt-conta-corrente.unid-neg                                                      */
/*           AND b-solicitacao.tipo-beneficio               = tt-conta-corrente.tipo-beneficio                                                */
/*           AND b-solicitacao.dt-periodo-ini               = tt-conta-corrente.dt-periodo-ini                                                */
/*           AND b-solicitacao.dt-periodo-fim               = tt-conta-corrente.dt-periodo-fim:                                               */
/*                                                                                                                                            */
/*         IF  NOT b-solicitacao.Ajuste THEN DO: /*PAGAMENTOS*/                                                                               */
/*             CASE  b-solicitacao.SituacaoSolicitacaoBeneficio:                                                                              */
/*                 WHEN  993520008 THEN de-tot-aprovadas = de-tot-aprovadas + b-solicitacao.ValorSolicitado.                                  */
/*                 WHEN  993520003 THEN de-tot-pendente  = de-tot-pendente  + b-solicitacao.ValorSolicitado - (b-solicitacao.vl-abatido-apb). */
/*                 WHEN  993520004 THEN de-tot-pagas     = de-tot-pagas     + (IF  b-solicitacao.vl-abatido-apb > 0 THEN                      */
/*                                                                                 (b-solicitacao.vl-abatido-apb)                             */
/*                                                                            ELSE                                                            */
/*                                                                                 b-solicitacao.ValorSolicitado).                            */
/*             END CASE.                                                                                                                      */
/*         END.                                                                                                                               */
/*         ELSE /*AJUSTES*/                                                                                                                   */
/*             ASSIGN de-tot-ajustes = de-tot-ajustes + b-solicitacao.ValorSolicitado.                                                        */
/*                                                                                                                                            */
/*                                                                                                                                            */
/*     END.                                                                                                                                   */
/*                                                                                                                                            */
/*     ASSIGN fi-aprovadas :SCREEN-VALUE IN FRAME fpage5 = STRING(de-tot-aprovadas)                                                           */
/*            fi-pendentes :SCREEN-VALUE IN FRAME fpage5 = STRING(de-tot-pendente)                                                            */
/*            fi-pagas     :SCREEN-VALUE IN FRAME fpage5 = STRING(de-tot-pagas)                                                               */
/*            fi-ajustes   :SCREEN-VALUE IN FRAME fpage5 = STRING(de-tot-ajustes).                                                            */
/*                                                                                                                                            */
/*     IF  AVAIL tt-conta-corrente THEN                                                                                                       */
/*         ASSIGN fi-disponivel:SCREEN-VALUE IN FRAM fpage5 = string(tt-conta-corrente.de-disponivel).                                        */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posiciona-registro w-cadsim 
PROCEDURE pi-posiciona-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER r-row AS ROWID.

    DEF BUFFER b-emitente FOR emitente.

    FIND FIRST int-cc-benef NO-LOCK
        WHERE rowid(int-cc-benef) = r-row NO-ERROR.
    IF  NOT AVAIL int-cc-benef THEN
        RETURN "OK".

    FIND FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = int-cc-benef.canal NO-ERROR.

    CREATE tt-conta-corrente.
    ASSIGN tt-conta-corrente.canal  = int-cc-benef.canal               
           tt-conta-corrente.r-rowid = ROWID(int-cc-benef).  
    
    {&open-query-br-conta-corrente}
    APPLY "value-changed" TO br-conta-corrente IN FRAME f-cad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reposiciona-canal-x-cc w-cadsim 
PROCEDURE pi-reposiciona-canal-x-cc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR l-ok       AS LOGICAL INIT NO NO-UNDO.
    DEF VAR r-row-novo AS ROWID NO-UNDO.
    DEF VAR i-canal    AS INTEGER NO-UNDO.
    DEF BUFFER b-tt-conta-corrente FOR tt-conta-corrente.
    DEF BUFFER b-tt-canal FOR tt-canal.
    DEF BUFFER b-int-cc-benef-aux FOR int-cc-benef.

    IF  gr-conta-corrente <> ? THEN DO:

        FIND FIRST b-int-cc-benef-aux
            WHERE rowid(b-int-cc-benef-aux) = gr-conta-corrente NO-LOCK.

        IF  AVAIL b-int-cc-benef-aux  THEN DO:
            /* REPOSICIONA NO CANAL DA CONTA QUE ACABA DE SER CRIADA */
            IF  NOT AVAIL tt-canal THEN DO:
                RUN pi-carrega-canais.

                FIND FIRST b-tt-canal
                    WHERE b-tt-canal.canal = b-int-cc-benef-aux.canal NO-ERROR.

                IF  AVAIL b-tt-canal THEN DO:
                    REPOSITION br-canais TO ROWID ROWID(b-tt-canal).
                    APPLY "value-changed" TO br-canais IN FRAME f-cad.
                    APPLY "row-display" TO br-canais IN FRAME f-cad.
                END.
                
            END.

            RUN pi-carrega-cc.

            FIND FIRST b-tt-conta-corrente
                WHERE b-tt-conta-corrente.r-rowid = gr-conta-corrente NO-ERROR.
   
            REPOSITION br-conta-corrente TO ROWID ROWID(b-tt-conta-corrente).

            APPLY "value-changed"        TO br-conta-corrente IN FRAME f-cad.
            APPLY "row-display"          TO br-conta-corrente IN FRAME f-cad.

        END.
    END.
  
    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-status-crm-em-tela w-cadsim 
PROCEDURE pi-seta-status-crm-em-tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-desc-status AS CHAR NO-UNDO.
/*     DO WITH FRAME fpage1:                                              */
/*                                                                        */
/*         CASE p-desc-status:                                            */
/*             WHEN "ATIVO" THEN                                          */
/*                 ASSIGN fi-status-beneficio:SCREEN-VALUE = "ATIVO"      */
/*                        fi-status-beneficio:FGCOLOR = 2                 */
/*                        fi-status-beneficio:FONT    = 0.                */
/*                                                                        */
/*             WHEN "BLOQUEADO" THEN                                      */
/*                 ASSIGN fi-status-beneficio:SCREEN-VALUE = "BLOQUEADO"  */
/*                        fi-status-beneficio:FGCOLOR = 12                */
/*                        fi-status-beneficio:FONT    = 0.                */
/*                                                                        */
/*             WHEN "SUSPENSO" THEN                                       */
/*                 ASSIGN fi-status-beneficio:SCREEN-VALUE = "SUSPENSO"   */
/*                         fi-status-beneficio:FGCOLOR = 14               */
/*                         fi-status-beneficio:FONT    = 0.               */
/*             OTHERWISE fi-status-beneficio:SCREEN-VALUE = "".           */
/*         END.                                                           */
/*     END.                                                               */

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-solicita-historico-usuario w-cadsim 
PROCEDURE pi-solicita-historico-usuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*     DEF VAR c-historico AS CHAR NO-UNDO.                                                                               */
/*                                                                                                                        */
/*     ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.                                                                              */
/*     RUN esp/esb/esesb008b.w (OUTPUT c-historico).                                                                      */
/*     ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.                                                                             */
/*                                                                                                                        */
/*     IF  c-historico = "" THEN DO:                                                                                      */
/*         RUN utp/ut-msgs.p(INPUT "show",                                                                                */
/*                           INPUT 17006,                                                                                 */
/*                           INPUT "Deve ser informado um descritivo hist¢rico para a operaá∆o.").                        */
/*          RETURN "NOK".                                                                                                 */
/*     END.                                                                                                               */
/*                                                                                                                        */
/*     RUN utp/ut-msgs.p(INPUT "show":U,                                                                                  */
/*                       INPUT 27100,                                                                                     */
/*                       INPUT "Confirma transferància entre unidades?" + "~~" +                                          */
/*                             "Unidade Origem..........: " + tt-cc-transf.unid-neg       + CHR(10) +                     */
/*                             "Unidade Destino.........: " + tt-cc-transf-dest.unid-neg  + CHR(10) +                     */
/*                             "Saldo a ser transferido: R$ " + de-saldo-transf:SCREEN-VALUE IN FRAME fpage4  + CHR(10)). */
/*                                                                                                                        */
/*     IF  RETURN-VALUE = "NO" THEN                                                                                       */
/*         RETURN "NOK".                                                                                                  */
/*                                                                                                                        */
/*     RETURN "OK".                                                                                                       */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-status-alterando w-cadsim 
PROCEDURE pi-status-alterando :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*     DEF INPUT PARAM p-habilitar AS LOG NO-UNDO.                 */
/*                                                                 */
/*     DO WITH FRAME fpage4:                                       */
/*         ASSIGN bt-transf:SENSITIVE          = NOT p-habilitar   */
/*                bt-cancela:SENSITIVE         = p-habilitar       */
/*                bt-efetiva-transf:SENSITIVE  = p-habilitar       */
/*                de-saldo-transf:SENSITIVE    = NOT p-habilitar   */
/*                fi-unidade:SENSITIVE         = NOT p-habilitar.  */
/*     END.                                                        */
/*                                                                 */
/*     DO WITH FRAME f-cad:                                        */
/*         ASSIGN fi-canal:SENSITIVE          = NOT p-habilitar    */
/*                bt-goto-emitente:SENSITIVE  = NOT p-habilitar    */
/*                br-canais:SENSITIVE         = NOT p-habilitar    */
/*                br-conta-corrente:SENSITIVE = NOT p-habilitar    */
/*                bt-param-cc:SENSITIVE       = NOT p-habilitar    */
/*                folder-1:SENSITIVE          = NOT p-habilitar    */
/*                folder-5:SENSITIVE          = NOT p-habilitar.   */
/*     END.                                                        */

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
  {src/adm/template/snd-list.i "int-solicitacao"}
  {src/adm/template/snd-list.i "tt-conta-corrente"}
  {src/adm/template/snd-list.i "tt-canal"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-saldo-pendente w-cadsim 
FUNCTION fn-saldo-pendente RETURNS DECIMAL
  ( INPUT p-guid-canal AS CHAR ,
    INPUT p-unidade    AS char,
    INPUT p-beneficio  AS INTEGER,
    INPUT p-per-ini    AS DATE,
    INPUT p-per-fim    AS DATE  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR de-pendentes AS DECIMAL NO-UNDO.
    
     FOR EACH int-solicitacao NO-LOCK
         WHERE int-solicitacao.CodigoConta                  = p-guid-canal
           AND int-solicitacao.CodigoUnidadeNegocio         = p-unidade
           AND int-solicitacao.tipo-beneficio               = p-beneficio
           AND int-solicitacao.dt-periodo-ini               = p-per-ini
           AND int-solicitacao.dt-periodo-fim               = p-per-fim
           AND int-solicitacao.SituacaoSolicitacaoBeneficio = 993520003 /* PENDENTE DE PAGAMENTO */
           AND NOT int-solicitacao.Ajuste: /*Ajuste*/

         ASSIGN de-pendentes = de-pendentes + int-solicitacao.ValorSolicitado - int-solicitacao.vl-abatido-apb.
     END.

  RETURN de-pendentes.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-saldo-reembolsado w-cadsim 
FUNCTION fn-saldo-reembolsado RETURNS DECIMAL
  ( INPUT p-guid-canal AS CHAR ,
    INPUT p-unidade    AS char,
    INPUT p-beneficio  AS INTEGER,
    INPUT p-per-ini    AS DATE,
    INPUT p-per-fim    AS DATE  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR de-tot-pagas AS DECIMAL NO-UNDO.
    DEF VAR de-abatido   AS DECIMAL NO-UNDO.
    
     FOR EACH int-solicitacao NO-LOCK
         WHERE int-solicitacao.CodigoConta                  = p-guid-canal
           AND int-solicitacao.CodigoUnidadeNegocio         = p-unidade
           AND int-solicitacao.tipo-beneficio               = p-beneficio
           AND int-solicitacao.dt-periodo-ini               = p-per-ini
           AND int-solicitacao.dt-periodo-fim               = p-per-fim
           AND int-solicitacao.SituacaoSolicitacaoBeneficio >= 993520003
           AND int-solicitacao.SituacaoSolicitacaoBeneficio <= 993520004
           AND NOT int-solicitacao.Ajuste:  /* Ajuste */

         ASSIGN de-abatido = int-solicitacao.vl-abatido-apb.

         IF int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 
         AND de-abatido = 0 THEN
             ASSIGN de-abatido = int-solicitacao.ValorSolicitado.

         ASSIGN de-tot-pagas = de-tot-pagas + de-abatido.
                                              
     END.

  RETURN de-tot-pagas.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnbeneficio w-cadsim 
FUNCTION fnbeneficio RETURNS CHARACTER
  (INPUT p-tipo AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-tipo:
      WHEN 21 THEN RETURN "V M C".
      WHEN 37 THEN RETURN "Rebate".
      WHEN 22 THEN RETURN "Stock Rotation".
      WHEN 66 THEN RETURN "Rebate P¢s-Venda".
      WHEN 08 THEN RETURN "Price Protection".
      WHEN 15 THEN RETURN "Backup".
      WHEN 04 THEN RETURN "Show Room".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMovto w-cadsim 
FUNCTION fnMovto RETURNS CHARACTER
  ( p-movto AS INTEGER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE p-movto:
      WHEN 1 THEN RETURN "PROV".
      WHEN 2 THEN RETURN "DESP".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSitPedido w-cadsim 
FUNCTION fnSitPedido RETURNS CHARACTER
  ( INPUT  p-sit AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-sit:
      WHEN 1 THEN RETURN "Aberto".
      WHEN 2 THEN RETURN "Atendido Parcial".
      WHEN 3 THEN RETURN "Atendido Total".
      WHEN 4 THEN RETURN "Pendente".
      WHEN 5 THEN RETURN "Suspenso".
      WHEN 6 THEN RETURN "Cancelado".
      WHEN 7 THEN RETURN "Fatur Balc∆o".
  END CASE.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSituacao w-cadsim 
FUNCTION fnSituacao RETURNS CHARACTER
    (INPUT p-situacao AS INTEGER) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/

    IF  p-situacao = 0 THEN
       RETURN "SIM".
    ELSE
       RETURN "N«O".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnStatus w-cadsim 
FUNCTION fnStatus RETURNS CHARACTER
  ( p-status AS INTEGER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE p-status:
      WHEN 1 THEN RETURN "Ativa".
      WHEN 2 THEN RETURN "Finalizada".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnStatusSolicitacao w-cadsim 
FUNCTION fnStatusSolicitacao RETURNS CHARACTER
  ( p-status AS INTEGER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF  NOT int-solicitacao.log-historica THEN DO:
  
      CASE p-status:
          /*WHEN 993520008 THEN RETURN "APROVADA".*/
          WHEN 993520003 THEN RETURN "PENDENTE".
          WHEN 993520004 THEN RETURN "PAGA".
          WHEN 993520006 THEN RETURN "CANCELADA".
          OTHERWISE RETURN "ANµLISE" .
      END CASE.

  END.
  ELSE DO:
      CASE p-status:
          WHEN 993520003 THEN RETURN "TRANSFERIDA".
          WHEN 993520004 THEN RETURN "PAGA".
          WHEN 993520006 THEN RETURN "CANCELADA".
          OTHERWISE RETURN "TRANSFERIDA" .
      END CASE.
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTransacao w-cadsim 
FUNCTION fnTransacao RETURNS CHARACTER
  (INPUT p-tipo AS INT /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE p-tipo:
      WHEN 1  THEN RETURN "Sa°da Transferància".
      WHEN 2  THEN RETURN "Entrada Transferància".
      WHEN 3  THEN RETURN "Ajuste".
      WHEN 4  THEN RETURN "Criaá∆o Manual".
      WHEN 10 THEN RETURN "Saldo Inicial".
      WHEN 20 THEN RETURN "Saldo Inicial".
      WHEN 30 THEN RETURN "Saldo Inicial".
      WHEN 40 THEN RETURN "Saldo Inicial".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

