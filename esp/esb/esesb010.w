&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
{include/i-prgvrs.i ISGT0006 2.00.00.000}


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
DEF BUFFER b-int-cc-benef FOR int-cc-benef.
DEF buffer b-novo         FOR int-cc-benef.
DEF VAR i-situacao      AS INTEGER NO-UNDO.
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

DEF TEMP-TABLE tt-pedido
    FIELD nome-abrev     AS CHAR FORMAT "X(12)"
    FIELD nr-pedcli      AS CHAR FORMAT "X(12)"
    FIELD cod-estabel    AS CHAR FORMAT "X(05)"
    FIELD dt-implantacao AS DATE FORMAT "99/99/99"
    FIELD dt-cancela     AS DATE FORMAT "99/99/99"
    FIELD cod-sit-ped    AS INTEGER
    FIELD desc-sit-ped   AS CHAR FORMAT "X(20)"
    FIELD vl-aprovado    AS DEC  FORMAT ">,>>>,>>>,>>9.99"
    FIELD vl-liq-ped     AS DECIMAL DECIMALS 10 FORMAT ">,>>>,>>>,>>9.99"
    FIELD vl-tot-ped     AS DECIMAL DECIMALS 10 FORMAT ">,>>>,>>>,>>9.99".
                                     
DEF BUFFER b-tt-canal FOR tt-canal.

DEFINE TEMP-TABLE tt-solicitacao NO-UNDO LIKE int-solicitacao
    FIELD r-solicitacao    AS ROWID
    FIELD r-tt-solicitacao AS ROWID
    FIELD r-conta-corrente AS ROWID
    FIELD vl-aprovado      AS DEC
    FIELD nome-abrev       AS CHAR
    FIELD nome-emit        AS CHAR FORMAT "X(60)"
    FIELD cod-gr-cob       AS INT
    FIELD desc-beneficio   AS CHAR FORMAT "x(20)"
    FIELD desc-situacao    AS CHAR FORMAT "X(10)"
    FIELD c-ajuste         AS CHAR FORMAT "X(8)"
    FIELD a-pagar-solicit  AS DEC DECIMALS 4 FORMAT "->>,>>>,>>9.99"
    FIELD vl-abatido-verba AS DEC DECIMALS 4 FORMAT "->>,>>>,>>9.99"
    FIELD a-pagar          AS DEC DECIMALS 4 FORMAT "->>,>>>,>>9.99"
    FIELD a-pagar-apb      AS DEC FORMAT "->>,>>>,>>9.99"
    FIELD vl-saldo-cc      AS DEC DECIMALS 4
    FIELD vl-titulo-ori    AS DEC
    FIELD vl-titulo        AS DEC
    FIELD hora             AS CHAR FORMAT "X(8)"
    FIELD desc-forma-pagto-abrev AS CHAR FORMAT "X(11)"   
    FIELD vl-abatido-parcial AS DEC
        INDEX idx-rowid r-solicitacao.

DEFINE TEMP-TABLE tt-itens NO-UNDO LIKE int-solicitacao-item
    FIELD desc-item    AS CHAR FORMAT "X(60)"
    FIELD cod-sit-item AS CHAR FORMAT "X(20)"
    FIELD qt-atendida  AS DEC FORMAT ">>>,>>>,>>9".

DEFINE TEMP-TABLE tt-tit-acr
    FIELD cod_estab          AS CHARACTER
    FIELD cod_espec_docto    AS CHARACTER
    FIELD cod_ser_docto      AS CHARACTER
    FIELD cod_tit_acr        AS CHARACTER
    FIELD cod_parcela        AS CHARACTER
    FIELD cdn_cliente        AS INTEGER
    FIELD nom_abrev          AS CHAR FORMAT "X(12)"
    FIELD cod_id_feder       AS CHAR FORMAT "X(20)"
    FIELD dat_vencto_tit_acr AS DATE FORMAT "99/99/9999"
    FIELD val_origin_tit_acr AS DEC FORMAT ">>>,>>>,>>9.99"
    FIELD val-liquidado      AS DEC FORMAT ">>>,>>>,>>9.99"
    FIELD recid-tit-acr      AS RECID.

DEFINE TEMP-TABLE tt-conta-corrente NO-UNDO
    LIKE int-cc-benef
    FIELD status-crm         AS CHAR FORMAT "X(12)"
    FIELD nome-classificacao AS CHAR FORMAT "X(25)"
    FIELD desc-tp-movto      AS CHAR FORMAT "x(25)"
    FIELD desc-beneficio     AS CHAR FORMAT "X(25)"
    FIELD r-rowid            AS ROWID
    FIELD de-reembolsado     AS DEC
    FIELD de-pendente        AS DEC
    FIELD de-disponivel      AS DEC.

/********** PARA CONSULTA DE BENEF÷CIO *************/
DEF TEMP-TABLE tt-erro-benef   LIKE tt-erro.
DEF TEMP-TABLE tt-erro-central LIKE tt-erro.  
/* Temp-table tt-beneficio */
{esp/esb/esesbapi004-benef.i}
DEF TEMP-TABLE tt-canal-crm NO-UNDO
    FIELD canal      AS INTEGER
    FIELD guid-canal AS CHAR FORMAT "x(36)"
    FIELD guid-class AS CHAR FORMAT "x(36)"
       INDEX idx-canal  IS PRIMARY UNIQUE canal .
/***************************************************/

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

DEF NEW GLOBAL SHARED VAR v_rec_tit_ap AS RECID format ">>>>>>9" INITIAL ? NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_tit_acr AS RECID format ">>>>>>9" INITIAL ? NO-UNDO.

DEF NEW GLOBAL SHARED VAR gr-ped-venda AS ROWID NO-UNDO.



/*Estrutura Canais centralizados*/
{esp/esb/esesbapi005.i}

{esp/esb/esesbapi008.i} /*tt-titulo-acr e temp-tables auxiliares */

DEF STREAM s-1.

DEF NEW GLOBAL SHARED VAR gr-solicitacao AS ROWID NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-conta-corrente AS ROWID NO-UNDO.


/*-----------------  R P W  ----------------------*/
{esp/esb/IN/msg0152.i2}

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.


{esp/esb/esesbapi010-saldo.i1}
DEF TEMP-TABLE tt-erro-saldo LIKE tt-erro.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-itens

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-itens tt-pedido tt-solicitacao tt-tit-acr

/* Definitions for BROWSE br-itens                                      */
&Scoped-define FIELDS-IN-QUERY-br-itens tt-itens.CodigoEstabelecimento tt-itens.nr-pedcli tt-itens.CodigoProduto tt-itens.desc-item tt-itens.cod-sit-item tt-itens.ValorUnitarioAprovado tt-itens.QuantidadeAprovada tt-itens.ValorTotalAprovado tt-itens.QuantidadeCancelada tt-itens.qt-atendida tt-itens.ValorCancelado tt-itens.ValorPago   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-itens   
&Scoped-define SELF-NAME br-itens
&Scoped-define QUERY-STRING-br-itens FOR EACH tt-itens BY tt-itens.CodigoEstabelecimento                                           BY tt-itens.CodigoProduto
&Scoped-define OPEN-QUERY-br-itens OPEN QUERY {&SELF-NAME} FOR EACH tt-itens BY tt-itens.CodigoEstabelecimento                                           BY tt-itens.CodigoProduto.
&Scoped-define TABLES-IN-QUERY-br-itens tt-itens
&Scoped-define FIRST-TABLE-IN-QUERY-br-itens tt-itens


/* Definitions for BROWSE br-pedido                                     */
&Scoped-define FIELDS-IN-QUERY-br-pedido tt-pedido.nome-abrev tt-pedido.nr-pedcli tt-pedido.cod-estabel tt-pedido.dt-implantacao tt-pedido.dt-cancela tt-pedido.desc-sit-ped tt-pedido.vl-aprovado tt-pedido.vl-liq-ped tt-pedido.vl-tot-ped   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-pedido   
&Scoped-define SELF-NAME br-pedido
&Scoped-define QUERY-STRING-br-pedido FOR EACH tt-pedido BY tt-pedido.nr-pedcli
&Scoped-define OPEN-QUERY-br-pedido OPEN QUERY {&SELF-NAME} FOR EACH tt-pedido BY tt-pedido.nr-pedcli.
&Scoped-define TABLES-IN-QUERY-br-pedido tt-pedido
&Scoped-define FIRST-TABLE-IN-QUERY-br-pedido tt-pedido


/* Definitions for BROWSE br-solicitacao                                */
&Scoped-define FIELDS-IN-QUERY-br-solicitacao tt-solicitacao.c-ajuste tt-solicitacao.cod-emitente tt-solicitacao.nome-abrev tt-solicitacao.desc-beneficio tt-solicitacao.CodigoUnidadeNegocio tt-solicitacao.DataCriacao tt-solicitacao.hora tt-solicitacao.desc-forma-pagto-abrev tt-solicitacao.vl-aprovado tt-solicitacao.vl-empenho-pago tt-solicitacao.vl-abatido-verba tt-solicitacao.a-pagar-solicit tt-solicitacao.vl-abatido-parcial tt-solicitacao.vl-titulo tt-solicitacao.desc-situacao tt-solicitacao.log-enviada tt-solicitacao.TrimestreCompetencia tt-solicitacao.cod-gr-cob   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-solicitacao   
&Scoped-define SELF-NAME br-solicitacao
&Scoped-define QUERY-STRING-br-solicitacao FOR EACH tt-solicitacao BY tt-solicitacao.DataCriacao  DESC                                                 BY tt-solicitacao.hora      DESC
&Scoped-define OPEN-QUERY-br-solicitacao OPEN QUERY {&SELF-NAME} FOR EACH tt-solicitacao BY tt-solicitacao.DataCriacao  DESC                                                 BY tt-solicitacao.hora      DESC.
&Scoped-define TABLES-IN-QUERY-br-solicitacao tt-solicitacao
&Scoped-define FIRST-TABLE-IN-QUERY-br-solicitacao tt-solicitacao


/* Definitions for BROWSE br-tit-acr                                    */
&Scoped-define FIELDS-IN-QUERY-br-tit-acr tt-tit-acr.cod_estab tt-tit-acr.cod_espec_docto tt-tit-acr.cod_ser_docto tt-tit-acr.cod_tit_acr tt-tit-acr.cod_parcela tt-tit-acr.cdn_cliente tt-tit-acr.nom_abrev tt-tit-acr.cod_id_feder tt-tit-acr.dat_vencto_tit_acr tt-tit-acr.val_origin_tit_acr tt-tit-acr.val-liquidado   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-tit-acr   
&Scoped-define SELF-NAME br-tit-acr
&Scoped-define QUERY-STRING-br-tit-acr FOR EACH tt-tit-acr BY tt-tit-acr.cod_tit_acr                                             BY tt-tit-acr.cod_parcela
&Scoped-define OPEN-QUERY-br-tit-acr OPEN QUERY {&SELF-NAME} FOR EACH tt-tit-acr BY tt-tit-acr.cod_tit_acr                                             BY tt-tit-acr.cod_parcela.
&Scoped-define TABLES-IN-QUERY-br-tit-acr tt-tit-acr
&Scoped-define FIRST-TABLE-IN-QUERY-br-tit-acr tt-tit-acr


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-solicitacao}

/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-br-pedido}

