&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-item-mov NO-UNDO /*LIKE movto-estoq*/
       field r-rowid      as row
       field selec        as LOG format "*/ "
       FIELD cod-estabel  LIKE movto-estoq.cod-estabel
       FIELD cod-emitente LIKE movto-estoq.cod-emitente
       FIELD it-codigo    LIKE movto-estoq.it-codigo
       FIELD lote         LIKE movto-estoq.lote
       field altera       as LOG
       field nr-seq       as integer
       field nr-cor       as integer
       field desc-item    as char format "x(60)" LABEL "Descricao"
       field qtd-entrada  like movto-estoq.quantidade
       field qtd-saida    like movto-estoq.quantidade
       field quantidade   like movto-estoq.quantidade
       field mensagem     as CHAR format "x(90)" LABEL "Mensagem"
       INDEX id nr-seq.

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
    FIELD qtd-analise    LIKE wm-saldo-estoque.qtd-atual COLUMN-LABEL "Qtd Anÿlise"
    FIELD r-rowid        AS ROWID.

DEF TEMP-TABLE ttResumoItem NO-UNDO
         FIELD id-box            LIKE  wm-box-saldo.id-box
         FIELD ind-status-box    LIKE  wm-box-saldo.ind-status-box
         FIELD ind-status-saldo  LIKE  wm-box-saldo.ind-status-saldo
         FIELD cod-embalagem     LIKE  wm-box-saldo.cod-embalagem
         FIELD qtd-item          LIKE  wm-box-saldo.qtd-item COLUMN-LABEL  "Qtd Item Atual"
         FIELD qtd-item-alocad   LIKE  wms-box-sdo-alocad.qtd-alocad
         FIELD qtd-item-liberado LIKE  wm-box-saldo.qtd-item COLUMN-LABEL "Qtd Item Liberada"
         FIELD RowNum           AS INTEGER
         FIELD r-RowId          AS ROWID
         INDEX w-res01 id-box   
                       cod-embalagem 
                       qtd-item
                       ind-status-saldo.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i iwm9700 2.00.00.002}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        iwm9700
&GLOBAL-DEFINE Version        2.00.00.002 

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   <Folder1 ,Folder 2 ,... , Folder8>

&GLOBAL-DEFINE page0Widgets   btatualiza btcancel btImportar btQueryJoins btReportsJoins btExit btHelp ~
                              c-it-codigo-tela  c-desc-item l-consid-estrutura c-hora d-data c-responsavel c-cod-estabel c-desc-est c-depos-entr c-local-entr c-refer-entr c-desc-dep-entr c-lote d-qtd-item ~
                              rs-tipo-trans c-depos-sai c-local-sai c-refer-sai c-desc-dep-sai i-ord-produ c-ct-codigo c-desc-conta c-sc-codigo c-desc-cc ~
                              brTable1 bt-alterar bt-marcar bt-desmarcar bt-marcartodos bt-desmarcartodos bt-transferir
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp               AS HANDLE                   NO-UNDO.
DEFINE VARIABLE i-cor-fg              AS INTEGER                  NO-UNDO.
DEFINE VARIABLE i-cor-bg              AS INTEGER                  NO-UNDO.
DEFINE VARIABLE i-seq-erro            AS INTEGER                  NO-UNDO.
DEFINE VARIABLE c-sit-item            AS CHAR                     NO-UNDO.

def var l-primeira                  as logical  init yes               no-undo.

define var c-formato-conta  as char no-undo.
define var c-formato-ccusto as char no-undo. 

DEFINE VARIABLE i-empresa                   LIKE estabelec.ep-codigo NO-UNDO.
DEFINE VARIABLE l-ckd                       AS LOG       NO-UNDO.
DEFINE VARIABLE l-item-ckd                  AS LOG       NO-UNDO.
DEFINE VARIABLE hDBOestabelec               AS HANDLE    NO-UNDO.
DEFINE VARIABLE hDBOWm-saldo-estoque        AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBOsc035                    AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_api_ccusto                AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_api_cta_ctbl              AS HANDLE    NO-UNDO.
DEFINE VARIABLE v_cod_formato               AS CHAR      NO-UNDO.
DEFINE VARIABLE v_log_utz_ccusto            AS LOG       NO-UNDO.
DEFINE VARIABLE v_cod_plano_ccusto          AS CHAR      NO-UNDO.
DEFINE VARIABLE v_des_plano_ccusto          AS CHAR      NO-UNDO.
DEFINE VARIABLE v_cod_ccusto                AS CHAR      NO-UNDO.
DEFINE VARIABLE v_des_ccusto                AS CHAR      NO-UNDO.
DEFINE VARIABLE v_cod_format_inic           AS CHAR      NO-UNDO.
DEFINE VARIABLE v_cod_format_fim            AS CHAR      NO-UNDO.
DEFINE VARIABLE v_cod_cta_ctbl              AS CHAR      NO-UNDO.
DEFINE VARIABLE v_des_cta_ctbl              AS CHAR      NO-UNDO.
DEFINE VARIABLE v_ind_finalid_cta           AS CHAR      NO-UNDO.
DEFINE VARIABLE v_num_tip_cta_ctbl          AS INT       NO-UNDO.
DEFINE VARIABLE v_num_sit_cta_ctbl          AS INT       NO-UNDO.
DEFINE VARIABLE d-quant-ant                 LIKE tt-item-mov.quantidade NO-UNDO.
DEFINE VARIABLE d-quantidade-mult           AS DEC       NO-UNDO.
DEFINE VARIABLE de-qtd-disponivel           AS DEC       NO-UNDO.
DEFINE VARIABLE l-erro-requisicao           as logical no-undo.
DEFINE VARIABLE i-nr-requisicao             like requisicao.nr-requisicao no-undo.
DEFINE VARIABLE i-cont                      AS INTEGER NO-UNDO.

def new global shared var c-it-codigo  like saldo-estoq.it-codigo   no-undo.
def var h_api_cta               as handle no-undo.
def var h_api_ccust             as handle no-undo.
def var v_cod_cta               as char   no-undo.
def var v_des_cta               as char   no-undo.
def var v_cod_ccust             as char   no-undo.
def var v_des_ccust             as char   no-undo.

DEFINE BUFFER b-requisicao         FOR requisicao.    
DEFINE BUFFER b-it-requis          FOR it-requisicao.
DEFINE BUFFER b-deposito           FOR deposito.
DEFINE BUFFER b-wm-etiqueta        FOR wm-etiqueta.
DEFINE BUFFER b-estrutura          FOR estrutura.
DEFINE BUFFER bsaldo-estoq         FOR saldo-estoq.

DEF TEMP-TABLE tt_log_erro NO-UNDO
    FIELD ttv_num_cod_erro      AS INTEGER FORMAT ">>>>,>>9" LABEL "N£mero"         COLUMN-LABEL "N£mero"
    FIELD ttv_des_msg_ajuda     AS CHARACTER FORMAT "x(40)"  LABEL "Mensagem Ajuda" COLUMN-LABEL "Mensagem Ajuda"
    FIELD ttv_des_msg_erro      AS CHARACTER FORMAT "x(60)"  LABEL "Mensagem Erro"  COLUMN-LABEL "Inconsistˆncia".

DEFINE VARIABLE wh-pesquisa    AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

{cep/ceapi001k.i}
{wmp/wm9000.i}
{wmp/wm9055.i}
{esapi/esapi006tt.i} /*** tt-estrutura ***/

DEFINE BUFFER b-tt-movto                 FOR tt-movto.
DEFINE BUFFER b-tt-item-mov              FOR tt-item-mov.

