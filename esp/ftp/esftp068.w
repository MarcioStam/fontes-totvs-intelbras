&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP068 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP068
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Solicitaá‰es,Pedidos,Embarques,Pendentes,Saldo, Aguard.WMS,NF Transito,Reservado

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 ~
                              c-item btAtualiza bt-atualiza-estoque ~
                              tg-solic tg-ped tg-emb tg-pend tg-saldo
&GLOBAL-DEFINE page1Widgets   br-notas                                
&GLOBAL-DEFINE page2Widgets   br-pedido bt-selecao tg-orcamento
&GLOBAL-DEFINE page3Widgets   br-pre-fat
&GLOBAL-DEFINE page4Widgets   br-fat-ser-lote
&GLOBAL-DEFINE page5Widgets   br-saldo 
&GLOBAL-DEFINE page6Widgets   br-notas-wms 
&GLOBAL-DEFINE page7Widgets   br-nf-transito
&GLOBAL-DEFINE page8Widgets   br-reservado

DEFINE VARIABLE de-qt-pedida    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-qt-sdo-ped   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-qt-log-aloca AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-qt-alocada   AS DECIMAL     NO-UNDO.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE tt-notas 
    FIELD cod-estabel    LIKE estabelec.cod-estabel
    FIELD nr-pedido      LIKE it-ped-fiscal.nr-pedido
    FIELD cod-emitente   LIKE ped-fiscal.cod-emitente
    FIELD dt-emissao     LIKE ped-fiscal.dt-emissao
    FIELD nome-emit      LIKE emitente.nome-emit
    FIELD usuario-magnus LIKE ped-fiscal.usuario-magnus
    FIELD Nome           LIKE usuar_mestre.nom_usuario
    FIELD situacao       AS CHAR
    FIELD it-codigo      LIKE it-ped-fiscal.it-codigo   
    FIELD qtde           LIKE it-ped-fiscal.qtde        
    FIELD vl-unit        LIKE it-ped-fiscal.vl-unit     
    FIELD cod-depos      LIKE it-ped-fiscal.cod-depos.

DEF TEMP-TABLE tt-saldo-estoque
    FIELD it-codigo     LIKE saldo-estoq.it-codigo
    FIELD cod-estabel   LIKE saldo-estoq.cod-estabel
    FIELD cod-depos     LIKE saldo-estoq.cod-depos
    FIELD cod-refer     LIKE saldo-estoq.cod-refer
    FIELD cod-localiz   LIKE saldo-estoq.cod-localiz
    FIELD lote          LIKE saldo-estoq.lote
    FIELD dt-vali-lote  LIKE saldo-estoq.dt-vali-lote
    FIELD saldo-calc    AS DECIMAL FORMAT "->>>>>>,>>9.9999"
    FIELD qtidade-atu   LIKE saldo-estoq.qtidade-atu
    FIELD qt-disponivel AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999"
    FIELD qt-alocada    LIKE saldo-estoq.qt-alocada
    FIELD qt-aloc-prod  LIKE saldo-estoq.qt-aloc-prod
    FIELD qt-aloc-ped   LIKE saldo-estoq.qt-aloc-ped
    FIELD qt-atual-wms  AS DECIMAL FORMAT ">>>,>>>,>>9.9999"
    FIELD qt-disp-wms   AS DECIMAL FORMAT "->>>,>>>,>>9.9999"
    FIELD qt-bloq-wms   AS DECIMAL FORMAT ">>>,>>>,>>9.9999"
    FIELD qt-aloc-nao-integrada AS DECIMAL FORMAT ">>>,>>>,>>9.9999"
    FIELD qt-bloqueada  AS DEC
    FIELD qt-transito   AS DEC
    FIELD qt-reservada  AS DEC.

DEFINE TEMP-TABLE tt-ped-ent
    FIELD nome-abrev   LIKE ped-ent.nome-abrev  
    FIELD nr-pedcli    LIKE ped-ent.nr-pedcli   
    FIELD cod-refer    LIKE ped-ent.cod-refer   
    FIELD dt-entrega   LIKE ped-ent.dt-entrega  
    FIELD qt-pedida    LIKE ped-ent.qt-pedida
    FIELD qt-sdo-ped   LIKE ped-ent.qt-pedida
    FIELD qt-log-aloca LIKE ped-ent.qt-log-aloca
    FIELD qt-alocada   LIKE ped-ent.qt-alocada  
    FIELD cod-sit-ent  LIKE ped-ent.cod-sit-ent
    FIELD cod-priori   LIKE ped-venda.cod-priori
    FIELD cod-atendente AS CHARACTER FORMAT "x(3)" COLUMN-LABEL "At"
    FIELD nome-atend    AS CHARACTER FORMAT "x(15)" COLUMN-LABEL "Nome Atendente".

DEFINE TEMP-TABLE tt-it-pre-fat
    FIELD nr-embarque LIKE it-pre-fat.cdd-embarq
    FIELD nr-resumo   LIKE it-pre-fat.nr-resumo
    FIELD nome-abrev  LIKE it-pre-fat.nome-abrev
    FIELD nr-pedcli   LIKE it-pre-fat.nr-pedcli
    FIELD cod-depos   LIKE it-dep-fat.cod-depos
    FIELD cod-localiz LIKE it-dep-fat.cod-localiz
    FIELD qt-alocada  LIKE it-pre-fat.qt-alocada.

DEFINE TEMP-TABLE tt-wt-fat-ser-lote
    FIELD cod-estabel   LIKE fat-ser-lote.cod-estabel
    FIELD serie         LIKE fat-ser-lote.serie
    FIELD nr-nota-fis   LIKE fat-ser-lote.nr-nota-fis
    FIELD seq-wt-docto  LIKE wt-fat-ser-lote.seq-wt-docto 
    FIELD cod-depos     LIKE wt-fat-ser-lote.cod-depos    
    FIELD quantidade    LIKE wt-fat-ser-lote.quantidade.

DEFINE TEMP-TABLE tt-notas-wms LIKE int-wms-nf-atualiz
       FIELD cod-atendente  AS CHAR
       FIELD nome-atendente AS CHAR
       FIELD qt-bloqueada   AS DEC.
DEFINE TEMP-TABLE tt-notas-wms-estab
    FIELD cod-estabel LIKE estabelec.cod-estabel
    FIELD cod-depos   LIKE int-wms-nf-atualiz.cod-depos
    FIELD qtde-total  LIKE int-wms-nf-atualiz.qt-baixada.


DEFINE TEMP-TABLE tt-notas-transito NO-UNDO
       FIELD nr-nota-fis  AS CHAR
       FIELD serie        AS CHAR
       FIELD cod-estabel  AS CHAR
       FIELD nr-seq-fat   AS INT
       FIELD it-codigo    AS CHAR
       FIELD qt-transito  AS DEC.

DEF NEW GLOBAL SHARED VAR c-seg-usuario  AS CHAR FORMAT "x(12)"    NO-UNDO.
DEF NEW GLOBAL SHARED VAR g-saldo-zerado AS LOGICAL INITIAL NO     NO-UNDO.
DEF NEW GLOBAL SHARED VAR g-dt-saldo     LIKE movto-estoq.dt-trans NO-UNDO.

DEF VAR h-acomp AS HANDLE NO-UNDO.

DEF VAR c-nome-abrev-ini  LIKE ped-ent.nome-abrev INIT ""             NO-UNDO.
DEF VAR c-nome-abrev-fim  LIKE ped-ent.nome-abrev INIT "ZZZZZZZZZZZZ" NO-UNDO.
DEF VAR c-nr-pedcli-ini   LIKE ped-ent.nr-pedcli  INIT ""             NO-UNDO.
DEF VAR c-nr-pedcli-fim   LIKE ped-ent.nr-pedcli  INIT "ZZZZZZZZZZZZ" NO-UNDO.
DEF VAR da-dt-entrega-ini LIKE ped-ent.dt-entrega                     NO-UNDO.
DEF VAR da-dt-entrega-fim LIKE ped-ent.dt-entrega                     NO-UNDO.
DEF VAR c-atend-ini       LIKE ped-venda.tp-pedido                    NO-UNDO.
DEF VAR c-atend-fim       LIKE ped-venda.tp-pedido INIT "99"          NO-UNDO.
DEF VAR c-estab-ini         AS CHAR                                   NO-UNDO.
DEF VAR c-estab-fim         AS CHAR INIT "ZZZ"                        NO-UNDO.
DEFINE VARIABLE de-qt-priori-01 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-saldo-exp AS DECIMAL     NO-UNDO.

DEF VAR c-estabel         LIKE ped-venda.cod-estabel           NO-UNDO.
DEF VAR c-completo        AS CHAR FORMAT "x(05)"               NO-UNDO.
DEF VAR c-sit-item        AS CHAR FORMAT "x(15)"               NO-UNDO.
DEF VAR c-lista-sit-item  AS CHAR                              NO-UNDO.
DEF VAR c-sit-credito     AS CHAR FORMAT "x(15)"               NO-UNDO.
DEF VAR c-lista-sit-cred  AS CHAR                              NO-UNDO.

DEF VAR de-qt-saldo       AS DEC  FORMAT "->,>>>,>>>,>>9.9999" NO-UNDO.
DEF VAR l-cancela         AS LOG                               NO-UNDO.

DEF VAR d-saldo-calculado      AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999" LABEL "Quantidade na Data" NO-UNDO.
DEF VAR d-saldo-calculado-disp AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999" LABEL "Quantidade na Data" NO-UNDO.
DEF VAR d-disponivel-disp      AS DECIMAL FORMAT "->>>>>>,>>9.9999"    LABEL "Dispon°vel"         NO-UNDO.
DEFINE VARIABLE d-qt-aloc-ped-disp  AS DECIMAL     NO-UNDO.

DEFINE VAR hDBOWm-saldo-estoque AS HANDLE NO-UNDO.
DEFINE VAR qtd-bloqueada AS DEC NO-UNDO.

DEFINE VARIABLE c-clientes AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE ttWm-saldo NO-UNDO
    FIELD cod-estabel    LIKE wm-saldo-estoque.cod-estabel
    FIELD cod-local      LIKE wm-saldo-estoque.cod-local
    FIELD cod-cliente    LIKE wm-saldo-estoque.cod-cliente
    FIELD cod-refer      LIKE wm-saldo-estoque.cod-refer
    FIELD cod-embal      LIKE wm-box-saldo.cod-embalagem
    FIELD qtd-atual      LIKE wm-saldo-estoque.qtd-atual COLUMN-LABEL "Qtd Item Atual"
    FIELD qtd-liberada   LIKE wm-saldo-estoque.qtd-atual COLUMN-LABEL "Qtd Item Liberada"
    FIELD qtd-destinada  LIKE wm-saldo-estoque.qtd-atual COLUMN-LABEL "Qtd Destinada"
    FIELD qtd-compromet  LIKE wm-saldo-estoque.qtd-atual COLUMN-LABEL "Qtd Comprometida"
    FIELD qtd-bloq-pick  LIKE wm-saldo-estoque.qtd-atual COLUMN-LABEL "Qtd Bloq Picking"
    FIELD qtd-analise    LIKE wm-saldo-estoque.qtd-atual COLUMN-LABEL "Qtd Anˇlise"
    FIELD r-rowid        AS ROWID.

DEF TEMP-TABLE tt-reserva-user NO-UNDO
    FIELD cod-depos   AS CHAR
    FIELD cod-estabel AS CHAR
    FIELD it-codigo   AS CHAR
    FIELD usuario     AS CHAR FORMAT "x(12)"
    FIELD nome        AS CHAR 
    FIELD qt-reserva  AS INTEGER
    FIELD observ      AS CHAR. 

{esp/es0018.i}