/* Definitions for FRAME fpage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage5 ~
    ~{&OPEN-QUERY-br-tit-acr}

/* Definitions for FRAME fpage6                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage6 ~
    ~{&OPEN-QUERY-br-itens}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rs-canais rs-selecao fi-canal fi-data-ini ~
fi-data-fim fi-unidade-ini fi-unidade-fim fi-gr-cob-ini fi-gr-cob-fim ~
rs-tipo rs-envio bt-listar-pedidos cb-beneficio cb-forma-pagto cb-situacao ~
bt-filtrar bt-encontro-contas bt-pagamento bt-ajuste-tit bt-altera-titulo ~
bt-exporta-solicitacao bt-ok fi-nome-abrev fi-nome rt-button Rect-Main ~
folder-1 folder-4 IMAGE-25 IMAGE-26 IMAGE-27 IMAGE-28 br-solicitacao ~
folder-5 folder-6 IMAGE-33 IMAGE-34 RECT-156 folder-7 RECT-158 RECT-161 ~
RECT-162 RECT-163 
&Scoped-Define DISPLAYED-OBJECTS rs-canais rs-selecao fi-canal fi-data-ini ~
fi-data-fim fi-unidade-ini fi-unidade-fim fi-gr-cob-ini fi-gr-cob-fim ~
rs-tipo rs-envio cb-beneficio cb-forma-pagto cb-situacao fi-nome-abrev ~
fi-nome 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCod-Sit-Item w-cadsim 
FUNCTION fnCod-Sit-Item RETURNS CHARACTER
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSituacaoSolicitacao w-cadsim 
FUNCTION fnSituacaoSolicitacao RETURNS CHARACTER
  (INPUT p-sit AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnStatus w-cadsim 
FUNCTION fnStatus RETURNS CHARACTER
  ( p-status AS INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnStatusContaCorrente w-cadsim 
FUNCTION fnStatusContaCorrente RETURNS CHARACTER
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
DEFINE BUTTON bt-ajuste-tit 
     IMAGE-UP FILE "image/im-ajust.gif":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Ajustar automaticamente o T°tulo no APB".

DEFINE BUTTON bt-altera-titulo 
     IMAGE-UP FILE "adeicon/editor.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Alteraá∆o T°tulo - App717aa".

DEFINE BUTTON bt-encontro-contas 
     IMAGE-UP FILE "adeicon/sort-u.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Encontro de Contas - Apb0735aa".

DEFINE BUTTON bt-exporta-solicitacao 
     IMAGE-UP FILE "image/excel.jpg":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Exportar Conta Corrente para Excel".

DEFINE BUTTON bt-filtrar 
     IMAGE-UP FILE "adeicon/filt-u95.bmp":U
     LABEL "" 
     SIZE 7 BY 1.92 TOOLTIP "Buscar Solicitaá‰es".

DEFINE BUTTON bt-listar-pedidos 
     IMAGE-UP FILE "image/ii-classe.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Listar Pedidos gerados por Solicitaá‰es".

DEFINE BUTTON bt-ok AUTO-GO 
     IMAGE-UP FILE "adeicon/cueexit.bmp":U
     LABEL "&Fechar" 
     SIZE 4.29 BY 1.25 TOOLTIP "Sair do programa"
     BGCOLOR 8 .

DEFINE BUTTON bt-pagamento 
     IMAGE-UP FILE "image\im-fin":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Efetuar pagamento da solicitaá∆o".

DEFINE VARIABLE cb-beneficio AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Benef°cio" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "VMC","Rebate","Rebate P¢s-Venda","Stock Rotation","Stock Backup","Show Room","Price Protection","Todos" 
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE cb-forma-pagto AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Forma Pagto" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Produto","Desconto em Duplicata","Dinheiro","Todos" 
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE cb-situacao AS CHARACTER FORMAT "X(256)":U INITIAL "Pendentes" 
     LABEL "Situaá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 7
     LIST-ITEMS "Em An†lise","Pendentes","Em An†lise + Pendentes","Pagas","Canceladas","Todas" 
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE fi-canal AS CHARACTER FORMAT "X(256)":U 
     LABEL "Canal" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-data-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 TOOLTIP "Data de Entrada da Solicitaá∆o (fim)" NO-UNDO.

DEFINE VARIABLE fi-data-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 TOOLTIP "Data de Entrada da Solicitaá∆o" NO-UNDO.

DEFINE VARIABLE fi-gr-cob-fim AS INTEGER FORMAT ">>9":U INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .79 NO-UNDO.

DEFINE VARIABLE fi-gr-cob-ini AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Grp. Cobr" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .79 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .79 NO-UNDO.

DEFINE VARIABLE fi-nome-abrev AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY .79 NO-UNDO.

DEFINE VARIABLE fi-unidade-fim AS CHARACTER FORMAT "x(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .79 NO-UNDO.

DEFINE VARIABLE fi-unidade-ini AS CHARACTER FORMAT "x(3)":U 
     LABEL "Unidade" 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .79 NO-UNDO.

DEFINE IMAGE folder-1
     FILENAME "image\ts-up110.bmp":U
     SIZE 16 BY 1.21.

DEFINE IMAGE folder-4
     FILENAME "image\ts-dn110.bmp":U
     SIZE 16 BY 1.21.

DEFINE IMAGE folder-5
     FILENAME "image\ts-dn110.bmp":U
     SIZE 16 BY 1.21.

DEFINE IMAGE folder-6
     FILENAME "image\ts-dn110.bmp":U
     SIZE 16 BY 1.21.

DEFINE IMAGE folder-7
     FILENAME "image\ts-dn110.bmp":U
     SIZE 16 BY 1.21.

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

DEFINE VARIABLE rs-canais AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Distribuidores", 1,
"Revendas", 2
     SIZE 16 BY 1.79 NO-UNDO.

DEFINE VARIABLE rs-envio AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Enviadas", 1,
"N∆o Enviadas", 2,
"Ambas", 3
     SIZE 37.14 BY .75 TOOLTIP "Envio de Status da Solicitaá∆o para o CRM" NO-UNDO.

DEFINE VARIABLE rs-selecao AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos os Canais", 1,
"Informar Canal", 2
     SIZE 39.43 BY .79 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Normal", 1,
"Ajuste Saldo", 2,
"Ambas", 3
     SIZE 39 BY .75 TOOLTIP "Tipo de Solicitaá∆o (Normal/Ajuste de Saldo)" NO-UNDO.

DEFINE RECTANGLE RECT-156
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55 BY 6.04.

DEFINE RECTANGLE RECT-158
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24 BY 6.04.

DEFINE RECTANGLE RECT-161
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59.29 BY 6.04.

DEFINE RECTANGLE RECT-162
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21 BY 2.75.

DEFINE RECTANGLE RECT-163
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59.29 BY 2.25.

DEFINE RECTANGLE Rect-Main
     EDGE-PIXELS 1 GRAPHIC-EDGE    
     SIZE 140 BY 9
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 140 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE ed-descritivo AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 45.72 BY 2.67 NO-UNDO.

DEFINE VARIABLE fi-a-pagar AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "∑ Pagar" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 0 NO-UNDO.

DEFINE VARIABLE fi-beneficio AS CHARACTER FORMAT "x(100)":U 
     LABEL "Benef°cio" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cond-pagto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cond. Pagto." 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-data AS DATE FORMAT "99/99/9999":U 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "x(100)":U 
     LABEL "Nome" 
     VIEW-AS FILL-IN 
     SIZE 43.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-empenho-cancelado AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Empenho Cancelado" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .75
     FONT 0 NO-UNDO.

DEFINE VARIABLE fi-empenho-pago AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Empenho Pago" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .75
     FONT 0 NO-UNDO.

DEFINE VARIABLE fi-empenho-transferido AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Empenho Transferido" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .75
     FONT 0 NO-UNDO.

DEFINE VARIABLE fi-forma-canc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Forma Cancelamento" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-forma-pagto AS CHARACTER FORMAT "x(100)":U 
     LABEL "Forma Pagamento" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-grupo-cob AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Grupo Cobranáa" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hora AS CHARACTER FORMAT "X(8)":U 
     LABEL "Hora" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-emit AS CHARACTER FORMAT "x(100)":U 
     LABEL "Canal" 
     VIEW-AS FILL-IN 
     SIZE 43.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-pagtos AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Pagtos Trim. Atual" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 0 NO-UNDO.

DEFINE VARIABLE fi-pagtos-ant AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Pagtos Anteriores" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 0 NO-UNDO.

DEFINE VARIABLE fi-situacao-solicitacao AS CHARACTER FORMAT "X(25)":U 
     LABEL "Situaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 21.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-status AS CHARACTER FORMAT "X(15)":U 
     LABEL "Status" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-transacao AS DATE FORMAT "99/99/9999":U 
     LABEL "Transaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fi-unidade AS CHARACTER FORMAT "x(100)":U 
     LABEL "Unid Neg." 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-validade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Validade" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-valor AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Solicitaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 0 NO-UNDO.

DEFINE VARIABLE fi-valor-abater AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "∑ Pagar" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88
     FONT 0 NO-UNDO.

DEFINE VARIABLE fi-valor-cancelado AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 0 NO-UNDO.

DEFINE VARIABLE fi-valor-pago AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Pago" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88
     FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-143
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73.43 BY 4.5.

DEFINE RECTANGLE RECT-144
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33.14 BY 4.46.

DEFINE RECTANGLE RECT-145
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48.43 BY 3.21.

DEFINE RECTANGLE RECT-146
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32.43 BY 3.17.

DEFINE RECTANGLE RECT-147
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 54.29 BY 3.25.

DEFINE RECTANGLE RECT-148
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28 BY 2.46.

DEFINE RECTANGLE RECT-149
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28 BY 1.46.

DEFINE VARIABLE tg-descarta-verba AS LOGICAL INITIAL no 
     LABEL "Descarta Verba" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.72 BY .83 NO-UNDO.

DEFINE VARIABLE tg-integrada AS LOGICAL INITIAL no 
     LABEL "Enviada ao CRM" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.57 BY .83 NO-UNDO.

DEFINE BUTTON bt-exporta-pedidos 
     IMAGE-UP FILE "image/excel.jpg":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Exportar Pedidos para Excel".

DEFINE BUTTON bt-pedido 
     IMAGE-UP FILE "adeicon/results.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Consulta Pedido".

DEFINE BUTTON bt-tit-acr 
     IMAGE-UP FILE "adeicon/results.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Consulta T°tulo Contas a Receber".

DEFINE VARIABLE fi-liquida-acr AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Liquidaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .79 NO-UNDO.

DEFINE BUTTON bt-pedido-2 
     IMAGE-UP FILE "adeicon/results.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Consulta Pedido".

DEFINE VARIABLE fi-emp-qtde-cancelada AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Qtde j† Cancelada" 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .79 NO-UNDO.

DEFINE VARIABLE fi-emp-vl-cancelado AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Vl j† Cancelado" 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .79 NO-UNDO.

DEFINE VARIABLE fi-emp-vl-pago AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Vl j† pago" 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .79 NO-UNDO.

DEFINE VARIABLE fi-item-abatido-apb AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Abatido do T°tulo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .79
     FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE fi-item-aberto AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Aberto" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .79 NO-UNDO.

DEFINE VARIABLE fi-item-atendido AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Atendido Total/Parcial" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .79 NO-UNDO.

DEFINE VARIABLE fi-item-cancelado AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Cancelado" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-157
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 1.67.

DEFINE BUTTON bt-cc 
     IMAGE-UP FILE "adeicon/results.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Consulta Conta Corrente do Benef°cio".

DEFINE BUTTON bt-titulo-2 
     IMAGE-UP FILE "image/cmcac.gif":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Consulta t°tulo APB vinculado a Conta Corrente".

DEFINE VARIABLE fi-analise AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Solicitaá‰es em An†lise" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-aprovada AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Solicitaá‰es Ö Pagar" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-categoria AS CHARACTER FORMAT "X(256)":U 
     LABEL "Categoria" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .79 NO-UNDO.

DEFINE VARIABLE fi-classificacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Classificaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .79 NO-UNDO.

DEFINE VARIABLE fi-EmpenhoTotal AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Total (7)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Finalizada-Stock-Rotation AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Finalizada Stock Rotation" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-perc-beneficio AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Benef°cio" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .79 NO-UNDO.

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

DEFINE VARIABLE fi-SaldoDisponivel AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Saldo Dispon°vel (4 - 5 + 6 - 7 - 8)" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .79
     BGCOLOR 15 FGCOLOR 9 FONT 2 NO-UNDO.

DEFINE VARIABLE fi-VerbaAcumulada AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Transf. p/ Ac£mulo Benef. (2)" 
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
     SIZE 7 BY .79 NO-UNDO.

DEFINE VARIABLE fi-vl-custo AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Custo Prev" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-52
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 2.58.

DEFINE RECTANGLE RECT-53
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 4.75.

DEFINE RECTANGLE RECT-56
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35 BY 4.17.

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35 BY 2.25.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 3.75.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 1.75.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 1.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-itens FOR 
      tt-itens SCROLLING.

DEFINE QUERY br-pedido FOR 
      tt-pedido SCROLLING.

DEFINE QUERY br-solicitacao FOR 
      tt-solicitacao SCROLLING.

DEFINE QUERY br-tit-acr FOR 
      tt-tit-acr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-itens w-cadsim _FREEFORM
  QUERY br-itens DISPLAY
      tt-itens.CodigoEstabelecimento  COLUMN-LABEL "Estab"                                   WIDTH 4
      tt-itens.nr-pedcli              COLUMN-LABEL "Pedido"                                  WIDTH 7
      tt-itens.CodigoProduto          COLUMN-LABEL "Produto"                                 WIDTH 9
      tt-itens.desc-item              COLUMN-LABEL "Descriá∆o"                               WIDTH 18
      tt-itens.cod-sit-item           COLUMN-LABEL "Situaá∆o"                                WIDTH 10  
      tt-itens.ValorUnitarioAprovado  COLUMN-LABEL "Unit. Aprov"   FORMAT ">>>,>>>,>>9.99"   WIDTH 10
      tt-itens.QuantidadeAprovada     COLUMN-LABEL "Qtde Aprov"    FORMAT ">>>,>>>,>>9.99"   WIDTH 10
      tt-itens.ValorTotalAprovado     COLUMN-LABEL "Tot Aprovado"  FORMAT ">>>,>>>,>>9.99"   WIDTH 10
      tt-itens.QuantidadeCancelada    COLUMN-LABEL "Qt.Cancelada"  FORMAT ">>>,>>>,>>9.99"   WIDTH 10  
      tt-itens.qt-atendida            COLUMN-LABEL "Qt Atendida"   FORMAT ">>>,>>>,>>9.99"   WIDTH 10
      tt-itens.ValorCancelado         COLUMN-LABEL "Vl.Cancelada"  FORMAT ">>>,>>>,>>9.99"   WIDTH 10  
      tt-itens.ValorPago              COLUMN-LABEL "Qt. Pago"      FORMAT ">>>,>>>,>>9.99"   WIDTH 10
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 135.14 BY 5.63
         FONT 7
         TITLE "Itens da Solicitaá∆o" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE br-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-pedido w-cadsim _FREEFORM
  QUERY br-pedido DISPLAY
      tt-pedido.nome-abrev       COLUMN-LABEL "Cliente"            WIDTH 11
      tt-pedido.nr-pedcli        COLUMN-LABEL "Pedido"             WIDTH  8
      tt-pedido.cod-estabel      COLUMN-LABEL "Estab"              WIDTH 5
      tt-pedido.dt-implantacao   COLUMN-LABEL "Implantaá∆o"        WIDTH 12 FORMAT "99/99/99"
      tt-pedido.dt-cancela       COLUMN-LABEL "Cancelamento"       WIDTH 14 FORMAT "99/99/99"
      tt-pedido.desc-sit-ped     COLUMN-LABEL "Situaá∆o Pedido"    WIDTH 16
      tt-pedido.vl-aprovado      COLUMN-LABEL "Aprovado Solic."    WIDTH 14
      tt-pedido.vl-liq-ped       COLUMN-LABEL "L°quido"            WIDTH 14
      tt-pedido.vl-tot-ped       COLUMN-LABEL "Total"              WIDTH 14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 121.72 BY 7.58
         FONT 7
         TITLE "Pedidos Vinculados a Solicitaá∆o" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN TOOLTIP "Pedido de venda gerado pela solicitaá∆o. Duplo Clique para detalhar faturamento".

DEFINE BROWSE br-solicitacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-solicitacao w-cadsim _FREEFORM
  QUERY br-solicitacao DISPLAY
      tt-solicitacao.c-ajuste                               COLUMN-LABEL "Tipo"         FORMAT "X(10)"                WIDTH 6.5
      tt-solicitacao.cod-emitente                           COLUMN-LABEL "Canal"                                      WIDTH 6.5
      tt-solicitacao.nome-abrev                             COLUMN-LABEL "NomeAbrev"        FORMAT "X(12)"            WIDTH 10
      tt-solicitacao.desc-beneficio                         COLUMN-LABEL "Benef°cio"        FORMAT "X(22)"            WIDTH 9
      tt-solicitacao.CodigoUnidadeNegocio                   COLUMN-LABEL "Unid."            FORMAT "X(3)"             WIDTH 3.5
      tt-solicitacao.DataCriacao                            COLUMN-LABEL "Criada em"        FORMAT "99/99/99"         WIDTH 7.7
      tt-solicitacao.hora                                   COLUMN-LABEL "Hora"                                       WIDTH 6.7
      tt-solicitacao.desc-forma-pagto-abrev                 COLUMN-LABEL "FormPagto"        FORMAT "X(24)"            WIDTH 8
      tt-solicitacao.vl-aprovado                            COLUMN-LABEL "Vl Solicitado"    FORMAT "->>>,>>>,>>9.99"  WIDTH 8.6
      tt-solicitacao.vl-empenho-pago                        COLUMN-LABEL "Pg. Trim. Ant."   FORMAT "->>>,>>>,>>9.99"  WIDTH 9.3
      tt-solicitacao.vl-abatido-verba                       COLUMN-LABEL "Pago Atual"       FORMAT "->>>,>>>,>>9.99"  WIDTH 8.8
      tt-solicitacao.a-pagar-solicit                        COLUMN-LABEL "Em Aberto"        FORMAT "->>>,>>>,>>9.99"  WIDTH 8.8
      tt-solicitacao.vl-abatido-parcial                     COLUMN-LABEL "Abatido T°tulo"   FORMAT "->>>,>>>,>>9.99"  WIDTH 9.4
      tt-solicitacao.vl-titulo                              COLUMN-LABEL "Saldo T°tulo"     FORMAT "->>>,>>>,>>9.99"  WIDTH 8.9
      tt-solicitacao.desc-situacao                          COLUMN-LABEL "Status"           FORMAT "X(10)"            WIDTH 9
      tt-solicitacao.log-enviada                            COLUMN-LABEL "Env.CRM"          FORMAT "SIM/N«O"          WIDTH 8
      tt-solicitacao.TrimestreCompetencia                   COLUMN-LABEL "Competància"      FORMAT "X(8)"             WIDTH 9
      tt-solicitacao.cod-gr-cob                             COLUMN-LABEL "Gr Cob."                                   WIDTH 6
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 140 BY 6.5
         TITLE "SOLICITAÄÂES" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN TOOLTIP "Seleciona para detalhamento".

DEFINE BROWSE br-tit-acr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-tit-acr w-cadsim _FREEFORM
  QUERY br-tit-acr DISPLAY
      tt-tit-acr.cod_estab          COLUMN-LABEL "Estab"        WIDTH 5
      tt-tit-acr.cod_espec_docto    COLUMN-LABEL "EspÇcie"      WIDTH 5
      tt-tit-acr.cod_ser_docto      COLUMN-LABEL "SÇrie"        WIDTH 5
      tt-tit-acr.cod_tit_acr        COLUMN-LABEL "T°tulo"       WIDTH 12
      tt-tit-acr.cod_parcela        COLUMN-LABEL "Parcela"      WIDTH 2
      tt-tit-acr.cdn_cliente        COLUMN-LABEL "Cliente"      WIDTH 14
      tt-tit-acr.nom_abrev          COLUMN-LABEL "NomAbrev"     WIDTH 12
      tt-tit-acr.cod_id_feder       COLUMN-LABEL "CNPJ"         WIDTH 12
      tt-tit-acr.dat_vencto_tit_acr COLUMN-LABEL "Vencto"       WIDTH 12
      tt-tit-acr.val_origin_tit_acr COLUMN-LABEL "Saldo Orig"   WIDTH 12
      tt-tit-acr.val-liquidado      COLUMN-LABEL "Vl Liquidado" WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 129.43 BY 6.58
         FONT 7
         TITLE "Abatimentos Contas a Receber" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN TOOLTIP "T°tulos abatidos atravÇs de encontro de contas".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     rs-canais AT ROW 3.63 COL 97 NO-LABEL WIDGET-ID 244
     rs-selecao AT ROW 2.79 COL 14 NO-LABEL WIDGET-ID 40
     fi-canal AT ROW 3.67 COL 12.43 COLON-ALIGNED WIDGET-ID 126
     fi-data-ini AT ROW 5.54 COL 12.43 COLON-ALIGNED WIDGET-ID 190
     fi-data-fim AT ROW 5.54 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 192
     fi-unidade-ini AT ROW 6.54 COL 16.86 COLON-ALIGNED WIDGET-ID 110
     fi-unidade-fim AT ROW 6.54 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     fi-gr-cob-ini AT ROW 7.54 COL 15.57 COLON-ALIGNED WIDGET-ID 160
     fi-gr-cob-fim AT ROW 7.54 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 162
     rs-tipo AT ROW 7.58 COL 74.86 HELP
          "Tipo de Solicitaá∆o (Normal/Ajuste de Saldo)" NO-LABEL WIDGET-ID 212
     rs-envio AT ROW 6.67 COL 74.86 HELP
          "Envio de Status da Solicitaá∆o para o CRM" NO-LABEL WIDGET-ID 234
     bt-listar-pedidos AT ROW 1.13 COL 116.86 HELP
          "Listar Pedidos gerados por Solicitaá‰es" WIDGET-ID 218
     cb-beneficio AT ROW 2.88 COL 71.43 COLON-ALIGNED WIDGET-ID 142
     cb-forma-pagto AT ROW 5.13 COL 71.43 COLON-ALIGNED WIDGET-ID 170
     cb-situacao AT ROW 4 COL 71.43 COLON-ALIGNED WIDGET-ID 148
     bt-filtrar AT ROW 4.79 COL 126.72 HELP
          "Buscar Solicitaá‰es" WIDGET-ID 132
     bt-encontro-contas AT ROW 8.79 COL 142.86 HELP
          "Encontro de Contas - Apb0735aa" WIDGET-ID 174
     bt-pagamento AT ROW 10.13 COL 142.86 HELP
          "Efetuar pagamento da solicitaá∆o" WIDGET-ID 184
     bt-ajuste-tit AT ROW 11.46 COL 142.86 HELP
          "Ajustar automaticamente o T°tulo no APB" WIDGET-ID 222
     bt-altera-titulo AT ROW 12.79 COL 142.86 HELP
          "Alteraá∆o T°tulo - App717aa" WIDGET-ID 176
     bt-exporta-solicitacao AT ROW 14.13 COL 142.86 HELP
          "Exportar Conta Corrente para Excel" WIDGET-ID 106
     bt-ok AT ROW 1.17 COL 137.29 HELP
          "Sair do programa" WIDGET-ID 242
     fi-nome-abrev AT ROW 3.67 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 238 NO-TAB-STOP 
     fi-nome AT ROW 4.58 COL 12.43 COLON-ALIGNED NO-LABEL WIDGET-ID 128 NO-TAB-STOP 
     br-solicitacao AT ROW 8.83 COL 2 WIDGET-ID 200
     "Status CRM:" VIEW-AS TEXT
          SIZE 10 BY .67 AT ROW 6.71 COL 64.43 WIDGET-ID 232
     "Itens da Solicitaá∆o" VIEW-AS TEXT
          SIZE 13.29 BY .67 AT ROW 15.79 COL 50.57 WIDGET-ID 188
          BGCOLOR 8 FONT 7
     "Visualizar:" VIEW-AS TEXT
          SIZE 10 BY .67 AT ROW 2.75 COL 95 WIDGET-ID 250
     "Abatimentos" VIEW-AS TEXT
          SIZE 8.72 BY .67 AT ROW 15.79 COL 37.57 WIDGET-ID 182
          BGCOLOR 8 FONT 7
     "Solicitaá‰es x Pagamentos" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1.46 COL 2.43 WIDGET-ID 122
          BGCOLOR 7 FONT 0
     "C. Corrente Benef°cio" VIEW-AS TEXT
          SIZE 14.72 BY .67 AT ROW 15.79 COL 65.72 WIDGET-ID 208
          BGCOLOR 8 FONT 7
     "Tipo Solicitaá∆o:" VIEW-AS TEXT
          SIZE 13.14 BY .67 AT ROW 7.58 COL 61.72 WIDGET-ID 216
     "Detalhe Solicitaá∆o" VIEW-AS TEXT
          SIZE 13.86 BY .67 AT ROW 15.79 COL 3.14
          BGCOLOR 8 FONT 7
     "Pedidos" VIEW-AS TEXT
          SIZE 6 BY .67 AT ROW 15.79 COL 22.72 WIDGET-ID 178
          BGCOLOR 8 FONT 7
     rt-button AT ROW 1 COL 2
     Rect-Main AT ROW 16.54 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 146.86 BY 24.88
         BGCOLOR 15 .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-cad
     folder-1 AT ROW 15.58 COL 2
     folder-4 AT ROW 15.58 COL 17.86 WIDGET-ID 10
     IMAGE-25 AT ROW 6.54 COL 25.86 WIDGET-ID 112
     IMAGE-26 AT ROW 6.54 COL 30 WIDGET-ID 114
     IMAGE-27 AT ROW 7.54 COL 26 WIDGET-ID 164
     IMAGE-28 AT ROW 7.54 COL 30 WIDGET-ID 166
     folder-5 AT ROW 15.58 COL 33.72 WIDGET-ID 180
     folder-6 AT ROW 15.58 COL 49.43 WIDGET-ID 186
     IMAGE-33 AT ROW 5.54 COL 25.86 WIDGET-ID 196
     IMAGE-34 AT ROW 5.54 COL 30 WIDGET-ID 198
     RECT-156 AT ROW 2.67 COL 2 WIDGET-ID 204
     folder-7 AT ROW 15.58 COL 65.14 WIDGET-ID 206
     RECT-158 AT ROW 2.67 COL 118 WIDGET-ID 248
     RECT-161 AT ROW 2.67 COL 57.86 WIDGET-ID 256
     RECT-162 AT ROW 3.17 COL 93.72 WIDGET-ID 258
     RECT-163 AT ROW 6.46 COL 57.86 WIDGET-ID 260
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 146.86 BY 24.88
         BGCOLOR 15 .

DEFINE FRAME fpage5
     br-tit-acr AT ROW 1.42 COL 2.57 HELP
          "T°tulos abatidos atravÇs de encontro de contas" WIDGET-ID 300
     bt-tit-acr AT ROW 1.5 COL 133 HELP
          "Consulta T°tulo Contas a Receber" WIDGET-ID 64
     fi-liquida-acr AT ROW 8.25 COL 117.29 COLON-ALIGNED WIDGET-ID 66
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 16.83
         SIZE 137 BY 8.46
         BGCOLOR 15 FGCOLOR 0 FONT 7 WIDGET-ID 400.

DEFINE FRAME fPage4
     br-pedido AT ROW 1.42 COL 2.29 HELP
          "Pedido de venda gerado pela solicitaá∆o. Duplo Clique para deta" WIDGET-ID 300
     bt-pedido AT ROW 1.5 COL 125 HELP
          "Consulta Pedido" WIDGET-ID 64
     bt-exporta-pedidos AT ROW 2.92 COL 125 HELP
          "Exportar Pedidos para Excel" WIDGET-ID 106
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 16.83
         SIZE 138 BY 8.46
         BGCOLOR 15 FGCOLOR 0 FONT 7.

DEFINE FRAME fPage1
     fi-cond-pagto AT ROW 7.25 COL 13.43 COLON-ALIGNED WIDGET-ID 196
     fi-descricao AT ROW 1.5 COL 13.86 COLON-ALIGNED WIDGET-ID 138
     fi-nome-emit AT ROW 2.5 COL 13.86 COLON-ALIGNED WIDGET-ID 140
     fi-beneficio AT ROW 3.5 COL 13.86 COLON-ALIGNED WIDGET-ID 142
     fi-forma-pagto AT ROW 4.5 COL 13.86 COLON-ALIGNED WIDGET-ID 144
     ed-descritivo AT ROW 6.33 COL 91.29 NO-LABEL WIDGET-ID 146
     fi-valor AT ROW 1.5 COL 92.57 COLON-ALIGNED WIDGET-ID 160
     fi-unidade AT ROW 3.5 COL 42 COLON-ALIGNED WIDGET-ID 150
     fi-grupo-cob AT ROW 4.5 COL 44 COLON-ALIGNED WIDGET-ID 152
     fi-situacao-solicitacao AT ROW 6.25 COL 13.43 COLON-ALIGNED WIDGET-ID 158
     fi-status AT ROW 6.25 COL 41.29 COLON-ALIGNED WIDGET-ID 168
     tg-integrada AT ROW 2.5 COL 60 WIDGET-ID 172
     fi-valor-abater AT ROW 1.5 COL 122.43 COLON-ALIGNED WIDGET-ID 174
     fi-data AT ROW 3.5 COL 57 COLON-ALIGNED WIDGET-ID 180
     fi-hora AT ROW 4.5 COL 57 COLON-ALIGNED WIDGET-ID 182
     fi-valor-pago AT ROW 2.54 COL 122.43 COLON-ALIGNED WIDGET-ID 184
     fi-valor-cancelado AT ROW 4.5 COL 122.43 COLON-ALIGNED NO-LABEL WIDGET-ID 186
     fi-validade AT ROW 8.17 COL 13.43 COLON-ALIGNED WIDGET-ID 198
     fi-transacao AT ROW 7.25 COL 41.29 COLON-ALIGNED WIDGET-ID 200
     fi-forma-canc AT ROW 8.25 COL 41.29 COLON-ALIGNED WIDGET-ID 202
     tg-descarta-verba AT ROW 1.5 COL 60 WIDGET-ID 204
     fi-pagtos AT ROW 2.5 COL 92.57 COLON-ALIGNED WIDGET-ID 212
     fi-empenho-transferido AT ROW 6.54 COL 72.72 COLON-ALIGNED WIDGET-ID 220
     fi-empenho-pago AT ROW 7.38 COL 72.72 COLON-ALIGNED WIDGET-ID 222
     fi-empenho-cancelado AT ROW 8.21 COL 72.72 COLON-ALIGNED WIDGET-ID 224
     fi-pagtos-ant AT ROW 3.5 COL 92.57 COLON-ALIGNED WIDGET-ID 226
     fi-a-pagar AT ROW 4.5 COL 92.57 COLON-ALIGNED WIDGET-ID 228
     "Descritivo:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 5.75 COL 91.14 WIDGET-ID 148
     "Valores:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 1.04 COL 76 WIDGET-ID 190
     "Empenho Transferido outro(s) Trimestre(s):" VIEW-AS TEXT
          SIZE 29 BY .54 AT ROW 5.79 COL 57.86 WIDGET-ID 216
     "Financeiro:" VIEW-AS TEXT
          SIZE 7.57 BY .54 AT ROW 1.04 COL 110.72 WIDGET-ID 208
     "Cancelado:" VIEW-AS TEXT
          SIZE 7.57 BY .54 AT ROW 4 COL 111 WIDGET-ID 232
     RECT-143 AT ROW 1.25 COL 1.57 WIDGET-ID 162
     RECT-144 AT ROW 1.25 COL 75.86 WIDGET-ID 164
     RECT-145 AT ROW 6.04 COL 89.57 WIDGET-ID 166
     RECT-147 AT ROW 6 COL 1.72 WIDGET-ID 194
     RECT-148 AT ROW 1.25 COL 110 WIDGET-ID 206
     RECT-146 AT ROW 6.04 COL 56.72 WIDGET-ID 214
     RECT-149 AT ROW 4.25 COL 110 WIDGET-ID 230
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 16.83
         SIZE 138 BY 8.46
         BGCOLOR 15 FGCOLOR 0 FONT 7.

DEFINE FRAME fpage7
     bt-cc AT ROW 1.29 COL 125 HELP
          "Consulta Conta Corrente do Benef°cio" WIDGET-ID 64
     fi-VerbaCalculada AT ROW 1.5 COL 64.29 COLON-ALIGNED WIDGET-ID 154
     fi-periodo-ini AT ROW 1.83 COL 13.86 COLON-ALIGNED WIDGET-ID 12
     fi-periodo-fim AT ROW 1.83 COL 26.14 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     fi-analise AT ROW 1.83 COL 109 COLON-ALIGNED WIDGET-ID 166
     fi-VerbaAcumulada AT ROW 2.5 COL 64.29 COLON-ALIGNED WIDGET-ID 196
     bt-titulo-2 AT ROW 2.58 COL 125 HELP
          "Consulta t°tulo APB vinculado a Conta Corrente" WIDGET-ID 136
     fi-unidade AT ROW 2.83 COL 13.86 COLON-ALIGNED WIDGET-ID 2
          LABEL "Unid. Neg¢cio:" FORMAT "X(256)":U
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     fi-aprovada AT ROW 2.83 COL 109 COLON-ALIGNED WIDGET-ID 168
     fi-VerbaTransferida AT ROW 3.5 COL 64.29 COLON-ALIGNED WIDGET-ID 156
     fi-classificacao AT ROW 3.83 COL 13.86 COLON-ALIGNED WIDGET-ID 8
     fi-EmpenhoTotal AT ROW 3.83 COL 109 COLON-ALIGNED WIDGET-ID 188
     fi-VerbaTotal AT ROW 4.5 COL 64.29 COLON-ALIGNED WIDGET-ID 158
     fi-categoria AT ROW 4.83 COL 13.86 COLON-ALIGNED WIDGET-ID 10
     fi-Reembolsado AT ROW 5.79 COL 109 COLON-ALIGNED WIDGET-ID 190
     fi-VerbaCancelada AT ROW 6 COL 65 COLON-ALIGNED WIDGET-ID 162
     fi-VerbaAjustada AT ROW 7 COL 65 COLON-ALIGNED WIDGET-ID 164
     fi-vl-ating-meta AT ROW 7.04 COL 13.86 COLON-ALIGNED WIDGET-ID 90
     fi-perc-beneficio AT ROW 7.04 COL 32.86 COLON-ALIGNED WIDGET-ID 186
     fi-SaldoDisponivel AT ROW 7.79 COL 105 COLON-ALIGNED WIDGET-ID 180
     fi-vl-custo AT ROW 8.04 COL 13.86 COLON-ALIGNED WIDGET-ID 88
     fi-Finalizada-Stock-Rotation AT ROW 8.21 COL 65 COLON-ALIGNED WIDGET-ID 224
     "Movimentaá‰es:" VIEW-AS TEXT
          SIZE 12 BY .54 AT ROW 5.58 COL 45.86 WIDGET-ID 174
     "Provisionamento:" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 6.21 COL 5 WIDGET-ID 96
     "Geral:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 1.04 COL 5 WIDGET-ID 178
     "Solicitaá‰es:" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 1.04 COL 83 WIDGET-ID 176
     "Verba Original:" VIEW-AS TEXT
          SIZE 10.43 BY .54 AT ROW 1.04 COL 45.57 WIDGET-ID 172
     RECT-52 AT ROW 6.54 COL 3.86 WIDGET-ID 94
     RECT-53 AT ROW 1.29 COL 3.86 WIDGET-ID 138
     RECT-56 AT ROW 1.33 COL 44.29 WIDGET-ID 150
     RECT-57 AT ROW 5.79 COL 44.29 WIDGET-ID 160
     RECT-58 AT ROW 1.33 COL 82 WIDGET-ID 170
     RECT-60 AT ROW 5.33 COL 82 WIDGET-ID 192
     RECT-61 AT ROW 7.33 COL 82 WIDGET-ID 194
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 16.83
         SIZE 138 BY 8.46
         BGCOLOR 15 FGCOLOR 0 FONT 7 WIDGET-ID 600.

DEFINE FRAME fpage6
     br-itens AT ROW 1.38 COL 1.86 WIDGET-ID 700
     fi-item-aberto AT ROW 7.38 COL 84 COLON-ALIGNED WIDGET-ID 68
     fi-item-atendido AT ROW 7.38 COL 115.43 COLON-ALIGNED WIDGET-ID 66
     bt-pedido-2 AT ROW 7.5 COL 132.86 HELP
          "Consulta Pedido" WIDGET-ID 64
     fi-emp-vl-cancelado AT ROW 7.96 COL 32.86 COLON-ALIGNED WIDGET-ID 84
     fi-emp-vl-pago AT ROW 8 COL 8.72 COLON-ALIGNED WIDGET-ID 82
     fi-emp-qtde-cancelada AT ROW 8 COL 59.14 COLON-ALIGNED WIDGET-ID 86
     fi-item-cancelado AT ROW 8.38 COL 84 COLON-ALIGNED WIDGET-ID 70
     fi-item-abatido-apb AT ROW 8.38 COL 115.43 COLON-ALIGNED WIDGET-ID 76
     "Empenho Transferido Outro(s) Trimestre(s):" VIEW-AS TEXT
          SIZE 29 BY .54 AT ROW 7.25 COL 3 WIDGET-ID 80
     RECT-157 AT ROW 7.58 COL 2 WIDGET-ID 78
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 16.83
         SIZE 138 BY 8.46
         BGCOLOR 15 FGCOLOR 0 FONT 7 WIDGET-ID 500.


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
         HEIGHT             = 24.88
         WIDTH              = 146.86
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME f-cad:HANDLE
       FRAME fPage4:FRAME = FRAME f-cad:HANDLE
       FRAME fpage5:FRAME = FRAME f-cad:HANDLE
       FRAME fpage6:FRAME = FRAME f-cad:HANDLE
       FRAME fpage7:FRAME = FRAME f-cad:HANDLE.

/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-solicitacao IMAGE-28 f-cad */
ASSIGN 
       br-solicitacao:ALLOW-COLUMN-SEARCHING IN FRAME f-cad = TRUE
       br-solicitacao:COLUMN-RESIZABLE IN FRAME f-cad       = TRUE.