{cdp/cd0666.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-item-mov

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-item-mov.selec tt-item-mov.nr-seq tt-item-mov.it-codigo tt-item-mov.desc-item tt-item-mov.lote tt-item-mov.qtd-sai tt-item-mov.qtd-entr tt-item-mov.quantidade tt-item-mov.mensagem   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1   
&Scoped-define SELF-NAME brTable1
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-item-mov       BY tt-item-mov.cod-estabel       BY tt-item-mov.cod-emitente       BY tt-item-mov.serie-docto       BY tt-item-mov.nro-docto INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY {&SELF-NAME} FOR EACH tt-item-mov       BY tt-item-mov.nr-seq INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-item-mov
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-item-mov

/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brTable1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btQueryJoins btReportsJoins btExit btHelp ~
btAtualiza btcancel btImportar c-cod-estabel c-ct-codigo c-sc-codigo brTable1 bt-alterar bt-marcar bt-desmarcar bt-marcartodos bt-desmarcartodos bt-transferir ~
rtToolBar-2 RECT-1 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel c-desc-est c-depos-entr c-local-entr c-refer-entr ~
c-desc-dep-entr c-depos-sai c-local-sai c-refer-sai c-desc-dep-sai c-hora d-data c-responsavel ~
rs-tipo-trans c-it-codigo-tela c-desc-item l-consid-estrutura c-lote d-valid-lote d-qtd-item i-ord-produ c-status c-ct-codigo c-desc-conta ~
c-sc-codigo c-desc-cc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-2 c-hora d-data c-lote d-valid-lote
&Scoped-define List-3 c-hora d-data c-lote d-valid-lote 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn_sit_item wWindow 
FUNCTION fn_sit_item RETURNS CHARACTER
  ( p-idi-situacao AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ***********************  Control Definitions  ********************** */

DEFINE MENU POPUP-MENU-c-lote 
       MENU-ITEM mZoomLoteP     LABEL "Zoom de Lote Estoque".
DEFINE MENU POPUP-MENU-c-depos-entr 
       MENU-ITEM mZoomDeposE    LABEL "Zoom de Dep¢sitos"
       MENU-ITEM mZoomSalDepE   LABEL "Zoom de Saldos".
DEFINE MENU POPUP-MENU-c-depos-sai 
       MENU-ITEM mZoomDeposS    LABEL "Zoom de Dep¢sitos"
       MENU-ITEM mZoomSalDepS   LABEL "Zoom de Saldos".
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
DEFINE BUTTON bt-alterar 
     LABEL "Altera" 
     SIZE 15 BY 1.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-transferir 
     LABEL "Transferir" 
     SIZE 15 BY 1.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-marcar 
     LABEL "Marca" 
     SIZE 15 BY 1.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-desmarcar 
     LABEL "Desmarca" 
     SIZE 15 BY 1.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-marcartodos 
     LABEL "Marca Todos" 
     SIZE 15 BY 1.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-desmarcartodos 
     LABEL "Desmarca Todos" 
     SIZE 15 BY 1.

DEFINE BUTTON btAtualiza 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-relo.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Atualizar".

DEFINE BUTTON btcancel 
     IMAGE-UP FILE "image/im-cancel.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-relo.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Cancelar".

DEFINE BUTTON btImportar
     IMAGE-UP FILE "image/toolbar/im-exp.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-exp.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Importar arquivo".

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

/*
DEFINE VARIABLE rs-tipo-trans AS INTEGER LABEL "Transa»’o" INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Transfer¼ncia Dep½sitos", 1,
          "Transfer¼ncia Cento Custos", 2
     SIZE 50 BY .88 NO-UNDO. */

DEFINE VARIABLE rs-tipo-trans AS INTEGER LABEL "Transacao" INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Transferencia Depositos", 1
     SIZE 50 BY .88 NO-UNDO. 

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "x(3)" 
     LABEL "Estabel":R9 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88.

DEFINE VARIABLE c-ct-codigo AS CHARACTER FORMAT "x(08)" 
     LABEL "Conta":R17 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88.

DEFINE VARIABLE c-depos-entr AS CHARACTER FORMAT "x(3)" 
     LABEL "Deposito Entrada":R16 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-local-entr AS CHARACTER FORMAT "x(20)" 
     LABEL "Localizacao Entrada":R16 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-refer-entr AS CHARACTER FORMAT "x(8)" 
     LABEL "Referencia Entrada":R16 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-depos-sai AS CHARACTER FORMAT "x(3)" 
     LABEL "Deposito Saida":R16 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-local-sai AS CHARACTER FORMAT "x(20)" 
     LABEL "Localizacao Saida":R16 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-refer-sai AS CHARACTER FORMAT "x(8)" 
     LABEL "Referencia Saida":R16 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cc AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-conta AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-dep-entr AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 26.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-dep-sai AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 26.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-est AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 74.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.72 BY .88 NO-UNDO.

DEFINE VARIABLE l-consid-estrutura AS LOGICAL INITIAL YES
     LABEL "Considera estrutura"
     VIEW-AS TOGGLE-BOX 
     SIZE 18.72 BY .79 NO-UNDO.

DEFINE VARIABLE c-hora AS CHARACTER FORMAT "99:99" INITIAL "00:00"
     LABEL "Hora Entrada":R12 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE d-data AS DATE FORMAT "99/99/9999" 
      LABEL "Data Entrada":R12 
      VIEW-AS FILL-IN 
      SIZE 10 BY .88.

DEFINE VARIABLE c-it-codigo-tela AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE d-valid-lote AS DATE FORMAT "99/99/9999" 
      LABEL "Validade":R12 
      VIEW-AS FILL-IN 
      SIZE 10 BY .88.

DEFINE VARIABLE d-qtd-item AS DECIMAL FORMAT ">>>,>>>,>>9.9999" INITIAL 1
      LABEL "Quantidade":R12 
      VIEW-AS FILL-IN 
      SIZE 14 BY .88.

DEFINE VARIABLE c-lote AS CHARACTER FORMAT "x(20)" 
    LABEL "Lote":R12 
    VIEW-AS FILL-IN 
    SIZE 21 BY .88.

DEFINE VARIABLE c-responsavel AS CHARACTER FORMAT "X(12)":U 
     LABEL "Requisitante" 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-codigo AS CHARACTER FORMAT "x(08)" 
     LABEL "Centro de Custo":R17 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88.

DEFINE VARIABLE i-ord-produ AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Ordem Producao" 
     VIEW-AS FILL-IN 
     SIZE 14.43 BY .88 NO-UNDO.


DEFINE VARIABLE c-status AS CHARACTER FORMAT "X(30)":U 
     LABEL "Status" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 145 BY 9.5.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 145 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-item-mov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wWindow _FREEFORM
  QUERY brTable1 NO-LOCK DISPLAY
      tt-item-mov.selec       COLUMN-LABEL ""
      tt-item-mov.nr-seq      COLUMN-LABEL "Nr Seq"
      tt-item-mov.it-codigo   COLUMN-LABEL "Item" 
      tt-item-mov.desc-item   COLUMN-LABEL "Descricao Item" FORMAT "x(20)":U
      tt-item-mov.lote
      tt-item-mov.qtd-sai     COLUMN-LABEL "Qtd Saida" 
      tt-item-mov.qtd-entr    COLUMN-LABEL "Qtd Entrada" 
      tt-item-mov.quantidade  COLUMN-LABEL "Qtd Item"
      tt-item-mov.mensagem    FORMAT "x(90)"
/*     ENABLE              */
/*       tt-item-mov.selec */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 144 BY 12
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 131 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 135 HELP
          "Relat«rios relacionados"
     btExit AT ROW 1.13 COL 139 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 143 HELP
          "Ajuda"
     btAtualiza AT ROW 1.13 COL 3.43 WIDGET-ID 2
     btcancel   AT ROW 1.13 COL 13.43 WIDGET-ID 2
     btImportar AT ROW 1.13 COL 8.43 WIDGET-ID 2
     rs-tipo-trans AT ROW 1.2 COL 33 WIDGET-ID 2
     c-cod-estabel AT ROW 3 COL 14.43 COLON-ALIGNED WIDGET-ID 104
     c-desc-est AT ROW 3 COL 22.29 COLON-ALIGNED NO-LABEL WIDGET-ID 94
     c-it-codigo-tela AT ROW 4 COL 14.43 COLON-ALIGNED WIDGET-ID 110
     c-desc-item AT ROW 4 COL 32.29 COLON-ALIGNED NO-LABEL WIDGET-ID 96
     l-consid-estrutura AT ROW 4 COL 80.29 COLON-ALIGNED NO-LABEL WIDGET-ID 96
     c-depos-sai AT ROW 5 COL 14.43 COLON-ALIGNED WIDGET-ID 114
     c-desc-dep-sai AT ROW 5 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 116
     c-local-sai AT ROW 5 COL 60 COLON-ALIGNED WIDGET-ID 114
     c-refer-sai AT ROW 5 COL 90 COLON-ALIGNED WIDGET-ID 114
     c-depos-entr AT ROW 6 COL 14.43 COLON-ALIGNED WIDGET-ID 102
     c-desc-dep-entr AT ROW 6 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     c-local-entr AT ROW 6 COL 60 COLON-ALIGNED WIDGET-ID 114
     c-refer-entr AT ROW 6 COL 90 COLON-ALIGNED WIDGET-ID 114
     c-hora AT ROW 7 COL 14.43 COLON-ALIGNED WIDGET-ID 108

     d-data AT ROW 7 COL 33 COLON-ALIGNED WIDGET-ID 108

     c-lote AT ROW 8 COL 14.43 COLON-ALIGNED WIDGET-ID 112
     d-valid-lote AT ROW 8 COL 50 COLON-ALIGNED WIDGET-ID 112
     d-qtd-item AT ROW 8 COL 80 COLON-ALIGNED WIDGET-ID 112
     i-ord-produ AT ROW 9 COL 14.72 COLON-ALIGNED WIDGET-ID 122

     c-status AT ROW 9 COL 39 COLON-ALIGNED WIDGET-ID 122

     c-responsavel AT ROW 9 COL 75 COLON-ALIGNED WIDGET-ID 100
     c-ct-codigo AT ROW 10 COL 14.72 COLON-ALIGNED WIDGET-ID 120
     c-desc-conta AT ROW 10 COL 33.57 COLON-ALIGNED NO-LABEL WIDGET-ID 118
     c-sc-codigo AT ROW 11 COL 14.72 COLON-ALIGNED WIDGET-ID 124
     c-desc-cc AT ROW 11 COL 33.57 COLON-ALIGNED NO-LABEL WIDGET-ID 126
     brTable1 AT ROW 12.75 COL 3 WIDGET-ID 200
     bt-alterar        AT ROW 25 COL 3.14 WIDGET-ID 74
     bt-marcar         AT ROW 25 COL 18.14 WIDGET-ID 74
     bt-desmarcar      AT ROW 25 COL 33.14 WIDGET-ID 74
     bt-marcartodos    AT ROW 25 COL 48.14 WIDGET-ID 74
     bt-desmarcartodos AT ROW 25 COL 63.14 WIDGET-ID 74 
     bt-transferir     AT ROW 25 COL 132.14 WIDGET-ID 74
     rtToolBar-2 AT ROW 1 COL 3
     RECT-1 AT ROW 2.75 COL 3 WIDGET-ID 84
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 148 BY 25.54
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-item-mov T "?" NO-UNDO movind movto-estoq
      ADDITIONAL-FIELDS:
          field r-rowid as row
          field nr-seq as integer
          field desc-item as char format "x(60)"
          field qtd-entrada like movto-estoq.quantidade
          field qtd-saida   like movto-estoq.quantidade
          field mensagem    as char
          
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 25.54
         WIDTH              = 148
         MAX-HEIGHT         = 27.5
         MAX-WIDTH          = 190.14
         VIRTUAL-HEIGHT     = 27.5
         VIRTUAL-WIDTH      = 190.14
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB brTable1 c-desc-cc fpage0 */
ASSIGN 
       brTable1:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE.

ASSIGN 
       c-lote:POPUP-MENU IN FRAME fpage0       = MENU POPUP-MENU-c-lote:HANDLE.

ASSIGN 
       c-depos-entr:POPUP-MENU IN FRAME fpage0       = MENU POPUP-MENU-c-depos-entr:HANDLE.

ASSIGN 
       c-depos-sai:POPUP-MENU IN FRAME fpage0       = MENU POPUP-MENU-c-depos-sai:HANDLE.


/* SETTINGS FOR FILL-IN c-depos-entr IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-depos-sai IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cc IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-conta IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-dep-entr IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-dep-saida IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-est IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN l-consid-estrutura IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-hora IN FRAME fpage0
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-it-codigo-tela IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-lote IN FRAME fpage0
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-responsavel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-ord-produ IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-item-mov
      BY tt-item-mov.cod-estabel
      BY tt-item-mov.cod-emitente
      BY tt-item-mov.serie-docto
      BY tt-item-mov.nro-docto INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED,"
     _OrdList          = "Temp-Tables.tt-item-mov.cod-estabel|yes,Temp-Tables.tt-item-mov.cod-emitente|yes,Temp-Tables.tt-item-mov.serie-docto|yes,Temp-Tables.tt-item-mov.nro-docto|yes"
     _Where[1]         = "Temp-Tables.tt-item-mov.cnpj >= c-cnpj-ini
 AND Temp-Tables.tt-item-mov.cnpj <= c-cnpj-fim"
     _Query            is OPENED
*/  /* BROWSE brTable1 */
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


&Scoped-define BROWSE-NAME brTable1
&Scoped-define SELF-NAME brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable1 wWindow
ON ROW-DISPLAY OF brTable1 IN FRAME fpage0
DO:
    IF AVAIL tt-item-mov  
    THEN DO:
        ASSIGN i-cor-bg = 15 i-cor-fg = 1.

        CASE tt-item-mov.nr-cor:
           WHEN 1 THEN ASSIGN i-cor-bg = 15 i-cor-fg = 1.  
           WHEN 2 THEN ASSIGN i-cor-bg = 12 i-cor-fg = 15. 
           WHEN 3 THEN ASSIGN i-cor-bg = 14 i-cor-fg = 1.
           WHEN 4 THEN ASSIGN i-cor-bg = 2  i-cor-fg = 15.
        END CASE.
        
        ASSIGN tt-item-mov.selec:BGCOLOR        IN BROWSE brTable1 = i-cor-bg
               tt-item-mov.selec:FGCOLOR        IN BROWSE brTable1 = i-cor-fg
               tt-item-mov.nr-seq:BGCOLOR       IN BROWSE brTable1 = i-cor-bg
               tt-item-mov.nr-seq:FGCOLOR       IN BROWSE brTable1 = i-cor-fg
               tt-item-mov.it-codigo:BGCOLOR    IN BROWSE brTable1 = i-cor-bg
               tt-item-mov.it-codigo:FGCOLOR    IN BROWSE brTable1 = i-cor-fg
               tt-item-mov.desc-item:BGCOLOR    IN BROWSE brTable1 = i-cor-bg
               tt-item-mov.desc-item:FGCOLOR    IN BROWSE brTable1 = i-cor-fg
               tt-item-mov.lote:BGCOLOR         IN BROWSE brTable1 = i-cor-bg
               tt-item-mov.lote:FGCOLOR         IN BROWSE brTable1 = i-cor-fg
               tt-item-mov.qtd-sai:BGCOLOR      IN BROWSE brTable1 = i-cor-bg
               tt-item-mov.qtd-sai:FGCOLOR      IN BROWSE brTable1 = i-cor-fg
               tt-item-mov.qtd-entr:BGCOLOR     IN BROWSE brTable1 = i-cor-bg
               tt-item-mov.qtd-entr:FGCOLOR     IN BROWSE brTable1 = i-cor-fg
               tt-item-mov.quantidade:BGCOLOR   IN BROWSE brTable1 = i-cor-bg
               tt-item-mov.quantidade:FGCOLOR   IN BROWSE brTable1 = i-cor-fg
               tt-item-mov.mensagem:BGCOLOR     IN BROWSE brTable1 = i-cor-bg
               tt-item-mov.mensagem:FGCOLOR     IN BROWSE brTable1 = i-cor-fg.

           
    END.
   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brtable1 w-window
ON MOUSE-SELECT-DBLCLICK OF brtable1 IN FRAME fpage0
DO:
    if  avail tt-item-mov 
    AND tt-item-mov.selec = YES THEN 
        apply 'choose' to bt-desmarcar in frame {&frame-name}.
    ELSE
        apply 'choose' to bt-marcar in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-transferir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-transferir wWindow
ON CHOOSE OF bt-transferir IN FRAME fpage0 /* Transferir */
DO:
    DEF VAR p-nr-docto AS INTEGER NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.    

      RUN pi-transferir (OUTPUT p-nr-docto).

      IF RETURN-VALUE = "OK" THEN DO:

          MESSAGE "Processamento ocorrido com sucesso para documento " + string(p-nr-docto) + "!"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
          
          EMPTY TEMP-TABLE tt-item-mov.
          ASSIGN c-it-codigo-tela:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" 
                 c-desc-item:SCREEN-VALUE IN FRAME {&frame-name}      = ""
                 c-hora:SCREEN-VALUE IN FRAME {&frame-name}           = "00:00"

                  d-data:SCREEN-VALUE IN FRAME {&frame-name}           = ''
                 
                 c-cod-estabel:SCREEN-VALUE IN FRAME {&frame-name}    = ""
                 c-desc-est:SCREEN-VALUE IN FRAME {&frame-name}       = ""
                 c-depos-entr:SCREEN-VALUE IN FRAME {&frame-name}     = ""
                 c-local-entr:SCREEN-VALUE IN FRAME {&frame-name}     = ""
                 c-refer-entr:SCREEN-VALUE IN FRAME {&frame-name}     = ""
                 c-desc-dep-entr:SCREEN-VALUE IN FRAME {&frame-name}  = ""
                 c-lote:SCREEN-VALUE IN FRAME {&frame-name}           = ""
                 d-valid-lote:SCREEN-VALUE IN FRAME {&frame-name}     = ""
                 d-qtd-item:SCREEN-VALUE IN FRAME {&frame-name}       = "0"
                 c-depos-sai:SCREEN-VALUE IN FRAME {&frame-name}      = ""
                 c-local-sai:SCREEN-VALUE IN FRAME {&frame-name}      = ""
                 c-refer-sai:SCREEN-VALUE IN FRAME {&frame-name}      = ""
                 c-desc-dep-sai:SCREEN-VALUE IN FRAME {&frame-name}   = ""
                 i-ord-produ:SCREEN-VALUE IN FRAME {&frame-name}      = "0"
                 c-status:SCREEN-VALUE IN FRAME {&frame-name}         = ""
                 c-ct-codigo:SCREEN-VALUE IN FRAME {&frame-name}      = ""
                 c-desc-conta:SCREEN-VALUE IN FRAME {&frame-name}     = ""
                 c-sc-codigo:SCREEN-VALUE IN FRAME {&frame-name}      = ""
                 c-desc-cc:SCREEN-VALUE IN FRAME {&frame-name}        = ""  

                 c-depos-entr:SENSITIVE IN FRAME fPage0               = YES
                 c-depos-sai:SENSITIVE IN FRAME fPage0                = YES
                 c-hora:SENSITIVE IN FRAME fPage0                     = YES
                
                 d-data:SENSITIVE IN FRAME fPage0                     = YES

                 l-consid-estrutura:SENSITIVE IN FRAME fPage0         = YES
                 i-ord-produ:SENSITIVE IN FRAME fPage0 = YES
                 c-status:SENSITIVE IN FRAME fPage0    = NO 
                 c-ct-codigo:SENSITIVE IN FRAME fPage0 = NO
                 c-sc-codigo:SENSITIVE IN FRAME fPage0 = NO.

          APPLY "VALUE-CHANGED":U TO rs-tipo-trans IN FRAME fpage0.
          APPLY "LEAVE":U TO c-depos-entr IN FRAME fpage0.
          APPLY "LEAVE":U TO c-depos-sai IN FRAME fpage0.

          {&OPEN-QUERY-brTable1}

      END.

      {&OPEN-QUERY-brTable1}

        /*
     find first b-tt-item-mov where
                b-tt-item-mov.r-rowid = r-rw-movto no-error.
     if avail b-tt-item-mov then do:
       
        assign r-rw-movto = rowid(b-tt-item-mov).
                     
        reposition brtable1 to rowid(r-rw-movto).
     end.     
    */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-alterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-alterar wWindow
ON CHOOSE OF bt-alterar IN FRAME fpage0 /* Transferir */
DO:
  if  avail tt-item-mov AND tt-item-mov.altera THEN 
      IF NOT l-ckd OR (l-ckd AND in-wm-param.log-separa-ckd) then do:
            
          ASSIGN d-quant-ant = tt-item-mov.quantidade. 

          UPDATE tt-item-mov.quantidade LABEL "Qtd Item" WITH 1 COL VIEW-AS DIALOG-BOX TITLE "Altera" FRAME f1.

          /*ASSIGN d-quantidade-mult = 0.
    
          FIND FIRST wm-item-embalagem-local 
               WHERE wm-item-embalagem-local.cod-estabel = c-cod-estabel
                 AND wm-item-embalagem-local.cod-item    = c-it-codigo-tela
                 AND wm-item-embalagem-local.cod-local   = c-depos-sai
				 AND wm-item-embalagem-local.log-padrao = true NO-LOCK NO-ERROR.
          IF AVAIL wm-item-embalagem-local  THEN DO:
             /*IF wm-item-embalagem-local.log-abre-emb-item = NO 
             AND wm-item-embalagem-local.qtd-emb-item <> 0 THEN DO:*/
    
	         IF wm-item-embalagem-local.qtd-emb-item <> 0 THEN DO:
                ASSIGN d-quantidade-mult = tt-item-mov.quantidade / wm-item-embalagem-local.qtd-emb-item. 
    
                IF d-quantidade-mult <> TRUNC(d-quantidade-mult,0) THEN
                   ASSIGN d-quantidade-mult = (TRUNC(d-quantidade-mult,0) + 1) * wm-item-embalagem-local.qtd-emb-item.
    
             END.
          END.*/

          FIND CURRENT tt-item-mov EXCLUSIVE-LOCK NO-ERROR.
          IF tt-item-mov.qtd-saida < tt-item-mov.quantidade THEN DO:
              ASSIGN tt-item-mov.mensagem = "Saldo de " + trim(string(tt-item-mov.qtd-saida)) + " no dep½sito de sa­da ² insuficiente".             
              ASSIGN tt-item-mov.quantidade = 0
                     tt-item-mov.nr-cor = 2 /*"Vermelho"*/
                     tt-item-mov.altera      = YES.
              disp tt-item-mov.quantidade tt-item-mov.mensagem with browse {&browse-name}. 
                {&OPEN-QUERY-brTable1}
          END.
          ELSE DO:
            disp tt-item-mov.quantidade with browse {&browse-name}.
            IF tt-item-mov.quantidade <> 0 AND tt-item-mov.quantidade <> d-quant-ant THEN DO:
               ASSIGN tt-item-mov.nr-cor = 1
                      tt-item-mov.mensagem = "".
                 {&OPEN-QUERY-brTable1}
            END.
          END.
      END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-marcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marcar wWindow
ON CHOOSE OF bt-marcar IN FRAME fpage0 /* Marcar */
DO:
    if  avail tt-item-mov 
    AND tt-item-mov.altera THEN
        IF NOT l-ckd 
        OR (l-ckd AND in-wm-param.log-separa-ckd) then do:
            assign tt-item-mov.selec = YES.
            disp tt-item-mov.selec with browse {&browse-name}.
        end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-desmarcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarcar wWindow
ON CHOOSE OF bt-desmarcar IN FRAME fpage0 /* Desmarcar */
DO:
    if  avail tt-item-mov 
    AND tt-item-mov.altera THEN
        IF NOT l-ckd 
        OR (l-ckd AND in-wm-param.log-separa-ckd) then do:
            assign tt-item-mov.selec = NO.
            disp tt-item-mov.selec with browse {&browse-name}.
        end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-marcartodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marcartodos wWindow
ON CHOOSE OF bt-marcartodos IN FRAME fpage0 /* Marcar Todos*/
DO:
    FOR EACH tt-item-mov WHERE tt-item-mov.altera:
        assign tt-item-mov.selec = YES.
        disp tt-item-mov.selec with browse {&browse-name}.
    END.
{&OPEN-QUERY-{&browse-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-desmarcartodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarcartodos wWindow
ON CHOOSE OF bt-desmarcartodos IN FRAME fpage0 /* Desmarcar todos */
DO:
    FOR EACH tt-item-mov:
        assign tt-item-mov.selec = NO.
        disp tt-item-mov.selec with browse {&browse-name}.
    END.
{&OPEN-QUERY-{&browse-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAtualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualiza wWindow
ON CHOOSE OF btAtualiza IN FRAME fpage0
DO:
    APPLY "leave":U TO c-ct-codigo IN FRAME fPage0.       
    APPLY "leave":U TO c-sc-codigo IN FRAME fPage0.

    APPLY "leave":U TO i-ord-produ IN FRAME fPage0.

     ASSIGN  input frame fpage0 c-it-codigo-tela  c-desc-item c-hora d-data c-responsavel c-cod-estabel c-desc-est 
                                c-depos-entr c-local-entr c-refer-entr c-desc-dep-entr c-lote d-valid-lote d-qtd-item
                                c-depos-sai c-local-sai c-refer-sai c-desc-dep-sai i-ord-produ c-status c-ct-codigo 
                                c-desc-conta c-sc-codigo c-desc-cc rs-tipo-trans l-consid-estrutura. 

     
     IF c-cod-estabel <> "" THEN
         RUN pi-CarregaMovto.

     IF CAN-FIND(FIRST tt-item-mov) THEN DO:
         ASSIGN c-depos-entr:SENSITIVE IN FRAME fPage0 = NO
                c-depos-sai:SENSITIVE IN FRAME fPage0 = NO
                c-local-entr:SENSITIVE IN FRAME fPage0 = NO
                c-local-sai:SENSITIVE IN FRAME fPage0 = NO
                c-hora:SENSITIVE IN FRAME fPage0 = NO

                d-data:SENSITIVE IN FRAME fPage0 = NO
               
                l-consid-estrutura:SENSITIVE IN FRAME fPage0 = NO
                i-ord-produ:SENSITIVE IN FRAME fPage0 = NO
                c-status   :SENSITIVE IN FRAME fPage0 = NO
                c-ct-codigo:SENSITIVE IN FRAME fPage0 = NO
                c-refer-entr:SENSITIVE IN FRAME fPage0 = NO
                c-refer-sai:SENSITIVE IN FRAME fPage0 = NO
                c-sc-codigo:SENSITIVE IN FRAME fPage0 = NO
                .
     END.

     {&OPEN-QUERY-{&browse-name}}
     
END.

&Scoped-define SELF-NAME btcancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btcancel wWindow
ON CHOOSE OF btcancel IN FRAME fpage0
DO:
    ASSIGN c-depos-entr:SENSITIVE IN FRAME fPage0 = YES
           c-depos-sai:SENSITIVE IN FRAME fPage0 = YES
           c-hora:SENSITIVE IN FRAME fPage0 = YES
           
           d-data:SENSITIVE IN FRAME fPage0 = YES
           
           l-consid-estrutura:SENSITIVE IN FRAME fPage0 = YES
           i-ord-produ:SENSITIVE IN FRAME fPage0 = YES
           c-it-codigo-tela:SENSITIVE IN FRAME fPage0 = YES
           c-status   :SENSITIVE IN FRAME fPage0 = NO
           c-ct-codigo:SENSITIVE IN FRAME fPage0 = NO
           c-sc-codigo:SENSITIVE IN FRAME fPage0 = NO.

    APPLY "VALUE-CHANGED":U TO rs-tipo-trans IN FRAME fpage0.
    APPLY "LEAVE":U TO c-depos-entr IN FRAME fpage0.
    APPLY "LEAVE":U TO c-depos-sai IN FRAME fpage0.

    EMPTY TEMP-TABLE tt-item-mov.    
        
    {&OPEN-QUERY-{&browse-name}}
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btImportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImportar wWindow
ON CHOOSE OF btImportar IN FRAME fpage0
DO:
    DEF VAR c-arq-entrada AS CHAR NO-UNDO.
    DEF VAR c-dados AS CHAR NO-UNDO.
    
    RUN wmp/iwm9700a.w(OUTPUT c-arq-entrada).
    IF c-arq-entrada = "" THEN RETURN NO-APPLY.

    ASSIGN  input frame fpage0  c-desc-item c-hora d-data c-responsavel c-cod-estabel c-desc-est 
                                c-depos-entr c-local-entr c-refer-entr c-desc-dep-entr d-valid-lote 
                                c-depos-sai c-local-sai c-refer-sai c-desc-dep-sai i-ord-produ c-status c-ct-codigo 
                                c-desc-conta c-sc-codigo c-desc-cc rs-tipo-trans. 

    INPUT FROM VALUE(c-arq-entrada).
    REPEAT:
        IMPORT UNFORMATTED c-dados.

        ASSIGN c-it-codigo-tela = ENTRY(1,c-dados,";") 
               c-lote = ENTRY(2,c-dados,";")
               d-qtd-item = dec(ENTRY(3,c-dados,";"))
               l-consid-estrutura = NO.

        RUN pi-CarregaMovto.
               
    END.

    INPUT CLOSE.

    IF CAN-FIND(FIRST tt-item-mov) THEN DO:
         ASSIGN c-depos-entr:SENSITIVE IN FRAME fPage0 = NO
                c-depos-sai:SENSITIVE IN FRAME fPage0 = NO
                c-local-entr:SENSITIVE IN FRAME fPage0 = NO
                c-local-sai:SENSITIVE IN FRAME fPage0 = NO
                c-hora:SENSITIVE IN FRAME fPage0 = NO
                
                d-data:SENSITIVE IN FRAME fPage0 = NO 
                
                l-consid-estrutura:SENSITIVE IN FRAME fPage0 = NO
                i-ord-produ:SENSITIVE IN FRAME fPage0 = NO
                c-ct-codigo:SENSITIVE IN FRAME fPage0 = NO
                c-refer-entr:SENSITIVE IN FRAME fPage0 = NO
                c-refer-sai:SENSITIVE IN FRAME fPage0 = NO
                c-sc-codigo:SENSITIVE IN FRAME fPage0 = NO
                c-lote:SENSITIVE IN FRAME fPage0 = NO
                d-valid-lote:SENSITIVE IN FRAME {&frame-name} = NO.
     END.
        
    {&OPEN-QUERY-{&browse-name}}
     
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


&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON F5 OF c-cod-estabel IN FRAME fpage0 /* Estabel */
DO:

 {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                    &campo=c-cod-estabel
                    &campo2=c-desc-est
                    &campozoom=cod-estabel
                    &campozoom2=nome}  
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON LEAVE OF c-cod-estabel IN FRAME fpage0 /* Estabel */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-desc-est
                   &where="estabelec.cod-estabel = input frame {&frame-name} 
                           c-cod-estabel"}
   IF AVAIL estabelec THEN DO:
    
        ASSIGN i-empresa = estabelec.ep-codigo.

        FIND FIRST estab-mat WHERE estab-mat.cod-estabel = estabelec.cod-estabel NO-LOCK NO-ERROR.
        IF AVAIL estab-mat THEN DO:
            ASSIGN c-ct-codigo = estab-mat.cod-cta-transf-unif
                   c-sc-codigo = estab-mat.cod-ccusto-transf-unif.
            
            /* Retorna formato da conta contabil */
            run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                               input  "",                 /* PLANO CONTAS */
                                                               input  TODAY,              /* DATA DE TRANSACAO */
                                                               output c-formato-conta,    /* FORMATO CONTA */
                                                               output table tt_log_erro). /* ERROS */
            /* Retorna formato do centro de custo */
            run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                           input  "",                 /* PLANO CCUSTO */
                                                           input  TODAY,              /* DATA DE TRANSACAO */
                                                           output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                           output table tt_log_erro). /* ERROS */
            if c-formato-conta <> "" then
               assign c-ct-codigo:format in frame {&FRAME-NAME} = c-formato-conta.
            if c-formato-ccusto <> "" then
               assign c-sc-codigo:format in frame {&FRAME-NAME} = c-formato-ccusto.  
                                                                             
            ASSIGN c-ct-codigo:SCREEN-VALUE IN FRAME fPage0 = c-ct-codigo
                   c-sc-codigo:SCREEN-VALUE IN FRAME fPage0 = c-sc-codigo.
            IF c-ct-codigo <> "" THEN
                APPLY "leave":U TO c-ct-codigo IN FRAME fPage0.       
            IF c-sc-codigo <> "" THEN
                APPLY "leave":U TO c-sc-codigo IN FRAME fPage0.
            
            FIND first usuar-mater where usuar-mater.cod-usuario = c-seg-usuario NO-LOCK NO-ERROR.
            if  avail usuar-mater 
            AND rs-tipo-trans:SCREEN-VALUE IN FRAME fPage0 = "2" then do:
                assign c-sc-codigo:format in frame {&frame-name} = "x(20)".
                assign c-sc-codigo:screen-value in frame {&frame-name} = usuar-mater.sc-codigo.
                            
                /* CENTRO CUSTO */
                IF c-sc-codigo:SCREEN-VALUE <> "" THEN DO:
                    RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  i-empresa,                                   /* EMPRESA EMS2 */
                                                               INPUT  "",                                          /* CODIGO DO PLANO CCUSTO */
                                                               INPUT  usuar-mater.sc-codigo,                       /* CCUSTO */
                                                               INPUT  TODAY,                                       /* DATA DE TRANSACAO */
                                                               OUTPUT v_des_ccusto,                                /* DESCRICAO DO CCUSTO */
                                                               OUTPUT TABLE tt_log_erro).                          /* ERROS */         
                END.
                assign c-desc-cc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.

                IF RETURN-VALUE = "OK" then do:
                    run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                                   input  "",                 /* PLANO CCUSTO */
                                                                   input  TODAY,             /* DATA DE TRANSACAO */
                                                                   output v_cod_formato,      /* FORMATO CCUSTO */
                                                                   output table tt_log_erro). /* ERROS */
                    IF NOT CAN-FIND(FIRST tt_log_erro) THEN
                        assign c-sc-codigo:format in frame {&frame-name} = v_cod_formato.
                end.
                /* CENTRO CUSTO */
            end.
        END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME fpage0 /* Estabel */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo wWindow
ON ENTRY OF c-ct-codigo IN FRAME fpage0 /* Conta */
DO:
    find first param-global no-lock no-error.

   assign c-ct-codigo:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo wWindow
ON F5 OF c-ct-codigo IN FRAME fpage0 /* Conta */
DO:
    RUN limpaErros.
    run pi_zoom_cta_ctbl_integr in h_api_cta (input  i-empresa,                 /* EMPRESA EMS2 */
                                              input  "CEP",                     /* MÎDULO */
                                              input  "",                        /* PLANO DE CONTAS */
                                              input  "(nenhum)",                /* FINALIDADES */
                                              input  TODAY,                     /* DATA TRANSACAO */
                                              output v_cod_cta,                 /* CODIGO CONTA */
                                              output v_des_cta,                 /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,         /* FINALIDADE DA CONTA */
                                              output table tt_log_erro).        /* ERROS */ 
        
    IF NOT CAN-FIND(FIRST tt_log_erro) OR RETURN-VALUE = "OK" THEN 
        IF v_cod_cta <> "" THEN
        ASSIGN c-ct-codigo:screen-value in frame {&FRAME-NAME} = v_cod_cta
               c-desc-conta:screen-value in frame {&FRAME-NAME} = v_des_cta.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF c-ct-codigo IN FRAME fpage0 /* Conta */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo wMasterDetail
ON LEAVE OF c-ct-codigo IN FRAME fpage0 /* Conta */
DO:
    ASSIGN c-desc-conta = "".
    IF c-ct-codigo:SCREEN-VALUE <> "" THEN DO:
        ASSIGN c-ct-codigo:FORMAT IN FRAME fPage0 = "x(20)"
               v_cod_cta_ctbl = c-ct-codigo:SCREEN-VALUE.
        RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        i-empresa,                      /* EMPRESA EMS2 */
                                                       INPUT        "",                             /* PLANO DE CONTAS */
                                                       INPUT-OUTPUT v_cod_cta_ctbl,                 /* CONTA */
                                                       INPUT        TODAY,                          /* DATA TRANSACAO */   
                                                       OUTPUT       c-desc-conta,                   /* DESCRICAO CONTA */
                                                       OUTPUT       v_num_tip_cta_ctbl,             /* TIPO DA CONTA */
                                                       OUTPUT       v_num_sit_cta_ctbl,             /* SITUA°€O DA CONTA */
                                                       OUTPUT       v_ind_finalid_cta,              /* FINALIDADES DA CONTA */
                                                       OUTPUT TABLE tt_log_erro).                   /* ERROS */

    END.
    if c-formato-conta <> "" then
       assign c-ct-codigo:format in frame {&FRAME-NAME} = c-formato-conta.
    DISP c-desc-conta WITH FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-consid-estrutura wMasterDetail
ON VALUE-CHANGED OF l-consid-estrutura IN FRAME fpage0 /* Conta */
DO:
    /*IF INPUT FRAME fPage0 l-consid-estrutura and
       can-find(FIRST estrutura
                WHERE estrutura.it-codigo = INPUT FRAME fPage0 c-it-codigo-tela) THEN
        ASSIGN d-qtd-item:SENSITIVE IN FRAME fPage0 = YES.
    ELSE
        ASSIGN d-qtd-item:SCREEN-VALUE IN FRAME fPage0 = "1"
               d-qtd-item:SENSITIVE IN FRAME fPage0 = NO.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo wWindow
ON F5 OF c-sc-codigo IN FRAME fpage0 /* Conta */
DO:
    RUN limpaErros.
    run pi_zoom_ccusto in h_api_ccust (input  i-empresa,          /* EMPRESA EMS2 */
                                       input  "",                 /* CODIGO DO PLANO CCUSTO */
                                       input  "",                 /* UNIDADE DE NEGOCIO */
                                       input  TODAY,              /* DATA DE TRANSACAO */
                                       output v_cod_ccust,        /* CODIGO CCUSTO */
                                       output v_des_ccust,        /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 
    
    IF NOT CAN-FIND(tt_log_erro)OR RETURN-VALUE = "OK" THEN
        IF v_cod_ccust <> "" THEN
            ASSIGN c-sc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccust
                   c-desc-cc:SCREEN-VALUE IN FRAME {&FRAME-NAME}   = v_des_ccust.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF c-sc-codigo IN FRAME fpage0 /* Conta */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo wMasterDetail
ON LEAVE OF c-sc-codigo IN FRAME fpage0 /* Conta */
DO:
    ASSIGN c-desc-cc = "".
    IF c-sc-codigo:SCREEN-VALUE <> "" THEN DO:
        RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  i-empresa,                                                /* EMPRESA EMS2 */
                                                   INPUT  "",                                                       /* CODIGO DO PLANO CCUSTO */
                                                   INPUT  c-sc-codigo,  /* CCUSTO */
                                                   INPUT  TODAY,                                       /* DATA DE TRANSACAO */
                                                   OUTPUT c-desc-cc,                                             /* DESCRICAO DO CCUSTO */
                                                   OUTPUT TABLE tt_log_erro).                                       /* ERROS */         
    END.
    DISP c-desc-cc WITH FRAME fPage0.
END.

&Scoped-define SELF-NAME c-depos-entr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-entr wWindow
ON F5 OF c-depos-entr IN FRAME fpage0 /* Dep«sito Entrada */
DO:
    assign l-implanta = NO.
    
    {include/zoomvar.i
        &prog-zoom=inzoom/z01in084.w
        &campo=c-depos-entr
        &campo2=c-desc-dep-entr
        &campozoom=cod-depos
        &campozoom2=nome
        &FRAME=fpage0}.
            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mZoomDeposE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomDeposE V-table-Win
ON CHOOSE OF MENU-ITEM mZoomDeposE /* Zoom de Dep½sitos */
DO:
    apply "F5" to c-depos-sai in frame {&frame-name}.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mZoomSalDepE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalDepE V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalDepE /* Zoom de Saldos */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = "c-depos-entr"
        &campozoom  = "cod-depos"
        &campo2     = "c-refer-entr"
        &campozoom2 = "cod-refer"
        &campo3     = "c-local-entr"
        &campozoom3 = "cod-localiz"
        &campo4     = "c-lote"
        &campozoom4 = "lote"
        &campo5     = "c-desc-dep-entr"
        &campozoom5 = "nome"}
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mZoomLoteP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomLoteP V-table-Win
ON CHOOSE OF MENU-ITEM mZoomLoteP /* Zoom de Dep½sitos */
DO:
    apply "F5" to c-lote in frame {&frame-name}.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomDeposS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomDeposS V-table-Win
