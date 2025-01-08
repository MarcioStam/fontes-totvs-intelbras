&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ped-venda-aux NO-UNDO LIKE ped-venda
       FIELD r-Rowid AS ROWID
       field r-ped-venda as rowid.
DEFINE TEMP-TABLE ttped-item NO-UNDO LIKE ped-item
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttped-venda NO-UNDO LIKE ped-venda
       field r-rowid as rowid
       field r-ped-venda as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**\
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESPDP006 2.06.00.003}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          ESPDP006
&GLOBAL-DEFINE Version          2.06.00.003

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Itens Pedido

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           NO

&GLOBAL-DEFINE AddParent        NO
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     NO
&GLOBAL-DEFINE DeleteParent     NO

&GLOBAL-DEFINE AddSon1          NO
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       NO
&GLOBAL-DEFINE DeleteSon1       NO
&GLOBAL-DEFINE DetailSon1       NO

&GLOBAL-DEFINE ttParent         ttped-venda
&GLOBAL-DEFINE hDBOParent       hped-venda
&GLOBAL-DEFINE DBOParentTable   ped-venda
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           ttped-item
&GLOBAL-DEFINE hDBOSon1         hped-item
&GLOBAL-DEFINE DBOSon1Table     ped-item
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE FNC_MULTI_IDIOMA NO

&GLOBAL-DEFINE page0Fields      ttped-venda.nome-abrev ~
                                ttped-venda.nr-pedcli ~
                                ttped-venda.dt-emissao ~
                                ttped-venda.dt-entrega ~
                                ttped-venda.cod-cond-pag ~
                                cidade-cif ~
                                cod-transp ~
                                ttped-venda.nome-transp ~
                                ttped-venda.cod-emitente ~
                                ttped-venda.cod-gr-cli ~
                                ttped-venda.vl-liq-abe ~
                                ttped-venda.nat-operacao ~
                                ttped-venda.cidade ~
                                ttped-venda.estado ~
                                ttped-venda.observacoes ~
                                ttped-venda.cond-espec ~
                                ttped-venda.cod-cond-pag ~
                                ttped-venda.ind-fat-par ~
                                ttped-venda.no-ab-reppri ~
                                ttped-venda.desc-bloq-cr ~
                                c-cod-estabel ~
                                ttped-venda.cod-priori ~
                                ttped-venda.tp-pedido ~
                                de-vl-total-alocado ~
                                de-vl-ipi-alocado ~
                                de-vl-st-alocado ~
                                de-LimIntelbras      ~
                                de-LimIntelbrasClube ~
                                c-situacao ~
                                c-desc-grupo ~
                                vCod-depos ~
                                c-marketplace ~
                                c-natureza ~
                                

&GLOBAL-DEFINE page1Browse      brSon1 

&GLOBAL-DEFINE NumRowsReturned  1000
&GLOBAL-DEFINE off-end1         YES
&GLOBAL-DEFINE off-home1        YES

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{esp/pdp/espdp006.i}

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent}   AS HANDLE       NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}     AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-bo-emitente   AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-alocacao      AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-pd4000        AS HANDLE       NO-UNDO.                             
DEFINE VARIABLE h-esapi018      AS HANDLE       NO-UNDO.
DEFINE VARIABLE iqtd            AS INTEGER      NO-UNDO.
DEFINE VARIABLE l-fecha-prog    AS LOGICAL      NO-UNDO.
DEFINE VARIABLE c-erros         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE dt-aux          AS DATE         NO-UNDO.
/********** Variaveis para <> produtos c/ mesma funcionalidade   **********/
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_estab_usuar         AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren        AS CHARACTER format "x(12)" label "Usu†rio Corrente"     column-label "Usu†rio Corrente"    no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_pais_empres_usuar   AS CHARACTER format "x(3)"  label "Pa°s Empresa Usu†rio" column-label "Pa°s"                no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar        AS CHARACTER format "x(3)" label "Empresa" column-label "Empresa" no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE i-ep-codigo-usuario       LIKE mgcad.empresa.ep-codigo no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE v_cdn_empres_usuar        LIKE mgcad.empresa.ep-codigo no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_ped_exec            AS RECID     format ">>>>>>9"    no-undo. 
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_modul_dtsul_corren  AS CHAR      format "x(3)"       label "M¢dulo Corrente" column-label "M¢dulo Corrente" no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_aplicat_dtsul_corren AS CHAR      format "x(3)"       no-undo. 
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_modul_dtsul_empres  AS CHAR      format "x(100)"     no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_unid_negoc_usuar    AS CHAR      format "x(3)"       view-as COMBO-BOX 
     list-items "" inner-lines 5 bgcolor 15 font 2 label "Unidade Neg¢cio" column-label "Unid Neg¢cio" no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_funcao_negoc_empres AS CHAR      format "x(50)"      no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_ccusto_corren       AS CHAR      format "x(11)"      label "Centro Custo"    column-label "Centro Custo" no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE l-autconlist              AS LOG                           no-undo.    

DEFINE VARIABLE p_cod_prog_dtsul_w                          AS Character format "x(50)"      no-undo.
DEFINE VARIABLE p_cod_prog_dtsul_rp                         AS Character format "x(50)"      no-undo.
DEFINE VARIABLE p_cod_release                               AS Character format "x(9)"       no-undo.
DEFINE VARIABLE p_cdn_estil_dwb                             AS Integer   format ">>9"        no-undo.
DEFINE VARIABLE p_arquivo                                   AS Character format "x(50)"      no-undo.
DEFINE VARIABLE p_destino                                   AS integer   format "9"          no-undo.
DEFINE VARIABLE p_raw_param                                 AS Raw                           no-undo.
DEFINE VARIABLE p_num_ped_exec                              AS integer   format ">>>>9"      no-undo.
DEFINE VARIABLE v-log-agenda-auto-ok                        AS logical   initial yes         no-undo.
DEFINE VARIABLE v_num_aux                                   AS INTEGER   format ">>>>,>>9"   no-undo.
DEFINE VARIABLE v_dat_exec_ped_exec_old                     AS DATE      format "99/99/9999" label "Data Execuá∆o"   column-label "Data Exec" no-undo.
DEFINE VARIABLE v_hra_exec_ped_exec_old                     AS CHARACTER format "99:99:99"   label "Hora Execuá∆o"   column-label "Hora Exec" no-undo.
DEFINE VARIABLE v_log_answer                                AS logical                       no-undo. /*local*/
DEFINE VARIABLE v_cod_msg_parameters                        AS CHARACTER format "x(2000)"    NO-UNDO.
DEFINE VARIABLE v_cod_prog_dtsul                            AS CHARACTER format "x(50)"      label "Programa"        column-label "Programa" no-undo.
DEFINE VARIABLE v_num_msg_erro                              AS INTEGER   format ">>>>>>9"    label "Mensagem"        column-label "Mensagem" no-undo.
DEFINE VARIABLE v_cdn_empresa_aux                           LIKE mgcad.empresa.ep-codigo    no-undo.
DEFINE VARIABLE c-prmgems                                   AS Char                          no-undo.   
DEFINE VARIABLE wh-tx-depos                                 AS WIDGET-HANDLE                 NO-UNDO.
DEFINE VARIABLE h-esftp083                                  AS HANDLE                        NO-UNDO.
DEFINE VARIABLE c-mensagem                                  AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE wh-pesquisa                                 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bodi159cal                                AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE l-dt-entrega-pedido AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-dt-entrega-itens  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE vQtAlocar-aux   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE vQtAlocar-param AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-atendente     AS CHARACTER   NO-UNDO.

define temp-table tt-param-aval no-undo
    field nr-pedido     like ped-venda.nr-pedido
    field param-aval    as integer
    field cod-sit-aval  as integer
    field embarque      as logical
    field efetiva       as logical
    field retorna       as logical
    field reavalia-forc as logical
    field vl-a-avaliar  as decimal
    field saldo-lim     as decimal
    field usuario       as character
    field programa      as character
    index codigo is unique primary nr-pedido.

DEFINE TEMP-TABLE tt-itens-calculo
    FIELD it-codigo  LIKE ITEM.it-codigo
    FIELD quantidade AS DEC.

DEFINE TEMP-TABLE tt-volumes
    FIELD it-codigo    LIKE volume-nf.it-codigo
    FIELD nr-volume    LIKE volume-nf.nr-volume
    FIELD qtde         LIKE volume-nf.qtde     
    FIELD sigla-emb    LIKE volume-nf.sigla-emb   
    FIELD varios-itens LIKE volume-nf.varios-itens
    FIELD peso         AS DEC
    INDEX nr-volume    nr-volume.

define temp-table tt-param no-undo
    field destino       as integer
    field arquivo       as char format "x(35)"
    field usuario       as char format "x(12)"
    field data-exec     as date
    field hora-exec     as integer
    field nome-abrev    LIKE ped-venda.nome-abrev
    field nr-pedcli     LIKE ped-venda.nr-pedcli    
    field Cod-depos     LIKE deposito.cod-depos
    field Localizacao   LIKE saldo-estoq.cod-localiz 
    .

define temp-table tt-digita NO-UNDO
    field nome-abrev     LIKE ped-venda.nome-abrev
    field nr-pedcli      LIKE ped-venda.nr-pedcli 
    field c-it-codigo    LIKE ped-item.it-codigo
    field c-cod-refer    LIKE ped-item.cod-refer
    field i-nr-sequencia LIKE ped-item.nr-sequencia
    .

DEFINE TEMP-TABLE tt-estab-depos NO-UNDO                                  
    FIELD cod-estabel LIKE estabelec.cod-estabel
    FIELD cod-depos   LIKE deposito.cod-depos.

/********************** RPW RPW RPW **********************/
define buffer b-tt-digita for tt-digita.
define temp-table tt-raw-digita
    field raw-digita    as raw.

DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.

define temp-table tt-erros-aval no-undo
    field cod-emitente as integer
    field cd-erro      as integer
    index codigo is unique primary cod-emitente cd-erro.

def new global shared var v_rec_servid_exec as recid format ">>>>>>9" initial ? no-undo.

def new global shared temp-table tt-ped-item-shared
    field nome-abrev    LIKE ped-item.nome-abrev   
    field nr-pedcli     LIKE ped-item.nr-pedcli    
    field nr-sequencia  LIKE ped-item.nr-sequencia 
    field it-codigo     LIKE ped-item.it-codigo    
    field cod-refer     LIKE ped-item.cod-refer    
    INDEX idx_peditem
    nome-abrev  
    nr-pedcli   
    nr-sequencia
    it-codigo   
    cod-refer   .

DEFINE TEMP-TABLE tt-tb-preco NO-UNDO
    FIELD nr-tabpre        LIKE tb-preco.nr-tabpre
    FIELD ds-descricao     AS CHARACTER FORMAT "x(30)":U
    FIELD cod-rep          LIKE crm-relacionamento-cliente.cod-rep
    FIELD cd-categoria     LIKE crm-relacionamento-cliente.cd-categoria
    FIELD ds-categoria     LIKE crm-categoria.ds-categoria
    FIELD cd-unid-negoc    AS CHARACTER
    FIELD cod-cond-pag     LIKE cond-pagto.cod-cond-pag
    FIELD cod-gr-cli       LIKE emitente.cod-gr-cli
    FIELD ds-gr-cli        LIKE gr-cli.descricao
    FIELD lg-tb-especifica AS INTEGER.

DEFINE TEMP-TABLE tt-zera-aloc NO-UNDO
    FIELD r-ped-item AS ROWID.
    

DEFINE BUFFER bsaldo-estoq FOR saldo-estoq.            
DEFINE BUFFER bped-venda    FOR ped-venda.             
DEFINE BUFFER bped-item     FOR ped-item.            
DEFINE BUFFER bFatComercial FOR fat-comercial.          
DEFINE BUFFER bf-emitente   FOR emitente.              
DEFINE BUFFER bmovto_tit_acr_perdas FOR movto_tit_acr. 
DEFINE BUFFER bf-ped-venda FOR ped-venda.
DEFINE BUFFER bf-ped-item  FOR ped-item.
DEFINE BUFFER btt-ped-venda-aux FOR tt-ped-venda-aux.
    

{esapi/esapi002tt.i}    /* Definicao da temp-table de origem */
{utp/ut-glob.i}
{cdp/cd0666.i}          /* Definicao da temp-table de erros */
{upc\btb910za-upc.i}
{utp/utapi019.i}        /* Definiá∆o de temp-tables do email */
{btb/btb912zb.i}
{btb/btapi523.i h-param-global}
{esp/es0018.i}
{esp/esb/esesb000.i}
{esp/esb/out/msg0312.i}

DEFINE TEMP-TABLE tt-AtuErro LIKE tt-erro.  
DEFINE TEMP-TABLE tt-erro2 NO-UNDO LIKE tt-erro.
{upc/pd4000k-upce.i}

DEF NEW GLOBAL SHARED VAR gr-ped-venda              AS ROWID         NO-UNDO. 
DEF NEW GLOBAL SHARED VAR gr-ped-venda-aux          AS ROWID         NO-UNDO. 

DEFINE VARIABLE gr-ped-venda-espdp003               AS ROWID         NO-UNDO. 

DEFINE VAR dt-inicio-entrega AS DATE NO-UNDO.
DEFINE VAR dt-fim-entrega    AS DATE NO-UNDO.


ASSIGN gr-ped-venda-espdp003 = gr-ped-venda
       gr-ped-venda-aux      = gr-ped-venda.                                  


DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
        "Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE FRAME f-pg-imp
    rs-execucao AT ROW 8.88 COL 2.86 HELP
         "Modo de Execuá∆o" NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10.5 WIDGET-ID 100.

/* Trava WMS  */
DEFINE NEW GLOBAL SHARED VARIABLE v_cod-deposESPDP006       LIKE deposito.cod-depos NO-UNDO.

/*fnEstoque*/
{esp/pdp/espdp006fn.i}

/*pi-valida-bloqueio-fat*/
{esp/pdp/espdp006.i2}

DEFINE BUFFER bint-pedido-vtex FOR int-pedido-vtex.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brPedidos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ped-venda-aux ttped-item

/* Definitions for BROWSE brPedidos                                     */
&Scoped-define FIELDS-IN-QUERY-brPedidos tt-ped-venda-aux.nome-abrev ~
tt-ped-venda-aux.nr-pedcli tt-ped-venda-aux.tp-pedido ~
tt-ped-venda-aux.dt-emissao tt-ped-venda-aux.dt-entrega 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPedidos 
&Scoped-define QUERY-STRING-brPedidos FOR EACH tt-ped-venda-aux ~
      WHERE tt-ped-venda-aux.cod-priori <> 44     ~
 AND tt-ped-venda-aux.tp-pedido <> "34" ~
 NO-LOCK ~
    BY tt-ped-venda-aux.dt-emissao ~
       BY tt-ped-venda-aux.nr-pedcli
&Scoped-define OPEN-QUERY-brPedidos OPEN QUERY brPedidos FOR EACH tt-ped-venda-aux ~
      WHERE tt-ped-venda-aux.cod-priori <> 44     ~
 AND tt-ped-venda-aux.tp-pedido <> "34" ~
 NO-LOCK ~
    BY tt-ped-venda-aux.dt-emissao ~
       BY tt-ped-venda-aux.nr-pedcli.
&Scoped-define TABLES-IN-QUERY-brPedidos tt-ped-venda-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brPedidos tt-ped-venda-aux


/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttped-item.it-codigo ~
fnDescItem() @ c-descitem ttped-item.qt-pedida ~
ttped-item.qt-pedida  - ttped-item.qt-atendida - ttped-item.qt-log-aloca  @ d-saldo ~
ttped-item.qt-log-aloca @ i-aloca ttped-item.qt-log-aloca ~
fnEstoque(c-cod-estabel, ttped-item.it-codigo, vCod-depos, vLocalizacao, no) @ d-estoque ~
ttped-item.vl-preuni 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 ttped-item.qt-log-aloca 
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon1 ttped-item
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon1 ttped-item
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttped-item NO-LOCK ~
    BY ttped-item.it-codigo
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttped-item NO-LOCK ~
    BY ttped-item.it-codigo.
&Scoped-define TABLES-IN-QUERY-brSon1 ttped-item
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttped-item


/* Definitions for FRAME fPage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage0 ~
    ~{&OPEN-QUERY-brPedidos}

/* Definitions for FRAME fPage1                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttped-venda.nr-pedcli ~
ttped-venda.cod-emitente ttped-venda.nome-abrev ttped-venda.no-ab-reppri ~
ttped-venda.cod-gr-cli ttped-venda.dt-emissao ttped-venda.dt-entrega ~
ttped-venda.nat-operacao ttped-venda.cod-cond-pag ttped-venda.cidade ~
ttped-venda.estado ttped-venda.tp-pedido ttped-venda.nome-transp ~
ttped-venda.desc-bloq-cr ttped-venda.cod-priori ttped-venda.ind-fat-par ~
ttped-venda.vl-liq-abe ttped-venda.observacoes ttped-venda.cond-espec 
&Scoped-define ENABLED-TABLES ttped-venda
&Scoped-define FIRST-ENABLED-TABLE ttped-venda
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 rtParent rtToolBar RECT-3 ~
RECT-4 RECT-5 btFirst btPrev btNext btLast btGoTo btSel btPedido btExtra ~
btMod btAlocAut btConsulta btSerExec btFat btQueryJoins btReportsJoins ~
btExit btHelp btCalcula btCalcula-2 c-servidor brPedidos c-cod-estabel ~
c-desc-grupo vCod-depos c-marketplace c-natureza c-situacao cod-transp ~
c-transp cidade-cif c-frete de-ps-total-alocado de-vl-total-alocado ~
de-vl-st-alocado c-sit-credito de-ps-total-aberto de-LimIntelbras btVolumes ~
btLimite i-volumes de-vl-ipi-alocado de-LimIntelbrasClube bt-loc-pedido 
&Scoped-Define DISPLAYED-FIELDS ttped-venda.nr-pedcli ~
ttped-venda.cod-emitente ttped-venda.nome-abrev ttped-venda.no-ab-reppri ~
ttped-venda.cod-gr-cli ttped-venda.dt-emissao ttped-venda.dt-entrega ~
ttped-venda.nat-operacao ttped-venda.cod-cond-pag ttped-venda.cidade ~
ttped-venda.estado ttped-venda.tp-pedido ttped-venda.nome-transp ~
ttped-venda.desc-bloq-cr ttped-venda.cod-priori ttped-venda.cod-canal-venda ~
ttped-venda.ind-fat-par ttped-venda.vl-liq-abe ttped-venda.observacoes ~
ttped-venda.cond-espec 
&Scoped-define DISPLAYED-TABLES ttped-venda
&Scoped-define FIRST-DISPLAYED-TABLE ttped-venda
&Scoped-Define DISPLAYED-OBJECTS c-servidor c-cod-estabel c-desc-grupo ~
vCod-depos vLocalizacao fi-descricao c-marketplace c-natureza c-situacao ~
cod-transp c-transp cidade-cif c-frete cod-transp-red c-nome-transp-red ~
de-ps-total-alocado de-vl-total-alocado de-vl-st-alocado c-sit-credito ~
de-ps-total-aberto de-LimIntelbras i-volumes de-vl-ipi-alocado ~
de-LimIntelbrasClube 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wMasterDetail 
FUNCTION fnDescItem RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       RULE
       MENU-ITEM miSel          LABEL "Seleá∆o"        ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM miFat          LABEL "Faturar"        ACCELERATOR "CTRL-F"
       MENU-ITEM miFat2         LABEL "Faturar"        ACCELERATOR "CTRL-D"
       MENU-ITEM miCalc         LABEL "Calcula"        ACCELERATOR "CTRL-E"
       MENU-ITEM miDet          LABEL "Detalhar"       ACCELERATOR "CTRL-P"
       MENU-ITEM miExtra        LABEL "Inf. Adicionais" ACCELERATOR "CTRL-A"
       MENU-ITEM m_Liberao_Faturamento_Total_A LABEL "Liberaá∆o Total Autom†tica" ACCELERATOR "CTRL-L"
       RULE
       MENU-ITEM miMod          LABEL "Modificar"      ACCELERATOR "CTRL-U"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-loc-pedido 
     LABEL "Localiza Pedido" 
     SIZE 15 BY 1.

DEFINE BUTTON btAlocAut 
     IMAGE-UP FILE "image/gr-cla.bmp":U
     IMAGE-INSENSITIVE FILE "image/gr-cla.bmp":U
     LABEL "Modificar" 
     SIZE 4 BY 1.25 TOOLTIP "Alocaá∆o Total Autom†tica".

DEFINE BUTTON btCalcula 
     IMAGE-UP FILE "image\im-calc4":U
     IMAGE-INSENSITIVE FILE "image\ii-calc4":U
     LABEL "C†lculo da Nota" 
     SIZE 4 BY 1.25 TOOLTIP "C†lculo da nota"
     FONT 4.

DEFINE BUTTON btCalcula-2 
     IMAGE-UP FILE "adeicon/header9x.bmp":U
     IMAGE-DOWN FILE "adeicon/header9x.bmp":U
     IMAGE-INSENSITIVE FILE "adeicon/header9x.bmp":U
     LABEL "C†lcula Pedidos Selecionados" 
     SIZE 4 BY 1.25 TOOLTIP "C†lcula Pedidos Selecionados"
     FONT 4.

DEFINE BUTTON btConsulta 
     IMAGE-UP FILE "adeicon/debug.bmp":U
     IMAGE-DOWN FILE "adeicon/debug.bmp":U
     IMAGE-INSENSITIVE FILE "adeicon/debug.bmp":U
     LABEL "Consulta" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Faturamento Comercial".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExtra 
     IMAGE-UP FILE "image/im-notah.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-notah.bmp":U
     LABEL "Informaá‰es Adicionais" 
     SIZE 4 BY 1.25 TOOLTIP "informaá‰es Adicionais".

DEFINE BUTTON btFat 
     IMAGE-UP FILE "image/im-amort.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-amort.bmp":U
     LABEL "Fat" 
     SIZE 4 BY 1.25 TOOLTIP "Liberar para Faturamento".

DEFINE BUTTON btFat-2 
     IMAGE-UP FILE "adeicon/header0x.bmp":U
     IMAGE-DOWN FILE "adeicon/header0x.bmp":U
     IMAGE-INSENSITIVE FILE "adeicon/header0x.bmp":U
     LABEL "Fat" 
     SIZE 4 BY 1.25 TOOLTIP "Seleciona Pedido a Faturar".

DEFINE BUTTON btFaturaTodosPedSel 
     IMAGE-UP FILE "adeicon/devwb.bmp":U
     IMAGE-DOWN FILE "adeicon/devwb.bmp":U
     IMAGE-INSENSITIVE FILE "adeicon/devwb.bmp":U
     LABEL "Fatura Todos" 
     SIZE 4 BY 1.25 TOOLTIP "Fatura Todos os Pedidos Selecionados"
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btLimite 
     IMAGE-UP FILE "adeicon/check.bmp":U
     LABEL "Calcula Limiter" 
     SIZE 4 BY 1.

DEFINE BUTTON btMod 
     IMAGE-UP FILE "image/im-mod.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-mod.bmp":U
     LABEL "Modificar" 
     SIZE 4 BY 1.25 TOOLTIP "Modificar Pedido".

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPedido 
     IMAGE-UP FILE "image/im-det.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "Detalhar" 
     SIZE 4 BY 1.25 TOOLTIP "Detalhes do Pedido".

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

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

DEFINE BUTTON btSel 
     IMAGE-UP FILE "image\im-ran":U
     IMAGE-INSENSITIVE FILE "image\ii-ran":U
     LABEL "Sel" 
     SIZE 4 BY 1.25 TOOLTIP "Seleá∆o".

DEFINE BUTTON btSerExec 
     IMAGE-UP FILE "adeicon/freeup.bmp":U
     IMAGE-DOWN FILE "adeicon/freeup.bmp":U
     IMAGE-INSENSITIVE FILE "adeicon/freeup.bmp":U
     LABEL "Execuá∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Servidor Execuá∆o".

DEFINE BUTTON btVolumes 
     IMAGE-UP FILE "adeicon/check.bmp":U
     LABEL "Calcula Valumes" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-frete AS CHARACTER FORMAT "X(256)" 
     LABEL "Frete" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 2
     LIST-ITEMS "CIF","FOB" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE c-transp AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 16
     LIST-ITEMS "Item 1,","Item 2" 
     DROP-DOWN-LIST
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estabelec." 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-grupo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-marketplace AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marketplace" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-natureza AS CHARACTER FORMAT "X(256)":U 
     LABEL "Natureza" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-transp-red AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN NATIVE 
     SIZE 19.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-servidor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Servidor" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-sit-credito AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situaá∆o CrÇdito" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 0 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(256)" 
     LABEL "Situaá∆o Pedido" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE cidade-cif LIKE ttped-venda.cidade-cif
     LABEL "Frete":R12 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE cod-transp AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Transportador" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE cod-transp-red AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Transp Redesp" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE de-LimIntelbras AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Limite Intelbras" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-LimIntelbrasClube AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Lim Intelbras Clube" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-ps-total-aberto AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Peso Total Aberto" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-ps-total-alocado AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Peso Total Alocado" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ipi-alocado AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Valor IPI Aloc:" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-st-alocado AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Valor ST Aloc:" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-total-alocado AS DECIMAL FORMAT "->>>>>,>>9.99" INITIAL 0 
     LABEL "Vl Total Alocado:" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 24.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-volumes AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "N£mero de volumes" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE vCod-depos AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88
     FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE vLocalizacao AS CHARACTER FORMAT "X(256)":U INITIAL "*" 
     LABEL "Localizaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 TOOLTIP "~"*~" Equivale a todas as localizaá‰es."
     FGCOLOR 12  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56.29 BY 2.67.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 2.67.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80.29 BY 3.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32 BY 3.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32 BY 3.58.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 162.43 BY 26.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 163 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAlocaTudo 
     LABEL "Aloca Tudo" 
     SIZE 15 BY 1.

DEFINE BUTTON btDesaloca 
     LABEL "Desaloca Tudo" 
     SIZE 15 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brPedidos FOR 
      tt-ped-venda-aux SCROLLING.

DEFINE QUERY brSon1 FOR 
      ttped-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brPedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPedidos wMasterDetail _STRUCTURED
  QUERY brPedidos NO-LOCK DISPLAY
      tt-ped-venda-aux.nome-abrev FORMAT "x(12)":U
      tt-ped-venda-aux.nr-pedcli FORMAT "x(12)":U
      tt-ped-venda-aux.tp-pedido FORMAT "x(2)":U
      tt-ped-venda-aux.dt-emissao FORMAT "99/99/9999":U
      tt-ped-venda-aux.dt-entrega FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 42 BY 24.13
         FONT 1 ROW-HEIGHT-CHARS .5.

DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      ttped-item.it-codigo FORMAT "X(7)":U WIDTH 8.43
      fnDescItem() @ c-descitem COLUMN-LABEL "Descriá∆o" FORMAT "x(60)":U
            WIDTH 43.43
      ttped-item.qt-pedida COLUMN-LABEL "Qtd Ped" FORMAT ">>>,>>9":U
            WIDTH 9
      ttped-item.qt-pedida  - ttped-item.qt-atendida - ttped-item.qt-log-aloca  @ d-saldo COLUMN-LABEL "Sdo Ped" FORMAT ">>>,>>9":U
            WIDTH 9
      ttped-item.qt-log-aloca @ i-aloca COLUMN-LABEL "Alocado" FORMAT ">>>,>>9":U
            WIDTH 9
      ttped-item.qt-log-aloca COLUMN-LABEL "Reserva" FORMAT ">>>,>>9":U
            WIDTH 9 COLUMN-FGCOLOR 4
      fnEstoque(c-cod-estabel, ttped-item.it-codigo, vCod-depos, vLocalizacao, no) @ d-estoque COLUMN-LABEL "Estoque" FORMAT "->>>,>>9":U
            WIDTH 9
      ttped-item.vl-preuni COLUMN-LABEL "Preáo" FORMAT ">>>,>>9.99":U
            WIDTH 9
  ENABLE
      ttped-item.qt-log-aloca
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 113.57 BY 7.25
         FONT 2 ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSel AT ROW 1.13 COL 21.57 HELP
          "V† Para"
     btPedido AT ROW 1.13 COL 39 HELP
          "V† Para"
     btExtra AT ROW 1.13 COL 43.29 HELP
          "V† Para"
     btMod AT ROW 1.13 COL 47.57 HELP
          "V† Para"
     btAlocAut AT ROW 1.13 COL 51.86 HELP
          "V† Para" WIDGET-ID 2
     btConsulta AT ROW 1.13 COL 56.14 HELP
          "Consulta Faturamento Comercial" WIDGET-ID 54
     btSerExec AT ROW 1.13 COL 60.43 HELP
          "Consulta Servidor Execuá∆o" WIDGET-ID 56
     btFat AT ROW 1.13 COL 123.57 HELP
          "V† Para"
     btFat-2 AT ROW 1.13 COL 127.86 HELP
          "Seleciona Pedido a Faturar em RPW" WIDGET-ID 42
     btFaturaTodosPedSel AT ROW 1.13 COL 136.43 HELP
          "Fatura Todos os Pedidos Selecionados" WIDGET-ID 38
     btQueryJoins AT ROW 1.13 COL 147.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 151.29 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 155.29 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 159.29 HELP
          "Ajuda"
     btCalcula AT ROW 1.17 COL 119.29 HELP
          "Elimina ocorrància corrente" WIDGET-ID 22
     btCalcula-2 AT ROW 1.17 COL 132.14 HELP
          "C†lcula pedidos selecionados que estejam an prioridade 09" WIDGET-ID 40
     c-servidor AT ROW 1.33 COL 108 COLON-ALIGNED WIDGET-ID 58
     brPedidos AT ROW 2.88 COL 120 WIDGET-ID 100
     ttped-venda.nr-pedcli AT ROW 3.25 COL 14 COLON-ALIGNED
          LABEL "Pedido":R17
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttped-venda.cod-emitente AT ROW 3.25 COL 45 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .88
     ttped-venda.nome-abrev AT ROW 3.25 COL 52.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     ttped-venda.no-ab-reppri AT ROW 3.25 COL 96 COLON-ALIGNED WIDGET-ID 78
          LABEL "Representante"
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     c-cod-estabel AT ROW 4.25 COL 14 COLON-ALIGNED WIDGET-ID 16
     ttped-venda.cod-gr-cli AT ROW 4.25 COL 45 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .88
     c-desc-grupo AT ROW 4.25 COL 48.86 COLON-ALIGNED NO-LABEL
     vCod-depos AT ROW 4.25 COL 96 COLON-ALIGNED WIDGET-ID 62
     ttped-venda.dt-emissao AT ROW 5.25 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttped-venda.dt-entrega AT ROW 5.25 COL 45 COLON-ALIGNED
          LABEL "Prev.Fatur"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     vLocalizacao AT ROW 5.25 COL 96 COLON-ALIGNED WIDGET-ID 68
     ttped-venda.nat-operacao AT ROW 6.25 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttped-venda.cod-cond-pag AT ROW 6.25 COL 45 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .88
     fi-descricao AT ROW 6.25 COL 49.57 COLON-ALIGNED NO-LABEL WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 163.14 BY 28
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage0
     c-marketplace AT ROW 6.25 COL 91 COLON-ALIGNED WIDGET-ID 86
     c-natureza AT ROW 6.25 COL 106 COLON-ALIGNED WIDGET-ID 92
     c-situacao AT ROW 7.25 COL 14 COLON-ALIGNED HELP
          "Situaá∆o do pedido"
     ttped-venda.cidade AT ROW 7.25 COL 45 COLON-ALIGNED
          LABEL "Cidade":R8
          VIEW-AS FILL-IN 
          SIZE 24.57 BY .88
     ttped-venda.estado AT ROW 7.25 COL 70 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     ttped-venda.tp-pedido AT ROW 8.25 COL 14 COLON-ALIGNED
          LABEL "Atendente"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cod-transp AT ROW 8.25 COL 45 COLON-ALIGNED HELP
          "Digite o c¢digo do transportador" WIDGET-ID 44
     ttped-venda.nome-transp AT ROW 8.25 COL 54.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 19.72 BY .88
     c-transp AT ROW 8.25 COL 55.43 COLON-ALIGNED NO-LABEL
     ttped-venda.desc-bloq-cr AT ROW 8.25 COL 85 NO-LABEL WIDGET-ID 80
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 30 BY 2.83
     cidade-cif AT ROW 9.25 COL 14 COLON-ALIGNED HELP
          ""
          LABEL "Frete":R12
     c-frete AT ROW 9.25 COL 14 COLON-ALIGNED
     cod-transp-red AT ROW 9.25 COL 45 COLON-ALIGNED WIDGET-ID 88
     c-nome-transp-red AT ROW 9.25 COL 54.29 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     ttped-venda.cod-priori AT ROW 10.25 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttped-venda.cod-canal-venda AT ROW 10.25 COL 45 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     ttped-venda.ind-fat-par AT ROW 10.25 COL 57 WIDGET-ID 36
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .88
     de-ps-total-alocado AT ROW 11.63 COL 16.29 COLON-ALIGNED WIDGET-ID 72
     de-vl-total-alocado AT ROW 11.63 COL 42.72 COLON-ALIGNED
     de-vl-st-alocado AT ROW 11.63 COL 67.14 COLON-ALIGNED
     c-sit-credito AT ROW 11.63 COL 96 COLON-ALIGNED WIDGET-ID 12
     de-ps-total-aberto AT ROW 12.63 COL 16.29 COLON-ALIGNED WIDGET-ID 70
     ttped-venda.vl-liq-abe AT ROW 12.63 COL 42.72 COLON-ALIGNED
          LABEL "Vl Total Aberto"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     de-LimIntelbras AT ROW 12.63 COL 96 COLON-ALIGNED WIDGET-ID 48
     btVolumes AT ROW 13.58 COL 27.43 HELP
          "Calcula Limites" WIDGET-ID 66
     btLimite AT ROW 13.58 COL 111.14 HELP
          "Calcula Limites" WIDGET-ID 50
     i-volumes AT ROW 13.63 COL 16.29 COLON-ALIGNED WIDGET-ID 64
     de-vl-ipi-alocado AT ROW 13.63 COL 42.72 COLON-ALIGNED
     de-LimIntelbrasClube AT ROW 13.63 COL 96 COLON-ALIGNED WIDGET-ID 46
     ttped-venda.observacoes AT ROW 15.58 COL 4 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 53 BY 2
     ttped-venda.cond-espec AT ROW 15.58 COL 61 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 53.72 BY 2
     bt-loc-pedido AT ROW 27.13 COL 147.29 WIDGET-ID 8
     "Observaá‰es" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 14.96 COL 5.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 163.14 BY 28
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage0
     "Condiá‰es Especiais" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 14.96 COL 62.14
     "Motivo Liberaá∆o /Bloqueio CrÇdito" VIEW-AS TEXT
          SIZE 24.29 BY .54 AT ROW 7.54 COL 85 WIDGET-ID 82
     RECT-1 AT ROW 15.21 COL 2.72
     RECT-2 AT ROW 15.21 COL 60
     rtParent AT ROW 2.5 COL 1
     rtToolBar AT ROW 1 COL 1
     RECT-3 AT ROW 11.42 COL 2.72 WIDGET-ID 74
     RECT-4 AT ROW 11.42 COL 84 WIDGET-ID 76
     RECT-5 AT ROW 7.75 COL 84 WIDGET-ID 84
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 163.14 BY 28
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.38 COL 1
     btDesaloca AT ROW 8.75 COL 82 HELP
          "Aloca todas as reservas dispon°veis" WIDGET-ID 4
     btAlocaTudo AT ROW 8.75 COL 100 HELP
          "Aloca todas as reservas dispon°veis" WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.29 ROW 19.29
         SIZE 116.72 BY 8.88
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-ped-venda-aux T "?" NO-UNDO mgmov ped-venda
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
          field r-ped-venda as rowid
      END-FIELDS.
      TABLE: ttped-item T "?" NO-UNDO mgmov ped-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttped-venda T "?" NO-UNDO mgmov ped-venda
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          field r-ped-venda as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = "Geraá∆o Reservas - ESPDP006"
         HEIGHT             = 28
         WIDTH              = 163.14
         MAX-HEIGHT         = 38.88
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 38.88
         VIRTUAL-WIDTH      = 195.14
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brPedidos c-servidor fPage0 */
ASSIGN 
       brPedidos:ALLOW-COLUMN-SEARCHING IN FRAME fPage0 = TRUE.