{cdp/cd0666.i} /*tt-erro*/

//{esp/pdp/espdp006fn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-fat-ser-lote

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-wt-fat-ser-lote tt-notas-transito ~
tt-notas tt-notas-wms tt-notas-wms-estab tt-ped-ent ped-venda tt-it-pre-fat ~
tt-reserva-user tt-saldo-estoque

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br-fat-ser-lote                               */
&Scoped-define FIELDS-IN-QUERY-br-fat-ser-lote tt-wt-fat-ser-lote.cod-estabel tt-wt-fat-ser-lote.serie tt-wt-fat-ser-lote.nr-nota-fis tt-wt-fat-ser-lote.seq-wt-docto tt-wt-fat-ser-lote.cod-depos tt-wt-fat-ser-lote.quantidade[1]   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-fat-ser-lote   
&Scoped-define SELF-NAME br-fat-ser-lote
&Scoped-define QUERY-STRING-br-fat-ser-lote FOR EACH tt-wt-fat-ser-lote
&Scoped-define OPEN-QUERY-br-fat-ser-lote OPEN QUERY {&SELF-NAME} FOR EACH tt-wt-fat-ser-lote.
&Scoped-define TABLES-IN-QUERY-br-fat-ser-lote tt-wt-fat-ser-lote
&Scoped-define FIRST-TABLE-IN-QUERY-br-fat-ser-lote tt-wt-fat-ser-lote


/* Definitions for BROWSE br-nf-transito                                */
&Scoped-define FIELDS-IN-QUERY-br-nf-transito tt-notas-transito.cod-estabel tt-notas-transito.serie tt-notas-transito.nr-nota-fis tt-notas-transito.nr-seq-fat //tt-notas-transito.it-codigo tt-notas-transito.qt-transito   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-nf-transito   
&Scoped-define SELF-NAME br-nf-transito
&Scoped-define QUERY-STRING-br-nf-transito FOR EACH tt-notas-transito
&Scoped-define OPEN-QUERY-br-nf-transito OPEN QUERY {&SELF-NAME} FOR EACH tt-notas-transito.
&Scoped-define TABLES-IN-QUERY-br-nf-transito tt-notas-transito
&Scoped-define FIRST-TABLE-IN-QUERY-br-nf-transito tt-notas-transito


/* Definitions for BROWSE br-notas                                      */
&Scoped-define FIELDS-IN-QUERY-br-notas tt-notas.cod-estabel tt-notas.nr-pedido tt-notas.cod-emitente tt-notas.dt-emissao tt-notas.nome-emit tt-notas.usuario-magnus tt-notas.nome tt-notas.situacao tt-notas.it-codigo tt-notas.qtde tt-notas.vl-unit tt-notas.cod-depos   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-notas   
&Scoped-define SELF-NAME br-notas
&Scoped-define QUERY-STRING-br-notas FOR EACH tt-notas BY tt-notas.situacao                                           BY tt-notas.cod-emitente                                           BY tt-notas.nr-pedido
&Scoped-define OPEN-QUERY-br-notas OPEN QUERY {&SELF-NAME} FOR EACH tt-notas BY tt-notas.situacao                                           BY tt-notas.cod-emitente                                           BY tt-notas.nr-pedido.
&Scoped-define TABLES-IN-QUERY-br-notas tt-notas
&Scoped-define FIRST-TABLE-IN-QUERY-br-notas tt-notas


/* Definitions for BROWSE br-notas-wms                                  */
&Scoped-define FIELDS-IN-QUERY-br-notas-wms tt-notas-wms.cod-estabel tt-notas-wms.serie tt-notas-wms.nr-nota-fis tt-notas-wms.nr-seq-fat tt-notas-wms.it-codigo tt-notas-wms.cod-depos tt-notas-wms.qt-baixada tt-notas-wms.cod-atendente tt-notas-wms.nome-atendente   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-notas-wms   
&Scoped-define SELF-NAME br-notas-wms
&Scoped-define QUERY-STRING-br-notas-wms FOR EACH tt-notas-wms
&Scoped-define OPEN-QUERY-br-notas-wms OPEN QUERY {&SELF-NAME} FOR EACH tt-notas-wms.
&Scoped-define TABLES-IN-QUERY-br-notas-wms tt-notas-wms
&Scoped-define FIRST-TABLE-IN-QUERY-br-notas-wms tt-notas-wms


/* Definitions for BROWSE br-notas-wms-estab                            */
&Scoped-define FIELDS-IN-QUERY-br-notas-wms-estab tt-notas-wms-estab.cod-estabel tt-notas-wms-estab.cod-depos tt-notas-wms-estab.qtde-total   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-notas-wms-estab   
&Scoped-define SELF-NAME br-notas-wms-estab
&Scoped-define QUERY-STRING-br-notas-wms-estab FOR EACH tt-notas-wms-estab
&Scoped-define OPEN-QUERY-br-notas-wms-estab OPEN QUERY {&SELF-NAME} FOR EACH tt-notas-wms-estab.
&Scoped-define TABLES-IN-QUERY-br-notas-wms-estab tt-notas-wms-estab
&Scoped-define FIRST-TABLE-IN-QUERY-br-notas-wms-estab tt-notas-wms-estab


/* Definitions for BROWSE br-pedido                                     */
&Scoped-define FIELDS-IN-QUERY-br-pedido fn-estabelecimento() @ c-estabel tt-ped-ent.nome-abrev tt-ped-ent.nr-pedcli tt-ped-ent.cod-atend tt-ped-ent.cod-priori tt-ped-ent.nome-atend tt-ped-ent.cod-refer tt-ped-ent.dt-entrega tt-ped-ent.qt-pedida tt-ped-ent.qt-sdo-ped tt-ped-ent.qt-log-aloca tt-ped-ent.qt-alocada fn-qt-saldo() @ de-qt-saldo ENTRY(tt-ped-ent.cod-sit-ent,c-lista-sit-item) @ c-sit-item fn-sit-aval() @ c-sit-credito fn-completo() @ c-completo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-pedido   
&Scoped-define SELF-NAME br-pedido
&Scoped-define QUERY-STRING-br-pedido FOR EACH tt-ped-ent, ~
                               FIRST ped-venda OF tt-ped-ent
&Scoped-define OPEN-QUERY-br-pedido OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-ent, ~
                               FIRST ped-venda OF tt-ped-ent.
&Scoped-define TABLES-IN-QUERY-br-pedido tt-ped-ent ped-venda
&Scoped-define FIRST-TABLE-IN-QUERY-br-pedido tt-ped-ent
&Scoped-define SECOND-TABLE-IN-QUERY-br-pedido ped-venda


/* Definitions for BROWSE br-pre-fat                                    */
&Scoped-define FIELDS-IN-QUERY-br-pre-fat tt-it-pre-fat.nr-embarque tt-it-pre-fat.nr-resumo tt-it-pre-fat.nr-pedcli tt-it-pre-fat.nome-abrev tt-it-pre-fat.cod-depos tt-it-pre-fat.cod-localiz tt-it-pre-fat.qt-alocada   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-pre-fat   
&Scoped-define SELF-NAME br-pre-fat
&Scoped-define QUERY-STRING-br-pre-fat FOR EACH tt-it-pre-fat
&Scoped-define OPEN-QUERY-br-pre-fat OPEN QUERY {&SELF-NAME} FOR EACH tt-it-pre-fat.
&Scoped-define TABLES-IN-QUERY-br-pre-fat tt-it-pre-fat
&Scoped-define FIRST-TABLE-IN-QUERY-br-pre-fat tt-it-pre-fat


/* Definitions for BROWSE br-reservado                                  */
&Scoped-define FIELDS-IN-QUERY-br-reservado tt-reserva-user.cod-estabel tt-reserva-user.cod-depos tt-reserva-user.qt-reserva tt-reserva-user.usuario tt-reserva-user.nome tt-reserva-user.observ   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-reservado   
&Scoped-define SELF-NAME br-reservado
&Scoped-define QUERY-STRING-br-reservado FOR EACH tt-reserva-user
&Scoped-define OPEN-QUERY-br-reservado OPEN QUERY {&SELF-NAME} FOR EACH tt-reserva-user.
&Scoped-define TABLES-IN-QUERY-br-reservado tt-reserva-user
&Scoped-define FIRST-TABLE-IN-QUERY-br-reservado tt-reserva-user


/* Definitions for BROWSE br-saldo                                      */
&Scoped-define FIELDS-IN-QUERY-br-saldo tt-saldo-estoque.cod-estabel tt-saldo-estoque.cod-depos tt-saldo-estoque.lote tt-saldo-estoque.cod-refer tt-saldo-estoque.cod-localiz tt-saldo-estoque.saldo-calc tt-saldo-estoque.qtidade-atu tt-saldo-estoque.qt-disponivel tt-saldo-estoque.qt-alocada tt-saldo-estoque.qt-aloc-prod tt-saldo-estoque.qt-aloc-ped tt-saldo-estoque.qt-transito tt-saldo-estoque.qt-reservada tt-saldo-estoque.qt-atual-wms tt-saldo-estoque.qt-disp-wms tt-saldo-estoque.qt-bloq-wms tt-saldo-estoque.qt-aloc-nao-integrada tt-saldo-estoque.qt-bloqueada   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-saldo   
&Scoped-define SELF-NAME br-saldo
&Scoped-define QUERY-STRING-br-saldo FOR EACH tt-saldo-estoque
&Scoped-define OPEN-QUERY-br-saldo OPEN QUERY {&SELF-NAME} FOR EACH tt-saldo-estoque.
&Scoped-define TABLES-IN-QUERY-br-saldo tt-saldo-estoque
&Scoped-define FIRST-TABLE-IN-QUERY-br-saldo tt-saldo-estoque


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-notas}

/* Definitions for FRAME fPage2                                         */

/* Definitions for FRAME fPage3                                         */

/* Definitions for FRAME fPage4                                         */

/* Definitions for FRAME fPage5                                         */

/* Definitions for FRAME fpage6                                         */