ASSIGN 
       fi-nome:READ-ONLY IN FRAME f-cad        = TRUE.

ASSIGN 
       fi-nome-abrev:READ-ONLY IN FRAME f-cad        = TRUE.

/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
ASSIGN 
       ed-descritivo:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-a-pagar:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-beneficio:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-cond-pagto:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-data:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-descricao:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-empenho-cancelado:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-empenho-pago:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-empenho-transferido:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-forma-canc:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-forma-pagto:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-grupo-cob:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-hora:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-nome-emit:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-pagtos:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-pagtos-ant:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-situacao-solicitacao:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-status:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-transacao:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-unidade:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-validade:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-valor:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-valor-abater:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-valor-cancelado:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-valor-pago:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR TOGGLE-BOX tg-descarta-verba IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-integrada IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB br-pedido 1 fPage4 */
ASSIGN 
       br-pedido:ALLOW-COLUMN-SEARCHING IN FRAME fPage4 = TRUE
       br-pedido:COLUMN-RESIZABLE IN FRAME fPage4       = TRUE.

/* SETTINGS FOR FRAME fpage5
                                                                        */
/* BROWSE-TAB br-tit-acr 1 fpage5 */
ASSIGN 
       br-tit-acr:ALLOW-COLUMN-SEARCHING IN FRAME fpage5 = TRUE
       br-tit-acr:COLUMN-RESIZABLE IN FRAME fpage5       = TRUE.

ASSIGN 
       fi-liquida-acr:READ-ONLY IN FRAME fpage5        = TRUE.

/* SETTINGS FOR FRAME fpage6
                                                                        */
/* BROWSE-TAB br-itens RECT-157 fpage6 */
ASSIGN 
       br-itens:ALLOW-COLUMN-SEARCHING IN FRAME fpage6 = TRUE
       br-itens:COLUMN-RESIZABLE IN FRAME fpage6       = TRUE.

ASSIGN 
       fi-item-abatido-apb:READ-ONLY IN FRAME fpage6        = TRUE.

ASSIGN 
       fi-item-aberto:READ-ONLY IN FRAME fpage6        = TRUE.

ASSIGN 
       fi-item-atendido:READ-ONLY IN FRAME fpage6        = TRUE.

ASSIGN 
       fi-item-cancelado:READ-ONLY IN FRAME fpage6        = TRUE.

/* SETTINGS FOR FRAME fpage7
                                                                        */
/* SETTINGS FOR FILL-IN fi-analise IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-aprovada IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-categoria IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-classificacao IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-EmpenhoTotal IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-Finalizada-Stock-Rotation IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-perc-beneficio IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-fim IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-ini IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-Reembolsado IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-SaldoDisponivel IN FRAME fpage7
   NO-ENABLE                                                            */