ON CHOOSE OF MENU-ITEM mZoomDeposS /* Zoom de Dep½sitos */
DO:
    apply "F5" to c-depos-sai in frame {&frame-name}.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mZoomSalDepS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalDepS V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalDepS /* Zoom de Saldos */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = "c-depos-sai"
        &campozoom  = "cod-depos"
        &campo2     = "c-refer-sai"
        &campozoom2 = "cod-refer"
        &campo3     = "c-local-sai"
        &campozoom3 = "cod-localiz"
        &campo4     = "c-lote"
        &campozoom4 = "lote"
        &campo5     = "c-desc-dep-sai"
        &campozoom5 = "nome"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-entr wWindow
ON LEAVE OF c-depos-entr IN FRAME fpage0 /* Dep«sito Entrada */
DO:
    {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=c-desc-dep-entr
                   &where="deposito.cod-depos = input frame {&frame-name} 
                           c-depos-entr"}

     IF c-depos-entr:SCREEN-VALUE IN FRAME {&frame-name} <> "" THEN
         ASSIGN c-sc-codigo:SCREEN-VALUE IN FRAME {&frame-name} = ""
                c-desc-cc:SCREEN-VALUE IN FRAME {&frame-name}   = ""
                c-sc-codigo:SENSITIVE IN FRAME {&frame-name}    = NO.
     ELSE DO:
         ASSIGN c-sc-codigo:SENSITIVE IN FRAME {&frame-name} = NO.
     END.
     FOR FIRST b-deposito
         FIELDS ( cod-depos log-gera-wms log-aloca-qtd-wms )
         WHERE b-deposito.cod-depos = c-depos-entr:SCREEN-VALUE IN FRAME {&frame-name} NO-LOCK: 
         IF b-deposito.log-gera-wms THEN
             ASSIGN c-local-entr:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                    c-local-entr:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
         ELSE 
             ASSIGN c-local-entr:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
     END.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo-tela wWindow
ON LEAVE OF c-it-codigo-tela IN FRAME fpage0 /* Item */
DO:
    IF c-it-codigo-tela:SCREEN-VALUE IN FRAME {&frame-name} <> "" THEN DO:
        {include/leave.i &tabela=ITEM
                       &atributo-ref=desc-item
                       &variavel-ref=c-desc-item
                       &where="item.it-codigo = input frame {&frame-name} 
                               c-it-codigo-tela"}
    
       IF AVAIL ITEM THEN DO:
           FIND FIRST in-grup-estoq WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-LOCK NO-ERROR.
           IF AVAIL in-grup-estoq THEN
               ASSIGN l-ckd = in-grup-estoq.log-ckd.
           ELSE
               ASSIGN l-ckd = NO.
               
       END.
       IF ITEM.tipo-con-est = 1 THEN ASSIGN c-lote:SCREEN-VALUE IN FRAME {&frame-name} = ""
                                            c-lote:SENSITIVE IN FRAME {&frame-name} = NO
                                            d-valid-lote:SENSITIVE IN FRAME {&frame-name} = NO
                                            c-refer-sai:SENSITIVE IN FRAME {&frame-name} = NO
                                            c-refer-entr:SENSITIVE IN FRAME {&frame-name} = NO.
       IF ITEM.tipo-con-est = 2 THEN ASSIGN c-lote:SENSITIVE IN FRAME {&frame-name} = YES
                                            d-valid-lote:SENSITIVE IN FRAME {&frame-name} = NO
                                            c-refer-sai:SENSITIVE IN FRAME {&frame-name} = NO
                                            c-refer-entr:SENSITIVE IN FRAME {&frame-name} = NO.
       IF ITEM.tipo-con-est = 3 THEN ASSIGN c-lote:SENSITIVE IN FRAME {&frame-name} = YES
                                            /*d-valid-lote:SENSITIVE IN FRAME {&frame-name} = YES*/
                                            c-refer-sai:SENSITIVE IN FRAME {&frame-name} = NO
                                            c-refer-entr:SENSITIVE IN FRAME {&frame-name} = NO.
       IF ITEM.tipo-con-est = 4 THEN ASSIGN c-lote:SENSITIVE IN FRAME {&frame-name} = YES
                                            /*d-valid-lote:SENSITIVE IN FRAME {&frame-name} = YES*/
                                            c-refer-sai:SENSITIVE IN FRAME {&frame-name} = YES
                                            c-refer-entr:SENSITIVE IN FRAME {&frame-name} = YES.
       ASSIGN c-it-codigo = ITEM.it-codigo.

       APPLY "value-changed":U TO l-consid-estrutura IN FRAME fPage0.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-produ wWindow
ON LEAVE OF i-ord-produ IN FRAME fpage0 /* Item */
DO:   

    IF i-ord-produ:SCREEN-VALUE IN FRAME {&frame-name} <> "0" THEN DO:

        FIND FIRST ord-prod WHERE ord-prod.nr-ord-prod = INT(i-ord-produ:SCREEN-VALUE IN FRAME {&frame-name}) NO-LOCK NO-ERROR.
        IF NOT AVAIL ord-prod THEN DO:
           MESSAGE "Ordem de Produ‡Æo nÆo encontrada!"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           RETURN "NOK":U.
        END.

        IF ord-prod.estado > 6 THEN DO:
           MESSAGE "Estado da OP nao permite movimento !" SKIP
                   "Altere para uma OP valida"
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
           RETURN "NOK":U.            
        END.

        FIND FIRST reservas WHERE reservas.nr-ord-produ = int(i-ord-produ:SCREEN-VALUE IN FRAME {&frame-name}) NO-LOCK NO-ERROR.
        IF NOT AVAIL reservas THEN DO:
           MESSAGE "Ordem de Produ‡Æo nÆo possui reservas!"
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
           RETURN "NOK":U.
        END.

        FIND FIRST ITEM WHERE ITEM.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.
        IF NOT AVAIL ITEM THEN DO:
           MESSAGE "Produto da OP nao encontrado !"
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
           RETURN "NOK":U.            
        END.
        
        ASSIGN c-it-codigo-tela:SCREEN-VALUE IN FRAME {&frame-name} = ITEM.it-codigo
               c-desc-item:SCREEN-VALUE IN FRAME {&frame-name}      = ITEM.desc-item.

        IF  c-local-entr:SCREEN-VALUE IN FRAME {&frame-name} = '' THEN
               c-local-entr:SCREEN-VALUE IN FRAME {&frame-name}     = REPLACE(i-ord-produ:SCREEN-VALUE IN FRAME {&frame-name},'.','').
       
       //FIND FIRST ITEM WHERE ITEM.it-codigo = reserva.item-pai NO-LOCK NO-ERROR.
       /*
       ASSIGN c-it-codigo-tela:SCREEN-VALUE IN FRAME {&frame-name} = reserva.item-pai
              c-desc-item:SCREEN-VALUE IN FRAME {&frame-name} = IF AVAIL ITEM THEN ITEM.desc-item ELSE ""*/

       ASSIGN c-it-codigo-tela:SENSITIVE IN FRAME {&frame-name} = NO
              c-lote:SCREEN-VALUE IN FRAME {&frame-name} = ""              
              c-lote:SENSITIVE IN FRAME {&frame-name} = NO              
              d-valid-lote:SCREEN-VALUE IN FRAME {&frame-name} = ""
              d-valid-lote:SENSITIVE IN FRAME {&frame-name} = NO. 

       CASE ord-prod.estado:
           WHEN 1 THEN 
               ASSIGN c-status:SCREEN-VALUE IN FRAME {&frame-name} = '¥ INI - '.
           WHEN 2 THEN
               ASSIGN c-status:SCREEN-VALUE IN FRAME {&frame-name} = 'LIB. - '.
           WHEN 3 THEN
               ASSIGN c-status:SCREEN-VALUE IN FRAME {&frame-name} = 'RES. - '.
           WHEN 4 THEN
               ASSIGN c-status:SCREEN-VALUE IN FRAME {&frame-name} = 'SEP. - '.
           WHEN 5 THEN
               ASSIGN c-status:SCREEN-VALUE IN FRAME {&frame-name} = 'REQ. - '.
           WHEN 6 THEN
               ASSIGN c-status:SCREEN-VALUE IN FRAME {&frame-name} = 'INI. - '.
           WHEN 7 THEN
               ASSIGN c-status:SCREEN-VALUE IN FRAME {&frame-name} = 'FIN. - '.
           WHEN 8 THEN
               ASSIGN c-status:SCREEN-VALUE IN FRAME {&frame-name} = 'TERM. - '.
       END CASE.

       ASSIGN c-status:SCREEN-VALUE IN FRAME {&frame-name} = c-status:SCREEN-VALUE IN FRAME {&frame-name} + " " + 
                                                             STRING(ord-prod.qt-produzida) + '/' + STRING(ord-prod.qt-ordem).
    END.
    ELSE
       ASSIGN c-it-codigo-tela:SENSITIVE IN FRAME {&frame-name} = YES
              c-lote:SENSITIVE IN FRAME {&frame-name} = YES
              /*d-valid-lote:SENSITIVE IN FRAME {&frame-name} = YES*/.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-entr wWindow
ON MOUSE-SELECT-DBLCLICK OF c-depos-entr IN FRAME fpage0 /* Dep«sito Entrada */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-depos-sai
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-sai wWindow
ON F5 OF c-depos-sai IN FRAME fpage0 /* Dep«sito Saðda */
DO:
    assign l-implanta = yes.
       
     {include/zoomvar.i
        &prog-zoom  = "inzoom/z01in084.w"
        &campo      = c-depos-sai
        &campo2     = c-desc-dep-sai
        &campozoom  = cod-depos
        &campozoom2 = nome
        &FRAME      =fpage0}
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-sai wWindow
ON LEAVE OF c-depos-sai IN FRAME fpage0 /* Dep«sito Saðda */
DO:
    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=c-desc-dep-sai
                     &where="deposito.cod-depos = input frame {&frame-name} 
                             c-depos-sai"}

    FOR FIRST deposito
        FIELDS (cod-depos log-gera-wms log-aloca-qtd-wms)
        WHERE deposito.cod-depos = c-depos-sai:SCREEN-VALUE IN FRAME {&frame-name} NO-LOCK: 
        IF deposito.log-gera-wms THEN
             ASSIGN c-local-sai:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                    c-local-sai:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
         ELSE 
             ASSIGN c-local-sai:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo-trans wWindow
ON VALUE-CHANGED  OF rs-tipo-trans IN FRAME fpage0 /* transacao */
DO:

    IF rs-tipo-trans:SCREEN-VALUE IN FRAME {&frame-name} = "1" THEN
        ASSIGN c-sc-codigo:SCREEN-VALUE IN FRAME {&frame-name} = ""
               c-desc-cc:SCREEN-VALUE IN FRAME {&frame-name}   = ""
               c-depos-entr:SENSITIVE IN FRAME {&frame-name}   = YES
               c-local-entr:SENSITIVE IN FRAME {&frame-name}   = YES
               c-refer-entr:SENSITIVE IN FRAME {&frame-name}   = YES
               c-sc-codigo:SENSITIVE IN FRAME {&frame-name}    = NO.
    ELSE DO:
        ASSIGN c-depos-entr:SCREEN-VALUE IN FRAME {&frame-name} = ""
               c-depos-entr:SCREEN-VALUE IN FRAME {&frame-name} = ""
               c-local-entr:SCREEN-VALUE IN FRAME {&frame-name} = ""
               c-local-entr:SCREEN-VALUE IN FRAME {&frame-name} = ""
               c-refer-entr:SCREEN-VALUE IN FRAME {&frame-name} = ""
               c-refer-entr:SCREEN-VALUE IN FRAME {&frame-name} = ""
               c-sc-codigo:SENSITIVE IN FRAME {&frame-name}     = NO
               c-depos-entr:SENSITIVE IN FRAME {&frame-name}    = NO
               c-local-entr:SENSITIVE IN FRAME {&frame-name}    = NO
               c-refer-entr:SENSITIVE IN FRAME {&frame-name}    = NO.
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-sai wWindow
ON MOUSE-SELECT-DBLCLICK OF c-depos-sai IN FRAME fpage0 /* Dep«sito Saðda */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-hora
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hora wWindow
ON MOUSE-SELECT-DBLCLICK OF c-hora IN FRAME fpage0 /* Hora Entrada */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-it-codigo-tela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo-tela wWindow
ON F5 OF c-it-codigo-tela IN FRAME fpage0 /* Item */
DO:
   
   {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                    &campo=c-it-codigo-tela
                    &campo2=c-desc-item
                    &campozoom=it-codigo
                    &campozoom2=desc-item
                    &FRAME=fpage0}  
                                    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo-tela wWindow
ON MOUSE-SELECT-DBLCLICK OF c-it-codigo-tela IN FRAME fpage0 /* Item */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-lote wWindow
ON LEAVE OF c-lote IN FRAME fpage0 /* Dep«sito Saðda */
DO:
    FIND FIRST saldo-estoq NO-LOCK
         WHERE saldo-estoq.cod-estabel = INPUT FRAME {&FRAME-NAME} c-cod-estabel
           AND saldo-estoq.lote = INPUT FRAME {&FRAME-NAME} c-lote NO-ERROR.
    IF AVAIL saldo-estoq THEN
        ASSIGN d-valid-lote:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(saldo-estoq.dt-vali-lote).
    ELSE
        ASSIGN d-valid-lote:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-lote wWindow
ON F5 OF c-lote IN FRAME fpage0 /* Lote */
DO:

    {include/zoomvar.i &prog-zoom="inzoom/z03in403.w"
                       &campo=c-lote
                       &campo2=c-depos-sai
                       &campo3=d-valid-lote
                       &campo4=c-local-sai
                       &campo5=c-refer-sai
                       &campozoom=lote
                       &campozoom2=cod-depos
                       &campozoom3=dt-vali-lote
                       &campozoom4=cod-localiz
                       &campozoom5=cod-refer}
    
    /*{include/zoomvar.i &prog-zoom="eszoom/z03esin403.w"
                       &campo=c-lote
                       &campo2=c-depos-sai
                       &campo3=d-valid-lote
                       &campo4=c-local-sai
                       &campo5=c-refer-sai
                       &campo6=c-it-codigo-tela
                       &campo7=c-cod-estabel
                       &campozoom=lote
                       &campozoom2=cod-depos
                       &campozoom3=dt-vali-lote
                       &campozoom4=cod-localiz
                       &campozoom5=cod-refer
                       &campozoom6=it-codigo
                       &campozoom7=cod-estabel
                       &parametros="run pi-seta-inicial in wh-pesquisa (input frame {&frame-name} c-it-codigo-tela, input frame {&frame-name} c-it-codigo-tela )."}*/
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-lote wWindow
ON MOUSE-SELECT-DBLCLICK OF c-lote IN FRAME fpage0 /* Lote */
DO:
    Apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME i-ord-produ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-produ wWindow
ON F5 OF i-ord-produ IN FRAME fpage0 /* Ordem Produ¯Êo */
DO:
  assign i-ep-codigo-usuario = i-empresa.

  {include/zoomvar.i &prog-zoom="inzoom/z01in271.w"
                     &campo=i-ord-produ
                     &campozoom=nr-ord-produ}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-produ wWindow
ON MOUSE-SELECT-DBLCLICK OF i-ord-produ IN FRAME fpage0 /* Ordem Produ¯Êo */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 

/*:T--- L«gica para inicializa¯Êo do programam ---*/
{window/mainblock.i}

  if c-cod-estabel:load-mouse-pointer  ("image/lupa.cur" ) in frame {&frame-name} then.
  if c-depos-entr:load-mouse-pointer   ("image/lupa.cur" ) in frame {&frame-name} then.
  if c-depos-sai:load-mouse-pointer    ("image/lupa.cur" ) in frame {&frame-name} then.
  if c-it-codigo-tela:load-mouse-pointer    ("image/lupa.cur")  in frame {&frame-name} then.  
  if i-ord-produ:load-mouse-pointer    ("image/lupa.cur")  in frame {&frame-name} then.
  if c-lote:load-mouse-pointer         ("image/lupa.cur")  in frame {&frame-name} then.
  if c-ct-codigo:load-mouse-pointer    ("image/lupa.cur" ) in frame {&frame-name} then.
  if c-sc-codigo:load-mouse-pointer    ("image/lupa.cur" ) in frame {&frame-name} then.

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
    /*--- valida senha do usu¨rio logado no sistema ---*/
    run btb/btb910zz.p (input c-seg-usuario, input no).

    /*--- caso a senha n’o seja informada corretamente 
          o programa sera finalizado ---*/
    if  return-value = "NOK":U then 
        return "NOK":U.

    ASSIGN c-desc-est:SENSITIVE IN FRAME fpage0       = NO
           c-desc-dep-entr:SENSITIVE IN FRAME fpage0  = NO
           c-desc-dep-sai:SENSITIVE IN FRAME fpage0 = NO
           c-responsavel:SENSITIVE IN FRAME fpage0    = NO
           c-desc-item:SENSITIVE IN FRAME fpage0      = NO
           c-desc-conta:SENSITIVE IN FRAME fpage0     = NO
           c-desc-cc:SENSITIVE IN FRAME fpage0        = NO
           c-responsavel:SCREEN-VALUE IN FRAME fpage0 = c-seg-usuario
           c-ct-codigo:SENSITIVE IN FRAME fpage0      = NO.
    
    FIND first usuar-mater where usuar-mater.cod-usuario = c-seg-usuario NO-LOCK NO-ERROR.
    if not avail usuar-mater then do:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 56,
                           INPUT "Usu rio de Materiais").
    
        UNDO, RETURN "NOK":U.
    end.
    
    FIND FIRST in-wm-param NO-LOCK NO-ERROR.
    FIND FIRST param-compra NO-LOCK NO-ERROR.
    
      if l-primeira then do:
         RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
         assign l-primeira = no.
      end.
    
      ASSIGN c-sc-codigo:SCREEN-VALUE IN FRAME {&frame-name} = ""
             c-desc-cc:SCREEN-VALUE IN FRAME {&frame-name}   = ""
             c-depos-entr:SENSITIVE IN FRAME {&frame-name}   = YES
             c-local-entr:SENSITIVE IN FRAME {&frame-name}   = YES
             c-refer-entr:SENSITIVE IN FRAME {&frame-name}   = YES
             c-sc-codigo:SENSITIVE IN FRAME {&frame-name}    = NO.

  /* Code placed here will execute AFTER standard behavior.    */
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    RUN initializeDBOs.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 /*:T--- Verifica se o DBO j˜ est˜ inicializado ---*/
   
    IF NOT VALID-HANDLE(h_api_ccusto) THEN DO:
        RUN prgint/utb/utb742za.py PERSISTEN SET h_api_ccusto.
    END.  

    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
    END.

    RUN prgint\utb\utb743za.py PERSISTENT SET h_api_cta.
    RUN prgint\utb\utb742za.py PERSISTENT SET h_api_ccust.

    ASSIGN rs-tipo-trans:SCREEN-VALUE IN FRAME fPage0 = "1".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-CarregaMovto wWindow 
PROCEDURE pi-CarregaMovto :
/*------------------------------------------------------------------------------
  Purpose: Carrega o Browse de Notas Fiscais de entrada    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        {utp/ut-liter.i Leitura_Dos_Movimentos *}
    RUN pi-inicializar IN h-acomp(RETURN-VALUE).
    
    RUN pi-desabilita-cancela IN h-acomp.

    FOR FIRST b-deposito
        FIELDS ( cod-depos log-gera-wms log-aloca-qtd-wms )
        WHERE b-deposito.cod-depos = c-depos-entr NO-LOCK: 
    END.
    FOR FIRST deposito
        FIELDS ( cod-depos log-gera-wms log-aloca-qtd-wms )
        WHERE deposito.cod-depos = c-depos-sai NO-LOCK: 
    END.

    ASSIGN l-item-ckd = NO.

    IF i-ord-produ = 0 THEN DO:
        IF (deposito.log-gera-wms OR b-deposito.log-gera-wms) THEN DO:
            IF  deposito.log-gera-wms THEN DO:
               FIND FIRST wm-etiqueta 
                    WHERE (wm-etiqueta.cod-item           = c-it-codigo-tela OR wm-etiqueta.cod-item <> '')
                      AND wm-etiqueta.cod-estabel        = c-cod-estabel
                      AND wm-etiqueta.cod-lote           = c-lote
                      AND wm-etiqueta.cod-refer          = c-refer-sai
                      /*AND wm-etiqueta.dt-validade-lote   = d-valid-lote */
                      AND wm-etiqueta.ind-sit-agrupador  = 2 NO-LOCK NO-ERROR.
            END.
            ELSE DO:
                FIND FIRST wm-etiqueta 
                     WHERE (wm-etiqueta.cod-item           = c-it-codigo-tela OR wm-etiqueta.cod-item <> '')
                       AND wm-etiqueta.cod-estabel        = c-cod-estabel
                       AND wm-etiqueta.cod-lote           = c-lote
                       AND wm-etiqueta.cod-refer          = c-refer-entr
                       /*AND wm-etiqueta.dt-validade-lote   = d-valid-lote */
                       AND wm-etiqueta.ind-sit-agrupador  = 2 NO-LOCK NO-ERROR.
            END.

            IF AVAIL wm-etiqueta AND 
               CAN-FIND(FIRST in-agrup-etiqueta  NO-LOCK
                        WHERE in-agrup-etiqueta.id-etiqueta-pai = wm-etiqueta.id-etiqueta) THEN
                ASSIGN l-item-ckd = YES.
            ELSE 
                ASSIGN l-item-ckd = NO.
        END.

        /*Verifica se o item ou lote informado ‚ de um item filho CKD*/
        IF c-it-codigo-tela = "" THEN DO:
            FIND FIRST saldo-estoq NO-LOCK
                 WHERE saldo-estoq.lote = c-lote NO-ERROR.
    
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = saldo-estoq.it-codigo NO-ERROR.
        END.
        ELSE
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = c-it-codigo-tela NO-ERROR.
        
        FIND FIRST in-grup-estoq WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-LOCK NO-ERROR.
        IF AVAIL in-grup-estoq THEN
            ASSIGN l-ckd = in-grup-estoq.log-ckd.
        ELSE
            ASSIGN l-ckd = NO.
        /**/

        IF l-ckd THEN DO:
           EMPTY TEMP-TABLE tt-item-mov.
           RUN pi-carrega-item-ckd.
        END.
        ELSE DO:
           IF CAN-FIND (FIRST estrutura no-lock
                        WHERE estrutura.it-codigo = c-it-codigo-tela) and
               l-consid-estrutura THEN DO:
               EMPTY TEMP-TABLE tt-item-mov.
               RUN pi-carrega-item-estrutura (INPUT c-it-codigo-tela,
                                              INPUT 1).
           END.
           ELSE DO:
               
               RUN pi-cria-tt-item-mov(INPUT ITEM.it-codigo,
                                       INPUT d-qtd-item,
                                       INPUT YES).
           END.
        END.
    END.
    ELSE DO: 
        FIND FIRST reservas WHERE reservas.nr-ord-produ = i-ord-produ NO-LOCK NO-ERROR.
        IF NOT AVAIL reservas THEN DO:
           MESSAGE "Ordem de Produ‡Æo nÆo possui reservas!"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           RUN pi-finalizar IN h-acomp.
           RETURN "NOK":U.
        END.
        EMPTY TEMP-TABLE tt-item-mov.    
       RUN pi-carrega-item-ordem.
    END.

    /*{&OPEN-QUERY-brTable1}*/
        
    RUN pi-finalizar IN h-acomp.   
   
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn_sit_item wWindow 
FUNCTION fn_sit_item RETURNS CHARACTER
  ( p-idi-situacao AS INT ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna a situa¯Êo do documento 
    Notes:  
------------------------------------------------------------------------------*/

    CASE p-idi-situacao:
        WHEN 1 THEN c-sit-item = "Pendente".
        WHEN 2 THEN c-sit-item = "Erro".
        WHEN 3 THEN c-sit-item = "Gerado".
        WHEN 4 THEN c-sit-item = "Confirmado".
    END CASE.

    RETURN c-sit-item.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-item-estrutura wWindow 
PROCEDURE pi-carrega-item-estrutura:

    DEF INPUT PARAM p-it-codigo LIKE ITEM.it-codigo NO-UNDO.
    DEF INPUT PARAM p-nivel AS INT NO-UNDO.

    FIND ITEM NO-LOCK 
        WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

    EMPTY TEMP-TABLE tt-estrutura.

    RUN esapi/esapi006.p ( INPUT ROWID(ITEM),    /* Rowid */
                           INPUT "",             /* Refer */
                           INPUT 1,              /* Quantidade */
                           INPUT 0,              /* Quantidade Liq */
                           INPUT 0,              /* N¡vel */
                           INPUT-OUTPUT TABLE tt-estrutura,
                           INPUT TODAY,          /* Data Corte */
                           INPUT YES,            /* Recursivo */
                           INPUT 19,             /* N¡veis */
                           INPUT c-cod-estabel). /* Estabel */

    FOR EACH tt-estrutura NO-LOCK:
        IF tt-estrutura.log-fantasma THEN NEXT.

        RUN pi-cria-tt-item-mov(INPUT tt-estrutura.es-codigo,
                                INPUT tt-estrutura.quant-usada * d-qtd-item,
                                INPUT NO).

    END.

/* ** estrutura antiga
    
    /*S¢ ir  imprimir no grid itens que no primeiro n¡vel sejam do TIPO C, os demais devem abrir a estrutura. E no segundo n¡vel imprimir os itens do tipo F e C.*/
    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo = p-it-codigo:

        IF not(estrutura.data-inicio  <= TODAY and
               estrutura.data-termino > TODAY) THEN NEXT.

        IF p-nivel = 2 AND estrutura.fantasma THEN NEXT.
        
        FIND FIRST item WHERE item.it-codigo = estrutura.es-codigo NO-LOCK NO-ERROR.

        IF p-nivel = 1 AND
           item.compr-fabric = 2 /*Fabricado*/ THEN DO:
            RUN pi-carrega-item-estrutura(INPUT estrutura.es-codigo,
                                          INPUT 2).
        END.
        ELSE
            RUN pi-cria-tt-item-mov(INPUT estrutura.es-codigo,
                                    INPUT estrutura.qtd-compon * d-qtd-item,
                                    INPUT NO).
    END.
    */

    RETURN "OK":U.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-item-ordem wWindow 
PROCEDURE pi-carrega-item-ordem:
    DEF VAR p-qtd-disp-saida AS DEC NO-UNDO. 
    DEF VAR p-qtd-saldo-saida AS DEC NO-UNDO.
    DEF VAR p-qtd-disp-entrada AS DEC NO-UNDO. 
    DEF VAR p-qtd-saldo-entrada AS DEC NO-UNDO.
    DEF VAR i-seq AS INT NO-UNDO.

    DEF VAR qtd-atual            AS DEC NO-UNDO.
    DEF VAR l-lote-venc          AS LOG NO-UNDO.

    ASSIGN i-seq = 0.
    FOR EACH reservas NO-LOCK
        WHERE reservas.nr-ord-produ = i-ord-produ:

        FIND FIRST ITEM WHERE ITEM.it-codigo = reservas.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN DO:
            FIND FIRST in-grup-estoq WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-LOCK NO-ERROR.
            IF AVAIL in-grup-estoq THEN
                ASSIGN l-ckd = in-grup-estoq.log-ckd.
            ELSE
                ASSIGN l-ckd = NO.

        END.
        assign p-qtd-disp-entrada = 0
               p-qtd-saldo-entrada  = 0.

        
        for each saldo-estoq FIELDS (cod-estabel cod-depos lote it-codigo
                                     qtidade-atu dt-vali-lote dt-ul-contag
                                     cod-refer qt-aloc-prod qt-alocada qt-aloc-ped
                                     cod-localiz) where
                 saldo-estoq.it-codigo   = reservas.it-codigo AND 
                 saldo-estoq.cod-estabel = c-cod-estabel      AND 
                 /*saldo-estoq.cod-local   = c-local-entr       AND*/
                 saldo-estoq.cod-refer   = c-refer-entr       AND
                 saldo-estoq.cod-depos   = c-depos-entr  no-lock:

            assign p-qtd-disp-entrada  = p-qtd-disp-entrada + (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada - 
                                         saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped)
                   p-qtd-saldo-entrada = p-qtd-saldo-entrada  + saldo-estoq.qtidade-atu.

        END.

        

        assign p-qtd-disp-saida  = 0
               p-qtd-saldo-saida = 0
               l-lote-venc       = NO.

        for each saldo-estoq FIELDS (cod-estabel cod-depos lote it-codigo
                                     qtidade-atu dt-vali-lote dt-ul-contag
                                     cod-refer qt-aloc-prod qt-alocada qt-aloc-ped
                                     cod-localiz) where
                 saldo-estoq.it-codigo   = reservas.it-codigo AND 
                 saldo-estoq.cod-estabel = c-cod-estabel      AND 
                 saldo-estoq.cod-local   = c-local-sai        AND
                 saldo-estoq.cod-refer   = c-refer-sai        AND
                 saldo-estoq.cod-depos   = c-depos-sai  no-lock:

            assign p-qtd-disp-saida  = p-qtd-disp-saida + (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada - 
                                       saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped)
                   p-qtd-saldo-saida = p-qtd-saldo-saida  + saldo-estoq.qtidade-atu.

            IF saldo-estoq.dt-vali-lote < TODAY AND saldo-estoq.cod-depos = 'WAL' THEN
               ASSIGN l-lote-venc = YES.

        END.

        ASSIGN d-quantidade-mult = 0.

        IF deposito.log-gera-wms THEN DO:
            FIND FIRST wm-item-embalagem-local 
                 WHERE wm-item-embalagem-local.cod-estabel = c-cod-estabel
                   AND wm-item-embalagem-local.cod-item    = reservas.it-codigo
                   AND wm-item-embalagem-local.cod-local   = c-depos-sai NO-LOCK NO-ERROR.
            IF AVAIL wm-item-embalagem-local  THEN DO:
                
               /*IF wm-item-embalagem-local.log-abre-emb-item = NO 
               AND wm-item-embalagem-local.qtd-emb-item <> 0 THEN DO:*/
               IF wm-item-embalagem-local.qtd-emb-item <> 0 THEN DO:                 
                  ASSIGN d-quantidade-mult = d-qtd-item / wm-item-embalagem-local.qtd-emb-item. 
    
                  IF d-quantidade-mult <> TRUNC(d-quantidade-mult,0) THEN DO:
                      ASSIGN d-quantidade-mult = (TRUNC(d-quantidade-mult,0) + 1) * wm-item-embalagem-local.qtd-emb-item.
                  END.
                  ELSE IF d-quantidade-mult = TRUNC(d-quantidade-mult,0) THEN DO:
				          ASSIGN d-quantidade-mult = (TRUNC(d-quantidade-mult,0)) * wm-item-embalagem-local.qtd-emb-item.
                  END.
               END.
            END.

            /*
            RUN wmp/wm9055.p (INPUT c-cod-estabel,
                              INPUT c-depos-sai,
                              INPUT 0,
                              INPUT 0,
                              INPUT c-it-codigo-tela,
                              INPUT c-refer-sai,
                              INPUT c-lote,
                              OUTPUT TABLE tt-saldo-aloc,
                              OUTPUT TABLE RowErrors).
                             
            ASSIGN de-qtd-disponivel = 0.
            FOR EACH tt-saldo-aloc:
                ASSIGN de-qtd-disponivel = de-qtd-disponivel + (tt-saldo-aloc.qtd-box - tt-saldo-aloc.qtd-alocada).
            END.

            ASSIGN p-qtd-disp-saida = de-qtd-disponivel +  p-qtd-saldo-saida.*/

            ASSIGN de-qtd-disponivel = 0.
            IF c-lote <> "" THEN DO:
                
                IF NOT VALID-HANDLE(hBOsc035) THEN
                    RUN scbo/bosc035.p PERSISTENT SET hBOsc035.
           
               RUN getOcupacaoItem IN hBOsc035 (INPUT c-cod-estabel,
                                                INPUT c-depos-sai,
                                                INPUT 0,
                                                INPUT reservas.it-codigo,
                                                INPUT c-refer-sai,
                                                INPUT c-lote,
                                                OUTPUT qtd-atual,
                                                OUTPUT TABLE ttResumoItem).
           
                IF VALID-HANDLE(hBOsc035) THEN
                    DELETE PROCEDURE hBOsc035.
           
                ASSIGN de-qtd-disponivel = 0.
                FOR EACH ttResumoItem:
                    ASSIGN de-qtd-disponivel = de-qtd-disponivel + ttResumoItem.qtd-item-liberado.
                END.
           
                FOR EACH wm-aloca-saldo NO-LOCK
                   WHERE wm-aloca-saldo.cod-estabel = c-cod-estabel
                     AND wm-aloca-saldo.cod-local   = c-depos-sai
                     AND wm-aloca-saldo.cod-item    = reservas.it-codigo
                     AND wm-aloca-saldo.cod-lote    = c-lote:
                    ASSIGN de-qtd-disponivel = de-qtd-disponivel - wm-aloca-saldo.qtd-item.
                END.
           
                IF de-qtd-disponivel < 0 THEN
                    ASSIGN de-qtd-disponivel = 0.
            END.
            ELSE DO:
                IF NOT VALID-HANDLE(hDBOWm-saldo-estoque) THEN
                    RUN scbo/bosc058.p PERSISTENT SET hDBOWm-saldo-estoque.
           
                RUN getSaldoPicking IN hDBOWm-saldo-estoque (INPUT reservas.it-codigo,
                                                             INPUT 0,
                                                             INPUT 0,
                                                             OUTPUT TABLE ttWm-saldo).
           
                IF VALID-HANDLE(hDBOWm-saldo-estoque) THEN
                    DELETE PROCEDURE hDBOWm-saldo-estoque.
           
                
                ASSIGN l-lote-venc = NO.
           
                FOR EACH ttWm-saldo NO-LOCK
                   WHERE ttWm-saldo.cod-estabel = c-cod-estabel
                     AND ttWm-saldo.cod-local   = c-depos-sai:

                    
                    FOR EACH wm-saldo-estoque WHERE
                             wm-saldo-estoque.cod-item    = reservas.it-codigo         AND
                             wm-saldo-estoque.cod-estabel = ttWm-saldo.cod-estabel AND
                             wm-saldo-estoque.cod-local   = ttWm-saldo.cod-local
                             NO-LOCK.
                        
                        IF wm-saldo-estoque.qtd-liberada <> 0 AND
                           wm-saldo-estoque.qtd-atual    <> 0 AND
                           wm-saldo-estoque.dt-validade-lote < TODAY  AND 
                           ttWm-saldo.cod-local = 'WAL'
                        THEN ASSIGN l-lote-venc = YES. 
           
                    END.
                    
           
                    ASSIGN /*qtd-atual     = qtd-atual     + ttWm-saldo.qtd-atual*/
                           de-qtd-disponivel  = de-qtd-disponivel  + ttWm-saldo.qtd-liberada.
                END.
           
                FOR EACH wm-aloca-saldo NO-LOCK
                   WHERE wm-aloca-saldo.cod-estabel = c-cod-estabel
                     AND wm-aloca-saldo.cod-local   = c-depos-sai
                     AND wm-aloca-saldo.cod-item    = reservas.it-codigo:
                    ASSIGN de-qtd-disponivel = de-qtd-disponivel - wm-aloca-saldo.qtd-item.
                END.
            END.
           
            IF de-qtd-disponivel < 0 THEN
                ASSIGN de-qtd-disponivel = 0.
           
            ASSIGN p-qtd-disp-saida = de-qtd-disponivel.
    
        END.

        ASSIGN i-seq = i-seq + 1.

        CREATE tt-item-mov.
        ASSIGN tt-item-mov.nr-seq      = i-seq
               tt-item-mov.it-codigo   = reservas.it-codigo
               tt-item-mov.qtd-saida   = p-qtd-disp-saida   
               tt-item-mov.qtd-entrada = p-qtd-disp-entrada 
               tt-item-mov.quantidade  = IF d-quantidade-mult = 0 THEN (reservas.quant-orig - reservas.quant-atend) * d-qtd-item ELSE d-quantidade-mult
               tt-item-mov.desc-item   = ITEM.desc-item
               tt-item-mov.nr-cor      = 1 /*transparente*/
               tt-item-mov.altera      = YES.

        /*IF tt-item-mov.quantidade < tt-item-mov.qtd-entrada THEN DO:
            ASSIGN tt-item-mov.mensagem = "Quantidade alterada de " + trim(string(tt-item-mov.quantidade)) + 
                                 " para 0 visto que o requisitante jÿ possui saldo de " + 
                                  trim(string(tt-item-mov.qtd-entrada)) + " para o item".
            ASSIGN /*tt-item-mov.quantidade = 0*/
                   tt-item-mov.nr-cor = 3 /*"Amarelo"*/
                   tt-item-mov.altera = YES.

        END.*/
        
        IF d-quantidade-mult <> 0 AND d-quantidade-mult < (reservas.quant-orig - reservas.quant-atend) * d-qtd-item THEN DO:
            DO WHILE tt-item-mov.quantidade < (reservas.quant-orig - reservas.quant-atend) * d-qtd-item:
               ASSIGN tt-item-mov.quantidade = tt-item-mov.quantidade + d-quantidade-mult. 
            END.
        END.

        IF d-quantidade-mult <> 0 
        AND d-quantidade-mult <> ((reservas.quant-orig - reservas.quant-atend) * d-qtd-item) AND AVAIL wm-item-embalagem-local THEN DO:
            ASSIGN tt-item-mov.mensagem = "Quantidade ajustada de " + trim(string((reservas.quant-orig - reservas.quant-atend) * d-qtd-item)) + " para " +
                                          trim(string(tt-item-mov.quantidade)) + " devido a quantidade do item da embalagem ser de " + 
                                          trim(string(wm-item-embalagem-local.qtd-emb-item)). 
            ASSIGN tt-item-mov.nr-cor     = 3 /*"Amarelo"*/
                   tt-item-mov.altera     = YES.

            RELEASE wm-item-embalagem-local.
        END.


        IF tt-item-mov.quantidade > tt-item-mov.qtd-saida + tt-item-mov.qtd-entrada THEN DO:
            ASSIGN tt-item-mov.mensagem = "Saldo de " + trim(string(tt-item-mov.qtd-saida + tt-item-mov.qtd-entrada )) + " no dep¢sito de sa¡da ² insuficiente".             
            ASSIGN /*tt-item-mov.quantidade = 0*/
                   tt-item-mov.nr-cor = 2 /*"Vermelho"*/
                   tt-item-mov.altera = YES.
        END.  

        IF l-lote-venc = YES THEN
           ASSIGN tt-item-mov.mensagem = "Lote vencido"
                  tt-item-mov.nr-cor   = 2 /*"Vermelho"*/.


        /* verificar
        
        IF saldo-estoq.dt-vali-lote < TODAY THEN DO:

           ASSIGN tt-item-mov.mensagem = "Lote vencido"
                  tt-item-mov.nr-cor   = 2 /*"Vermelho"*/.
        END.*/
    END.
    
    RETURN "OK":U.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-item-ckd wWindow 
PROCEDURE pi-carrega-item-ckd:
    DEF VAR p-qtd-disp-saida     AS DEC NO-UNDO. 
    DEF VAR p-qtd-saldo-saida    AS DEC NO-UNDO.
    DEF VAR p-qtd-disp-entrada   AS DEC NO-UNDO. 
    DEF VAR p-qtd-saldo-entrada  AS DEC NO-UNDO.
    

    for each saldo-estoq FIELDS (cod-estabel cod-depos lote it-codigo
                                 qtidade-atu dt-vali-lote dt-ul-contag
                                 cod-refer qt-aloc-prod qt-alocada qt-aloc-ped
                                 cod-localiz) 
        WHERE (saldo-estoq.it-codigo   = c-it-codigo-tela OR c-it-codigo-tela = "") AND
               saldo-estoq.cod-estabel = c-cod-estabel         AND 
               saldo-estoq.cod-depos   = c-depos-sai           AND
               saldo-estoq.cod-local   = c-local-sai           AND
               saldo-estoq.cod-refer   = c-refer-sai           AND
              (saldo-estoq.lote        = c-lote OR c-lote = "") no-lock,
        FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = saldo-estoq.it-codigo:

        assign p-qtd-disp-saida = 0
               p-qtd-saldo-saida  = 0.

        assign p-qtd-disp-saida  = p-qtd-disp-saida + (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada - 
                                     saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped)
               p-qtd-saldo-saida = p-qtd-saldo-saida  + saldo-estoq.qtidade-atu.


        assign p-qtd-disp-entrada = 0
               p-qtd-saldo-entrada  = 0.
    
        for each bsaldo-estoq FIELDS (cod-estabel cod-depos lote it-codigo
                                     qtidade-atu dt-vali-lote dt-ul-contag
                                     cod-refer qt-aloc-prod qt-alocada qt-aloc-ped
                                     cod-localiz) 
            where bsaldo-estoq.it-codigo   = saldo-estoq.it-codigo   AND 
                  bsaldo-estoq.cod-estabel = saldo-estoq.cod-estabel AND 
                 /* bsaldo-estoq.cod-local   = c-local-entr            AND*/
                  bsaldo-estoq.cod-refer   = c-refer-entr            AND
                  bsaldo-estoq.cod-depos   = c-depos-entr            AND
                  bsaldo-estoq.lote        = saldo-estoq.lote  no-lock:
    
            assign p-qtd-disp-entrada  = p-qtd-disp-entrada + (bsaldo-estoq.qtidade-atu  - bsaldo-estoq.qt-alocada - 
                                       bsaldo-estoq.qt-aloc-prod - bsaldo-estoq.qt-aloc-ped)
                   p-qtd-saldo-entrada = p-qtd-saldo-entrada  + bsaldo-estoq.qtidade-atu.
    
        END.

        /*ASSIGN d-quantidade-mult = 0.

        FIND FIRST wm-item-embalagem-local 
             WHERE wm-item-embalagem-local.cod-estabel = saldo-estoq.cod-estabel
               AND wm-item-embalagem-local.cod-item    = saldo-estoq.it-codigo
               AND wm-item-embalagem-local.cod-local   = c-depos-sai NO-LOCK NO-ERROR.
        IF AVAIL wm-item-embalagem-local  THEN DO:
            
           /*IF wm-item-embalagem-local.log-abre-emb-item = NO 
           AND wm-item-embalagem-local.qtd-emb-item <> 0 THEN DO:*/
           IF wm-item-embalagem-local.qtd-emb-item <> 0 THEN DO:
                                           
              ASSIGN d-quantidade-mult = p-qtd-disp-entrada / wm-item-embalagem-local.qtd-emb-item. 
    
              IF d-quantidade-mult > TRUNC(d-quantidade-mult,0) THEN DO:
                ASSIGN d-quantidade-mult = (TRUNC(d-quantidade-mult,0) + 1) * wm-item-embalagem-local.qtd-emb-item.
              END.
              ELSE IF d-quantidade-mult = TRUNC(d-quantidade-mult,0) THEN DO:
                ASSIGN d-quantidade-mult = (TRUNC(d-quantidade-mult,0)) * wm-item-embalagem-local.qtd-emb-item.
              END.
    
           END.
        END.*/
    
        IF deposito.log-gera-wms THEN DO:
            
            /*FIND FIRST wm-item-embalagem-local 
                 WHERE wm-item-embalagem-local.cod-estabel = saldo-estoq.cod-estabel
                   AND wm-item-embalagem-local.cod-item    = saldo-estoq.it-codigo
                   AND wm-item-embalagem-local.cod-local   = c-depos-sai NO-LOCK NO-ERROR.
            IF AVAIL wm-item-embalagem-local  THEN DO:
                
               /*IF wm-item-embalagem-local.log-abre-emb-item = NO 
               AND wm-item-embalagem-local.qtd-emb-item <> 0 THEN DO:*/
               IF wm-item-embalagem-local.qtd-emb-item <> 0 THEN DO:                  
                  ASSIGN d-quantidade-mult = (1 * d-qtd-item) / wm-item-embalagem-local.qtd-emb-item. 
    
                  IF d-quantidade-mult <> TRUNC(d-quantidade-mult,0) THEN
                      ASSIGN d-quantidade-mult = (TRUNC(d-quantidade-mult,0) + 1) * wm-item-embalagem-local.qtd-emb-item.
    
               END.
            END.*/
            
            RUN wmp/wm9055.p (INPUT saldo-estoq.cod-estabel,
                              INPUT c-depos-sai,
                              INPUT 0,
                              INPUT 0,
                              INPUT saldo-estoq.it-codigo,
                              INPUT c-refer-sai,
                              INPUT saldo-estoq.lote,
                              OUTPUT TABLE tt-saldo-aloc,
                              OUTPUT TABLE RowErrors).
            ASSIGN de-qtd-disponivel = 0.
            FOR EACH tt-saldo-aloc:
                ASSIGN de-qtd-disponivel = de-qtd-disponivel + (tt-saldo-aloc.qtd-box - tt-saldo-aloc.qtd-alocada).
            END.
    
            ASSIGN p-qtd-disp-saida = de-qtd-disponivel.
    
        END.
    
        FIND LAST b-tt-item-mov NO-LOCK NO-ERROR.
    
        CREATE tt-item-mov.
        ASSIGN tt-item-mov.nr-seq      = IF AVAIL b-tt-item-mov THEN b-tt-item-mov.nr-seq + 1 ELSE 1
               tt-item-mov.it-codigo   = saldo-estoq.it-codigo
               tt-item-mov.lote        = saldo-estoq.lote
               tt-item-mov.qtd-saida   = p-qtd-disp-saida 
               tt-item-mov.qtd-entrada = p-qtd-disp-entrada
               tt-item-mov.quantidade  = p-qtd-disp-saida /*IF d-quantidade-mult = 0 THEN (p-qtd-disp-entrada * d-qtd-item) ELSE d-quantidade-mult*/
               tt-item-mov.desc-item   = ITEM.desc-item
               tt-item-mov.nr-cor      = 1 /*transparente*/
               tt-item-mov.altera      = YES.
    
        /*IF d-quantidade-mult <> 0 
        AND d-quantidade-mult <> p-qtd-disp-entrada THEN DO:
            ASSIGN tt-item-mov.mensagem = "Quantidade ajustada de " + trim(string(p-qtd-disp-entrada)) + " para " +
                                          trim(string(tt-item-mov.quantidade)) + " devido a quantidade do item da embalagem ser de " + 
                                          trim(string(wm-item-embalagem-local.qtd-emb-item)). 
            ASSIGN tt-item-mov.nr-cor     = 3 /*"Amarelo"*/
                   tt-item-mov.altera     = YES.
        END.*/
    
        /*IF tt-item-mov.quantidade < tt-item-mov.qtd-entrada THEN DO:
            ASSIGN tt-item-mov.mensagem = "Quantidade alterada de " + trim(string(tt-item-mov.quantidade)) + 
                                 " para 0 visto que o requisitante j  possui saldo de " + 
                                  trim(string(tt-item-mov.qtd-entrada)) + " para o item".
            ASSIGN tt-item-mov.quantidade = 0
                   tt-item-mov.nr-cor     = 3 /*"Amarelo"*/
                   tt-item-mov.altera     = YES.
    
        END.*/
    
        IF tt-item-mov.qtd-saida < tt-item-mov.quantidade THEN DO:
            ASSIGN tt-item-mov.mensagem = "Saldo de " + trim(string(tt-item-mov.qtd-saida)) + " no dep¢sito de sa¡da ² insuficiente".             
            ASSIGN /*tt-item-mov.quantidade = 0*/
                   tt-item-mov.nr-cor     = 2 /*"Vermelho"*/
                   tt-item-mov.altera     = YES.
        END.

        IF saldo-estoq.dt-vali-lote < TODAY THEN DO:

           ASSIGN tt-item-mov.mensagem = "Lote vencido"
                  tt-item-mov.nr-cor   = 2 /*"Vermelho"*/.
        END.

    END.

    RETURN "OK":U.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-transferir wWindow 
PROCEDURE pi-transferir:

    DEF OUTPUT PARAM p-nr-docto AS INTEGER NO-UNDO.

    DEFINE VARIABLE i-seq-erro               AS INTEGER                            NO-UNDO.
    DEFINE VARIABLE i-nr-docto               AS INTEGER                            NO-UNDO.
    DEFINE VARIABLE c-aux                    AS CHARACTER FORMAT "x(25)"           NO-UNDO.
    DEFINE VARIABLE d-qtd-movto              LIKE item-docto-transf-depos.qtd-item NO-UNDO.
    DEFINE VARIABLE c-cod-local              LIKE wm-docto.cod-local               NO-UNDO.
    DEFINE VARIABLE i-seq-wm                 AS INTEGER                            NO-UNDO.
    DEFINE VARIABLE i-seq-req                AS INTEGER                            NO-UNDO.

    DEFINE BUFFER b-item-docto-transf-depos  FOR item-docto-transf-depos.

    DEFINE VARIABLE l-lote-branco            AS LOGICAL                            NO-UNDO.
    DEFINE VARIABLE i-id-docto               AS INTEGER                            NO-UNDO.
    DEFINE VARIABLE h-ceapi001k              AS HANDLE                             NO-UNDO.
    DEFINE VARIABLE c-msg                    AS CHAR                               NO-UNDO.
    DEFINE VARIABLE l-primeiro               AS LOG                                NO-UNDO.

    DEFINE VARIABLE i-qtde AS INTEGER     NO-UNDO.
    
    EMPTY TEMP-TABLE tt-movto.
    EMPTY TEMP-TABLE ttWm-docto.
    EMPTY TEMP-TABLE ttWm-docto-itens.

    IF  l-item-ckd
    AND NOT in-wm-param.log-separa-ckd THEN
        IF CAN-FIND(FIRST tt-item-mov 
                    WHERE NOT tt-item-mov.selec) THEN DO:
             MESSAGE "Item CKD nÆo permite transferˆncia parcial!"
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
             RETURN "NOK":U.
        END.

    IF NOT CAN-FIND(FIRST tt-item-mov 
                WHERE tt-item-mov.selec) THEN DO:
         MESSAGE "Nennhum Item foi selecionado para tranferˆncia!"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN "NOK":U.
    END.

    IF NOT CAN-FIND(FIRST deposito 
                WHERE deposito.cod-depos = c-depos-entr) THEN DO:
		if rs-tipo-trans = 1 then do:
			 MESSAGE "Deposito de entrada invalido!"
				 VIEW-AS ALERT-BOX INFO BUTTONS OK.
			 RETURN "NOK":U.
		 end.
    END.


    IF d-data:SCREEN-VALUE IN FRAME fPage0 = ''  THEN DO:
       MESSAGE 'Data da Terefa deve ser informada'
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.

       APPLY 'entry' TO d-data IN FRAME fPage0.
       RETURN 'NOK'.
    END.
    
    IF INT(i-ord-produ:SCREEN-VALUE IN FRAME {&frame-name}) <> 0 THEN DO: 
       FIND FIRST ord-prod WHERE ord-prod.nr-ord-prod = INT(i-ord-produ:SCREEN-VALUE IN FRAME {&frame-name}) NO-LOCK NO-ERROR.

       IF NOT AVAIL ord-prod THEN DO:
          MESSAGE "Ordem de Produ‡Æo nÆo encontrada!"
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          RETURN "NOK":U.
       END.
    
       IF ord-prod.estado > 6 THEN DO:
          MESSAGE "Estado da OP nao permite movimento !" SKIP
                  "Altere para uma OP valida"
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          RETURN "NOK":U.            
       END.
    END.



    ASSIGN i-id-docto = 0
           l-primeiro = YES.

    REQUISICAO:
    DO TRANSACTION:    
        FOR EACH tt-item-mov NO-LOCK
            WHERE tt-item-mov.selec:
            /*  IF tt-item-mov.quantidade > (item-docto-transf-depos.qtd-item - item-docto-transf-depos.qtd-atual-item ) THEN DO:
                ASSIGN c-aux = STRING(item-docto-transf-depos.num-seq) + " / " +
                               STRING(item-docto-transf-depos.cod-item ).
        
                RUN piCreateError (INPUT 19055,
                                   INPUT c-aux,
                                   INPUT ? ).
            END.*/
        
            IF tt-item-mov.quantidade <= 0 THEN DO:
                ASSIGN c-msg = "do item " + STRING(tt-item-mov.nr-seq).
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 4570,
                                   INPUT c-msg).
                UNDO REQUISICAO, RETURN "NOK":U.
            END.

            IF INT(i-ord-produ:SCREEN-VALUE IN FRAME fpage0) <> 0 OR 
               l-consid-estrutura:CHECKED IN FRAME fpage0 THEN DO:

               ASSIGN i-qtde = tt-item-mov.quantidade.
    
               IF i-qtde <> tt-item-mov.quantidade THEN DO:
                  RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                     INPUT 17006,
                                     INPUT "Quantidade Fracionada nao pode ser movimentada~~" + tt-item-mov.it-codigo + " - Qtde: " + STRING(tt-item-mov.quantidade) ).
                  UNDO REQUISICAO, RETURN "NOK":U.
               END.
            END.


        
    /*         IF CAN-FIND(FIRST RowErrors                                    */
    /*                         WHERE RowErrors.ErrorSubType = "ERROR":U) THEN */
    /*             RETURN "NOK":U.                                            */
            
            /* ----- Integra»’o com Estoque ----- */
            FIND FIRST param-estoq NO-LOCK NO-ERROR.
        
            FIND FIRST wm-param NO-LOCK NO-ERROR. 
        
            FOR FIRST ITEM FIELDS(it-codigo un tipo-con-est)
                WHERE item.it-codigo = tt-item-mov.it-codigo NO-LOCK: 
            END.
        
            ASSIGN l-lote-branco = NO. 
        
            IF item.tipo-con-est = 1 /* Serial */ THEN DO:
                IF wm-param.log-tip-control-estoq-serial = YES THEN DO:
                    FIND FIRST wm-item no-lock
                        WHERE wm-item.cod-item = item.it-codigo NO-ERROR.
                    IF AVAIL wm-item 
                    AND wm-item.ind-tipo-contr-est = 3 THEN DO:
                        ASSIGN l-lote-branco = YES.
                    END.
                END.
            END.
        
            FOR FIRST deposito
                FIELDS (cod-depos log-gera-wms log-aloca-qtd-wms)
                WHERE deposito.cod-depos = c-depos-sai NO-LOCK: 
            END.
            IF  l-primeiro THEN DO:
                IF  c-depos-entr <> "" THEN DO:
                    RUN gera-numero-op-manual (OUTPUT i-nr-docto).
                    CREATE docto-transf-depos.
                    ASSIGN docto-transf-depos.cod-estab             = c-cod-estabel
                           docto-transf-depos.num-docto-transf      = i-nr-docto
                           docto-transf-depos.cod-depos-saida       = c-depos-sai
                           docto-transf-depos.cod-depos-entr        = c-depos-entr
                           docto-transf-depos.cod-cta-ctbl-unif     = c-ct-codigo
                           docto-transf-depos.cod-ccusto-movto-unif = c-sc-codigo
                           docto-transf-depos.cdn-emitente          = 0
                           docto-transf-depos.cod-usuar             = c-seg-usuario
                           docto-transf-depos.dat-docto             = TODAY
                           docto-transf-depos.idi-sit-docto         = 3
                           docto-transf-depos.log-gera-sugest       = YES
                           l-primeiro                               = NO
                           p-nr-docto                               = i-nr-docto.
                END.
                ELSE DO:

                    find last requisicao use-index requisicao 
                         where requisicao.nr-requisicao >= param-compra.prim-solic-man
                         and   requisicao.nr-requisicao <= param-compra.ult-solic-man no-lock no-error.
                    IF AVAIL requisicao THEN DO:
                        IF  requisicao.nr-requisicao >= 999999999 OR requisicao.nr-requisicao = param-compra.ult-solic-man THEN DO:
                            ASSIGN i-cont = param-compra.prim-solic-man.
                            REPEAT:
                                 IF CAN-FIND(requisicao WHERE
                                           requisicao.nr-requisicao = i-cont) THEN DO:
                                     ASSIGN  i-cont = i-cont + 1.
                                     NEXT.
                                 END.
                                 ASSIGN i-nr-requisicao = i-cont.
                                 LEAVE.    
                            END. 
                        END.
                        ELSE
                            ASSIGN i-nr-requisicao = IF AVAIL requisicao THEN (requisicao.nr-requisicao + 1)
                                                                         ELSE param-compra.prim-solic-man.
                    END.
                    ELSE
                        ASSIGN i-nr-requisicao = param-compra.prim-solic-man.

                    create requisicao.
                    assign requisicao.nr-requisicao = i-nr-requisicao 
                           requisicao.dt-requisicao = today
                           requisicao.situacao      = 3
                           requisicao.cod-estabel   = c-cod-estabel
                           requisicao.tp-requis     = 1
                           requisicao.estado        = 1
                           i-seq-req                = 10
                           requisicao.nome-abrev    = c-responsavel
                           p-nr-docto               = i-nr-requisicao.

                    FIND first usuar-mater where usuar-mater.cod-usuario = c-responsavel NO-LOCK NO-ERROR.

                    if not avail usuar-mater then do:
                        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                           INPUT 56,
                                           INPUT "Usu rio de Materiais").
     
                        UNDO REQUISICAO, RETURN "NOK":U.
                    end.
                    IF  not usuar-mater.usuar-requis then do:
                        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                           INPUT 874,
                                           INPUT "Requisi‡Æo de Materiais").
     
                        UNDO REQUISICAO, RETURN "NOK":U.
                    end.

                END.

            END.
            IF deposito.log-gera-wms = NO 
            AND c-depos-entr <> "" THEN DO: /* N’o Movimenta Qdo Sa­da ² WMS */
                FIND FIRST wm-item WHERE
                    wm-item.cod-item = tt-item-mov.it-codigo NO-LOCK NO-ERROR.

                EMPTY TEMP-TABLE tt-movto.
                /* Movimento de Sa­da do Estoque */
                CREATE tt-movto.
                ASSIGN tt-movto.cod-depos      = c-depos-sai
                       tt-movto.cod-emitente   = 0
                       tt-movto.cod-estabel    = c-cod-estabel
                       tt-movto.cod-refer      = c-refer-sai
                       tt-movto.dt-trans       = TODAY
                       tt-movto.esp-docto      = 33
                       tt-movto.i-sequen       = 1
                       tt-movto.it-codigo      = tt-item-mov.it-codigo
                       tt-movto.cod-localiz    = c-local-sai
                       tt-movto.lote           = tt-item-mov.lote
                       tt-movto.nro-docto      = string(docto-transf-depos.num-docto-transf)
                       tt-movto.num-sequen     = tt-item-mov.nr-seq
                       tt-movto.quantidade     = tt-item-mov.quantidade
                       tt-movto.ct-codigo      = string(c-ct-codigo,"X(20)")
                       tt-movto.sc-codigo      = c-sc-codigo
                       tt-movto.tipo-trans     = 2
                       tt-movto.un             = item.un
                       tt-movto.cod-prog-orig  = "ce9701":U
                       tt-movto.usuario        = c-seg-usuario
                       tt-movto.cod-versao-integracao   = 1
                       tt-movto.dat-valid-lote-fabrican = d-valid-lote.
    
                /* Movimento de Entrada do Estoque */
                CREATE b-tt-movto.
                ASSIGN b-tt-movto.cod-depos      = c-depos-entr
                       b-tt-movto.cod-emitente   = tt-movto.cod-emitente  
                       b-tt-movto.cod-estabel    = tt-movto.cod-estabel   
                       b-tt-movto.cod-refer      = tt-movto.cod-refer     
                       b-tt-movto.dt-trans       = tt-movto.dt-trans      
                       b-tt-movto.esp-docto      = tt-movto.esp-docto     
                       b-tt-movto.i-sequen       = 2
                       b-tt-movto.it-codigo      = tt-movto.it-codigo
                       b-tt-movto.cod-localiz    = ""
                       b-tt-movto.lote           = tt-movto.lote
                       b-tt-movto.nro-docto      = tt-movto.nro-docto
                       b-tt-movto.num-sequen     = tt-movto.num-sequen
                       b-tt-movto.quantidade     = tt-movto.quantidade
                       b-tt-movto.ct-codigo      = tt-movto.ct-codigo
                       b-tt-movto.sc-codigo      = tt-movto.sc-codigo
                       b-tt-movto.tipo-trans     = 1
                       b-tt-movto.un             = tt-movto.un
                       b-tt-movto.cod-prog-orig  = tt-movto.cod-prog-orig
                       b-tt-movto.usuario        = tt-movto.usuario
                       b-tt-movto.cod-versao-integracao   = 1
                       b-tt-movto.dat-valid-lote-fabrican = d-valid-lote.
                
                /* Atualiza o estoque */
                RUN cep/ceapi001k.p PERSISTENT SET h-ceapi001k.
                RUN pi-execute IN h-ceapi001k (INPUT-OUTPUT TABLE tt-movto,
                                               INPUT-OUTPUT TABLE tt-erro,
                                               INPUT YES).


                IF  CAN-FIND(FIRST tt-erro) THEN DO:
                    FOR EACH tt-erro:
                        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                           INPUT 17006,
                                           INPUT "Seq.:" + STRING(tt-item-mov.nr-seq) + "~~" +
                                                 tt-erro.mensagem).
                    END.
    
                    IF VALID-HANDLE(h-ceapi001k) THEN
                        DELETE PROCEDURE h-ceapi001k.
    
                    UNDO REQUISICAO, RETURN "NOK":U.
                END.
                ELSE DO:
                    IF RETURN-VALUE = "NOK":U THEN
                        UNDO REQUISICAO, RETURN "NOK":U.
                END.
                IF VALID-HANDLE(h-ceapi001k) THEN
                    DELETE PROCEDURE h-ceapi001k.
    
            END.        
    /*            MESSAGE "param-estoq.int-1=" param-estoq.int-1 " Integra»’o WMS"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
                /* ----- Integra»’o com WMS ----- */          
            IF param-estoq.int-1 = 1 THEN DO:
                IF c-depos-entr <> "" THEN
                    FOR FIRST b-deposito
                        FIELDS ( cod-depos log-gera-wms log-aloca-qtd-wms )
                        WHERE b-deposito.cod-depos = c-depos-entr NO-LOCK: 
                    END.
                IF deposito.log-gera-wms   = YES
                OR (AVAIL b-deposito AND b-deposito.log-gera-wms = YES) THEN DO:
    
                    IF deposito.log-gera-wms THEN DO:
                        IF c-depos-entr <> "" THEN
                            FIND FIRST ttWm-docto 
                                 WHERE ttWm-docto.cod-estabel      = c-cod-estabel                               
                                   AND ttWm-docto.cod-local        = c-local-sai
                                   AND ttWm-docto.num-docto        = STRING(docto-transf-depos.num-docto-transf) NO-LOCK NO-ERROR.
                        ELSE 
                            FIND FIRST ttWm-docto 
                                 WHERE ttWm-docto.cod-estabel      = c-cod-estabel                               
                                   AND ttWm-docto.cod-local        = c-local-sai
                                   AND ttWm-docto.num-docto        = STRING(requisicao.nr-requisicao) NO-LOCK NO-ERROR.
                    END.
                    ELSE
                        FIND FIRST ttWm-docto 
                             WHERE ttWm-docto.cod-estabel      = c-cod-estabel                               
                               AND ttWm-docto.cod-local        = c-local-entr                                         
                               AND ttWm-docto.num-docto        = STRING(docto-transf-depos.num-docto-transf) NO-LOCK NO-ERROR.

                    IF NOT AVAIL ttwm-docto THEN DO:
                        CREATE ttWm-docto.
                        ASSIGN ttWm-docto.cod-estabel      = c-cod-estabel
                               ttWm-docto.cod-local        = IF deposito.log-gera-wms THEN c-local-sai ELSE c-local-entr 
                               ttWm-docto.num-docto        = IF c-depos-entr <> "" THEN STRING(docto-transf-depos.num-docto-transf) ELSE STRING(requisicao.nr-requisicao)
                               ttWm-docto.num-docto-origem = IF c-depos-entr <> "" THEN STRING(docto-transf-depos.num-docto-transf) ELSE STRING(requisicao.nr-requisicao)
                               ttWm-docto.ind-origem-docto = IF c-depos-entr <> "" THEN 7 /* Transfer¼ncia Destino */ ELSE 21 /* Requisicao do Estoque */
                               i-seq-wm                    = 10
                               ttWm-docto.alteracao        = NO.

                        IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-dat-atz-movto-est-wms" AND funcao.ativo = YES) THEN 
                            ASSIGN ttWm-docto.log-dat-atualiz-movto-estoq = YES.
                        ELSE
                            ASSIGN ttWm-docto.log-dat-atualiz-movto-estoq = NO.
        
                        IF deposito.log-gera-wms = YES THEN       /* Deposito de Sa­da ² WMS */
                            ASSIGN ttWm-docto.ind-tipo-trans = 2       /* Sa­da */
                                   ttWm-docto.cod-depos = c-depos-sai.
                        ELSE                                /* Deposito de Entrada ² WMS */
                            ASSIGN ttWm-docto.ind-tipo-trans = 1       /* Entrada */
                                   ttWm-docto.cod-depos = c-depos-entr
                                   ttWm-docto.id-carga = 0.
                    END.
                    ELSE ASSIGN i-seq-wm = i-seq-wm + 10.

                    CREATE ttWm-docto-itens.
                    ASSIGN ttWm-docto-itens.cod-estabel    = c-cod-estabel
                           ttWm-docto-itens.cod-local      = IF ttWm-docto.ind-tipo-trans = 1 THEN c-local-entr ELSE c-local-sai
                           ttWm-docto-itens.num-docto      = ttWm-docto.num-docto
                           ttWm-docto-itens.id-docto       = i-id-docto
                           ttWm-docto-itens.cod-cliente    = 0
                           ttWm-docto-itens.cod-item       = tt-item-mov.it-codigo
                           ttWm-docto-itens.cod-refer      = IF ttWm-docto.ind-tipo-trans = 1 THEN c-refer-entr ELSE c-refer-sai
                           ttWm-docto-itens.cod-lote       = tt-item-mov.lote
                           ttwm-docto-itens.dt-validade-lote = d-valid-lote
                           ttWm-docto-itens.qtd-item       = tt-item-mov.quantidade
                           ttWm-docto-itens.num-seq-orig   = i-seq-wm
                           ttWm-docto-itens.dt-atualizacao = TODAY
                           ttWm-docto-itens.gera-sugestao  = YES
                           ttWm-docto-itens.num-seq-item   = i-seq-wm.

                     IF  c-depos-entr <> "" THEN DO:
                         CREATE item-docto-transf-depos.
                         ASSIGN item-docto-transf-depos.cod-item          = tt-item-mov.it-codigo
                                item-docto-transf-depos.cod-localiz-entr  = ""
                                item-docto-transf-depos.cod-localiz-saida = c-local-sai
                                item-docto-transf-depos.cod-lote          = tt-item-mov.lote
                                item-docto-transf-depos.cod-refer         = c-refer-sai
                                item-docto-transf-depos.idi-sit-docto     = 3
                                item-docto-transf-depos.num-docto-transf  = i-nr-docto
                                item-docto-transf-depos.num-seq           = i-seq-wm
                                item-docto-transf-depos.qtd-atual-item    = tt-item-mov.quantidade
                                item-docto-transf-depos.qtd-envia         = tt-item-mov.quantidade
                                item-docto-transf-depos.qtd-item          = tt-item-mov.quantidade
                                item-docto-transf-depos.qtd-movto-item    = 0.
                     END.
                     ELSE DO:
                         create it-requisicao.
                         assign it-requisicao.nr-requisicao  = requisicao.nr-requisicao
                                it-requisicao.sequencia      = i-seq-req
                                i-seq-req                    = i-seq-req + 10
                                it-requisicao.ep-codigo      = i-empresa
                                it-requisicao.it-codigo      = tt-item-mov.it-codigo
                                it-requisicao.qt-requisitada = tt-item-mov.quantidade
                                it-requisicao.qt-a-atender   = tt-item-mov.quantidade
                                it-requisicao.situacao       = 3
                                it-requisicao.estado         = 1 
                                it-requisicao.cod-estabel    = c-cod-estabel
                                it-requisicao.num-ord-inv    = 0
                                it-requisicao.seq-planej     = 1
                                it-requisicao.dt-entrega     = today
                                it-requisicao.tp-requis      = requisicao.tp-requis
                                it-requisicao.ct-codigo      = c-ct-codigo
                                it-requisicao.sc-codigo      = c-sc-codigo
                                it-requisicao.cod-depos      = c-depos-sai
                                it-requisicao.cod-localiz    = c-local-sai
                                it-requisicao.cod-refer      = c-refer-sai
                                it-requisicao.cod-unid-negoc = ""
                                it-requisicao.nome-abrev     = c-responsavel
                                it-requisicao.nome-aprov     = c-responsavel
                                it-requisicao.preco-unit     = 0.01
                                it-requisicao.un             = ITEM.un
                                it-requisicao.val-item       = 0.01.
                             .