/* Definitions for FRAME fpage7                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage7 ~
    ~{&OPEN-QUERY-br-nf-transito}

/* Definitions for FRAME fpage8                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage8 ~
    ~{&OPEN-QUERY-br-reservado}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar btQueryJoins ~
btReportsJoins btExit btHelp c-item btAtualiza bt-atualiza-estoque tg-solic ~
tg-ped c-descricao tg-emb tg-pend tg-saldo btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS c-item tg-solic tg-ped c-descricao tg-emb ~
tg-pend tg-saldo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-completo wWindow 
FUNCTION fn-completo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-estabelecimento wWindow 
FUNCTION fn-estabelecimento RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-qt-saldo wWindow 
FUNCTION fn-qt-saldo RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-qtd-data wWindow 
FUNCTION fn-qtd-data RETURNS DECIMAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-sit-aval wWindow 
FUNCTION fn-sit-aval RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEstoque wWindow 
FUNCTION fnEstoque RETURNS DECIMAL
  ( INPUT p-cod-estabel   AS CHAR,
    INPUT p-it-codigo     AS CHAR,
    INPUT p-cod-depos     AS CHAR,
    INPUT p-cod-localiz   AS CHAR,
    INPUT p-lote          AS CHAR,
    INPUT p-saldo-central AS LOG) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-atualiza-estoque 
     LABEL "Atualiza Alocaá∆o" 
     SIZE 21 BY 1.

DEFINE BUTTON btAtualiza 
     IMAGE-UP FILE "adeicon/check.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descriá∆o" 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE c-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 147 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 150 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tg-emb AS LOGICAL INITIAL yes 
     LABEL "Embarques" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ped AS LOGICAL INITIAL yes 
     LABEL "Pedidos" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .83 NO-UNDO.

DEFINE VARIABLE tg-pend AS LOGICAL INITIAL yes 
     LABEL "Notas Pendentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-saldo AS LOGICAL INITIAL yes 
     LABEL "Saldo Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-solic AS LOGICAL INITIAL yes 
     LABEL "Solicitaá‰es" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE c-total-qtde AS CHARACTER FORMAT "X(256)":U 
     LABEL "Total Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-total-valor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Total Valor" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE BUTTON bt-selecao 
     LABEL "Se&leá∆o" 
     SIZE 12 BY 1.

DEFINE VARIABLE d-qt-aloc-ped AS CHARACTER FORMAT "X(256)":U 
     LABEL "Qtde Alocada Pedida" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE d-qt-alocada AS CHARACTER FORMAT "X(256)":U 
     LABEL "Qtdade Alocada" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE d-qt-pedida-tot AS CHARACTER FORMAT "X(256)":U 
     LABEL "Qtdade Pedida" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE d-qt-saldo-exp AS CHARACTER FORMAT "X(256)":U 
     LABEL "(Saldo EXP/WEX)-(Ped.Priorid. 01)" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE tg-orcamento AS LOGICAL INITIAL no 
     LABEL "Listar Oráamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE d-tot-disponivel AS DECIMAL FORMAT "->>>>>>,>>9.9999":U INITIAL 0 
     LABEL "Tot Disp" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE d-tot-saldo-calc AS DECIMAL FORMAT "->>>>>>,>>9.9999":U INITIAL 0 
     LABEL "Tot Qtde Data" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-qt-aloc-ped AS DECIMAL FORMAT "->>>>>>,>>9.9999":U INITIAL 0 
     LABEL "Total Pedidos Alocados" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-saldo AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Saldo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-fat-ser-lote FOR 
      tt-wt-fat-ser-lote SCROLLING.

DEFINE QUERY br-nf-transito FOR 
      tt-notas-transito SCROLLING.

DEFINE QUERY br-notas FOR 
      tt-notas SCROLLING.

DEFINE QUERY br-notas-wms FOR 
      tt-notas-wms SCROLLING.

DEFINE QUERY br-notas-wms-estab FOR 
      tt-notas-wms-estab SCROLLING.

DEFINE QUERY br-pedido FOR 
      tt-ped-ent, 
      ped-venda SCROLLING.

DEFINE QUERY br-pre-fat FOR 
      tt-it-pre-fat SCROLLING.

DEFINE QUERY br-reservado FOR 
      tt-reserva-user SCROLLING.

DEFINE QUERY br-saldo FOR 
      tt-saldo-estoque SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-fat-ser-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-fat-ser-lote wWindow _FREEFORM
  QUERY br-fat-ser-lote NO-LOCK DISPLAY
      tt-wt-fat-ser-lote.cod-estabel   COLUMN-LABEL "Estab"
tt-wt-fat-ser-lote.serie         COLUMN-LABEL "Serie"
tt-wt-fat-ser-lote.nr-nota-fis   COLUMN-LABEL "Nr. Nota Fiscal"
tt-wt-fat-ser-lote.seq-wt-docto  WIDTH 10 COLUMN-LABEL "Docto FT4003"
tt-wt-fat-ser-lote.cod-depos     WIDTH 10 COLUMN-LABEL "Deposito"   
tt-wt-fat-ser-lote.quantidade[1] WIDTH 15 COLUMN-LABEL "Quantidade"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 141.57 BY 9.79
         FONT 1
         TITLE "Notas Pendentes Atualizaá∆o".

DEFINE BROWSE br-nf-transito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-nf-transito wWindow _FREEFORM
  QUERY br-nf-transito DISPLAY
      tt-notas-transito.cod-estabel  COLUMN-LABEL "Estab"
 tt-notas-transito.serie        COLUMN-LABEL "Serie"
 tt-notas-transito.nr-nota-fis  COLUMN-LABEL "Nota Fiscal"
 tt-notas-transito.nr-seq-fat   COLUMN-LABEL "Seq Fat"
 //tt-notas-transito.it-codigo  
 tt-notas-transito.qt-transito  COLUMN-LABEL "Qt Transito" WIDTH 20
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 122 BY 7
         FONT 1
         TITLE "Notas em transito" FIT-LAST-COLUMN.

DEFINE BROWSE br-notas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-notas wWindow _FREEFORM
  QUERY br-notas DISPLAY
      tt-notas.cod-estabel
      tt-notas.nr-pedido     
      tt-notas.cod-emitente  
      tt-notas.dt-emissao    
      tt-notas.nome-emit    FORMAT "x(20)"   
      tt-notas.usuario-magnus COLUMN-LABEL "Usuario"
      tt-notas.nome
      tt-notas.situacao      
      tt-notas.it-codigo FORMAT "x(10)"    
      tt-notas.qtde          
      tt-notas.vl-unit       
      tt-notas.cod-depos
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 142.43 BY 9.54
         FONT 1
         TITLE "Notas Fiscais" FIT-LAST-COLUMN.

DEFINE BROWSE br-notas-wms
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-notas-wms wWindow _FREEFORM
  QUERY br-notas-wms NO-LOCK DISPLAY
      tt-notas-wms.cod-estabel  COLUMN-LABEL "Estab"
   tt-notas-wms.serie        COLUMN-LABEL "SÇrie"
   tt-notas-wms.nr-nota-fis  COLUMN-LABEL "Nr. Nota"
   tt-notas-wms.nr-seq-fat   COLUMN-LABEL "Seq Item Nota"
   tt-notas-wms.it-codigo    COLUMN-LABEL "Item"
   tt-notas-wms.cod-depos    COLUMN-LABEL "Dep¢sito"
   tt-notas-wms.qt-baixada   COLUMN-LABEL "Qtdee Aguardando WMS"
   tt-notas-wms.cod-atendente COLUMN-LABEL "Atendente"
   tt-notas-wms.nome-atendente COLUMN-LABEL "Nm Atend"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 111 BY 6.25
         FONT 1
         TITLE "Notas Aguardando Integraá∆o com  W M S" ROW-HEIGHT-CHARS .46.

DEFINE BROWSE br-notas-wms-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-notas-wms-estab wWindow _FREEFORM
  QUERY br-notas-wms-estab NO-LOCK DISPLAY
      tt-notas-wms-estab.cod-estabel  COLUMN-LABEL "Estab"      WIDTH 7
      tt-notas-wms-estab.cod-depos    COLUMN-LABEL "Dep¢sito"   WIDTH 7
      tt-notas-wms-estab.qtde-total   COLUMN-LABEL "Quantidade" WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 41 BY 4.75
         FONT 1
         TITLE "Totais por Estabelecimento" ROW-HEIGHT-CHARS .46.

DEFINE BROWSE br-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-pedido wWindow _FREEFORM
  QUERY br-pedido NO-LOCK DISPLAY
      fn-estabelecimento() @ c-estabel
      tt-ped-ent.nome-abrev   FORMAT "x(20)":U
      tt-ped-ent.nr-pedcli    FORMAT "x(12)":U
      tt-ped-ent.cod-atend    FORMAT "x(2)":U
      tt-ped-ent.cod-priori   
      tt-ped-ent.nome-atend   FORMAT "x(12)":U
      tt-ped-ent.cod-refer    FORMAT "x(8)":U
      tt-ped-ent.dt-entrega   FORMAT "99/99/9999":U COLUMN-LABEL "Prev.Fatur"
      tt-ped-ent.qt-pedida    FORMAT ">>>>,>>9.9999":U
      tt-ped-ent.qt-sdo-ped   FORMAT ">>>>,>>9.9999":U COLUMN-LABEL "Sdo Ped"
      tt-ped-ent.qt-log-aloca FORMAT ">>>>,>>9.9999":U
      tt-ped-ent.qt-alocada   FORMAT ">>>>,>>9.9999":U
      fn-qt-saldo() @ de-qt-saldo
      ENTRY(tt-ped-ent.cod-sit-ent,c-lista-sit-item) @ c-sit-item
      fn-sit-aval() @ c-sit-credito
      fn-completo() @ c-completo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 142.57 BY 9.75
         FONT 1
         TITLE "Alocaá‰es".

DEFINE BROWSE br-pre-fat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-pre-fat wWindow _FREEFORM
  QUERY br-pre-fat NO-LOCK DISPLAY
      tt-it-pre-fat.nr-embarque       WIDTH 10 COLUMN-LABEL "Embarque"     
      tt-it-pre-fat.nr-resumo         WIDTH 10 COLUMN-LABEL "Resumo"     
      tt-it-pre-fat.nr-pedcli         WIDTH 10 COLUMN-LABEL "Pedido"       
      tt-it-pre-fat.nome-abrev        WIDTH 10 COLUMN-LABEL "Nome Abrev"       
      tt-it-pre-fat.cod-depos         WIDTH 10 COLUMN-LABEL "Deposito"     
      tt-it-pre-fat.cod-localiz       WIDTH 15 COLUMN-LABEL "Localizacao"  
      tt-it-pre-fat.qt-alocada        WIDTH 15 COLUMN-LABEL "Qtde Alocada"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 142.57 BY 9.79
         FONT 1
         TITLE "Embarques".

DEFINE BROWSE br-reservado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-reservado wWindow _FREEFORM
  QUERY br-reservado DISPLAY
      tt-reserva-user.cod-estabel  COLUMN-LABEL "Estab"
tt-reserva-user.cod-depos    COLUMN-LABEL "Depos"
tt-reserva-user.qt-reserva   COLUMN-LABEL "Qt Reservada" FORMAT "->>>>,>>9.9999" WIDTH 10
tt-reserva-user.usuario      COLUMN-LABEL "Usuario" FORMAT 'x(12)'
tt-reserva-user.nome         COLUMN-LABEL "Nome" FORMAT 'x(150)' WIDTH 40
tt-reserva-user.observ       COLUMN-LABEL "Observ." FORMAT 'x(200)'
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 134 BY 7
         FONT 1
         TITLE "Saldo Reservado" FIT-LAST-COLUMN.

DEFINE BROWSE br-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-saldo wWindow _FREEFORM
  QUERY br-saldo NO-LOCK DISPLAY
      tt-saldo-estoque.cod-estabel     FORMAT "X(3)"  
    tt-saldo-estoque.cod-depos                                                  WIDTH 5
    tt-saldo-estoque.lote                                                  WIDTH 12
    tt-saldo-estoque.cod-refer       FORMAT "x(12)"                             WIDTH 5
    tt-saldo-estoque.cod-localiz                                                WIDTH 8
    tt-saldo-estoque.saldo-calc                                                 WIDTH 13
    tt-saldo-estoque.qtidade-atu                                                WIDTH 10
    tt-saldo-estoque.qt-disponivel   FORMAT "->>>>>>,>>9.9999"                  WIDTH 13
    tt-saldo-estoque.qt-alocada      FORMAT "->>>>,>>9.9999"                    WIDTH 10
    tt-saldo-estoque.qt-aloc-prod    FORMAT "->>>>,>>9.9999"                    WIDTH 10
    tt-saldo-estoque.qt-aloc-ped     FORMAT "->>>>,>>9.9999"                    WIDTH 10
    tt-saldo-estoque.qt-transito    COLUMN-LABEL "Qt Transito"  FORMAT "->>>>,>>9.9999" WIDTH 10
    tt-saldo-estoque.qt-reservada   COLUMN-LABEL "Qt Reservada" FORMAT "->>>>,>>9.9999" WIDTH 10
    tt-saldo-estoque.qt-atual-wms            COLUMN-LABEL "Atual WMS"           WIDTH 10
    tt-saldo-estoque.qt-disp-wms             COLUMN-LABEL "Dispon.WMS"          WIDTH 10
    tt-saldo-estoque.qt-bloq-wms             COLUMN-LABEL "Bloq.WMS"            WIDTH 10
    tt-saldo-estoque.qt-aloc-nao-integrada   COLUMN-LABEL "Aguardando integr WMS" WIDTH 16
    tt-saldo-estoque.qt-bloqueada   COLUMN-LABEL "Aguardando Separacao" WIDTH 16
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 144.43 BY 9.54
         FONT 1
         TITLE "Saldo Estoque".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.17 COL 131 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.17 COL 135 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.17 COL 139 HELP
          "Sair"
     btHelp AT ROW 1.17 COL 143 HELP
          "Ajuda"
     c-item AT ROW 3 COL 13.14 COLON-ALIGNED
     btAtualiza AT ROW 3 COL 32.57
     bt-atualiza-estoque AT ROW 3 COL 40 WIDGET-ID 2
     tg-solic AT ROW 3 COL 74
     tg-ped AT ROW 4 COL 74
     c-descricao AT ROW 4.25 COL 13 COLON-ALIGNED
     tg-emb AT ROW 5 COL 74
     tg-pend AT ROW 6 COL 74
     tg-saldo AT ROW 7 COL 74
     btOK AT ROW 22.96 COL 2
     btCancel AT ROW 22.96 COL 13
     btHelp2 AT ROW 23 COL 137
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 22.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 150.14 BY 23.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fpage8
     br-reservado AT ROW 2.5 COL 6 WIDGET-ID 600
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 9.71
         SIZE 144.43 BY 11.83
         FONT 1 WIDGET-ID 700.

DEFINE FRAME fpage6
     br-notas-wms AT ROW 1.75 COL 20.43
     br-notas-wms-estab AT ROW 8.46 COL 53.14 WIDGET-ID 300
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 9.5
         SIZE 146 BY 12.75
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage3
     br-pre-fat AT ROW 1.71 COL 1.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 9.5
         SIZE 144.43 BY 12.75
         FONT 1.

DEFINE FRAME fPage1
     br-notas AT ROW 1.71 COL 1.57
     c-total-qtde AT ROW 11.5 COL 47 COLON-ALIGNED
     c-total-valor AT ROW 11.5 COL 70 COLON-ALIGNED
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 9.75
         SIZE 144.43 BY 12.25
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     br-fat-ser-lote AT ROW 1.71 COL 1.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 9.5
         SIZE 144.43 BY 11.25
         FONT 1.

DEFINE FRAME fPage2
     br-pedido AT ROW 1.25 COL 1
     bt-selecao AT ROW 11.5 COL 3
     tg-orcamento AT ROW 11.75 COL 16.14 WIDGET-ID 10
     d-qt-pedida-tot AT ROW 11.75 COL 40.57 COLON-ALIGNED WIDGET-ID 2
     d-qt-aloc-ped AT ROW 11.75 COL 68.86 COLON-ALIGNED WIDGET-ID 6
     d-qt-alocada AT ROW 11.75 COL 93.29 COLON-ALIGNED WIDGET-ID 4
     d-qt-saldo-exp AT ROW 11.75 COL 130.29 COLON-ALIGNED WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 9.75
         SIZE 144.43 BY 12.25
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fpage7
     br-nf-transito AT ROW 2.5 COL 8 WIDGET-ID 600
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 9.71
         SIZE 144.43 BY 11.83
         FONT 1 WIDGET-ID 500.

DEFINE FRAME fPage5
     br-saldo AT ROW 1.71 COL 1.57
     dt-saldo AT ROW 11.5 COL 36 COLON-ALIGNED
     d-tot-saldo-calc AT ROW 11.5 COL 57 COLON-ALIGNED
     d-tot-disponivel AT ROW 11.5 COL 80 COLON-ALIGNED
     de-qt-aloc-ped AT ROW 11.5 COL 114 COLON-ALIGNED WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 9.5
         SIZE 146 BY 12.75
         FONT 1.


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
         HEIGHT             = 23.75
         WIDTH              = 150.14
         MAX-HEIGHT         = 28.54
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.54
         VIRTUAL-WIDTH      = 195.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fpage6:FRAME = FRAME fpage0:HANDLE
       FRAME fpage7:FRAME = FRAME fpage0:HANDLE
       FRAME fpage8:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
ASSIGN 
       c-descricao:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-notas 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB br-pedido 1 fPage2 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB br-pre-fat 1 fPage3 */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB br-fat-ser-lote 1 fPage4 */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB br-saldo 1 fPage5 */