ASSIGN 
       fi-SaldoDisponivel:READ-ONLY IN FRAME fpage7        = TRUE.

/* SETTINGS FOR FILL-IN fi-unidade IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-VerbaAcumulada IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-VerbaAjustada IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-VerbaCalculada IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-VerbaCancelada IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-VerbaTotal IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-VerbaTransferida IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vl-ating-meta IN FRAME fpage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vl-custo IN FRAME fpage7
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-itens
/* Query rebuild information for BROWSE br-itens
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-itens BY tt-itens.CodigoEstabelecimento
                                          BY tt-itens.CodigoProduto
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-itens */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-pedido
/* Query rebuild information for BROWSE br-pedido
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-pedido BY tt-pedido.nr-pedcli
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-pedido */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-solicitacao
/* Query rebuild information for BROWSE br-solicitacao
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-solicitacao BY tt-solicitacao.DataCriacao  DESC
                                                BY tt-solicitacao.hora      DESC
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-solicitacao */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-tit-acr
/* Query rebuild information for BROWSE br-tit-acr
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-tit-acr BY tt-tit-acr.cod_tit_acr
                                            BY tt-tit-acr.cod_parcela
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-tit-acr */
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


&Scoped-define BROWSE-NAME br-itens
&Scoped-define FRAME-NAME fpage6
&Scoped-define SELF-NAME br-itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-itens w-cadsim
ON START-SEARCH OF br-itens IN FRAME fpage6 /* Itens da Solicitaá∆o */
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


&Scoped-define BROWSE-NAME br-pedido
&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME br-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedido w-cadsim
ON MOUSE-SELECT-DBLCLICK OF br-pedido IN FRAME fPage4 /* Pedidos Vinculados a Solicitaá∆o */
DO:

    IF  NOT AVAIL tt-solicitacao THEN
        RETURN NO-APPLY.

    APPLY "CHOOSE"  TO bt-pedido IN FRAME fpage4.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedido w-cadsim
ON START-SEARCH OF br-pedido IN FRAME fPage4 /* Pedidos Vinculados a Solicitaá∆o */
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


&Scoped-define BROWSE-NAME br-solicitacao
&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME br-solicitacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-solicitacao w-cadsim
ON MOUSE-SELECT-CLICK OF br-solicitacao IN FRAME f-cad /* SOLICITAÄÂES */
DO:
  IF  NOT AVAIL tt-solicitacao THEN
      RETURN "OK".

  RUN pi-carrega-detalhes.
  RUN pi-carrega-pedidos.
  RUN pi-carrega-tit-acr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-solicitacao w-cadsim
ON RIGHT-MOUSE-DBLCLICK OF br-solicitacao IN FRAME f-cad /* SOLICITAÄÂES */
DO:

    IF  AVAIL tt-solicitacao THEN DO:
    
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 15825,
                           INPUT "C¢digo Indentificado da Solicitaá∆o CRM " + "~~" + "GUID: " + STRING(tt-solicitacao.CodigoSolicitacaoBeneficio)).
        
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-solicitacao w-cadsim
ON ROW-DISPLAY OF br-solicitacao IN FRAME f-cad /* SOLICITAÄÂES */
DO:
   
    IF  tt-solicitacao.vl-titulo < tt-solicitacao.ValorAbater 
    AND tt-solicitacao.SituacaoSolicitacaoBeneficio = 993520003 THEN
        ASSIGN /*tt-solicitacao.vl-titulo:BGCOLOR IN BROWSE br-solicitacao = 14*/
               tt-solicitacao.vl-titulo:FGCOLOR IN BROWSE br-solicitacao = 12
               /*tt-solicitacao.vl-titulo:FONT    IN BROWSE br-solicitacao = 0*/ .
    ELSE
        ASSIGN /*tt-solicitacao.vl-titulo:BGCOLOR IN BROWSE br-solicitacao = 20*/ /*15*/
               tt-solicitacao.vl-titulo:FGCOLOR IN BROWSE br-solicitacao = 0
               /*tt-solicitacao.vl-titulo:FONT    IN BROWSE br-solicitacao = 1*/.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-solicitacao w-cadsim
ON START-SEARCH OF br-solicitacao IN FRAME f-cad /* SOLICITAÄÂES */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-solicitacao w-cadsim
ON VALUE-CHANGED OF br-solicitacao IN FRAME f-cad /* SOLICITAÄÂES */
DO: 

    IF  NOT AVAIL tt-solicitacao THEN
        RETURN "OK".

    RUN pi-carrega-cc. 
    RUN pi-carrega-detalhes. 
    RUN pi-carrega-pedidos. 
    RUN pi-carrega-tit-acr.
    
/*                                                                              */
/*     IF  AVAIL tt-conta-corrente THEN                                         */
/*         RUN pi-seta-status-crm-em-tela (INPUT tt-conta-corrente.status-crm). */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-tit-acr
&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME br-tit-acr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tit-acr w-cadsim
ON MOUSE-SELECT-DBLCLICK OF br-tit-acr IN FRAME fpage5 /* Abatimentos Contas a Receber */
DO:

    IF  NOT AVAIL tt-tit-acr THEN
        RETURN NO-APPLY.

    APPLY "CHOOSE"  TO bt-tit-acr IN FRAME fpage5.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tit-acr w-cadsim
ON START-SEARCH OF br-tit-acr IN FRAME fpage5 /* Abatimentos Contas a Receber */
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


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME bt-ajuste-tit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuste-tit w-cadsim
ON CHOOSE OF bt-ajuste-tit IN FRAME f-cad
DO:
    DEF VAR de-titulo AS DEC NO-UNDO.
    
    DEF VAR i-cont AS INTEGER NO-UNDO.
        
    IF  br-solicitacao:num-selected-rows <> 1 THEN DO:
        RUN utp/ut-msgs.p(input "show":U,
                          input 17006,
                          input  "Apenas uma solicitaá∆o de cada vez pode estar selecionada para ajuste de t°tulo.").
        RETURN NO-APPLY.
    END.


    /* VALIDAÄÂES*/
    IF  NOT tt-solicitacao.SituacaoSolicitacaoBeneficio = 993520003 THEN DO:
        /* PENDENTE DE PAGAMENTO*/
        RUN utp/ut-msgs.p(input "show":U,
                  input 17006,
                  input  "Situaá∆o da Solicitaá∆o n∆o permite Ajuste de saldo.").
        RETURN "NOK".
    END.

    IF  tt-solicitacao.desc-forma-pagto = "Produto" THEN DO:
        RUN utp/ut-msgs.p(input "show":U,
                  input 17006,
                  input  "Forma de pagamento <Produto> n∆o permite ajuste de saldo de t°tulo").
        RETURN "NOK".
    END.

    FOR LAST int-cc-benef NO-LOCK
        WHERE int-cc-benef.tp-movto       = 2 /*DESPESA*/
          AND int-cc-benef.tipo-beneficio = tt-solicitacao.tipo-beneficio
          AND int-cc-benef.unid-neg       = tt-solicitacao.CodigoUnidadeNegocio
          AND int-cc-benef.canal          = tt-solicitacao.cod-emitente
          AND int-cc-benef.dt-periodo-ini = tt-solicitacao.dt-periodo-ini
          AND int-cc-benef.dt-periodo-fim = tt-solicitacao.dt-periodo-fim:

        FIND FIRST tit_ap NO-LOCK                                                 
            WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab              
              AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.         

        IF  AVAIL tit_ap THEN
            ASSIGN de-titulo = tit_ap.val_sdo_tit_ap.
    END.

    IF  tt-solicitacao.ValorAbater <= de-titulo THEN
        RETURN NO-APPLY.

    DEF VAR r-row-solicitacao AS ROWID NO-UNDO.
    DEF VAR l-ok              AS LOG   NO-UNDO.

    DEF BUFFER b-tt-solicitacao FOR tt-solicitacao.

    ASSIGN r-row-solicitacao = tt-solicitacao.r-solicitacao.

    RUN esp/esb/esesb010c.w (INPUT  tt-solicitacao.r-conta-corrente,
                             INPUT  tt-solicitacao.ValorAbater,
                             OUTPUT l-ok).

    IF  l-ok THEN DO:
        
        APPLY "CHOOSE" TO bt-filtrar IN FRAME f-cad.

        FIND FIRST b-tt-solicitacao
            WHERE b-tt-solicitacao.r-solicitacao = r-row-solicitacao NO-ERROR.
    
        REPOSITION br-solicitacao TO ROWID b-tt-solicitacao.r-tt-solicitacao.
        APPLY "value-changed"        TO br-solicitacao IN FRAME f-cad.

        /* AGENDA O ENVIO DO STATUS (MSG0154) E SALDO (MSG0159) PARA O CRM */
        IF  AVAIL  b-tt-solicitacao THEN
            RUN piEnviaSaldosBarramento (INPUT b-tt-solicitacao.CodigoSolicitacaoBeneficio,
                                         INPUT STRING(b-tt-solicitacao.cod-emitente)).

    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-altera-titulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-altera-titulo w-cadsim
ON CHOOSE OF bt-altera-titulo IN FRAME f-cad
DO:

    ASSIGN v_rec_tit_ap = ?.

    /* Conta corrente */
    FIND LAST int-cc-benef NO-LOCK
        WHERE int-cc-benef.tp-movto       = 2 /*DESPESA*/
          AND int-cc-benef.tipo-beneficio = tt-solicitacao.tipo-beneficio
          AND int-cc-benef.unid-neg       = tt-solicitacao.CodigoUnidadeNegocio
          AND int-cc-benef.canal          = tt-solicitacao.cod-emitente
          AND int-cc-benef.dt-periodo-ini = tt-solicitacao.dt-periodo-ini
          AND int-cc-benef.dt-periodo-fim = tt-solicitacao.dt-periodo-fim
          AND int-cc-benef.id-status      = 1 NO-ERROR. /* ATIVO*/ 

    FIND FIRST tit_ap NO-LOCK                                                 
        WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab              
          AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.

    IF  NOT AVAIL  tit_ap THEN
        RETURN "OK".

    ASSIGN v_rec_tit_ap = RECID(tit_ap).

    RUN prgfin/apb/apb717aa.p.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage7
&Scoped-define SELF-NAME bt-cc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cc w-cadsim
ON CHOOSE OF bt-cc IN FRAME fpage7
DO:
  
    IF  AVAIL int-cc-benef THEN DO:

        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        ASSIGN gr-conta-corrente = ROWID(int-cc-benef).
        RUN esp/esb/esesb008.w.
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME bt-encontro-contas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-encontro-contas w-cadsim
ON CHOOSE OF bt-encontro-contas IN FRAME f-cad
DO:
    DEF VAR i-cont AS INTEGER NO-UNDO.
        
    IF  br-solicitacao:num-selected-rows <> 1 THEN DO:
        RUN utp/ut-msgs.p(input "show":U,
                          input 17006,
                          input  "Apenas uma solicitaá∆o pode ser paga de cada vez").
        RETURN NO-APPLY.
    END.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    
    IF  tt-solicitacao.vl-titulo < tt-solicitacao.ValorAbater THEN
        APPLY "CHOOSE" TO bt-ajuste-tit IN FRAME f-cad.
    
    DEF VAR l-erro              AS LOG NO-UNDO.
    DEF VAR i                   AS INT NO-UNDO.
    DEF VAR r-row-solicitacao   AS ROWID NO-UNDO.
    DEF BUFFER b-tt-solicitacao FOR tt-solicitacao.

    ASSIGN r-row-solicitacao = tt-solicitacao.r-solicitacao.

    IF  NOT AVAIL tt-solicitacao THEN
        RETURN NO-APPLY.

    IF  tt-solicitacao.SituacaoSolicitacaoBeneficio <> 993520003  /* Pendente */ THEN  DO:
        RUN utp/ut-msgs.p(input "show":U,
                          input 17006,
                          input  "Situaá∆o da Solicitaá∆o n∆o permite encontro de contas" + "~~Solicitaá∆o deve estar pendente de pagamento").
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
        RETURN NO-APPLY.
    END.

    IF  tt-solicitacao.desc-forma-pagto <> "Desconto em duplicata" THEN DO:
        RUN utp/ut-msgs.p(input "show":U,
                          input 17006,
                          input  "Forma de pagamento inv†lida" + "~~ Solicitaá∆o n∆o permite pagamento via Desconto em Duplicatas").
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
        RETURN NO-APPLY.
    END.

    /* Conta corrente */
    FIND LAST int-cc-benef NO-LOCK
        WHERE int-cc-benef.tp-movto        = 2 /*DESPESA*/
          AND int-cc-benef.tipo-beneficio  = tt-solicitacao.tipo-beneficio
          AND int-cc-benef.unid-neg        = tt-solicitacao.CodigoUnidadeNegocio
          AND int-cc-benef.canal           = tt-solicitacao.cod-emitente
          AND int-cc-benef.dt-periodo-ini  = tt-solicitacao.dt-periodo-ini
          AND int-cc-benef.dt-periodo-fim  = tt-solicitacao.dt-periodo-fim
          AND int-cc-benef.id-status       = 1 NO-ERROR. /* ATIVO*/ 

    IF  NOT AVAIL int-cc-benef THEN DO:
        RUN utp/ut-msgs.p(input "show":U, 
                          input 17006,
                          input  "N∆o foi encontrada conta corrente relacionada a esta Solicitaá∆o. Verificar se a conta corrente est† inativa.").
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
        RETURN NO-APPLY.
    END.

    FIND FIRST tit_ap NO-LOCK                                                 
        WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab              
          AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.

    IF  NOT AVAIL  tit_ap THEN DO:
        RUN utp/ut-msgs.p(input "show":U, 
                          input 17006,
                          input  "N∆o encontrado T°tulo a Pagar relacionado a conta corrente: " + "~~" +
                                 "Benef°cio: " + fnBeneficio(int-cc-benef.tipo-beneficio) + CHR(10) + 
                                 "Unidade..: " + int-cc-benef.unid-neg                    + CHR(10) +
                                 "Canal....: " + string(int-cc-benef.canal)               + CHR(10) +
                                 "Status...: Ativo ").
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
        RETURN NO-APPLY.
    END.

    EMPTY TEMP-TABLE tt-titulo-acr.
    EMPTY TEMP-TABLE tt-erro.


    DEF VAR de-valor-a-abater AS DEC NO-UNDO.
    DEF VAR da-transacao      AS DATE NO-UNDO.

    ASSIGN de-valor-a-abater = tt-solicitacao.ValorAbater .

    /* PROGRAMA DE ENCONTRO DE CONTAS */
    RUN esp/esb/esesb010a.w (INPUT tt-solicitacao.cod-emitente,
                             INPUT de-valor-a-abater,
                             OUTPUT da-transacao,
                             OUTPUT TABLE tt-titulo-acr,
                             OUTPUT TABLE tt-erro).

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
            
            ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
            RETURN NO-APPLY.
        END.
    END.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    IF  NOT CAN-FIND (FIRST tt-titulo-acr) THEN
        RETURN "NO-APPLY". 
    
    /* API ENCONTRO DE CONTAS */
    EMPTY TEMP-TABLE tt-erro-aux.
    RUN esp/esb/esesbapi008.p (INPUT tt-solicitacao.r-solicitacao,
                               INPUT tit_ap.cod_estab,
                               INPUT int-cc-benef.canal,
                               INPUT tit_ap.cod_tit_ap,
                               INPUT "U",
                               INPUT tit_ap.cod_espec_docto,
                               INPUT tit_ap.cod_parcela,
                               INPUT de-valor-a-abater,
                               INPUT da-transacao,
                               INPUT TABLE tt-titulo-acr,
                               OUTPUT TABLE tt-erro).


    IF  RETURN-VALUE <> "OK" THEN 
        l-erro = YES.

    FOR EACH tt-erro:
        ASSIGN i = i + 10.
        CREATE tt-erro-aux.
        ASSIGN tt-erro-aux.i-sequen = i
               tt-erro-aux.cd-erro  = tt-erro.codigo
               tt-erro-aux.mensagem = tt-erro.mensagem + CHR(10) + "Detalhe: " + tt-erro.ajuda.
    END.
    
    EMPTY TEMP-TABLE tt-erro.

    IF  CAN-FIND (FIRST tt-erro-aux) THEN DO:
        RUN cdp/cd0666.w (INPUT TABLE tt-erro-aux).
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
        RETURN NO-APPLY.
    END.
    IF  l-erro THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Erro ao processar encontro de contas" + "~~" +
                                "N∆o foi poss°vel efetuar o processamento").
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES. 
        RETURN NO-APPLY.
    END.


    RUN utp/ut-msgs.p(INPUT "show",
                      INPUT 15825,
                      INPUT "Encontro de contas realizado com sucesso!" + "~~" +
                            "A Solicitaá∆o foi alterada para paga." ).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    /* REPOSICIONAR ATUALIZANDO OS VALORES NA TELA.*/ 
    ASSIGN cb-situacao:SCREEN-VALUE IN FRAME f-cad = "Pagas".
    
    APPLY "CHOOSE" TO bt-filtrar IN FRAME f-cad.

    FIND FIRST b-tt-solicitacao
        WHERE b-tt-solicitacao.r-solicitacao = r-row-solicitacao NO-ERROR.

    IF  AVAIL b-tt-solicitacao THEN DO:
        REPOSITION br-solicitacao TO ROWID b-tt-solicitacao.r-tt-solicitacao.
        APPLY "value-changed"  TO br-solicitacao IN FRAME f-cad.

        /* AGENDA O ENVIO DO STATUS (MSG0154) E SALDO (MSG0159) PARA O CRM */
        RUN piEnviaSaldosBarramento (INPUT b-tt-solicitacao.CodigoSolicitacaoBeneficio,
                                     INPUT STRING(b-tt-solicitacao.cod-emitente)).


    END.

    RETURN "OK".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-exporta-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exporta-pedidos w-cadsim