ASSIGN 
       btCalcula-2:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR BUTTON btFat-2 IN FRAME fPage0
   NO-ENABLE                                                            */
ASSIGN 
       btFat-2:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR BUTTON btFaturaTodosPedSel IN FRAME fPage0
   NO-ENABLE                                                            */
ASSIGN 
       btFaturaTodosPedSel:HIDDEN IN FRAME fPage0           = TRUE.

ASSIGN 
       btMod:HIDDEN IN FRAME fPage0           = TRUE.

ASSIGN 
       c-frete:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR FILL-IN c-nome-transp-red IN FRAME fPage0
   NO-ENABLE                                                            */
ASSIGN 
       c-transp:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR FILL-IN ttped-venda.cidade IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cidade-cif IN FRAME fPage0
   LIKE = Temp-Tables.ttped-venda. EXP-LABEL EXP-SIZE                   */
/* SETTINGS FOR FILL-IN ttped-venda.cod-canal-venda IN FRAME fPage0
   NO-ENABLE                                                            */
ASSIGN 
       ttped-venda.cod-canal-venda:READ-ONLY IN FRAME fPage0        = TRUE.

/* SETTINGS FOR FILL-IN cod-transp-red IN FRAME fPage0
   NO-ENABLE                                                            */
ASSIGN 
       ttped-venda.cond-espec:READ-ONLY IN FRAME fPage0        = TRUE.

ASSIGN 
       ttped-venda.desc-bloq-cr:READ-ONLY IN FRAME fPage0        = TRUE.

/* SETTINGS FOR FILL-IN ttped-venda.dt-entrega IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttped-venda.no-ab-reppri IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttped-venda.nome-abrev IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttped-venda.nr-pedcli IN FRAME fPage0
   EXP-LABEL                                                            */
ASSIGN 
       ttped-venda.nr-pedcli:READ-ONLY IN FRAME fPage0        = TRUE.

ASSIGN 
       ttped-venda.observacoes:READ-ONLY IN FRAME fPage0        = TRUE.

/* SETTINGS FOR FILL-IN ttped-venda.tp-pedido IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttped-venda.vl-liq-abe IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN vLocalizacao IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
ASSIGN 
       brSon1:MAX-DATA-GUESS IN FRAME fPage1         = 300.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPedidos
/* Query rebuild information for BROWSE brPedidos
     _TblList          = "Temp-Tables.tt-ped-venda-aux"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-ped-venda-aux.dt-emissao|yes,Temp-Tables.tt-ped-venda-aux.nr-pedcli|yes"
     _Where[1]         = "Temp-Tables.tt-ped-venda-aux.cod-priori <> 44    
 AND Temp-Tables.tt-ped-venda-aux.tp-pedido <> ""34""
"
     _FldNameList[1]   = Temp-Tables.tt-ped-venda-aux.nome-abrev
     _FldNameList[2]   = Temp-Tables.tt-ped-venda-aux.nr-pedcli
     _FldNameList[3]   = Temp-Tables.tt-ped-venda-aux.tp-pedido
     _FldNameList[4]   = Temp-Tables.tt-ped-venda-aux.dt-emissao
     _FldNameList[5]   = Temp-Tables.tt-ped-venda-aux.dt-entrega
     _Query            is OPENED
*/  /* BROWSE brPedidos */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.ttped-item"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST USED"
     _OrdList          = "Temp-Tables.ttped-item.it-codigo|yes"
     _FldNameList[1]   > Temp-Tables.ttped-item.it-codigo
"ttped-item.it-codigo" ? "X(7)" "character" ? ? ? ? ? ? no "Item" no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fnDescItem() @ c-descitem" "Descriá∆o" "x(60)" ? ? ? ? ? ? ? no ? no no "43.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttped-item.qt-pedida
"ttped-item.qt-pedida" "Qtd Ped" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"ttped-item.qt-pedida  - ttped-item.qt-atendida - ttped-item.qt-log-aloca  @ d-saldo" "Sdo Ped" ">>>,>>9" ? ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"ttped-item.qt-log-aloca @ i-aloca" "Alocado" ">>>,>>9" ? ? ? ? ? ? ? no "Quantidade alocada para o pedido" no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttped-item.qt-log-aloca
"ttped-item.qt-log-aloca" "Reserva" ">>>,>>9" "decimal" ? 4 ? ? ? ? yes ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fnEstoque(c-cod-estabel, ttped-item.it-codigo, vCod-depos, vLocalizacao, no) @ d-estoque" "Estoque" "->>>,>>9" ? ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttped-item.vl-preuni
"ttped-item.vl-preuni" "Preáo" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail /* Geraá∆o Reservas - ESPDP006 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail /* Geraá∆o Reservas - ESPDP006 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brPedidos
&Scoped-define SELF-NAME brPedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPedidos wMasterDetail
ON START-SEARCH OF brPedidos IN FRAME fPage0
DO:
    DEFINE VARIABLE i-cont       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-pos-coluna AS INTEGER     NO-UNDO.

    SELF:CLEAR-SORT-ARROWS().

    IF SELF:CURRENT-COLUMN:TABLE = "":U OR
       SELF:CURRENT-COLUMN:TABLE = ?    THEN
        RETURN NO-APPLY.

    IF c-nome-coluna <> SELF:CURRENT-COLUMN:NAME THEN
        ASSIGN c-nome-coluna = SELF:CURRENT-COLUMN:NAME
               l-asc         = YES.
    ELSE
        ASSIGN l-asc = NOT l-asc.

    IF l-asc THEN
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME).
    ELSE
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC":U).
            
    DO i-cont = 1 TO SELF:NUM-COLUMNS:
        IF SELF:CURRENT-COLUMN = SELF:GET-BROWSE-COLUMN(i-cont) THEN
            ASSIGN i-pos-coluna = i-cont.
    END.

    SELF:SET-SORT-ARROW(i-pos-coluna, l-asc).

    SELF:QUERY:QUERY-OPEN().
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPedidos wMasterDetail
ON VALUE-CHANGED OF brPedidos IN FRAME fPage0
DO:
    IF AVAILABLE tt-ped-venda-aux THEN
        RUN repositionRecord IN THIS-PROCEDURE (INPUT tt-ped-venda-aux.r-Rowid). 
    {&OPEN-QUERY-brSaldo}
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON ROW-DISPLAY OF brSon1 IN FRAME fPage1
DO:
    IF AVAIL ttped-item THEN DO:

        RUN pi-periodo-fat.

        FIND FIRST item-uni-estab NO-LOCK USE-INDEX codigo
             WHERE item-uni-estab.cod-estabel = ttped-venda.cod-estabel
               AND item-uni-estab.it-codigo   = ttped-item.it-codigo
               AND item-uni-estab.nr-linha    = 20 NO-ERROR.
        IF  AVAIL  item-uni-estab THEN DO:
            ASSIGN ttPed-item.it-codigo:FGCOLOR IN BROWSE brSon1 = 2
                   ttPed-item.vl-preuni:FGCOLOR IN BROWSE brSon1 = 2
                   ttPed-item.qt-pedida:FGCOLOR IN BROWSE brSon1 = 2
                   i-aloca:FGCOLOR IN BROWSE brSon1 = 2
                   d-saldo:FGCOLOR IN BROWSE brSon1 = 2
                   d-estoque:FGCOLOR IN BROWSE brSon1 = 2
                   c-descitem:FGCOLOR IN BROWSE brSon1 = 2.    
        END.
        ELSE DO:
            IF ttped-item.dt-entrega <= TODAY THEN DO: 
                ASSIGN de-fnEstoque = fnEstoque(ttped-venda.cod-estabel, ttped-item.it-codigo, vCod-depos, vLocalizacao, NO).
                IF  de-fnEstoque + ttped-item.qt-log-aloca = 0 THEN
                    ASSIGN ttPed-item.it-codigo:FGCOLOR IN BROWSE brSon1 = 12
                           ttPed-item.vl-preuni:FGCOLOR IN BROWSE brSon1 = 12
                           ttPed-item.qt-pedida:FGCOLOR IN BROWSE brSon1 = 12
                           i-aloca:FGCOLOR IN BROWSE brSon1 = 12
                           d-saldo:FGCOLOR IN BROWSE brSon1 = 12
                           d-estoque:FGCOLOR IN BROWSE brSon1 = 12
                           c-descitem:FGCOLOR IN BROWSE brSon1 = 12.
                ELSE DO:                    
                    IF  de-fnEstoque + ttped-item.qt-log-aloca < (ttPed-item.qt-pedida - ttPed-item.qt-atendida) THEN
                        ASSIGN ttPed-item.it-codigo:FGCOLOR IN BROWSE brSon1 = 9
                               ttPed-item.vl-preuni:FGCOLOR IN BROWSE brSon1 = 9
                               ttPed-item.qt-pedida:FGCOLOR IN BROWSE brSon1 = 9
                               i-aloca:FGCOLOR IN BROWSE brSon1 = 9
                               d-saldo:FGCOLOR IN BROWSE brSon1 = 9
                               d-estoque:FGCOLOR IN BROWSE brSon1 = 9
                               c-descitem:FGCOLOR IN BROWSE brSon1 = 9. 
                    ELSE    
                        ASSIGN ttPed-item.it-codigo:FGCOLOR IN BROWSE brSon1 = ?
                               ttPed-item.vl-preuni:FGCOLOR IN BROWSE brSon1 = ?
                               ttPed-item.qt-pedida:FGCOLOR IN BROWSE brSon1 = ?
                               i-aloca:FGCOLOR IN BROWSE brSon1 = ?
                               d-saldo:FGCOLOR IN BROWSE brSon1 = ?
                               d-estoque:FGCOLOR IN BROWSE brSon1 = ?
                               c-descitem:FGCOLOR IN BROWSE brSon1 = ?.
                END.
            END.
        END.

        /*ultimo dia DO mes*/
       /* assign dt-aux = date(MONTH(TODAY), 25, year(TODAY))
               dt-aux = dt-aux + 15
               dt-aux = date(month(dt-aux), 01, year(dt-aux)) - 1.

        IF dt-aux = ttped-item.dt-entrega THEN
            ASSIGN dt-aux = dt-aux + 1. */

        IF ttped-item.dt-entrega > TODAY
        AND ttped-item.dt-entrega <= dt-fim-entrega THEN
            ASSIGN ttPed-item.it-codigo:FGCOLOR IN BROWSE brSon1 = 15
                   ttPed-item.vl-preuni:FGCOLOR IN BROWSE brSon1 = 15
                   ttPed-item.qt-pedida:FGCOLOR IN BROWSE brSon1 = 15
                   ttPed-item.qt-log-aloca:FGCOLOR IN BROWSE brSon1 = 15
                   i-aloca:FGCOLOR IN BROWSE brSon1 = 15
                   d-saldo:FGCOLOR IN BROWSE brSon1 = 15
                   d-estoque:FGCOLOR IN BROWSE brSon1 = 15
                   c-descitem:FGCOLOR IN BROWSE brSon1 = 15
                   ttPed-item.it-codigo:bGCOLOR IN BROWSE brSon1 = 7
                   ttPed-item.vl-preuni:bGCOLOR IN BROWSE brSon1 = 7
                   ttPed-item.qt-pedida:bGCOLOR IN BROWSE brSon1 = 7
                   ttPed-item.qt-log-aloca:FGCOLOR IN BROWSE brSon1 = 7
                   i-aloca:bGCOLOR IN BROWSE brSon1 = 7
                   d-saldo:bGCOLOR IN BROWSE brSon1 = 7
                   d-estoque:bGCOLOR IN BROWSE brSon1 = 7
                   c-descitem:bGCOLOR IN BROWSE brSon1 = 7.

        //IF ttped-item.dt-entrega > dt-aux THEN
        IF ttped-item.dt-entrega > dt-fim-entrega THEN DO:
            ASSIGN ttPed-item.it-codigo:FGCOLOR IN BROWSE brSon1 = 15
                   ttPed-item.vl-preuni:FGCOLOR IN BROWSE brSon1 = 15
                   ttPed-item.qt-pedida:FGCOLOR IN BROWSE brSon1 = 15
                   ttPed-item.qt-log-aloca:FGCOLOR IN BROWSE brSon1 = 15
                   i-aloca:FGCOLOR IN BROWSE brSon1 = 15
                   d-saldo:FGCOLOR IN BROWSE brSon1 = 15
                   d-estoque:FGCOLOR IN BROWSE brSon1 = 15
                   c-descitem:FGCOLOR IN BROWSE brSon1 = 15
                   ttPed-item.it-codigo:bGCOLOR IN BROWSE brSon1 = 1
                   ttPed-item.vl-preuni:bGCOLOR IN BROWSE brSon1 = 1
                   ttPed-item.qt-pedida:bGCOLOR IN BROWSE brSon1 = 1
                   ttPed-item.qt-log-aloca:FGCOLOR IN BROWSE brSon1 = 1
                   i-aloca:bGCOLOR IN BROWSE brSon1 = 1
                   d-saldo:bGCOLOR IN BROWSE brSon1 = 1
                   d-estoque:bGCOLOR IN BROWSE brSon1 = 1
                   c-descitem:bGCOLOR IN BROWSE brSon1 = 1.
        END.

        ASSIGN l-bloqueado = NO.
        IF CAN-FIND(FIRST int-ped-item NO-LOCK
                        WHERE int-ped-item.nome-abrev   = ttped-item.nome-abrev
                          AND int-ped-item.nr-pedcli    = ttped-item.nr-pedcli
                          AND int-ped-item.nr-sequencia = ttped-item.nr-sequencia
                          AND int-ped-item.it-codigo    = ttped-item.it-codigo
                          AND int-ped-item.cod-refer    = ttped-item.cod-refer
                          AND (int-ped-item.ind-status-preco = 1 OR int-ped-item.ind-status-preco = 3)) THEN
              ASSIGN l-bloqueado = YES.
    
         IF  l-bloqueado THEN DO:
                ASSIGN ttPed-item.it-codigo:FGCOLOR IN BROWSE brSon1 = 15
                       ttPed-item.vl-preuni:FGCOLOR IN BROWSE brSon1 = 15
                       ttPed-item.qt-pedida:FGCOLOR IN BROWSE brSon1 = 15
                       ttPed-item.qt-log-aloca:FGCOLOR IN BROWSE brSon1 = 15
                       i-aloca:FGCOLOR IN BROWSE brSon1 = 15
                       d-saldo:FGCOLOR IN BROWSE brSon1 = 15
                       d-estoque:FGCOLOR IN BROWSE brSon1 = 15
                       c-descitem:FGCOLOR IN BROWSE brSon1 = 15
                       ttPed-item.it-codigo:bGCOLOR IN BROWSE brSon1 = 2
                       ttPed-item.vl-preuni:bGCOLOR IN BROWSE brSon1 = 2
                       ttPed-item.qt-pedida:bGCOLOR IN BROWSE brSon1 = 2
                       ttPed-item.qt-log-aloca:FGCOLOR IN BROWSE brSon1 = 2
                       i-aloca:bGCOLOR IN BROWSE brSon1 = 2
                       d-saldo:bGCOLOR IN BROWSE brSon1 = 2
                       d-estoque:bGCOLOR IN BROWSE brSon1 = 2
                       c-descitem:bGCOLOR IN BROWSE brSon1 = 2.
         END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON VALUE-CHANGED OF brSon1 IN FRAME fPage1
DO:
  
    {&OPEN-QUERY-brSaldo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME bt-loc-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-loc-pedido wMasterDetail
ON CHOOSE OF bt-loc-pedido IN FRAME fPage0 /* Localiza Pedido */
DO:
    RUN goToPedidoAux.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAlocaTudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlocaTudo wMasterDetail
ON CHOOSE OF btAlocaTudo IN FRAME fPage1 /* Aloca Tudo */
DO:
    
    FOR EACH tt-item: DELETE tt-item. END. 
    FOR EACH tt-erro: DELETE tt-erro. END. 

    ASSIGN cReturn = "".

    IF AVAIL ttPed-venda THEN DO:

        FOR EACH ttPed-Item OF ttPed-venda:

            ASSIGN vQtAlocar = 0.

            ASSIGN de-qtd-estoq = fnEstoque(ttped-venda.cod-estabel, ttped-item.it-codigo, vCod-depos, "*", NO).

            IF de-qtd-estoq < (ttped-item.qt-pedida - ttped-item.qt-atendida - ttped-item.qt-log-aloca) THEN
                ASSIGN vQtAlocar = de-qtd-estoq.
            ELSE
                ASSIGN vQtAlocar = ttped-item.qt-pedida - ttped-item.qt-atendida - ttped-item.qt-log-aloca.

            IF vQtAlocar = 0 THEN
                NEXT.

            FIND FIRST bf-ped-venda NO-LOCK 
                 WHERE bf-ped-venda.nr-pedcli  = ttped-venda.nr-pedcli 
                   AND bf-ped-venda.nome-abrev = ttped-venda.nome-abrev NO-ERROR.
        
            FIND FIRST bf-ped-item OF ttped-item NO-LOCK NO-ERROR.
        
            IF  AVAIL bf-ped-venda
            AND AVAIL bf-ped-item THEN DO:
        
                RUN esp/pdp/espdp006f.p (INPUT c-seg-usuario,
                                         INPUT ROWID(bf-ped-venda),
                                         INPUT ROWID(bf-ped-item),
                                         INPUT vCod-depos,
                                         INPUT IF vLocalizacao = "*" THEN "" ELSE vLocalizacao,
                                         INPUT vQtAlocar,
                                         INPUT vUnid-Neg,
                                         OUTPUT TABLE tt-erro).
            END.

            ASSIGN ttped-item.qt-pedida    = bf-ped-item.qt-pedida   
                   ttped-item.qt-atendida  = bf-ped-item.qt-atendida 
                   ttped-item.qt-log-aloca = bf-ped-item.qt-log-aloca.
        END. /* ttPed_item */

        {&OPEN-QUERY-brSon1}
        
        RUN pi-calcula-valor-alocado.

        IF  VALID-HANDLE(h-alocacao) THEN
            DELETE PROCEDURE h-alocacao.

        IF CAN-FIND(FIRST tt-erro) THEN DO:
            RUN cdp/cd0666.w (INPUT TABLE tt-erro).
        END.

        RUN pi-marca-pedido.
    END.
    {&OPEN-QUERY-brSon1}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btAlocAut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlocAut wMasterDetail
ON CHOOSE OF btAlocAut IN FRAME fPage0 /* Modificar */
DO:
    RUN esp/pdp/espdp006d.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCalcula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCalcula wMasterDetail
ON CHOOSE OF btCalcula IN FRAME fPage0 /* C†lculo da Nota */
DO:

    DEFINE VARIABLE i-opcao         AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE c-nome-abrev    LIKE ped-venda.nome-abrev   NO-UNDO.
    DEFINE VARIABLE c-nr-pedcli     LIKE ped-venda.nr-pedcli    NO-UNDO.
    DEFINE VARIABLE h-ft4002        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE i-cont-aux      AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE c-servidorTela  AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE c-estab         AS CHARACTER                NO-UNDO.

    RUN pi-impede-fatur-depositos-diferente.
    IF  RETURN-VALUE <> "OK" THEN
        RETURN NO-APPLY.
        
    /*RUN pi-valida-reservas.
    IF RETURN-VALUE <> "OK" THEN DO:
        ASSIGN cReturn = "NOK".                
        RETURN NO-APPLY.  
    END.*/

    FOR FIRST mgesp.ponto-programa
        WHERE ponto-programa.nome-programa = "espdp006"
          AND ponto-programa.ponto = 12:

        IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa 
              AND ENTRY(1,conteudo-programa.conteudo) = v_cod_estab_usuar) THEN DO:
                MESSAGE "Faturamento Comercial Autom†tico n∆o est† liberado para o estabelecimento " + v_cod_estab_usuar
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN "OK".
        END.
    END.
    
    IF ttped-venda.cod-priori:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '07' THEN DO:
        FIND FIRST mgesp.ponto-programa NO-LOCK
            WHERE ponto-programa.nome-programa = "pd4000"
              AND ponto-programa.ponto         = 7 NO-ERROR.
        IF AVAIL mgesp.ponto-programa THEN DO:
            IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK
                    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                      AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 17006, 
                                   INPUT "Pedido est† sendo faturado.~~Aguarde o mesmo ser liberado.").
                ASSIGN cReturn = "NOK".                
                RETURN NO-APPLY.  
            END. /* IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK */
        END. /* IF AVAIL mgesp.ponto-programa THEN DO: */
    END.


    RUN pi-limpaTTables.

    ASSIGN c-nome-abrev     = ttped-venda.nome-abrev:SCREEN-VALUE IN FRAME {&FRAME-NAME}
           c-nr-pedcli      = ttped-venda.nr-pedcli :SCREEN-VALUE IN FRAME {&FRAME-NAME}
           p_num_ped_exec   = 0
           c-servidorTela   = c-servidor            :SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    RUN pi-valida-bloqueio-fat (INPUT  c-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                OUTPUT c-mensagem).

    IF RETURN-VALUE <> "OK" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17006, 
                           INPUT c-mensagem).
        ASSIGN cReturn = "NOK".                
        RETURN NO-APPLY.
    END.

    for first ped-item
        fields ()
        where  ped-item.nome-abrev = c-nome-abrev
        and    ped-item.nr-pedcli  = c-nr-pedcli 
        and   (ped-item.qt-alocada > 0
         or    ped-item.dec-1      > 0) no-lock:

        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17006, 
                           INPUT "Pedido vinculado a embarque.~~Por gentileza, faturar este pedido atravÇs de embarque.").
        ASSIGN cReturn = "NOK".                
        RETURN NO-APPLY.  

    end.    


    APPLY "choose" TO btFat IN FRAME {&FRAME-NAME}.

    IF cReturn = "NOK" THEN NEXT.
    ELSE DO:
        /***********/
        FIND FIRST ped-venda NO-LOCK 
             WHERE ped-venda.nr-pedcli = c-nr-pedcli NO-ERROR.
        IF AVAIL ped-venda THEN DO:

            IF ped-venda.cod-priori = 10 THEN DO:

                /* Presa pelo faturamento comercial */
                DO TRANS:
                    FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
                    ASSIGN ped-venda.cod-priori = 07 . 
                END.

                FIND CURRENT ttped-venda NO-ERROR.
                IF AVAIL ttped-venda THEN
                    ASSIGN ttped-venda.cod-priori = 07. 

                FIND CURRENT ped-venda NO-LOCK NO-ERROR.

                FOR EACH ped-item NO-LOCK
                   WHERE ped-item.nome-abrev = c-nome-abrev
                     AND ped-item.nr-pedcli  = c-nr-pedcli .
                    FIND FIRST ITEM NO-LOCK
                         WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.

                    IF ped-item.qt-log-aloc <> 0 or
                       ITEM.baixa-estoq = NO THEN DO:

                        IF ped-item.cod-sit-item = 6  THEN NEXT.

                        CREATE tt-digita.
                        ASSIGN tt-digita.nome-abrev     = c-nome-abrev  
                               tt-digita.nr-pedcli      = c-nr-pedcli   
                               tt-digita.c-it-codigo    = ped-item.it-codigo    
                               tt-digita.c-cod-refer    = ped-item.cod-refer    
                               tt-digita.i-nr-sequencia = ped-item.nr-sequencia.
                    END.
                    ELSE DO:

                        FIND FIRST prod-composto WHERE prod-composto.it-codigo-filho = ped-item.it-codigo NO-LOCK NO-ERROR.
                        IF AVAIL prod-composto THEN DO:

                            FIND FIRST ITEM WHERE ITEM.it-codigo = prod-composto.it-codigo-filho NO-LOCK NO-ERROR.
                            IF AVAIL ITEM THEN DO:

                                IF item.baixa-estoq = NO THEN DO:
                                    CREATE tt-digita.
                                    ASSIGN tt-digita.nome-abrev     = c-nome-abrev  
                                           tt-digita.nr-pedcli      = c-nr-pedcli   
                                           tt-digita.c-it-codigo    = ped-item.it-codigo    
                                           tt-digita.c-cod-refer    = ped-item.cod-refer    
                                           tt-digita.i-nr-sequencia = ped-item.nr-sequencia 
                                           .
                                END. /* IF item.baixa-estoq = NO THEN DO: */
                            END. /* IF AVAIL ITEM THEN DO: */
                        END. /* IF AVAIL prod-composto THEN DO: */
                    END.
                END.

                create tt-param.
                assign tt-param.usuario     = c-seg-usuario
                       tt-param.destino     = 2
                       tt-param.data-exec   = today
                       tt-param.hora-exec   = time

                       tt-param.nome-abrev  = c-nome-abrev 
                       tt-param.nr-pedcli   = c-nr-pedcli 
                       tt-param.Cod-depos   = vCod-depos  
                       tt-param.Localizacao = IF vLocalizacao = "*" THEN "" ELSE vLocalizacao.

                ASSIGN tt-param.arquivo = "esftp016rpFatCom_UNIX.tmp".

                RAW-TRANSFER tt-param TO raw-param.
                FOR each tt-digita NO-LOCK:
                    create tt-raw-digita.
                    raw-transfer tt-digita to tt-raw-digita.raw-digita.
                END.

                ASSIGN p_cod_prog_dtsul_w    = "esftp016rp"           
                       p_cod_prog_dtsul_rp   = "esp/ftp/esftp016rp.p"
                       p_cod_release         = '2.00.00.000'                    
                       p_cdn_estil_dwb       = 97                   
                       p_arquivo             = "esftp016rpFatCom.tmp" 
                       p_destino             = 2                    
                       p_raw_param           = raw-param.  

                create tt_param_segur.
                assign tt_param_segur.tta_num_vers_integr_api      = 3
                       tt_param_segur.tta_cod_aplicat_dtsul_corren = "MFT"
                       tt_param_segur.tta_cod_empres_usuar         = string(i-ep-codigo-usuario)
                       tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst
                       tt_param_segur.tta_cod_idiom_usuar          = "POR":U
                       tt_param_segur.tta_cod_modul_dtsul_corren   = "MFT"
                       tt_param_segur.tta_cod_pais_empres_usuar    = "BRA"
                       tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren
                       tt_param_segur.tta_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog.

                create tt_ped_exec.
                assign tt_ped_exec.tta_num_seq                = 1
                       tt_ped_exec.tta_cod_usuario            = v_cod_usuar_corren
                       tt_ped_exec.tta_cod_prog_dtsul         = p_cod_prog_dtsul_w 
                       tt_ped_exec.tta_cod_prog_dtsul_rp      = p_cod_prog_dtsul_rp
                       tt_ped_exec.tta_cod_release_prog_dtsul = p_cod_release      
                       tt_ped_exec.tta_dat_exec_ped_exec      = today
                       tt_ped_exec.tta_hra_exec_ped_exec      = replace(string(time,"HH:MM:SS"), ":", "")
                       tt_ped_exec.tta_cod_servid_exec        = c-servidorTela
                       tt_ped_exec.tta_cdn_estil_dwb          = 97.

                create tt_ped_exec_param.
                assign tt_ped_exec_param.tta_num_seq              = 1
                       tt_ped_exec_param.tta_cod_dwb_file         = "ftp/esftp016rp.p"
                       tt_ped_exec_param.tta_cod_dwb_output       = 'Arquivo'
                       tt_ped_exec_param.tta_nom_dwb_printer      = p_arquivo.

                raw-transfer tt-param       to tt_ped_exec_param.tta_raw_param_ped_exec.

                ASSIGN i-cont-aux = 0.
                FOR EACH tt-raw-digita NO-LOCK: 
                     ASSIGN i-cont-aux = i-cont-aux + 1.
                     CREATE tt_ped_exec_param_aux.
                     ASSIGN tt_ped_exec_param_aux.tta_num_dwb_order      = i-cont-aux
                            tt_ped_exec_param_aux.tta_num_seq            = 1
                            tt_ped_exec_param_aux.tta_raw_param_ped_exec = tt-raw-digita.raw-digita.
                END.

                run btb/btb912zb.p (input-output table tt_param_segur,
                                    input-output table tt_ped_exec,
                                    input table tt_ped_exec_param,
                                    input table tt_ped_exec_param_aux,
                                    input table tt_ped_exec_sel).

                FIND FIRST tt_ped_exec NO-LOCK NO-ERROR.
                IF AVAIL tt_ped_exec THEN DO TRANS:

                    ASSIGN p_num_ped_exec = tt_ped_exec.tta_num_ped_exec.

                    FIND FIRST fat-comercial EXCLUSIVE-LOCK
                         WHERE fat-comercial.num-ped-exec = tt_ped_exec.tta_num_ped_exec
                           AND fat-comercial.nr-pedcli    = c-nr-pedcli  NO-ERROR.

                    IF NOT AVAIL fat-comercial THEN DO:
                        CREATE fat-comercial.                          
                        ASSIGN fat-comercial.nr-sequencia    = 10 
                               fat-comercial.dt-fatura       = TODAY
                               fat-comercial.hr-fatura       = TIME 
                               fat-comercial.nome-abrev      = c-nome-abrev
                               fat-comercial.nr-pedcli       = c-nr-pedcli 
                               fat-comercial.num-ped-exec    = tt_ped_exec.tta_num_ped_exec
                               fat-comercial.tipo            = 1.
                    END. /* IF NOT AVAIL fat-comercial THEN DO: */
                    ELSE DO:
                        ASSIGN fat-comercial.dt-fatura       = TODAY
                               fat-comercial.hr-fatura       = TIME.
                    END.
                    FIND CURRENT fat-comercial   NO-LOCK NO-ERROR.
                    RELEASE fat-comercial.

                END. /* IF AVAIL tt_ped_exec THEN DO: */

            END. /* IF ped-venda.cod-priori = 10 THEN DO: */

        END. /* IF AVAIL ped-venda THEN DO: */
        /***********/
    END. /* IF cReturn <> "NOK" THEN NEXT. */        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCalcula-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCalcula-2 wMasterDetail