/* SETTINGS FOR FILL-IN d-tot-disponivel IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-tot-saldo-calc IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qt-aloc-ped IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dt-saldo IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fpage6
                                                                        */
/* BROWSE-TAB br-notas-wms 1 fpage6 */
/* BROWSE-TAB br-notas-wms-estab br-notas-wms fpage6 */
/* SETTINGS FOR FRAME fpage7
                                                                        */
/* BROWSE-TAB br-nf-transito 1 fpage7 */
/* SETTINGS FOR FRAME fpage8
                                                                        */
/* BROWSE-TAB br-reservado 1 fpage8 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-fat-ser-lote
/* Query rebuild information for BROWSE br-fat-ser-lote
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-wt-fat-ser-lote.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST USED,"
     _JoinCode[1]      = "movdis.ped-ent.it-codigo = mgind.item.it-codigo"
     _Where[1]         = "ped-ent.dt-entrega  >= da-dt-entrega-ini and
ped-ent.dt-entrega  <= da-dt-entrega-fim and
ped-ent.cod-sit-ent <= 2
"
     _Query            is NOT OPENED
*/  /* BROWSE br-fat-ser-lote */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-nf-transito
/* Query rebuild information for BROWSE br-nf-transito
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-notas-transito.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-nf-transito */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-notas
/* Query rebuild information for BROWSE br-notas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-notas BY tt-notas.situacao
                                          BY tt-notas.cod-emitente
                                          BY tt-notas.nr-pedido.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-notas */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-notas-wms
/* Query rebuild information for BROWSE br-notas-wms
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-notas-wms.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE"
     _Where[1]         = "( (not g-saldo-zerado and saldo-estoq.qtidade-atu <> 0 ) or
 (g-saldo-zerado = yes) )"
     _Query            is NOT OPENED
*/  /* BROWSE br-notas-wms */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-notas-wms-estab
/* Query rebuild information for BROWSE br-notas-wms-estab
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-notas-wms-estab.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE"
     _Where[1]         = "( (not g-saldo-zerado and saldo-estoq.qtidade-atu <> 0 ) or
 (g-saldo-zerado = yes) )"
     _Query            is NOT OPENED
*/  /* BROWSE br-notas-wms-estab */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-pedido
/* Query rebuild information for BROWSE br-pedido
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-ent,
                        FIRST ped-venda OF tt-ped-ent.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST USED,"
     _JoinCode[1]      = "movdis.ped-ent.it-codigo = mgind.item.it-codigo"
     _Where[1]         = "ped-ent.dt-entrega  >= da-dt-entrega-ini and
ped-ent.dt-entrega  <= da-dt-entrega-fim and
ped-ent.cod-sit-ent <= 2
"
     _Where[2]         = " ped-venda.nome-abrev >= c-nome-abrev-ini and
 ped-venda.nome-abrev <= c-nome-abrev-fim and
 ped-venda.nr-pedcli  >= c-nr-pedcli-ini  and
 ped-venda.nr-pedcli  <= c-nr-pedcli-fim  and 
 ped-venda.esp-ped <> 2"
     _Query            is NOT OPENED
*/  /* BROWSE br-pedido */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-pre-fat
/* Query rebuild information for BROWSE br-pre-fat
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-it-pre-fat.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST USED,"
     _JoinCode[1]      = "movdis.ped-ent.it-codigo = mgind.item.it-codigo"
     _Where[1]         = "ped-ent.dt-entrega  >= da-dt-entrega-ini and
ped-ent.dt-entrega  <= da-dt-entrega-fim and
ped-ent.cod-sit-ent <= 2
"
     _Query            is NOT OPENED
*/  /* BROWSE br-pre-fat */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-reservado
/* Query rebuild information for BROWSE br-reservado
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-reserva-user.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-reservado */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-saldo
/* Query rebuild information for BROWSE br-saldo
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-saldo-estoque.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE"
     _Where[1]         = "( (not g-saldo-zerado and saldo-estoq.qtidade-atu <> 0 ) or
 (g-saldo-zerado = yes) )"
     _Query            is NOT OPENED
*/  /* BROWSE br-saldo */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage5
/* Query rebuild information for FRAME fPage5
     _Query            is NOT OPENED
*/  /* FRAME fPage5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage6
/* Query rebuild information for FRAME fpage6
     _Query            is NOT OPENED
*/  /* FRAME fpage6 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage7
/* Query rebuild information for FRAME fpage7
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage7 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage8
/* Query rebuild information for FRAME fpage8
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage8 */
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


&Scoped-define SELF-NAME bt-atualiza-estoque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atualiza-estoque wWindow
ON CHOOSE OF bt-atualiza-estoque IN FRAME fpage0 /* Atualiza Alocaá∆o */
DO:
  FIND FIRST ITEM NO-LOCK
       WHERE ITEM.it-codigo = INPUT FRAME {&FRAME-NAME} c-item NO-ERROR.
  IF AVAIL ITEM THEN DO:
/*      IF item.tipo-con-est = 3 THEN DO:                                                */
/*         MESSAGE "N∆o Ç permitido atualizar alocaá∆o de itens controlados por estoque" */
/*             VIEW-AS ALERT-BOX ERROR BUTTONS OK.                                       */
/*         RETURN NO-APPLY.                                                              */
/*      END.                                                                             */
/*      ELSE                                                                             */
        RUN esp/ftp/esftp068a.w (INPUT c-item:SCREEN-VALUE).
     
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-selecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-selecao wWindow
ON CHOOSE OF bt-selecao IN FRAME fPage2 /* Seleá∆o */
DO:
    RUN esp/ftp/esftp068b.w (INPUT-OUTPUT c-nome-abrev-ini,
                             INPUT-OUTPUT c-nome-abrev-fim,
                             INPUT-OUTPUT c-nr-pedcli-ini,
                             INPUT-OUTPUT c-nr-pedcli-fim,
                             INPUT-OUTPUT da-dt-entrega-ini,
                             INPUT-OUTPUT da-dt-entrega-fim,
                             INPUT-OUTPUT c-atend-ini,
                             INPUT-OUTPUT c-atend-fim,
                             INPUT-OUTPUT c-estab-ini,
                             INPUT-OUTPUT c-estab-fim,
                             OUTPUT       l-cancela).

    IF  NOT l-cancela THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        RUN pi-inicializar IN h-acomp (INPUT "Processando, aguarde.").

        EMPTY TEMP-TABLE tt-ped-ent.
        RUN pi-pedido.
        {&OPEN-QUERY-br-pedido}

        RUN pi-finalizar IN h-acomp.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btAtualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualiza wWindow