/*                         find first item-uni-estab no-lock
                              where item-uni-estab.it-codigo   = it-requisicao.it-codigo
                              and   item-uni-estab.cod-estabel = it-requisicao.cod-estabel no-error.
                         if  avail item-uni-estab then do:
                             if  param-compra.int-2 = 1 then /* por grupo de compras */
                                 assign it-requisicao.cod-grp-compra = item-uni-estab.cod-grp-compra.
                             else /* por comprador */
                                 assign it-requisicao.cod-comprado = item-uni-estab.cod-comprado.
                         end.
        
                        create tt-movto.
                        assign tt-movto.cod-depos      = c-depos-sai
                               tt-movto.cod-emitente   = 0
                               tt-movto.cod-estabel    = c-cod-estabel
                               tt-movto.cod-refer      = c-refer-sai
                               tt-movto.ct-codigo      = c-ct-codigo
                               tt-movto.descricao-db   = it-requisicao.narrativa
                               tt-movto.dt-nf-saida    = ?
                               tt-movto.dt-trans       = TODAY
                               tt-movto.esp-docto      = 30
                               tt-movto.i-sequen       = it-requisicao.sequencia
                               tt-movto.it-codigo      = it-requisicao.it-codigo
                               tt-movto.cod-localiz    = c-local-sai
                               tt-movto.lote           = c-lote
                               tt-movto.nat-operacao   = ""
                               tt-movto.nro-docto      = string(it-requisicao.nr-requisicao,"999,999,999")
                               tt-movto.num-sequen     = it-requisicao.sequencia
                               tt-movto.sequen-nf      = it-requisicao.sequencia
                               tt-movto.numero-ordem   = 0
                               tt-movto.peso-liquido   = 0
                               tt-movto.quantidade     = tt-item-mov.quantidade
                               tt-movto.referencia     = ""
                               tt-movto.sc-codigo      = c-sc-codigo
                               tt-movto.serie-docto    = ""
                               tt-movto.tipo-preco     = 0
                               tt-movto.tipo-trans     = 2
                               tt-movto.tipo-valor     = 2
                               tt-movto.un             = item.un
                               tt-movto.cod-prog-orig  = "b06in385":U
                               tt-movto.usuario        = c-responsavel
                               tt-movto.cod-versao-integracao = 1
                               tt-movto.num-ord-inv    = it-requisicao.num-ord-inv
                               tt-movto.cod-unid-negoc = it-requisicao.cod-unid-negoc.
                  
                    run cep/ceapi001k.p persistent set h-ceapi001k.
                
                    run pi-execute in h-ceapi001k (input-output table tt-movto,
                                                   input-output table tt-erro,
                                                   input yes).
                    
                    IF  CAN-FIND(FIRST tt-erro) THEN DO:
                        FOR EACH tt-erro:
                            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                               INPUT tt-erro.cd-erro,
                                               INPUT tt-erro.mensagem).
                        END.

                        IF VALID-HANDLE(h-ceapi001k) THEN
                            DELETE PROCEDURE h-ceapi001k.

                        UNDO, RETURN "NOK":U.
                    END.
                    ELSE DO:
                        IF RETURN-VALUE = "NOK":U THEN
                            RETURN "NOK":U.
                    END.
                    IF VALID-HANDLE(h-ceapi001k) THEN
                        DELETE PROCEDURE h-ceapi001k. */
                    find requisicao
                        where requisicao.nr-requisicao = i-nr-requisicao exclusive-lock no-error.
                    FIND FIRST it-requisicao 
                         WHERE it-requisicao.it-codigo      = tt-item-mov.it-codigo 
                           AND it-requisicao.nr-requisicao  = requisicao.nr-requisicao
                        EXCLUSIVE-LOCK NO-ERROR.
                    assign requisicao.dt-atend         = TODAY
                           it-requisicao.qt-atendida   = tt-item-mov.quantidade
                           it-requisicao.qt-a-atender  = 0
                           it-requisicao.qt-a-devolver = tt-item-mov.quantidade
                           it-requisicao.dt-atend      = TODAY
                           it-requisicao.situacao      = 2.
        
                    find first b-it-requis
                        where b-it-requis.nr- = requisicao.nr-requisicao
                        and   b-it-requis.situacao      = 1
                        no-lock no-error.
                    if  not avail b-it-requis then do:
                        assign requisicao.situacao = 2.
                    end.
                end.
        
                
             END.
             