ON CHOOSE OF bt-exporta-pedidos IN FRAME fPage4
DO:

    RUN pi-gera-excel-ped-venda.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME bt-exporta-solicitacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exporta-solicitacao w-cadsim
ON CHOOSE OF bt-exporta-solicitacao IN FRAME f-cad
DO:

    RUN pi-gera-excel-solicitacao.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtrar w-cadsim
ON CHOOSE OF bt-filtrar IN FRAME f-cad
DO:
    RUN pi-limpa-tela.
    EMPTY TEMP-TABLE tt-pedido.
    EMPTY TEMP-TABLE tt-conta-corrente.
    EMPTY TEMP-TABLE tt-tit-acr.
    EMPTY TEMP-TABLE tt-itens.

    RUN pi-carrega-solicitacoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-listar-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-listar-pedidos w-cadsim
ON CHOOSE OF bt-listar-pedidos IN FRAME f-cad
DO:
 
    RUN esp/esb/esesb010B.w.

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


&Scoped-define SELF-NAME bt-pagamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pagamento w-cadsim
ON CHOOSE OF bt-pagamento IN FRAME f-cad
DO:
    DEF VAR i-cont AS INTEGER NO-UNDO.
    
    DO  i-cont = 1 to br-solicitacao:num-selected-rows:
        IF  br-solicitacao:fetch-selected-row (i-cont) THEN DO:
            /* PENDENTE DE PAGAMENTO*/
            IF  tt-solicitacao.desc-forma-pagto <> "Dinheiro" THEN DO:
                RUN utp/ut-msgs.p(input "show":U,
                                  input 17006,
                                  input  "Apenas solicitaá‰es cuja forma de pagamento seja <Dinheiro> devem ser selecionadas.").
                RETURN "NOK".
            END.

            /* PENDENTE DE PAGAMENTO*/
            IF  NOT tt-solicitacao.SituacaoSolicitacaoBeneficio = 993520003 THEN DO:
                RUN utp/ut-msgs.p(input "show":U,
                                  input 17006,
                                  input  "As Solicitaá‰es devem estar com situaá∆o <Pendente> para que possam ser pagas.").
                RETURN "NOK".
            END.
        END.   
    END.

    RUN utp/ut-msgs.p (input "show", input 27100, input "Confirma o Pagamento?" + "~~" +
               "Todas as solicitaá‰es selecionadas ser∆o sinalizadas como pagas. Confirma?").

    IF  RETURN-VALUE <> "YES" THEN 
        RETURN NO-APPLY.

    DO  i-cont = 1 to br-solicitacao:num-selected-rows:
        IF  br-solicitacao:fetch-selected-row (i-cont) THEN DO:
        
            /* Verifica Solicitaá‰es em aberto */
             blk-principal:
             DO TRANSACTION
             ON ERROR UNDO blk-principal,LEAVE blk-principal
             ON STOP  UNDO blk-principal,LEAVE blk-principal:
        
                 FIND FIRST int-solicitacao EXCLUSIVE-LOCK
                     WHERE rowid(int-solicitacao) = tt-solicitacao.r-solicitacao.
        
                 /* ATUALIZAR O CONTAS A PAGAR */
                 IF  AVAIL int-solicitacao THEN 
                     ASSIGN int-solicitacao.SituacaoSolicitacaoBeneficio  = 993520004
                            int-solicitacao.ValorPago                     = int-solicitacao.ValorAbater.
        
                 FIND CURRENT int-solicitacao NO-LOCK.
                      
                 /* AGENDA O ENVIO DO STATUS (MSG0154) E SALDO (MSG0159) PARA O CRM */
                 IF  AVAIL int-solicitacao THEN
                     RUN piEnviaSaldosBarramento (INPUT int-solicitacao.CodigoSolicitacaoBeneficio,
                                                  INPUT STRING(int-solicitacao.cod-emitente)).
        
                 RELEASE int-solicitacao.
                
             END.
        END.   
    END.




    /*


    IF  NOT AVAIL tt-solicitacao THEN
        RETURN "NOK".

    IF  NOT tt-solicitacao.SituacaoSolicitacaoBeneficio = 993520003 THEN DO:
        /* PENDENTE DE PAGAMENTO*/
        RUN utp/ut-msgs.p(input "show":U,
                  input 17006,
                  input  "Situaá∆o da Solicitaá∆o n∆o permite pagamento.").
        RETURN "NOK".
    END.

    IF  tt-solicitacao.desc-forma-pagto <> "Dinheiro" THEN DO:
        /* PENDENTE DE PAGAMENTO*/
        RUN utp/ut-msgs.p(input "show":U,
                  input 17006,
                  input  "Forma de pagamento n∆o permite pagamento manual").
        RETURN "NOK".
    END.



 /*                                                                                                                            */
/*                                                                                                                            */
/*     DEF VAR de-saldo-disp   AS DEC NO-UNDO.                                                                                */
/*     DEF VAR de-saldo-titulo AS DEC NO-UNDO.                                                                                */
/*                                                                                                                            */
/*     RUN pi-retorna-saldo-disponivel (INPUT  tt-solicitacao.r-solicitacao,                                                  */
/*                                      OUTPUT de-saldo-titulo,                                                               */
/*                                      OUTPUT de-saldo-disp).                                                                */
/*                                                                                                                            */
/*     /* BATER O VALOR CHEIO SOLICITADO COM O VALOR CHEIO DA CONTA CORRENTE */                                               */
/*     IF  de-saldo-disp < tt-solicitacao.ValorSolicitado                                                                     */
/*     OR  de-saldo-disp <= 0 THEN DO:                                                                                        */
/*         RUN utp/ut-msgs.p(input "show":U,                                                                                  */
/*                           input 17006,                                                                                     */
/*                           input  "Saldo da conta corrente do benef°cio Ç insuficiente para suprir o Valor Solicitado ~~" + */
/*                                  "Saldo Atual C. Corrente: R$ " + trim(STRING(de-saldo-disp)) + CHR(10) +                  */
/*                                  "Saldo Atual T°tulo.....: R$ " + trim(STRING(de-saldo-titulo)) ).                         */
/*         RETURN "NOK".                                                                                                      */
/*     END.                                                                                                                   */
/*                                                                                                                            */
    
    /* Verifica Solicitaá‰es em aberto */
     blk-principal:
     DO TRANSACTION
     ON ERROR UNDO blk-principal,LEAVE blk-principal
     ON STOP  UNDO blk-principal,LEAVE blk-principal:

         FIND FIRST int-solicitacao EXCLUSIVE-LOCK
             WHERE rowid(int-solicitacao) = tt-solicitacao.r-solicitacao.

         /* ATUALIZAR O CONTAS A PAGAR */
         IF  AVAIL int-solicitacao THEN 
             ASSIGN int-solicitacao.SituacaoSolicitacaoBeneficio  = 993520004
                    int-solicitacao.ValorPago                     = int-solicitacao.ValorAbater.

         FIND CURRENT int-solicitacao NO-LOCK.
              
         /* AGENDA O ENVIO DO STATUS (MSG0154) E SALDO (MSG0159) PARA O CRM */
         IF  AVAIL int-solicitacao THEN
             RUN piEnviaSaldosBarramento (INPUT int-solicitacao.CodigoSolicitacaoBeneficio,
                                          INPUT STRING(int-solicitacao.cod-emitente)).


         RELEASE int-solicitacao.

     END.

     */

     APPLY "CHOOSE" TO bt-filtrar IN FRAME f-cad.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pedido w-cadsim
ON CHOOSE OF bt-pedido IN FRAME fPage4
DO:
  
    IF  NOT AVAIL tt-pedido THEN
        RETURN NO-APPLY.

    ASSIGN gr-ped-venda = ?.

    FIND FIRST ped-venda NO-LOCK
        WHERE ped-venda.nome-abrev = tt-pedido.nome-abrev
          AND ped-venda.nr-pedcli  = tt-pedido.nr-pedcli NO-ERROR.
                            
    IF  AVAIL ped-venda THEN DO:
        ASSIGN gr-ped-venda = ROWID(ped-venda).
        RUN pdp/pd1001.w.
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage6
&Scoped-define SELF-NAME bt-pedido-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pedido-2 w-cadsim
ON CHOOSE OF bt-pedido-2 IN FRAME fpage6
DO:
  
    IF  NOT AVAIL tt-pedido THEN
        RETURN NO-APPLY.

    ASSIGN gr-ped-venda = ?.

    FIND FIRST ped-venda NO-LOCK
        WHERE ped-venda.nome-abrev = tt-pedido.nome-abrev
          AND ped-venda.nr-pedcli  = tt-pedido.nr-pedcli NO-ERROR.
                            
    IF  AVAIL ped-venda THEN DO:
        ASSIGN gr-ped-venda = ROWID(ped-venda).
        RUN pdp/pd1001.w.
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME bt-tit-acr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-tit-acr w-cadsim
ON CHOOSE OF bt-tit-acr IN FRAME fpage5
DO:
  
    ASSIGN v_rec_tit_acr = ?.

    /* Conta corrente */

    IF  NOT AVAIL tt-tit-acr THEN
        RETURN NO-APPLY.

    ASSIGN v_rec_tit_acr = tt-tit-acr.recid-tit-acr.

    FIND FIRST tit_acr NO-LOCK
        WHERE RECID(tit_acr) = v_rec_tit_acr.

    RUN prgfin/acr/acr212aa.p.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage7
&Scoped-define SELF-NAME bt-titulo-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-titulo-2 w-cadsim
ON CHOOSE OF bt-titulo-2 IN FRAME fpage7
DO:
  
    IF  NOT AVAIL int-cc-benef THEN
        RETURN NO-APPLY.

    ASSIGN v_rec_tit_ap = ?.

    FIND FIRST tit_ap NO-LOCK
        WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab
          AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.
                            
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
    DEF VAR r-row AS ROWID NO-UNDO.

    RUN pi-busca-canal (OUTPUT r-row).

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


&Scoped-define SELF-NAME folder-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-1 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-1 IN FRAME f-cad
DO:

  folder-1:LOAD-IMAGE("image/ts-up110.bmp").
  folder-4:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-5:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-6:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-7:LOAD-IMAGE("image/ts-dn110.bmp").

  VIEW FRAME fPage1.
  HIDE FRAME fPage4.
  HIDE FRAME fPage5.
  HIDE FRAME fPage6.
  HIDE FRAME fPage7.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME folder-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-4 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-4 IN FRAME f-cad
DO:


  folder-1:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-5:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-4:LOAD-IMAGE("image/ts-up110.bmp").
  folder-6:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-7:LOAD-IMAGE("image/ts-dn110.bmp").

  HIDE FRAME fPage1.
  HIDE FRAME fPage5.
  VIEW FRAME fPage4.
  HIDE FRAME fPage6.
  HIDE FRAME fPage7.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME folder-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-5 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-5 IN FRAME f-cad
DO:


  folder-1:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-4:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-5:LOAD-IMAGE("image/ts-up110.bmp").
  folder-6:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-7:LOAD-IMAGE("image/ts-dn110.bmp").

  HIDE FRAME fPage1.
  HIDE FRAME fPage4.
  VIEW FRAME fPage5.
  HIDE FRAME fPage6.
  HIDE FRAME fPage7.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME folder-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-6 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-6 IN FRAME f-cad
DO:


  folder-1:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-4:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-5:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-6:LOAD-IMAGE("image/ts-up110.bmp").
  folder-7:LOAD-IMAGE("image/ts-dn110.bmp").

  HIDE FRAME fPage1.
  HIDE FRAME fPage4.
  HIDE FRAME fPage5.
  VIEW FRAME fPage6.
  HIDE FRAME fPage7.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME folder-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-7 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-7 IN FRAME f-cad
DO:


  folder-1:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-4:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-5:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-6:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-7:LOAD-IMAGE("image/ts-up110.bmp").

  HIDE FRAME fPage1.
  HIDE FRAME fPage4.
  HIDE FRAME fPage5.
  HIDE FRAME fPage6.
  VIEW FRAME fPage7.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-selecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-selecao w-cadsim