ON CHOOSE OF btAtualiza IN FRAME fpage0
DO:
    FIND FIRST ITEM
         WHERE ITEM.it-codigo = c-item:SCREEN-VALUE IN FRAME fpage0 NO-LOCK NO-ERROR.

    IF AVAIL ITEM THEN DO ON STOP UNDO, LEAVE:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        RUN pi-inicializar IN h-acomp (INPUT "Processando, aguarde.").

        ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = ITEM.desc-item.
        ASSIGN INPUT FRAME fPage0 tg-solic tg-ped tg-emb tg-pend tg-saldo.

        EMPTY TEMP-TABLE tt-notas.
        EMPTY TEMP-TABLE tt-ped-ent.
        EMPTY TEMP-TABLE tt-it-pre-fat.        
        EMPTY TEMP-TABLE tt-wt-fat-ser-lote.
        EMPTY TEMP-TABLE tt-saldo-estoque.
        EMPTY TEMP-TABLE tt-notas-wms.
        EMPTY TEMP-TABLE tt-notas-wms-estab.
        EMPTY TEMP-TABLE tt-notas-transito.

        /* fPage1 - Solicitacoes (ESFTP012) */
        IF tg-solic THEN
            RUN pi-solicitacoes.
        ELSE
            ASSIGN c-total-qtde:SCREEN-VALUE  IN FRAME fpage1 = STRING(0)
                   c-total-valor:SCREEN-VALUE IN FRAME fpage1 = STRING(0).
        /* fPage2 - Pedidos (PD0505) */
        IF tg-ped THEN
            RUN pi-pedido.
        /* fPage3 - Embarques */
        IF tg-emb THEN
            RUN pi-embarques.
        /* fPage4 - Notas Pendentes Atualizacao */
        IF tg-pend THEN
            RUN pi-pendentes.
        /* fPage5 - Saldo Estoque (CE0830) */
        IF tg-saldo THEN
            RUN pi-saldo-estoque.
        ELSE
            ASSIGN dt-saldo:SCREEN-VALUE         IN FRAME fpage5 = ""
                   d-tot-disponivel:SCREEN-VALUE IN FRAME fpage5 = STRING(0)
                   d-tot-saldo-calc:SCREEN-VALUE IN FRAME fpage5 = STRING(0).

        RUN pi-notas-wms.
        RUN pi-notas-transito. 
        RUN pi-saldo-reservado.


        {&OPEN-QUERY-br-notas}
        {&OPEN-QUERY-br-pedido}
        {&OPEN-QUERY-br-pre-fat}
        {&OPEN-QUERY-br-fat-ser-lote}      
        {&OPEN-QUERY-br-saldo}
        {&OPEN-QUERY-br-notas-wms}
        {&OPEN-QUERY-br-notas-wms-estab}
        {&OPEN-QUERY-br-nf-transito}
        {&OPEN-QUERY-br-reservado}

        RUN pi-finalizar IN h-acomp.
    END.
    ELSE DO:
        MESSAGE "Item Inexistente"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        APPLY "ENTRY" TO c-item IN FRAME fPage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tg-orcamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-orcamento wWindow
ON VALUE-CHANGED OF tg-orcamento IN FRAME fPage2 /* Listar Oráamento */
DO:
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Processando, aguarde.").
    
    EMPTY TEMP-TABLE tt-ped-ent.
    RUN pi-pedido.
    {&OPEN-QUERY-br-pedido}
    
    RUN pi-finalizar IN h-acomp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-fat-ser-lote
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /** fPage2 **/
    {utp/ut-liter.i Est *}
    ASSIGN c-estabel:LABEL IN BROWSE br-pedido = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Completo *}
    ASSIGN c-completo:LABEL IN BROWSE br-pedido = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Sit_CrÇdito *}
    ASSIGN c-sit-credito:LABEL IN BROWSE br-pedido = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Sit_Entrega *}
    ASSIGN c-sit-item:LABEL IN BROWSE br-pedido = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Qtde_Aloc_Ped *}
    ASSIGN tt-ped-ent.qt-log-aloca:LABEL IN BROWSE br-pedido = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Qtde_Saldo *}
    ASSIGN de-qt-saldo:LABEL IN BROWSE br-pedido = TRIM(RETURN-VALUE).
    /**/

    /** fPage5 **/
    {utp/ut-liter.i Disp.Faturamento}
    ASSIGN tt-saldo-estoque.qt-disponivel:LABEL IN BROWSE br-saldo = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Quantidade_Data MCE}
    ASSIGN tt-saldo-estoque.saldo-calc:LABEL IN BROWSE br-saldo = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Dt_Saldo MCE}
    ASSIGN dt-saldo:LABEL IN FRAME fPage5 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Total_Qtde MCE}
    ASSIGN d-tot-saldo-calc:LABEL IN FRAME fPage5 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Total_Disp MCE}
    ASSIGN d-tot-disponivel:LABEL IN FRAME fPage5 = TRIM(RETURN-VALUE).
    /**/

    ASSIGN tt-saldo-estoque.cod-estabel:WIDTH IN BROWSE br-saldo = 3
           tt-saldo-estoque.cod-refer  :WIDTH IN BROWSE br-saldo = 5.

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
       RUN utp/ut-liter.p (TRIM({diinc/i03di149.i 03}), "*", "").
       ASSIGN c-lista-sit-item  = RETURN-VALUE.
       RUN utp/ut-liter.p (TRIM({diinc/i03di159.i 03}), "*", "").
       ASSIGN c-lista-sit-cred  = RETURN-VALUE
              da-dt-entrega-ini = TODAY - 365
              da-dt-entrega-fim = TODAY + 30.
    &else
        ASSIGN c-lista-sit-item  = {diinc/i03di149.i 03}
               c-lista-sit-cred  = {diinc/i03di159.i 03}
               da-dt-entrega-ini = TODAY - 365
               da-dt-entrega-fim = TODAY + 30.
    &endif

    ASSIGN g-dt-saldo = TODAY.

    /*---[ Empresas clientes com permiss∆o ]-----------------------------------------------------------------*/
    RUN esp/es0018p.p (INPUT  "clientes-oem":U, INPUT  1, INPUT  0, INPUT  "":U, OUTPUT TABLE tt-prog-ponto).
    
    ASSIGN c-clientes = "".
    
    FOR EACH tt-prog-ponto:
    
        FOR FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = int(tt-prog-ponto.conteudo):
    
            ASSIGN c-clientes = c-clientes + emitente.nome-abrev + ";".
    
        END. /* FOR FIRST emitente NO-LOCK */
    
    END. /* FOR EACH tt-prog-ponto: */
    
    IF  length(c-clientes) > 0 THEN
        ASSIGN c-clientes = SUBSTRING(c-clientes, 1, LENGTH(c-clientes) - 1).

    /*-----------------------------------------------------------------[ Empresas clientes com permiss∆o ]---*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-embarques wWindow 
PROCEDURE pi-embarques :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH it-pre-fat NO-LOCK
        WHERE it-pre-fat.it-codigo = ITEM.it-codigo,
        FIRST pre-fatur OF it-pre-fat NO-LOCK
        WHERE pre-fatur.cod-sit-pre = 1,
         EACH it-dep-fat NO-LOCK
        WHERE it-dep-fat.cdd-embarq   = it-pre-fat.cdd-embarq
          AND it-dep-fat.nr-resumo    = it-pre-fat.nr-resumo
          AND it-dep-fat.nome-abrev   = it-pre-fat.nome-abrev
          AND it-dep-fat.nr-pedcli    = it-pre-fat.nr-pedcli
          AND it-dep-fat.cod-estabel  = pre-fatur.cod-estabel
          AND it-dep-fat.nr-sequencia = it-pre-fat.nr-sequencia
          AND it-dep-fat.it-codigo    = it-pre-fat.it-codigo
          AND it-dep-fat.cod-refer    = it-pre-fat.cod-refer
          AND it-dep-fat.nr-entrega   = it-pre-fat.nr-entrega:

        RUN pi-acompanhar IN h-acomp (INPUT "Embarque " + STRING(it-pre-fat.cdd-embarq)).

        CREATE tt-it-pre-fat.
        ASSIGN tt-it-pre-fat.nr-embarque = it-pre-fat.cdd-embarq
               tt-it-pre-fat.nr-resumo   = it-pre-fat.nr-resumo
               tt-it-pre-fat.nr-pedcli   = it-pre-fat.nr-pedcli
               tt-it-pre-fat.nome-abrev  = it-pre-fat.nome-abrev
               tt-it-pre-fat.cod-depos   = it-dep-fat.cod-depos
               tt-it-pre-fat.cod-localiz = it-dep-fat.cod-localiz
               tt-it-pre-fat.qt-alocada  = it-pre-fat.qt-alocada.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-notas-transito wWindow 
PROCEDURE pi-notas-transito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH int-it-nota-fisc-alocado NO-LOCK
   WHERE /*int-it-nota-fisc-alocado.cod-estabel  = saldo-estoq.cod-estabel
     AND int-it-nota-fisc-alocado.cod-depos    = saldo-estoq.cod-depos 
     AND*/ int-it-nota-fisc-alocado.it-codigo    = ITEM.it-codigo 
     AND int-it-nota-fisc-alocado.serie        = "3"
     AND int-it-nota-fisc-alocado.log-recebida = NO:

    CREATE tt-notas-transito.
    ASSIGN tt-notas-transito.cod-estabel = int-it-nota-fisc-alocado.cod-estabel
           tt-notas-transito.serie       = int-it-nota-fisc-alocado.serie
           tt-notas-transito.nr-nota-fis = int-it-nota-fisc-alocado.nr-nota-fis
           tt-notas-transito.it-codigo   = int-it-nota-fisc-alocado.it-codigo
           tt-notas-transito.nr-seq-fat  = int-it-nota-fisc-alocado.nr-seq-fat .


    ASSIGN tt-notas-transito.qt-transito = tt-notas-transito.qt-transito + int-it-nota-fisc-alocado.qt-faturada[1].

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-notas-wms wWindow 
PROCEDURE pi-notas-wms :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
       

        /* Alocada e n∆o integrada com WMS */
        FOR EACH int-wms-nf-atualiz NO-LOCK
            WHERE int-wms-nf-atualiz.it-codigo   = ITEM.it-codigo:

            FIND FIRST nota-fiscal NO-LOCK
                 WHERE nota-fiscal.cod-estabel = int-wms-nf-atualiz.cod-estabel
                   AND nota-fiscal.serie       = int-wms-nf-atualiz.serie
                   AND nota-fiscal.nr-nota-fis = int-wms-nf-atualiz.nr-nota-fis NO-ERROR.
            IF AVAIL nota-fiscal THEN DO:
                IF nota-fiscal.nr-pedcli <> "" THEN
                    FIND FIRST ped-venda NO-LOCK
                         WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-ERROR.
                    IF AVAIL ped-venda THEN
                        FIND FIRST atendente NO-LOCK
                             WHERE atendente.cd-oper = INT(ped-venda.tp-pedido) NO-ERROR.
            END.

            CREATE tt-notas-wms.
            BUFFER-COPY int-wms-nf-atualiz TO tt-notas-wms.
            ASSIGN tt-notas-wms.cod-atendente  = IF AVAIL atendente THEN string(atendente.cd-oper) ELSE ""
                   tt-notas-wms.nome-atendente = IF AVAIL atendente THEN atendente.nm-oper ELSE ""  .
                   

            FIND tt-notas-wms-estab
                WHERE tt-notas-wms-estab.cod-estabel = int-wms-nf-atualiz.cod-estabel
                  AND tt-notas-wms-estab.cod-depos   = int-wms-nf-atualiz.cod-depos NO-ERROR.

            IF  NOT AVAIL tt-notas-wms-estab THEN
                CREATE tt-notas-wms-estab.
            
            ASSIGN tt-notas-wms-estab.cod-estabel = int-wms-nf-atualiz.cod-estabel
                   tt-notas-wms-estab.cod-depos   = int-wms-nf-atualiz.cod-depos
                   tt-notas-wms-estab.qtde-total  = tt-notas-wms-estab.qtde-total + int-wms-nf-atualiz.qt-baixada.

        END.