/*              FIND CURRENT it-requisicao EXCLUSIVE-LOCK NO-ERROR.    */
/*              IF AVAIL it-requisicao THEN DO:                        */
/*                  ASSIGN OVERLAY(it-requisicao.char-1,15,1) = "Y":U. */
/*                  FIND CURRENT it-requisicao NO-LOCK NO-ERROR.       */
/*              END.                                                   */
            
/*                      END. */
/*                           */
/*                 END.      */
            END.                
        END.
        
        FIND FIRST ttWm-docto NO-LOCK NO-ERROR.
        IF AVAIL ttwm-docto THEN DO:
            RUN wmp/wm9000.p (INPUT-OUTPUT TABLE ttWm-docto,
                              INPUT-OUTPUT TABLE ttWm-docto-itens,
                              INPUT-OUTPUT TABLE ttwm-etiqueta,
                              OUTPUT TABLE RowErrors ).        
            IF CAN-FIND(FIRST RowErrors 
                            WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                FOR EACH RowErrors NO-LOCK:
            /*                             MESSAGE RowErrors.ErrorNumber          */
            /*                                 VIEW-AS ALERT-BOX INFO BUTTONS OK. */
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 17006,
                                       INPUT RowErrors.ErrorDescription + "~~" + RowErrors.ErrorHelp).  
    
                END.
                UNDO REQUISICAO, RETURN "NOK":U.
            END.

            FOR EACH ttWm-docto:
                FIND wm-docto NO-LOCK
                    WHERE wm-docto.cod-estabel = ttWm-docto.cod-estabel
                      AND wm-docto.cod-local   = ttWm-docto.cod-local
                      AND wm-docto.id-docto    = ttWm-docto.id-docto NO-ERROR.
                IF NOT AVAIL wm-docto 
                THEN DO:
                    MESSAGE "Documento WMS nÆo gerado! Transferˆncia nÆo efetuada. " + STRING(ttWm-docto.num-docto)
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    UNDO REQUISICAO, RETURN "NOK":U.
                END.
            END.

            FIND FIRST ttWm-docto NO-LOCK NO-ERROR.
            IF ttWm-docto.id-docto <> 0 
            AND c-depos-entr <> "" THEN DO:
               FIND FIRST docto-transf-depos WHERE docto-transf-depos.num-docto-transf = INT(ttwm-docto.num-docto) EXCLUSIVE-LOCK.
               ASSIGN docto-transf-depos.id-docto = ttwm-docto.id-docto.

               FOR EACH wm-tarefa-docto NO-LOCK
                   WHERE wm-tarefa-docto.id-docto = ttwm-docto.id-docto:
                   CREATE in-wm-tarefa-docto.
                   ASSIGN in-wm-tarefa-docto.id-tarefa   = wm-tarefa-docto.id-tarefa
                          in-wm-tarefa-docto.cod-local   = c-depos-entr
                          in-wm-tarefa-docto.cod-localiz = c-local-entr
                          in-wm-tarefa-docto.cod-usuario = c-responsavel
                          in-wm-tarefa-docto.data-tarefa = DATE(d-data:SCREEN-VALUE IN FRAME fPage0) 
                          in-wm-tarefa-docto.hora-tarefa = (INT(substring(c-hora,1,2)) * 3600) + (INT(substring(c-hora,3,2)) * 60).

                   ASSIGN in-wm-tarefa-docto.log-solicitado-kit-ckd = NO. /*l-item-ckd AND 
                                                                      NOT CAN-FIND(FIRST tt-item-mov WHERE NOT tt-item-mov.selec)*/
               END.
            END.

            IF ttWm-docto.id-docto <> 0 
            AND c-depos-entr = "" THEN DO:
                
                FOR EACH wm-tarefa-docto NO-LOCK
                   WHERE wm-tarefa-docto.id-docto = ttwm-docto.id-docto:
                    
                   CREATE in-wm-tarefa-docto.
                   ASSIGN in-wm-tarefa-docto.id-tarefa   = wm-tarefa-docto.id-tarefa
                          in-wm-tarefa-docto.cod-local   = c-responsavel
                          in-wm-tarefa-docto.cod-localiz = c-local-sai
                          in-wm-tarefa-docto.cod-usuario = c-responsavel
                          in-wm-tarefa-docto.data-tarefa = DATE(d-data:SCREEN-VALUE IN FRAME fPage0) 
                          in-wm-tarefa-docto.hora-tarefa = (INT(substring(c-hora,1,2)) * 3600) + (INT(substring(c-hora,3,2)) * 60).

                   ASSIGN in-wm-tarefa-docto.log-solicitado-kit-ckd = no. /*l-item-ckd AND 
                                                                      NOT CAN-FIND(FIRST tt-item-mov WHERE NOT tt-item-mov.selec)*/
               END.
            END.