ON CHOOSE OF btCalcula-2 IN FRAME fPage0 /* C†lcula Pedidos Selecionados */
DO:

/*     DEFINE VARIABLE i-opcao         AS INTEGER                  NO-UNDO.                                                  */
/*     DEFINE VARIABLE c-nome-abrev    LIKE ped-venda.nome-abrev   NO-UNDO.                                                  */
/*     DEFINE VARIABLE c-nr-pedcli     LIKE ped-venda.nr-pedcli    NO-UNDO.                                                  */
/*     DEFINE VARIABLE h-ft4002        AS HANDLE                   NO-UNDO.                                                  */
/*     DEFINE VARIABLE i-execucao      AS INTEGER                  NO-UNDO.                                                  */
/*     DEFINE VARIABLE i-cont-aux      AS INTEGER                  NO-UNDO.                                                  */
/*     DEFINE VARIABLE c-servidorTela  AS CHARACTER                NO-UNDO.                                                  */
/*     DEFINE VARIABLE c-estab         AS CHARACTER                NO-UNDO.                                                  */
/*                                                                                                                           */
/*     ASSIGN i-faturaSel = 3.                                                                                               */
/*                                                                                                                           */
/*     FOR FIRST mgesp.ponto-programa                                                                                       */
/*         WHERE ponto-programa.nome-programa = "espdp006"                                                                   */
/*           AND ponto-programa.ponto = 12:                                                                                  */
/*                                                                                                                           */
/*         IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK                                                            */
/*             WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa                                       */
/*               AND ENTRY(1,conteudo-programa.conteudo) = v_cod_estab_usuar) THEN DO:                                       */
/*                 MESSAGE "Faturamento Comercial Autom†tico n∆o est† liberado para o estabelecimento " + v_cod_estab_usuar  */
/*                     VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                    */
/*                 RETURN "OK".                                                                                              */
/*         END.                                                                                                              */
/*     END.                                                                                                                  */
/*                                                                                                                           */
/*     RUN pi-limpaTTables.                                                                                                  */
/*                                                                                                                           */
/*     ASSIGN c-nome-abrev     = ttped-venda.nome-abrev:SCREEN-VALUE IN FRAME {&FRAME-NAME}                                  */
/*            c-nr-pedcli      = ttped-venda.nr-pedcli :SCREEN-VALUE IN FRAME {&FRAME-NAME}                                  */
/*            i-execucao       = 2                                                                                           */
/*            p_num_ped_exec   = 0                                                                                           */
/*            c-servidorTela   = c-servidor            :SCREEN-VALUE IN FRAME {&FRAME-NAME}.                                 */
/*                                                                                                                           */
/*     RUN pi-valida-bloqueio-fat (INPUT  c-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME},                                 */
/*                                 OUTPUT c-mensagem).                                                                       */
/*                                                                                                                           */
/*     IF RETURN-VALUE <> "OK" THEN DO:                                                                                      */
/*         RUN utp/ut-msgs.p (INPUT "show":U,                                                                                */
/*                            INPUT 17006,                                                                                   */
/*                            INPUT c-mensagem).                                                                             */
/*         ASSIGN cReturn = "NOK".                                                                                           */
/*         RETURN NO-APPLY.                                                                                                  */
/*     END.                                                                                                                  */
/*                                                                                                                           */
/*     DO TRANSACTION ON ERROR UNDO, LEAVE:                                                                                  */
/*                                                                                                                           */
/*         /*APPLY "choose" TO btFat-2 IN FRAME {&FRAME-NAME}.*/                                                             */
/*                                                                                                                           */
/*         RUN utp/ut-msgs.p (INPUT "Show",                                                                                  */
/*                            INPUT 27100,                                                                                   */
/*                            INPUT "Deseja liberar pedido para Faturamento - Pedidos Selecionados?").                       */
/*                                                                                                                           */
/*                                                                                                                           */
/*         IF cReturn = "NOK" THEN NEXT.                                                                                     */
/*         ELSE DO:                                                                                                          */
/*                                                                                                                           */
/*             /***********/                                                                                                 */
/*             create tt-param.                                                                                              */
/*             assign tt-param.usuario     = c-seg-usuario                                                                   */
/*                    tt-param.destino     = 2                                                                               */
/*                    tt-param.data-exec   = today                                                                           */
/*                    tt-param.hora-exec   = time                                                                            */
/*                                                                                                                           */
/*                    tt-param.nome-abrev  = c-nome-abrev                                                                    */
/*                    tt-param.nr-pedcli   = c-nr-pedcli                                                                     */
/*                    tt-param.Cod-depos   = vCod-depos                                                                      */
/*                    tt-param.Localizacao = IF vLocalizacao = "*" THEN "" ELSE vLocalizacao.                                */
/*                                                                                                                           */
/*             IF OPSYS = "UNIX" THEN                                                                                        */
/*                 ASSIGN tt-param.arquivo = "/opt/totvs/spool/" + c-seg-usuario + "/esftp016rpPedSel_UNIX.tmp".             */
/*             ELSE                                                                                                          */
/*                 ASSIGN tt-param.arquivo = session:temp-directory + c-seg-usuario + "\esftp016rpPedSel_ONLINE.tmp".        */
/*                                                                                                                           */
/*             RAW-TRANSFER tt-param TO raw-param.                                                                           */
/*             FOR each tt-digita NO-LOCK:                                                                                   */
/*                 create tt-raw-digita.                                                                                     */
/*                 raw-transfer tt-digita to tt-raw-digita.raw-digita.                                                       */
/*             END.                                                                                                          */
/*                                                                                                                           */
/*             ASSIGN p_cod_prog_dtsul_w    = "esftp016rpb"                                                                  */
/*                    p_cod_prog_dtsul_rp   = "esp/ftp/esftp016rpb.p"                                                        */
/*                    p_cod_release         = '2.00.00.000'                                                                  */
/*                    p_cdn_estil_dwb       = 97                                                                             */
/*                    p_arquivo             = "esftp016rpPedSel.tmp"                                                         */
/*                    p_destino             = 2                                                                              */
/*                    p_raw_param           = raw-param.                                                                     */
/*                                                                                                                           */
/*             /*IF i-execucao = 2 THEN DO:*/                                                                                */
/*                                                                                                                           */
/*                 create tt_param_segur.                                                                                    */
/*                 assign tt_param_segur.tta_num_vers_integr_api      = 3                                                    */
/*                        tt_param_segur.tta_cod_aplicat_dtsul_corren = "MFT"                                                */
/*                        tt_param_segur.tta_cod_empres_usuar         = string(i-ep-codigo-usuario)                          */
/*                        tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst                                  */
/*                        tt_param_segur.tta_cod_idiom_usuar          = "POR":U                                              */
/*                        tt_param_segur.tta_cod_modul_dtsul_corren   = "MFT"                                                */
/*                        tt_param_segur.tta_cod_pais_empres_usuar    = "BRA"                                                */
/*                        tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren                                   */
/*                        tt_param_segur.tta_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog.                          */
/*                                                                                                                           */
/*                 create tt_ped_exec.                                                                                       */
/*                 assign tt_ped_exec.tta_num_seq                = 1                                                         */
/*                        tt_ped_exec.tta_cod_usuario            = v_cod_usuar_corren                                        */
/*                        tt_ped_exec.tta_cod_prog_dtsul         = p_cod_prog_dtsul_w                                        */
/*                        tt_ped_exec.tta_cod_prog_dtsul_rp      = p_cod_prog_dtsul_rp                                       */
/*                        tt_ped_exec.tta_cod_release_prog_dtsul = p_cod_release                                             */
/*                        tt_ped_exec.tta_dat_exec_ped_exec      = today                                                     */
/*                        tt_ped_exec.tta_hra_exec_ped_exec      = replace(string(time,"HH:MM:SS"), ":", "")                 */
/*                        tt_ped_exec.tta_cod_servid_exec        = c-servidorTela                                            */
/*                        tt_ped_exec.tta_cdn_estil_dwb          = 97.                                                       */
/*                                                                                                                           */
/*                 create tt_ped_exec_param.                                                                                 */
/*                 assign tt_ped_exec_param.tta_num_seq              = 1                                                     */
/*                        tt_ped_exec_param.tta_cod_dwb_file         = "ftp/esftp016rp.p"                                    */
/*                        tt_ped_exec_param.tta_cod_dwb_output       = 'Arquivo'                                             */
/*                        tt_ped_exec_param.tta_nom_dwb_printer      = p_arquivo.                                            */
/*                                                                                                                           */
/*                 raw-transfer tt-param       to tt_ped_exec_param.tta_raw_param_ped_exec.                                  */
/*                                                                                                                           */
/*                 ASSIGN i-cont-aux = 0.                                                                                    */
/*                 FOR EACH tt-raw-digita NO-LOCK:                                                                           */
/*                      ASSIGN i-cont-aux = i-cont-aux + 1.                                                                  */
/*                      CREATE tt_ped_exec_param_aux.                                                                        */
/*                      ASSIGN tt_ped_exec_param_aux.tta_num_dwb_order      = i-cont-aux                                     */
/*                             tt_ped_exec_param_aux.tta_num_seq            = 1                                              */
/*                             tt_ped_exec_param_aux.tta_raw_param_ped_exec = tt-raw-digita.raw-digita.                      */
/*                 END.                                                                                                      */
/*                                                                                                                           */
/*                 run btb/btb912zb.p (input-output table tt_param_segur,                                                    */
/*                                     input-output table tt_ped_exec,                                                       */
/*                                     input table tt_ped_exec_param,                                                        */
/*                                     input table tt_ped_exec_param_aux,                                                    */
/*                                     input table tt_ped_exec_sel).                                                         */
/*                                                                                                                           */
/*                 FIND FIRST tt_ped_exec NO-LOCK NO-ERROR.                                                                  */
/*                 IF AVAIL tt_ped_exec THEN DO:                                                                             */
/*                                                                                                                           */
/*                     ASSIGN p_num_ped_exec = tt_ped_exec.tta_num_ped_exec.                                                 */
/*                                                                                                                           */
/*                     FOR EACH fat-comercial                                                                                */
/*                         WHERE  fat-comercial.num-ped-exec    = 2229                                                       */
/*                           AND  fat-comercial.nr-sequencia    = 99 EXCLUSIVE-LOCK .                                        */
/*                                                                                                                           */
/*                         IF fat-comercial.c-status = c-seg-usuario THEN                                                    */
/*                             ASSIGN fat-comercial.num-ped-exec = p_num_ped_exec                                            */
/*                                    fat-comercial.c-status     = ''.                                                       */
/*                                                                                                                           */
/*                     END. /* IF NOT AVAIL fat-comercial THEN DO: */                                                        */
/*                     FIND CURRENT fat-comercial   NO-LOCK NO-ERROR.                                                        */
/*                     RELEASE fat-comercial.                                                                                */
/*                                                                                                                           */
/*                 END. /* IF AVAIL tt_ped_exec THEN DO: */                                                                  */
/*                                                                                                                           */
/*                                                                                                                           */
/*             /*END. /* IF i-execucao = 2 THEN DO: */*/                                                                     */
/*                                                                                                                           */
/*             /***********/                                                                                                 */
/*                                                                                                                           */
/*         END. /* IF cReturn <> "NOK" THEN NEXT. */                                                                         */
/*                                                                                                                           */
/*     END. /* DO TRANSACTION ON ERROR UNDO, LEAVE: */                                                                       */
/*                                                                                                                           */
/* ASSIGN i-faturaSel = 0.                                                                                                   */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConsulta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConsulta wMasterDetail
ON CHOOSE OF btConsulta IN FRAME fPage0 /* Consulta */
DO:
    RUN esp/ftp/esftp025.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDesaloca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesaloca wMasterDetail
ON CHOOSE OF btDesaloca IN FRAME fPage1 /* Desaloca Tudo */
DO:
    
    RUN pi-desaloca-tudo.    
    
    {&OPEN-QUERY-brSon1}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    RUN retornaOK.

    APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExtra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExtra wMasterDetail
ON CHOOSE OF btExtra IN FRAME fPage0 /* Informaá‰es Adicionais */
DO:
    IF  AVAIL ttped-venda THEN
        RUN esp/pdp/espdp006c.w (INPUT ttped-venda.nr-pedido).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFat wMasterDetail
ON CHOOSE OF btFat IN FRAME fPage0 /* Fat */
DO:
    /*RUN pi-valida-reservas.
    IF RETURN-VALUE <> "OK" THEN DO:
        ASSIGN cReturn = "NOK".                
        RETURN NO-APPLY.  
    END.*/

    ASSIGN i-faturaSel = 2.

    IF (ttped-venda.cod-priori:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '07') THEN DO:
        FIND FIRST mgesp.ponto-programa NO-LOCK
            WHERE ponto-programa.nome-programa = "pd4000"
              AND ponto-programa.ponto         = 7 NO-ERROR.
        IF AVAIL mgesp.ponto-programa THEN DO:
            IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK
                    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                      AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 17006, 
                                   INPUT "Pedido est† sendo faturado.~~Aguarde o mesmo ser liberado.").
                ASSIGN cReturn = "NOK".                
                RETURN NO-APPLY.  
            END. /* IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK */
        END. /* IF AVAIL mgesp.ponto-programa THEN DO: */
    END.

    OS-CREATE-DIR VALUE(session:temp-directory + c-seg-usuario).

    RUN pi-valida-bloqueio-fat (INPUT  c-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                OUTPUT c-mensagem).

    IF RETURN-VALUE <> "OK" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17006, 
                           INPUT c-mensagem).
        ASSIGN cReturn = "NOK".                
        RETURN NO-APPLY.
    END.

    IF AVAIL ttped-venda THEN DO:
        FOR EACH mgesp.ponto-programa NO-LOCK
            WHERE ponto-programa.nome-programa = "espdp006"
              AND ponto-programa.ponto         = 10,  
             EACH mgesp.conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
    
            IF  ttped-venda.tp-pedido >= entry(1,conteudo-programa.conteudo, ";")     AND
                ttped-venda.tp-pedido <= entry(2,conteudo-programa.conteudo, ";") THEN DO:

                IF entry(4,conteudo-programa.conteudo, ";") = '' THEN DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Existe execuá∆o de Alocaá∆o Autom†tica para atendente do pedido, usuario : " +  entry(3,conteudo-programa.conteudo, ";") ).     

                    ASSIGN cReturn = "NOK".                
                    RETURN NO-APPLY.
                END.
                ELSE DO:
                    IF vUnid-Neg = entry(4,conteudo-programa.conteudo, ";") THEN DO:
                        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Existe execuá∆o de Alocaá∆o Autom†tica para atendente do pedido, usuario : " +  entry(3,conteudo-programa.conteudo, ";") + ' - Unid Neg ' +  entry(4,conteudo-programa.conteudo, ";") ).     

                        ASSIGN cReturn = "NOK".                
                        RETURN NO-APPLY.
                    END.
                END.
            
            END.
        END.

        FIND FIRST int-emitente
            WHERE int-emitente.cod-emitente = ttped-venda.cod-emitente NO-LOCK NO-ERROR.

        FIND emitente
            WHERE emitente.cod-emitente = ttped-venda.cod-emitente NO-LOCK NO-ERROR.

        IF AVAIL emitente and
           emitente.cod-gr-cli <> 8 AND
           emitente.cod-gr-cli <> 9 and
           emitente.cod-gr-cli <> 10 and
           emitente.cod-gr-cli <> 15 and
           emitente.cod-gr-cli <> 16 AND
           ttped-venda.nat-operacao <> "694924" AND
           ttped-venda.nat-operacao <> "594934" THEN DO:
            IF AVAILABLE int-emitente     AND
               NOT int-emitente.id-ativo THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Cliente Inativo. Imposs°vel liberar para faturamento":U).
                ASSIGN cReturn = "NOK".                
                RETURN NO-APPLY.
            END.
        END.

        FOR FIRST mgesp.ponto-programa
            WHERE ponto-programa.nome-programa = "espdp006"
              AND ponto-programa.ponto         = 1,   /* Centrais Embratel */
             EACH mgesp.conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
              AND conteudo-programa.sequencia = int(ttped-venda.tp-pedido):
            IF INDEX(conteudo-programa.conteudo,c-seg-usuario) = 0 THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                               INPUT 17006, 
                                               INPUT "Permiss∆o para alocaá∆o do pedido restrita, somente estes usuarios podem alocar: " + conteudo-programa.conteudo).
                ASSIGN cReturn = "NOK".                
                UNDO, LEAVE.   
            END.
        end.


        RUN pi-prefatur.    

        IF    (PROGRAM-NAME(1) MATCHES '*espdp005*'
            OR PROGRAM-NAME(2) MATCHES '*espdp005*'
            OR PROGRAM-NAME(3) MATCHES '*espdp005*'
            OR PROGRAM-NAME(4) MATCHES '*espdp005*'
            OR PROGRAM-NAME(5) MATCHES '*espdp005*' 
            OR PROGRAM-NAME(6) MATCHES '*espdp005'
            OR PROGRAM-NAME(7) MATCHES '*espdp005*'
            OR PROGRAM-NAME(8) MATCHES '*espdp005*'
            OR PROGRAM-NAME(9) MATCHES '*espdp005*'
            OR PROGRAM-NAME(10) MATCHES '*espdp005*'
            OR PROGRAM-NAME(1) MATCHES '*espdp003*'
            OR PROGRAM-NAME(2) MATCHES '*espdp003*'
            OR PROGRAM-NAME(3) MATCHES '*espdp003*'
            OR PROGRAM-NAME(4) MATCHES '*espdp003*'
            OR PROGRAM-NAME(5) MATCHES '*espdp003*' 
            OR PROGRAM-NAME(6) MATCHES '*espdp003'
            OR PROGRAM-NAME(7) MATCHES '*espdp003*'
            OR PROGRAM-NAME(8) MATCHES '*espdp003*'
            OR PROGRAM-NAME(9) MATCHES '*espdp003*'
            OR PROGRAM-NAME(10) MATCHES '*espdp003*') AND
            gr-ped-venda-espdp003 <> ? THEN DO:
            for FIRST mgesp.ponto-programa
                where ponto-programa.nome-programa = "espdp005"
                  AND ponto-programa.ponto = 1,
                 EACH mgesp.conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
                IF ENTRY(1,conteudo-programa.conteudo) = v_cod_usuar_corren THEN DO:
                    APPLY "choose" TO btExit IN FRAME {&FRAME-NAME}.
                    LEAVE.
                END.
            END.
        END.
        ELSE DO:
            APPLY "entry" TO brson1 IN FRAME fpage1.
        END.
    END.    
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFat-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFat-2 wMasterDetail
ON CHOOSE OF btFat-2 IN FRAME fPage0 /* Fat */
DO: 

/*     FIND FIRST ttped-venda                                                                                                                                                                                                          */
/*          WHERE ttped-venda.nr-pedcli  = ttped-venda.nr-pedcli :SCREEN-VALUE IN FRAME {&FRAME-NAME}                                                                                                                                  */
/*            AND ttped-venda.nome-abrev = ttped-venda.nome-abrev:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.                                                                                                                        */
/*                                                                                                                                                                                                                                     */
/*     IF (ttped-venda.cod-priori:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '07') THEN DO:                                                                                                                                                 */
/*         FIND FIRST mgesp.ponto-programa NO-LOCK                                                                                                                                                                                    */
/*             WHERE ponto-programa.nome-programa = "pd4000"                                                                                                                                                                           */
/*               AND ponto-programa.ponto         = 7 NO-ERROR.                                                                                                                                                                        */
/*         IF AVAIL mgesp.ponto-programa THEN DO:                                                                                                                                                                                     */
/*             IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK                                                                                                                                                                  */
/*                     WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa                                                                                                                                              */
/*                       AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:                                                                                                                                                  */
/*                 RUN utp/ut-msgs.p (INPUT "show":U,                                                                                                                                                                                  */
/*                                    INPUT 17006,                                                                                                                                                                                     */
/*                                    INPUT "Pedido est† sendo faturado.~~Aguarde o mesmo ser liberado.").                                                                                                                             */
/*                 ASSIGN cReturn = "NOK".                                                                                                                                                                                             */
/*                 RETURN NO-APPLY.                                                                                                                                                                                                    */
/*             END. /* IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK */                                                                                                                                                       */
/*         END. /* IF AVAIL mgesp.ponto-programa THEN DO: */                                                                                                                                                                          */
/*     END.                                                                                                                                                                                                                            */
/*                                                                                                                                                                                                                                     */
/*     OS-CREATE-DIR VALUE(session:temp-directory + c-seg-usuario).                                                                                                                                                                    */
/*                                                                                                                                                                                                                                     */
/*     RUN pi-valida-bloqueio-fat (INPUT  c-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME},                                                                                                                                           */
/*                                 OUTPUT c-mensagem).                                                                                                                                                                                 */
/*                                                                                                                                                                                                                                     */
/*     IF RETURN-VALUE <> "OK" THEN DO:                                                                                                                                                                                                */
/*         RUN utp/ut-msgs.p (INPUT "show":U,                                                                                                                                                                                          */
/*                            INPUT 17006,                                                                                                                                                                                             */
/*                            INPUT c-mensagem).                                                                                                                                                                                       */
/*         ASSIGN cReturn = "NOK".                                                                                                                                                                                                     */
/*         RETURN NO-APPLY.                                                                                                                                                                                                            */
/*     END.                                                                                                                                                                                                                            */
/*                                                                                                                                                                                                                                     */
/*     IF AVAIL ttped-venda THEN DO:                                                                                                                                                                                                   */
/*         FOR EACH mgesp.ponto-programa NO-LOCK                                                                                                                                                                                      */
/*             WHERE ponto-programa.nome-programa = "espdp006"                                                                                                                                                                         */
/*               AND ponto-programa.ponto         = 10,                                                                                                                                                                                */
/*              EACH mgesp.conteudo-programa NO-LOCK                                                                                                                                                                                  */
/*             WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:                                                                                                                                                     */
/*                                                                                                                                                                                                                                     */
/*             IF  ttped-venda.tp-pedido >= entry(1,conteudo-programa.conteudo, ";")     AND                                                                                                                                           */
/*                 ttped-venda.tp-pedido <= entry(2,conteudo-programa.conteudo, ";") THEN DO:                                                                                                                                          */
/*                                                                                                                                                                                                                                     */
/*                 IF entry(4,conteudo-programa.conteudo, ";") = '' THEN DO:                                                                                                                                                           */
/*                     RUN utp/ut-msgs.p (INPUT "SHOW":U,                                                                                                                                                                              */
/*                                INPUT 17006,                                                                                                                                                                                         */
/*                                INPUT "Existe execuá∆o de Alocaá∆o Autom†tica para atendente do pedido, usuario : " +  entry(3,conteudo-programa.conteudo, ";") ).                                                                   */
/*                                                                                                                                                                                                                                     */
/*                     ASSIGN cReturn = "NOK".                                                                                                                                                                                         */
/*                     RETURN NO-APPLY.                                                                                                                                                                                                */
/*                 END.                                                                                                                                                                                                                */
/*                 ELSE DO:                                                                                                                                                                                                            */
/*                     IF vUnid-Neg = entry(4,conteudo-programa.conteudo, ";") THEN DO:                                                                                                                                                */
/*                         RUN utp/ut-msgs.p (INPUT "SHOW":U,                                                                                                                                                                          */
/*                                    INPUT 17006,                                                                                                                                                                                     */
/*                                    INPUT "Existe execuá∆o de Alocaá∆o Autom†tica para atendente do pedido, usuario : " +  entry(3,conteudo-programa.conteudo, ";") + ' - Unid Neg ' +  entry(4,conteudo-programa.conteudo, ";") ).  */
/*                                                                                                                                                                                                                                     */
/*                         ASSIGN cReturn = "NOK".                                                                                                                                                                                     */
/*                         RETURN NO-APPLY.                                                                                                                                                                                            */
/*                     END.                                                                                                                                                                                                            */
/*                 END.                                                                                                                                                                                                                */
/*                                                                                                                                                                                                                                     */
/*             END.                                                                                                                                                                                                                    */
/*         END.                                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                     */
/*         FIND FIRST int-emitente                                                                                                                                                                                                     */
/*             WHERE int-emitente.cod-emitente = ttped-venda.cod-emitente NO-LOCK NO-ERROR.                                                                                                                                            */
/*                                                                                                                                                                                                                                     */
/*         FIND emitente                                                                                                                                                                                                               */
/*             WHERE emitente.cod-emitente = ttped-venda.cod-emitente NO-LOCK NO-ERROR.                                                                                                                                                */
/*                                                                                                                                                                                                                                     */
/*         IF AVAIL emitente and                                                                                                                                                                                                       */
/*            emitente.cod-gr-cli <> 8 AND                                                                                                                                                                                             */
/*            emitente.cod-gr-cli <> 9 and                                                                                                                                                                                             */
/*            emitente.cod-gr-cli <> 10 and                                                                                                                                                                                            */
/*            emitente.cod-gr-cli <> 15 and                                                                                                                                                                                            */
/*            emitente.cod-gr-cli <> 16 AND                                                                                                                                                                                            */
/*            ttped-venda.nat-operacao <> "694924" AND                                                                                                                                                                                 */
/*            ttped-venda.nat-operacao <> "594934" THEN DO:                                                                                                                                                                            */
/*             IF AVAILABLE int-emitente     AND                                                                                                                                                                                       */
/*                NOT int-emitente.id-ativo THEN DO:                                                                                                                                                                                   */
/*                 RUN utp/ut-msgs.p (INPUT "SHOW":U,                                                                                                                                                                                  */
/*                                    INPUT 17006,                                                                                                                                                                                     */
/*                                    INPUT "Cliente Inativo. Imposs°vel liberar para faturamento":U).                                                                                                                                 */
/*                 ASSIGN cReturn = "NOK".                                                                                                                                                                                             */
/*                 RETURN NO-APPLY.                                                                                                                                                                                                    */
/*             END.                                                                                                                                                                                                                    */
/*         END.                                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                     */
/*         FOR FIRST mgesp.ponto-programa                                                                                                                                                                                             */
/*             WHERE ponto-programa.nome-programa = "espdp006"                                                                                                                                                                         */
/*               AND ponto-programa.ponto         = 1,   /* Centrais Embratel */                                                                                                                                                       */
/*              EACH mgesp.conteudo-programa NO-LOCK                                                                                                                                                                                  */
/*             WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa                                                                                                                                                      */
/*               AND conteudo-programa.sequencia = int(ttped-venda.tp-pedido):                                                                                                                                                         */
/*             IF INDEX(conteudo-programa.conteudo,c-seg-usuario) = 0 THEN DO:                                                                                                                                                         */
/*                 RUN utp/ut-msgs.p (INPUT "show":U,                                                                                                                                                                                  */
/*                                                INPUT 17006,                                                                                                                                                                         */
/*                                                INPUT "Permiss∆o para alocaá∆o do pedido restrita, somente estes usuarios podem alocar: " + conteudo-programa.conteudo).                                                             */
/*                 ASSIGN cReturn = "NOK".                                                                                                                                                                                             */
/*                 UNDO, LEAVE.                                                                                                                                                                                                        */
/*             END.                                                                                                                                                                                                                    */
/*         end.                                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                     */
/*         RUN pi-prefatur.                                                                                                                                                                                                            */
/*                                                                                                                                                                                                                                     */
/*         IF    (PROGRAM-NAME(1) MATCHES '*espdp005*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(2) MATCHES '*espdp005*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(3) MATCHES '*espdp005*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(4) MATCHES '*espdp005*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(5) MATCHES '*espdp005*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(6) MATCHES '*espdp005'                                                                                                                                                                                  */
/*             OR PROGRAM-NAME(7) MATCHES '*espdp005*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(8) MATCHES '*espdp005*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(9) MATCHES '*espdp005*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(10) MATCHES '*espdp005*'                                                                                                                                                                                */
/*             OR PROGRAM-NAME(1) MATCHES '*espdp003*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(2) MATCHES '*espdp003*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(3) MATCHES '*espdp003*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(4) MATCHES '*espdp003*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(5) MATCHES '*espdp003*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(6) MATCHES '*espdp003'                                                                                                                                                                                  */
/*             OR PROGRAM-NAME(7) MATCHES '*espdp003*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(8) MATCHES '*espdp003*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(9) MATCHES '*espdp003*'                                                                                                                                                                                 */
/*             OR PROGRAM-NAME(10) MATCHES '*espdp003*') AND                                                                                                                                                                           */
/*             gr-ped-venda-espdp003 <> ? THEN DO:                                                                                                                                                                                     */
/*             for FIRST mgesp.ponto-programa                                                                                                                                                                                         */
/*                 where ponto-programa.nome-programa = "espdp005"                                                                                                                                                                     */
/*                   AND ponto-programa.ponto = 1,                                                                                                                                                                                     */
/*                  EACH mgesp.conteudo-programa NO-LOCK                                                                                                                                                                              */
/*                 WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:                                                                                                                                                 */
/*                 IF ENTRY(1,conteudo-programa.conteudo) = v_cod_usuar_corren THEN DO:                                                                                                                                                */
/*                     APPLY "choose" TO btExit IN FRAME {&FRAME-NAME}.                                                                                                                                                                */
/*                     LEAVE.                                                                                                                                                                                                          */
.
.
.
.
.
.
.
.
.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFaturaTodosPedSel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFaturaTodosPedSel wMasterDetail
ON CHOOSE OF btFaturaTodosPedSel IN FRAME fPage0 /* Fatura Todos */
DO:


/*     DEFINE VARIABLE i-opcao         AS INTEGER                  NO-UNDO.                                                  */
/*     DEFINE VARIABLE c-nome-abrev    LIKE ped-venda.nome-abrev   NO-UNDO.                                                  */
/*     DEFINE VARIABLE c-nr-pedcli     LIKE ped-venda.nr-pedcli    NO-UNDO.                                                  */
/*     DEFINE VARIABLE h-ft4002        AS HANDLE                   NO-UNDO.                                                  */
/*     DEFINE VARIABLE i-execucao      AS INTEGER                  NO-UNDO.                                                  */
/*     DEFINE VARIABLE i-cont-aux      AS INTEGER                  NO-UNDO.                                                  */
/*     DEFINE VARIABLE c-servidorTela  AS CHARACTER                NO-UNDO.                                                  */
/*     DEFINE VARIABLE c-estab         AS CHARACTER                NO-UNDO.                                                  */
/*                                                                                                                           */
/*     ASSIGN i-faturaSel = 3.                                                                                               */
/*                                                                                                                           */
/*     FOR FIRST mgesp.ponto-programa                                                                                       */
/*         WHERE ponto-programa.nome-programa = "espdp006"                                                                   */
/*           AND ponto-programa.ponto = 12:                                                                                  */
/*                                                                                                                           */
/*         IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK                                                            */
/*             WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa                                       */
/*               AND ENTRY(1,conteudo-programa.conteudo) = v_cod_estab_usuar) THEN DO:                                       */
/*                 MESSAGE "Faturamento Comercial Autom†tico n∆o est† liberado para o estabelecimento " + v_cod_estab_usuar  */
/*                     VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                    */
/*                 RETURN "OK".                                                                                              */
/*         END.                                                                                                              */
/*     END.                                                                                                                  */
/*                                                                                                                           */
/*     RUN pi-limpaTTables.                                                                                                  */
/*                                                                                                                           */
/*     ASSIGN c-nome-abrev     = ttped-venda.nome-abrev:SCREEN-VALUE IN FRAME {&FRAME-NAME}                                  */
/*            c-nr-pedcli      = ttped-venda.nr-pedcli :SCREEN-VALUE IN FRAME {&FRAME-NAME}                                  */
/*            i-execucao       = 2                                                                                           */
/*            p_num_ped_exec   = 0                                                                                           */
/*            c-servidorTela   = c-servidor            :SCREEN-VALUE IN FRAME {&FRAME-NAME}.                                 */
/*                                                                                                                           */
/*     RUN pi-valida-bloqueio-fat (INPUT  c-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME},                                 */
/*                                 OUTPUT c-mensagem).                                                                       */
/*                                                                                                                           */
/*     IF RETURN-VALUE <> "OK" THEN DO:                                                                                      */
/*         RUN utp/ut-msgs.p (INPUT "show":U,                                                                                */
/*                            INPUT 17006,                                                                                   */
/*                            INPUT c-mensagem).                                                                             */
/*         ASSIGN cReturn = "NOK".                                                                                           */
/*         RETURN NO-APPLY.                                                                                                  */
/*     END.                                                                                                                  */
/*                                                                                                                           */
/*     DO TRANSACTION ON ERROR UNDO, LEAVE:                                                                                  */
/*                                                                                                                           */
/*         /*APPLY "choose" TO btFat-2 IN FRAME {&FRAME-NAME}.*/                                                             */
/*                                                                                                                           */
/*         RUN utp/ut-msgs.p (INPUT "Show",                                                                                  */
/*                            INPUT 27100,                                                                                   */
/*                            INPUT "Deseja liberar pedido para Faturamento - Pedidos Selecionados?").                       */
/*                                                                                                                           */
/*                                                                                                                           */
/*         IF cReturn = "NOK" THEN NEXT.                                                                                     */
/*         ELSE DO:                                                                                                          */
/*                                                                                                                           */
/*             /***********/                                                                                                 */
/*             create tt-param.                                                                                              */
/*             assign tt-param.usuario     = c-seg-usuario                                                                   */
/*                    tt-param.destino     = 2                                                                               */
/*                    tt-param.data-exec   = today                                                                           */
/*                    tt-param.hora-exec   = time                                                                            */
/*                                                                                                                           */
/*                    tt-param.nome-abrev  = c-nome-abrev                                                                    */
/*                    tt-param.nr-pedcli   = c-nr-pedcli                                                                     */
/*                    tt-param.Cod-depos   = vCod-depos                                                                      */
/*                    tt-param.Localizacao = IF vLocalizacao = "*" THEN "" ELSE vLocalizacao.                                */
/*                                                                                                                           */
/*             IF OPSYS = "UNIX" THEN                                                                                        */
/*                 ASSIGN tt-param.arquivo = "/opt/totvs/spool/" + c-seg-usuario + "/esftp016rpPedSel_UNIX.tmp".             */
/*             ELSE                                                                                                          */
/*                 ASSIGN tt-param.arquivo = session:temp-directory + c-seg-usuario + "\esftp016rpPedSel_ONLINE.tmp".        */
/*                                                                                                                           */
/*             RAW-TRANSFER tt-param TO raw-param.                                                                           */
/*             FOR each tt-digita NO-LOCK:                                                                                   */
/*                 create tt-raw-digita.                                                                                     */
/*                 raw-transfer tt-digita to tt-raw-digita.raw-digita.                                                       */
/*             END.                                                                                                          */
/*                                                                                                                           */
/*             ASSIGN p_cod_prog_dtsul_w    = "esftp016rpb"                                                                  */
/*                    p_cod_prog_dtsul_rp   = "esp/ftp/esftp016rpb.p"                                                        */
/*                    p_cod_release         = '2.00.00.000'                                                                  */
/*                    p_cdn_estil_dwb       = 97                                                                             */
/*                    p_arquivo             = "esftp016rpPedSel.tmp"                                                         */
/*                    p_destino             = 2                                                                              */
/*                    p_raw_param           = raw-param.                                                                     */
/*                                                                                                                           */
/*                                                                                                                           */
/*                                                                                                                           */
/*             create tt_param_segur.                                                                                        */
/*             assign tt_param_segur.tta_num_vers_integr_api      = 3                                                        */
/*                    tt_param_segur.tta_cod_aplicat_dtsul_corren = "MFT"                                                    */
/*                    tt_param_segur.tta_cod_empres_usuar         = string(i-ep-codigo-usuario)                              */
/*                    tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst                                      */
/*                    tt_param_segur.tta_cod_idiom_usuar          = "POR":U                                                  */
/*                    tt_param_segur.tta_cod_modul_dtsul_corren   = "MFT"                                                    */
/*                    tt_param_segur.tta_cod_pais_empres_usuar    = "BRA"                                                    */
/*                    tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren                                       */
/*                    tt_param_segur.tta_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog.                              */
/*                                                                                                                           */
/*             create tt_ped_exec.                                                                                           */
/*             assign tt_ped_exec.tta_num_seq                = 1                                                             */
/*                    tt_ped_exec.tta_cod_usuario            = v_cod_usuar_corren                                            */
/*                    tt_ped_exec.tta_cod_prog_dtsul         = p_cod_prog_dtsul_w                                            */
/*                    tt_ped_exec.tta_cod_prog_dtsul_rp      = p_cod_prog_dtsul_rp                                           */
/*                    tt_ped_exec.tta_cod_release_prog_dtsul = p_cod_release                                                 */
/*                    tt_ped_exec.tta_dat_exec_ped_exec      = today                                                         */
/*                    tt_ped_exec.tta_hra_exec_ped_exec      = replace(string(time,"HH:MM:SS"), ":", "")                     */
/*                    tt_ped_exec.tta_cod_servid_exec        = c-servidorTela                                                */
/*                    tt_ped_exec.tta_cdn_estil_dwb          = 97.                                                           */
/*                                                                                                                           */
/*             create tt_ped_exec_param.                                                                                     */
/*             assign tt_ped_exec_param.tta_num_seq              = 1                                                         */
/*                    tt_ped_exec_param.tta_cod_dwb_file         = "ftp/esftp016rp.p"                                        */
/*                    tt_ped_exec_param.tta_cod_dwb_output       = 'Arquivo'                                                 */
/*                    tt_ped_exec_param.tta_nom_dwb_printer      = p_arquivo.                                                */
/*                                                                                                                           */
/*             raw-transfer tt-param       to tt_ped_exec_param.tta_raw_param_ped_exec.                                      */
/*                                                                                                                           */
/*             ASSIGN i-cont-aux = 0.                                                                                        */
/*             FOR EACH tt-raw-digita NO-LOCK:                                                                               */
/*                  ASSIGN i-cont-aux = i-cont-aux + 1.                                                                      */
/*                  CREATE tt_ped_exec_param_aux.                                                                            */
/*                  ASSIGN tt_ped_exec_param_aux.tta_num_dwb_order      = i-cont-aux                                         */
/*                         tt_ped_exec_param_aux.tta_num_seq            = 1                                                  */
/*                         tt_ped_exec_param_aux.tta_raw_param_ped_exec = tt-raw-digita.raw-digita.                          */
/*             END.                                                                                                          */
/*                                                                                                                           */
/*             run btb/btb912zb.p (input-output table tt_param_segur,                                                        */
/*                                 input-output table tt_ped_exec,                                                           */
/*                                 input table tt_ped_exec_param,                                                            */
/*                                 input table tt_ped_exec_param_aux,                                                        */
/*                                 input table tt_ped_exec_sel).                                                             */
/*                                                                                                                           */
/*             FIND FIRST tt_ped_exec NO-LOCK NO-ERROR.                                                                      */
/*             IF AVAIL tt_ped_exec THEN DO:                                                                                 */
/*                                                                                                                           */
/*                 ASSIGN p_num_ped_exec = tt_ped_exec.tta_num_ped_exec.                                                     */
/*                                                                                                                           */
/*                 FIND FIRST fat-comercial                                                                                  */
/*                     WHERE  fat-comercial.num-ped-exec    = p_num_ped_exec                                                 */
/*                       AND  fat-comercial.nr-pedcli       = c-nr-pedcli                                                    */
/*                       AND  fat-comercial.nr-sequencia    = 99 NO-LOCK NO-ERROR.                                           */
/*                 IF AVAIL fat-comercial THEN DO:                                                                           */
/*                     ASSIGN fat-comercial.num-ped-exec    = p_num_ped_exec                                                 */
/*                            fat-comercial.tipo            = 3.                                                             */
/*                 END. /* IF NOT AVAIL fat-comercial THEN DO: */                                                            */
/*                 FIND CURRENT fat-comercial   NO-LOCK NO-ERROR.                                                            */
/*                 RELEASE fat-comercial.                                                                                    */
/*                                                                                                                           */
/*             END. /* IF AVAIL tt_ped_exec THEN DO: */                                                                      */
/*         END. /* IF cReturn <> "NOK" THEN NEXT. */                                                                         */
/*     END. /* DO TRANSACTION ON ERROR UNDO, LEAVE: */                                                                       */
/*                                                                                                                           */
/* ASSIGN i-faturaSel = 0.                                                                                                   */
/*                                                                                                                           */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.

    IF NOT AVAIL ttped-item THEN RETURN NO-APPLY.    
    ELSE
        APPLY "Entry" TO ttPed-item.qt-log-aloca IN BROWSE brSon1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
    IF NOT AVAIL ttped-item THEN RETURN NO-APPLY.    
    ELSE
        APPLY "Entry" TO ttPed-item.qt-log-aloca IN BROWSE brSon1.
        {&OPEN-QUERY-brSaldo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
  
    IF NOT AVAIL ttped-item THEN RETURN NO-APPLY.    
    ELSE
        APPLY "Entry" TO ttPed-item.qt-log-aloca IN BROWSE brSon1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLimite
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLimite wMasterDetail
ON CHOOSE OF btLimite IN FRAME fPage0 /* Calcula Limiter */
DO:
    DEFINE VARIABLE h-esapi001                as handle    NO-UNDO.
    DEFINE VARIABLE de-vl-lim-total-supcard   as decimal   NO-UNDO.
    DEFINE VARIABLE de-vl-lim-tot-supcard     as decimal   NO-UNDO.
    DEFINE VARIABLE de-vl-lim-dispo-supcard   as decimal   NO-UNDO.
    DEFINE VARIABLE de-vl-lim-total-intelbras as decimal   NO-UNDO.
    DEFINE VARIABLE de-vl-lim-dispo-intelbras as decimal   NO-UNDO.
    DEFINE VARIABLE de-vl-aloc-pedido         as decimal   NO-UNDO.
    DEFINE VARIABLE de-vl-comp-nfs            as decimal   NO-UNDO.
    
    IF AVAIL ttPed-venda THEN DO:

        /* O limite de crÇdito fica gravado na Matriz do cliente */
        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = ttPed-venda.cod-emitente NO-ERROR.
        IF AVAIL emitente THEN DO:

            IF NOT VALID-HANDLE(h-esapi001) THEN
                RUN esp/esapi001.p PERSISTENT SET h-esapi001.

            IF VALID-HANDLE(h-esapi001) THEN DO:
                RUN pi-saldo-raiz-cnpj IN h-esapi001 (INPUT  SUBSTRING(emitente.cgc, 1, 8),
                                                      OUTPUT de-vl-lim-total-supcard,
                                                      OUTPUT de-vl-lim-tot-supcard,
                                                      OUTPUT de-vl-aloc-pedido,
                                                      OUTPUT de-vl-comp-nfs,
                                                      OUTPUT de-vl-lim-dispo-supcard).
            END.

            IF RETURN-VALUE = "nok":U THEN DO:
                ASSIGN de-vl-lim-total-supcard = 0
                       de-vl-lim-tot-supcard   = 0
                       de-vl-lim-dispo-supcard = 0.
            END.

            DELETE PROCEDURE h-esapi001.
                ASSIGN h-esapi001 = ?.

            FIND FIRST bf-emitente no-lock
                 where bf-emitente.nome-abrev = emitente.nome-matriz NO-ERROR.

            ASSIGN de-vl-lim-total-intelbras = IF AVAIL bf-emitente THEN bf-emitente.lim-credito ELSE emitente.lim-credito.

            RUN pi-lim-disp-intelbras (INPUT  emitente.cod-emitente,
                                       OUTPUT de-vl-lim-dispo-intelbras).

            ASSIGN de-vl-lim-dispo-intelbras = de-vl-lim-total-intelbras - de-vl-lim-dispo-intelbras.

            IF de-vl-lim-dispo-intelbras < 0 THEN DO:
                ASSIGN de-vl-lim-dispo-intelbras = 0.
            END.

            ASSIGN de-LimIntelbras     :SCREEN-VALUE IN FRAME fPage0 = string(de-vl-lim-dispo-intelbras)
                   de-LimIntelbrasClube:SCREEN-VALUE IN FRAME fPage0 = string(de-vl-lim-dispo-supcard).
                   
            /* In°cio - Busca limite disponivel do DEPS */
            FIND FIRST int-emitente NO-LOCK
                 WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

            IF  AVAIL int-emitente THEN DO:
                EMPTY TEMP-TABLE tt-prog-ponto.
                RUN esp/es0018p.p (INPUT "dps-canal-vd",
                                   INPUT 1,
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        
                IF  CAN-FIND (FIRST tt-prog-ponto
                                 WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN DO:
    
                    EMPTY TEMP-TABLE msg0312r1-DadosCliente.
        
                    RUN esp/esb/out/msg0312.p (INPUT emitente.cod-emitente,
                                               OUTPUT TABLE msg0312r1-DadosCliente,
                                               OUTPUT TABLE resultado).
        
                    FIND FIRST msg0312r1-DadosCliente NO-LOCK NO-ERROR.

                    IF  AVAIL msg0312r1-DadosCliente THEN
                        ASSIGN de-LimIntelbras:SCREEN-VALUE IN FRAME fPage0 = string(msg0312r1-DadosCliente.LimiteDisponivel).
                END.
            END.
            /* Final - Busca limite disponivel do DEPS */
                   
        END. /* IF AVAIL emitente THEN DO: */

    END. /* IF AVAIL ttPed-venda THEN DO: */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btMod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMod wMasterDetail
ON CHOOSE OF btMod IN FRAME fPage0 /* Modificar */
DO:
    FIND FIRST ttped-venda 
         WHERE ttped-venda.nr-pedcli  = ttped-venda.nr-pedcli :SCREEN-VALUE IN FRAME {&FRAME-NAME}
           AND ttped-venda.nome-abrev = ttped-venda.nome-abrev:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.

    FOR FIRST mgesp.ponto-programa
        where ponto-programa.nome-programa = "espdp006"
          AND ponto-programa.ponto         = 1,   /* Centrais Embratel */
         EACH mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          AND conteudo-programa.sequencia = int(ttped-venda.tp-pedido):
        IF index(conteudo-programa.conteudo,c-seg-usuario) = 0 THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                                           INPUT 17006, 
                                           INPUT "Permiss∆o para alocaá∆o do pedido restrita, somente estes usuarios podem alocar: " + conteudo-programa.conteudo).
            ASSIGN cReturn = "NOK".                
                RETURN "NTR".   
        END.
    end.
    ASSIGN l-mod = NOT l-mod.
    IF l-mod = TRUE THEN
        RUN pi-modifica.
    ELSE DO:
        
        RUN pi-atualiza.
        
        IF RETURN-VALUE = "NTR" THEN DO:
            APPLY "entry" TO c-transp IN FRAME fPage0.                                           
        END.
        ELSE DO:
            IF NOT ped-venda.completo THEN DO:

                IF NOT VALID-HANDLE(h-bodi159cal) THEN
                    RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.
        

                RUN completeOrder IN h-bodi159cal (INPUT  ROWID(ped-venda),
                                                   OUTPUT TABLE rowErrors).
        
                DELETE PROCEDURE h-bodi159cal.
                ASSIGN h-bodi159cal = ?.
            END.               

            FOR EACH rowErrors NO-LOCK
               WHERE rowErrors.errornumber  <> 8259
                 AND RowErrors.ErrorType    <> "INTERNAL":U
                 AND RowErrors.ErrorSubType = "Error":U:  /* credito nío aprovado */

                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "N∆o foi poss°vel completar o pedido!" + "~~" + RowErrors.errorDescription).
            END.

            APPLY "Entry" TO ttPed-item.qt-log-aloca IN BROWSE brSon1.
        END.
            
    END.
    ASSIGN ttped-venda.nome-transp:VISIBLE IN FRAME fPage0 = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:

    RUN getNext IN THIS-PROCEDURE.

    IF NOT AVAIL ttped-item THEN RETURN NO-APPLY.    
    ELSE
        APPLY "Entry" TO ttPed-item.qt-log-aloca IN BROWSE brSon1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPedido wMasterDetail
ON CHOOSE OF btPedido IN FRAME fPage0 /* Detalhar */
DO:
    
    IF AVAIL ttped-venda THEN DO:
        ASSIGN gr-ped-venda = ttped-venda.r-ped-venda.
        IF NOT VALID-HANDLE(h-pd4000) THEN DO:
            RUN pdp/pd4000.w PERSISTENT SET h-pd4000.
            RUN dispatch IN h-pd4000 ('initialize') no-error.
            RUN repositionRecord IN h-pd4000 (INPUT gr-ped-venda).
        END.
        ELSE
            RUN repositionRecord IN h-pd4000 (INPUT gr-ped-venda).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
  
    IF NOT AVAIL ttped-item THEN RETURN NO-APPLY.    
    ELSE
        APPLY "Entry" TO ttPed-item.qt-log-aloca IN BROWSE brSon1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSel wMasterDetail
ON CHOOSE OF btSel IN FRAME fPage0 /* Sel */
DO:
    DEFINE VARIABLE l-abre-query AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE lRetorno     AS LOGICAL     NO-UNDO.

    RUN esp/pdp/espdp006e.w (INPUT-OUTPUT vEstabel-ini,   
                             INPUT-OUTPUT vEstabel-fim,   
                             INPUT-OUTPUT vAtendente-ini, 
                             INPUT-OUTPUT vAtendente-fim, 
                             INPUT-OUTPUT vRepres-ini,    
                             INPUT-OUTPUT vRepres-fim,    
                             INPUT-OUTPUT vEntrega-ini,   
                             INPUT-OUTPUT vEntrega-fim,   
                             INPUT-OUTPUT vPedido-ini,    
                             INPUT-OUTPUT vPedido-fim,    
                             INPUT-OUTPUT vImpPed-ini,    
                             INPUT-OUTPUT vImpPed-fim,    
                             INPUT-OUTPUT vCond-ini,      
                             INPUT-OUTPUT vCond-fim,      
                             INPUT-OUTPUT vPrior-ini,     
                             INPUT-OUTPUT vPrior-fim,     
                             INPUT-OUTPUT voperMestreIni, 
                             INPUT-OUTPUT voperMestreFim, 
                             INPUT-OUTPUT vCodEmite-ini,  
                             INPUT-OUTPUT vCodEmite-fim,  
                             INPUT-OUTPUT vItCodigo,      
                             INPUT-OUTPUT vUnid-Neg,      
                             INPUT-OUTPUT vCodSitAval,    
                             INPUT-OUTPUT vEntFutura,
                             INPUT-OUTPUT iOrig-mercad,
                             INPUT-OUTPUT vParcMinima,
                             INPUT-OUTPUT lPedAlocado,
                             OUTPUT l-abre-query,
                             INPUT-OUTPUT TABLE tt-estab-depos).   

    IF l-abre-query THEN DO:
    
        IF VALID-HANDLE({&hDBOSon1}) THEN DO:

            RUN pi-carrega-pedidos IN {&hDBOParent} (INPUT vEstabel-ini, 
                                                     INPUT vEstabel-fim, 
                                                     INPUT vAtendente-ini,
                                                     INPUT vAtendente-fim,
                                                     INPUT vRepres-ini,
                                                     INPUT vRepres-fim,
                                                     INPUT vEntrega-ini,
                                                     INPUT vEntrega-fim,
                                                     INPUT vPedido-ini,
                                                     INPUT vPedido-fim,
                                                     INPUT vImpPed-ini,
                                                     INPUT vImpPed-fim,
                                                     INPUT vCond-ini,
                                                     INPUT vCond-fim,
                                                     INPUT vPrior-ini,
                                                     INPUT vPrior-fim,
                                                     INPUT voperMestreIni,
                                                     INPUT voperMestreFim,
                                                     INPUT vCodEmite-ini,
                                                     INPUT vCodEmite-fim,
                                                     INPUT vItCodigo,
                                                     INPUT vUnid-Neg,
                                                     INPUT vCodSitAval,
                                                     INPUT vEntFutura,
                                                     INPUT iOrig-mercad,  
                                                     INPUT vParcMinima,
                                                     INPUT lPedAlocado,
                                                     INPUT TABLE tt-estab-depos ).

            RUN openQueryStatic IN {&hDBOParent} (INPUT "Navega":U) NO-ERROR.

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "Show",
                                   INPUT 17006,
                                   INPUT "Nenhum pedido encontrado!~~N∆o foi encontrado nenhum pedido a seleá∆o informada. Verifique a sua seleá∆o.").

                FOR EACH tt-ped-venda-aux: DELETE tt-ped-venda-aux. END.
                {&OPEN-QUERY-brPedidos} 
                RETURN NO-APPLY.
    
            END.
            ELSE DO:
    
                RUN getBatchRecords IN {&hDBOParent} (INPUT ?,
                                                      INPUT ?,
                                                      INPUT ?,
                                                      OUTPUT iqtd,
                                                      OUTPUT TABLE tt-ped-venda-aux).
        
                EMPTY TEMP-TABLE tt-prog-ponto.
                ASSIGN c-atendente = "".
                RUN esp/es0018p.p (INPUT "ESWSO0004":U, /* Nome do programa */
                                   INPUT 2,            /* Ponto do programa */
                                   INPUT 0,
                                   INPUT "":U,
                                   OUTPUT TABLE tt-prog-ponto).
                FOR EACH tt-prog-ponto:
                    IF c-atendente = "" THEN
                        ASSIGN c-atendente = tt-prog-ponto.conteudo.
                    ELSE
                        ASSIGN c-atendente = c-atendente + "," + tt-prog-ponto.conteudo.
                END.

                FOR EACH tt-ped-venda-aux
                   WHERE LOOKUP(tt-ped-venda-aux.tp-pedido,c-atendente) <> 0:
                    FOR FIRST int-pedido-vtex NO-LOCK
                        WHERE int-pedido-vtex.nr-pedcli = tt-ped-venda-aux.nr-pedcli:
                        IF CAN-FIND(FIRST bint-pedido-vtex NO-LOCK
                                    WHERE bint-pedido-vtex.nr-pedido  = int-pedido-vtex.nr-pedido
                                      AND bint-pedido-vtex.nr-pedcli <> int-pedido-vtex.nr-pedcli) THEN DO:
                            FOR EACH bint-pedido-vtex EXCLUSIVE-LOCK
                               WHERE bint-pedido-vtex.nr-pedido  = int-pedido-vtex.nr-pedido
                                 AND bint-pedido-vtex.nr-pedcli <> int-pedido-vtex.nr-pedcli,
                               FIRST ped-venda NO-LOCK
                               WHERE ped-venda.nr-pedcli = bint-pedido-vtex.nr-pedcli
                                 AND ped-venda.cod-sit-ped < 3:
                                RUN pi-cancela-pedido-dupli.   
                            END.
                        END.
                    END.
                END.
    
                {&OPEN-QUERY-brPedidos}  
                
                /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
                RUN getFirst IN {&hDBOParent}.
                
                /*:T Retorna rowid do registro corrente do DBO */
                RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
                
                /*:T Reposiciona registro com base em um rowid */
                RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).            
            END. /* ELSE DO: */
    
        END.
    
        IF NOT AVAIL ttped-item THEN RETURN NO-APPLY.    
        ELSE
            APPLY "Entry" TO ttPed-item.qt-log-aloca IN BROWSE brSon1.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSerExec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSerExec wMasterDetail
ON CHOOSE OF btSerExec IN FRAME fPage0 /* Execuá∆o */
DO:
    RUN btb/btb001aa.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVolumes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVolumes wMasterDetail
ON CHOOSE OF btVolumes IN FRAME fPage0 /* Calcula Valumes */
DO:
    ASSIGN i-volumes:SCREEN-VALUE IN FRAME fPage0 = "0".

    IF  AVAIL ttPed-venda 
    AND CAN-FIND (FIRST ttped-item
                  WHERE ttped-item.qt-log-aloca > 0) THEN DO:
    
        EMPTY TEMP-TABLE tt-itens-calculo.
        FOR EACH ttped-item 
           WHERE ttped-item.qt-log-aloca > 0 NO-LOCK:
            CREATE tt-itens-calculo.
            ASSIGN tt-itens-calculo.it-codigo  = ttped-item.it-codigo
                   tt-itens-calculo.quantidade = ttped-item.qt-log-aloca.
        END.

        RUN esp/ftp/esftp083.p PERSISTENT SET h-esftp083.

        EMPTY TEMP-TABLE tt-volumes.

        RUN pi-calcula-volumes IN h-esftp083 (INPUT ttPed-venda.cod-emitente,
                                              INPUT ttPed-venda.nat-operacao,
                                              INPUT ttPed-venda.cod-estabel,
                                              INPUT ttPed-venda.nome-transp,
                                              INPUT  TABLE tt-itens-calculo,
                                              OUTPUT TABLE tt-volumes,
                                              OUTPUT c-erros).

        IF c-erros <> "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "msg",
                               INPUT 17006,
                               INPUT c-erros).
        END.

        DELETE PROCEDURE h-esftp083.
        ASSIGN h-esftp083 = ?.

        FOR LAST tt-volumes
              BY tt-volumes.nr-volume:
            ASSIGN i-volumes:SCREEN-VALUE IN FRAME fPage0 = STRING(tt-volumes.nr-volume).    
        END.
        
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-frete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-frete wMasterDetail
ON VALUE-CHANGED OF c-frete IN FRAME fPage0 /* Frete */
DO:
    ASSIGN c-frete.
    IF c-frete = "CIF" THEN DO:
        IF  AVAIL ttPed-venda
        AND ttPed-venda.nome-transp <> "" THEN
            ASSIGN c-transp:SCREEN-VALUE IN FRAME fPage0 = ttPed-venda.nome-transp.

        ASSIGN c-transp:SENSITIVE IN FRAME fPage0 = TRUE.  
    END.
    ELSE
        ASSIGN c-transp:SCREEN-VALUE IN FRAME fPage0 = " "
               c-transp:SENSITIVE IN FRAME fPage0 = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-servidor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-servidor wMasterDetail
ON F5 OF c-servidor IN FRAME fPage0 /* Servidor */
DO:
  
    run btb/btb012ka.w.
    if  v_rec_servid_exec <> ?
    then do:
        find servid_exec where recid(servid_exec) = v_rec_servid_exec no-lock no-error.
        assign c-servidor:screen-value in frame {&frame-name} = servid_exec.cod_servid_exec.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-servidor wMasterDetail
ON MOUSE-SELECT-DBLCLICK OF c-servidor IN FRAME fPage0 /* Servidor */
DO:
  
    APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-transp wMasterDetail
ON VALUE-CHANGED OF c-transp IN FRAME fPage0
DO:
    ASSIGN c-transp.
    IF  c-transp = "RETIRA" OR c-transp = " " THEN
        ASSIGN c-frete:SCREEN-VALUE IN FRAME fPage0 = "FOB".  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-transp wMasterDetail
ON f5 OF cod-transp IN FRAME fPage0 /* Transportador */
DO:
    {method/zoomfields.i 
         &ProgramZoom="adzoom/z10ad268.w"
         &FieldZoom1="cod-transp"
         &FieldScreen1="cod-transp"
         &Frame1="fPage0"
         &FieldZoom2="nome-abrev"
         &FieldScreen2="ttped-venda.nome-transp"
         &Frame2="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-transp wMasterDetail
ON LEAVE OF cod-transp IN FRAME fPage0 /* Transportador */
DO:
  
    
    FIND FIRST transporte WHERE transporte.cod-transp = INPUT FRAME fPage0 cod-transp NO-LOCK NO-ERROR.

    IF AVAIL transporte THEN
        ASSIGN c-transp               :SCREEN-VALUE IN FRAME fPage0 = transporte.nome-abrev 
               ttped-venda.nome-transp:SCREEN-VALUE IN FRAME fPage0 = transporte.nome-abrev .
    ELSE 
        ASSIGN c-transp               :SCREEN-VALUE IN FRAME fPage0 = "" 
               ttped-venda.nome-transp:SCREEN-VALUE IN FRAME fPage0 = "" .
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-transp wMasterDetail
ON MOUSE-SELECT-DBLCLICK OF cod-transp IN FRAME fPage0 /* Transportador */
DO:
  
    APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miCalc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miCalc wMasterDetail
ON CHOOSE OF MENU-ITEM miCalc /* Calcula */
DO:
    APPLY "choose" TO btCalcula-2 IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miDet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miDet wMasterDetail
ON CHOOSE OF MENU-ITEM miDet /* Detalhar */
DO:
    APPLY "choose" TO btPedido IN FRAME fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miExtra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miExtra wMasterDetail
ON CHOOSE OF MENU-ITEM miExtra /* Inf. Adicionais */
DO:
    APPLY "choose" TO btExtra IN FRAME fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miFat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miFat wMasterDetail
ON CHOOSE OF MENU-ITEM miFat /* Faturar */
DO:
    APPLY "choose" TO btCalcula IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miFat2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miFat2 wMasterDetail
ON CHOOSE OF MENU-ITEM miFat2 /* Faturar */
DO:
    APPLY "choose" TO btFat-2 IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miMod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miMod wMasterDetail
ON CHOOSE OF MENU-ITEM miMod /* Modificar */
DO:
    APPLY "choose" TO btMod IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miSel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miSel wMasterDetail
ON CHOOSE OF MENU-ITEM miSel /* Seleá∆o */
DO:
    APPLY "choose" TO btSel IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Liberao_Faturamento_Total_A
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Liberao_Faturamento_Total_A wMasterDetail
ON CHOOSE OF MENU-ITEM m_Liberao_Faturamento_Total_A /* Liberaá∆o Total Autom†tica */
DO:
      APPLY "choose" TO btAlocAut IN FRAME fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttped-venda.no-ab-reppri
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-venda.no-ab-reppri wMasterDetail
ON f5 OF ttped-venda.no-ab-reppri IN FRAME fPage0 /* Representante */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad229.w
                        &campo=ttped-venda.no-ab-reppri
                        &campozoom=nome-abrev}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-venda.no-ab-reppri wMasterDetail
