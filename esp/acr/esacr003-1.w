&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
     
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{esinc\es0000.i}
/*
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
  */
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.

DEFINE VARIABLE v_column AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_asc    AS LOGICAL     NO-UNDO.

DEF VAR l-titulo AS LOG.
DEF VAR c-estabini      AS CHAR FORMAT "x(3)"       INIT ""           NO-UNDO.
DEF VAR c-estabfim      AS CHAR FORMAT "x(3)"       INIT "ZZZ"        NO-UNDO.
DEF VAR d-orderedini    AS DATE FORMAT "99/99/9999" INIT "01/01/1900" NO-UNDO. 
DEF VAR d-orderedfim    AS DATE FORMAT "99/99/9999" INIT "12/31/9999" NO-UNDO.
DEF VAR d-emissaoini    AS DATE FORMAT "99/99/9999" INIT "01/01/1900" NO-UNDO.
DEF VAR d-emissaofim    AS DATE FORMAT "99/99/9999" INIT "12/31/9999" NO-UNDO.
DEF VAR c-especieini    AS CHAR FORMAT "x(3)"       INIT ""           NO-UNDO.
DEF VAR c-especiefim    AS CHAR FORMAT "x(3)"       INIT "ZZZ"        NO-UNDO.
DEF VAR c-portadorini   AS CHAR FORMAT "x(5)"       INIT ""           NO-UNDO.
DEF VAR c-portadorfim   AS CHAR FORMAT "x(5)"       INIT "ZZZZZ"      NO-UNDO.
DEF VAR c-tituloini     AS CHAR FORMAT "x(5)"       INIT ""           NO-UNDO.
DEF VAR c-titulofim     AS CHAR FORMAT "x(5)"       INIT "ZZZZZZZZZZ" NO-UNDO.
DEF VAR c-titulodevini  AS CHAR FORMAT "x(5)"       INIT ""           NO-UNDO.
DEF VAR c-titulodevfim  AS CHAR FORMAT "x(5)"       INIT "ZZZZZZZZZZ" NO-UNDO.
DEF VAR c-clienteini    AS INT  FORMAT ">>>>>>>9"   INIT "0"          NO-UNDO.
DEF VAR c-clientefim    AS INT  FORMAT ">>>>>>>9"   INIT "99999999"   NO-UNDO.
DEF VAR d_vecdo         LIKE tit_acr.val_sdo_tit_acr                  NO-UNDO.  /*TOTAL VENCIDO*/
DEF VAR d-avcer         LIKE tit_acr.val_sdo_tit_acr                  NO-UNDO.  /*TOTAL A VENCER*/
DEF VAR d-vcto-mes      LIKE tit_acr.val_sdo_tit_acr                  NO-UNDO.  /*TOTAL VENCIMENTO MES*/
DEF VAR d-vl-cartorio   LIKE mgesp.int_tit_acr.val_desp_cartorio     NO-UNDO.  /*TOTAL DESP CARTORIO*/
DEF VAR vRetorno        AS CHAR                                       NO-UNDO.
DEF VAR i-cont-rating   AS INT                                        NO-UNDO.
DEF VAR v_rating_aux    AS CHAR                                       NO-UNDO.

def var v_log_mostra_perda_dedut
    as logical
    format "Sim/N∆o"
    initial YES
    view-as toggle-box
    label "Liquid Perda Dedut"
    column-label "Liquid Perda Dedut"
    no-undo.
def var v_log_top_milhao
    as logical
    format "Sim/N∆o"
    initial YES
    view-as toggle-box
    label "Top Milh∆o"
    column-label "Top Milh∆o"
    no-undo.
def var v_rating
    as char
    format "x(4)"
    initial ""
    label "Rating"
    column-label "Rating"
    VIEW-AS FILL-IN 
    SIZE 5 BY .88
    no-undo.

def var de-fator-1       as decimal format "999999,9999" init 1 no-undo.
DEF var c-obs            as char      no-undo.
DEF var c-return         as char      no-undo.
def var l-ok             as log  no-undo.

DEFINE VARIABLE i-contador      AS INT  FORMAT "999"         NO-UNDO.
DEFINE VARIABLE c-numero        AS CHAR FORMAT "x(12)"       NO-UNDO.
DEFINE VARIABLE c-parcela       AS CHAR FORMAT "x(2)"        NO-UNDO.
DEFINE VARIABLE c-data          AS CHAR FORMAT "x(8)"        NO-UNDO.
DEFINE VARIABLE c-data-emis     AS CHAR FORMAT "x(8)"        NO-UNDO.
DEFINE VARIABLE c-esp           AS CHAR FORMAT "x(3)"        NO-UNDO.
DEFINE VARIABLE c-vl-titulo     AS CHAR FORMAT "x(14)"       NO-UNDO.
DEFINE VARIABLE c-vl-cart       AS CHAR FORMAT "x(14)"       NO-UNDO.
DEFINE VARIABLE c-telefone      AS CHAR FORMAT "x(20)"       NO-UNDO.   
DEFINE VARIABLE c-nome-emit     AS CHAR FORMAT "x(40)"       NO-UNDO.   
DEFINE VARIABLE l-env-email     AS LOGICAL NO-UNDO.

DEFINE VARIABLE c-ender         LIKE pessoa_jurid.nom_endereco                   NO-UNDO.
DEFINE VARIABLE c-bairro        LIKE pessoa_jurid.nom_bairro                     NO-UNDO.
DEFINE VARIABLE c-cid           LIKE pessoa_jurid.nom_cidade                     NO-UNDO.
DEFINE VARIABLE c-cep           LIKE pessoa_jurid.cod_cep                        NO-UNDO.
DEFINE VARIABLE c-uf            LIKE pessoa_jurid.cod_unid_federac               NO-UNDO.
DEFINE VARIABLE c-cgc           LIKE pessoa_jurid.cod_id_feder   FORMAT "X(20)"  NO-UNDO.
DEFINE VARIABLE c-ins-estad     LIKE pessoa_jurid.cod_id_estad_jurid             NO-UNDO.
DEFINE VARIABLE c-ins-munic     LIKE pessoa_jurid.cod_id_munic_jurid             NO-UNDO.      
DEFINE VARIABLE c-email         LIKE pessoa_jurid.cod_e_mail                     NO-UNDO.
DEFINE VARIABLE de-tot-car      AS DEC FORMAT ">>>,>>>,>>9.99"                        NO-UNDO.  
DEFINE VARIABLE de-tot-cli      AS DEC FORMAT ">>>,>>>,>>9.99"                        NO-UNDO.
DEFINE VARIABLE v_arquivo       AS CHAR FORMAT "x(60)"                                NO-UNDO.
                                                                                      
/* SupplierCard */                                                                    
DEFINE VARIABLE i-dias-atraso-param-sc AS INTEGER                                     NO-UNDO.
DEFINE VARIABLE h-esapi001             AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-val-lim-supcard     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-saldo-ped-alocado   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-saldo-nfs-faturado  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-saldo-disp-supcard  AS DECIMAL     NO-UNDO.

DEFINE BUFFER bf-emitente FOR emitente.


DEFINE NEW GLOBAL SHARED VARIABLE v_rec_cliente AS RECID NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_tit_acr AS RECID NO-UNDO.
DEF    NEW GLOBAL SHARED VAR      v_rec_contrat_vendor AS RECID NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-esutp025 AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-esacr003 AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE g-esacr070-cliente AS INTEGER NO-UNDO.

DEFINE TEMP-TABLE tt_int_tit_acr LIKE mgesp.int_tit_acr.

DEF BUFFER b-emitente-matriz      FOR emitente.
DEF BUFFER b_movto_tit_acr_perdas FOR movto_tit_acr.
DEF BUFFER b-emitente-ped         FOR emitente.

{esp\acr\esacr003tt.i}
{esp\acr\acr711zo.i}

DEF STREAM Stream_1.

FORM tt_saldo.cod_espec_docto        COLUMN-LABEL "Esp"    FORMAT "x(06)"
     tt_saldo.cod_ser_docto          COLUMN-LABEL "Ser"    FORMAT "x(04)"
     tt_saldo.cod_tit_acr            COLUMN-LABEL "T°tulo" FORMAT "x(13)"
     tt_saldo.cod_parcela            COLUMN-LABEL "/P"
     tt_saldo.dat_emis_docto         COLUMN-LABEL "Emiss∆o"
     tt_saldo.dat_vencto_tit_acr     COLUMN-LABEL "Vencto"
     tt_saldo.val_origin_tit_acr     COLUMN-LABEL "Vl. Orig."
     tt_saldo.val_sdo_tit_acr        COLUMN-LABEL "Vl. Cli."
     tt_saldo.num_atr                COLUMN-LABEL "Atr†s"   FORMAT '->>>9'
     tt_saldo.cod_portador           COLUMN-LABEL "Por"
     tt_saldo.cod_cart_bcia          COLUMN-LABEL "Cart"
     tt_saldo.cod_tit_acr_bco        COLUMN-LABEL "Num Banco"
     tt_saldo.val_desp_cartorio      COLUMN-LABEL "Vl. Cart¢rio"
     tt_saldo.ind_sit_envio          COLUMN-LABEL "Status Envio"
     tt_saldo.cod_boleto_impresso    COLUMN-LABEL "Boleto Impresso"    
     tt_saldo.cod_perda              COLUMN-LABEL "Indic. Perda"
     tt_saldo.num_planinha_vendor    COLUMN-LABEL "Plan Vend"
     WITH NO-ATTR-SPACE 09 DOWN ROW 5 WIDTH 132 FRAME f-tt-saldo-p
     TITLE " Titulos do Cliente ".

DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE mgesp.ponto-programa.nome-programa
    FIELD ponto            LIKE mgesp.ponto-programa.ponto
    FIELD sequencia        LIKE mgesp.conteudo-programa.sequencia 
    FIELD conteudo         LIKE mgesp.conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEF BUFFER b_tit_acr_VE FOR tit_acr.
DEF BUFFER b_tit_acr_DM FOR tit_acr.
DEF BUFFER b_tit_acr FOR tit_acr.

/* Temp-table para envio de e-mail */                 
def temp-table tt_mail_fax no-undo
    field ttv_nom_servid            as character format "x(30)"
    field ttv_num_porta_servid  as integer   format ">>>>9"
    field ttv_log_exchange          as logical   format "Sim/N∆o" initial no
    field ttv_nom_from              as character format "x(50)"
    field ttv_nom_to                as character format "x(50)" label "To"
    field ttv_nom_cc                as character format "x(50)" label "Cc"
    field ttv_nom_subject           as character format "x(30)"
    field ttv_nom_message           as character format "x(50)"
    field ttv_nom_attachfile    as character format "x(30)"
    field ttv_num_imptcia           as integer   format "9"
    field ttv_log_envda             as logical   format "Sim/N∆o" initial no
    field ttv_log_lida              as logical   format "Sim/N∆o" initial no
    field ttv_cod_format_mail   as character format "x(8)"    initial "TEXTO".

def temp-table tt_erros_mail_fax no-undo
    field ttv_cod_erro          as character format "x(10)"
    field ttv_des_erro          as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_arquivo       as character format "x(255)".
/* Temp-table para envio de e-mail */
def temp-table tt-matriz no-undo
    field cod-emitente LIKE emitente.cod-emitente.


DEFINE VARIABLE i-dias-atraso-tit AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-tit-atrasado    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-atraso-pagto    AS LOGICAL     NO-UNDO.

DEFINE BUFFER bf-int-ped-venda FOR int-ped-venda.
DEFINE BUFFER bf-int-ped-venda-br FOR int-ped-venda.

DEFINE VARIABLE c-lista-clientes AS CHARACTER FORMAT 'x(100)':U NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

define temp-table tt-cond-esp
       field seq          as   int format ">>9"
       field cod-vencto   like cond-ped.cod-vencto   extent 0
       field data-pagto   like cond-ped.data-pagto   extent 0 
       field nr-dias-venc like cond-ped.nr-dias-venc extent 0
       field vl-pagto     like cond-ped.vl-pagto     extent 0
       Field perc-pagto   like cond-ped.perc-pagto   extent 0.

&Scoped-define BROWSE-NAME br_cond_esp

&ANALYZE-SUSPEND
DEFINE QUERY br_cond_esp FOR 
      tt-cond-esp SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_cond_esp
  QUERY br_cond_esp NO-LOCK DISPLAY
      tt-cond-esp.seq
      tt-cond-esp.data-pagto
      tt-cond-esp.cod-vencto
      tt-cond-esp.nr-dias-venc
      tt-cond-esp.perc-pagto
      tt-cond-esp.vl-pagto
    WITH NO-ASSIGN SEPARATORS SIZE 49.5 BY 3.3.

define temp-table tt-antecip
       field parc    as   int format "99"
       field doc     as   char
       field data    like ped-antecip.data-antecip extent 0
       field valor   like ped-antecip.vl-antecip   extent 0.

&Scoped-define BROWSE-NAME br_antecip



DEFINE VARIABLE c-doc AS CHARACTER FORMAT "X(256)":U 
     LABEL "T°tulo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-parc AS INTEGER FORMAT ">9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 03 BY .88 NO-UNDO.

&ANALYZE-SUSPEND
DEFINE QUERY br_antecip FOR 
      tt-antecip SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_antecip
  QUERY br_antecip NO-LOCK DISPLAY
      tt-antecip.data
      tt-antecip.valor
    WITH NO-ASSIGN SEPARATORS SIZE 49.9 BY 3.3.




def var d-vl-aberto     as decimal           no-undo.
def var c-lista-cod-sit-aval as char no-undo.
def var c-lista-cod-sit-ped  as char no-undo.
def var c-cod-sit-aval as char  no-undo.
def var c-nf-devol     as char  no-undo.
def var c-cod-sit-ped  as char  no-undo.

ASSIGN c-lista-cod-sit-aval = "N∆o Avaliado,Avaliado,Aprovado,N∆o Aprovado,Pendente Informaá∆o"
       c-lista-cod-sit-ped  = "Aberto,Atendido Parcial,Atendido Total,Pendente,Suspenso,Cancelado,Fatur Balc∆o".


DEFINE BUTTON bt-repres
     LABEL "Representantes" 
     SIZE 12 BY 1.


DEFINE BUTTON bt-aprova 
     LABEL "&Aprovar" 
     SIZE 10 BY 1.
DEFINE BUTTON bt-filtro 
     LABEL "&Filtro" 
     SIZE 10 BY 1.
DEFINE BUTTON bt-reprova 
     LABEL "&Reprovar" 
     SIZE 10 BY 1.
DEFINE BUTTON bt-can
     IMAGE-UP FILE "image~\im-can":U
     LABEL "Can" 
     tooltip "Cancela Alteraá∆o"
     SIZE 4 BY 1.25
     FONT 4.
DEFINE BUTTON bt-mod 
     IMAGE-UP FILE "image~\im-mod":U
     IMAGE-INSENSITIVE FILE "image~\ii-mod":U
     LABEL "Mod" 
     tooltip "Modifica An†lise de CrÇdito"
     SIZE 4 BY 1.25
     FONT 4.
DEFINE BUTTON bt-sav 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     tooltip "Confirma Alteraá∆o"
     LABEL "Sav" 
     SIZE 4 BY 1.25
     FONT 4.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-converte B-table-Win 
FUNCTION fn-desc-condicao RETURNS CHARACTER
  (input p-cond-pag as INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-converte B-table-Win 
FUNCTION fn-nf-devol RETURNS CHARACTER
  (input c_cod_estab       AS CHAR,
   INPUT c_cod_espec_docto AS CHAR,
   INPUT c_cod_ser_docto   AS CHAR,
   INPUT c_cod_tit_acr     AS CHAR,
   INPUT c_cod_parcela     AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-converte B-table-Win 
FUNCTION fn-converte RETURNS DECIMAL
  (input r-ped-venda as rowid) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-converte B-table-Win 
FUNCTION fn-converte RETURNS DECIMAL
  (input r-ped-venda as rowid):

  def var d-vl-aberto as decimal no-undo.

  find first ped-venda where rowid(ped-venda) = r-ped-venda no-lock no-error.
  if avail ped-venda then do:
     run pi-converte-moeda (output d-vl-aberto).
  end.


  RETURN d-vl-aberto.   /* Function return value. */

END FUNCTION.

DEFINE TEMP-TABLE tt-situacao NO-UNDO 
       FIELD it-codigo AS CHAR
       field situacao as int
       index situacao situacao.

DEFINE TEMP-TABLE tt-situacao-ped NO-UNDO 
       FIELD it-codigo AS CHAR
       field situacao as int
       index situacao situacao.

def temp-table tt-cond-pagto no-undo
    field cod-cond-pag like cond-pagto.cod-cond-pag.
    

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_ped FOR 
      tt-situacao,
      tt-matriz,
      b-emitente-ped,
      ped-venda,
      bf-int-ped-venda-br,
      tt-cond-pagto SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_ped
  QUERY br_ped NO-LOCK DISPLAY
      /*bf-int-ped-venda-br.liberacao-forcada FORMAT "Sim/N∆o":U COLUMN-LABEL "Lib":U VIEW-AS TOGGLE-BOX*/
      ped-venda.cod-emitente
      ped-venda.nr-pedido FORMAT ">>>,>>>,>>9":U
      fn-converte(rowid(ped-venda)) @ d-vl-aberto FORMAT ">>,>>>,>>>,>>9.99":U WIDTH 10
      entry(ped-venda.cod-sit-aval, c-lista-cod-sit-aval) @ c-cod-sit-aval FORMAT "x(19)":U WIDTH 10
      entry(ped-venda.cod-sit-ped, c-lista-cod-sit-ped) @ c-cod-sit-ped FORMAT "x(20)":U    WIDTH 11.3
      fn-desc-condicao(ped-venda.cod-cond-pag) COLUMN-LABEL "Pagto" WIDTH 20 FORMAT "x(60)"
      ped-venda.dt-implant
      bf-int-ped-venda-br.dt-negociacao   COLUMN-LABEL "Dt Base"
      bf-int-ped-venda-br.dias-negociacao COLUMN-LABEL "Dias Negoc"
      ped-venda.dt-entrega
      ped-venda.nr-pedcli FORMAT "x(12)":U
      ped-venda.mo-codigo COLUMN-LABEL "Moeda" FORMAT ">>9":U WIDTH 5
      /*ENABLE
      bf-int-ped-venda-br.liberacao-forcada*/
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE /*53.2*/ 100.29 BY 5.5.

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME br_tt_saldo

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt_saldo

/* Definitions for BROWSE br_tt_saldo                                   */
&Scoped-define FIELDS-IN-QUERY-br_tt_saldo tt_saldo.l-ok tt_saldo.cdn_cliente tt_saldo.cod_estab tt_saldo.cod_espec_docto tt_saldo.cod_ser_docto tt_saldo.cod_tit_acr tt_saldo.cod_parcela tt_saldo.dat_emis_docto tt_saldo.dat_vencto_tit_acr tt_saldo.dat_entrega tt_saldo.dat_prev_entr tt_saldo.val_origin_tit_acr tt_saldo.val_sdo_tit_acr tt_saldo.cod_PO_cliente tt_saldo.num_atr tt_saldo.cod_portador tt_saldo.cod_cart_bcia tt_saldo.cod_cond_cobr tt_saldo.cod_tit_acr_bco tt_saldo.val_desp_cartorio tt_saldo.ind_sit_envio tt_saldo.cod_boleto_impresso tt_saldo.cod_perda tt_saldo.log_liq_perdas tt_saldo.num_planinha_vendor 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_tt_saldo tt_saldo.val_desp_cartorio   
&Scoped-define ENABLED-TABLES-IN-QUERY-br_tt_saldo tt_saldo
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_tt_saldo tt_saldo
&Scoped-define SELF-NAME br_tt_saldo
&Scoped-define OPEN-QUERY-br_tt_saldo IF l-titulo = NO THEN OPEN QUERY {&SELF-NAME} FOR EACH tt_saldo USE-INDEX ix-dt-venc NO-LOCK /*INDEXED-REPOSITION*/. ELSE OPEN QUERY {&SELF-NAME} FOR EACH tt_saldo USE-INDEX ix-tit     NO-LOCK /*INDEXED-REPOSITION*/.
&Scoped-define TABLES-IN-QUERY-br_tt_saldo tt_saldo
&Scoped-define FIRST-TABLE-IN-QUERY-br_tt_saldo tt_saldo


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-br_tt_saldo}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtParent rtParent-2 rtToolBar btFirst ~
btPrev btNext btLast btDet bt_historico_padrao bt_historico btZoom btFiltro btPrint bt_rel_cred btMail btRegrasVencto btTransfCred btSelec ~
btGera btAcordo btmatriz btExit btHelp cod-cliente btGoTo rs-opcao v_log_mostra_perda_dedut br_tt_saldo bt-repres
&Scoped-Define DISPLAYED-OBJECTS cod-cliente c-cliente v_num_pessoa c-fone ~
c-cidade c-estado i-cod-grp-cobr /*c-gr*/ v_user_libcre v_log_top_milhao v_rating v_email d-tot-orig ~
d-tot-cliente d-credito v_vcto_mes v_sdo_vencido v_sdo_avencer ~
rs-opcao v_log_mostra_perda_dedut

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miDetalhe      LABEL "Detalhe"        ACCELERATOR "ALT-D"
       MENU-ITEM miPesquisa     LABEL "Pesquisa"       ACCELERATOR "ALT-Z"
       RULE
       MENU-ITEM miFaixa        LABEL "Faixa"         
       RULE
       MENU-ITEM miRelat        LABEL "Relat¢rios"    
       RULE
       MENU-ITEM m_Desmarca     LABEL "Desmarca"       ACCELERATOR "CTRL-D"
       MENU-ITEM mimail         LABEL "Envia E-Mail"  
       MENU-ITEM migeracao      LABEL "Geraá∆o"       
       MENU-ITEM miacordo       LABEL "Acordo Comercial"
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
def button bt_historico_padrao
    label "Hist¢rico"
    tooltip "Inclui Hist¢rico do Cliente"
    image-up file "image/im-ampr3.gif"
    image-insensitive file "image/ii-hist.bmp"
    size 4 by 1.25.

def button bt_historico
    label "Hist¢rico"
    tooltip "Consulta Hist¢rico do Cliente"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-hist.bmp"
    image-insensitive file "image/ii-hist.bmp"
&endif
    size 4 by 1.25.

DEFINE BUTTON btRegrasVencto 
     IMAGE-UP FILE "image/intelbras/APPTS.ICO":U
     IMAGE-INSENSITIVE FILE "image/intelbras/APPTS.ICO":U
     LABEL "Atualiza" 
     SIZE 4 BY 1.25 TOOLTIP "Regras de Vencimento".

DEFINE BUTTON btDet 
     IMAGE-UP FILE "image/im-det.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image\im-ran.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-ran.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro".

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGera 
     IMAGE-UP FILE "image/im-rnl.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-rnl.bmp":U
     LABEL "Geracao"  
     SIZE 4 BY 1.25 TOOLTIP "Envio Arquivo Assessoria".

DEFINE BUTTON btAcordo
     IMAGE-UP FILE "image/im-aloca.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-aloca.bmp":U
     LABEL "Acordo Comercial" 
     SIZE 4 BY 1.25 TOOLTIP "Acordo Comercial".
    
DEFINE BUTTON btMatriz
     IMAGE-UP FILE "adeicon/rpt-u.bmp":U
     IMAGE-INSENSITIVE FILE "adeicon/rpt-u.bmp":U
     LABEL "Matriz" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Matriz".

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY .88.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btTransfCred 
     IMAGE-UP FILE "image\im-amort":U
     IMAGE-INSENSITIVE FILE "image\ii-amort":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btMail 
     IMAGE-UP FILE "image/im-carta.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-carta.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25 TOOLTIP "E-Mail".

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image/im-nex1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-nex1.bmp":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image/im-pre1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-pre1.bmp":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrint 
     IMAGE-UP FILE "image\im-pri.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-pri.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt_rel_cred
     IMAGE-UP FILE "image\im-gera.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-gera.bmp":U
     TOOLTIP "Relat¢rio Avaliaá∆o CrÇdito" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btSelec 
     IMAGE-UP FILE "image/im-carga.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-carga.bmp":U
     LABEL "Atualiza" 
     SIZE 4 BY 1.25 TOOLTIP "Envio Assessoria".

DEFINE BUTTON btZoom 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sea1.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE c-cidade LIKE pessoa_fisic.nom_cidade
     VIEW-AS FILL-IN 
     SIZE 28.43 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-cliente AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 53 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-estado LIKE pessoa_fisic.cod_unid_federac
     LABEL "UF" 
     VIEW-AS FILL-IN 
     SIZE 4.29 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-fone LIKE pessoa_fisic.cod_telefone
     VIEW-AS FILL-IN 
     SIZE 19.14 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-gr LIKE grp_clien.des_grp_clien
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cod-cliente AS CHARACTER FORMAT "X(20)" 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 20.43 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE d-credito LIKE tit_acr.val_origin_tit_acr
     LABEL "Total Val CrÇdito" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE d-tot-cliente LIKE tit_acr.val_sdo_tit_acr
     LABEL "Total Val Cliente" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE d-tot-matriz LIKE tit_acr.val_sdo_tit_acr
     LABEL "Limite Utilizado" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88
     NO-UNDO.

DEFINE VARIABLE d-tot-ped LIKE tit_acr.val_sdo_tit_acr
     LABEL "Total Ped" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88
     NO-UNDO.

DEFINE VARIABLE d-tot-orig LIKE tit_acr.val_origin_tit_acr
     LABEL "Total Val Orig" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v_vcto_mes AS DECIMAL FORMAT ">>,>>>,>>9.99"
     LABEL "Total Vencimento Màs"
     VIEW-AS FILL-IN
     SIZE 17.57 BY .88
     BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE v_desp_cartorio AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Total Desp Cart¢rio" 
     VIEW-AS FILL-IN 
     SIZE 17.57 BY .88
     BGCOLOR 15 FGCOLOR 12 NO-UNDO.

DEFINE VARIABLE v_email AS CHARACTER FORMAT "X(60)":U 
     LABEL "E-mail" 
     VIEW-AS FILL-IN 
     SIZE 42.57 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v_user_libcre LIKE emitente.user-libcre 
     LABEL "Ult Alt Cred" 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v_nom_abrev AS CHARACTER FORMAT "X(15)":U 
     LABEL "Repres" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v_num_pessoa AS INTEGER FORMAT ">>>>>>9":U INITIAL ? 
     LABEL "Pessoa" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v_sdo_avencer AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Val a Vencer" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v_sdo_vencido AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Val Vencido" 
     VIEW-AS FILL-IN 
     SIZE 17.57 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v_tot_sel AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Selecionado" 
     VIEW-AS FILL-IN 
     SIZE 17.57 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-tx-cli AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 22.29 BY .67 NO-UNDO.

DEFINE VARIABLE i-dias-base AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-grp-cobr AS INTEGER FORMAT ">9":U LABEL "Grp Cobr"
    VIEW-AS FILL-IN
    SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE rs-opcao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Por Vencimento", 1,
          "Por T°tulo", 2
     SIZE 30 BY 1
     NO-UNDO.

DEFINE VARIABLE rs-modo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "INFORMAÄÂES FINANCEIRAS", 1,
"ANµLISE DE CRêDITO", 2
     SIZE 50 BY 1
      NO-UNDO.

DEFINE RECTANGLE RECT-1 /* do rs-modo*/
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 106 BY 1.25
     FGCOLOR 1.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 106  BY 1.25
     FGCOLOR 1.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 106 BY 12.8 
     FGCOLOR 1.

DEFINE RECTANGLE RECT-4 /*Limites */
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 106 BY 15.5 
     FGCOLOR 1.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54.55 BY 7.25
     FGCOLOR 1.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.4 BY 7.25
     FGCOLOR 1.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 106 BY 3.54.

DEFINE RECTANGLE rtParent-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 106 BY 3.08.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 106 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE c-desc-cond-pagto-vdr AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE cb-credito-cli AS CHARACTER FORMAT "X(100)":U 
     LABEL "CrÇdito" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-lim-tot-supcard AS DECIMAL FORMAT "->>>,>>>,>>9.99"
     LABEL "Limite SC"
     VIEW-AS FILL-IN 
     SIZE 11 BY .80
     NO-UNDO.

DEFINE VARIABLE de-lim-uti-supcard AS DECIMAL FORMAT "->>>,>>>,>>9.99"
     LABEL "Lim Uti SC"
     VIEW-AS FILL-IN 
     SIZE 11 BY .80
     NO-UNDO.

DEFINE VARIABLE de-lim-uti-intelbras AS DECIMAL FORMAT "->>>,>>>,>>9.99"
     LABEL "Lim Uti Intel"
     VIEW-AS FILL-IN 
     SIZE 11 BY .80
     NO-UNDO.

DEFINE VARIABLE de-lim-disp-cli AS DECIMAL FORMAT "->>>,>>>,>>9.99"
     LABEL "Lim Disp"
     VIEW-AS FILL-IN 
     SIZE 11 BY .80
     NO-UNDO.

DEFINE VARIABLE i-dias-atras-supcard AS INTEGER FORMAT ">>9"
     LABEL "Dias Atraso SC"
     VIEW-AS FILL-IN 
     SIZE 6 BY .80
     NO-UNDO.

DEFINE VARIABLE i-dias-atras-intelbras AS INTEGER FORMAT ">>9"
     LABEL "Dias Atraso Intel"
     VIEW-AS FILL-IN 
     SIZE 6 BY .80
     NO-UNDO.

/*
DEFINE BUTTON bt-det-supcard
     IMAGE-UP FILE "image~\im-det":U
     IMAGE-INSENSITIVE FILE "image~\ii-det":U
     TOOLTIP "Detalhes"
     LABEL "Det" 
     SIZE 3 BY 0.80
     FONT 4.
*/

DEFINE RECTANGLE rt-divisao
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 0.5 BY 1.2
     FGCOLOR 1.

def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def var v_des_histor_clien
    as character
    format "x(2000)":U
    view-as editor max-chars 2000 scrollbar-vertical
    size 40 by 3
    bgcolor 15 font 2
    label "Hist¢rico Cliente"
    column-label "Hist¢rico Cliente"
    no-undo.

def var v_des_histor_clien_con
    as character
    format "x(2000)":U
    view-as editor max-chars 2000 scrollbar-vertical
    size 40 by 3
    bgcolor 15 font 2
    label "Hist¢rico Cliente"
    column-label "Hist¢rico Cliente"
    no-undo.

def var v_dat_gerac_histor 
    as date 
    format "99/99/9999":U 
    no-undo.
    
def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.

def rectangle rt_001
    size 1 by 1
    edge-pixels 2.
def rectangle rt_002
    size 1 by 1
    edge-pixels 2.

def var v_cod_usuar_inic
    as character
    format "x(12)":U
    label "Usu†rio"
    no-undo.
def var v_dat_histor_1
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "Data"
    no-undo.
def var v_cod_hora_1
    as character
    format "x(8)":U
    initial "00:00:00"
    label "Hora"
    no-undo.
def button bt_pre1
    label "<"
    tooltip "Ocorrància Anterior da Tabela"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-pre1"
    image-insensitive file "image/ii-pre1"
&endif
    size 1 by 1.
def button bt_nex1
    label ">"
    tooltip "Pr¢xima Ocorrància da Tabela"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-nex1"
    image-insensitive file "image/ii-nex1"
&endif
    size 1 by 1.

def frame f_dlg_01_histor_clien
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 07.17 col 02.00 bgcolor 7 
    histor_clien.des_abrev_histor_clien
         at row 02.00 col 18.00 colon-aligned label "Abrev Hist¢rico"
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_des_histor_clien
         at row 03.00 col 18.00 colon-aligned label "Hist¢rico Cliente"
         help "Hist¢rico Cliente"
         view-as editor max-chars 2000 scrollbar-vertical
         size 40 by 3
         bgcolor 15 font 2
    bt_ok
         at row 07.38 col 03.00 font ?
         help "OK"
    bt_can
         at row 07.38 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 67.00 by 09.00 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Hist¢rico Cliente".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_dlg_01_histor_clien = 10.00
           bt_can:height-chars  in frame f_dlg_01_histor_clien = 01.00
           bt_ok:width-chars    in frame f_dlg_01_histor_clien = 10.00
           bt_ok:height-chars   in frame f_dlg_01_histor_clien = 01.00
           rt_cxcf:width-chars  in frame f_dlg_01_histor_clien = 63.57
           rt_cxcf:height-chars in frame f_dlg_01_histor_clien = 01.42
           rt_mold:width-chars  in frame f_dlg_01_histor_clien = 63.57
           rt_mold:height-chars in frame f_dlg_01_histor_clien = 05.58.
    /* set return-inserted = yes for editors */
    assign v_des_histor_clien:return-inserted in frame f_dlg_01_histor_clien = yes.
    /* set private-data for the help system */
    assign histor_clien.des_abrev_histor_clien:private-data in frame f_dlg_01_histor_clien = "HLP=000022190":U
           v_des_histor_clien:private-data                  in frame f_dlg_01_histor_clien = "HLP=000022051":U
           bt_ok:private-data                               in frame f_dlg_01_histor_clien = "HLP=000010721":U
           bt_can:private-data                              in frame f_dlg_01_histor_clien = "HLP=000011050":U
           frame f_dlg_01_histor_clien:private-data                                        = "HLP=000023615".

/* set return-inserted = yes for editors */

/* set private-data for the help system */

/* ** Tratamento para mostrar os representantes   */
DEFINE VARIABLE c-nome-rep AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-un  AS CHARACTER   NO-UNDO.

FUNCTION fn-desc-condicao RETURNS CHARACTER
  ( p-cond-pag AS INTEGER ) :
    
    FIND FIRST cond-pagto
        WHERE cond-pagto.cod-cond-pag = p-cond-pag NO-LOCK NO-ERROR.

    IF AVAILABLE cond-pagto THEN
        RETURN string(cond-pagto.cod-cond-pag, ">>9") + " - " + cond-pagto.descricao.
    ELSE
        RETURN "":U.

END FUNCTION.

FUNCTION fn-nf-devol RETURNS CHARACTER
  (c_cod_estab       AS CHAR,
   c_cod_espec_docto AS CHAR,
   c_cod_ser_docto   AS CHAR,
   c_cod_tit_acr     AS CHAR,
   c_cod_parcela     AS CHAR) :

    DEFINE VARIABLE v_log_antecip AS LOGICAL     NO-UNDO.

    ASSIGN c-nf-devol = "".
    
    FIND FIRST tit_acr NO-LOCK
         WHERE tit_acr.cod_estab   = c_cod_estab
           AND tit_acr.cod_espec   = c_cod_espec_docto
           AND tit_acr.cod_ser     = c_cod_ser_docto
           AND tit_acr.cod_tit_acr = c_cod_tit_acr
           AND tit_acr.cod_parcela = c_cod_parcela NO-ERROR.
    
    for first espec_docto fields(ind_tip_espec_docto) no-lock 
        where  espec_docto.cod_espec_docto = tit_acr.cod_espec_docto:
    end.
    if avail espec_docto then do:
        if espec_docto.ind_tip_espec_docto = "Antecipaá∆o" /*l_antecipacao*/  then 
            assign v_log_antecip = YES.
    end.
    
    find nota_devol_tit_acr no-lock
        where nota_devol_tit_acr.cod_estab       = tit_acr.cod_estab
          and nota_devol_tit_acr.cod_espec_docto = tit_acr.cod_espec_docto
          and nota_devol_tit_acr.cod_ser_docto   = tit_acr.cod_ser_docto
          and nota_devol_tit_acr.cod_tit_acr     = tit_acr.cod_tit_acr
          and nota_devol_tit_acr.cod_parcela     = tit_acr.cod_parcela
        no-error.
    if  avail nota_devol_tit_acr
    THEN DO:
          ASSIGN c-nf-devol = nota_devol_tit_acr.cod_nota_devol.
    END.
    
    if  v_log_antecip AND not avail nota_devol_tit_acr then do:
    
        FOR FIRST movto_tit_acr FIELDS(cod_estab num_id_movto_tit_acr) NO-LOCK
            WHERE  movto_tit_acr.cod_estab      = tit_acr.cod_estab
            AND    movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
            AND    movto_tit_acr.ind_trans_acr  = "Implantaá∆o a CrÇdito" /*l_implantacao_a_credito*/ :
        
            for first relacto_tit_acr fields(cod_estab num_id_tit_acr) no-lock
                where relacto_tit_acr.cod_estab_tit_acr_pai = movto_tit_acr.cod_estab
                and   relacto_tit_acr.num_id_movto_tit_acr  = movto_tit_acr.num_id_movto_tit_acr:
        
                for first b_tit_acr no-lock
                    where b_tit_acr.cod_estab      = relacto_tit_acr.cod_estab
                    and   b_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr:
                    find nota_devol_tit_acr no-lock
                        where nota_devol_tit_acr.cod_estab       = b_tit_acr.cod_estab
                          and nota_devol_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                          and nota_devol_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                          and nota_devol_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                          and nota_devol_tit_acr.cod_parcela     = b_tit_acr.cod_parcela
                        no-error.
                    if  avail nota_devol_tit_acr then do:
                         ASSIGN c-nf-devol = nota_devol_tit_acr.cod_nota_devol.
                    end /* if */.
                end.
            end.
        END.
    END.

    RETURN c-nf-devol.

END FUNCTION.

FUNCTION fn-nome-rep RETURNS CHARACTER
  ( p-cod-rep AS INTEGER ) :
    
    FIND FIRST repres
        WHERE repres.cod-rep = p-cod-rep NO-LOCK NO-ERROR.

    IF AVAILABLE repres THEN
        RETURN repres.nome-abrev.
    ELSE
        RETURN "":U.

END FUNCTION.

FUNCTION fn-desc-un RETURNS CHARACTER
  ( p-cod_unid_negoc AS CHARACTER ) :

    FIND FIRST unid-comerc NO-LOCK
        WHERE  unid-comerc.cd-unid-comerc = INT(p-cod_unid_negoc) NO-ERROR.
    IF  AVAIL  unid-comerc THEN
        RETURN unid-comerc.ds-unid-comerc.
    ELSE
        RETURN "".

END FUNCTION.

DEFINE QUERY qr_repres FOR 
       crm-relacionamento-cliente
        SCROLLING.

DEFINE BROWSE br_repres
  QUERY qr_repres DISPLAY
        fn-desc-un(crm-relacionamento-cliente.cd-unid-negoc) @ c-desc-un  COLUMN-LABEL "Unidade"     FORMAT "x(30)":U
        crm-relacionamento-cliente.cod-rep                                COLUMN-LABEL "Repres"      FORMAT ">>>,>>9"
        fn-nome-rep(crm-relacionamento-cliente.cod-rep)      @ c-nome-rep COLUMN-LABEL "Nome Repres" FORMAT "x(30)"
        crm-relacionamento-cliente.dt-vigencia-ini                        COLUMN-LABEL "Vig. Inicio" FORMAT "99/99/9999":U
        crm-relacionamento-cliente.dt-vigencia-fim                        COLUMN-LABEL "Vig. Fim"    FORMAT "99/99/9999":U
  WITH NO-ASSIGN SEPARATORS SIZE 71.50 BY 5.8.

def frame f_dlg_01_repres
    br_repres
         at row 01.20 col 02.00
    rt_cxcf
         at row 07.17 col 02.00 bgcolor 7 
    bt_ok
         at row 07.38 col 03.00 font ?
         help "OK"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 74.00 by 09.00 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Representantes".
    /* adjust size of objects in this frame */
    assign bt_ok:width-chars    in frame f_dlg_01_repres = 10.00
           bt_ok:height-chars   in frame f_dlg_01_repres = 01.00
           rt_cxcf:width-chars  in frame f_dlg_01_repres = 71.50
           rt_cxcf:height-chars in frame f_dlg_01_repres = 01.42.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_tt_saldo FOR 
      tt_saldo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_tt_saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_tt_saldo C-Win _FREEFORM
  QUERY br_tt_saldo DISPLAY
      tt_saldo.l-ok
      tt_saldo.cdn_cliente            COLUMN-LABEL "Cliente" FORMAT ">>>>>>>>9"
      tt_saldo.cod_estab              COLUMN-LABEL "Est"    FORMAT "x(04)"
      tt_saldo.cod_espec_docto        COLUMN-LABEL "Esp"    FORMAT "x(03)"
      tt_saldo.cod_ser_docto          COLUMN-LABEL "Ser"    FORMAT "x(03)"
      tt_saldo.cod_tit_acr            COLUMN-LABEL "T°tulo" FORMAT "x(20)"
      tt_saldo.cod_parcela            COLUMN-LABEL "/P"
      fn-nf-devol(tt_saldo.cod_estab, tt_saldo.cod_espec_docto, tt_saldo.cod_ser_docto, tt_saldo.cod_tit_acr, tt_saldo.cod_parcela) @ c-nf-devol COLUMN-LABEL "NF Devol" WIDTH 9 FORMAT "x(18)"
      tt_saldo.dat_emis_docto         COLUMN-LABEL "Emiss∆o"
      tt_saldo.dat_vencto_tit_acr     COLUMN-LABEL "Vencto"
      tt_saldo.dat_entrega            COLUMN-LABEL "Entrega"
      tt_saldo.dat_prev_entr          COLUMN-LABEL "Prev Entrega"
      tt_saldo.val_origin_tit_acr     COLUMN-LABEL "Vl. Orig."
      tt_saldo.val_sdo_tit_acr        COLUMN-LABEL "Vl. Cli."
      tt_saldo.num_atr                COLUMN-LABEL "Atr†s"     FORMAT '->>>9'
      tt_saldo.cod_portador           COLUMN-LABEL "Por"
      tt_saldo.cod_cart_bcia          COLUMN-LABEL "Cart"
      tt_saldo.cod_cond_cobr          COLUMN-LABEL "Cond"    FORMAT "x(03)"
      tt_saldo.cod_PO_cliente         COLUMN-LABEL "PO Cliente"
      tt_saldo.cod_tit_acr_bco        COLUMN-LABEL "Num Banco"
      tt_saldo.val_desp_cartorio      COLUMN-LABEL "Vl. Cart¢rio"
      tt_saldo.ind_sit_envio          COLUMN-LABEL "Status Envio"
      tt_saldo.cod_boleto_impresso    COLUMN-LABEL "Boleto Impresso"    
      tt_saldo.cod_perda              COLUMN-LABEL "Indic. Perda"
      tt_saldo.log_liq_perdas         COLUMN-LABEL "Liq. Perda"
      tt_saldo.num_planinha_vendor    COLUMN-LABEL "Plan Vend" FORMAT ">>>>9"
ENABLE tt_saldo.val_desp_cartorio
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 104.5 BY 12.5
         FONT 1 ROW-HEIGHT-CHARS .54 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btDet AT ROW 1.13 COL 18.57 HELP
          "Pesquisa"
     btZoom AT ROW 1.13 COL 22.57 HELP
          "Pesquisa"
     btFiltro AT ROW 1.13 COL 27.57 HELP
          "Pesquisa"
     btPrint AT ROW 1.13 COL 31.57 HELP
          "Pesquisa"
     btMail AT ROW 1.13 COL 35.57 HELP
          "Pesquisa"
     btSelec AT ROW 1.13 COL 41.57 HELP
          "Envio Acessoria"
     bt_historico_padrao AT ROW 1.13 COL 45.57 HELP
          "Hist¢rico do Cliente"
     bt_historico  AT ROW 1.13 COL 49.57 HELP
          "Hist¢rico do Cliente"
     bt-mod AT ROW 1.13 COL 55.57 HELP
          "Modifica CrÇdito"
     bt-can AT ROW 1.13 COL 59.57 HELP
          "Cancela Alteraá∆o"
     bt-sav AT ROW 1.13 COL 63.57 HELP
          "Confirma Alteraá∆o"
     bt_rel_cred AT ROW 1.13 COL 67.57  HELP
          "Relat¢rio An†lise CrÇdito"
     btGera AT ROW 1.13 COL 73.57 HELP
          "Pesquisa"
     btAcordo AT ROW 1.13 COL 77.57 HELP
          "Acordo Comercial"
     btMatriz AT ROW 1.13 COL 81.57 HELP
         "Matriz"
    btRegrasVencto AT ROW 1.13 COL 85.63 HELP
         "Regras de Vencimento"
    btTransfCred AT ROW 1.13 COL 89.7 HELP
          "Transferir CrÇdito"
     btExit AT ROW 1.13 COL 98.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 102.72 HELP
          "Ajuda"
    cod-cliente AT ROW 3.04 COL 7.57 COLON-ALIGNED HELP
          "C¢digo Cliente"
     btGoTo AT ROW 3.04 COL 29.86 HELP
          "V† Para"
     c-cliente AT ROW 3.04 COL 32 COLON-ALIGNED HELP
          "Nome Pessoa" NO-LABEL
     v_num_pessoa AT ROW 3.04 COL 92 COLON-ALIGNED
     c-fone AT ROW 4 COL 80 COLON-ALIGNED
          BGCOLOR 15 
     c-cidade AT ROW 4.04 COL 7.57 COLON-ALIGNED
          BGCOLOR 15 
     c-estado AT ROW 4.04 COL 42 COLON-ALIGNED
          LABEL "UF"
          BGCOLOR 15 
     v_rating AT ROW 4.04 COL 50.5 LABEL "Rating"
     bt-repres   AT ROW 5 COL 40
     v_log_top_milhao AT ROW 4.04 COL 63 LABEL "Top Milh∆o" VIEW-AS TOGGLE-BOX
     i-cod-grp-cobr AT ROW 5.04 COL 7.57 COLON-ALIGNED HELP
          "Grp Cobr"
     v_user_libcre AT ROW 5.04 COL 22 COLON-ALIGNED
     v_email AT ROW 5.04 COL 56.5 COLON-ALIGNED
     d-tot-orig AT ROW 8.15 COL 13.86 COLON-ALIGNED
          LABEL "Total Val Orig"
          BGCOLOR 15 
     d-tot-cliente AT ROW 8.15 COL 46.29 COLON-ALIGNED
          LABEL "Total Val Cliente"
          BGCOLOR 15 
     d-credito AT ROW 8.15 COL 80.14 COLON-ALIGNED
          LABEL "Total Val CrÇdito"
          BGCOLOR 15 
     v_vcto_mes      AT ROW 9.5 COL 80    COLON-ALIGNED
     v_sdo_vencido   AT ROW 9.5 COL 13.72 COLON-ALIGNED
     v_sdo_avencer   AT ROW 9.5 COL 46.29 COLON-ALIGNED

     rs-modo     AT ROW 06.50 COL 28.43 NO-LABEL
     

     rs-opcao                 AT ROW 11.19 COL 01.43 NO-LABEL
     v_log_mostra_perda_dedut AT ROW 11.39 COL 40    LABEL "Liquidaá∆o Perda Dedut°vel" VIEW-AS TOGGLE-BOX 
     br_tt_saldo              AT ROW 12.65 COL 01.59

    /*emitente.ind-cre-cli          AT ROW 08.40 COL 05   COLON-ALIGNED NO-LABEL*/
     cb-credito-cli                AT ROW 10.30 COL 05 COLON-ALIGNED
     b-emitente-matriz.lim-credito AT ROW 08.55 COL 38 COLON-ALIGNED LABEL "Limite CrÇdito Intelbras" VIEW-AS FILL-IN SIZE 11 BY .80
     b-emitente-matriz.dt-lim-cred AT ROW 08.55 COL 62 COLON-ALIGNED LABEL "Dt Lim CrÇd" VIEW-AS FILL-IN SIZE 11 BY .80
     d-tot-matriz                  AT ROW 08.55 COL 88 COLON-ALIGNED VIEW-AS FILL-IN SIZE 11 BY .80

     /*de-lim-tot-supcard            AT ROW 08.85 COL 25 COLON-ALIGNED
     de-lim-uti-supcard            AT ROW 08.85 COL 45 COLON-ALIGNED
     de-lim-uti-intelbras          AT ROW 08.85 COL 66 COLON-ALIGNED
     bt-det-supcard                AT ROW 08.85 COL 77 COLON-ALIGNED
     de-lim-disp-cli               AT ROW 08.85 COL 88 COLON-ALIGNED*/
     
     i-dias-atras-intelbras        AT ROW 08.55 COL 11.5 COLON-ALIGNED
     /*i-dias-atras-supcard          AT ROW 08.85 COL 11.5 COLON-ALIGNED*/

     br_ped      AT ROW 11.40 COL 1.6
     br_cond_esp AT ROW 17.20 COL 1.6
     br_antecip  AT ROW 17.20 COL 52

     bt-filtro  AT ROW 10.20 COL 24.5
     bt-aprova  AT ROW 10.20 COL 34.5
     bt-reprova AT ROW 10.20 COL 44.5
    
     d-tot-ped  AT ROW 20.90 COL 5 
     c-doc      AT ROW 20.90 COL 27 
     i-parc     AT ROW 20.90 COL 46 NO-LABEL

    
     int-ped-venda.dt-negociacao   AT ROW 20.90 COL 83 COLON-ALIGNED LABEL "Negociaá∆o" VIEW-AS FILL-IN SIZE 9.70 BY .88
     int-ped-venda.dias-negociacao AT ROW 20.90 COL 93 COLON-ALIGNED NO-LABEL           VIEW-AS FILL-IN SIZE 3.70 BY .88

     grp_clien.cod_grp_clien AT ROW 20.90 COL 64   COLON-ALIGNED LABEL "Grupo Cliente"

     ped-venda.desc-bloq-cr AT ROW 21.90 COL 3 LABEL "Mot Bloq CR"
                            VIEW-AS FILL-IN SIZE 86.35 BY 1
     ped-venda.observacoes  AT ROW 23.50 COL 01 COLON-ALIGNED NO-LABEL
                            VIEW-AS EDITOR  SCROLLBAR-VERTICAL SIZE 48 BY 1.7
     ped-venda.cond-espec  AT ROW 23.50 COL 50 COLON-ALIGNED NO-LABEL
                            VIEW-AS EDITOR  SCROLLBAR-VERTICAL SIZE 48 BY 1.7

     RECT-1     AT ROW 06.42 COL 1    BGCOLOR 7
     RECT-2     AT ROW 11.10 COL 1    BGCOLOR 7
     RECT-3     AT ROW 12.50 COL 1    BGCOLOR 7
     rect-4     AT ROW 07.80 COL 1    BGCOLOR 7
     rect-5     AT ROW 12.90 COL 1    BGCOLOR 7
     rect-6     AT ROW 12.90 COL 55.5 BGCOLOR 7
     rt-divisao AT ROW 13.10 COL 21.5 BGCOLOR 7
     v_tot_sel AT ROW 11.25 COL 79.8 COLON-ALIGNED
     
     rtParent AT ROW 2.71 COL 1
     rtParent-2 AT ROW 7.8 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 110 /*101.86*/ BY 26.37
         FONT 1.

/* CrÇdito do Cliente - Busca conforme est† no campo da tabela */
ASSIGN cb-credito-cli:LIST-ITEMS IN FRAME default-frame = {adinc/i10ad098.i 3}.

assign br_ped:COLUMN-MOVABLE   in frame DEFAULT-FRAME = yes
       br_ped:COLUMN-RESIZABLE in frame DEFAULT-FRAME = yes.

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta D°vidas Cliente - ESACR003 (1.00.00.010)"
         HEIGHT             = 24.45
         WIDTH              = 106
         MAX-HEIGHT         = 31.41
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 31.41
         VIRTUAL-WIDTH      = 146.29
         MAX-BUTTON         = no
         RESIZE             = no
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_tt_saldo
&ANALYZE-RESUME


ON CHOOSE OF bt_historico IN FRAME default-frame
DO:
    /*RUN esp/acr/esacr003g.w (INPUT v_cod_empres_usuar,
                               INPUT int(INPUT FRAME {&FRAME-NAME} cod-cliente)).*/

    RUN esp/acr/esacr003g.w (INPUT v_cod_empres_usuar,
                             INPUT TABLE tt-matriz).
END.

ON MOUSE-EXTEND-CLICK OF br_tt_saldo IN FRAME DEFAULT-FRAME
DO:

    apply 'mouse-select-click' to br_tt_saldo.
END.

ON MOUSE-SELECT-CLICK OF br_ped IN FRAME DEFAULT-FRAME
DO:

    run pi_mouse_select_click_br_ped.
END.

ON " " OF br_ped IN FRAME DEFAULT-FRAME
DO:

    apply 'mouse-select-click' to br_ped.
END.

ON "value-changed" OF br_ped IN FRAME DEFAULT-FRAME
DO:

    apply 'mouse-select-click' to br_ped.
END.


ON MOUSE-SELECT-CLICK OF br_tt_saldo IN FRAME DEFAULT-FRAME
DO:

    run pi_mouse_select_click.
END.

ON " " OF br_tt_saldo IN FRAME DEFAULT-FRAME
DO:

    apply 'mouse-select-click' to br_tt_saldo.
END.

ON START-SEARCH OF br_tt_saldo IN FRAME DEFAULT-FRAME
DO:
   def var hColumn as handle no-undo.
      assign hColumn = {&BROWSE-NAME}:current-column.
      if valid-handle(hColumn) then
      do:
         if hColumn:label = "T°tulo"  
            THEN ASSIGN l-titulo = YES.
            ELSE ASSIGN l-titulo = NO.
      end.
    {&open-query-{&browse-name}}
END.

/*
ON CHOOSE OF bt-det-supcard IN FRAME default-frame
DO:
    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cod-emitente = INT(INPUT FRAME {&FRAME-NAME} cod-cliente) NO-ERROR.
    IF  AVAIL  emitente THEN
        RUN esp/acr/esacr003e.w (INPUT SUBSTRING(emitente.cgc,1,8)).
END.*/
  
/* ************************  Control Triggers  ************************ */
def var l-abertos        as log  init yes    no-undo.
def var l-atend-total    as log  init no     no-undo.
def var l-atend-parcial  as log  init yes    no-undo.
def var l-suspensos      as log  init no     no-undo.
def var l-cancelados     as log  init no     no-undo.
def var c-lista          as char init "1,2"  no-undo.

def var l-avaliado       as logical init no  no-undo.
def var l-nao-avaliado   as logical init NO  no-undo.
def var l-aprovado       as logical init no  no-undo.
def var l-reprovado      as logical init yes no-undo.

def var l-ped-a-vista    as logical init YES no-undo.
def var l-bndes          as logical init NO  no-undo.
def var l-cond-ic        as logical init NO  no-undo.
def var l-cond-intelbras as logical init NO  no-undo.

def var c-aval as char init "4"              no-undo.

def var dt-implant-ini      as date     init &IF "{&ems_dbtype}":U = "MSS":U &THEN "01/01/1800":U &ELSE "01/01/0001":U &ENDIF no-undo.
def var dt-implant-fim      as date     init "12/31/9999" no-undo.
def var dt-entrega-ini      as date     init TODAY no-undo.
def var dt-entrega-fim      as date     init TODAY no-undo.
def var l-consid-dt-implant as logical  init no           no-undo.
def var l-consid-dt-entrega as logical  init no           no-undo.

def temp-table tt-cod-sit-aval NO-UNDO
  field i-sit-aval as int.


&Scoped-define SELF-NAME bt-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro B-table-Win
ON CHOOSE OF bt-filtro IN FRAME default-frame /* Filtro */
DO:
    Run esp/acr/esacr003d.p (input-output l-abertos,
                             input-output l-atend-total,
                             input-output l-atend-parcial,
                             input-output l-suspensos,    
                             input-output l-cancelados,    
                             input-output l-ok,
                             input-output l-avaliado,
                             input-output l-nao-avaliado,
                             input-output l-aprovado,
                             input-output l-reprovado,
                             input-output l-ped-a-vista,
                             input-output l-bndes,
                             input-output l-cond-ic,
                             input-output l-cond-intelbras,
                             input-output dt-implant-ini,
                             input-output dt-implant-fim,
                             input-output dt-entrega-ini,
                             input-output dt-entrega-fim).

    assign l-consid-dt-implant = (dt-implant-ini <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF OR dt-implant-fim <> 12/31/9999)
           l-consid-dt-entrega = (dt-entrega-ini <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF OR dt-entrega-fim <> 12/31/9999).

   If  l-ok then do:
       EMPTY TEMP-TABLE tt-situacao NO-ERROR.
       if l-abertos       THEN do: CREATE tt-situacao. ASSIGN tt-situacao.situacao = 1. END.
       if l-atend-parcial THEN do: CREATE tt-situacao. ASSIGN tt-situacao.situacao = 2. END.
       if l-atend-total   THEN do: CREATE tt-situacao. ASSIGN tt-situacao.situacao = 3. END.
       if l-suspensos     THEN do: CREATE tt-situacao. ASSIGN tt-situacao.situacao = 5. END.
       if l-cancelados    THEN do: CREATE tt-situacao. ASSIGN tt-situacao.situacao = 6. END.

       assign c-aval = "".
       if l-avaliado      then Assign c-aval  = c-aval  + "2".
       if l-nao-avaliado  then Assign c-aval  = c-aval  + ",1".
       if l-aprovado      then Assign c-aval  = c-aval  + ",3".
       if l-reprovado     then Assign c-aval  = c-aval  + ",4".

       EMPTY TEMP-TABLE tt-cod-sit-aval NO-ERROR.
       if l-avaliado     then do: create tt-cod-sit-aval.  assign tt-cod-sit-aval.i-sit-aval = 2. end.
       if l-nao-avaliado then do: create tt-cod-sit-aval.  assign tt-cod-sit-aval.i-sit-aval = 1. end.
       if l-aprovado     then do: create tt-cod-sit-aval.  assign tt-cod-sit-aval.i-sit-aval = 3. end.
       if l-reprovado    then do:  create tt-cod-sit-aval. assign tt-cod-sit-aval.i-sit-aval = 4. end.

       EMPTY TEMP-TABLE tt-cond-pagto NO-ERROR.
       IF  l-ped-a-vista THEN DO:
           FOR EACH cond-pagto NO-LOCK
              WHERE cond-pagto.cod-vencto = 2 /* A Vista */ :

              IF  NOT CAN-FIND(FIRST tt-cond-pagto
                               WHERE tt-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag) THEN DO:
                  CREATE tt-cond-pagto.
                  ASSIGN tt-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag.
              END.
           END. /* FOR EACH cond-pagto NO-LOCK */
       END.
       IF  l-bndes THEN DO:
           FOR EACH cond-pagto NO-LOCK
              WHERE cond-pagto.cod-cond-pag = 555 :

              IF  NOT CAN-FIND(FIRST tt-cond-pagto
                               WHERE tt-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag) THEN DO:
                  CREATE tt-cond-pagto.
                  ASSIGN tt-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag.
              END.
           END. /* FOR EACH cond-pagto NO-LOCK */
       END.
       IF  l-cond-ic THEN DO:
           FOR EACH cond-pagto NO-LOCK,
              FIRST int-cond-pagto NO-LOCK
              WHERE int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag:

              IF  SUBSTRING(int-cond-pagto.char-1, 4,1) NE 'S' THEN NEXT.

              IF  NOT CAN-FIND(FIRST tt-cond-pagto
                               WHERE tt-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag) THEN DO:
                  CREATE tt-cond-pagto.
                  ASSIGN tt-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag.
              END.
           END. /* FOR EACH cond-pagto NO-LOCK */
       END.
       IF  l-cond-intelbras THEN DO:
           FOR EACH cond-pagto NO-LOCK:

              /* Atende as demais situaá‰es que n∆o foram vistas nas opá‰es acima */
              IF cond-pagto.cod-vencto = 2 THEN NEXT.
              IF cond-pagto.cod-cond-pag = 555 THEN NEXT.

              FIND FIRST int-cond-pagto NO-LOCK
                  WHERE  int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag NO-ERROR.
              IF  AVAIL int-cond-pagto AND SUBSTRING(int-cond-pagto.char-1, 4,1) = 'S' THEN NEXT.
                

              IF  NOT CAN-FIND(FIRST tt-cond-pagto
                               WHERE tt-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag) THEN DO:
                  CREATE tt-cond-pagto.
                  ASSIGN tt-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag.
              END.
           END. /* FOR EACH cond-pagto NO-LOCK */
       END.

       OPEN QUERY br_ped
            FOR EACH tt-situacao NO-LOCK,
                EACH tt-matriz
               WHERE tt-matriz.cod-emitente >= c-clienteini
                 AND tt-matriz.cod-emitente <= c-clientefim,
               FIRST b-emitente-ped NO-LOCK
               WHERE b-emitente-ped.cod-emitente = tt-matriz.cod-emitente,
                EACH ped-venda USE-INDEX ch-credito
               WHERE ped-venda.nome-abrev    = b-emitente-ped.nome-abrev
                 AND   ped-venda.cod-sit-ped   = tt-situacao.situacao
                 AND   ped-venda.completo      = YES
                 AND  (ped-venda.cod-priori   >= 01
                 AND   ped-venda.cod-priori   <= 06)
                 AND   lookup(string(ped-venda.cod-sit-aval),c-aval) > 0
                 AND   ped-venda.cod-sit-aval <> 5
                 AND ((NOT l-consid-dt-implant)
                  OR   (l-consid-dt-implant
                 AND  (ped-venda.dt-implant >= dt-implant-ini
                 AND   ped-venda.dt-implant <= dt-implant-fim)))
                 AND ((NOT l-consid-dt-entrega)
                  OR   (l-consid-dt-entrega
                 AND  (ped-venda.dt-entrega >= dt-entrega-ini
                 AND   ped-venda.dt-entrega <= dt-entrega-fim)))
                 AND  ped-venda.origem <> 9 NO-LOCK,
               FIRST bf-int-ped-venda-br NO-LOCK
               WHERE bf-int-ped-venda-br.nr-pedido = ped-venda.nr-pedido,
               FIRST tt-cond-pagto 
               WHERE tt-cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag
                  BY ped-venda.nr-pedido
                  /*INDEXED-REPOSITION*/.

       END.

END.

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Consulta D°vidas Cliente - ESACR003 (1.00.00.010) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Consulta D°vidas Cliente - ESACR003 (1.00.00.010) */
DO:
/***********************************************************************************************
VERS«O 1.00.00.001 - Incluso Total a Vencer, Total Vencido e Valor Total Desp Cart¢rio;
                     Alterado de c¢digo de Representante para Nome abrev do mesmo;
                     Impress∆o por Data de Vencimento e T°tulo(Mario Fleith)
       1.00.00.002 - Envio de E-mail(Joe1)              
       1.00.00.003 - Corregaá∆o do Valor Origem para parcelas Vendor(Mario Fleith)              
       1.00.00.004 - Busca o valor original das parcelas vendor migrados do Magnus(Mario Fleith)              
************************************************************************************************/
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_tt_saldo
&Scoped-define SELF-NAME br_tt_saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_tt_saldo C-Win
ON CTRL-D OF br_tt_saldo IN FRAME DEFAULT-FRAME
DO:
  RUN pi-desmarca.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_tt_saldo C-Win
ON MOUSE-SELECT-DBLCLICK OF br_tt_saldo IN FRAME DEFAULT-FRAME
DO:
  ASSIGN v_rec_tit_acr = tt_saldo.rec_tit_acr.
  RUN prgfin/acr/acr212aa.p.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_tt_saldo C-Win
ON ROW-DISPLAY OF br_tt_saldo IN FRAME DEFAULT-FRAME
DO:

    IF  AVAIL tt_saldo
    AND tt_saldo.log_liq_perdas 
    THEN DO:
         ASSIGN tt_saldo.l-ok:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.cdn_cliente:BGCOLOR IN BROWSE {&browse-name} = 14 
                tt_saldo.cod_estab:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.cod_espec_docto:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.cod_ser_docto:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.cod_tit_acr:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.cod_parcela:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.dat_emis_docto:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.dat_vencto_tit_acr:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.dat_entrega:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.dat_prev_entr:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.val_origin_tit_acr:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.val_sdo_tit_acr:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.num_planinha_vendor:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.cod_PO_cliente:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.num_atr:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.cod_portador:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.cod_cart_bcia:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.cod_cond_cobr:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.cod_tit_acr_bco:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.val_desp_cartorio:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.ind_sit_envio:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.cod_boleto_impresso:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.cod_perda:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.log_liq_perdas:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                tt_saldo.val_desp_cartorio:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14
                c-nf-devol:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14.
    END.

    IF AVAIL tt_saldo THEN
        IF tt_saldo.l-ok = "*" THEN
            ASSIGN tt_saldo.l-ok:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.cdn_cliente:FGCOLOR IN BROWSE {&browse-name} = 12  
                   tt_saldo.cod_estab:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.cod_espec_docto:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.cod_ser_docto:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.cod_tit_acr:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.cod_parcela:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.dat_emis_docto:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.dat_vencto_tit_acr:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.dat_entrega:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.dat_prev_entr:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.val_origin_tit_acr:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.val_sdo_tit_acr:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.num_planinha_vendor:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.cod_PO_cliente:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.num_atr:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.cod_portador:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.cod_cart_bcia:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.cod_cond_cobr:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.cod_tit_acr_bco:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.val_desp_cartorio:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.ind_sit_envio:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.cod_boleto_impresso:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.cod_perda:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.log_liq_perdas:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   tt_saldo.val_desp_cartorio:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                   c-nf-devol:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
        ELSE
            ASSIGN tt_saldo.l-ok:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.cdn_cliente:FGCOLOR IN BROWSE {&browse-name} = ?   
                   tt_saldo.cod_estab:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.cod_espec_docto:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.cod_ser_docto:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.cod_tit_acr:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.cod_parcela:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.dat_emis_docto:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.dat_vencto_tit_acr:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.dat_entrega:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.dat_prev_entr:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.val_origin_tit_acr:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.val_sdo_tit_acr:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.num_planinha_vendor:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.cod_PO_cliente:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.num_atr:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.cod_portador:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.cod_cart_bcia:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.cod_cond_cobr:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.cod_tit_acr_bco:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.val_desp_cartorio:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.ind_sit_envio:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.cod_boleto_impresso:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.cod_perda:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.log_liq_perdas:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   tt_saldo.val_desp_cartorio:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?
                   c-nf-devol:FGCOLOR IN BROWSE {&BROWSE-NAME} = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRegrasVencto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRegrasVencto C-Win
ON CHOOSE OF btRegrasVencto IN FRAME DEFAULT-FRAME /* Atualiza */
DO:
   RUN esp/acr/esacr070.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btTransfCred
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTransfCred C-Win
ON CHOOSE OF btTransfCred IN FRAME DEFAULT-FRAME /* Atualiza */
DO:
    IF AVAIL tt_saldo THEN DO:
        GET CURRENT br_tt_saldo.

        RUN esp/acr/esacr003h.w (INPUT tt_saldo.cod_estab      ,
                                 INPUT tt_saldo.cod_espec_docto,
                                 INPUT tt_saldo.cod_ser_docto  ,
                                 INPUT tt_saldo.cod_tit_acr    ,
                                 INPUT tt_saldo.cod_parcela    ,
                                 INPUT tt_saldo.cdn_cliente).                

        RUN pi-display.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDet C-Win
ON CHOOSE OF btDet IN FRAME DEFAULT-FRAME /* Mail */
DO:
  RUN pi-detalhe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btDet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDet C-Win
ON CHOOSE OF bt-repres IN FRAME DEFAULT-FRAME /* Mail */
DO:

    IF AVAIL emscad.cliente 
    THEN DO:

         VIEW FRAME f_dlg_01_repres.

         DISPLAY br_repres
                 bt_ok
                 WITH FRAME f_dlg_01_repres.

         ENABLE ALL WITH FRAME f_dlg_01_repres.

         OPEN QUERY qr_repres FOR EACH crm-relacionamento-cliente NO-LOCK WHERE crm-relacionamento-cliente.cod-emitente = emscad.cliente.cdn_cliente.

         WAIT-FOR GO OF FRAME f_dlg_01_repres.

    END.
    HIDE FRAME f_dlg_01_repres.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_historico_padrao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_historico_padrao C-Win
ON CHOOSE OF bt_historico_padrao IN FRAME DEFAULT-FRAME /* Mail */
DO:
    /************************** Buffer Definition Begin *************************/

    def buffer b_histor_clien
        for histor_clien.


    /*************************** Buffer Definition End **************************/

    if avail emscad.cliente then do:
       main_block:
           do on endkey undo main_block, leave main_block on error undo main_block, leave main_block:
           create histor_clien. 
           assign histor_clien.cod_empresa = cliente.cod_empresa
                  histor_clien.cdn_cliente = cliente.cdn_cliente.

           find last b_histor_clien no-lock
                where b_histor_clien.cod_empresa = histor_clien.cod_empresa
                and   b_histor_clien.cdn_cliente = histor_clien.cdn_cliente no-error.
           if avail b_histor_clien then do:
               assign histor_clien.num_seq_histor_clien = b_histor_clien.num_seq_histor_clien + 1.
           end.
           else do:
               assign histor_clien.num_seq_histor_clien = 1.
           end.

           view frame f_dlg_01_histor_clien.

           display bt_can
                   bt_ok
                   v_des_histor_clien
                   histor_clien.des_abrev_histor_clien
                   with frame f_dlg_01_histor_clien.
           enable all with frame f_dlg_01_histor_clien.
           wait-for go of frame f_dlg_01_histor_clien.

           assign histor_clien.des_abrev_histor_clien = input frame f_dlg_01_histor_clien histor_clien.des_abrev_histor_clien
                  histor_clien.des_histor_clien       = input frame f_dlg_01_histor_clien v_des_histor_clien
                  histor_clien.dat_gerac_histor       = TODAY
                  histor_clien.hra_gerac_histor       = STRING(TIME,"hh:mm:ss")
                  histor_clien.cod_usuario            = v_cod_usuar_corren. 
                  
           if histor_clien.des_abrev_histor_clien = ''
           or histor_clien.des_histor_clien       = ''
           then do:
                MESSAGE "Hist¢rico Abreviado e Descriá∆o devem ser informados !" VIEW-AS ALERT-BOX ERROR.
                undo main_block, retry.
           end.
           
      end /* do main_block */.   
    end.
    hide frame f_dlg_01_histor_clien.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit C-Win
ON CHOOSE OF btExit IN FRAME DEFAULT-FRAME /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro C-Win
ON CHOOSE OF btFiltro IN FRAME DEFAULT-FRAME /* Mail */
DO:
  RUN pi-filter.
  RUN pi-display. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst C-Win
ON CHOOSE OF btFirst IN FRAME DEFAULT-FRAME /* First */
DO:
  RUN pi-first.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGera C-Win
ON CHOOSE OF btGera IN FRAME DEFAULT-FRAME /* Geracao */
DO:
    IF NOT CAN-FIND(FIRST tt_int_tit_acr) THEN
        MESSAGE "N∆o foi selecionado nenhum t°tulo para envio Ö assessoria." 
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    ELSE DO:
        RUN pi-geracao.
        RUN pi-display.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAcordo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAcordo C-Win
ON CHOOSE OF btAcordo IN FRAME DEFAULT-FRAME /* Acordo Comercial */
DO:

    IF AVAIL emscad.cliente THEN DO:
        ASSIGN h-esacr003 = THIS-PROCEDURE.
        RUN esp/utp/esutp025.w.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btAcordo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMatriz C-Win
ON CHOOSE OF btMatriz IN FRAME DEFAULT-FRAME /* Acordo Comercial */
DO:

    IF  AVAIL emscad.cliente THEN DO:

        FIND emitente NO-LOCK
            WHERE emitente.cod-emitente = emscad.cliente.cdn_cliente NO-ERROR.
        ASSIGN h-esacr003 = THIS-PROCEDURE.
        RUN esp/acr/esacr003f.w (INPUT emitente.nome-matriz,
                                 INPUT emitente.cod-emitente).
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo C-Win
ON CHOOSE OF btGoTo IN FRAME DEFAULT-FRAME /* Go To */
DO:
    RUN pi-gotorecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast C-Win
ON CHOOSE OF btLast IN FRAME DEFAULT-FRAME /* Last */
DO:
  RUN pi-last.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btMail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMail C-Win
ON CHOOSE OF btMail IN FRAME DEFAULT-FRAME /* Mail */
DO:
    RUN pi-email.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext C-Win
ON CHOOSE OF btNext IN FRAME DEFAULT-FRAME /* Next */
DO:
  RUN pi-next.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev C-Win
ON CHOOSE OF btPrev IN FRAME DEFAULT-FRAME /* Prev */
DO:
  RUN pi-prev.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrint
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrint C-Win
ON CHOOSE OF btPrint IN FRAME DEFAULT-FRAME /* Mail */
DO:
  RUN pi-print.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSelec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelec C-Win
ON CHOOSE OF btSelec IN FRAME DEFAULT-FRAME /* Atualiza */
DO:
  RUN pi-atualiza-int-tit-acr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btZoom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btZoom C-Win
ON CHOOSE OF btZoom IN FRAME DEFAULT-FRAME /* Mail */
DO:
  RUN pi-zoom.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-cliente C-Win
ON RETURN OF cod-cliente IN FRAME DEFAULT-FRAME /* Cliente */
DO:
  RUN pi-gotorecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miDetalhe C-Win
ON CHOOSE OF MENU-ITEM miDetalhe /* Detalhe */
DO:
  APPLY "CHOOSE" TO btDet IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miFaixa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miFaixa C-Win
ON CHOOSE OF MENU-ITEM miFaixa /* Faixa */
DO:
  APPLY "CHOOSE" TO btFiltro IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miFirst C-Win
ON CHOOSE OF MENU-ITEM miFirst /* Primeiro */
DO:
  APPLY "CHOOSE" TO btFirst IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME migeracao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL migeracao C-Win
ON CHOOSE OF MENU-ITEM migeracao /* Geraá∆o */
DO:
    APPLY "CHOOSE" TO btGera IN FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miacordo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miacordo C-Win
ON CHOOSE OF MENU-ITEM miacordo /* Acordo Comercial */
DO:
    APPLY "CHOOSE" TO btAcordo IN FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miLast C-Win
ON CHOOSE OF MENU-ITEM miLast /* Èltimo */
DO:
  APPLY "CHOOSE" TO btLast IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mimail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mimail C-Win
ON CHOOSE OF MENU-ITEM mimail /* Envia E-Mail */
DO:
    APPLY "CHOOSE" TO btMail IN FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miNext C-Win
ON CHOOSE OF MENU-ITEM miNext /* Pr¢ximo */
DO:
  APPLY "CHOOSE" TO btNext IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miPesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miPesquisa C-Win
ON CHOOSE OF MENU-ITEM miPesquisa /* Pesquisa */
DO:
  APPLY "CHOOSE" TO btZoom IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miPrev C-Win
ON CHOOSE OF MENU-ITEM miPrev /* Anterior */
DO:
  APPLY "CHOOSE" TO btPrev IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miRelat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miRelat C-Win
ON CHOOSE OF MENU-ITEM miRelat /* Relat¢rios */
DO:
  APPLY "CHOOSE" TO btPrint IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Desmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Desmarca C-Win
ON CHOOSE OF MENU-ITEM m_Desmarca /* Desmarca */
DO:
  RUN pi-desmarca.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-opcao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-opcao C-Win
ON VALUE-CHANGED OF rs-opcao IN FRAME DEFAULT-FRAME
DO:
   
   ASSIGN rs-opcao.

   if rs-opcao = 2  
       THEN ASSIGN l-titulo = YES.
       ELSE ASSIGN l-titulo = NO.

   {&OPEN-QUERY-{&BROWSE-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v_log_mostra_perda_dedut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v_log_mostra_perda_dedut C-Win
ON VALUE-CHANGED OF v_log_mostra_perda_dedut IN FRAME DEFAULT-FRAME
DO:
   
   ASSIGN v_log_mostra_perda_dedut.

   APPLY "CHOOSE" TO btgoto.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ** Gatilhos para a aprovaá∆o / reprovaá∆o dos pedidos ***/

def var l-inval-sit      as log  no-undo.
def var l-val-aprov      as log  no-undo.
def var i-cont           as int  no-undo. 
def var pe-quem-aprovou  like ped-venda.quem-aprovou no-undo.
def var c-pe-motivo      as char no-undo.
def var c-pe-motivo-no   as char no-undo.
def var pe-dt-apr-cred   like ped-venda.dt-apr-cred initial today no-undo.
def var c-pe-motivo-yes  as char no-undo.
def new Global shared var c-seg-usuario as char format "x(12)" no-undo.

DEF VAR h-bodi261         AS HANDLE                   NO-UNDO. 
DEF VAR h-bodi159cal      AS HANDLE                   NO-UNDO.

def temp-table tt-api-param no-undo
    field alocacao-pedidos as int /* 1-MantÇm 2-Aloca 3-Desaloca */
    field l-acomp          as logi
    field h-acomp          as handle.

def temp-table tt-aloc-ped-venda no-undo
    field i-sequen   as int
    field nome-abrev like ped-venda.nome-abrev
    field nr-pedcli  like ped-venda.nr-pedcli
    index ch-pedido is primary unique
        nome-abrev
        nr-pedcli.
        
def temp-table tt-aloc-ped-ent no-undo
    field nome-abrev   like ped-ent.nome-abrev
    field nr-pedcli    like ped-ent.nr-pedcli
    field nr-sequencia like ped-ent.nr-sequencia
    field it-codigo    like ped-ent.it-codigo
    field cod-refer    like ped-ent.cod-refer
    field nr-entrega   like ped-ent.nr-entrega
    field qt-a-alocar  as decimal
    index ch-item-ped is primary unique
        nome-abrev
        nr-pedcli
        nr-sequencia
        it-codigo
        cod-refer
        nr-entrega.
        
def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF TEMP-TABLE tt-ped-item-cotas NO-UNDO
    FIELD nr-sequencia AS INT 
    FIELD it-codigo    AS CHAR
    FIELD cod-refer    AS CHAR.

ON CHOOSE OF bt-aprova IN FRAME default-frame /* Aprovar */
DO:

    RUN pi-valida-condicao-esacr070.
    IF  RETURN-VALUE <> "OK" THEN
        RETURN NO-APPLY.

    /* Seleciona usu†rio autorizados para aprovar pedido */
    RUN esp\es0018p.p (INPUT "esacr003", /* Nome do programa */
                       INPUT 2,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FIND tt-prog-ponto WHERE 
         tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.
    IF NOT AVAIL tt-prog-ponto 
    THEN DO:
         MESSAGE "Usu†rio n∆o possui permiss∆o para Aprovar Pedidos" VIEW-AS ALERT-BOX WARNING.
         RETURN NO-APPLY.
    END.
    
    run pi-permissao-usuario(input 1).
    if  return-value = "NOK" then
        return NO-APPLY.

    assign l-inval-sit = no
           l-val-aprov = no.

    if  br_ped:num-selected-rows in frame default-frame > 0  
    then do:
        if  locked ped-venda 
        then do:
            MESSAGE "Este pedido est† em uso por outro usu†rio." SKIP
                    "No momento outro usu†rio esta usando este mesmo pedido." VIEW-AS ALERT-BOX.
            return no-apply.
        end.
        do  i-cont = 1 to br_ped:num-selected-rows:
            if  br_ped:fetch-selected-row (i-cont) then
            do:

                FIND emitente NO-LOCK 
                    WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

                if emitente.ind-cre-cli = 4 then do:
                    MESSAGE "Cliente com crÇdito suspenso." VIEW-AS ALERT-BOX.
                    return 'no-apply'.
                end.

                FIND FIRST bf-int-ped-venda
                    WHERE bf-int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.

                IF AVAILABLE bf-int-ped-venda        /* AND
                   NOT bf-int-ped-venda.liberacao-forcada*/ THEN DO:
                    ASSIGN l-atraso-pagto = NO.

                    FIND FIRST natur-oper
                        WHERE natur-oper.nat-operacao = ped-venda.nat-operacao NO-LOCK NO-ERROR.

                    /* S¢ valida os dias de atraso para os pedidos que geram duplicatas (n∆o s∆o de garantia, p¢s-venda, etc) */
                    IF AVAILABLE natur-oper    AND
                       natur-oper.emite-duplic THEN DO:
                        FIND LAST int-param-supcard NO-LOCK NO-ERROR.

                        IF AVAILABLE int-param-supcard THEN DO:
                            RUN esp/acr/esacr043.p (INPUT  SUBSTRING(emitente.cgc, 1, 8),
                                                    INPUT  emitente.nome-matriz,
                                                    INPUT  int-param-supcard.qtd-dias-atraso,
                                                    OUTPUT i-dias-atraso-tit,
                                                    OUTPUT l-tit-atrasado,
                                                    OUTPUT c-lista-clientes).

                            IF l-tit-atrasado THEN DO:
                                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                   INPUT 17006,
                                                   INPUT "O cliente possui t°tulos em atraso com a Intelbras":U +
                                                         "~~":U +
                                                         "O cliente possui t°tulos em atraso com a Intelbras de atÇ ":U + TRIM(STRING(i-dias-atraso-tit)) + 
                                                         " dias. A tolerancia Ç de ":U + TRIM(STRING(int-param-supcard.qtd-dias-atraso)) + 
                                                         " dias de atraso.":U + CHR(13) + "Cliente(s): ":U + CHR(13) + c-lista-clientes).

                                ASSIGN l-atraso-pagto = YES.
                            END. /* IF l-tit-atrasado THEN DO: */

                            IF NOT l-atraso-pagto THEN DO:
                                RUN esp/acr/esacr061.p (INPUT  emitente.nome-matriz,
                                                        INPUT  int-param-supcard.qtd-dias-atraso,
                                                        OUTPUT i-dias-atraso-tit,
                                                        OUTPUT l-tit-atrasado).
    
                                IF l-tit-atrasado THEN DO:
                                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                       INPUT 27100,
                                                       INPUT "O cliente possui t°tulos em atraso com a Intelbras. Confirma aprovaá∆o?":U +
                                                             "~~":U +
                                                             "O cliente possui t°tulos em atraso com a Intelbras de atÇ ":U + TRIM(STRING(i-dias-atraso-tit)) + " dias. A tolerancia Ç de ":U + TRIM(STRING(int-param-supcard.qtd-dias-atraso)) + " dias de atraso.":U).

                                    IF RETURN-VALUE = "YES":U THEN
                                        ASSIGN l-atraso-pagto = NO.
                                    ELSE
                                        ASSIGN l-atraso-pagto = YES.
                                END. /* IF l-tit-atrasado THEN DO: */
                            END.
                        END. /* IF AVAILABLE int-param-supcard THEN DO: */
                    END. /* IF AVAILABLE natur-oper    AND
                               natur-oper.emite-duplic THEN DO: */

                    /* Validaá∆o de T°tulos em Atraso com o "Cart∆o Intelbras Clube" (SupplierCard) - Fabiano Sakae Ribeiro (Exponencial TI) - In°cio */
                    IF NOT l-atraso-pagto THEN DO:
                        FIND FIRST int-emitente-supcard
                            WHERE int-emitente-supcard.raiz-cnpj      = SUBSTRING(emitente.cgc, 1, 8) /* Busca somente pela raiz do CNPJ (8 primeiros d°gitos) */
                              AND int-emitente-supcard.dat-avaliacao  = TODAY /* Sempre verificar o de hoje */
                              AND int-emitente-supcard.log-habilitado = YES EXCLUSIVE-LOCK NO-ERROR.

                        IF AVAILABLE int-emitente-supcard THEN DO:
                            /* Verificando se o cliente est† em atraso com o SupplierCard e se est† dentro do tolerado pela Intelbras - In°cio */
                            IF int-emitente-supcard.qtd-dias-atraso-sc > 0 THEN DO:
                                IF int-emitente-supcard.qtd-dias-atraso-int <> 0 AND
                                   int-emitente-supcard.qtd-dias-atraso-int <> ? THEN DO:
                                    IF int-emitente-supcard.qtd-dias-atraso-int < int-emitente-supcard.qtd-dias-atraso-sc THEN DO:
                                        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                           INPUT 17006,
                                                           INPUT "O cliente est† em atraso com o cart∆o Intelbras Clube":U +
                                                                 "~~":U +
                                                                 "O cliente est† ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-sc)) + " dias em atraso com o cart∆o Intelbras Clube. A tolerancia Ç de ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-int)) + " dias de atraso.":U).

                                        ASSIGN l-atraso-pagto = YES.
                                    END. /* IF int-emitente-supcard.qtd-dias-atraso-int < int-emitente-supcard.qtd-dias-atraso-sc THEN DO: */
                                END. /* IF int-emitente-supcard.qtd-dias-atraso-int <> 0 AND
                                           int-emitente-supcard.qtd-dias-atraso-int <> ? THEN DO: */
                                ELSE DO:
                                    FIND LAST int-param-supcard NO-LOCK NO-ERROR.

                                    IF AVAILABLE int-param-supcard THEN DO:
                                        IF int-param-supcard.qtd-dias-atraso < int-emitente-supcard.qtd-dias-atraso-sc THEN DO:
                                            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                               INPUT 17006,
                                                               INPUT "O cliente est† em atraso com o cart∆o Intelbras Clube":U +
                                                                     "~~":U +
                                                                     "O cliente est† ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-sc)) + " dias em atraso com o cart∆o Intelbras Clube. A tolerancia Ç de ":U + TRIM(STRING(int-param-supcard.qtd-dias-atraso)) + " dias de atraso.":U).

                                            ASSIGN l-atraso-pagto = YES.
                                        END. /* IF int-param-supcard.qtd-dias-atraso < int-emitente-supcard.qtd-dias-atraso-sc THEN DO: */
                                    END. /* IF AVAILABLE int-param-supcard THEN DO: */
                                END. /* ELSE DO: - IF int-emitente-supcard.qtd-dias-atraso-int <> 0 AND
                                                      int-emitente-supcard.qtd-dias-atraso-int <> ? THEN DO: */
                            END. /* IF int-emitente-supcard.qtd-dias-atraso-sc > 0 THEN DO: */
                            /* Verificando se o cliente est† em atraso com o SupplierCard e se est† dentro do tolerado pela Intelbras - Final */

                            /* Verificando se o cliente est† em atraso com os t°tulos da Intelbras e se est† dentro do tolerado pela Intelbras - In°cio */
                            IF NOT l-atraso-pagto THEN DO:
                                IF int-emitente-supcard.qtd-dias-atraso-int <> 0 AND
                                   int-emitente-supcard.qtd-dias-atraso-int <> ? THEN DO:
                                    RUN esp/acr/esacr043.p (INPUT  int-emitente-supcard.raiz-cnpj,
                                                            INPUT  emitente.nome-matriz,
                                                            INPUT  int-emitente-supcard.qtd-dias-atraso-int,
                                                            OUTPUT i-dias-atraso-tit,
                                                            OUTPUT l-tit-atrasado,
                                                            OUTPUT c-lista-clientes).

                                    IF l-tit-atrasado THEN DO:
                                        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                           INPUT 17006,
                                                           INPUT "O cliente possui t°tulos em atraso com a Intelbras":U +
                                                                 "~~":U +
                                                                 "O cliente possui t°tulos em atraso com a Intelbras de atÇ ":U + TRIM(STRING(i-dias-atraso-tit)) + 
                                                                 " dias. A tolerancia Ç de ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-int)) + 
                                                                 " dias de atraso.":U + CHR(13) + "Cliente(s): ":U + CHR(13) + c-lista-clientes).

                                        ASSIGN l-atraso-pagto = YES.
                                    END. /* IF l-tit-atrasado THEN DO: */
                                END. /* IF int-emitente-supcard.qtd-dias-atraso-int <> 0 AND
                                           int-emitente-supcard.qtd-dias-atraso-int <> ? THEN DO: */
                            END. /* IF NOT l-atraso-pagto THEN DO: */
                            /* Verificando se o cliente est† em atraso com os t°tulos da Intelbras e se est† dentro do tolerado pela Intelbras - Final */
                        END. /* IF AVAILABLE int-emitente-supcard THEN DO: */
                    END. /* IF NOT l-atraso-pagto THEN DO: */
                    /* Validaá∆o de T°tulos em Atraso com o "Cart∆o Intelbras Clube" (SupplierCard) - Fabiano Sakae Ribeiro (Exponencial TI) - Final */

                    IF l-atraso-pagto THEN
                        RETURN NO-APPLY.
                END. /* IF AVAILABLE bf-int-ped-venda         AND
                           NOT bf-int-ped-venda.liber-forcada THEN DO: */

                if  ped-venda.cod-sit-ped <= 2 then do:
                    assign l-inval-sit = yes.
                    if  ped-venda.cod-sit-aval <> 3 then do:
                        assign l-val-aprov = yes.
                        leave.
                    end.
                end.
            end.
        end.
        if  (l-inval-sit = yes and l-val-aprov = no) then do:
            MESSAGE "Pedido j† est† aprovado." VIEW-AS ALERT-BOX.
            return 'no-apply'.
        end.
        else
            if  l-inval-sit = no then do:
                MESSAGE "Pedido com situaá∆o inv†lida para aprovaá∆o." SKIP
                        "Pedido esta com situaá∆o inv†lida para aprovaá∆o." VIEW-AS ALERT-BOX.
                 return no-apply.
            end.     

        if  session:set-wait-state ("general") then.

        assign pe-quem-aprovou = ped-venda.quem-aprovou
               c-pe-motivo     = " "
               c-pe-motivo-no  = " ".

        /* ** 505
        run pdp/pd0802c.w (input-output pe-quem-aprovou,
                           input-output pe-dt-apr-cred,
                           input-output c-pe-motivo,
                           input-output c-pe-motivo-yes,
                           output l-ok).
                 ***/
        run cmp/cm0201c.w (input-output pe-quem-aprovou,
                           input-output pe-dt-apr-cred,
                           input-output c-pe-motivo,
                           input-output c-pe-motivo-yes,
                           output l-ok).


        assign l-inval-sit = no.

        if  l-ok = yes then do:
            aprova:
            do trans i-cont = 1 to br_ped:num-selected-rows on error undo, next:

                if  br_ped:fetch-selected-row (i-cont) then do:
                    run pi-aprova. 

                    /* Alocaá∆o F°sica/L¢gica */
                    find first para-ped no-lock no-error.
                    if para-ped.int-2 = 1 /* Automatica */ then do:
                        
                        
                        if   para-ped.tp-aloca-ped  > 1 /* Alocacao Fisica ou Logica  */ 
                        and  para-ped.int-1 = 1 /* On-Line */ 
                        and (para-ped.int-2 = 1 /* Automatica */ 
                         or (para-ped.int-2 = 2 /*manual*/ and para-ped.tp-aloca-ped = 2))     then do:
                            &if defined(pdapi002) = 0 &then
                                &global-define pdapi002
                                define variable h-aloc as handle no-undo.
                                define variable de-qt-a-alocar as decimal no-undo.
                            &endif

                            run pdp/pdapi002.p persistent set h-aloc.  
                            create tt-api-param.
                            assign tt-api-param.alocacao-pedidos = 2
                                   tt-api-param.l-acomp  =  no.

                            create tt-aloc-ped-venda.
                            assign tt-aloc-ped-venda.i-sequen   = 1
                                   tt-aloc-ped-venda.nome-abrev =  ped-venda.nome-abrev
                                   tt-aloc-ped-venda.nr-pedcli  =  ped-venda.nr-pedcli.

                            run pi-alocacao in h-aloc ( input  1,
                                                        input  table tt-api-param,
                                                        input  table tt-aloc-ped-venda,
                                                        input  table tt-aloc-ped-ent,
                                                        output table tt-erro).

                           for each tt-api-param:
                               delete tt-api-param.
                           end.
                           for each tt-aloc-ped-venda:
                               delete tt-aloc-ped-venda.
                           end. 
                           delete procedure h-aloc.

                        end.

                    end.
                    /* Chamada da upc 
                    run pi-epc('APROVACAO', 
                               THIS-PROCEDURE,
                               "PED-VENDA",
                               rowid(ped-venda)).
                    if  return-value = 'adm-error' then do:
                        if  session:set-wait-state (" ") then. 
                        undo aprova, next aprova.
                    end.                */
                end.
            end.

            find first para-ped no-lock no-error. /* deixar esta linha por causa do undo aprova */
            
            OPEN QUERY br_ped
                 FOR EACH tt-situacao NO-LOCK,
                     EACH tt-matriz
                    WHERE tt-matriz.cod-emitente >= c-clienteini
                      AND tt-matriz.cod-emitente <= c-clientefim,
                    FIRST b-emitente-ped NO-LOCK
                    WHERE b-emitente-ped.cod-emitente = tt-matriz.cod-emitente,
                      EACH ped-venda USE-INDEX ch-credito
                      WHERE ped-venda.nome-abrev    = b-emitente-ped.nome-abrev
                      AND   ped-venda.cod-sit-ped   = tt-situacao.situacao
                      AND   ped-venda.completo      = YES
                      AND  (ped-venda.cod-priori   >= 01
                      AND   ped-venda.cod-priori   <= 06)
                      AND   lookup(string(ped-venda.cod-sit-aval),c-aval) > 0
                      AND   ped-venda.cod-sit-aval <> 5
                      AND ((NOT l-consid-dt-implant)
                      OR   (l-consid-dt-implant
                      AND  (ped-venda.dt-implant >= dt-implant-ini
                      AND   ped-venda.dt-implant <= dt-implant-fim)))
                      AND ((NOT l-consid-dt-entrega)
                      OR   (l-consid-dt-entrega
                      AND  (ped-venda.dt-entrega >= dt-entrega-ini
                      AND   ped-venda.dt-entrega <= dt-entrega-fim)))
                      AND   ped-venda.origem <> 9 NO-LOCK,
                      FIRST bf-int-ped-venda-br NO-LOCK
                      WHERE bf-int-ped-venda-br.nr-pedido = ped-venda.nr-pedido,
                      FIRST tt-cond-pagto
                      WHERE tt-cond-pagto.cod-cond-pag = tt-cond-pagto.cod-cond-pag
                BY ped-venda.nr-pedido
          /*INDEXED-REPOSITION*/.

     if  l-inval-sit then do:
         MESSAGE "Pedido com situaá∆o inv†lida para aprovaá∆o." SKIP
                 "Existe pelo menos um pedido selecionado que est† com situaá∆o inv†lida para aprovaá∆o. O pedido que esta com situaá∆o valida foi aprovado." VIEW-AS ALERT-BOX.
         return no-apply.
     end.
end.

        if  session:set-wait-state (" ") then.

    end.
END.

ON CHOOSE OF bt-reprova IN FRAME default-frame /* Reprovar */
DO:

   def vari h-aloc as handle no-undo.

   /* Seleciona usu†rio autorizados para reprovar pedido */
   RUN esp\es0018p.p (INPUT "esacr003", /* Nome do programa */
                      INPUT 3,          /* Ponto do programa */
                      INPUT 0,
                      INPUT "",
                      OUTPUT TABLE tt-prog-ponto) NO-ERROR.
   FIND tt-prog-ponto WHERE 
        tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.
   IF NOT AVAIL tt-prog-ponto 
   THEN DO:
        MESSAGE "Usu†rio n∆o possui permiss∆o para Reprovar Pedidos" VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
   END.

   run pi-permissao-usuario(input 2).
   if  return-value = "NOK" then
       return NO-APPLY.

   assign l-inval-sit = no
          l-val-aprov = yes.

   if  br_ped:num-selected-rows in frame default-frame > 0 then do:
       if  locked ped-venda then do:
           MESSAGE "Este pedido est† em uso por outro usu†rio." SKIP
                   "No momento outro usu†rio esta usando este mesmo pedido." VIEW-AS ALERT-BOX.
           return no-apply.
       end.
       do  i-cont = 1 to br_ped:num-selected-rows:
           if  br_ped:fetch-selected-row (i-cont) then
           do:
                
                find current ped-venda NO-LOCK NO-ERROR.

                FIND emitente NO-LOCK 
                    WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
                
                if emitente.ind-cre-cli = 4 then do:
                    MESSAGE "Cliente com crÇdito suspenso." VIEW-AS ALERT-BOX.
                    return 'no-apply'.
                end.

                if  can-find (first ped-ent
                      where ped-ent.nome-abrev = ped-venda.nome-abrev
                        and ped-ent.nr-pedcli  = ped-venda.nr-pedcli
                        and ped-ent.qt-alocada > ped-ent.qt-atendida) THEN do:
                    MESSAGE "Existem embarques alocados para este pedido." VIEW-AS ALERT-BOX.
                    return 'no-apply'.
                end.

                if  ped-venda.cod-sit-ped <> 3 then do:
                    assign l-inval-sit = yes.
                    if  ped-venda.cod-sit-aval <> 4 then do:
                        assign l-val-aprov = no.
                        leave.
                    end.
                end.
           end.
       end.
/*        if  (l-inval-sit = yes and l-val-aprov = yes) then do:      */
/*            MESSAGE "Pedido j† est† Reprovado." VIEW-AS ALERT-BOX.  */
/*            return 'no-apply'.                                      */
/*        end.                                                        */
/*        else                                                        */
           if  l-inval-sit = no then do:
               MESSAGE "Pedido totalmente atendido" VIEW-AS ALERT-BOX.  
               return 'no-apply'.
           end.

       if  session:set-wait-state ("general") then.

       assign pe-quem-aprovou = ped-venda.quem-aprovou
              c-pe-motivo     = " "
              c-pe-motivo-no  = " ".

       /* ** 505
       run pdp/pd0802b.w (input-output pe-quem-aprovou,
                          input-output pe-dt-apr-cred,
                          input-output c-pe-motivo,
                          input-output c-pe-motivo-no,
                          output l-ok ).
                ***/

       
      run cmp/cm0201b.w (input-output pe-quem-aprovou,
                         input-output pe-dt-apr-cred,
                         input-output c-pe-motivo,
                         input-output c-pe-motivo-no,
                         output l-ok ).
      
      IF   l-ok = YES 
      AND (l-inval-sit = yes and l-val-aprov = yes) THEN DO:
          DO  i-cont = 1 to br_ped:num-selected-rows:
              IF  br_ped:fetch-selected-row (i-cont) then
              DO:
                  find current ped-venda NO-LOCK NO-ERROR.
                  RUN pi-grava-historico-credito (INPUT ped-venda.nome-abrev,
                                                  INPUT ped-venda.nr-pedcli,   
                                                  INPUT pe-dt-apr-cred,
                                                  INPUT pe-quem-aprovou,
                                                  INPUT c-pe-motivo,
                                                  INPUT ped-venda.cod-sit-aval).  

                  DISP ped-venda.desc-bloq-cr WHEN AVAIL ped-venda  with frame default-frame.

              END.
          END.
      END.
      

      if  l-ok = YES 
      AND NOT (l-inval-sit = yes and l-val-aprov = yes) then do:   
          reprova:
          do trans i-cont = 1 to br_ped:num-selected-rows on error undo, next:
              if br_ped:fetch-selected-row (i-cont) then do:              
                 run pi-reprova.       

                 find first para-ped no-lock no-error. /* deixar esta linha por causa do undo aprova */

                 /* Desalocaá∆o F°sica/L¢gica */  /* RETIRADO POR SOLICITACAO CONFORME CHAMADO 62450 */
/*                  if  para-ped.int-1 = 1 /* ALOCAÄ«O ON-LINE */ and                                                                        */
/*                      para-ped.tp-aloca-ped > 1 and                                                                                        */
/*                      ped-venda.esp-ped = 1 AND /* PEDIDO FECHADO */                                                                       */
/*                      substring(ped-venda.nat-operacao,1,1) <> "7" then do: /* Caso for exportaá∆o n∆o dever† desalocar - Chamado 59687 */ */
/*                      run pdp/pdapi002.p persistent set h-aloc.                                                                            */
/*                                                                                                                                           */
/*                      for each ped-ent of ped-venda no-lock:                                                                               */
/*                          if  ped-ent.qt-log-aloca = 0 then next.                                                                          */
/*                          if  para-ped.tp-aloca-ped = 2 then                                                                               */
/*                              run pi-desaloca-logica in h-aloc (rowid(ped-ent),                                                            */
/*                                                                ped-ent.qt-log-aloca). /* Qtde Ö Desalocar */                              */
/*                          else if  para-ped.tp-aloca-ped = 3 then                                                                          */
/*                              run pi-desaloca-fisica-aut in h-aloc (rowid(ped-ent),                                                        */
/*                                                                    ped-ent.qt-log-aloca). /* Qtde Ö Desalocar */                          */
/*                      end.                                                                                                                 */
/*                      delete procedure h-aloc.                                                                                             */
/*                  end.                                                                                                                     */

                 /* Chamada da upc 
                 run pi-epc('REPROVACAO', 
                            THIS-PROCEDURE,
                            "PED-VENDA",
                            rowid(ped-venda)).
                 if  return-value = 'adm-error':U then do:
                     if  session:set-wait-state (" ":U) then. 
                     undo reprova, next reprova.
                 end.                */
              end.  
          end.
          
          OPEN QUERY br_ped
               FOR EACH tt-situacao NO-LOCK,
                   EACH tt-matriz
                  WHERE tt-matriz.cod-emitente >= c-clienteini
                    AND tt-matriz.cod-emitente <= c-clientefim,
                  FIRST b-emitente-ped NO-LOCK
                  WHERE b-emitente-ped.cod-emitente = tt-matriz.cod-emitente,
                   EACH ped-venda USE-INDEX ch-credito
                   WHERE ped-venda.nome-abrev    = b-emitente-ped.nome-abrev
                   AND   ped-venda.cod-sit-ped   = tt-situacao.situacao
                   AND   ped-venda.completo      = YES
                   AND  (ped-venda.cod-priori   >= 01
                   AND   ped-venda.cod-priori   <= 06)
                   AND   lookup(string(ped-venda.cod-sit-aval),c-aval) > 0
                   AND   ped-venda.cod-sit-aval <> 5
                   AND ((NOT l-consid-dt-implant)
                   OR   (l-consid-dt-implant
                   AND  (ped-venda.dt-implant >= dt-implant-ini
                   AND   ped-venda.dt-implant <= dt-implant-fim)))
                   AND ((NOT l-consid-dt-entrega)
                   OR   (l-consid-dt-entrega
                   AND  (ped-venda.dt-entrega >= dt-entrega-ini
                   AND   ped-venda.dt-entrega <= dt-entrega-fim)))
                   AND   ped-venda.origem <> 9 NO-LOCK,
                   FIRST bf-int-ped-venda-br NO-LOCK
                   WHERE bf-int-ped-venda-br.nr-pedido = ped-venda.nr-pedido,
                   FIRST tt-cond-pagto NO-LOCK
                        BY ped-venda.nr-pedido
                   /*INDEXED-REPOSITION*/.
      end.

      if session:set-wait-state (" ") then. 

   end.   

END.


/* ** Fim - Gatilhos para a aprovaá∆o / reprovaá∆o dos pedidos ***/


/* ** Gatilhos para a alteraá∆o da an†lise de crÇdito ***/
ON CHOOSE OF bt-mod IN FRAME default-frame
DO:

    IF NOT AVAIL emitente 
       THEN RETURN NO-APPLY.
    IF NOT AVAIL b-emitente-matriz 
       THEN RETURN NO-APPLY.

    /* Seleciona usu†rio autorizados para alterar */
    RUN esp\es0018p.p (INPUT "esacr003", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FIND tt-prog-ponto WHERE 
         tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.
    IF NOT AVAIL tt-prog-ponto 
    THEN DO:
         MESSAGE "Usu†rio n∆o possui permiss∆o para alterar as informaá‰es" SKIP
                 "relacionadas a An†lise de CrÇdito" VIEW-AS ALERT-BOX WARNING.
         RETURN NO-APPLY.
    END.

    FIND CURRENT b-emitente-matriz EXCLUSIVE-LOCK.
    FIND CURRENT emitente          EXCLUSIVE-LOCK.

    ASSIGN c-obs = b-emitente-matriz.observacoes.

    DISABLE bt-mod 
            rs-modo WITH FRAME default-frame.

    /*desabilitar todos os botoes e campos da tela que nao sejam da analise de credito*/
    DISABLE btFirst
            btPrev
            btNext
            btLast
            btDet
            btZoom
            btFiltro
            btPrint
            btMail
            btRegrasVencto
            btTransfCred
            btSelec
            bt_historico_padrao
            bt_historico
            bt_rel_cred
            btGera
            btAcordo
            btMatriz
            btExit
            btHelp
            cod-cliente
            btGoTo 
            bt-filtro
            bt-aprova
            bt-reprova
            bt-repres WITH FRAME default-frame.

    ENABLE bt-can
           bt-sav 
           /*emitente.ind-cre-cli*/
           cb-credito-cli
           b-emitente-matriz.lim-credito
           b-emitente-matriz.dt-lim-cred
           i-dias-atras-intelbras
           i-cod-grp-cobr
           v_log_top_milhao
           v_rating           
           WITH FRAME default-frame.

END.


ON CHOOSE OF bt-sav IN FRAME default-frame
DO:
    
    def buffer b_histor_clien
        for histor_clien.

    IF DEC(b-emitente-matriz.lim-credito:SCREEN-VALUE IN FRAME default-frame) <> 0 THEN DO:
         IF date(b-emitente-matriz.dt-lim-cred:SCREEN-VALUE IN FRAME default-frame) = ? 
         THEN DO:
              MESSAGE "Data deve ser informada." SKIP
                      "Data deve ser informada para Limite de CrÇdito maior que zero !" VIEW-AS ALERT-BOX.
              APPLY "entry" TO b-emitente-matriz.dt-lim-cred.
              RETURN NO-APPLY.
         END.
    END.

    IF  INT(i-dias-atras-intelbras:SCREEN-VALUE IN FRAME default-frame) > i-dias-atraso-param-sc THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Dias de Atraso superior aos dias informados nos parÉmetros da SupplierCard.~~" +
                                 "Dias de Atraso Intelbras est† superior ao limite dos parÉmetros. Limite: " + STRING(i-dias-atraso-param-sc) + " dias.").

        APPLY "ENTRY":U TO i-dias-atras-intelbras IN FRAME default-frame.
        RETURN NO-APPLY.
    END.

    IF  v_rating:SCREEN-VALUE IN FRAME default-frame <> "" THEN DO:
        DO  i-cont-rating = 1 TO LENGTH(INPUT FRAME default-frame v_rating):
            ASSIGN v_rating_aux = SUBSTR(INPUT FRAME default-frame v_rating,i-cont-rating,1).
    
            IF  v_rating_aux <> "A" 
            AND v_rating_aux <> "B"
            AND v_rating_aux <> "C" 
            AND v_rating_aux <> "+"
            AND v_rating_aux <> "-" THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "O formato informado para o Rating Ç inv†lido, deve considerar apenas os conceitos (A / B / C / + / -) !").
        
                APPLY "ENTRY":U TO v_rating IN FRAME default-frame.
                RETURN NO-APPLY.
            END.
        END.
    END.

    IF emitente.ind-cre-cli   <>  LOOKUP(cb-credito-cli:SCREEN-VALUE IN FRAME default-frame, cb-credito-cli:LIST-ITEMS) /*int(emitente.ind-cre-cli:SCREEN-VALUE IN FRAME default-frame)*/
    OR b-emitente-matriz.lim-credito <>  dec(b-emitente-matriz.lim-credito:SCREEN-VALUE IN FRAME default-frame)
    OR b-emitente-matriz.dt-lim-cred <> date(b-emitente-matriz.dt-lim-cred:SCREEN-VALUE IN FRAME default-frame)
    THEN DO:
    
         /* Gera hist¢rico para as alteraá‰es das informaá‰es da an†lise de crÇdito */
         CREATE histor_clien. 
         ASSIGN histor_clien.cod_empresa = emscad.cliente.cod_empresa
                histor_clien.cdn_cliente = emscad.cliente.cdn_cliente.
    
         FIND LAST b_histor_clien NO-LOCK 
             WHERE b_histor_clien.cod_empresa = histor_clien.cod_empresa
               AND b_histor_clien.cdn_cliente = histor_clien.cdn_cliente NO-ERROR.
         IF AVAIL b_histor_clien 
            THEN ASSIGN histor_clien.num_seq_histor_clien = b_histor_clien.num_seq_histor_clien + 1.
            ELSE ASSIGN histor_clien.num_seq_histor_clien = 1.
        
            /*emitente.ind-cre-cli:SCREEN-VALUE IN FRAME default-frame*/
         ASSIGN histor_clien.des_abrev_histor_clien = "Hist¢rico Autom†tica - ESACR003"
                histor_clien.des_histor_clien       = "An†lise de CrÇdito alterado em " + STRING(TODAY, "99/99/9999") + " pelo usu†rio "  + v_cod_usuar_corren + " :" + CHR(10) + CHR(10) +
                                                      "Data Limite de CrÇdito de: "     + (IF b-emitente-matriz.dt-lim-cred = ? THEN "01/01/0001" ELSE STRING(b-emitente-matriz.dt-lim-cred, "99/99/9999"))      + " para " + b-emitente-matriz.dt-lim-cred:SCREEN-VALUE IN FRAME default-frame + CHR(10) +
                                                      "Indicador de CrÇdito de: "       + STRING(emitente.ind-cre-cli)                    + " para " + STRING(LOOKUP(cb-credito-cli:SCREEN-VALUE IN FRAME default-frame, cb-credito-cli:LIST-ITEMS)) + CHR(10) +
                                                      "Limite de CrÇdito de: "          + STRING(b-emitente-matriz.lim-credito, ">>>,>>>,>>9.99")  + " para " + b-emitente-matriz.lim-credito:SCREEN-VALUE IN FRAME default-frame.
        
         ASSIGN emitente.ind-cre-cli          = LOOKUP(cb-credito-cli:SCREEN-VALUE IN FRAME default-frame, cb-credito-cli:LIST-ITEMS) /*int(emitente.ind-cre-cli:SCREEN-VALUE IN FRAME default-frame)*/
                b-emitente-matriz.lim-credito = dec(b-emitente-matriz.lim-credito:SCREEN-VALUE IN FRAME default-frame)
                b-emitente-matriz.dt-lim-cred = date(b-emitente-matriz.dt-lim-cred:SCREEN-VALUE IN FRAME default-frame)
                b-emitente-matriz.user-libcre = v_cod_usuar_corren
                v_user_libcre                 = v_cod_usuar_corren
                b-emitente-matriz.observacoes = c-obs.
    
    END.


    /* Grava a informaá∆o na Extens∆o do emitente. */
    FIND FIRST int-emitente EXCLUSIVE-LOCK
        WHERE  int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
    IF  NOT AVAIL int-emitente THEN DO:
        CREATE int-emitente.
        ASSIGN int-emitente.cod-emitente = emitente.cod-emitente.
    END.

    ASSIGN int-emitente.cod-gr-cob = INT(i-cod-grp-cobr:SCREEN-VALUE IN FRAME default-frame)
           int-emitente.top-milhao = IF v_log_top_milhao:CHECKED IN FRAME default-frame = NO THEN NO ELSE YES
           int-emitente.rating     = string(v_rating:SCREEN-VALUE IN FRAME default-frame).


    /* SupplierCard */
    FIND LAST int-emitente-supcard EXCLUSIVE-LOCK
        WHERE int-emitente-supcard.raiz-cnpj = SUBSTRING(b-emitente-matriz.cgc,1,8) NO-ERROR.
    IF  AVAIL int-emitente-supcard THEN
        ASSIGN int-emitente-supcard.qtd-dias-atraso-int = INT(i-dias-atras-intelbras:SCREEN-VALUE IN FRAME default-frame).
    /* SupplierCard- FIM */
     
    IF  AVAIL b-emitente-matriz THEN
        FIND CURRENT b-emitente-matriz NO-LOCK.

    IF  AVAIL emitente THEN
        FIND CURRENT emitente NO-LOCK.
    
    IF  AVAIL int-emitente then
        FIND CURRENT int-emitente NO-LOCK.

    IF  AVAIL int-emitente-supcard THEN
        FIND CURRENT int-emitente-supcard NO-LOCK.

    IF  AVAIL histor_clien THEN
        FIND CURRENT histor_clien NO-LOCK.
    
    ENABLE bt-mod 
           rs-modo WITH FRAME default-frame.

    /*habilitar todos os botoes e campos da tela que nao sejam da analise de credito    */
    ENABLE btFirst
           btPrev
           btNext
           btLast
           btDet
           btZoom
           btFiltro
           btPrint
           btMail
           btRegrasVencto
           btTransfCred
           btSelec
           bt_historico_padrao
           bt_historico
           bt_rel_cred
           btGera
           btAcordo
           btMatriz
           btExit
           btHelp
           cod-cliente
           btGoTo 
           bt-filtro
           bt-aprova
           bt-reprova 
           bt-repres WITH FRAME default-frame.

    DISABLE bt-can
            bt-sav 
            /*emitente.ind-cre-cli*/
            cb-credito-cli
            b-emitente-matriz.lim-credito
            b-emitente-matriz.dt-lim-cred
            i-dias-atras-intelbras
            i-cod-grp-cobr
            v_log_top_milhao
            v_rating
            WITH FRAME default-frame.
    DISP v_user_libcre WITH FRAME default-frame.

    RETURN "OK".

END.

ON CHOOSE OF bt-can IN FRAME default-frame
DO:

    IF  AVAIL b-emitente-matriz THEN
        FIND CURRENT b-emitente-matriz NO-LOCK.

    IF  AVAIL emitente THEN
        FIND CURRENT emitente NO-LOCK.
    
    IF  AVAIL int-emitente then
        FIND CURRENT int-emitente NO-LOCK.

    IF  AVAIL int-emitente-supcard THEN
        FIND CURRENT int-emitente-supcard NO-LOCK.

    IF  AVAIL histor_clien THEN
        FIND CURRENT histor_clien NO-LOCK.

    ASSIGN v_user_libcre = b-emitente-matriz.user-libcre.

    ENABLE bt-mod 
           rs-modo WITH FRAME default-frame.
           cb-credito-cli:SCREEN-VALUE                     IN FRAME {&FRAME-NAME} = {adinc/i10ad098.i 4 emitente.ind-cre-cli}.

    DISP v_user_libcre cb-credito-cli /*emitente.ind-cre-cli*/ b-emitente-matriz.lim-credito b-emitente-matriz.dt-lim-cred i-cod-grp-cobr v_log_top_milhao v_rating
         WITH FRAME default-frame.

    /*habilitar todos os botoes e campos da tela que nao sejam da analise de credito    */
    ENABLE btFirst
           btPrev
           btNext
           btLast
           btDet
           btZoom
           btFiltro
           btPrint
           btMail
           btRegrasVencto
           btTransfCred
           btSelec
           bt_historico_padrao
           bt_historico
           btGera
           btAcordo
           btMatriz
           bt_rel_cred
           btExit
           btHelp
           cod-cliente
           btGoTo 
           bt-filtro
           bt-aprova
           bt-reprova 
           bt-repres WITH FRAME default-frame.

    DISABLE bt-can
            bt-sav 
            /*emitente.ind-cre-cli*/
            cb-credito-cli
            b-emitente-matriz.lim-credito
            b-emitente-matriz.dt-lim-cred
            i-dias-atras-intelbras
            i-cod-grp-cobr
            v_rating
            v_log_top_milhao
            WITH FRAME default-frame.

END.

ON LEAVE OF b-emitente-matriz.lim-credito IN FRAME default-frame
DO:
  IF DECIMAL(b-emitente-matriz.lim-credito:SCREEN-VALUE) = 0.00 
  THEN DO:
       DISABLE b-emitente-matriz.dt-lim-cred WITH FRAME default-frame.
       ASSIGN b-emitente-matriz.dt-lim-cred:SCREEN-VALUE = "".
  END.
  ELSE DO:
       IF NOT b-emitente-matriz.dt-lim-cred:SENSITIVE 
       THEN DO:
            ENABLE b-emitente-matriz.dt-lim-cred WITH FRAME DEFAULT-frame.
            APPLY 'entry' TO b-emitente-matriz.dt-lim-cred IN FRAME default-frame.
            RETURN NO-APPLY.
       END.
   END.
END.

ON LEAVE OF v_rating IN FRAME default-frame DO:
    /* Altera para mai£sculo o Rating */
    ASSIGN v_rating:SCREEN-VALUE IN FRAME default-frame = CAPS(v_rating:SCREEN-VALUE IN FRAME default-frame).
END.

ON VALUE-CHANGED OF cb-credito-cli /*emitente.ind-cre-cli*/ IN FRAME default-frame
DO:

  /*IF INT(emitente.ind-cre-cli:SCREEN-VALUE IN FRAME default-frame) <> 2 THEN*/
    IF  LOOKUP(cb-credito-cli:SCREEN-VALUE IN FRAME default-frame, cb-credito-cli:LIST-ITEMS) <> 2 THEN
        ENABLE b-emitente-matriz.lim-credito
               b-emitente-matriz.dt-lim-cred WITH FRAME default-frame.
    ELSE DO WITH FRAME default-frame:
        ASSIGN b-emitente-matriz.lim-credito:SCREEN-VALUE = "0"
               b-emitente-matriz.dt-lim-cred:SCREEN-VALUE = ?.

        DISABLE b-emitente-matriz.lim-credito
                b-emitente-matriz.dt-lim-cred.
    END.

    /* verifica se foi alterado o tipo de avaliacao de credito */
    /*IF  INT(emitente.ind-cre-cli:SCREEN-VALUE)  = 4  /* suspenso */
    AND INT(emitente.ind-cre-cli:SCREEN-VALUE) <> emitente.ind-cre-cli THEN DO:*/
    IF  LOOKUP(cb-credito-cli:SCREEN-VALUE IN FRAME default-frame, cb-credito-cli:LIST-ITEMS) = 4 /* Suspenso */ AND
        LOOKUP(cb-credito-cli:SCREEN-VALUE IN FRAME default-frame, cb-credito-cli:LIST-ITEMS) <> emitente.ind-cre-cli THEN DO:
        FOR EACH ped-venda NO-LOCK
           WHERE ped-venda.cod-estabel  = v_cod_estab_usuar
             AND ped-venda.nome-abrev   = emitente.nome-abrev
             AND ped-venda.cod-sit-ped <= 2:    /* aberto e atend parcial */

            IF ped-venda.cod-priori   = 10 
               THEN MESSAGE "Pedido " + TRIM(ped-venda.nr-pedcli) + " liberado para faturamento (Prioridade 10)." SKIP(2)
                            "N∆o Ç poss°vel suspender o crÇdito do cliente. "  SKIP
                            "O pedido "    + TRIM(ped-venda.nr-pedcli)         SKIP
                            " do cliente " + TRIM(ped-venda.nome-abrev)        SKIP
                            " est† liberado para faturamento (Prioridade 10)." VIEW-AS ALERT-BOX.

            FOR EACH ped-ent NO-LOCK OF ped-venda:
                IF  ped-ent.qt-alocada > 0
                AND (ped-ent.qt-alocada - ped-ent.qt-atendida) > 0 
                THEN DO:
                     MESSAGE "Pedido " + TRIM(ped-venda.nr-pedcli) + " alocado em embarque." SKIP(2)
                             "N∆o Ç poss°vel suspender o crÇdito do cliente. " SKIP
                             "O pedido " + TRIM(ped-venda.nr-pedcli)           SKIP
                             " do cliente " + TRIM(ped-venda.nome-abrev)       SKIP
                             " est† alocado em embarque(s) n∆o faturado(s)." VIEW-AS ALERT-BOX.
                     LEAVE.
                END.
            END.
        END.
    END.    

    /*IF INT(emitente.ind-cre-cli:SCREEN-VALUE IN FRAME default-frame) = 4 THEN DO:*/
    IF  LOOKUP(cb-credito-cli:SCREEN-VALUE IN FRAME default-frame, cb-credito-cli:LIST-ITEMS) = 4 THEN DO:

        /* ** 505
        RUN pdp/pd0806a.w (INPUT-OUTPUT c-obs).
                 ***/
        RUN cmp/cm0102a.w (INPUT-OUTPUT c-obs,
                                 OUTPUT c-return).

        FIND FIRST ped-venda NO-LOCK
            WHERE ped-venda.nome-abrev    = emitente.nome-abrev
              AND ped-venda.cod-sit-ped  <= 1 
              AND ped-venda.cod-sit-aval <> 4 NO-ERROR.
        IF AVAIL ped-venda THEN
            MESSAGE "ATENÄ«O: Cliente est† suspenso !" SKIP(2)
                    "Se desejar reprovar seus pedidos, execute o programa pd0808." VIEW-AS ALERT-BOX.
    END.

    /*IF  emitente.ind-cre-cli = 4 AND
      INT(emitente.ind-cre-cli:SCREEN-VALUE IN FRAME default-frame) <> 4 THEN*/
    IF  emitente.ind-cre-cli = 4 AND
        LOOKUP(cb-credito-cli:SCREEN-VALUE IN FRAME default-frame, cb-credito-cli:LIST-ITEMS) <> 4 THEN
        /* ** 505
        RUN pdp/pd0806a.w (INPUT-OUTPUT c-obs).
                    ***/
        RUN cmp/cm0102a.w (INPUT-OUTPUT c-obs,
                                 OUTPUT c-return).
END.

/* ** Fim - Gatilhos para a alteraá∆o da an†lise de crÇdito ***/


ON CHOOSE OF bt_rel_cred IN FRAME default-frame
DO:
    RUN esp/pdp/espdp051.r. /*pdp/pd0807.r*/
END.

&Scoped-define SELF-NAME rs-modo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-modo C-Win
ON VALUE-CHANGED OF rs-modo IN FRAME DEFAULT-FRAME
DO:
   RUN pi_rs-modo.
END.

/*
ON 'VALUE-CHANGED':U OF bf-int-ped-venda-br.liberacao-forcada IN BROWSE br_ped
DO:
    FIND CURRENT bf-int-ped-venda-br EXCLUSIVE-LOCK NO-ERROR.

    IF NOT ERROR-STATUS:ERROR THEN
        ASSIGN INPUT BROWSE br_ped bf-int-ped-venda-br.liberacao-forcada.

    FIND CURRENT bf-int-ped-venda-br NO-LOCK NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

ON 'LEAVE':U OF bf-int-ped-venda-br.liberacao-forcada IN BROWSE br_ped
DO:
    RELEASE bf-int-ped-venda-br.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

run prgtec/men/men901za.py (Input 'esacr003') /*prg_fnc_verify_security*/.
if  return-value = "2012"
then do:
    MESSAGE "Usu†rio sem permiss∆o para acessar o programa!"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN.
end.

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ASSIGN h-esacr003 = THIS-PROCEDURE.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

assign c-cod-sit-aval:label in browse br_ped = "Sit.Aval".
assign c-cod-sit-ped:label  in browse br_ped = "Sit.Ped".
assign d-vl-aberto:label    in browse br_ped = "Vl Aberto Ped".
ASSIGN c-seg-usuario = v_cod_usuar_corren.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

   RUN enable_UI.

   ASSIGN cod-cliente:FORMAT IN FRAME {&FRAME-NAME} = "x(20)":U.

   APPLY "ENTRY"         TO cod-cliente IN FRAME {&FRAME-NAME}.
   APPLY "VALUE-CHANGED" TO rs-modo     IN FRAME {&FRAME-NAME}.

   IF NOT THIS-PROCEDURE:PERSISTENT 
      THEN WAIT-FOR CLOSE OF THIS-PROCEDURE.

   ON LEAVE OF tt_saldo.val_desp_cartorio IN BROWSE {&BROWSE-NAME} 
   DO:
      IF INPUT BROWSE {&BROWSE-NAME} tt_saldo.val_desp_cartorio <> 0 
      THEN DO:
           /*  O controle de acesso passa a ser atravÇs do EMS - Aporte*/
           FIND CURRENT tt_saldo NO-ERROR. 
           IF AVAIL tt_saldo 
              THEN ASSIGN tt_saldo.val_desp_cartorio = INPUT BROWSE {&BROWSE-NAME} tt_saldo.val_desp_cartorio.
      END.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  
  /* ** Pasta Informaá‰es Financeiras ***/
  DISPLAY cod-cliente c-cliente v_num_pessoa c-fone c-cidade c-estado 
          i-cod-grp-cobr /*c-gr*/ v_user_libcre v_email d-tot-orig d-tot-cliente v_rating v_log_top_milhao
          d-credito v_vcto_mes v_sdo_vencido v_sdo_avencer rs-modo rs-opcao v_log_mostra_perda_dedut v_tot_sel
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.

  ENABLE rtParent rtParent-2 rtToolBar btFirst btPrev btNext btLast 
         btDet btZoom btFiltro btPrint btMail btRegrasVencto btTransfCred btSelec bt_historico_padrao bt_historico bt_rel_cred btGera btAcordo btMatriz btExit 
         btHelp cod-cliente btGoTo rs-modo rs-opcao v_log_mostra_perda_dedut br_tt_saldo bt-repres
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.

  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}

  /* ** Pasta Analise de Credito ***/
  DISPLAY br_ped br_cond_esp br_antecip bt-filtro bt-aprova bt-reprova
          c-doc i-parc      
          i-cod-grp-cobr v_log_top_milhao v_rating RECT-4 RECT-5 RECT-6 
        WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.

  ENABLE br_ped br_cond_esp br_antecip bt-filtro bt-aprova bt-reprova RECT-4 RECT-5 RECT-6 /*bt-det-supcard */
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.

  VIEW C-Win.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-int-tit-acr C-Win 
PROCEDURE pi-atualiza-int-tit-acr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR i-cont AS INT NO-UNDO.            
    DEFINE VARIABLE l-selecionado AS LOGICAL NO-UNDO.
                
    IF  br_tt_saldo:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 0 THEN DO:
        DO I-Cont = 1 to br_tt_saldo:NUM-SELECTED-ROWS:
            br_tt_saldo:FETCH-SELECTED-ROW(I-Cont).
            IF tt_saldo.ind_tip_espec_docto = "Antecipaá∆o" THEN DO:
                MESSAGE "Titulo " + tt_saldo.cod_tit_acr + "/" + tt_saldo.cod_parcela + " Ç de antecipaá∆o!" SKIP 
                        "N∆o Ç poss°vel enviar t°tulos de antecipaá∆o para a assessoria de cobranáa. "  SKIP
                        "Este t°tulo ser† ignorado."
                        VIEW-AS ALERT-BOX WARNING.
                NEXT.
            END.
            IF tt_saldo.dat_vencto_tit_acr >= TODAY THEN DO:
                MESSAGE "Titulo " + tt_saldo.cod_tit_acr + "/" + tt_saldo.cod_parcela + " n∆o est† vencido!" SKIP 
                        "N∆o Ç poss°vel enviar t°tulos que ainda n∆o venceram para a assessoria de cobranáa. "  SKIP
                        "Este t°tulo ser† ignorado."
                        VIEW-AS ALERT-BOX WARNING.
                NEXT.
            END.
            FIND mgesp.int_tit_acr EXCLUSIVE-LOCK
                WHERE int_tit_acr.cod_estab      = tt_saldo.cod_estab     
                AND   int_tit_acr.num_id_tit_acr = tt_saldo.num_id_tit_acr NO-ERROR.
            IF NOT AVAIL int_tit_acr THEN DO:
                CREATE int_tit_acr.
                ASSIGN int_tit_acr.cod_estab            = tt_saldo.cod_estab     
                       int_tit_acr.num_id_tit_acr       = tt_saldo.num_id_tit_acr    
                       int_tit_acr.cod_portador         = tt_saldo.cod_portador      
                       int_tit_acr.cod_cart_bcia        = tt_saldo.cod_cart_bcia     
                       int_tit_acr.ind_sit_envio        = "Selecionado"
                       int_tit_acr.val_desp_cartorio    = tt_saldo.val_desp_cartorio.
                FIND FIRST tt_int_tit_acr
                     WHERE tt_int_tit_acr.cod_estab      = tt_saldo.cod_estab     
                     AND   tt_int_tit_acr.num_id_tit_acr = tt_saldo.num_id_tit_acr NO-ERROR.
                IF NOT AVAIL tt_int_tit_acr THEN
                DO:
                    CREATE tt_int_tit_acr.
                    BUFFER-COPY int_tit_acr TO tt_int_tit_acr NO-ERROR.
                END.
                ASSIGN l-selecionado = YES.
            END.
            ELSE DO:
                IF int_tit_acr.ind_sit_envio = "Enviado" THEN
                    MESSAGE "Titulo " + tt_saldo.cod_tit_acr + "/" + tt_saldo.cod_parcela + " J† Foi Enviado" SKIP 
                            "Deseja Atualiz†-lo Novamente? " 
                            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                            TITLE "" UPDATE l-opcao AS LOGICAL.
                ELSE
                    ASSIGN l-opcao = TRUE.
                CASE l-opcao:         
                    WHEN TRUE THEN 
                    DO:
                        ASSIGN int_tit_acr.cod_portador         = tt_saldo.cod_portador      
                               int_tit_acr.cod_cart_bcia        = tt_saldo.cod_cart_bcia     
                               int_tit_acr.ind_sit_envio        = "Selecionado"
                               int_tit_acr.val_desp_cartorio    = tt_saldo.val_desp_cartorio.

                        FIND FIRST tt_int_tit_acr
                             WHERE tt_int_tit_acr.cod_estab      = tt_saldo.cod_estab     
                             AND   tt_int_tit_acr.num_id_tit_acr = tt_saldo.num_id_tit_acr NO-ERROR.
                        IF NOT AVAIL tt_int_tit_acr THEN
                        DO:
                            CREATE tt_int_tit_acr.
                            BUFFER-COPY int_tit_acr TO tt_int_tit_acr NO-ERROR.
                        END.
                        ELSE ASSIGN tt_int_tit_acr.ind_sit_envio = int_tit_acr.ind_sit_envio.
                        ASSIGN l-selecionado = YES.
                    END.
                    WHEN FALSE THEN
                        NEXT.
                    OTHERWISE.
                END CASE.
            END.
        END.
    END.
    IF l-selecionado = YES THEN 
    DO:
        RUN pi-display.
        MESSAGE "T°tulo selecionado com sucesso."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-totais C-Win 
PROCEDURE pi-calcula-totais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN d-tot-orig    = 0
           d-tot-cliente = 0
           d-credito     = 0.

    FOR EACH tt_saldo:
        FIND espec_docto NO-LOCK
            WHERE espec_docto.cod_espec_docto = tt_saldo.cod_espec_docto NO-ERROR.
        IF AVAIL espec_docto THEN DO:
            IF espec_docto.ind_tip_espec_docto = "Normal" 
            OR espec_docto.ind_tip_espec_docto BEGINS "Vendor" THEN
                ASSIGN d-tot-orig     = d-tot-orig     + tt_saldo.val_origin_tit_acr  /*Acumula Total Original*/
                       d-tot-cliente  = d-tot-cliente  + tt_saldo.val_sdo_tit_acr.    /*Acumula Total Cliente*/
            ELSE                             
                ASSIGN d-credito      = d-credito      + tt_saldo.val_sdo_tit_acr.    /*Acumula Credito */
        END.
    END.

    DISP d-tot-orig         @ d-tot-orig 
         d-tot-cliente      @ d-tot-cliente
         d-credito          @ d-credito
         WITH FRAME {&FRAME-NAME}.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desmarca C-Win 
PROCEDURE pi-desmarca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR i-cont AS INT NO-UNDO.            

IF  br_tt_saldo:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 0 THEN DO:
    DO I-Cont = 1 to br_tt_saldo:NUM-SELECTED-ROWS:

        br_tt_saldo:FETCH-SELECTED-ROW(I-Cont).

        IF tt_saldo.l-ok = "*" THEN DO:
            ASSIGN tt_saldo.l-ok = ""
                   tt_saldo.ind_sit_envio = "".
            FIND FIRST tt_int_tit_acr OF tt_saldo NO-LOCK NO-ERROR.
            DELETE tt_int_tit_acr.
        END.
    
        {&BROWSE-NAME}:REFRESH() IN FRAME {&FRAME-NAME}.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-detalhe C-Win 
PROCEDURE pi-detalhe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Atribuir a variavel global v_rec_cliente com o recid do cliente corrente e
   executar o programa de detalhe do cliente */

RUN prgfin/acr/acr205aa.w.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-display C-Win 
PROCEDURE pi-display :
    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/

    DEF VAR d-vl-aberto  AS DECIMAL NO-UNDO.

    DEF BUFFER b-emitente     FOR emitente.

    IF SESSION:SET-WAIT-STATE("general") THEN.
    
    ASSIGN v_rec_cliente = RECID(emscad.cliente)
           g-esacr070-cliente = emscad.cliente.cdn_cliente.
    
    FIND clien_financ NO-LOCK
        WHERE clien_financ.cod_empresa = emscad.cliente.cod_empresa
        AND   clien_financ.cdn_cliente = emscad.cliente.cdn_cliente NO-ERROR.
    FIND FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = clien_financ.cdn_cliente NO-ERROR.
    FIND b-emitente-matriz NO-LOCK
        WHERE b-emitente-matriz.nome-abrev = emitente.nome-matriz NO-ERROR.
    FIND grp_clien NO-LOCK
        WHERE grp_clien.cod_grp_clien = emscad.cliente.cod_grp_clien.
    FIND FIRST representante NO-LOCK
        WHERE representante.cod_empresa = clien_financ.cod_empresa
        AND   representante.cdn_repres  = clien_financ.cdn_repres NO-ERROR.
    
    /* ** Cria relaá∆o de filiais para a an†lise de crÇdito ***/
    FOR EACH tt-matriz:
        DELETE tt-matriz.
    END.
    FOR EACH b-emitente NO-LOCK
        WHERE b-emitente.nome-matriz = b-emitente-matriz.nome-abrev:
        CREATE tt-matriz.
        ASSIGN tt-matriz.cod-emitente = b-emitente.cod-emitente.
    END.

    ASSIGN v_num_pessoa = IF AVAIL emscad.cliente THEN emscad.cliente.num_pessoa ELSE 0. 
    
    RUN esp/acr/esacr003b.p (INPUT emscad.cliente.num_pessoa,
                             OUTPUT v_email).

    
    FIND FIRST int-emitente NO-LOCK
        WHERE  int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
    
    ASSIGN i-cod-grp-cobr   = IF AVAIL int-emitente THEN int-emitente.cod-gr-cob ELSE 0
           v_log_top_milhao = IF AVAIL int-emitente THEN int-emitente.top-milhao ELSE no
           v_rating         = IF AVAIL int-emitente THEN int-emitente.rating     ELSE "".
    
    /*****    Mostra dados referente ao cliente    ******/    
    DISP TRIM(STRING(emscad.cliente.cdn_cliente))                                     @ cod-cliente
         emscad.cliente.nom_pessoa                                                    @ c-cliente
         i-cod-grp-cobr                                                             
         v_log_top_milhao
         v_rating
         b-emitente-matriz.user-libcre       WHEN     AVAIL b-emitente-matriz       @ v_user_libcre
         ""                                  WHEN NOT AVAIL b-emitente-matriz       @ v_user_libcre
         v_email
         v_num_pessoa
         WITH FRAME {&FRAME-NAME}.
    
    /*  Verefica se o cliente Ç pessoa f°sica ou jur°dica  */
    
    IF emscad.cliente.num_pessoa MODULO 2 = 0 
    THEN DO:
        FIND pessoa_fisic NO-LOCK
            WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
        IF AVAIL pessoa_fisic THEN
            DISP pessoa_fisic.nom_cidade        @ c-cidade
                 pessoa_fisic.cod_telefone      @ c-fone  
                 pessoa_fisic.cod_unid_federac  @ c-estado
                 WITH FRAME {&FRAME-NAME}.
    END.
    ELSE DO:
        FIND pessoa_jurid NO-LOCK
            WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
        IF AVAIL pessoa_jurid THEN
            DISP pessoa_jurid.nom_cidade        @ c-cidade
                 pessoa_jurid.cod_telefone      @ c-fone  
                 pessoa_jurid.cod_unid_federac  @ c-estado
                 WITH FRAME {&FRAME-NAME}.
    END.
    
    FOR EACH tt_saldo:
        DELETE tt_saldo.
    END.
    
    ASSIGN d-vl-cartorio = 0
           d_vecdo       = 0
           d-avcer       = 0
           d-vcto-mes    = 0
           d-tot-matriz  = 0
           d-tot-ped     = 0.     
    
    for each estabelecimento no-lock
        where estabelecimento.cod_estab >= c-estabini
          and estabelecimento.cod_estab <= c-estabfim:
          
        /* T°tulos transferidos para o 102 e 103 */
        IF estabelecimento.cod_estab = '201'
        OR estabelecimento.cod_estab = '301'
           THEN NEXT.

        FOR EACH tt-matriz
            WHERE tt-matriz.cod-emitente >= c-clienteini
              AND tt-matriz.cod-emitente <= c-clientefim:

            FOR EACH tit_acr NO-LOCK
                WHERE tit_acr.cod_estab           = estabelecimento.cod_estab
                AND   tit_acr.cdn_cliente         = tt-matriz.cod-emitente
                AND   tit_acr.dat_vencto_tit_acr  >= d-orderedini 
                 AND   tit_acr.dat_vencto_tit_acr  <= d-orderedfim 
                AND   tit_acr.dat_emis_docto      >= d-emissaoini 
                AND   tit_acr.dat_emis_docto      <= d-emissaofim 
                AND   tit_acr.cod_espec_docto     >= c-especieini 
                AND   tit_acr.cod_espec_docto     <= c-especiefim 
                AND   tit_acr.cod_portador        >= c-portadorini
                AND   tit_acr.cod_portador        <= c-portadorfim
                AND   tit_acr.cod_tit_acr         >= c-tituloini
                AND   tit_acr.cod_tit_acr         <= c-titulofim
                /*AND   tit_acr.log_sdo_tit_acr     = YES*/
                AND   tit_acr.val_sdo_tit_acr      > 0
                AND   tit_acr.log_tit_acr_estordo  = NO USE-INDEX titacr_cliente:

                FIND FIRST b_movto_tit_acr_perdas NO-LOCK 
                     WHERE b_movto_tit_acr_perdas.cod_estab           = tit_acr.cod_estab
                       AND b_movto_tit_acr_perdas.num_id_tit_acr      = tit_acr.num_id_tit_acr
                       AND b_movto_tit_acr_perdas.ind_trans_acr_abrev = "LQPD"
                       AND b_movto_tit_acr_perdas.log_movto_estordo   = NO NO-ERROR.

                IF v_log_mostra_perda_dedut = NO 
                THEN DO:
                     IF AVAIL b_movto_tit_acr_perdas 
                        THEN NEXT.
                END. 

                IF c-titulodevini <> "" OR c-titulodevfim <> "ZZZZZZZZZZ" THEN DO:
                    FIND nota-fiscal NO-LOCK
                        WHERE nota-fiscal.cod-estabel = tit_acr.cod_estab
                          AND nota-fiscal.serie = tit_acr.cod_ser_docto
                          AND nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr
                        NO-ERROR.
                    IF AVAIL nota-fiscal THEN DO:
                        FIND FIRST devol-cli NO-LOCK
                            WHERE devol-cli.cod-estabel = nota-fiscal.cod-estabel
                              AND devol-cli.serie = nota-fiscal.serie 
                              AND devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis
                              AND devol-cli.nro-docto >= c-titulodevini
                              AND devol-cli.nro-docto <= c-titulodevfim
                            NO-ERROR.
                        IF NOT AVAIL devol-cli THEN NEXT.
                    END.
                    ELSE NEXT.
                END. 

            
                IF tit_acr.ind_tip_espec_docto      = "Normal"
                OR tit_acr.ind_tip_espec_docto BEGINS "Vendor" 
                THEN DO:


                    IF  tit_acr.cod_portador <> "9905"
                    AND tit_acr.cod_portador <> "9930"
                    AND tit_acr.cod_portador <> "9929"
                    AND tit_acr.cod_portador <> "9915"
                    AND tit_acr.cod_portador <> "9919"
                    AND tit_acr.cod_portador <> "9943"
                    AND tit_acr.cod_portador <> "9929"
                    AND tit_acr.cod_cart_bcia <> "CSR" THEN DO: 
    
                         IF tit_acr.cod_espec_docto = "VE" 
                         THEN DO:
                              /* Localiza extensao da parcela que contem o valor do cliente(com juros) */
                              FIND FIRST parc_vendor NO-LOCK
                                   WHERE parc_vendor.cod_estab_tit_acr = tit_acr.cod_estab
                                     AND parc_vendor.num_id_tit_acr    = tit_acr.num_id_tit_acr NO-ERROR.
                              IF AVAIL parc_vendor 
                                 THEN ASSIGN d-tot-matriz = d-tot-matriz + parc_vendor.val_parc_vendor_clien.
                         END.
                         IF tit_acr.cod_espec_docto = "VEM" 
                         THEN DO:
                              ASSIGN d-tot-matriz = d-tot-matriz + tit_acr.val_sdo_tit_acr.
                              FIND FIRST movto_tit_acr OF tit_acr NO-LOCK
                                   WHERE movto_tit_acr.ind_trans_acr_abrev = 'IMPL' NO-ERROR.
                              IF AVAIL movto_tit_acr 
                              THEN DO:
                                   FIND FIRST histor_movto_tit_acr NO-LOCK
                                        WHERE histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                                          AND histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                                          AND histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
                                   IF AVAIL histor_movto_tit_acr 
                                      THEN ASSIGN d-tot-matriz = d-tot-matriz + tit_acr.val_sdo_tit_acr. 
                              END.
                         END.
                         IF  tit_acr.cod_espec_docto <> "VE" 
                         AND tit_acr.cod_espec_docto <> "VEM" THEN DO:

                             ASSIGN d-tot-matriz = d-tot-matriz + tit_acr.val_sdo_tit_acr. 

                         END.
                    END.
                END.   
                                   
                CREATE tt_saldo.
                ASSIGN tt_saldo.cod_empresa            = tit_acr.cod_empresa
                       tt_saldo.cod_estab              = tit_acr.cod_estab
                       tt_saldo.cod_espec_docto        = tit_acr.cod_espec_docto           
                       tt_saldo.cod_ser_docto          = tit_acr.cod_ser_docto
                       tt_saldo.cod_tit_acr            = tit_acr.cod_tit_acr           
                       tt_saldo.ind_tip_espec_docto    = tit_acr.ind_tip_espec_docto
                       tt_saldo.cod_parcela            = tit_acr.cod_parcela               
                       tt_saldo.dat_vencto_tit_acr     = tit_acr.dat_vencto_tit_acr        
                       tt_saldo.dat_emis_docto         = tit_acr.dat_emis_docto            
                       tt_saldo.val_sdo_origin_tit_acr = tit_acr.val_origin_tit_acr
                       tt_saldo.val_sdo_tit_acr        = tit_acr.val_sdo_tit_acr
                       tt_saldo.num_atr                = TODAY - tit_acr.dat_vencto_tit_acr
                       tt_saldo.cod_portador           = tit_acr.cod_portador              
                       tt_saldo.cod_cart_bcia          = tit_acr.cod_cart_bcia
                       tt_saldo.rec_tit_acr            = RECID(tit_acr)
                       tt_saldo.cdn_cliente            = tit_acr.cdn_cliente
                       tt_saldo.num_id_tit_acr         = tit_acr.num_id_tit_acr
                       tt_saldo.cod_tit_acr_bco        = tit_acr.cod_tit_acr_bco
                       tt_saldo.cod_perda              = IF tit_acr.dat_indcao_perda_dedut = 12/31/9999 THEN "N∆o" ELSE "Sim"
                       tt_saldo.num_planinha_vendor    = 0
                       tt_saldo.cod_cond_cobr          = tit_acr.cod_cond_cobr
                       tt_saldo.log_liq_perdas         = AVAIL b_movto_tit_acr_perdas.
            
                ASSIGN tt_saldo.val_origin_tit_acr = tit_acr.val_origin_tit_acr.
                
                IF tit_acr.ind_tip_espec_docto = "Normal"
                OR tit_acr.ind_tip_espec_docto BEGINS "Vendor" 
                THEN DO:
                        IF  tit_acr.cod_portador <> "9904"
                        AND tit_acr.cod_portador <> "9905"
                        AND tit_acr.cod_portador <> "9930"
                        AND tit_acr.cod_portador <> "9929"
                        AND tit_acr.cod_portador <> "9915"
                        AND tit_acr.cod_portador <> "9919"
                        AND tit_acr.cod_portador <> "9943"
                        AND tit_acr.cod_portador <> "9996"
                        AND tit_acr.cod_cart_bcia <> "CSR" THEN DO: 
                           IF TODAY - tit_acr.dat_vencto_tit_acr > 0 THEN 
                              ASSIGN d_vecdo = d_vecdo + tt_saldo.val_sdo_tit_acr.
                           ELSE 
                              ASSIGN d-avcer = d-avcer + tt_saldo.val_sdo_tit_acr.
                           IF MONTH(TODAY) = MONTH(tit_acr.dat_vencto_tit_acr) 
                              THEN ASSIGN d-vcto-mes = d-vcto-mes + tt_saldo.val_sdo_tit_acr.
                        END.

                        /* Pedido de Origem do Cliente - Informaªío solicitada no PD4000, campo "PO Cliente" */
                        FIND FIRST nota-fiscal NO-LOCK
                            WHERE  nota-fiscal.cod-estabel = tit_acr.cod_estab
                            AND    nota-fiscal.serie       = tit_acr.cod_ser
                            AND    nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr NO-ERROR.
                        
                        IF  AVAIL  nota-fiscal THEN DO:
                            ASSIGN tt_saldo.dat_entrega = nota-fiscal.dt-entr-cli.

                            FIND FIRST ped-venda NO-LOCK
                                WHERE  ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                                AND    ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
                            IF  AVAIL  ped-venda THEN DO:
                                FIND FIRST int-ped-venda NO-LOCK
                                    WHERE  int-ped-venda.cod-estabel = ped-venda.cod-estabel
                                    AND    int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
                                IF  AVAIL  int-ped-venda THEN
                                    ASSIGN tt_saldo.cod_PO_cliente = TRIM(SUBSTRING(int-ped-venda.char-1,53,12)).
                            END.
                            
                            FIND FIRST int-nota-fiscal NO-LOCK
                                WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                                AND   int-nota-fiscal.serie       = nota-fiscal.serie
                                AND   int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR. 
            
                            IF  AVAIL int-nota-fiscal THEN
                                ASSIGN tt_saldo.dat_prev_entr = date(SUBSTR(int-nota-fiscal.char-1,50,10)).
                        END.
                        /* Fim - Pedido de Origem do Cliente */

                END.
            
               FIND mgesp.int_tit_acr NO-LOCK
                    WHERE int_tit_acr.cod_estab      = tit_acr.cod_estab
                    AND   int_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr NO-ERROR.
                IF AVAIL int_tit_acr THEN DO:
                    ASSIGN tt_saldo.ind_sit_envio       = int_tit_acr.ind_sit_envio
                           tt_saldo.val_desp_cartorio   = int_tit_acr.val_desp_cartorio
                           tt_saldo.cod_boleto_impresso = IF int_tit_acr.log_boleto_impresso THEN "Sim" ELSE "N∆o"
                           d-vl-cartorio                = d-vl-cartorio + int_tit_acr.val_desp_cartorio.     /*TOTALIZA VALOR CARTORIO*/
                    FIND FIRST tt_int_tit_acr OF int_tit_acr NO-LOCK NO-ERROR.
                    IF AVAIL tt_int_tit_acr THEN DO:
                        IF tt_int_tit_acr.ind_sit_envio = "Selecionado" THEN
                            ASSIGN tt_saldo.l-ok = "*".
                        ELSE 
                            ASSIGN tt_saldo.l-ok = "".
                    END.
                    ELSE DO:
                        IF int_tit_acr.ind_sit_envio = "Selecionado" THEN DO:
            
                            FIND CURRENT int_tit_acr EXCLUSIVE-LOCK.
                            ASSIGN int_tit_acr.ind_sit_envio = ""
                                   tt_saldo.ind_sit_envio = "".
                            FIND CURRENT int_tit_acr NO-LOCK.
            
                        END.
                    END.
                END.
                ELSE 
                    ASSIGN tt_saldo.ind_sit_envio       = ""
                           tt_saldo.val_desp_cartorio   = 0
                           tt_saldo.cod_boleto_impresso = "N∆o".    
                               
            END.
            
        END.

    END.
    
    /* ** Soma saldo dos pedidos em aberto ***/
    FOR EACH tt-situacao-ped:
        DELETE tt-situacao-ped.
    END.
    CREATE tt-situacao-ped. 
    ASSIGN tt-situacao-ped.situacao = 1. /* Aberto */
    CREATE tt-situacao-ped. 
    ASSIGN tt-situacao-ped.situacao = 2. /* Atendido Parcial */

    FOR EACH tt-matriz:
   
        FIND b-emitente-ped NO-LOCK
            WHERE b-emitente-ped.cod-emitente = tt-matriz.cod-emitente NO-ERROR.
    
        FOR EACH tt-situacao-ped NO-LOCK,
            EACH ped-venda USE-INDEX ch-credito NO-LOCK
            WHERE ped-venda.nome-abrev   = b-emitente-ped.nome-abrev
              AND  ped-venda.cod-sit-ped  = tt-situacao-ped.situacao
              AND  ped-venda.cod-sit-aval = 3 /* Aprovado */
              AND  ped-venda.completo     = YES
              AND (ped-venda.cod-priori  <> 44) /* Oráamento */,
            EACH natur-oper  /** CONSISTENCIA SE GERA OU NAO FATURAMENTO **/
            WHERE natur-oper.nat-operacao = ped-venda.nat-operacao
              AND natur-oper.emite-duplic = YES NO-LOCK:
    

         IF  ped-venda.cod-estabel < c-estabini
         OR  ped-venda.cod-estabel > c-estabfim THEN 
             NEXT.
          
        /* T°tulos transferidos para o 102 e 103 */
        IF ped-venda.cod-estabel = '201'
        OR ped-venda.cod-estabel = '301'
           THEN NEXT.


            FIND cond-pagto NO-LOCK
               WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-ERROR.
            IF AVAIL cond-pagto
            AND cond-pagto.cod-cond-pag <> 502
            AND cond-pagto.cod-vencto    = 2
                THEN NEXT.
    
    
            FIND int-cond-pagto OF cond-pagto NO-LOCK NO-ERROR.
            IF  AVAIL int-cond-pagto
            AND SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U  
                THEN NEXT.
    
            RUN pi-converte-moeda (OUTPUT d-vl-aberto).
    
            ASSIGN d-tot-matriz = d-tot-matriz + d-vl-aberto.
    
        END.
    END.

    FOR EACH tt-situacao-ped:
        DELETE tt-situacao-ped.
    END.
    /* ** Fim totalizaá∆o pedidos ***/

    /*
    RUN pi-vendor.
    */
    RUN pi-calcula-totais.
    
    FOR EACH tt_Cliente:
        DELETE tt_Cliente.
    END.
    
    DO WITH FRAME {&FRAME-NAME}:
        CREATE tt_Cliente.
        ASSIGN tt_Cliente.cdn_cliente       = emscad.cliente.cdn_cliente
               tt_Cliente.nom_pessoa        = INPUT c-cliente
               tt_Cliente.nom_cidade        = INPUT c-cidade
               tt_Cliente.cod_telefone      = INPUT c-fone  
             /*  tt_Cliente.des_grp_clien     = INPUT c-gr */
               tt_Cliente.cod_unid_federac  = INPUT c-estado
               tt_Cliente.d-saldo           = INPUT d-tot-orig   
               tt_Cliente.d-saldoc          = INPUT d-tot-cliente
               tt_Cliente.d-credito         = INPUT d-credito
               tt_Cliente.d-vl-cartorio     = d-vl-cartorio
               tt_Cliente.d-vecdo           = d_vecdo
               tt_Cliente.d-avcer           = d-avcer
               tt_Cliente.d-vcto-mes        = d-vcto-mes.
    END.
    
    DISP tt_Cliente.d-vecdo       @ v_sdo_vencido
         tt_Cliente.d-avcer       @ v_sdo_avencer 
         tt_Cliente.d-vcto-mes    @ v_vcto_mes
        WITH FRAME {&FRAME-NAME}.
    
    {&OPEN-QUERY-{&BROWSE-NAME}}
    

/* ** Tratamento para a pasta Analise de Credito ***/

    ASSIGN cb-credito-cli:SCREEN-VALUE IN FRAME default-frame = {adinc/i10ad098.i 4 emitente.ind-cre-cli}.

    
    /**** INICIO - SupplierCard ****/
    IF  NOT VALID-HANDLE(h-esapi001) THEN
        RUN esp/esapi001.p PERSISTENT SET h-esapi001.
    
    IF  VALID-HANDLE(h-esapi001) THEN
        RUN pi-saldo-raiz-cnpj IN h-esapi001 (INPUT  SUBSTRING(emitente.cgc,1,8),
                                              OUTPUT de-lim-tot-supcard,     /* Valor do limite total do cliente para hoje */
                                              OUTPUT de-val-lim-supcard,     /* Valor do limite de hoje da SupplierCard - int-emitente-supcard */
                                              OUTPUT de-saldo-ped-alocado,   /* Valor alocado para pedidos (alocaá∆o em aberto) ATê a data de hoje - int-ped-aloc-supcard */
                                              OUTPUT de-saldo-nfs-faturado,  /* Valor comprometido por notas fiscais no dia de HOJE - int-nfs-supcard */
                                              OUTPUT de-saldo-disp-supcard). /* Valor dispon°vel para consumo (de-val-lim-supcard - (de-saldo-ped-alocado + de-saldo-nfs-faturado)) */
    IF  VALID-HANDLE(h-esapi001) THEN
        DELETE PROCEDURE h-esapi001.
    
    ASSIGN h-esapi001 = ?.

    /* Calcula os valores de limite */
    /*
    ASSIGN de-lim-uti-supcard     = de-lim-tot-supcard - de-val-lim-supcard
           de-lim-uti-intelbras   = de-saldo-ped-alocado + de-saldo-nfs-faturado
           de-lim-disp-cli        = de-lim-tot-supcard - de-lim-uti-supcard - de-lim-uti-intelbras.
    */
    ASSIGN i-dias-atras-intelbras = 0.

    FIND LAST int-emitente-supcard NO-LOCK
        WHERE int-emitente-supcard.raiz-cnpj = SUBSTRING(emitente.cgc,1,8) NO-ERROR.
    IF  AVAIL int-emitente-supcard THEN DO:
        ASSIGN /*i-dias-atras-supcard   = int-emitente-supcard.qtd-dias-atraso-sc*/
               i-dias-atras-intelbras = int-emitente-supcard.qtd-dias-atraso-int.
    END.

    FIND LAST int-param-supcard NO-LOCK NO-ERROR.
    ASSIGN i-dias-atraso-param-sc = IF AVAIL int-param-supcard THEN int-param-supcard.qtd-dias-atraso ELSE 0.

    /*
    /* Se os dias de atraso do cliente na SupplierCard forem superior ao Limite do ParÉmetro, coloca em vermelho */
    IF  i-dias-atras-supcard > i-dias-atraso-param-sc THEN
        ASSIGN i-dias-atras-supcard:FGCOLOR = 12.
    /**** FIM - SupplierCard ****/
    */

    DISP /*emitente.ind-cre-cli */
         cb-credito-cli
         b-emitente-matriz.lim-credito
         b-emitente-matriz.dt-lim-cred
         d-tot-matriz @ d-tot-matriz
         d-tot-ped @ d-tot-ped
         grp_clien.cod_grp_clien
         /*de-lim-tot-supcard
         de-lim-uti-supcard
         de-lim-uti-intelbras
         de-lim-disp-cli
         i-dias-atras-supcard
         i-dias-atras-intelbras*/
        WITH FRAME {&FRAME-NAME}.

   OPEN QUERY br_ped
        FOR EACH tt-situacao NO-LOCK,
            EACH tt-matriz
           WHERE tt-matriz.cod-emitente >= c-clienteini
             AND tt-matriz.cod-emitente <= c-clientefim,
           FIRST b-emitente-ped NO-LOCK
           WHERE b-emitente-ped.cod-emitente = tt-matriz.cod-emitente,
            EACH ped-venda USE-INDEX ch-credito
            WHERE ped-venda.nome-abrev    = b-emitente-ped.nome-abrev
            AND   ped-venda.cod-sit-ped   = tt-situacao.situacao
            AND   ped-venda.completo      = YES
            AND  (ped-venda.cod-priori   >= 01
            AND   ped-venda.cod-priori   <= 06)
            AND   lookup(string(ped-venda.cod-sit-aval),c-aval) > 0
            AND   ped-venda.cod-sit-aval <> 5
            AND ((NOT l-consid-dt-implant)
            OR   (l-consid-dt-implant
            AND  (ped-venda.dt-implant >= dt-implant-ini
            AND   ped-venda.dt-implant <= dt-implant-fim)))
            AND ((NOT l-consid-dt-entrega)
            OR   (l-consid-dt-entrega
            AND  (ped-venda.dt-entrega >= dt-entrega-ini
            AND   ped-venda.dt-entrega <= dt-entrega-fim)))
            AND  ped-venda.origem <> 9 NO-LOCK,
            FIRST bf-int-ped-venda-br NO-LOCK
            WHERE bf-int-ped-venda-br.nr-pedido = ped-venda.nr-pedido,
            FIRST tt-cond-pagto
             WHERE tt-cond-pagto.cod-cond-pag = tt-cond-pagto.cod-cond-pag
                BY ped-venda.nr-pedido
            /*INDEXED-REPOSITION*/.

    APPLY "VALUE-CHANGED" TO br_ped IN FRAME DEFAULT-frame.
    APPLY "VALUE-CHANGED" TO rs-modo IN FRAME DEFAULT-frame.

/* ** Fim tratamento Analise de Credito ***/

    IF SESSION:SET-WAIT-STATE("") THEN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-email C-Win 
PROCEDURE pi-email :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  Nas mensagens est† sendo substituido o CHR(13) por CHR(10) para que a mensagem
  n∆o saia truncada no e-mail.
------------------------------------------------------------------------------*/

    DEFINE BUTTON btGoToCancel AUTO-END-KEY  LABEL "&Cancelar"  SIZE 10 BY 1 BGCOLOR 8.
    DEFINE BUTTON btGoToOK /*AUTO-GO */      LABEL "&OK"        SIZE 10 BY 1 BGCOLOR 8.
    DEFINE RECTANGLE rtGoToButton            EDGE-PIXELS 2 GRAPHIC-EDGE  SIZE 68 BY 1.42 BGCOLOR 7.
    DEFINE VARIABLE c-endereco-email AS CHAR LABEL "E-Mail" FORMAT "X(300)" VIEW-AS FILL-IN  SIZE 40 BY .88 NO-UNDO. 
    DEFINE VARIABLE i-msg-ini AS INT LABEL "Msg Ini" FORMAT ">>9"           VIEW-AS FILL-IN  SIZE 4 BY .88 NO-UNDO. 
    DEFINE VARIABLE i-msg-fin AS INT LABEL "Msg Fin" FORMAT ">>9"           VIEW-AS FILL-IN  SIZE 4 BY .88 NO-UNDO. 
    DEFINE VARIABLE c-des-msg-ini AS CHAR FORMAT "x(20)"                 
        VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
        SIZE 57 BY 3.25 NO-UNDO.
    DEFINE VARIABLE c-des-msg-fin AS CHAR FORMAT "x(20)"                 
        VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
        SIZE 57 BY 3.25 NO-UNDO.

    DEFINE VARIABLE e-narrativa-ini AS CHAR LABEL "Narrativa Ini" FORMAT "x(500)"
        VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
        SIZE 57 BY 3.25 NO-UNDO.

    DEFINE VARIABLE e-narrativa-fin AS CHAR LABEL "Narrativa Fin" FORMAT "x(500)"
        VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
        SIZE 57 BY 3.25 NO-UNDO.
        
    DEFINE VARIABLE vMensagem       AS CHARACTER FORMAT 'x(2000)'   NO-UNDO.
    DEFINE VARIABLE cLinha          AS CHARACTER FORMAT 'x(300)'    NO-UNDO.

    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    DEFINE FRAME fGoToRecord
        c-endereco-email  AT ROW 1.21   COL 8 COLON-ALIGNED  
        i-msg-ini         AT ROW 2.21   COL 8 COLON-ALIGNED
        c-des-msg-ini     AT ROW 3.21   COL 8 COLON-ALIGNED NO-LABEL 
        e-narrativa-ini   AT ROW 6.71   COL 8 COLON-ALIGNED
        i-msg-fin         AT ROW 10.21  COL 8 COLON-ALIGNED
        c-des-msg-fin     AT ROW 11.21  COL 8 COLON-ALIGNED NO-LABEL 
        e-narrativa-fin   AT ROW 14.61  COL 8 COLON-ALIGNED 
        btGoToOK          AT ROW 18.23  COL 2.14
        btGoToCancel      AT ROW 18.23  COL 13
        rtGoToButton      AT ROW 17.98  COL 1

        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "E-MAIL" FONT 1
             CANCEL-BUTTON btGoToCancel.    

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:

        OUTPUT STREAM Stream_1 TO VALUE(v_arquivo).  

        PUT STREAM STREAM_1
            emscad.empresa.Nom_Razao_Social SKIP 
            "Departamento Financeiro"     SKIP(1).

        FIND FIRST mgcad.mensagem 
            WHERE mgcad.mensagem.cod-mensagem = INPUT FRAME fGoToRecord i-msg-ini NO-ERROR.
        IF AVAIL mgcad.mensagem THEN
        DO:
            
            ASSIGN vMensagem = mgcad.mensagem.texto-mensag
                   /*vMensagem = REPLACE(vMensagem, CHR(10),"")*/
                   vMensagem = REPLACE(vMensagem, CHR(13),CHR(10)).
            PUT STREAM STREAM_1
                vMensagem SKIP(1)
                INPUT FRAME fGoToRecord e-narrativa-ini SKIP(1) 
                emscad.cliente.cdn_cliente
                " - "
                emscad.cliente.nom_pessoa SKIP(2). 

        END.
        PUT STREAM STREAM_1
            "Esp Ser Titulo     \P Dat Emis   Dat Vecto  Val Original   Val Cliente    Atr  Port  Cart Val Desp Cart " SKIP 
            "--- --- ---------- -- ---------- ---------- -------------- -------------- ---- ----- ---- --------------" SKIP. 

        FOR EACH tt_saldo NO-LOCK:
            PUT STREAM STREAM_1
                 tt_saldo.cod_espec_docto     AT 01   
                 tt_saldo.cod_ser_docto       AT 05   
                 tt_saldo.cod_tit_acr         AT 09   
                 tt_saldo.cod_parcela         AT 20   
                 tt_saldo.dat_emis_docto      AT 23   
                 tt_saldo.dat_vencto_tit_acr  AT 34   
                 tt_saldo.val_origin_tit_acr  AT 45   
                 tt_saldo.val_sdo_tit_acr     AT 60  
                 tt_saldo.num_atr             AT 75 FORMAT "->>9"
                 tt_saldo.cod_portador        AT 80  
                 tt_saldo.cod_cart_bcia       AT 86  
                 tt_saldo.val_desp_cartorio   AT 91
                SKIP.     
        END.

        PUT STREAM STREAM_1 
            SKIP(1)
            "    TOTAL ORIGINAL: "
            INPUT FRAME DEFAULT-frame d-tot-orig   
            "    TOTAL CLIENTE: "
            INPUT FRAME DEFAULT-frame d-tot-cliente
            "    CRêDITO: "
            INPUT FRAME DEFAULT-frame d-credito    
            SKIP(2).

        FIND FIRST mgcad.mensagem 
            WHERE mgcad.mensagem.cod-mensagem = INPUT FRAME fGoToRecord i-msg-fin NO-ERROR.
        IF AVAIL mgcad.mensagem THEN
        DO:
            ASSIGN vMensagem = mgcad.mensagem.texto-mensag
                   /*vMensagem = REPLACE(vMensagem, CHR(10),CHR(13))*/
                   vMensagem = REPLACE(vMensagem, CHR(13),CHR(10))
                .
            PUT STREAM STREAM_1
                vMensagem SKIP(1)
                INPUT FRAME fGoToRecord e-narrativa-fin SKIP(1). 

        END.

        OUTPUT STREAM STREAM_1 CLOSE.

        INPUT STREAM Stream_1 FROM VALUE(v_arquivo).

        ASSIGN vMensagem = "".
        REPEAT:
            IMPORT STREAM STREAM_1 UNFORMATTED cLinha.
            ASSIGN cLinha = REPLACE(cLinha,CHR(10)," ")
                   cLinha = REPLACE(cLinha,CHR(13)," ")
                   vMensagem = vMensagem + cLinha + CHR(10) .
        END.

        /* envio de e-mail */
        create tt_mail_fax.
        assign tt_mail_fax.ttv_nom_to           = TRIM(INPUT FRAME fGoToRecord c-endereco-email)
               tt_mail_fax.ttv_nom_subject      = "A/C Contas a Pagar - " + emscad.cliente.nom_pessoa
               tt_mail_fax.ttv_nom_message      = vMensagem
               tt_mail_fax.ttv_nom_attachfile   = v_arquivo    
               tt_mail_fax.ttv_num_imptcia      = 2
               tt_mail_fax.ttv_cod_format_mail  = "texto".
        FOR FIRST usuar_mestre NO-LOCK 
            WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren:
            ASSIGN tt_mail_fax.ttv_nom_from     = IF usuar_mestre.cod_e_mail_local = "" THEN "Financeiro@intelbras.com.br" ELSE usuar_mestre.cod_e_mail_local.
        END.
        
        run prgtec\btb\btb916za.py (input "1",
                                        input  table tt_mail_fax,
                                        output table tt_erros_mail_fax).

        
        /* Erro da API de envio de email ser∆o enviados para um arquivo no diret¢rio tempor†rio */
        IF  CAN-FIND(tt_erros_mail_fax) THEN DO:
            FIND FIRST tt_erros_mail_fax NO-LOCK NO-ERROR.
            IF AVAIL tt_erros_mail_fax THEN
                MESSAGE "Erro: "       tt_erros_mail_fax.ttv_cod_erro SKIP
                        "Desc Erro: "  tt_erros_mail_fax.ttv_des_erro SKIP
                        "Desc Arq: "   tt_erros_mail_fax.ttv_des_arquivo                          
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        ELSE OS-DELETE VALUE(v_arquivo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    ON "LEAVE" OF i-msg-ini IN FRAME fGoToRecord DO:
        FIND FIRST mgcad.mensagem 
            WHERE mgcad.mensagem.cod-mensagem = INPUT FRAME fGoToRecord i-msg-ini NO-ERROR.
        IF AVAIL mgcad.mensagem THEN
            ASSIGN c-des-msg-ini:SCREEN-VALUE IN FRAME fGoToRecord = mgcad.mensagem.texto-mensag /*mgcad.mensagem.descricao*/ .
    END.

    ON "LEAVE":U OF i-msg-fin IN FRAME fGoToRecord DO:
        FIND FIRST mgcad.mensagem 
            WHERE mgcad.mensagem.cod-mensagem = INPUT FRAME fGoToRecord i-msg-fin NO-ERROR.
        IF AVAIL mgcad.mensagem THEN
            ASSIGN c-des-msg-fin:SCREEN-VALUE IN FRAME fGoToRecord = mgcad.mensagem.texto-mensag /*mgcad.mensagem.descricao*/.
    END.

    /*  ----------------------  */

    FIND FIRST emscad.empresa NO-LOCK 
         WHERE emscad.empresa.Cod_Empresa = v_cod_empres_usuar NO-ERROR.

    RUN esp/acr/esacr003b.p (INPUT emscad.cliente.num_pessoa,
                             OUTPUT c-endereco-email).

    ASSIGN e-narrativa-ini:RETURN-INSERTED IN FRAME fGoToRecord  = TRUE
           e-narrativa-fin:RETURN-INSERTED IN FRAME fGoToRecord  = TRUE
           v_arquivo                                             = SESSION:TEMP-DIRECTORY + "esacr003.txt".
    
    DISP c-endereco-email
         WITH FRAME fGoToRecord. 

    ENABLE c-endereco-email 
           i-msg-ini      
           e-narrativa-ini
           i-msg-fin      
           e-narrativa-fin
           c-des-msg-ini
           c-des-msg-fin
           btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    ASSIGN c-des-msg-ini:READ-ONLY IN FRAME fGoToRecord = YES
           c-des-msg-fin:READ-ONLY IN FRAME fGoToRecord = YES.
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-filter C-Win 
PROCEDURE pi-filter :
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

    DEFINE IMAGE im-last0
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-first0
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-last1
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-first1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-last2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-first2
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-last3
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-first3
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-last4
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-first4
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-last5
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-first5
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-last6
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-first6
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-last7
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

    DEFINE IMAGE im-first7
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

    DEFINE VARIABLE c-estabini-filter AS CHAR LABEL "Estabelecimento" FORMAT "x(03)"
        VIEW-AS FILL-IN 
        SIZE 4 BY .88 NO-UNDO. 

    DEFINE VARIABLE c-estabfim-filter AS CHAR FORMAT "x(03)"
        VIEW-AS FILL-IN 
        SIZE 4 BY .88 NO-UNDO. 

    DEFINE VARIABLE d-orderedini-filter AS DATE LABEL "Vencimento" FORMAT "99/99/9999"
        VIEW-AS FILL-IN 
        SIZE 10 BY .88 NO-UNDO. 

    DEFINE VARIABLE d-orderedfim-filter AS DATE FORMAT "99/99/9999"
        VIEW-AS FILL-IN 
        SIZE 10 BY .88 NO-UNDO. 

    DEFINE VARIABLE d-emissaoini-filter AS DATE LABEL "Emiss∆o" FORMAT "99/99/9999"
        VIEW-AS FILL-IN 
        SIZE 10 BY .88 NO-UNDO. 

    DEFINE VARIABLE d-emissaofim-filter AS DATE FORMAT "99/99/9999"
        VIEW-AS FILL-IN 
        SIZE 10 BY .88 NO-UNDO. 

    DEFINE VARIABLE c-especieini-filter AS CHAR LABEL "EspÇcie" FORMAT "x(3)"
        VIEW-AS FILL-IN 
        SIZE 4 BY .88 NO-UNDO. 

    DEFINE VARIABLE c-especiefim-filter AS CHAR FORMAT "x(3)"
        VIEW-AS FILL-IN 
        SIZE 4 BY .88 NO-UNDO. 

    DEFINE VARIABLE c-portadorini-filter AS CHAR LABEL "Portador" FORMAT "x(5)"
    VIEW-AS FILL-IN 
    SIZE 6 BY .88 NO-UNDO. 

    DEFINE VARIABLE c-portadorfim-filter AS CHAR FORMAT "x(5)"
    VIEW-AS FILL-IN 
    SIZE 6 BY .88 NO-UNDO. 

    DEFINE VARIABLE c-tituloini-filter AS CHAR LABEL "T°tulo" FORMAT "x(10)"
    VIEW-AS FILL-IN 
    SIZE 10 BY .88 NO-UNDO. 

    DEFINE VARIABLE c-titulofim-filter AS CHAR FORMAT "x(10)"
    VIEW-AS FILL-IN 
    SIZE 10 BY .88 NO-UNDO. 

    DEFINE VARIABLE c-titulodevini-filter AS CHAR LABEL "T°tulo Dev" FORMAT "x(10)"
    VIEW-AS FILL-IN 
    SIZE 10 BY .88 NO-UNDO. 

    DEFINE VARIABLE c-titulodevfim-filter AS CHAR FORMAT "x(10)"
    VIEW-AS FILL-IN 
    SIZE 10 BY .88 NO-UNDO. 

    DEFINE VARIABLE c-clienteini-filter AS INT LABEL "Cliente" FORMAT ">>>>>>>9"
    VIEW-AS FILL-IN
    SIZE 10 BY .88 NO-UNDO.

    DEFINE VARIABLE c-clientefim-filter AS INT FORMAT ">>>>>>>9"
    VIEW-AS FILL-IN
    SIZE 10 BY .88 NO-UNDO.

    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    DEFINE FRAME fGoToRecord

        c-estabini-filter AT ROW 1.21 COL 19.72 COLON-ALIGNED
        im-last0   AT ROW 1.21 COL 23.71 COLON-ALIGNED
        im-first0  AT ROW 1.21 COL 28.71 COLON-ALIGNED
        c-estabfim-filter AT ROW 1.21 COL 31.72 COLON-ALIGNED NO-LABEL

        d-orderedini-filter AT ROW 2.21 COL 13.72 COLON-ALIGNED
        im-last1   AT ROW 2.21 COL 23.71 COLON-ALIGNED
        im-first1  AT ROW 2.21 COL 28.71 COLON-ALIGNED
        d-orderedfim-filter AT ROW 2.21 COL 31.72 COLON-ALIGNED NO-LABEL
        
        d-emissaoini-filter AT ROW 3.21 COL 13.72 COLON-ALIGNED
        im-last2   AT ROW 3.21 COL 23.71 COLON-ALIGNED
        im-first2  AT ROW 3.21 COL 28.71 COLON-ALIGNED
        d-emissaofim-filter AT ROW 3.21 COL 31.72 COLON-ALIGNED NO-LABEL

        c-especieini-filter AT ROW 4.21 COL 19.72 COLON-ALIGNED
        im-last3   AT ROW 4.21 COL 23.71 COLON-ALIGNED
        im-first3  AT ROW 4.21 COL 28.71 COLON-ALIGNED
        c-especiefim-filter AT ROW 4.21 COL 31.72 COLON-ALIGNED NO-LABEL

        c-portadorini-filter AT ROW 5.21 COL 17.72 COLON-ALIGNED
        im-last4   AT ROW 5.21 COL 23.71 COLON-ALIGNED
        im-first4  AT ROW 5.21 COL 28.71 COLON-ALIGNED
        c-portadorfim-filter AT ROW 5.21 COL 31.72 COLON-ALIGNED NO-LABEL

        c-tituloini-filter AT ROW 6.21 COL 13.72 COLON-ALIGNED
        im-last5   AT ROW 6.21 COL 23.71 COLON-ALIGNED
        im-first5  AT ROW 6.21 COL 28.71 COLON-ALIGNED
        c-titulofim-filter AT ROW 6.21 COL 31.72 COLON-ALIGNED NO-LABEL

        c-titulodevini-filter AT ROW 7.21 COL 13.72 COLON-ALIGNED
        im-last6   AT ROW 7.21 COL 23.71 COLON-ALIGNED
        im-first6  AT ROW 7.21 COL 28.71 COLON-ALIGNED
        c-titulodevfim-filter AT ROW 7.21 COL 31.72 COLON-ALIGNED NO-LABEL

        c-clienteini-filter AT ROW 8.21 COL 13.72 COLON-ALIGNED
        im-last7   AT ROW 8.21 COL 23.71 COLON-ALIGNED
        im-first7  AT ROW 8.21 COL 28.71 COLON-ALIGNED
        c-clientefim-filter AT ROW 8.21 COL 31.72 COLON-ALIGNED NO-LABEL
                
        btGoToOK          AT ROW 9.63 COL 2.14
        btGoToCancel      AT ROW 9.63 COL 13
        rtGoToButton      AT ROW 9.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Faixa" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:

        ASSIGN c-estabini-filter
               c-estabfim-filter
               d-orderedini-filter               
               d-orderedfim-filter               
               d-emissaoini-filter               
               d-emissaofim-filter               
               c-especieini-filter               
               c-especiefim-filter               
               c-portadorini-filter              
               c-portadorfim-filter        
               c-tituloini-filter
               c-titulofim-filter
               c-titulodevini-filter
               c-titulodevfim-filter
               c-clienteini-filter
               c-clientefim-filter
               c-estabini     = c-estabini-filter
               c-estabfim     = c-estabfim-filter
               d-orderedini   = d-orderedini-filter
               d-orderedfim   = d-orderedfim-filter
               d-emissaoini   = d-emissaoini-filter 
               d-emissaofim   = d-emissaofim-filter 
               c-especieini   = c-especieini-filter 
               c-especiefim   = c-especiefim-filter 
               c-portadorini  = c-portadorini-filter
               c-portadorfim  = c-portadorfim-filter
               c-tituloini    = c-tituloini-filter
               c-titulofim    = c-titulofim-filter
               c-titulodevini = c-titulodevini-filter
               c-titulodevfim = c-titulodevfim-filter
               c-clienteini   = c-clienteini-filter
               c-clientefim   = c-clientefim-filter.

        /*{&OPEN-QUERY-{&BROWSE-NAME}}*/
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN c-estabini-filter:SCREEN-VALUE     = ""
               c-estabfim-filter:SCREEN-VALUE     = "ZZZ"
               d-orderedini-filter:SCREEN-VALUE   = "01/01/1900"
               d-orderedfim-filter:SCREEN-VALUE   = "31/12/9999"
               d-emissaoini-filter:SCREEN-VALUE   = "01/01/1900" 
               d-emissaofim-filter:SCREEN-VALUE   = "31/12/9999"
               c-especieini-filter:SCREEN-VALUE   = "" 
               c-especiefim-filter:SCREEN-VALUE   = "ZZ"
               c-portadorini-filter:SCREEN-VALUE  = "" 
               c-portadorfim-filter:SCREEN-VALUE  = "ZZZZZ"
               c-tituloini-filter:SCREEN-VALUE    = "" 
               c-titulofim-filter:SCREEN-VALUE    = "ZZZZZZZZZZ"
               c-titulodevini-filter:SCREEN-VALUE = ""
               c-titulodevfim-filter:SCREEN-VALUE = "ZZZZZZZZZZ"
               c-clienteini-filter:SCREEN-VALUE   = "0"
               c-clientefim-filter:SCREEN-VALUE   = "99999999".
    END.
    
    ENABLE c-estabini-filter
           c-estabfim-filter
           d-orderedini-filter
           d-orderedfim-filter
           d-emissaoini-filter
           d-emissaofim-filter
           c-especieini-filter
           c-especiefim-filter
           c-portadorini-filter
           c-portadorfim-filter  
           c-tituloini-filter
           c-titulofim-filter
           c-titulodevini-filter
           c-titulodevfim-filter
           c-clienteini-filter
           c-clientefim-filter
           btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 

    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-first C-Win 
PROCEDURE pi-first :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND FIRST emscad.cliente NO-LOCK NO-ERROR.

acha_tit:
REPEAT:

    for each estabelecimento no-lock
        where estabelecimento.cod_estab >= c-estabini
          and estabelecimento.cod_estab <= c-estabfim:

        /* T°tulos transferidos para o 102 e 103 */
        IF estabelecimento.cod_estab = '201'
        OR estabelecimento.cod_estab = '301'
           THEN NEXT.
    
        IF can-find(FIRST tit_acr NO-LOCK
            WHERE tit_acr.cod_estab           = estabelecimento.cod_estab
            AND   tit_acr.cdn_cliente         = emscad.cliente.cdn_cliente
            AND   tit_acr.dat_vencto_tit_acr  >= d-orderedini 
            AND   tit_acr.dat_vencto_tit_acr  <= d-orderedfim 
            AND   tit_acr.dat_emis_docto      >= d-emissaoini 
            AND   tit_acr.dat_emis_docto      <= d-emissaofim 
            AND   tit_acr.cod_espec_docto     >= c-especieini 
            AND   tit_acr.cod_espec_docto     <= c-especiefim 
            AND   tit_acr.cod_portador        >= c-portadorini
            AND   tit_acr.cod_portador        <= c-portadorfim
            AND   tit_acr.cod_tit_acr         >= c-tituloini
            AND   tit_acr.cod_tit_acr         <= c-titulofim
            /*AND   tit_acr.log_sdo_tit_acr     = YES*/
            AND   tit_acr.val_sdo_tit_acr      > 0 USE-INDEX titacr_cliente) THEN
            LEAVE acha_tit.
            
    end.
    
    FIND NEXT emscad.cliente NO-LOCK NO-ERROR.
    
    IF NOT AVAIL emscad.cliente THEN DO:
        LEAVE.
    END.

END.


IF AVAIL emscad.cliente THEN DO:
    RUN pi-display.

    DISABLE btFirst btPrev
        WITH FRAME {&FRAME-NAME}.

    ASSIGN MENU-ITEM miFirst:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miPrev:SENSITIVE IN MENU smFile = FALSE.

    ENABLE btNext btLast
        WITH FRAME {&FRAME-NAME}.

    ASSIGN MENU-ITEM miNext:SENSITIVE IN MENU smFile = TRUE
           MENU-ITEM miLast:SENSITIVE IN MENU smFile = TRUE.
END.
ELSE DO:
    MESSAGE "N∆o existe nenhum registro na tabela!" VIEW-AS ALERT-BOX ERROR.
    DISABLE ALL EXCEPT btExit btHelp
        WITH FRAME {&FRAME-NAME}.
    ASSIGN MENU-ITEM miFirst:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miNext:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miPrev:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miLast:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miDetalhe:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miPesquisa:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miFaixa:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miRelat:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miMail:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miGeracao:SENSITIVE IN MENU smFile = FALSE
           MENU-ITEM miAcordo:SENSITIVE IN MENU smFile = FALSE.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-geracao C-Win 
PROCEDURE pi-geracao :
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
         SIZE 78 BY 1.42
         BGCOLOR 7.

    DEFINE VARIABLE i-empresa AS INT LABEL "Empresa Cobranáa"
        VIEW-AS COMBO-BOX SORT AUTO-COMPLETION
        LIST-ITEM-PAIRS "Valorem",1,"Global",2,"Averbach",3,"Dejuris",4,"Angeza",5,"Payment",6,"Gold Star",7,"AM Assessoria e Cobranáa",8,"Cobrance",9,"Progress",10,"Soliduz",11,"Talk Cobranáas",12,"Duarte",13
        SIZE 20 BY .88 NO-UNDO.

    DEFINE VARIABLE c-arquivo1 AS CHAR FORMAT "x(256)" LABEL "Arquivo de T°tulos"
        VIEW-AS FILL-IN 
        SIZE 50 BY .88 NO-UNDO.

    DEFINE VARIABLE c-arquivo2 AS CHAR FORMAT "x(256)" LABEL "Arquivo de T°tulos Enviados"
        VIEW-AS FILL-IN 
        SIZE 50 BY .88 NO-UNDO.

    DEFINE VARIABLE c-arquivo3 AS CHAR FORMAT "x(256)" LABEL "Arquivo de Clientes"
        VIEW-AS FILL-IN 
        SIZE 50 BY .88 NO-UNDO.

    DEFINE BUTTON bt-arquivo1 
        IMAGE-UP FILE "adeicon/open.bmp":U
        LABEL "" 
        SIZE 3.86 BY 1.08 TOOLTIP "Localiza Arquivo".

    DEFINE BUTTON bt-arquivo2 
        IMAGE-UP FILE "adeicon/open.bmp":U
        LABEL "" 
        SIZE 3.86 BY 1.08 TOOLTIP "Localiza Arquivo".

    DEFINE BUTTON bt-arquivo3 
        IMAGE-UP FILE "adeicon/open.bmp":U
        LABEL "" 
        SIZE 3.86 BY 1.08 TOOLTIP "Localiza Arquivo".
    
    /* os itens do combo-box acima devem vir da base de dados */

    DEFINE FRAME fGoToRecord
        i-empresa         AT ROW 1.71 COL 19.5 COLON-ALIGNED
        c-arquivo1        AT ROW 3.21 COL 19.5 COLON-ALIGNED
        bt-arquivo1       AT ROW 3.11 COL 69.5 COLON-ALIGNED  
        c-arquivo2        AT ROW 4.21 COL 19.5 COLON-ALIGNED
        bt-arquivo2       AT ROW 4.11 COL 69.5 COLON-ALIGNED
        c-arquivo3        AT ROW 5.21 COL 19.5 COLON-ALIGNED
        bt-arquivo3       AT ROW 5.11 COL 69.5 COLON-ALIGNED
        btGoToOK          AT ROW 7.03 COL 2.14
        btGoToCancel      AT ROW 7.03 COL 13
        rtGoToButton      AT ROW 6.78 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Geraá∆o" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "VALUE-CHANGED":U OF i-empresa IN FRAME fGoToRecord DO:
        IF INPUT FRAME fGoToRecord i-empresa = 1 
        THEN DO: 
             DISABLE c-arquivo3
                     bt-arquivo3 
                 WITH FRAME fGoToRecord.
             ASSIGN c-arquivo1 = "c:/assessorias/Valorem.csv"    
                    c-arquivo2 = "c:/assessorias/cliValorem.lst"
                    c-arquivo3 = "".   
             DISP c-arquivo1 
                  c-arquivo2
                  c-arquivo3
                 WITH FRAME fGoToRecord. 
        END.
        IF INPUT FRAME fGoToRecord i-empresa = 2 
        THEN DO: 
             DISABLE c-arquivo3
                     bt-arquivo3
                 WITH FRAME fGoToRecord. 
             ASSIGN c-arquivo1 = "c:/assessorias/global.txt"    
                    c-arquivo2 = "c:/assessorias/cliglo.lst"
                    c-arquivo3 = "".   
             DISP c-arquivo1 
                  c-arquivo2
                  c-arquivo3
                 WITH FRAME fGoToRecord. 
        END.
        IF INPUT FRAME fGoToRecord i-empresa = 3 
        THEN DO: 
             DISABLE c-arquivo3
                     bt-arquivo3
                 WITH FRAME fGoToRecord. 
             ASSIGN c-arquivo1 = "c:/assessorias/INTELBRAS" + STRING(DAY(TODAY), "99") + STRING(MONTH(TODAY), "99") + SUBSTRING(STRING(YEAR(TODAY), "9999"), 3, 2) + "01.txt"    
                    c-arquivo2 = "c:/assessorias/cliaverb.lst"
                    c-arquivo3 = "".   
             DISP c-arquivo1 
                  c-arquivo2
                  c-arquivo3
                 WITH FRAME fGoToRecord. 
        END.
        IF INPUT FRAME fGoToRecord i-empresa = 4 
        THEN DO: 
             DISABLE c-arquivo3
                     bt-arquivo3
                 WITH FRAME fGoToRecord. 
             ASSIGN c-arquivo1 = "c:/assessorias/dejuris.txt"    
                    c-arquivo2 = "c:/assessorias/clideju.lst"
                    c-arquivo3 = "".   
             DISP c-arquivo1 
                  c-arquivo2
                  c-arquivo3
                 WITH FRAME fGoToRecord. 
        END.

        IF INPUT FRAME fGoToRecord i-empresa = 5 
        THEN DO: 
             DISABLE c-arquivo3
                     bt-arquivo3
                 WITH FRAME fGoToRecord. 
             ASSIGN c-arquivo1 = "c:/assessorias/Angeza.csv"    
                    c-arquivo2 = "c:/assessorias/cliAngez.lst"
                    c-arquivo3 = "".   
             DISP c-arquivo1 
                  c-arquivo2
                  c-arquivo3
                 WITH FRAME fGoToRecord. 
        END.

        IF INPUT FRAME fGoToRecord i-empresa = 6
        THEN DO: 
             DISABLE c-arquivo3
                     bt-arquivo3
                 WITH FRAME fGoToRecord. 
             ASSIGN c-arquivo1 = "c:/assessorias/Payment.csv"    
                    c-arquivo2 = "c:/assessorias/cliPayment.lst"
                    c-arquivo3 = "".   
             DISP c-arquivo1 
                  c-arquivo2
                  c-arquivo3
                 WITH FRAME fGoToRecord. 
        END.

        IF INPUT FRAME fGoToRecord i-empresa = 7 
        THEN DO: 
             DISABLE c-arquivo3
                     bt-arquivo3
                 WITH FRAME fGoToRecord. 
             ASSIGN c-arquivo1 = "c:/assessorias/GoldStar.csv"    
                    c-arquivo2 = "c:/assessorias/cliGold.lst"
                    c-arquivo3 = "".   
             DISP c-arquivo1 
                  c-arquivo2
                  c-arquivo3
                 WITH FRAME fGoToRecord. 
        END.

        IF INPUT FRAME fGoToRecord i-empresa = 8 
        THEN DO: 
             DISABLE c-arquivo3
                     bt-arquivo3
                 WITH FRAME fGoToRecord. 
             ASSIGN c-arquivo1 = "c:/assessorias/AmAssessoriaeCob.csv"    
                    c-arquivo2 = "c:/assessorias/cliAmAssessoriaeCob.lst"
                    c-arquivo3 = "".   
             DISP c-arquivo1 
                  c-arquivo2
                  c-arquivo3
                 WITH FRAME fGoToRecord. 
        END.

        IF INPUT FRAME fGoToRecord i-empresa = 9 
        THEN DO: 
             DISABLE c-arquivo3
                     bt-arquivo3
                 WITH FRAME fGoToRecord. 
             ASSIGN c-arquivo1 = "c:/assessorias/Cobrance.csv"    
                    c-arquivo2 = "c:/assessorias/cliCobran.lst"
                    c-arquivo3 = "".   
             DISP c-arquivo1 
                  c-arquivo2
                  c-arquivo3
                 WITH FRAME fGoToRecord. 
        END.

        IF INPUT FRAME fGoToRecord i-empresa = 10
        THEN DO: 
             DISABLE c-arquivo3
                     bt-arquivo3
                 WITH FRAME fGoToRecord. 
             ASSIGN c-arquivo1 = "c:/assessorias/Progress.csv"    
                    c-arquivo2 = "c:/assessorias/cliProgress.lst"
                    c-arquivo3 = "".   
             DISP c-arquivo1 
                  c-arquivo2
                  c-arquivo3
                 WITH FRAME fGoToRecord. 
        END.

        IF INPUT FRAME fGoToRecord i-empresa = 11
        THEN DO: 
             DISABLE c-arquivo3
                     bt-arquivo3 
                 WITH FRAME fGoToRecord.
             ASSIGN c-arquivo1 = "c:/assessorias/Soliduz.csv"    
                    c-arquivo2 = "c:/assessorias/cliSoliduz.lst"
                    c-arquivo3 = "".   
             DISP c-arquivo1 
                  c-arquivo2
                  c-arquivo3
                 WITH FRAME fGoToRecord. 
        END.

        IF INPUT FRAME fGoToRecord i-empresa = 12
        THEN DO: 
             DISABLE c-arquivo3
                     bt-arquivo3 
                 WITH FRAME fGoToRecord.
             ASSIGN c-arquivo1 = "c:/assessorias/Talk.csv"    
                    c-arquivo2 = "c:/assessorias/cliTalk.lst"
                    c-arquivo3 = "".   
             DISP c-arquivo1 
                  c-arquivo2
                  c-arquivo3
                 WITH FRAME fGoToRecord. 
        END.

        IF INPUT FRAME fGoToRecord i-empresa = 13
        THEN DO: 
             DISABLE c-arquivo3
                     bt-arquivo3 
                 WITH FRAME fGoToRecord.
             ASSIGN c-arquivo1 = "c:/assessorias/Duarte.csv"    
                    c-arquivo2 = "c:/assessorias/cliDuarte.lst"
                    c-arquivo3 = "".   
             DISP c-arquivo1 
                  c-arquivo2
                  c-arquivo3
                 WITH FRAME fGoToRecord. 
        END.
    END.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-empresa
               c-arquivo1
               c-arquivo2
               c-arquivo3.
        
        IF SESSION:SET-WAIT-STATE("general") THEN.
        if i-empresa = 1 then
            run pi-Valorem (INPUT c-arquivo1,
                             INPUT c-arquivo2,
                             INPUT c-arquivo3).
        if i-empresa = 2 then
            run pi-global (INPUT c-arquivo1,
                           INPUT c-arquivo2,
                           INPUT c-arquivo3).
        if i-empresa = 3 then
            run pi-averbach (INPUT c-arquivo1,
                             INPUT c-arquivo2,
                             INPUT c-arquivo3).
        if i-empresa = 4 then
            run pi-dejuris (INPUT c-arquivo1,
                            INPUT c-arquivo2,
                            INPUT c-arquivo3).
        if i-empresa = 5 then
            run pi-angeza (INPUT c-arquivo1,
                           INPUT c-arquivo2,
                           INPUT c-arquivo3).
        if i-empresa = 6 then
            run pi-payment (INPUT c-arquivo1,
                            INPUT c-arquivo2,
                            INPUT c-arquivo3).
        if i-empresa = 7 then
            run pi-GoldStar (INPUT c-arquivo1,
                             INPUT c-arquivo2,
                             INPUT c-arquivo3).
        if i-empresa = 8 then
            run pi-AMAssessoriaeCob(INPUT c-arquivo1,
                                    INPUT c-arquivo2,
                                    INPUT c-arquivo3).
        if i-empresa = 9 then
            run pi-cobrance (INPUT c-arquivo1,
                             INPUT c-arquivo2,
                             INPUT c-arquivo3).

        if i-empresa = 10 then
            run pi-progress (INPUT c-arquivo1,
                             INPUT c-arquivo2,
                             INPUT c-arquivo3).

        if i-empresa = 11 then
            run pi-Soliduz (INPUT c-arquivo1,
                            INPUT c-arquivo2,
                            INPUT c-arquivo3).

        if i-empresa = 12 then
            run pi-talk (INPUT c-arquivo1,
                         INPUT c-arquivo2,
                         INPUT c-arquivo3).

        if i-empresa = 13 then
            run pi-duarte (INPUT c-arquivo1,
                         INPUT c-arquivo2,
                         INPUT c-arquivo3).

        IF SESSION:SET-WAIT-STATE("") THEN.

        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    ON "CHOOSE":U OF bt-arquivo1 IN FRAME fGoToRecord DO:
        def var c-arq-conv  as char no-undo.
        def var l-ok        as logical init no.
    
        assign c-arq-conv = replace(input frame fGoToRecord c-arquivo1, "/", "\").
        SYSTEM-DIALOG GET-FILE c-arq-conv
           FILTERS "*.sdf" "*.sdf",
                   "*.txt" "*.txt",
                   "*.lst" "*.lst",
                   "*.*" "*.*"
           ASK-OVERWRITE 
           DEFAULT-EXTENSION "sdf"
           INITIAL-DIR "spool" 
           SAVE-AS
           USE-FILENAME
           UPDATE l-ok.
    
        if  l-ok = yes then do:
            assign c-arq-conv = replace(c-arq-conv, "\", "/"). 
            display c-arq-conv @ c-arquivo1 with frame fGoToRecord.
        end.
    END.

    ON "CHOOSE":U OF bt-arquivo2 IN FRAME fGoToRecord DO:
        def var c-arq-conv  as char no-undo.
        def var l-ok        as logical init no.
    
        assign c-arq-conv = replace(input frame fGoToRecord c-arquivo2, "/", "\").
        SYSTEM-DIALOG GET-FILE c-arq-conv
           FILTERS "*.sdf" "*.sdf",
                   "*.lst" "*.lst",
                   "*.txt" "*.txt", 
                   "*.*" "*.*"
           ASK-OVERWRITE 
           DEFAULT-EXTENSION "sdf"
           INITIAL-DIR "spool" 
           SAVE-AS
           USE-FILENAME
           UPDATE l-ok.
    
        if  l-ok = yes then do:
            assign c-arq-conv = replace(c-arq-conv, "\", "/"). 
            display c-arq-conv @ c-arquivo2 with frame fGoToRecord.
        end.
    END.

    ON "CHOOSE":U OF bt-arquivo3 IN FRAME fGoToRecord DO:
        def var c-arq-conv  as char no-undo.
        def var l-ok        as logical init no.
        
        assign c-arq-conv = replace(input frame fGoToRecord c-arquivo3, "/", "\").
        SYSTEM-DIALOG GET-FILE c-arq-conv
           FILTERS "*.lst" "*.lst",
                   "*.sdf" "*.sdf",
                   "*.txt" "*.txt", 
                   "*.*" "*.*"
           ASK-OVERWRITE 
           DEFAULT-EXTENSION "lst"
           INITIAL-DIR "spool" 
           SAVE-AS
           USE-FILENAME
           UPDATE l-ok.
    
        if  l-ok = yes then do:
            assign c-arq-conv = replace(c-arq-conv, "\", "/"). 
            display c-arq-conv @ c-arquivo3 with frame fGoToRecord.
        end.
    END.

    ASSIGN i-empresa:SCREEN-VALUE IN FRAME fGoToRecord = "1".
    APPLY "VALUE-CHANGED" TO i-empresa IN FRAME fGoToRecord.
    
    ENABLE i-empresa  
           btGoToOK 
           btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-global C-Win 
PROCEDURE pi-global :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-arquivo1 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo2 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo3 AS CHAR FORMAT "x(256)".

    DEF VAR i-seqtemp AS INT NO-UNDO.

    FOR EACH tt_tit_acr_enviado:
        DELETE tt_tit_acr_enviado.
    END.

    /*   Message "Gerando Arquivo de Titulos ....".   */
    OUTPUT TO VALUE(p-arquivo1) PAGE-SIZE 0.
    ASSIGN i-contador = 0.
    FOR EACH  tt_int_tit_acr,
        FIRST mgesp.int_tit_acr EXCLUSIVE-LOCK
        WHERE int_tit_acr.cod_estab      = tt_int_tit_acr.cod_estab 
        AND   int_tit_acr.num_id_tit_acr = tt_int_tit_acr.num_id_tit_acr
        AND   int_tit_acr.ind_sit_envio = "Selecionado",
        FIRST tit_acr NO-LOCK
              WHERE tit_acr.cod_estab = INT_tit_acr.cod_estab
              AND   tit_acr.num_id_tit_acr = int_tit_acr.num_id_tit_acr,
        FIRST emscad.cliente NO-LOCK
            WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente
        BREAK BY tit_acr.cdn_cliente:
        ASSIGN c-ender     = ""
               c-bairro    = ""
               c-cid       = ""
               c-uf        = ""
               c-cgc       = ""
               c-email     = ""
               c-ins-estad = ""
               c-ins-munic = ""
               c-cep       = "".
        IF emscad.cliente.num_pessoa MODULO 2 = 0 THEN DO:
            FIND pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_fisic THEN
                ASSIGN c-ender     = pessoa_fisic.nom_endereco 
                       c-bairro    = pessoa_fisic.nom_bairro
                       c-cid       = pessoa_fisic.nom_cidade
                       c-uf        = pessoa_fisic.cod_unid_federac
                       c-cep       = pessoa_fisic.cod_cep
                       c-cgc       = pessoa_fisic.cod_id_feder
                       c-email     = pessoa_fisic.cod_e_mail
                       c-ins-estad = ""
                       c-ins-munic = ""
                       c-fone      = pessoa_fisic.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","")
                       c-nome-emit = pessoa_fisic.nom_pessoa.
        END.
        ELSE DO:
            FIND pessoa_jurid NO-LOCK
                WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_jurid THEN DO:
                IF pessoa_jurid.nom_endereco      = pessoa_jurid.nom_ender_cobr 
                OR pessoa_jurid.nom_ender_cobr = "" THEN
                    ASSIGN c-ender     = pessoa_jurid.nom_endereco 
                           c-bairro    = pessoa_jurid.nom_bairro
                           c-cid       = pessoa_jurid.nom_cidade
                           c-uf        = pessoa_jurid.cod_unid_federac
                           c-cep       = pessoa_jurid.cod_cep
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail.
                ELSE 
                    ASSIGN c-ender     = pessoa_jurid.nom_ender_cobr
                           c-bairro    = pessoa_jurid.nom_bairro_cobr
                           c-cid       = pessoa_jurid.nom_cidad_cobr
                           c-uf        = pessoa_jurid.cod_unid_federac_cobr
                           c-cep       = pessoa_jurid.cod_cep_cobr
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail_cobr.
                 ASSIGN c-ins-estad = pessoa_jurid.cod_id_estad_jurid
                        c-ins-munic = pessoa_jurid.cod_id_munic_jurid
                        c-nome-emit = pessoa_jurid.nom_pessoa
                        c-fone      = pessoa_jurid.cod_telefone
                        c-fone      = REPLACE(c-fone,"-","")
                        c-fone      = REPLACE(c-fone,")","")
                        c-fone      = REPLACE(c-fone,"(","")
                        c-fone      = REPLACE(c-fone," ","").
            END.
        END.
        IF FIRST-OF(tit_acr.cdn_cliente) THEN DO:
            FIND LAST histor_clien NO-LOCK
               WHERE histor_clien.cod_empresa = emscad.cliente.cod_empresa
               AND   histor_clien.cdn_cliente = emscad.cliente.cdn_cliente NO-ERROR.
            IF NOT AVAIL histor_clien THEN DO:
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Global"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Global" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
            ELSE DO: 
                ASSIGN i-seqtemp = histor_clien.num_seq_histor_clien.
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = i-seqtemp + 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Global"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Global" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
        END.
            
        ASSIGN i-contador   = i-contador + 1
               c-numero     = STRING(tit_acr.cod_tit_acr)
               c-parcela    = STRING(tit_acr.cod_parcela)
               c-data       = SUBSTR(STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_vencto_tit_acr), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_vencto_tit_acr),"99"),1,2)
               c-data-emis  = SUBSTR(STRING(YEAR(tit_acr.dat_emis_docto),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_emis_docto), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_emis_docto),"99"),1,2)
               c-esp        = "DP"
               c-vl-titulo = STRING(tit_acr.val_sdo_tit_acr, ">>>,>>>,>>9.99").
               c-vl-titulo = REPLACE(c-vl-titulo,",","." ).                    
               c-vl-cart   = STRING(int_tit_acr.val_desp_cartorio, ">>>,>>>,>>9.99").
               c-vl-cart   = REPLACE(c-vl-cart,",",".").                    

        PUT "82901000000127" FORMAT "X(14)"
            "Intelbras S/A - Ind. Telec. Eletronica Brasileira " 
            FORMAT "X(50)"
            c-cgc FORMAT "X(14)"
            c-nome-emit             FORMAT "!(50)"      
            c-ender                 FORMAT "X(50)"      
            c-bairro                FORMAT "X(20)"      
            c-cid                   FORMAT "!(20)"       
            c-uf                    FORMAT "!(02)"      
            c-cep                   FORMAT "99999999"   
            c-fone                  FORMAT "X(11)"
            c-esp 
            INT(c-numero)           FORMAT "999999999999"   
            c-parcela
            SUBSTR(c-data-emis,7,2) FORMAT "99"
            "/"
            SUBSTR(c-data-emis,5,2) FORMAT "99"
            "/"
            SUBSTR(c-data-emis,1,4) FORMAT "9999"
            SUBSTR(c-data,7,2)      FORMAT "99"
            "/"
            SUBSTR(c-data,5,2)      FORMAT "99"
            "/"
            SUBSTR(c-data,1,4)      FORMAT "9999"
            c-vl-titulo             FORMAT "999999999999999" 
            c-vl-cart               FORMAT "999999999999999"  SKIP.
                                                   
        /*****  Atualiza para os titulos para ENVIADO e armazena DATA DO ENVIO  *****/
        ASSIGN int_tit_acr.ind_sit_envio      = "Enviado"
               int_tit_acr.dat_envi_asses_cob = TODAY.
        
        /***** Cria TT de Titulos de Enviados  *****/
        CREATE tt_tit_acr_enviado.
        ASSIGN tt_tit_acr_enviado.cod_estab          = tit_acr.cod_estab
               tt_tit_acr_enviado.cod_espec_docto    = tit_acr.cod_espec_docto   
               tt_tit_acr_enviado.cod_ser_docto      = tit_acr.cod_ser_docto     
               tt_tit_acr_enviado.cod_tit_acr        = tit_acr.cod_tit_acr       
               tt_tit_acr_enviado.cod_parcela        = tit_acr.cod_parcela       
               tt_tit_acr_enviado.dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
               tt_tit_acr_enviado.dat_emis_docto     = tit_acr.dat_emis_docto    
               tt_tit_acr_enviado.cod_portador       = tit_acr.cod_portador      
               tt_tit_acr_enviado.cod_cart_bcia      = tit_acr.cod_cart_bcia     
               tt_tit_acr_enviado.cdn_cliente        = tit_acr.cdn_cliente       
               tt_tit_acr_enviado.nom_abrev          = emscad.cliente.nom_abrev        
               tt_tit_acr_enviado.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
               tt_tit_acr_enviado.val_origin_tit_acr = tit_acr.val_origin_tit_acr
               tt_tit_acr_enviado.val_desp_cartorio   = int_tit_acr.val_desp_cartorio.

    END.         /******* FOR EACH TITULO *********/
            
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.
            
    ASSIGN de-tot-car = 0
           de-tot-cli = 0.
              
    /***** "Gerando Arquivo de Titulos Enviados....".   *****/
    OUTPUT TO VALUE(p-arquivo2) PAGE-SIZE 0.
    ASSIGN i-contador = 0.
    FOR EACH tt_tit_acr_enviado NO-LOCK
        BREAK BY tt_tit_acr_enviado.cdn_cliente
              BY tt_tit_acr_enviado.dat_vencto_tit_acr:
        
        FIND FIRST emscad.cliente NO-LOCK
             WHERE emscad.cliente.cdn_cliente = tt_tit_acr_enviado.cdn_cliente NO-ERROR. 
        IF FIRST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(22)
               "Titulos Enviados Global - "
               TODAY FORMAT "99/99/9999" SKIP(2)
               "Esp Ser Titulo    /P  Emissao   Vencto Port /Car "
               "Codigo       Nome Abrev      Valo Cartorio   Valor Original" SKIP 
               "--- --- ------------ -------- -------- ----- --- "
               "-----------  --------------- --------------- ---------------" SKIP.
        END.

        ASSIGN de-tot-car = de-tot-car + tt_tit_acr_enviado.val_desp_cartorio
               de-tot-cli = de-tot-cli + tt_tit_acr_enviado.val_sdo_tit_acr.
                 
        PUT tt_tit_acr_enviado.cod_espec_docto    " "
            tt_tit_acr_enviado.cod_ser_docto      " "
            tt_tit_acr_enviado.cod_tit_acr  
            tt_tit_acr_enviado.cod_parcela        " "
            tt_tit_acr_enviado.dat_emis_docto     FORMAT "99/99/99" " "
            tt_tit_acr_enviado.dat_vencto_tit_acr FORMAT "99/99/99" " "
            tt_tit_acr_enviado.cod_portador       " " 
            tt_tit_acr_enviado.cod_cart_bcia      " "
            tt_tit_acr_enviado.cdn_cliente        "  "
            tt_tit_acr_enviado.nom_abrev          FORMAT "x(15)" " "
            tt_tit_acr_enviado.val_desp_cartorio  " "
            tt_tit_acr_enviado.val_sdo_tit_acr    SKIP.

        IF LAST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(38) "   Totais do Cliente"
               de-tot-car   "  "  
               de-tot-cli.
           IF LINE-COUNTER > 48 THEN 
              PAGE.
           ELSE 
              PUT SKIP(6).
              
           ASSIGN de-tot-car = 0 
                  de-tot-cli = 0.
        END.
    END. /****** FOR EACH tt_tit_acr_enviado ******/
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.

    FOR EACH tt_tit_acr_enviado:
        FIND tit_acr NO-LOCK
             WHERE tit_acr.cod_estab         = tt_tit_acr_enviado.cod_estab      
             AND   tit_acr.cod_espec_docto   = tt_tit_acr_enviado.cod_espec_docto
             AND   tit_acr.cod_ser_docto     = tt_tit_acr_enviado.cod_ser_docto  
             AND   tit_acr.cod_tit_acr       = tt_tit_acr_enviado.cod_tit_acr    
             AND   tit_acr.cod_parcela       = tt_tit_acr_enviado.cod_parcela    NO-ERROR.
        RUN piAlteraTitulo (INPUT  "9926",
                            INPUT  "90",
                            INPUT  "Global",
                            OUTPUT vRetorno).  
        
        IF vRetorno = "OK" THEN
           DELETE tt_tit_acr_enviado.
    END. /*  FOR EACH tt_tit_acr_enviado  */  
    FOR EACH  tt_int_tit_acr:
        DELETE tt_int_tit_acr.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gotorecord C-Win 
PROCEDURE pi-gotorecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF VAR cod-cli AS CHAR NO-UNDO.

    ASSIGN cod-cli = INPUT FRAME {&FRAME-NAME} cod-cliente.
   
    FIND emscad.cliente NO-LOCK
        WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
          and emscad.cliente.cdn_cliente = int(cod-cli) NO-ERROR.
    IF NOT AVAIL emscad.cliente THEN DO:
        FIND emscad.cliente NO-LOCK
            WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
              and emscad.cliente.nom_abrev   = cod-cli NO-ERROR.
        IF NOT AVAIL emscad.cliente THEN DO:
            ASSIGN cod-cli = REPLACE(cod-cli, '.', '')
                   cod-cli = REPLACE(cod-cli, '/', '')
                   cod-cli = REPLACE(cod-cli, '-', '').
            FIND emscad.cliente NO-LOCK
                WHERE emscad.cliente.cod_empresa  = v_cod_empres_usuar
                  AND emscad.cliente.cod_pais     = "bra"
                  and emscad.cliente.cod_id_feder = cod-cli NO-ERROR.
            IF NOT AVAIL emscad.cliente THEN DO:
                MESSAGE "Cliente n∆o existe para a chave informada!" VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY" TO cod-cliente IN FRAME {&FRAME-NAME}.
                RETURN NO-APPLY.
            END.
        END.
    END.

    IF  AVAIL emscad.cliente THEN DO:
        RUN pi-display.        
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-last C-Win 
PROCEDURE pi-last :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND LAST emscad.cliente NO-LOCK NO-ERROR.

acha_tit:
REPEAT:

    for each estabelecimento no-lock
        where estabelecimento.cod_estab >= c-estabini
          and estabelecimento.cod_estab <= c-estabfim:

        /* T°tulos transferidos para o 102 e 103 */
        IF estabelecimento.cod_estab = '201'
        OR estabelecimento.cod_estab = '301'
           THEN NEXT.
           
        IF can-find(FIRST tit_acr NO-LOCK
            WHERE tit_acr.cod_estab           = estabelecimento.cod_estab
            AND   tit_acr.cdn_cliente         = emscad.cliente.cdn_cliente
            AND   tit_acr.dat_vencto_tit_acr  >= d-orderedini 
            AND   tit_acr.dat_vencto_tit_acr  <= d-orderedfim 
            AND   tit_acr.dat_emis_docto      >= d-emissaoini 
            AND   tit_acr.dat_emis_docto      <= d-emissaofim 
            AND   tit_acr.cod_espec_docto     >= c-especieini 
            AND   tit_acr.cod_espec_docto     <= c-especiefim 
            AND   tit_acr.cod_portador        >= c-portadorini
            AND   tit_acr.cod_portador        <= c-portadorfim
            AND   tit_acr.cod_tit_acr         >= c-tituloini
            AND   tit_acr.cod_tit_acr         <= c-titulofim
            /*AND   tit_acr.log_sdo_tit_acr     = YES*/
            AND   tit_acr.val_sdo_tit_acr      > 0 USE-INDEX titacr_cliente) THEN
            LEAVE acha_tit.
            
    end.
    
    FIND PREV emscad.cliente NO-LOCK NO-ERROR.
    
    IF NOT AVAIL emscad.cliente THEN DO:
        LEAVE.
    END.

END.
RUN pi-display.

DISABLE btLast
        btNext
    WITH FRAME {&FRAME-NAME}.

ASSIGN MENU-ITEM miLast:SENSITIVE IN MENU smFile = FALSE
       MENU-ITEM miNext:SENSITIVE IN MENU smFile = FALSE.

ENABLE btFirst
       btPrev
    WITH FRAME {&FRAME-NAME}.

ASSIGN MENU-ITEM miFirst:SENSITIVE IN MENU smFile = TRUE
       MENU-ITEM miPrev:SENSITIVE IN MENU smFile = TRUE.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Valorem C-Win 
PROCEDURE pi-Valorem PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-arquivo1 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo2 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo3 AS CHAR FORMAT "x(256)".

    DEF VAR de-vl-titulo AS DEC NO-UNDO.
    DEF VAR de-vl-cart AS DEC NO-UNDO.
      
    DEF VAR i-seqtemp AS INT NO-UNDO.

    FOR EACH tt_tit_acr_enviado:
        DELETE tt_tit_acr_enviado.
    END.

    OUTPUT TO VALUE(p-arquivo1) PAGE-SIZE 0 CONVERT TARGET 'iso8859-1'.
    PUT "RAZ«O SOCIAL;CNPJ;DAT. DE VENCTO;Nß DO T÷TULO;PARCELA;VALOR;EMAIL;ENDEREÄO;BAIRRO;MUNICIPIO;CEP;TELEFONE;UF" SKIP.

    ASSIGN i-contador = 0.
    
    FOR EACH  tt_int_tit_acr,
        FIRST mgesp.int_tit_acr EXCLUSIVE-LOCK
        WHERE int_tit_acr.cod_estab      = tt_int_tit_acr.cod_estab 
        AND   int_tit_acr.num_id_tit_acr = tt_int_tit_acr.num_id_tit_acr
        AND   int_tit_acr.ind_sit_envio = "Selecionado",
        FIRST tit_acr NO-LOCK
              WHERE tit_acr.cod_estab = INT_tit_acr.cod_estab
              AND   tit_acr.num_id_tit_acr = int_tit_acr.num_id_tit_acr,
        FIRST emscad.cliente NO-LOCK
            WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente
            BREAK BY tit_acr.cdn_cliente:
        
        ASSIGN c-ender     = ""
               c-bairro    = ""
               c-cid       = ""
               c-uf        = ""
               c-cgc       = ""
               c-email     = ""
               c-ins-estad = ""
               c-ins-munic = ""
               c-cep       = "".

        IF  emscad.cliente.num_pessoa MODULO 2 = 0 THEN DO:
            
            FIND pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
            
            IF  AVAIL pessoa_fisic THEN
                ASSIGN c-ender     = pessoa_fisic.nom_endereco 
                       c-bairro    = pessoa_fisic.nom_bairro
                       c-cid       = pessoa_fisic.nom_cidade
                       c-uf        = pessoa_fisic.cod_unid_federac
                       c-cep       = pessoa_fisic.cod_cep
                       c-cgc       = pessoa_fisic.cod_id_feder
                       c-email     = pessoa_fisic.cod_e_mail
                       c-ins-estad = ""
                       c-ins-munic = ""
                       c-fone      = pessoa_fisic.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","")
                       c-nome-emit = pessoa_fisic.nom_pessoa.
        END.
        ELSE DO:
            FIND pessoa_jurid NO-LOCK
                WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
            
            IF  AVAIL pessoa_jurid THEN DO:
                
                IF  pessoa_jurid.nom_endereco      = pessoa_jurid.nom_ender_cobr 
                OR  pessoa_jurid.nom_ender_cobr = "" THEN
                    ASSIGN c-ender     = pessoa_jurid.nom_endereco 
                           c-bairro    = pessoa_jurid.nom_bairro
                           c-cid       = pessoa_jurid.nom_cidade
                           c-uf        = pessoa_jurid.cod_unid_federac
                           c-cep       = pessoa_jurid.cod_cep
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail.
                ELSE 
                    ASSIGN c-ender     = pessoa_jurid.nom_ender_cobr
                           c-bairro    = pessoa_jurid.nom_bairro_cobr
                           c-cid       = pessoa_jurid.nom_cidad_cobr
                           c-uf        = pessoa_jurid.cod_unid_federac_cobr
                           c-cep       = pessoa_jurid.cod_cep_cobr
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail_cobr.
                ASSIGN c-ins-estad = pessoa_jurid.cod_id_estad_jurid
                       c-ins-munic = pessoa_jurid.cod_id_munic_jurid
                       c-nome-emit = pessoa_jurid.nom_pessoa
                       c-fone      = pessoa_jurid.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","").
            END.
        END.
        
        IF  FIRST-OF(tit_acr.cdn_cliente) THEN DO:
            FIND LAST histor_clien NO-LOCK
                WHERE histor_clien.cod_empresa = emscad.cliente.cod_empresa
                AND   histor_clien.cdn_cliente = emscad.cliente.cdn_cliente NO-ERROR.
            
            IF  NOT AVAIL histor_clien THEN DO:
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Valorem"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Valorem" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
            ELSE DO: 
                ASSIGN i-seqtemp = histor_clien.num_seq_histor_clien.
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = i-seqtemp + 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Cobrance"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Valorem" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
        END.
            
        ASSIGN i-contador   = i-contador + 1
               c-numero     = STRING(tit_acr.cod_tit_acr) 
               c-parcela    = STRING(tit_acr.cod_parcela)
               c-data       = SUBSTR(STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_vencto_tit_acr), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_vencto_tit_acr),"99"),1,2)
               c-data-emis  = SUBSTR(STRING(YEAR(tit_acr.dat_emis_docto),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_emis_docto), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_emis_docto),"99"),1,2)
               c-esp        = "DP"
               de-vl-titulo = tit_acr.val_sdo_tit_acr
               de-vl-cart   = int_tit_acr.val_desp_cartorio.
               
        IF  tit_acr.cod_espec_docto = "VD" THEN DO:            
            FIND FIRST b_tit_acr_VE NO-LOCK
                 WHERE b_tit_acr_VE.cod_estab       = tit_acr.cod_estab
                 AND   b_tit_acr_VE.cod_espec_docto = "VE"
                 AND   b_tit_acr_VE.cod_ser_docto   = tit_acr.cod_ser_docto
                 AND   b_tit_acr_VE.cod_tit_acr     = tit_acr.cod_tit_acr
                 AND   b_tit_acr_VE.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
            
            IF  AVAIL b_tit_acr_VE THEN 
                ASSIGN c-data = SUBSTR(STRING(YEAR(b_tit_acr_VE.dat_vencto_tit_acr),"9999"),1,4) 
                              + SUBSTR(STRING(MONTH(b_tit_acr_VE.dat_vencto_tit_acr), "99"),1,2)
                              + SUBSTR(STRING(DAY(b_tit_acr_VE.dat_vencto_tit_acr),"99"),1,2).
        END.

/* ** Informaá‰es solicitadas no EXCEL - enviado arquivo texto separado por ";" pois a Assessoria n∆o enviou padr∆o de layout
RAZ«O SOCIAL 	 
CNPJ 	 
DAT. DE VENCTO 	 
Nß DO T÷TULO 	
VALOR	
EMAIL
ENDEREÄO 	 
BAIRRO 	 
MUNICIPIO 	 
CEP 	 
TELEFONE 	 
UF 
***/
        CASE LENGTH(c-cgc):
            WHEN 14 THEN ASSIGN c-cgc = STRING(c-cgc, "99.999.999/9999-99").
            WHEN 15 THEN ASSIGN c-cgc = STRING(c-cgc, "999.999.999/9999-99").
            OTHERWISE    ASSIGN c-cgc = STRING(c-cgc, "999.999.999-99").
        END CASE.

        PUT c-nome-emit             FORMAT "!(50)"           ";"
            c-cgc             ";"
            SUBSTR(c-data,7,2)      FORMAT "99" "/" SUBSTR(c-data,5,2)      FORMAT "99" "/" SUBSTR(c-data,1,4)      FORMAT "9999"            ";"
            /*INT(c-numero)           FORMAT "999999999999"    ";"
            tratava inteiro (acima) e passou a tratar como alfanumÇrico (abaixo) */
            c-numero                FORMAT "x(12)"           ";"
            c-parcela                                        ";"
            de-vl-titulo                                     ";"
            c-email                                          ";"
            c-ender                 FORMAT "X(50)"           ";"
            c-bairro                FORMAT "X(20)"           ";"
            c-cid                   FORMAT "!(20)"           ";"
            c-cep                   FORMAT "99999999"        ";"
            c-fone                  FORMAT "X(11)"           ";"
            c-uf                    FORMAT "!(02)" SKIP.
                                                   
        /*****  Atualiza para os titulos para ENVIADO e armazena DATA DO ENVIO  *****/
        ASSIGN int_tit_acr.ind_sit_envio      = "Enviado"
               int_tit_acr.dat_envi_asses_cob = TODAY.
        
        /***** Cria TT de Titulos de Enviados  *****/
        CREATE tt_tit_acr_enviado.
        ASSIGN tt_tit_acr_enviado.cod_estab          = tit_acr.cod_estab
               tt_tit_acr_enviado.cod_espec_docto    = tit_acr.cod_espec_docto   
               tt_tit_acr_enviado.cod_ser_docto      = tit_acr.cod_ser_docto     
               tt_tit_acr_enviado.cod_tit_acr        = tit_acr.cod_tit_acr       
               tt_tit_acr_enviado.cod_parcela        = tit_acr.cod_parcela       
               tt_tit_acr_enviado.dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
               tt_tit_acr_enviado.dat_emis_docto     = tit_acr.dat_emis_docto    
               tt_tit_acr_enviado.cod_portador       = tit_acr.cod_portador      
               tt_tit_acr_enviado.cod_cart_bcia      = tit_acr.cod_cart_bcia     
               tt_tit_acr_enviado.cdn_cliente        = tit_acr.cdn_cliente       
               tt_tit_acr_enviado.nom_abrev          = emscad.cliente.nom_abrev        
               tt_tit_acr_enviado.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
               tt_tit_acr_enviado.val_origin_tit_acr = tit_acr.val_origin_tit_acr
               tt_tit_acr_enviado.val_desp_cartorio   = int_tit_acr.val_desp_cartorio.

    END.         /******* FOR EACH TITULO *********/
            
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.
            
    ASSIGN de-tot-car = 0
           de-tot-cli = 0.
              
    /***** "Gerando Arquivo de Titulos Enviados....".   *****/
    OUTPUT TO VALUE(p-arquivo2) PAGE-SIZE 0.
    ASSIGN i-contador = 0.
    
    FOR EACH tt_tit_acr_enviado NO-LOCK
        BREAK BY tt_tit_acr_enviado.cdn_cliente
              BY tt_tit_acr_enviado.dat_vencto_tit_acr:
        
        FIND FIRST emscad.cliente NO-LOCK
             WHERE emscad.cliente.cdn_cliente = tt_tit_acr_enviado.cdn_cliente NO-ERROR. 
        
        IF  FIRST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
            PUT SPACE(22)
                "Titulos Enviados Valorem - "
                TODAY FORMAT "99/99/9999" SKIP(2)
                "Esp Ser Titulo    /P  Emissao   Vencto Port /Car "
                "Codigo       Nome Abrev      Valo Cartorio   Valor Original" SKIP 
                "--- --- ------------ -------- -------- ----- --- "
                "-----------  --------------- --------------- ---------------" SKIP.
        END.

        ASSIGN de-tot-car = de-tot-car + tt_tit_acr_enviado.val_desp_cartorio
               de-tot-cli = de-tot-cli + tt_tit_acr_enviado.val_sdo_tit_acr.
                 
        PUT tt_tit_acr_enviado.cod_espec_docto    " "
            tt_tit_acr_enviado.cod_ser_docto      " "
            tt_tit_acr_enviado.cod_tit_acr  
            tt_tit_acr_enviado.cod_parcela        " "
            tt_tit_acr_enviado.dat_emis_docto     FORMAT "99/99/99" " "
            tt_tit_acr_enviado.dat_vencto_tit_acr FORMAT "99/99/99" " "
            tt_tit_acr_enviado.cod_portador       " " 
            tt_tit_acr_enviado.cod_cart_bcia      " "
            tt_tit_acr_enviado.cdn_cliente        "  "
            tt_tit_acr_enviado.nom_abrev          FORMAT "x(15)" " "
            tt_tit_acr_enviado.val_desp_cartorio  " "
            tt_tit_acr_enviado.val_sdo_tit_acr    SKIP.

        IF  LAST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
            PUT SPACE(38) "   Totais do Cliente"
                de-tot-car   "  "  
                de-tot-cli.
            
            IF  LINE-COUNTER > 48 THEN 
                PAGE.
            ELSE 
                PUT SKIP(6).
              
            ASSIGN de-tot-car = 0 
                   de-tot-cli = 0.
        END.
    END. /****** FOR EACH tt_tit_acr_enviado ******/
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.

    FOR EACH tt_tit_acr_enviado:
        FIND tit_acr NO-LOCK
             WHERE tit_acr.cod_estab         = tt_tit_acr_enviado.cod_estab      
             AND   tit_acr.cod_espec_docto   = tt_tit_acr_enviado.cod_espec_docto
             AND   tit_acr.cod_ser_docto     = tt_tit_acr_enviado.cod_ser_docto  
             AND   tit_acr.cod_tit_acr       = tt_tit_acr_enviado.cod_tit_acr    
             AND   tit_acr.cod_parcela       = tt_tit_acr_enviado.cod_parcela    NO-ERROR.
        
        RUN piAlteraTitulo (INPUT  "9957",
                            INPUT  "90",
                            INPUT  "Valorem",
                            OUTPUT vRetorno).  
        
        IF  vRetorno = "OK" THEN
            DELETE tt_tit_acr_enviado.
    END.

    FOR EACH  tt_int_tit_acr:
        DELETE tt_int_tit_acr.
    END.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Soliduz C-Win 
PROCEDURE pi-Soliduz PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-arquivo1 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo2 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo3 AS CHAR FORMAT "x(256)".

    DEF VAR de-vl-titulo AS DEC NO-UNDO.
    DEF VAR de-vl-cart AS DEC NO-UNDO.
      
    DEF VAR i-seqtemp AS INT NO-UNDO.

    FOR EACH tt_tit_acr_enviado:
        DELETE tt_tit_acr_enviado.
    END.

    OUTPUT TO VALUE(p-arquivo1) PAGE-SIZE 0 CONVERT TARGET 'iso8859-1'.
    PUT "RAZ«O SOCIAL;CNPJ;DAT. DE VENCTO;Nß DO T÷TULO;PARCELA;VALOR;EMAIL;ENDEREÄO;BAIRRO;MUNICIPIO;CEP;TELEFONE;UF" SKIP.

    ASSIGN i-contador = 0.
    
    FOR EACH  tt_int_tit_acr,
        FIRST mgesp.int_tit_acr EXCLUSIVE-LOCK
        WHERE int_tit_acr.cod_estab      = tt_int_tit_acr.cod_estab 
        AND   int_tit_acr.num_id_tit_acr = tt_int_tit_acr.num_id_tit_acr
        AND   int_tit_acr.ind_sit_envio = "Selecionado",
        FIRST tit_acr NO-LOCK
              WHERE tit_acr.cod_estab = INT_tit_acr.cod_estab
              AND   tit_acr.num_id_tit_acr = int_tit_acr.num_id_tit_acr,
        FIRST emscad.cliente NO-LOCK
            WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente
            BREAK BY tit_acr.cdn_cliente:
        
        ASSIGN c-ender     = ""
               c-bairro    = ""
               c-cid       = ""
               c-uf        = ""
               c-cgc       = ""
               c-email     = ""
               c-ins-estad = ""
               c-ins-munic = ""
               c-cep       = "".

        IF  emscad.cliente.num_pessoa MODULO 2 = 0 THEN DO:
            
            FIND pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
            
            IF  AVAIL pessoa_fisic THEN
                ASSIGN c-ender     = pessoa_fisic.nom_endereco 
                       c-bairro    = pessoa_fisic.nom_bairro
                       c-cid       = pessoa_fisic.nom_cidade
                       c-uf        = pessoa_fisic.cod_unid_federac
                       c-cep       = pessoa_fisic.cod_cep
                       c-cgc       = pessoa_fisic.cod_id_feder
                       c-email     = pessoa_fisic.cod_e_mail
                       c-ins-estad = ""
                       c-ins-munic = ""
                       c-fone      = pessoa_fisic.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","")
                       c-nome-emit = pessoa_fisic.nom_pessoa.
        END.
        ELSE DO:
            FIND pessoa_jurid NO-LOCK
                WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
            
            IF  AVAIL pessoa_jurid THEN DO:
                
                IF  pessoa_jurid.nom_endereco      = pessoa_jurid.nom_ender_cobr 
                OR  pessoa_jurid.nom_ender_cobr = "" THEN
                    ASSIGN c-ender     = pessoa_jurid.nom_endereco 
                           c-bairro    = pessoa_jurid.nom_bairro
                           c-cid       = pessoa_jurid.nom_cidade
                           c-uf        = pessoa_jurid.cod_unid_federac
                           c-cep       = pessoa_jurid.cod_cep
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail.
                ELSE 
                    ASSIGN c-ender     = pessoa_jurid.nom_ender_cobr
                           c-bairro    = pessoa_jurid.nom_bairro_cobr
                           c-cid       = pessoa_jurid.nom_cidad_cobr
                           c-uf        = pessoa_jurid.cod_unid_federac_cobr
                           c-cep       = pessoa_jurid.cod_cep_cobr
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail_cobr.
                ASSIGN c-ins-estad = pessoa_jurid.cod_id_estad_jurid
                       c-ins-munic = pessoa_jurid.cod_id_munic_jurid
                       c-nome-emit = pessoa_jurid.nom_pessoa
                       c-fone      = pessoa_jurid.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","").
            END.
        END.
        
        IF  FIRST-OF(tit_acr.cdn_cliente) THEN DO:
            FIND LAST histor_clien NO-LOCK
                WHERE histor_clien.cod_empresa = emscad.cliente.cod_empresa
                AND   histor_clien.cdn_cliente = emscad.cliente.cdn_cliente NO-ERROR.
            
            IF  NOT AVAIL histor_clien THEN DO:
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Soliduz"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Soliduz"
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
            ELSE DO: 
                ASSIGN i-seqtemp = histor_clien.num_seq_histor_clien.
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = i-seqtemp + 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Soliduz"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Soliduz" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
        END.
            
        ASSIGN i-contador   = i-contador + 1
               c-numero     = STRING(tit_acr.cod_tit_acr) 
               c-parcela    = STRING(tit_acr.cod_parcela)
               c-data       = SUBSTR(STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_vencto_tit_acr), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_vencto_tit_acr),"99"),1,2)
               c-data-emis  = SUBSTR(STRING(YEAR(tit_acr.dat_emis_docto),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_emis_docto), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_emis_docto),"99"),1,2)
               c-esp        = "DP"
               de-vl-titulo = tit_acr.val_sdo_tit_acr
               de-vl-cart   = int_tit_acr.val_desp_cartorio.
               
        IF  tit_acr.cod_espec_docto = "VD" THEN DO:            
            FIND FIRST b_tit_acr_VE NO-LOCK
                 WHERE b_tit_acr_VE.cod_estab       = tit_acr.cod_estab
                 AND   b_tit_acr_VE.cod_espec_docto = "VE"
                 AND   b_tit_acr_VE.cod_ser_docto   = tit_acr.cod_ser_docto
                 AND   b_tit_acr_VE.cod_tit_acr     = tit_acr.cod_tit_acr
                 AND   b_tit_acr_VE.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
            
            IF  AVAIL b_tit_acr_VE THEN 
                ASSIGN c-data = SUBSTR(STRING(YEAR(b_tit_acr_VE.dat_vencto_tit_acr),"9999"),1,4) 
                              + SUBSTR(STRING(MONTH(b_tit_acr_VE.dat_vencto_tit_acr), "99"),1,2)
                              + SUBSTR(STRING(DAY(b_tit_acr_VE.dat_vencto_tit_acr),"99"),1,2).
        END.

/* ** Informaá‰es solicitadas no EXCEL - enviado arquivo texto separado por ";" pois a Assessoria n∆o enviou padr∆o de layout
RAZ«O SOCIAL 	 
CNPJ 	 
DAT. DE VENCTO 	 
Nß DO T÷TULO 	
VALOR	
EMAIL
ENDEREÄO 	 
BAIRRO 	 
MUNICIPIO 	 
CEP 	 
TELEFONE 	 
UF 
***/
        CASE LENGTH(c-cgc):
            WHEN 14 THEN ASSIGN c-cgc = STRING(c-cgc, "99.999.999/9999-99").
            WHEN 15 THEN ASSIGN c-cgc = STRING(c-cgc, "999.999.999/9999-99").
            OTHERWISE    ASSIGN c-cgc = STRING(c-cgc, "999.999.999-99").
        END CASE.

        PUT c-nome-emit             FORMAT "!(50)"           ";"
            c-cgc             ";"
            SUBSTR(c-data,7,2)      FORMAT "99" "/" SUBSTR(c-data,5,2)      FORMAT "99" "/" SUBSTR(c-data,1,4)      FORMAT "9999"            ";"
            /*INT(c-numero)           FORMAT "999999999999"    ";"
            tratava inteiro (acima) e passou a tratar como alfanumÇrico (abaixo) */
            c-numero                FORMAT "x(12)"           ";"
            c-parcela                                        ";"
            de-vl-titulo                                     ";"
            c-email                                          ";"
            c-ender                 FORMAT "X(50)"           ";"
            c-bairro                FORMAT "X(20)"           ";"
            c-cid                   FORMAT "!(20)"           ";"
            c-cep                   FORMAT "99999999"        ";"
            c-fone                  FORMAT "X(11)"           ";"
            c-uf                    FORMAT "!(02)" SKIP.
                                                   
        /*****  Atualiza para os titulos para ENVIADO e armazena DATA DO ENVIO  *****/
        ASSIGN int_tit_acr.ind_sit_envio      = "Enviado"
               int_tit_acr.dat_envi_asses_cob = TODAY.
        
        /***** Cria TT de Titulos de Enviados  *****/
        CREATE tt_tit_acr_enviado.
        ASSIGN tt_tit_acr_enviado.cod_estab          = tit_acr.cod_estab
               tt_tit_acr_enviado.cod_espec_docto    = tit_acr.cod_espec_docto   
               tt_tit_acr_enviado.cod_ser_docto      = tit_acr.cod_ser_docto     
               tt_tit_acr_enviado.cod_tit_acr        = tit_acr.cod_tit_acr       
               tt_tit_acr_enviado.cod_parcela        = tit_acr.cod_parcela       
               tt_tit_acr_enviado.dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
               tt_tit_acr_enviado.dat_emis_docto     = tit_acr.dat_emis_docto    
               tt_tit_acr_enviado.cod_portador       = tit_acr.cod_portador      
               tt_tit_acr_enviado.cod_cart_bcia      = tit_acr.cod_cart_bcia     
               tt_tit_acr_enviado.cdn_cliente        = tit_acr.cdn_cliente       
               tt_tit_acr_enviado.nom_abrev          = emscad.cliente.nom_abrev        
               tt_tit_acr_enviado.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
               tt_tit_acr_enviado.val_origin_tit_acr = tit_acr.val_origin_tit_acr
               tt_tit_acr_enviado.val_desp_cartorio   = int_tit_acr.val_desp_cartorio.

    END.         /******* FOR EACH TITULO *********/
            
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.
            
    ASSIGN de-tot-car = 0
           de-tot-cli = 0.
              
    /***** "Gerando Arquivo de Titulos Enviados....".   *****/
    OUTPUT TO VALUE(p-arquivo2) PAGE-SIZE 0.
    ASSIGN i-contador = 0.
    
    FOR EACH tt_tit_acr_enviado NO-LOCK
        BREAK BY tt_tit_acr_enviado.cdn_cliente
              BY tt_tit_acr_enviado.dat_vencto_tit_acr:
        
        FIND FIRST emscad.cliente NO-LOCK
             WHERE emscad.cliente.cdn_cliente = tt_tit_acr_enviado.cdn_cliente NO-ERROR. 
        
        IF  FIRST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
            PUT SPACE(22)
                "Titulos Enviados Soliduz - "
                TODAY FORMAT "99/99/9999" SKIP(2)
                "Esp Ser Titulo    /P  Emissao   Vencto Port /Car "
                "Codigo       Nome Abrev      Valo Cartorio   Valor Original" SKIP 
                "--- --- ------------ -------- -------- ----- --- "
                "-----------  --------------- --------------- ---------------" SKIP.
        END.

        ASSIGN de-tot-car = de-tot-car + tt_tit_acr_enviado.val_desp_cartorio
               de-tot-cli = de-tot-cli + tt_tit_acr_enviado.val_sdo_tit_acr.
                 
        PUT tt_tit_acr_enviado.cod_espec_docto    " "
            tt_tit_acr_enviado.cod_ser_docto      " "
            tt_tit_acr_enviado.cod_tit_acr  
            tt_tit_acr_enviado.cod_parcela        " "
            tt_tit_acr_enviado.dat_emis_docto     FORMAT "99/99/99" " "
            tt_tit_acr_enviado.dat_vencto_tit_acr FORMAT "99/99/99" " "
            tt_tit_acr_enviado.cod_portador       " " 
            tt_tit_acr_enviado.cod_cart_bcia      " "
            tt_tit_acr_enviado.cdn_cliente        "  "
            tt_tit_acr_enviado.nom_abrev          FORMAT "x(15)" " "
            tt_tit_acr_enviado.val_desp_cartorio  " "
            tt_tit_acr_enviado.val_sdo_tit_acr    SKIP.

        IF  LAST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
            PUT SPACE(38) "   Totais do Cliente"
                de-tot-car   "  "  
                de-tot-cli.
            
            IF  LINE-COUNTER > 48 THEN 
                PAGE.
            ELSE 
                PUT SKIP(6).
              
            ASSIGN de-tot-car = 0 
                   de-tot-cli = 0.
        END.
    END. /****** FOR EACH tt_tit_acr_enviado ******/
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.

    FOR EACH tt_tit_acr_enviado:
        FIND tit_acr NO-LOCK
             WHERE tit_acr.cod_estab         = tt_tit_acr_enviado.cod_estab      
             AND   tit_acr.cod_espec_docto   = tt_tit_acr_enviado.cod_espec_docto
             AND   tit_acr.cod_ser_docto     = tt_tit_acr_enviado.cod_ser_docto  
             AND   tit_acr.cod_tit_acr       = tt_tit_acr_enviado.cod_tit_acr    
             AND   tit_acr.cod_parcela       = tt_tit_acr_enviado.cod_parcela    NO-ERROR.
        
        RUN piAlteraTitulo (INPUT  "9960",
                            INPUT  "90",
                            INPUT  "Soliduz",
                            OUTPUT vRetorno).  
        
        IF  vRetorno = "OK" THEN
            DELETE tt_tit_acr_enviado.
    END.

    FOR EACH  tt_int_tit_acr:
        DELETE tt_int_tit_acr.
    END.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-talk C-Win 
PROCEDURE pi-talk PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-arquivo1 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo2 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo3 AS CHAR FORMAT "x(256)".

    DEF VAR de-vl-titulo AS DEC NO-UNDO.
    DEF VAR de-vl-cart AS DEC NO-UNDO.
      
    DEF VAR i-seqtemp AS INT NO-UNDO.

    FOR EACH tt_tit_acr_enviado:
        DELETE tt_tit_acr_enviado.
    END.

    OUTPUT TO VALUE(p-arquivo1) PAGE-SIZE 0 CONVERT TARGET 'iso8859-1'.
    PUT "RAZ«O SOCIAL;CNPJ;DAT. DE VENCTO;Nß DO T÷TULO;PARCELA;VALOR;EMAIL;ENDEREÄO;BAIRRO;MUNICIPIO;CEP;TELEFONE;UF" SKIP.

    ASSIGN i-contador = 0.
    
    FOR EACH  tt_int_tit_acr,
        FIRST mgesp.int_tit_acr EXCLUSIVE-LOCK
        WHERE int_tit_acr.cod_estab      = tt_int_tit_acr.cod_estab 
        AND   int_tit_acr.num_id_tit_acr = tt_int_tit_acr.num_id_tit_acr
        AND   int_tit_acr.ind_sit_envio = "Selecionado",
        FIRST tit_acr NO-LOCK
              WHERE tit_acr.cod_estab = INT_tit_acr.cod_estab
              AND   tit_acr.num_id_tit_acr = int_tit_acr.num_id_tit_acr,
        FIRST emscad.cliente NO-LOCK
            WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente
            BREAK BY tit_acr.cdn_cliente:
        
        ASSIGN c-ender     = ""
               c-bairro    = ""
               c-cid       = ""
               c-uf        = ""
               c-cgc       = ""
               c-email     = ""
               c-ins-estad = ""
               c-ins-munic = ""
               c-cep       = "".

        IF  emscad.cliente.num_pessoa MODULO 2 = 0 THEN DO:
            
            FIND pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
            
            IF  AVAIL pessoa_fisic THEN
                ASSIGN c-ender     = pessoa_fisic.nom_endereco 
                       c-bairro    = pessoa_fisic.nom_bairro
                       c-cid       = pessoa_fisic.nom_cidade
                       c-uf        = pessoa_fisic.cod_unid_federac
                       c-cep       = pessoa_fisic.cod_cep
                       c-cgc       = pessoa_fisic.cod_id_feder
                       c-email     = pessoa_fisic.cod_e_mail
                       c-ins-estad = ""
                       c-ins-munic = ""
                       c-fone      = pessoa_fisic.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","")
                       c-nome-emit = pessoa_fisic.nom_pessoa.
        END.
        ELSE DO:
            FIND pessoa_jurid NO-LOCK
                WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
            
            IF  AVAIL pessoa_jurid THEN DO:
                
                IF  pessoa_jurid.nom_endereco      = pessoa_jurid.nom_ender_cobr 
                OR  pessoa_jurid.nom_ender_cobr = "" THEN
                    ASSIGN c-ender     = pessoa_jurid.nom_endereco 
                           c-bairro    = pessoa_jurid.nom_bairro
                           c-cid       = pessoa_jurid.nom_cidade
                           c-uf        = pessoa_jurid.cod_unid_federac
                           c-cep       = pessoa_jurid.cod_cep
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail.
                ELSE 
                    ASSIGN c-ender     = pessoa_jurid.nom_ender_cobr
                           c-bairro    = pessoa_jurid.nom_bairro_cobr
                           c-cid       = pessoa_jurid.nom_cidad_cobr
                           c-uf        = pessoa_jurid.cod_unid_federac_cobr
                           c-cep       = pessoa_jurid.cod_cep_cobr
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail_cobr.
                ASSIGN c-ins-estad = pessoa_jurid.cod_id_estad_jurid
                       c-ins-munic = pessoa_jurid.cod_id_munic_jurid
                       c-nome-emit = pessoa_jurid.nom_pessoa
                       c-fone      = pessoa_jurid.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","").
            END.
        END.
        
        IF  FIRST-OF(tit_acr.cdn_cliente) THEN DO:
            FIND LAST histor_clien NO-LOCK
                WHERE histor_clien.cod_empresa = emscad.cliente.cod_empresa
                AND   histor_clien.cdn_cliente = emscad.cliente.cdn_cliente NO-ERROR.
            
            IF  NOT AVAIL histor_clien THEN DO:
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Talk"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Talk"
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
            ELSE DO: 
                ASSIGN i-seqtemp = histor_clien.num_seq_histor_clien.
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = i-seqtemp + 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Talk"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Talk" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
        END.
            
        ASSIGN i-contador   = i-contador + 1
               c-numero     = STRING(tit_acr.cod_tit_acr) 
               c-parcela    = STRING(tit_acr.cod_parcela)
               c-data       = SUBSTR(STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_vencto_tit_acr), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_vencto_tit_acr),"99"),1,2)
               c-data-emis  = SUBSTR(STRING(YEAR(tit_acr.dat_emis_docto),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_emis_docto), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_emis_docto),"99"),1,2)
               c-esp        = "DP"
               de-vl-titulo = tit_acr.val_sdo_tit_acr
               de-vl-cart   = int_tit_acr.val_desp_cartorio.
               
        IF  tit_acr.cod_espec_docto = "VD" THEN DO:            
            FIND FIRST b_tit_acr_VE NO-LOCK
                 WHERE b_tit_acr_VE.cod_estab       = tit_acr.cod_estab
                 AND   b_tit_acr_VE.cod_espec_docto = "VE"
                 AND   b_tit_acr_VE.cod_ser_docto   = tit_acr.cod_ser_docto
                 AND   b_tit_acr_VE.cod_tit_acr     = tit_acr.cod_tit_acr
                 AND   b_tit_acr_VE.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
            
            IF  AVAIL b_tit_acr_VE THEN 
                ASSIGN c-data = SUBSTR(STRING(YEAR(b_tit_acr_VE.dat_vencto_tit_acr),"9999"),1,4) 
                              + SUBSTR(STRING(MONTH(b_tit_acr_VE.dat_vencto_tit_acr), "99"),1,2)
                              + SUBSTR(STRING(DAY(b_tit_acr_VE.dat_vencto_tit_acr),"99"),1,2).
        END.

/* ** Informaá‰es solicitadas no EXCEL - enviado arquivo texto separado por ";" pois a Assessoria n∆o enviou padr∆o de layout
RAZ«O SOCIAL 	 
CNPJ 	 
DAT. DE VENCTO 	 
Nß DO T÷TULO 	
VALOR	
EMAIL
ENDEREÄO 	 
BAIRRO 	 
MUNICIPIO 	 
CEP 	 
TELEFONE 	 
UF 
***/
        CASE LENGTH(c-cgc):
            WHEN 14 THEN ASSIGN c-cgc = STRING(c-cgc, "99.999.999/9999-99").
            WHEN 15 THEN ASSIGN c-cgc = STRING(c-cgc, "999.999.999/9999-99").
            OTHERWISE    ASSIGN c-cgc = STRING(c-cgc, "999.999.999-99").
        END CASE.

        PUT c-nome-emit             FORMAT "!(50)"           ";"
            c-cgc             ";"
            SUBSTR(c-data,7,2)      FORMAT "99" "/" SUBSTR(c-data,5,2)      FORMAT "99" "/" SUBSTR(c-data,1,4)      FORMAT "9999"            ";"
            /*INT(c-numero)           FORMAT "999999999999"    ";"
            tratava inteiro (acima) e passou a tratar como alfanumÇrico (abaixo) */
            c-numero                FORMAT "x(12)"           ";"
            c-parcela                                        ";"
            de-vl-titulo                                     ";"
            c-email                                          ";"
            c-ender                 FORMAT "X(50)"           ";"
            c-bairro                FORMAT "X(20)"           ";"
            c-cid                   FORMAT "!(20)"           ";"
            c-cep                   FORMAT "99999999"        ";"
            c-fone                  FORMAT "X(11)"           ";"
            c-uf                    FORMAT "!(02)" SKIP.
                                                   
        /*****  Atualiza para os titulos para ENVIADO e armazena DATA DO ENVIO  *****/
        ASSIGN int_tit_acr.ind_sit_envio      = "Enviado"
               int_tit_acr.dat_envi_asses_cob = TODAY.
        
        /***** Cria TT de Titulos de Enviados  *****/
        CREATE tt_tit_acr_enviado.
        ASSIGN tt_tit_acr_enviado.cod_estab          = tit_acr.cod_estab
               tt_tit_acr_enviado.cod_espec_docto    = tit_acr.cod_espec_docto   
               tt_tit_acr_enviado.cod_ser_docto      = tit_acr.cod_ser_docto     
               tt_tit_acr_enviado.cod_tit_acr        = tit_acr.cod_tit_acr       
               tt_tit_acr_enviado.cod_parcela        = tit_acr.cod_parcela       
               tt_tit_acr_enviado.dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
               tt_tit_acr_enviado.dat_emis_docto     = tit_acr.dat_emis_docto    
               tt_tit_acr_enviado.cod_portador       = tit_acr.cod_portador      
               tt_tit_acr_enviado.cod_cart_bcia      = tit_acr.cod_cart_bcia     
               tt_tit_acr_enviado.cdn_cliente        = tit_acr.cdn_cliente       
               tt_tit_acr_enviado.nom_abrev          = emscad.cliente.nom_abrev        
               tt_tit_acr_enviado.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
               tt_tit_acr_enviado.val_origin_tit_acr = tit_acr.val_origin_tit_acr
               tt_tit_acr_enviado.val_desp_cartorio   = int_tit_acr.val_desp_cartorio.

    END.         /******* FOR EACH TITULO *********/
            
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.
            
    ASSIGN de-tot-car = 0
           de-tot-cli = 0.
              
    /***** "Gerando Arquivo de Titulos Enviados....".   *****/
    OUTPUT TO VALUE(p-arquivo2) PAGE-SIZE 0.
    ASSIGN i-contador = 0.
    
    FOR EACH tt_tit_acr_enviado NO-LOCK
        BREAK BY tt_tit_acr_enviado.cdn_cliente
              BY tt_tit_acr_enviado.dat_vencto_tit_acr:
        
        FIND FIRST emscad.cliente NO-LOCK
             WHERE emscad.cliente.cdn_cliente = tt_tit_acr_enviado.cdn_cliente NO-ERROR. 
        
        IF  FIRST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
            PUT SPACE(22)
                "Titulos Enviados Talk - "
                TODAY FORMAT "99/99/9999" SKIP(2)
                "Esp Ser Titulo    /P  Emissao   Vencto Port /Car "
                "Codigo       Nome Abrev      Valo Cartorio   Valor Original" SKIP 
                "--- --- ------------ -------- -------- ----- --- "
                "-----------  --------------- --------------- ---------------" SKIP.
        END.

        ASSIGN de-tot-car = de-tot-car + tt_tit_acr_enviado.val_desp_cartorio
               de-tot-cli = de-tot-cli + tt_tit_acr_enviado.val_sdo_tit_acr.
                 
        PUT tt_tit_acr_enviado.cod_espec_docto    " "
            tt_tit_acr_enviado.cod_ser_docto      " "
            tt_tit_acr_enviado.cod_tit_acr  
            tt_tit_acr_enviado.cod_parcela        " "
            tt_tit_acr_enviado.dat_emis_docto     FORMAT "99/99/99" " "
            tt_tit_acr_enviado.dat_vencto_tit_acr FORMAT "99/99/99" " "
            tt_tit_acr_enviado.cod_portador       " " 
            tt_tit_acr_enviado.cod_cart_bcia      " "
            tt_tit_acr_enviado.cdn_cliente        "  "
            tt_tit_acr_enviado.nom_abrev          FORMAT "x(15)" " "
            tt_tit_acr_enviado.val_desp_cartorio  " "
            tt_tit_acr_enviado.val_sdo_tit_acr    SKIP.

        IF  LAST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
            PUT SPACE(38) "   Totais do Cliente"
                de-tot-car   "  "  
                de-tot-cli.
            
            IF  LINE-COUNTER > 48 THEN 
                PAGE.
            ELSE 
                PUT SKIP(6).
              
            ASSIGN de-tot-car = 0 
                   de-tot-cli = 0.
        END.
    END. /****** FOR EACH tt_tit_acr_enviado ******/
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.

    FOR EACH tt_tit_acr_enviado:
        FIND tit_acr NO-LOCK
             WHERE tit_acr.cod_estab         = tt_tit_acr_enviado.cod_estab      
             AND   tit_acr.cod_espec_docto   = tt_tit_acr_enviado.cod_espec_docto
             AND   tit_acr.cod_ser_docto     = tt_tit_acr_enviado.cod_ser_docto  
             AND   tit_acr.cod_tit_acr       = tt_tit_acr_enviado.cod_tit_acr    
             AND   tit_acr.cod_parcela       = tt_tit_acr_enviado.cod_parcela    NO-ERROR.
        
        RUN piAlteraTitulo (INPUT  "9961",
                            INPUT  "90",
                            INPUT  "Talk",
                            OUTPUT vRetorno).  
        
        IF  vRetorno = "OK" THEN
            DELETE tt_tit_acr_enviado.
    END.

    FOR EACH  tt_int_tit_acr:
        DELETE tt_int_tit_acr.
    END.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-duarte C-Win 
PROCEDURE pi-duarte PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-arquivo1 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo2 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo3 AS CHAR FORMAT "x(256)".

    DEF VAR de-vl-titulo AS DEC NO-UNDO.
    DEF VAR de-vl-cart AS DEC NO-UNDO.
      
    DEF VAR i-seqtemp AS INT NO-UNDO.

    FOR EACH tt_tit_acr_enviado:
        DELETE tt_tit_acr_enviado.
    END.

    OUTPUT TO VALUE(p-arquivo1) PAGE-SIZE 0 CONVERT TARGET 'iso8859-1'.
    PUT "RAZ«O SOCIAL;CNPJ;DAT. DE VENCTO;Nß DO T÷TULO;PARCELA;VALOR;EMAIL;ENDEREÄO;BAIRRO;MUNICIPIO;CEP;TELEFONE;UF" SKIP.

    ASSIGN i-contador = 0.
    
    FOR EACH  tt_int_tit_acr,
        FIRST mgesp.int_tit_acr EXCLUSIVE-LOCK
        WHERE int_tit_acr.cod_estab      = tt_int_tit_acr.cod_estab 
        AND   int_tit_acr.num_id_tit_acr = tt_int_tit_acr.num_id_tit_acr
        AND   int_tit_acr.ind_sit_envio = "Selecionado",
        FIRST tit_acr NO-LOCK
              WHERE tit_acr.cod_estab = INT_tit_acr.cod_estab
              AND   tit_acr.num_id_tit_acr = int_tit_acr.num_id_tit_acr,
        FIRST emscad.cliente NO-LOCK
            WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente
            BREAK BY tit_acr.cdn_cliente:
        
        ASSIGN c-ender     = ""
               c-bairro    = ""
               c-cid       = ""
               c-uf        = ""
               c-cgc       = ""
               c-email     = ""
               c-ins-estad = ""
               c-ins-munic = ""
               c-cep       = "".

        IF  emscad.cliente.num_pessoa MODULO 2 = 0 THEN DO:
            
            FIND pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
            
            IF  AVAIL pessoa_fisic THEN
                ASSIGN c-ender     = pessoa_fisic.nom_endereco 
                       c-bairro    = pessoa_fisic.nom_bairro
                       c-cid       = pessoa_fisic.nom_cidade
                       c-uf        = pessoa_fisic.cod_unid_federac
                       c-cep       = pessoa_fisic.cod_cep
                       c-cgc       = pessoa_fisic.cod_id_feder
                       c-email     = pessoa_fisic.cod_e_mail
                       c-ins-estad = ""
                       c-ins-munic = ""
                       c-fone      = pessoa_fisic.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","")
                       c-nome-emit = pessoa_fisic.nom_pessoa.
        END.
        ELSE DO:
            FIND pessoa_jurid NO-LOCK
                WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
            
            IF  AVAIL pessoa_jurid THEN DO:
                
                IF  pessoa_jurid.nom_endereco      = pessoa_jurid.nom_ender_cobr 
                OR  pessoa_jurid.nom_ender_cobr = "" THEN
                    ASSIGN c-ender     = pessoa_jurid.nom_endereco 
                           c-bairro    = pessoa_jurid.nom_bairro
                           c-cid       = pessoa_jurid.nom_cidade
                           c-uf        = pessoa_jurid.cod_unid_federac
                           c-cep       = pessoa_jurid.cod_cep
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail.
                ELSE 
                    ASSIGN c-ender     = pessoa_jurid.nom_ender_cobr
                           c-bairro    = pessoa_jurid.nom_bairro_cobr
                           c-cid       = pessoa_jurid.nom_cidad_cobr
                           c-uf        = pessoa_jurid.cod_unid_federac_cobr
                           c-cep       = pessoa_jurid.cod_cep_cobr
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail_cobr.
                ASSIGN c-ins-estad = pessoa_jurid.cod_id_estad_jurid
                       c-ins-munic = pessoa_jurid.cod_id_munic_jurid
                       c-nome-emit = pessoa_jurid.nom_pessoa
                       c-fone      = pessoa_jurid.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","").
            END.
        END.
        
        IF  FIRST-OF(tit_acr.cdn_cliente) THEN DO:
            FIND LAST histor_clien NO-LOCK
                WHERE histor_clien.cod_empresa = emscad.cliente.cod_empresa
                AND   histor_clien.cdn_cliente = emscad.cliente.cdn_cliente NO-ERROR.
            
            IF  NOT AVAIL histor_clien THEN DO:
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Duarte"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Duarte"
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
            ELSE DO: 
                ASSIGN i-seqtemp = histor_clien.num_seq_histor_clien.
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = i-seqtemp + 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Duarte"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Duarte" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
        END.
            
        ASSIGN i-contador   = i-contador + 1
               c-numero     = STRING(tit_acr.cod_tit_acr) 
               c-parcela    = STRING(tit_acr.cod_parcela)
               c-data       = SUBSTR(STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_vencto_tit_acr), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_vencto_tit_acr),"99"),1,2)
               c-data-emis  = SUBSTR(STRING(YEAR(tit_acr.dat_emis_docto),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_emis_docto), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_emis_docto),"99"),1,2)
               c-esp        = "DP"
               de-vl-titulo = tit_acr.val_sdo_tit_acr
               de-vl-cart   = int_tit_acr.val_desp_cartorio.
               
        IF  tit_acr.cod_espec_docto = "VD" THEN DO:            
            FIND FIRST b_tit_acr_VE NO-LOCK
                 WHERE b_tit_acr_VE.cod_estab       = tit_acr.cod_estab
                 AND   b_tit_acr_VE.cod_espec_docto = "VE"
                 AND   b_tit_acr_VE.cod_ser_docto   = tit_acr.cod_ser_docto
                 AND   b_tit_acr_VE.cod_tit_acr     = tit_acr.cod_tit_acr
                 AND   b_tit_acr_VE.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
            
            IF  AVAIL b_tit_acr_VE THEN 
                ASSIGN c-data = SUBSTR(STRING(YEAR(b_tit_acr_VE.dat_vencto_tit_acr),"9999"),1,4) 
                              + SUBSTR(STRING(MONTH(b_tit_acr_VE.dat_vencto_tit_acr), "99"),1,2)
                              + SUBSTR(STRING(DAY(b_tit_acr_VE.dat_vencto_tit_acr),"99"),1,2).
        END.

/* ** Informaá‰es solicitadas no EXCEL - enviado arquivo texto separado por ";" pois a Assessoria n∆o enviou padr∆o de layout
RAZ«O SOCIAL 	 
CNPJ 	 
DAT. DE VENCTO 	 
Nß DO T÷TULO 	
VALOR	
EMAIL
ENDEREÄO 	 
BAIRRO 	 
MUNICIPIO 	 
CEP 	 
TELEFONE 	 
UF 
***/
        CASE LENGTH(c-cgc):
            WHEN 14 THEN ASSIGN c-cgc = STRING(c-cgc, "99.999.999/9999-99").
            WHEN 15 THEN ASSIGN c-cgc = STRING(c-cgc, "999.999.999/9999-99").
            OTHERWISE    ASSIGN c-cgc = STRING(c-cgc, "999.999.999-99").
        END CASE.

        PUT c-nome-emit             FORMAT "!(50)"           ";"
            c-cgc             ";"
            SUBSTR(c-data,7,2)      FORMAT "99" "/" SUBSTR(c-data,5,2)      FORMAT "99" "/" SUBSTR(c-data,1,4)      FORMAT "9999"            ";"
            /*INT(c-numero)           FORMAT "999999999999"    ";"
            tratava inteiro (acima) e passou a tratar como alfanumÇrico (abaixo) */
            c-numero                FORMAT "x(12)"           ";"
            c-parcela                                        ";"
            de-vl-titulo                                     ";"
            c-email                                          ";"
            c-ender                 FORMAT "X(50)"           ";"
            c-bairro                FORMAT "X(20)"           ";"
            c-cid                   FORMAT "!(20)"           ";"
            c-cep                   FORMAT "99999999"        ";"
            c-fone                  FORMAT "X(11)"           ";"
            c-uf                    FORMAT "!(02)" SKIP.
                                                   
        /*****  Atualiza para os titulos para ENVIADO e armazena DATA DO ENVIO  *****/
        ASSIGN int_tit_acr.ind_sit_envio      = "Enviado"
               int_tit_acr.dat_envi_asses_cob = TODAY.
        
        /***** Cria TT de Titulos de Enviados  *****/
        CREATE tt_tit_acr_enviado.
        ASSIGN tt_tit_acr_enviado.cod_estab          = tit_acr.cod_estab
               tt_tit_acr_enviado.cod_espec_docto    = tit_acr.cod_espec_docto   
               tt_tit_acr_enviado.cod_ser_docto      = tit_acr.cod_ser_docto     
               tt_tit_acr_enviado.cod_tit_acr        = tit_acr.cod_tit_acr       
               tt_tit_acr_enviado.cod_parcela        = tit_acr.cod_parcela       
               tt_tit_acr_enviado.dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
               tt_tit_acr_enviado.dat_emis_docto     = tit_acr.dat_emis_docto    
               tt_tit_acr_enviado.cod_portador       = tit_acr.cod_portador      
               tt_tit_acr_enviado.cod_cart_bcia      = tit_acr.cod_cart_bcia     
               tt_tit_acr_enviado.cdn_cliente        = tit_acr.cdn_cliente       
               tt_tit_acr_enviado.nom_abrev          = emscad.cliente.nom_abrev        
               tt_tit_acr_enviado.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
               tt_tit_acr_enviado.val_origin_tit_acr = tit_acr.val_origin_tit_acr
               tt_tit_acr_enviado.val_desp_cartorio   = int_tit_acr.val_desp_cartorio.

    END.         /******* FOR EACH TITULO *********/
            
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.
            
    ASSIGN de-tot-car = 0
           de-tot-cli = 0.
              
    /***** "Gerando Arquivo de Titulos Enviados....".   *****/
    OUTPUT TO VALUE(p-arquivo2) PAGE-SIZE 0.
    ASSIGN i-contador = 0.
    
    FOR EACH tt_tit_acr_enviado NO-LOCK
        BREAK BY tt_tit_acr_enviado.cdn_cliente
              BY tt_tit_acr_enviado.dat_vencto_tit_acr:
        
        FIND FIRST emscad.cliente NO-LOCK
             WHERE emscad.cliente.cdn_cliente = tt_tit_acr_enviado.cdn_cliente NO-ERROR. 
        
        IF  FIRST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
            PUT SPACE(22)
                "Titulos Enviados Duarte - "
                TODAY FORMAT "99/99/9999" SKIP(2)
                "Esp Ser Titulo    /P  Emissao   Vencto Port /Car "
                "Codigo       Nome Abrev      Valo Cartorio   Valor Original" SKIP 
                "--- --- ------------ -------- -------- ----- --- "
                "-----------  --------------- --------------- ---------------" SKIP.
        END.

        ASSIGN de-tot-car = de-tot-car + tt_tit_acr_enviado.val_desp_cartorio
               de-tot-cli = de-tot-cli + tt_tit_acr_enviado.val_sdo_tit_acr.
                 
        PUT tt_tit_acr_enviado.cod_espec_docto    " "
            tt_tit_acr_enviado.cod_ser_docto      " "
            tt_tit_acr_enviado.cod_tit_acr  
            tt_tit_acr_enviado.cod_parcela        " "
            tt_tit_acr_enviado.dat_emis_docto     FORMAT "99/99/99" " "
            tt_tit_acr_enviado.dat_vencto_tit_acr FORMAT "99/99/99" " "
            tt_tit_acr_enviado.cod_portador       " " 
            tt_tit_acr_enviado.cod_cart_bcia      " "
            tt_tit_acr_enviado.cdn_cliente        "  "
            tt_tit_acr_enviado.nom_abrev          FORMAT "x(15)" " "
            tt_tit_acr_enviado.val_desp_cartorio  " "
            tt_tit_acr_enviado.val_sdo_tit_acr    SKIP.

        IF  LAST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
            PUT SPACE(38) "   Totais do Cliente"
                de-tot-car   "  "  
                de-tot-cli.
            
            IF  LINE-COUNTER > 48 THEN 
                PAGE.
            ELSE 
                PUT SKIP(6).
              
            ASSIGN de-tot-car = 0 
                   de-tot-cli = 0.
        END.
    END. /****** FOR EACH tt_tit_acr_enviado ******/
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.

    FOR EACH tt_tit_acr_enviado:
        FIND tit_acr NO-LOCK
             WHERE tit_acr.cod_estab         = tt_tit_acr_enviado.cod_estab      
             AND   tit_acr.cod_espec_docto   = tt_tit_acr_enviado.cod_espec_docto
             AND   tit_acr.cod_ser_docto     = tt_tit_acr_enviado.cod_ser_docto  
             AND   tit_acr.cod_tit_acr       = tt_tit_acr_enviado.cod_tit_acr    
             AND   tit_acr.cod_parcela       = tt_tit_acr_enviado.cod_parcela    NO-ERROR.
        
        RUN piAlteraTitulo (INPUT  "9962",
                            INPUT  "90",
                            INPUT  "Duarte",
                            OUTPUT vRetorno).  
        
        IF  vRetorno = "OK" THEN
            DELETE tt_tit_acr_enviado.
    END.

    FOR EACH  tt_int_tit_acr:
        DELETE tt_int_tit_acr.
    END.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-averbach C-Win 
PROCEDURE pi-averbach PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-arquivo1 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo2 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo3 AS CHAR FORMAT "x(256)".

    DEF VAR i-seqtemp            AS INT NO-UNDO.
    DEFINE VARIABLE c-tip-pessoa AS CHARACTER   NO-UNDO.

    FOR EACH tt_tit_acr_enviado:
        DELETE tt_tit_acr_enviado.
    END.

    /*   Message "Gerando Arquivo de Titulos ....".   */
    OUTPUT TO VALUE(p-arquivo1) PAGE-SIZE 0 CONVERT TARGET 'iso8859-1'.
    PUT UNFORMATTED "01REMESSA01COBRANCA       00000000000000000000INTELBRAS S/A                    AVERBACH       "  STRING(DAY(TODAY), "99") STRING(MONTH(TODAY), "99") SUBSTRING(STRING(YEAR(TODAY), "9999"), 3, 2) "0000001" + FILL(" ", 287) + "000001" SKIP.

    ASSIGN i-contador = 0.
    FOR EACH  tt_int_tit_acr,
        FIRST mgesp.int_tit_acr EXCLUSIVE-LOCK
        WHERE int_tit_acr.cod_estab      = tt_int_tit_acr.cod_estab 
        AND   int_tit_acr.num_id_tit_acr = tt_int_tit_acr.num_id_tit_acr
        AND   int_tit_acr.ind_sit_envio = "Selecionado",
        FIRST tit_acr NO-LOCK
              WHERE tit_acr.cod_estab = INT_tit_acr.cod_estab
              AND   tit_acr.num_id_tit_acr = int_tit_acr.num_id_tit_acr,
        FIRST emscad.cliente NO-LOCK
            WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente
        BREAK BY tit_acr.cdn_cliente:
        ASSIGN c-ender      = ""
               c-bairro     = ""
               c-cid        = ""
               c-uf         = ""
               c-cgc        = ""
               c-email      = ""
               c-ins-estad  = ""
               c-ins-munic  = ""
               c-cep        = ""
               c-tip-pessoa = "".
        IF emscad.cliente.num_pessoa MODULO 2 = 0 THEN DO:
            FIND pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_fisic THEN
                ASSIGN c-ender      = pessoa_fisic.nom_endereco 
                       c-bairro     = pessoa_fisic.nom_bairro
                       c-cid        = pessoa_fisic.nom_cidade
                       c-uf         = pessoa_fisic.cod_unid_federac
                       c-cep        = pessoa_fisic.cod_cep
                       c-cgc        = pessoa_fisic.cod_id_feder
                       c-email      = pessoa_fisic.cod_e_mail
                       c-ins-estad  = ""
                       c-ins-munic  = ""
                       c-fone       = pessoa_fisic.cod_telefone
                       c-fone       = REPLACE(c-fone,"-","")
                       c-fone       = REPLACE(c-fone,")","")
                       c-fone       = REPLACE(c-fone,"(","")
                       c-fone       = REPLACE(c-fone," ","")
                       c-nome-emit  = pessoa_fisic.nom_pessoa
                       c-tip-pessoa = "01".
        END.
        ELSE DO:
            FIND pessoa_jurid NO-LOCK
                WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_jurid THEN DO:
                IF pessoa_jurid.nom_endereco      = pessoa_jurid.nom_ender_cobr 
                OR pessoa_jurid.nom_ender_cobr = "" THEN
                    ASSIGN c-ender      = pessoa_jurid.nom_endereco 
                           c-bairro     = pessoa_jurid.nom_bairro
                           c-cid        = pessoa_jurid.nom_cidade
                           c-uf         = pessoa_jurid.cod_unid_federac
                           c-cep        = pessoa_jurid.cod_cep
                           c-cgc        = pessoa_jurid.cod_id_feder
                           c-email      = pessoa_jurid.cod_e_mail.
                ELSE 
                    ASSIGN c-ender     = pessoa_jurid.nom_ender_cobr
                           c-bairro    = pessoa_jurid.nom_bairro_cobr
                           c-cid       = pessoa_jurid.nom_cidad_cobr
                           c-uf        = pessoa_jurid.cod_unid_federac_cobr
                           c-cep       = pessoa_jurid.cod_cep_cobr
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail_cobr.
                ASSIGN c-ins-estad  = pessoa_jurid.cod_id_estad_jurid
                       c-ins-munic  = pessoa_jurid.cod_id_munic_jurid
                       c-nome-emit  = pessoa_jurid.nom_pessoa
                       c-fone       = pessoa_jurid.cod_telefone
                       c-fone       = REPLACE(c-fone,"-","")
                       c-fone       = REPLACE(c-fone,")","")
                       c-fone       = REPLACE(c-fone,"(","")
                       c-fone       = REPLACE(c-fone," ","")
                       c-tip-pessoa = "02".
            END.
        END.
        IF FIRST-OF(tit_acr.cdn_cliente) THEN DO:
            FIND LAST histor_clien NO-LOCK
               WHERE histor_clien.cod_empresa = emscad.cliente.cod_empresa
               AND   histor_clien.cdn_cliente = emscad.cliente.cdn_cliente NO-ERROR.
            IF NOT AVAIL histor_clien THEN DO:
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Averbach"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Averbach" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
            ELSE DO: 
                ASSIGN i-seqtemp = histor_clien.num_seq_histor_clien.
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = i-seqtemp + 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Averbach"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Averbach" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
        END.
            
        ASSIGN i-contador   = i-contador + 1
               c-numero     = STRING(tit_acr.cod_tit_acr) 
               c-parcela    = STRING(tit_acr.cod_parcela)
               c-data       =        STRING(  DAY(tit_acr.dat_vencto_tit_acr),   "99")
                            +        STRING(MONTH(tit_acr.dat_vencto_tit_acr),   "99")
                            + SUBSTR(STRING( YEAR(tit_acr.dat_vencto_tit_acr), "9999"),3,2)
               c-esp        = "DP"
               c-vl-titulo = STRING(tit_acr.val_sdo_tit_acr       * 100, "9999999999")
               c-vl-cart   = STRING(int_tit_acr.val_desp_cartorio * 100,   "99999999").                    

        PUT UNFORMATTED 
            "10282901000000127"   
            FILL(" ", 20)         
            FILL("0", 20)         
            FILL(" ", 05)         
            FILL("0", 16)         
            FILL(" ", 28)         
            FILL("0", 01)         
            FILL(" ", 01)         
            FILL("0", 02)         
            c-numero
            c-parcela
            c-data                                 
            FILL("0", 03)
            c-vl-titulo
            c-vl-cart                           
            "01"                   
            FILL(" ", 01)         
            FILL("0", 10)         
            FILL(" ", 13)         
            FILL("0", 06)         
            FILL(" ", 13)         
            FILL("0", 26)         
            c-tip-pessoa
            STRING(c-cgc, "99999999999999") 
            c-nome-emit  FORMAT "x(40)" 
            STRING(c-ender, "x(40)")    
            STRING(SUBSTRING(STRING(DEC(c-fone)), 1, 2), "99")                      
            STRING(SUBSTRING(STRING(DEC(c-fone)), 3, LENGTH(c-fone) - 2), "99999999")
            FILL(" ", 02)         
            STRING(c-cep, "99999999")    
            STRING(c-cid, "x(15)")                                                                             
            STRING(c-uf, "x(02)")       
            FILL(" ", 43)        
            STRING(i-contador + 1, "999999") SKIP.
                                                   
        /*****  Atualiza para os titulos para ENVIADO e armazena DATA DO ENVIO  *****/
        ASSIGN int_tit_acr.ind_sit_envio      = "Enviado"
               int_tit_acr.dat_envi_asses_cob = TODAY.
        
        /***** Cria TT de Titulos de Enviados  *****/
        CREATE tt_tit_acr_enviado.
        ASSIGN tt_tit_acr_enviado.cod_estab          = tit_acr.cod_estab
               tt_tit_acr_enviado.cod_espec_docto    = tit_acr.cod_espec_docto   
               tt_tit_acr_enviado.cod_ser_docto      = tit_acr.cod_ser_docto     
               tt_tit_acr_enviado.cod_tit_acr        = tit_acr.cod_tit_acr       
               tt_tit_acr_enviado.cod_parcela        = tit_acr.cod_parcela       
               tt_tit_acr_enviado.dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
               tt_tit_acr_enviado.dat_emis_docto     = tit_acr.dat_emis_docto    
               tt_tit_acr_enviado.cod_portador       = tit_acr.cod_portador      
               tt_tit_acr_enviado.cod_cart_bcia      = tit_acr.cod_cart_bcia     
               tt_tit_acr_enviado.cdn_cliente        = tit_acr.cdn_cliente       
               tt_tit_acr_enviado.nom_abrev          = emscad.cliente.nom_abrev        
               tt_tit_acr_enviado.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
               tt_tit_acr_enviado.val_origin_tit_acr = tit_acr.val_origin_tit_acr
               tt_tit_acr_enviado.val_desp_cartorio   = int_tit_acr.val_desp_cartorio.

    END.         /******* FOR EACH TITULO *********/
            
    PUT UNFORMATTED "9"  FILL(" ", 393) STRING(i-contador + 2, "999999") SKIP.
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.
            
    ASSIGN de-tot-car = 0
           de-tot-cli = 0.
              
    /***** "Gerando Arquivo de Titulos Enviados....".   *****/
    OUTPUT TO VALUE(p-arquivo2) PAGE-SIZE 0.
    ASSIGN i-contador = 0.
    FOR EACH tt_tit_acr_enviado NO-LOCK
        BREAK BY tt_tit_acr_enviado.cdn_cliente
              BY tt_tit_acr_enviado.dat_vencto_tit_acr:
        
        FIND FIRST emscad.cliente NO-LOCK
             WHERE emscad.cliente.cdn_cliente = tt_tit_acr_enviado.cdn_cliente NO-ERROR. 
        IF FIRST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(22)
               "Titulos Enviados Averbach - "
               TODAY FORMAT "99/99/9999" SKIP(2)
               "Esp Ser Titulo    /P  Emissao   Vencto Port /Car "
               "Codigo       Nome Abrev      Valo Cartorio   Valor Original" SKIP 
               "--- --- ------------ -------- -------- ----- --- "
               "-----------  --------------- --------------- ---------------" SKIP.
        END.

        ASSIGN de-tot-car = de-tot-car + tt_tit_acr_enviado.val_desp_cartorio
               de-tot-cli = de-tot-cli + tt_tit_acr_enviado.val_sdo_tit_acr.
                 
        PUT tt_tit_acr_enviado.cod_espec_docto    " "
            tt_tit_acr_enviado.cod_ser_docto      " "
            tt_tit_acr_enviado.cod_tit_acr  
            tt_tit_acr_enviado.cod_parcela        " "
            tt_tit_acr_enviado.dat_emis_docto     FORMAT "99/99/99" " "
            tt_tit_acr_enviado.dat_vencto_tit_acr FORMAT "99/99/99" " "
            tt_tit_acr_enviado.cod_portador       " " 
            tt_tit_acr_enviado.cod_cart_bcia      " "
            tt_tit_acr_enviado.cdn_cliente        "  "
            tt_tit_acr_enviado.nom_abrev          FORMAT "x(15)" " "
            tt_tit_acr_enviado.val_desp_cartorio  " "
            tt_tit_acr_enviado.val_sdo_tit_acr    SKIP.

        IF LAST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(38) "   Totais do Cliente"
               de-tot-car   "  "  
               de-tot-cli.
           IF LINE-COUNTER > 48 THEN 
              PAGE.
           ELSE 
              PUT SKIP(6).
              
           ASSIGN de-tot-car = 0 
                  de-tot-cli = 0.
        END.
    END. /****** FOR EACH tt_tit_acr_enviado ******/
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.

    FOR EACH tt_tit_acr_enviado:
        FIND tit_acr NO-LOCK
             WHERE tit_acr.cod_estab         = tt_tit_acr_enviado.cod_estab      
             AND   tit_acr.cod_espec_docto   = tt_tit_acr_enviado.cod_espec_docto
             AND   tit_acr.cod_ser_docto     = tt_tit_acr_enviado.cod_ser_docto  
             AND   tit_acr.cod_tit_acr       = tt_tit_acr_enviado.cod_tit_acr    
             AND   tit_acr.cod_parcela       = tt_tit_acr_enviado.cod_parcela    NO-ERROR.
        RUN piAlteraTitulo (INPUT  "9928",
                            INPUT  "90",
                            INPUT  "Averbach",
                            OUTPUT vRetorno).  
        
        IF vRetorno = "OK" THEN
           DELETE tt_tit_acr_enviado.
    END. /*  FOR EACH tt_tit_acr_enviado  */  
    FOR EACH  tt_int_tit_acr:
        DELETE tt_int_tit_acr.
    END.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dejuris C-Win 
PROCEDURE pi-dejuris PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-arquivo1 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo2 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo3 AS CHAR FORMAT "x(256)".

    DEF VAR i-seqtemp AS INT NO-UNDO.

    FOR EACH tt_tit_acr_enviado:
        DELETE tt_tit_acr_enviado.
    END.

    /*   Message "Gerando Arquivo de Titulos ....".   */
    OUTPUT TO VALUE(p-arquivo1) PAGE-SIZE 0 CONVERT TARGET 'iso8859-1'.
    ASSIGN i-contador = 0.
    FOR EACH  tt_int_tit_acr,
        FIRST mgesp.int_tit_acr EXCLUSIVE-LOCK
        WHERE int_tit_acr.cod_estab      = tt_int_tit_acr.cod_estab 
        AND   int_tit_acr.num_id_tit_acr = tt_int_tit_acr.num_id_tit_acr
        AND   int_tit_acr.ind_sit_envio = "Selecionado",
        FIRST tit_acr NO-LOCK
              WHERE tit_acr.cod_estab = INT_tit_acr.cod_estab
              AND   tit_acr.num_id_tit_acr = int_tit_acr.num_id_tit_acr,
        FIRST emscad.cliente NO-LOCK
            WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente
        BREAK BY tit_acr.cdn_cliente:
        ASSIGN c-ender     = ""
               c-bairro    = ""
               c-cid       = ""
               c-uf        = ""
               c-cgc       = ""
               c-email     = ""
               c-ins-estad = ""
               c-ins-munic = ""
               c-cep       = "".
        IF emscad.cliente.num_pessoa MODULO 2 = 0 THEN DO:
            FIND pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_fisic THEN
                ASSIGN c-ender     = pessoa_fisic.nom_endereco 
                       c-bairro    = pessoa_fisic.nom_bairro
                       c-cid       = pessoa_fisic.nom_cidade
                       c-uf        = pessoa_fisic.cod_unid_federac
                       c-cep       = pessoa_fisic.cod_cep
                       c-cgc       = pessoa_fisic.cod_id_feder
                       c-email     = pessoa_fisic.cod_e_mail
                       c-ins-estad = ""
                       c-ins-munic = ""
                       c-fone      = pessoa_fisic.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","")
                       c-nome-emit = pessoa_fisic.nom_pessoa.
        END.
        ELSE DO:
            FIND pessoa_jurid NO-LOCK
                WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_jurid THEN DO:
                IF pessoa_jurid.nom_endereco      = pessoa_jurid.nom_ender_cobr 
                OR pessoa_jurid.nom_ender_cobr = "" THEN
                    ASSIGN c-ender     = pessoa_jurid.nom_endereco 
                           c-bairro    = pessoa_jurid.nom_bairro
                           c-cid       = pessoa_jurid.nom_cidade
                           c-uf        = pessoa_jurid.cod_unid_federac
                           c-cep       = pessoa_jurid.cod_cep
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail.
                ELSE 
                    ASSIGN c-ender     = pessoa_jurid.nom_ender_cobr
                           c-bairro    = pessoa_jurid.nom_bairro_cobr
                           c-cid       = pessoa_jurid.nom_cidad_cobr
                           c-uf        = pessoa_jurid.cod_unid_federac_cobr
                           c-cep       = pessoa_jurid.cod_cep_cobr
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail_cobr.
                 ASSIGN c-ins-estad = pessoa_jurid.cod_id_estad_jurid
                        c-ins-munic = pessoa_jurid.cod_id_munic_jurid
                        c-nome-emit = pessoa_jurid.nom_pessoa
                        c-fone      = pessoa_jurid.cod_telefone
                        c-fone      = REPLACE(c-fone,"-","")
                        c-fone      = REPLACE(c-fone,")","")
                        c-fone      = REPLACE(c-fone,"(","")
                        c-fone      = REPLACE(c-fone," ","").
            END.
        END.
        IF FIRST-OF(tit_acr.cdn_cliente) THEN DO:
            FIND LAST histor_clien NO-LOCK
               WHERE histor_clien.cod_empresa = emscad.cliente.cod_empresa
               AND   histor_clien.cdn_cliente = emscad.cliente.cdn_cliente NO-ERROR.
            IF NOT AVAIL histor_clien THEN DO:
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Dejuris"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Dejuris" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
            ELSE DO: 
                ASSIGN i-seqtemp = histor_clien.num_seq_histor_clien.
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = i-seqtemp + 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Dejuris"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Dejuris" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
        END.
            
        ASSIGN i-contador   = i-contador + 1
               c-numero     = STRING(tit_acr.cod_tit_acr) 
               c-parcela    = STRING(tit_acr.cod_parcela)
               c-data       = SUBSTR(STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_vencto_tit_acr), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_vencto_tit_acr),"99"),1,2)
               c-data-emis  = SUBSTR(STRING(YEAR(tit_acr.dat_emis_docto),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_emis_docto), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_emis_docto),"99"),1,2)
               c-esp        = "DP"
               c-vl-titulo = STRING(tit_acr.val_sdo_tit_acr, ">>>,>>>,>>9.99").
               c-vl-titulo = REPLACE(c-vl-titulo,",","." ).                    
               c-vl-cart   = STRING(int_tit_acr.val_desp_cartorio, ">>>,>>>,>>9.99").
               c-vl-cart   = REPLACE(c-vl-cart,",",".").                    

/* ** Informaá‰es solicitadas no EXCEL - enviado arquivo texto separado por ";" pois a Assessoria n∆o enviou padr∆o de layout
RAZ«O SOCIAL 	 
CNPJ 	 
DAT. DE VENCTO 	 
Nß DO T÷TULO 	
VALOR	
EMAIL
ENDEREÄO 	 
BAIRRO 	 
MUNICIPIO 	 
CEP 	 
TELEFONE 	 
UF 
***/

        PUT c-nome-emit             FORMAT "!(50)"           ";"
            c-cgc FORMAT "X(14)"                             ";"
            SUBSTR(c-data,7,2)      FORMAT "99" "/" SUBSTR(c-data,5,2)      FORMAT "99" "/" SUBSTR(c-data,1,4)      FORMAT "9999"            ";"
            INT(c-numero)           FORMAT "999999999999"    ";"
            c-parcela                                        ";"
            c-vl-titulo             FORMAT "999999999999999" ";"
            c-email                                          ";"
            c-ender                 FORMAT "X(50)"           ";"
            c-bairro                FORMAT "X(20)"           ";"
            c-cid                   FORMAT "!(20)"           ";"
            c-cep                   FORMAT "99999999"        ";"
            c-fone                  FORMAT "X(11)"           ";"
            c-uf                    FORMAT "!(02)" SKIP.
                                                   
        /*****  Atualiza para os titulos para ENVIADO e armazena DATA DO ENVIO  *****/
        ASSIGN int_tit_acr.ind_sit_envio      = "Enviado"
               int_tit_acr.dat_envi_asses_cob = TODAY.
        
        /***** Cria TT de Titulos de Enviados  *****/
        CREATE tt_tit_acr_enviado.
        ASSIGN tt_tit_acr_enviado.cod_estab          = tit_acr.cod_estab
               tt_tit_acr_enviado.cod_espec_docto    = tit_acr.cod_espec_docto   
               tt_tit_acr_enviado.cod_ser_docto      = tit_acr.cod_ser_docto     
               tt_tit_acr_enviado.cod_tit_acr        = tit_acr.cod_tit_acr       
               tt_tit_acr_enviado.cod_parcela        = tit_acr.cod_parcela       
               tt_tit_acr_enviado.dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
               tt_tit_acr_enviado.dat_emis_docto     = tit_acr.dat_emis_docto    
               tt_tit_acr_enviado.cod_portador       = tit_acr.cod_portador      
               tt_tit_acr_enviado.cod_cart_bcia      = tit_acr.cod_cart_bcia     
               tt_tit_acr_enviado.cdn_cliente        = tit_acr.cdn_cliente       
               tt_tit_acr_enviado.nom_abrev          = emscad.cliente.nom_abrev        
               tt_tit_acr_enviado.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
               tt_tit_acr_enviado.val_origin_tit_acr = tit_acr.val_origin_tit_acr
               tt_tit_acr_enviado.val_desp_cartorio   = int_tit_acr.val_desp_cartorio.

    END.         /******* FOR EACH TITULO *********/
            
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.
            
    ASSIGN de-tot-car = 0
           de-tot-cli = 0.
              
    /***** "Gerando Arquivo de Titulos Enviados....".   *****/
    OUTPUT TO VALUE(p-arquivo2) PAGE-SIZE 0.
    ASSIGN i-contador = 0.
    FOR EACH tt_tit_acr_enviado NO-LOCK
        BREAK BY tt_tit_acr_enviado.cdn_cliente
              BY tt_tit_acr_enviado.dat_vencto_tit_acr:
        
        FIND FIRST emscad.cliente NO-LOCK
             WHERE emscad.cliente.cdn_cliente = tt_tit_acr_enviado.cdn_cliente NO-ERROR. 
        IF FIRST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(22)
               "Titulos Enviados Dejuris - "
               TODAY FORMAT "99/99/9999" SKIP(2)
               "Esp Ser Titulo    /P  Emissao   Vencto Port /Car "
               "Codigo       Nome Abrev      Valo Cartorio   Valor Original" SKIP 
               "--- --- ------------ -------- -------- ----- --- "
               "-----------  --------------- --------------- ---------------" SKIP.
        END.

        ASSIGN de-tot-car = de-tot-car + tt_tit_acr_enviado.val_desp_cartorio
               de-tot-cli = de-tot-cli + tt_tit_acr_enviado.val_sdo_tit_acr.
                 
        PUT tt_tit_acr_enviado.cod_espec_docto    " "
            tt_tit_acr_enviado.cod_ser_docto      " "
            tt_tit_acr_enviado.cod_tit_acr  
            tt_tit_acr_enviado.cod_parcela        " "
            tt_tit_acr_enviado.dat_emis_docto     FORMAT "99/99/99" " "
            tt_tit_acr_enviado.dat_vencto_tit_acr FORMAT "99/99/99" " "
            tt_tit_acr_enviado.cod_portador       " " 
            tt_tit_acr_enviado.cod_cart_bcia      " "
            tt_tit_acr_enviado.cdn_cliente        "  "
            tt_tit_acr_enviado.nom_abrev          FORMAT "x(15)" " "
            tt_tit_acr_enviado.val_desp_cartorio  " "
            tt_tit_acr_enviado.val_sdo_tit_acr    SKIP.

        IF LAST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(38) "   Totais do Cliente"
               de-tot-car   "  "  
               de-tot-cli.
           IF LINE-COUNTER > 48 THEN 
              PAGE.
           ELSE 
              PUT SKIP(6).
              
           ASSIGN de-tot-car = 0 
                  de-tot-cli = 0.
        END.
    END. /****** FOR EACH tt_tit_acr_enviado ******/
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.

    FOR EACH tt_tit_acr_enviado:
        FIND tit_acr NO-LOCK
             WHERE tit_acr.cod_estab         = tt_tit_acr_enviado.cod_estab      
             AND   tit_acr.cod_espec_docto   = tt_tit_acr_enviado.cod_espec_docto
             AND   tit_acr.cod_ser_docto     = tt_tit_acr_enviado.cod_ser_docto  
             AND   tit_acr.cod_tit_acr       = tt_tit_acr_enviado.cod_tit_acr    
             AND   tit_acr.cod_parcela       = tt_tit_acr_enviado.cod_parcela    NO-ERROR.
        RUN piAlteraTitulo (INPUT  "9925",
                            INPUT  "90",
                            INPUT  "Dejuris",
                            OUTPUT vRetorno).  
        
        IF vRetorno = "OK" THEN
           DELETE tt_tit_acr_enviado.
    END. /*  FOR EACH tt_tit_acr_enviado  */  
    FOR EACH  tt_int_tit_acr:
        DELETE tt_int_tit_acr.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dejuris C-Win 
PROCEDURE pi-GoldStar PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-arquivo1 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo2 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo3 AS CHAR FORMAT "x(256)".

    DEF VAR de-vl-titulo AS DEC NO-UNDO.
    DEF VAR de-vl-cart AS DEC NO-UNDO.
      
    DEF VAR i-seqtemp AS INT NO-UNDO.

    FOR EACH tt_tit_acr_enviado:
        DELETE tt_tit_acr_enviado.
    END.

    /*   Message "Gerando Arquivo de Titulos ....".   */
    OUTPUT TO VALUE(p-arquivo1) PAGE-SIZE 0 CONVERT TARGET 'iso8859-1'.
    PUT "RAZ«O SOCIAL;CNPJ;DAT. DE VENCTO;Nß DO T÷TULO;PARCELA;VALOR;EMAIL;ENDEREÄO;BAIRRO;MUNICIPIO;CEP;TELEFONE;UF" SKIP.

    ASSIGN i-contador = 0.
    FOR EACH  tt_int_tit_acr,
        FIRST mgesp.int_tit_acr EXCLUSIVE-LOCK
        WHERE int_tit_acr.cod_estab      = tt_int_tit_acr.cod_estab 
        AND   int_tit_acr.num_id_tit_acr = tt_int_tit_acr.num_id_tit_acr
        AND   int_tit_acr.ind_sit_envio = "Selecionado",
        FIRST tit_acr NO-LOCK
              WHERE tit_acr.cod_estab = INT_tit_acr.cod_estab
              AND   tit_acr.num_id_tit_acr = int_tit_acr.num_id_tit_acr,
        FIRST emscad.cliente NO-LOCK
            WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente
        BREAK BY tit_acr.cdn_cliente:
        ASSIGN c-ender     = ""
               c-bairro    = ""
               c-cid       = ""
               c-uf        = ""
               c-cgc       = ""
               c-email     = ""
               c-ins-estad = ""
               c-ins-munic = ""
               c-cep       = "".
        IF emscad.cliente.num_pessoa MODULO 2 = 0 THEN DO:
            FIND pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_fisic THEN
                ASSIGN c-ender     = pessoa_fisic.nom_endereco 
                       c-bairro    = pessoa_fisic.nom_bairro
                       c-cid       = pessoa_fisic.nom_cidade
                       c-uf        = pessoa_fisic.cod_unid_federac
                       c-cep       = pessoa_fisic.cod_cep
                       c-cgc       = pessoa_fisic.cod_id_feder
                       c-email     = pessoa_fisic.cod_e_mail
                       c-ins-estad = ""
                       c-ins-munic = ""
                       c-fone      = pessoa_fisic.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","")
                       c-nome-emit = pessoa_fisic.nom_pessoa.
        END.
        ELSE DO:
            FIND pessoa_jurid NO-LOCK
                WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_jurid THEN DO:
                IF pessoa_jurid.nom_endereco      = pessoa_jurid.nom_ender_cobr 
                OR pessoa_jurid.nom_ender_cobr = "" THEN
                    ASSIGN c-ender     = pessoa_jurid.nom_endereco 
                           c-bairro    = pessoa_jurid.nom_bairro
                           c-cid       = pessoa_jurid.nom_cidade
                           c-uf        = pessoa_jurid.cod_unid_federac
                           c-cep       = pessoa_jurid.cod_cep
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail.
                ELSE 
                    ASSIGN c-ender     = pessoa_jurid.nom_ender_cobr
                           c-bairro    = pessoa_jurid.nom_bairro_cobr
                           c-cid       = pessoa_jurid.nom_cidad_cobr
                           c-uf        = pessoa_jurid.cod_unid_federac_cobr
                           c-cep       = pessoa_jurid.cod_cep_cobr
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail_cobr.
                 ASSIGN c-ins-estad = pessoa_jurid.cod_id_estad_jurid
                        c-ins-munic = pessoa_jurid.cod_id_munic_jurid
                        c-nome-emit = pessoa_jurid.nom_pessoa
                        c-fone      = pessoa_jurid.cod_telefone
                        c-fone      = REPLACE(c-fone,"-","")
                        c-fone      = REPLACE(c-fone,")","")
                        c-fone      = REPLACE(c-fone,"(","")
                        c-fone      = REPLACE(c-fone," ","").
            END.
        END.
        IF FIRST-OF(tit_acr.cdn_cliente) THEN DO:
            FIND LAST histor_clien NO-LOCK
               WHERE histor_clien.cod_empresa = emscad.cliente.cod_empresa
               AND   histor_clien.cdn_cliente = emscad.cliente.cdn_cliente NO-ERROR.
            IF NOT AVAIL histor_clien THEN DO:
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Gold Star"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria GoldStar" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
            ELSE DO: 
                ASSIGN i-seqtemp = histor_clien.num_seq_histor_clien.
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = i-seqtemp + 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Gold Star"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Gold Star" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
        END.
            
        ASSIGN i-contador   = i-contador + 1
               c-numero     = STRING(tit_acr.cod_tit_acr) 
               c-parcela    = STRING(tit_acr.cod_parcela)
               c-data       = SUBSTR(STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_vencto_tit_acr), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_vencto_tit_acr),"99"),1,2)
               c-data-emis  = SUBSTR(STRING(YEAR(tit_acr.dat_emis_docto),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_emis_docto), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_emis_docto),"99"),1,2)
               c-esp        = "DP"
               de-vl-titulo = tit_acr.val_sdo_tit_acr
               de-vl-cart   = int_tit_acr.val_desp_cartorio.
               

        
        IF tit_acr.cod_espec_docto = "VD"
        THEN DO:            
             FIND FIRST b_tit_acr_VE NO-LOCK
                 WHERE b_tit_acr_VE.cod_estab       = tit_acr.cod_estab
                   AND b_tit_acr_VE.cod_espec_docto = "VE"
                   AND b_tit_acr_VE.cod_ser_docto   = tit_acr.cod_ser_docto
                   AND b_tit_acr_VE.cod_tit_acr     = tit_acr.cod_tit_acr
                   AND b_tit_acr_VE.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
             IF AVAIL b_tit_acr_VE 
                THEN ASSIGN c-data = SUBSTR(STRING(YEAR(b_tit_acr_VE.dat_vencto_tit_acr),"9999"),1,4) 
                                     + SUBSTR(STRING(MONTH(b_tit_acr_VE.dat_vencto_tit_acr), "99"),1,2)
                                     + SUBSTR(STRING(DAY(b_tit_acr_VE.dat_vencto_tit_acr),"99"),1,2).
        END.

/* ** Informaá‰es solicitadas no EXCEL - enviado arquivo texto separado por ";" pois a Assessoria n∆o enviou padr∆o de layout
RAZ«O SOCIAL 	 
CNPJ 	 
DAT. DE VENCTO 	 
Nß DO T÷TULO 	
VALOR	
EMAIL
ENDEREÄO 	 
BAIRRO 	 
MUNICIPIO 	 
CEP 	 
TELEFONE 	 
UF 
***/
        CASE LENGTH(c-cgc):
            WHEN 14 THEN ASSIGN c-cgc = STRING(c-cgc, "99.999.999/9999-99").
            WHEN 15 THEN ASSIGN c-cgc = STRING(c-cgc, "999.999.999/9999-99").
            OTHERWISE    ASSIGN c-cgc = STRING(c-cgc, "999.999.999-99").
        END CASE.

        PUT c-nome-emit             FORMAT "!(50)"           ";"
            c-cgc             ";"
            SUBSTR(c-data,7,2)      FORMAT "99" "/" SUBSTR(c-data,5,2)      FORMAT "99" "/" SUBSTR(c-data,1,4)      FORMAT "9999"            ";"
            INT(c-numero)           FORMAT "999999999999"    ";"
            c-parcela                                        ";"
            de-vl-titulo                                     ";"
            c-email                                          ";"
            c-ender                 FORMAT "X(50)"           ";"
            c-bairro                FORMAT "X(20)"           ";"
            c-cid                   FORMAT "!(20)"           ";"
            c-cep                   FORMAT "99999999"        ";"
            c-fone                  FORMAT "X(11)"           ";"
            c-uf                    FORMAT "!(02)" SKIP.
                                                   
        /*****  Atualiza para os titulos para ENVIADO e armazena DATA DO ENVIO  *****/
        ASSIGN int_tit_acr.ind_sit_envio      = "Enviado"
               int_tit_acr.dat_envi_asses_cob = TODAY.
        
        /***** Cria TT de Titulos de Enviados  *****/
        CREATE tt_tit_acr_enviado.
        ASSIGN tt_tit_acr_enviado.cod_estab          = tit_acr.cod_estab
               tt_tit_acr_enviado.cod_espec_docto    = tit_acr.cod_espec_docto   
               tt_tit_acr_enviado.cod_ser_docto      = tit_acr.cod_ser_docto     
               tt_tit_acr_enviado.cod_tit_acr        = tit_acr.cod_tit_acr       
               tt_tit_acr_enviado.cod_parcela        = tit_acr.cod_parcela       
               tt_tit_acr_enviado.dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
               tt_tit_acr_enviado.dat_emis_docto     = tit_acr.dat_emis_docto    
               tt_tit_acr_enviado.cod_portador       = tit_acr.cod_portador      
               tt_tit_acr_enviado.cod_cart_bcia      = tit_acr.cod_cart_bcia     
               tt_tit_acr_enviado.cdn_cliente        = tit_acr.cdn_cliente       
               tt_tit_acr_enviado.nom_abrev          = emscad.cliente.nom_abrev        
               tt_tit_acr_enviado.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
               tt_tit_acr_enviado.val_origin_tit_acr = tit_acr.val_origin_tit_acr
               tt_tit_acr_enviado.val_desp_cartorio   = int_tit_acr.val_desp_cartorio.

    END.         /******* FOR EACH TITULO *********/
            
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.
            
    ASSIGN de-tot-car = 0
           de-tot-cli = 0.
              
    /***** "Gerando Arquivo de Titulos Enviados....".   *****/
    OUTPUT TO VALUE(p-arquivo2) PAGE-SIZE 0.
    ASSIGN i-contador = 0.
    FOR EACH tt_tit_acr_enviado NO-LOCK
        BREAK BY tt_tit_acr_enviado.cdn_cliente
              BY tt_tit_acr_enviado.dat_vencto_tit_acr:
        
        FIND FIRST emscad.cliente NO-LOCK
             WHERE emscad.cliente.cdn_cliente = tt_tit_acr_enviado.cdn_cliente NO-ERROR. 
        IF FIRST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(22)
               "Titulos Enviados Gold Star - "
               TODAY FORMAT "99/99/9999" SKIP(2)
               "Esp Ser Titulo    /P  Emissao   Vencto Port /Car "
               "Codigo       Nome Abrev      Valo Cartorio   Valor Original" SKIP 
               "--- --- ------------ -------- -------- ----- --- "
               "-----------  --------------- --------------- ---------------" SKIP.
        END.

        ASSIGN de-tot-car = de-tot-car + tt_tit_acr_enviado.val_desp_cartorio
               de-tot-cli = de-tot-cli + tt_tit_acr_enviado.val_sdo_tit_acr.
                 
        PUT tt_tit_acr_enviado.cod_espec_docto    " "
            tt_tit_acr_enviado.cod_ser_docto      " "
            tt_tit_acr_enviado.cod_tit_acr  
            tt_tit_acr_enviado.cod_parcela        " "
            tt_tit_acr_enviado.dat_emis_docto     FORMAT "99/99/99" " "
            tt_tit_acr_enviado.dat_vencto_tit_acr FORMAT "99/99/99" " "
            tt_tit_acr_enviado.cod_portador       " " 
            tt_tit_acr_enviado.cod_cart_bcia      " "
            tt_tit_acr_enviado.cdn_cliente        "  "
            tt_tit_acr_enviado.nom_abrev          FORMAT "x(15)" " "
            tt_tit_acr_enviado.val_desp_cartorio  " "
            tt_tit_acr_enviado.val_sdo_tit_acr    SKIP.

        IF LAST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(38) "   Totais do Cliente"
               de-tot-car   "  "  
               de-tot-cli.
           IF LINE-COUNTER > 48 THEN 
              PAGE.
           ELSE 
              PUT SKIP(6).
              
           ASSIGN de-tot-car = 0 
                  de-tot-cli = 0.
        END.
    END. /****** FOR EACH tt_tit_acr_enviado ******/
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.

    FOR EACH tt_tit_acr_enviado:
        FIND tit_acr NO-LOCK
             WHERE tit_acr.cod_estab         = tt_tit_acr_enviado.cod_estab      
             AND   tit_acr.cod_espec_docto   = tt_tit_acr_enviado.cod_espec_docto
             AND   tit_acr.cod_ser_docto     = tt_tit_acr_enviado.cod_ser_docto  
             AND   tit_acr.cod_tit_acr       = tt_tit_acr_enviado.cod_tit_acr    
             AND   tit_acr.cod_parcela       = tt_tit_acr_enviado.cod_parcela    NO-ERROR.
        RUN piAlteraTitulo (INPUT  "9949",
                            INPUT  "90",
                            INPUT  "Gold Star",
                            OUTPUT vRetorno).  
        
        IF vRetorno = "OK" THEN
           DELETE tt_tit_acr_enviado.
    END. /*  FOR EACH tt_tit_acr_enviado  */  
    FOR EACH  tt_int_tit_acr:
        DELETE tt_int_tit_acr.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dejuris C-Win 
PROCEDURE pi-AMAssessoriaeCob  PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-arquivo1 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo2 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo3 AS CHAR FORMAT "x(256)".

    DEF VAR de-vl-titulo AS DEC NO-UNDO.
    DEF VAR de-vl-cart AS DEC NO-UNDO.
      
    DEF VAR i-seqtemp AS INT NO-UNDO.

    FOR EACH tt_tit_acr_enviado:
        DELETE tt_tit_acr_enviado.
    END.

    /*   Message "Gerando Arquivo de Titulos ....".   */
    OUTPUT TO VALUE(p-arquivo1) PAGE-SIZE 0 CONVERT TARGET 'iso8859-1'.
    PUT "RAZ«O SOCIAL;CNPJ;DAT. DE VENCTO;Nß DO T÷TULO;PARCELA;VALOR;EMAIL;ENDEREÄO;BAIRRO;MUNICIPIO;CEP;TELEFONE;UF" SKIP.

    ASSIGN i-contador = 0.
    FOR EACH  tt_int_tit_acr,
        FIRST mgesp.int_tit_acr EXCLUSIVE-LOCK
        WHERE int_tit_acr.cod_estab      = tt_int_tit_acr.cod_estab 
        AND   int_tit_acr.num_id_tit_acr = tt_int_tit_acr.num_id_tit_acr
        AND   int_tit_acr.ind_sit_envio = "Selecionado",
        FIRST tit_acr NO-LOCK
              WHERE tit_acr.cod_estab = INT_tit_acr.cod_estab
              AND   tit_acr.num_id_tit_acr = int_tit_acr.num_id_tit_acr,
        FIRST emscad.cliente NO-LOCK
            WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente
        BREAK BY tit_acr.cdn_cliente:
        ASSIGN c-ender     = ""
               c-bairro    = ""
               c-cid       = ""
               c-uf        = ""
               c-cgc       = ""
               c-email     = ""
               c-ins-estad = ""
               c-ins-munic = ""
               c-cep       = "".
        IF emscad.cliente.num_pessoa MODULO 2 = 0 THEN DO:
            FIND pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_fisic THEN
                ASSIGN c-ender     = pessoa_fisic.nom_endereco 
                       c-bairro    = pessoa_fisic.nom_bairro
                       c-cid       = pessoa_fisic.nom_cidade
                       c-uf        = pessoa_fisic.cod_unid_federac
                       c-cep       = pessoa_fisic.cod_cep
                       c-cgc       = pessoa_fisic.cod_id_feder
                       c-email     = pessoa_fisic.cod_e_mail
                       c-ins-estad = ""
                       c-ins-munic = ""
                       c-fone      = pessoa_fisic.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","")
                       c-nome-emit = pessoa_fisic.nom_pessoa.
        END.
        ELSE DO:
            FIND pessoa_jurid NO-LOCK
                WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_jurid THEN DO:
                IF pessoa_jurid.nom_endereco      = pessoa_jurid.nom_ender_cobr 
                OR pessoa_jurid.nom_ender_cobr = "" THEN
                    ASSIGN c-ender     = pessoa_jurid.nom_endereco 
                           c-bairro    = pessoa_jurid.nom_bairro
                           c-cid       = pessoa_jurid.nom_cidade
                           c-uf        = pessoa_jurid.cod_unid_federac
                           c-cep       = pessoa_jurid.cod_cep
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail.
                ELSE 
                    ASSIGN c-ender     = pessoa_jurid.nom_ender_cobr
                           c-bairro    = pessoa_jurid.nom_bairro_cobr
                           c-cid       = pessoa_jurid.nom_cidad_cobr
                           c-uf        = pessoa_jurid.cod_unid_federac_cobr
                           c-cep       = pessoa_jurid.cod_cep_cobr
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail_cobr.
                 ASSIGN c-ins-estad = pessoa_jurid.cod_id_estad_jurid
                        c-ins-munic = pessoa_jurid.cod_id_munic_jurid
                        c-nome-emit = pessoa_jurid.nom_pessoa
                        c-fone      = pessoa_jurid.cod_telefone
                        c-fone      = REPLACE(c-fone,"-","")
                        c-fone      = REPLACE(c-fone,")","")
                        c-fone      = REPLACE(c-fone,"(","")
                        c-fone      = REPLACE(c-fone," ","").
            END.
        END.
        IF FIRST-OF(tit_acr.cdn_cliente) THEN DO:
            FIND LAST histor_clien NO-LOCK
               WHERE histor_clien.cod_empresa = emscad.cliente.cod_empresa
               AND   histor_clien.cdn_cliente = emscad.cliente.cdn_cliente NO-ERROR.
            IF NOT AVAIL histor_clien THEN DO:
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = 1
                       histor_clien.des_abrev_histor_clien   = "AM ASSESSORIA E COBRANÄA "
                       histor_clien.des_histor_clien         = "Titulos enviados a AM ASSESSORIA E COBRANÄA " 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
            ELSE DO: 
                ASSIGN i-seqtemp = histor_clien.num_seq_histor_clien.
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = i-seqtemp + 1
                       histor_clien.des_abrev_histor_clien   = "AM ASSESSORIA E COBRANÄA "
                       histor_clien.des_histor_clien         = "Titulos enviados a AM ASSESSORIA E COBRANÄA " 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
        END.
            
        ASSIGN i-contador   = i-contador + 1
               c-numero     = STRING(tit_acr.cod_tit_acr) 
               c-parcela    = STRING(tit_acr.cod_parcela)
               c-data       = SUBSTR(STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_vencto_tit_acr), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_vencto_tit_acr),"99"),1,2)
               c-data-emis  = SUBSTR(STRING(YEAR(tit_acr.dat_emis_docto),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_emis_docto), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_emis_docto),"99"),1,2)
               c-esp        = "DP"
               de-vl-titulo = tit_acr.val_sdo_tit_acr
               de-vl-cart   = int_tit_acr.val_desp_cartorio.
               

        
        IF tit_acr.cod_espec_docto = "VD"
        THEN DO:            
             FIND FIRST b_tit_acr_VE NO-LOCK
                 WHERE b_tit_acr_VE.cod_estab       = tit_acr.cod_estab
                   AND b_tit_acr_VE.cod_espec_docto = "VE"
                   AND b_tit_acr_VE.cod_ser_docto   = tit_acr.cod_ser_docto
                   AND b_tit_acr_VE.cod_tit_acr     = tit_acr.cod_tit_acr
                   AND b_tit_acr_VE.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
             IF AVAIL b_tit_acr_VE 
                THEN ASSIGN c-data = SUBSTR(STRING(YEAR(b_tit_acr_VE.dat_vencto_tit_acr),"9999"),1,4) 
                                     + SUBSTR(STRING(MONTH(b_tit_acr_VE.dat_vencto_tit_acr), "99"),1,2)
                                     + SUBSTR(STRING(DAY(b_tit_acr_VE.dat_vencto_tit_acr),"99"),1,2).
        END.

/* ** Informaá‰es solicitadas no EXCEL - enviado arquivo texto separado por ";" pois a Assessoria n∆o enviou padr∆o de layout
RAZ«O SOCIAL 	 
CNPJ 	 
DAT. DE VENCTO 	 
Nß DO T÷TULO 	
VALOR	
EMAIL
ENDEREÄO 	 
BAIRRO 	 
MUNICIPIO 	 
CEP 	 
TELEFONE 	 
UF 
***/
        CASE LENGTH(c-cgc):
            WHEN 14 THEN ASSIGN c-cgc = STRING(c-cgc, "99.999.999/9999-99").
            WHEN 15 THEN ASSIGN c-cgc = STRING(c-cgc, "999.999.999/9999-99").
            OTHERWISE    ASSIGN c-cgc = STRING(c-cgc, "999.999.999-99").
        END CASE.

        PUT c-nome-emit             FORMAT "!(50)"           ";"
            c-cgc             ";"
            SUBSTR(c-data,7,2)      FORMAT "99" "/" SUBSTR(c-data,5,2)      FORMAT "99" "/" SUBSTR(c-data,1,4)      FORMAT "9999"            ";"
            INT(c-numero)           FORMAT "999999999999"    ";"
            c-parcela                                        ";"
            de-vl-titulo                                     ";"
            c-email                                          ";"
            c-ender                 FORMAT "X(50)"           ";"
            c-bairro                FORMAT "X(20)"           ";"
            c-cid                   FORMAT "!(20)"           ";"
            c-cep                   FORMAT "99999999"        ";"
            c-fone                  FORMAT "X(11)"           ";"
            c-uf                    FORMAT "!(02)" SKIP.
                                                   
        /*****  Atualiza para os titulos para ENVIADO e armazena DATA DO ENVIO  *****/
        ASSIGN int_tit_acr.ind_sit_envio      = "Enviado"
               int_tit_acr.dat_envi_asses_cob = TODAY.
        
        /***** Cria TT de Titulos de Enviados  *****/
        CREATE tt_tit_acr_enviado.
        ASSIGN tt_tit_acr_enviado.cod_estab          = tit_acr.cod_estab
               tt_tit_acr_enviado.cod_espec_docto    = tit_acr.cod_espec_docto   
               tt_tit_acr_enviado.cod_ser_docto      = tit_acr.cod_ser_docto     
               tt_tit_acr_enviado.cod_tit_acr        = tit_acr.cod_tit_acr       
               tt_tit_acr_enviado.cod_parcela        = tit_acr.cod_parcela       
               tt_tit_acr_enviado.dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
               tt_tit_acr_enviado.dat_emis_docto     = tit_acr.dat_emis_docto    
               tt_tit_acr_enviado.cod_portador       = tit_acr.cod_portador      
               tt_tit_acr_enviado.cod_cart_bcia      = tit_acr.cod_cart_bcia     
               tt_tit_acr_enviado.cdn_cliente        = tit_acr.cdn_cliente       
               tt_tit_acr_enviado.nom_abrev          = emscad.cliente.nom_abrev        
               tt_tit_acr_enviado.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
               tt_tit_acr_enviado.val_origin_tit_acr = tit_acr.val_origin_tit_acr
               tt_tit_acr_enviado.val_desp_cartorio   = int_tit_acr.val_desp_cartorio.

    END.         /******* FOR EACH TITULO *********/
            
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.
            
    ASSIGN de-tot-car = 0
           de-tot-cli = 0.
              
    /***** "Gerando Arquivo de Titulos Enviados....".   *****/
    OUTPUT TO VALUE(p-arquivo2) PAGE-SIZE 0 CONVERT TARGET 'iso8859-1'.
    ASSIGN i-contador = 0.
    FOR EACH tt_tit_acr_enviado NO-LOCK
        BREAK BY tt_tit_acr_enviado.cdn_cliente
              BY tt_tit_acr_enviado.dat_vencto_tit_acr:
        
        FIND FIRST emscad.cliente NO-LOCK
             WHERE emscad.cliente.cdn_cliente = tt_tit_acr_enviado.cdn_cliente NO-ERROR. 
        IF FIRST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(22)
               "Titulos Enviados AM ASSESSORIA E COBRANÄA  - "
               TODAY FORMAT "99/99/9999" SKIP(2)
               "Esp Ser Titulo    /P  Emissao   Vencto Port /Car "
               "Codigo       Nome Abrev      Valo Cartorio   Valor Original" SKIP 
               "--- --- ------------ -------- -------- ----- --- "
               "-----------  --------------- --------------- ---------------" SKIP.
        END.

        ASSIGN de-tot-car = de-tot-car + tt_tit_acr_enviado.val_desp_cartorio
               de-tot-cli = de-tot-cli + tt_tit_acr_enviado.val_sdo_tit_acr.
                 
        PUT tt_tit_acr_enviado.cod_espec_docto    " "
            tt_tit_acr_enviado.cod_ser_docto      " "
            tt_tit_acr_enviado.cod_tit_acr  
            tt_tit_acr_enviado.cod_parcela        " "
            tt_tit_acr_enviado.dat_emis_docto     FORMAT "99/99/99" " "
            tt_tit_acr_enviado.dat_vencto_tit_acr FORMAT "99/99/99" " "
            tt_tit_acr_enviado.cod_portador       " " 
            tt_tit_acr_enviado.cod_cart_bcia      " "
            tt_tit_acr_enviado.cdn_cliente        "  "
            tt_tit_acr_enviado.nom_abrev          FORMAT "x(15)" " "
            tt_tit_acr_enviado.val_desp_cartorio  " "
            tt_tit_acr_enviado.val_sdo_tit_acr    SKIP.

        IF LAST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(38) "   Totais do Cliente"
               de-tot-car   "  "  
               de-tot-cli.
           IF LINE-COUNTER > 48 THEN 
              PAGE.
           ELSE 
              PUT SKIP(6).
              
           ASSIGN de-tot-car = 0 
                  de-tot-cli = 0.
        END.
    END. /****** FOR EACH tt_tit_acr_enviado ******/
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.

    FOR EACH tt_tit_acr_enviado:
        FIND tit_acr NO-LOCK
             WHERE tit_acr.cod_estab         = tt_tit_acr_enviado.cod_estab      
             AND   tit_acr.cod_espec_docto   = tt_tit_acr_enviado.cod_espec_docto
             AND   tit_acr.cod_ser_docto     = tt_tit_acr_enviado.cod_ser_docto  
             AND   tit_acr.cod_tit_acr       = tt_tit_acr_enviado.cod_tit_acr    
             AND   tit_acr.cod_parcela       = tt_tit_acr_enviado.cod_parcela    NO-ERROR.
        RUN piAlteraTitulo (INPUT  "9956",
                            INPUT  "90",
                            INPUT  "AM ASSESSORIA E COBRANÄA ",
                            OUTPUT vRetorno).  
        
        IF vRetorno = "OK" THEN
           DELETE tt_tit_acr_enviado.
    END. /*  FOR EACH tt_tit_acr_enviado  */  
    FOR EACH  tt_int_tit_acr:
        DELETE tt_int_tit_acr.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dejuris C-Win 
PROCEDURE pi-angeza PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-arquivo1 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo2 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo3 AS CHAR FORMAT "x(256)".

    DEF VAR de-vl-titulo AS DEC NO-UNDO.
    DEF VAR de-vl-cart AS DEC NO-UNDO.
      
    DEF VAR i-seqtemp AS INT NO-UNDO.

    FOR EACH tt_tit_acr_enviado:
        DELETE tt_tit_acr_enviado.
    END.

    /*   Message "Gerando Arquivo de Titulos ....".   */
    OUTPUT TO VALUE(p-arquivo1) PAGE-SIZE 0 CONVERT TARGET 'iso8859-1'.
    PUT "RAZ«O SOCIAL;CNPJ;DAT. DE VENCTO;Nß DO T÷TULO;PARCELA;VALOR;EMAIL;ENDEREÄO;BAIRRO;MUNICIPIO;CEP;TELEFONE;UF" SKIP.

    ASSIGN i-contador = 0.
    FOR EACH  tt_int_tit_acr,
        FIRST mgesp.int_tit_acr EXCLUSIVE-LOCK
        WHERE int_tit_acr.cod_estab      = tt_int_tit_acr.cod_estab 
        AND   int_tit_acr.num_id_tit_acr = tt_int_tit_acr.num_id_tit_acr
        AND   int_tit_acr.ind_sit_envio = "Selecionado",
        FIRST tit_acr NO-LOCK
              WHERE tit_acr.cod_estab = INT_tit_acr.cod_estab
              AND   tit_acr.num_id_tit_acr = int_tit_acr.num_id_tit_acr,
        FIRST emscad.cliente NO-LOCK
            WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente
        BREAK BY tit_acr.cdn_cliente:
        ASSIGN c-ender     = ""
               c-bairro    = ""
               c-cid       = ""
               c-uf        = ""
               c-cgc       = ""
               c-email     = ""
               c-ins-estad = ""
               c-ins-munic = ""
               c-cep       = "".
        IF emscad.cliente.num_pessoa MODULO 2 = 0 THEN DO:
            FIND pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_fisic THEN
                ASSIGN c-ender     = pessoa_fisic.nom_endereco 
                       c-bairro    = pessoa_fisic.nom_bairro
                       c-cid       = pessoa_fisic.nom_cidade
                       c-uf        = pessoa_fisic.cod_unid_federac
                       c-cep       = pessoa_fisic.cod_cep
                       c-cgc       = pessoa_fisic.cod_id_feder
                       c-email     = pessoa_fisic.cod_e_mail
                       c-ins-estad = ""
                       c-ins-munic = ""
                       c-fone      = pessoa_fisic.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","")
                       c-nome-emit = pessoa_fisic.nom_pessoa.
        END.
        ELSE DO:
            FIND pessoa_jurid NO-LOCK
                WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_jurid THEN DO:
                IF pessoa_jurid.nom_endereco      = pessoa_jurid.nom_ender_cobr 
                OR pessoa_jurid.nom_ender_cobr = "" THEN
                    ASSIGN c-ender     = pessoa_jurid.nom_endereco 
                           c-bairro    = pessoa_jurid.nom_bairro
                           c-cid       = pessoa_jurid.nom_cidade
                           c-uf        = pessoa_jurid.cod_unid_federac
                           c-cep       = pessoa_jurid.cod_cep
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail.
                ELSE 
                    ASSIGN c-ender     = pessoa_jurid.nom_ender_cobr
                           c-bairro    = pessoa_jurid.nom_bairro_cobr
                           c-cid       = pessoa_jurid.nom_cidad_cobr
                           c-uf        = pessoa_jurid.cod_unid_federac_cobr
                           c-cep       = pessoa_jurid.cod_cep_cobr
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail_cobr.
                 ASSIGN c-ins-estad = pessoa_jurid.cod_id_estad_jurid
                        c-ins-munic = pessoa_jurid.cod_id_munic_jurid
                        c-nome-emit = pessoa_jurid.nom_pessoa
                        c-fone      = pessoa_jurid.cod_telefone
                        c-fone      = REPLACE(c-fone,"-","")
                        c-fone      = REPLACE(c-fone,")","")
                        c-fone      = REPLACE(c-fone,"(","")
                        c-fone      = REPLACE(c-fone," ","").
            END.
        END.
        IF FIRST-OF(tit_acr.cdn_cliente) THEN DO:
            FIND LAST histor_clien NO-LOCK
               WHERE histor_clien.cod_empresa = emscad.cliente.cod_empresa
               AND   histor_clien.cdn_cliente = emscad.cliente.cdn_cliente NO-ERROR.
            IF NOT AVAIL histor_clien THEN DO:
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Angeza"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Angeza" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
            ELSE DO: 
                ASSIGN i-seqtemp = histor_clien.num_seq_histor_clien.
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = i-seqtemp + 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Angeza"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Angeza" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
        END.
            
        ASSIGN i-contador   = i-contador + 1
               c-numero     = STRING(tit_acr.cod_tit_acr) 
               c-parcela    = STRING(tit_acr.cod_parcela)
               c-data       = SUBSTR(STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_vencto_tit_acr), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_vencto_tit_acr),"99"),1,2)
               c-data-emis  = SUBSTR(STRING(YEAR(tit_acr.dat_emis_docto),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_emis_docto), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_emis_docto),"99"),1,2)
               c-esp        = "DP"
               de-vl-titulo = tit_acr.val_sdo_tit_acr
               de-vl-cart   = int_tit_acr.val_desp_cartorio.
               

        
        IF tit_acr.cod_espec_docto = "VD"
        THEN DO:            
             FIND FIRST b_tit_acr_VE NO-LOCK
                 WHERE b_tit_acr_VE.cod_estab       = tit_acr.cod_estab
                   AND b_tit_acr_VE.cod_espec_docto = "VE"
                   AND b_tit_acr_VE.cod_ser_docto   = tit_acr.cod_ser_docto
                   AND b_tit_acr_VE.cod_tit_acr     = tit_acr.cod_tit_acr
                   AND b_tit_acr_VE.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
             IF AVAIL b_tit_acr_VE 
                THEN ASSIGN c-data = SUBSTR(STRING(YEAR(b_tit_acr_VE.dat_vencto_tit_acr),"9999"),1,4) 
                                     + SUBSTR(STRING(MONTH(b_tit_acr_VE.dat_vencto_tit_acr), "99"),1,2)
                                     + SUBSTR(STRING(DAY(b_tit_acr_VE.dat_vencto_tit_acr),"99"),1,2).
        END.

/* ** Informaá‰es solicitadas no EXCEL - enviado arquivo texto separado por ";" pois a Assessoria n∆o enviou padr∆o de layout
RAZ«O SOCIAL 	 
CNPJ 	 
DAT. DE VENCTO 	 
Nß DO T÷TULO 	
VALOR	
EMAIL
ENDEREÄO 	 
BAIRRO 	 
MUNICIPIO 	 
CEP 	 
TELEFONE 	 
UF 
***/
        CASE LENGTH(c-cgc):
            WHEN 14 THEN ASSIGN c-cgc = STRING(c-cgc, "99.999.999/9999-99").
            WHEN 15 THEN ASSIGN c-cgc = STRING(c-cgc, "999.999.999/9999-99").
            OTHERWISE    ASSIGN c-cgc = STRING(c-cgc, "999.999.999-99").
        END CASE.

        PUT c-nome-emit             FORMAT "!(50)"           ";"
            c-cgc             ";"
            SUBSTR(c-data,7,2)      FORMAT "99" "/" SUBSTR(c-data,5,2)      FORMAT "99" "/" SUBSTR(c-data,1,4)      FORMAT "9999"            ";"
            INT(c-numero)           FORMAT "999999999999"    ";"
            c-parcela                                        ";"
            de-vl-titulo                                     ";"
            c-email                                          ";"
            c-ender                 FORMAT "X(50)"           ";"
            c-bairro                FORMAT "X(20)"           ";"
            c-cid                   FORMAT "!(20)"           ";"
            c-cep                   FORMAT "99999999"        ";"
            c-fone                  FORMAT "X(11)"           ";"
            c-uf                    FORMAT "!(02)" SKIP.
                                                   
        /*****  Atualiza para os titulos para ENVIADO e armazena DATA DO ENVIO  *****/
        ASSIGN int_tit_acr.ind_sit_envio      = "Enviado"
               int_tit_acr.dat_envi_asses_cob = TODAY.
        
        /***** Cria TT de Titulos de Enviados  *****/
        CREATE tt_tit_acr_enviado.
        ASSIGN tt_tit_acr_enviado.cod_estab          = tit_acr.cod_estab
               tt_tit_acr_enviado.cod_espec_docto    = tit_acr.cod_espec_docto   
               tt_tit_acr_enviado.cod_ser_docto      = tit_acr.cod_ser_docto     
               tt_tit_acr_enviado.cod_tit_acr        = tit_acr.cod_tit_acr       
               tt_tit_acr_enviado.cod_parcela        = tit_acr.cod_parcela       
               tt_tit_acr_enviado.dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
               tt_tit_acr_enviado.dat_emis_docto     = tit_acr.dat_emis_docto    
               tt_tit_acr_enviado.cod_portador       = tit_acr.cod_portador      
               tt_tit_acr_enviado.cod_cart_bcia      = tit_acr.cod_cart_bcia     
               tt_tit_acr_enviado.cdn_cliente        = tit_acr.cdn_cliente       
               tt_tit_acr_enviado.nom_abrev          = emscad.cliente.nom_abrev        
               tt_tit_acr_enviado.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
               tt_tit_acr_enviado.val_origin_tit_acr = tit_acr.val_origin_tit_acr
               tt_tit_acr_enviado.val_desp_cartorio   = int_tit_acr.val_desp_cartorio.

    END.         /******* FOR EACH TITULO *********/
            
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.
            
    ASSIGN de-tot-car = 0
           de-tot-cli = 0.
              
    /***** "Gerando Arquivo de Titulos Enviados....".   *****/
    OUTPUT TO VALUE(p-arquivo2) PAGE-SIZE 0.
    ASSIGN i-contador = 0.
    FOR EACH tt_tit_acr_enviado NO-LOCK
        BREAK BY tt_tit_acr_enviado.cdn_cliente
              BY tt_tit_acr_enviado.dat_vencto_tit_acr:
        
        FIND FIRST emscad.cliente NO-LOCK
             WHERE emscad.cliente.cdn_cliente = tt_tit_acr_enviado.cdn_cliente NO-ERROR. 
        IF FIRST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(22)
               "Titulos Enviados Angeza - "
               TODAY FORMAT "99/99/9999" SKIP(2)
               "Esp Ser Titulo    /P  Emissao   Vencto Port /Car "
               "Codigo       Nome Abrev      Valo Cartorio   Valor Original" SKIP 
               "--- --- ------------ -------- -------- ----- --- "
               "-----------  --------------- --------------- ---------------" SKIP.
        END.

        ASSIGN de-tot-car = de-tot-car + tt_tit_acr_enviado.val_desp_cartorio
               de-tot-cli = de-tot-cli + tt_tit_acr_enviado.val_sdo_tit_acr.
                 
        PUT tt_tit_acr_enviado.cod_espec_docto    " "
            tt_tit_acr_enviado.cod_ser_docto      " "
            tt_tit_acr_enviado.cod_tit_acr  
            tt_tit_acr_enviado.cod_parcela        " "
            tt_tit_acr_enviado.dat_emis_docto     FORMAT "99/99/99" " "
            tt_tit_acr_enviado.dat_vencto_tit_acr FORMAT "99/99/99" " "
            tt_tit_acr_enviado.cod_portador       " " 
            tt_tit_acr_enviado.cod_cart_bcia      " "
            tt_tit_acr_enviado.cdn_cliente        "  "
            tt_tit_acr_enviado.nom_abrev          FORMAT "x(15)" " "
            tt_tit_acr_enviado.val_desp_cartorio  " "
            tt_tit_acr_enviado.val_sdo_tit_acr    SKIP.

        IF LAST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(38) "   Totais do Cliente"
               de-tot-car   "  "  
               de-tot-cli.
           IF LINE-COUNTER > 48 THEN 
              PAGE.
           ELSE 
              PUT SKIP(6).
              
           ASSIGN de-tot-car = 0 
                  de-tot-cli = 0.
        END.
    END. /****** FOR EACH tt_tit_acr_enviado ******/
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.

    FOR EACH tt_tit_acr_enviado:
        FIND tit_acr NO-LOCK
             WHERE tit_acr.cod_estab         = tt_tit_acr_enviado.cod_estab      
             AND   tit_acr.cod_espec_docto   = tt_tit_acr_enviado.cod_espec_docto
             AND   tit_acr.cod_ser_docto     = tt_tit_acr_enviado.cod_ser_docto  
             AND   tit_acr.cod_tit_acr       = tt_tit_acr_enviado.cod_tit_acr    
             AND   tit_acr.cod_parcela       = tt_tit_acr_enviado.cod_parcela    NO-ERROR.
        RUN piAlteraTitulo (INPUT  "9922",
                            INPUT  "90",
                            INPUT  "Angeza",
                            OUTPUT vRetorno).  
        
        IF vRetorno = "OK" THEN
           DELETE tt_tit_acr_enviado.
    END. /*  FOR EACH tt_tit_acr_enviado  */  
    FOR EACH  tt_int_tit_acr:
        DELETE tt_int_tit_acr.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dejuris C-Win 
PROCEDURE pi-cobrance PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-arquivo1 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo2 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo3 AS CHAR FORMAT "x(256)".

    DEF VAR de-vl-titulo AS DEC NO-UNDO.
    DEF VAR de-vl-cart AS DEC NO-UNDO.
      
    DEF VAR i-seqtemp AS INT NO-UNDO.

    FOR EACH tt_tit_acr_enviado:
        DELETE tt_tit_acr_enviado.
    END.

    /*   Message "Gerando Arquivo de Titulos ....".   */
    OUTPUT TO VALUE(p-arquivo1) PAGE-SIZE 0 CONVERT TARGET 'iso8859-1'.
    PUT "RAZ«O SOCIAL;CNPJ;DAT. DE VENCTO;Nß DO T÷TULO;PARCELA;VALOR;EMAIL;ENDEREÄO;BAIRRO;MUNICIPIO;CEP;TELEFONE;UF" SKIP.

    ASSIGN i-contador = 0.
    FOR EACH  tt_int_tit_acr,
        FIRST mgesp.int_tit_acr EXCLUSIVE-LOCK
        WHERE int_tit_acr.cod_estab      = tt_int_tit_acr.cod_estab 
        AND   int_tit_acr.num_id_tit_acr = tt_int_tit_acr.num_id_tit_acr
        AND   int_tit_acr.ind_sit_envio = "Selecionado",
        FIRST tit_acr NO-LOCK
              WHERE tit_acr.cod_estab = INT_tit_acr.cod_estab
              AND   tit_acr.num_id_tit_acr = int_tit_acr.num_id_tit_acr,
        FIRST emscad.cliente NO-LOCK
            WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente
        BREAK BY tit_acr.cdn_cliente:
        ASSIGN c-ender     = ""
               c-bairro    = ""
               c-cid       = ""
               c-uf        = ""
               c-cgc       = ""
               c-email     = ""
               c-ins-estad = ""
               c-ins-munic = ""
               c-cep       = "".
        IF emscad.cliente.num_pessoa MODULO 2 = 0 THEN DO:
            FIND pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_fisic THEN
                ASSIGN c-ender     = pessoa_fisic.nom_endereco 
                       c-bairro    = pessoa_fisic.nom_bairro
                       c-cid       = pessoa_fisic.nom_cidade
                       c-uf        = pessoa_fisic.cod_unid_federac
                       c-cep       = pessoa_fisic.cod_cep
                       c-cgc       = pessoa_fisic.cod_id_feder
                       c-email     = pessoa_fisic.cod_e_mail
                       c-ins-estad = ""
                       c-ins-munic = ""
                       c-fone      = pessoa_fisic.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","")
                       c-nome-emit = pessoa_fisic.nom_pessoa.
        END.
        ELSE DO:
            FIND pessoa_jurid NO-LOCK
                WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_jurid THEN DO:
                IF pessoa_jurid.nom_endereco      = pessoa_jurid.nom_ender_cobr 
                OR pessoa_jurid.nom_ender_cobr = "" THEN
                    ASSIGN c-ender     = pessoa_jurid.nom_endereco 
                           c-bairro    = pessoa_jurid.nom_bairro
                           c-cid       = pessoa_jurid.nom_cidade
                           c-uf        = pessoa_jurid.cod_unid_federac
                           c-cep       = pessoa_jurid.cod_cep
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail.
                ELSE 
                    ASSIGN c-ender     = pessoa_jurid.nom_ender_cobr
                           c-bairro    = pessoa_jurid.nom_bairro_cobr
                           c-cid       = pessoa_jurid.nom_cidad_cobr
                           c-uf        = pessoa_jurid.cod_unid_federac_cobr
                           c-cep       = pessoa_jurid.cod_cep_cobr
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail_cobr.
                 ASSIGN c-ins-estad = pessoa_jurid.cod_id_estad_jurid
                        c-ins-munic = pessoa_jurid.cod_id_munic_jurid
                        c-nome-emit = pessoa_jurid.nom_pessoa
                        c-fone      = pessoa_jurid.cod_telefone
                        c-fone      = REPLACE(c-fone,"-","")
                        c-fone      = REPLACE(c-fone,")","")
                        c-fone      = REPLACE(c-fone,"(","")
                        c-fone      = REPLACE(c-fone," ","").
            END.
        END.
        IF FIRST-OF(tit_acr.cdn_cliente) THEN DO:
            FIND LAST histor_clien NO-LOCK
               WHERE histor_clien.cod_empresa = emscad.cliente.cod_empresa
               AND   histor_clien.cdn_cliente = emscad.cliente.cdn_cliente NO-ERROR.
            IF NOT AVAIL histor_clien THEN DO:
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Cobrance"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Cobrance" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
            ELSE DO: 
                ASSIGN i-seqtemp = histor_clien.num_seq_histor_clien.
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = i-seqtemp + 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Cobrance"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Cobrance" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
        END.
            
        ASSIGN i-contador   = i-contador + 1
               c-numero     = STRING(tit_acr.cod_tit_acr) 
               c-parcela    = STRING(tit_acr.cod_parcela)
               c-data       = SUBSTR(STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_vencto_tit_acr), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_vencto_tit_acr),"99"),1,2)
               c-data-emis  = SUBSTR(STRING(YEAR(tit_acr.dat_emis_docto),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_emis_docto), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_emis_docto),"99"),1,2)
               c-esp        = "DP"
               de-vl-titulo = tit_acr.val_sdo_tit_acr
               de-vl-cart   = int_tit_acr.val_desp_cartorio.
               

        
        IF tit_acr.cod_espec_docto = "VD"
        THEN DO:            
             FIND FIRST b_tit_acr_VE NO-LOCK
                 WHERE b_tit_acr_VE.cod_estab       = tit_acr.cod_estab
                   AND b_tit_acr_VE.cod_espec_docto = "VE"
                   AND b_tit_acr_VE.cod_ser_docto   = tit_acr.cod_ser_docto
                   AND b_tit_acr_VE.cod_tit_acr     = tit_acr.cod_tit_acr
                   AND b_tit_acr_VE.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
             IF AVAIL b_tit_acr_VE 
                THEN ASSIGN c-data = SUBSTR(STRING(YEAR(b_tit_acr_VE.dat_vencto_tit_acr),"9999"),1,4) 
                                     + SUBSTR(STRING(MONTH(b_tit_acr_VE.dat_vencto_tit_acr), "99"),1,2)
                                     + SUBSTR(STRING(DAY(b_tit_acr_VE.dat_vencto_tit_acr),"99"),1,2).
        END.

/* ** Informaá‰es solicitadas no EXCEL - enviado arquivo texto separado por ";" pois a Assessoria n∆o enviou padr∆o de layout
RAZ«O SOCIAL 	 
CNPJ 	 
DAT. DE VENCTO 	 
Nß DO T÷TULO 	
VALOR	
EMAIL
ENDEREÄO 	 
BAIRRO 	 
MUNICIPIO 	 
CEP 	 
TELEFONE 	 
UF 
***/
        CASE LENGTH(c-cgc):
            WHEN 14 THEN ASSIGN c-cgc = STRING(c-cgc, "99.999.999/9999-99").
            WHEN 15 THEN ASSIGN c-cgc = STRING(c-cgc, "999.999.999/9999-99").
            OTHERWISE    ASSIGN c-cgc = STRING(c-cgc, "999.999.999-99").
        END CASE.

        PUT c-nome-emit             FORMAT "!(50)"           ";"
            c-cgc             ";"
            SUBSTR(c-data,7,2)      FORMAT "99" "/" SUBSTR(c-data,5,2)      FORMAT "99" "/" SUBSTR(c-data,1,4)      FORMAT "9999"            ";"
            INT(c-numero)           FORMAT "999999999999"    ";"
            c-parcela                                        ";"
            de-vl-titulo                                     ";"
            c-email                                          ";"
            c-ender                 FORMAT "X(50)"           ";"
            c-bairro                FORMAT "X(20)"           ";"
            c-cid                   FORMAT "!(20)"           ";"
            c-cep                   FORMAT "99999999"        ";"
            c-fone                  FORMAT "X(11)"           ";"
            c-uf                    FORMAT "!(02)" SKIP.
                                                   
        /*****  Atualiza para os titulos para ENVIADO e armazena DATA DO ENVIO  *****/
        ASSIGN int_tit_acr.ind_sit_envio      = "Enviado"
               int_tit_acr.dat_envi_asses_cob = TODAY.
        
        /***** Cria TT de Titulos de Enviados  *****/
        CREATE tt_tit_acr_enviado.
        ASSIGN tt_tit_acr_enviado.cod_estab          = tit_acr.cod_estab
               tt_tit_acr_enviado.cod_espec_docto    = tit_acr.cod_espec_docto   
               tt_tit_acr_enviado.cod_ser_docto      = tit_acr.cod_ser_docto     
               tt_tit_acr_enviado.cod_tit_acr        = tit_acr.cod_tit_acr       
               tt_tit_acr_enviado.cod_parcela        = tit_acr.cod_parcela       
               tt_tit_acr_enviado.dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
               tt_tit_acr_enviado.dat_emis_docto     = tit_acr.dat_emis_docto    
               tt_tit_acr_enviado.cod_portador       = tit_acr.cod_portador      
               tt_tit_acr_enviado.cod_cart_bcia      = tit_acr.cod_cart_bcia     
               tt_tit_acr_enviado.cdn_cliente        = tit_acr.cdn_cliente       
               tt_tit_acr_enviado.nom_abrev          = emscad.cliente.nom_abrev        
               tt_tit_acr_enviado.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
               tt_tit_acr_enviado.val_origin_tit_acr = tit_acr.val_origin_tit_acr
               tt_tit_acr_enviado.val_desp_cartorio   = int_tit_acr.val_desp_cartorio.

    END.         /******* FOR EACH TITULO *********/
            
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.
            
    ASSIGN de-tot-car = 0
           de-tot-cli = 0.
              
    /***** "Gerando Arquivo de Titulos Enviados....".   *****/
    OUTPUT TO VALUE(p-arquivo2) PAGE-SIZE 0.
    ASSIGN i-contador = 0.
    FOR EACH tt_tit_acr_enviado NO-LOCK
        BREAK BY tt_tit_acr_enviado.cdn_cliente
              BY tt_tit_acr_enviado.dat_vencto_tit_acr:
        
        FIND FIRST emscad.cliente NO-LOCK
             WHERE emscad.cliente.cdn_cliente = tt_tit_acr_enviado.cdn_cliente NO-ERROR. 
        IF FIRST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(22)
               "Titulos Enviados Cobrance - "
               TODAY FORMAT "99/99/9999" SKIP(2)
               "Esp Ser Titulo    /P  Emissao   Vencto Port /Car "
               "Codigo       Nome Abrev      Valo Cartorio   Valor Original" SKIP 
               "--- --- ------------ -------- -------- ----- --- "
               "-----------  --------------- --------------- ---------------" SKIP.
        END.

        ASSIGN de-tot-car = de-tot-car + tt_tit_acr_enviado.val_desp_cartorio
               de-tot-cli = de-tot-cli + tt_tit_acr_enviado.val_sdo_tit_acr.
                 
        PUT tt_tit_acr_enviado.cod_espec_docto    " "
            tt_tit_acr_enviado.cod_ser_docto      " "
            tt_tit_acr_enviado.cod_tit_acr  
            tt_tit_acr_enviado.cod_parcela        " "
            tt_tit_acr_enviado.dat_emis_docto     FORMAT "99/99/99" " "
            tt_tit_acr_enviado.dat_vencto_tit_acr FORMAT "99/99/99" " "
            tt_tit_acr_enviado.cod_portador       " " 
            tt_tit_acr_enviado.cod_cart_bcia      " "
            tt_tit_acr_enviado.cdn_cliente        "  "
            tt_tit_acr_enviado.nom_abrev          FORMAT "x(15)" " "
            tt_tit_acr_enviado.val_desp_cartorio  " "
            tt_tit_acr_enviado.val_sdo_tit_acr    SKIP.

        IF LAST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(38) "   Totais do Cliente"
               de-tot-car   "  "  
               de-tot-cli.
           IF LINE-COUNTER > 48 THEN 
              PAGE.
           ELSE 
              PUT SKIP(6).
              
           ASSIGN de-tot-car = 0 
                  de-tot-cli = 0.
        END.
    END. /****** FOR EACH tt_tit_acr_enviado ******/
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.

    FOR EACH tt_tit_acr_enviado:
        FIND tit_acr NO-LOCK
             WHERE tit_acr.cod_estab         = tt_tit_acr_enviado.cod_estab      
             AND   tit_acr.cod_espec_docto   = tt_tit_acr_enviado.cod_espec_docto
             AND   tit_acr.cod_ser_docto     = tt_tit_acr_enviado.cod_ser_docto  
             AND   tit_acr.cod_tit_acr       = tt_tit_acr_enviado.cod_tit_acr    
             AND   tit_acr.cod_parcela       = tt_tit_acr_enviado.cod_parcela    NO-ERROR.
        RUN piAlteraTitulo (INPUT  "9919",
                            INPUT  "90",
                            INPUT  "Cobrance",
                            OUTPUT vRetorno).  
        
        IF vRetorno = "OK" THEN
           DELETE tt_tit_acr_enviado.
    END. /*  FOR EACH tt_tit_acr_enviado  */  
    FOR EACH  tt_int_tit_acr:
        DELETE tt_int_tit_acr.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dejuris C-Win 
PROCEDURE pi-progress PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-arquivo1 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo2 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo3 AS CHAR FORMAT "x(256)".

    DEF VAR de-vl-titulo AS DEC NO-UNDO.
    DEF VAR de-vl-cart AS DEC NO-UNDO.
      
    DEF VAR i-seqtemp AS INT NO-UNDO.

    FOR EACH tt_tit_acr_enviado:
        DELETE tt_tit_acr_enviado.
    END.

    /*   Message "Gerando Arquivo de Titulos ....".   */
    OUTPUT TO VALUE(p-arquivo1) PAGE-SIZE 0 CONVERT TARGET 'iso8859-1'.
    PUT "RAZ«O SOCIAL;CNPJ;DAT. DE VENCTO;Nß DO T÷TULO;PARCELA;VALOR;EMAIL;ENDEREÄO;BAIRRO;MUNICIPIO;CEP;TELEFONE;UF" SKIP.

    ASSIGN i-contador = 0.
    FOR EACH  tt_int_tit_acr,
        FIRST mgesp.int_tit_acr EXCLUSIVE-LOCK
        WHERE int_tit_acr.cod_estab      = tt_int_tit_acr.cod_estab 
        AND   int_tit_acr.num_id_tit_acr = tt_int_tit_acr.num_id_tit_acr
        AND   int_tit_acr.ind_sit_envio = "Selecionado",
        FIRST tit_acr NO-LOCK
              WHERE tit_acr.cod_estab = INT_tit_acr.cod_estab
              AND   tit_acr.num_id_tit_acr = int_tit_acr.num_id_tit_acr,
        FIRST emscad.cliente NO-LOCK
            WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente
        BREAK BY tit_acr.cdn_cliente:
        ASSIGN c-ender     = ""
               c-bairro    = ""
               c-cid       = ""
               c-uf        = ""
               c-cgc       = ""
               c-email     = ""
               c-ins-estad = ""
               c-ins-munic = ""
               c-cep       = "".
        IF emscad.cliente.num_pessoa MODULO 2 = 0 THEN DO:
            FIND pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_fisic THEN
                ASSIGN c-ender     = pessoa_fisic.nom_endereco 
                       c-bairro    = pessoa_fisic.nom_bairro
                       c-cid       = pessoa_fisic.nom_cidade
                       c-uf        = pessoa_fisic.cod_unid_federac
                       c-cep       = pessoa_fisic.cod_cep
                       c-cgc       = pessoa_fisic.cod_id_feder
                       c-email     = pessoa_fisic.cod_e_mail
                       c-ins-estad = ""
                       c-ins-munic = ""
                       c-fone      = pessoa_fisic.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","")
                       c-nome-emit = pessoa_fisic.nom_pessoa.
        END.
        ELSE DO:
            FIND pessoa_jurid NO-LOCK
                WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_jurid THEN DO:
                IF pessoa_jurid.nom_endereco      = pessoa_jurid.nom_ender_cobr 
                OR pessoa_jurid.nom_ender_cobr = "" THEN
                    ASSIGN c-ender     = pessoa_jurid.nom_endereco 
                           c-bairro    = pessoa_jurid.nom_bairro
                           c-cid       = pessoa_jurid.nom_cidade
                           c-uf        = pessoa_jurid.cod_unid_federac
                           c-cep       = pessoa_jurid.cod_cep
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail.
                ELSE 
                    ASSIGN c-ender     = pessoa_jurid.nom_ender_cobr
                           c-bairro    = pessoa_jurid.nom_bairro_cobr
                           c-cid       = pessoa_jurid.nom_cidad_cobr
                           c-uf        = pessoa_jurid.cod_unid_federac_cobr
                           c-cep       = pessoa_jurid.cod_cep_cobr
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail_cobr.
                 ASSIGN c-ins-estad = pessoa_jurid.cod_id_estad_jurid
                        c-ins-munic = pessoa_jurid.cod_id_munic_jurid
                        c-nome-emit = pessoa_jurid.nom_pessoa
                        c-fone      = pessoa_jurid.cod_telefone
                        c-fone      = REPLACE(c-fone,"-","")
                        c-fone      = REPLACE(c-fone,")","")
                        c-fone      = REPLACE(c-fone,"(","")
                        c-fone      = REPLACE(c-fone," ","").
            END.
        END.
        IF FIRST-OF(tit_acr.cdn_cliente) THEN DO:
            FIND LAST histor_clien NO-LOCK
               WHERE histor_clien.cod_empresa = emscad.cliente.cod_empresa
               AND   histor_clien.cdn_cliente = emscad.cliente.cdn_cliente NO-ERROR.
            IF NOT AVAIL histor_clien THEN DO:
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Progress"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Progress" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
            ELSE DO: 
                ASSIGN i-seqtemp = histor_clien.num_seq_histor_clien.
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = i-seqtemp + 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Progress"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Progress" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
        END.
            
        ASSIGN i-contador   = i-contador + 1
               c-numero     = STRING(tit_acr.cod_tit_acr) 
               c-parcela    = STRING(tit_acr.cod_parcela)
               c-data       = SUBSTR(STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_vencto_tit_acr), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_vencto_tit_acr),"99"),1,2)
               c-data-emis  = SUBSTR(STRING(YEAR(tit_acr.dat_emis_docto),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_emis_docto), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_emis_docto),"99"),1,2)
               c-esp        = "DP"
               de-vl-titulo = tit_acr.val_sdo_tit_acr
               de-vl-cart   = int_tit_acr.val_desp_cartorio.
               

        
        IF tit_acr.cod_espec_docto = "VD"
        THEN DO:            
             FIND FIRST b_tit_acr_VE NO-LOCK
                 WHERE b_tit_acr_VE.cod_estab       = tit_acr.cod_estab
                   AND b_tit_acr_VE.cod_espec_docto = "VE"
                   AND b_tit_acr_VE.cod_ser_docto   = tit_acr.cod_ser_docto
                   AND b_tit_acr_VE.cod_tit_acr     = tit_acr.cod_tit_acr
                   AND b_tit_acr_VE.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
             IF AVAIL b_tit_acr_VE 
                THEN ASSIGN c-data = SUBSTR(STRING(YEAR(b_tit_acr_VE.dat_vencto_tit_acr),"9999"),1,4) 
                                     + SUBSTR(STRING(MONTH(b_tit_acr_VE.dat_vencto_tit_acr), "99"),1,2)
                                     + SUBSTR(STRING(DAY(b_tit_acr_VE.dat_vencto_tit_acr),"99"),1,2).
        END.

/* ** Informaá‰es solicitadas no EXCEL - enviado arquivo texto separado por ";" pois a Assessoria n∆o enviou padr∆o de layout
RAZ«O SOCIAL 	 
CNPJ 	 
DAT. DE VENCTO 	 
Nß DO T÷TULO 	
VALOR	
EMAIL
ENDEREÄO 	 
BAIRRO 	 
MUNICIPIO 	 
CEP 	 
TELEFONE 	 
UF 
***/
        CASE LENGTH(c-cgc):
            WHEN 14 THEN ASSIGN c-cgc = STRING(c-cgc, "99.999.999/9999-99").
            WHEN 15 THEN ASSIGN c-cgc = STRING(c-cgc, "999.999.999/9999-99").
            OTHERWISE    ASSIGN c-cgc = STRING(c-cgc, "999.999.999-99").
        END CASE.

        PUT c-nome-emit             FORMAT "!(50)"           ";"
            c-cgc             ";"
            SUBSTR(c-data,7,2)      FORMAT "99" "/" SUBSTR(c-data,5,2)      FORMAT "99" "/" SUBSTR(c-data,1,4)      FORMAT "9999"            ";"
            INT(c-numero)           FORMAT "999999999999"    ";"
            c-parcela                                        ";"
            de-vl-titulo                                     ";"
            c-email                                          ";"
            c-ender                 FORMAT "X(50)"           ";"
            c-bairro                FORMAT "X(20)"           ";"
            c-cid                   FORMAT "!(20)"           ";"
            c-cep                   FORMAT "99999999"        ";"
            c-fone                  FORMAT "X(11)"           ";"
            c-uf                    FORMAT "!(02)" SKIP.
                                                   
        /*****  Atualiza para os titulos para ENVIADO e armazena DATA DO ENVIO  *****/
        ASSIGN int_tit_acr.ind_sit_envio      = "Enviado"
               int_tit_acr.dat_envi_asses_cob = TODAY.
        
        /***** Cria TT de Titulos de Enviados  *****/
        CREATE tt_tit_acr_enviado.
        ASSIGN tt_tit_acr_enviado.cod_estab          = tit_acr.cod_estab
               tt_tit_acr_enviado.cod_espec_docto    = tit_acr.cod_espec_docto   
               tt_tit_acr_enviado.cod_ser_docto      = tit_acr.cod_ser_docto     
               tt_tit_acr_enviado.cod_tit_acr        = tit_acr.cod_tit_acr       
               tt_tit_acr_enviado.cod_parcela        = tit_acr.cod_parcela       
               tt_tit_acr_enviado.dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
               tt_tit_acr_enviado.dat_emis_docto     = tit_acr.dat_emis_docto    
               tt_tit_acr_enviado.cod_portador       = tit_acr.cod_portador      
               tt_tit_acr_enviado.cod_cart_bcia      = tit_acr.cod_cart_bcia     
               tt_tit_acr_enviado.cdn_cliente        = tit_acr.cdn_cliente       
               tt_tit_acr_enviado.nom_abrev          = emscad.cliente.nom_abrev        
               tt_tit_acr_enviado.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
               tt_tit_acr_enviado.val_origin_tit_acr = tit_acr.val_origin_tit_acr
               tt_tit_acr_enviado.val_desp_cartorio   = int_tit_acr.val_desp_cartorio.

    END.         /******* FOR EACH TITULO *********/
            
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.
            
    ASSIGN de-tot-car = 0
           de-tot-cli = 0.
              
    /***** "Gerando Arquivo de Titulos Enviados....".   *****/
    OUTPUT TO VALUE(p-arquivo2) PAGE-SIZE 0.
    ASSIGN i-contador = 0.
    FOR EACH tt_tit_acr_enviado NO-LOCK
        BREAK BY tt_tit_acr_enviado.cdn_cliente
              BY tt_tit_acr_enviado.dat_vencto_tit_acr:
        
        FIND FIRST emscad.cliente NO-LOCK
             WHERE emscad.cliente.cdn_cliente = tt_tit_acr_enviado.cdn_cliente NO-ERROR. 
        IF FIRST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(22)
               "Titulos Enviados Progress - "
               TODAY FORMAT "99/99/9999" SKIP(2)
               "Esp Ser Titulo    /P  Emissao   Vencto Port /Car "
               "Codigo       Nome Abrev      Valo Cartorio   Valor Original" SKIP 
               "--- --- ------------ -------- -------- ----- --- "
               "-----------  --------------- --------------- ---------------" SKIP.
        END.

        ASSIGN de-tot-car = de-tot-car + tt_tit_acr_enviado.val_desp_cartorio
               de-tot-cli = de-tot-cli + tt_tit_acr_enviado.val_sdo_tit_acr.
                 
        PUT tt_tit_acr_enviado.cod_espec_docto    " "
            tt_tit_acr_enviado.cod_ser_docto      " "
            tt_tit_acr_enviado.cod_tit_acr  
            tt_tit_acr_enviado.cod_parcela        " "
            tt_tit_acr_enviado.dat_emis_docto     FORMAT "99/99/99" " "
            tt_tit_acr_enviado.dat_vencto_tit_acr FORMAT "99/99/99" " "
            tt_tit_acr_enviado.cod_portador       " " 
            tt_tit_acr_enviado.cod_cart_bcia      " "
            tt_tit_acr_enviado.cdn_cliente        "  "
            tt_tit_acr_enviado.nom_abrev          FORMAT "x(15)" " "
            tt_tit_acr_enviado.val_desp_cartorio  " "
            tt_tit_acr_enviado.val_sdo_tit_acr    SKIP.

        IF LAST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(38) "   Totais do Cliente"
               de-tot-car   "  "  
               de-tot-cli.
           IF LINE-COUNTER > 48 THEN 
              PAGE.
           ELSE 
              PUT SKIP(6).
              
           ASSIGN de-tot-car = 0 
                  de-tot-cli = 0.
        END.
    END. /****** FOR EACH tt_tit_acr_enviado ******/
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.

    FOR EACH tt_tit_acr_enviado:
        FIND tit_acr NO-LOCK
             WHERE tit_acr.cod_estab         = tt_tit_acr_enviado.cod_estab      
             AND   tit_acr.cod_espec_docto   = tt_tit_acr_enviado.cod_espec_docto
             AND   tit_acr.cod_ser_docto     = tt_tit_acr_enviado.cod_ser_docto  
             AND   tit_acr.cod_tit_acr       = tt_tit_acr_enviado.cod_tit_acr    
             AND   tit_acr.cod_parcela       = tt_tit_acr_enviado.cod_parcela    NO-ERROR.
        RUN piAlteraTitulo (INPUT  "9958",
                            INPUT  "90",
                            INPUT  "Progress",
                            OUTPUT vRetorno).  
        
        IF vRetorno = "OK" THEN
           DELETE tt_tit_acr_enviado.
    END. /*  FOR EACH tt_tit_acr_enviado  */  
    FOR EACH  tt_int_tit_acr:
        DELETE tt_int_tit_acr.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dejuris C-Win 
PROCEDURE pi-payment PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-arquivo1 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo2 AS CHAR FORMAT "x(256)".
    DEF INPUT PARAM p-arquivo3 AS CHAR FORMAT "x(256)".

    DEF VAR de-vl-titulo AS DEC NO-UNDO.
    DEF VAR de-vl-cart AS DEC NO-UNDO.
    DEFINE VARIABLE c-ser AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-par AS CHARACTER   NO-UNDO.
      
    DEF VAR i-seqtemp AS INT NO-UNDO.

    FOR EACH tt_tit_acr_enviado:
        DELETE tt_tit_acr_enviado.
    END.

    /*   Message "Gerando Arquivo de Titulos ....".   */
    OUTPUT TO VALUE(p-arquivo1) PAGE-SIZE 0 CONVERT TARGET 'iso8859-1'.

    PUT "CNPJ;NOME;ENDEREÄO COMPLETO;TELEFONE;E-MAIL;T÷TULO;ESPECIE;SERIE;PARCELA;VENCIMENTO;VALOR" SKIP.

    ASSIGN i-contador = 0.
    FOR EACH  tt_int_tit_acr,
        FIRST mgesp.int_tit_acr EXCLUSIVE-LOCK
        WHERE int_tit_acr.cod_estab      = tt_int_tit_acr.cod_estab 
        AND   int_tit_acr.num_id_tit_acr = tt_int_tit_acr.num_id_tit_acr
        AND   int_tit_acr.ind_sit_envio = "Selecionado",
        FIRST tit_acr NO-LOCK
              WHERE tit_acr.cod_estab = INT_tit_acr.cod_estab
              AND   tit_acr.num_id_tit_acr = int_tit_acr.num_id_tit_acr,
        FIRST emscad.cliente NO-LOCK
            WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente
        BREAK BY tit_acr.cdn_cliente:
        ASSIGN c-ender     = ""
               c-bairro    = ""
               c-cid       = ""
               c-uf        = ""
               c-cgc       = ""
               c-email     = ""
               c-ins-estad = ""
               c-ins-munic = ""
               c-cep       = "".
        IF emscad.cliente.num_pessoa MODULO 2 = 0 THEN DO:
            FIND pessoa_fisic NO-LOCK
                WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_fisic THEN
                ASSIGN c-ender     = pessoa_fisic.nom_endereco 
                       c-bairro    = pessoa_fisic.nom_bairro
                       c-cid       = pessoa_fisic.nom_cidade
                       c-uf        = pessoa_fisic.cod_unid_federac
                       c-cep       = pessoa_fisic.cod_cep
                       c-cgc       = pessoa_fisic.cod_id_feder
                       c-email     = pessoa_fisic.cod_e_mail
                       c-ins-estad = ""
                       c-ins-munic = ""
                       c-fone      = pessoa_fisic.cod_telefone
                       c-fone      = REPLACE(c-fone,"-","")
                       c-fone      = REPLACE(c-fone,")","")
                       c-fone      = REPLACE(c-fone,"(","")
                       c-fone      = REPLACE(c-fone," ","")
                       c-nome-emit = pessoa_fisic.nom_pessoa.
        END.
        ELSE DO:
            FIND pessoa_jurid NO-LOCK
                WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
            IF AVAIL pessoa_jurid THEN DO:
                IF pessoa_jurid.nom_endereco      = pessoa_jurid.nom_ender_cobr 
                OR pessoa_jurid.nom_ender_cobr = "" THEN
                    ASSIGN c-ender     = pessoa_jurid.nom_endereco 
                           c-bairro    = pessoa_jurid.nom_bairro
                           c-cid       = pessoa_jurid.nom_cidade
                           c-uf        = pessoa_jurid.cod_unid_federac
                           c-cep       = pessoa_jurid.cod_cep
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail.
                ELSE 
                    ASSIGN c-ender     = pessoa_jurid.nom_ender_cobr
                           c-bairro    = pessoa_jurid.nom_bairro_cobr
                           c-cid       = pessoa_jurid.nom_cidad_cobr
                           c-uf        = pessoa_jurid.cod_unid_federac_cobr
                           c-cep       = pessoa_jurid.cod_cep_cobr
                           c-cgc       = pessoa_jurid.cod_id_feder
                           c-email     = pessoa_jurid.cod_e_mail_cobr.
                 ASSIGN c-ins-estad = pessoa_jurid.cod_id_estad_jurid
                        c-ins-munic = pessoa_jurid.cod_id_munic_jurid
                        c-nome-emit = pessoa_jurid.nom_pessoa
                        c-fone      = pessoa_jurid.cod_telefone
                        c-fone      = REPLACE(c-fone,"-","")
                        c-fone      = REPLACE(c-fone,")","")
                        c-fone      = REPLACE(c-fone,"(","")
                        c-fone      = REPLACE(c-fone," ","").
            END.
        END.
        IF FIRST-OF(tit_acr.cdn_cliente) THEN DO:
            FIND LAST histor_clien NO-LOCK
               WHERE histor_clien.cod_empresa = emscad.cliente.cod_empresa
               AND   histor_clien.cdn_cliente = emscad.cliente.cdn_cliente NO-ERROR.
            IF NOT AVAIL histor_clien THEN DO:
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Payment"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Payment" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
            ELSE DO: 
                ASSIGN i-seqtemp = histor_clien.num_seq_histor_clien.
                CREATE histor_clien.
                ASSIGN histor_clien.cod_empresa              = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente              = emscad.cliente.cdn_cliente
                       histor_clien.num_seq_histor_clien     = i-seqtemp + 1
                       histor_clien.des_abrev_histor_clien   = "Assessoria Payment"
                       histor_clien.des_histor_clien         = "Titulos enviados a Assessoria Payment" 
                                                                  + " em " 
                                                                  +  STRING(TODAY,"99/99/9999")
                                                                  + " Ös " 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),1,2) 
                                                                  + SUBSTRING(STRING(TIME,"HH:MM"),4,2). 
            END.
        END.
            
        ASSIGN i-contador   = i-contador + 1
               c-numero     = STRING(tit_acr.cod_tit_acr)
               c-par        = STRING(tit_acr.cod_parcela)
               c-ser        = STRING(tit_acr.cod_ser_docto)
               c-data       = SUBSTR(STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_vencto_tit_acr), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_vencto_tit_acr),"99"),1,2)
               c-data-emis  = SUBSTR(STRING(YEAR(tit_acr.dat_emis_docto),"9999"),1,4)
                            + SUBSTR(STRING(MONTH(tit_acr.dat_emis_docto), "99"),1,2)
                            + SUBSTR(STRING(DAY(tit_acr.dat_emis_docto),"99"),1,2)
               c-esp        = STRING(tit_acr.cod_espec_docto)
               de-vl-titulo = tit_acr.val_sdo_tit_acr
               de-vl-cart   = int_tit_acr.val_desp_cartorio.
               

        
        IF tit_acr.cod_espec_docto = "VD"
        THEN DO:            
             FIND FIRST b_tit_acr_VE NO-LOCK
                 WHERE b_tit_acr_VE.cod_estab       = tit_acr.cod_estab
                   AND b_tit_acr_VE.cod_espec_docto = "VE"
                   AND b_tit_acr_VE.cod_ser_docto   = tit_acr.cod_ser_docto
                   AND b_tit_acr_VE.cod_tit_acr     = tit_acr.cod_tit_acr
                   AND b_tit_acr_VE.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
             IF AVAIL b_tit_acr_VE 
                THEN ASSIGN c-data = SUBSTR(STRING(YEAR(b_tit_acr_VE.dat_vencto_tit_acr),"9999"),1,4) 
                                     + SUBSTR(STRING(MONTH(b_tit_acr_VE.dat_vencto_tit_acr), "99"),1,2)
                                     + SUBSTR(STRING(DAY(b_tit_acr_VE.dat_vencto_tit_acr),"99"),1,2).
        END.

/* ** Informaá‰es solicitadas no EXCEL - enviado arquivo texto separado por ";" pois a Assessoria n∆o enviou padr∆o de layout
CNPJ
NOME
ENDEREÄO COMPLETO
TELEFONE
E-MAIL
T÷TULO
ESPECIE
SERIE
PARCELA
VENCIMENTO
VALOR
***/

        CASE LENGTH(c-cgc):
            WHEN 14 THEN ASSIGN c-cgc = STRING(c-cgc, "99.999.999/9999-99").
            WHEN 15 THEN ASSIGN c-cgc = STRING(c-cgc, "999.999.999/9999-99").
            OTHERWISE    ASSIGN c-cgc = STRING(c-cgc, "999.999.999-99").
        END CASE.

        PUT UNFORMATTED 
            c-cgc                                   ";"
            c-nome-emit             FORMAT "!(50)"  ";"
            TRIM(STRING(c-ender,"!X(50)"))          " - "
            TRIM(STRING(c-bairro, "!X(20)"))        " - "
            TRIM(STRING(c-cid, "!(20)"))            " - "
            TRIM(STRING(c-uf, "!(02)"))             " - "
            TRIM(STRING(c-cep, "99999999"))         ";"
            c-fone                  FORMAT "X(11)"  ";"
            c-email                                 ";"
            INT(c-numero)           FORMAT "999999999999"    ";"
            c-esp                                            ";"
            c-ser                                            ";"
            c-par                                            ";"
            SUBSTR(c-data,7,2)      FORMAT "99" "/" SUBSTR(c-data,5,2)      FORMAT "99" "/" SUBSTR(c-data,1,4)      FORMAT "9999"            ";"
            STRING(de-vl-titulo, ">>>>,>>>,>>9.99")          SKIP.

        /*****  Atualiza para os titulos para ENVIADO e armazena DATA DO ENVIO  *****/
        ASSIGN int_tit_acr.ind_sit_envio      = "Enviado"
               int_tit_acr.dat_envi_asses_cob = TODAY.
        
        /***** Cria TT de Titulos de Enviados  *****/
        CREATE tt_tit_acr_enviado.
        ASSIGN tt_tit_acr_enviado.cod_estab          = tit_acr.cod_estab
               tt_tit_acr_enviado.cod_espec_docto    = tit_acr.cod_espec_docto   
               tt_tit_acr_enviado.cod_ser_docto      = tit_acr.cod_ser_docto     
               tt_tit_acr_enviado.cod_tit_acr        = tit_acr.cod_tit_acr       
               tt_tit_acr_enviado.cod_parcela        = tit_acr.cod_parcela       
               tt_tit_acr_enviado.dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr
               tt_tit_acr_enviado.dat_emis_docto     = tit_acr.dat_emis_docto    
               tt_tit_acr_enviado.cod_portador       = tit_acr.cod_portador      
               tt_tit_acr_enviado.cod_cart_bcia      = tit_acr.cod_cart_bcia     
               tt_tit_acr_enviado.cdn_cliente        = tit_acr.cdn_cliente       
               tt_tit_acr_enviado.nom_abrev          = emscad.cliente.nom_abrev        
               tt_tit_acr_enviado.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
               tt_tit_acr_enviado.val_origin_tit_acr = tit_acr.val_origin_tit_acr
               tt_tit_acr_enviado.val_desp_cartorio   = int_tit_acr.val_desp_cartorio.

    END.         /******* FOR EACH TITULO *********/
            
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.
            
    ASSIGN de-tot-car = 0
           de-tot-cli = 0.
              
    /***** "Gerando Arquivo de Titulos Enviados....".   *****/
    OUTPUT TO VALUE(p-arquivo2) PAGE-SIZE 0.
    ASSIGN i-contador = 0.
    FOR EACH tt_tit_acr_enviado NO-LOCK
        BREAK BY tt_tit_acr_enviado.cdn_cliente
              BY tt_tit_acr_enviado.dat_vencto_tit_acr:
        
        FIND FIRST emscad.cliente NO-LOCK
             WHERE emscad.cliente.cdn_cliente = tt_tit_acr_enviado.cdn_cliente NO-ERROR. 
        IF FIRST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(22)
               "Titulos Enviados Payment - "
               TODAY FORMAT "99/99/9999" SKIP(2)
               "Esp Ser Titulo    /P  Emissao   Vencto Port /Car "
               "Codigo       Nome Abrev      Valo Cartorio   Valor Original" SKIP 
               "--- --- ------------ -------- -------- ----- --- "
               "-----------  --------------- --------------- ---------------" SKIP.
        END.

        ASSIGN de-tot-car = de-tot-car + tt_tit_acr_enviado.val_desp_cartorio
               de-tot-cli = de-tot-cli + tt_tit_acr_enviado.val_sdo_tit_acr.
                 
        PUT tt_tit_acr_enviado.cod_espec_docto    " "
            tt_tit_acr_enviado.cod_ser_docto      " "
            tt_tit_acr_enviado.cod_tit_acr  
            tt_tit_acr_enviado.cod_parcela        " "
            tt_tit_acr_enviado.dat_emis_docto     FORMAT "99/99/99" " "
            tt_tit_acr_enviado.dat_vencto_tit_acr FORMAT "99/99/99" " "
            tt_tit_acr_enviado.cod_portador       " " 
            tt_tit_acr_enviado.cod_cart_bcia      " "
            tt_tit_acr_enviado.cdn_cliente        "  "
            tt_tit_acr_enviado.nom_abrev          FORMAT "x(15)" " "
            tt_tit_acr_enviado.val_desp_cartorio  " "
            tt_tit_acr_enviado.val_sdo_tit_acr    SKIP.

        IF LAST-OF(tt_tit_acr_enviado.cdn_cliente) THEN DO:
           PUT SPACE(38) "   Totais do Cliente"
               de-tot-car   "  "  
               de-tot-cli.
           IF LINE-COUNTER > 48 THEN 
              PAGE.
           ELSE 
              PUT SKIP(6).
              
           ASSIGN de-tot-car = 0 
                  de-tot-cli = 0.
        END.
    END. /****** FOR EACH tt_tit_acr_enviado ******/
    OUTPUT CLOSE.
    HIDE MESSAGE NO-PAUSE.

    FOR EACH tt_tit_acr_enviado:
        FIND tit_acr NO-LOCK
             WHERE tit_acr.cod_estab         = tt_tit_acr_enviado.cod_estab      
             AND   tit_acr.cod_espec_docto   = tt_tit_acr_enviado.cod_espec_docto
             AND   tit_acr.cod_ser_docto     = tt_tit_acr_enviado.cod_ser_docto  
             AND   tit_acr.cod_tit_acr       = tt_tit_acr_enviado.cod_tit_acr    
             AND   tit_acr.cod_parcela       = tt_tit_acr_enviado.cod_parcela    NO-ERROR.
        RUN piAlteraTitulo (INPUT  "9923",
                            INPUT  "90",
                            INPUT  "Payment",
                            OUTPUT vRetorno).  
        
        IF vRetorno = "OK" THEN
           DELETE tt_tit_acr_enviado.
    END. /*  FOR EACH tt_tit_acr_enviado  */  
    FOR EACH  tt_int_tit_acr:
        DELETE tt_int_tit_acr.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-next C-Win 
PROCEDURE pi-next :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

acha_tit:
REPEAT:
    FIND NEXT emscad.cliente NO-LOCK NO-ERROR.
    IF NOT AVAIL emscad.cliente THEN
        LEAVE.

    for each estabelecimento no-lock
        where estabelecimento.cod_estab >= c-estabini
          and estabelecimento.cod_estab <= c-estabfim:

        /* T°tulos transferidos para o 102 e 103 */
        IF estabelecimento.cod_estab = '201'
        OR estabelecimento.cod_estab = '301'
           THEN NEXT.
           
        IF can-find(FIRST tit_acr NO-LOCK
            WHERE tit_acr.cod_estab           = estabelecimento.cod_estab
            AND   tit_acr.cdn_cliente         = emscad.cliente.cdn_cliente
            AND   tit_acr.dat_vencto_tit_acr  >= d-orderedini 
            AND   tit_acr.dat_vencto_tit_acr  <= d-orderedfim 
            AND   tit_acr.dat_emis_docto      >= d-emissaoini 
            AND   tit_acr.dat_emis_docto      <= d-emissaofim 
            AND   tit_acr.cod_espec_docto     >= c-especieini 
            AND   tit_acr.cod_espec_docto     <= c-especiefim 
            AND   tit_acr.cod_portador        >= c-portadorini
            AND   tit_acr.cod_portador        <= c-portadorfim
            AND   tit_acr.cod_tit_acr         >= c-tituloini
            AND   tit_acr.cod_tit_acr         <= c-titulofim
            /*AND   tit_acr.log_sdo_tit_acr     = YES*/
            AND   tit_acr.val_sdo_tit_acr      > 0 USE-INDEX titacr_cliente) THEN
            LEAVE acha_tit.
    end.
    
END.

IF AVAIL emscad.cliente THEN DO:


    RUN pi-display.

    ENABLE btFirst
           btPrev
        WITH FRAME {&FRAME-NAME}.

    ASSIGN MENU-ITEM miFirst:SENSITIVE IN MENU smFile = TRUE
           MENU-ITEM miPrev:SENSITIVE IN MENU smFile = TRUE.

END.
ELSE DO:
    MESSAGE "Èltimo registro!" VIEW-AS ALERT-BOX ERROR.
    RUN pi-last.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-prev C-Win 
PROCEDURE pi-prev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

acha_tit:
REPEAT:
    FIND PREV emscad.cliente NO-LOCK NO-ERROR.
    
    IF NOT AVAIL emscad.cliente THEN DO:
        LEAVE.
    END.

    for each estabelecimento no-lock
        where estabelecimento.cod_estab >= c-estabini
          and estabelecimento.cod_estab <= c-estabfim:

        /* T°tulos transferidos para o 102 e 103 */
        IF estabelecimento.cod_estab = '201'
        OR estabelecimento.cod_estab = '301'
           THEN NEXT.
       
        IF can-find(FIRST tit_acr NO-LOCK
            WHERE tit_acr.cod_estab           = estabelecimento.cod_estab
            AND   tit_acr.cdn_cliente         = emscad.cliente.cdn_cliente
            AND   tit_acr.dat_vencto_tit_acr  >= d-orderedini 
            AND   tit_acr.dat_vencto_tit_acr  <= d-orderedfim 
            AND   tit_acr.dat_emis_docto      >= d-emissaoini 
            AND   tit_acr.dat_emis_docto      <= d-emissaofim 
            AND   tit_acr.cod_espec_docto     >= c-especieini 
            AND   tit_acr.cod_espec_docto     <= c-especiefim 
            AND   tit_acr.cod_portador        >= c-portadorini
            AND   tit_acr.cod_portador        <= c-portadorfim
            AND   tit_acr.cod_tit_acr         >= c-tituloini
            AND   tit_acr.cod_tit_acr         <= c-titulofim
            /*AND   tit_acr.log_sdo_tit_acr     = YES*/
            AND   tit_acr.val_sdo_tit_acr      > 0 USE-INDEX titacr_cliente) THEN
            LEAVE acha_tit.
            
    end.
            
END.

IF AVAIL emscad.cliente THEN DO:
    RUN pi-display.
    ENABLE btNext
           btLast
        WITH FRAME {&FRAME-NAME}.
    ASSIGN MENU-ITEM miNext:SENSITIVE IN MENU smFile = TRUE
           MENU-ITEM miLast:SENSITIVE IN MENU smFile = TRUE.
END.
ELSE DO:
    MESSAGE "Primeiro registro!" VIEW-AS ALERT-BOX ERROR.
    RUN pi-first.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-print C-Win 
PROCEDURE pi-print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hWindow AS HANDLE     NO-UNDO.
    ASSIGN hWindow = CURRENT-WINDOW.

    ASSIGN hWindow:SENSITIVE = NO.
    ASSIGN INPUT FRAME {&FRAME-NAME} rs-opcao.
    
    RUN esp\acr\esacr003a.w(INPUT TABLE tt_saldo,
                            INPUT TABLE tt_cliente,
                            INPUT rs-opcao ).

    ASSIGN hWindow:SENSITIVE = YES.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vendor C-Win 
PROCEDURE pi-vendor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH tt_saldo: 
      IF tt_saldo.cod_espec_docto = "VE"  OR 
         tt_saldo.cod_espec_docto = "VEM" THEN DO:  /*Parcela Vendor Migrados do Magnus*/
         /* Localiza parcela vendor gerada no fechamento - VE */
         FIND FIRST tit_acr NO-LOCK
              WHERE tit_acr.cod_estab       = tt_saldo.cod_estab
                AND tit_acr.cod_espec_docto = tt_saldo.cod_espec_docto
                AND tit_acr.cod_ser_docto   = tt_saldo.cod_ser_docto
                AND tit_acr.cod_tit_acr     = tt_saldo.cod_tit_acr
                AND tit_acr.cod_parcela     = tt_saldo.cod_parcela NO-ERROR.

         IF AVAIL tit_acr THEN DO:
             IF tit_acr.cod_espec_docto = "VE" THEN DO:
                 /* Localiza extensao da parcela que contem o valor do cliente(com juros) */
                 FIND FIRST parc_vendor NO-LOCK
                     WHERE parc_vendor.cod_estab_tit_acr = tt_saldo.cod_estab
                       AND parc_vendor.num_id_tit_acr    = tt_saldo.num_id_tit_acr NO-ERROR.
                 IF AVAIL parc_vendor THEN
                     ASSIGN tt_saldo.val_sdo_tit_acr     = parc_vendor.val_parc_vendor_clien
                            tt_saldo.val_origin_tit_acr  = parc_vendor.val_parc_vendor_orig
                            tt_saldo.num_planinha_vendor = parc_vendor.num_planilha_vendor.
    
                /* Localiza planilha vendor para buscar a nota fiscal de origem */
                FIND FIRST planilha_vendor NO-LOCK
                    WHERE planilha_vendor.cod_estab           = tit_acr.cod_estab
                      AND planilha_vendor.num_planilha_vendor = INT(tit_acr.cod_tit_acr) NO-ERROR.
    
                /* Localiza duplicata origem (DM, que tem o mesmo numero da nota fiscal) */
                FIND FIRST dupl_vendor NO-LOCK OF planilha_vendor NO-ERROR.
                IF AVAIL dupl_vendor THEN DO:
                    FIND FIRST tit_acr NO-LOCK
                        WHERE tit_acr.cod_estab       = dupl_vendor.cod_estab_tit_acr
                          AND tit_acr.num_id_tit_acr  = dupl_vendor.num_id_tit_acr NO-ERROR.
                     IF AVAIL tit_acr THEN
                         ASSIGN tt_saldo.cod_tit_acr = tit_acr.cod_tit_acr.
                 END.
                 ELSE
                     ASSIGN tt_saldo.cod_tit_acr = "".
             END.
             ELSE DO:
                
                 /* Vers∆o 1.00.00.004 - Mario Fleith Jr.*/
                ASSIGN tt_saldo.num_planinha_vendor = INT(tit_acr.cod_tit_acr)                  
                       tt_saldo.cod_tit_acr         = tit_acr.cod_tit_acr
                       tt_saldo.val_sdo_tit_acr     = tit_acr.val_sdo_tit_acr.
                FIND FIRST movto_tit_acr OF tit_acr NO-LOCK
                    WHERE movto_tit_acr.ind_trans_acr_abrev = 'IMPL' NO-ERROR.
                IF AVAIL movto_tit_acr THEN DO:
                   FIND FIRST histor_movto_tit_acr NO-LOCK
                      WHERE histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                      AND   histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                      AND   histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
                   IF AVAIL histor_movto_tit_acr THEN DO:
                      ASSIGN tt_saldo.val_sdo_tit_acr     = tit_acr.val_sdo_tit_acr
                             tt_saldo.val_origin_tit_acr  = DEC(entry(1,histor_movto_tit_acr.des_text_histor,';')). 
                   END.
                   ELSE
                      ASSIGN tt_saldo.val_origin_tit_acr  = 0.
                END.
                ELSE 
                   ASSIGN tt_saldo.val_origin_tit_acr = 0.

             END.
         END.
      END.
      
      IF tt_saldo.cod_espec_docto = "VD" THEN DO:
          FIND FIRST tit_acr NO-LOCK
               WHERE tit_acr.cod_estab       = tt_saldo.cod_estab
                 AND tit_acr.cod_espec_docto = tt_saldo.cod_espec_docto
                 AND tit_acr.cod_ser_docto   = tt_saldo.cod_ser_docto
                 AND tit_acr.cod_tit_acr     = tt_saldo.cod_tit_acr
                 AND tit_acr.cod_parcela     = tt_saldo.cod_parcela NO-ERROR.
          IF AVAIL tit_acr THEN
              ASSIGN tt_saldo.num_planinha_vendor = INT(tit_acr.cod_tit_acr).
      END.

      /** Rotina para Buscar DP-Original de Vendor Debitado **/
      FIND FIRST tit_acr NO-LOCK
          WHERE tit_acr.cod_estab          = tt_saldo.cod_estab
            AND tit_acr.cod_espec_docto    = "VD"
            AND tit_acr.cod_ser_docto      = tt_saldo.cod_ser_docto
            AND tit_acr.cod_tit_acr        = tt_saldo.cod_tit_acr
            AND tit_acr.cod_parcela        = tt_saldo.cod_parcela
            AND tt_saldo.cod_espec_docto  <> "AC" NO-ERROR.

      IF AVAIL tit_acr THEN DO:
         FIND FIRST b_tit_acr_VE NO-LOCK
             WHERE b_tit_acr_VE.cod_estab       = tit_acr.cod_estab
               AND b_tit_acr_VE.cod_espec_docto = "VE"
               AND b_tit_acr_VE.cod_ser_docto   = tit_acr.cod_ser_docto
               AND b_tit_acr_VE.cod_tit_acr     = tit_acr.cod_tit_acr
               AND b_tit_acr_VE.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
         IF AVAIL b_tit_acr_VE THEN DO:
             IF tit_acr.dat_vencto_tit_acr = tit_acr.dat_emis_docto THEN
                 ASSIGN tt_saldo.dat_vencto_tit_acr = b_tit_acr_VE.dat_vencto_tit_acr.

             /* Dias de atraso */
             ASSIGN tt_saldo.num_atr = TODAY - b_tit_acr_VE.dat_vencto_tit_acr.

             FIND FIRST relacto_tit_acr OF tit_acr NO-LOCK NO-ERROR.

             FIND FIRST parc_vendor NO-LOCK
                 WHERE parc_vendor.cod_estab_tit_acr = relacto_tit_acr.cod_estab
                   AND parc_vendor.num_id_tit_acr    = relacto_tit_acr.num_id_tit_acr_pai NO-ERROR.
                        
             FIND FIRST b_tit_acr_DM 
                 WHERE b_tit_acr_DM.cod_estab      = relacto_tit_acr.cod_estab
                 AND   b_tit_acr_DM.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr_pai NO-ERROR.
                ASSIGN tt_saldo.dat_vencto_tit_acr = b_tit_acr_DM.dat_vencto_tit_acr
                       tt_saldo.cod_tit_acr_bco    = b_tit_acr_DM.cod_tit_acr_bco.
             
             FIND FIRST planilha_vendor NO-LOCK
                 WHERE planilha_vendor.cod_estab           = b_tit_acr_VE.cod_estab
                   AND planilha_vendor.num_planilha_vendor = INT(b_tit_acr_VE.cod_tit_acr) NO-ERROR.
             IF AVAIL planilha_vendor THEN DO:
                 FIND FIRST dupl_vendor NO-LOCK OF planilha_vendor NO-ERROR.
                 IF AVAIL dupl_vendor THEN DO:
                     FIND FIRST b_tit_acr_DM NO-LOCK
                         WHERE b_tit_acr_DM.cod_estab      = dupl_vendor.cod_estab_tit_acr
                           AND b_tit_acr_DM.num_id_tit_acr = dupl_vendor.num_id_tit_acr NO-ERROR.
                     IF AVAIL b_tit_acr_DM THEN  
                         ASSIGN tt_saldo.cod_tit_acr        = b_tit_acr_DM.cod_tit_acr
                              /*  tt_saldo.val_sdo_tit_acr    = parc_vendor.val_parc_vendor_clien */
                                tt_saldo.val_origin_tit_acr = parc_vendor.val_parc_vendor_clien.   
                 END.
             END.
             
         END.
      END.

  END. /******* FOR EACH tt_saldo *********/    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom C-Win 
PROCEDURE pi-zoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Executar o programa de zoom de clientes e posicionar o registro neste programa com
   base na variavel global v_rec_cliente */
RUN prgint/utb/utb107ka.p.
IF v_rec_cliente <> ? THEN DO:
    FIND emscad.cliente NO-LOCK
        WHERE RECID(emscad.cliente) = v_rec_cliente NO-ERROR.
    IF AVAIL emscad.cliente THEN
        RUN pi-display.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE pi_rs-modo:

    IF int(rs-modo:screen-value IN FRAME default-frame) = 1 THEN DO:
        
         ASSIGN rs-opcao:visible                 = YES
                v_log_mostra_perda_dedut:VISIBLE = YES
                br_tt_saldo:visible              = YES
                v_tot_sel:visible              = YES
                RECT-2:visible                 = YES
                RECT-3:visible                 = YES
                rtParent-2:visible             = YES
                d-tot-orig:visible             = YES
                d-tot-cliente:visible          = YES
                d-credito:visible             = YES
                v_vcto_mes:visible       = YES
                v_sdo_vencido:visible          = YES
                v_sdo_avencer:visible          = YES
                /*emitente.ind-cre-cli:visible   = NO*/
                cb-credito-cli:VISIBLE         = NO
                b-emitente-matriz.lim-credito:visible   = NO
                b-emitente-matriz.dt-lim-cred:visible   = NO
                d-tot-matriz:VISIBLE           = NO
                d-tot-ped:VISIBLE              = NO
                /*de-lim-tot-supcard:VISIBLE     = NO
                de-lim-uti-supcard:VISIBLE     = NO
                de-lim-uti-intelbras:VISIBLE   = NO
                bt-det-supcard:VISIBLE         = NO
                de-lim-disp-cli:VISIBLE        = NO
                i-dias-atras-supcard:VISIBLE   = NO*/
                i-dias-atras-intelbras:VISIBLE = NO
                rt-divisao:VISIBLE             = NO
                br_ped:visible                 = NO
                br_cond_esp:visible            = NO
                br_antecip:visible             = NO
                bt-filtro:visible              = NO
                bt-aprova:visible              = NO
                bt-reprova:visible             = NO
                c-doc:visible                  = NO
                i-parc:visible                 = NO
                grp_clien.cod_grp_clien:VISIBLE = NO
                ped-venda.desc-bloq-cr:VISIBLE = NO
                ped-venda.observacoes:visible  = NO
                ped-venda.cond-espec:visible   = NO
                int-ped-venda.dt-negociacao:VISIBLE   = NO
                int-ped-venda.dias-negociacao:VISIBLE = NO
                RECT-4:VISIBLE                 = NO
                RECT-5:VISIBLE                 = NO
                RECT-6:VISIBLE                 = NO.
                
         DISABLE bt-mod WITH FRAME default-frame.

    END.
    ELSE DO:
         ASSIGN rs-opcao:visible                 = NO
                v_log_mostra_perda_dedut:VISIBLE = NO
                br_tt_saldo:visible              = NO
                v_tot_sel:visible              = NO
                RECT-2:visible                 = NO
                RECT-3:visible                 = NO
                rtParent-2:visible             = NO
                d-tot-orig:visible             = NO
                d-tot-cliente:visible          = NO
                d-credito :visible             = NO
                v_vcto_mes:visible       = NO
                v_sdo_vencido:visible          = NO
                v_sdo_avencer:visible          = NO
                /*emitente.ind-cre-cli:visible   = YES*/
                cb-credito-cli:VISIBLE         = YES
                b-emitente-matriz.lim-credito:visible   = YES
                b-emitente-matriz.dt-lim-cred:visible   = YES
                d-tot-matriz:VISIBLE           = YES
                d-tot-ped:VISIBLE              = YES
                /*de-lim-tot-supcard:VISIBLE     = YES
                de-lim-uti-supcard:VISIBLE     = YES
                de-lim-uti-intelbras:VISIBLE   = YES
                bt-det-supcard:VISIBLE         = YES
                de-lim-disp-cli:VISIBLE        = YES
                i-dias-atras-supcard:VISIBLE   = YES*/
                i-dias-atras-intelbras:VISIBLE = YES
                rt-divisao:VISIBLE             = YES
                br_ped:visible                 = YES
                br_cond_esp:visible            = YES
                br_antecip:visible             = YES
                bt-filtro:visible              = YES
                bt-aprova:visible              = YES
                bt-reprova:visible             = YES
                c-doc:visible                  = YES
                i-parc:visible                 = YES
                grp_clien.cod_grp_clien:VISIBLE = YES
                ped-venda.desc-bloq-cr:VISIBLE = YES
                ped-venda.observacoes:visible  = YES
                ped-venda.cond-espec:visible   = YES
                int-ped-venda.dt-negociacao:VISIBLE   = YES  
                int-ped-venda.dias-negociacao:VISIBLE = YES
                RECT-4:VISIBLE                 = no
                RECT-5:VISIBLE                 = no
                RECT-6:VISIBLE                 = no.
                
         /*zarpe*/

         ENABLE bt-mod ped-venda.observacoes ped-venda.cond-espec WITH FRAME default-frame.

         ASSIGN ped-venda.observacoes:READ-ONLY = YES
                ped-venda.cond-espec:READ-ONLY  = YES.

    END.

END.

PROCEDURE pi_mouse_select_click_br_ped:

    /************************* Variable Definition Begin ************************/
    DEF VAR i-cont AS INT.
    def var v_num_cont
        as integer
        format ">,>>9":U
        initial 0
        no-undo.
    def var v_log_method
        as logical
        format "Sim/N∆o"
        initial yes
        no-undo.
    /************************** Variable Definition End *************************/
    
    for each tt-cond-esp:
        delete tt-cond-esp.
    end.
    
    for each tt-antecip:
        delete tt-antecip.
    end.

    assign 
           i-dias-base    = 0
           
           
           i-parc = 0
           c-doc  = ""
           d-tot-ped = 0.
    
    FIND ped-venda NO-LOCK
        WHERE RECID(ped-venda) = ? NO-ERROR.
    FIND int-ped-venda NO-LOCK
        WHERE RECID(int-ped-venda) = ? NO-ERROR.

    IF BROWSE br_ped:NUM-SELECTED-ROWS  = 1 
    THEN DO:

         assign v_log_method = browse br_ped:fetch-selected-row(1).

         if can-find(first cond-ped 
                     where cond-ped.nr-pedido = ped-venda.nr-pedido) 
         then do:
              for each cond-ped no-lock 
                  where cond-ped.nr-pedido = ped-venda.nr-pedido:

                  if cond-ped.data-pagto   <> ? 
                  or cond-ped.nr-dias-venc <> 0 
                  then do:

                       create tt-cond-esp.
                       assign tt-cond-esp.seq           = cond-ped.nr-sequencia
                              tt-cond-esp.data-pagto    = cond-ped.data-pagto
                              tt-cond-esp.cod-vencto    = cond-ped.cod-vencto
                              tt-cond-esp.nr-dias-venc  = cond-ped.nr-dias-venc
                              tt-cond-esp.vl-pagto      = cond-ped.vl-pagto
                              tt-cond-esp.perc-pagto    = cond-ped.perc-pagto.
                  end.          
              end. 
         end.

/*          find cond-pagto                                                               */
/*               where cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag no-lock no-error. */
/*                                                                                        */
/*          /*if avail cond-pagto                                                         */
/*              THEN assign c-desc-cond-pagto = cond-pagto.descricao.                     */
/*          */                                                                            */
/*          run vep/ve2027.p (input rowid(ped-venda),                                     */
/*                            output i-cod-cond-cli,                                      */
/*                            output i-dias-base,                                         */
/*                            output da-base,                                             */
/*                            output de-tx-cli ).                                         */
/*                                                                                        */
/*          if i-cod-cond-cli > 0 then do:                                                */
/*             find cond-pagto where                                                      */
/*                  cond-pagto.cod-cond-pag = i-cod-cond-cli no-lock no-error.            */
/*             if avail cond-pagto then                                                   */
/*                assign c-desc-cond-pagto-vdr = cond-pagto.descricao.                    */
/*          end.                                                                          */

         find first ped-antecip NO-LOCK
              where ped-antecip.nr-pedido = ped-venda.nr-pedido no-error.
         if avail ped-antecip 
         then do:
              do i-cont = 1 to 6:
                 if ped-antecip.data-antecip[i-cont] = ? 
                    then next.
                 create tt-antecip.
                 assign tt-antecip.data   = ped-antecip.data-antecip[i-cont]
                        tt-antecip.valor  = ped-antecip.vl-antecip[i-cont].
              end.

              assign i-parc = ped-antecip.parcela
                     c-doc  = ped-antecip.nr-docto.
         end.   

         find first int-ped-venda
              where int-ped-venda.nr-pedido = ped-venda.nr-pedido no-lock no-error.

         RUN pi-converte-moeda (OUTPUT d-vl-aberto).
         assign d-tot-ped = d-tot-ped + d-vl-aberto.

    END.
    ELSE DO:

         do v_num_cont = 1 to browse br_ped:num-selected-rows:
            assign v_log_method = browse br_ped:fetch-selected-row(v_num_cont).
            RUN pi-converte-moeda (OUTPUT d-vl-aberto).
            assign d-tot-ped = d-tot-ped + d-vl-aberto.
         end.

        FIND ped-venda NO-LOCK
            WHERE RECID(ped-venda) = ? NO-ERROR.
        FIND int-ped-venda NO-LOCK
            WHERE RECID(int-ped-venda) = ? NO-ERROR.

    END.

    disp ped-venda.desc-bloq-cr WHEN AVAIL ped-venda
         ped-venda.observacoes  WHEN AVAIL ped-venda 
         ped-venda.cond-espec   WHEN AVAIL ped-venda
         int-ped-venda.dias-negociacao WHEN AVAIL int-ped-venda
         int-ped-venda.dt-negociacao   WHEN AVAIL int-ped-venda
         i-parc
         c-doc
         d-tot-ped
         with frame default-frame.

    IF NOT AVAIL ped-venda
       THEN ASSIGN ped-venda.desc-bloq-cr:SCREEN-VALUE IN FRAME default-frame = ""
                   ped-venda.observacoes:SCREEN-VALUE  IN FRAME default-frame = ""
                   ped-venda.cond-espec:SCREEN-VALUE   IN FRAME default-frame = "".
    IF NOT AVAIL int-ped-venda 
       THEN ASSIGN int-ped-venda.dias-negociacao:SCREEN-VALUE IN FRAME default-frame = ""  
                   int-ped-venda.dt-negociacao:SCREEN-VALUE  IN FRAME default-frame  = "". 

    IF  AVAIL ped-venda
    AND ped-venda.cod-sit-aval = 3 THEN
        ASSIGN ped-venda.desc-bloq-cr:SCREEN-VALUE IN FRAME default-frame = "". /* andrey */


    OPEN QUERY br_cond_esp FOR EACH tt-cond-esp NO-LOCK.
    OPEN QUERY br_antecip  FOR EACH tt-antecip  NO-LOCK.

END.

PROCEDURE pi_mouse_select_click:

    /************************* Variable Definition Begin ************************/
    def var v_num_cont
        as integer
        format ">,>>9":U
        initial 0
        no-undo.
    def var v_log_method
        as logical
        format "Sim/N∆o"
        initial yes
        no-undo.
    /************************** Variable Definition End *************************/
    
    assign v_tot_sel = 0.

    do v_num_cont = 1 to browse br_tt_saldo:num-selected-rows:
       assign v_log_method = browse br_tt_saldo:fetch-selected-row(v_num_cont).
       assign v_tot_sel = v_tot_sel + tt_saldo.val_sdo_tit_acr.
    end.

    display v_tot_sel
            with frame DEFAULT-FRAME.
END PROCEDURE.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAlteraTitulo C-Win 
PROCEDURE piAlteraTitulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pCodPortador  LIKE tit_acr.cod_portador  NO-UNDO.
    DEFINE INPUT  PARAM pCodCartBcia  LIKE tit_acr.cod_cart_bcia NO-UNDO.
    DEFINE INPUT  PARAM pAcessoria    AS   CHAR                  NO-UNDO.
    DEFINE OUTPUT PARAM pReturn       AS   CHAR                  NO-UNDO.

    DEFINE VARIABLE v_num_aux_2      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE v_num_cont       AS INTEGER    NO-UNDO.
    DEFINE VARIABLE v_num_aux        AS INTEGER    NO-UNDO.
    DEFINE VARIABLE v_cod_refer_impl AS CHARACTER  NO-UNDO.

    /*Calcula referencia automatica*/

    repeat:       

      ASSIGN v_num_aux_2 = integer(this-procedure:handle).
             v_cod_refer_impl = 'NOSSNR' + STRING(YEAR (TODAY), '9999')
                                         + STRING(MONTH(TODAY), '99')
                                         + STRING(DAY  (TODAY), '99').
      do v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               v_cod_refer_impl = v_cod_refer_impl + chr(v_num_aux).
      end.

      find first movto_tit_acr 
           where movto_tit_acr.cod_estab   = tit_acr.cod_estab
             and movto_tit_acr.cod_refer = v_cod_refer_impl no-lock no-error.
      if not avail movto_tit_acr then LEAVE.
    end.

    CREATE tt_alter_tit_acr_base_2.
    ASSIGN tt_alter_tit_acr_base_2.tta_cod_estab                   = tit_acr.cod_estab                     
           tt_alter_tit_acr_base_2.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr

           tt_alter_tit_acr_base_2.tta_dat_transacao               = TODAY /*tit_acr.dat_transacao*/
           tt_alter_tit_acr_base_2.tta_cod_refer                   = v_cod_refer_impl
           tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_imp = ?
           tt_alter_tit_acr_base_2.tta_val_sdo_tit_acr             = ? /*tit_acr.val_sdo_tit_acr*/
           tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_alt = ?
           tt_alter_tit_acr_base_2.ttv_ind_motiv_acerto_val        = ?
           tt_alter_tit_acr_base_2.tta_cod_portador                = ? /*tit_acr.cod_portador                   */
           tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = ? /*tit_acr.cod_cart_bcia                  */
           tt_alter_tit_acr_base_2.tta_val_despes_bcia             = ? /*tit_acr.val_despes_bcia                */
           tt_alter_tit_acr_base_2.tta_cod_agenc_cobr_bcia         = ? /*tit_acr.cod_agenc_cobr_bcia            */
           tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ? /*tit_acr.cod_tit_acr_bco                */
           tt_alter_tit_acr_base_2.tta_dat_emis_docto              = ? /*tit_acr.dat_emis_docto                 */
           tt_alter_tit_acr_base_2.tta_dat_vencto_tit_acr          = tit_acr.dat_vencto_tit_acr
           tt_alter_tit_acr_base_2.tta_dat_prev_liquidac           = tit_acr.dat_prev_liquidac 
           tt_alter_tit_acr_base_2.tta_dat_fluxo_tit_acr           = ? /*tit_acr.dat_fluxo_tit_acr              */
           tt_alter_tit_acr_base_2.tta_ind_sit_tit_acr             = ? /*tit_acr.ind_sit_tit_acr                */
           tt_alter_tit_acr_base_2.tta_cod_cond_cobr               = ? /*tit_acr.cod_cond_cobr                  */
           tt_alter_tit_acr_base_2.tta_log_tip_cr_perda_dedut_tit  = ? /*tit_acr.log_tip_cr_perda_dedut_tit     */
           tt_alter_tit_acr_base_2.tta_dat_abat_tit_acr            = ? /*tit_acr.dat_abat_tit_acr               */
           tt_alter_tit_acr_base_2.tta_val_perc_abat_acr           = ? /*tit_acr.val_perc_abat_acr              */
           tt_alter_tit_acr_base_2.tta_val_abat_tit_acr            = ? /*tit_acr.val_abat_tit_acr               */
           tt_alter_tit_acr_base_2.tta_dat_desconto                = ? /*tit_acr.dat_desconto                   */
           tt_alter_tit_acr_base_2.tta_val_perc_desc               = ? /*tit_acr.val_perc_desc                  */
           tt_alter_tit_acr_base_2.tta_val_desc_tit_acr            = ? /*tit_acr.val_desc_tit_acr               */
           tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_juros_acr   = ? /*tit_acr.qtd_dias_carenc_juros_acr      */
           tt_alter_tit_acr_base_2.tta_val_perc_juros_dia_atraso   = ? /*tit_acr.val_perc_juros_dia_atraso      */
           tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_multa_acr   = ? /*tit_acr.qtd_dias_carenc_multa_acr      */
           tt_alter_tit_acr_base_2.tta_val_perc_multa_atraso       = ? /*tit_acr.val_perc_multa_atraso          */
           tt_alter_tit_acr_base_2.ttv_cod_portador_mov            = ?                                        
           tt_alter_tit_acr_base_2.tta_ind_tip_cobr_acr            = ? /*tit_acr.ind_tip_cobr_acr               */
           tt_alter_tit_acr_base_2.tta_ind_ender_cobr              = ? /*tit_acr.ind_ender_cobr                 */
           tt_alter_tit_acr_base_2.tta_nom_abrev_contat            = ? /*tit_acr.nom_abrev_contat               */
           tt_alter_tit_acr_base_2.tta_val_liq_tit_acr             = ? /*tit_acr.val_liq_tit_acr                */
           tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_1_movto    = ?                                         
           tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_2_movto    = ?                                        
           tt_alter_tit_acr_base_2.tta_log_tit_acr_destndo         = ? /*tit_acr.log_tit_acr_destndo            */
           tt_alter_tit_acr_base_2.tta_cod_histor_padr             = ?                                        
           tt_alter_tit_acr_base_2.ttv_des_text_histor             = 
                        "Titulo enviado Assessoria " + trim(pAcessoria)  + " em " + STRING(TODAY,"99/99/9999")

           tt_alter_tit_acr_base_2.tta_des_obs_cobr                = ? /*tit_acr.des_obs_cobr                     */
           tt_alter_tit_acr_base_2.tta_num_seq_tit_acr             = ? /*tit_acr.num_seq_tit_acr*/               
           tt_alter_tit_acr_base_2.ttv_cod_estab_planilha          = ? /*tit_acr.cod_estab */
           tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ? 
           tt_alter_tit_acr_base_2.tta_cod_portador                = pCodPortador
           tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = pCodCartBcia
        .
    
    run prgfin/acr/acr711zo.py (Input 4,
                                Input  table tt_alter_tit_acr_base_2,
                                Input  table tt_alter_tit_acr_rateio,
                                Input  table tt_alter_tit_acr_ped_vda,
                                Input  table tt_alter_tit_acr_comis,
                                Input  table tt_alter_tit_acr_cheq,
                                Input  table tt_alter_tit_acr_iva,
                                Input  table tt_alter_tit_acr_impto_retid_2,
                                Input  table tt_alter_tit_acr_cobr_espec_2,
                                Input  table tt_alter_tit_acr_rat_desp_rec,
                                output table tt_log_erros_alter_tit_acr,
                                Input no).

    IF CAN-FIND(FIRST tt_log_erros_alter_tit_acr) THEN 
    DO:
        FOR FIRST  tt_log_erros_alter_tit_acr:
            MESSAGE 
                  "Estab: "              tt_log_erros_alter_tit_acr.tta_cod_estab                    SKIP
                  "Token Cta Receber: "  tt_log_erros_alter_tit_acr.tta_num_id_tit_acr               SKIP
                  "N£mero Mensagem: "    tt_log_erros_alter_tit_acr.ttv_num_mensagem                 SKIP
                  "Tipo Mensagem: "      tt_log_erros_alter_tit_acr.ttv_cod_tip_msg_dwb              SKIP
                  "Inconsistància: "     tt_log_erros_alter_tit_acr.ttv_des_msg_erro                 SKIP
                  "Mensagem Ajuda: "     tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda                SKIP
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        END.
    END.
    ELSE do:
        FOR EACH tt_alter_tit_acr_base_2: DELETE tt_alter_tit_acr_base_2. END.
        pReturn = "OK".
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-converte-moeda B-table-Win 
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

    /*
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
    */

    /*
    find first int-ped-venda
        where int-ped-venda.nr-pedido = ped-venda.nr-pedido no-lock no-error.
        
    if available int-ped-venda then
        assign de-valor-aberto = (ped-venda.vl-liq-abe + int-ped-venda.vl-frete) * de-fator-1 / de-fator-2.
    ELSE 
    */
        assign de-valor-aberto = ped-venda.vl-liq-abe * de-fator-1 / de-fator-2.
    
end.                          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE pi-permissao-usuario :

  def input param i-tipo-trans as int no-undo. /* 1. Aprovar 2. Reprovar */ 

  find emitente where
       emitente.nome-abrev = ped-venda.nome-abrev no-lock no-error.

  find first usu-gr-cli  /* Pesquisa por usu†rio e cliente */
       where usu-gr-cli.cod-usuario = v_cod_usuar_corren
         and usu-gr-cli.nome-abrev  = emitente.nome-abrev
         and usu-gr-cli.ind-funcao  = 1 /* CrÇdito */ no-lock no-error.
  if  not avail usu-gr-cli then
      find first usu-gr-cli  /* Pesquisa por usu†rio e grupo */
           where usu-gr-cli.cod-usuario = v_cod_usuar_corren
              and (usu-gr-cli.cod-gr-cli = emitente.cod-gr-cli
                   or usu-gr-cli.cod-gr-cli = 0)
             and usu-gr-cli.ind-funcao  = 1 /* CrÇdito */ no-lock no-error.

  if  not avail usu-gr-cli 
  then do:

       MESSAGE "Usu†rio " + v_cod_usuar_corren + " sem permiss∆o para " + trim(return-value) SKIP(2)
               "O usuario utilizado n∆o possui permiss∆o" SKIP 
               "para aprovar os pedidos desse cliente." VIEW-AS ALERT-BOX.
       RETURN "NOK".
  end.

  if  i-tipo-trans = 1 then
      apply 'entry' to bt-aprova in frame {&frame-name}.
  else
      apply 'entry' to bt-reprova in frame {&frame-name}.

  RETURN "OK".
  
END PROCEDURE.

PROCEDURE pi-aprova :
    if  l-ok = yes then do: 

        find current ped-venda EXCLUSIVE-LOCK NO-ERROR.
        if  ped-venda.cod-sit-ped > 2 then
            assign l-inval-sit = yes.
        else do:
            assign ped-venda.desc-forc-cr = c-pe-motivo-yes
                   ped-venda.dt-apr-cred  = pe-dt-apr-cred
                   ped-venda.cod-sit-aval = 3
                   ped-venda.quem-aprovou = pe-quem-aprovou.

            /* Atualizaá∆o de Cotas */
            IF AVAIL param-global AND
               param-global.modulo-08 THEN DO:

               IF  NOT VALID-HANDLE(h-bodi261) OR 
                   h-bodi261:TYPE      <> "PROCEDURE":U OR 
                   h-bodi261:FILE-NAME <> "dibo/bodi261.p":U THEN 
                   RUN dibo/bodi261.p PERSISTENT SET h-bodi261 NO-ERROR.

                IF ped-venda.cod-sit-com <> 1 THEN 
                   RUN setarLogAtualizacao IN h-bodi261.     
                RUN atualizarCotasPedido IN h-bodi261(INPUT ROWID(ped-venda),
                                                      INPUT 1, /*atualiza*/
                                                      INPUT TABLE tt-ped-item-cotas).

               IF VALID-HANDLE(h-bodi261) THEN DO:
                  DELETE PROCEDURE h-bodi261.
                  ASSIGN h-bodi261 = ?.
               END.    
            END.

            /* antigo cd4100*/
            IF  NOT VALID-HANDLE(h-bodi159cal) OR 
                h-bodi159cal:TYPE      <> "PROCEDURE":U OR 
                h-bodi159cal:FILE-NAME <> "dibo/bodi159cal.p":U THEN 
                RUN dibo/bodi159cal.p PERSISTENT SET h-bodi159cal.
            RUN setInvoicingAvaiable in h-bodi159cal(INPUT ROWID(ped-venda)).
            IF VALID-HANDLE(h-bodi159cal) THEN DO:
               DELETE PROCEDURE h-bodi159cal.
               ASSIGN h-bodi159cal = ?.
            END.    

        end.
        /**
        *** Integraá‰es: CRM
        **/
        RUN utp/ut-crm.p.  /* Verifica se possue integraá∆o com CRM */
        IF  RETURN-VALUE = "YES":U THEN
            RUN adapters/neogrid/pdp/anepd016.p (INPUT rowid(ped-venda),
                                                 INPUT "CHANGE":U).
        find current ped-venda NO-LOCK NO-ERROR.
    end.
END PROCEDURE.

PROCEDURE pi-reprova :
   
   if  l-ok = yes then do:           
       find current ped-venda EXCLUSIVE-LOCK NO-ERROR.
       if  ped-venda.cod-sit-ped = 3 then
           return.
       else 
           if  ped-venda.cod-sit-aval = 4 then
               return.
           else do:          
               assign ped-venda.desc-bloq-cr = c-pe-motivo-no
                      ped-venda.dt-apr-cred  = pe-dt-apr-cred
                      ped-venda.cod-sit-aval = 4 /* simula uma suspens∆o */
                      ped-venda.quem-aprovou = pe-quem-aprovou.

               /* Atualizaá∆o de Cotas */
               IF AVAIL param-global AND
                  param-global.modulo-08 THEN DO:

                  IF  NOT VALID-HANDLE(h-bodi261) OR 
                      h-bodi261:TYPE      <> "PROCEDURE":U OR 
                      h-bodi261:FILE-NAME <> "dibo/bodi261.p":U THEN 
                      RUN dibo/bodi261.p PERSISTENT SET h-bodi261 NO-ERROR.

                  IF ped-venda.cod-sit-com <> 1 THEN 
                     RUN setarLogAtualizacao IN h-bodi261.     
                  RUN atualizarCotasPedido IN h-bodi261(INPUT ROWID(ped-venda),
                                                        INPUT 1,
                                                        INPUT TABLE tt-ped-item-cotas). /* a bo verifica se est† 
                                                                                           reprov por crÇdito */
                  IF VALID-HANDLE(h-bodi261) THEN DO:
                     DELETE PROCEDURE h-bodi261.
                     ASSIGN h-bodi261 = ?.
                  END.    
               END.

               /* antigo cd4100*/
               IF  NOT VALID-HANDLE(h-bodi159cal) OR 
                   h-bodi159cal:TYPE      <> "PROCEDURE":U OR 
                   h-bodi159cal:FILE-NAME <> "dibo/bodi159cal.p":U THEN 
                   RUN dibo/bodi159cal.p PERSISTENT SET h-bodi159cal.
               RUN setInvoicingAvaiable in h-bodi159cal(INPUT ROWID(ped-venda)).
               IF VALID-HANDLE(h-bodi159cal) THEN DO:
                  DELETE PROCEDURE h-bodi159cal.
                  ASSIGN h-bodi159cal = ?.
               END.    

           end. 
           find current ped-venda NO-LOCK NO-ERROR.
           /**
           *** Integraá‰es: CRM
           **/
           RUN utp/ut-crm.p.  /* Verifica se possue integraá∆o com CRM */
           IF  RETURN-VALUE = "YES":U THEN
               RUN adapters/neogrid/pdp/anepd016.p (INPUT rowid(ped-venda),
                                                    INPUT "CHANGE":U).
   end.

END PROCEDURE.

PROCEDURE piFiltraRaizCnpj:

    DEFINE OUTPUT PARAM p-raiz-cnpj AS CHAR NO-UNDO.

    IF AVAIL emscad.cliente THEN
        ASSIGN p-raiz-cnpj = SUBSTRING(emscad.cliente.cod_id_feder,1,8).

END PROCEDURE.

PROCEDURE pi-grava-historico-credito:

    DEF INPUT PARAM p-nome-abrev    AS CHAR NO-UNDO.
    DEF INPUT PARAM p-nr-pedcli     AS CHAR NO-UNDO.
    DEF INPUT PARAM p-data          AS DATE NO-UNDO.
    DEF INPUT PARAM p-quem-aprovou  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-descricao     AS CHAR NO-UNDO.
    DEF INPUT PARAM p-sit-aval      AS INT  NO-UNDO.
    
    DEF VAR i-sequencia AS INTEGER NO-UNDO.
    DEF BUFFER b-hist FOR historico-credito.

    IF  ped-venda.desc-bloq-cr = p-descricao THEN 
        RETURN "OK" .

    ASSIGN i-sequencia = 1.

    FIND LAST historico-credito 
         WHERE historico-credito.nome-abrev = p-nome-abrev
           AND historico-credito.nr-pedcli  = p-nr-pedcli
        NO-LOCK NO-ERROR.
    

    IF AVAIL historico-credito THEN DO:
       IF  historico-credito.motivo = p-descricao THEN
           RETURN "OK".
       ASSIGN i-sequencia = historico-credito.nr-sequencia + 1. 
    END.
    DO TRANS:
    
        IF  ped-venda.desc-bloq-cr <> historico-credito.motivo THEN DO:
            CREATE historico-credito.
            ASSIGN historico-credito.nome-abrev    = p-nome-abrev
                   historico-credito.nr-pedcli     = p-nr-pedcli           
                   historico-credito.nr-sequencia  = i-sequencia            
                   historico-credito.dt-data-movto = ped-venda.dt-apr-cred   
                   historico-credito.usuar-movto   = ped-venda.quem-aprovou
                   historico-credito.motivo        = ped-venda.desc-bloq-cr 
                   historico-credito.tipo-movto    = "Bloq".
        END.
        FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
        IF  AVAIL ped-venda THEN DO:
            ASSIGN ped-venda.quem-aprovou = p-quem-aprovou
                   ped-venda.dt-apr-cred  = p-data
                   ped-venda.desc-bloq-cr = p-descricao.
            FIND CURRENT ped-venda NO-LOCK.
        END.

    END.
END.

PROCEDURE pi-valida-condicao-esacr070:

    DEF VAR i             AS INTEGER NO-UNDO.
    DEF VAR c-pedidos     AS CHAR FORMAT "x(100)" NO-UNDO.
    DEF VAR l-pedido-ok   AS LOG INIT YES NO-UNDO.
    
    do  i = 1 to br_ped:NUM-SELECTED-ROWS IN FRAME default-frame:
        if  br_ped:fetch-selected-row (i) IN FRAME default-frame  then
        do:
            RUN esp\acr\esacrapi001.p (INPUT  ped-venda.nome-abrev,
                                       INPUT  ped-venda.cod-cond-pag,
                                       INPUT  ped-venda.nat-operacao,
                                       OUTPUT l-pedido-ok).
            IF  NOT l-pedido-ok THEN
                ASSIGN c-pedidos = c-pedidos + " " + ped-venda.nr-pedcli + CHR(10).

        END.
    END.

    IF  c-pedidos <> "" THEN DO:
        RUN utp/ut-msgs.p (input "show", input 27100, input "Cond. de Pagto n∆o v†lida(s) conforme cadastro de exceá‰es e/ou n∆o parametrizada(s) para Canais ou B2B. Confirma?" + "~~" +
                           "Lista de pedidos: " + CHR(10) + c-pedidos).
        IF  RETURN-VALUE <> "YES" THEN 
            RETURN "NOK".
    END.

    RETURN "Ok".

END PROCEDURE.

/*
Pedido pd0802     : dibrw/B11DI159
Credito pd0806    : advwr/V32AD098  
Informaá‰es vendor: divwr/v46di159.w
Condiá∆o especial : dibrw/b04di018.w
Antecipaá‰es      : dibrw/b03di146.w
*/