END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pedido wWindow 
PROCEDURE pi-pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN de-qt-pedida    = 0
           de-qt-sdo-ped   = 0
           de-qt-log-aloca = 0
           de-qt-alocada   = 0
           de-qt-priori-01 = 0.

    IF c-nome-abrev-ini  = ""             AND
       c-nome-abrev-fim  = "ZZZZZZZZZZZZ" AND
       c-nr-pedcli-ini   = ""             AND
       c-nr-pedcli-fim   = "ZZZZZZZZZZZZ" THEN DO:

        FOR EACH ped-ent OF ITEM
           WHERE ped-ent.dt-entrega  >= da-dt-entrega-ini AND
                 ped-ent.dt-entrega  <= da-dt-entrega-fim AND
                 ped-ent.cod-sit-ent <= 2 NO-LOCK,
           FIRST ped-venda OF ped-ent
           WHERE ped-venda.esp-ped   <> 2 
             AND ped-venda.tp-pedido   >= c-atend-ini 
             AND ped-venda.tp-pedido   <= c-atend-fim
             AND ped-venda.cod-estabel >= c-estab-ini
             AND ped-venda.cod-estabel <= c-estab-fim
             AND NOT(ped-venda.log-cotacao)   NO-LOCK,
            FIRST ped-item OF ped-ent NO-LOCK:

            IF LOOKUP(ped-venda.nome-abrev, c-clientes, ";") <> 0 THEN NEXT.

            IF INPUT FRAME fpage2 tg-orcamento = NO THEN
                IF ped-venda.cod-priori = 44 THEN
                    NEXT.

            FIND atendente
                WHERE atendente.cd-oper = INT(ped-venda.tp-pedido) NO-LOCK NO-ERROR.
            RUN pi-acompanhar IN h-acomp (INPUT "Pedido " + STRING(ped-ent.nr-pedcli)).
    
            CREATE tt-ped-ent.
            ASSIGN tt-ped-ent.nome-abrev   = ped-ent.nome-abrev  
                   tt-ped-ent.nr-pedcli    = ped-ent.nr-pedcli   
                   tt-ped-ent.cod-refer    = ped-ent.cod-refer   
                   tt-ped-ent.dt-entrega   = ped-ent.dt-entrega  
                   tt-ped-ent.qt-sdo-ped   = ped-item.qt-pedida - ped-item.qt-atendida
                   tt-ped-ent.qt-pedida    = ped-ent.qt-pedida   
                   tt-ped-ent.qt-log-aloca = ped-ent.qt-log-aloca
                   tt-ped-ent.qt-alocada   = ped-ent.qt-alocada  
                   tt-ped-ent.cod-sit-ent  = ped-ent.cod-sit-ent
                   tt-ped-ent.cod-atend    = ped-venda.tp-pedido
                   tt-ped-ent.nome-atend   = atendente.nm-ope
                   tt-ped-ent.cod-priori   = ped-venda.cod-priori.
            ASSIGN de-qt-pedida    = de-qt-pedida    + tt-ped-ent.qt-pedida
                   de-qt-sdo-ped   = de-qt-sdo-ped   + tt-ped-ent.qt-sdo-ped
                   de-qt-log-aloca = de-qt-log-aloca + tt-ped-ent.qt-log-aloca
                   de-qt-alocada   = de-qt-alocada   + tt-ped-ent.qt-alocada.
            IF ped-venda.cod-priori = 01 AND
                ped-item.cod-sit-item <= 2 THEN DO:
                ASSIGN de-qt-priori-01 = de-qt-priori-01 + ped-ent.qt-pedida - ped-ent.qt-atendida.
            END.
                
        END.
    END.
    ELSE DO:         
        FOR EACH ped-ent OF ITEM
           WHERE ped-ent.dt-entrega  >= da-dt-entrega-ini AND
                 ped-ent.dt-entrega  <= da-dt-entrega-fim AND
                 ped-ent.cod-sit-ent <= 2 NO-LOCK,
           FIRST ped-venda OF ped-ent
           WHERE ped-venda.cod-estabel >= c-estab-ini
             AND ped-venda.cod-estabel <= c-estab-fim
             AND ped-venda.nome-abrev  >= c-nome-abrev-ini 
             AND ped-venda.nome-abrev  <= c-nome-abrev-fim 
             AND ped-venda.nr-pedcli   >= c-nr-pedcli-ini  
             AND ped-venda.nr-pedcli   <= c-nr-pedcli-fim  
             AND ped-venda.tp-pedido >= c-atend-ini 
             AND ped-venda.tp-pedido <= c-atend-fim    
             AND ped-venda.esp-ped     <> 2               
             AND NOT(ped-venda.log-cotacao)                    NO-LOCK,
            FIRST ped-item OF ped-ent NO-LOCK:
            FIND atendente
                WHERE atendente.cd-oper = INT(ped-venda.tp-pedido) NO-LOCK NO-ERROR.
    
            RUN pi-acompanhar IN h-acomp (INPUT "Pedido " + STRING(ped-ent.nr-pedcli)).
    
            CREATE tt-ped-ent.
            ASSIGN tt-ped-ent.nome-abrev   = ped-ent.nome-abrev  
                   tt-ped-ent.nr-pedcli    = ped-ent.nr-pedcli   
                   tt-ped-ent.cod-refer    = ped-ent.cod-refer   
                   tt-ped-ent.dt-entrega   = ped-ent.dt-entrega  
                   tt-ped-ent.qt-pedida    = ped-ent.qt-pedida  
                   tt-ped-ent.qt-sdo-ped   = ped-item.qt-pedida - ped-item.qt-atendida
                   tt-ped-ent.qt-log-aloca = ped-ent.qt-log-aloca
                   tt-ped-ent.qt-alocada   = ped-ent.qt-alocada  
                   tt-ped-ent.cod-sit-ent  = ped-ent.cod-sit-ent
                   tt-ped-ent.cod-atend    = ped-venda.tp-pedido
                   tt-ped-ent.nome-atend   = atendente.nm-oper
                   tt-ped-ent.cod-priori   = ped-venda.cod-priori.
            ASSIGN de-qt-pedida    = de-qt-pedida    + tt-ped-ent.qt-pedida
                   de-qt-sdo-ped   = de-qt-sdo-ped   + tt-ped-ent.qt-sdo-ped
                   de-qt-log-aloca = de-qt-log-aloca + tt-ped-ent.qt-log-aloca
                   de-qt-alocada   = de-qt-alocada   + tt-ped-ent.qt-alocada.

            IF ped-venda.cod-priori = 01 AND
                ped-item.cod-sit-item <= 2 THEN
                ASSIGN de-qt-priori-01 = de-qt-priori-01 + ped-ent.qt-pedida - ped-ent.qt-atendida.
        END.
    END.

    ASSIGN de-saldo-exp = 0.
    FOR EACH saldo-estoq
        WHERE saldo-estoq.it-codigo = ITEM.it-codigo
          AND (saldo-estoq.cod-depos = "EXP" OR saldo-estoq.cod-depos = "WEX")
          AND NOT saldo-estoq.cod-localiz BEGINS "blo" NO-LOCK:
        ASSIGN de-saldo-exp = de-saldo-exp + saldo-estoq.qtidade-atu.
    END.

    ASSIGN d-qt-pedida-tot:SCREEN-VALUE IN FRAME fpage2 = string(de-qt-pedida)    
           
           d-qt-alocada:SCREEN-VALUE IN FRAME fpage2    = string(de-qt-alocada)  
           d-qt-aloc-ped:SCREEN-VALUE IN FRAME fpage2   = string(de-qt-log-aloca)
           d-qt-saldo-exp:SCREEN-VALUE IN FRAME fpage2   = STRING(de-saldo-exp - de-qt-priori-01).
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pendentes wWindow 
PROCEDURE pi-pendentes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH wt-fat-ser-lote NO-LOCK
       WHERE wt-fat-ser-lote.it-codigo = ITEM.it-codigo,
       FIRST wt-docto OF wt-fat-ser-lote NO-LOCK
       WHERE wt-docto.nr-pedcli = "":U:

        RUN pi-acompanhar IN h-acomp (INPUT "Nota " + STRING(wt-fat-ser-lote.seq-wt-docto)).

        CREATE tt-wt-fat-ser-lote.
        ASSIGN tt-wt-fat-ser-lote.cod-estabel   = wt-docto.cod-estabel     
               tt-wt-fat-ser-lote.serie         = wt-docto.serie           
               tt-wt-fat-ser-lote.seq-wt-docto  = wt-fat-ser-lote.seq-wt-docto 
               tt-wt-fat-ser-lote.cod-depos     = wt-fat-ser-lote.cod-depos    
               tt-wt-fat-ser-lote.quantidade[1] = wt-fat-ser-lote.quantidade[1].                                              
    END.
    FOR EACH fat-ser-lote NO-LOCK
            WHERE fat-ser-lote.it-codigo = ITEM.it-codigo,
            FIRST nota-fiscal OF fat-ser-lote NO-LOCK
            WHERE nota-fiscal.dt-confirma = ?
            AND nota-fiscal.dt-cancel = ?:

        CREATE tt-wt-fat-ser-lote.
        ASSIGN tt-wt-fat-ser-lote.cod-estabel   = fat-ser-lote.cod-estabel
               tt-wt-fat-ser-lote.serie         = fat-ser-lote.serie
               tt-wt-fat-ser-lote.nr-nota-fis   = fat-ser-lote.nr-nota-fis
               tt-wt-fat-ser-lote.cod-depos     = fat-ser-lote.cod-depos    
               tt-wt-fat-ser-lote.quantidade[1] = fat-ser-lote.qt-baixada[1].   
    END.

    FIND CURRENT tt-wt-fat-ser-lote NO-LOCK NO-ERROR.
    RELEASE tt-wt-fat-ser-lote.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-saldo-estoque wWindow 