ON MOUSE-SELECT-DBLCLICK OF ttped-venda.no-ab-reppri IN FRAME fPage0 /* Representante */
DO:
  
    APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vCod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vCod-depos wMasterDetail
ON LEAVE OF vCod-depos IN FRAME fPage0 /* Dep¢sito */
DO:
    RUN pi-valida-deposito.

    IF RETURN-VALUE <> "OK" THEN
        RETURN NO-APPLY.

    ASSIGN vCod-depos = INPUT FRAME fPage0 vCod-depos.

    {&OPEN-QUERY-brSon1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vLocalizacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vLocalizacao wMasterDetail
ON LEAVE OF vLocalizacao IN FRAME fPage0 /* Localizaá∆o */
DO:
  RUN pi-valida-deposito.

  IF RETURN-VALUE <> "OK" THEN
      RETURN NO-APPLY.

  ASSIGN vLocalizacao = INPUT FRAME fPage0 vLocalizacao.

  {&OPEN-QUERY-brSon1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brPedidos
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
/* MESSAGE 'Main 1 ' STRING(gr-ped-venda) SKIP */
/*         STRING(gr-ped-venda005)             */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.      */

/* FIND FIRST para-ped NO-LOCK. */
/*    */
ASSIGN c-lista = " , ,RETIRA,RETIRA,".

IF gr-ped-venda <> ? THEN
    ASSIGN gr-ped-venda005 = gr-ped-venda.

FOR EACH transporte NO-LOCK
    BREAK BY transporte.nome-abrev:
     ASSIGN c-lista = c-lista + transporte.nome-abrev + ",".
END.

ASSIGN c-lista = SUBSTRING(c-lista,1,LENGTH(c-lista) - 1)
       c-transp:LIST-ITEMS IN FRAME fPage0 = c-lista.


ON 'RETURN':U OF ttped-item.qt-log-aloca IN BROWSE brSon1 DO:

    IF AVAILABLE ttPed-item THEN DO:

        ASSIGN l-enter = TRUE.
        
        IF INTEGER(ttped-item.qt-log-aloca:SCREEN-VALUE IN BROWSE brSon1) > ttped-item.qt-log-aloca THEN DO:
            
            ASSIGN de-aloca-item-astec = DECIMAL(ttped-item.qt-log-aloca:SCREEN-VALUE IN BROWSE brSon1) - ttped-item.qt-log-aloca.
            
            SESSION:SET-WAIT-STATE("general":U).     
            RUN pi-aloca.         
            RUN pi-atualiza-quantidades.
            SESSION:SET-WAIT-STATE("":U).        
            
        END.
        ELSE IF INTEGER(ttped-item.qt-log-aloca:SCREEN-VALUE IN BROWSE brSon1) < ttped-item.qt-log-aloca THEN DO:

            ASSIGN de-desaloca-item-astec = ttped-item.qt-log-aloca - DECIMAL(ttped-item.qt-log-aloca:SCREEN-VALUE IN BROWSE brSon1).

            SESSION:SET-WAIT-STATE("general":U).     
            RUN pi-desaloca.                
            SESSION:SET-WAIT-STATE("":U).        
        END.                                
    END.
END.


ON 'ENTRY':U OF ttped-item.qt-log-aloca IN BROWSE brSon1 DO:

    IF AVAIL ttped-item THEN DO:

        ASSIGN c-old-value = ttped-item.qt-log-aloca
               cReturn = "":U.

        IF ttPed-item.qt-log-aloca = 0 OR
           ttPed-item.qt-log-aloca = ? THEN DO:
            
            ASSIGN de-qtd-estoq = fnEstoque(c-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME}, ttped-item.it-codigo, vCod-depos, vLocalizacao, NO).
            
            IF de-qtd-estoq < (ttped-item.qt-pedida - ttped-item.qt-atendida - ttped-item.qt-log-aloca) THEN
                ASSIGN ttped-item.qt-log-aloca:SCREEN-VALUE IN BROWSE brSon1 = STRING(de-qtd-estoq).
            ELSE
                ASSIGN ttped-item.qt-log-aloca:SCREEN-VALUE IN BROWSE brSon1 = STRING(ttped-item.qt-pedida - ttped-item.qt-atendida - ttped-item.qt-log-aloca).                
        END.
    END.
END.

ON 'leave':U OF ttped-item.qt-log-aloca IN BROWSE brSon1 DO:

    IF AVAIL ttped-item THEN DO:
        ASSIGN ttped-item.qt-log-aloca:SCREEN-VALUE IN BROWSE brSon1 = STRING(ttped-item.qt-log-aloca).                
    END.

END.

c-servidor:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame {&FRAME-NAME}.
ttped-venda.no-ab-reppri:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame {&FRAME-NAME}.
cod-transp:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame {&FRAME-NAME}.

{masterdetail/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDestroyInterface wMasterDetail 
PROCEDURE AfterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*--- Destr¢i os Servidores RPC inicializados pelos DBOs ---*/
  /*  {btb/btb008za.i3}
        
    /*Alteracao para deletar da mem¢ria o WindowStyles e o btb008za.p*/
    IF VALID-HANDLE(h-servid-rpc) THEN
    DO:
       DELETE PROCEDURE h-servid-rpc.
       ASSIGN h-servid-rpc = ?. /*Garantir que a vari†vel n∆o vai mais apontar para nenhum handle de outro objeto - este problema apareceu na v9.1B com Windows2000*/
    END.

    IF VALID-HANDLE(hWindowStyles) THEN
        DELETE PROCEDURE hWindowStyles.
    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iqtd                      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-lista-cod-sit-aval      AS CHARACTER   NO-UNDO.

    DEFINE BUFFER b-natur-oper FOR natur-oper.
    DEFINE BUFFER b-item       FOR item.    
    
    FIND FIRST tt-estab-depos
         WHERE tt-estab-depos.cod-estabel = ttped-venda.cod-estabel NO-ERROR.

    IF AVAIL tt-estab-depos THEN 
        ASSIGN vCod-depos = tt-estab-depos.cod-depos.
    ELSE 
        ASSIGN vCod-depos = "".

        
    DISPLAY vCod-depos
            vLocalizacao WITH FRAME fPage0.

    ASSIGN fi-descricao:SCREEN-VALUE IN FRAME fpage0        = ""
           c-lista-cod-sit-aval = "N∆o Avaliado,Avaliado,Aprovado,N∆o Aprovado,Pendente Informaá∆o"
           i-volumes:SCREEN-VALUE IN FRAME fPage0 = "0".
    
    IF  AVAIL ttPed-venda THEN DO:

        FIND FIRST bped-venda WHERE bped-venda.nr-pedcli = ttped-venda.nr-pedcli NO-LOCK NO-ERROR.
        IF AVAIL bped-venda THEN DO:
            ASSIGN ttped-venda.cod-priori:SCREEN-VALUE IN FRAME fPage0 = string(bped-venda.cod-priori,'99').
            FIND FIRST transporte WHERE transporte.nome-abrev = bped-venda.nome-transp NO-LOCK NO-ERROR.
            IF AVAIL transporte THEN
                ASSIGN cod-transp             :SCREEN-VALUE IN FRAME fPage0 = string(transporte.cod-transp)
                       ttPed-venda.nome-transp:SCREEN-VALUE IN FRAME fPage0 = transporte.nome-abrev.

            FIND FIRST transporte 
                 WHERE transporte.nome-abrev = bped-venda.nome-tr-red NO-LOCK NO-ERROR.
            IF AVAIL transporte THEN
                ASSIGN cod-transp-red   :SCREEN-VALUE IN FRAME fPage0 = string(transporte.cod-transp)
                       c-nome-transp-red:SCREEN-VALUE IN FRAME fPage0 = transporte.nome-abrev.
            ELSE
                ASSIGN cod-transp-red   :SCREEN-VALUE IN FRAME fPage0 = ""
                       c-nome-transp-red:SCREEN-VALUE IN FRAME fPage0 = "".

        END. /* IF tt-ped-venda.nome-transp:SCREEN-VALUE IN FRAME fPage0 <> '' THEN DO: */

        IF  ttPed-venda.cod-sit-aval = 3 THEN
            ASSIGN ttPed-venda.desc-bloq-cr:SCREEN-VALUE IN FRAME fPage0 = "". /* andrey */

        ASSIGN c-sit-credito:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(ttped-venda.cod-sit-aval, c-lista-cod-sit-aval).
               
        IF ttPed-Venda.cidade-cif = "" THEN
            ASSIGN c-frete:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = "FOB"
                   cidade-cif:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "FOB".
        ELSE
            ASSIGN c-frete:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = "CIF"
                   cidade-cif:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CIF".
            
        ASSIGN c-situacao:SCREEN-VALUE IN FRAME fPage0 = ENTRY(ttped-venda.cod-sit-ped,"Aberto,Atendido Parcial,Atendido Total,Pendente,Suspenso,Cancelado,Fatur Balc∆o").
        
        FIND FIRST gr-cli OF ttped-venda NO-LOCK NO-ERROR.
        IF  AVAIL gr-cli THEN
            ASSIGN c-desc-grupo:SCREEN-VALUE IN FRAME fPage0 = gr-cli.descricao.        
            
        DISPLAY ttPed-venda.nome-transp FORMAT "x(200)"
                ttPed-venda.cod-canal-venda WITH FRAME {&FRAME-NAME}.

        RUN pi-calcula-valor-alocado.

        ASSIGN ttPed-venda.observacoes:SENSITIVE IN FRAME fPage0     = TRUE
               ttPed-venda.cond-espec:SENSITIVE IN FRAME fPage0      = TRUE
               ttPed-venda.cod-canal-venda:SENSITIVE IN FRAME fPage0 = TRUE
               ttPed-venda.nr-pedcli:SENSITIVE IN FRAME fPage0 = TRUE
               c-cod-estabel:SENSITIVE IN FRAME fPage0 = FALSE
               c-cod-estabel:SCREEN-VALUE IN FRAME fPage0 = ttped-venda.cod-estabel
               c-cod-estabel = ttped-venda.cod-estabel.

        FIND FIRST cond-pagto NO-LOCK 
             WHERE cond-pagto.cod-cond-pag = ttped-venda.cod-cond-pag NO-ERROR.

        IF  AVAIL cond-pagto THEN DO:
            ASSIGN fi-descricao:SCREEN-VALUE IN FRAME fpage0 = cond-pagto.descricao.
        END.
    
        FIND FIRST tt-ped-venda-aux NO-LOCK
            WHERE  tt-ped-venda-aux.nome-abrev = ttped-venda.nome-abrev
            AND    tt-ped-venda-aux.nr-pedcli  = ttped-venda.nr-pedcli NO-ERROR.
        IF  AVAIL  tt-ped-venda-aux THEN DO:
            REPOSITION brPedidos TO ROWID ROWID(tt-ped-venda-aux) NO-ERROR.
        END.

        ASSIGN de-ps-total-aberto = 0 .
        FOR EACH  b-ped-item
            WHERE b-ped-item.nome-abrev = ttped-venda.nome-abrev
            AND   b-ped-item.nr-pedcli  = ttped-venda.nr-pedcli
            AND   b-ped-item.cod-sit-item < 3 NO-LOCK,
            FIRST b-natur-oper
            WHERE b-natur-oper.nat-operacao = b-ped-item.nat-operacao NO-LOCK,
            FIRST b-item
            WHERE b-item.it-codigo = b-ped-item.it-codigo NO-LOCK:
            
            ASSIGN de-ps-total-aberto = de-ps-total-aberto + ((b-ped-item.qt-pedida - b-ped-item.qt-atendida) * b-item.peso-bruto).
        END.
        DISPLAY de-ps-total-aberto WITH FRAME fPage0.

        EMPTY TEMP-TABLE tt-prog-ponto.
        ASSIGN c-atendente = "".
        RUN esp/es0018p.p (INPUT "ESWSO0004":U, /* Nome do programa */
                           INPUT 2,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
        FOR EACH tt-prog-ponto:
            IF c-atendente = "" THEN
                ASSIGN c-atendente = tt-prog-ponto.conteudo.
            ELSE
                ASSIGN c-atendente = c-atendente + "," + tt-prog-ponto.conteudo.
        END.

        IF LOOKUP(ttped-venda.tp-pedido,c-atendente) <> 0 THEN DO: //somente pedidos loja fazer a leitura

            FIND FIRST int-pedido-vtex NO-LOCK
                 WHERE int-pedido-vtex.nr-pedcli = ttped-venda.nr-pedcli NO-ERROR.
            IF AVAIL int-pedido-vtex THEN
                ASSIGN c-marketplace  = int-pedido-vtex.marketplace.
            ELSE ASSIGN c-marketplace = "".
          
            DISPLAY c-marketplace WITH FRAME fPage0.
        END.

        ASSIGN c-natureza = "".
        FIND FIRST emitente
             WHERE emitente.cod-emitente = ttped-venda.cod-emitente NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:
            IF emitente.natureza = 1 THEN
                ASSIGN c-natureza = "Fisica".
            ELSE
                ASSIGN c-natureza = "Juridica".
        END.
        DISPLAY c-natureza WITH FRAME fPage0.

    END.

    RUN pi-integra-pedido.

    IF AVAIL ttped-venda THEN
        ASSIGN v-pedido-anterior = ttped-venda.nr-pedido.

/*     FOR EACH mgesp.ponto-programa NO-LOCK                                                                */
/*         WHERE ponto-programa.nome-programa = "espdp006"                                                   */
/*           AND ponto-programa.ponto         = 11,                                                          */
/*          EACH mgesp.conteudo-programa NO-LOCK                                                            */
/*         WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:                               */
/*                                                                                                           */
/*         ASSIGN c-servidor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = entry(1,conteudo-programa.conteudo, ";"). */
/*                                                                                                           */
/*     END. /* FOR EACH mgesp.ponto-programa NO-LOCK */                                                     */

    FIND FIRST mgesp.ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "pd4000"
          AND ponto-programa.ponto         = 7 NO-ERROR.
    IF AVAIL mgesp.ponto-programa THEN DO:
        IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:

            ASSIGN btFat:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
            IF ttped-venda.cod-priori:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '07' THEN
                ASSIGN btMod:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
            ELSE
                ASSIGN btMod:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

        END. /* IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK */
        ELSE
            ASSIGN btMod:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                   btFat:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

    END. /* IF AVAIL mgesp.ponto-programa THEN DO: */

    IF ttped-venda.cod-priori:SCREEN-VALUE IN FRAME fPage0 = '09' THEN DO:
        ASSIGN btFat       :SENSITIVE IN FRAME {&FRAME-NAME} = NO
               btCalcula   :SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE
        ASSIGN btFat       :SENSITIVE IN FRAME {&FRAME-NAME} = YES
               btCalcula   :SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    /*ASSIGN rs-execucao1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.*/

    FIND FIRST mgesp.ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "espdp006"
          AND ponto-programa.ponto         = 13 NO-ERROR.
    IF AVAIL mgesp.ponto-programa THEN DO:
        IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:
            ASSIGN btFat    :SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        END. /* IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK */
        ELSE
            ASSIGN btFat    :SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END. /* IF AVAIL mgesp.ponto-programa THEN DO: */

    FOR EACH mgesp.ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "espdp006"
          AND ponto-programa.ponto         = 14:
        IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:
            ASSIGN btFaturaTodosPedSel:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        END. /* IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK */
        ELSE
            ASSIGN btFaturaTodosPedSel:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END. /* FOR EACH mgesp.ponto-programa NO-LOCK */

    IF vcod-depos <> "" THEN
        APPLY "LEAVE" TO vcod-depos IN FRAME fPage0.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-handle-tmp AS HANDLE      NO-UNDO.

    ASSIGN h-handle-tmp = SESSION:FIRST-PROCEDURE.
    DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO INITIAL NO.
    
    /*Valida se existe outro espdp006 aberto*/
    IF VALID-HANDLE (h-handle-tmp) THEN DO:
        blk_espdp006:
        REPEAT:
            IF h-handle-tmp:NAME = "esp/pdp/espdp006.w" THEN DO:

                IF l-erro THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 27979,
                                       INPUT "ATENÄ«O!~~J† existe um ESPDP006 em execuá∆o nessa sess∆o, o uso simultaneo de dois ESPDP006 pode causar problemas de saldo. Feche um deles." ).

                    DELETE PROCEDURE hped-item.
                    DELETE PROCEDURE hped-venda.
                    DELETE PROCEDURE h-handle-tmp.
                   
                    ASSIGN l-fecha-prog = YES.
                    LEAVE blk_espdp006.
                END.
                /*A primeira instancia que encontra na d† erro, se achar outra d†*/
                ASSIGN l-erro = YES.
            END.
            ASSIGN h-handle-tmp = h-handle-tmp:NEXT-SIBLING.
    
            IF NOT VALID-HANDLE(h-handle-tmp) THEN
                LEAVE blk_espdp006.
        END.
    END.

    ASSIGN vCod-depos:SENSITIVE IN FRAME fPage0 = YES.

    FOR EACH mgesp.ponto-programa NO-LOCK
       WHERE ponto-programa.nome-programa = "espdp006"
         AND ponto-programa.ponto         = 11,  
        EACH mgesp.conteudo-programa NO-LOCK
       WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

       ASSIGN c-servidor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = entry(1,conteudo-programa.conteudo, ";").

    END. /* FOR EACH mgesp.ponto-programa NO-LOCK */

    FOR FIRST mgesp.ponto-programa
        WHERE ponto-programa.nome-programa = "espdp006"
          AND ponto-programa.ponto = 4,
        FIRST mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          AND ENTRY(1,conteudo-programa.conteudo) = c-seg-usuario:     /* Usuario que tera a localizacao habilitado */
    END.

    IF AVAIL conteudo-programa THEN DO:
        ENABLE vLocalizacao
            WITH FRAME fPage0.
    END.

    
    /*
    IF gr-ped-venda = ? THEN
       gr-ped-venda = gr-ped-venda-aux.*/

   
    IF  gr-ped-venda <> ? THEN DO:
        ASSIGN gr-ped-venda-espdp003 = gr-ped-venda.
    END.

    IF  gr-ped-venda-espdp003  = ?
    AND gr-ped-venda005       <> ? THEN
        ASSIGN gr-ped-venda-espdp003 = gr-ped-venda005.

    ASSIGN wMasterDetail:VISIBLE = TRUE.

    ASSIGN vImpPed-ini  = ADD-INTERVAL(TODAY, -12, "month")
           vEntrega-ini = ADD-INTERVAL(TODAY, -12, "month").

    IF AVAIL ttped-item THEN
        ASSIGN ttped-item.qt-log-aloca:DISABLE-AUTO-ZAP IN BROWSE brSon1 = FALSE.

    ENABLE btPedido 
           btSel
           btExtra
           btMod 
           btAlocAut 
           btConsulta
           btSerExec
           brPedidos
           bt-loc-pedido
           btCalcula
           c-servidor
           btLimite
           btVolumes
           ttped-venda.desc-bloq-cr            
        WITH FRAME {&FRAME-NAME}.

    ENABLE btAlocaTudo btDesaloca
        WITH FRAME fPage1.

    if  gr-ped-venda-espdp003 = ? THEN DO:
        
        APPLY "choose" TO btSel IN FRAME {&FRAME-NAME}.
    END.
    ELSE DO:
        
        IF VALID-HANDLE({&hDBOSon1}) THEN DO:

            FIND FIRST ped-venda NO-LOCK
                 WHERE ROWID(ped-venda) = gr-ped-venda-espdp003  NO-ERROR.

            IF NOT AVAIL ped-venda THEN DO:
                APPLY "choose" TO btSel IN FRAME {&FRAME-NAME}.
            END.
            ELSE DO:
                
                RUN pi-carrega-pedidos IN {&hDBOParent} (INPUT ped-venda.cod-estabel,
                                                         INPUT ped-venda.cod-estabel,
                                                         INPUT ped-venda.tp-pedido,
                                                         INPUT ped-venda.tp-pedido,
                                                         INPUT 0,
                                                         INPUT 99999,
                                                         INPUT ped-venda.dt-entrega,
                                                         INPUT ped-venda.dt-entrega,
                                                         INPUT ped-venda.nr-pedcli,
                                                         INPUT ped-venda.nr-pedcli,
                                                         INPUT ped-venda.dt-implant,
                                                         INPUT ped-venda.dt-implant,
                                                         INPUT ped-venda.cod-cond-pag,
                                                         INPUT ped-venda.cod-cond-pag,
                                                         INPUT ped-venda.cod-priori,
                                                         INPUT ped-venda.cod-priori,
                                                         INPUT 00,
                                                         INPUT 99,
                                                         INPUT ped-venda.cod-emitente,
                                                         INPUT ped-venda.cod-emitente,
                                                         INPUT "",
                                                         INPUT "",
                                                         INPUT "",
                                                         INPUT NO, //Entrega futura
                                                         INPUT 0,  //Origem Mercadoria
                                                         INPUT NO, //Parcela Minima
                                                         INPUT NO, //somente alocado
                                                         INPUT TABLE tt-estab-depos) NO-ERROR.
    
                RUN openQueryStatic IN {&hDBOParent} (INPUT "Navega":U) NO-ERROR.

                IF RETURN-VALUE = "NOK":U THEN DO:
                    
                    RUN utp/ut-msgs.p (INPUT "Show",
                                       INPUT 17006,
                                       INPUT "Nenhum pedido encontrado!~~N∆o foi encontrado nenhum pedido a seleá∆o informada. Verifique a sua seleá∆o.").
                    RETURN NO-APPLY.
                END.    
                ELSE DO:
                    RUN getBatchRecords IN {&hDBOParent} (INPUT ?,
                                                          INPUT ?,
                                                          INPUT ?,
                                                          OUTPUT iqtd,
                                                          OUTPUT TABLE tt-ped-venda-aux).

                    FOR EACH tt-ped-venda-aux:
                        FOR FIRST int-pedido-vtex NO-LOCK
                            WHERE int-pedido-vtex.nr-pedcli = tt-ped-venda-aux.nr-pedcli:
                            IF CAN-FIND(FIRST bint-pedido-vtex NO-LOCK
                                        WHERE bint-pedido-vtex.nr-pedido  = int-pedido-vtex.nr-pedido
                                          AND bint-pedido-vtex.nr-pedcli <> int-pedido-vtex.nr-pedcli) THEN DO:
                                FOR EACH bint-pedido-vtex EXCLUSIVE-LOCK
                                   WHERE bint-pedido-vtex.nr-pedido  = int-pedido-vtex.nr-pedido
                                     AND bint-pedido-vtex.nr-pedcli <> int-pedido-vtex.nr-pedcli,
                                   FIRST ped-venda NO-LOCK
                                   WHERE ped-venda.nr-pedcli = bint-pedido-vtex.nr-pedcli
                                     AND ped-venda.cod-sit-ped < 3:
                                    RUN pi-cancela-pedido-dupli.
                                END.
                            END.
                        END.
                    END.
                    
                    {&OPEN-QUERY-brPedidos} 
                    /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
                    RUN getFirst IN {&hDBOParent}.

                    /*:T Retorna rowid do registro corrente do DBO */
                    RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).

                    /*:T Reposiciona registro com base em um rowid */
                    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
                END.
            END.
        END.
    END.

    IF  AVAIL ttped-venda THEN DO:
        IF CAN-FIND(FIRST ped-transf NO-LOCK
                    WHERE ped-transf.nome-abrev = ttped-venda.nome-abrev
                    AND   ped-transf.nr-pedcli  = ttped-venda.nr-pedcli) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT STRING("Pedido em processo de Transferància. Aguarde o processo finalizar para alterar o pedido.":U +
                                            "O pedido n∆o pode ser alterado pois est† em processo de Transferància entre Estabelecimentos!":U)).
        END.
    END.

    RETURN "OK":U.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroyInterface wMasterDetail 
PROCEDURE beforeDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-integra-pedido.
    IF VALID-HANDLE(h-pd4000) THEN RUN pi-finalizar     IN h-pd4000.
    IF VALID-HANDLE(h-pd4000) THEN RUN destroyInterface IN h-pd4000.
    IF VALID-HANDLE(h-pd4000) THEN DELETE PROCEDURE        h-pd4000.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToPedidoAux wMasterDetail 
PROCEDURE goToPedidoAux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    DEF VAR vnr-pedcli LIKE ped-venda.nr-pedcli VIEW-AS FILL-IN SIZE 12 BY .88.

    DEFINE FRAME fGoToRecord
        vnr-pedcli AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Pedido" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.                
             
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN vnr-pedcli.
        
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        FIND FIRST tt-ped-venda-aux
            WHERE tt-ped-venda-aux.nr-pedcli = vnr-pedcli NO-ERROR.

        IF NOT AVAIL tt-ped-venda-aux THEN DO:
            RUN utp/ut-msgs.p (INPUT "Show",
                               INPUT 17006,
                               INPUT "Pedido n∆o encontrado!~~Este pedido n∆o est† na seleá∆o previamente informada ou o pedido n∆o est† liberado para faturamento.").
            
            RETURN NO-APPLY.
        END.
        
        REPOSITION brPedidos TO ROWID ROWID(tt-ped-venda-aux) NO-ERROR.
        APPLY "value-changed" TO brPedidos IN FRAME fPage0.
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE vnr-pedcli btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    DEF VAR vnome-abrev LIKE ped-venda.nome-abrev VIEW-AS FILL-IN SIZE 19 BY .88.
    DEF VAR vnr-pedcli LIKE ped-venda.nr-pedcli VIEW-AS FILL-IN SIZE 12 BY .88.

    
    DEFINE FRAME fGoToRecord
        vnome-abrev AT ROW 1.21 COL 17.72 COLON-ALIGNED
        vnr-pedcli AT ROW 2.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Pedido" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.                
             
    ON "LEAVE":U OF vnome-abrev IN FRAME fGoToRecord DO:
        def var c-retorno as char no-undo.

        assign input vnome-abrev.
        
        if vnome-abrev <> "" then do:
            run findNomeAbrev in h-bo-emitente(input vnome-abrev, output c-retorno).

            assign vnome-abrev:screen-value in frame fGoToRecord = c-retorno.
        end.

    END.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN vnome-abrev
               vnr-pedcli.
        
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT vnome-abrev, INPUT vnr-pedcli).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "Show",
                               INPUT 17006,
                               INPUT "Pedido n∆o encontrado!~~Este pedido n∆o est† na seleá∆o previamente informada ou o pedido n∆o est† liberado para faturamento.").
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        IF VALID-HANDLE(h-bo-emitente) THEN
            DELETE PROCEDURE h-bo-emitente.
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    RUN adbo/boad098.p PERSISTENT SET h-bo-emitente.                 
    
    ENABLE vnome-abrev vnr-pedcli btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "esbo/esbodi159a.p":U THEN DO:
        {btb/btb008za.i1 esbo/esbodi159a.p YES}
        {btb/btb008za.i2 esbo/esbodi159a.p '' {&hDBOParent}} 
    END.    
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "esbo/esbodi154.p":U THEN DO:
        {btb/btb008za.i1 esbo/esbodi154.p YES}
        {btb/btb008za.i2 esbo/esbodi154.p '' {&hDBOSon1}} 
    END.       
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    {masterdetail/OpenQueriesSon.i &Parent="pedido"
                                   &Query="byPedido"
                                   &PageNumber="1"}
                                           
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-aloca wMasterDetail 
PROCEDURE pi-aloca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-item: DELETE tt-item. END. 
    FOR EACH tt-erro: DELETE tt-erro. END. 

    FIND FIRST bf-ped-venda NO-LOCK 
         WHERE bf-ped-venda.nr-pedcli  = ttped-venda.nr-pedcli 
           AND bf-ped-venda.nome-abrev = ttped-venda.nome-abrev NO-ERROR.

    FIND FIRST bf-ped-item OF ttped-item NO-LOCK NO-ERROR.

    IF  AVAIL bf-ped-venda
    AND AVAIL bf-ped-item THEN DO:

        ASSIGN vQtAlocar  = INTEGER(ttPed-item.qt-log-aloca:SCREEN-VALUE IN BROWSE brSon1) - ttPed-item.qt-log-aloca.   

        RUN esp/pdp/espdp006f.p (INPUT c-seg-usuario,
                                 INPUT ROWID(bf-ped-venda),
                                 INPUT ROWID(bf-ped-item),
                                 INPUT vCod-depos,
                                 INPUT IF vLocalizacao = "*" THEN "" ELSE vLocalizacao,
                                 INPUT vQtAlocar,
                                 INPUT vUnid-Neg,
                                 OUTPUT TABLE tt-erro).
    END.

    ASSIGN ttped-item.qt-pedida    = bf-ped-item.qt-pedida   
           ttped-item.qt-atendida  = bf-ped-item.qt-atendida 
           ttped-item.qt-log-aloca = bf-ped-item.qt-log-aloca.
   
    IF CAN-FIND(FIRST tt-erro) THEN DO:
        RUN cdp/cd0666.w (INPUT TABLE tt-erro).
        ASSIGN rGoto = ROWID(ttPed-item).
        {&OPEN-QUERY-brSon1}
        REPOSITION brSon1 TO ROWID rGoto.
        RETURN "ERRO".
    END.

    ASSIGN rGoto = ROWID(ttPed-item).
    RUN pi-atualiza-quantidades.
    /*{&OPEN-QUERY-brSon1}*/
    REPOSITION brSon1 TO ROWID rGoto.

    RUN pi-calcula-valor-alocado.

    RUN pi-marca-pedido.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza wMasterDetail 