/*             if avail requisicao then do:                                          */
/*                 if valid-handle(h_v19in385) then                                  */
/*                     run pi-atualiza-situacao in h_v19in385 (requisicao.situacao). */
/*                                                                                   */
/*             end.                                                                  */

        END.

        /* Chamado M2403-135 */
        IF INT(i-ord-produ:SCREEN-VALUE IN FRAME {&frame-name}) <> 0 THEN DO: 
           FIND FIRST ord-prod WHERE ord-prod.nr-ord-prod = INT(i-ord-produ:SCREEN-VALUE IN FRAME {&frame-name}) EXCLUSIVE-LOCK NO-ERROR.
        
           IF AVAIL ord-prod THEN DO:
              ASSIGN ord-prod.estado = 4. /* Separada */ 
           END.
        END.                                             
    
    END.                                                 

    release docto-transf-depos.
    release requisicao.
    release item-docto-transf-depos.
    release it-requisicao.
    release in-wm-tarefa-docto.

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gera-numero-op-manual DBOProgram 
PROCEDURE gera-numero-op-manual:

DEFINE OUTPUT PARAMETER num-digitado AS INTEGER NO-UNDO.

FIND LAST docto-transf-depos NO-LOCK NO-ERROR.
  IF AVAIL docto-transf-depos AND docto-transf-depos.num-docto-transf < 9999999 THEN
      ASSIGN num-digitado = docto-transf-depos.num-docto-transf + 1.
  ELSE DO:
      ASSIGN num-digitado = 1.  
      REPEAT:
      /*find last embarque WHERE embarque.cdd-embarq = de-cdd-embarq no-lock no-error.*/
      IF CAN-FIND(FIRST docto-transf-depos WHERE docto-transf-depos.num-docto-transf = num-digitado) THEN
          ASSIGN num-digitado = num-digitado + 1. 
      ELSE
          LEAVE.
      END.