ON VALUE-CHANGED OF rs-selecao IN FRAME f-cad
DO:

  IF  SELF:SCREEN-VALUE = "2" THEN
      ASSIGN fi-canal:SENSITIVE = YES.
  ELSE
      ASSIGN fi-canal:SENSITIVE = NO
             fi-canal:SCREEN-VALUE IN FRAME f-cad = ""
             fi-nome:SCREEN-VALUE IN FRAME f-cad = ""
             fi-nome-abrev:SCREEN-VALUE IN FRAME f-cad = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-itens
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
  DISPLAY rs-canais rs-selecao fi-canal fi-data-ini fi-data-fim fi-unidade-ini 
          fi-unidade-fim fi-gr-cob-ini fi-gr-cob-fim rs-tipo rs-envio 
          cb-beneficio cb-forma-pagto cb-situacao fi-nome-abrev fi-nome 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rs-canais rs-selecao fi-canal fi-data-ini fi-data-fim fi-unidade-ini 
         fi-unidade-fim fi-gr-cob-ini fi-gr-cob-fim rs-tipo rs-envio 
         bt-listar-pedidos cb-beneficio cb-forma-pagto cb-situacao bt-filtrar 
         bt-encontro-contas bt-pagamento bt-ajuste-tit bt-altera-titulo 
         bt-exporta-solicitacao bt-ok fi-nome-abrev fi-nome rt-button Rect-Main 
         folder-1 folder-4 IMAGE-25 IMAGE-26 IMAGE-27 IMAGE-28 br-solicitacao 
         folder-5 folder-6 IMAGE-33 IMAGE-34 RECT-156 folder-7 RECT-158 
         RECT-161 RECT-162 RECT-163 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  DISPLAY fi-cond-pagto fi-descricao fi-nome-emit fi-beneficio fi-forma-pagto 
          ed-descritivo fi-valor fi-unidade fi-grupo-cob fi-situacao-solicitacao 
          fi-status tg-integrada fi-valor-abater fi-data fi-hora fi-valor-pago 
          fi-valor-cancelado fi-validade fi-transacao fi-forma-canc 
          tg-descarta-verba fi-pagtos fi-empenho-transferido fi-empenho-pago 
          fi-empenho-cancelado fi-pagtos-ant fi-a-pagar 
      WITH FRAME fPage1 IN WINDOW w-cadsim.
  ENABLE fi-cond-pagto fi-descricao fi-nome-emit fi-beneficio fi-forma-pagto 
         ed-descritivo fi-valor fi-unidade fi-grupo-cob fi-situacao-solicitacao 
         fi-status fi-valor-abater fi-data fi-hora fi-valor-pago 
         fi-valor-cancelado fi-validade fi-transacao fi-forma-canc fi-pagtos 
         fi-empenho-transferido fi-empenho-pago fi-empenho-cancelado 
         fi-pagtos-ant fi-a-pagar RECT-143 RECT-144 RECT-145 RECT-147 RECT-148 
         RECT-146 RECT-149 
      WITH FRAME fPage1 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fPage1}
  ENABLE br-pedido bt-pedido bt-exporta-pedidos 
      WITH FRAME fPage4 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fPage4}
  DISPLAY fi-liquida-acr 
      WITH FRAME fpage5 IN WINDOW w-cadsim.
  ENABLE br-tit-acr bt-tit-acr fi-liquida-acr 
      WITH FRAME fpage5 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fpage5}
  DISPLAY fi-item-aberto fi-item-atendido fi-emp-vl-cancelado fi-emp-vl-pago 
          fi-emp-qtde-cancelada fi-item-cancelado fi-item-abatido-apb 
      WITH FRAME fpage6 IN WINDOW w-cadsim.
  ENABLE RECT-157 br-itens fi-item-aberto fi-item-atendido bt-pedido-2 
         fi-emp-vl-cancelado fi-emp-vl-pago fi-emp-qtde-cancelada 
         fi-item-cancelado fi-item-abatido-apb 
      WITH FRAME fpage6 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fpage6}
  DISPLAY fi-VerbaCalculada fi-periodo-ini fi-periodo-fim fi-analise 
          fi-VerbaAcumulada fi-unidade fi-aprovada fi-VerbaTransferida 
          fi-classificacao fi-EmpenhoTotal fi-VerbaTotal fi-categoria 
          fi-Reembolsado fi-VerbaCancelada fi-VerbaAjustada fi-vl-ating-meta 
          fi-perc-beneficio fi-SaldoDisponivel fi-vl-custo 
          fi-Finalizada-Stock-Rotation 
      WITH FRAME fpage7 IN WINDOW w-cadsim.
  ENABLE RECT-52 RECT-53 RECT-56 RECT-57 RECT-58 RECT-60 RECT-61 bt-cc 
         bt-titulo-2 
      WITH FRAME fpage7 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fpage7}
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

  ASSIGN  v_rec_tit_ap      = ?
          gr-ped-venda      = ?
          gr-solicitacao    = ?
          gr-conta-corrente = ?.

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
  
  ASSIGN  v_rec_tit_ap      = ?
          gr-ped-venda      = ?
          gr-solicitacao    = ?
          gr-conta-corrente = ?.  
  
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

  {utp/ut9000.i "ESESB010" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN dispatch  IN this-procedure ('enable-fields':U).

  APPLY 'mouse-select-click' TO folder-1 IN FRAME f-cad.
  
/*   APPLY 'value-changed'      TO br-canais IN FRAME f-cad.  */
  
  ASSIGN fi-data-ini:SCREEN-VALUE IN FRAME f-cad = STRING(TODAY)
         fi-data-fim:SCREEN-VALUE IN FRAME f-cad = STRING(TODAY).
  
  ASSIGN rs-selecao:SCREEN-VALUE = "1".
  APPLY "VALUE-CHANGED" TO rs-selecao.

  IF  gr-solicitacao <> ? THEN DO:
      FIND FIRST int-solicitacao
          WHERE rowid(int-solicitacao) = gr-solicitacao NO-LOCK NO-ERROR.

      IF  AVAIL int-solicitacao THEN DO WITH FRAME f-cad:
          ASSIGN rs-selecao:SCREEN-VALUE = "2".
          APPLY "VALUE-CHANGED" TO rs-selecao.
          
          ASSIGN fi-canal:SCREEN-VALUE = STRING(int-solicitacao.cod-emitente).
          APPLY "LEAVE" TO fi-canal.

          ASSIGN fi-unidade-ini:SCREEN-VALUE = int-solicitacao.CodigoUnidadeNegocio.
                 fi-unidade-fim:SCREEN-VALUE = int-solicitacao.CodigoUnidadeNegocio.

          CASE int-solicitacao.SituacaoSolicitacaoBeneficio:
              WHEN 993520003 THEN cb-situacao:SCREEN-VALUE = "Pendentes".
              WHEN 993520004 THEN cb-situacao:SCREEN-VALUE = "Pagas".
              WHEN 993520006 THEN cb-situacao:SCREEN-VALUE = "Canceladas".
              OTHERWISE cb-situacao:SCREEN-VALUE = "Todas".
          END CASE.

          ASSIGN cb-forma-pagto:SCREEN-VALUE = int-solicitacao.desc-forma-pagto
                 fi-data-ini:SCREEN-VALUE IN FRAME f-cad = STRING(int-solicitacao.DataCriacao)    
                 fi-data-fim:SCREEN-VALUE IN FRAME f-cad = STRING(int-solicitacao.DataCriacao).    

          APPLY "CHOOSE" TO bt-filtrar.

      END.

  END.

  {include/i-inifld.i}

  RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage1:HANDLE ).
  RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage4:HANDLE ).


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

    DEF OUTPUT PARAM p-row AS ROWID NO-UNDO.

    IF  fi-canal:SCREEN-VALUE IN FRAME f-cad = "" 
    OR  fi-canal:SCREEN-VALUE IN FRAME f-cad = "0" THEN
        RETURN "NOK".
    
    /* valida emitente canal */
    EMPTY TEMP-TABLE tt-central.
    RUN esp/esb/esesbapi005.p (INPUT  fi-canal:SCREEN-VALUE IN FRAME f-cad,
                               OUTPUT TABLE tt-central,
                               OUTPUT TABLE tt-erro).

    FIND FIRST tt-erro NO-ERROR.

    IF  RETURN-VALUE <> "OK"
    OR AVAIL tt-erro THEN DO:
        RUN utp/ut-msgs.p(input "show":U, 
                          input 17006,
                          input tt-erro.mensagem + "~~" + tt-erro.ajuda).
        APPLY "entry" TO fi-canal IN FRAME f-cad.
        RETURN "NOK".
    END.
        
    FIND FIRST tt-central 
        WHERE tt-central.canal-central = int(fi-canal:SCREEN-VALUE) NO-ERROR.

    /* VERIFICA SE O CANAL ê CENTRALIZADO, LOGO, N«O PERMITE INCLU÷LO NO BROWSER*/
    IF  NOT AVAIL tt-central THEN DO:
        RUN utp/ut-msgs.p(input "show":U, 
                          input 17006,
                          input "Este canal apura benef°cios de forma centralizada." + "~~" +
                                "A geraá∆o dos benef°cios s¢ pode ser processada para a Matriz.").
        APPLY "entry" TO fi-canal IN FRAME f-cad.
        RETURN "NOK".
    END.

    ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad       = tt-central.nome-emit-central
           fi-nome-abrev:SCREEN-VALUE IN FRAME f-cad = tt-central.nome-abrev-central.

    ASSIGN p-row = tt-central.r-row-central.

    RETURN "OK".

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

                        
    
    DEF VAR l-ok AS LOG INIT NO.

    IF  NOT AVAIL tt-solicitacao THEN
        RETURN "OK".

    EMPTY TEMP-TABLE tt-conta-corrente.
    ASSIGN gr-conta-corrente = ?.

    FOR LAST int-cc-benef NO-LOCK
        WHERE int-cc-benef.tp-movto        = 2 /*Despesa*/
          AND int-cc-benef.canal           = tt-solicitacao.cod-emitente
          AND int-cc-benef.unid-neg        = tt-solicitacao.CodigoUnidadeNegocio
          AND int-cc-benef.tipo-beneficio  = tt-solicitacao.tipo-beneficio
          AND int-cc-benef.dt-periodo-ini  = tt-solicitacao.dt-periodo-ini
          AND int-cc-benef.dt-periodo-fim  = tt-solicitacao.dt-periodo-fim
        ,FIRST int-class-canal NO-LOCK
                WHERE int-class-canal.codigo-classificacao = int-cc-benef.classificacao:

        /*Buscar Saldo Dispon°vel*/
        RUN esp/esb/esesbapi010-saldo.p (INPUT int-cc-benef.canal,
                                         INPUT int-cc-benef.tipo-beneficio,
                                         INPUT int-cc-benef.unid-neg,
                                         INPUT int-cc-benef.dt-periodo-ini,
                                         INPUT int-cc-benef.dt-periodo-fim,
                                         INPUT ?,
                                         INPUT ?,
                                         OUTPUT l-ok,
                                         OUTPUT TABLE tt-saldo,
                                         OUTPUT TABLE tt-erro-saldo).

/*         IF  RETURN-VALUE <> "OK" OR NOT l-ok THEN DO:                        */
/*              FOR EACH tt-erro-saldo:                                         */
/*                 RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,             */
/*                                                     INPUT tt-erro.mensagem). */
/*             END.                                                             */
/*             RETURN "NOK".                                                    */
/*         END.                                                                 */
/*                                                                              */
/*         FOR FIRST tt-saldo:                                                  */
/*             ASSIGN de-disponivel = tt-saldo.VerbaDisponivel.                 */
/*         END.                                                                 */
/*                                                                              */

        DO WITH FRAME fpage7:
        
            ASSIGN fi-periodo-ini:SCREEN-VALUE               = STRING(int-cc-benef.dt-periodo-ini)
                   fi-periodo-fim:SCREEN-VALUE               = STRING(int-cc-benef.dt-periodo-fim)
                   fi-unidade:SCREEN-VALUE                   = int-cc-benef.unid-neg
                   fi-classificacao:SCREEN-VALUE             = int-class-canal.nome
                   fi-categoria:SCREEN-VALUE                 = int-cc-benef.categoria
                   fi-vl-ating-meta:SCREEN-VALUE             = STRING(int-cc-benef.perc-prov-meta)
                   fi-vl-custo:SCREEN-VALUE                  = STRING(int-cc-benef.perc-custo)
                   fi-perc-beneficio:SCREEN-VALUE            = STRING(int-cc-benef.perc-benef)
                   fi-Finalizada-Stock-Rotation:SCREEN-VALUE = /*STRING(int-cc-benef.descarte-stock-rotation) */ STRING(int-cc-benef.Descarte-Stock-Rotation)
                   fi-VerbaCalculada:SCREEN-VALUE            = STRING(int-cc-benef.VerbaCalculada)
                   fi-VerbaAcumulada:SCREEN-VALUE            = STRING(int-cc-benef.VerbaAcumulada)
                   fi-VerbaTransferida:SCREEN-VALUE          = STRING(int-cc-benef.VerbaPeriodoAnterior)
                   fi-VerbaCancelada:SCREEN-VALUE            = STRING(int-cc-benef.VerbaCancelada)
                   fi-VerbaAjustada:SCREEN-VALUE             = STRING(int-cc-benef.VerbaAjustada)
                   fi-VerbaTotal:SCREEN-VALUE                = STRING(int-cc-benef.VerbaCalculada + int-cc-benef.VerbaAcumulada + int-cc-benef.VerbaPeriodoAnterior).
            FIND FIRST tt-saldo NO-ERROR.
            IF  AVAIL tt-saldo THEN DO:
                ASSIGN fi-analise:SCREEN-VALUE          = string(tt-saldo.VerbaEmpenhadaAnalise)
                       fi-aprovada:SCREEN-VALUE         = string(tt-saldo.VerbaEmpenhadaAprovada)
    
                       fi-EmpenhoTotal:SCREEN-VALUE     = string(tt-saldo.VerbaEmpenhadaTotal)
    
                       fi-Reembolsado:SCREEN-VALUE      = string(tt-saldo.VerbaReembolsada)
                       fi-SaldoDisponivel:SCREEN-VALUE  = string(tt-saldo.VerbaDisponivel).  

                ASSIGN tt-solicitacao.vl-saldo-cc = tt-saldo.VerbaDisponivel.
            
            END.            
            
            
        END.
    END.

    IF  AVAIL int-cc-benef THEN
        ASSIGN gr-conta-corrente = ROWID(int-cc-benef).
    ELSE DO:

        ASSIGN fi-periodo-ini:SCREEN-VALUE               = ""
               fi-periodo-fim:SCREEN-VALUE               = ""
               fi-unidade:SCREEN-VALUE                   = ""
               fi-classificacao:SCREEN-VALUE             = ""
               fi-categoria:SCREEN-VALUE                 = ""
               fi-vl-ating-meta:SCREEN-VALUE             = ""
               fi-vl-custo:SCREEN-VALUE                  = ""
               fi-perc-beneficio:SCREEN-VALUE            = ""
               fi-VerbaCalculada:SCREEN-VALUE            = ""
               fi-VerbaAcumulada:SCREEN-VALUE            = ""
               fi-VerbaTransferida:SCREEN-VALUE          = ""
               fi-VerbaCancelada:SCREEN-VALUE            = ""
               fi-VerbaAjustada:SCREEN-VALUE             = "" 
               fi-VerbaTotal:SCREEN-VALUE                = "" 
               fi-analise:SCREEN-VALUE                   = "" 
               fi-aprovada:SCREEN-VALUE                  = "" 
               fi-EmpenhoTotal:SCREEN-VALUE              = "" 
               fi-Reembolsado:SCREEN-VALUE               = "" 
               fi-SaldoDisponivel:SCREEN-VALUE           = "" 
               fi-Finalizada-Stock-Rotation:SCREEN-VALUE = "".
                                                 
    END.
   
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

    
    IF  NOT AVAIL tt-solicitacao THEN
        RETURN "OK".
    
    DO  WITH FRAME fpage1:
    
        ASSIGN fi-descricao:SCREEN-VALUE            = tt-solicitacao.NomeSolicitacaoBeneficio
               fi-nome-emit:SCREEN-VALUE            = tt-solicitacao.nome-emit
               fi-beneficio:SCREEN-VALUE            = fnBeneficio(tt-solicitacao.tipo-beneficio)
               fi-forma-pagto:SCREEN-VALUE          = tt-solicitacao.desc-forma-pagto
               fi-unidade:SCREEN-VALUE              = tt-solicitacao.CodigoUnidadeNegocio
               ed-descritivo:SCREEN-VALUE           = tt-solicitacao.DescricaoSolicitacao
               fi-grupo-cob:SCREEN-VALUE            = string(tt-solicitacao.cod-gr-cob)
               fi-data:SCREEN-VALUE                 = string(tt-solicitacao.DataCriacao, "99/99/9999")
               fi-hora:SCREEN-VALUE                 = tt-solicitacao.hora-trans
               fi-situacao-solicitacao:SCREEN-VALUE = fnSituacaoSolicitacao(tt-solicitacao.SituacaoSolicitacaoBeneficio)
               fi-status:SCREEN-VALUE               = IF  tt-solicitacao.situacao = 0 THEN "ATIVA" ELSE "INATIVA"
               fi-valor:screen-value                = string(tt-solicitacao.ValorSolicitado)
               tg-integrada:CHECKED                 = tt-solicitacao.log-enviada.
        
        ASSIGN fi-valor-cancelado:SCREEN-VALUE      = string(tt-solicitacao.ValorCancelado)
               fi-transacao:SCREEN-VALUE            = STRING(tt-solicitacao.DataCriacao)
               fi-cond-pagto:SCREEN-VALUE           = STRING(tt-solicitacao.CodigoCondicaoPagamento)
               fi-validade:SCREEN-VALUE             = STRING(tt-solicitacao.DataValidade).

               fi-pagtos:SCREEN-VALUE               = string(IF  tt-solicitacao.desc-forma-pagto = "Produto" THEN 
                                                                 tt-solicitacao.ValorPago
                                                             ELSE IF  tt-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 THEN
                                                                      tt-solicitacao.ValorSolicitado
                                                                  ELSE 0
                                                             ).

               IF  tt-solicitacao.FormaCancelamento = 993520000 THEN
                   ASSIGN fi-forma-canc:SCREEN-VALUE = "Autom†tico".
               ELSE
                   ASSIGN fi-forma-canc:SCREEN-VALUE = "Manual".

        ASSIGN tg-descarta-verba:CHECKED = tt-solicitacao.DescartarVerba.

        /* Empenhos transportados de trimestres anteriores */
        ASSIGN fi-empenho-transferido:SCREEN-VALUE  = string(tt-solicitacao.vl-empenho-transferido)
               fi-empenho-pago:SCREEN-VALUE         = string(tt-solicitacao.vl-empenho-pago)
               fi-pagtos-ant:SCREEN-VALUE           = string(tt-solicitacao.vl-empenho-pago)
               fi-empenho-cancelado:SCREEN-VALUE    = /*string(tt-solicitacao.vl-empenho-cancelado)*/ tt-solicitacao.char-1.
               
        
       ASSIGN fi-a-pagar:SCREEN-VALUE               = string(tt-solicitacao.ValorSolicitado  - 
                                                             tt-solicitacao.vl-abatido-verba - 
                                                             tt-solicitacao.vl-empenho-pago -
                                                             tt-solicitacao.ValorCancelado).

       IF  tt-solicitacao.tipo-beneficio = 4 OR tt-solicitacao.tipo-beneficio = 15 THEN
           ASSIGN fi-valor-abater:SCREEN-VALUE         = string(0.00)
                  fi-valor-pago:SCREEN-VALUE           = string(0.00).
       ELSE       
           ASSIGN fi-valor-abater:SCREEN-VALUE         = string((DEC(fi-a-pagar:SCREEN-VALUE) * DEC(fi-vl-custo:SCREEN-VALUE IN FRAME fpage7)) / 100)
                  fi-valor-pago:SCREEN-VALUE           = string(tt-solicitacao.vl-abatido-parcial).

    END.

    RUN pi-carrega-itens.
    
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-itens w-cadsim 
PROCEDURE pi-carrega-itens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE tt-itens.


  IF  NOT AVAIL tt-solicitacao THEN
      RETURN "OK".

  DEF VAR de-pedida             AS DEC NO-UNDO.
  DEF VAR de-atendido           AS DEC NO-UNDO.
  DEF VAR de-cancelado          AS DEC NO-UNDO.
  DEF VAR de-suspenso           AS DEC NO-UNDO.
  DEF VAR de-pendente           AS DEC NO-UNDO.
  DEF VAR de-abatido            AS DEC NO-UNDO.
  DEF VAR de-emp-pago           AS DEC NO-UNDO.
  DEF VAR de-qtd-emp-cancelada  AS DEC NO-UNDO.
  DEF VAR de-vl-emp-cancelado   AS DEC NO-UNDO.
  DEF VAR de-qt-emp-atendida    AS DEC NO-UNDO.

  FOR EACH int-solicitacao-item NO-LOCK
      WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = tt-solicitacao.CodigoSolicitacaoBeneficio
      BREAK BY int-solicitacao-item.nr-pedcli
            BY int-solicitacao-item.CodigoProduto:

        CREATE tt-itens.
        BUFFER-COPY int-solicitacao-item TO tt-itens.

        FIND FIRST ped-item
            WHERE ped-item.nome-abrev = int-solicitacao-item.nome-abrev
              AND ped-item.nr-pedcli  = int-solicitacao-item.nr-pedcli
              AND ped-item.it-codigo  = int-solicitacao-item.CodigoProduto NO-LOCK NO-ERROR.

        IF AVAIL ped-item THEN DO:
            ASSIGN tt-itens.nr-pedcli    = ped-item.nr-pedcli
                   tt-itens.cod-sit-item = fnCod-Sit-Item(ped-item.cod-sit-item)
                   tt-itens.qt-atendida  = ped-item.qt-atendida
                   tt-itens.ValorPago    = int-solicitacao-item.ValorPago
                   de-pedida             = de-pedida    + int-solicitacao-item.ValorTotalAprovado 
                   de-atendido           = de-atendido  + int-solicitacao-item.ValorPago
                   de-cancelado          = de-cancelado + int-solicitacao-item.ValorCancelado.
            
            ASSIGN  de-emp-pago           = de-emp-pago          + int-solicitacao-item.vl-empenho-pago
                    de-qtd-emp-cancelada  = de-qtd-emp-cancelada + int-solicitacao-item.qt-ja-cancelada-empenho
                    de-vl-emp-cancelado   = de-vl-emp-cancelado  + int-solicitacao-item.vl-ja-cancelado-empenho
                    de-qt-emp-atendida    = de-qt-emp-atendida   + int-solicitacao-item.qt-ja-atendida-empenho.
            /*
            ASSIGN de-emp-pago           = de-emp-pago          + int-solicitacao-item.dec-1
                   de-qtd-emp-cancelada  = de-qtd-emp-cancelada + int-solicitacao-item.dec-1
                   de-vl-emp-cancelado   = de-vl-emp-cancelado  + int-solicitacao-item.dec-1
                   de-qt-emp-atendida    = de-qt-emp-atendida   + int-solicitacao-item.dec-1.
             */      
        END.
        ELSE
            ASSIGN de-pedida             = de-pedida    + (int-solicitacao-item.ValorTotalAprovado) 
                   de-cancelado          = de-cancelado + int-solicitacao-item.ValorCancelado.

        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = int-solicitacao-item.CodigoProduto NO-ERROR.

        IF  AVAIL ITEM THEN
            ASSIGN tt-itens.desc-item    = ITEM.desc-item.

    END.

    /* Campos controle per°odo atual */
    ASSIGN fi-item-cancelado  :SCREEN-VALUE IN FRAME fpage6 = STRING(de-cancelado)
           fi-item-aberto     :SCREEN-VALUE IN FRAME fpage6 = STRING(de-pedida - de-emp-pago - de-atendido - de-cancelado)
           fi-item-atendido   :SCREEN-VALUE IN FRAME fpage6 = STRING(de-atendido).
           
    /* Campos controle de empenho transferido de trimestres anteriores na mesma solicitaá∆o */
    ASSIGN fi-emp-vl-pago       :SCREEN-VALUE IN FRAME fpage6 = STRING(de-emp-pago)
           fi-emp-vl-cancelado  :SCREEN-VALUE IN FRAME fpage6 = STRING(de-qtd-emp-cancelada)
           fi-emp-qtde-cancelada:SCREEN-VALUE IN FRAME fpage6 = STRING(de-vl-emp-cancelado).

    IF  tt-solicitacao.tipo-beneficio = 4 OR tt-solicitacao.tipo-beneficio = 15 THEN
        ASSIGN fi-item-abatido-apb:SCREEN-VALUE IN FRAME fpage6 = STRING(0.00).
    ELSE
        ASSIGN fi-item-abatido-apb:SCREEN-VALUE IN FRAME fpage6 = STRING( 
                                                                         (tt-solicitacao.vl-abatido-apb  * -1) * (IF  AVAIL int-cc-benef THEN int-cc-benef.perc-custo ELSE 0 ) / 100
                                                                         ).

    {&open-query-br-itens}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-pedidos w-cadsim 