PROCEDURE pi-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    blk_ped:
    DO TRANSACTION:

        ASSIGN l-limpo = NO.

        IF NOT CAN-FIND (FIRST repres
                         WHERE repres.nome-abrev =  ttped-venda.no-ab-reppri:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17006, 
                               INPUT "Representante informado nío esta cadastrado!").        

            ASSIGN l-mod = NOT l-mod.                               
            RETURN "NTR".
        END.

        ASSIGN c-frete                      = c-frete                        :SCREEN-VALUE IN FRAME {&FRAME-NAME}   /*INPUT FRAME fPage0 */
               c-transp                     = ttped-venda.nome-transp        :SCREEN-VALUE IN FRAME {&FRAME-NAME}   /*INPUT FRAME fPage0 */ 
               ttped-venda.nome-transp      = ttped-venda.nome-transp        :SCREEN-VALUE IN FRAME {&FRAME-NAME}   /*INPUT FRAME fPage0 */
               ttped-venda.observacoes      = ttped-venda.observacoes        :SCREEN-VALUE IN FRAME {&FRAME-NAME}   /*INPUT FRAME fPage0 */
               ttped-venda.cond-espec       = ttped-venda.cond-espec         :SCREEN-VALUE IN FRAME {&FRAME-NAME}   /*INPUT FRAME fPage0 */
               ttped-venda.cod-canal-venda  = int(ttped-venda.cod-canal-venda:SCREEN-VALUE IN FRAME {&FRAME-NAME})  /*INPUT FRAME fPage0 */
               ttped-venda.tp-pedido        = ttped-venda.tp-pedido          :SCREEN-VALUE IN FRAME {&FRAME-NAME}
               ttped-venda.ind-fat-par      = ttped-venda.ind-fat-par        :CHECKED IN FRAME {&FRAME-NAME}.  /*INPUT FRAME fPage0 */ 
               ttped-venda.no-ab-reppri     = ttped-venda.no-ab-reppri       :SCREEN-VALUE IN FRAME {&FRAME-NAME}.

        FIND FIRST ped-venda EXCLUSIVE-LOCK 
             WHERE ped-venda.nome-abrev = ttped-venda.nome-abrev 
               AND ped-venda.nr-pedcli  = ttped-venda.nr-pedcli NO-ERROR.
                                   
        IF AVAIL ped-venda THEN DO:   

            IF int(ttped-venda.tp-pedido) <> 70 AND 
               int(ttped-venda.tp-pedido) <> 99 THEN
                IF  int(ttped-venda.cod-canal-venda:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> 0 THEN DO:
                    FIND canal-venda
                        WHERE canal-venda.cod-canal-venda = int(ttped-venda.cod-canal-venda:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                        NO-LOCK NO-ERROR.
                    IF NOT AVAIL canal-venda THEN DO:
                        RUN utp/ut-msgs.p (INPUT "show":U, 
                                       INPUT 17006, 
                                       INPUT "Canal de vendas informado nío esta cadastrado!").        
                        ASSIGN l-mod = NOT l-mod.                               
                        RETURN "NTR".
                    END.
                END.
            IF c-frete = "CIF" THEN DO:
                IF c-transp = "" OR c-transp = " " THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show":U, 
                                       INPUT 17006, 
                                       INPUT "Transportador nao informado!~~No caso de frete CIF, um transportador deve ser informado!").        
                    ASSIGN l-mod = NOT l-mod.                               
                    RETURN "NTR".
                END.    
                
                ASSIGN ped-venda.cidade-cif                    = ttped-venda.cidade
                       ttped-venda.cidade-cif                  = ttped-venda.cidade
                       cidade-cif:SCREEN-VALUE IN FRAME fPage0 = "CIF".
    
                IF c-transp = "RETIRA" THEN DO:
                    ASSIGN ped-venda.nome-transp                                = c-transp
                           ttped-venda.nome-transp:SCREEN-VALUE IN FRAME fPage0 = c-transp
                           ttped-venda.nome-transp                              = c-transp
                           ped-venda.cod-rota                                   = ""
                           ped-venda.desc-valor-ped                             = 0
                           ped-venda.cidade-cif                                 = ""
                           ttped-venda.cidade-cif                               = ""
                           cidade-cif:SCREEN-VALUE IN FRAME fPage0              = "FOB".
                END. /* IF c-transp = "RETIRA" THEN DO: */
                ELSE DO:
                    ASSIGN ped-venda.nome-transp                                = c-transp 
                           ttped-venda.nome-transp:SCREEN-VALUE IN FRAME fPage0 = c-transp
                           ttped-venda.nome-transp                              = c-transp
                           ped-venda.cidade-cif                                 = ttped-venda.cidade
                           ttped-venda.cidade-cif                               = ttped-venda.cidade
                           cidade-cif:SCREEN-VALUE IN FRAME fPage0              = "CIF".
                END. /* IF c-transp <> "RETIRA" THEN DO: */
            END.
            ELSE DO:
                
                ASSIGN ped-venda.cidade-cif                                 = ""
                       cidade-cif:SCREEN-VALUE IN FRAME fPage0              = "FOB"
                       ttped-venda.cidade-cif                               = ""
                       c-transp:SCREEN-VALUE IN FRAME fPage0                = "RETIRA"
                       ttped-venda.nome-transp:SCREEN-VALUE IN FRAME fPage0 = "RETIRA"               
                       ped-venda.nome-transp                                = "RETIRA"
                       ttped-venda.nome-transp                              = "RETIRA"
                       ped-venda.cod-rota                                   = ""
                       ped-venda.desc-valor-ped                             = 0.
            END.    

            FOR FIRST ped-repre EXCLUSIVE-LOCK
                WHERE ped-repre.nr-pedido   = ped-venda.nr-pedido
                  AND ped-repre.nome-ab-rep = ped-venda.no-ab-reppri:
                ASSIGN ped-repre.nome-ab-rep = ttped-venda.no-ab-reppri:SCREEN-VALUE IN FRAME fPage0.
            END.

            ASSIGN ped-venda.observacoes     = ttped-venda.observacoes
                   ped-venda.cond-espec      = ttped-venda.cond-espec
                   ped-venda.cod-canal-venda = ttped-venda.cod-canal-venda
                   ped-venda.tp-pedido       = ttped-venda.tp-pedido   :SCREEN-VALUE IN FRAME fPage0
                   ped-venda.ind-fat-par     = ttped-venda.ind-fat-par :CHECKED IN FRAME fPage0
                   ped-venda.no-ab-reppri    = ttped-venda.no-ab-reppri:SCREEN-VALUE IN FRAME fPage0
                   .   

            IF ped-venda.dt-entrega <> DATE(ttped-venda.dt-entrega:SCREEN-VALUE IN FRAME fPage0) THEN DO:

                RUN esp/pdp/espdp006g.w (OUTPUT l-dt-entrega-pedido,
                                         OUTPUT l-dt-entrega-itens).
                

                IF l-dt-entrega-pedido THEN DO:
                    ASSIGN ttped-venda.dt-entrega = date(ttped-venda.dt-entrega:SCREEN-VALUE IN FRAME fPage0)
                           ped-venda.dt-entrega   = date(ttped-venda.dt-entrega:SCREEN-VALUE IN FRAME fPage0).
                END.

                IF l-dt-entrega-itens THEN DO:
                    FOR EACH bf-ped-item OF ped-venda EXCLUSIVE-LOCK
                       WHERE bf-ped-item.cod-sit-item < 3:
    
                        ASSIGN bf-ped-item.dt-entrega = date(ttped-venda.dt-entrega:SCREEN-VALUE IN FRAME fPage0).
                    END.
                END.
            
                /*RUN utp/ut-msgs.p (INPUT "Show",
                                   INPUT 27100,
                                   INPUT "Deseja alterar somente a data de Prev Faturamento do pedido?").
    
                IF  RETURN-VALUE = "YES" THEN DO:
                    ASSIGN ttped-venda.dt-entrega = date(ttped-venda.dt-entrega:SCREEN-VALUE IN FRAME fPage0)
                           ped-venda.dt-entrega   = date(ttped-venda.dt-entrega:SCREEN-VALUE IN FRAME fPage0).
                END.
                ELSE DO:
                    RUN utp/ut-msgs.p (INPUT "Show",
                                       INPUT 27100,
                                       INPUT " Deseja alterar somente a data de Prev Faturamento dos itens do pedido?").
                    IF  RETURN-VALUE = "YES" THEN DO:
                        FOR EACH bf-ped-item OF ped-venda EXCLUSIVE-LOCK
                            WHERE bf-ped-item.cod-sit-item < 3:
        
                             ASSIGN bf-ped-item.dt-entrega = date(ttped-venda.dt-entrega:SCREEN-VALUE IN FRAME fPage0).
                         END.
                    END.
                    ELSE DO:
                        RUN utp/ut-msgs.p (INPUT "Show",
                                           INPUT 27100,
                                           INPUT " Deseja alterar a data de Prev Faturamento do pedido e dos itens do pedido?").
                        IF  RETURN-VALUE = "YES" THEN DO:
                            ASSIGN ttped-venda.dt-entrega = date(ttped-venda.dt-entrega:SCREEN-VALUE IN FRAME fPage0)
                                   ped-venda.dt-entrega   = date(ttped-venda.dt-entrega:SCREEN-VALUE IN FRAME fPage0).

                            FOR EACH bf-ped-item OF ped-venda EXCLUSIVE-LOCK
                               WHERE bf-ped-item.cod-sit-item < 3:
            
                                ASSIGN bf-ped-item.dt-entrega = date(ttped-venda.dt-entrega:SCREEN-VALUE IN FRAME fPage0).
                            END.
                        END.
                    END.
                END.*/
            END.
            
            /* Alteraªío da prioridade - tem que reabrir a query */
            IF ped-venda.cod-priori <> int(ttped-venda.cod-priori:SCREEN-VALUE IN FRAME fPage0) THEN DO:

                ASSIGN ped-venda.cod-priori = int(ttped-venda.cod-priori:SCREEN-VALUE IN FRAME fPage0).
    
                       
                RUN getNext IN {&hDBOParent}.
    
                IF RETURN-VALUE = "NOK" THEN DO:
                    RUN getPrev IN {&hDBOParent}.
    
                    IF RETURN-VALUE = "NOK":U THEN DO:
                        FOR EACH ttped-item: DELETE ttped-item. END. 
                        {&OPEN-QUERY-{&BROWSE-NAME}}
                        ASSIGN l-limpo = YES.
                    END.
                END.
                
                IF l-limpo = NO THEN DO:
                    RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
                    RUN getKey IN {&hDBOParent} (OUTPUT c-nome-abrev-sel,
                                                 OUTPUT c-nr-pedcli-sel ).
                END.
        
                RUN pi-carrega-pedidos IN {&hDBOParent} (INPUT vEstabel-ini, 
                                                         INPUT vEstabel-fim, 
                                                         INPUT vAtendente-ini,
                                                         INPUT vAtendente-fim,
                                                         INPUT vRepres-ini,
                                                         INPUT vRepres-fim,
                                                         INPUT vEntrega-ini,
                                                         INPUT vEntrega-fim,
                                                         INPUT vPedido-ini,
                                                         INPUT vPedido-fim,
                                                         INPUT vImpPed-ini,
                                                         INPUT vImpPed-fim,
                                                         INPUT vCond-ini,
                                                         INPUT vCond-fim,
                                                         INPUT vPrior-ini,
                                                         INPUT vPrior-fim,
                                                         INPUT voperMestreIni,
                                                         INPUT voperMestreFim,
                                                         INPUT vItCodigo,
                                                         INPUT vUnid-Neg,
                                                         INPUT vCodSitAval,
                                                         INPUT vEntFutura,
                                                         INPUT vParcMinima,
                                                         INPUT TABLE tt-estab-depos) NO-ERROR.
                
                RUN openQueryStatic IN {&hDBOParent} (INPUT "Navega":U) NO-ERROR.
                
                /*aqui*/
                IF l-limpo = NO THEN DO:
                    RUN goToKey IN {&hDBOParent} (INPUT c-nome-abrev-sel, 
                                                  INPUT c-nr-pedcli-sel ).
                    RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
                    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo) NO-ERROR.    
                END.
                ELSE 
                    RUN repositionRecord IN THIS-PROCEDURE (INPUT ?) NO-ERROR.    

                /* tem que retornar ok senío a transaªío nao eh efetivada - hahahaha */
                RUN retornaOK.
            END.        
        END.  
    END.

    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nome-abrev = ttped-venda.nome-abrev:SCREEN-VALUE IN FRAME fPage0 
           AND ped-venda.nr-pedcli  = ttped-venda.nr-pedcli :SCREEN-VALUE IN FRAME fPage0  NO-ERROR.
    
    ENABLE btFirst
           btPrev
           btNext
           btLast
           btGoto
           btSel
           btExtra
           btPedido WITH FRAME fPage0.

    ENABLE brSon1 WITH FRAME fPage1.

    ASSIGN MENU-ITEM miFirst:SENSITIVE IN MENU smFile = TRUE
           MENU-ITEM miPrev :SENSITIVE IN MENU smFile = TRUE
           MENU-ITEM miNext :SENSITIVE IN MENU smFile = TRUE
           MENU-ITEM miLast :SENSITIVE IN MENU smFile = TRUE
           MENU-ITEM miGoto :SENSITIVE IN MENU smFile = TRUE
           MENU-ITEM miSel  :SENSITIVE IN MENU smFile = TRUE
           MENU-ITEM miFat  :SENSITIVE IN MENU smFile = TRUE
           MENU-ITEM miExtra:SENSITIVE IN MENU smFile = TRUE 
           MENU-ITEM miDet  :SENSITIVE IN MENU smFile = TRUE.

    btMod:LOAD-IMAGE("image/im-mod.bmp") IN FRAME fPage0.
    DISABLE ttped-venda.cod-priori 
            ttPed-venda.observacoes
            ttPed-venda.cond-espec
            ttped-venda.cod-canal-venda 
            ttped-venda.tp-pedido
            ttped-venda.dt-entrega
            ttped-venda.ind-fat-par
            ttped-venda.no-ab-reppri
            cod-transp
            WITH FRAME fPage0.

    ASSIGN cidade-cif                 :VISIBLE IN FRAME fPage0      = TRUE
           c-frete                    :VISIBLE IN FRAME fPage0      = FALSE
           c-transp                   :VISIBLE IN FRAME fPage0      = FALSE
           ttped-venda.observacoes    :READ-ONLY IN FRAME fPage0    = TRUE       
           ttped-venda.cond-espec     :READ-ONLY IN FRAME fPage0    = TRUE
           ttped-venda.cod-canal-venda:READ-ONLY IN FRAME fPage0    = TRUE 
           cod-transp                 :READ-ONLY IN FRAME fPage0    = TRUE. 

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-quantidades wMasterDetail 
PROCEDURE pi-atualiza-quantidades :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 ASSIGN d-estoque:SCREEN-VALUE IN BROWSE brSon1 = STRING(fnEstoque(c-cod-estabel, ttped-item.it-codigo, vCod-depos, vLocalizacao, no)) 
        i-aloca  :SCREEN-VALUE IN BROWSE brSon1 = STRING(ttPed-item.qt-log-aloca)
        d-saldo  :SCREEN-VALUE IN BROWSE brSon1 = STRING(ttped-item.qt-pedida - ttped-item.qt-atendida - ttped-item.qt-log-aloca).

 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-valor-alocado wMasterDetail 
PROCEDURE pi-calcula-valor-alocado :
DEFINE VARIABLE de-valor-st AS DECIMAL  NO-UNDO.
DEFINE VARIABLE d-ipi-trib  AS INT      NO-UNDO.
DEFINE BUFFER b-item FOR item.
    

    ASSIGN de-vl-total-alocado = 0
           de-ps-total-alocado = 0
           de-vl-ipi-alocado   = 0
           de-vl-st-alocado    = 0
           de-valor-st         = 0
           de-vl-total         = 0.

    
    FOR EACH  b-ped-item
        WHERE b-ped-item.nome-abrev = ttped-venda.nome-abrev
          AND b-ped-item.nr-pedcli  = ttped-venda.nr-pedcli
          AND b-ped-item.cod-sit-item < 3 NO-LOCK,
        FIRST natur-oper NO-LOCK
        WHERE natur-oper.nat-operacao = b-ped-item.nat-operacao,
        FIRST b-item
        WHERE b-item.it-codigo = b-ped-item.it-codigo NO-LOCK:

        assign d-ipi-trib = if  natur-oper.cd-trib-ipi = 1
                                then if  b-item.cd-trib-ipi = 1
                                     or  b-item.cd-trib-ipi = 4
                                     then 1
                                     else b-item.cd-trib-ipi
                                else if  natur-oper.cd-trib-ipi = 2
                                     or  natur-oper.cd-trib-ipi = 3
                                     then natur-oper.cd-trib-ipi
                                     else b-item.cd-trib-ipi.

        ASSIGN  de-vl-total = de-vl-total + (b-ped-item.qt-pedida - b-ped-item.qt-atendida) * b-ped-item.vl-preuni.

        IF   b-ped-item.qt-log-aloc <> 0 THEN DO:
             ASSIGN de-vl-total-alocado = de-vl-total-alocado + (b-ped-item.qt-log-aloc * b-ped-item.vl-preuni)
                    de-ps-total-alocado = de-ps-total-alocado + (b-ped-item.qt-log-aloc * b-item.peso-bruto).

             IF d-ipi-trib = 1 THEN
                 ASSIGN de-vl-ipi-alocado   = de-vl-ipi-alocado + ROUND((b-ped-item.qt-log-aloc * b-ped-item.vl-preuni * b-ped-item.aliquota-ipi / 100),2).

            IF  natur-oper.subs-trib THEN
                ASSIGN de-vl-st-alocado = de-vl-st-alocado + ROUND(((b-ped-item.vl-tot-it - b-ped-item.vl-liq-it -
                       (b-ped-item.qt-pedida * b-ped-item.vl-preuni) * (b-ped-item.aliquota-ipi / 100)) / b-ped-item.qt-pedida) * b-ped-item.qt-log-aloc,2).
        END.
    END.

    DISPLAY de-vl-total-alocado
            de-ps-total-alocado
            de-vl-ipi-alocado
            de-vl-st-alocado
        WITH FRAME fpage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cancela-pedido-dupli wMasterDetail 
PROCEDURE pi-cancela-pedido-dupli :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE bo-ped-venda-can    AS HANDLE    NO-UNDO.

    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nr-pedcli = bint-pedido-vtex.nr-pedcli NO-ERROR.
    IF AVAIL ped-venda THEN DO:

        FOR FIRST int-ped-venda EXCLUSIVE-LOCK
            WHERE int-ped-venda.nr-pedido = int(bint-pedido-vtex.nr-pedcli):
            DELETE int-ped-venda.
        END.
    
        FOR FIRST int-ped-venda2 EXCLUSIVE-LOCK
            WHERE int-ped-venda2.nr-pedido   = int(bint-pedido-vtex.nr-pedcli):
            DELETE int-ped-venda2.
        END.

        FOR EACH int-ocorrencias-vtex EXCLUSIVE-LOCK
           WHERE int-ocorrencias-vtex.nr-pedido     = bint-pedido-vtex.nr-pedido    
             AND int-ocorrencias-vtex.seq-pedido    = bint-pedido-vtex.seq-pedido   
             AND int-ocorrencias-vtex.dt-integracao = bint-pedido-vtex.dt-integracao
             AND int-ocorrencias-vtex.hr-integracao = bint-pedido-vtex.hr-integracao:
            DELETE int-ocorrencias-vtex.
        END.

        FIND FIRST btt-ped-venda-aux
             WHERE btt-ped-venda-aux.nr-pedcli = bint-pedido-vtex.nr-pedcli NO-ERROR.
        IF AVAIL btt-ped-venda-aux THEN
            DELETE btt-ped-venda-aux.

        DELETE bint-pedido-vtex.

        IF NOT VALID-HANDLE(bo-ped-venda-can) 
        OR bo-ped-venda-can:TYPE <> "PROCEDURE":U 
        OR bo-ped-venda-can:FILE-NAME <> "dibo/bodi159can.p" THEN
            RUN dibo/bodi159can.p PERSISTENT SET bo-ped-venda-can.

        FIND FIRST emitente
             WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.

        RUN emptyRowErrors  IN bo-ped-venda-can.
        RUN setUserLog IN bo-ped-venda-can (INPUT c-seg-usuario).
        RUN validateCancelation IN bo-ped-venda-can (INPUT  ROWID(ped-venda),
                                                     OUTPUT TABLE Rowerrors).
        IF NOT CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorType <> "INTERNAL"
                          AND RowErrors.ErrorSubType = "Error":U) THEN DO:
            RUN updateCancelation    IN bo-ped-venda-can(INPUT ROWID(ped-venda),
                                                         INPUT "Cancelamento por pedido em duplicidade no ecommerce.",
                                                         INPUT TODAY,
                                                         INPUT 13).

        END.

        IF VALID-HANDLE (bo-ped-venda-can) THEN DO:
            DELETE PROCEDURE bo-ped-venda-can.
            ASSIGN bo-ped-venda-can = ?.
        END.
    END.
 
    RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-converte-moeda wMasterDetail 
PROCEDURE pi-converte-moeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output param de-valor-aberto like ped-venda.vl-liq-abe.

def var i-moeda          as integer no-undo.
def var de-fator-2       like de-fator-1 init 1 no-undo.

    ASSIGN i-moeda = 0.
    
    if  avail ped-venda then do:
        if  ped-venda.mo-codigo = 0 then 
            assign de-fator-1 = 1.
        else do:
             
            find first cotacao
                where cotacao.mo-codigo   = ped-venda.mo-codigo
                and   cotacao.ano-periodo = string(year(TODAY)) + string(month(TODAY),"99")
                and   cotacao.cotacao[int(day(TODAY))] <> 0 no-lock no-error.
    
            if  avail cotacao then
                assign de-fator-1 = cotacao.cotacao[int(day(TODAY))].
    
        end.
    
        if  i-moeda <> 0 then do:
            
            find first cotacao
                where cotacao.mo-codigo   = i-moeda
                and   cotacao.ano-periodo = string(year(TODAY)) + string(month(TODAY),"99")
                and   cotacao.cotacao[int(day(TODAY))] <> 0 no-lock no-error.
    
            if  avail cotacao then
                assign de-fator-2 = cotacao.cotacao[int(day(TODAY))].
    
        end.
        else assign de-fator-2 = 1.
    
        assign de-valor-aberto = ped-venda.vl-liq-abe * de-fator-1 / de-fator-2.
        
    end.                          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desaloca wMasterDetail 
PROCEDURE pi-desaloca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt-item: DELETE tt-item. END. 
    FOR EACH tt-erro: DELETE tt-erro. END. 
    
    ASSIGN cReturn = "".

    BLOCO:
    DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:
        FOR FIRST mgesp.ponto-programa
            WHERE ponto-programa.nome-programa = "espdp006"
              AND ponto-programa.ponto         = 1,   /* Centrais Embratel */
             EACH mgesp.conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
              AND conteudo-programa.sequencia = int(ttped-venda.tp-pedido):
            IF index(conteudo-programa.conteudo,c-seg-usuario) = 0 THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                               INPUT 17006, 
                                               INPUT "Permiss∆o para alocaá∆o do pedido restrita, somente estes usuarios podem alocar: " + conteudo-programa.conteudo).
                ASSIGN cReturn = "NOK".                
                UNDO, LEAVE Bloco.   
            END.
        END.
    
        FIND FIRST permissao-alocacao
             WHERE permissao-alocacao.it-codigo = ttped-item.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL permissao-alocacao AND
           permissao-alocacao.usuario <> c-seg-usuario THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                                           INPUT 17006, 
                                           INPUT "Usuario sem permiss∆o para alocaá∆o deste item. Este item esta bloqueado pelo usuario : " + permissao-alocacao.usuario).
            ASSIGN cReturn = "NOK".                
            UNDO, LEAVE Bloco.   
        END.
        
        FIND FIRST ped-ent 
             WHERE ped-ent.nome-abrev   = ttped-item.nome-abrev  
               AND ped-ent.nr-pedcli    = ttped-item.nr-pedcli   
               AND ped-ent.nr-sequencia = ttped-item.nr-sequencia
               AND ped-ent.it-codigo    = ttped-item.it-codigo   
               AND ped-ent.cod-refer    = ttped-item.cod-refer NO-LOCK NO-ERROR.

        IF NOT AVAIL ped-ent THEN DO:
            ASSIGN cReturn = "NOK" .
            UNDO, LEAVE Bloco.
        END.    
        
        FIND FIRST ped-ent 
             WHERE ped-ent.nome-abrev   = ttped-item.nome-abrev  
               AND ped-ent.nr-pedcli    = ttped-item.nr-pedcli   
               AND ped-ent.nr-sequencia = ttped-item.nr-sequencia
               AND ped-ent.it-codigo    = ttped-item.it-codigo   
               AND ped-ent.cod-refer    = ttped-item.cod-refer NO-LOCK NO-ERROR.
        IF NOT AVAIL ped-ent THEN DO:
            ASSIGN cReturn = "NOK" .
            UNDO, LEAVE Bloco.
        END.
        
        ASSIGN vQtAlocar = ttPed-item.qt-log-aloca - INTEGER(ttPed-item.qt-log-aloca:SCREEN-VALUE IN BROWSE brSon1). 

        /* 
        EFETUA  A DESALOCAÄ«O FISICA DOS ITENS DO PEDIDO SELECIONADO 
        */
    
        ASSIGN vQtAlocar-aux = vQtAlocar.

        blk_saldo:
        FOR EACH ped-saldo NO-LOCK
           WHERE ped-saldo.cod-depos   = vCod-depos  
             AND ped-saldo.cod-estabel = ttped-venda.cod-estabel 
             AND ped-saldo.nome-abrev  = ped-ent.nome-abrev      
             AND ped-saldo.nr-pedcli   = ped-ent.nr-pedcli       
             AND ped-saldo.nr-seq-item = ped-ent.nr-sequencia    
             AND ped-saldo.it-codigo   = ped-ent.it-codigo       
             AND ped-saldo.cod-refer   = ped-ent.cod-refer       
             AND ped-saldo.nr-entrega  = ped-ent.nr-entrega:

            /*IF vLocalizacao = "*" THEN
                FIND FIRST saldo-estoq NO-LOCK
                     WHERE saldo-estoq.cod-estabel = ttped-venda.cod-estabel
                       AND saldo-estoq.it-codigo   = ttped-item.it-codigo
                       AND saldo-estoq.cod-depos   = vCod-depos  
                       AND saldo-estoq.cod-localiz = ""
                       AND saldo-estoq.qt-aloc-ped > 0 NO-ERROR.
            ELSE 
                FIND FIRST saldo-estoq NO-LOCK
                     WHERE saldo-estoq.cod-estabel = ttped-venda.cod-estabel
                       AND saldo-estoq.it-codigo   = ttped-item.it-codigo
                       AND saldo-estoq.cod-depos   = vCod-depos  
                       AND saldo-estoq.cod-localiz = vLocalizacao
                       AND saldo-estoq.qt-aloc-ped > 0 NO-ERROR.*/

            FIND FIRST saldo-estoq OF ped-saldo NO-LOCK NO-ERROR.
    
            IF NOT AVAIL saldo-estoq THEN DO:
                ASSIGN cReturn = "NOK" .
                UNDO, LEAVE Bloco.
            END.

            IF ped-saldo.qt-aloc-ped >= vQtAlocar-aux THEN
                ASSIGN vQtAlocar-param = vQtAlocar-aux
                       vQtAlocar-aux   = 0.
            ELSE 
                ASSIGN vQtAlocar-param = ped-saldo.qt-aloc-ped
                       vQtAlocar-aux   = vQtAlocar-aux - ped-saldo.qt-aloc-ped.
            
            RUN pdp/pdapi002.p PERSISTENT SET h-alocacao.    
            RUN pi-desaloca-fisica-man in h-alocacao(INPUT ROWID(ped-ent),
                                                     INPUT-OUTPUT vQtAlocar-param, 
                                                     INPUT ROWID(saldo-estoq)).

            IF VALID-HANDLE(h-alocacao) THEN
                DELETE PROCEDURE h-alocacao.

            
            IF RETURN-VALUE = "NOK" THEN DO:
    
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 17006, 
                                   INPUT "N∆o foi possivel efetuar a desalocaá∆o f°sica do material!").
                
                ASSIGN cReturn = "NOK".
                UNDO BLOCO, LEAVE BLOCO.        
            END.

            IF vQtAlocar-aux = 0 THEN
                LEAVE blk_saldo.
        END.
        
        FIND FIRST item-uni-estab NO-LOCK
             WHERE item-uni-estab.cod-estabel = ttped-venda.cod-estabel
               AND item-uni-estab.it-codigo   = ttped-item.it-codigo
               AND item-uni-estab.nr-linha    = 20 NO-ERROR.

        IF AVAIL item-uni-estab THEN DO:
            RUN esapi\esapi009.p (input ttped-venda.cod-estabel,
                                  INPUT ttped-item.it-codigo,
                                  INPUT vCod-depos,  
                                  INPUT IF vLocalizacao = "*" THEN "" ELSE vLocalizacao,
                                  INPUT vQtAlocar,
                                  OUTPUT TABLE tt-erro).

            
            /*Conforme Anderson Cenci deve ignorar este erro*/
            FOR EACH tt-erro
               WHERE tt-erro.cd-erro = 27607:
                DELETE tt-erro.
            END.

            IF CAN-FIND(FIRST tt-erro) THEN DO:
                ASSIGN cReturn = "NOK".
                UNDO, LEAVE Bloco.        
            END.
            ELSE    
                ASSIGN cReturn = "OK".            
        END.
        ELSE
            ASSIGN cReturn = "OK".
    
        IF cReturn = "OK":U AND
           CAN-FIND(FIRST int-ped-item-astec
                    WHERE int-ped-item-astec.nome-abrev   = ttped-item.nome-abrev
                      AND int-ped-item-astec.nr-pedcli    = ttped-item.nr-pedcli
                      AND int-ped-item-astec.nr-sequencia = ttped-item.nr-sequencia
                      AND int-ped-item-astec.it-codigo    = ttped-item.it-codigo) THEN DO:
            EMPTY TEMP-TABLE RowErrors.
    
            IF  NOT VALID-HANDLE(h-esapi018)                  OR
                h-esapi018:TYPE      <> "PROCEDURE":U         OR
               (h-esapi018:FILE-NAME <> "esapi/esapi018.p":U  AND
                h-esapi018:FILE-NAME <> "esapi/esapi018.r":U) THEN
                RUN esapi/esapi018.p PERSISTENT SET h-esapi018.
    
            IF VALID-HANDLE(h-esapi018) THEN DO:
                RUN alocarDesalocarPedItemAstec IN h-esapi018 (INPUT ttped-item.nome-abrev,
                                                               INPUT ttped-item.nr-pedcli,
                                                               INPUT ttped-item.nr-sequencia,
                                                               INPUT ttped-item.it-codigo,
                                                               INPUT 2,
                                                               INPUT de-desaloca-item-astec).
    
                IF RETURN-VALUE = "NOK":U THEN
                    RUN getRowErrors IN h-esapi018 (OUTPUT TABLE RowErrors).
            END.
    
            IF VALID-HANDLE(h-esapi018) THEN
                RUN destroy IN h-esapi018.
    
            IF VALID-HANDLE(h-esapi018) THEN
                DELETE PROCEDURE h-esapi018.
    
            ASSIGN h-esapi018 = ?.
    
            IF CAN-FIND(FIRST RowErrors) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="YES"}
                {method/showmessage.i3}
    
                ASSIGN cReturn = "NOK":U.
    
                UNDO BLOCO, LEAVE BLOCO.
            END.
        END.
    END. /* DO TRANSACTION */

    FIND FIRST bf-ped-item OF ttped-item NO-LOCK NO-ERROR.
    
    IF AVAIL bf-ped-item  THEN DO:
        ASSIGN ttped-item.qt-pedida    = bf-ped-item.qt-pedida   
               ttped-item.qt-atendida  = bf-ped-item.qt-atendida 
               ttped-item.qt-log-aloca = bf-ped-item.qt-log-aloca.
    END.

    IF CAN-FIND(FIRST tt-erro) THEN DO:
        RUN cdp/cd0666.w (INPUT TABLE tt-erro).
        RETURN "ERRO".
    END.

    ASSIGN rGoto = ROWID(ttPed-item).
    RUN pi-atualiza-quantidades.
    REPOSITION brSon1 TO ROWID rGoto.

    RUN pi-calcula-valor-alocado.

    IF VALID-HANDLE(h-alocacao) THEN
       DELETE PROCEDURE h-alocacao.
    

    RUN pi-marca-pedido.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desaloca-tudo wMasterDetail 