PROCEDURE pi-saldo-estoque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE l-central-config AS LOGICAL     NO-UNDO.

    IF NOT VALID-HANDLE(hDBOWm-saldo-estoque) THEN DO:
       run scbo/bosc058.p persistent set hDBOWm-saldo-estoque.
    END. 

    ASSIGN qtd-bloqueada = 0.
    RUN getSaldoPicking IN hDBOWm-saldo-estoque (INPUT ITEM.it-codigo,
                                                 INPUT 0,
                                                 INPUT 0,
                                                 OUTPUT TABLE ttWm-saldo).
     FOR EACH ttWm-saldo NO-LOCK:
         ASSIGN qtd-bloqueada = qtd-bloqueada + ttWm-saldo.qtd-bloq-pick.
     END.

    ASSIGN d-saldo-calculado-disp = 0
           d-disponivel-disp      = 0
           d-qt-aloc-ped-disp     = 0.

    FOR EACH saldo-estoq OF ITEM NO-LOCK:

        ASSIGN d-saldo-calculado = fn-qtd-data().       
        IF d-saldo-calculado = 0 AND NOT g-saldo-zerado THEN NEXT.

        
        ASSIGN l-central-config = CAN-FIND(FIRST item-uni-estab USE-INDEX codigo
                                           WHERE item-uni-estab.it-codigo   = saldo-estoq.it-codigo
                                           AND   item-uni-estab.cod-estabel = saldo-estoq.cod-estabel
                                           AND   item-uni-estab.nr-linha    = 20).

        RUN pi-acompanhar IN h-acomp (INPUT "Saldo " + STRING(saldo-estoq.it-codigo)).

        CREATE  tt-saldo-estoque.
        ASSIGN  tt-saldo-estoque.it-codigo     = saldo-estoq.it-codigo
                tt-saldo-estoque.cod-estabel   = saldo-estoq.cod-estabel
                tt-saldo-estoque.cod-depos     = saldo-estoq.cod-depos
                tt-saldo-estoque.cod-refer     = saldo-estoq.cod-refer
                tt-saldo-estoque.cod-localiz   = saldo-estoq.cod-localiz
                tt-saldo-estoque.lote          = saldo-estoq.lote
                tt-saldo-estoque.dt-vali-lote  = saldo-estoq.dt-vali-lote
                tt-saldo-estoque.saldo-calc    = d-saldo-calculado
                tt-saldo-estoque.qtidade-atu   = saldo-estoq.qtidade-atu
                tt-saldo-estoque.qt-disponivel = fnEstoque(saldo-estoq.cod-estabel, saldo-estoq.it-codigo, saldo-estoq.cod-depos, saldo-estoq.cod-localiz, saldo-estoq.lote, l-central-config)
                tt-saldo-estoque.qt-alocada    = saldo-estoq.qt-alocada
                tt-saldo-estoque.qt-aloc-prod  = saldo-estoq.qt-aloc-prod
                tt-saldo-estoque.qt-aloc-ped   = saldo-estoq.qt-aloc-ped
                tt-saldo-estoque.qt-bloqueada  = qtd-bloqueada.

        /* Alocada e n∆o integrada com WMS */
        FOR EACH int-wms-nf-atualiz NO-LOCK
            WHERE int-wms-nf-atualiz.it-codigo   = tt-saldo-estoque.it-codigo  
              AND int-wms-nf-atualiz.cod-depos   = tt-saldo-estoque.cod-depos
              and int-wms-nf-atualiz.cod-estabel = tt-saldo-estoque.cod-estabel:
              ASSIGN tt-saldo-estoque.qt-aloc-nao-integrada = tt-saldo-estoque.qt-aloc-nao-integrada + int-wms-nf-atualiz.qt-baixada.
        END.

        ASSIGN d-saldo-calculado-disp = d-saldo-calculado-disp + tt-saldo-estoque.saldo-calc
               d-disponivel-disp      = d-disponivel-disp      + tt-saldo-estoque.qt-disponivel
               d-qt-aloc-ped-disp     = d-qt-aloc-ped-disp     + tt-saldo-estoque.qt-aloc-ped.

        RUN esp/wmp/eswmpapi003.p (INPUT  tt-saldo-estoque.cod-estabel,
                                   INPUT  tt-saldo-estoque.cod-depos,
                                   INPUT  tt-saldo-estoque.it-codigo,
                                   INPUT  "",
                                   OUTPUT tt-saldo-estoque.qt-atual-wms,
                                   OUTPUT tt-saldo-estoque.qt-disp-wms,
                                   OUTPUT tt-saldo-estoque.qt-bloq-wms,
                                   OUTPUT TABLE tt-erro).

        /* Qtde Reservada ESPDP080 */ 
        
        FOR EACH reservas-ast
            WHERE reservas-ast.cod-depos    = saldo-estoq.cod-depos
              AND reservas-ast.it-codigo    = saldo-estoq.it-codigo 
              AND reservas-ast.cod-estabel  = saldo-estoq.cod-estabel 
              AND reservas-ast.dt-reserva  <= TODAY NO-LOCK:

            IF  reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY THEN DO:
                ASSIGN tt-saldo-estoque.qt-reservada = tt-saldo-estoque.qt-reservada + reservas-ast.qt-reserva.
            END.
        END.

        //buscar nota do transito do entreposto
        FIND FIRST int-estabel-ressuprimento NO-LOCK
             WHERE int-estabel-ressuprimento.cod-estabel = saldo-estoq.cod-estabel NO-ERROR.
        IF NOT AVAIL int-estabel-ressuprimento THEN NEXT.

        for first int-estabel-origem-ressup  NO-LOCK
            where int-estabel-origem-ressup.cod-estabel-origem = saldo-estoq.cod-estabel 
              AND int-estabel-origem-ressup.cod-depos-ressup   = saldo-estoq.cod-depos:

            FOR EACH int-it-nota-fisc-alocado NO-LOCK
               WHERE int-it-nota-fisc-alocado.cod-estabel  = saldo-estoq.cod-estabel
                 AND int-it-nota-fisc-alocado.cod-depos    = saldo-estoq.cod-depos
                 AND int-it-nota-fisc-alocado.it-codigo    = saldo-estoq.it-codigo 
                 AND int-it-nota-fisc-alocado.serie        = "3"
                 AND int-it-nota-fisc-alocado.log-recebida = NO:

                ASSIGN tt-saldo-estoque.qt-transito = tt-saldo-estoque.qt-transito + int-it-nota-fisc-alocado.qt-faturada[1].

            END.
        end.

        

    END.

    ASSIGN d-tot-disponivel = d-disponivel-disp
           d-tot-saldo-calc = d-saldo-calculado-disp
           de-qt-aloc-ped    = d-qt-aloc-ped-disp.
           

    DISP dt-saldo
         d-tot-disponivel 
         d-tot-saldo-calc 
         de-qt-aloc-ped WITH FRAME fPage5. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-saldo-reservado wWindow 
PROCEDURE pi-saldo-reservado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-reserva-user.

FOR EACH reservas-ast NO-LOCK
    WHERE reservas-ast.it-codigo  = ITEM.it-codigo
      AND reservas-ast.dt-reserva <= TODAY:

    IF reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY THEN DO:
       CREATE tt-reserva-user.
       ASSIGN tt-reserva-user.it-codigo   = reservas-ast.it-codigo
              tt-reserva-user.cod-estabel = reservas-ast.cod-estabel
              tt-reserva-user.cod-depos   = reservas-ast.cod-depos
              tt-reserva-user.usuario     = reservas-ast.cd-usuario 
              tt-reserva-user.qt-reserva  = reservas-ast.qt-reserva
              tt-reserva-user.obs         = reservas-ast.obs.

       FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = reservas-ast.cd-usuario NO-LOCK NO-ERROR.

       IF AVAIL usuar_mestre THEN
          ASSIGN tt-reserva-user.nome = UPPER(usuar_mestre.nom_usuario).
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-solicitacoes wWindow 
PROCEDURE pi-solicitacoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-cont     AS INTEGER NO-UNDO.
    DEF VAR i-hora-ini AS INTEGER NO-UNDO.
    
    ASSIGN c-total-qtde:SCREEN-VALUE  IN FRAME fpage1 = STRING(0)
           c-total-valor:SCREEN-VALUE IN FRAME fpage1 = STRING(0).

    IF c-item:SCREEN-VALUE IN FRAME fpage0 <> ""  THEN DO:
        
        FOR EACH mgesp.it-ped-fiscal NO-LOCK
           WHERE mgesp.it-ped-fiscal.it-codigo = c-item:SCREEN-VALUE IN FRAME fpage0:
            
            RUN pi-acompanhar IN h-acomp (INPUT "Solicitaá∆o " + STRING(it-ped-fiscal.nr-pedido)).

            FIND FIRST mgesp.ped-fiscal
                 WHERE ped-fiscal.nr-pedido = it-ped-fiscal.nr-pedido NO-LOCK NO-ERROR.

            FIND FIRST emitente
                 WHERE emitente.cod-emitente = ped-fiscal.cod-emitente NO-LOCK NO-ERROR.


            IF ped-fiscal.situacao > 4  THEN NEXT.

            CREATE tt-notas.
            ASSIGN tt-notas.nr-pedido       = ped-fiscal.nr-pedido  
                   tt-notas.cod-estabel     = ped-fiscal.cod-estabel
                   tt-notas.cod-emitente    = ped-fiscal.cod-emitente  
                   tt-notas.dt-emissao      = ped-fiscal.dt-emissao    
                   tt-notas.nome-emit       = emitente.nome-emit     
                   tt-notas.usuario-magnus  = ped-fiscal.usuario-magnus
                   tt-notas.it-codigo       = it-ped-fiscal.it-codigo     
                   tt-notas.qtde            = it-ped-fiscal.qtde          
                   tt-notas.vl-unit         = it-ped-fiscal.vl-unit       
                   tt-notas.cod-depos       = it-ped-fiscal.cod-depos.

            FIND FIRST usuar_mestre
                 WHERE usuar_mestre.cod_usuario = ped-fiscal.usuario-magnus NO-LOCK NO-ERROR.

            IF AVAIL usuar_mestre THEN
                ASSIGN tt-notas.nome = usuar_mestre.cod_usuario.

            IF ped-fiscal.situacao = 0 THEN
                ASSIGN tt-notas.situacao        = "Digitado".
            ELSE
            IF ped-fiscal.situacao = 1 THEN
                ASSIGN tt-notas.situacao        = "A liberar".
            ELSE
            IF ped-fiscal.situacao = 2 THEN
                ASSIGN tt-notas.situacao        = "A Relacionar".
            ELSE
            IF ped-fiscal.situacao = 3 THEN
                ASSIGN tt-notas.situacao        = "A Faturar".
            ELSE
            IF ped-fiscal.situacao = 4 THEN
               ASSIGN tt-notas.situacao         = "Atendido Parcialmente".
            ELSE
            IF ped-fiscal.situacao = 5 THEN
               ASSIGN tt-notas.situacao         = "Atendido".
            ELSE
            IF ped-fiscal.situacao = 6 THEN
               ASSIGN tt-notas.situacao         = "Bloqueado".

            ASSIGN c-total-qtde:SCREEN-VALUE  IN FRAME fpage1 = STRING(DEC(c-total-qtde:SCREEN-VALUE  IN FRAME fpage1) + it-ped-fiscal.qtde)
                   c-total-valor:SCREEN-VALUE IN FRAME fpage1 = STRING(DEC(c-total-valor:SCREEN-VALUE IN FRAME fpage1) + it-ped-fiscal.vl-unit * it-ped-fiscal.qtde).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-completo wWindow 
FUNCTION fn-completo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    IF AVAIL ped-venda AND ped-venda.completo THEN
        RETURN "Sim".
    ELSE
        RETURN "N∆o".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-estabelecimento wWindow 
FUNCTION fn-estabelecimento RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND FIRST ped-venda USE-INDEX ch-pedido WHERE
             ped-venda.nome-abrev = tt-ped-ent.nome-abrev AND
             ped-venda.nr-pedcli  = tt-ped-ent.nr-pedcli  NO-LOCK NO-ERROR.
  
  IF  AVAIL ped-venda THEN
      RETURN ped-venda.cod-estabel.
  ELSE
      RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-qt-saldo wWindow 
FUNCTION fn-qt-saldo RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN tt-ped-ent.qt-sdo-ped - tt-ped-ent.qt-alocada - tt-ped-ent.qt-log-aloc.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-qtd-data wWindow 
FUNCTION fn-qtd-data RETURNS DECIMAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

assign d-tot-disponivel = 0
       d-tot-saldo-calc = 0
       dt-saldo = g-dt-saldo.
assign d-tot-disponivel  = d-tot-disponivel + (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada -
                                               saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped)
       d-saldo-calculado = saldo-estoq.qtidade-atu.

IF  item.tipo-con-est = 1
    OR  g-dt-saldo = TODAY /* se for a data que vem padr∆o (today) nao ira lcoalizar nenhum movimento
                              neste caso o melhor indice e' por data mesmo que o controle seja por lote */
    THEN
        open query qr-movto
        for each movto-estoq use-index item-data where
                             movto-estoq.it-codigo   = saldo-estoq.it-codigo    and
                             movto-estoq.cod-refer   = saldo-estoq.cod-refer    and
                             movto-estoq.cod-estabel = saldo-estoq.cod-estabel  and
                             movto-estoq.cod-depos   = saldo-estoq.cod-depos    and
                             movto-estoq.lote        = saldo-estoq.lote         and
                             movto-estoq.cod-localiz = saldo-estoq.cod-localiz  and
                             movto-estoq.esp-docto  <> 37                         and
                             movto-estoq.dt-trans    > g-dt-saldo no-lock.
    ELSE
        open query qr-movto
        for each movto-estoq use-index item-estab where
                             movto-estoq.it-codigo   = saldo-estoq.it-codigo    and
                             movto-estoq.cod-refer   = saldo-estoq.cod-refer    and
                             movto-estoq.cod-estabel = saldo-estoq.cod-estabel  and
                             movto-estoq.cod-depos   = saldo-estoq.cod-depos    and
                             movto-estoq.lote        = saldo-estoq.lote         and
                             movto-estoq.cod-localiz = saldo-estoq.cod-localiz  and
                             movto-estoq.esp-docto  <> 37                         and
                             movto-estoq.dt-trans    > g-dt-saldo no-lock.