PROCEDURE pi-carrega-pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR de-tot-aprov AS DEC NO-UNDO.
    EMPTY TEMP-TABLE tt-pedido.

    DEF BUFFER b-tt-pedido FOR tt-pedido.

    FOR EACH int-solicitacao-item NO-LOCK
        WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = tt-solicitacao.CodigoSolicitacaoBeneficio
          BREAK BY int-solicitacao-item.CodigoEstabelecimento:


        IF  FIRST-OF (int-solicitacao-item.CodigoEstabelecimento) THEN
            ASSIGN de-tot-aprov = 0. 

        ASSIGN de-tot-aprov = de-tot-aprov + int-solicitacao-item.ValorTotalAprovado.

        IF  LAST-OF (int-solicitacao-item.CodigoEstabelecimento) THEN DO:
            FIND FIRST ped-venda NO-LOCK
                WHERE ped-venda.nome-abrev = int-solicitacao-item.nome-abrev 
                  AND ped-venda.nr-pedcli  = int-solicitacao-item.nr-pedcli NO-ERROR.
    
            IF  AVAIL ped-venda THEN DO:
                CREATE tt-pedido.
                ASSIGN tt-pedido.nome-abrev      = ped-venda.nome-abrev
                       tt-pedido.nr-pedcli       = ped-venda.nr-pedcli
                       tt-pedido.cod-estabel     = ped-venda.cod-estabel
                       tt-pedido.dt-implantacao  = ped-venda.dt-implant
                       tt-pedido.dt-cancela      = ped-venda.dt-cancela
                       tt-pedido.cod-sit-ped     = ped-venda.cod-sit-ped
                       tt-pedido.desc-sit-ped    = fnSitPedido(ped-venda.cod-sit-ped)
                       tt-pedido.vl-aprovado     = de-tot-aprov
                       tt-pedido.vl-liq-ped      = ped-venda.vl-liq-ped
                       tt-pedido.vl-tot-ped      = ped-venda.vl-tot-ped.
            END.
        END.

    END.

    {&open-query-br-pedido}
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-solicitacoes w-cadsim 
PROCEDURE pi-carrega-solicitacoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR i-tipo-benef    AS INTEGER NO-UNDO.
    DEF VAR i-canal         AS INTEGER NO-UNDO.
    DEF VAR c-forma-pagto   AS CHAR    NO-UNDO.
    DEF VAR de-vl-aprovado  AS DEC     NO-UNDO.
    DEF VAR l-tipo          AS LOG     NO-UNDO.
    DEF VAR l-enviada       AS LOG     NO-UNDO.
    DEF VAR i-tipo-canal    AS INTEGER NO-UNDO.
    
    EMPTY TEMP-TABLE tt-solicitacao.

    DO WITH FRAME f-cad:

        /* TIPO DE SOLICITACAO */
        IF  rs-tipo:SCREEN-VALUE = "1" THEN
            ASSIGN l-tipo = NO.
        ELSE IF rs-tipo:SCREEN-VALUE = "2" THEN
                ASSIGN l-tipo = YES.
             ELSE
                ASSIGN l-tipo = ?.

        /* STATUS SOLICITACAO */
        IF  rs-envio:SCREEN-VALUE = "1" THEN
            ASSIGN l-enviada = YES.
        ELSE IF rs-envio:SCREEN-VALUE = "2" THEN
                ASSIGN l-enviada = NO.
             ELSE
                ASSIGN l-enviada = ?.

        /* BENEF÷CIO */
        CASE cb-beneficio:SCREEN-VALUE:
            WHEN "VMC"              THEN i-tipo-benef = 21.
            WHEN "REBATE"           THEN i-tipo-benef = 37.
            WHEN "REBATE P‡S-VENDA" THEN i-tipo-benef = 66.
            WHEN "STOCK ROTATION"   THEN i-tipo-benef = 22.
            WHEN "STOCK BACKUP"     THEN i-tipo-benef = 04.
            WHEN "SHOW ROOM"        THEN i-tipo-benef = 15.
            WHEN "PRICE PROTECTION" THEN i-tipo-benef = 08.
            WHEN "TODOS"            THEN i-tipo-benef = 0.
            OTHERWISE DO:
                RUN utp/ut-msgs.p(INPUT "show",
                                  INPUT 17006,
                                  INPUT "Selecionar Tipo de benef°cio" + "~~" + 
                                        "N∆o foi selecionado o tipo de benef°cio.").
                RETURN "NOK".
            END.
        END CASE.

        /* FORMA PAGAMENTO */

        CASE cb-forma-pagto:SCREEN-VALUE:
             WHEN "Produto"                  THEN c-forma-pagto = "Produto".              
             WHEN "Desconto em Duplicata"    THEN c-forma-pagto = "Desconto em Duplicata".
             WHEN "Dinheiro"                 THEN c-forma-pagto = "Dinheiro".             
             WHEN "Todos"                    THEN c-forma-pagto = "0".                
        END CASE.

        IF  rs-selecao:SCREEN-VALUE = "1" THEN
            ASSIGN i-canal = ?.
        ELSE DO:
            ASSIGN i-canal = INT(fi-canal:SCREEN-VALUE IN FRAME f-cad).
         
            FIND FIRST int-emitente NO-LOCK
                WHERE int-emitente.cod-emitente = i-canal NO-ERROR.
    
            IF NOT AVAIL int-emitente THEN DO:
                RUN utp/ut-msgs.p(input "show":U, 
                                  input 17006,
                                  input  "Cliente inexistente").
                RETURN "NOK".
            END.
        END.

        /* SITUAÄ«O SOLICITAÄ«O */
        CASE cb-situacao:SCREEN-VALUE:
            WHEN "Pendentes"              THEN ASSIGN i-situacao = 993520003.
            WHEN "Pagas"                  THEN ASSIGN i-situacao = 993520004.
            WHEN "Canceladas"             THEN ASSIGN i-situacao = 993520006.
            WHEN "Em An†lise"             THEN ASSIGN i-situacao = ?.
            WHEN "Em An†lise + Pendentes" THEN ASSIGN i-situacao = 999999999.
            WHEN "Todas"                  THEN ASSIGN i-situacao = 0.
        END CASE.

        IF  rs-canais:SCREEN-VALUE = "2" THEN
            ASSIGN i-tipo-canal = 1.
        ELSE
            ASSIGN i-tipo-canal = 0.

    END.
    
    FOR EACH int-solicitacao NO-LOCK
        WHERE (IF l-enviada       =  ?  THEN  YES  ELSE int-solicitacao.log-enviada                   = l-enviada     )
          AND (IF i-canal         =  ?  THEN  YES  ELSE int-solicitacao.cod-emitente                  = i-canal       )
          AND (IF l-tipo          =  ?  THEN  YES  ELSE int-solicitacao.Ajuste                        = l-tipo        )
          AND (IF i-tipo-benef    =  0  THEN  YES  ELSE (int-solicitacao.tipo-benef                   = i-tipo-benef  ))
          AND (IF i-situacao      =  0 OR i-situacao = ? THEN 
                  YES  
               ELSE IF  i-situacao = 999999999 THEN
                        (int-solicitacao.SituacaoSolicitacaoBeneficio <> 993520004 AND int-solicitacao.SituacaoSolicitacaoBeneficio <> 993520006)
                    ELSE                                                 
                        (int-solicitacao.SituacaoSolicitacaoBeneficio = i-situacao    )
               )
          AND (IF c-forma-pagto   = "0" THEN  YES  ELSE (int-solicitacao.desc-forma-pagto             = c-forma-pagto ))  
          AND int-solicitacao.CodigoUnidadeNegocio >= fi-unidade-ini:SCREEN-VALUE IN FRAME f-cad    
          AND int-solicitacao.CodigoUnidadeNegocio <= fi-unidade-fim:SCREEN-VALUE IN FRAME f-cad  
          AND int-solicitacao.DataCriacao >= date(fi-data-ini:SCREEN-VALUE)
          AND int-solicitacao.DataCriacao <= date(fi-data-fim:SCREEN-VALUE)
          AND NOT int-solicitacao.log-historica /* solicitaá∆o hist¢rica */
          AND int-solicitacao.int-1 = i-tipo-canal
          
        ,FIRST int-emitente NO-LOCK
            WHERE int-emitente.cod-guid = int-solicitacao.CodigoConta
              AND int-emitente.cod-gr-cob >= INT(fi-gr-cob-ini:SCREEN-VALUE IN FRAME f-cad)
              AND int-emitente.cod-gr-cob <= INT(fi-gr-cob-fim:SCREEN-VALUE IN FRAME f-cad)
        ,FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = int-emitente.cod-emitente:
        
        /*S¢ mostra as "Em An†lise"*/
        IF  i-situacao = ? THEN DO:
            IF int-solicitacao.SituacaoSolicitacaoBeneficio = 993520003
            OR int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004
            OR int-solicitacao.SituacaoSolicitacaoBeneficio = 993520006 THEN
               NEXT.
        END.
        /*S¢ mostra as "Em An†lise + Pendentes "*/
        IF  i-situacao = 999999999 THEN
            IF  int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 OR int-solicitacao.SituacaoSolicitacaoBeneficio = 993520006 THEN
                NEXT.

        CREATE tt-solicitacao.
        BUFFER-COPY int-solicitacao TO tt-solicitacao.

        /* Caso tenha itens relacionados (pedidos), totaliza o valor aprovado */
        FOR EACH int-solicitacao-item NO-LOCK
            WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = int-solicitacao.CodigoSolicitacaoBeneficio:
            ASSIGN de-vl-aprovado = de-vl-aprovado + ValorTotalAprovado. 
        END.

        IF  de-vl-aprovado = 0  THEN
            ASSIGN de-vl-aprovado = int-solicitacao.ValorSolicitado.

        ASSIGN tt-solicitacao.r-solicitacao        = ROWID(int-solicitacao)
               tt-solicitacao.vl-aprovado          = int-solicitacao.ValorSolicitado
               tt-solicitacao.r-tt-solicitacao     = ROWID(tt-solicitacao)
               tt-solicitacao.nome-abrev           = emitente.nome-abrev
               tt-solicitacao.nome-emit            = emitente.nome-emit
               tt-solicitacao.desc-beneficio       = fnBeneficio(tt-solicitacao.tipo-beneficio)
               tt-solicitacao.desc-situacao        = fnStatus(tt-solicitacao.SituacaoSolicitacaoBeneficio)
               tt-solicitacao.CodigoUnidadeNegocio = upper(int-solicitacao.CodigoUnidadeNegocio)
               tt-solicitacao.c-ajuste             = IF  int-solicitacao.Ajuste THEN  "AJUSTE" ELSE "NORMAL"
               tt-solicitacao.hora                 = int-solicitacao.hora-trans.

        CASE tt-solicitacao.desc-forma-pagto:
             WHEN "Produto"               THEN ASSIGN tt-solicitacao.desc-forma-pagto-abrev = "Produto".
             WHEN "Desconto em Duplicata" THEN ASSIGN tt-solicitacao.desc-forma-pagto-abrev = "Duplicata".
             WHEN "Dinheiro"              THEN ASSIGN tt-solicitacao.desc-forma-pagto-abrev = "Dinheiro".
        END CASE.



        /****************************  SALDO NO AP  *******************************/
        FOR LAST int-cc-benef NO-LOCK
            WHERE int-cc-benef.tp-movto       = 2 /*DESPESA*/
              AND int-cc-benef.tipo-beneficio = tt-solicitacao.tipo-beneficio
              AND int-cc-benef.unid-neg       = tt-solicitacao.CodigoUnidadeNegocio
              AND int-cc-benef.canal          = tt-solicitacao.cod-emitente
              AND int-cc-benef.dt-periodo-ini = tt-solicitacao.dt-periodo-ini
              AND int-cc-benef.dt-periodo-fim = tt-solicitacao.dt-periodo-fim:

            ASSIGN tt-solicitacao.r-conta-corrente = ROWID(int-cc-benef).
                   /*tt-solicitacao.vl-saldo-cc      = int-cc-benef.vl-saldo.*/

            FIND FIRST tit_ap NO-LOCK                                                 
                WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab              
                  AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.         
                                                                                             
            IF  AVAIL tit_ap THEN
                ASSIGN tt-solicitacao.vl-titulo     = tit_ap.val_sdo_tit_ap
                       tt-solicitacao.vl-titulo-ori = tit_ap.val_origin_tit_ap.
        END.

        IF  tt-solicitacao.Ajuste THEN /*AJUSTE*/
            ASSIGN tt-solicitacao.a-pagar-solicit = tt-solicitacao.vl-aprovado * (int-cc-benef.perc-custo / 100)
                   tt-solicitacao.a-pagar         = tt-solicitacao.vl-aprovado * (int-cc-benef.perc-custo / 100)
                   tt-solicitacao.a-pagar-apb     = tt-solicitacao.a-pagar.
        ELSE DO:
            IF  tt-solicitacao.desc-forma-pagto-abrev = "Duplicata" THEN DO:
                IF  tt-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 THEN
                    ASSIGN tt-solicitacao.a-pagar-solicit = 0
                           tt-solicitacao.a-pagar         = 0
                           tt-solicitacao.a-pagar-apb     = 0.
                ELSE
                    ASSIGN tt-solicitacao.a-pagar-solicit = tt-solicitacao.ValorAprovado
                           tt-solicitacao.a-pagar         = tt-solicitacao.vl-aprovado
                           tt-solicitacao.a-pagar-apb     = tt-solicitacao.ValorAbater.
            END.
            ELSE DO:                         
                ASSIGN tt-solicitacao.a-pagar-solicit = tt-solicitacao.vl-aprovado - int-solicitacao.vl-abatido-apb - int-solicitacao.vl-empenho-pago - int-solicitacao.ValorCancelado
                       tt-solicitacao.a-pagar         = (tt-solicitacao.ValorAbater - int-solicitacao.vl-abatido-apb) * (-1)  
                       tt-solicitacao.a-pagar-apb     = tt-solicitacao.a-pagar * IF AVAIL int-cc-benef THEN (int-cc-benef.perc-custo / 100) ELSE 1.

            END.
        END.

        IF  tt-solicitacao.SituacaoSolicitacaoBeneficio = 993520004
        OR  tt-solicitacao.SituacaoSolicitacaoBeneficio = 993520006  THEN
            ASSIGN tt-solicitacao.a-pagar     = 0
                   tt-solicitacao.a-pagar-apb = 0.


        IF  tt-solicitacao.desc-forma-pagto-abrev = "Produto" THEN
            ASSIGN tt-solicitacao.vl-abatido-parcial   = tt-solicitacao.vl-abatido-apb * (IF  AVAIL int-cc-benef THEN int-cc-benef.perc-custo ELSE 0 ) / 100.
        ELSE DO: /*Desconto em Duplicata*/             
            IF  tt-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 THEN
                ASSIGN tt-solicitacao.vl-abatido-parcial = tt-solicitacao.ValorAbater.
            ELSE
                ASSIGN tt-solicitacao.vl-abatido-parcial = 0.
        END.

        IF  tt-solicitacao.desc-forma-pagto-abrev = "duplicata"
        AND tt-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 THEN
            ASSIGN tt-solicitacao.vl-abatido-verba     = int-solicitacao.ValorSolicitado.
        ELSE
            ASSIGN tt-solicitacao.vl-abatido-verba     = tt-solicitacao.vl-abatido-apb.

        /* QUANDO FOR UM AJUSTE */
        IF  tt-solicitacao.Ajuste THEN
            ASSIGN tt-solicitacao.a-pagar-solicit    = 0
                   tt-solicitacao.vl-abatido-verba   = int-solicitacao.ValorSolicitado
                   tt-solicitacao.vl-abatido-parcial = 0.

    END.
    
    {&open-query-br-solicitacao}

    APPLY "value-changed" TO br-solicitacao IN FRAME f-cad.

    {&open-query-br-pedido}
    {&open-query-br-tit-acr}
    {&open-query-br-itens}
    {&open-query-br-conta-corrente}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tit-acr w-cadsim 