PROCEDURE pi-desaloca-tudo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt-item: DELETE tt-item. END. 
    FOR EACH tt-erro: DELETE tt-erro. END. 
    
    ASSIGN cReturn = "".

    BLOCO:
    DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:
        FOR FIRST mgesp.ponto-programa
            WHERE ponto-programa.nome-programa = "espdp006"
              AND ponto-programa.ponto         = 1,   /* Centrais Embratel */
             EACH mgesp.conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
              AND conteudo-programa.sequencia = int(ttped-venda.tp-pedido):
            IF index(conteudo-programa.conteudo,c-seg-usuario) = 0 THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                               INPUT 17006, 
                                               INPUT "Permiss∆o para alocaá∆o do pedido restrita, somente estes usuarios podem alocar: " + conteudo-programa.conteudo).
                ASSIGN cReturn = "NOK".                
                UNDO, LEAVE Bloco.   
            END.
        END.
    
        FIND FIRST permissao-alocacao
             WHERE permissao-alocacao.it-codigo = ttped-item.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL permissao-alocacao AND
           permissao-alocacao.usuario <> c-seg-usuario THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                                           INPUT 17006, 
                                           INPUT "Usuario sem permiss∆o para alocaá∆o deste item. Este item esta bloqueado pelo usuario : " + permissao-alocacao.usuario).
            ASSIGN cReturn = "NOK".                
            UNDO, LEAVE Bloco.   
        END.
        
        IF AVAIL ttPed-venda THEN DO:

           FOR EACH ttped-item OF ttPed-venda:
           
                 FIND FIRST ped-ent 
                      WHERE ped-ent.nome-abrev   = ttped-item.nome-abrev  
                        AND ped-ent.nr-pedcli    = ttped-item.nr-pedcli   
                        AND ped-ent.nr-sequencia = ttped-item.nr-sequencia
                        AND ped-ent.it-codigo    = ttped-item.it-codigo   
                        AND ped-ent.cod-refer    = ttped-item.cod-refer NO-LOCK NO-ERROR.
           
                 IF NOT AVAIL ped-ent THEN DO:
                     ASSIGN cReturn = "NOK" .
                     UNDO, LEAVE Bloco.
                 END.    
                 
                 FIND FIRST ped-ent 
                      WHERE ped-ent.nome-abrev   = ttped-item.nome-abrev  
                        AND ped-ent.nr-pedcli    = ttped-item.nr-pedcli   
                        AND ped-ent.nr-sequencia = ttped-item.nr-sequencia
                        AND ped-ent.it-codigo    = ttped-item.it-codigo   
                        AND ped-ent.cod-refer    = ttped-item.cod-refer NO-LOCK NO-ERROR.
                 IF NOT AVAIL ped-ent THEN DO:
                     ASSIGN cReturn = "NOK" .
                     UNDO, LEAVE Bloco.
                 END.
                 
                 ASSIGN vQtAlocar = INTEGER(ttPed-item.qt-log-aloca:SCREEN-VALUE IN BROWSE brSon1). 
           
                 /* 
                 EFETUA  A DESALOCAÄ«O FISICA DOS ITENS DO PEDIDO SELECIONADO 
                 */
                 ASSIGN vQtAlocar-aux = vQtAlocar.
           
                 blk_saldo:
                 FOR EACH ped-saldo NO-LOCK
                    WHERE ped-saldo.cod-depos   = vCod-depos  
                      AND ped-saldo.cod-estabel = ttped-venda.cod-estabel 
                      AND ped-saldo.nome-abrev  = ped-ent.nome-abrev      
                      AND ped-saldo.nr-pedcli   = ped-ent.nr-pedcli       
                      AND ped-saldo.nr-seq-item = ped-ent.nr-sequencia    
                      AND ped-saldo.it-codigo   = ped-ent.it-codigo       
                      AND ped-saldo.cod-refer   = ped-ent.cod-refer       
                      AND ped-saldo.nr-entrega  = ped-ent.nr-entrega:

                     FIND FIRST saldo-estoq OF ped-saldo NO-LOCK NO-ERROR.
             
                     IF NOT AVAIL saldo-estoq THEN DO:
                         ASSIGN cReturn = "NOK" .
                         UNDO, LEAVE Bloco.
                     END.
           
                     IF ped-saldo.qt-aloc-ped >= vQtAlocar-aux THEN
                         ASSIGN vQtAlocar-param = vQtAlocar-aux
                                vQtAlocar-aux   = 0.
                     ELSE 
                         ASSIGN vQtAlocar-param = ped-saldo.qt-aloc-ped
                                vQtAlocar-aux   = vQtAlocar-aux - ped-saldo.qt-aloc-ped.
                         
                     RUN pdp/pdapi002.p PERSISTENT SET h-alocacao.    
                     RUN pi-desaloca-fisica-man in h-alocacao(INPUT ROWID(ped-ent),
                                                              INPUT-OUTPUT vQtAlocar-param, 
                                                              INPUT ROWID(saldo-estoq)).
           
                     IF VALID-HANDLE(h-alocacao) THEN
                         DELETE PROCEDURE h-alocacao.
           
                     
                     IF RETURN-VALUE = "NOK" THEN DO:
             
                         RUN utp/ut-msgs.p (INPUT "show":U, 
                                            INPUT 17006, 
                                            INPUT "N∆o foi possivel efetuar a desalocaá∆o f°sica do material!").
                         
                         ASSIGN cReturn = "NOK".
                         UNDO BLOCO, LEAVE BLOCO.        
                     END.
           
                     IF vQtAlocar-aux = 0 THEN
                         LEAVE blk_saldo.
                 END.
                 
                 FIND FIRST item-uni-estab NO-LOCK
                      WHERE item-uni-estab.cod-estabel = ttped-venda.cod-estabel
                        AND item-uni-estab.it-codigo   = ttped-item.it-codigo
                        AND item-uni-estab.nr-linha    = 20 NO-ERROR.
           
                 IF AVAIL item-uni-estab THEN DO:
                     RUN esapi\esapi009.p (input ttped-venda.cod-estabel,
                                           INPUT ttped-item.it-codigo,
                                           INPUT vCod-depos,  
                                           INPUT IF vLocalizacao = "*" THEN "" ELSE vLocalizacao,
                                           INPUT vQtAlocar,
                                           OUTPUT TABLE tt-erro).
           
                     
                     /*Conforme Anderson Cenci deve ignorar este erro*/
                     FOR EACH tt-erro
                        WHERE tt-erro.cd-erro = 27607:
                         DELETE tt-erro.
                     END.
           
                     IF CAN-FIND(FIRST tt-erro) THEN DO:
                         ASSIGN cReturn = "NOK".
                         UNDO, LEAVE Bloco.        
                     END.
                     ELSE    
                         ASSIGN cReturn = "OK".            
                 END.
                 ELSE
                     ASSIGN cReturn = "OK".
             
                 IF cReturn = "OK":U AND
                    CAN-FIND(FIRST int-ped-item-astec
                             WHERE int-ped-item-astec.nome-abrev   = ttped-item.nome-abrev
                               AND int-ped-item-astec.nr-pedcli    = ttped-item.nr-pedcli
                               AND int-ped-item-astec.nr-sequencia = ttped-item.nr-sequencia
                               AND int-ped-item-astec.it-codigo    = ttped-item.it-codigo) THEN DO:
                     EMPTY TEMP-TABLE RowErrors.
             
                     IF  NOT VALID-HANDLE(h-esapi018)                  OR
                         h-esapi018:TYPE      <> "PROCEDURE":U         OR
                        (h-esapi018:FILE-NAME <> "esapi/esapi018.p":U  AND
                         h-esapi018:FILE-NAME <> "esapi/esapi018.r":U) THEN
                         RUN esapi/esapi018.p PERSISTENT SET h-esapi018.
             
                     IF VALID-HANDLE(h-esapi018) THEN DO:
                         RUN alocarDesalocarPedItemAstec IN h-esapi018 (INPUT ttped-item.nome-abrev,
                                                                        INPUT ttped-item.nr-pedcli,
                                                                        INPUT ttped-item.nr-sequencia,
                                                                        INPUT ttped-item.it-codigo,
                                                                        INPUT 2,
                                                                        INPUT de-desaloca-item-astec).
             
                         IF RETURN-VALUE = "NOK":U THEN
                             RUN getRowErrors IN h-esapi018 (OUTPUT TABLE RowErrors).
                     END.
             
                     IF VALID-HANDLE(h-esapi018) THEN
                         RUN destroy IN h-esapi018.
             
                     IF VALID-HANDLE(h-esapi018) THEN
                         DELETE PROCEDURE h-esapi018.
             
                     ASSIGN h-esapi018 = ?.
             
                     IF CAN-FIND(FIRST RowErrors) THEN DO:
                         {method/showmessage.i1}
                         {method/showmessage.i2 &Modal="YES"}
                         {method/showmessage.i3}
             
                         ASSIGN cReturn = "NOK":U.
             
                         UNDO BLOCO, LEAVE BLOCO.
                     END.
                 END.
             END. /* DO TRANSACTION */
        END. //fim tt-peditem
    END. //avail tt-ped-venda.


    IF AVAIL ttped-venda THEN DO:
      FOR EACH ttped-item OF ttped-venda:
     
          FIND FIRST bf-ped-item OF ttped-item NO-LOCK NO-ERROR.
     
          IF AVAIL bf-ped-item  THEN DO:
             ASSIGN ttped-item.qt-pedida    = bf-ped-item.qt-pedida   
                    ttped-item.qt-atendida  = bf-ped-item.qt-atendida 
                    ttped-item.qt-log-aloca = bf-ped-item.qt-log-aloca.
          END.
          RUN pi-atualiza-quantidades.          
      END.
    END.

    IF CAN-FIND(FIRST tt-erro) THEN DO:
        RUN cdp/cd0666.w (INPUT TABLE tt-erro).
        RETURN "ERRO".
    END.

   // ASSIGN rGoto = ROWID(ttPed-item).
    //RUN pi-atualiza-quantidades.
   // REPOSITION brSon1 TO ROWID rGoto.

    RUN pi-calcula-valor-alocado.
    
    IF VALID-HANDLE(h-alocacao) THEN
       DELETE PROCEDURE h-alocacao.
    
    RUN pi-marca-pedido.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-enviar-email wMasterDetail 
PROCEDURE pi-enviar-email :
/*------------------------------------------------------------------------------
  Purpose:     Enviar email informando que um Pedido com Material Faltante est†
               sendo liberado.
  Parameters:  <none>
  Notes:       Envia o email para os usu†rios que est∆o cadastrados no ES0018
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-dest     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-texto    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-utapi019 AS HANDLE      NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF  NOT AVAIL ttped-venda THEN
        RETURN "OK":U.

    FOR FIRST mgesp.ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "espdp006"
        AND   ponto-programa.ponto         = 9, /* Usu†rio que receber∆o email */
        EACH  mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        ASSIGN c-dest = c-dest + conteudo-programa.conteudo + ";".
    END.

    IF  c-dest = "" THEN
        RETURN "OK":U.

    /* Busca os Itens do Pedido para enviar por email */
    FOR EACH ttped-item NO-LOCK:
        FIND FIRST item NO-LOCK
            WHERE  item.it-codigo = ttped-item.it-codigo NO-ERROR.
        IF  NOT AVAIL item THEN
            NEXT.

        ASSIGN c-texto = c-texto + 
                         STRING(ttped-item.it-codigo, "x(20)") + " - " +
                         STRING(item.descricao-1, "x(40)")             +
                         STRING(ttped-item.qt-log-aloca, ">>>,>>9.99") +
                         CHR(13).
    END.


    IF  NOT VALID-HANDLE(h-utapi019) THEN
        RUN utp/utapi019.p PERSISTENT SET h-utapi019.


    EMPTY TEMP-TABLE tt-envio2.
    EMPTY TEMP-TABLE tt-mensagem.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail
           tt-envio2.porta             = param-global.porta-mail
           tt-envio2.remetente         = "intelbras@intelbras.com.br"
           tt-envio2.destino           = c-dest
           tt-envio2.assunto           = "MATERIAL FALTANTE - Pedido: " + ttped-venda.nr-pedcli
           tt-envio2.formato           = "TEXTO".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "Pedido Liberado para Faturamento."    + CHR(13) +
                                      "Pedido: " + ttped-venda.nr-pedcli     + " Cliente: " + ttped-venda.nome-abrev + CHR(13) + CHR(13) +
                                      STRING("Item", "x(62)") + "Quantidade" + CHR(13) +
                                      FILL("-", 73)     + CHR(13) +
                                      c-texto + CHR(13) + CHR(13) +
                                      "<E-mail autom†tico. N∆o responda>".

    IF  VALID-HANDLE(h-utapi019) THEN
        RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).


    IF  VALID-HANDLE(h-utapi019) THEN
        DELETE PROCEDURE h-utapi019.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-impede-fatur-depositos-diferente wMasterDetail 
PROCEDURE pi-impede-fatur-depositos-diferente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF BUFFER b-ped-saldo FOR ped-saldo.

    FOR EACH ped-saldo NO-LOCK
        WHERE ped-saldo.nr-pedcli   = ttped-venda.nr-pedcli
          AND ped-saldo.nome-abrev  = ttped-venda.nome-abrev
          AND ped-saldo.qt-aloc-ped > 0:

        FIND FIRST  b-ped-saldo NO-LOCK
             WHERE b-ped-saldo.nr-pedcli  = ped-saldo.nr-pedcli  
               AND b-ped-saldo.nome-abrev = ped-saldo.nome-abrev
               AND b-ped-saldo.cod-depos  <> ped-saldo.cod-depos
               AND b-ped-saldo.qt-aloc-ped > 0
               NO-ERROR.

        IF  AVAIL b-ped-saldo THEN DO:
            RUN utp/ut-msgs.p ("show",
                               17006,
                               "Tentativa de alocaá∆o de itens de dep¢sitos diferente~~" +
                               "Item: "        + ped-saldo.it-codigo + 
                               " Dep¢sito "    + string(ped-saldo.cod-depos, "!!!") +
                               "  - > Item: "  + b-ped-saldo.it-codigo +
                               " Dep¢sito "    + string(b-ped-saldo.cod-depos, "!!!")).

             RETURN "NOK".
        END.
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-integra-pedido wMasterDetail 
PROCEDURE pi-integra-pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*Integra com programa de canais via msg0091.p os pedidos que tiveram quantidade alocada*/
    FIND FIRST int-ped-venda EXCLUSIVE-LOCK
         WHERE int-ped-venda.nr-pedido = v-pedido-anterior NO-ERROR.
    IF  AVAIL int-ped-venda THEN DO:

        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido NO-ERROR.

        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

        RUN esp/es0018p.p (INPUT "msg0091", /* Nome do programa */
                           INPUT 1,         /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

         FIND FIRST tt-prog-ponto 
              WHERE tt-prog-ponto.conteudo = "online" NO-ERROR.

        IF  AVAIL ped-venda
        AND AVAIL int-emitente 
        AND int-emitente.ind-participa-canais    = 993520001
        AND SUBSTRING(int-ped-venda.char-1,66,1) = "1"  
        AND AVAIL tt-prog-ponto THEN DO:
            
            RAW-TRANSFER ped-venda TO raw-param2.
            RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                                    INPUT        raw-param2, /* Tupla do registro */
                                    OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.            
        END.

        OVERLAY(int-ped-venda.char-1,66,1) = "0".
    END.
    FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
    RELEASE int-ped-venda.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-lim-disp-intelbras wMasterDetail 
PROCEDURE pi-lim-disp-intelbras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE input  parameter p-cod-cliente        as integer NO-UNDO format ">>>>>>>>9":U.
    DEFINE output parameter p-lim-disp-intelbras as decimal NO-UNDO initial 0.

    DEFINE VARIABLE de-fator as decimal NO-UNDO format "999999,9999":U initial 1.

    assign p-lim-disp-intelbras = 0.
   
    for each bf-emitente no-lock
       where bf-emitente.nome-matriz = emitente.nome-matriz:
        for each estabelecimento no-lock:
          /** Ignora t°tulos da Nova e da Maxcom **/
          if (estabelecimento.cod_estab = '201') 
          or (estabelecimento.cod_estab = '301') then
             next.

            for each tit_acr use-index titacr_cliente no-lock
               where tit_acr.cod_estab           = estabelecimento.cod_estab
                 and tit_acr.cdn_cliente         = bf-emitente.cod-emitente
                 and tit_acr.val_sdo_tit_acr     > 0
                 and tit_acr.log_tit_acr_estordo = no:

                if can-find (first bmovto_tit_acr_perdas
                             where bmovto_tit_acr_perdas.cod_estab           = tit_acr.cod_estab
                               and bmovto_tit_acr_perdas.num_id_tit_acr      = tit_acr.num_id_tit_acr
                               and bmovto_tit_acr_perdas.ind_trans_acr_abrev = "LQPD"
                               and bmovto_tit_acr_perdas.log_movto_estordo   = no) then
                   next.
    
                /* T°tulos transferidos para o 102 e 103 */
                if tit_acr.cod_estab = "201":U or
                   tit_acr.cod_estab = "301":U then 
                    next.
        
                if tit_acr.ind_tip_espec_docto      = "Normal":U or
                   tit_acr.ind_tip_espec_docto begins "Vendor":U then do:
        
                    IF  tit_acr.cod_portador <> "9905"
                    AND tit_acr.cod_portador <> "9930"
                    AND tit_acr.cod_portador <> "9915"
                    AND tit_acr.cod_portador <> "9943"
                    AND tit_acr.cod_cart_bcia <> "CSR" THEN DO: 

                        if tit_acr.cod_espec_docto = "VE":U then do:
            
                            /* Localiza extensao da parcela que contem o valor do cliente(com juros) */
                            FIND FIRST parc_vendor no-lock
                                 where parc_vendor.cod_estab_tit_acr = tit_acr.cod_estab
                                   and parc_vendor.num_id_tit_acr    = tit_acr.num_id_tit_acr NO-ERROR.
            
                            if avail parc_vendor then
                                assign p-lim-disp-intelbras = p-lim-disp-intelbras + parc_vendor.val_parc_vendor_clien.
                        end.
            
                        if tit_acr.cod_espec_docto = "VEM":U then do:
                            assign p-lim-disp-intelbras = p-lim-disp-intelbras + tit_acr.val_sdo_tit_acr.
            
                            FIND FIRST movto_tit_acr of tit_acr no-lock
                                where movto_tit_acr.ind_trans_acr_abrev = 'IMPL' NO-ERROR.
            
                            if avail movto_tit_acr then do:
                                FIND FIRST histor_movto_tit_acr no-lock
                                     where histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                                       and histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                                       and histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
            
                                if avail histor_movto_tit_acr then
                                    assign p-lim-disp-intelbras = p-lim-disp-intelbras + tit_acr.val_sdo_tit_acr.
                            end.
                        end.
            
                        if tit_acr.cod_espec_docto <> "VE":U  and
                           tit_acr.cod_espec_docto <> "VEM":U then
                            assign p-lim-disp-intelbras = p-lim-disp-intelbras + tit_acr.val_sdo_tit_acr.
                    END.
                end.
            end.
        end.

        for each  ped-venda no-lock
           where  ped-venda.nome-abrev   = bf-emitente.nome-abrev
             and (ped-venda.cod-sit-ped  = 1  /* Aberto */
              or  ped-venda.cod-sit-ped  = 2) /* Atendido Parcial */
             and  ped-venda.completo     = yes
             and  ped-venda.cod-sit-aval = 3  /* Aprovado */
             and  ped-venda.cod-priori  <> 44:
    
            FIND FIRST cond-pagto no-lock
                 where cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-ERROR.
    
            if  avail cond-pagto
            and cond-pagto.cod-cond-pag <> 502 
            and cond-pagto.cod-vencto    = 2 then 
                next.
    
            FIND int-cond-pagto OF cond-pagto NO-LOCK NO-ERROR.
            IF  AVAIL int-cond-pagto
            AND SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U  
                THEN NEXT.

            RUN pi-converte-moeda (OUTPUT d-vl-aberto).

            ASSIGN p-lim-disp-intelbras = p-lim-disp-intelbras + d-vl-aberto.

        end.

    end.
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpaTTables wMasterDetail 
PROCEDURE pi-limpaTTables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt-raw-digita.
        DELETE tt-raw-digita.
    END.

    FOR EACH tt-param.
        DELETE tt-param.
    END.

    FOR EACH tt-digita.
        DELETE tt-digita.
    END.

    FOR EACH tt_param_segur.
        DELETE tt_param_segur.
    END.

    FOR EACH tt_ped_exec.
        DELETE tt_ped_exec.
    END.

    FOR EACH tt_ped_exec_param.
        DELETE tt_ped_exec_param.
    END.

    FOR EACH tt_ped_exec_param_aux.
        DELETE tt_ped_exec_param_aux.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-marca-pedido wMasterDetail 
PROCEDURE pi-marca-pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*Marca os pedidos que tiveram quantidades alocadas/desalocadas para integrar com programa de canais via msg0091.p*/
    FIND FIRST int-ped-venda EXCLUSIVE-LOCK
         WHERE int-ped-venda.nr-pedido = ttped-venda.nr-pedido NO-ERROR.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = ttped-venda.cod-emitente NO-ERROR.

    IF  AVAIL int-ped-venda
    AND AVAIL int-emitente 
    AND int-emitente.ind-participa-canais  = 993520001 THEN DO:
        OVERLAY(int-ped-venda.char-1,66,1) = "1".
    END.
    FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
    RELEASE      int-ped-venda.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-modifica wMasterDetail 
PROCEDURE pi-modifica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    btMod:LOAD-IMAGE("image/im-chck1.bmp") IN FRAME fPage0.
    
    ASSIGN cidade-cif:VISIBLE IN FRAME fPage0 = FALSE       
           c-frete:VISIBLE IN FRAME fPage0 = TRUE
           ttped-venda.nome-transp:VISIBLE IN FRAME fPage0 = FALSE
           /*c-transp:VISIBLE IN FRAME fPage0 = TRUE*/
           cod-transp:VISIBLE IN FRAME fPage0 = TRUE
           ttped-venda.cod-canal-venda:VISIBLE IN FRAME fPage0 = TRUE
           ttped-venda.tp-pedido:VISIBLE IN FRAME fpage0 = TRUE
           ttped-venda.dt-entrega:VISIBLE IN FRAME fpage0 = TRUE
           ttped-venda.ind-fat-par:VISIBLE IN FRAME fpage0 = TRUE
           ttped-venda.no-ab-reppri:VISIBLE IN FRAME fpage0 = TRUE.

    DISABLE btFirst
            btPrev
            btNext
            btLast
            btGoto
            btSel
            btFat
            btExtra
            c-sit-credito
            btPedido WITH FRAME fPage0.

    DISABLE brSon1 WITH FRAME fPage1.
            
    ASSIGN MENU-ITEM miFirst:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miPrev:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miNext:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miLast:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miGoto:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miSel:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miFat:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miExtra:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miDet:SENSITIVE IN MENU smFile = FALSE.
    
    ENABLE c-frete 
           /*c-transp*/
           ttped-venda.cod-priori
           ttped-venda.cod-canal-venda
           ttped-venda.tp-pedido
           ttped-venda.dt-entrega
           ttped-venda.ind-fat-par
           ttped-venda.no-ab-reppri
           cod-transp
           WITH FRAME fPage0.

    ASSIGN ttped-venda.observacoes:READ-ONLY IN FRAME fPage0 = FALSE       
           ttped-venda.cond-espec:READ-ONLY IN FRAME fPage0 = FALSE
           ttped-venda.cod-canal-venda:READ-ONLY IN FRAME fPage0 = FALSE.

    APPLY "value-changed" TO c-frete IN FRAME fPage0.
    
    APPLY "value-changed" TO c-transp IN FRAME fPage0.
    
    APPLY "value-changed" TO ttped-venda.tp-pedido IN FRAME fPage0.
    
    APPLY "value-changed" TO ttped-venda.ind-fat-par IN FRAME fPage0.

    APPLY "leave" TO cod-transp IN FRAME fPage0.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-periodo-fat wMasterDetail 
PROCEDURE pi-periodo-fat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dt-ini-year    AS CHAR        NO-UNDO .
    DEFINE VARIABLE dt-ini-month   AS CHAR        NO-UNDO .
    DEFINE VARIABLE dt-ini-day     AS CHAR        NO-UNDO .
    
    ASSIGN dt-inicio-entrega = TODAY.
    
    IF DAY(dt-inicio-entrega) <= 20 THEN DO:
       ASSIGN dt-inicio-entrega = ADD-INTERVAL(dt-inicio-entrega, -1, 'months') .
    
       ASSIGN dt-ini-year  = STRING(YEAR(dt-inicio-entrega)).
       ASSIGN dt-ini-month = STRING(MONTH(dt-inicio-entrega)).
       ASSIGN dt-ini-day   = "21" .
    
    
       ASSIGN dt-inicio-entrega = DATE(dt-ini-day + "/" + dt-ini-month + "/" + dt-ini-year ) .
    END.
    ELSE DO:
      ASSIGN dt-ini-year  = STRING(YEAR(dt-inicio-entrega)).  
      ASSIGN dt-ini-month = STRING(MONTH(dt-inicio-entrega)).
      ASSIGN dt-ini-day   = "21" .
    
      ASSIGN dt-fim-entrega = DATE(dt-ini-day + "/" + dt-ini-month + "/" + dt-ini-year ) .
    
    END.
    
    IF MONTH(dt-inicio-entrega) =  MONTH(TODAY) THEN DO:
        ASSIGN dt-fim-entrega = ADD-INTERVAL(dt-inicio-entrega, 1, 'months') - 1 .
    END.
    ELSE DO:
        ASSIGN dt-fim-entrega = ADD-INTERVAL(dt-inicio-entrega, 1, 'months') - 1 .
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-prefatur wMasterDetail 
PROCEDURE pi-prefatur :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN l-limpo = NO.
    
    SESSION:SET-WAIT-STATE("general":U).
    RUN pi-ValidaPreFatur.

    IF cReturn <> "NOK" THEN DO:

        IF i-faturaSel = 3 THEN DO:
            RUN utp/ut-msgs.p (INPUT "Show",
                               INPUT 27100,
                               INPUT "Deseja liberar pedido para Faturamento - Pedidos Selecionados?").
        END.
        ELSE IF i-faturaSel = 2 THEN DO:
            RUN utp/ut-msgs.p (INPUT "Show",
                               INPUT 27100,
                               INPUT "Deseja liberar pedido para faturamento?").
        END.

        IF RETURN-VALUE = "YES" OR i-faturaSel = 1 THEN DO:

            /*OUTPUT TO VALUE("an046325/espdp006_" + TRIM(v_cod_usuar_corren)  +  ".LOG") APPEND.
            PUT "Itens de Pedidos LIberados : " ttped-venda.nr-pedcli " " TODAY " "  STRING(TIME,"HH:MM:SS") SKIP.
             PUT "Item                  Qt. Ped.       Qt. Aloc      Qt.Embarq.    Qt. Atendida" SKIP.
            FOR EACH ped-item OF ttped-venda NO-LOCK:
                PUT ped-item.it-codigo " " ped-item.qt-pedida " " ped-item.qt-log-aloc " " ped-item.qt-alocada " " ped-item.qt-atendida SKIP.
            END.
            OUTPUT CLOSE.*/

            IF ttPed-venda.cidade-cif <> "" THEN DO:
                ASSIGN c-mesgitem  = "Verifique se existe pesos (l°quido/bruto) cadastrados para os seguintes itens:" + CHR(13)
                       l-peso      = TRUE
                       l-narrativa = TRUE.


                FOR EACH ped-item OF ttPed-venda NO-LOCK:
                    FIND FIRST item OF ped-item NO-LOCK NO-ERROR.

                    IF AVAIL item THEN DO:
                        IF item.peso-bruto = 0 OR 
                           item.peso-bruto = ? OR
                           item.peso-liquido = 0 OR 
                           item.peso-liquido = ? THEN DO:
                            ASSIGN c-mesgitem = c-mesgitem + STRING(item.it-codigo) + " - " + item.desc-item + CHR(13)
                                   l-peso = FALSE.
                        END.

                        IF item.ind-imp-desc <> 1 and
                           item.narrativa = "" THEN DO:
                            ASSIGN c-mesgitem-nar = c-mesgitem-nar + STRING(item.it-codigo) + " - " + item.desc-item + CHR(13)
                                   l-narrativa = FALSE.
                        END.
                    END.

                    FIND FIRST item-dist 
                         WHERE item-dist.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
                    IF NOT AVAIL item-dist THEN DO:
                        CREATE item-dist.
                        ASSIGN item-dist.it-codigo = ped-item.it-codigo.
                    END.
                END.

                IF l-peso = FALSE THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show":U, 
                                       INPUT 27979, 
                                       INPUT "Item do pedido n∆o tem peso bruto/l°quido!~~" + c-mesgitem).
                END.

                IF l-narrativa = FALSE THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show":U, 
                                       INPUT 27979, 
                                       INPUT "Item do pedido n∆o tem Narrativa!~~" + c-mesgitem-nar).
                END.
            END.

            /* Bloco para enviar email aos usu†rios, quando os pedidos faturados forem de determinadas naturezas cadastradas - Incidente 33949 */
            FIND FIRST mgesp.ponto-programa NO-LOCK
                WHERE  ponto-programa.nome-programa = "espdp006"
                AND    ponto-programa.ponto         = 8 /* Naturezas que dever∆o enviar email */ NO-ERROR.
            IF  AVAIL  ponto-programa THEN DO:
                IF  CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK
                             WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                             AND   conteudo-programa.conteudo     = ttped-venda.nat-operacao) THEN DO:
                    RUN pi-enviar-email IN THIS-PROCEDURE.
                END.
            END.

            DO TRANSACTION:

                IF  emitente.ind-aval-embarque <> 1 THEN DO: /* para Canais */

                    if   (   emitente.ind-cre-cli  = 1  /* Normal                      */
                          or emitente.ind-cre-cli  = 5)  /* Pagamento a Vista           */  
                    and emitente.ind-aval-emb > 1        /* Atrasos ou Atrasos + Limite */ 
                    and ttped-venda.origem <> 9 /* pedidos de bonificaªío nío avaliam cr≤dito */
                    then do:
                        create tt-param-aval.
                        assign tt-param-aval.nr-pedido    = ttped-venda.nr-pedido
                               tt-param-aval.param-aval   = (if emitente.ind-aval-embarque = 2
                                                             then 1
                                                             else 3)
                              tt-param-aval.embarque      = yes
                              tt-param-aval.efetiva       = yes
                              tt-param-aval.retorna       = yes
                              tt-param-aval.reavalia-forc = no
                              tt-param-aval.vl-a-aval     = ttped-venda.vl-liq-abe
                              tt-param-aval.usuario       = c-seg-usuario
                              tt-param-aval.programa      = 'eqapi300'.

                        run cdp/cdapi013.p (input-output table tt-param-aval,
                                            input-output table tt-erros-aval).

                        for each tt-param-aval:
                            delete tt-param-aval.
                        end.

                        find first tt-erros-aval no-error.
                        if  available(tt-erros-aval) then do:

                            /* Pedido nío foi aprovado. */
                             RUN utp/ut-msgs.p (INPUT "show":U, 
                                                INPUT tt-erros-aval.cd-erro, 
                                                INPUT (ttped-venda.nr-pedcli  + '~~' +
                                                       ttped-venda.nome-abrev + '~~' +
                                                       ttped-venda.desc-bloq)).

    /*                         run setInvoicingAvaiable in h-bodi159cal(input rowid(ped-venda)). */

                            FOR EACH tt-erros-aval:
                                DELETE tt-erros-aval.
                            END.

                            RETURN 'NOK':U.
                        END.
                    END.
                END.

                FIND FIRST ped-venda EXCLUSIVE-LOCK
                    WHERE  ped-venda.nome-abrev = ttped-venda.nome-abrev
                    AND    ped-venda.nr-pedcli = ttped-venda.nr-pedcli  NO-ERROR.
                IF  AVAIL  ped-venda THEN DO:
                    IF i-faturaSel = 2 THEN DO:
                        ASSIGN ped-venda.cod-priori                                =  10
                               ttped-venda.cod-priori:SCREEN-VALUE IN FRAME fPage0 = '10'
                               ttped-venda.cod-priori                              =  10.
                    END.
                    ELSE DO:

                        ASSIGN ped-venda.cod-priori                                =  09
                               ttped-venda.cod-priori:SCREEN-VALUE IN FRAME fPage0 = '09'
                               ttped-venda.cod-priori                              =  09.
    
                        FIND FIRST fat-comercial
                            WHERE  fat-comercial.num-ped-exec    = 2229
                              AND  fat-comercial.nr-pedcli       = ttped-venda.nr-pedcli :SCREEN-VALUE IN FRAME fPage0  
                              AND  fat-comercial.nr-sequencia    = 99 NO-LOCK NO-ERROR.
                        IF NOT AVAIL fat-comercial THEN DO:
                            CREATE fat-comercial.                          
                            ASSIGN fat-comercial.nr-sequencia    = 99 
                                   fat-comercial.dt-fatura       = TODAY
                                   fat-comercial.hr-fatura       = TIME
                                   fat-comercial.nome-abrev      = ttped-venda.nome-abrev:SCREEN-VALUE IN FRAME fPage0
                                   fat-comercial.nr-pedcli       = ttped-venda.nr-pedcli :SCREEN-VALUE IN FRAME fPage0 
                                   fat-comercial.num-ped-exec    = 2229
                                   fat-comercial.tipo            = 2
                                   fat-comercial.c-status        = c-seg-usuario.
                        END. /* IF NOT AVAIL fat-comercial THEN DO: */
                        FIND CURRENT fat-comercial   NO-LOCK NO-ERROR.
                        RELEASE fat-comercial.

                    END.
                END.
                FIND CURRENT ped-venda NO-LOCK NO-ERROR.
                RELEASE ped-venda.

                ASSIGN i-faturaSel = 1.

            END.

            FIND FIRST ped-venda NO-LOCK 
                 WHERE ped-venda.nome-abrev = ttped-venda.nome-abrev 
                 AND   ped-venda.nr-pedcli  = ttped-venda.nr-pedcli NO-ERROR.

            /* Somente carrega novamente os pedidos se n∆o ocorreram erros ao liberar o pedido (na trigger) */
            IF  AVAIL ped-venda THEN DO TRANS:

                FIND FIRST int-ped-venda
                    WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido
                      AND int-ped-venda.cod-estabel = ped-venda.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL int-ped-venda THEN
                    ASSIGN OVERLAY(int-ped-venda.char-1,250,15) = c-seg-usuario.
                FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
                RELEASE int-ped-venda.

                FIND FIRST tt-ped-venda-aux NO-LOCK
                    WHERE  tt-ped-venda-aux.nome-abrev = ped-venda.nome-abrev
                    AND    tt-ped-venda-aux.nr-pedcli  = ped-venda.nr-pedcli NO-ERROR.
                IF  AVAIL  tt-ped-venda-aux THEN DO:
                    DELETE tt-ped-venda-aux.
                END.

                RUN getNext IN {&hDBOParent}.
                IF RETURN-VALUE = "NOK" THEN DO:
                    RUN getPrev IN {&hDBOParent}.
                    IF RETURN-VALUE = "NOK":U THEN DO:
                        FOR EACH ttped-item: DELETE ttped-item. END. 
                        {&OPEN-QUERY-{&BROWSE-NAME}}
                        ASSIGN l-limpo = YES.
                    END.
                END.

                IF l-limpo = NO THEN DO:
                    RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
                    RUN getKey   IN {&hDBOParent} (OUTPUT c-nome-abrev-sel,
                                                   OUTPUT c-nr-pedcli-sel ).
                END.

                RUN openQueryStatic IN {&hDBOParent} (INPUT "Navega":U) NO-ERROR.

                IF l-limpo = NO THEN DO:

                    RUN goToKey IN {&hDBOParent} (INPUT c-nome-abrev-sel, 
                                                  INPUT c-nr-pedcli-sel ).
                    RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
                    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo) NO-ERROR.    
                END.
                ELSE
                    RUN repositionRecord IN THIS-PROCEDURE (INPUT ?) NO-ERROR.
            END.

            /* tem que retornar ok sen∆o a transaá∆o nao eh efetivada - hahahaha */
            RUN retornaOK.
        END.
        ELSE
            ASSIGN cReturn = "NOK".                

    END. /* IF cReturn <> "NOK" THEN DO: */
    
    SESSION:SET-WAIT-STATE("":U). 
            
    IF  AVAIL ttPed-Item THEN
        APPLY "Entry" TO ttPed-item.qt-log-aloca IN BROWSE brSon1.
    ELSE 
        APPLY "Entry" TO btSel IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-alocacao wMasterDetail 