get first qr-movto.
do while avail (movto-estoq):
    if movto-estoq.tipo-trans = 1 then
        assign d-saldo-calculado = d-saldo-calculado - movto-estoq.quantidade.
    else
        assign d-saldo-calculado = d-saldo-calculado + movto-estoq.quantidade.
    get next qr-movto.
end. /* while */ 

/*bloco comentado por efeito documentacional - sem funá∆o no programa*/
/* assign d-tot-saldo-calc = d-tot-saldo-calc + d-saldo-calculado.              */
/* find first tt-saldo where                                                    */
/*      tt-saldo.it-codigo   = b-saldo-estoq.it-codigo   and                    */
/*      tt-saldo.cod-depos   = b-saldo-estoq.cod-depos   and                    */
/*      tt-saldo.cod-estabel = b-saldo-estoq.cod-estabel and                    */
/*      tt-saldo.cod-localiz = b-saldo-estoq.cod-localiz and                    */
/*      tt-saldo.cod-refer   = b-saldo-estoq.cod-refer   and                    */
/*      tt-saldo.lote        = b-saldo-estoq.lote no-error.                     */
/* if not avail tt-saldo then do:                                               */
/*     create tt-saldo.                                                         */
/*     assign tt-saldo.it-codigo   = b-saldo-estoq.it-codigo                    */
/*            tt-saldo.cod-depos   = b-saldo-estoq.cod-depos                    */
/*            tt-saldo.cod-estabel = b-saldo-estoq.cod-estabel                  */
/*            tt-saldo.cod-localiz = b-saldo-estoq.cod-localiz                  */
/*            tt-saldo.cod-refer   = b-saldo-estoq.cod-refer                    */
/*            tt-saldo.lote        = b-saldo-estoq.lote                         */
/*            tt-saldo.qtidade-data = tt-saldo.qtidade-data + d-saldo-calculado */
/*            tt-saldo.qtidade-disp = tt-saldo.qtidade-disp + d-tot-disponivel. */
/*                                                                              */
/* end.                                                                         */


  RETURN d-saldo-calculado.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-sit-aval wWindow 
FUNCTION fn-sit-aval RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    IF  AVAIL ped-venda THEN 
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DO:
            RUN utp/ut-liter.p (trim({diinc/i03di159.i 04 ped-venda.cod-sit-aval}), "*", "").
            RETURN RETURN-VALUE.
        END.
        &else
        RETURN {diinc/i03di159.i 04 ped-venda.cod-sit-aval}.
        &endif
    ELSE
        RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEstoque wWindow 
FUNCTION fnEstoque RETURNS DECIMAL
  ( INPUT p-cod-estabel   AS CHAR,
    INPUT p-it-codigo     AS CHAR,
    INPUT p-cod-depos     AS CHAR,
    INPUT p-cod-localiz   AS CHAR,
    INPUT p-lote          AS CHAR,
    INPUT p-saldo-central AS LOG):

    
    
/*------------------------------------------------------------------------------
  Purpose:  Retornar o saldo dispo°vel para alocaá∆o do item
------------------------------------------------------------------------------*/
    DEFINE VARIABLE qtd            AS DECIMAL    NO-UNDO INIT 0.
    DEFINE VARIABLE qtd-alocada    AS DECIMAL    NO-UNDO INIT 0.
    DEFINE VARIABLE c-localizacao  AS CHARACTER  NO-UNDO. 
    DEFINE VARIABLE p-qtd-total    LIKE wm-saldo-estoque.qtd-atual            NO-UNDO.
    DEFINE VARIABLE p-qtd-disp     LIKE wm-saldo-estoque.qtd-atual            NO-UNDO.
    DEFINE VARIABLE p-qtd-bloq     LIKE wm-saldo-estoque.qtd-atual            NO-UNDO.
    DEFINE VARIABLE qtd-atualizada LIKE int-wms-nf-atualiz.qt-baixada NO-UNDO.

    DEFINE BUFFER bf-saldo-estoq-fnEstoque FOR saldo-estoq.
    
    ASSIGN c-localizacao = "".
    
    /*Localizaá‰es que devem ser desconsideradas*/
    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "espdp006":U
          AND ponto-programa.ponto         = 2,
        EACH  conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa
          AND ENTRY(1,conteudo-programa.conteudo) = p-cod-depos:
        IF  c-localizacao = "" THEN
            ASSIGN c-localizacao = ENTRY(2,conteudo-programa.conteudo).
        ELSE
            ASSIGN c-localizacao = c-localizacao + "," + ENTRY(2,conteudo-programa.conteudo).
    END.
    
    FIND FIRST item-uni-estab USE-INDEX codigo NO-LOCK 
         WHERE item-uni-estab.it-codigo   = p-it-codigo
           AND item-uni-estab.cod-estabel = p-cod-estabel
           AND item-uni-estab.nr-linha    = 20 NO-ERROR.
    
    IF  AVAIL item-uni-estab
    AND NOT p-saldo-central THEN DO:
        RUN esapi/esapi011.p (INPUT  p-cod-estabel,
                              INPUT  p-it-codigo,
                              INPUT  p-cod-depos,
                              INPUT  p-cod-localiz,
                              OUTPUT qtd).
    END.
    ELSE DO:
        
        FOR EACH bf-saldo-estoq-fnEstoque NO-LOCK
            WHERE bf-saldo-estoq-fnEstoque.cod-depos   = p-cod-depos
              AND bf-saldo-estoq-fnEstoque.it-codigo   = p-it-codigo
              AND bf-saldo-estoq-fnEstoque.cod-estabel = p-cod-estabel
              AND bf-saldo-estoq-fnEstoque.cod-localiz = p-cod-localiz
              AND bf-saldo-estoq-fnEstoque.lote        = p-lote:

            /* Desconsidera as localizaá‰es cadastradas no ES0018 */
            IF  (bf-saldo-estoq-fnEstoque.cod-localiz <> "" OR c-localizacao <> "") 
            AND (LOOKUP(bf-saldo-estoq-fnEstoque.cod-localiz, c-localizacao) > 0) THEN
                NEXT.

            IF  p-cod-localiz <> "*"
            AND bf-saldo-estoq-fnEstoque.cod-localiz <> p-cod-localiz THEN
                NEXT.
            
            FIND FIRST int-saldo-estoq NO-LOCK
                {dbini\es322.i1 int-saldo-estoq bf-saldo-estoq-fnEstoque} NO-ERROR.

            IF  AVAIL int-saldo-estoq 
            AND int-saldo-estoq.log-bloqueado THEN NEXT.

            ASSIGN qtd         = qtd + bf-saldo-estoq-fnEstoque.qtidade-atu - bf-saldo-estoq-fnEstoque.qt-alocada - bf-saldo-estoq-fnEstoque.qt-aloc-prod - bf-saldo-estoq-fnEstoque.qt-aloc-ped
                   qtd-alocada = qtd-alocada + bf-saldo-estoq-fnEstoque.qt-alocada + bf-saldo-estoq-fnEstoque.qt-aloc-ped.

            //buscar nota do transito do entreposto
            FIND FIRST int-estabel-ressuprimento NO-LOCK
                 WHERE int-estabel-ressuprimento.cod-estabel = bf-saldo-estoq-fnEstoque.cod-estabel NO-ERROR.
            IF AVAIL int-estabel-ressuprimento THEN DO:
                for first int-estabel-origem-ressup  NO-LOCK
                    where int-estabel-origem-ressup.cod-estabel-origem = bf-saldo-estoq-fnEstoque.cod-estabel 
                      AND int-estabel-origem-ressup.cod-depos-ressup   = bf-saldo-estoq-fnEstoque.cod-depos:
              
                    FOR EACH int-it-nota-fisc-alocado NO-LOCK
                       WHERE int-it-nota-fisc-alocado.cod-estabel  = bf-saldo-estoq-fnEstoque.cod-estabel
                         AND int-it-nota-fisc-alocado.cod-depos    = bf-saldo-estoq-fnEstoque.cod-depos
                         AND int-it-nota-fisc-alocado.it-codigo    = bf-saldo-estoq-fnEstoque.it-codigo 
                         AND int-it-nota-fisc-alocado.serie        = "3"
                         AND int-it-nota-fisc-alocado.log-recebida = NO:
              
                        ASSIGN qtd = qtd - int-it-nota-fisc-alocado.qt-faturada[1].
              
                    END.
                end.
            END.

            /* Qtde Reservada ESPDP080 */ 
            /*
            FOR EACH reservas-ast
                WHERE reservas-ast.cod-depos    = bf-saldo-estoq-fnEstoque.cod-depos
                AND   reservas-ast.it-codigo    = bf-saldo-estoq-fnEstoque.it-codigo 
                AND   reservas-ast.cod-estabel  = bf-saldo-estoq-fnEstoque.cod-estabel
                AND   reservas-ast.dt-reserva  <= TODAY NO-LOCK:

                IF  reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY THEN DO:
                    ASSIGN qtd = qtd - reservas-ast.qt-reserva.
                END.
            END.*/

        END.

        /* Validacao MFT x WMS  */
        FIND FIRST deposito 
             WHERE deposito.cod-depos    = p-cod-depos
               AND deposito.log-gera-wms = YES NO-LOCK NO-ERROR.


        IF  AVAIL deposito
        AND NOT AVAIL item-uni-estab THEN DO: /*Central configurada nunca tem saldo no wms, ent∆o considera sempre o saldo cont†bil*/
            EMPTY TEMP-TABLE tt-erro.

            RUN esp/wmp/eswmpapi003.p (INPUT  p-cod-estabel,
                                       INPUT  p-cod-depos,
                                       INPUT  p-it-codigo,
                                       INPUT  "",
                                       OUTPUT p-qtd-total,
                                       OUTPUT p-qtd-disp,
                                       OUTPUT p-qtd-bloq,
                                       OUTPUT TABLE tt-erro).

            FOR EACH tt-erro WHERE tt-erro.cd-erro = 56:
                DELETE tt-erro.
            END. /* FOR EACH tt-erro */

            /* Verifica quantidade atualizada no estoque e que ainda estah pendente de integracao com o WMS */
            ASSIGN qtd-atualizada = 0.
            FOR EACH int-wms-nf-atualiz NO-LOCK
               WHERE int-wms-nf-atualiz.cod-depos   = p-cod-depos
                 AND int-wms-nf-atualiz.it-codigo   = p-it-codigo
                 AND int-wms-nf-atualiz.cod-estabel = p-cod-estabel:

                ASSIGN qtd-atualizada = qtd-atualizada + int-wms-nf-atualiz.qt-baixada.
            END.

            /*Considera o menor entre dispon°vel estoque ou dispon°vel WMS*/
            ASSIGN qtd = IF p-qtd-disp - qtd-alocada - qtd-atualizada < qtd THEN p-qtd-disp - qtd-alocada - qtd-atualizada ELSE qtd.
        END. /* IF AVAIL deposito THEN DO: */
    END.

    IF qtd < 0 THEN
        ASSIGN qtd = 0.

    RETURN qtd.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