PROCEDURE pi-carrega-tit-acr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    EMPTY TEMP-TABLE tt-tit-acr.
    ASSIGN fi-liquida-acr:SCREEN-VALUE IN FRAME fpage5 = string(0).

    {&open-query-br-tit-acr}

    DEF VAR de-total AS DEC NO-UNDO.
    DEF BUFFER b_movto_tit_acr      FOR movto_tit_acr.
    DEF BUFFER b_movto_tit_acr_tres FOR movto_tit_acr.
    DEF BUFFER b_tit_acr            FOR tit_acr.

    IF  AVAIL tt-solicitacao THEN DO:
        
        FIND FIRST int-cc-benef NO-LOCK
            WHERE int-cc-benef.canal          = tt-solicitacao.cod-emitente
              AND int-cc-benef.unid-neg       = tt-solicitacao.CodigoUnidadeNegocio
              AND int-cc-benef.tipo-beneficio = tt-solicitacao.tipo-beneficio
              AND int-cc-benef.dt-periodo-ini = tt-solicitacao.dt-periodo-ini
              AND int-cc-benef.dt-periodo-fim = tt-solicitacao.dt-periodo-fim NO-ERROR.
    
        IF  NOT AVAIL int-cc-benef THEN
            RETURN "OK".
    
        FIND enctro_cta NO-LOCK
           WHERE enctro_cta.cod_estab = int-cc-benef.cod_estab
             AND enctro_cta.cod_refer = tt-solicitacao.ref-encontro-contas NO-ERROR.
        
        IF  NOT AVAIL enctro_cta THEN
            RETURN "OK".
    
        for each movto_tit_acr no-lock 
            where movto_tit_acr.cod_estab = enctro_cta.cod_estab
            and   movto_tit_acr.cod_refer = enctro_cta.cod_refer
            and   movto_tit_acr.ind_trans_acr_abrev = "LQEC"
            AND   movto_tit_acr.LOG_movto_estordo   = NO:
    
            find b_tit_acr no-lock
               where b_tit_acr.cod_estab      = movto_tit_acr.cod_estab
               and   b_tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr no-error.

            FIND FIRST b_movto_tit_acr_tres OF b_tit_acr 
                 WHERE b_movto_tit_acr_tres.ind_trans_acr_abrev = "TRES" NO-LOCK NO-ERROR.

            IF AVAIL b_movto_tit_acr_tres
            THEN DO:
                 FOR EACH b_movto_tit_acr NO-LOCK
                     WHERE b_movto_tit_acr.cod_estab            = b_movto_tit_acr_tres.cod_estab_tit_acr_pai
                       AND b_movto_tit_acr.num_id_movto_tit_acr = b_movto_tit_acr_tres.num_id_movto_tit_acr_pai:

                     FIND tit_acr NO-LOCK 
                         WHERE tit_acr.cod_estab      = b_movto_tit_acr.cod_estab
                           AND tit_acr.num_id_tit_acr = b_movto_tit_acr.num_id_tit_acr 
                           AND tit_acr.num_id_tit_acr <>  b_tit_acr.num_id_tit_acr    NO-ERROR.
                 END.
            END.
            ELSE DO:
                find tit_acr no-lock
                    where tit_acr.cod_estab      = movto_tit_acr.cod_estab
                    and   tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr no-error.
            END.

            IF  NOT AVAIL tit_acr THEN
                NEXT.

            FIND emitente NO-LOCK 
                WHERE emitente.cod-emitente = tit_acr.cdn_cliente NO-ERROR.
    
            CREATE tt-tit-acr.                                               
            ASSIGN tt-tit-acr.cod_estab          = tit_acr.cod_estab         
                   tt-tit-acr.cod_espec_docto    = tit_acr.cod_espec_docto   
                   tt-tit-acr.cod_ser_docto      = tit_acr.cod_ser_docto     
                   tt-tit-acr.cod_tit_acr        = tit_acr.cod_tit_acr       
                   tt-tit-acr.cod_parcela        = tit_acr.cod_parcela       
                   tt-tit-acr.cdn_cliente        = tit_acr.cdn_cliente       
                   tt-tit-acr.nom_abrev          = tit_acr.nom_abrev
                   tt-tit-acr.cod_id_feder       = emitente.cgc
                   tt-tit-acr.dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
                   tt-tit-acr.val_origin_tit_acr = tit_acr.val_origin_tit_acr
                   tt-tit-acr.val-liquidado      = movto_tit_acr.val_movto_tit_acr 
                   tt-tit-acr.recid-tit-acr      = RECID(tit_acr)
                   de-total                      = de-total + movto_tit_acr.val_movto_tit_acr .
        end.
        
        ASSIGN fi-liquida-acr:SCREEN-VALUE IN FRAME fpage5 = string(de-total).
    END.
    
    {&open-query-br-tit-acr}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-excel-ped-venda w-cadsim 
PROCEDURE pi-gera-excel-ped-venda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

      IF  NOT AVAIL tt-solicitacao THEN
          RETURN "OK".

      DEF VAR c-arquivo AS CHAR NO-UNDO.

      DEF BUFFER b-tt-pedido FOR tt-pedido.

      ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "Pedidos_" + STRING(tt-solicitacao.cod-emitente) + "_" + STRING(TODAY, "99-99-9999") + "_"+ STRING(TIME) + ".csv".

      OUTPUT STREAM s-1 TO value(c-arquivo) CONVERT TARGET "iso8859-1".

      PUT STREAM s-1 "Cliente;Pedido;Implantaá∆o;Cancelamento;Situaá∆o Pedido;Val L°quido; Val Total" SKIP.

      FOR EACH b-tt-pedido
           BY  b-tt-pedido.nr-pedcli:
           EXPORT STREAM s-1 DELIMITER ";" b-tt-pedido.nome-abrev    
                                           b-tt-pedido.nr-pedcli     
                                           b-tt-pedido.dt-implantacao
                                           b-tt-pedido.dt-cancela    
                                           b-tt-pedido.desc-sit-ped  
                                           b-tt-pedido.vl-liq-ped    
                                           b-tt-pedido.vl-tot-ped.    
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

      DEF VAR c-data AS CHAR FORMAT "x(10)" NO-UNDO.
      DEF VAR da-ultimo-pagto AS DATE INIT 01/01/0001 NO-UNDO.

      IF  NOT AVAIL tt-solicitacao THEN
          RETURN "OK".

      DEF VAR c-arquivo AS CHAR NO-UNDO.

      DEF BUFFER b-tt-solicitacao FOR tt-solicitacao.

      ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "Solicitacao_" + STRING(tt-solicitacao.cod-emitente) + "_" + STRING(TODAY, "99-99-9999") + "_" + STRING(TIME) + ".csv".

      OUTPUT STREAM s-1 TO value(c-arquivo) CONVERT TARGET "iso8859-1".

      PUT STREAM s-1 "Tipo;Canal;NomeAbrev;Nome;Solicitaá∆o;Benef°cio;Unidade;Data;Hora;Trimestre;Forma Pagto;Solicitaá∆o;Dt Pagto;Pago Trim. Ant.;Pago Atual; Em Aberto;Sdo Financ. Orig; Abat. Tot/Parcial;Sdo Financ Atual;Situaá∆o;Envio CRM;Ativa;Grupo Cobranáa;GUID CRM" SKIP.

      IF  NOT VALID-HANDLE(h-acomp) THEN                                  
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      
                                                                        
     IF  VALID-HANDLE(h-acomp) THEN                                      
        RUN pi-inicializar IN h-acomp (INPUT "Gerando Relat¢rio...").

      FOR EACH b-tt-solicitacao
          ,FIRST emitente NO-LOCK 
            WHERE emitente.cod-emitente = b-tt-solicitacao.cod-emitente
           BY b-tt-solicitacao.cod-emitente          
           BY b-tt-solicitacao.tipo-beneficio
           BY b-tt-solicitacao.CodigoUnidadeNegocio 
           BY b-tt-solicitacao.DataCriacao 
           BY b-tt-solicitacao.hora :


           ASSIGN c-data = "".

           IF  b-tt-solicitacao.ajuste  THEN
               ASSIGN c-data = "".

           /* Buscar data de pagamento das solicitaá‰es de Desconto em Duplicata */
           IF  b-tt-solicitacao.desc-forma-pagto = "Desconto em duplicata"
           AND b-tt-solicitacao.SituacaoSolicitacaoBeneficio = 993520004  THEN DO:
               FIND FIRST int-cc-benef
                   WHERE int-cc-benef.tp-movto        = 2 /*despesa*/
                     AND int-cc-benef.canal           = b-tt-solicitacao.cod-emitente
                     AND int-cc-benef.unid-neg        = b-tt-solicitacao.CodigoUnidadeNegocio
                     AND int-cc-benef.tipo-beneficio  = b-tt-solicitacao.tipo-beneficio
                     AND int-cc-benef.dt-periodo-ini  = b-tt-solicitacao.dt-periodo-ini
                     AND int-cc-benef.dt-periodo-fim  = b-tt-solicitacao.dt-periodo-fim  NO-LOCK NO-ERROR.

               IF  AVAIL int-cc-benef THEN DO:
                   FIND enctro_cta NO-LOCK
                      WHERE enctro_cta.cod_estab = int-cc-benef.cod_estab
                        AND enctro_cta.cod_refer = b-tt-solicitacao.ref-encontro-contas NO-ERROR.

                   IF  AVAIL enctro_cta THEN
                       c-data = STRING(enctro_cta.dat_transacao, "99/99/9999").
               END.
           END.

           ASSIGN da-ultimo-pagto = 01/01/0001.

           IF  b-tt-solicitacao.desc-forma-pagto = "Produto" 
           AND b-tt-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 /*Pagas*/ THEN DO:

               FOR EACH int-solicitacao-item NO-LOCK
                   WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = b-tt-solicitacao.CodigoSolicitacaoBeneficio 
                     and int-solicitacao-item.log-historica = NO /*N∆o considera as hist¢ricas*/:

                   FIND LAST nota-fiscal NO-LOCK
                       WHERE nota-fiscal.nome-ab-cli = int-solicitacao-item.nome-abrev
                         AND nota-fiscal.nr-pedcli   = int-solicitacao-item.nr-pedcli NO-ERROR.

                   IF  AVAIL nota-fiscal 
                   AND nota-fiscal.dt-emis-nota > da-ultimo-pagto THEN
                       ASSIGN da-ultimo-pagto = nota-fiscal.dt-emis-nota.
               END.

               IF  da-ultimo-pagto = 01/01/0001 THEN
                   ASSIGN c-data = "".
               ELSE 
                   ASSIGN c-data = STRING(da-ultimo-pagto, "99/99/9999").

           END.

           EXPORT STREAM s-1 DELIMITER ";" IF b-tt-solicitacao.Ajuste THEN "AJUSTE" ELSE "NORMAL"
                                           b-tt-solicitacao.cod-emitente                          
                                           b-tt-solicitacao.nome-abrev        
                                           emitente.nome-emit
                                           b-tt-solicitacao.NomeSolicitacaoBeneficio 
                                           upper(b-tt-solicitacao.desc-beneficio)     
                                           b-tt-solicitacao.CodigoUnidadeNegocio
                                           b-tt-solicitacao.DataCriacao
                                           b-tt-solicitacao.hora-trans
                                           b-tt-solicitacao.TrimestreCompetencia
                                           b-tt-solicitacao.desc-forma-pagto                      
                                           b-tt-solicitacao.vl-aprovado   
                                           c-data
                                           b-tt-solicitacao.vl-empenho-pago
                                           b-tt-solicitacao.vl-abatido-verba
                                           b-tt-solicitacao.a-pagar-solicit
                                           b-tt-solicitacao.vl-titulo-ori
                                           b-tt-solicitacao.vl-abatido-parcial 
                                           b-tt-solicitacao.vl-titulo
                                           b-tt-solicitacao.desc-situacao
                                           string(b-tt-solicitacao.log-enviada, "SIM/N«O")
                                           fnSituacao(b-tt-solicitacao.situacao)
                                           b-tt-solicitacao.cod-gr-cob 
                                           b-tt-solicitacao.CodigoSolicitacaoBeneficio.               

      END.

      OUTPUT STREAM s-1 CLOSE.

      IF  VALID-HANDLE(h-acomp) THEN                                      
          RUN pi-finalizar IN h-acomp.

      DOS SILENT START excel VALUE(c-arquivo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-tela w-cadsim 
PROCEDURE pi-limpa-tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN fi-descricao           :SCREEN-VALUE IN FRAME fpage1 = ""                     
           fi-nome-emit           :SCREEN-VALUE IN FRAME fpage1 = ""
           fi-beneficio           :SCREEN-VALUE IN FRAME fpage1 = ""
           fi-unidade             :SCREEN-VALUE IN FRAME fpage1 = ""
           fi-data                :SCREEN-VALUE IN FRAME fpage1 = "01/01/0001"
           fi-forma-pagto         :SCREEN-VALUE IN FRAME fpage1 = ""
           fi-grupo-cob           :SCREEN-VALUE IN FRAME fpage1 = "0"          
           fi-hora                :SCREEN-VALUE IN FRAME fpage1 = ""
           ed-descritivo          :SCREEN-VALUE IN FRAME fpage1 = ""
           fi-valor               :SCREEN-VALUE IN FRAME fpage1 = "0,00"
           fi-valor-abater        :SCREEN-VALUE IN FRAME fpage1 = "0,00"
           fi-pagtos              :SCREEN-VALUE IN FRAME fpage1 = "0,00"
           fi-situacao-solicitacao:SCREEN-VALUE IN FRAME fpage1 = ""
           fi-status              :SCREEN-VALUE IN FRAME fpage1 = ""
           tg-integrada:CHECKED                                 = NO.

    ASSIGN fi-item-cancelado    :SCREEN-VALUE IN FRAME fpage6 = "0,00"
           fi-item-aberto       :SCREEN-VALUE IN FRAME fpage6 = "0,00"
           fi-item-atendido     :SCREEN-VALUE IN FRAME fpage6 = "0,00"
           fi-emp-vl-pago       :SCREEN-VALUE IN FRAME fpage6 = "0,00"
           fi-emp-vl-cancelado  :SCREEN-VALUE IN FRAME fpage6 = "0,00".
           fi-emp-qtde-cancelada:SCREEN-VALUE IN FRAME fpage6 = "0,00".


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
  {src/adm/template/snd-list.i "tt-solicitacao"}
  {src/adm/template/snd-list.i "tt-itens"}
  {src/adm/template/snd-list.i "tt-pedido"}
  {src/adm/template/snd-list.i "tt-tit-acr"}

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
      WHEN 22 THEN RETURN "Stock Rot.".
      WHEN 66 THEN RETURN "Rebate P¢s".
      WHEN 15 THEN RETURN "Show Room".
      WHEN 04 THEN RETURN "Backup".
      WHEN 08 THEN RETURN "Price Protection".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCod-Sit-Item w-cadsim 
FUNCTION fnCod-Sit-Item RETURNS CHARACTER
  (INPUT p-tipo AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-tipo:
      WHEN 1 THEN RETURN "Aberto".          
      WHEN 2 THEN RETURN "Atend Parcial".
      WHEN 3 THEN RETURN "Atendido Total".  
      WHEN 4 THEN RETURN "Pendente".        
      WHEN 5 THEN RETURN "Suspenso".       
      WHEN 6 THEN RETURN "Cancelado".       
      WHEN 7 THEN RETURN "Fatur Balc∆o".    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSituacaoSolicitacao w-cadsim 
FUNCTION fnSituacaoSolicitacao RETURNS CHARACTER
  (INPUT p-sit AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-sit:
      WHEN 993520008 THEN RETURN "Aprovada".
      WHEN 993520003 THEN RETURN "Pagamento Pendente".
      WHEN 993520004 THEN RETURN "Pagamento Efetuado".
      WHEN 993520006 THEN RETURN "Cancelada".
      OTHERWISE RETURN "Em an†lise".
                
  END CASE.
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
      WHEN 993520003 THEN RETURN "PENDENTE".
      WHEN 993520004 THEN RETURN "PAGA".
      WHEN 993520006 THEN RETURN "CANCELADA".
      OTHERWISE RETURN "ANµLISE".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnStatusContaCorrente w-cadsim 
FUNCTION fnStatusContaCorrente RETURNS CHARACTER
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