PROCEDURE pi-valida-alocacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE d-qtde-reservas-ast AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-usuar-reservas    AS CHARACTER   NO-UNDO.

    FOR EACH ponto-programa NO-LOCK
       WHERE ponto-programa.nome-programa = "espdp006"
         AND ponto-programa.ponto         = 10,  
        EACH conteudo-programa NO-LOCK
       WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            
        IF  ttped-venda.tp-pedido >= entry(1,conteudo-programa.conteudo, ";")     
        AND ttped-venda.tp-pedido <= entry(2,conteudo-programa.conteudo, ";") THEN DO:

            IF entry(4,conteudo-programa.conteudo, ";") = "" THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Existe execuá∆o de Alocaá∆o Autom†tica para atendente do pedido, usuario : " +  entry(3,conteudo-programa.conteudo, ";") ).     
        
                RETURN "NOK".
            END.
            ELSE DO:
                IF vUnid-Neg = entry(4,conteudo-programa.conteudo, ";") THEN DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Existe execuá∆o de Alocaá∆o Autom†tica para atendente do pedido, usuario : " +  entry(3,conteudo-programa.conteudo, ";") + ' - Unid Neg ' +  entry(4,conteudo-programa.conteudo, ";") ).     
        
                    RETURN "NOK".
                END.
            END.
        END.
    END.

    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "bodi317va",
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          AND ENTRY(2, conteudo-programa.conteudo, ";") = ttped-venda.cod-estabel:

        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17006, 
                           INPUT "Estabelecimento bloqueado para Alocaá∆o e Faturamento").
        RETURN "NOK".
    END.

    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "espdp006"
          AND ponto-programa.ponto         = 1,   /* Centrais Embratel */
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          AND conteudo-programa.sequencia    = int(ttped-venda.tp-pedido):
        IF INDEX(conteudo-programa.conteudo,c-seg-usuario) = 0 THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                                           INPUT 17006, 
                                           INPUT "Permiss∆o para alocaá∆o do pedido restrita, somente estes usuarios podem alocar: " + conteudo-programa.conteudo).
            RETURN "NOK".
        END.
    END.

    FOR EACH reservas-ast
        WHERE reservas-ast.cod-depos   = vCod-depos
        AND   reservas-ast.it-codigo   = ttped-item.it-codigo
        AND   reservas-ast.cod-estabel = ttped-venda.cod-estabel
        AND   reservas-ast.dt-reserva  <= TODAY NO-LOCK:

        IF reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY THEN
            ASSIGN d-qtde-reservas-ast = d-qtde-reservas-ast + reservas-ast.qt-reserva
                   c-usuar-reservas    = c-usuar-reservas + (IF c-usuar-reservas = "" THEN "" ELSE ", ") + reservas-ast.cd-usuario.
    END.

    IF d-qtde-reservas-ast > 0 THEN DO:
        IF fnEstoque(ttped-venda.cod-estabel,ttped-item.it-codigo, vCod-depos, "*", NO) < (d-qtde-reservas-ast + de-aloca-item-astec) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17006, 
                               INPUT "H† reservas de saldo!~~Entrar em contato com a pessoa que fez a reserva: " + c-usuar-reservas + "!").

            RETURN "NOK".

        END. 
    END. 

    FIND FIRST ped-ent 
         WHERE ped-ent.nome-abrev   = ttped-item.nome-abrev  
         AND   ped-ent.nr-pedcli    = ttped-item.nr-pedcli   
         AND   ped-ent.nr-sequencia = ttped-item.nr-sequencia
         AND   ped-ent.it-codigo    = ttped-item.it-codigo   
         AND   ped-ent.cod-refer    = ttped-item.cod-refer NO-LOCK NO-ERROR.
    IF NOT AVAIL ped-ent THEN DO:

        RETURN "NOK".
    END.  

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-deposito wMasterDetail 
PROCEDURE pi-valida-deposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE l-wms-estab-ativo AS LOGICAL NO-UNDO.

    FIND FIRST deposito NO-LOCK
         WHERE deposito.cod-depos = vCod-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.

    IF NOT AVAIL deposito THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Dep¢sito " + vCod-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " n∆o cadastrado.").

        RETURN "NOK".
    END.

    IF deposito.alocado = NO THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Deposito informado n∆o permite Alocaá∆o, verifique atravÇs do programa cd0601").
       RETURN "NOK":U.
    END.

    RUN esp/wmp/eswmpapi006.p( INPUT c-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME}, OUTPUT l-wms-estab-ativo).
    /*
    IF  l-wms-estab-ativo AND vCod-Depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'EXP' THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Alocacao Bloqueada para o deposito EXP com estabelecimento 104!" + "~~" + 
                                 "Deposito bloqueado devido a implantacao do WMS!").
        RETURN "NOK".
    END. 
    */
    FOR FIRST mgesp.ponto-programa                                            
        WHERE ponto-programa.nome-programa = "espdp006"                        
          AND ponto-programa.ponto = 5:

        IF NOT CAN-FIND (FIRST conteudo-programa 
                         WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa
                           AND ENTRY(2,conteudo-programa.conteudo) = c-seg-usuario
                           AND ENTRY(1,conteudo-programa.conteudo) = vCod-Depos:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Usu†rio " + c-seg-usuario + " sem permiss∆o para alocar no dep¢sito " +  vCod-Depos:SCREEN-VALUE IN FRAME {&FRAME-NAME}).     
         RETURN "NOK":U.
        END.
    END.

    IF  vLocalizacao:SCREEN-VALUE IN FRAME fPage0 <> "" 
    AND vLocalizacao:SCREEN-VALUE IN FRAME fPage0 <> "*"  THEN DO:
        FIND FIRST mgcad.localizacao NO-LOCK
             WHERE localizacao.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               AND localizacao.cod-depos   = vCod-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               AND localizacao.cod-localiz = vLocalizacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.
      
        IF NOT AVAIL localizacao THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Localizaá∆o n∆o encontrada!" + "~~" +
                                     "N∆o encontrada localizaá∆o " + vLocalizacao:SCREEN-VALUE IN FRAME fPage0 + " para o dep¢sito " + vCod-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
            RETURN "NOK":U.
        END.
        /*
        IDBA Bruno -- M2403-017Trava faturamento dep¢sito EXP
        IF vCod-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "EXP" 
        OR vCod-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "WEX"
        OR vCod-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "WEC" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "N∆o Ç permitido alocar em dep¢sito de expediá∆o com localizaá∆o diferente de branco!").
            RETURN "NOK":U.
        END.*/
    END.

    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
    NO-LOCK NO-ERROR.

    IF AVAIL estabelec AND SUBSTRING(estabelec.char-1,396,1) = 'S' THEN DO:
       RUN esp/es0018p.p (INPUT "espdp090",                       
                          INPUT 1,
                          INPUT 0,
                          INPUT "",
                          OUTPUT TABLE tt-prog-ponto).
      
       FIND FIRST deposito WHERE deposito.cod-depos = vCod-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
      
       IF AVAIL deposito THEN DO:
      
          FIND FIRST tt-prog-ponto
               WHERE tt-prog-ponto.conteudo = ttped-venda.nat-operacao:SCREEN-VALUE IN FRAME {&FRAME-NAME}
          NO-ERROR.
      
          IF deposito.ind-tipo-dep = 1 THEN DO: //DEPOSITO INTERNO
             IF AVAIL tt-prog-ponto THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Natureza de operaá∆o de entreposto n∆o pode ser utilizada para um Dep¢sito Interno" ).
        
                RETURN "NOK":U.
             END.
          END.
      
          IF deposito.ind-tipo-dep = 2 THEN DO: //DEPOSITO EXTERNO
             IF NOT AVAIL tt-prog-ponto THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Natureza de operaá∆o n∆o pode ser utilizada para deposito de Entreposto"  ).
        
                RETURN "NOK":U.
             END.
          END.
       END.
    END.
    
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-reservas wMasterDetail 
PROCEDURE pi-valida-reservas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER bttped-item FOR ttped-item.
    EMPTY TEMP-TABLE tt-zera-aloc.
    
    FOR EACH bttped-item NO-LOCK
       WHERE bttped-item.nr-pedcli    = ttped-venda.nr-pedcli :SCREEN-VALUE IN FRAME {&FRAME-NAME}
         AND bttped-item.nome-abrev   = ttped-venda.nome-abrev:SCREEN-VALUE IN FRAME {&FRAME-NAME}
         AND bttped-item.qt-log-aloca > 0:
    
        FOR FIRST reservas-ast NO-LOCK
            WHERE reservas-ast.cod-depos    = vCod-depos
              AND reservas-ast.it-codigo    = bttped-item.it-codigo
              AND reservas-ast.cod-estabel  = ttped-venda.cod-estabel 
              AND (reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY):
    
            RUN utp/ut-msgs.p (INPUT "Show",
                               INPUT 27100,
                               INPUT "Item " + reservas-ast.it-codigo + " reservado pelo usuario " + reservas-ast.cd-usuario + ". ~~ Caso deseje prosseguir o faturamento, este item ser† desalocado, deseja faturar mesmo assim?").
        
            IF RETURN-VALUE = "YES" THEN DO:
                CREATE tt-zera-aloc.
                ASSIGN tt-zera-aloc.r-ped-item = rowid(bttped-item). 
            END.
            ELSE DO:
                RETURN "NOK".
            END.
        END.
    END.
    
    blk_zera_aloc:
    FOR EACH tt-zera-aloc:
    
        REPOSITION brSon1 TO ROWID tt-zera-aloc.r-ped-item.
        
        ASSIGN ttPed-item.qt-log-aloca:SCREEN-VALUE IN BROWSE brSOn1  = "0".
        
        ASSIGN de-desaloca-item-astec = ttped-item.qt-log-aloca - DECIMAL(ttped-item.qt-log-aloca:SCREEN-VALUE IN BROWSE brSon1).

        RUN pi-desaloca.                

        IF cReturn <> "OK" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "N∆o foi poss°vel realizar a desalocaá∆o do item " + ttped-item.it-codigo).

            UNDO blk_zera_aloc, LEAVE blk_zera_aloc.
        END.
    END.
              
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ValidaPreFatur wMasterDetail 
PROCEDURE pi-ValidaPreFatur :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE l-erro         AS LOGICAL  INIT NO   NO-UNDO.
DEFINE VARIABLE d-peso-alocado AS DECIMAL            NO-UNDO.
DEFINE VARIABLE d-peso-aberto  AS DECIMAL            NO-UNDO.

DEFINE BUFFER bf-item FOR item.

    FIND FIRST natur-oper OF ttped-venda NO-LOCK.
    IF  AVAIL  natur-oper THEN DO:
        IF natur-oper.emite-duplic THEN DO:

            ASSIGN i-parc         = 1
                   de-valor       = 0.
    
            FIND FIRST pd-vendor OF ttPed-venda NO-LOCK NO-ERROR.
            IF AVAIL pd-vendor THEN DO:
                FIND FIRST cond-pagto WHERE cond-pagto.cod-cond-pag = pd-vendor.cod-cond-cli NO-LOCK NO-ERROR.
                IF AVAIL cond-pagto THEN
                    ASSIGN i-parc = cond-pagto.num-parcelas.
            END.
            ELSE DO:
                FIND FIRST cond-pagto WHERE cond-pagto.cod-cond-pag = ttped-venda.cod-cond-pag NO-LOCK NO-ERROR.
                IF AVAIL cond-pagto THEN
                    ASSIGN i-parc = cond-pagto.num-parcelas.
            END.
    
            FOR EACH bPed-item OF ttPed-venda NO-LOCK
               WHERE bPed-item.cod-sit-item < 3 :                    
                ASSIGN de-valor = de-valor + (bped-item.vl-tot-it / bped-item.qt-pedida * bped-item.qt-log-aloca).

                FOR FIRST bf-item FIELDS(peso-bruto)
                    WHERE bf-item.it-codigo = bPed-item.it-codigo NO-LOCK:

                    ASSIGN d-peso-alocado = d-peso-alocado + (bPed-item.qt-log-aloc * bf-item.peso-bruto)
                           d-peso-aberto  = d-peso-aberto  + ((bPed-item.qt-pedida - bPed-item.qt-atendida) * bf-item.peso-bruto).
                END.
            END.
    
            FIND FIRST atendente
                 WHERE atendente.cd-oper = INT(ttPed-venda.tp-pedido) NO-LOCK NO-ERROR.
            
            IF AVAIL atendente THEN DO:
                
                FIND FIRST minimos-faturamento
                    WHERE minimos-faturamento.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME fPage0
                    AND   minimos-faturamento.oper-mestre = atendente.oper-mestre NO-LOCK NO-ERROR.
                IF AVAIL minimos-faturamento THEN DO:

                    IF (de-valor / i-parc) < minimos-faturamento.vl-parc-minima THEN DO:
                        IF de-valor < minimos-faturamento.vl-fatur-minimo THEN DO:
                            IF l-erro = NO THEN DO:
                                RUN utp/ut-msgs.p (INPUT "show":U, 
                                                   INPUT 27100, 
                                                   INPUT "Valor Liberado para faturamento inferior ao Parametrizado e Valor da Parcela do Pedido inferior ao Parametrizado!~~" + 
                                                         "Valor Liberado para faturamento inferior ao Parametrizado: " + STRING(minimos-faturamento.vl-fatur-minimo) + ".":U
                                                         + CHR(10) + CHR(10) +
                                                         "Valor da Parcela do Pedido inferior ao Parametrizado: " + STRING(minimos-faturamento.vl-parc-minima) + ".":U
                                                         + CHR(10) + CHR(10) + "Deseja continuar?":U).
                                IF RETURN-VALUE = "NO":U THEN DO:
                                    ASSIGN l-erro = YES.
                                    ASSIGN cReturn = "NOK".
                                    RETURN NO-APPLY.
                                END.
                            END.
                        END.
                        ELSE DO:
                            IF l-erro = NO THEN DO:
                                RUN utp/ut-msgs.p (INPUT "show":U, 
                                                   INPUT 27100, 
                                                   INPUT "Valor da Parcela do Pedido inferior ao Parametrizado!~~" + 
                                                         "Valor da Parcela do Pedido inferior ao Parametrizado: " + STRING(minimos-faturamento.vl-parc-minima) + ".":U
                                                         + CHR(10) + CHR(10) + "Deseja continuar?":U).
                                
                                IF RETURN-VALUE = "NO":U THEN DO:
                                    ASSIGN l-erro = YES.
                                    ASSIGN cReturn = "NOK".
                                    RETURN NO-APPLY.
                                END.
                            END.
                        END.
                    END.

                    IF de-valor < minimos-faturamento.vl-fatur-minimo THEN DO:
                        IF l-erro = NO THEN DO:
                            RUN utp/ut-msgs.p (INPUT "show":U, 
                                               INPUT 27100, 
                                               INPUT "Valor Liberado para faturamento inferior ao Parametrizado!~~" + 
                                                     "Valor Liberado para faturamento inferior ao Parametrizado: " + STRING(minimos-faturamento.vl-fatur-minimo) + ".":U
                                                     + CHR(10) + CHR(10) + "Deseja continuar?":U).
                            
                            IF RETURN-VALUE = "NO":U THEN DO:
                                ASSIGN l-erro = YES.
                                ASSIGN cReturn = "NOK".
                                RETURN NO-APPLY.
                            END.
                        END.
                    END.

                    IF ((de-vl-total - DEC(de-vl-total-alocado:SCREEN-VALUE IN FRAME fpage0)) / i-parc) > 1 AND /* Maior que 1 para evitar diferenáa de arredondamento */
                       ((de-vl-total - DEC(de-vl-total-alocado:SCREEN-VALUE IN FRAME fpage0)) / i-parc) < minimos-faturamento.vl-parc-minima THEN DO:
                        IF l-erro = NO THEN DO:
                            RUN utp/ut-msgs.p (INPUT "show":U, 
                                               INPUT 27100, 
                                               INPUT "Valor de Saldo do Pedido por parcela " + STRING((de-vl-total - DEC(de-vl-total-alocado:SCREEN-VALUE IN FRAME fpage0)) / i-parc) + " inferior ao Parametrizado!~~" + CHR(10) +
                                                     "Valor de Saldo do Pedido inferior ao Parametrizado: " + STRING(minimos-faturamento.vl-parc-minima) + ".":U + CHR(10) +
                                                     /*"Valor Total do Pedido em Aberto: " + STRING(de-vl-total) + ".":U + CHR(10) +
                                                     "Valor Total do Pedido Alocado  : " + STRING(de-vl-total-alocado:SCREEN-VALUE IN FRAME fpage0) + ".":U  +*/
                                                     CHR(10) + CHR(10) + "Deseja continuar?":U).
                            
                            IF RETURN-VALUE = "NO":U THEN DO:
                                ASSIGN l-erro = YES.
                                ASSIGN cReturn = "NOK".
                                RETURN NO-APPLY.
                            END.
                        END.
                    END.

                    IF (de-ps-total-aberto - d-peso-alocado) < minimos-faturamento.peso-bruto-min THEN DO:
                        IF l-erro = NO THEN DO:
                            RUN utp/ut-msgs.p (INPUT "show":U, 
                                               INPUT 27100, 
                                               INPUT "Peso aberto do Pedido inferior ao Parametrizado: " + STRING(minimos-faturamento.peso-bruto-min) + ".":U + CHR(10) +
                                                     CHR(10) + CHR(10) + "Deseja continuar?":U).
                            
                            IF RETURN-VALUE = "NO":U THEN DO:
                                ASSIGN l-erro = YES.
                                ASSIGN cReturn = "NOK".
                                RETURN NO-APPLY.
                            END.
                        END.
                    END.

                    IF d-peso-alocado < minimos-faturamento.peso-bruto-min THEN DO:
                        IF l-erro = NO THEN DO:
                            RUN utp/ut-msgs.p (INPUT "show":U, 
                                               INPUT 27100, 
                                               INPUT "Peso alocado do Pedido inferior ao Parametrizado: " + STRING(minimos-faturamento.peso-bruto-min) + ".":U + CHR(10) +
                                                     CHR(10) + CHR(10) + "Deseja continuar?":U).
                            
                            IF RETURN-VALUE = "NO":U THEN DO:
                                ASSIGN l-erro = YES.
                                ASSIGN cReturn = "NOK".
                                RETURN NO-APPLY.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.
    
    /** Verificaá∆o colocada por Felipe, em 16.07.2007, para liberar pedido APENAS quando o cliente
        estiver com o cadastro de cidade preenchido corretamente **/
    IF NOT CAN-FIND (FIRST emitente NO-LOCK
                     WHERE emitente.cod-emitente = ttPed-venda.cod-emitente
                       AND CAN-FIND (FIRST mgcad.cidade NO-LOCK
                                     WHERE cidade.pais   = emitente.pais
                                       AND cidade.estado = emitente.estado
                                       AND cidade.cidade = emitente.cidade)) THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17006, 
                           INPUT "N∆o Ç poss°vel liberar para faturamento!~~" + 
                                 "O cliente n∆o est† com o cadastro de cidade preenchido corretamente!" + CHR(10) +
                                 "Verifique o cadastro do ENDEREÄO DE ENTREGA.").
        ASSIGN cReturn = "NOK".
        RETURN NO-APPLY.           
    END.
    
    IF NOT CAN-FIND (FIRST emitente NO-LOCK
                     WHERE emitente.cod-emitente = ttPed-venda.cod-emitente
                       AND CAN-FIND (FIRST mgcad.cidade NO-LOCK
                                     WHERE cidade.pais   = emitente.pais-cob
                                       AND cidade.estado = emitente.estado-cob
                                       AND cidade.cidade = emitente.cidade-cob)) THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17006, 
                           INPUT "N∆o Ç poss°vel liberar para faturamento!~~" + 
                                 "O cliente n∆o est† com o cadastro de cidade preenchido corretamente!" + CHR(10) +
                                 "Verifique o cadastro do ENDEREÄO DE COBRANÄA.").
        ASSIGN cReturn = "NOK".
        RETURN NO-APPLY.           
    END.
    
    IF NOT CAN-FIND (FIRST loc-entr NO-LOCK
                     WHERE loc-entr.nome-abrev  = ttPed-venda.nome-abrev
                       AND loc-entr.cod-entrega = ttPed-venda.cod-entrega 
                       AND CAN-FIND (FIRST mgcad.cidade NO-LOCK
                                     WHERE cidade.pais   = loc-entr.pais
                                       AND cidade.estado = loc-entr.estado
                                       AND cidade.cidade = loc-entr.cidade)) THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17006, 
                           INPUT "N∆o Ç poss°vel liberar para faturamento!~~" + 
                                 "O cliente n∆o est† com o cadastro de cidade preenchido corretamente!" + CHR(10) +
                                 "Verifique o cadastro do LOCAL DE ENTREGA.").
        ASSIGN cReturn = "NOK".
        RETURN NO-APPLY.           
    END.
    /** Fim das verificaá‰es **/
    
    IF  emitente.ind-aval-embarque = 1 THEN  do: /* Definido para Canais */
        IF  ttped-venda.cod-sit-aval <> 3 THEN DO:
            
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17006, 
                               INPUT "Pedido n∆o pode ser faturado!~~Pedido n∆o pode ser faturado pois n∆o foi aprovado crÇdito!").
            ASSIGN cReturn = "NOK".
            RETURN NO-APPLY.   
        END. 
    END.
        
    FIND FIRST int-cond-pagto
        WHERE int-cond-pagto.cod-cond-pag = ttPed-venda.cod-cond-pag NO-LOCK NO-ERROR.
    IF  NOT AVAILABLE int-cond-pagto                      OR
       (AVAILABLE int-cond-pagto                         AND
        SUBSTRING(int-cond-pagto.char-1, 4, 1) <> "S":U) THEN DO:
        IF  NOT ttPed-venda.dsp-pre-fat THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "N∆o Ç poss°vel liberar para faturamento!":U +
                                     "~~":U +
                                     "Este pedido n∆o est† liberado para faturamento!":U +
                                     CHR(10) +
                                     "Favor alterar o pedido.":U).
    
            ASSIGN cReturn = "NOK".
            RETURN NO-APPLY.
        END.
    END.
    
    IF ttPed-venda.cidade-cif <> "" THEN DO:        
        IF ttPed-venda.nome-transp = "" OR
           ttPed-venda.nome-transp = ? THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17006, 
                               INPUT "Pedido n∆o pode ser faturado!~~Pedido n∆o pode ser faturado pois o frete Ç CIF e n∆o existe transportadora definida para o mesmo!").
                               /*INPUT "Pedido n∆o pode ser faturado!~~Pedido n∆o pode ser faturado pois o frete Ç CIF e n∆o existe transportadora/rota/serviáo definido para o mesmo!").*/
            ASSIGN cReturn = "NOK".
            RETURN NO-APPLY.           
        END.
    END.
    
    IF ttPed-venda.ind-fat-par = NO THEN DO:
        FOR EACH ped-item OF ttPed-venda 
            WHERE ped-item.cod-sit-item <= 2 NO-LOCK:
            IF (ped-item.qt-pedida - ped-item.qt-atendida - ped-item.qt-log-aloca) <> 0 THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 17006, 
                                   INPUT "Pedido n∆o pode ser liberado para faturamento!~~Este pedido n∆o permite faturamento parcial!").
                ASSIGN cReturn = "NOK".
                RETURN NO-APPLY.
            END.
        END.
    END.
        
    ASSIGN l-reserva        = FALSE
           l-cotas          = FALSE
           l-dt-entrega     = FALSE
           c-pedido-critica = "".
    
    FOR EACH ped-item OF ttped-venda NO-LOCK:
        IF ped-item.qt-log-aloca > 0 THEN DO:
            ASSIGN l-reserva = TRUE.
            IF ped-item.dt-entrega > TODAY THEN DO:
               ASSIGN l-dt-entrega = TRUE
                      c-pedido-critica = c-pedido-critica + ped-item.it-codigo + ",".
            END.
        END.
        IF ped-item.cod-sit-com <> 2 THEN
            ASSIGN l-cotas = TRUE.
    END.
    
    IF l-reserva = FALSE THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17006, 
                           INPUT "Pedido n∆o pode ser faturado!~~Pedido n∆o pode ser faturado pois n∆o existe reserva/alocaá∆o para nenhum item!").
        ASSIGN cReturn = "NOK".
        RETURN NO-APPLY.
    END.
    
    IF l-cotas = TRUE THEN DO:        
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17006, 
                           INPUT "Pedido n∆o pode ser faturado!~~Este pedido est† bloqueado por cotas! Liberar atravÇs do programa AC1004 (Aprovaá∆o Manual Cotas por Item).").
        ASSIGN cReturn = "NOK".
        RETURN NO-APPLY.        
    END.

    FOR EACH ped-item OF ttPed-venda NO-LOCK
       WHERE ped-item.cod-sit-item <= 2
         AND ped-item.qt-log-aloc   > 0,
        FIRST ped-ent OF ped-item NO-LOCK:

        find FIRST ped-saldo 
             where ped-saldo.nome-abrev  = ped-ent.nome-abrev      
               and ped-saldo.nr-pedcli   = ped-ent.nr-pedcli       
               and ped-saldo.nr-seq-item = ped-ent.nr-sequencia    
               and ped-saldo.it-codigo   = ped-ent.it-codigo       
               and ped-saldo.cod-refer   = ped-ent.cod-refer       
               and ped-saldo.nr-entrega  = ped-ent.nr-entrega 
        no-lock no-error.

        if not avail ped-saldo then 
        DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                                INPUT 17006, 
                                INPUT "Pedido com problemas de alocaá∆o, favor procurar a TIC").

             ASSIGN cReturn = "NOK".
             RETURN NO-APPLY.
        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validaWMS wMasterDetail 
PROCEDURE pi-validaWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Validacao MFT x WMS  */
    FIND FIRST deposito NO-LOCK
         WHERE deposito.cod-depos    = vCod-depos
           AND deposito.log-gera-wms = YES  NO-ERROR.
    
    IF AVAIL deposito THEN DO:
        IF fnEstoque(ttped-venda.cod-estabel, ped-ent.it-codigo, vCod-depos, vLocalizacao, NO) < vQtAlocada THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17006, 
                               INPUT "Saldo indisponivel! ~~Item " + ped-ent.it-codigo + " nao possui saldo f°sico disponivel no deposito " + vCod-depos + "." +
                                     "Possivel causa: Bloqueio de localizacao Para maiores informacoes, entrar em contato com o responsavel pelo deposito.").

            ASSIGN cReturn = "NOK"
                   ttPed-item.qt-log-aloca:SCREEN-VALUE IN BROWSE brSon1 = ''.
        END. /* IF p-qtd-disp < vQtAlocada THEN DO: */
    END. /* IF AVAIL deposito THEN DO: */
    /* Fim Valid MFT x WMS  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaOK wMasterDetail 
PROCEDURE retornaOK :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wMasterDetail 
FUNCTION fnDescItem RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    IF AVAIL ttped-item THEN
        FIND FIRST item OF ttped-item NO-LOCK NO-ERROR.

    IF AVAIL item THEN
        RETURN item.desc-item.
    ELSE
        RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