END.

END PROCEDURE.

/* --------------------- PROCEDURES INTERNAS ------------------------ */

PROCEDURE PICREATEERROR:

    DEFINE INPUT PARAMETER piErrorNumber       AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER piErrorParameters   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER piErrorDescription  AS CHARACTER NO-UNDO.

    ASSIGN i-seq-erro = i-seq-erro + 1.

    IF piErrorDescription = ? THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT piErrorNumber,
                           INPUT piErrorParameters).  

        FIND FIRST RowErrors 
             WHERE RowErrors.ErrorDescription = RETURN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAIL RowErrors THEN DO:
            CREATE RowErrors.
            ASSIGN RowErrors.ErrorSequence    = i-seq-erro
                   RowErrors.ErrorNumber      = piErrorNumber
                   RowErrors.ErrorParameters  = piErrorParameters
                   RowErrors.ErrorType        = "EMS"
                   RowErrors.ErrorSubType     = "ERROR"
                   RowErrors.ErrorDescription = RETURN-VALUE.

            RUN utp/ut-msgs.p (INPUT "help",
                               INPUT RowErrors.ErrorNumber,
                               INPUT RowErrors.ErrorParameters).  
            ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.
        END.
    END.        
    ELSE DO:
            CREATE RowErrors.
            ASSIGN RowErrors.ErrorSequence    = i-seq-erro
                   RowErrors.ErrorNumber      = piErrorNumber
                   RowErrors.ErrorParameters  = ""
                   RowErrors.ErrorType        = "EMS"
                   RowErrors.ErrorSubType     = "ERROR"
                   RowErrors.ErrorDescription = piErrorDescription.

    END.

    RETURN "OK":U.                   
END PROCEDURE.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE limpaErros V-table-Win 
PROCEDURE limpaErros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN /*v_cod_cta         = ""   /* CODIGO CONTA */*/
           v_des_cta         = ""   /* DESCRICAO CONTA */
           v_ind_finalid_cta = ""   /* FINALIDADE DA CONTA */
           v_cod_ccust       = ""   /* CODIGO CCUSTO */
           v_des_ccust       = "".  /* DESCRICAO CCUSTO */

    FOR EACH tt_log_erro:
      DELETE tt_log_erro.
    END.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-item-mov V-table-Win 
PROCEDURE pi-cria-tt-item-mov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-it-codigo LIKE saldo-estoq.it-codigo NO-UNDO.
    DEF INPUT PARAM p-qtd-compon LIKE estrutura.qtd-compon NO-UNDO.
    DEF INPUT PARAM p-consid-lote AS LOGICAL               NO-UNDO.

    DEF VAR p-qtd-disp-saida     AS DEC NO-UNDO. 
    DEF VAR p-qtd-saldo-saida    AS DEC NO-UNDO.
    DEF VAR p-qtd-disp-entrada   AS DEC NO-UNDO. 
    DEF VAR p-qtd-saldo-entrada  AS DEC NO-UNDO.
    DEF VAR qtd-atual            AS DEC NO-UNDO.
    DEF VAR l-lote-venc          AS LOG NO-UNDO.

    assign p-qtd-disp-entrada = 0
           p-qtd-saldo-entrada  = 0.

    IF p-it-codigo = "" THEN DO:
        FIND FIRST saldo-estoq NO-LOCK
             WHERE saldo-estoq.lote = c-lote NO-ERROR.

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = saldo-estoq.it-codigo NO-ERROR.
    END.
    ELSE
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.
    
    for each saldo-estoq FIELDS (cod-estabel cod-depos lote it-codigo
                                 qtidade-atu dt-vali-lote dt-ul-contag
                                 cod-refer qt-aloc-prod qt-alocada qt-aloc-ped
                                 cod-localiz) 
        WHERE  saldo-estoq.it-codigo   = ITEM.it-codigo      AND 
               saldo-estoq.cod-estabel = c-cod-estabel       AND 
               saldo-estoq.cod-depos   = c-depos-entr        AND
               /*saldo-estoq.cod-local   = c-local-entr        AND*/
               saldo-estoq.cod-refer   = c-refer-entr        AND
              (saldo-estoq.lote        = c-lote OR c-lote = "") no-lock:

        assign p-qtd-disp-entrada  = p-qtd-disp-entrada + (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada - 
                                     saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped)
               p-qtd-saldo-entrada = p-qtd-saldo-entrada  + saldo-estoq.qtidade-atu.

    END.
    
    assign p-qtd-disp-saida   = 0
           p-qtd-saldo-saida  = 0
           l-lote-venc        = NO.

    for FIRST saldo-estoq FIELDS (cod-estabel cod-depos lote it-codigo
                                 qtidade-atu dt-vali-lote dt-ul-contag
                                 cod-refer qt-aloc-prod qt-alocada qt-aloc-ped
                                 cod-localiz) where
              saldo-estoq.it-codigo   = ITEM.it-codigo      AND 
              saldo-estoq.cod-estabel = c-cod-estabel       AND 
              saldo-estoq.cod-local   = c-local-sai         AND
              saldo-estoq.cod-refer   = c-refer-sai         AND
              saldo-estoq.cod-depos   = c-depos-sai         AND
             (saldo-estoq.lote        = c-lote OR c-lote = "")  no-lock:

        assign p-qtd-disp-saida  = p-qtd-disp-saida + (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada - 
                                   saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped)
               p-qtd-saldo-saida = p-qtd-saldo-saida  + saldo-estoq.qtidade-atu.

        IF saldo-estoq.dt-vali-lote < TODAY THEN
        ASSIGN l-lote-venc = YES.

    END.

    ASSIGN d-quantidade-mult = 0.

    /**/

    IF deposito.log-gera-wms THEN DO:
        FIND FIRST wm-item-embalagem-local 
             WHERE wm-item-embalagem-local.cod-estabel = c-cod-estabel
               AND wm-item-embalagem-local.cod-item    = ITEM.it-codigo
               AND wm-item-embalagem-local.cod-local   = c-depos-sai NO-LOCK NO-ERROR.
        IF AVAIL wm-item-embalagem-local  THEN DO:
            
           /*IF wm-item-embalagem-local.log-abre-emb-item = NO 
           AND wm-item-embalagem-local.qtd-emb-item <> 0 THEN DO:*/
           IF wm-item-embalagem-local.qtd-emb-item <> 0 THEN DO:		
				  
				ASSIGN d-quantidade-mult = p-qtd-compon / wm-item-embalagem-local.qtd-emb-item.			
	
              IF d-quantidade-mult > TRUNC(d-quantidade-mult,0) THEN DO:
				ASSIGN d-quantidade-mult = (TRUNC(d-quantidade-mult,0) + 1) * wm-item-embalagem-local.qtd-emb-item.
			  END.
			  ELSE IF d-quantidade-mult = TRUNC(d-quantidade-mult,0) THEN DO:
				ASSIGN d-quantidade-mult = (TRUNC(d-quantidade-mult,0)) * wm-item-embalagem-local.qtd-emb-item.
			  END.
           END.
        END.

        ASSIGN de-qtd-disponivel = 0.
        IF p-consid-lote AND
           c-lote <> "" THEN DO:
            
            IF NOT VALID-HANDLE(hBOsc035) THEN
                RUN scbo/bosc035.p PERSISTENT SET hBOsc035.
    
           RUN getOcupacaoItem IN hBOsc035 (INPUT c-cod-estabel,
                                            INPUT c-depos-sai,
                                            INPUT 0,
                                            INPUT ITEM.it-codigo,
                                            INPUT c-refer-sai,
                                            INPUT c-lote,
                                            OUTPUT qtd-atual,
                                            OUTPUT TABLE ttResumoItem).
    
            IF VALID-HANDLE(hBOsc035) THEN
                DELETE PROCEDURE hBOsc035.

            ASSIGN de-qtd-disponivel = 0.
            FOR EACH ttResumoItem:
                ASSIGN de-qtd-disponivel = de-qtd-disponivel + ttResumoItem.qtd-item-liberado.
            END.

            FOR EACH wm-aloca-saldo NO-LOCK
               WHERE wm-aloca-saldo.cod-estabel = c-cod-estabel
                 AND wm-aloca-saldo.cod-local   = c-depos-sai
                 AND wm-aloca-saldo.cod-item    = ITEM.it-codigo
                 AND wm-aloca-saldo.cod-lote    = c-lote:
                ASSIGN de-qtd-disponivel = de-qtd-disponivel - wm-aloca-saldo.qtd-item.
            END.

            IF de-qtd-disponivel < 0 THEN
                ASSIGN de-qtd-disponivel = 0.


        END.
        ELSE DO:
            IF NOT VALID-HANDLE(hDBOWm-saldo-estoque) THEN
                RUN scbo/bosc058.p PERSISTENT SET hDBOWm-saldo-estoque.
    
            RUN getSaldoPicking IN hDBOWm-saldo-estoque (INPUT ITEM.it-codigo,
                                                         INPUT 0,
                                                         INPUT 0,
                                                         OUTPUT TABLE ttWm-saldo).
    
            IF VALID-HANDLE(hDBOWm-saldo-estoque) THEN
                DELETE PROCEDURE hDBOWm-saldo-estoque.
    
            
            /*FOR EACH tt-saldo-aloc:
                ASSIGN de-qtd-disponivel = de-qtd-disponivel + (tt-saldo-aloc.qtd-box - tt-saldo-aloc.qtd-alocada).
            END.*/
            ASSIGN l-lote-venc = NO.

            FOR EACH ttWm-saldo NO-LOCK
               WHERE ttWm-saldo.cod-estabel = c-cod-estabel
                 AND ttWm-saldo.cod-local   = c-depos-sai:
/*
                FOR EACH saldo-estoq WHERE
                         saldo-estoq.it-codigo   = ITEM.it-codigo         AND
                         saldo-estoq.cod-estabel = ttWm-saldo.cod-estabel AND
                         saldo-estoq.cod-depos   = ttWm-saldo.cod-local
                         NO-LOCK.

                    IF saldo-estoq.qtidade-atu  <> 0 AND
                       saldo-estoq.dt-vali-lote < TODAY
                    THEN ASSIGN l-lote-venc = YES. 

                END.    */
                FOR EACH wm-saldo-estoque WHERE
                         wm-saldo-estoque.cod-item    = ITEM.it-codigo         AND
                         wm-saldo-estoque.cod-estabel = ttWm-saldo.cod-estabel AND
                         wm-saldo-estoque.cod-local   = ttWm-saldo.cod-local
                         NO-LOCK.

                    IF wm-saldo-estoque.qtd-liberada <> 0 AND
                       wm-saldo-estoque.qtd-atual    <> 0 AND
                       wm-saldo-estoque.dt-validade-lote < TODAY
                    THEN ASSIGN l-lote-venc = YES. 

                END.

                ASSIGN /*qtd-atual     = qtd-atual     + ttWm-saldo.qtd-atual*/
                       de-qtd-disponivel  = de-qtd-disponivel  + ttWm-saldo.qtd-liberada.
            END.

            FOR EACH wm-aloca-saldo NO-LOCK
               WHERE wm-aloca-saldo.cod-estabel = c-cod-estabel
                 AND wm-aloca-saldo.cod-local   = c-depos-sai
                 AND wm-aloca-saldo.cod-item    = ITEM.it-codigo:
                ASSIGN de-qtd-disponivel = de-qtd-disponivel - wm-aloca-saldo.qtd-item.
            END.
        END.

        IF de-qtd-disponivel < 0 THEN
            ASSIGN de-qtd-disponivel = 0.

        ASSIGN p-qtd-disp-saida = de-qtd-disponivel.
        
    END.

    FIND LAST b-tt-item-mov NO-LOCK NO-ERROR.

    CREATE tt-item-mov.
    ASSIGN tt-item-mov.nr-seq      = IF AVAIL b-tt-item-mov THEN b-tt-item-mov.nr-seq + 1 ELSE 1
           tt-item-mov.it-codigo   = ITEM.it-codigo
           tt-item-mov.lote        = IF c-lote <> "" THEN c-lote ELSE ""
           tt-item-mov.qtd-saida   = p-qtd-disp-saida 
           tt-item-mov.qtd-entrada = p-qtd-disp-entrada
           tt-item-mov.quantidade  = IF d-quantidade-mult = 0 THEN p-qtd-compon ELSE d-quantidade-mult
           tt-item-mov.desc-item   = ITEM.desc-item
           tt-item-mov.nr-cor      = 1 /*transparente*/
           tt-item-mov.altera      = YES.

    IF d-quantidade-mult <> 0 
    AND d-quantidade-mult <> p-qtd-compon THEN DO:
        ASSIGN tt-item-mov.mensagem = "Quantidade ajustada de " + trim(string(p-qtd-compon)) + " para " +
                                      trim(string(tt-item-mov.quantidade)) + " devido a quantidade do item da embalagem ser de " + 
                                      trim(string(wm-item-embalagem-local.qtd-emb-item)). 
        ASSIGN tt-item-mov.nr-cor     = 3 /*"Amarelo"*/
               tt-item-mov.altera     = YES.
    END.

    /*IF tt-item-mov.quantidade < tt-item-mov.qtd-entrada THEN DO:
        ASSIGN tt-item-mov.mensagem = "Quantidade alterada de " + trim(string(tt-item-mov.quantidade)) + 
                             " para 0 visto que o requisitante j  possui saldo de " + 
                              trim(string(tt-item-mov.qtd-entrada)) + " para o item".
        ASSIGN tt-item-mov.quantidade = 0
               tt-item-mov.nr-cor     = 3 /*"Amarelo"*/
               tt-item-mov.altera     = YES.

    END.*/

    IF tt-item-mov.qtd-saida < tt-item-mov.quantidade THEN DO:
        ASSIGN tt-item-mov.mensagem = "Saldo de " + trim(string(tt-item-mov.qtd-saida)) + " no dep¢sito de sa¡da ² insuficiente".             
        ASSIGN /*tt-item-mov.quantidade = 0*/
               tt-item-mov.nr-cor     = 2 /*"Vermelho"*/
               tt-item-mov.altera     = YES.
    END.

    IF l-lote-venc = YES THEN
    ASSIGN tt-item-mov.mensagem = "Lote vencido"
           tt-item-mov.nr-cor   = 2 /*"Vermelho"*/.
    /*
    MESSAGE "C"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
        IF saldo-estoq.dt-vali-lote < TODAY THEN DO:
            MESSAGE "aquib"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
           ASSIGN tt-item-mov.mensagem = "Lote vencido"
                  tt-item-mov.nr-cor   = 2 /*"Vermelho"*/.
        END. */

END PROCEDURE.
  /*
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calculo wWindow 
PROCEDURE pi-calculo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
    def var de-quant-tot like tt-saldo-estoq.qtidade-req no-undo.

    empty temp-table tt-movto.
    empty temp-table tt-item-wms.

    find first it-requisicao exclusive-lock 
         where it-requisicao.nr-requisicao = i-nr-requisicao
           and it-requisicao.sequencia     = i-sequencia
           and it-requisicao.it-codigo     = c-it-codigo no-wait no-error.

    if locked(it-requisicao) then do:
        {utp/ut-table.i movind it-requisicao 1}
        run utp/ut-msgs.p (input "show":U, input 27837, input return-value).

        return no-apply.
    end.

    do  on error  undo, return error
        on stop   undo, return error
        on quit   undo, return error
        on endkey undo, return error:
        
        empty temp-table tt-matriz.

        for first it-requisicao no-lock
            where it-requisicao.nr-requisicao = i-nr-requisicao
              and it-requisicao.sequencia     = i-sequencia
              and it-requisicao.it-codigo     = c-it-codigo. end.

        assign i-seq-wms = i-seq-wms + 1
               de-qtidade = 0.

            FIND FIRST deposito WHERE
                deposito.cod-depos = c-depos-sai NO-LOCK NO-ERROR.

                /* se deposito eh de WMS */
                IF deposito.log-gera-wms THEN DO:
                
                    FIND FIRST tt-item-wms NO-LOCK
                         WHERE tt-item-wms.cod-estabel  = c-cod-estabel
                           AND tt-item-wms.cod-depos    = c-cod-depos-sai  
                           AND tt-item-wms.cod-item     = it-requisicao.it-codigo   
                           AND tt-item-wms.cod-refer    = c-refer-sai  
                           AND tt-item-wms.cod-lote     = c-lote NO-ERROR.

                    IF NOT AVAIL tt-item-wms THEN DO:
                        CREATE tt-item-wms.
                        ASSIGN tt-item-wms.cod-estabel  = c-cod-estabel           
                               tt-item-wms.cod-depos    = c-cod-depos-sai         
                               tt-item-wms.cod-item     = it-requisicao.it-codigo 
                               tt-item-wms.cod-refer    = c-refer-sai             
                               tt-item-wms.cod-lote     = c-lote
                               tt-item-wms.num-seq-orig = it-requisicao.sequencia
                               tt-item-wms.qtd-item     = 0.
                    END.

                    ASSIGN tt-item-wms.qtd-item = tt-item-wms.qtd-item + tt-saldo-estoq.qtidade-req
                           de-qtidade = de-qtidade + tt-saldo-estoq.qtidade-req.
                    NEXT.
                END.
            END.

                create tt-movto.
                assign tt-movto.cod-depos      = tt-saldo-estoq.cod-depos
                       tt-movto.cod-emitente   = 0
                       tt-movto.cod-estabel    = tt-saldo-estoq.cod-estabel
                       tt-movto.cod-refer      = tt-saldo-estoq.cod-refer
                       tt-movto.ct-codigo      = it-requisicao.ct-codigo
                       tt-movto.descricao-db   = it-requisicao.narrativa
                       tt-movto.dt-nf-saida    = ?
                       tt-movto.dt-trans       = da-dt-atend
                       tt-movto.esp-docto      = 30
                       tt-movto.i-sequen       = i-seq
                       tt-movto.it-codigo      = it-requisicao.it-codigo
                       tt-movto.cod-localiz    = tt-saldo-estoq.cod-localiz
                       tt-movto.lote           = tt-saldo-estoq.lote
                       tt-movto.nat-operacao   = ""
                       tt-movto.nro-docto      = &if '{&bf_mat_versao_ems}' >= '2.04' &then 
                                                     string(it-requisicao.nr-requisicao,"999,999,999")
                                                 &else
                                                     string(it-requisicao.nr-requisicao,"999,999")
                                                 &endif
                       tt-movto.num-sequen     = it-requisicao.sequencia
                       tt-movto.sequen-nf      = it-requisicao.sequencia
                       tt-movto.numero-ordem   = 0
                       tt-movto.peso-liquido   = 0
                       tt-movto.quantidade     = tt-saldo-estoq.qtidade-req * tt-matriz.perc-rateio / 100
                       tt-movto.referencia     = ""
                       tt-movto.sc-codigo      = it-requisicao.sc-codigo
                       tt-movto.serie-docto    = ""
                       tt-movto.tipo-preco     = 0
                       tt-movto.tipo-trans     = 2
                       tt-movto.tipo-valor     = 2
                       tt-movto.un             = item.un
                       tt-movto.cod-prog-orig  = "b06in385":U
                       tt-movto.usuario        = c-seg-usuario
                       tt-movto.cod-versao-integracao = 1
                       tt-movto.num-ord-inv    = it-requisicao.num-ord-inv.

                &if '{&bf_mat_versao_ems}' >= '2.062' &then
                 IF  l-unidade-negocio THEN DO:
                     IF it-requisicao.num-ord-inv <> 0 AND NOT item.fraciona THEN DO:
                         ASSIGN de-fracao-val-quantidade = de-fracao-val-quantidade + (tt-movto.quantidade - TRUNC(tt-movto.quantidade,0))
                                tt-movto.quantidade = TRUNC(tt-movto.quantidade,0).
    
                         FIND FIRST tt-movto-un NO-LOCK NO-ERROR.
                         IF AVAIL tt-movto-un AND tt-movto-un.perc-unid-neg = 100 /*100%*/ THEN DO:
                             ASSIGN tt-movto.cod-unid-negoc = tt-movto-un.cod-unid-neg.
                             DELETE tt-movto-un.
                         END.
                         ELSE DO:
                             IF AVAIL tt-movto-un THEN
                                 ASSIGN tt-movto.cod-unid-negoc = tt-movto-un.cod-unid-neg.
                             ELSE
                                 ASSIGN tt-movto.cod-unid-negoc = tt-matriz.cod-unid-neg.
                         END.
                     END.
                     ELSE
                         ASSIGN tt-movto.cod-unid-negoc = tt-matriz.cod-unid-neg.
                 END.
                 ELSE
                     ASSIGN tt-movto.cod-unid-negoc = it-requisicao.cod-unid-negoc.
                     
                &endif
                 ASSIGN de-quant-tot = de-quant-tot + tt-movto.quantidade.
            END.
            
            assign de-qtidade = de-qtidade + tt-saldo-estoq.qtidade-req.
            
            IF  de-fracao-val-quantidade <> 0 THEN
                ASSIGN tt-movto.quantidade = tt-movto.quantidade + de-fracao-val-quantidade.

          &if '{&bf_mat_versao_ems}' >= '2.062' &then  
            /*Acerto de Residuo Rateio por Unidade de Negocio*/
            IF  l-unidade-negocio AND it-requisicao.num-ord-inv <> 0 and can-find(first tt-matriz
                                                                                  where tt-matriz.perc-rateio  <> 100) THEN DO:
               IF tt-saldo-estoq.qtidade-req <> de-quant-tot THEN
                     ASSIGN tt-movto.quantidade = tt-movto.quantidade + (tt-saldo-estoq.qtidade-req - de-quant-tot).                
            END.
          &ENDIF
          
        END.            
        find it-requisicao
            where it-requisicao.nr-requisicao = i-nr-requisicao
            and   it-requisicao.sequencia     = i-sequencia
            and   it-requisicao.it-codigo     = c-it-codigo 
        NO-LOCK no-error no-wait.
        
        IF CAN-FIND(FIRST tt-item-wms) THEN DO:
            RUN cep/ceapi032.p (INPUT it-requisicao.nr-requisicao,
                                INPUT TABLE tt-item-wms,
                                OUTPUT TABLE RowErrors).
    
            IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="YES"}
                {method/showmessage.i3}
                 RETURN "ADM-ERROR":U.
            END.
    
            FIND CURRENT it-requisicao EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL it-requisicao THEN DO:
                ASSIGN OVERLAY(it-requisicao.char-1,15,1) = "Y":U.
                FIND CURRENT it-requisicao NO-LOCK NO-ERROR.
            END.
        END.

        IF can-find(FIRST tt-movto) THEN DO:
            run cep/ceapi001k.p persistent set h-ceapi001k.

            run pi-valida-movto-uneg in h-ceapi001k (input table tt-movto-un).

            run pi-execute in h-ceapi001k (input-output table tt-movto,
                                           input-output table tt-erro,
                                           input yes).
            delete procedure h-ceapi001k.
        END.
        
         if  can-find(first tt-erro) then do:
            run cdp/cd0666.w(input table tt-erro).       
            return "adm-error".
        end.
        else do:
             if return-value = "nok":U then
                 return "adm-error".

             IF de-qtidade = 0 THEN RETURN.

             IF NOT AVAIL param-global THEN
                 find first param-global no-lock no-error.
             
            find requisicao
                where requisicao.nr-requisicao = i-nr-requisicao exclusive-lock no-error.
            find current it-requisicao exclusive-lock.
            assign requisicao.dt-atend         = da-dt-atend
                   it-requisicao.qt-atendida   = it-requisicao.qt-atendida
                                               + de-qtidade
                                               /*+ (de-saldo - input frame {&frame-name} de-saldo-req)*/
                   it-requisicao.qt-a-atender  = it-requisicao.qt-a-atender
                                               - de-qtidade
                                               /*- (de-saldo - input frame {&frame-name} de-saldo-req)*/
                   it-requisicao.qt-a-devolver = it-requisicao.qt-a-devolver
                                               + de-qtidade 
                                               /*+ (de-saldo - input frame {&frame-name} de-saldo-req).*/
                   it-requisicao.dt-atend      = da-dt-atend.
            if  it-requisicao.qt-devolvida > 0 then do:
                assign it-requisicao.qt-devolvida = it-requisicao.qt-devolvida
                                                  - de-qtidade.
                                                  /*- (de-saldo - input frame {&frame-name} de-saldo-req).*/
                if  it-requisicao.qt-devolvida < 0 then
                    assign it-requisicao.qt-devolvida = 0.
            end.

            ASSIGN rw-it-requisicao = ROWID(it-requisicao).
            if  it-requisicao.qt-a-atender = 0 then do:
                assign it-requisicao.situacao = 2.
                find first b-it-requis
                    where b-it-requis.nr- = requisicao.nr-requisicao
                    and   b-it-requis.situacao      = 1
                    no-lock no-error.
                if  not avail b-it-requis then do:
                    assign requisicao.situacao = 2.
                end.
        end.

        if avail requisicao then do:
            if valid-handle(h_v19in385) then
                run pi-atualiza-situacao in h_v19in385 (requisicao.situacao).
                
        end.
        
     END.
     
    release it-requisicao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
*/
