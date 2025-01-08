/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i LF0302RP 2.00.00.072 } /*** 010072 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i lf0302rp MLF}
&ENDIF

{include/i_fnctrad.i}
/*****************************************************************************/
{utp/ut-glob.i}

/*
SCOPED-DEFINE pagesize 42
*/

    DEF TEMP-TABLE tt-importa-movto-gko NO-UNDO
        FIELD cgc-intelbras     LIKE emitente.cgc
        FIELD cgc-transp        LIKE emitente.cgc
        FIELD cod-emitente      LIKE emitente.cod-emitente
        FIELD cod-estabel       LIKE estabelec.cod-estabel
        FIELD cod-nota            AS CHAR
        FIELD cod-serie           AS CHAR
        FIELD cod-ctrc            AS CHAR
        FIELD cod-fatura          AS CHAR
        FIELD cod-conta           AS CHAR
        FIELD cod-ccusto          AS CHAR
        FIELD des-conta           AS CHAR
        FIELD des-movto           AS CHAR
        FIELD val-credito         AS DEC
        FIELD val-debito          AS DEC
        FIELD dat-movto           AS DATE.


{lfp/lf0302rp.i new shared }

{btb/btb009za.i}

{cdp/cdcfgfin.i}

{include/i-getentryfield.i}

{include/i-epc200.i LF0302RP}
define variable d-sdo-final as decimal no-undo.
define variable c-ind-sdo-fim    as char    no-undo.
define variable v-log-existe-sdo as logical no-undo.
define variable d-val-cr as decimal no-undo.
define variable d-val-db as decimal no-undo.
define variable v-periodo-repeat-ini as integer no-undo.

def var v-count     as integer no-undo.
def var dt-aux      as date    no-undo.
def var dt-ini-aux  as date    no-undo.
def stream s-excel-1.
def stream s-excel-2.

define temp-table tt-raw-digita no-undo
    field raw-digita    as raw.

define input param raw-param as raw no-undo.
define input param table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def temp-table tt-RowErrors no-undo
   field ErrorSequence                   as integer        format    '>>>,>>9' 
   field ErrorNumber                     as integer        format    '>>>,>>9' 
   field ErrorDescription                as character      format    'x(50)'
   field ErrorParameters                 as character      format    'x(150)'
   field ErrorType                       as character      format    'x(50)'
   field ErrorHelp                       as character      format    'x(250)'
   field ErrorSubType                    as character      format    'x(50)'
   .

def temp-table tt_log_erro no-undo
   field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
   field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
   field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància".



def temp-table tt-cta-ctbl-nivel no-undo
    field ct-codigo as character format "x(20)" 
    field sc-codigo as character format "x(20)" 
    field num-nivel as inte format '>>>9'
    index i_cta_ctbl 
          ct-codigo desc 
          sc-codigo desc.

def new shared temp-table tt-dwf-estab no-undo 
    like dwf-estab
    field r-rowid as rowid
  index dwfestab-id as primary unique
        cod-estab
        dat-inic-valid
    .

def new shared temp-table tt-dwf-ender no-undo
    like dwf-ender
    field r-rowid as rowid
  index dwfender-01
    cod-cep
  index dwfender-id as primary unique 
    cdn-ender
    dat-inic-valid
    .

def var v_cod_estab_ini as CHAR format "x(3)":U NO-UNDO.
def var v_cod_estab_fim as CHAR format "x(3)":U NO-UNDO.
def var v_log_epc       as LOGICAL              NO-UNDO.

def new shared temp-table tt-dwf-pessoa no-undo
    like dwf-pessoa
    field r-rowid as rowid
  index dwfpss-id as primary unique
    cdn-pessoa
    dat-inic-valid
  index dwfpss-01
    cod-cnpj
    cod-cpf.

def new shared temp-table tt-dwf-plano-ccusto no-undo
    like dwf-plano-ccusto
    field r-rowid as rowid
  index dwfplncc-id as primary unique 
    cod-empresa
    cdn-empresa
    cod-plano-ccusto
    dat-inic-valid
  index dwfplncc-dat-fim
    dat-fim-valid
    .

define new shared temp-table tt-dwf-ccusto no-undo
    like dwf-ccusto
    field r-Rowid as rowid
  index dwfccst-dat-fim
    dat-fim-valid
  index dwfccst-id as primary unique 
    cod-empresa
    cdn-empresa
    cod-ccusto
    cod-unid-neg
    dat-inic-valid
    .

define new shared temp-table tt-dwf-item-lancto-ctbl no-undo
    like dwf-item-lancto-ctbl
    field r-Rowid as rowid
  index dwftmlnc-id as primary unique 
    cod-empresa
    cdn-empresa
    cod-modul-dtsul
    cod-lote-ctbl
    cod-lancto-ctbl
    num-seq-lancto-ctbl
    dat-inic-valid
  index dwftmlnc-dat-fim
    dat-fim-valid
  index dwftmlnc-dat-fim-emp
    cdn-empresa
    dat-fim-valid
    .

define new shared temp-table tt-dwf-lancto-ctbl no-undo
    like dwf-lancto-ctbl
    field r-Rowid as rowid
  index dwflnctc-id as primary unique
    cod-empresa
    cdn-empresa
    cod-modul-dtsul
    cod-lote-ctbl
    cod-lancto-ctbl
    dat-inic-valid
  index dwflnctc-dat-fim
    dat-fim-valid
  index dwflnctc-data
    cod-empresa
    cdn-empresa
    cod-modul-dtsul
    cod-lote-ctbl
    cod-lancto-ctbl
    dat-lancto-ctbl
    dat-fim-valid
  index dwflnctc-lancto
    cod-empresa
    cdn-empresa
    cod-modul-dtsul
    dat-lancto-ctbl
    .

define new shared temp-table tt-dwf-cta-ctbl no-undo
    like dwf-cta-ctbl
    field r-rowid as rowid
  index dwfctctb-id as primary unique 
    cod-empresa
    cdn-empresa
    cod-cta-ctbl
    dat-inic-valid
  index dwfctctb-dat-fim
    dat-fim-valid
  index dwfctctb-sup
    cod-empresa
    cdn-empresa
    cod-cta-ctbl-sup
    cod-cta-ctbl /* Para ordenaá∆o - Bloco J*/
  index tt_sup
    cod-cta-ctbl-sup        ascending
    ind-tip-cta-ctbl        ascending
  index tt-conta-sup-natur
    cod-cta-ctbl-sup        ascending
    num-natur-grp-cta-ctbl  ascending
  index tt-conta-tip
    ind-tip-cta-ctbl        ascending
  index cta-sup-tipo 
    cod-cta-ctbl-sup 
    ind-tip-cta-ctbl.

define new shared temp-table tt-dwf-sdo-ctbl no-undo
    like dwf-sdo-ctbl
    field r-Rowid as rowid
  index dwfsdctb-id as primary unique
    cod-modul-dtsul
    cod-empresa
    cdn-empresa
    cod-cta-ctbl
    cod-ccusto
    cod-unid-negoc
    num-period-ctbl
    num-exerc-ctbl
    cod-estab
    dat-inic-valid
  index dwfsdctb-dat-fim
    dat-fim-valid
  index dwfsdctb-exerc
    cod-empresa
    cdn-empresa
    cod-modul-dtsul
    num-exerc-ctbl
  index tt_periodo                      
      cod-empresa     asc
      num-period-ctbl asc
      num-exerc-ctbl  asc
  index tt_cta_ccusto
      cod-cta-ctbl    asc
      cod-ccusto      asc
  index tt-id2
      cod-empresa
      cod-modul-dtsul
      cdn-empresa
      cod-estab
      cod-cta-ctbl
      cod-unid-negoc
      num-period-ctbl
      num-exerc-ctbl
      ind-espec-cta-ctbl
    .  

define new shared temp-table tt-dwf-sdo-ctbl-antes-encert no-undo
    like dwf-sdo-ctbl-antes-encert
    field r-Rowid as rowid
  index dwfsdcta-id as primary unique 
    cod-empresa
    cod-estab
    cod-modul-dtsul
    dat-apurac-restdo
    cod-cta-ctbl
    cod-ccusto
    cod-unid-neg
    dat-inic-valid
    .

define new shared temp-table tt-dwf-estab-extens no-undo
    like dwf-estab-extens
    field r-Rowid as rowid
  index dwfstbxt-dat-fim
        dat-fim-valid
  index dwfstbxt-id as primary unique
        cod-estab
        dat-inic-valid
    .

define new shared temp-table tt-dwf-cta-ctbl-refer no-undo
    like dwf-cta-ctbl-refer
    field r-rowid as rowid
  index dwfctcta-id as primary unique
    cod-empresa
    cod-cta-ctbl
    cod-ccusto
    cod-unid-neg
    dat-inic-period
    dat-fim-period
    dat-inic-valid
  index dwfctcta-prod
    cod-empresa
    cod-produto
    .


define new shared temp-table tt-dwf-cta-aglut no-undo
    like dwf-cta-aglut
    field r-rowid as rowid
  index dwfctglt-id as primary unique 
    cod-empresa
    cod-cta-ctbl
    cod-cta-ctbl-aglut
    cod-ccusto
    cod-unid-negoc
    dat-inic-valid
  index dwfctglt-niv
    cod-empresa
    cod-cta-ctbl
    cod-cta-ctbl-aglut
    cod-ccusto
    num-niv-cta-ctbl
  index nivel 
    cod-empresa  
    cod-cta-ctbl
    num-niv-cta-ctbl desc.

define new shared temp-table tt-dwf-demonst-ctbl-bloco no-undo
    like dwf-demonst-ctbl-bloco
    field r-Rowid as rowid
  index dwfdmnsb-id as primary unique 
    cod-empresa
    dat-inic-demonst-ctbl
    dat-inic-valid
    .

define new shared temp-table tt-dwf-balan-patrim no-undo
    like dwf-balan-patrim
    field r-Rowid as rowid
  index dwfblnpt-id as primary unique 
    cod-empresa
    dat-inic-demonst-ctbl
    cod-cta-ctbl-aglut
    dat-inic-valid
    .

define new shared temp-table tt-dwf-participan no-undo
    like dwf-participan
    field r-Rowid as rowid
  index dwfprtcp-id as primary unique 
    cod-empresa
    cod-estab
    cod-participan
    dat-inic-valid
  index dwfprtcp-bac
    cod-empresa
    cod-estab
    cod-participan
    num-bacen
  index dwfprtcp-data
    dat-inic-period
    dat-fim-period
    .

define new shared temp-table tt-dwf-demonst-restdo-exerc no-undo
    like dwf-demonst-restdo-exerc
    field r-Rowid as rowid
  index dwfdmnsc-id as primary unique
        cod-empresa           asc
        dat-inic-demonst-ctbl asc
        cod-cta-ctbl-aglut    asc
        num-seq-indic-sit-sdo asc
        dat-inic-valid        asc
    
    .

define temp-table tt-recid-advertencias-sped-ap no-undo
    FIELD recid-ap                     AS RECID
    INDEX tt-recid
          recid-ap                     ASCENDING.

define new shared temp-table tt-log-advertencias-sped no-undo
    field num-seq                      as integer
    field num-cod-erro                 as integer
    field des-erro                     as character
    field des-ajuda                    as character
    field log-erro-tela                as logical 
    index tt-erro                         
          num-cod-erro                 ascending
    index tt-id                           
          num-seq                      ascending
          num-cod-erro                 ascending
    .

/* Utilizada para chamada das apis, que limpam o conte£do da tt de erros*/
define temp-table tt-log-erros-sped-aux no-undo
    like tt-log-erros-sped.
    .

/* Utilizada para chamada das apis, que limpam o conte£do da tt de erros*/
define temp-table tt-log-advertencias-sped-aux no-undo
    like tt-log-advertencias-sped.
    .

def new shared temp-table tt_data_apuracao no-undo
    field ttv_dat_apurac_restdo            as date format "99/99/9999"
    index tt_data                          is primary unique
          ttv_dat_apurac_restdo            ascending
    .
define temp-table tt-dwf-estab-aux  no-undo like tt-dwf-estab.
define temp-table tt-dwf-pessoa-aux no-undo like tt-dwf-pessoa.
define temp-table tt-dwf-ender-aux  no-undo like tt-dwf-ender. 

define temp-table tt-linhas-demonstrativo no-undo
    field i-demonst   as int
    field i-seq         as int
    field c-tipo        as char
    field c-titulo      as char
    field de-valor      as decimal format "(>>>>>>>>,>>9.99)":U
    field i-nivel       as int
    field c-conta       as char
    field de-valor-ini as decimal format "(>>>>>>>>,>>9.99)":U
    index tt-id as primary
    i-seq   asc
    c-tipo asc
    .

define temp-table tt-lancto-calc-saldo no-undo
    field dat-lancto as date
    field val-lancto as decimal
    field ind-natur  as char
    index tt-dt-natur
          dat-lancto asc
          ind-natur  asc.

def temp-table tt-xml-input-output no-undo
    field ttv_cod_label                     as character format "x(8)"  label "Label" column-label "Label"
    field ttv_des_conteudo                  as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_des_conteudo_aux              as character format "x(40)"
    field ttv_num_seq_1                     as integer   format ">>>,>>9"
    index tt_id
          ttv_cod_label    ascending
          ttv_des_conteudo ascending
          ttv_num_seq_1    ascending
    index tt_2
          ttv_cod_label    ascending.

def temp-table tt-log-erros-integracao no-undo
    field ttv_num_seq                       as integer   format ">>>,>>9" label "Sequància" column-label "Seq"
    field ttv_num_cod_erro                  as integer   format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                      as character format "x(80)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_ajuda                     as character format "x(100)" label "Ajuda" column-label "Ajuda".    

def temp-table tt-traducao-ems2-ems5 no-undo
    field ep-codigo              like diario-ap.ep-codigo
    field cod-estabel            like diario-ap.cod-estabel
    field cod-moeda                as integer
    field ct-codigo                like diario-ap.ct-conta
    field sc-codigo                like diario-ap.sc-conta
    field ttv_cod_cta_ctbl_contra  as character format "x(20)" label "Contra Partida" column-label "Contra Partida"
    field tta_cod_empresa          as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab            as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_finalid_econ     as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_plano_cta_ctbl   as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl         as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_unid_negoc       as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto     as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto           as character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_cta_ctbl_cp         as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_unid_negoc_cp       as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto_cp     as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto_cp           as character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    index tt_1
          ep-codigo   ascending
          cod-estabel ascending
          cod-moeda   ascending
          ct-codigo   ascending
          sc-codigo   ascending

    .

def temp-table tt_movimentos_ems5 no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field ttv_dat_trans_diario             as date format "99/99/9999" label "Movimentos do Dia"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_val_movto                    as decimal format "->,>>>,>>>,>>9.99" decimals 2 label "Movimento" column-label "Valor Movto"
    field tta_ind_natur_lancto_ctbl        as character format "X(02)" initial "DB" label "Natureza" column-label "Natureza"
    field ttv_des_historico                as character format "x(150)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_cod_docto_movto_cta_bco      as character format "x(20)" label "Documento Banco" column-label "Documento Banco"
    field tta_num_id_aprop_lancto_ctbl     as integer format "999999999" initial 0 label "Apropriacao Lanáto" column-label "Apropriacao Lanáto"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field ttv_num_ascii                    as integer format ">>>>,>>9"
    field ttv_cod_arq_ems2                 as character format "x(16)"
    field ttv_cod_lancto_ctbl              as character format "x(20)"
    field ttv_cdn_clien_fornec             as Integer format ">>>,>>9" initial 0 column-label "Codigo Cli~\Fornc"
    field ttv_cb1_calc_dat_term_carenc     as Integer format ">>>>>>>9"
    field ttv_cod_cta_ctbl_contra          as character format "x(20)" label "Contra Partida" column-label "Contra Partida"
    field ttv_cod_num_pessoa               as character format "x(8)"
    field ttv_num_bacen                    as integer format ">>>>,>>9"
    field ttv_cod_modul                    as character format "x(3)" column-label "M¢dulo"
    index tt_estab
          tta_cod_estab                    ascending
    index tt_cta
          tta_cod_cta_ctbl                 ascending    
    .

/*def temp-table tt-rel-conta no-undo like rel-conta. unificaÁ„o*/

/* Essa tt Ç utilizada para armazenar os diferentes c¢digos de empresa
   que podem fazer parte da extraá∆o, para que seja poss°vel fazer a 
   seleá∆o dos dados ja extra°dos anteriormente e exclu°-los antes de 
   salvar os novos dados.
   Os c¢digos de empresa podem ser diferentes dos c¢digos informados pelo
   usuario quando os dados est∆o no m¢dulo de um produto e a contabilidade 
   esta em outro produto. Neste caso, os dados ser∆o salvos com a empresa 
   configurada na matriz de traduá∆o dos dois produtos.
   Para n∆o ficar verificando se devemos ou n∆o utilizar a matriz, toda vez
   que os lancamentos (tt-dwf-item-lancto-ctbl) forem extra°dos, as empresas
   utilizadas para estes registros ser∆o salvas nesta tt, para posterior 
   leitura na pi-exclui-dados-extraidos */
define new shared temp-table tt-empresas-utilizadas no-undo
    field cod-empresa as char
    field cdn-empresa like mgcad.empresa.ep-codigo
    .

define temp-table tt-empresa-datasul-10 no-undo
    field cdn-empresa like mgcad.empresa.ep-codigo
    .

def new shared temp-table tt_period no-undo
    field ttv_num_mes                      as int
    field ttv_num_ano                      as int
    field ttv_dat_inic_param               as date format "99/99/9999"
    field ttv_dat_fim_param                as date format "99/99/9999"
    field ttv_dat_inic_mes                 as date format "99/99/9999"
    field ttv_dat_fim_mes                  as date format "99/99/9999"
    index tt_mes_ano
    ttv_num_ano
    ttv_num_mes
    .
    

/* TT para sumarizar a extraáao e salvar os totais no hist¢rico */
define temp-table tt-totalizador-historico no-undo
    field c-empresa as char
    field c-modulo  as char
    field i-ano     as int
    field i-periodo as int
    field dt-ini    as date
    field dt-fim    as date
    field d-tot-db  as decimal
    field d-tot-cr  as decimal
    index tt-id
          c-empresa  asc
          c-modulo   asc
          i-ano      asc
          i-periodo  asc
          .

/* Temp-table utilizada para facilitar a consulta dos dados com todos os c¢digos relacionados Ö um m¢dulo */
define new shared temp-table tt-modulo no-undo
    field i-id as int
    field c-modulo as char
    field c-modulo-refer as char
    field l-selecionado as logical
    index tt-id as primary unique
        i-id
        c-modulo
    index tt-mod
        c-modulo
    index tt-selec
        l-selecionado
    .

define new shared temp-table tt-relacto-particip-pessoa no-undo
    field cod-empresa as char
    field cod-estab   as char
    field cod-relacto as char
    field ind-tip-pessoa as char
    field num-pessoa  as integer
    field dat-inic-valid as date
    field dat-fim-valid  as date
    index tt-search1
        cod-empresa
        num-pessoa
    .

/* Tabela de Movimentos do SPED */
define NEW shared temp-table tt-movimentos-SPED-ems2 NO-UNDO
    FIELD ep-codigo                       LIKE mgcad.empresa.ep-codigo
    FIELD cod-estabel                     LIKE estabelec.cod-estabel
    FIELD ano-periodo                     AS CHAR
    FIELD conta-contabil                  AS CHAR FORMAT "x(17)" LABEL "Conta Cont†bil" /*n∆o Ç utilizado*/
    FIELD ct-codigo                       AS CHAR FORMAT "x(20)"
    FIELD sc-codigo                       AS CHAR FORMAT "x(20)" LABEL "Subconta"
    Field cod-unid-negoc                  as character format "x(3)" label "Unid Neg¢cio" 
    FIELD data                            AS DATE FORMAT "99/99/9999" LABEL "Data Transaá∆o"
    FIELD valor                           AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Vl CrÇdito"
    FIELD transacao                       AS INT
    FIELD historico                       AS CHARACTER FORMAT "x(150)" LABEL "Hist¢rico" COLUMN-LABEL "Hist¢rico"
    FIELD num-arquivamento                AS CHAR FORMAT "x(16)" LABEL "Documento"
    FIELD cod-emitente                    AS INT FORMAT "999999999"
    FIELD contra-partida                  AS CHAR FORMAT "x(20)" LABEL "Conta Cont†bil"
    FIELD cod-lancto-contab               AS CHARACTER FORMAT "x(50)"
    FIELD num-bacen                       AS CHAR FORMAT "x(05)" LABEL "BACEN"
    FIELD COD-MODUL                       AS CHAR FORMAT "X(03)"
    INDEX tt-conta
          conta-contabil                   ASCENDING
    INDEX tt-2
          ep-codigo                        ASCENDING
          cod-estabel                      ASCENDING
          conta-contabil                   ASCENDING
    index tt_id                            is primary
         ep-codigo                       ascending
         cod-estabel                     ascending
         COD-MODUL                       ascending
         cod-lancto-contab               ascending    .


define variable i-demonst-balanco  as int     no-undo.
define variable i-demonst-restdo   as int     no-undo.
def var i-var as int extent 9 no-undo.
def var c-arquivo-excel-1 as char no-undo.
def var c-arquivo-excel-2 as char no-undo.
def var c-time  as char   format "x(08)" no-undo.
def var i-time  as int    no-undo.
def var h-hex64 as handle no-undo.
DEF VAR v-log-origin-ap AS LOGICAL NO-UNDO.
def var l-diario-auxiliar-ems2 as logical no-undo initial no.
def var l-diario-auxiliar-ems5 as logical no-undo initial no.

function convert-hex-to-base64 returns character (input c-rowid as char) in h-hex64.

/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}

/* definiá∆o de vari†veis  */
define variable h-acomp             as handle  no-undo.

define variable h-ems5     as handle no-undo.
define variable c-message  as char   no-undo.
define variable c-origem   as char   no-undo.
define variable c-contabilidade  as char no-undo.
define variable c-tipo-balancete as char no-undo.
define variable c-literal1 as char   no-undo.
define variable c-literal2 as char   no-undo.
define variable h-btb009za          as handle  no-undo.
define variable l-ems5-nova-conexao as logical no-undo initial no.
define variable c-modulos-ems5 as char no-undo.
define variable c-modulos-ems2 as char no-undo.

define variable c-label-contas-pagar   as char no-undo.
define variable c-label-contas-receber as char no-undo.
define variable c-label-aplic-emprest  as char no-undo.
define variable c-label-caixa-bancos   as char no-undo.
define variable c-label-ativo-fixo     as char no-undo.
define variable c-label-faturamento    as char no-undo.
define variable c-label-estoque        as char no-undo.
define variable c-label-patrimonio     as char no-undo.
define variable c-label-mri     as char no-undo.

define variable c-label-j100     as char no-undo.
define variable c-label-apur-lucro-perda     as char no-undo.
define variable c-label-hfp            as char no-undo.
define variable c-label-hpp            as char no-undo.
define variable c-label-hrb            as char no-undo.
define variable c-label-trp            as char no-undo.

define variable dat-today   as date no-undo.
define variable i-seq-100   as integer no-undo.
define variable i-seq-150   as integer no-undo.

/* Para alimentar a informacao de c¢dig do IBGE e c¢digo do domicilio fiscal */
def new global shared var hlf0202d as handle no-undo.

define stream s-dump.

/*def buffer b-tt-rel-conta for tt-rel-conta. unificaÁ„o*/
def buffer b-dwf-lancto-ctbl for dwf-lancto-ctbl.

/* definiá∆o de frames do relat¢rio */
form c-message no-label format "x(255)" view-as editor size 130 by 1
    with frame f-extracao width 132 down stream-io.

form c-literal1 format "x(30)" no-label skip
     tt-param.c-cenario-contabil  colon 45 format "x(30)" 
     tt-param.c-empresa           colon 45
     tt-param.i-empresa-ems2      colon 45
     tt-param.dt-ini              colon 45 format "99/99/9999"   space(5)
     "|<  >|"                              
     tt-param.dt-fim              colon 75 format "99/99/9999" NO-LABEL SKIP
     c-literal2                   format "x(30)" no-label skip
     c-origem                     colon 45 format "x(30)" skip
     c-contabilidade              colon 45 format "x(10)" skip(1)
     c-modulos-ems5               to 61 format "x(30)" no-label skip
     tt-param.l-ems5-caixa-bancos   colon 45 format "Sim/N∆o"
     tt-param.l-ems5-contas-pagar   colon 45 format "Sim/N∆o"
     tt-param.l-ems5-contas-receber colon 45 format "Sim/N∆o"
     tt-param.l-ems5-ativo-fixo     colon 45 format "Sim/N∆o"
     tt-param.l-ems5-aplic-emprest  colon 45 format "Sim/N∆o"
     tt-param.l-ems5-hrb            colon 45 format "Sim/N∆o"
     tt-param.l-ems5-hpp            colon 45 format "Sim/N∆o"
     tt-param.l-ems5-hfp            colon 45 format "Sim/N∆o" skip(1)
     c-modulos-ems2                 to 61 format "x(30)" no-label skip
     tt-param.l-ems2-estoque        colon 45 format "Sim/N∆o"
     tt-param.l-ems2-faturamento    colon 45 format "Sim/N∆o"
     tt-param.l-ems2-caixa-bancos   colon 45 format "Sim/N∆o"
     tt-param.l-ems2-contas-pagar   colon 45 format "Sim/N∆o"
     tt-param.l-ems2-contas-receber colon 45 format "Sim/N∆o"
     tt-param.l-ems2-patrimonio     colon 45 format "Sim/N∆o"
     tt-param.l-ems2-mri             colon 45 format "Sim/N∆o" skip(1)
     tt-param.l-gera-j100           colon 45 format "Sim/N∆o" 
     tt-param.l-apura-result-sped   colon 45 format "Sim/N∆o" 
     tt-param.l-atualiza-participante colon 45 format "Sim/N∆o"
     tt-param.l-relaciona-lancto-participante colon 45 format "Sim/N∆o"
     tt-param.l-balancete         colon 45 
     c-tipo-balancete             colon 45 format "x(30)"
     tt-param.i-nivel             colon 45 
     tt-param.l-demonstrativo     colon 45 
     tt-param.c-balanco           colon 45 format "x(15)"
     tt-param.c-demonstracao      colon 45 format "x(15)"
     tt-param.usuario             colon 45 format "x(30)"
     c-time                       colon 45 format "x(08)"
     with frame f-parametros width 132 stream-io side-labels.

/* include padr∆o para output de relat¢rios */
{include/i-rpout.i &STREAM="stream str-rp"}

/* include com a definiá∆o da frame de cabeáalho e rodapÇ */
{include/i-rpcab.i &STREAM="str-rp"}

/* Desabilita Triggers */
disable triggers for load of dwf-cta-ctbl-refer.
disable triggers for load of dwf-cta-ctbl.
disable triggers for load of dwf-cta-aglut.
disable triggers for load of dwf-demonst-ctbl-bloco.
disable triggers for load of dwf-balan-patrim.
disable triggers for load of dwf-demonst-restdo-exerc.
disable triggers for load of dwf-item-lancto-ctbl.
disable triggers for load of dwf-lancto-ctbl.
disable triggers for load of dwf-sdo-ctbl-antes-encert.
disable triggers for load of dwf-sdo-ctbl.
disable triggers for load of dwf-ccusto.
disable triggers for load of dwf-plano-ccusto.
disable triggers for load of dwf-estab-extens.

find mgcad.empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.

{utp/ut-liter.i Extraá∆o_de_Dados_-_SPED_Cont†bil *}
/* bloco principal do programa */
assign c-programa     = "LF/LF0302RP"
       c-versao       = "2.00"
       c-revisao      = "000"
       c-empresa      = empresa.razao-social
       c-sistema      = ""
       c-titulo-relat = return-value.

assign dat-today = today.

assign l-diario-auxiliar-ems2 = YES
       l-diario-auxiliar-ems5 = (tt-param.l-ems5-caixa-bancos or
                                 tt-param.l-ems5-contas-pagar or
                                 tt-param.l-ems5-contas-receber or
                                 tt-param.l-ems5-ativo-fixo or
                                 tt-param.l-ems5-aplic-emprest or
                                 tt-param.l-ems5-hrb or
                                 tt-param.l-ems5-hpp or
                                 tt-param.l-ems5-hfp OR
                                 (tt-param.l-ems2-patrimonio AND 
                                  tt-param.c-contabilidade = "ems5"))
    .

{utp/ut-liter.i Contas_a_Pagar *}                       assign c-label-contas-pagar   = return-value.
{utp/ut-liter.i Contas_a_Receber *}                     assign c-label-contas-receber = return-value.
{utp/ut-liter.i Aplicaá‰es_e_EmprÇstimos *}             assign c-label-aplic-emprest  = return-value.
{utp/ut-liter.i Caixa_e_Bancos *}                       assign c-label-caixa-bancos   = return-value.
{utp/ut-liter.i Ativo_Fixo *}                           assign c-label-ativo-fixo     = return-value.
{utp/ut-liter.i Faturamento *}                          assign c-label-faturamento    = return-value.
{utp/ut-liter.i Estoque *}                              assign c-label-estoque        = return-value.
{utp/ut-liter.i Patrimìnio *}                           assign c-label-patrimonio     = return-value.
{utp/ut-liter.i Faturamento_de_Plano_de_Sa£de *}        assign c-label-hfp            = trim(return-value).
{utp/ut-liter.i Pagamento_de_Prestadores *}             assign c-label-hpp            = trim(return-value).
{utp/ut-liter.i Repasse_de_Benefici†rios *}             assign c-label-hrb            = trim(return-value).
{utp/ut-liter.i Sistema_Gerenciamento_de_Transportes *} assign c-label-trp            = trim(return-value).
{utp/ut-liter.i Modulo_de_Recuperacao_de_Impostos *}    assign c-label-mri            = trim(return-value).

{utp/ut-liter.i Gera_J100 *}     assign c-label-j100            = trim(return-value).
{utp/ut-liter.i Realiza_apur._de_resultados_no_per°odo *}    assign c-label-apur-lucro-perda            = trim(return-value).
/* executando de forma persistente o utilit†rio de acompanhamento */
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Extraindo_Dados *}


run pi-inicializar in h-acomp (input return-value).
run pi-acompanhar in h-acomp (input return-value).

assign i-time = time.

/* Exclui os dados das tabelas de erro e auxiliares utilizadas no processo */
for each tt-log-erros-sped:
    delete tt-log-erros-sped.
end.
for each tt-log-advertencias-sped:
    delete tt-log-advertencias-sped.
end.
for each tt-relacto-particip-pessoa:
    delete tt-relacto-particip-pessoa.
end.
for each tt_period:
    delete tt_period.
end.
for each tt-modulo:
    delete tt-modulo.
end.
for each tt-empresas-utilizadas:
    delete tt-empresas-utilizadas.
end.
for each tt-empresa-datasul-10:
    delete tt-empresa-datasul-10.
end.

/* Funá∆o utilizada para a remover lanáamentos criados indevidamente nos clientes que utilizaram 
   as primeiras vers‰es do extrator do SPED em 2009 (para estrega do SPED 2008).
   Para os clientes que n∆o utilizaram esta vers∆o, a rotina n∆o efetuar† nenhuma alteraá∆o */
run pi-tratar-dwf-item-lancto-ctbl-orfao.

def var h_api_ccusto       as handle no-undo.
def var h_api_cta          as handle no-undo.

IF NOT VALID-HANDLE(h_api_ccusto) THEN
    run prgint/utb/utb742za.py persistent set h_api_ccusto.

IF NOT VALID-HANDLE(h_api_cta) THEN
    run prgint/utb/utb743za.py persistent set h_api_cta.
if  not valid-handle(hlf0202d) then do:
    run lfp/lf0202d.p persistent set hlf0202d.
    run initializeInf in hlf0202d.
end.

/* Caso esteja extraindo di†rio auxiliar e a contabilidade esteja no EMS 2,
   cria as temp-table com as informaá‰es de relacionamento entre pessoa-participante */
/*if tt-param.c-diario = "diarioauxiliar" and 
   tt-param.c-contabilidade = "ems2" and 
   tt-param.l-relaciona-lancto-participante then do:
    for each relacto-particip-emit no-lock:
        create tt-relacto-particip-pessoa.
        assign tt-relacto-particip-pessoa.cod-empresa    = string(relacto-particip-emit.cdn-empresa)
               tt-relacto-particip-pessoa.cod-estab      = ''
               tt-relacto-particip-pessoa.cod-relacto    = relacto-particip-emit.cod-relacto-particip
               tt-relacto-particip-pessoa.ind-tip-pessoa = '' 
               tt-relacto-particip-pessoa.num-pessoa     = relacto-particip-emit.cdn-emitente-particip
               tt-relacto-particip-pessoa.dat-inic-valid = relacto-particip-emit.dat-inic-valid
               tt-relacto-particip-pessoa.dat-fim-valid  = relacto-particip-emit.dat-fim-valid
        .
    end.
end. unificaÁ„o*/

/* Cria tabela com periodos para facilitar os loops de per°odo tanto na 
   extraá∆o do EMS 2 quanto na extraá∆o do EMS 5 */
run pi-cria-tt-period.
run pi-cria-tt-modulo.

/* Extraá∆o - EMS 5 */
/* Se for contabilidade EMS 5 ou se algum m¢dulo do ems5 estiver selecionado, instancia o utb733za */
if not can-find(first tt-log-erros-sped) and 
   (tt-param.c-contabilidade = "ems5" or
    l-diario-auxiliar-ems5) then do:

    if search("prgint/utb/utb733za.p") = ? and 
       search("prgint/utb/utb733za.r") = ? then do:
        run pi-cria-tt-erros-sped(input 34349, 
                                  input "prgint/utb/utb733za.r",
                                  input no,
                                  input "").
    end.
    else do:
        run pi-conecta-ems5(1).
        if not can-find(first tt-log-erros-sped) then do:
            run prgint/utb/utb733za.r persistent set h-ems5 (input 1).
        end.
    end.
end.

/* Controle de empresas para o Datasul 10 */
run pi-cria-tt-empresa-datasul-10.

/*****************************************************************************************
** 
** As melhorias desenvolvidas no projeto 398 permitem que o usuario faáa a     
** extraá∆o de dados do EMS 5 e do EMS 2 ao mesmo tempo para os diarios auxiliares.
**
*****************************************************************************************/
run pi-limpa-tts.
   
/* Se for di†rio geral com contabilidade no EMS 5 ou di†rio auxiliar com algum m¢dulo do 
   EMS 5 selecionado, chama as pis de extraá∆o SPED do EMS 5 no utb733za */
if not can-find(first tt-log-erros-sped) THEN DO:

    if tt-param.c-diario = "diarioauxiliar" and
    tt-param.l-ems2-patrimonio and
    tt-param.c-contabilidade = "ems5" then do:
        DEF VAR l-sem-movto AS LOGICAL NO-UNDO.

        if valid-handle(h-ems5) then do:
            RUN pi_extrator_sped_valida_patrimonio in h-ems5 (INPUT tt-param.c-empresa,
                                                              INPUT tt-param.dt-ini,
                                                              INPUT tt-param.dt-fim,
                                                              OUTPUT l-sem-movto).
            IF l-sem-movto THEN DO:
                RUN pi-cria-tt-erros-sped (INPUT 30919,
                                           INPUT "Patrimonio",
                                           INPUT NO,
                                           INPUT "").
            END.
        END.
    END.

    IF ((tt-param.c-diario = "diariogeral" and
    tt-param.c-contabilidade = "ems5") or
    l-diario-auxiliar-ems5) then do:

        if valid-handle(h-ems5) then do:
            run pi_validacoes_sped in h-ems5.

            if return-value <> "NOK" then do:

                /*L¢gica inserida para corrigir problemas onde o centro de custo era
                  duplicado no arquivo SPED pois a empresa ficava = 0 em determinadas
                  situaá‰es
                */
                if can-find(first dwf-ccusto no-lock 
                            where dwf-ccusto.cdn-empresa = "0") then do:
                    for each dwf-ccusto exclusive-lock 
                      where dwf-ccusto.cdn-empresa = "0":
                        delete dwf-ccusto.
                    end.
                end.

                run pi_extrator_sped_main in h-ems5 (input h-acomp,
                                                     input dat-today).
            end.
        end.
    END.

    if can-find(first tt-log-erros-sped) then do:
        delete procedure h-ems5.
        run pi-conecta-ems5(2).
    end.
end.

if not can-find(first tt-log-erros-sped) 
    and (tt-param.c-diario = "diariogeral" and tt-param.c-contabilidade = "ems2")
    and (not tt-param.l-apura-result-sped) then do:

    if not can-find( first referencia-ct no-lock
                 where referencia-ct.referencia = "|L/P" + string(year(tt-param.dt-ini) - 1)) then do:

        create tt-log-advertencias-sped.
        assign tt-log-advertencias-sped.num-cod-erro = 52222
               tt-log-advertencias-sped.des-erro = "". 

    end.

end.

/* Extraá∆o - EMS 2 */ 
if not can-find(first tt-log-erros-sped) and 
        ((tt-param.c-diario = "diariogeral" and 
          tt-param.c-contabilidade = "ems2") or
          (tt-param.c-diario = "diarioauxiliar" and
          l-diario-auxiliar-ems2)) then do:
    run pi-validacoes-ems2.

    /*MESSAGE return-value
        VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

    if return-value <> "nok" then do:
        run pi-extrator-sped-main-ems2.
    end.
end.

/* Extrai saldo dos diarios auxiliares */
if not can-find (tt-log-erros-sped) then do:

    if tt-param.c-diario = "diarioauxiliar" then do:

        {utp/ut-liter.i Extraindo_Saldos *}
        run pi-acompanhar in h-acomp (input return-value).

        if tt-param.c-contabilidade = "ems5" then do:
            if valid-handle(h-ems5) then do:
                run pi_extrator_sped_saldo_auxiliar in h-ems5.
                run pi_extrator_sped_plano_ccusto in h-ems5.
            end.
        end.
        /*else /* EMS 2 */
            run pi-extrair-saldo-contabil-auxiliar. unificaÁ„o*/
    end.

    {utp/ut-liter.i Extraindo_Participantes *}
    run pi-acompanhar in h-acomp (input return-value).

    if tt-param.c-contabilidade = "ems5" then do:
        if valid-handle(h-ems5) then 
            run pi_extrator_sped_participante in h-ems5.
    end.
    /*else
        run pi-extrair-participantes.*/
end.

/* APURAÄ«O DE RESULTADOS */
if tt-param.l-apura-result-sped then do:
    run pi-acompanhar in h-acomp (input string("Apurando Resultados em " + string(tt-param.dt-fim, '99/99/9999') + " para o SPED Cont†bil")).
    run pi-apura-resultados-sped.
end.

/* Erros */
if can-find(first tt-log-erros-sped
            where tt-log-erros-sped.log-erro-tela = yes) then do:
    for each tt-log-erros-sped
       where tt-log-erros-sped.log-erro-tela = yes:
        run utp/ut-msgs.p (input "show":U, 
                           input tt-log-erros-sped.num-cod-erro, 
                           input tt-log-erros-sped.des-erro).
    end.
    run pi-finalizar in h-acomp.
    if valid-handle(h-ems5) then do:
        delete procedure h-ems5.
        run pi-conecta-ems5(2).
    end.
    
    return error.
end.
         
/*Coppi - 241.291*/
if not can-find(first tt-log-erros-sped) then do:
    run pi-salva-registros.  
end.
/*Coppi - 241.291*/

if can-find(first tt-log-erros-sped
                 where tt-log-erros-sped.log-erro-tela = no) then do:
    
    {lfp/lf0302rp.i1 log-erros-sped}

    view stream str-rp frame f-cabec.
    {utp/ut-liter.i Nenhuma_informaá∆o_foi_extra°da_para_o_MLF,_devido_aos_seguintes_erros: *}
    assign c-message = return-value.
    disp stream str-rp c-message with frame f-extracao.
    down 2 stream str-rp with frame f-extracao.

    {lfp/lf0302rp.i2 1}

    for each tt-log-erros-sped
       where tt-log-erros-sped.log-erro-tela = no
         and tt-log-erros-sped.num-cod-erro > 0:
        run utp/ut-msgs.p (input "msg":U, 
                           input tt-log-erros-sped.num-cod-erro, 
                           input tt-log-erros-sped.des-erro).

        assign c-message = "Msg " + string(tt-log-erros-sped.num-cod-erro) + ": " +  return-value.
        disp stream str-rp c-message with frame f-extracao.

        run utp/ut-msgs.p (input "help":U, 
                           input tt-log-erros-sped.num-cod-erro, 
                           input tt-log-erros-sped.des-erro).
        if trim(return-value) <> "" then do:
            assign c-message = "Ajuda: " + return-value.
            down stream str-rp with frame f-extracao.
            disp stream str-rp c-message with frame f-extracao.
        end.
       
        down 2 stream str-rp with frame f-extracao.

        {lfp/lf0302rp.i2 1}

    end.

    output stream s-excel-1 close.

    /* Erros Demonstrativo - Balanáo Patrimonial - C¢digo -1 */
    run pi-print-erros-natur-demonstrativo(input "balanco").
    
    /* Erros Demonstrativo - Demonstraá∆o de Resultados - C¢digo -2 */
    run pi-print-erros-natur-demonstrativo(input "dre").

    run pi-print-parametros.
    run pi-finalizar in h-acomp.
    return.
end.
                 
if valid-handle(h-ems5) then do:
    delete procedure h-ems5.
    run pi-conecta-ems5(2).
end.


/* Advertàncias */
def var l-advertencia as logical no-undo initial no.
def var i-cont-linhas as int no-undo.
if can-find(first tt-log-advertencias-sped
            where tt-log-advertencias-sped.log-erro-tela = no) then do:

    {lfp/lf0302rp.i1 log-advertencias-sped}

    assign l-advertencia = yes.
    view stream str-rp frame f-cabec.
    
    {utp/ut-liter.i Advertàncias: *}
    assign c-message = return-value.
    disp stream str-rp c-message with frame f-extracao.
    down 2 stream str-rp with frame f-extracao.

    {lfp/lf0302rp.i2 1}

    for each tt-log-advertencias-sped
       where tt-log-advertencias-sped.log-erro-tela = no
        by tt-log-advertencias-sped.num-cod-erro desc:

        /*Por padr∆o, o extrator n∆o executa a ut-msgs no momento do erro por causa do EMS 5. */
        if tt-log-advertencias-sped.num-cod-erro > 0 then do:
            IF CAN-FIND(tt-recid-advertencias-sped-ap WHERE tt-recid-advertencias-sped-ap.recid-ap = RECID(tt-log-advertencias-sped)) THEN DO:
                assign c-message = "Msg " + string(tt-log-advertencias-sped.num-cod-erro) + ": " + tt-log-advertencias-sped.des-erro.
            END.
            ELSE DO:
                run utp/ut-msgs.p (input "help":U, 
                                   input tt-log-advertencias-sped.num-cod-erro, 
                                   input tt-log-advertencias-sped.des-erro).
                assign c-message = "Msg " + string(tt-log-advertencias-sped.num-cod-erro) + ": " + return-value.
            END.
        end.
        else do:
            /* Advertàncias da integraá∆o entre os produtos vem com o num-cod-erro = -1
               Advertàncias das APIs de movimentos vem com num-cod-erro = -3.
               Nestas mensagens, Ç feita a execuá∆o da ut-msgs para armazenar a mensagem 
               nos campos des-erro e des-ajuda.
               Deve imprimir o des-erro e o des-ajuda quando este for <> de "" */
            assign c-message = tt-log-advertencias-sped.des-erro.
            if tt-log-advertencias-sped.des-ajuda <> "" then
                assign c-message = c-message + chr(13) + chr(10) + tt-log-advertencias-sped.des-ajuda.
        end.
        disp stream str-rp c-message with frame f-extracao.
        down 2 stream str-rp with frame f-extracao.

        {lfp/lf0302rp.i2 1}

    end.

    output stream s-excel-1 close.
 
end.

if not l-advertencia then
    view stream str-rp frame f-cabec.

view stream str-rp frame f-rodape.

/* corpo do relat¢rio */
run pi-print-resultado-extracao.

/* Salva hist¢rico da execuá∆o */
run pi-salva-historico-execucao.

run pi-limpa-tts.

run pi-print-parametros.

if  valid-handle (hlf0202d) then do:  
    RUN finalizeInf   IN hlf0202d.
    delete procedure hlf0202d.  
    assign hlf0202d = ?.  
end.

{include/i-rpclo.i &STREAM="stream str-rp"}

run pi-finalizar in h-acomp.

return "OK":U.

/***************************************************************************************************/
procedure pi-exclui-dados-extraidos:
    def var c-modulos as char no-undo.
    def var c-cod-modul as char no-undo.
    def var i-cont as int no-undo.
    def var c-message as char no-undo.

    run pi-retorna-modulos-selecionados.
    assign c-modulos = return-value.

    {utp/ut-liter.i Removendo_Dados *}
    assign c-message = return-value.

    /* Limpa todo o DE-PARA no MLF */
    if tt-param.c-diario = "diariogeral" then do:

        run pi-acompanhar in h-acomp (input c-message + " - (dwf-cta-ctbl-refer)").

        for each dwf-cta-ctbl-refer USE-INDEX dwfctcta-prod exclusive-lock
            where dwf-cta-ctbl-refer.cod-empresa = tt-param.c-empresa
              and dwf-cta-ctbl-refer.cod-produto = tt-param.c-contabilidade transaction:
            delete dwf-cta-ctbl-refer.
        end.

                if not tt-param.l-gera-j100 then do:

                    if (tt-param.l-balancete or tt-param.l-demonstrativo) and

                        NOT can-find (first tt-dwf-demonst-ctbl-bloco) then DO:
                            FOR EACH dwf-demonst-ctbl-bloco
                                where dwf-demonst-ctbl-bloco.cod-empresa = tt-param.c-empresa
                                exclusive-lock transaction: 

                                if ((dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl >= tt-param.dt-ini and 
                                     dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl <= tt-param.dt-fim) or
                                    (dwf-demonst-ctbl-bloco.dat-fim-demonst-ctbl  >= tt-param.dt-ini and
                                     dwf-demonst-ctbl-bloco.dat-fim-demonst-ctbl  <= tt-param.dt-fim)) or
                                   ((tt-param.dt-ini >= dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl and 
                                     tt-param.dt-ini <= dwf-demonst-ctbl-bloco.dat-fim-demonst-ctbl) or
                                    (tt-param.dt-fim >= dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl and
                                     tt-param.dt-fim <= dwf-demonst-ctbl-bloco.dat-fim-demonst-ctbl)) then do:
                                
                                
                                        for each dwf-balan-patrim
                                            where dwf-balan-patrim.cod-empresa = dwf-demonst-ctbl-bloco.cod-empresa
                                              and dwf-balan-patrim.dat-inic-demonst-ctbl = dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl 
                                            exclusive-lock:
                                            delete dwf-balan-patrim.
                                        end.
                                    
                                        for each dwf-demonst-restdo-exerc
                                            where dwf-demonst-restdo-exerc.cod-empresa = dwf-demonst-ctbl-bloco.cod-empresa
                                              and dwf-demonst-restdo-exerc.dat-inic-demonst-ctbl = dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl 
                                            exclusive-lock:
                                            delete dwf-demonst-restdo-exerc.
                                        end.
                                        
                                
                                        delete dwf-demonst-ctbl-bloco.
                                   
                                END.
                            END.
                        END.
                    END.
                    
                    
                    
        if (tt-param.l-balancete or tt-param.l-demonstrativo) and
           can-find (first tt-dwf-demonst-ctbl-bloco) then do:

            run pi-acompanhar in h-acomp (input c-message + " - (dwf-cta-aglut)").

            for each dwf-cta-aglut exclusive-lock
                where dwf-cta-aglut.cod-empresa = tt-param.c-empresa transaction:
                delete dwf-cta-aglut.
            end.

            run pi-acompanhar in h-acomp (input c-message + " - (dwf-demonst-ctbl-bloco)").


            


            for each dwf-demonst-ctbl-bloco
                where dwf-demonst-ctbl-bloco.cod-empresa = tt-param.c-empresa
                exclusive-lock transaction: 

                /* Datas sobrepostas */
                if ((dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl >= tt-param.dt-ini and 
                     dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl <= tt-param.dt-fim) or
                    (dwf-demonst-ctbl-bloco.dat-fim-demonst-ctbl  >= tt-param.dt-ini and
                     dwf-demonst-ctbl-bloco.dat-fim-demonst-ctbl  <= tt-param.dt-fim)) or
                   ((tt-param.dt-ini >= dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl and 
                     tt-param.dt-ini <= dwf-demonst-ctbl-bloco.dat-fim-demonst-ctbl) or
                    (tt-param.dt-fim >= dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl and
                     tt-param.dt-fim <= dwf-demonst-ctbl-bloco.dat-fim-demonst-ctbl)) then do:

                    for each dwf-balan-patrim
                        where dwf-balan-patrim.cod-empresa = dwf-demonst-ctbl-bloco.cod-empresa
                          and dwf-balan-patrim.dat-inic-demonst-ctbl = dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl 
                        exclusive-lock:
                        delete dwf-balan-patrim.
                    end.

                    for each dwf-demonst-restdo-exerc
                        where dwf-demonst-restdo-exerc.cod-empresa = dwf-demonst-ctbl-bloco.cod-empresa
                          and dwf-demonst-restdo-exerc.dat-inic-demonst-ctbl = dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl 
                        exclusive-lock:
                        delete dwf-demonst-restdo-exerc.
                    end.

                    delete dwf-demonst-ctbl-bloco.
                end.
            end.
        end.
    end.

    do i-cont = 1 to num-entries(c-modulos, ","):
        assign c-cod-modul = GetEntryField(i-cont, c-modulos, ",").

        for each tt-empresas-utilizadas:

            /* O for each dwf-lancto-ctbl est† sendo feito com no-lock para que possa ser criado
               uma transaá∆o a n°vel de dwf-item-lancto-ctbl, se lesse com exclusive e com transaction
               ocorreria o erro abaixo:
                ** WARNING--TRANSACTION keyword given within actual transaction level. (214)
            */
            run pi-acompanhar in h-acomp (input c-message + " - (dwf-lancto-ctbl)").

            for each dwf-lancto-ctbl fields (cod-empresa    
                                             cdn-empresa    
                                             cod-modul-dtsul
                                             cod-lote-ctbl  
                                             cod-lancto-ctbl
                                             dat-lancto-ctbl) no-lock
                where dwf-lancto-ctbl.cod-empresa      = tt-empresas-utilizadas.cod-empresa
                  and dwf-lancto-ctbl.cdn-empresa      = tt-empresas-utilizadas.cdn-empresa
                  and dwf-lancto-ctbl.cod-modul-dtsul  = c-cod-modul
                  and dwf-lancto-ctbl.dat-lancto-ctbl >= tt-param.dt-ini
                  and dwf-lancto-ctbl.dat-lancto-ctbl <= tt-param.dt-fim:
                for each dwf-item-lancto-ctbl exclusive-lock
                   where dwf-item-lancto-ctbl.cod-empresa     = dwf-lancto-ctbl.cod-empresa
                     and dwf-item-lancto-ctbl.cdn-empresa     = dwf-lancto-ctbl.cdn-empresa
                     and dwf-item-lancto-ctbl.cod-modul-dtsul = dwf-lancto-ctbl.cod-modul-dtsul
                     and dwf-item-lancto-ctbl.cod-lote-ctbl   = dwf-lancto-ctbl.cod-lote-ctbl
                     and dwf-item-lancto-ctbl.cod-lancto-ctbl = dwf-lancto-ctbl.cod-lancto-ctbl transaction:
                    delete dwf-item-lancto-ctbl.
                end.
                do trans:
                    find b-dwf-lancto-ctbl exclusive-lock
                         where rowid(b-dwf-lancto-ctbl) = rowid(dwf-lancto-ctbl) no-error.
                    if avail b-dwf-lancto-ctbl then
                        delete b-dwf-lancto-ctbl.
                end.
            end.

            run pi-acompanhar in h-acomp (input c-message + " - (dwf-sdo-ctbl)").

            for each dwf-sdo-ctbl exclusive-lock
               where dwf-sdo-ctbl.cod-modul-dtsul = c-cod-modul
                 and dwf-sdo-ctbl.cod-empresa = tt-empresas-utilizadas.cod-empresa
                 and dwf-sdo-ctbl.cdn-empresa = tt-empresas-utilizadas.cdn-empresa
                 and dwf-sdo-ctbl.num-exerc-ctbl >= year(tt-param.dt-ini)
                 and dwf-sdo-ctbl.num-exerc-ctbl <= year(tt-param.dt-fim) transaction:

                /* 
                    L¢gica para excluir os saldos dos per°odos selecionados para extraá∆o,
                    respeitando os registros que se referem a um per°odo parcial e que n∆o
                    fazem parte da extraá∆o atual.
                    Os registros que possuem um per°odo em comum com a extraá∆o atual ser∆o
                    exclu°dos, pois se o extrator chegou a este ponto significa que o usu†rio
                    confirmou esta aá∆o na mensagem no in°cio da execuá∆o 
                    
                    tt-param.dt-ini -> Data inicial da Extraá∆o
                    tt-param.dt-fim -> Data final da Extraá∆o
                    dwf-sdo-ctbl.dat-livre-1 -> Data inicial do saldo existente no MLF
                    dwf-sdo-ctbl.dat-livre-2 -> Data final do saldo existente no MLF
                */
                    
                /* Se o ano do saldo extra°do for igual ao ano da data inicial ou final da extraá∆o */
                if dwf-sdo-ctbl.num-exerc-ctbl = year(tt-param.dt-ini) or 
                   dwf-sdo-ctbl.num-exerc-ctbl = year(tt-param.dt-fim) then do:

                    /* Se o màs do saldo extra°do estiver entre o per°odo inicial e final da extraá∆o, 
                       exclui o registro pois ser† salvo novamente pela extraá∆o atual */
                    if (dwf-sdo-ctbl.num-exerc-ctbl = year(tt-param.dt-ini) and
                        dwf-sdo-ctbl.num-exerc-ctbl < year(tt-param.dt-fim) and 
                        dwf-sdo-ctbl.num-period-ctbl > month(tt-param.dt-ini)) or 
                       (dwf-sdo-ctbl.num-exerc-ctbl = year(tt-param.dt-fim) and
                        dwf-sdo-ctbl.num-exerc-ctbl > year(tt-param.dt-ini) and 
                        dwf-sdo-ctbl.num-period-ctbl < month(tt-param.dt-fim)) or
                       (dwf-sdo-ctbl.num-exerc-ctbl = year(tt-param.dt-ini) and
                        dwf-sdo-ctbl.num-exerc-ctbl = year(tt-param.dt-fim) and
                        dwf-sdo-ctbl.num-period-ctbl > month(tt-param.dt-ini) and
                        dwf-sdo-ctbl.num-period-ctbl < month(tt-param.dt-fim)) then do:
                        delete dwf-sdo-ctbl.
                        next.
                    end.
                    /* Se o màs do saldo extra°do for igual ao màs da data inicial ou final da extraá∆o */
                    else if (dwf-sdo-ctbl.num-exerc-ctbl = year(tt-param.dt-ini) and 
                             dwf-sdo-ctbl.num-period-ctbl = month(tt-param.dt-ini)) or
                            (dwf-sdo-ctbl.num-exerc-ctbl = year(tt-param.dt-fim) and 
                             dwf-sdo-ctbl.num-period-ctbl = month(tt-param.dt-fim)) then do:

                        /* Se a data inicial do saldo extra°do for maior ou igual Ö data inicial da extraá∆o
                           e a data final do saldo for maior ou igual Ö data final da extraá∆o */
                        if (dwf-sdo-ctbl.dat-livre-1 >= tt-param.dt-ini and
                            dwf-sdo-ctbl.dat-livre-2 <= tt-param.dt-fim) or
                        /* Se a data inicial da extraá∆o for maior ou igual Ö data inicial do saldo extra°do
                           e a data final da extraá∆o for maior ou igual Ö data final do saldo */
                           (dwf-sdo-ctbl.dat-livre-1 <= tt-param.dt-ini and
                            dwf-sdo-ctbl.dat-livre-2 >= tt-param.dt-fim) or
                        /* Ou se a data inicial do saldo extra°do for menor que a data inicial da extraá∆o
                           e a data final do saldo for maior ou igual Ö data inicial da extraá∆o 
                           e menor ou igual Ö data final da extraá∆o (sobreposiá∆o parcial de datas) */
                           (dwf-sdo-ctbl.dat-livre-1 < tt-param.dt-ini and
                            dwf-sdo-ctbl.dat-livre-2 >= tt-param.dt-ini and
                            dwf-sdo-ctbl.dat-livre-2 <= tt-param.dt-fim) or 
                        /* Ou se a data final do saldo extra°do for maior que a data final da extraá∆o
                           e a data inicial do saldo for maior ou igual Ö data inicial da extraá∆o 
                           e menor ou igual Ö data final da extraá∆o (sobreposiá∆o parcial de datas) */
                           (dwf-sdo-ctbl.dat-livre-2 > tt-param.dt-fim and
                            dwf-sdo-ctbl.dat-livre-1 >= tt-param.dt-ini and
                            dwf-sdo-ctbl.dat-livre-1 <= tt-param.dt-fim) then do:
                            delete dwf-sdo-ctbl.
                            next.
                        end.

                    end.
                end.
                /* Se o ano do saldo extra°do estiver entre o per°odo inicial e final da extraá∆o, 
                   exclui o registro pois ser† salvo novamente pela extraá∆o atual */
                else if (dwf-sdo-ctbl.num-exerc-ctbl > year(tt-param.dt-ini) and
                         dwf-sdo-ctbl.num-exerc-ctbl < year(tt-param.dt-fim)) then do:
                    delete dwf-sdo-ctbl.
                    next.
                end.
            end.
        end.


        if tt-param.c-diario = "diariogeral" then do:

            run pi-acompanhar in h-acomp (input c-message + " - (dwf-sdo-ctbl-antes-encert)").

            for each tt-dwf-estab-extens:
                if can-find (first dwf-sdo-ctbl-antes-encert
                             where dwf-sdo-ctbl-antes-encert.cod-empresa = tt-dwf-estab-extens.cod-empresa
                               and dwf-sdo-ctbl-antes-encert.cod-estab = tt-dwf-estab-extens.cod-estab
                               and dwf-sdo-ctbl-antes-encert.cod-modul-dtsul = c-cod-modul
                               and dwf-sdo-ctbl-antes-encert.dat-apurac-restdo >= tt-param.dt-ini 
                               and dwf-sdo-ctbl-antes-encert.dat-apurac-restdo <= tt-param.dt-fim) then do:
                             
                    for each dwf-sdo-ctbl-antes-encert exclusive-lock
                       where dwf-sdo-ctbl-antes-encert.cod-empresa = tt-dwf-estab-extens.cod-empresa
                         and dwf-sdo-ctbl-antes-encert.cod-estab = tt-dwf-estab-extens.cod-estab
                         and dwf-sdo-ctbl-antes-encert.cod-modul-dtsul = c-cod-modul
                         and dwf-sdo-ctbl-antes-encert.dat-apurac-restdo >= tt-param.dt-ini 
                         and dwf-sdo-ctbl-antes-encert.dat-apurac-restdo <= tt-param.dt-fim transaction:
                        delete dwf-sdo-ctbl-antes-encert.
                    end.
                end.
            end.    
            for each dwf-sdo-ctbl-antes-encert exclusive-lock
               where dwf-sdo-ctbl-antes-encert.cod-empresa = tt-param.c-empresa
                 and dwf-sdo-ctbl-antes-encert.cod-estab = ""
                 and dwf-sdo-ctbl-antes-encert.cod-modul-dtsul = c-cod-modul
                 and dwf-sdo-ctbl-antes-encert.dat-apurac-restdo >= tt-param.dt-ini 
                 and dwf-sdo-ctbl-antes-encert.dat-apurac-restdo <= tt-param.dt-fim transaction:
                delete dwf-sdo-ctbl-antes-encert.
            end.
        end.

        /* Exclui os registros de hist¢rico com datas (meses) sobrepostas Ö nova extraá∆o */
        for each dwf-histor-sped-ctbl exclusive-lock
           where dwf-histor-sped-ctbl.cod-empresa = tt-param.c-empresa
             and dwf-histor-sped-ctbl.cod-estab = ''
             and dwf-histor-sped-ctbl.cod-produt-dtsul = (if tt-param.c-contabilidade = "ems2" then "EMS 2" else "EMS 5")
             and dwf-histor-sped-ctbl.ind-diario = (if tt-param.c-diario = "diariogeral" then "Geral" else "Auxiliar")
             and dwf-histor-sped-ctbl.cod-modul-dtsul = c-cod-modul:

            if year(dwf-histor-sped-ctbl.dat-inic-period) = year(tt-param.dt-ini) or 
               year(dwf-histor-sped-ctbl.dat-fim-period) = year(tt-param.dt-fim) then do:

                if ( year(dwf-histor-sped-ctbl.dat-inic-period)  = year(tt-param.dt-ini) and
                     year(dwf-histor-sped-ctbl.dat-fim-period)   < year(tt-param.dt-fim) and 
                     month(dwf-histor-sped-ctbl.dat-inic-period) > month(tt-param.dt-ini)) or 
                   ( year(dwf-histor-sped-ctbl.dat-fim-period)   = year(tt-param.dt-fim) and
                     year(dwf-histor-sped-ctbl.dat-inic-period)  > year(tt-param.dt-ini) and 
                     month(dwf-histor-sped-ctbl.dat-fim-period)  < month(tt-param.dt-fim)) or
                   ( year(dwf-histor-sped-ctbl.dat-inic-period)  = year(tt-param.dt-ini) and
                     year(dwf-histor-sped-ctbl.dat-fim-period)   = year(tt-param.dt-fim) and
                     month(dwf-histor-sped-ctbl.dat-inic-period) > month(tt-param.dt-ini) and
                     month(dwf-histor-sped-ctbl.dat-fim-period)  < month(tt-param.dt-fim)) then do:
                    delete dwf-histor-sped-ctbl.
                    next.
                end.
                else if (year(dwf-histor-sped-ctbl.dat-inic-period)  = year(tt-param.dt-ini) and 
                         month(dwf-histor-sped-ctbl.dat-inic-period) = month(tt-param.dt-ini)) or
                        (year(dwf-histor-sped-ctbl.dat-fim-period)   = year(tt-param.dt-fim) and 
                         month(dwf-histor-sped-ctbl.dat-fim-period)  = month(tt-param.dt-fim)) then do:

                    if (dwf-histor-sped-ctbl.dat-inic-period >= tt-param.dt-ini and
                        dwf-histor-sped-ctbl.dat-fim-period <= tt-param.dt-fim) or
                       (dwf-histor-sped-ctbl.dat-inic-period <= tt-param.dt-ini and
                        dwf-histor-sped-ctbl.dat-fim-period >= tt-param.dt-fim) or
                       (dwf-histor-sped-ctbl.dat-inic-period < tt-param.dt-ini and
                        dwf-histor-sped-ctbl.dat-fim-period >= tt-param.dt-ini and
                        dwf-histor-sped-ctbl.dat-fim-period <= tt-param.dt-fim) or 
                       (dwf-histor-sped-ctbl.dat-fim-period > tt-param.dt-fim and
                        dwf-histor-sped-ctbl.dat-inic-period >= tt-param.dt-ini and
                        dwf-histor-sped-ctbl.dat-inic-period <= tt-param.dt-fim) then do:
                        delete dwf-histor-sped-ctbl.
                        next.
                    end.

                end.
            end.
            else if (year(dwf-histor-sped-ctbl.dat-inic-period) > year(tt-param.dt-ini) and
                     year(dwf-histor-sped-ctbl.dat-fim-period) < year(tt-param.dt-fim)) then do:
                delete dwf-histor-sped-ctbl.
                next.
            end.
        end.
        
    end.
end procedure.
/***************************************************************************************************/
procedure pi-conecta-ems5:
    define input parameter i-connect as integer no-undo.

    find first param-global no-lock no-error.

    if not avail param-global then do:
        run pi-cria-tt-erros-sped(input 16,
                                  input "",
                                  input no,
                                  input "").
        return.
    end.
    
    if not valid-handle (h-btb009za) or
       h-btb009za:type <> "PROCEDURE":U or
       h-btb009za:file-name <> "btb/btb009za.p":U then
        run btb/btb009za.p persistent set h-btb009za.

    if i-connect = 1 then do:
        if not connected("emsbas":U) or 
           not connected("emsfin":U) or 
           not connected("emsuni":U) then do: 
            if valid-handle (h-btb009za) and 
               h-btb009za:TYPE = "PROCEDURE":U and
               h-btb009za:FILE-NAME = "btb/btb009za.p":U then do:

                run pi-conecta-bco in h-btb009za (input 1,                         /*contem a versao de integracao da Api*/
                                                  input i-connect,                 /*contem a opcao desejada (1-Conexao, 2-Desconexao)*/
                                                  input param-global.empresa-prin, /*contem o codigo da empresa*/
                                                  input "all":U,                   /*contem o codigo do banco externo*/ 
                                                  output table tt_erros_conexao).  /*retorna erros caso existam*/
                if can-find(first tt_erros_conexao) then do:
                    find first tt_erros_conexao no-error.
                    run pi-cria-tt-erros-sped(input tt_erros_conexao.cd-erro,
                                              input tt_erros_conexao.param-1,
                                              input no,
                                              input "").
                    return.
                end.

                assign l-ems5-nova-conexao = yes.
            end.
        end.
    end.
    else do:
        if l-ems5-nova-conexao = yes then do:
            if connected("emsbas":U) or 
               connected("emsfin":U) or 
               connected("emsuni":U) then do:
                
                if valid-handle (h-btb009za) and
                   h-btb009za:type = "PROCEDURE":U and
                   h-btb009za:file-name = "btb/btb009za.p":U then do:

                    run pi-conecta-bco in h-btb009za (input 1,                         /*contem a versao de integracao da Api*/
                                                      input i-connect,                 /*contem a opcao desejada (1-Conexao, 2-Desconexao)*/
                                                      input param-global.empresa-prin, /*contem o codigo da empresa*/
                                                      input "all":U,                   /*contem o codigo do banco externo*/ 
                                                      output table tt_erros_conexao).  /*retorna erros caso existam*/
                    if can-find(first tt_erros_conexao) then do:
                        find first tt_erros_conexao no-error.
                        run pi-cria-tt-erros-sped(input tt_erros_conexao.cd-erro,
                                                  input tt_erros_conexao.param-1,
                                                  input no,
                                                  input "").
                        return.
                    end.
                end.
            end.    
        end.    
    end.
end procedure.
/***************************************************************************************************/
procedure pi-inclui-separador:
    define input-output parameter c-value as char no-undo.

    if c-value <> "" then
        assign c-value = c-value + ",":U.

end procedure.
/***************************************************************************************************/
procedure pi-retorna-modulos-selecionados:

    def var c-modulos as char no-undo initial "".

    if tt-param.c-diario = "diariogeral" then do:
        if tt-param.c-contabilidade = "ems5" then
            assign c-modulos = "FGL,MCT".
        else 
            assign c-modulos = "MCT,FGL".
    end.
    else do:
        if tt-param.l-ems5-contas-pagar or 
           tt-param.l-ems2-contas-pagar then do:
            run pi-inclui-separador(input-output c-modulos).
            assign c-modulos = c-modulos + "APB,APP,MAP".
        end.
        if tt-param.l-ems5-contas-receber or
           tt-param.l-ems2-contas-receber then do:
            run pi-inclui-separador(input-output c-modulos).
            assign c-modulos = c-modulos + "ACR,CRP,MCR".
        end.
        if tt-param.l-ems5-aplic-emprest then do:
            run pi-inclui-separador(input-output c-modulos).
            assign c-modulos = c-modulos + "APL".
        end.
        if tt-param.l-ems5-caixa-bancos or
           tt-param.l-ems2-caixa-bancos then do:
            run pi-inclui-separador(input-output c-modulos).
            assign c-modulos = c-modulos + "CMG,CBP,MCB".
        end.
        if tt-param.l-ems5-ativo-fixo or
           tt-param.l-ems2-patrimonio then do:
            run pi-inclui-separador(input-output c-modulos).
            assign c-modulos = c-modulos + "FAS,PTP,MPT".
        end.
        if tt-param.l-ems5-hfp then do:
            run pi-inclui-separador(input-output c-modulos).
            assign c-modulos = c-modulos + "HFP".
        end.
        if tt-param.l-ems5-hpp then do:
            run pi-inclui-separador(input-output c-modulos).
            assign c-modulos = c-modulos + "HPP".
        end.
        if tt-param.l-ems5-hrb then do:
            run pi-inclui-separador(input-output c-modulos).
            assign c-modulos = c-modulos + "HRB".
        end.
        if tt-param.l-ems2-faturamento then do:
            run pi-inclui-separador(input-output c-modulos).
            assign c-modulos = c-modulos + "MFT,FTP".
        end.
        if tt-param.l-ems2-estoque then do:
            run pi-inclui-separador(input-output c-modulos).
            assign c-modulos = c-modulos + "MCE,CEP".
        end.
        if tt-param.l-ems2-mri then do:
            run pi-inclui-separador(input-output c-modulos).
            assign c-modulos = c-modulos + "MRI,RIP".
        end.
    end.

    return c-modulos.
end procedure.
/***************************************************************************************************/
procedure pi-retorna-label-modulo:

    define input parameter p-cod-modulo as char no-undo.

    define variable c-retorno as char no-undo.

    case p-cod-modulo:
        when "MAP" or when "APB" then
            assign c-retorno = c-label-contas-pagar.
        when "MCR" or when "ACR" then
            assign c-retorno = c-label-contas-receber.
        when "MCB" or when "CMG" then
            assign c-retorno = c-label-caixa-bancos.
        when "MPT" or when "FAS" then
            assign c-retorno = c-label-patrimonio.
        when "MFT" then
            assign c-retorno = c-label-faturamento.
        when "MCE" then
            assign c-retorno = c-label-estoque.
        when "HFP" then
            assign c-retorno = c-label-hfp.
        when "HPP" then
            assign c-retorno = c-label-hpp.
        when "HRB" then
            assign c-retorno = c-label-hrb.
        when "MRI" or when "RIP" then
            assign c-retorno = c-label-mri.
        when "TRP" or when "MTR" then
            assign c-retorno = c-label-trp.
    end case.
    
    return c-retorno.

end procedure.
/***************************************************************************************************/
procedure pi-is-integer:
    define input parameter c-value as char no-undo.

    define variable i as integer no-undo.
    define variable c-return as char no-undo.

    assign i = integer(c-value) no-error.
    if error-status:error then
        assign c-return = "false".
    else 
        assign c-return = "true".

    assign error-status:error = no no-error.

    return c-return.
end.
/***************************************************************************************************/
procedure pi-cria-tt-erros-sped:
    define input parameter p-erro     as integer no-undo.
    define input parameter p-des-erro as char no-undo.
    define input parameter p-log-tela as logical no-undo.
    define input parameter p-cod-cta  as char no-undo.

    if p-cod-cta <> "" then do:
        find first tt-log-erros-sped
            where tt-log-erros-sped.num-cod-erro = p-erro
              and tt-log-erros-sped.cod-cta-ctbl = p-cod-cta
              and tt-log-erros-sped.cod-ccusto   = ""
            no-error.

        if not avail tt-log-erros-sped then do:
            create tt-log-erros-sped.
            assign tt-log-erros-sped.num-cod-erro  = p-erro
                   tt-log-erros-sped.des-erro      = p-des-erro
                   tt-log-erros-sped.log-erro-tela = p-log-tela
                   tt-log-erros-sped.cod-cta-ctbl  = p-cod-cta
                   tt-log-erros-sped.cod-ccusto    = "".
        end.
    end.
    else do:
        create tt-log-erros-sped.
        assign tt-log-erros-sped.num-cod-erro  = p-erro
               tt-log-erros-sped.des-erro      = p-des-erro
               tt-log-erros-sped.log-erro-tela = p-log-tela
               tt-log-erros-sped.cod-cta-ctbl  = p-cod-cta
               tt-log-erros-sped.cod-ccusto    = "".
    end.
    release tt-log-erros-sped.

end procedure.
/***************************************************************************************************/
procedure pi-validacoes-ems2:
    /* esta PI s¢ ser† executada quando tt-param.c-produto = "ems2" */

    define variable c-modulos          as char    no-undo.
    define variable c-modulos-com-erro as char    no-undo.
    define variable l-error            as logical no-undo.

    &IF "{&mguni_version}" < "2.07A" &THEN
    /* Validaá∆o - Empresa */
    if tt-param.i-empresa-ems2 = ? or
       tt-param.i-empresa-ems2 = 0 
    then do:
        run pi-cria-tt-erros-sped(input 17006, 
                                  input "Empresa deve ser informada",
                                  input no,
                                  input "").
        return "nok".
    end.
    
    if not can-find (first empresa no-lock
                     where empresa.ep-codigo = tt-param.i-empresa-ems2) 
    then do:
        run pi-cria-tt-erros-sped(input 34479,
                                  input tt-param.i-empresa-ems2,
                                  input no,
                                  input "").
        return "nok".
    end.
    &ENDIF
    
    /* Validaá∆o - Periodos */
    if tt-param.dt-fim < tt-param.dt-fim then do:
        run pi-cria-tt-erros-sped(input 31814, 
                                  input "",
                                  input no,
                                  input "").
        return "nok".
    end.
    
    /* Validaá∆o - M¢dulos selecionados 
    if tt-param.c-diario = "diarioauxiliar" then do:
        if (tt-param.l-ems5-caixa-bancos = no and
            tt-param.l-ems5-contas-pagar = no and
            tt-param.l-ems5-contas-receber = no and
            tt-param.l-ems5-ativo-fixo = no and
            tt-param.l-ems5-aplic-emprest = no and
            tt-param.l-ems5-hrb = no and
            tt-param.l-ems5-hpp = no and
            tt-param.l-ems5-hfp = no and
            tt-param.l-ems2-estoque = no and
            tt-param.l-ems2-faturamento = no and
            tt-param.l-ems2-caixa-bancos = no and
            tt-param.l-ems2-contas-pagar = no and
            tt-param.l-ems2-contas-receber = no and
            tt-param.l-ems2-patrimonio = no AND
            tt-param.l-ems2-mri = no) then do:
            run pi-cria-tt-erros-sped(input 34295, 
                                      input "",
                                      input no,
                                      input "").
            return "nok".
        end.
    end.
                                        */
    /*if tt-param.c-diario = "diarioauxiliar" and
       tt-param.l-ems2-patrimonio and
       tt-param.c-contabilidade = "ems2" then do:
        def var l-sem-movto as logical no-undo.
        run pi-verifica-movto-patrimonio(output l-sem-movto).
        if l-sem-movto then do:
            create tt-log-advertencias-sped.
            assign tt-log-advertencias-sped.num-cod-erro = 30919
                   tt-log-advertencias-sped.des-erro = "Patrimonio". 
        end.
    end. unificaÁ„o*/

    /* Verifica a existància das APIs de extraá∆o */
    if tt-param.c-diario = "diarioauxiliar" then do:
        if tt-param.l-ems2-contas-pagar then do:
            if search("app/apapi707.p") = ? and
               search("app/apapi707.r") = ? then
                run pi-cria-tt-erros-sped(input 36368, 
                                          input "Contas a Pagar~~app/apapi707.r",
                                          input no,
                                          input "").
                   
        end.
        if tt-param.l-ems2-caixa-bancos then do:
            if search("cbp/cbapi503.p") = ? and
               search("cbp/cbapi503.r") = ? then
                run pi-cria-tt-erros-sped(input 36368, 
                                          input "Caixa e Bancos~~cbp/cbapi503.r",
                                          input no,
                                          input "").
        end.
        if tt-param.l-ems2-contas-receber then do:
            if search("crp/crapi802.p") = ? and
               search("crp/crapi802.r") = ? then
                run pi-cria-tt-erros-sped(input 36368, 
                                          input "Contas a Receber~~crp/crapi802.r",
                                          input no,
                                          input "").
        end.
        if tt-param.l-ems2-estoque then do:
            if search("cep/ceapi309.p") = ? and
               search("cep/ceapi309.r") = ? then
                run pi-cria-tt-erros-sped(input 36368, 
                                          input "Estoque~~cep/ceapi309.r",
                                          input no,
                                          input "").
        end.
        if tt-param.l-ems2-faturamento then do:
            if search("ftp/ftapi600.p") = ? and
               search("ftp/ftapi600.r") = ? then
                run pi-cria-tt-erros-sped(input 36368, 
                                          input "Faturamento~~ftp/ftapi600.r",
                                          input no,
                                          input "").
        end.
        
        if tt-param.l-ems2-mri then do:
            if search("rip/riapi016.p") = ? and
               search("rip/riapi016.r") = ? then
                run pi-cria-tt-erros-sped(input 36368, 
                                          input "MÛdulo de RecuperaÁ„o de Impostos~~trp/trapi003.r",
                                          input no,
                                          input "").
        end.

        if can-find(first tt-log-erros-sped) then
            return "nok".
    end.
    
    if tt-param.l-demonstrativo then do:
        if trim(tt-param.c-balanco) = "" or
           trim(tt-param.c-demonstracao) = "" then do:
            run pi-cria-tt-erros-sped(input 34535, 
                                      input "",
                                      input no,
                                      input "").
            return "nok".
        end.

        run pi-is-integer(input tt-param.c-balanco).
        if return-value = "false" then
            assign i-demonst-balanco = 0.
        else
            assign i-demonst-balanco = int(tt-param.c-balanco).

        run pi-is-integer(input tt-param.c-demonstracao).
        if return-value = "false" then
            assign i-demonst-restdo = 0.
        else
            assign i-demonst-restdo = int(tt-param.c-demonstracao).

        if not can-find(first demonstra
                        where demonstra.de-codigo = i-demonst-balanco) then do:
            run pi-cria-tt-erros-sped(input 34536, 
                                      input string(tt-param.c-balanco + "~~" + "EMS 2"),
                                      input no,
                                      input "").
            return "nok".
        end.

        if not can-find(first demonstra
                        where demonstra.de-codigo = i-demonst-restdo) then do:
            run pi-cria-tt-erros-sped(input 34536, 
                                      input string(tt-param.c-demonstracao + "~~" + "EMS 2"),
                                      input no,
                                      input "").
            return "nok".
        end.

    end.
    
    return "ok".

end procedure.
/***************************************************************************************************/
/*
 * Procedure que busca parÉmetros de filtro de estabelecimento
 * Chamado: TDLMHE
 */
PROCEDURE pi-estab-range:
    ASSIGN v_log_epc = NO
           v_cod_estab_ini = ''
           v_cod_estab_fim = 'ZZZZZ'.

    if c-nom-prog-upc-mg97  <> ""
    or c-nom-prog-dpc-mg97  <> ""
    or c-nom-prog-appc-mg97 <> "" then do:

       for each tt-epc
           where tt-epc.cod-event = "estab-range" exclusive-lock:
           delete tt-epc.
       end.

       create tt-epc.
       assign tt-epc.cod-event     = "estab-range":u
              tt-epc.cod-parameter = "estab-ini":u
              tt-epc.val-parameter = "".

       create tt-epc.
       assign tt-epc.cod-event     = "estab-range":u
              tt-epc.cod-parameter = "estab-fim":u
              tt-epc.val-parameter = "ZZZZZ".

       create tt-epc.
       assign tt-epc.cod-event     = "estab-range":u
              tt-epc.cod-parameter = "log-epc":u
              tt-epc.val-parameter = 'no':u.

       {include/i-epc201.i "estab-range"}

       FIND FIRST tt-epc WHERE tt-epc.cod-parameter = "log-epc" NO-ERROR.

       IF AVAIL tt-epc THEN DO:
           /* if log-epc = 'yes':u */
           IF tt-epc.val-parameter = 'yes':u THEN DO:
               ASSIGN v_log_epc = YES.
               
               FIND FIRST tt-epc WHERE tt-epc.cod-parameter = "estab-ini" NO-ERROR.
               IF AVAIL tt-epc THEN DO:
                   ASSIGN v_cod_estab_ini = string(tt-epc.val-parameter).

                   FIND FIRST tt-epc WHERE tt-epc.cod-parameter = "estab-fim" NO-ERROR.
                   IF AVAIL tt-epc THEN 
                       ASSIGN v_cod_estab_fim = string(tt-epc.val-parameter).
                   ELSE
                       ASSIGN v_log_epc = NO.
               END.
               ELSE
                   ASSIGN v_log_epc = NO.

           END. /* log-epc = 'yes':u */
           ELSE
               ASSIGN v_log_epc = NO.
       END. /* avail tt-epc log-epc */
       ELSE
           ASSIGN v_log_epc = NO.
    END.

    for each tt-epc
        where tt-epc.cod-event = "estab-range" exclusive-lock:
        delete tt-epc.
    END.
END PROCEDURE.
/***************************************************************************************************/
procedure pi-extrator-sped-main-ems2:

    define variable c-modulos-sel as char    no-undo.
    define variable c-modulo      as char    no-undo.
    define variable i-cont        as integer no-undo.
    define variable h-lfapi074    as handle  no-undo.
    define variable c-desc-modulo as char    no-undo.
    define variable c-param       as char    no-undo.
    define variable l-data-faixa  as logical initial no no-undo.
    define variable c-conta-lucros-perdas as char no-undo.
 
    RUN pi-estab-range.

    /* Temp utilizada para melhoria de performance */
    /*for each rel-conta no-lock:
        create tt-rel-conta.
        buffer-copy rel-conta to tt-rel-conta.
    end. unificaÁ„o*/
       
    if tt-param.c-diario = "diariogeral" and
       tt-param.c-contabilidade = "ems2" then do:

        /*{utp/ut-liter.i Extraindo_Plano_de_Contas *}
        run pi-acompanhar in h-acomp (input return-value).
        run pi-extrair-cta-ctbl.

        /* Extraá∆o - Lanáamentos cont†beis di†rio geral*/
        {utp/ut-liter.i Extraindo_Lanáamentos *}
        run pi-acompanhar in h-acomp (input return-value).
        run pi-extrair-lancamento-contabil-geral.

        /* Extraá∆o - Saldos cont†beis di†rio geral*/
        {utp/ut-liter.i Extraindo_Saldos *}
        run pi-acompanhar in h-acomp (input return-value).
        run pi-extrair-saldo-contabil-geral.

        /* caso n∆o retorne saldo/movimento nas contas, n∆o deve gerar os arquivos */
        find first tt-dwf-sdo-ctbl no-error.
        if not avail tt-dwf-sdo-ctbl then do:
            run pi-cria-tt-erros-sped(input 34413,
                                      input '',
                                      input no,
                                      input "").
            return.
        end. unificaÁ„o*/

    end.
    else if tt-param.c-diario = "diarioauxiliar" then do:
        
        /* Monta tt com o plano de contas mas n∆o salva a extraá∆o.
           TT utilizada para l¢gica recursiva de preenchimento do saldo das contas sintÇticas */
        {utp/ut-liter.i Extraindo_Lanáamentos *}
        run pi-acompanhar in h-acomp (input return-value).
        run pi-extrair-lancamento-contabil-auxiliar.
    end.

    /* A VALIDACAO DA MATRIZ DE TRADUCAO DEVE SER FEITA SOMENTE QUANDO A EXTRACAO FOR PARA O DIARIO GERAL,
       POIS O NOVO PROCESSO DE EXTRACAO DE DADOS OBRIGA QUE O DIARIO GERAL SEJA GERADO ANTES DO AUXILIAR,
       O QUE DISPENSA UMA NOVA VALIDACAO DAS CONTAS. */
    if tt-param.c-diario = "diariogeral" and
       tt-param.c-contabilidade = "ems2" then do:

        /* Valida DE-PARA do Plano de Contas Referencial */
        /*for each tt-dwf-sdo-ctbl:
    
            find first tt-dwf-cta-ctbl
                where tt-dwf-cta-ctbl.cod-empresa = tt-dwf-sdo-ctbl.cod-empresa
                  and tt-dwf-cta-ctbl.cdn-empresa = tt-dwf-sdo-ctbl.cdn-empresa
                  and tt-dwf-cta-ctbl.cod-cta-ctbl = tt-dwf-sdo-ctbl.cod-cta-ctbl
                no-lock no-error.
    
            if not avail tt-dwf-cta-ctbl then next.
    
            if tt-dwf-cta-ctbl.ind-espec-cta-ctbl <> "Anal°tica" then 
                next.            
    
            /* Verifica se a conta est† cadastrada no DE-PARA do plano referencial */
            find first cta-ctbl-refer
                where cta-ctbl-refer.cdn-empresa = tt-param.i-empresa-ems2
                  and cta-ctbl-refer.cod-conta = tt-dwf-cta-ctbl.cod-cta-ctbl
                  and cta-ctbl-refer.dat-valid-inic <= tt-dwf-sdo-ctbl.dat-livre-1
                  and cta-ctbl-refer.dat-valid-fim  >= tt-dwf-sdo-ctbl.dat-livre-2
                no-lock no-error.
            if avail cta-ctbl-refer then do:
    
                if not can-find(first tt-dwf-cta-ctbl-refer
                                where tt-dwf-cta-ctbl-refer.cod-empresa = tt-dwf-cta-ctbl.cod-empresa
                                  and tt-dwf-cta-ctbl-refer.cod-cta-ctbl = tt-dwf-cta-ctbl.cod-cta-ctbl
                                  and tt-dwf-cta-ctbl-refer.cod-ccusto = ""
                                  and tt-dwf-cta-ctbl-refer.dat-inic-period = cta-ctbl-refer.dat-valid-inic
                                  and tt-dwf-cta-ctbl-refer.dat-fim-period = cta-ctbl-refer.dat-valid-fim) then do:
    
                    create tt-dwf-cta-ctbl-refer.
                    assign tt-dwf-cta-ctbl-refer.cod-empresa        = tt-dwf-cta-ctbl.cod-empresa
                           tt-dwf-cta-ctbl-refer.cod-cta-ctbl-refer = cta-ctbl-refer.cod-cta-refer
                           tt-dwf-cta-ctbl-refer.cod-ccusto         = ""
                           tt-dwf-cta-ctbl-refer.cod-estab          = ""
                           tt-dwf-cta-ctbl-refer.cod-cta-ctbl       = cta-ctbl-refer.cod-conta
                           tt-dwf-cta-ctbl-refer.dat-inic-period    = cta-ctbl-refer.dat-valid-inic
                           tt-dwf-cta-ctbl-refer.dat-fim-period     = cta-ctbl-refer.dat-valid-fim
                           tt-dwf-cta-ctbl-refer.dat-inic-valid     = dat-today
                           tt-dwf-cta-ctbl-refer.dat-fim-valid      = ?
                           tt-dwf-cta-ctbl-refer.ind-natur-cta-ctbl = string(cta-ctbl-refer.idi-natur-cta-ctbl,"99")
                           tt-dwf-cta-ctbl-refer.cod-produto        = "ems2"
                           tt-dwf-cta-ctbl-refer.cod-unid-neg       = ""
                           .
                end.
                
                if cta-ctbl-refer.idi-natur-cta-ctbl <> 4 then do:
                    assign c-conta-lucros-perdas = "".

                    find empresa where empresa.ep-codigo = tt-param.i-empresa-ems2 no-lock no-error.
                
                    if avail empresa then
                        assign c-conta-lucros-perdas = empresa.conta-lucros-perdas.

                    assign tt-param.c-conta-lucros-perdas = c-conta-lucros-perdas.

                    if cta-ctbl-refer.cod-conta <> c-conta-lucros-perdas then do:

                        for each tt_period:

                            if can-find(first tt-dwf-sdo-ctbl-antes-encert
                                        where tt-dwf-sdo-ctbl-antes-encert.cod-empresa       = tt-dwf-cta-ctbl.cod-empresa
                                          and tt-dwf-sdo-ctbl-antes-encert.cod-estab         = ""
                                          and tt-dwf-sdo-ctbl-antes-encert.cod-modul-dtsul   = tt-dwf-sdo-ctbl.cod-modul-dtsul
                                          and tt-dwf-sdo-ctbl-antes-encert.dat-apurac-restdo = tt_period.ttv_dat_fim_param
                                          and tt-dwf-sdo-ctbl-antes-encert.cod-cta-ctbl      = tt-dwf-sdo-ctbl.cod-cta-ctbl 
                                          and tt-dwf-sdo-ctbl-antes-encert.cod-ccusto        = "") then do:
    
                                assign c-param = tt-dwf-sdo-ctbl.cod-cta-ctbl + "~~" + string(cta-ctbl-refer.idi-natur-cta-ctbl,"99").
    
                                run pi-cria-tt-erros-sped(input 35099, 
                                                          input c-param,
                                                          input no,
                                                          input tt-dwf-sdo-ctbl.cod-cta-ctbl).
    
                            end.  
                        end.
                        
                   end.
                end.                  
            end.
            else do:
                find first cta-ctbl-refer
                    where cta-ctbl-refer.cdn-empresa = tt-param.i-empresa-ems2
                      and cta-ctbl-refer.cod-conta = tt-dwf-cta-ctbl.cod-cta-ctbl
                    no-lock no-error.
                if avail cta-ctbl-refer then do:
                    run pi-cria-tt-erros-sped(input 35120,
                                              input tt-dwf-cta-ctbl.cod-cta-ctbl,
                                              input no,
                                              input tt-dwf-cta-ctbl.cod-cta-ctbl).
                end.
                else do:
                    run pi-cria-tt-erros-sped(input 35121,
                                              input tt-dwf-cta-ctbl.cod-cta-ctbl,
                                              input no,
                                              input tt-dwf-cta-ctbl.cod-cta-ctbl).
                end.
            end.
        end.

        for each tt-dwf-cta-ctbl:
    
            if tt-dwf-cta-ctbl.ind-espec-cta-ctbl <> "Anal°tica" then 
                next.            
    
            /* Verifica se a conta est† cadastrada no DE-PARA do plano referencial */
            find first cta-ctbl-refer
                where cta-ctbl-refer.cdn-empresa = tt-param.i-empresa-ems2
                  and cta-ctbl-refer.cod-conta = tt-dwf-cta-ctbl.cod-cta-ctbl
                  and cta-ctbl-refer.dat-valid-inic <= tt-param.dt-ini
                  and cta-ctbl-refer.dat-valid-fim  >= tt-param.dt-fim
                no-lock no-error.
    
            if avail cta-ctbl-refer then do:
    
                if not can-find(first tt-dwf-cta-ctbl-refer
                                where tt-dwf-cta-ctbl-refer.cod-empresa = tt-dwf-cta-ctbl.cod-empresa
                                  and tt-dwf-cta-ctbl-refer.cod-cta-ctbl = tt-dwf-cta-ctbl.cod-cta-ctbl
                                  and tt-dwf-cta-ctbl-refer.cod-ccusto = ""
                                  AND tt-dwf-cta-ctbl-refer.cod-unid-neg = ""
                                  and tt-dwf-cta-ctbl-refer.dat-inic-period = cta-ctbl-refer.dat-valid-inic
                                  and tt-dwf-cta-ctbl-refer.dat-fim-period = cta-ctbl-refer.dat-valid-fim) then do:
    
                    create tt-dwf-cta-ctbl-refer.
                    assign tt-dwf-cta-ctbl-refer.cod-empresa        = tt-dwf-cta-ctbl.cod-empresa
                           tt-dwf-cta-ctbl-refer.cod-cta-ctbl-refer = cta-ctbl-refer.cod-cta-refer
                           tt-dwf-cta-ctbl-refer.cod-ccusto         = ""
                           tt-dwf-cta-ctbl-refer.cod-estab          = ""
                           tt-dwf-cta-ctbl-refer.cod-cta-ctbl       = cta-ctbl-refer.cod-conta
                           tt-dwf-cta-ctbl-refer.dat-inic-period    = cta-ctbl-refer.dat-valid-inic
                           tt-dwf-cta-ctbl-refer.dat-fim-period     = cta-ctbl-refer.dat-valid-fim
                           tt-dwf-cta-ctbl-refer.dat-inic-valid     = dat-today
                           tt-dwf-cta-ctbl-refer.dat-fim-valid      = ?
                           tt-dwf-cta-ctbl-refer.ind-natur-cta-ctbl = string(cta-ctbl-refer.idi-natur-cta-ctbl,"99")
                           tt-dwf-cta-ctbl-refer.cod-produto        = "ems2" 
                           tt-dwf-cta-ctbl-refer.cod-unid-neg       = ""
                           .
                end.                                     
            end.
        end.

        run pi-extrair-estabelecimento.unificaÁ„o*/
    end.
end procedure.
/***************************************************************************************************/
/*procedure pi-extrair-lancamento-contabil-geral:

    define variable c-conta-lucros-perdas as char no-undo.
    define variable c-referencia       as char    no-undo.
    define variable c-ind-natur        as char    no-undo.
        
    find empresa where empresa.ep-codigo = tt-param.i-empresa-ems2 no-lock no-error.

    if  avail empresa then
        assign c-conta-lucros-perdas = empresa.conta-lucros-perdas.
                                                     
    for each movimento fields (ep-codigo
                               cod-estabel
                               data
                               valor
                               tipo
                               referencia
                               conta-contabil
                               seq-unica
                               historico
                               &IF "{&mgadm_version}" >= "2.09" &THEN
                               cdn-emitente-particip
                               &ELSE
                               int-1
                               &ENDIF
                               ) no-lock
        where movimento.ep-codigo   = tt-param.i-empresa-ems2
        and   movimento.data       >= tt-param.dt-ini
        and   movimento.data       <= tt-param.dt-fim
        and   movimento.valor       > 0:
                        
        IF v_log_epc THEN DO:
            IF movimento.cod-estabel < v_cod_estab_ini OR movimento.cod-estabel > v_cod_estab_fim THEN
                NEXT.
        END.

        assign c-ind-natur  = if(movimento.tipo = 1 or movimento.tipo = 3) then "D":U else "C":U
               c-referencia = (if movimento.referencia begins "|l/p" then
                                  substring(movimento.referencia,2,9) 
                               else  
                                  movimento.referencia).

        assign c-referencia = replace(c-referencia, "|", "/") + "/" + 
                              trim(movimento.cod-estabel) +  
                              string(month(movimento.data), '99') + 
                              substr(string(year(movimento.data)),3,2). /* Ano com 2 d°gitos para respeitar o tamanho do cod_lancto_ctbl */

        assign c-referencia = replace(c-referencia,"'","").
        assign c-referencia = replace(c-referencia,"`","").
        assign c-referencia = replace(c-referencia,"Ô","").
                    
        find first tt-dwf-lancto-ctbl use-index dwflnctc-id no-lock
             where tt-dwf-lancto-ctbl.cod-empresa      = string(movimento.ep-codigo)
             and   tt-dwf-lancto-ctbl.cdn-empresa      = movimento.ep-codigo
             and   tt-dwf-lancto-ctbl.cod-modul-dtsul  = "MCT":U
             and   tt-dwf-lancto-ctbl.cod-lote-ctbl    = trim(movimento.cod-estabel)
             and   tt-dwf-lancto-ctbl.cod-lancto-ctbl  = c-referencia
             and   tt-dwf-lancto-ctbl.dat-inic-valid   = dat-today
             no-error.
            
        if  not avail tt-dwf-lancto-ctbl then do:
            create tt-dwf-lancto-ctbl.
            assign tt-dwf-lancto-ctbl.cdn-empresa      = movimento.ep-codigo  
                   tt-dwf-lancto-ctbl.cod-empresa      = string(movimento.ep-codigo)
                   tt-dwf-lancto-ctbl.cod-modul-dtsul  = "MCT":U 
                   tt-dwf-lancto-ctbl.cod-lote-ctbl    = replace(trim(movimento.cod-estabel), "|", " ")
                   tt-dwf-lancto-ctbl.cod-lancto-ctbl  = replace(c-referencia, "|", " ")         
                   tt-dwf-lancto-ctbl.dat-inic-valid   = dat-today.

            assign tt-dwf-lancto-ctbl.dat-lancto-ctbl          = movimento.data
                   tt-dwf-lancto-ctbl.log-lancto-apurac-restdo = if movimento.referencia begins "|L/P":U then yes else no
                   tt-dwf-lancto-ctbl.ind-lancto-ctbl          = if tt-dwf-lancto-ctbl.log-lancto-apurac-restdo then "E":U else "N":U
                   tt-dwf-lancto-ctbl.dat-fim-valid            = ?.

            /* Salva o movimento de origem dos lanáamentos da contabilidade para o bloco I015 */
            if movimento.referencia BEGINS "AP" then 
                assign tt-dwf-lancto-ctbl.cod-livre-1 = "MAP".
            else if movimento.referencia BEGINS "CB" then
                assign tt-dwf-lancto-ctbl.cod-livre-1 = "MCB".
            else if movimento.referencia BEGINS "CR" then
                assign tt-dwf-lancto-ctbl.cod-livre-1 = "MCR".
            else if movimento.referencia BEGINS "PT" then
                assign tt-dwf-lancto-ctbl.cod-livre-1 = "MPT".
            else if movimento.referencia BEGINS "CE" then
                assign tt-dwf-lancto-ctbl.cod-livre-1 = "MCE".
            else if movimento.referencia BEGINS "FT" then
                assign tt-dwf-lancto-ctbl.cod-livre-1 = "MFT".
            else if movimento.referencia BEGINS "TR" then
                assign tt-dwf-lancto-ctbl.cod-livre-1 = "MTR".
            else
                assign tt-dwf-lancto-ctbl.cod-livre-1 = "MCT".
                   
        end.

        if  c-ind-natur = "C":U then
            assign tt-dwf-lancto-ctbl.val-lancto-ctbl = tt-dwf-lancto-ctbl.val-lancto-ctbl
                                                      + movimento.valor.
                
        /* apuraá∆o de resultados */
        if  c-conta-lucros-perdas <> "" then do:
            if (tt-dwf-lancto-ctbl.log-lancto-apurac-restdo = yes and 
                movimento.conta-contabil <> c-conta-lucros-perdas) then do:

                for first tt_period
                   where tt_period.ttv_num_mes = month(movimento.data)
                     and tt_period.ttv_num_ano = year(movimento.data):

                    if movimento.data <> tt_period.ttv_dat_fim_param then do:
                        run pi-cria-tt-erros-sped(input 36705, 
                                                  input string(movimento.data, '99/99/9999'),
                                                  input no,
                                                  input "").
                        return.
                    end.
                
                    find first tt-dwf-sdo-ctbl-antes-encert use-index dwfsdcta-id
                         where tt-dwf-sdo-ctbl-antes-encert.cod-empresa       = string(movimento.ep-codigo)
                         and   tt-dwf-sdo-ctbl-antes-encert.cod-estab         = ""
                         and   tt-dwf-sdo-ctbl-antes-encert.cod-modul-dtsul   = "MCT":U
                         and   tt-dwf-sdo-ctbl-antes-encert.dat-apurac-restdo = tt_period.ttv_dat_fim_param
                         and   tt-dwf-sdo-ctbl-antes-encert.cod-cta-ctbl      = movimento.conta-contabil
                         and   tt-dwf-sdo-ctbl-antes-encert.cod-ccusto        = ""
                         and   tt-dwf-sdo-ctbl-antes-encert.dat-inic-valid    = dat-today 
                         no-error.

                    if  not avail(tt-dwf-sdo-ctbl-antes-encert) then do:
                        create tt-dwf-sdo-ctbl-antes-encert.
                        assign tt-dwf-sdo-ctbl-antes-encert.cod-empresa       = string(movimento.ep-codigo)
                               tt-dwf-sdo-ctbl-antes-encert.cod-estab         = ""
                               tt-dwf-sdo-ctbl-antes-encert.cod-cta-ctbl      = movimento.conta-contabil
                               tt-dwf-sdo-ctbl-antes-encert.cod-ccusto        = ""
                               tt-dwf-sdo-ctbl-antes-encert.cod-modul-dtsul   = "MCT":U
                               tt-dwf-sdo-ctbl-antes-encert.dat-apurac-restdo = tt_period.ttv_dat_fim_param
                               tt-dwf-sdo-ctbl-antes-encert.dat-inic-valid    = dat-today 
                               tt-dwf-sdo-ctbl-antes-encert.dat-fim-valid     = ?
                               tt-dwf-sdo-ctbl-antes-encert.val-sdo-ctbl-fim-antes-encert = 0.
                    end.

                    if c-ind-natur = "D" then 
                        assign tt-dwf-sdo-ctbl-antes-encert.val-sdo-ctbl-fim-antes-encert = tt-dwf-sdo-ctbl-antes-encert.val-sdo-ctbl-fim-antes-encert -
                                                                                            movimento.valor.
                    else
                        assign tt-dwf-sdo-ctbl-antes-encert.val-sdo-ctbl-fim-antes-encert = tt-dwf-sdo-ctbl-antes-encert.val-sdo-ctbl-fim-antes-encert +
                                                                                            movimento.valor.
                    release tt-dwf-sdo-ctbl-antes-encert.
                end.
            end.
        end.
        
        create tt-dwf-item-lancto-ctbl.
        assign tt-dwf-item-lancto-ctbl.cod-lote-ctbl          = replace(tt-dwf-lancto-ctbl.cod-lote-ctbl, "|", " ")
               tt-dwf-item-lancto-ctbl.cod-lancto-ctbl        = replace(c-referencia, "|", " ")
               tt-dwf-item-lancto-ctbl.num-seq-lancto-ctbl    = movimento.seq-unica 
               tt-dwf-item-lancto-ctbl.cdn-empresa            = movimento.ep-codigo
               tt-dwf-item-lancto-ctbl.cod-empresa            = string(movimento.ep-codigo)
               tt-dwf-item-lancto-ctbl.cod-modul-dtsul        = "MCT":U
               tt-dwf-item-lancto-ctbl.cod-estab              = trim(movimento.cod-estabel)
               tt-dwf-item-lancto-ctbl.cod-cta-ctbl           = movimento.conta-contabil
               tt-dwf-item-lancto-ctbl.cod-ccusto             = ""
               tt-dwf-item-lancto-ctbl.ind-natur-lancto-ctbl  = c-ind-natur
               tt-dwf-item-lancto-ctbl.val-lancto-ctbl        = movimento.valor
               /*Rodrigo - ATV236239*/
               tt-dwf-item-lancto-ctbl.des-histor-lancto-ctbl = if movimento.historico <> ? AND trim(movimento.historico) <> "" then
                                                                    replace(movimento.historico,"|"," ")
                                                                else
                                                                    "(Aut) - Movimento Cont†bil do dia " + string(movimento.data, "99/99/9999")
               /*Rodrigo - ATV236239*/
               tt-dwf-item-lancto-ctbl.cod-arq-lancto-ctbl    = if movimento.referencia begins "|L/P" then 
                                                                   replace(substring(movimento.referencia,2,9), "|", " ") 
                                                                else 
                                                                   replace(movimento.referencia, "|", " ")
               tt-dwf-item-lancto-ctbl.dat-livre-1            = movimento.data
               tt-dwf-item-lancto-ctbl.dat-inic-valid         = dat-today
               tt-dwf-item-lancto-ctbl.dat-fim-valid          = ?
               tt-dwf-item-lancto-ctbl.cod-arq-lancto-ctbl = replace(tt-dwf-item-lancto-ctbl.cod-arq-lancto-ctbl, "|", " ").

        run pi-registra-empresa-utilizada (input tt-dwf-item-lancto-ctbl.cod-empresa,
                                           input tt-dwf-item-lancto-ctbl.cdn-empresa).

        if tt-param.l-relaciona-lancto-participante = yes then do:
            /* procura na tabela relacto-lancto na data */
            &IF "{&mgadm_version}" >= "2.09" &THEN
            if movimento.cdn-emitente-particip <> 0 then do:
                assign tt-dwf-item-lancto-ctbl.cod-participan = string(movimento.cdn-emitente-particip).
            end.
            else do:
                find first relacto-lancto-particip no-lock
                    where relacto-lancto-particip.cdn-empresa          = movimento.ep-codigo
                      and relacto-lancto-particip.cod-modul            = "MCT"
                      and relacto-lancto-particip.cod-lancto-contab    = string(movimento.seq-unica) no-error.
                if avail relacto-lancto-particip then
                    assign tt-dwf-item-lancto-ctbl.cod-participan = string(relacto-lancto-particip.cdn-emitente-particip).
            end.
            &ELSE
            if movimento.int-1 <> 0 then do:
                assign tt-dwf-item-lancto-ctbl.cod-participan = string(movimento.int-1).
            end.
            else do:
                find first tab-livre-movfis no-lock
                    where tab-livre-movfis.cod-modul-dtsul      = "MCT"
                      and tab-livre-movfis.cod-tab-dic-dtsul    = "relacto-lancto-particip"
                      and tab-livre-movfis.cod-compon-1-idx-tab = string(movimento.ep-codigo)
                      and tab-livre-movfis.cod-compon-2-idx-tab = string(movimento.seq-unica) no-error.
                if avail tab-livre-movfis then
                    assign tt-dwf-item-lancto-ctbl.cod-participan = tab-livre-movfis.cod-livre-1.
            end.
            &ENDIF
        end.
    end.

end procedure. unificaÁ„o*/

/***************************************************************************************************/
procedure pi-extrair-lancamento-contabil-auxiliar:
    
    define variable c-ano-periodo        as char    no-undo.
    define variable c-cod-lote-ctbl      as char    no-undo.
    define variable c-cod-lancto-ctbl    as char    no-undo.
    define variable c-modulos            as char    no-undo.
    define variable i-count              as int     no-undo.
    define variable c-arq-dump           as char    no-undo.

    define variable l-lancto-ctbl-create as logical no-undo.
    define variable h-api                as handle no-undo.

    if not valid-handle(h-hex64) then
        if search('utp/ut-hex64.r') <> ? then
            run utp/ut-hex64.r persistent set h-hex64.

    for each tt-movimentos-sped-ems2:
        delete tt-movimentos-sped-ems2.
    end.


/* ** Importaá∆o lanáamentos GKO ***/
        DEFINE VARIABLE v-cod-linha      AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE v-cod-arq-origem AS CHARACTER   NO-UNDO.

        /*************************************************************************************************************/

        /* Identificar arquivo origem do GKO para SPED */
        FOR FIRST ponto-programa
            WHERE ponto-programa.nome-programa = "gk0007"
              AND ponto-programa.ponto         = 1,
             EACH conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

            IF  conteudo-programa.conteudo                  <> "" AND
                NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
            THEN DO:
                IF  OPSYS = "WIN32"
                THEN DO:
                    IF  ENTRY(1,conteudo-programa.conteudo,";") = "ARQSPEDGKOWIN32"
                    THEN
                        ASSIGN v-cod-arq-origem = ENTRY(2,conteudo-programa.conteudo,";").
                END.
                ELSE DO:
                    IF  ENTRY(1,conteudo-programa.conteudo,";") = "ARQSPEDGKOUNIX"
                    THEN
                        ASSIGN v-cod-arq-origem = ENTRY(2,conteudo-programa.conteudo,";").
                END.
            END.
        END.

        ASSIGN v-cod-arq-origem = "C:\temp\sped.CSV".

        DEF VAR a AS INT.

        EMPTY TEMP-TABLE tt-importa-movto-gko.

        INPUT FROM VALUE(v-cod-arq-origem) CONVERT SOURCE "iso8859-1".

        REPEAT:
            IMPORT UNFORMATTED v-cod-linha.
            ASSIGN v-cod-linha = REPLACE(v-cod-linha,'"',"").

            CREATE tt-importa-movto-gko.
            ASSIGN tt-importa-movto-gko.cgc-intelbras = ENTRY(1,v-cod-linha,";")
                   tt-importa-movto-gko.cgc-transp    = ENTRY(2,v-cod-linha,";")
                   tt-importa-movto-gko.cod-nota      = ENTRY(3,v-cod-linha,";")
                   tt-importa-movto-gko.cod-serie     = ENTRY(4,v-cod-linha,";")
                   tt-importa-movto-gko.cod-ctrc      = ENTRY(5,v-cod-linha,";")
                   tt-importa-movto-gko.cod-fatura    = ENTRY(6,v-cod-linha,";")
                   tt-importa-movto-gko.cod-conta     = ENTRY(7,v-cod-linha,";")
                   tt-importa-movto-gko.cod-ccusto    = ENTRY(8,v-cod-linha,";")
                   tt-importa-movto-gko.des-conta     = ENTRY(9,v-cod-linha,";")
                   tt-importa-movto-gko.val-credito   = DEC(ENTRY(10,v-cod-linha,";"))
                   tt-importa-movto-gko.val-debito    = DEC(ENTRY(11,v-cod-linha,";"))
                   tt-importa-movto-gko.des-movto     = ENTRY(12,v-cod-linha,";")
                   tt-importa-movto-gko.dat-movto     = DATE(ENTRY(13,v-cod-linha,";")).

            FIND FIRST estabelec NO-LOCK
                WHERE  estabelec.cgc = tt-importa-movto-gko.cgc-intelbras NO-ERROR.

            IF  AVAIL estabelec
            THEN
                ASSIGN tt-importa-movto-gko.cod-estabel = estabelec.cod-estabel.

            FIND FIRST emitente NO-LOCK
                WHERE  emitente.cgc = tt-importa-movto-gko.cgc-transp NO-ERROR.

            IF  AVAIL emitente
            THEN
                 tt-importa-movto-gko.cod-emitente = emitente.cod-emitente.

            ASSIGN a = a + 1.

        END.

        INPUT CLOSE.

        MESSAGE a
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        DEFINE VARIABLE v_sc-codigo      AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE v_cod-unid-negoc AS CHARACTER   NO-UNDO.

        FOR EACH tt-importa-movto-gko:

            ASSIGN v_sc-codigo      = ""
                   v_cod-unid-negoc = "".
            
            IF tt-importa-movto-gko.cod-ccusto <> "" 
            THEN DO:
                 ASSIGN v_sc-codigo      = SUBSTRING(tt-importa-movto-gko.cod-ccusto, 4, 5)
                        v_cod-unid-negoc = SUBSTRING(tt-importa-movto-gko.cod-ccusto, 1, 3).
                 FIND unid_negoc NO-LOCK
                     WHERE unid_negoc.cdn_unid_negoc = INT(v_cod-unid-negoc) NO-ERROR.
                 IF AVAIL unid_negoc 
                    THEN ASSIGN v_cod-unid-negoc = unid_negoc.cod_unid_negoc.
                 IF v_sc-codigo = "00000" 
                    THEN ASSIGN v_sc-codigo = "".
            END.


            CREATE tt-movimentos-SPED-ems2.
            ASSIGN tt-movimentos-SPED-ems2.ep-codigo         = i-ep-codigo-usuario
                   tt-movimentos-SPED-ems2.cod-estabel       = tt-importa-movto-gko.cod-estabel
                   tt-movimentos-SPED-ems2.ano-periodo       = STRING(STRING(YEAR(tt-importa-movto-gko.dat-movto), "9999") + "/" + STRING(MONTH(tt-importa-movto-gko.dat-movto), "99"))
                   tt-movimentos-SPED-ems2.cod-emitente      = tt-importa-movto-gko.cod-emitente
                   tt-movimentos-SPED-ems2.ct-codigo         = tt-importa-movto-gko.cod-conta
                   tt-movimentos-SPED-ems2.sc-codigo         = v_sc-codigo
                   tt-movimentos-SPED-ems2.cod-unid-negoc    = v_cod-unid-negoc
                  /* tt-movimentos-SPED-ems2.conta-contabil    = tt-importa-movto-gko.cod-conta + tt-importa-movto-gko.cod-ccusto*/
                   tt-movimentos-SPED-ems2.data              = tt-importa-movto-gko.dat-movto
                   tt-movimentos-SPED-ems2.valor             = IF tt-importa-movto-gko.val-credito <> 0 THEN tt-importa-movto-gko.val-credito ELSE tt-importa-movto-gko.val-debito
                   tt-movimentos-SPED-ems2.transacao         = IF tt-importa-movto-gko.val-credito <> 0 THEN 2 ELSE 1
                   tt-movimentos-SPED-ems2.num-arquivamento  = ""
                   tt-movimentos-SPED-ems2.contra-partida    = ""
                   tt-movimentos-SPED-ems2.cod-modul         = "TRP"
                   tt-movimentos-SPED-ems2.cod-lancto-contab = STRING(ROWID(tt-importa-movto-gko))
                   tt-movimentos-SPED-ems2.cod-unid-negoc    = ""
                   tt-movimentos-SPED-ems2.historico         = tt-importa-movto-gko.des-movto + " # "
                                                             + " Nota/Ser: " + tt-importa-movto-gko.cod-nota + "/" + tt-importa-movto-gko.cod-serie + " # "
                                                             + " CTRC: "     + tt-importa-movto-gko.cod-ctrc + " # "
                                                             + " Fatura: "   + tt-importa-movto-gko.cod-fatura. 

            ASSIGN a = a + 1.

        END.

        MESSAGE a
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        run pi-limpa-return-value.
        run pi-verifica-movimentos-apis(input 'MTR,TRP').

    run pi-retorna-modulos-selecionados.
    assign c-modulos = return-value.
    
    ASSIGN c-arquivo-log = "c:\temp\lancto-gko.txt".

    MESSAGE c-arquivo-log
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    /* Se o extrato de vers∆o estiver ativo, fazer um dump da tt-movimentos-sped-ems2 */
    if c-arquivo-log <> "" then do:
        run pi-retorna-nome-dump (output c-arq-dump).

        MESSAGE c-arq-dump
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        output stream s-dump to value(c-arq-dump).
        put stream s-dump unformatted 'EMPRESA ESTAB  ANO PERIODO CONTA CONTµBIL    CONTA           SUB CONTA DATA       VALOR              TRANSAÄ«O NUMERO ARQUIVAMENTO EMIENTE   CONTRA PARTIDA       LANCAMENTO CTBL      UNIDADE DE NEG‡CIO M‡DULO HIST‡RICO                                 ' skip.
        put STREAM s-dump UNFORMATTED '------- ------ ----------- ----------------- --------------- --------- ---------- ------------------ --------- ------------------- --------- -------------------- -------------------- ------------------ ------ ------------------------------------------' skip.
        FOR EACH tt-movimentos-sped-ems2:
            put STREAM s-dump unformatted tt-movimentos-sped-ems2.ep-codigo   AT 1
                        tt-movimentos-sped-ems2.cod-estabel                   AT 9
                        tt-movimentos-sped-ems2.ano-periodo                   AT 16
                        tt-movimentos-sped-ems2.conta-contabil                AT 28
                        tt-movimentos-sped-ems2.ct-codigo                     AT 46
                        tt-movimentos-sped-ems2.sc-codigo                     AT 62
                        tt-movimentos-sped-ems2.data                          AT 72
                        tt-movimentos-sped-ems2.valor                         AT 83
                        tt-movimentos-sped-ems2.transacao                     AT 102
                        tt-movimentos-sped-ems2.num-arquivamento              AT 112
                        tt-movimentos-sped-ems2.cod-emitente                  AT 132
                        tt-movimentos-sped-ems2.contra-partida                AT 142
                        tt-movimentos-sped-ems2.cod-lancto-contab             AT 163
                        tt-movimentos-sped-ems2.cod-unid-negoc                AT 184
                        tt-movimentos-sped-ems2.cod-modul                     AT 203
                        tt-movimentos-sped-ems2.historico                     AT 210.
        END.
        output stream s-dump close.
    end.
    
    /* Quando a contabilidade estiver no EMS 5, Ç necessario executar a rotina de integraá∆o, para
       traduzir as informaá‰es de acordo com a matriz de traduá∆o */
    if tt-param.c-contabilidade = "ems5" then do:
        run pi-integracao-diario-auxiliar-ems2-ems5.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-acerta-debito-credito:

    define input-output param d-valor        as decimal no-undo.
    define output       param c-ind-sdo-ctbl as char    no-undo.

    if d-valor < 0 then do:
        assign d-valor = d-valor * -1.
               c-ind-sdo-ctbl = "C".
    end.
    else 
        assign c-ind-sdo-ctbl = "D".

end procedure.
/***************************************************************************************************/
procedure pi-limpa-tts:

    for each tt-cta-ctbl-nivel:
        delete tt-cta-ctbl-nivel.
    end.
    for each tt-dwf-estab:
        delete tt-dwf-estab.
    end.
    for each tt-dwf-ender:
        delete tt-dwf-ender.
    end.
    for each tt-dwf-pessoa:
        delete tt-dwf-pessoa.
    end.
    for each tt-dwf-plano-ccusto:
        delete tt-dwf-plano-ccusto.
    end.
    for each tt-dwf-ccusto:
        delete tt-dwf-ccusto.
    end.
    for each tt-dwf-item-lancto-ctbl:
        delete tt-dwf-item-lancto-ctbl.
    end.
    for each tt-dwf-lancto-ctbl:
        delete tt-dwf-lancto-ctbl.
    end.
    for each tt-dwf-cta-ctbl:
        delete tt-dwf-cta-ctbl.
    end.
    for each tt-dwf-sdo-ctbl:
        delete tt-dwf-sdo-ctbl.
    end.
    for each tt-dwf-sdo-ctbl-antes-encert:
        delete tt-dwf-sdo-ctbl-antes-encert.
    end.
    for each tt-dwf-estab-extens:
        delete tt-dwf-estab-extens.
    end.
    for each tt-dwf-cta-ctbl-refer:
        delete tt-dwf-cta-ctbl-refer.
    end.

    for each tt-dwf-cta-aglut:
        delete tt-dwf-cta-aglut.
    end.
    for each tt-dwf-demonst-ctbl-bloco:
        delete tt-dwf-demonst-ctbl-bloco.
    end.
    for each tt-dwf-balan-patrim:
        delete tt-dwf-balan-patrim.
    end.
    for each tt-dwf-demonst-restdo-exerc:
        delete tt-dwf-demonst-restdo-exerc.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-salva-registros:
    
    {utp/ut-liter.i Buscando_Natureza_Conta_Cont†bil *}
    run pi-acompanhar in h-acomp (input return-value).

    run pi-busca-natur-cta-ctbl.

    {utp/ut-liter.i Extraindo_C¢digos_Aglutinaá∆o *}
    run pi-acompanhar in h-acomp (input return-value).

    run pi-extrair-codigo-aglutinacao.

    {utp/ut-liter.i Extraindo_Bloco_J *}
    run pi-acompanhar in h-acomp (input return-value).

    run pi-extrair-blocoj.

    if can-find(first tt-log-erros-sped) THEN DO:
        RETURN "nok". /*Coppi - 241.291*/
    END.
     

    run pi-exclui-dados-extraidos.

    /* Lanáamentos Cont†beis */
    RUN pi-bofi177.

    /* Itens dos Lanáamentos Cont†beis */
    RUN pi-bofi178.

    /* Saldos Cont†beis */
    RUN pi-bofi179.

    RUN pi-bofi297.

    /* Contas Cont†beis */
    RUN pi-bofi180.

    if (tt-param.l-balancete or tt-param.l-demonstrativo) then do:
        
        /* C¢digo Aglutinaá∆o */
        RUN pi-bofi318.

        /* Bloco J */
        RUN pi-bofi319.
        RUN pi-bofi320.
        RUN pi-bofi321.

    end.
    
    RUN pi-bofi298.

    /* Estabelecimento Extens∆o */
    RUN pi-bofi187.

    /* Plano Centro de Custo */
    RUN pi-bofi217.

    /* Centro de Custo */
    RUN pi-bofi181.

    /* Participantes */
    run pi-salva-participantes.
    
end procedure.
/***************************************************************************************************/
procedure pi-busca-natur-cta-ctbl:

    /*Hugo - Atv 244177*/
    DEF VAR v-natur        AS INT NO-UNDO.
    DEF VAR v-cod-cta-ctbl AS CHAR NO-UNDO.
    DEF VAR l-ok           AS LOG  NO-UNDO.
    /*Hugo fim - Atv 244177*/

    define buffer b-tt-dwf-cta-ctbl  for tt-dwf-cta-ctbl.
    
    /* Preenche a natureza das contas anal°ticas */
    for each tt-dwf-cta-ctbl
       where tt-dwf-cta-ctbl.cod-empresa = tt-param.c-empresa:
        find first tt-dwf-cta-ctbl-refer
            where tt-dwf-cta-ctbl-refer.cod-empresa = tt-dwf-cta-ctbl.cod-empresa
              and tt-dwf-cta-ctbl-refer.cod-cta-ctbl = tt-dwf-cta-ctbl.cod-cta-ctbl
            no-error.
        if avail tt-dwf-cta-ctbl-refer then
            assign tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl = int(tt-dwf-cta-ctbl-refer.ind-natur-cta-ctbl).
    end.

    /*Hugo - Atv 244177*/
    for each tt-dwf-cta-ctbl
       where tt-dwf-cta-ctbl.ind-tip-cta-ctbl = "S"
         and tt-dwf-cta-ctbl.cod-cta-ctbl-sup = "":
     
        ASSIGN v-natur = 0    
               v-cod-cta-ctbl = ""
               l-ok = NO.

        RUN pi-valida-natur(INPUT tt-dwf-cta-ctbl.cod-cta-ctbl,
                            INPUT tt-dwf-cta-ctbl.cod-cta-ctbl,
                            INPUT-OUTPUT v-natur,
                            INPUT-OUTPUT v-cod-cta-ctbl,
                            INPUT-OUTPUT l-ok).

        ASSIGN l-ok = NO.
    
        RUN pi-valida-natur(INPUT tt-dwf-cta-ctbl.cod-cta-ctbl,
                            INPUT tt-dwf-cta-ctbl.cod-cta-ctbl,
                            INPUT-OUTPUT v-natur,
                            INPUT-OUTPUT v-cod-cta-ctbl,
                            INPUT-OUTPUT l-ok).
                
    END.
    /*Hugo fim - Atv 244177*/

    /* Zera a natureza das contas sintÇticas */
    for each tt-dwf-cta-ctbl
       where tt-dwf-cta-ctbl.ind-tip-cta-ctbl = "S":
        assign tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl = 0.
    end.

    /* Preenche a natureza das contas sintÇticas de acordo com a natureza 
       da primeira conta filha */
    for each tt-dwf-cta-ctbl
       where tt-dwf-cta-ctbl.ind-tip-cta-ctbl = "S"
         and tt-dwf-cta-ctbl.cod-cta-ctbl-sup = "":

        run pi-busca-natur-cta-ctbl-filhas (input tt-dwf-cta-ctbl.cod-cta-ctbl).
        
        find first b-tt-dwf-cta-ctbl
            where b-tt-dwf-cta-ctbl.cod-cta-ctbl-sup = tt-dwf-cta-ctbl.cod-cta-ctbl
              and b-tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl <> 0
            no-error.

        if avail b-tt-dwf-cta-ctbl then 
            assign tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl = b-tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl.
        else 
            assign tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl = 9. /* Outras */

        run pi-replica-natur-filhas-sem-refer (input tt-dwf-cta-ctbl.cod-cta-ctbl,
                                               input tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl).
    end.

    /* Acerta natureza das contas sem depara */
    for each tt-dwf-cta-ctbl 
        where tt-dwf-cta-ctbl.ind-tip-cta-ctbl = "A"
          and tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl = 0:
        
        find first b-tt-dwf-cta-ctbl
            where b-tt-dwf-cta-ctbl.cod-cta-ctbl = tt-dwf-cta-ctbl.cod-cta-ctbl-sup
            no-error.

        if avail b-tt-dwf-cta-ctbl then
            assign tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl = b-tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl.

    end.

    /* PARA AS CONTAS QUE AINDA PERMANECEM SEM O CODIGO DA NATUREZA ATRIBUIR NATUREZA 9 (OUTRAS) */
    for each tt-dwf-cta-ctbl
        where tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl = 0:
        assign tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl = 9.
    end.

end.
/***************************************************************************************************/
/*Hugo - Atv 244177*/
PROCEDURE pi-valida-natur:
    define input          param p-cod-cta-ctbl-pai as char no-undo.
    define input          param p-cod-cta-ctbl-sup as char no-undo.
    define INPUT-OUTPUT   param p-natur            as int  no-undo.
    define INPUT-OUTPUT   param p-cod-cta-ctbl     as char no-undo.
    DEFINE INPUT-OUTPUT   PARAM p-ok               AS LOG  NO-UNDO.

    define buffer b-tt-dwf-cta-ctbl for tt-dwf-cta-ctbl.
    
    find first b-tt-dwf-cta-ctbl 
        where b-tt-dwf-cta-ctbl.cod-cta-ctbl-sup = p-cod-cta-ctbl-sup
        AND   b-tt-dwf-cta-ctbl.ind-tip-cta-ctbl       = 'A'
        and   b-tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl <> p-natur
        AND   b-tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl <> 0 no-error.
    if avail b-tt-dwf-cta-ctbl THEN DO:
      
         IF  p-natur <> 0 THEN DO:
             create tt-log-advertencias-sped.
             assign tt-log-advertencias-sped.num-cod-erro = 51898
                    tt-log-advertencias-sped.des-erro = p-cod-cta-ctbl-pai + '~~' + b-tt-dwf-cta-ctbl.cod-cta-ctbl + '~~' + string(b-tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl) + '~~' + p-cod-cta-ctbl + '~~' + string(p-natur). 
                   /*'Na estrutura de conta ' + p-cod-cta-ctbl-pai + ' as contas filhas: ' + b-tt-dwf-cta-ctbl.cod-cta-ctbl + ' de natureza: ' + string(b-tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl) + ' e ' + p-cod-cta-ctbl + ' de natureza: ' + string(p-natur) + ' est∆o com naturezas diferentes. Para o SPED Cont†bil, contas que est∆o na mesma estrutura devem ter a mesma natureza. Ocorrer† mensagem de advertància no validador do SPED Cont†bil se as naturezas permanecerem como est∆o.'*/
         END.

         ASSIGN p-natur        = b-tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl
                p-cod-cta-ctbl = b-tt-dwf-cta-ctbl.cod-cta-ctbl
                p-ok = YES.
         RETURN.
    END.

    for each b-tt-dwf-cta-ctbl
       where b-tt-dwf-cta-ctbl.cod-cta-ctbl-sup = p-cod-cta-ctbl-sup
         and b-tt-dwf-cta-ctbl.ind-tip-cta-ctbl = "S":

         run pi-valida-natur (INPUT p-cod-cta-ctbl-pai,
                              INPUT b-tt-dwf-cta-ctbl.cod-cta-ctbl,
                              INPUT-OUTPUT p-natur,
                              INPUT-OUTPUT p-cod-cta-ctbl,
                              INPUT-OUTPUT p-ok).
         
         IF  p-ok THEN
             RETURN.

    END.
END PROCEDURE.
/*Hugo fim - Atv 244177*/
/****************************************************************************************************/
procedure pi-busca-natur-cta-ctbl-filhas:
    define input param p-cod-cta-ctbl-sup as char no-undo.

    define buffer b-tt-dwf-cta-ctbl  for tt-dwf-cta-ctbl.
    define buffer b2-tt-dwf-cta-ctbl for tt-dwf-cta-ctbl.

    find first b-tt-dwf-cta-ctbl 
        where b-tt-dwf-cta-ctbl.cod-cta-ctbl-sup = p-cod-cta-ctbl-sup
          and b-tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl <> 0
        no-error.
    if avail b-tt-dwf-cta-ctbl then return.

    for each b-tt-dwf-cta-ctbl
        where b-tt-dwf-cta-ctbl.cod-cta-ctbl-sup = p-cod-cta-ctbl-sup
          and b-tt-dwf-cta-ctbl.ind-tip-cta-ctbl = "S":

        run pi-busca-natur-cta-ctbl-filhas (input b-tt-dwf-cta-ctbl.cod-cta-ctbl).

        find first b2-tt-dwf-cta-ctbl
            where b2-tt-dwf-cta-ctbl.cod-cta-ctbl-sup = b-tt-dwf-cta-ctbl.cod-cta-ctbl
              and b2-tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl <> 0
            no-error.
        if avail b2-tt-dwf-cta-ctbl then 
            assign b-tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl = b2-tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-replica-natur-filhas-sem-refer:
    define input param p-cod-cta-ctbl-sup as char no-undo.
    define input param p-natur            as int  no-undo.

    define buffer b-tt-dwf-cta-ctbl for tt-dwf-cta-ctbl.

    for each b-tt-dwf-cta-ctbl USE-INDEX tt-conta-sup-natur
        where b-tt-dwf-cta-ctbl.cod-cta-ctbl-sup = p-cod-cta-ctbl-sup:
        if b-tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl = 0 then
            assign b-tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl = p-natur.

        run pi-replica-natur-filhas-sem-refer (input b-tt-dwf-cta-ctbl.cod-cta-ctbl,
                                               input b-tt-dwf-cta-ctbl.num-natur-grp-cta-ctbl).
    end.
end procedure.
/***************************************************************************************************/
procedure pi-extrair-codigo-aglutinacao:

    for each tt-dwf-cta-aglut:
        delete tt-dwf-cta-aglut.
    end.

    if tt-param.l-balancete = yes then do:
        for each tt-dwf-cta-ctbl USE-INDEX tt-conta-tip
            where tt-dwf-cta-ctbl.ind-tip-cta-ctbl = "A":

            find first tt-dwf-cta-ctbl-refer
                where tt-dwf-cta-ctbl-refer.cod-empresa = tt-dwf-cta-ctbl.cod-empresa
                  and tt-dwf-cta-ctbl-refer.cod-cta-ctbl = tt-dwf-cta-ctbl.cod-cta-ctbl
                no-lock no-error.

            if not avail tt-dwf-cta-ctbl-refer or 
                (tt-dwf-cta-ctbl-refer.ind-natur-cta-ctbl <> "01" and
                 tt-dwf-cta-ctbl-refer.ind-natur-cta-ctbl <> "02" and
                 tt-dwf-cta-ctbl-refer.ind-natur-cta-ctbl <> "03" and
                 tt-dwf-cta-ctbl-refer.ind-natur-cta-ctbl <> "04") then next.

            if tt-param.c-tipo-balancete = "contacontabil":U then do:

                create tt-dwf-cta-aglut.
                assign tt-dwf-cta-aglut.cod-empresa        = tt-dwf-cta-ctbl.cod-empresa
                       tt-dwf-cta-aglut.cod-cta-ctbl       = tt-dwf-cta-ctbl.cod-cta-ctbl
                       tt-dwf-cta-aglut.cod-cta-ctbl-aglut = tt-dwf-cta-ctbl.cod-cta-ctbl
                       tt-dwf-cta-aglut.des-tit-ctbl-aglut = tt-dwf-cta-ctbl.des-tit-ctbl
                       tt-dwf-cta-aglut.num-niv-cta-ctbl   = 1
                       tt-dwf-cta-aglut.cod-ccusto         = "".
            end.
            else if tt-param.c-tipo-balancete = "estrutura":U then do:

                if tt-dwf-cta-ctbl.num-niv-cta-ctbl <= tt-param.i-nivel and
                   tt-dwf-cta-ctbl.cod-cta-ctbl <> tt-dwf-cta-ctbl.cod-cta-ctbl-sup then do:
                    
                    create tt-dwf-cta-aglut.
                    assign tt-dwf-cta-aglut.cod-empresa        = tt-dwf-cta-ctbl.cod-empresa
                           tt-dwf-cta-aglut.cod-cta-ctbl       = tt-dwf-cta-ctbl.cod-cta-ctbl
                           tt-dwf-cta-aglut.cod-cta-ctbl-aglut = tt-dwf-cta-ctbl.cod-cta-ctbl
                           tt-dwf-cta-aglut.des-tit-ctbl-aglut = tt-dwf-cta-ctbl.des-tit-ctbl
                           tt-dwf-cta-aglut.num-niv-cta-ctbl   = tt-dwf-cta-ctbl.num-niv-cta-ctbl
                           tt-dwf-cta-aglut.cod-ccusto         = "".
                end.

                if tt-dwf-cta-ctbl.cod-cta-ctbl-sup <> "" and 
                   tt-dwf-cta-ctbl.cod-cta-ctbl <> tt-dwf-cta-ctbl.cod-cta-ctbl-sup then
                    run pi-cria-aglutinacao-estrutura (input tt-dwf-cta-ctbl.cod-cta-ctbl,
                                                       input tt-dwf-cta-ctbl.cod-cta-ctbl-sup).
            end.
        end.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-cria-aglutinacao-estrutura:
    define input parameter p-cod-cta-ctbl     as char no-undo.
    define input parameter p-cod-cta-ctbl-sup as char no-undo.
    define buffer btt-dwf-cta-ctbl for tt-dwf-cta-ctbl.

    define variable dt-ini as date no-undo.
    define variable dt-fim as date no-undo.

    FOR FIRST btt-dwf-cta-ctbl FIELDS (cod-empresa
                                       cod-cta-ctbl
                                       num-niv-cta-ctbl
                                       des-tit-ctbl
                                       cod-cta-ctbl-sup)
        WHERE btt-dwf-cta-ctbl.cod-empresa  = tt-param.c-empresa
        AND   btt-dwf-cta-ctbl.cdn-empresa  = tt-param.i-empresa-ems2
        AND   btt-dwf-cta-ctbl.cod-cta-ctbl = p-cod-cta-ctbl-sup.
    END.

    if avail btt-dwf-cta-ctbl then do:

        if btt-dwf-cta-ctbl.num-niv-cta-ctbl <= tt-param.i-nivel then do:
            create tt-dwf-cta-aglut.
            assign tt-dwf-cta-aglut.cod-empresa        = btt-dwf-cta-ctbl.cod-empresa
                   tt-dwf-cta-aglut.cod-cta-ctbl       = p-cod-cta-ctbl
                   tt-dwf-cta-aglut.cod-cta-ctbl-aglut = btt-dwf-cta-ctbl.cod-cta-ctbl
                   tt-dwf-cta-aglut.des-tit-ctbl-aglut = btt-dwf-cta-ctbl.des-tit-ctbl
                   tt-dwf-cta-aglut.num-niv-cta-ctbl   = btt-dwf-cta-ctbl.num-niv-cta-ctbl
                   tt-dwf-cta-aglut.cod-ccusto         = "".
        end.

        if btt-dwf-cta-ctbl.cod-cta-ctbl-sup <> "" then
            run pi-cria-aglutinacao-estrutura (input p-cod-cta-ctbl,
                                               input btt-dwf-cta-ctbl.cod-cta-ctbl-sup).
    end.
end procedure.
/***************************************************************************************************/
procedure pi-extrair-blocoj:
    define variable d-saldo-atual as decimal no-undo.
    define variable d-saldo-atual-antes-encert as decimal no-undo.
    define variable l-saldo   as logical initial no no-undo.
    define buffer btt-dwf-balan-patrim for tt-dwf-balan-patrim.
    define buffer btt-dwf-demonst-restdo-exerc for tt-dwf-demonst-restdo-exerc.

    define variable d-saldo-inicial as decimal no-undo.

    define variable dt-ini as date no-undo.
    define variable dt-fim as date no-undo.

    /* Por Conta Cont†bil */       
    if tt-param.l-balancete then do:

        run pi-acompanhar in h-acomp (input 'Extraindo Balancete').

        for each tt_period:

            assign dt-ini = tt_period.ttv_dat_inic_param
                   dt-fim = tt_period.ttv_dat_fim_param.

            find first tt-dwf-sdo-ctbl
                where tt-dwf-sdo-ctbl.cod-empresa = tt-param.c-empresa
                  and tt-dwf-sdo-ctbl.cdn-empresa = tt-param.i-empresa-ems2
                  and tt-dwf-sdo-ctbl.num-exerc-ctbl  = tt_period.ttv_num_ano
                  and tt-dwf-sdo-ctbl.num-period-ctbl = tt_period.ttv_num_mes
                  and tt-dwf-sdo-ctbl.dat-inic-valid = dt-fim
                no-error.

            if not avail tt-dwf-sdo-ctbl then
                next.

            if not tt-param.l-gera-j100 then do:
                if not can-find (first tt-dwf-sdo-ctbl-antes-encert
                                 where tt-dwf-sdo-ctbl-antes-encert.cod-empresa = tt-param.c-empresa
                                   and tt-dwf-sdo-ctbl-antes-encert.dat-apurac-restdo = dt-fim) then 
                    next.
            end.

            find first tt-dwf-demonst-ctbl-bloco
                where tt-dwf-demonst-ctbl-bloco.cod-empresa = tt-param.c-empresa
                  and tt-dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl = dt-ini
                  and tt-dwf-demonst-ctbl-bloco.dat-fim-demonst-ctbl = dt-fim
                no-error.
            if not avail tt-dwf-demonst-ctbl-bloco then do:
                create tt-dwf-demonst-ctbl-bloco.
                assign tt-dwf-demonst-ctbl-bloco.cod-empresa = tt-param.c-empresa
                       tt-dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl = dt-ini
                       tt-dwf-demonst-ctbl-bloco.dat-fim-demonst-ctbl = dt-fim.
            end.

            for each tt-dwf-cta-ctbl USE-INDEX tt-conta-tip
                where tt-dwf-cta-ctbl.ind-tip-cta-ctbl = "A":

               find first tt-dwf-cta-ctbl-refer
                    where tt-dwf-cta-ctbl-refer.cod-empresa = tt-dwf-cta-ctbl.cod-empresa
                      and tt-dwf-cta-ctbl-refer.cod-cta-ctbl = tt-dwf-cta-ctbl.cod-cta-ctbl
                    no-error.

                if not avail tt-dwf-cta-ctbl-refer then next.

                assign d-saldo-atual   = 0
                       d-saldo-inicial = 0.

                /* Retorna Saldo Final para contas de Ativo, Passivo e Patrimìnio e 
                   saldo antes do encerramento para contas de Resultado */
                run pi-retorna-saldo-atual-balancete (input tt-dwf-cta-ctbl.cod-cta-ctbl, 
                                                      input tt_period.ttv_num_ano,
                                                      input tt_period.ttv_num_mes, 
                                                      input dt-fim,
                                                      output d-saldo-atual, 
                                                      output d-saldo-atual-antes-encert,
                                                      output d-saldo-inicial).

                for each tt-dwf-cta-aglut USE-INDEX nivel
                   where tt-dwf-cta-aglut.cod-empresa = tt-dwf-cta-ctbl.cod-empresa
                     and tt-dwf-cta-aglut.cod-cta-ctbl = tt-dwf-cta-ctbl.cod-cta-ctbl:

                    /* Contas de Ativo, Passivo e Patrimìnio */
                    if tt-dwf-cta-ctbl-refer.ind-natur-cta-ctbl = "01" or
                       tt-dwf-cta-ctbl-refer.ind-natur-cta-ctbl = "02" or
                       tt-dwf-cta-ctbl-refer.ind-natur-cta-ctbl = "03" then do:

                        find first tt-dwf-balan-patrim
                            where tt-dwf-balan-patrim.cod-empresa          = tt-dwf-cta-aglut.cod-empresa
                              and tt-dwf-balan-patrim.dat-inic-demonst-ctbl = tt-dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl
                              and tt-dwf-balan-patrim.cod-cta-ctbl-aglut   = tt-dwf-cta-aglut.cod-cta-ctbl-aglut
                            no-error.

                        if not avail tt-dwf-balan-patrim then do:
                            
                            create tt-dwf-balan-patrim.
                            assign tt-dwf-balan-patrim.cod-empresa          = tt-dwf-cta-aglut.cod-empresa
                                   tt-dwf-balan-patrim.dat-inic-demonst-ctbl = tt-dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl
                                   tt-dwf-balan-patrim.cod-cta-ctbl-aglut   = tt-dwf-cta-aglut.cod-cta-ctbl-aglut
                                   tt-dwf-balan-patrim.num-niv-cta-ctbl     = tt-dwf-cta-aglut.num-niv-cta-ctbl
                                   tt-dwf-balan-patrim.cod-indic-grp        = (if tt-dwf-cta-ctbl-refer.ind-natur-cta-ctbl = "01" then "1" else "2")
                                   tt-dwf-balan-patrim.des-tit-ctbl-aglut   = tt-dwf-cta-aglut.des-tit-ctbl-aglut
                                   tt-dwf-balan-patrim.val-tot-cta-aglut     = 0
                                   &if "{&mgadm_version}" >= "2.09" &then
                                   tt-dwf-balan-patrim.val-inicial-cta-aglut = 0
                                   &ELSE
                                   tt-dwf-balan-patrim.val-livre-1           = 0
                                   &ENDIF.
                        end.
                        assign tt-dwf-balan-patrim.val-tot-cta-aglut = tt-dwf-balan-patrim.val-tot-cta-aglut + d-saldo-atual
                               &if "{&mgadm_version}" >= "2.09" &then
                               tt-dwf-balan-patrim.val-inicial-cta-aglut = tt-dwf-balan-patrim.val-inicial-cta-aglut + d-saldo-inicial
                               &ELSE
                               tt-dwf-balan-patrim.val-livre-1           = tt-dwf-balan-patrim.val-livre-1 + d-saldo-inicial
                               &ENDIF.
                    end.
                    /* Contas de Resultado */
                    else if tt-dwf-cta-ctbl-refer.ind-natur-cta-ctbl = "04" then do:

                        find first tt-dwf-demonst-restdo-exerc
                            where tt-dwf-demonst-restdo-exerc.cod-empresa = tt-dwf-cta-aglut.cod-empresa
                              and tt-dwf-demonst-restdo-exerc.dat-inic-demonst-ctbl = tt-dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl
                              and tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut = tt-dwf-cta-aglut.cod-cta-ctbl-aglut
                            no-error.

                        if not avail tt-dwf-demonst-restdo-exerc then do:
                            /* Para o balancete, ser† utilizado o cod-livre-1 para fins de ordenaá∆o (por conta superior. 
                               Essa ordenaá∆o Ç feita na geraá∆o do arquivo, de acordo com o layout utilizado. 
                               Para evitar problemas de performance, criamos um totalizador, que funciona como temp-table, 
                               e colocamos o cod-livre-1 como um dos campos do °ndice (ordenaá∆o) */

                            create tt-dwf-demonst-restdo-exerc.
                            assign tt-dwf-demonst-restdo-exerc.cod-empresa           = tt-dwf-cta-aglut.cod-empresa
                                   tt-dwf-demonst-restdo-exerc.dat-inic-demonst-ctbl  = tt-dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl
                                   tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut    = tt-dwf-cta-aglut.cod-cta-ctbl-aglut
                                   tt-dwf-demonst-restdo-exerc.num-niv-cta-ctbl      = tt-dwf-cta-aglut.num-niv-cta-ctbl
                                   tt-dwf-demonst-restdo-exerc.des-tit-ctbl-aglut    = tt-dwf-cta-aglut.des-tit-ctbl-aglut
                                   tt-dwf-demonst-restdo-exerc.val-tot-cta-aglut     = 0.
                        end.
                        
                        assign tt-dwf-demonst-restdo-exerc.val-tot-cta-aglut = tt-dwf-demonst-restdo-exerc.val-tot-cta-aglut + d-saldo-atual-antes-encert.
                    end.
                end.
            end.
        end.

        for each tt-dwf-balan-patrim:
            
            &if "{&mgadm_version}" >= "2.09" &then
            IF tt-dwf-balan-patrim.val-inicial-cta-aglut = 0 THEN
                ASSIGN tt-dwf-balan-patrim.ind-sit-sdo-inicial = "C".
            ELSE IF tt-dwf-balan-patrim.val-inicial-cta-aglut < 0 THEN
                ASSIGN tt-dwf-balan-patrim.val-inicial-cta-aglut = tt-dwf-balan-patrim.val-inicial-cta-aglut * (-1)
                       tt-dwf-balan-patrim.ind-sit-sdo-inicial = "C".
            ELSE ASSIGN tt-dwf-balan-patrim.ind-sit-sdo-inicial = "D".
            &ELSE
            IF tt-dwf-balan-patrim.val-livre-1 = 0 THEN
                ASSIGN tt-dwf-balan-patrim.cod-livre-1 = "C".
            ELSE IF tt-dwf-balan-patrim.val-livre-1 < 0 THEN
                ASSIGN tt-dwf-balan-patrim.val-livre-1 = tt-dwf-balan-patrim.val-livre-1 * (-1)
                       tt-dwf-balan-patrim.cod-livre-1 = "C".
            ELSE ASSIGN tt-dwf-balan-patrim.cod-livre-1 = "D".
            &ENDIF

            if tt-dwf-balan-patrim.val-tot-cta-aglut = 0 then 
            do:
                assign l-saldo = no.
                run pi-verifica-saldo-filhas (input  "balanco",
                                              input  tt-dwf-balan-patrim.cod-empresa,
                                              input  tt-dwf-balan-patrim.cod-cta-ctbl-aglut,
                                              output l-saldo).
                if  l-saldo then
                    assign tt-dwf-balan-patrim.ind-sit-sdo = "C".
                ELSE delete tt-dwf-balan-patrim.
                
            end.
            else if tt-dwf-balan-patrim.val-tot-cta-aglut < 0 then
                assign tt-dwf-balan-patrim.val-tot-cta-aglut = tt-dwf-balan-patrim.val-tot-cta-aglut * (-1)
                       tt-dwf-balan-patrim.ind-sit-sdo     = "C".
            else assign tt-dwf-balan-patrim.ind-sit-sdo     = "D".
        end.

        
        for each tt-dwf-demonst-restdo-exerc:

            if tt-dwf-demonst-restdo-exerc.val-tot-cta-aglut = 0 then do: 
                assign l-saldo = no.
                run pi-verifica-saldo-filhas (input  "dre",
                                              input  tt-dwf-demonst-restdo-exerc.cod-empresa,
                                              input  tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut,
                                              output l-saldo).
                if  l-saldo then
                    assign tt-dwf-demonst-restdo-exerc.ind-sit-sdo = "P".
                else
                

                    delete tt-dwf-demonst-restdo-exerc. 
            end.
            else if tt-dwf-demonst-restdo-exerc.val-tot-cta-aglut < 0 then do:

                find first tt-dwf-cta-ctbl
                     where tt-dwf-cta-ctbl.cod-empresa = tt-dwf-demonst-restdo-exerc.cod-empresa
                       and tt-dwf-cta-ctbl.cod-cta-ctbl = tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut
                    no-error.
                if avail tt-dwf-cta-ctbl then
                    assign tt-dwf-demonst-restdo-exerc.val-tot-cta-aglut = tt-dwf-demonst-restdo-exerc.val-tot-cta-aglut * (-1)
                           tt-dwf-demonst-restdo-exerc.ind-sit-sdo     = if tt-dwf-cta-ctbl.ind-tip-cta-ctbl = "A" then "R" else "P".
                else
                    assign tt-dwf-demonst-restdo-exerc.val-tot-cta-aglut = tt-dwf-demonst-restdo-exerc.val-tot-cta-aglut * (-1)
                           tt-dwf-demonst-restdo-exerc.ind-sit-sdo     = "R".
            end.
            else if tt-dwf-demonst-restdo-exerc.val-tot-cta-aglut > 0 then do:
                find first tt-dwf-cta-ctbl
                     where tt-dwf-cta-ctbl.cod-empresa = tt-dwf-demonst-restdo-exerc.cod-empresa
                       and tt-dwf-cta-ctbl.cod-cta-ctbl = tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut
                    no-error.
                if avail tt-dwf-cta-ctbl then
                    assign tt-dwf-demonst-restdo-exerc.ind-sit-sdo     = if tt-dwf-cta-ctbl.ind-tip-cta-ctbl = "A" then "D" else "N".
                else
                    assign tt-dwf-demonst-restdo-exerc.ind-sit-sdo     = "D".
            end.
        end.
        
        /* Realizado este tratamento para gravar no campo dwf-balan-patrim.num-livre e 
           tt-dwf-demonst-restdo-exerc.num-seq-indic-sit-sdo a sequencia Ö qual devem ser
           apresentadas as conta no bloco J100 e J150 */
        /*  Alterado o where cdn-empresa >= para = 
            Os campos c-empresa e i-empresa-ems2 da tt-param ser∆o tratados para refletirem 
            a seleá∆o do usuario na tela, conforme a contabilidade selecionada (EMS 2 ou 5) */
        for each tt-dwf-cta-ctbl 
            fields (cod-empresa
                    cdn-empresa
                    cod-cta-ctbl
                    cod-cta-ctbl-sup
                    ind-tip-cta-ctbl
                    num-natur-grp-cta-ctbl
                    num-niv-cta-ctbl
                    des-tit-ctbl) no-lock 
           where tt-dwf-cta-ctbl.cod-empresa = tt-param.c-empresa
             and tt-dwf-cta-ctbl.cdn-empresa = tt-param.i-empresa-ems2
             and tt-dwf-cta-ctbl.cod-cta-ctbl-sup = ""
             and tt-dwf-cta-ctbl.dat-fim-valid = ?
             /*Joao Claudio - ATV246938*/
             by tt-dwf-cta-ctbl.cod-cta-ctbl:
            
           if  can-find(first tt-dwf-balan-patrim no-lock
               where tt-dwf-balan-patrim.cod-empresa = tt-dwf-cta-ctbl.cod-empresa
                 and tt-dwf-balan-patrim.cod-cta-ctbl-aglut = tt-dwf-cta-ctbl.cod-cta-ctbl) then
           do:
               assign i-seq-100 = i-seq-100 + 1.
               for each tt-dwf-balan-patrim
                   fields(cod-empresa
                          cod-cta-ctbl-aglut
                          num-livre-1) exclusive-lock
                   where tt-dwf-balan-patrim.cod-empresa = tt-dwf-cta-ctbl.cod-empresa
                     and tt-dwf-balan-patrim.cod-cta-ctbl-aglut = tt-dwf-cta-ctbl.cod-cta-ctbl
                   break by tt-dwf-balan-patrim.cod-cta-ctbl-aglut:

                   assign tt-dwf-balan-patrim.num-livre-1 = i-seq-100.

                   if  last(tt-dwf-balan-patrim.cod-cta-ctbl-aglut) then
                       run pi-busca-filhas(input-output i-seq-100,
                                           input tt-dwf-cta-ctbl.cod-cta-ctbl).
               end.
           end.
           else do:
               if  can-find(first tt-dwf-demonst-restdo-exerc no-lock
                   where tt-dwf-demonst-restdo-exerc.cod-empresa        = tt-dwf-cta-ctbl.cod-empresa
                     and tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut = tt-dwf-cta-ctbl.cod-cta-ctbl) then
               do:
                   assign i-seq-150 = i-seq-150 + 1.
                   for each tt-dwf-demonst-restdo-exerc
                       fields(cod-empresa
                              cod-cta-ctbl-aglut
                              num-seq-indic-sit-sdo) exclusive-lock
                       where tt-dwf-demonst-restdo-exerc.cod-empresa        = tt-dwf-cta-ctbl.cod-empresa
                         and tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut = tt-dwf-cta-ctbl.cod-cta-ctbl
                       break by tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut:

                       assign tt-dwf-demonst-restdo-exerc.num-seq-indic-sit-sdo = i-seq-150.

                       if  last(tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut) then
                           run pi-busca-filhas(input-output i-seq-150,
                                               input tt-dwf-cta-ctbl.cod-cta-ctbl).
                   end.
               end.
           end.
        end.
    end.
    else if tt-param.l-demonstrativo then do:
        run pi-acompanhar in h-acomp (input 'Extraindo Demonstrativos').

        /*if tt-param.c-diario = "diariogeral" and
           tt-param.c-contabilidade = "ems2" then
            run pi-extrai-demonstrativo-contabil.
        else unificaÁ„o*/
        if tt-param.c-diario = "diariogeral" and
                tt-param.c-contabilidade = "ems5" then do:

            if valid-handle(h-ems5) then do:

                run pi_extrator_sped_demonstrativo_contabil in h-ems5 (input h-acomp).

            end.                            
        end.

        release tt-dwf-demonst-ctbl-bloco.
        release tt-dwf-balan-patrim.
        release tt-dwf-demonst-restdo-exerc.

        if can-find(first tt-dwf-demonst-ctbl-bloco) then do:
            if not can-find(first tt-dwf-balan-patrim) then do:
                run pi-cria-erro-demonst-sem-dados (input 'balanco').
            end.

            if not tt-param.l-gera-j100 then do:
                if not can-find(first tt-dwf-demonst-restdo-exerc) then do:
                    run pi-cria-erro-demonst-sem-dados (input 'dre').
                end.
            end.

        end.
    end.

    for each tt-dwf-demonst-ctbl-bloco:
        if not CAN-FIND(first tt-dwf-balan-patrim 
            where tt-dwf-balan-patrim.cod-empresa = tt-dwf-demonst-ctbl-bloco.cod-empresa and 
            tt-dwf-balan-patrim.dat-inic-demonst-ctbl = tt-dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl ) then 
        do:
                          
                           
            if not CAN-FIND(first tt-dwf-demonst-restdo-exerc
                where tt-dwf-demonst-restdo-exerc.cod-empresa = tt-dwf-demonst-restdo-exerc.cod-empresa and 
                tt-dwf-demonst-restdo-exerc.dat-inic-demonst-ctbl = tt-dwf-demonst-restdo-exerc.dat-inic-demonst-ctbl ) then 
            do:
                delete tt-dwf-demonst-ctbl-bloco.
            end.
        end.  
    end.
end procedure.
/***************************************************************************************************/
procedure pi-retorna-saldo-atual-balancete:
    define input  param p-cod-cta-ctbl as char    no-undo.
    define input  param p-ano          as integer no-undo.
    define input  param p-num-periodo  as integer no-undo.
    define input  param p-dt-fim       as date    no-undo.
    define output param d-saldo-atual  as decimal no-undo.
    define output param d-saldo-atual-antes-encert as decimal no-undo.
    define output param d-saldo-inicial            as decimal no-undo.

    define variable d-saldo-aux         as decimal no-undo.
    define variable d-saldo-inicial-aux as decimal no-undo.

    assign d-saldo-atual = 0
           d-saldo-atual-antes-encert = 0
           d-saldo-aux = 0
           d-saldo-inicial = 0
           d-saldo-inicial-aux = 0.

    for each tt-dwf-sdo-ctbl
        where tt-dwf-sdo-ctbl.cod-empresa     = tt-param.c-empresa
          and tt-dwf-sdo-ctbl.cdn-empresa     = tt-param.i-empresa-ems2
          and tt-dwf-sdo-ctbl.cod-cta-ctbl    = p-cod-cta-ctbl
          and tt-dwf-sdo-ctbl.num-exerc-ctbl  = p-ano
          and tt-dwf-sdo-ctbl.num-period-ctbl = p-num-periodo
          and tt-dwf-sdo-ctbl.cod-estab       = ""
          and tt-dwf-sdo-ctbl.dat-inic-valid  = p-dt-fim:

        if tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = "C" then
            assign d-saldo-aux = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim * (-1).
        else
            assign d-saldo-aux = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim.

        assign d-saldo-atual = d-saldo-atual + d-saldo-aux.

        IF tt-dwf-sdo-ctbl.ind-sdo-ctbl-inic = "C" THEN 
            ASSIGN d-saldo-inicial-aux = tt-dwf-sdo-ctbl.val-sdo-ctbl-inic * (-1).
        ELSE ASSIGN d-saldo-inicial-aux = tt-dwf-sdo-ctbl.val-sdo-ctbl-inic.

        ASSIGN d-saldo-inicial = d-saldo-inicial + d-saldo-inicial-aux.

        find first tt-dwf-sdo-ctbl-antes-encert
             where tt-dwf-sdo-ctbl-antes-encert.cod-empresa = tt-dwf-sdo-ctbl.cod-empresa
               and tt-dwf-sdo-ctbl-antes-encert.cod-estab = tt-dwf-sdo-ctbl.cod-estab
               and tt-dwf-sdo-ctbl-antes-encert.cod-modul-dtsul = tt-dwf-sdo-ctbl.cod-modul-dtsul
               and tt-dwf-sdo-ctbl-antes-encert.dat-apurac-restdo = tt-dwf-sdo-ctbl.dat-inic-valid
               and tt-dwf-sdo-ctbl-antes-encert.cod-cta-ctbl = tt-dwf-sdo-ctbl.cod-cta-ctbl
               and tt-dwf-sdo-ctbl-antes-encert.cod-ccusto = tt-dwf-sdo-ctbl.cod-ccusto
               and tt-dwf-sdo-ctbl-antes-encert.cod-unid-neg = tt-dwf-sdo-ctbl.cod-unid-negoc
               and tt-dwf-sdo-ctbl-antes-encert.dat-inic-valid = dat-today
               no-error.

        if avail tt-dwf-sdo-ctbl-antes-encert then do:
            if tt-dwf-sdo-ctbl-antes-encert.ind-sdo-ctbl-fim = "C" then
                assign d-saldo-atual-antes-encert = d-saldo-atual-antes-encert + (tt-dwf-sdo-ctbl-antes-encert.val-sdo-ctbl-fim-antes-encert * (-1)).
            else
                assign d-saldo-atual-antes-encert = d-saldo-atual-antes-encert + tt-dwf-sdo-ctbl-antes-encert.val-sdo-ctbl-fim-antes-encert.
        end.

    end.

end procedure.
/***************************************************************************************************/
procedure pi-print-erros-natur-demonstrativo:
    define input param p-tip-demonst as char no-undo.

    def var i-cod-erro as int no-undo.
    def var c-demonst as char no-undo.
    
    if p-tip-demonst = "balanco" then do:
        assign i-cod-erro = -1
               c-demonst  = tt-param.c-balanco.
    end.
    else if p-tip-demonst = "dre" then do:
        assign i-cod-erro = -2
               c-demonst  = tt-param.c-demonstracao.
    end.

    for each tt-log-erros-sped
       where tt-log-erros-sped.log-erro-tela = no
         and tt-log-erros-sped.num-cod-erro = i-cod-erro
        break by tt-log-erros-sped.num-cod-erro:
        
        if first-of(tt-log-erros-sped.num-cod-erro) then do:
            assign c-message = substitute("As contas cont†beis abaixo est∆o com a natureza inv†lida em relaá∆o ao demonstrativo ~"&1~" (&2):",
                                          c-demonst,
                                          if p-tip-demonst = "balanco" then "Balanáo Patrimonial" else "Demonstraá∆o de Resultados").
            disp stream str-rp c-message with frame f-extracao.
            down 1 stream str-rp with frame f-extracao.
        end.

        assign c-message = tt-log-erros-sped.des-erro.
        disp stream str-rp c-message with frame f-extracao.
        down 1 stream str-rp with frame f-extracao.

        if last-of(tt-log-erros-sped.num-cod-erro) then do:
            assign c-message = substitute("Favor rever o demonstrativo (&1) ou a natureza da conta (&2) para seguir a seguinte regra:",
                                          if tt-param.c-diario = "diariogeral" and tt-param.c-contabilidade = "ems2" then "CT0111" else "prgfin/mgl/mgl003aa",
                                          if tt-param.c-diario = "diariogeral" and tt-param.c-contabilidade = "ems2" then "CD1014" else "prgint/utb/utb119aa").
            disp stream str-rp c-message with frame f-extracao.
            down 1 stream str-rp with frame f-extracao.

            assign c-message = "Demonstrativo Cont†bil do Balanáo Patrimonial considerar contas com natureza:".
            disp stream str-rp c-message with frame f-extracao.
            down 1 stream str-rp with frame f-extracao.

            assign c-message = "            01 - Ativo, 02 - Passivo, ou 03 Patrimìnio L°quido.".
            disp stream str-rp c-message with frame f-extracao.
            down 1 stream str-rp with frame f-extracao.

            assign c-message = "Demonstrativo Cont†bil de Demonstraá∆o de Resultado considerar contas com natureza:".
            disp stream str-rp c-message with frame f-extracao.
            down 1 stream str-rp with frame f-extracao.

            assign c-message = "            04 - Apuraá∆o de Resultado.".
            disp stream str-rp c-message with frame f-extracao.
            down 2 stream str-rp with frame f-extracao.
        end.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-cria-erro-demonst-sem-dados:
    define input param p-tip-demonst as char no-undo.
    
    define variable c-param as char no-undo.

    assign c-param = (if p-tip-demonst = 'balanco' then tt-param.c-balanco + " (Balanáo Patrimonial)" else tt-param.c-demonstracao + " (Demonstraá∆o de Resultados)") + "~~" +
                     (if tt-param.c-diario = "diariogeral" and tt-param.c-contabilidade = "ems2" then "CT0111~~CD1014" else "prgfin/mgl/mgl003aa~~prgint/utb/utb119aa").

    run pi-cria-tt-erros-sped(input 34625, 
                              input c-param,
                              input no,
                              input "").

end procedure.
/***************************************************************************************************/
procedure pi-print-parametros:

    if tt-param.l-parametros then do:
        page stream str-rp.

        {utp/ut-liter.i Empresa_EMS_5 *}
        assign tt-param.c-empresa:label in frame f-parametros = return-value.

        {utp/ut-liter.i Empresa_EMS_2 *}
        assign tt-param.i-empresa-ems2:label in frame f-parametros = return-value.

        {utp/ut-liter.i Data_da_Extraá∆o *}
        assign tt-param.dt-ini:label in frame f-parametros = return-value.

        {utp/ut-liter.i Cen†rio_Cont†bil *}
        assign tt-param.c-cenario-contabil:label in frame f-parametros = return-value.


        {utp/ut-liter.i Livro *}
        assign c-origem:label in frame f-parametros = return-value.

        {utp/ut-liter.i Contabilidade *}
        assign c-contabilidade:label in frame f-parametros = return-value.

        assign tt-param.l-ems5-caixa-bancos:label in frame f-parametros = c-label-caixa-bancos
               tt-param.l-ems5-contas-pagar:label in frame f-parametros = c-label-contas-pagar
               tt-param.l-ems5-contas-receber:label in frame f-parametros = c-label-contas-receber
               tt-param.l-ems5-ativo-fixo:label in frame f-parametros = c-label-ativo-fixo
               tt-param.l-ems5-aplic-emprest:label in frame f-parametros = c-label-aplic-emprest
               tt-param.l-ems5-hrb:label in frame f-parametros = c-label-hrb
               tt-param.l-ems5-hpp:label in frame f-parametros = c-label-hpp
               tt-param.l-ems5-hfp:label in frame f-parametros = c-label-hfp
               tt-param.l-ems2-estoque:label in frame f-parametros = c-label-estoque
               tt-param.l-ems2-faturamento:label in frame f-parametros = c-label-faturamento
               tt-param.l-ems2-caixa-bancos:label in frame f-parametros = c-label-caixa-bancos
               tt-param.l-ems2-contas-pagar:label in frame f-parametros = c-label-contas-pagar
               tt-param.l-ems2-contas-receber:label in frame f-parametros = c-label-contas-receber
               tt-param.l-ems2-patrimonio:label in frame f-parametros = c-label-patrimonio
               tt-param.l-ems2-mri:label in frame f-parametros = c-label-mri.

               tt-param.l-gera-j100:label in frame f-parametros = c-label-j100.
               tt-param.l-apura-result-sped:label in frame f-parametros = c-label-apur-lucro-perda.
        {utp/ut-liter.i Balancete *}
        assign tt-param.l-balancete:label in frame f-parametros = return-value.

        {utp/ut-liter.i Seleá∆o *}
        assign c-tipo-balancete:label in frame f-parametros = return-value.

        {utp/ut-liter.i N°vel *}
        assign tt-param.i-nivel:label in frame f-parametros = return-value.

        {utp/ut-liter.i Demonstrativo_Cont†bil *}
        assign tt-param.l-demonstrativo:label in frame f-parametros = return-value.

        {utp/ut-liter.i Balanáo_Patrimonial *}
        assign tt-param.c-balanco:label in frame f-parametros = return-value.

        {utp/ut-liter.i Demonstraá∆o_de_Resultados *}
        assign tt-param.c-demonstracao:label in frame f-parametros = return-value.

        if tt-param.c-diario = "diariogeral" then do:
            {utp/ut-liter.i Di†rio_Geral *}
            assign c-origem = return-value.
        end.
        else do:
            {utp/ut-liter.i Di†rio_Auxiliar *}
            assign c-origem = return-value.
        end.

        if tt-param.c-contabilidade = "ems2" then
            assign c-contabilidade = "EMS 2".
        else
            assign c-contabilidade = "EMS 5".
        
        {utp/ut-liter.i M‡DULOS_EMS_5 *}
        assign c-modulos-ems5 = return-value.

        {utp/ut-liter.i M‡DULOS_EMS_2 *}
        assign c-modulos-ems2 = return-value.

        if tt-param.c-tipo-balancete = "contacontabil":U then do:
            {utp/ut-liter.i Conta_Cont†bil *}
            assign c-tipo-balancete = return-value.
        end.
        else if tt-param.c-tipo-balancete = "estrutura":U then do:
            {utp/ut-liter.i Estrutura *}
            assign c-tipo-balancete = return-value.
        end.

        {utp/ut-liter.i Usu†rio *}
        assign tt-param.usuario:label in frame f-parametros = return-value.

        {utp/ut-liter.i Tempo_Processamento *}
        assign c-time:label in frame f-parametros = return-value.

        {utp/ut-liter.i SELEÄ«O *}
        assign c-literal1 = return-value.

        {utp/ut-liter.i PAR∂METROS *}
        assign c-literal2 = return-value.

        {utp/ut-liter.i Atualiza_Participante *}
        assign tt-param.l-atualiza-participante:label in frame f-parametros = return-value.

        {utp/ut-liter.i Relaciona_Lanáamento_x_Participante *}
        assign tt-param.l-relaciona-lancto-participante:label in frame f-parametros = return-value.

        ASSIGN c-time = STRING(TIME - i-time,"HH:MM:SS").

        if tt-param.c-diario = "diarioauxiliar" then
            display stream str-rp 
                tt-param.c-empresa
                with frame f-parametros.
        else if tt-param.c-contabilidade = "ems5" then do:
            display stream str-rp 
                tt-param.c-empresa
                with frame f-parametros.
        end.

        &IF "{&mgadm_version}" >= "2.07A" &THEN
        if tt-param.c-diario = "diarioauxiliar" then
            display stream str-rp 
                tt-param.i-empresa-ems2
                with frame f-parametros.
        &ELSE
        display stream str-rp 
            tt-param.i-empresa-ems2
            with frame f-parametros.
        &ENDIF

        display stream str-rp
            c-literal1
            tt-param.c-cenario-contabil  
            tt-param.dt-ini       
            tt-param.dt-fim       
            c-literal2
            c-origem
            c-contabilidade
            c-modulos-ems5
            tt-param.l-ems5-caixa-bancos   
            tt-param.l-ems5-contas-pagar  
            tt-param.l-ems5-contas-receber
            tt-param.l-ems5-ativo-fixo    
            tt-param.l-ems5-aplic-emprest 
            tt-param.l-ems5-hrb           
            tt-param.l-ems5-hpp           
            tt-param.l-ems5-hfp           
            c-modulos-ems2
            tt-param.l-ems2-estoque       
            tt-param.l-ems2-faturamento   
            tt-param.l-ems2-caixa-bancos  
            tt-param.l-ems2-contas-pagar  
            tt-param.l-ems2-contas-receber
            tt-param.l-ems2-patrimonio    
            tt-param.l-ems2-mri  

            tt-param.l-gera-j100
            tt-param.l-apura-result-sped
            tt-param.l-atualiza-participante
            tt-param.l-relaciona-lancto-participante
            tt-param.l-balancete
            c-tipo-balancete
            tt-param.i-nivel
            tt-param.l-demonstrativo
            tt-param.c-balanco
            tt-param.c-demonstracao
            tt-param.usuario
            c-time
            with frame f-parametros.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-bofi177:

    run pi-acompanhar in h-acomp (input 'Efetivando Extraá∆o: Lanáamentos Cont†beis').
    
    def buffer b-dwf-lancto-ctbl for dwf-lancto-ctbl.

    for each tt-dwf-lancto-ctbl:
        
        for last dwf-lancto-ctbl use-index dwflnctc-id no-lock
            where dwf-lancto-ctbl.cod-empresa      = tt-dwf-lancto-ctbl.cod-empresa    
            and   dwf-lancto-ctbl.cdn-empresa      = tt-dwf-lancto-ctbl.cdn-empresa    
            and   dwf-lancto-ctbl.cod-modul-dtsul  = tt-dwf-lancto-ctbl.cod-modul-dtsul
            and   dwf-lancto-ctbl.cod-lote-ctbl    = tt-dwf-lancto-ctbl.cod-lote-ctbl  
            and   dwf-lancto-ctbl.cod-lancto-ctbl  = tt-dwf-lancto-ctbl.cod-lancto-ctbl
            and   dwf-lancto-ctbl.dat-inic-valid  <= dat-today.
        end.
        
        do trans:
            if  not avail dwf-lancto-ctbl then do:
                create dwf-lancto-ctbl.
                buffer-copy tt-dwf-lancto-ctbl to dwf-lancto-ctbl.
                ASSIGN dwf-lancto-ctbl.log-livre-1 = YES. 
            end.
            else do:
                find b-dwf-lancto-ctbl exclusive-lock
                     where rowid(b-dwf-lancto-ctbl) = rowid(dwf-lancto-ctbl) no-error.

                if  avail b-dwf-lancto-ctbl then do:
                    buffer-copy tt-dwf-lancto-ctbl except cod-empresa
                                                          cdn-empresa    
                                                          cod-modul-dtsul
                                                          cod-lote-ctbl  
                                                          cod-lancto-ctbl to b-dwf-lancto-ctbl.
                    ASSIGN b-dwf-lancto-ctbl.log-livre-1 = YES.
                end.
            end.
        end.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-bofi178:
    
    run pi-acompanhar in h-acomp (input 'Efetivando Extraá∆o: Itens Lancto Cont†bil').

    def buffer b-dwf-item-lancto-ctbl for dwf-item-lancto-ctbl.

    for each tt-dwf-item-lancto-ctbl:
        
        for last dwf-item-lancto-ctbl use-index dwftmlnc-id no-lock
            where dwf-item-lancto-ctbl.cod-empresa         = tt-dwf-item-lancto-ctbl.cod-empresa        
            and   dwf-item-lancto-ctbl.cdn-empresa         = tt-dwf-item-lancto-ctbl.cdn-empresa        
            and   dwf-item-lancto-ctbl.cod-modul-dtsul     = tt-dwf-item-lancto-ctbl.cod-modul-dtsul    
            and   dwf-item-lancto-ctbl.cod-lote-ctbl       = tt-dwf-item-lancto-ctbl.cod-lote-ctbl      
            and   dwf-item-lancto-ctbl.cod-lancto-ctbl     = tt-dwf-item-lancto-ctbl.cod-lancto-ctbl    
            and   dwf-item-lancto-ctbl.num-seq-lancto-ctbl = tt-dwf-item-lancto-ctbl.num-seq-lancto-ctbl
            and   dwf-item-lancto-ctbl.dat-inic-valid     <= dat-today.
        end.
        
        do trans:
            if  not avail dwf-item-lancto-ctbl then do:
                create dwf-item-lancto-ctbl.
                buffer-copy tt-dwf-item-lancto-ctbl to dwf-item-lancto-ctbl.
                ASSIGN dwf-item-lancto-ctbl.log-livre-1 = YES.
            end.
            else do:
                find b-dwf-item-lancto-ctbl exclusive-lock
                     where rowid(b-dwf-item-lancto-ctbl) = rowid(dwf-item-lancto-ctbl) no-error.
                if  avail b-dwf-item-lancto-ctbl then do:
                    buffer-copy tt-dwf-item-lancto-ctbl except cod-empresa
                                                               cdn-empresa        
                                                               cod-modul-dtsul    
                                                               cod-lote-ctbl      
                                                               cod-lancto-ctbl    
                                                               num-seq-lancto-ctbl to b-dwf-item-lancto-ctbl.
                    ASSIGN  b-dwf-item-lancto-ctbl.log-livre-1 = YES.                                                             
                end.
            end.
        end.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-bofi179:

    run pi-acompanhar in h-acomp (input 'Efetivando Extraá∆o: Saldos Cont†beis').
    
    def buffer b-dwf-sdo-ctbl for dwf-sdo-ctbl.

    for each tt-dwf-sdo-ctbl:
        create dwf-sdo-ctbl.
        buffer-copy tt-dwf-sdo-ctbl to dwf-sdo-ctbl.
        ASSIGN dwf-sdo-ctbl.log-livre-1 = yes.
        
    end.

end procedure.
/***************************************************************************************************/
procedure pi-bofi297:
    
    run pi-acompanhar in h-acomp (input 'Efetivando Extraá∆o: Saldos Antes Encer.').
    
    def buffer b-dwf-sdo-ctbl-antes-encert for dwf-sdo-ctbl-antes-encert.

    for each tt-dwf-sdo-ctbl-antes-encert:
        
        for last dwf-sdo-ctbl-antes-encert fields (cod-empresa      
                                                    cod-estab        
                                                    cod-modul-dtsul  
                                                    dat-apurac-restdo
                                                    cod-cta-ctbl     
                                                    cod-ccusto       
                                                    dat-inic-valid) use-index dwfsdcta-id no-lock
            where dwf-sdo-ctbl-antes-encert.cod-empresa       = tt-dwf-sdo-ctbl-antes-encert.cod-empresa      
            and   dwf-sdo-ctbl-antes-encert.cod-estab         = tt-dwf-sdo-ctbl-antes-encert.cod-estab        
            and   dwf-sdo-ctbl-antes-encert.cod-modul-dtsul   = tt-dwf-sdo-ctbl-antes-encert.cod-modul-dtsul  
            and   dwf-sdo-ctbl-antes-encert.dat-apurac-restdo = tt-dwf-sdo-ctbl-antes-encert.dat-apurac-restdo
            and   dwf-sdo-ctbl-antes-encert.cod-cta-ctbl      = tt-dwf-sdo-ctbl-antes-encert.cod-cta-ctbl     
            and   dwf-sdo-ctbl-antes-encert.cod-ccusto        = tt-dwf-sdo-ctbl-antes-encert.cod-ccusto
            and   dwf-sdo-ctbl-antes-encert.cod-unid-neg      = tt-dwf-sdo-ctbl-antes-encert.cod-unid-neg
            and   dwf-sdo-ctbl-antes-encert.dat-inic-valid   <= dat-today.
        end.

        do trans:
            if  not avail dwf-sdo-ctbl-antes-encert then do:
                create dwf-sdo-ctbl-antes-encert.
                buffer-copy tt-dwf-sdo-ctbl-antes-encert to dwf-sdo-ctbl-antes-encert.
            end.
            else do:
                find first b-dwf-sdo-ctbl-antes-encert exclusive-lock
                     where rowid(b-dwf-sdo-ctbl-antes-encert) = rowid(dwf-sdo-ctbl-antes-encert) no-error.
                if  avail b-dwf-sdo-ctbl-antes-encert then do:
                    buffer-copy tt-dwf-sdo-ctbl-antes-encert except cod-empresa      
                                                                    cod-estab        
                                                                    cod-modul-dtsul  
                                                                    dat-apurac-restdo
                                                                    cod-cta-ctbl     
                                                                    cod-ccusto to b-dwf-sdo-ctbl-antes-encert.
               end.
            end.
        end.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-bofi318:

    run pi-acompanhar in h-acomp (input 'Efetivando Extraá∆o: Aglutinaá∆o').
    
    def buffer b-dwf-cta-aglut for dwf-cta-aglut.

    for each tt-dwf-cta-aglut:

        for last dwf-cta-aglut fields (cod-empresa       
                                        cod-cta-ctbl      
                                        cod-cta-ctbl-aglut
                                        cod-ccusto        
                                        dat-inic-valid) use-index dwfctglt-id no-lock
            where dwf-cta-aglut.cod-empresa        = tt-dwf-cta-aglut.cod-empresa       
            and   dwf-cta-aglut.cod-cta-ctbl       = tt-dwf-cta-aglut.cod-cta-ctbl      
            and   dwf-cta-aglut.cod-cta-ctbl-aglut = tt-dwf-cta-aglut.cod-cta-ctbl-aglut
            and   dwf-cta-aglut.cod-ccusto         = tt-dwf-cta-aglut.cod-ccusto
            and   dwf-cta-aglut.cod-unid-negoc     = tt-dwf-cta-aglut.cod-unid-negoc
            and   dwf-cta-aglut.dat-inic-valid    <= dat-today.
        end.

        do trans:
            if  not avail dwf-cta-aglut then do:
                create dwf-cta-aglut.
                buffer-copy tt-dwf-cta-aglut to dwf-cta-aglut.
            end.
            else do:
                find b-dwf-cta-aglut exclusive-lock
                     where rowid(b-dwf-cta-aglut) = rowid(dwf-cta-aglut) no-error.
                if  avail b-dwf-cta-aglut then do:
                    buffer-copy tt-dwf-cta-aglut except cod-empresa       
                                                        cod-cta-ctbl      
                                                        cod-cta-ctbl-aglut
                                                        cod-ccusto to b-dwf-cta-aglut.
                end.
            end.
        end.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-bofi319:

    run pi-acompanhar in h-acomp (input 'Efetivando Extraá∆o: Demonstrativo').
    
    def buffer b-dwf-demonst-ctbl-bloco for dwf-demonst-ctbl-bloco.

    for each tt-dwf-demonst-ctbl-bloco:

        for last dwf-demonst-ctbl-bloco fields (cod-empresa          
                                                dat-inic-demonst-ctbl
                                                dat-inic-valid) use-index dwfdmnsb-id no-lock
            where dwf-demonst-ctbl-bloco.cod-empresa           = tt-dwf-demonst-ctbl-bloco.cod-empresa          
            and   dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl = tt-dwf-demonst-ctbl-bloco.dat-inic-demonst-ctbl
            and   dwf-demonst-ctbl-bloco.dat-inic-valid       <= dat-today.
        end.

        do trans:
            if  not avail dwf-demonst-ctbl-bloco then do:
                create dwf-demonst-ctbl-bloco.
                buffer-copy tt-dwf-demonst-ctbl-bloco to dwf-demonst-ctbl-bloco.
            end.
            else do:
                find b-dwf-demonst-ctbl-bloco exclusive-lock
                     where rowid(b-dwf-demonst-ctbl-bloco) = rowid(dwf-demonst-ctbl-bloco) no-error.
                if  avail b-dwf-demonst-ctbl-bloco then do:
                    buffer-copy tt-dwf-demonst-ctbl-bloco except cod-empresa           
                                                             dat-inic-demonst-ctbl to b-dwf-demonst-ctbl-bloco.
                end.
            end.
        end.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-bofi320:

    run pi-acompanhar in h-acomp (input 'Efetivando Extraá∆o: Balanáo Patrimonial').
    
    def buffer b-dwf-balan-patrim for dwf-balan-patrim.

    for each tt-dwf-balan-patrim:
            
        for last dwf-balan-patrim fields (cod-empresa          
                                          dat-inic-demonst-ctbl
                                          cod-cta-ctbl-aglut   
                                          dat-inic-valid) use-index dwfblnpt-id no-lock
            where dwf-balan-patrim.cod-empresa           = tt-dwf-balan-patrim.cod-empresa          
            and   dwf-balan-patrim.dat-inic-demonst-ctbl = tt-dwf-balan-patrim.dat-inic-demonst-ctbl
            and   dwf-balan-patrim.cod-cta-ctbl-aglut    = tt-dwf-balan-patrim.cod-cta-ctbl-aglut
            and   dwf-balan-patrim.dat-inic-valid       <= dat-today.
        end.
        
        do trans:
            if  not avail dwf-balan-patrim then do:
                create dwf-balan-patrim.
                buffer-copy tt-dwf-balan-patrim to dwf-balan-patrim.
            end.
            else do:
                find b-dwf-balan-patrim exclusive-lock
                     where rowid(b-dwf-balan-patrim) = rowid(dwf-balan-patrim) no-error.
                if  avail b-dwf-balan-patrim then do:
                    buffer-copy tt-dwf-balan-patrim except cod-empresa          
                                                           dat-inic-demonst-ctbl
                                                           cod-cta-ctbl-aglut to b-dwf-balan-patrim.
                end.
            end.
        end.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-bofi321:
    
    run pi-acompanhar in h-acomp (input 'Efetivando Extraá∆o: Demonstrativo Resultado Exerc°cio').
    
    def buffer b-dwf-demonst-restdo-exerc for dwf-demonst-restdo-exerc.

    for each tt-dwf-demonst-restdo-exerc:

        for last dwf-demonst-restdo-exerc fields (cod-empresa          
                                                   dat-inic-demonst-ctbl
                                                   cod-cta-ctbl-aglut   
                                                   ind-sit-sdo          
                                                   num-seq-indic-sit-sdo
                                                   dat-inic-valid) use-index dwfdmnsc-id no-lock
            where dwf-demonst-restdo-exerc.cod-empresa           = tt-dwf-demonst-restdo-exerc.cod-empresa          
            and   dwf-demonst-restdo-exerc.dat-inic-demonst-ctbl = tt-dwf-demonst-restdo-exerc.dat-inic-demonst-ctbl
            and   dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut    = tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut   
            and   dwf-demonst-restdo-exerc.ind-sit-sdo           = tt-dwf-demonst-restdo-exerc.ind-sit-sdo          
            and   dwf-demonst-restdo-exerc.num-seq-indic-sit-sdo = tt-dwf-demonst-restdo-exerc.num-seq-indic-sit-sdo
            and   dwf-demonst-restdo-exerc.dat-inic-valid       <= dat-today.
        end.
        
        do trans:
            if  not avail dwf-demonst-restdo-exerc then do:
                create dwf-demonst-restdo-exerc.
                buffer-copy tt-dwf-demonst-restdo-exerc to dwf-demonst-restdo-exerc.
            end.
            else do:
                find b-dwf-demonst-restdo-exerc exclusive-lock
                    where rowid(b-dwf-demonst-restdo-exerc) = rowid(dwf-demonst-restdo-exerc) no-error.
                if  avail b-dwf-demonst-restdo-exerc then do:
                    buffer-copy tt-dwf-demonst-restdo-exerc except cod-empresa          
                                                                   dat-inic-demonst-ctbl
                                                                   cod-cta-ctbl-aglut   
                                                                   ind-sit-sdo          
                                                                   num-seq-indic-sit-sdo to b-dwf-demonst-restdo-exerc.
                end.
            end.
        end.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-bofi298:
    
    run pi-acompanhar in h-acomp (input 'Efetivando Extraá∆o: Cta Ctbl Referància').

    for each tt-dwf-cta-ctbl-refer:

        for each  dwf-cta-ctbl-refer use-index dwfctcta-id exclusive-lock
            where dwf-cta-ctbl-refer.cod-empresa     = tt-dwf-cta-ctbl-refer.cod-empresa    
            and   dwf-cta-ctbl-refer.cod-cta-ctbl    = tt-dwf-cta-ctbl-refer.cod-cta-ctbl   
            and   dwf-cta-ctbl-refer.cod-ccusto      = tt-dwf-cta-ctbl-refer.cod-ccusto     
            and   dwf-cta-ctbl-refer.cod-unid-neg    = tt-dwf-cta-ctbl-refer.cod-unid-neg
            and   dwf-cta-ctbl-refer.dat-inic-period = tt-dwf-cta-ctbl-refer.dat-inic-period
            and   dwf-cta-ctbl-refer.dat-fim-period  = tt-dwf-cta-ctbl-refer.dat-fim-period:
            delete dwf-cta-ctbl-refer.
        end.

        create dwf-cta-ctbl-refer.
        buffer-copy tt-dwf-cta-ctbl-refer to dwf-cta-ctbl-refer.

    end.

end procedure.
/***************************************************************************************************/
procedure pi-bofi187:

    run pi-acompanhar in h-acomp (input 'Efetivando Extraá∆o: Estabelecimento').

    for each tt-dwf-estab-extens:

        for last dwf-estab-extens fields (cod-estab     
                                          dat-inic-valid) use-index dwfstbxt-id no-lock
            where dwf-estab-extens.cod-estab      = tt-dwf-estab-extens.cod-estab      
            and   dwf-estab-extens.dat-inic-valid <= dat-today
            and   dwf-estab-extens.dat-fim-valid  = ?.
        end.

        if  not avail dwf-estab-extens then do:
            create dwf-estab-extens.
            buffer-copy tt-dwf-estab-extens to dwf-estab-extens.
        end.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-bofi180:

    run pi-acompanhar in h-acomp (input 'Efetivando Extraá∆o: Contas Cont†beis').

    for each tt-dwf-cta-ctbl:

        for each  dwf-cta-ctbl use-index dwfctctb-id exclusive-lock
            where dwf-cta-ctbl.cod-empresa     = tt-dwf-cta-ctbl.cod-empresa   
            and   dwf-cta-ctbl.cdn-empresa     = tt-dwf-cta-ctbl.cdn-empresa   
            and   dwf-cta-ctbl.cod-cta-ctbl    = tt-dwf-cta-ctbl.cod-cta-ctbl
        transaction:
            delete dwf-cta-ctbl.
        end.

        do trans:
            create dwf-cta-ctbl.
            buffer-copy tt-dwf-cta-ctbl to dwf-cta-ctbl.
        end.

    end.

end procedure.
/***************************************************************************************************/
procedure pi-bofi217:
    
    run pi-acompanhar in h-acomp (input 'Efetivando Extraá∆o: Plano Centro de Custo').
    
    for each tt-dwf-plano-ccusto:

        for each  dwf-plano-ccusto use-index dwfplncc-id exclusive-lock
            where dwf-plano-ccusto.cod-empresa      = tt-dwf-plano-ccusto.cod-empresa     
            and   dwf-plano-ccusto.cdn-empresa      = tt-dwf-plano-ccusto.cdn-empresa     
            and   dwf-plano-ccusto.cod-plano-ccusto = tt-dwf-plano-ccusto.cod-plano-ccusto trans:
            delete dwf-plano-ccusto.
        end.
        
        do trans:
            create dwf-plano-ccusto.
            buffer-copy tt-dwf-plano-ccusto to dwf-plano-ccusto.
        end.

    end.

end procedure.
/***************************************************************************************************/
procedure pi-bofi181:

    run pi-acompanhar in h-acomp (input 'Efetivando Extraá∆o: Centro de Custo').
    
    for each tt-dwf-ccusto:
            
        for each  dwf-ccusto use-index dwfccst-id exclusive-lock
            where dwf-ccusto.cod-empresa    = tt-dwf-ccusto.cod-empresa   
            and   dwf-ccusto.cdn-empresa    = tt-dwf-ccusto.cdn-empresa   
            and   dwf-ccusto.cod-ccusto     = tt-dwf-ccusto.cod-ccusto 
            and   dwf-ccusto.cod-unid-neg   = tt-dwf-ccusto.cod-unid-neg trans:
            delete dwf-ccusto.
        end.
            
        do trans:
            create dwf-ccusto.
            buffer-copy tt-dwf-ccusto to dwf-ccusto.
        end.            
    end.

end procedure.
/***************************************************************************************************/
procedure pi-salva-participantes:

    run pi-acompanhar in h-acomp (input 'Efetivando Extraá∆o: Participantes').

    for each tt-dwf-participan:

        for each dwf-participan exclusive-lock
           where dwf-participan.cod-empresa = tt-dwf-participan.cod-empresa
             and dwf-participan.cod-estab = tt-dwf-participan.cod-estab
             and dwf-participan.cod-participan = tt-dwf-participan.cod-participan:
             delete dwf-participan.
         end.

        do trans:
            create dwf-participan.
            buffer-copy tt-dwf-participan to dwf-participan.
        end.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-extrair-estabelecimento:

    define variable h-lfapi074 as handle  no-undo.

    {utp/ut-liter.i Extraindo_Estabelecimentos *}
    run pi-acompanhar in h-acomp (input return-value).

    run lfp/lfapi074.p persistent set h-lfapi074.
    run pi-inicializa-dbos in h-lfapi074.

    for each estabelec fields (cod-estabel)
       where estabelec.ep-codigo = tt-param.i-empresa-ems2 no-lock:

        IF  v_log_epc THEN DO:
            IF estabelec.cod-estabel < v_cod_estab_ini OR estabelec.cod-estabel > v_cod_estab_fim THEN
                NEXT.
        END.

        run pi-estabelecimento in h-lfapi074 (input estabelec.cod-estabel, output table tt-RowErrors).   /*** api estabelecimento ***/

        if not can-find(first tt-log-erros-sped) then do:
            create tt-dwf-estab-extens.
            assign tt-dwf-estab-extens.cod-empresa    = string(estabelec.ep-codigo)
                   tt-dwf-estab-extens.cod-estab      = estabelec.cod-estab
                   tt-dwf-estab-extens.dat-inic-valid = dat-today
                   tt-dwf-estab-extens.dat-fim-valid  = ?.
        end.

    end.
    if not can-find(first tt-log-erros-sped) then
        run pi-retorna-tts in h-lfapi074 (output table tt-dwf-estab,
                                          output table tt-dwf-pessoa, 
                                          output table tt-dwf-ender).

    run pi-finaliza-dbos in h-lfapi074.

    if valid-handle(h-lfapi074) then do:
       delete procedure h-lfapi074.
       assign h-lfapi074 = ?.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-tratar-dwf-item-lancto-ctbl-orfao:
        
    def var i-reg    as integer no-undo.
    def var c-acomp  as char    no-undo.

    /* Somente executa uma vez esta procedure, Ç um processamento relativamente demorado, assim,
       foi feito um controle atravÇs de funá∆o para que a l¢gica somente seja executado uma vez.
       O que ir† ocorrer Ç que na primeira vez, caso a funá∆o n∆o exista, de haver uma demora
       mais consider†vel no tempo de processamento */

    if  can-find (first funcao no-lock
                  where funcao.cd-funcao = "lf0302-it-orfao":u) then
         
        return.

    def buffer b-dwf-item-lancto-ctbl for dwf-item-lancto-ctbl.

    {utp/ut-liter.i Verificando_Itens_Lancto_Ctbl_Orf∆os *}
    assign c-acomp = trim(return-value).

    for each dwf-item-lancto-ctbl fields (cod-empresa
                                          cdn-empresa    
                                          cod-modul-dtsul
                                          cod-lote-ctbl  
                                          cod-lancto-ctbl
                                          dat-inic-valid) no-lock:
        
        assign i-reg = i-reg + 1.

        if  i-reg mod 1000 = 0 then
            run pi-acompanhar in h-acomp (input c-acomp + " - " + string(i-reg)).

        for first dwf-lancto-ctbl fields (cod-empresa
                                          cdn-empresa    
                                          cod-modul-dtsul
                                          cod-lote-ctbl  
                                          cod-lancto-ctbl
                                          dat-inic-valid) use-index dwflnctc-id no-lock
            where dwf-lancto-ctbl.cod-empresa     = dwf-item-lancto-ctbl.cod-empresa    
            and   dwf-lancto-ctbl.cdn-empresa     = dwf-item-lancto-ctbl.cdn-empresa    
            and   dwf-lancto-ctbl.cod-modul-dtsul = dwf-item-lancto-ctbl.cod-modul-dtsul
            and   dwf-lancto-ctbl.cod-lote-ctbl   = dwf-item-lancto-ctbl.cod-lote-ctbl
            and   dwf-lancto-ctbl.cod-lancto-ctbl = dwf-item-lancto-ctbl.cod-lancto-ctbl.
        end.
        
        if  not avail dwf-lancto-ctbl then do trans:
            find b-dwf-item-lancto-ctbl exclusive-lock
                 where rowid(b-dwf-item-lancto-ctbl) = rowid(dwf-item-lancto-ctbl) no-error.
            if  avail b-dwf-item-lancto-ctbl then do:
                delete b-dwf-item-lancto-ctbl.
            end.
        end.
    end.
    
    do trans:
        create funcao.
        assign funcao.cd-funcao = "lf0302-it-orfao":u.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-busca-filhas:

    def input-output param p-seq   as integer no-undo.
    def input param  p-cod-sup     as character no-undo.

    if can-find(first tt-dwf-cta-ctbl no-lock
        where tt-dwf-cta-ctbl.cod-empresa = tt-param.c-empresa
          and tt-dwf-cta-ctbl.cdn-empresa = tt-param.i-empresa-ems2
          and tt-dwf-cta-ctbl.cod-cta-ctbl-sup = p-cod-sup
          and tt-dwf-cta-ctbl.dat-fim-valid = ?) then do:
            
        for each tt-dwf-cta-ctbl 
           fields (cod-empresa
                   cdn-empresa
                   cod-cta-ctbl 
                   cod-cta-ctbl-sup 
                   ind-tip-cta-ctbl
                   num-natur-grp-cta-ctbl
                   num-niv-cta-ctbl
                   des-tit-ctbl) no-lock
          where tt-dwf-cta-ctbl.cod-empresa = tt-param.c-empresa
            and tt-dwf-cta-ctbl.cdn-empresa = tt-param.i-empresa-ems2 
            and tt-dwf-cta-ctbl.cod-cta-ctbl-sup = p-cod-sup
            and tt-dwf-cta-ctbl.dat-fim-valid = ?:
            
            if  can-find(first tt-dwf-balan-patrim no-lock
                         where tt-dwf-balan-patrim.cod-empresa        = tt-dwf-cta-ctbl.cod-empresa
                           and tt-dwf-balan-patrim.cod-cta-ctbl-aglut = tt-dwf-cta-ctbl.cod-cta-ctbl) then
            do:
                assign p-seq = p-seq + 1.
                for each tt-dwf-balan-patrim
                    fields(cod-empresa
                           cod-cta-ctbl-aglut
                           num-livre-1) exclusive-lock
                    where tt-dwf-balan-patrim.cod-empresa        = tt-dwf-cta-ctbl.cod-empresa
                      and tt-dwf-balan-patrim.cod-cta-ctbl-aglut = tt-dwf-cta-ctbl.cod-cta-ctbl
                    break by tt-dwf-balan-patrim.cod-cta-ctbl-aglut:
                    assign tt-dwf-balan-patrim.num-livre-1 = p-seq.

                    if  last(tt-dwf-balan-patrim.cod-cta-ctbl-aglut) then
                        run pi-busca-filhas(input-output p-seq,
                                            input tt-dwf-cta-ctbl.cod-cta-ctbl).
                end.
            end.
            else do:
                if  can-find(first tt-dwf-demonst-restdo-exerc no-lock
                             where tt-dwf-demonst-restdo-exerc.cod-empresa        = tt-dwf-cta-ctbl.cod-empresa
                               and tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut = tt-dwf-cta-ctbl.cod-cta-ctbl) then
                do:
                    assign p-seq = p-seq + 1.
                    for each tt-dwf-demonst-restdo-exerc
                        fields(cod-empresa
                               cod-cta-ctbl-aglut
                               num-seq-indic-sit-sdo) exclusive-lock
                        where tt-dwf-demonst-restdo-exerc.cod-empresa        = tt-dwf-cta-ctbl.cod-empresa
                          and tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut = tt-dwf-cta-ctbl.cod-cta-ctbl
                        break by tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut:
                        assign tt-dwf-demonst-restdo-exerc.num-seq-indic-sit-sdo = p-seq.

                        if  last(tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut) then
                            run pi-busca-filhas(input-output p-seq,
                                                input tt-dwf-cta-ctbl.cod-cta-ctbl).
                    end.
                end.
            end.
        end.
    end.
end procedure.
/***************************************************************************************************/
procedure pi-retorna-mes-ini-fim:
    define input  parameter p-ano     as integer no-undo.
    define output parameter p-mes-ini as integer no-undo.
    define output parameter p-mes-fim as integer no-undo.    

    if p-ano = year(tt-param.dt-ini) then
        assign p-mes-ini = month(tt-param.dt-ini).
    else if p-ano < year(tt-param.dt-ini) or
            p-ano > year(tt-param.dt-fim) then
        assign p-mes-ini = 0. /* Ano inv†lido */
    else
        assign p-mes-ini = 1.

    if p-ano = year(tt-param.dt-fim) then
        assign p-mes-fim = month(tt-param.dt-fim).
    else if p-ano < year(tt-param.dt-ini) or
            p-ano > year(tt-param.dt-fim) then
        assign p-mes-fim = 0. /* Ano inv†lido */
    else
        assign p-mes-fim = 12.
end procedure.
/***************************************************************************************************/
procedure pi-integracao-diario-auxiliar-ems2-ems5:
    define buffer bf-tt-movimentos-sped-ems2 for tt-movimentos-sped-ems2.

    define variable c-cod-lote-ctbl   as char no-undo.
    define variable c-cod-lancto-ctbl as char no-undo.
    define variable num-ct-format     as int  no-undo.
    define variable num-sc-format     as int  no-undo.
    define variable c-cod-unid-negoc  as char no-undo.
    define variable i-num-pessoa      as int  no-undo.

    DEFINE VARIABLE v_cod_format_cta  AS CHAR.
    DEFINE VARIABLE v_cod_format_cc   AS CHAR.
    
    run pi_retorna_formato_ccusto in h_api_ccusto (input i-ep-codigo-usuario,    	/* EMPRESA EMS2 */
                                                   input "",          	            /* PLANO CENTRO DE CUSTO */
                                                   input today,               		/* DATA DE TRANSACAO */
                                                   output v_cod_format_cc,    		/* FORMATO CENTRO DE CUSTO */
                                                   output table tt_log_erro). 		/* ERROS */	


    run pi_retorna_formato_cta_ctbl in h_api_cta (input  i-ep-codigo-usuario,       /* EMPRESA EMS2 */
                                                  input  "",                   		/* PLANO CONTAS */
                                          		  input  today,                		/* DATA DE TRANSACAO */
                                                  output v_cod_format_cta,  		/* FORMATO CONTA */
                                                  output table tt_log_erro).   		/* ERROS */


    find first param-global no-lock no-error.
    
    assign num-ct-format = length(replace(replace(trim(v_cod_format_cta),".",""),"-",""))
           num-sc-format = length(replace(replace(trim(v_cod_format_cc),".",""),"-","")).

    /*--- Conecta bases do EMS 5 ---*/
    run pi-conecta-ems5(1).
    if can-find (first tt-log-erros-sped) then
        return.

    if valid-handle(h-ems5) then
        run pi_extrator_sped_carrega_tt_trad in h-ems5.

    if valid-handle(h-ems5) and
    tt-param.l-relaciona-lancto-participante then
        run pi_extrator_sped_carrega_tt_relacto_particip in h-ems5.

    movto_block:
    for each tt-movimentos-sped-ems2:

        if tt-movimentos-sped-ems2.valor = 0 then
            next.

        find first tt-traducao-ems2-ems5 no-lock
             where tt-traducao-ems2-ems5.ep-codigo               = tt-movimentos-sped-ems2.ep-codigo
             and   tt-traducao-ems2-ems5.cod-estabel             = tt-movimentos-sped-ems2.cod-estabel
             and   tt-traducao-ems2-ems5.cod-moeda               = 0
             and   tt-traducao-ems2-ems5.ct-codigo               = tt-movimentos-sped-ems2.ct-codigo
             and   tt-traducao-ems2-ems5.sc-codigo               = tt-movimentos-sped-ems2.sc-codigo
             and   tt-traducao-ems2-ems5.ttv_cod_cta_ctbl_contra = tt-movimentos-sped-ems2.contra-partida 
             no-error.

        if  not avail tt-traducao-ems2-ems5 then do:

            for each tt-xml-input-output:
                delete tt-xml-input-output.
            end.
            for each tt-log-erros-integracao.
                delete tt-log-erros-integracao.
            end.

            create tt-xml-input-output.
            assign tt-xml-input-output.ttv_cod_label    = "Funá∆o"
                   tt-xml-input-output.ttv_des_conteudo = "Contas Cont†beis 2.00"
                   tt-xml-input-output.ttv_num_seq_1    = 1.
            create tt-xml-input-output.
            assign tt-xml-input-output.ttv_cod_label    = "Produto"
                   tt-xml-input-output.ttv_des_conteudo = "EMS 5"
                   tt-xml-input-output.ttv_num_seq_1    = 1.
            create tt-xml-input-output.
            assign tt-xml-input-output.ttv_cod_label    = "Empresa"
                   tt-xml-input-output.ttv_des_conteudo = string(tt-movimentos-sped-ems2.ep-codigo)
                   tt-xml-input-output.ttv_num_seq_1    = 1.
            create tt-xml-input-output.
            assign tt-xml-input-output.ttv_cod_label    = "Estabel"
                   tt-xml-input-output.ttv_des_conteudo = string(tt-movimentos-sped-ems2.cod-estabel)
                   tt-xml-input-output.ttv_num_seq_1    = 1.
            create tt-xml-input-output.
            assign tt-xml-input-output.ttv_cod_label    = "Finalid"
                   tt-xml-input-output.ttv_des_conteudo = '0'
                   tt-xml-input-output.ttv_num_seq_1    = 1.
            create tt-xml-input-output.
            assign tt-xml-input-output.ttv_cod_label    = "Contas"
                   tt-xml-input-output.ttv_des_conteudo = tt-movimentos-sped-ems2.ct-codigo + ';' + 
                                                          tt-movimentos-sped-ems2.sc-codigo + ';;' +
                                                          string(tt-movimentos-sped-ems2.cod-estabel) + ';;' +
                                                          string(tt-movimentos-sped-ems2.data,'99/99/99') 
                   tt-xml-input-output.ttv_num_seq_1    = 1.
           
            /*para traduá∆o da conta cont†bil de contra partidade, utiliza a sequencia 2*/
            if  tt-movimentos-sped-ems2.contra-partida <> "" then do:
                create tt-xml-input-output.
                assign tt-xml-input-output.ttv_cod_label    = "Contas"
                       tt-xml-input-output.ttv_des_conteudo = substring(tt-movimentos-sped-ems2.contra-partida, 1, num-ct-format) +  ';' + /*conta*/
                                                              substring(tt-movimentos-sped-ems2.contra-partida, num-ct-format + 1, num-sc-format) + ';;' + /*sub-conta*/
                                                              string(tt-movimentos-sped-ems2.cod-estabel) + ';;' +
                                                              string(tt-movimentos-sped-ems2.data,'99/99/99') 
                  tt-xml-input-output.ttv_num_seq_1    = 2.
            end.

            run prgint/utb/utb786za.py (input-output table tt-xml-input-output,
                                        output       table tt-log-erros-integracao).

            if can-find(first tt-log-erros-integracao) then do:
                    
                /*Se o valor for zero e nao tem matriz de traducao para o estab entao elimina o erro e vai para o proximo movimento*/
                find first tt-log-erros-integracao
                     where tt-log-erros-integracao.ttv_num_cod_erro = 10209 no-error.

                if  tt-movimentos-sped-ems2.valor = 0 and avail tt-log-erros-integracao then do:
                    delete tt-log-erros-integracao.
                    next movto_block.
                end.

                /* nao deve validar as demais matrizes caso o valor for zero.*/
                if tt-movimentos-sped-ems2.valor <> 0 then do:
                    
                    for each tt-log-erros-integracao no-lock:
                        create tt-log-advertencias-sped.
                        assign tt-log-advertencias-sped.num-cod-erro = -1
                               tt-log-advertencias-sped.des-erro = "Msg " + string(tt-log-erros-integracao.ttv_num_cod_erro) + ": " + tt-log-erros-integracao.ttv_des_erro + " " + tt-log-erros-integracao.ttv_des_ajuda. 
                    end.                           
                    next movto_block.
                end.
            end.

            create tt-traducao-ems2-ems5.
            assign tt-traducao-ems2-ems5.ep-codigo               = tt-movimentos-sped-ems2.ep-codigo
                   tt-traducao-ems2-ems5.cod-estabel             = tt-movimentos-sped-ems2.cod-estabel
                   tt-traducao-ems2-ems5.cod-moeda               = 0
                   tt-traducao-ems2-ems5.ct-codigo               = tt-movimentos-sped-ems2.ct-codigo
                   tt-traducao-ems2-ems5.sc-codigo               = tt-movimentos-sped-ems2.sc-codigo
                   tt-traducao-ems2-ems5.ttv_cod_cta_ctbl_contra = tt-movimentos-sped-ems2.contra-partida.

            find first tt-xml-input-output no-lock
                 where tt-xml-input-output.ttv_cod_label = "Empresa" no-error.
            assign tt-traducao-ems2-ems5.tta_cod_empresa = tt-xml-input-output.ttv_des_conteudo_aux.
        
            find first tt-xml-input-output no-lock
                 where tt-xml-input-output.ttv_cod_label = "Estabel" no-error.
            assign tt-traducao-ems2-ems5.tta_cod_estab = tt-xml-input-output.ttv_des_conteudo_aux.


            /*nao cria traducao para conta e finalid*/
            if tt-movimentos-sped-ems2.valor <> 0 then do:
                for each tt-xml-input-output no-lock
                     where tt-xml-input-output.ttv_cod_label = "Contas":
                     if  tt-xml-input-output.ttv_num_seq_1 = 1 then
                        assign tt-traducao-ems2-ems5.tta_cod_plano_cta_ctbl = GetEntryField(1,tt-xml-input-output.ttv_des_conteudo_aux, ";")
                               tt-traducao-ems2-ems5.tta_cod_cta_ctbl       = GetEntryField(2,tt-xml-input-output.ttv_des_conteudo_aux, ";")
                               tt-traducao-ems2-ems5.tta_cod_plano_ccusto   = GetEntryField(3,tt-xml-input-output.ttv_des_conteudo_aux, ";")
                               tt-traducao-ems2-ems5.tta_cod_ccusto         = GetEntryField(4,tt-xml-input-output.ttv_des_conteudo_aux, ";")
                               tt-traducao-ems2-ems5.tta_cod_unid_negoc     = GetEntryField(5,tt-xml-input-output.ttv_des_conteudo_aux, ";").
                     else
                        assign tt-traducao-ems2-ems5.tta_cod_plano_cta_ctbl  = GetEntryField(1,tt-xml-input-output.ttv_des_conteudo_aux, ";")
                               tt-traducao-ems2-ems5.tta_cod_cta_ctbl_cp     = GetEntryField(2,tt-xml-input-output.ttv_des_conteudo_aux, ";")
                               tt-traducao-ems2-ems5.tta_cod_plano_ccusto_cp = GetEntryField(3,tt-xml-input-output.ttv_des_conteudo_aux, ";")
                               tt-traducao-ems2-ems5.tta_cod_ccusto_cp       = GetEntryField(4,tt-xml-input-output.ttv_des_conteudo_aux, ";")
                               tt-traducao-ems2-ems5.tta_cod_unid_negoc_cp   = GetEntryField(5,tt-xml-input-output.ttv_des_conteudo_aux, ";").
                end.

                find first tt-xml-input-output no-lock
                     where tt-xml-input-output.ttv_cod_label = "Finalid" no-error.
                assign tt-traducao-ems2-ems5.tta_cod_finalid_econ = tt-xml-input-output.ttv_des_conteudo_aux.
            end.
        end.

        if valid-handle(h-hex64) and 
           substring(tt-movimentos-sped-ems2.cod-lancto-contab,1,2) = "0x" then do:
            assign c-cod-lancto-ctbl = convert-hex-to-base64(tt-movimentos-sped-ems2.cod-lancto-contab).
        end.
        else do:
            assign c-cod-lancto-ctbl = tt-movimentos-sped-ems2.cod-lancto-contab.
        end.

        assign c-cod-lote-ctbl   = string(month(tt-movimentos-sped-ems2.data),'99') + string(year(tt-movimentos-sped-ems2.data),'9999')
               c-cod-lancto-ctbl = trim(c-cod-lancto-ctbl) + string(month(tt-movimentos-sped-ems2.data),'99') + string(year(tt-movimentos-sped-ems2.data),'9999').
               
        if length(c-cod-lancto-ctbl) > 20 then
            assign c-cod-lancto-ctbl = substring(c-cod-lancto-ctbl, 1, 20).

        find first tt-dwf-lancto-ctbl
             where tt-dwf-lancto-ctbl.cod-empresa      = tt-traducao-ems2-ems5.tta_cod_empresa
               &IF "{&mguni_version}" >= "2.07A" &THEN
               AND tt-dwf-lancto-ctbl.cdn-empresa      = tt-traducao-ems2-ems5.tta_cod_empresa
               &ELSE
               and tt-dwf-lancto-ctbl.cdn-empresa      = 0
               &ENDIF
               and tt-dwf-lancto-ctbl.cod-modul-dtsul  = tt-movimentos-sped-ems2.cod-modul
               and tt-dwf-lancto-ctbl.cod-lote-ctbl    = c-cod-lote-ctbl
               and tt-dwf-lancto-ctbl.cod-lancto-ctbl  = c-cod-lancto-ctbl
               and tt-dwf-lancto-ctbl.dat-inic-valid   = dat-today
             no-lock no-error.

        if not avail tt-dwf-lancto-ctbl then do:
            create tt-dwf-lancto-ctbl.
            assign tt-dwf-lancto-ctbl.cod-empresa              = tt-traducao-ems2-ems5.tta_cod_empresa
                   &IF "{&mguni_version}" >= "2.07A" &THEN
                   tt-dwf-lancto-ctbl.cdn-empresa              = tt-traducao-ems2-ems5.tta_cod_empresa
                   &ELSE
                   tt-dwf-lancto-ctbl.cdn-empresa              = 0
                   &ENDIF
                   tt-dwf-lancto-ctbl.cod-lote-ctbl            = replace(c-cod-lote-ctbl, "|", " ")
                   tt-dwf-lancto-ctbl.cod-lancto-ctbl          = replace(c-cod-lancto-ctbl, "|", " ")
                   tt-dwf-lancto-ctbl.cod-modul-dtsul          = tt-movimentos-sped-ems2.cod-modul
                   tt-dwf-lancto-ctbl.dat-lancto-ctbl          = tt-movimentos-sped-ems2.data
                   tt-dwf-lancto-ctbl.log-lancto-apurac-restdo = no
                   tt-dwf-lancto-ctbl.ind-lancto-ctbl          = "N" 
                   tt-dwf-lancto-ctbl.val-lancto-ctbl          = 0
                   tt-dwf-lancto-ctbl.dat-inic-valid           = dat-today
                   tt-dwf-lancto-ctbl.dat-fim-valid            = ?.
        end.

        assign c-cod-unid-negoc = if tt-movimentos-sped-ems2.cod-unid-negoc <> "" 
                                  then tt-movimentos-sped-ems2.cod-unid-negoc 
                                  else tt-traducao-ems2-ems5.tta_cod_unid_negoc.

        if valid-handle(h-ems5) then
            run pi_extrator_sped_verifica_un_depara in h-ems5 (input tt-traducao-ems2-ems5.tta_cod_cta_ctbl,
                                                               input tt-traducao-ems2-ems5.tta_cod_ccusto,
                                                               input c-cod-unid-negoc,
                                                               input tt-movimentos-sped-ems2.data,
                                                               output c-cod-unid-negoc).

        if tt-movimentos-sped-ems2.transacao = 1 then
            assign tt-dwf-lancto-ctbl.val-lancto-ctbl = tt-dwf-lancto-ctbl.val-lancto-ctbl + tt-movimentos-sped-ems2.valor.

        create tt-dwf-item-lancto-ctbl.
        assign tt-dwf-item-lancto-ctbl.cod-empresa              = tt-traducao-ems2-ems5.tta_cod_empresa
               &IF "{&mguni_version}" >= "2.07A" &THEN
               tt-dwf-item-lancto-ctbl.cdn-empresa              = tt-traducao-ems2-ems5.tta_cod_empresa
               &ELSE
               tt-dwf-item-lancto-ctbl.cdn-empresa              = 0
               &ENDIF
               tt-dwf-item-lancto-ctbl.cod-lote-ctbl            = replace(c-cod-lote-ctbl, "|", " ")
               tt-dwf-item-lancto-ctbl.cod-lancto-ctbl          = replace(c-cod-lancto-ctbl, "|", " ")
               tt-dwf-item-lancto-ctbl.num-seq-lancto-ctbl      = recid(tt-movimentos-sped-ems2) /* TODO ver recid(movto_fisc) */
               tt-dwf-item-lancto-ctbl.cod-estab                = tt-traducao-ems2-ems5.tta_cod_estab
               tt-dwf-item-lancto-ctbl.cod-cta-ctbl             = tt-traducao-ems2-ems5.tta_cod_cta_ctbl
               tt-dwf-item-lancto-ctbl.cod-ccusto               = tt-traducao-ems2-ems5.tta_cod_ccusto
               tt-dwf-item-lancto-ctbl.cod-unid-negoc           = c-cod-unid-negoc
               tt-dwf-item-lancto-ctbl.ind-natur-lancto-ctbl    = if tt-movimentos-sped-ems2.transacao = 1 then "D" else "C" 
               tt-dwf-item-lancto-ctbl.val-lancto-ctbl          = tt-movimentos-sped-ems2.valor
               tt-dwf-item-lancto-ctbl.des-histor-lancto-ctbl   = if tt-movimentos-sped-ems2.historico <> ? and trim(tt-movimentos-sped-ems2.historico) <> "" then
                                                                      replace(substr(tt-movimentos-sped-ems2.historico,1,150), "|", " ")
                                                                  else
                                                                      '(Aut) - Movimento Cont†bil do dia ' + string(tt-movimentos-sped-ems2.data, '99/99/9999')
               tt-dwf-item-lancto-ctbl.des-histor-lancto-ctbl   = replace(tt-dwf-item-lancto-ctbl.des-histor-lancto-ctbl, chr(13), " ")
               tt-dwf-item-lancto-ctbl.des-histor-lancto-ctbl   = replace(tt-dwf-item-lancto-ctbl.des-histor-lancto-ctbl, chr(10), " ")
               tt-dwf-item-lancto-ctbl.cod-arq-lancto-ctbl      = replace(tt-movimentos-sped-ems2.num-arquivamento, "|", " ")
               tt-dwf-item-lancto-ctbl.cod-modul-dtsul          = tt-movimentos-sped-ems2.cod-modul
               tt-dwf-item-lancto-ctbl.dat-livre-1              = tt-movimentos-sped-ems2.data
               tt-dwf-item-lancto-ctbl.dat-inic-valid           = dat-today
               tt-dwf-item-lancto-ctbl.dat-fim-valid            = ?.

        run pi-registra-empresa-utilizada (input tt-dwf-item-lancto-ctbl.cod-empresa,
                                           input tt-dwf-item-lancto-ctbl.cdn-empresa).

        /* Relaciona participantes de acordo com a contabilidade (a tt-relacto Ç criada com 
           os registros de relacionamento existentes no produto respons†vel pela contabilidade
           do cliente ) */

        assign i-num-pessoa = 0.

        if valid-handle(h-ems5) and
           tt-param.l-relaciona-lancto-participante then
            run pi_extrator_sped_retorna_pessoa_clien_fornec in h-ems5 (input tt-traducao-ems2-ems5.tta_cod_empresa,
                                                                        input tt-movimentos-sped-ems2.cod-emitente,
                                                                        output i-num-pessoa).

        if i-num-pessoa <> 0 then do:                                                              
            for each tt-relacto-particip-pessoa no-lock
                where tt-relacto-particip-pessoa.cod-empresa = tt-traducao-ems2-ems5.tta_cod_empresa
                  and tt-relacto-particip-pessoa.num-pessoa  = i-num-pessoa:
                /* s¢ vincula ou cria a tabela se estiver valido para a data do movimento */
                if  tt-relacto-particip-pessoa.dat-inic-valid <= tt-movimentos-sped-ems2.data
                and (tt-relacto-particip-pessoa.dat-fim-valid >= tt-movimentos-sped-ems2.data or
                     tt-relacto-particip-pessoa.dat-fim-valid = ?) then do:
                    assign tt-dwf-item-lancto-ctbl.cod-particip = string(tt-relacto-particip-pessoa.num-pessoa).
                end.
            end.
        end.

        /* Se o extrato de vers∆o estiver ativo, cria temp para dump dos dados traduzidos */
        if c-arquivo-log <> "" then do:
            
            create tt_movimentos_ems5.
            assign tt_movimentos_ems5.ttv_dat_trans_diario     = tt-movimentos-sped-ems2.data
                   tt_movimentos_ems5.ttv_cdn_clien_fornec     = tt-movimentos-sped-ems2.cod-emitente
                   tt_movimentos_ems5.ttv_val_movto            = tt-movimentos-sped-ems2.valor
                   tt_movimentos_ems5.tta_ind_natur_lancto_ctbl= if tt-movimentos-sped-ems2.transacao = 1 then "DB" else "CR"
                   tt_movimentos_ems5.ttv_cod_arq_ems2         = trim(tt-movimentos-sped-ems2.num-arquivamento)
                   tt_movimentos_ems5.ttv_cod_lancto_ctbl      = string(month(tt-movimentos-sped-ems2.data),'99') +
                                                                 string(year(tt-movimentos-sped-ems2.data),'9999').

            assign tt_movimentos_ems5.ttv_des_historico = substr(tt-movimentos-sped-ems2.historico,1,150)
                   tt_movimentos_ems5.ttv_des_historico = replace(tt_movimentos_ems5.ttv_des_historico , chr(13), " ")
                   tt_movimentos_ems5.ttv_des_historico = replace(tt_movimentos_ems5.ttv_des_historico , chr(10), " ").

            assign tt_movimentos_ems5.tta_cod_empresa        = tt-traducao-ems2-ems5.tta_cod_empresa
                   tt_movimentos_ems5.tta_cod_estab          = tt-traducao-ems2-ems5.tta_cod_estab
                   tt_movimentos_ems5.tta_cod_plano_cta_ctbl = tt-traducao-ems2-ems5.tta_cod_plano_cta_ctbl
                   tt_movimentos_ems5.tta_cod_cta_ctbl       = tt-traducao-ems2-ems5.tta_cod_cta_ctbl
                   tt_movimentos_ems5.tta_cod_plano_ccusto   = tt-traducao-ems2-ems5.tta_cod_plano_ccusto
                   tt_movimentos_ems5.tta_cod_ccusto         = tt-traducao-ems2-ems5.tta_cod_ccusto
                   tt_movimentos_ems5.tta_cod_unid_negoc     = tt-dwf-item-lancto-ctbl.cod-unid-negoc
                   tt_movimentos_ems5.tta_cod_finalid_econ   = tt-traducao-ems2-ems5.tta_cod_finalid_econ.
            assign tt_movimentos_ems5.ttv_cod_cta_ctbl_contra  = tt-traducao-ems2-ems5.tta_cod_cta_ctbl_cp
                   tt_movimentos_ems5.ttv_cod_lancto_ctbl      = tt-movimentos-sped-ems2.cod-lancto-contab
                   tt_movimentos_ems5.ttv_cod_modul            = tt-movimentos-sped-ems2.cod-modul.

        end.       

        delete tt-movimentos-sped-ems2.
    end.


    /*---  Desconecta as bases do EMS5 ---*/
    run pi-conecta-ems5(2).

end procedure.

/***************************************************************************************************/
procedure pi-registra-empresa-utilizada:
    def var v-cod-empres-ems-2 as char no-undo.
    def var v-cod-empres-ems-5 as char no-undo.
    define var h-ems5-aux      as handle no-undo.
    define input parameter p-cod-empresa as char no-undo.
    define input parameter p-cdn-empresa like mgcad.empresa.ep-codigo no-undo.

    if not can-find (first tt-empresas-utilizadas
                     where tt-empresas-utilizadas.cod-empresa = p-cod-empresa
                       and tt-empresas-utilizadas.cdn-empresa = p-cdn-empresa) then do:
        create tt-empresas-utilizadas.
        assign tt-empresas-utilizadas.cod-empresa = p-cod-empresa
               tt-empresas-utilizadas.cdn-empresa = p-cdn-empresa.

        if tt-param.c-contabilidade <> "ems2" then do:
            if  search("prgint/utb/utb733za.r") <> ? then do:
                run prgint/utb/utb733za.r persistent set h-ems5-aux (input 1).
                assign v-cod-empres-ems-2 = string(p-cdn-empresa)
                       v-cod-empres-ems-5 = p-cod-empresa.
                run pi_retorna_empresa_traduzida in h-ems5-aux (input tt-param.c-contabilidade,
                                                                input-output v-cod-empres-ems-2,
                                                                input-output v-cod-empres-ems-5).
                delete procedure h-ems5-aux.
                create tt-empresas-utilizadas.
                if  tt-param.c-contabilidade = "ems2" then do:
                    assign tt-empresas-utilizadas.cod-empresa = v-cod-empres-ems-5
                       &IF "{&mguni_version}" >= "2.071" &THEN
                           tt-empresas-utilizadas.cdn-empresa = "0".
                       &ELSE
                           tt-empresas-utilizadas.cdn-empresa = 0.
                       &ENDIF
                end.
                else do:
                    assign tt-empresas-utilizadas.cod-empresa = v-cod-empres-ems-2
                       &IF "{&mguni_version}" >= "2.071" &THEN
                           tt-empresas-utilizadas.cdn-empresa = v-cod-empres-ems-2.
                       &ELSE
                           tt-empresas-utilizadas.cdn-empresa = int(v-cod-empres-ems-2).
                       &ENDIF
                end.
            end.
        end.
    end.
end procedure.
/***************************************************************************************************/
procedure pi-salva-historico-execucao:

    def var l-ok as logical no-undo.
    def var c-contabilidade as char no-undo.
    def var c-diario as char no-undo.
    def var c-tipo-balancete as char no-undo.

    {utp/ut-liter.i Salvando_Hist¢rico *}
    run pi-acompanhar in h-acomp (input return-value).

    /* Preenche o hist¢rico com os meses que n∆o possuem saldo/movimento */
    for each tt-empresas-utilizadas:
        for each tt_period:
            for each tt-modulo
               where tt-modulo.l-selecionado = yes
               break by tt-modulo.i-id:
                if first-of(tt-modulo.i-id) then do:
                    if not can-find(first tt-totalizador-historico
                                    where tt-totalizador-historico.c-empresa = tt-empresas-utilizadas.cod-empresa
                                      and tt-totalizador-historico.i-ano = tt_period.ttv_num_ano
                                      and tt-totalizador-historico.i-periodo = tt_period.ttv_num_mes
                                      and tt-totalizador-historico.c-modulo = tt-modulo.c-modulo-refer) then do:
                        create tt-totalizador-historico.
                        assign tt-totalizador-historico.c-empresa = tt-empresas-utilizadas.cod-empresa
                               tt-totalizador-historico.c-modulo  = tt-modulo.c-modulo-refer
                               tt-totalizador-historico.i-ano     = tt_period.ttv_num_ano
                               tt-totalizador-historico.i-periodo = tt_period.ttv_num_mes
                               tt-totalizador-historico.dt-ini    = tt_period.ttv_dat_inic_param
                               tt-totalizador-historico.dt-fim    = tt_period.ttv_dat_fim_param
                               tt-totalizador-historico.d-tot-db  = 0
                               tt-totalizador-historico.d-tot-cr  = 0.
                    end.
                end.
            end.
        end.
    end.

    assign c-contabilidade  = (if tt-param.c-contabilidade = "ems2" then "EMS 2" else "EMS 5")
           c-diario         = (if tt-param.c-diario = "diariogeral" then "Geral" else "Auxiliar").

    if tt-param.l-balancete then
        assign c-tipo-balancete = (if tt-param.c-tipo-balancete = "estrutura" then "Estruturado" else "").
    else
        assign c-tipo-balancete = "".

    for each tt-totalizador-historico:
        create dwf-histor-sped-ctbl.
        assign dwf-histor-sped-ctbl.cod-empresa                  = tt-totalizador-historico.c-empresa
               dwf-histor-sped-ctbl.cod-estab                    = ""
               dwf-histor-sped-ctbl.dat-inic-period              = tt-totalizador-historico.dt-ini
               dwf-histor-sped-ctbl.dat-fim-period               = tt-totalizador-historico.dt-fim
               dwf-histor-sped-ctbl.cod-produt-dtsul             = (if tt-param.c-contabilidade = "ems2" then "EMS 2" else "EMS 5")
               dwf-histor-sped-ctbl.ind-diario                   = (if tt-param.c-diario = "diariogeral" then "Geral" else "Auxiliar")
               dwf-histor-sped-ctbl.ind-balanct-ctbl             = (if tt-param.l-balancete then c-tipo-balancete else "")
               dwf-histor-sped-ctbl.num-niv                      = tt-param.i-nivel
               dwf-histor-sped-ctbl.cod-demonst-ctbl-balan-pat   = (if tt-param.l-demonstrativo then tt-param.c-balanco else "")
               dwf-histor-sped-ctbl.cod-demonst-ctbl-demo-restdo = (if tt-param.l-demonstrativo then tt-param.c-demonstracao else "")
               dwf-histor-sped-ctbl.cod-cenar-ctbl               = tt-param.c-cenario-contabil
               dwf-histor-sped-ctbl.cod-modul-dtsul              = tt-totalizador-historico.c-modulo
               dwf-histor-sped-ctbl.val-tot-lancto-db            = tt-totalizador-historico.d-tot-db
               dwf-histor-sped-ctbl.val-tot-lancto-cr            = tt-totalizador-historico.d-tot-cr
               dwf-histor-sped-ctbl.cod-usuario                  = tt-param.usuario
               dwf-histor-sped-ctbl.dat-gerac-extrac             = today
               dwf-histor-sped-ctbl.hra-gerac-extrac             = replace(string(time,"HH:MM:SS"),":","") /* replace devido ao formato do campo 99:99:99 */
               &if "{&mgadm_version}" >= "2.09" &then
               dwf-histor-sped-ctbl.log-gera-j100                = tt-param.l-gera-j100
               dwf-histor-sped-ctbl.log-apurac-result-sped       = tt-param.l-apura-result-sped
               &else
               dwf-histor-sped-ctbl.log-livre-1                  = tt-param.l-gera-j100
               dwf-histor-sped-ctbl.log-livre-2                  = tt-param.l-apura-result-sped
               &endif
               .
    end.

end procedure.
/***************************************************************************************************/
procedure pi-cria-tt-period:
    define variable i-ano      as int  no-undo.
    define variable i-mes      as int  no-undo.
    define variable i-mes-ini  as int  no-undo.
    define variable i-mes-fim  as int  no-undo.
    define variable dt-ini-mes as date no-undo.
    define variable dt-fim-mes as date no-undo.

    do i-ano = year(tt-param.dt-ini) to year(tt-param.dt-fim):

        if i-ano = year(tt-param.dt-ini) then
            assign i-mes-ini = month(tt-param.dt-ini).
        else
            assign i-mes-ini = 1.

        if i-ano = year(tt-param.dt-fim) then
            assign i-mes-fim = month(tt-param.dt-fim).
        else
            assign i-mes-fim = 12.

        do i-mes = i-mes-ini to i-mes-fim:
            assign dt-ini-mes = date(i-mes, 1, i-ano)
                   dt-fim-mes = date(i-mes, 25, i-ano) + 10
                   dt-fim-mes = date(month(dt-fim-mes),1,year(dt-fim-mes)) - 1.

            create tt_period.
            assign tt_period.ttv_num_mes        = i-mes
                   tt_period.ttv_num_ano        = i-ano
                   tt_period.ttv_dat_inic_param = (if dt-ini-mes < tt-param.dt-ini then tt-param.dt-ini else dt-ini-mes)
                   tt_period.ttv_dat_fim_param  = (if dt-fim-mes > tt-param.dt-fim then tt-param.dt-fim else dt-fim-mes)
                   tt_period.ttv_dat_inic_mes   = dt-ini-mes
                   tt_period.ttv_dat_fim_mes    = dt-fim-mes.
        end.
    end.
end procedure.
/***************************************************************************************************/
procedure pi-limpa-return-value:
    return.
end.
/***************************************************************************************************/
procedure pi-verifica-movimentos-apis:
    define input parameter p-lista-modulo as char no-undo.

    define variable l-possui-movimentos as logical no-undo.
    define variable i-cont              as integer no-undo.
    define variable c-modulo            as char    no-undo.

    for each tt_period:
        assign l-possui-movimentos = no.

        for each tt-empresa-datasul-10:
            for each estabelec fields (cod-estabel)
               where estabelec.ep-codigo = tt-empresa-datasul-10.cdn-empresa no-lock:

                do i-cont = 1 to num-entries(p-lista-modulo, ","):
                    assign c-modulo = GetEntryField(i-cont, p-lista-modulo, ",").
             
                    if can-find(first tt-movimentos-sped-ems2
                                where tt-movimentos-sped-ems2.ep-codigo   = tt-empresa-datasul-10.cdn-empresa
                                  and tt-movimentos-sped-ems2.cod-estabel = estabelec.cod-estabel
                                  and tt-movimentos-sped-ems2.cod-modul   = c-modulo
                                  and tt-movimentos-sped-ems2.data       >= tt_period.ttv_dat_inic_param
                                  and tt-movimentos-sped-ems2.data       <= tt_period.ttv_dat_fim_param) then
                        assign l-possui-movimentos = yes.
                end.
            end.
        end.
        if not l-possui-movimentos then do:
            run pi-retorna-label-modulo (GetEntryField(1, p-lista-modulo, ",")).

            create tt-log-advertencias-sped.
            assign tt-log-advertencias-sped.num-cod-erro = 36585
            tt-log-advertencias-sped.des-erro = return-value + " do EMS 2~~" + 
                                                       string(tt_period.ttv_num_mes, "99") + "/" + 
                                                       string(tt_period.ttv_num_ano, "9999"). 
        end.
    end.
    
end procedure.
/***************************************************************************************************/
procedure pi-cria-tt-modulo:

    define variable i-id as int no-undo initial 0.
    define variable c-lista-modulos as char no-undo.
    define variable c-modulo as char no-undo.
    define variable i-cont as int no-undo.

    /* Sistema Gerenciamento Transportes */
    assign i-id = i-id + 1.
    assign c-lista-modulos = "MTR,TRP".
    do i-cont = 1 to num-entries(c-lista-modulos, ","):
        assign c-modulo = GetEntryField(i-cont, c-lista-modulos, ",").
        create tt-modulo.
        assign tt-modulo.i-id = i-id
               tt-modulo.c-modulo = c-modulo
               tt-modulo.c-modulo-refer = "MTR"
               tt-modulo.l-selecionado = YES.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-retorna-nome-dump:
    define output parameter p-arq-dump as char no-undo.

    def var c-dir-dump  as char no-undo.
    def var i-cont-dump as int  no-undo.
    def var c-aux-dump  as char no-undo.

    assign c-dir-dump = replace(c-arquivo-log, "/", chr(92)).

    do i-cont-dump = 1 to num-entries(c-dir-dump, chr(92)) - 1:
        assign c-aux-dump = c-aux-dump + GetEntryField(i-cont-dump, c-dir-dump, chr(92)) + chr(92).
    end.

    assign file-info:file-name = c-aux-dump.
    if file-info:full-pathname <> ? then 
        assign p-arq-dump = c-aux-dump.
    else 
        assign p-arq-dump = session:temp-dir.

    assign p-arq-dump = p-arq-dump + chr(92) + "dump-tt-movimentos" + 
                        string(day(today), "99") +
                        string(month(today), "99") +
                        string(year(today), "9999") + "-" +  
                        replace(string(time,"HH:MM:SS"),":","") + 
                        ".d".
end procedure.
/***************************************************************************************************/
procedure pi-cria-tt-empresa-datasul-10:

    /* Para o Datasul 10, devemos buscar os dados dos di†rios auxiliares (Estoque, Faturamento e TMS)
       de acordo com as empresas do EMS 2 que contabilizam na empresa selecionada do EMS 5.
       Por isso utilizamos a matriz de traduá∆o buscando todas as empresas do EMS 2 vinculadas a empresa
       informada pelo usu†rio 
       Esta temp-table s¢ ser† utilizada na chamada as apis de extraá∆o do Estoque, Faturamento e TMS, 
       que s∆o os £nicos m¢dulos do EMS 2 que enviam dados para o SPED Cont†bil no Datasul 10.
       Para releases menores que 2.07A, Ç criado um registro na tt com a empresa do EMS 2 informada 
       pelo usu†rio */

    &IF "{&mguni_version}" >= "2.07A" &THEN
        if valid-handle(h-ems5) then do:
            run pi_extrator_sped_empresa_datasul_10 in h-ems5 (output table tt-empresa-datasul-10).
        end.      
    &ELSE
    create tt-empresa-datasul-10.
    assign tt-empresa-datasul-10.cdn-empresa = tt-param.i-empresa-ems2.
    &ENDIF

end procedure.
/***************************************************************************************************/
procedure pi-print-resultado-extracao:

    /* Lanáamentos Cont†beis*/
    if can-find(first tt-dwf-lancto-ctbl) then do:

        {lfp/lf0302rp.i1 dwf-lancto-ctbl}

        ASSIGN c-arquivo-excel-2 = SESSION:TEMP-DIRECTORY + "dwf-item-lancto-ctbl.csv".
        OUTPUT STREAM s-excel-2 TO VALUE(c-arquivo-excel-2) convert target 'iso8859-1'.

        {utp/ut-liter.i Lanáamentos_Cont†beis *}
        assign c-message = return-value + " (dwf-lancto-ctbl/dwf-item-lancto-ctbl)".
        disp stream str-rp c-message with frame f-extracao.
        down 1 stream str-rp with frame f-extracao.

        {utp/ut-liter.i Lote *}         assign c-message = return-value + ";".
        {utp/ut-liter.i Lancto *}       assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i M¢dulo *}       assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Empresa *}      assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Data_Lancto *}  assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Valor_Lancto *} assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Tipo *}         assign c-message = c-message + return-value.

        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {lfp/lf0302rp.i2 1}
      
        {utp/ut-liter.i Lote *}          assign c-message = return-value + ";".
        {utp/ut-liter.i Lancto *}        assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Seq *}           assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i M¢dulo *}        assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Empresa *}       assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Estab *}         assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i ContaContabil *} assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i UN *}            assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i CentroCusto *}   assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Natureza *}      assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Valor_Lancto *}  assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Arquivamento *}  assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Participante *}  assign c-message = c-message + return-value.

        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.
        
        {lfp/lf0302rp.i2 2}

        {utp/ut-liter.i Imprimindo_Lancamentos *}
        run pi-acompanhar in h-acomp (input return-value).
        for each tt-dwf-lancto-ctbl:

            assign c-message = tt-dwf-lancto-ctbl.cod-lote-ctbl   + ";" +
                               tt-dwf-lancto-ctbl.cod-lancto-ctbl + ";" +
                               tt-dwf-lancto-ctbl.cod-modul-dtsul + ";" +
                               tt-dwf-lancto-ctbl.cod-empresa     + ";" +
                               string(tt-dwf-lancto-ctbl.dat-lancto-ctbl, "99/99/9999") + ";" +
                               trim(string(tt-dwf-lancto-ctbl.val-lancto-ctbl, "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99")) + ";" + 
                               tt-dwf-lancto-ctbl.ind-lancto-ctbl.

            disp stream str-rp c-message with frame f-extracao.
            down stream str-rp with frame f-extracao.

            {lfp/lf0302rp.i2 1}

            for each tt-dwf-item-lancto-ctbl
               where tt-dwf-item-lancto-ctbl.cod-empresa     = tt-dwf-lancto-ctbl.cod-empresa
                 and tt-dwf-item-lancto-ctbl.cdn-empresa     = tt-dwf-lancto-ctbl.cdn-empresa
                 and tt-dwf-item-lancto-ctbl.cod-modul-dtsul = tt-dwf-lancto-ctbl.cod-modul-dtsul
                 and tt-dwf-item-lancto-ctbl.cod-lote-ctbl   = tt-dwf-lancto-ctbl.cod-lote-ctbl
                 and tt-dwf-item-lancto-ctbl.cod-lancto-ctbl = tt-dwf-lancto-ctbl.cod-lancto-ctbl:
                
                assign c-message = tt-dwf-item-lancto-ctbl.cod-lote-ctbl   + ";" +
                                   tt-dwf-item-lancto-ctbl.cod-lancto-ctbl + ";" +
                                   string(tt-dwf-item-lancto-ctbl.num-seq-lancto-ctbl) + ";" +
                                   tt-dwf-item-lancto-ctbl.cod-modul-dtsul + ";" +
                                   tt-dwf-item-lancto-ctbl.cod-empresa     + ";" +
                                   tt-dwf-item-lancto-ctbl.cod-estab       + ";" +
                                   tt-dwf-item-lancto-ctbl.cod-cta-ctbl    + ";" +
                                   tt-dwf-item-lancto-ctbl.cod-unid-negoc  + ";" +
                                   tt-dwf-item-lancto-ctbl.cod-ccusto      + ";" +
                                   tt-dwf-item-lancto-ctbl.ind-natur-lancto-ctbl + ";" +
                                   trim(string(tt-dwf-item-lancto-ctbl.val-lancto-ctbl, "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99")) + ";" + 
                                   tt-dwf-item-lancto-ctbl.cod-arq-lancto-ctbl + ";" +
                                   tt-dwf-item-lancto-ctbl.cod-participan.

                disp stream str-rp c-message with frame f-extracao.
                down stream str-rp with frame f-extracao.

                {lfp/lf0302rp.i2 2}

            end.
            down 1 stream str-rp with frame f-extracao.

        end.

        OUTPUT STREAM s-excel-1 CLOSE.
        OUTPUT STREAM s-excel-2 CLOSE.

    end.

    down 1 stream str-rp with frame f-extracao.

    /* Saldos Cont†beis */
    if can-find(first tt-dwf-sdo-ctbl) then do:

        {lfp/lf0302rp.i1 dwf-sdo-ctbl}

        {utp/ut-liter.i Saldos_Cont†beis *}
        assign c-message = return-value + " (tt-dwf-sdo-ctbl)".
        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {utp/ut-liter.i Empresa *}        assign c-message = return-value + ";".
        {utp/ut-liter.i M¢dulo *}         assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Estab *}          assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i ContaContabil *}  assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i UN *}             assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i CentroCusto *}    assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Per°odo *}        assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Exerc°cio *}      assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i DataInicial *}    assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i DataFinal *}      assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i SdoInicial *}     assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i MovtoDB *}        assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i MovtoCR *}        assign c-message = c-message + return-value.

        if tt-param.c-diario = "diariogeral" then do:
            {utp/ut-liter.i SaldoFinal *}
            assign c-message = c-message  + ";" + return-value.
        end.

        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.
        
        {lfp/lf0302rp.i2 1}

        {utp/ut-liter.i Imprimindo_Saldos *}
        run pi-acompanhar in h-acomp (input return-value).

        for each tt-dwf-sdo-ctbl:

            if tt-dwf-sdo-ctbl.ind-espec-cta-ctbl = "Anal°tica" then do:

                find first tt-modulo 
                     where tt-modulo.c-modulo = tt-dwf-sdo-ctbl.cod-modul-dtsul
                     no-error.
                if avail tt-modulo then do:

                    find first tt-totalizador-historico
                         where tt-totalizador-historico.c-empresa = tt-dwf-sdo-ctbl.cod-empresa
                           and tt-totalizador-historico.c-modulo  = tt-modulo.c-modulo-refer
                           and tt-totalizador-historico.i-ano     = tt-dwf-sdo-ctbl.num-exerc-ctbl
                           and tt-totalizador-historico.i-periodo = tt-dwf-sdo-ctbl.num-period-ctbl
                        no-error.
                    if not avail tt-totalizador-historico then do:
                        create tt-totalizador-historico.
                        assign tt-totalizador-historico.c-empresa = tt-dwf-sdo-ctbl.cod-empresa
                               tt-totalizador-historico.c-modulo  = tt-modulo.c-modulo-refer
                               tt-totalizador-historico.i-ano     = tt-dwf-sdo-ctbl.num-exerc-ctbl
                               tt-totalizador-historico.i-periodo = tt-dwf-sdo-ctbl.num-period-ctbl
                               tt-totalizador-historico.dt-ini    = tt-dwf-sdo-ctbl.dat-livre-1
                               tt-totalizador-historico.dt-fim    = tt-dwf-sdo-ctbl.dat-inic-valid
                               tt-totalizador-historico.d-tot-db  = 0
                               tt-totalizador-historico.d-tot-cr  = 0.
                    end.

                    assign tt-totalizador-historico.d-tot-db = tt-totalizador-historico.d-tot-db + tt-dwf-sdo-ctbl.val-sdo-ctbl-db
                           tt-totalizador-historico.d-tot-cr = tt-totalizador-historico.d-tot-cr + tt-dwf-sdo-ctbl.val-sdo-ctbl-cr.
                end.
            end.
            
            assign c-message = tt-dwf-sdo-ctbl.cod-empresa             + ";" +
                               tt-dwf-sdo-ctbl.cod-modul-dtsul         + ";" +
                               tt-dwf-sdo-ctbl.cod-estab               + ";" +
                               tt-dwf-sdo-ctbl.cod-cta-ctbl            + ";" +
                               tt-dwf-sdo-ctbl.cod-unid-negoc          + ";" +
                               tt-dwf-sdo-ctbl.cod-ccusto              + ";" +
                               string(tt-dwf-sdo-ctbl.num-period-ctbl) + ";" +
                               string(tt-dwf-sdo-ctbl.num-exerc-ctbl)  + ";" +
                               string(tt-dwf-sdo-ctbl.dat-livre-1, "99/99/9999") + ";" +
                               string(tt-dwf-sdo-ctbl.dat-inic-valid, "99/99/9999")  + ";" +
                               trim(string(tt-dwf-sdo-ctbl.val-sdo-ctbl-inic, "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99")) + tt-dwf-sdo-ctbl.ind-sdo-ctbl-inic + ";" +
                               trim(string(tt-dwf-sdo-ctbl.val-sdo-ctbl-db, "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99"))   + ";" +
                               trim(string(tt-dwf-sdo-ctbl.val-sdo-ctbl-cr, "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99")).

            if tt-param.c-diario = "diariogeral" then do:
                assign c-message = c-message + ";" +
                                   trim(string(tt-dwf-sdo-ctbl.val-sdo-ctbl-fim, "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99"))  + tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim.
            end.
            disp stream str-rp c-message with frame f-extracao.
            down stream str-rp with frame f-extracao.

            {lfp/lf0302rp.i2 1}

        end.

        OUTPUT STREAM s-excel-1 CLOSE.

    end.

    down 1 stream str-rp with frame f-extracao.

    /* Saldos Antes do Encerramento */
    if can-find(first tt-dwf-sdo-ctbl-antes-encert) then do:

        {lfp/lf0302rp.i1 dwf-sdo-ctbl-antes-encert}

        {utp/ut-liter.i Saldos_Antes_do_Encerramento *}
        assign c-message = return-value + " (tt-dwf-sdo-ctbl-antes-encert)".
        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {utp/ut-liter.i Empresa *}          assign c-message = return-value + ";".
        {utp/ut-liter.i M¢dulo *}           assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Estab *}            assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i DataApuracResult *} assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i ContaContabil *}    assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i UN *}               assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i CentroCusto *}      assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i SaldoAntesEncer *}  assign c-message = c-message + return-value.

        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.
        
        {lfp/lf0302rp.i2 1}

        {utp/ut-liter.i Imprimindo_Saldos_Antes_Encerramento *}
        run pi-acompanhar in h-acomp (input return-value).

        for each tt-dwf-sdo-ctbl-antes-encert:
            
            assign c-message = tt-dwf-sdo-ctbl-antes-encert.cod-empresa      + ";" +
                               tt-dwf-sdo-ctbl-antes-encert.cod-modul-dtsul  + ";" +
                               tt-dwf-sdo-ctbl-antes-encert.cod-estab        + ";" + 
                               string(tt-dwf-sdo-ctbl-antes-encert.dat-apurac-restdo, "99/99/9999") + ";" +
                               tt-dwf-sdo-ctbl-antes-encert.cod-cta-ctbl + ";" +
                               tt-dwf-sdo-ctbl-antes-encert.cod-unid-neg + ";" +
                               tt-dwf-sdo-ctbl-antes-encert.cod-ccusto   + ";" +
                               trim(string(tt-dwf-sdo-ctbl-antes-encert.val-sdo-ctbl-fim-antes-encert, "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99")) + 
                               tt-dwf-sdo-ctbl-antes-encert.ind-sdo-ctbl-fim.
            disp stream str-rp c-message with frame f-extracao.
            down stream str-rp with frame f-extracao.

            {lfp/lf0302rp.i2 1}

        end.

        OUTPUT STREAM s-excel-1 CLOSE.

    end.

    down 1 stream str-rp with frame f-extracao.

    /* Plano de Contas */
    if can-find(first tt-dwf-cta-ctbl) then do:

        {lfp/lf0302rp.i1 dwf-cta-ctbl-refer}

        {utp/ut-liter.i Plano_de_Contas *}
        assign c-message = return-value + " (tt-dwf-cta-ctbl)".
        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {utp/ut-liter.i ContaContabil *}            assign c-message = return-value + ";".
        {utp/ut-liter.i T°tulo *}                   assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Natureza *}                 assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Data *}                     assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i EspÇcie *}                  assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i NivelConta *}               assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i ContaSup *}                 assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i UN *}                       assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i CentroCusto *}              assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i ContaReferencial *}         assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i NaturezaContaReferencial *} assign c-message = c-message + return-value.
        
        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {lfp/lf0302rp.i2 1}

        {utp/ut-liter.i Imprimindo_Plano_de_Contas *}
        run pi-acompanhar in h-acomp (input return-value).

        for each tt-dwf-cta-ctbl:

            if can-find( first tt-dwf-cta-ctbl-refer no-lock
                 where tt-dwf-cta-ctbl-refer.cod-empresa  = tt-dwf-cta-ctbl.cod-empresa
                   and tt-dwf-cta-ctbl-refer.cod-cta-ctbl = tt-dwf-cta-ctbl.cod-cta-ctbl)
            then do:
                for each tt-dwf-cta-ctbl-refer no-lock
                     where tt-dwf-cta-ctbl-refer.cod-empresa  = tt-dwf-cta-ctbl.cod-empresa
                       and tt-dwf-cta-ctbl-refer.cod-cta-ctbl = tt-dwf-cta-ctbl.cod-cta-ctbl:

                    assign c-message = tt-dwf-cta-ctbl.cod-cta-ctbl                         + ";" +
                                       tt-dwf-cta-ctbl.des-tit-ctbl                         + ";" +
                                       tt-dwf-cta-ctbl.ind-natur-grp-cta-ctbl               + ";" +
                                       string(tt-dwf-cta-ctbl.dat-incl-alter, '99/99/9999') + ";" +
                                       tt-dwf-cta-ctbl.ind-espec-cta-ctbl                   + ";" +
                                       string(tt-dwf-cta-ctbl.num-niv-cta-ctbl)             + ";" +
                                       tt-dwf-cta-ctbl.cod-cta-ctbl-sup.
                    
                    assign c-message = c-message + ";" + tt-dwf-cta-ctbl-refer.cod-unid-neg.
                    assign c-message = c-message + ";" + tt-dwf-cta-ctbl-refer.cod-ccusto.
                    assign c-message = c-message + ";" + tt-dwf-cta-ctbl-refer.cod-cta-ctbl-refer.
                    assign c-message = c-message + ";" + tt-dwf-cta-ctbl-refer.ind-natur-cta-ctbl.
                    
                    disp stream str-rp c-message with frame f-extracao.
                    down stream str-rp with frame f-extracao.

                    {lfp/lf0302rp.i2 1}

                end.
            end.
            else do:
                assign c-message = tt-dwf-cta-ctbl.cod-cta-ctbl                         + ";" +
                                   tt-dwf-cta-ctbl.des-tit-ctbl                         + ";" +
                                   tt-dwf-cta-ctbl.ind-natur-grp-cta-ctbl               + ";" +
                                   string(tt-dwf-cta-ctbl.dat-incl-alter, '99/99/9999') + ";" +
                                   tt-dwf-cta-ctbl.ind-espec-cta-ctbl                   + ";" +
                                   string(tt-dwf-cta-ctbl.num-niv-cta-ctbl)             + ";" +
                                   tt-dwf-cta-ctbl.cod-cta-ctbl-sup.

                assign c-message = c-message + ";;;;".

                disp stream str-rp c-message with frame f-extracao.
                down stream str-rp with frame f-extracao.

                {lfp/lf0302rp.i2 1}

            end.
        end.

        OUTPUT STREAM s-excel-1 CLOSE.

    end.
        
    down 1 stream str-rp with frame f-extracao.

    /* Plano de Centro de Custo */
    if can-find(first tt-dwf-ccusto) then do:

        {lfp/lf0302rp.i1 dwf-ccusto}

        {utp/ut-liter.i Centro_de_Custo *}
        assign c-message = return-value + " (dwf-ccusto)".
        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {utp/ut-liter.i Empresa *}     assign c-message = return-value + ";".
        {utp/ut-liter.i CCusto *}      assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i UN *}          assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Descriá∆o *}   assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i DataInicial *} assign c-message = c-message + return-value.

        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

         {lfp/lf0302rp.i2 1}

        {utp/ut-liter.i Imprimindo_Centro_de_Custo *}
        run pi-acompanhar in h-acomp (input return-value). 

        for each tt-dwf-ccusto:

            assign c-message = tt-dwf-ccusto.cod-empresa  + ";" +
                               tt-dwf-ccusto.cod-ccusto   + ";" +
                               tt-dwf-ccusto.cod-unid-neg + ";".

            if tt-dwf-ccusto.cod-livre-1 = "" then
                assign c-message = c-message + tt-dwf-ccusto.des-tit-ctbl + ";".
            else
                assign c-message = c-message + tt-dwf-ccusto.des-tit-ctbl + "/" + tt-dwf-ccusto.cod-livre-1 + ";".

            assign c-message = c-message + string(tt-dwf-ccusto.dat-incl-alter, '99/99/9999').

            disp stream str-rp c-message with frame f-extracao.
            down stream str-rp with frame f-extracao.

            {lfp/lf0302rp.i2 1}

        end.

        OUTPUT STREAM s-excel-1 CLOSE.

    end.

    down 1 stream str-rp with frame f-extracao.

    /* C¢digos de Aglutinaá∆o */
    if can-find(first tt-dwf-cta-aglut) then do:

        {lfp/lf0302rp.i1 dwf-cta-aglut}

        {utp/ut-liter.i C¢digos_de_Aglutinaá∆o *}
        assign c-message = return-value + " (dwf-cta-aglut)".
        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {utp/ut-liter.i Empresa *}           assign c-message = return-value + ";".
        {utp/ut-liter.i ContaContabil *}     assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i CCusto *}            assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i UN *}                assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i CodigoAglutinaá∆o *} assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i TituloAglutinacao *} assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Nivel *}             assign c-message = c-message + return-value.

        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {lfp/lf0302rp.i2 1}

        {utp/ut-liter.i Imprimindo_C¢digos_Aglutinaá∆o *}
        run pi-acompanhar in h-acomp (input return-value).
        for each tt-dwf-cta-aglut:

            assign c-message = tt-dwf-cta-aglut.cod-empresa + ";" +
                               tt-dwf-cta-aglut.cod-cta-ctbl + ";" +
                               tt-dwf-cta-aglut.cod-ccusto + ";" +
                               tt-dwf-cta-aglut.cod-unid-neg + ";" +
                               tt-dwf-cta-aglut.cod-cta-ctbl-aglut + ";" +
                               tt-dwf-cta-aglut.des-tit-ctbl-aglut + ";" +
                               string(tt-dwf-cta-aglut.num-niv-cta-ctbl).
            disp stream str-rp c-message with frame f-extracao.
            down stream str-rp with frame f-extracao.

            {lfp/lf0302rp.i2 1}

        end.

        OUTPUT STREAM s-excel-1 CLOSE.

    end.

    down 1 stream str-rp with frame f-extracao.

    /* Balanáo Patrimonial */
    if can-find(first tt-dwf-balan-patrim) then do:

        {lfp/lf0302rp.i1 dwf-balan-patrim}

        {utp/ut-liter.i Balanáo_Patrimonial *}
        assign c-message = return-value + " (tt-dwf-balan-patrim)".
        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {utp/ut-liter.i Empresa *}           assign c-message = return-value + ";".
        {utp/ut-liter.i Data_Inicial *}      assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i CodigoAglutinaá∆o *} assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i N°vel *}             assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i IndicadorGrupo *}    assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i T°tulo *}            assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Saldo_Final *}       assign c-message = c-message + RETURN-VALUE + ";".
        {utp/ut-liter.i Saldo_Inicial *}     assign c-message = c-message + return-value.

        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {lfp/lf0302rp.i2 1}

        {utp/ut-liter.i Imprimindo_Balanáo_Patrimonial *}
        run pi-acompanhar in h-acomp (input return-value).
        for each tt-dwf-balan-patrim:

            assign c-message = tt-dwf-balan-patrim.cod-empresa + ";" +
                               string(tt-dwf-balan-patrim.dat-inic-demonst-ctbl, "99/99/9999") + ";" +
                               tt-dwf-balan-patrim.cod-cta-ctbl-aglut + ";" +
                               string(tt-dwf-balan-patrim.num-niv-cta-ctbl) + ";" +
                               tt-dwf-balan-patrim.cod-indic-grp + ";" +
                               tt-dwf-balan-patrim.des-tit-ctbl-aglut + ";" +
                               trim(string(tt-dwf-balan-patrim.val-tot-cta-aglut, "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99")) + 
                               tt-dwf-balan-patrim.ind-sit-sdo  + ";" +
                               &if "{&mgadm_version}" >= "2.09" &then
                               trim(string(tt-dwf-balan-patrim.val-inicial-cta-aglut, "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99")) +
                               tt-dwf-balan-patrim.ind-sit-sdo-inicial
                               &ELSE
                               trim(string(tt-dwf-balan-patrim.val-livre-1, "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99")) +
                               tt-dwf-balan-patrim.cod-livre-1
                               &ENDIF.

            disp stream str-rp c-message with frame f-extracao.
            down stream str-rp with frame f-extracao.

            {lfp/lf0302rp.i2 1}

        end.

        OUTPUT STREAM s-excel-1 CLOSE.

    end.

    down 1 stream str-rp with frame f-extracao.

    /* Demonstraá∆o de Resultados */
    if can-find(first tt-dwf-demonst-restdo-exerc) then do:

        {lfp/lf0302rp.i1 dwf-demonst-restdo-exerc}

        {utp/ut-liter.i Demonstraá∆o_de_Resultados *}
        assign c-message = return-value + " (tt-dwf-demonst-restdo-exerc)".
        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {utp/ut-liter.i Empresa *}           assign c-message = return-value + ";".
        {utp/ut-liter.i Data_Inicial *}      assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i CodigoAglutinaá∆o *} assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i N°vel *}             assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i T°tulo *}            assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Valor *}             assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Situaá∆o *}          assign c-message = c-message + return-value.

        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {lfp/lf0302rp.i2 1}

        {utp/ut-liter.i Imprimindo_Demonstraá∆o_de_Resultados *}
        run pi-acompanhar in h-acomp (input return-value).
        for each tt-dwf-demonst-restdo-exerc:

            assign c-message = tt-dwf-demonst-restdo-exerc.cod-empresa + ";" +
                               string(tt-dwf-demonst-restdo-exerc.dat-inic-demonst-ctbl, "99/99/9999") + ";" +
                               tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut + ";" +
                               string(tt-dwf-demonst-restdo-exerc.num-niv-cta-ctbl) + ";" +
                               tt-dwf-demonst-restdo-exerc.des-tit-ctbl-aglut + ";" +
                               trim(string(tt-dwf-demonst-restdo-exerc.val-tot-cta-aglut, "->>>,>>>,>>>,>>>,>>>,>>>,>>9.99")) + ";" + 
                               tt-dwf-demonst-restdo-exerc.ind-sit-sdo.

            disp stream str-rp c-message with frame f-extracao.
            down stream str-rp with frame f-extracao.

            {lfp/lf0302rp.i2 1}

        end.

        OUTPUT STREAM s-excel-1 CLOSE.

    end.

    down 1 stream str-rp with frame f-extracao.

    /* Participante */
    if can-find(first tt-dwf-participan) then do:

        {lfp/lf0302rp.i1 dwf-participan}

        {utp/ut-liter.i Participante *}
        assign c-message = return-value + " (dwf-participan)".
        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {utp/ut-liter.i CodEmpresa *}    assign c-message = return-value + ";".
        {utp/ut-liter.i CodEstab *}      assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i CodParticipan *} assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i CdnPessoa *}     assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i CodRelac *}      assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i DataIniValid *}  assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i DataFimValid *}  assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i NumBacen *}      assign c-message = c-message + return-value.

        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {lfp/lf0302rp.i2 1}

        {utp/ut-liter.i Imprimindo_Dados_Participante *}
        run pi-acompanhar in h-acomp (input return-value).
        for each tt-dwf-participan:
            assign c-message = tt-dwf-participan.cod-empresa + ";" +
                               tt-dwf-participan.cod-estab + ";" +
                               tt-dwf-participan.cod-participan + ";" +
                               string(tt-dwf-participan.cdn-pessoa) + ";" +
                               tt-dwf-participan.cod-relacdo + ";" +
                               string(tt-dwf-participan.dat-inic-period, "99/99/9999") + ";" +
                               string(tt-dwf-participan.dat-fim-period, "99/99/9999") + ";" +
                               string(tt-dwf-participan.num-bacen).
            disp stream str-rp c-message with frame f-extracao.
            down stream str-rp with frame f-extracao.

            {lfp/lf0302rp.i2 1}

        end.

        output stream s-excel-1 close.

    end.

    down 1 stream str-rp with frame f-extracao.

    /* Estabelecimento */
    if can-find(first tt-dwf-estab) then do:

        {lfp/lf0302rp.i1 dwf-estab}

        {utp/ut-liter.i Estabelecimento *}
        assign c-message = return-value + " (dwf-estab)".
        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {utp/ut-liter.i Empresa *}         assign c-message = return-value + ";".
        {utp/ut-liter.i Estabelecimento *} assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i Pessoa *}          assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i NomFantasia *}     assign c-message = c-message + return-value.

        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {lfp/lf0302rp.i2 1}

        {utp/ut-liter.i Imprimindo_Estabelecimentos *}
        run pi-acompanhar in h-acomp (input return-value).
        for each tt-dwf-estab:
            find first tt-dwf-estab-extens
                 where tt-dwf-estab-extens.cod-estab = tt-dwf-estab.cod-estab
                no-lock no-error.
            if avail tt-dwf-estab-extens then 
                assign c-message = tt-dwf-estab-extens.cod-empresa + ";".
            else
                assign c-message = ";".

            assign c-message = c-message + 
                               tt-dwf-estab.cod-estab + ";" +
                               string(tt-dwf-estab.cdn-pessoa) + ";" +
                               tt-dwf-estab.nom-fantasia.
            disp stream str-rp c-message with frame f-extracao.
            down stream str-rp with frame f-extracao.

            {lfp/lf0302rp.i2 1}

        end.

        OUTPUT STREAM s-excel-1 CLOSE.

    end.


    down 1 stream str-rp with frame f-extracao.

    /* Pessoa */
    if can-find(first tt-dwf-pessoa) then do:

        {lfp/lf0302rp.i1 dwf-pessoa}

        {utp/ut-liter.i Pessoa *}
        assign c-message = return-value + " (dwf-pessoa)".
        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {utp/ut-liter.i CodPessoa *}   assign c-message = return-value + ";".
        {utp/ut-liter.i CodEndereáo *} assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i NomPessoa *}   assign c-message = c-message + return-value.

        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {lfp/lf0302rp.i2 1}

        {utp/ut-liter.i Imprimindo_Dados_Pessoa *}
        run pi-acompanhar in h-acomp (input return-value).
        for each tt-dwf-pessoa:
            assign c-message = string(tt-dwf-pessoa.cdn-pessoa) + ";" +
                               string(tt-dwf-pessoa.cdn-ender) + ";" +
                               tt-dwf-pessoa.nom-pessoa.
            disp stream str-rp c-message with frame f-extracao.
            down stream str-rp with frame f-extracao.

            {lfp/lf0302rp.i2 1}

        end.

         OUTPUT STREAM s-excel-1 CLOSE.

    end.

    down 1 stream str-rp with frame f-extracao.

    /* Endereáo */
    if can-find(first tt-dwf-ender) then do:

        {lfp/lf0302rp.i1 dwf-ender}

        {utp/ut-liter.i Endereáo *}
        assign c-message = return-value + " (dwf-ender)".
        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {utp/ut-liter.i CodEndereáo *}   assign c-message = return-value + ";".
        {utp/ut-liter.i NomeAbrev *}     assign c-message = c-message + return-value + ";".
        {utp/ut-liter.i NomLogradouro *} assign c-message = c-message + return-value.

        disp stream str-rp c-message with frame f-extracao.
        down stream str-rp with frame f-extracao.

        {lfp/lf0302rp.i2 1}

        {utp/ut-liter.i Imprimindo_Endereáos *}
        run pi-acompanhar in h-acomp (input return-value).
        for each tt-dwf-ender:
            assign c-message = string(tt-dwf-ender.cdn-ender) + ";" +
                               tt-dwf-ender.nom-abrev-ender + ";" +
                               tt-dwf-ender.nom-lograd.
            disp stream str-rp c-message with frame f-extracao.
            down stream str-rp with frame f-extracao.

            {lfp/lf0302rp.i2 1}

        end.

        OUTPUT STREAM s-excel-1 CLOSE.

    end.

    down 1 stream str-rp with frame f-extracao.

end procedure.
/***************************************************************************************************/
procedure pi-verifica-saldo-filhas:
    def input  param p-cod-opcao   as character no-undo.
    def input  param p-cod-empresa as character no-undo.
    def input  param p-cod-sup     as character no-undo.
    def output param p-log-saldo   as logical   no-undo.

    blk_dwf-cta-ctbl:
    for each  tt-dwf-cta-ctbl no-lock
        where tt-dwf-cta-ctbl.cod-empresa      = p-cod-empresa
          and tt-dwf-cta-ctbl.cod-cta-ctbl-sup = p-cod-sup:

        if  p-cod-opcao = "balanco" then do:
            if can-find (first tt-dwf-balan-patrim no-lock
                         where tt-dwf-balan-patrim.cod-empresa        = tt-dwf-cta-ctbl.cod-empresa
                           and tt-dwf-balan-patrim.cod-cta-ctbl-aglut = tt-dwf-cta-ctbl.cod-cta-ctbl
                           and tt-dwf-balan-patrim.val-tot-cta-aglut <> 0) then do:
                assign p-log-saldo = yes.
                leave blk_dwf-cta-ctbl.
            end.
            else do:
                run pi-verifica-saldo-filhas (input  p-cod-opcao,
                                              input  tt-dwf-cta-ctbl.cod-empresa,
                                              input  tt-dwf-cta-ctbl.cod-cta-ctbl,
                                              output p-log-saldo).
                if  p-log-saldo then
                    leave blk_dwf-cta-ctbl.
            end.
        end.
        else do:
            if  p-cod-opcao = "dre" then do:
                if can-find (first tt-dwf-demonst-restdo-exerc no-lock
                                 where tt-dwf-demonst-restdo-exerc.cod-empresa        = tt-dwf-cta-ctbl.cod-empresa
                                   and tt-dwf-demonst-restdo-exerc.cod-cta-ctbl-aglut = tt-dwf-cta-ctbl.cod-cta-ctbl
                                   and tt-dwf-demonst-restdo-exerc.val-tot-cta-aglut <> 0) then do:
                    assign p-log-saldo = yes.
                    leave blk_dwf-cta-ctbl.
                end.
                else do:
                    run pi-verifica-saldo-filhas (input  p-cod-opcao,
                                                  input  tt-dwf-cta-ctbl.cod-empresa,
                                                  input  tt-dwf-cta-ctbl.cod-cta-ctbl,
                                                  output p-log-saldo).
                    if  p-log-saldo then
                        leave blk_dwf-cta-ctbl.
                end.
            end.
        end.
    end.
end.
/***************************************************************************************************/
/* 
   In°cio da rotina de apuraá∆o de resultados utilizada apenas para a entrega do SPED Cont†bil. 
   O resultado apurado nesta rotina n∆o ser† armazenado no produto.
   Maiores detalhes sobre esta alteraá∆o, consultar a DIS dispon°vel em:
   ~\~\joaquina~\pastahst~\datasul~\0095 - Melhorias SPED Cont†bil Fase IV~\3. An†lise e Projeto~\DIS-MelhoriasSPED-FaseIV.doc 
   Item 1.5.1.2 - Apuraá∆o de Resultados

   Desenvolvedor: Fabio Thomaz (fut38629)
   Equipe: Inovaá∆o Fiscal
   Data: 01/02/2011
*/   
/***************************************************************************************************/
procedure pi-apura-resultados-sped:

    def buffer btt-dwf-sdo-ctbl for tt-dwf-sdo-ctbl.
    def buffer btt-dwf-cta-ctbl-refer for tt-dwf-cta-ctbl-refer.

    define variable c-modul as char no-undo.
    define variable c-cod-lote-ctbl as char no-undo.
    define variable c-cod-lancto-ctbl as char no-undo.
    define variable i-seq-lancto as int no-undo.
    define variable c-cod-unid-negoc as char no-undo.
    define variable d-valor as decimal no-undo.
    define variable c-ind-sdo-ctbl as char no-undo.
    define variable d-saldo-ini as decimal no-undo.
    define variable d-saldo-db as decimal no-undo.
    define variable d-saldo-cr as decimal no-undo.
    define variable c-contas-msg as char no-undo.

    /* Inicializaá∆o das vari†veis utilizadas no processo */
    assign c-modul = (if tt-param.c-contabilidade = 'ems2' then 'MCT' else 'FGL')
           c-cod-lote-ctbl = 'SPED'
           c-cod-lancto-ctbl = 'LP' + string(year(tt-param.dt-fim),'9999') 
                                    + string(month(tt-param.dt-fim),'99')
                                    + string(day(tt-param.dt-fim),'99')
           i-seq-lancto = 0
           c-cod-unid-negoc = ''.

    /* 
    - Advertància: Verificar se a conta de lucros e perdas possui unidades de neg¢cio
      informadas no de-para que n∆o foram informadas para todas as contas de receita 
      e despesa que ser∆o apuradas. Caso exista esta situaá∆o, o saldo da conta de 
      lucros e perdas para estas unidades n∆o estar† de acordo com a "realidade", 
      pois valores que deveriam ser apuradas nela foram jogadas para UN em branco (pois
      Ç onde est† o saldo da conta que est† sendo apurada, pela falta da UN na matriz) 
    */

    IF tt-param.c-conta-lucros-perdas = "" THEN DO:
        run pi-cria-tt-erros-sped(input 17006, 
                          input "Conta de Lucros e Perdas n∆o cadastrada. A conta de lucros e perdas deve estar informada na Manutená∆o de Planos 
                                  de Contas Cont†beis (prgint/utb/utb080aa.r).",
                          input no,
                          input "").
      END.
  else do: 
        FIND FIRST tt-dwf-cta-ctbl-refer 
            where tt-dwf-cta-ctbl-refer.cod-empresa = tt-param.c-empresa                   
              and tt-dwf-cta-ctbl-refer.cod-cta-ctbl = tt-param.c-conta-lucros-perdas     
               NO-ERROR.    

        IF  NOT AVAIL tt-dwf-cta-ctbl-refer THEN DO:
            run pi-cria-tt-erros-sped(input 17006, 
                  input  "A conta de lucros e perdas deve estar cadastrada na matriz SPED (prgint/utb/utb119aa.r).",
                  input no,
                  input "").
        END.
  

    END. 

    for each tt-dwf-cta-ctbl-refer
       where tt-dwf-cta-ctbl-refer.cod-empresa = tt-param.c-empresa
         and tt-dwf-cta-ctbl-refer.cod-cta-ctbl = tt-param.c-conta-lucros-perdas
         and tt-dwf-cta-ctbl-refer.cod-unid-neg <> "":

        assign c-contas-msg = ''.
        for each tt-dwf-cta-ctbl
           where tt-dwf-cta-ctbl.ind-tip-cta-ctbl = "A"
             and (tt-dwf-cta-ctbl.ind-natur-grp-cta-ctbl = "Receita":U
               or tt-dwf-cta-ctbl.ind-natur-grp-cta-ctbl = "Despesa":U):
            if not can-find(first btt-dwf-cta-ctbl-refer
                            where btt-dwf-cta-ctbl-refer.cod-empresa = tt-dwf-cta-ctbl-refer.cod-empresa
                              and btt-dwf-cta-ctbl-refer.cod-cta-ctbl = tt-dwf-cta-ctbl.cod-cta-ctbl
                              and btt-dwf-cta-ctbl-refer.cod-unid-neg = tt-dwf-cta-ctbl-refer.cod-unid-neg) 
            and can-find (first tt-dwf-sdo-ctbl
                          where tt-dwf-sdo-ctbl.cod-modul-dtsul = c-modul
                            and tt-dwf-sdo-ctbl.cod-empresa = tt-dwf-cta-ctbl-refer.cod-empresa
                            and tt-dwf-sdo-ctbl.cdn-empresa = tt-param.i-empresa-ems2 
                            and tt-dwf-sdo-ctbl.cod-cta-ctbl = tt-dwf-cta-ctbl.cod-cta-ctbl) then do:
               if c-contas-msg = '' then
                   assign c-contas-msg = tt-dwf-cta-ctbl.cod-cta-ctbl.
               else                                
                   assign c-contas-msg = c-contas-msg + ',' + tt-dwf-cta-ctbl.cod-cta-ctbl.
            end.
        end.
        if c-contas-msg <> "" then do:
            /* Para a conta de lucros e perdas (&1), foi informada a Unidade de Neg¢cio &2 na matriz de traduá∆o de contas externas, 
               porÇm a mesma n∆o foi informada para a conta de &3 &4. Esta inconsistància poder† afetar o valor da apuraá∆o de 
               lucros e perdas para a Unidade de Neg¢cio &2. Favor removà-la da matriz de traduá∆o para a conta de lucros e perdas,
               ou se desejar apurar o resultado desta unidade, inform†-la para todas as contas de Receita e Despesa. */
            create tt-log-advertencias-sped.
            assign tt-log-advertencias-sped.num-cod-erro = 51965
                   tt-log-advertencias-sped.des-erro = tt-param.c-conta-lucros-perdas + '~~' +
                                                       tt-dwf-cta-ctbl-refer.cod-unid-neg + '~~' +
                                                       c-contas-msg
                   .
        end.
    end.



    /*
        Lucilene / Rafael  - Tratamento para a conta de lucros e perdas quando n∆o h† registros na tabela de Saldo Cont†bil   (sdo-ctbl).
            Esta situaá∆o ocorre quando nunca foi realizada nenhuma apuraá∆o no produto nem pelo Sped ou quando n∆o foi implantado Saldo Inicial para conta de Lucros e Perdas. 
    */


    FIND FIRST tt_period WHERE ttv_num_mes  = month(tt-param.dt-fim) AND ttv_num_ano = YEAR(tt-param.dt-fim) NO-ERROR.

    for each tt-dwf-cta-ctbl-refer
       where tt-dwf-cta-ctbl-refer.cod-empresa = tt-param.c-empresa
         and tt-dwf-cta-ctbl-refer.cod-cta-ctbl = tt-param.c-conta-lucros-perdas:

        FIND FIRST tt-dwf-sdo-ctbl
            WHERE 
                   tt-dwf-sdo-ctbl.cod-empresa          = tt-param.c-empresa
                   AND tt-dwf-sdo-ctbl.cdn-empresa          = tt-param.i-empresa-ems2 
                   AND tt-dwf-sdo-ctbl.cod-modul-dtsul      = c-modul
                   AND tt-dwf-sdo-ctbl.cod-estab            = ""
                   AND tt-dwf-sdo-ctbl.cod-cta-ctbl         = tt-dwf-cta-ctbl-refer.cod-cta-ctbl
                   AND tt-dwf-sdo-ctbl.cod-unid-negoc       = tt-dwf-cta-ctbl-refer.cod-unid-neg
                   AND tt-dwf-sdo-ctbl.num-period-ctbl      = month(tt-param.dt-fim)
                   AND tt-dwf-sdo-ctbl.num-exerc-ctbl       = year(tt-param.dt-fim) 
                   AND tt-dwf-sdo-ctbl.dat-inic-valid       = tt_period.ttv_dat_fim_param NO-ERROR.
                   
                         
        
        IF NOT AVAIL tt-dwf-sdo-ctbl  THEN DO:
        

            create tt-dwf-sdo-ctbl.
            assign tt-dwf-sdo-ctbl.cod-empresa          = tt-param.c-empresa
                   tt-dwf-sdo-ctbl.cdn-empresa          = tt-param.i-empresa-ems2 
                   tt-dwf-sdo-ctbl.cod-modul-dtsul      = c-modul
                   tt-dwf-sdo-ctbl.cod-estab            = ""
                   tt-dwf-sdo-ctbl.cod-cta-ctbl         =  tt-dwf-cta-ctbl-refer.cod-cta-ctbl
                   tt-dwf-sdo-ctbl.cod-ccusto           = ""
                   tt-dwf-sdo-ctbl.cod-unid-negoc       = tt-dwf-cta-ctbl-refer.cod-unid-neg
                   tt-dwf-sdo-ctbl.num-period-ctbl      = month(tt-param.dt-fim)
                   tt-dwf-sdo-ctbl.num-exerc-ctbl       = YEAR(tt-param.dt-fim)
                   tt-dwf-sdo-ctbl.ind-espec-cta-ctbl   = "Anal°tica"
                   &if '{&emsfin_version}' >= '5.09' &then
                   tt-dwf-sdo-ctbl.dat-sdo              = tt_period.ttv_dat_fim_param
                   &endif
                   tt-dwf-sdo-ctbl.dat-livre-1          = tt_period.ttv_dat_inic_param
                   tt-dwf-sdo-ctbl.dat-livre-2          = tt_period.ttv_dat_fim_param
                   tt-dwf-sdo-ctbl.dat-inic-valid       = tt_period.ttv_dat_fim_param
                   tt-dwf-sdo-ctbl.dat-fim-valid        = ?.

        END.

    END.

 
    /* 
    - Verificar se existe apuraá∆o de resultados feita pelo produto no per°odo. Se existir, dever† desfazà-la, 
      eliminando os lanáamentos do lote de encerramento e recalculando o saldo das contas afetadas. 
      Neste momento, basta recalcular os saldos das contas anal°ticas;
    */
    if can-find(first tt-dwf-lancto-ctbl 
                where tt-dwf-lancto-ctbl.log-lancto-apurac-restdo = yes) then do:
        run pi-desfaz-apuracao-produto.                    
    end.

    /*
    - Verificar se a apuraá∆o de resultados do per°odo anterior foi realizada pela rotina do SPED cont†bil 
      ou pelo produto. Essa informaá∆o ficar† armazenada no hist¢rico de extraá‰es (dwf-histor-sped-ctbl);
    */
    run pi-calcula-saldo-ini-conta-lucros-perdas.

    /*
    - Cria o lote de apuraá∆o, para que os lanáamentos (tt-dwf-item-lancto-ctbl) sejam associados posteriormente 
    */
    find first tt-dwf-lancto-ctbl use-index dwflnctc-id no-lock
         where tt-dwf-lancto-ctbl.cod-empresa      = tt-param.c-empresa
         and   tt-dwf-lancto-ctbl.cdn-empresa      = tt-param.i-empresa-ems2
         and   tt-dwf-lancto-ctbl.cod-modul-dtsul  = c-modul
         and   tt-dwf-lancto-ctbl.cod-lote-ctbl    = c-cod-lote-ctbl
         and   tt-dwf-lancto-ctbl.cod-lancto-ctbl  = c-cod-lancto-ctbl
         and   tt-dwf-lancto-ctbl.dat-inic-valid   = dat-today
         no-error.
    
    if  not avail tt-dwf-lancto-ctbl then do:
        create tt-dwf-lancto-ctbl.
        assign tt-dwf-lancto-ctbl.cdn-empresa      = tt-param.i-empresa-ems2
               tt-dwf-lancto-ctbl.cod-empresa      = tt-param.c-empresa
               tt-dwf-lancto-ctbl.cod-modul-dtsul  = c-modul
               tt-dwf-lancto-ctbl.cod-lote-ctbl    = replace(c-cod-lote-ctbl, "|", " ")
               tt-dwf-lancto-ctbl.cod-lancto-ctbl  = replace(c-cod-lancto-ctbl, "|", " ")      
               tt-dwf-lancto-ctbl.dat-inic-valid   = dat-today.

        assign tt-dwf-lancto-ctbl.dat-lancto-ctbl          = tt-param.dt-fim
               tt-dwf-lancto-ctbl.log-lancto-apurac-restdo = yes
               tt-dwf-lancto-ctbl.ind-lancto-ctbl          = 'E':U
               tt-dwf-lancto-ctbl.dat-fim-valid            = ?
               tt-dwf-lancto-ctbl.val-lancto-ctbl          = 0.

        /* Salva o movimento de origem dos lanáamentos da contabilidade para o bloco I015 */
        assign tt-dwf-lancto-ctbl.cod-livre-1 = c-modul.
    end.

    /*
    - Para identificar quais contas ser∆o apuradas, ser† verificado se a conta Ç de "Receita" ou "Despesa", 
      atravÇs do campo tt-dwf-cta-ctbl.ind-natur-grp-cta-ctbl, que Ç preenchido de acordo com a natureza 
      da conta no produto. Somente as contas anal°ticas ser∆o consideradas nesta etapa;
    */
    for each tt-dwf-cta-ctbl
       where tt-dwf-cta-ctbl.ind-tip-cta-ctbl = "A"
         and (tt-dwf-cta-ctbl.ind-natur-grp-cta-ctbl = "Receita":U
           or tt-dwf-cta-ctbl.ind-natur-grp-cta-ctbl = "Despesa":U):

        if tt-dwf-cta-ctbl.cod-cta-ctbl = tt-param.c-conta-lucros-perdas then
            next.

        /*
        - Para as contas que ser∆o apuradas, o saldo inicial ser† sempre 0 (zero);
        */
        for each tt-dwf-sdo-ctbl
           where tt-dwf-sdo-ctbl.cod-modul-dtsul = c-modul
             and tt-dwf-sdo-ctbl.cod-empresa = tt-param.c-empresa
             and tt-dwf-sdo-ctbl.cdn-empresa = tt-param.i-empresa-ems2
             and tt-dwf-sdo-ctbl.cod-cta-ctbl = tt-dwf-cta-ctbl.cod-cta-ctbl
             and tt-dwf-sdo-ctbl.num-period-ctbl = month(tt-param.dt-ini)
             and tt-dwf-sdo-ctbl.num-exerc-ctbl = year(tt-param.dt-ini):

            assign tt-dwf-sdo-ctbl.val-sdo-ctbl-inic = 0
                   tt-dwf-sdo-ctbl.ind-sdo-ctbl-inic = 'D'.
            assign tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = tt-dwf-sdo-ctbl.val-sdo-ctbl-inic
                                                    + tt-dwf-sdo-ctbl.val-sdo-ctbl-db 
                                                    - tt-dwf-sdo-ctbl.val-sdo-ctbl-cr.
            assign d-saldo-ini = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim.

            /* Ajusta situaá∆o do saldo */
            assign d-valor = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim.
            run pi-acerta-debito-credito (input-output d-valor,
                                          output c-ind-sdo-ctbl).
            assign tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = d-valor
                   tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = c-ind-sdo-ctbl.
            
            /*
            - Devido ao zeramento do saldo inicial, recalcula os saldos das contas 
              para todos os periodos posteriores
            */
            for each tt_period
               where tt_period.ttv_dat_inic_mes > tt-param.dt-ini
                by tt_period.ttv_num_ano
                by tt_period.ttv_num_mes:
                for each btt-dwf-sdo-ctbl 
                   where btt-dwf-sdo-ctbl.cod-modul-dtsul = tt-dwf-sdo-ctbl.cod-modul-dtsul
                     and btt-dwf-sdo-ctbl.cod-empresa = tt-dwf-sdo-ctbl.cod-empresa
                     and btt-dwf-sdo-ctbl.cdn-empresa = tt-dwf-sdo-ctbl.cdn-empresa
                     and btt-dwf-sdo-ctbl.cod-cta-ctbl = tt-dwf-sdo-ctbl.cod-cta-ctbl
                     and btt-dwf-sdo-ctbl.cod-ccusto = tt-dwf-sdo-ctbl.cod-ccusto
                     and btt-dwf-sdo-ctbl.cod-unid-negoc = tt-dwf-sdo-ctbl.cod-unid-negoc
                     and btt-dwf-sdo-ctbl.num-period-ctbl = tt_period.ttv_num_mes
                     and btt-dwf-sdo-ctbl.num-exerc-ctbl = tt_period.ttv_num_ano:
                    assign btt-dwf-sdo-ctbl.val-sdo-ctbl-inic = d-saldo-ini
                           btt-dwf-sdo-ctbl.val-sdo-ctbl-fim = btt-dwf-sdo-ctbl.val-sdo-ctbl-inic
                                                             + btt-dwf-sdo-ctbl.val-sdo-ctbl-db 
                                                             - btt-dwf-sdo-ctbl.val-sdo-ctbl-cr.
                    assign d-saldo-ini = btt-dwf-sdo-ctbl.val-sdo-ctbl-fim.

                    /* Ajusta situaá∆o do saldo */
                    assign d-valor = btt-dwf-sdo-ctbl.val-sdo-ctbl-inic.
                    run pi-acerta-debito-credito (input-output d-valor,
                                                  output c-ind-sdo-ctbl).
                    assign btt-dwf-sdo-ctbl.val-sdo-ctbl-inic = d-valor
                           btt-dwf-sdo-ctbl.ind-sdo-ctbl-inic = c-ind-sdo-ctbl.

                    assign d-valor = btt-dwf-sdo-ctbl.val-sdo-ctbl-fim.
                    run pi-acerta-debito-credito (input-output d-valor,
                                                  output c-ind-sdo-ctbl).
                    assign btt-dwf-sdo-ctbl.val-sdo-ctbl-fim = d-valor
                           btt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = c-ind-sdo-ctbl.
                end.
            end.
        end.

        /*
        - Uma vez identificadas as contas, o saldo final das mesmas dar† origem a um movimento contr†rio o seu saldo, 
          para que o mesmo seja zerado, e a contra-partida deste lanáamento ser† lanáado na conta de lucros e perdas 
          (em apenas um movimento, que acumular† todos valores apurados). Estes lanáamentos dever∆o levar em 
          consideraá∆o o centro de custo e a unidade de neg¢cio presentes na temp-table de saldos na partida que 
          ir† zerar o saldo da conta apurada, e dever∆o ser agrupados em um lote de encerramento 
          (dwf-lancto-ctbl.log-lancto-apurac-restdo = yes);
        */

        for each tt-dwf-sdo-ctbl
           where tt-dwf-sdo-ctbl.cod-modul-dtsul = c-modul
             and tt-dwf-sdo-ctbl.cod-empresa     = tt-param.c-empresa
             and tt-dwf-sdo-ctbl.cdn-empresa     = tt-param.i-empresa-ems2
             and tt-dwf-sdo-ctbl.cod-cta-ctbl    = tt-dwf-cta-ctbl.cod-cta-ctbl
             and tt-dwf-sdo-ctbl.num-period-ctbl = month(tt-param.dt-fim)
             and tt-dwf-sdo-ctbl.num-exerc-ctbl  = year(tt-param.dt-fim)
             and tt-dwf-sdo-ctbl.cod-estab       = '':
             

            /* Lanáamento contr†rio ao saldo final para zerar a conta apurada */
            assign i-seq-lancto = i-seq-lancto + 1.

            create tt-dwf-item-lancto-ctbl.
            assign tt-dwf-item-lancto-ctbl.cod-lote-ctbl          = replace(tt-dwf-lancto-ctbl.cod-lote-ctbl, "|", " ")
                   tt-dwf-item-lancto-ctbl.cod-lancto-ctbl        = replace(tt-dwf-lancto-ctbl.cod-lancto-ctbl, "|", " ")
                   tt-dwf-item-lancto-ctbl.num-seq-lancto-ctbl    = i-seq-lancto
                   tt-dwf-item-lancto-ctbl.cdn-empresa            = tt-param.i-empresa-ems2
                   tt-dwf-item-lancto-ctbl.cod-empresa            = tt-param.c-empresa
                   tt-dwf-item-lancto-ctbl.cod-modul-dtsul        = c-modul
                   tt-dwf-item-lancto-ctbl.cod-estab              = ''
                   tt-dwf-item-lancto-ctbl.cod-cta-ctbl           = tt-dwf-sdo-ctbl.cod-cta-ctbl
                   tt-dwf-item-lancto-ctbl.cod-ccusto             = tt-dwf-sdo-ctbl.cod-ccusto
                   tt-dwf-item-lancto-ctbl.cod-unid-negoc         = tt-dwf-sdo-ctbl.cod-unid-negoc
                   tt-dwf-item-lancto-ctbl.val-lancto-ctbl        = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim
                   tt-dwf-item-lancto-ctbl.des-histor-lancto-ctbl = "(Aut) - Movimento Cont†bil de Apuraá∆o de Lucros e Perdas - " + string(tt-param.dt-fim, "99/99/9999")
                   tt-dwf-item-lancto-ctbl.cod-arq-lancto-ctbl    = replace(c-cod-lancto-ctbl, "|", " ")
                   tt-dwf-item-lancto-ctbl.dat-livre-1            = tt-param.dt-fim
                   tt-dwf-item-lancto-ctbl.dat-inic-valid         = dat-today
                   tt-dwf-item-lancto-ctbl.dat-fim-valid          = ?.
            
            if tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = 'C' then do:
                /* Lanáamento contr†rio ao saldo para zerar o saldo */
                assign tt-dwf-item-lancto-ctbl.ind-natur-lancto-ctbl  = 'D'.

                /* Soma o lanáamento no total de dÇbitos na tabela de saldo */
                assign tt-dwf-sdo-ctbl.val-sdo-ctbl-db = tt-dwf-sdo-ctbl.val-sdo-ctbl-db + tt-dwf-item-lancto-ctbl.val-lancto-ctbl.
            end.
            else do: 
                /* Apenas uma das partidas soma no lote */
                assign tt-dwf-lancto-ctbl.val-lancto-ctbl = tt-dwf-lancto-ctbl.val-lancto-ctbl
                                                          + tt-dwf-sdo-ctbl.val-sdo-ctbl-fim.
             
                /* Lanáamento contr†rio ao saldo para zerar o saldo */
                assign tt-dwf-item-lancto-ctbl.ind-natur-lancto-ctbl  = 'C'.

                /* Soma o lanáamento no total de crÇditos na tabela de saldo */
                assign tt-dwf-sdo-ctbl.val-sdo-ctbl-cr = tt-dwf-sdo-ctbl.val-sdo-ctbl-cr + tt-dwf-item-lancto-ctbl.val-lancto-ctbl.
                
            end.

            run pi-verifica-unid-negoc-depara (input tt-param.c-conta-lucros-perdas,
                                               input '',
                                               input tt-dwf-sdo-ctbl.cod-unid-negoc,
                                               input tt-param.dt-fim,
                                               output c-cod-unid-negoc).

            /* Lanáamento na conta de apuraá∆o */
            find first tt-dwf-item-lancto-ctbl
                 where tt-dwf-item-lancto-ctbl.cod-empresa = tt-dwf-lancto-ctbl.cod-empresa
                   and tt-dwf-item-lancto-ctbl.cdn-empresa = tt-dwf-lancto-ctbl.cdn-empresa
                   and tt-dwf-item-lancto-ctbl.cod-modul-dtsul = tt-dwf-lancto-ctbl.cod-modul-dtsul
                   and tt-dwf-item-lancto-ctbl.cod-lote-ctbl = tt-dwf-lancto-ctbl.cod-lote-ctbl
                   and tt-dwf-item-lancto-ctbl.cod-lancto-ctbl = tt-dwf-lancto-ctbl.cod-lancto-ctbl
                   and tt-dwf-item-lancto-ctbl.cod-cta-ctbl = tt-param.c-conta-lucros-perdas
                   and tt-dwf-item-lancto-ctbl.cod-ccusto = ''
                   and tt-dwf-item-lancto-ctbl.cod-unid-negoc = c-cod-unid-negoc
                   and tt-dwf-item-lancto-ctbl.ind-natur-lancto-ctbl = tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim
                no-error.
            if not avail tt-dwf-item-lancto-ctbl then do:
                assign i-seq-lancto = i-seq-lancto + 1.

                create tt-dwf-item-lancto-ctbl.
                assign tt-dwf-item-lancto-ctbl.cod-lote-ctbl          = replace(tt-dwf-lancto-ctbl.cod-lote-ctbl, "|", " ")
                       tt-dwf-item-lancto-ctbl.cod-lancto-ctbl        = replace(tt-dwf-lancto-ctbl.cod-lancto-ctbl, "|", " ")
                       tt-dwf-item-lancto-ctbl.num-seq-lancto-ctbl    = i-seq-lancto
                       tt-dwf-item-lancto-ctbl.cdn-empresa            = tt-param.i-empresa-ems2
                       tt-dwf-item-lancto-ctbl.cod-empresa            = tt-param.c-empresa
                       tt-dwf-item-lancto-ctbl.cod-modul-dtsul        = c-modul
                       tt-dwf-item-lancto-ctbl.cod-estab              = ''
                       tt-dwf-item-lancto-ctbl.cod-cta-ctbl           = tt-param.c-conta-lucros-perdas
                       tt-dwf-item-lancto-ctbl.cod-ccusto             = ''
                       tt-dwf-item-lancto-ctbl.cod-unid-negoc         = c-cod-unid-negoc
                       tt-dwf-item-lancto-ctbl.val-lancto-ctbl        = 0
                       tt-dwf-item-lancto-ctbl.ind-natur-lancto-ctbl  = tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim
                       tt-dwf-item-lancto-ctbl.des-histor-lancto-ctbl = "(Aut) - Movimento Cont†bil de Apuraá∆o de Lucros e Perdas - " + string(tt-param.dt-fim, "99/99/9999")
                       tt-dwf-item-lancto-ctbl.cod-arq-lancto-ctbl    = replace(c-cod-lancto-ctbl, "|", " ")
                       tt-dwf-item-lancto-ctbl.dat-livre-1            = tt-param.dt-fim
                       tt-dwf-item-lancto-ctbl.dat-inic-valid         = dat-today
                       tt-dwf-item-lancto-ctbl.dat-fim-valid          = ?.
            end.     
            /* Soma no lanáamento correspondente na conta de lucros e perdas */
            assign tt-dwf-item-lancto-ctbl.val-lancto-ctbl = tt-dwf-item-lancto-ctbl.val-lancto-ctbl
                                                           + tt-dwf-sdo-ctbl.val-sdo-ctbl-fim.

            if tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = 'C' then do:
                /* Apenas uma das partidas soma no lote */
                assign tt-dwf-lancto-ctbl.val-lancto-ctbl = tt-dwf-lancto-ctbl.val-lancto-ctbl
                                                          + tt-dwf-sdo-ctbl.val-sdo-ctbl-fim.
            end.

            /* Atualiza total de dÇbitos e crÇditos na conta de lucros e perdas */
            for first btt-dwf-sdo-ctbl
                where btt-dwf-sdo-ctbl.cod-modul-dtsul = tt-dwf-item-lancto-ctbl.cod-modul-dtsul
                  and btt-dwf-sdo-ctbl.cod-empresa     = tt-dwf-item-lancto-ctbl.cod-empresa
                  and btt-dwf-sdo-ctbl.cdn-empresa     = tt-dwf-item-lancto-ctbl.cdn-empresa
                  and btt-dwf-sdo-ctbl.cod-cta-ctbl    = tt-param.c-conta-lucros-perdas
                  and btt-dwf-sdo-ctbl.cod-ccusto      = ''
                  and btt-dwf-sdo-ctbl.cod-unid-negoc  = c-cod-unid-negoc
                  and btt-dwf-sdo-ctbl.num-period-ctbl = tt-dwf-sdo-ctbl.num-period-ctbl
                  and btt-dwf-sdo-ctbl.num-exerc-ctbl  = tt-dwf-sdo-ctbl.num-exerc-ctbl
                  and btt-dwf-sdo-ctbl.cod-estab       = '':
                if tt-dwf-item-lancto-ctbl.ind-natur-lancto-ctbl = 'D' then
                    assign btt-dwf-sdo-ctbl.val-sdo-ctbl-db = btt-dwf-sdo-ctbl.val-sdo-ctbl-db + tt-dwf-sdo-ctbl.val-sdo-ctbl-fim.
                else 
                    assign btt-dwf-sdo-ctbl.val-sdo-ctbl-cr = btt-dwf-sdo-ctbl.val-sdo-ctbl-cr + tt-dwf-sdo-ctbl.val-sdo-ctbl-fim.
            end.

            /*
            - AlÇm de criar os lanáamentos, dever∆o ser registrados os saldos das contas antes do encerramento, 
              na temp-table tt-dwf-sdo-ctbl-antes-encert, apenas para as contas de Receita e Despesa. A conta de 
              lucros e perdas n∆o deve ser inclu°da na tabela com saldos antes do encerramento;
            */
            find first tt-dwf-sdo-ctbl-antes-encert use-index dwfsdcta-id
                 where tt-dwf-sdo-ctbl-antes-encert.cod-empresa       = tt-dwf-sdo-ctbl.cod-empresa
                 and   tt-dwf-sdo-ctbl-antes-encert.cod-estab         = tt-dwf-sdo-ctbl.cod-estab
                 and   tt-dwf-sdo-ctbl-antes-encert.cod-modul-dtsul   = tt-dwf-sdo-ctbl.cod-modul-dtsul
                 and   tt-dwf-sdo-ctbl-antes-encert.dat-apurac-restdo = tt-param.dt-fim
                 and   tt-dwf-sdo-ctbl-antes-encert.cod-cta-ctbl      = tt-dwf-sdo-ctbl.cod-cta-ctbl
                 and   tt-dwf-sdo-ctbl-antes-encert.cod-ccusto        = tt-dwf-sdo-ctbl.cod-ccusto
                 and   tt-dwf-sdo-ctbl-antes-encert.cod-unid-neg      = tt-dwf-sdo-ctbl.cod-unid-negoc
                 and   tt-dwf-sdo-ctbl-antes-encert.dat-inic-valid    = dat-today 
                 no-error.

            if  not avail(tt-dwf-sdo-ctbl-antes-encert) then do:
                create tt-dwf-sdo-ctbl-antes-encert.
                assign tt-dwf-sdo-ctbl-antes-encert.cod-empresa       = tt-dwf-sdo-ctbl.cod-empresa
                       tt-dwf-sdo-ctbl-antes-encert.cod-estab         = tt-dwf-sdo-ctbl.cod-estab
                       tt-dwf-sdo-ctbl-antes-encert.cod-cta-ctbl      = tt-dwf-sdo-ctbl.cod-cta-ctbl
                       tt-dwf-sdo-ctbl-antes-encert.cod-ccusto        = tt-dwf-sdo-ctbl.cod-ccusto
                       tt-dwf-sdo-ctbl-antes-encert.cod-unid-neg      = tt-dwf-sdo-ctbl.cod-unid-negoc
                       tt-dwf-sdo-ctbl-antes-encert.cod-modul-dtsul   = tt-dwf-sdo-ctbl.cod-modul-dtsul
                       tt-dwf-sdo-ctbl-antes-encert.dat-apurac-restdo = tt-param.dt-fim
                       tt-dwf-sdo-ctbl-antes-encert.dat-inic-valid    = dat-today 
                       tt-dwf-sdo-ctbl-antes-encert.dat-fim-valid     = ?
                       tt-dwf-sdo-ctbl-antes-encert.ind-sdo-ctbl-fim  = tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim
                       tt-dwf-sdo-ctbl-antes-encert.val-sdo-ctbl-fim-antes-encert = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim
                       .
                IF tt-dwf-sdo-ctbl-antes-encert.val-sdo-ctbl-fim-antes-encert = 0 THEN
                    DELETE tt-dwf-sdo-ctbl-antes-encert.
                if not can-find(first tt_data_apuracao
                                where tt_data_apuracao.ttv_dat_apurac_restdo = tt-param.dt-fim) then do:
                    create tt_data_apuracao.
                    assign tt_data_apuracao.ttv_dat_apurac_restdo = tt-param.dt-fim.
                end.
            end.
        end. /* for each tt-dwf-sdo-ctbl */

        /*
        - Ap¢s a criaá∆o dos lanáamentos e a atualizaá∆o dos saldos antes do encerramento, 
          os saldos dever∆o ser recalculados..;
        */
        run pi-recalc-saldo (input c-modul,
                             input tt-param.c-empresa,
                             input tt-param.i-empresa-ems2,
                             input tt-dwf-cta-ctbl.cod-cta-ctbl).
    end. /* for each tt-dwf-cta-ctbl */

    IF tt-dwf-lancto-ctbl.val-lancto-ctbl = 0 THEN DO:
    
        FOR EACH tt-dwf-item-lancto-ctbl where 
                   tt-dwf-item-lancto-ctbl.cod-empresa = tt-dwf-lancto-ctbl.cod-empresa
                   and tt-dwf-item-lancto-ctbl.cdn-empresa = tt-dwf-lancto-ctbl.cdn-empresa
                   and tt-dwf-item-lancto-ctbl.cod-modul-dtsul = tt-dwf-lancto-ctbl.cod-modul-dtsul
                   and tt-dwf-item-lancto-ctbl.cod-lote-ctbl = tt-dwf-lancto-ctbl.cod-lote-ctbl
                   and tt-dwf-item-lancto-ctbl.cod-lancto-ctbl = tt-dwf-lancto-ctbl.cod-lancto-ctbl
                   and tt-dwf-item-lancto-ctbl.cod-cta-ctbl = tt-param.c-conta-lucros-perdas.

            DELETE tt-dwf-item-lancto-ctbl.

        END.

    DELETE tt-dwf-lancto-ctbl.
    
        
    END.
    /*
    - Recalcula os saldos da conta de lucros e perdas;
    */
    run pi-recalc-saldo (input c-modul,
                         input tt-param.c-empresa,
                         input tt-param.i-empresa-ems2,
                         input tt-param.c-conta-lucros-perdas).
    /*Busca o ultimo registro de apuraá∆o realizado antes do periodo informado em tela*/
    if month(tt-param.dt-ini) = 1 then do:
        find last dwf-sdo-ctbl no-lock
                where dwf-sdo-ctbl.cod-modul-dtsul = c-modul
                  and dwf-sdo-ctbl.cod-empresa     = tt-param.c-empresa
                  and dwf-sdo-ctbl.cdn-empresa     = tt-param.i-empresa-ems2
                  and dwf-sdo-ctbl.cod-cta-ctbl    = tt-param.c-conta-lucros-perdas
                  and dwf-sdo-ctbl.num-period-ctbl <= 12
                  and dwf-sdo-ctbl.num-exerc-ctbl  < year(tt-param.dt-fim) 
                  and dwf-sdo-ctbl.cod-estab = "" no-error.
    end.
    else do:
        find last dwf-sdo-ctbl no-lock
                where dwf-sdo-ctbl.cod-modul-dtsul = c-modul
                  and dwf-sdo-ctbl.cod-empresa     = tt-param.c-empresa
                  and dwf-sdo-ctbl.cdn-empresa     = tt-param.i-empresa-ems2
                  and dwf-sdo-ctbl.cod-cta-ctbl    = tt-param.c-conta-lucros-perdas
                  /*and dwf-sdo-ctbl.dat-livre-2     < tt-param.dt-ini*/
                  and dwf-sdo-ctbl.num-period-ctbl <= month(tt-param.dt-ini - 1)
                  and dwf-sdo-ctbl.num-exerc-ctbl  <= year(tt-param.dt-fim) 
                  and dwf-sdo-ctbl.cod-estab = "" 
                  and dwf-sdo-ctbl.dat-livre-1     < tt-param.dt-ini no-error.
    end.
    if avail dwf-sdo-ctbl then do:
        
        assign d-sdo-final   = dwf-sdo-ctbl.val-sdo-ctbl-fim
               c-ind-sdo-fim = dwf-sdo-ctbl.ind-sdo-ctbl-fim
               v-log-existe-sdo = no.

        /* Atualiza o saldo dos per°odos anteriores atÇ a ultima apuraá∆o encontrada*/
        for each tt-dwf-sdo-ctbl
            where tt-dwf-sdo-ctbl.cod-modul-dtsul = dwf-sdo-ctbl.cod-modul-dtsul
              and tt-dwf-sdo-ctbl.cod-empresa     = dwf-sdo-ctbl.cod-empresa
              and tt-dwf-sdo-ctbl.cdn-empresa     = dwf-sdo-ctbl.cdn-empresa
              and tt-dwf-sdo-ctbl.cod-cta-ctbl    = dwf-sdo-ctbl.cod-cta-ctbl
              and tt-dwf-sdo-ctbl.cod-ccusto      = ""
              and tt-dwf-sdo-ctbl.cod-unid-negoc  = dwf-sdo-ctbl.cod-unid-negoc
              and tt-dwf-sdo-ctbl.num-period-ctbl >= month(tt-param.dt-ini)
              and tt-dwf-sdo-ctbl.num-period-ctbl <= month(tt-param.dt-fim)
              and tt-dwf-sdo-ctbl.num-exerc-ctbl  = year(tt-param.dt-fim) /*dwf-sdo-ctbl.num-exerc-ctbl*/
              and tt-dwf-sdo-ctbl.cod-estab       = dwf-sdo-ctbl.cod-estab:

                if can-find( first btt-dwf-sdo-ctbl no-lock
                             where btt-dwf-sdo-ctbl.cod-modul-dtsul = tt-dwf-sdo-ctbl.cod-modul-dtsul
                               and btt-dwf-sdo-ctbl.cod-empresa     = tt-dwf-sdo-ctbl.cod-empresa
                               and btt-dwf-sdo-ctbl.cdn-empresa     = tt-dwf-sdo-ctbl.cdn-empresa
                               and btt-dwf-sdo-ctbl.cod-cta-ctbl    = tt-dwf-sdo-ctbl.cod-cta-ctbl
                               and btt-dwf-sdo-ctbl.cod-ccusto     <> ""
                               and btt-dwf-sdo-ctbl.cod-unid-negoc  = tt-dwf-sdo-ctbl.cod-unid-negoc
                               and btt-dwf-sdo-ctbl.num-period-ctbl = tt-dwf-sdo-ctbl.num-period-ctbl
                               and btt-dwf-sdo-ctbl.num-exerc-ctbl  = tt-dwf-sdo-ctbl.num-exerc-ctbl
                               and btt-dwf-sdo-ctbl.cod-estab       = tt-dwf-sdo-ctbl.cod-estab) then do:

                                
                    for each btt-dwf-sdo-ctbl exclusive-lock
                        where btt-dwf-sdo-ctbl.cod-modul-dtsul = tt-dwf-sdo-ctbl.cod-modul-dtsul
                          and btt-dwf-sdo-ctbl.cod-empresa     = tt-dwf-sdo-ctbl.cod-empresa
                          and btt-dwf-sdo-ctbl.cdn-empresa     = tt-dwf-sdo-ctbl.cdn-empresa
                          and btt-dwf-sdo-ctbl.cod-cta-ctbl    = tt-dwf-sdo-ctbl.cod-cta-ctbl
                          and btt-dwf-sdo-ctbl.cod-ccusto     <> ""
                          and btt-dwf-sdo-ctbl.cod-unid-negoc  = tt-dwf-sdo-ctbl.cod-unid-negoc
                          and btt-dwf-sdo-ctbl.num-period-ctbl = tt-dwf-sdo-ctbl.num-period-ctbl
                          and btt-dwf-sdo-ctbl.num-exerc-ctbl  = tt-dwf-sdo-ctbl.num-exerc-ctbl
                          and btt-dwf-sdo-ctbl.cod-estab       = tt-dwf-sdo-ctbl.cod-estab:

                        assign d-val-cr = d-val-cr + btt-dwf-sdo-ctbl.val-sdo-ctbl-cr
                               d-val-db = d-val-db + btt-dwf-sdo-ctbl.val-sdo-ctbl-db.

                        delete btt-dwf-sdo-ctbl.

                    end.

                end.
                
                assign tt-dwf-sdo-ctbl.val-sdo-ctbl-inic = d-sdo-final
                       tt-dwf-sdo-ctbl.ind-sdo-ctbl-inic = c-ind-sdo-fim
                       tt-dwf-sdo-ctbl.val-sdo-ctbl-cr   = tt-dwf-sdo-ctbl.val-sdo-ctbl-cr + d-val-cr
                       tt-dwf-sdo-ctbl.val-sdo-ctbl-db   = tt-dwf-sdo-ctbl.val-sdo-ctbl-db + d-val-db.
                if tt-dwf-sdo-ctbl.ind-sdo-ctbl-inic = "C" then do:
                    assign tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = tt-dwf-sdo-ctbl.val-sdo-ctbl-inic + 
                                                              tt-dwf-sdo-ctbl.val-sdo-ctbl-cr - 
                                                              tt-dwf-sdo-ctbl.val-sdo-ctbl-db.
                    if tt-dwf-sdo-ctbl.val-sdo-ctbl-fim < 0 then
                        assign tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = "D"
                               tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim * (-1).
                    else
                        assign tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = "C".

                end.
                else do:
                    assign tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = tt-dwf-sdo-ctbl.val-sdo-ctbl-inic - 
                                                              tt-dwf-sdo-ctbl.val-sdo-ctbl-cr + 
                                                              tt-dwf-sdo-ctbl.val-sdo-ctbl-db.
                    if tt-dwf-sdo-ctbl.val-sdo-ctbl-fim < 0 then
                        assign tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = "C"
                               tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim * (-1).
                    else
                        assign tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = "D".
                end.

                assign d-sdo-final   = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim
                       c-ind-sdo-fim = tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim
                       v-log-existe-sdo = yes.
                
        end.

            
        if v-log-existe-sdo = no then do:

            if dwf-sdo-ctbl.num-period-ctbl = 12 then
                assign v-periodo-repeat-ini = 0.
            else
                assign v-periodo-repeat-ini = dwf-sdo-ctbl.num-period-ctbl.


            repeat v-count = v-periodo-repeat-ini + 1  to month(tt-param.dt-fim) - 1:
                /* Pega o ultimo dia do màs da data final */
                assign dt-aux = date(v-count, 25, year(tt-param.dt-fim))
                       dt-aux = dt-aux + 15
                       dt-aux = date(month(dt-aux), 01, year(dt-aux)) - 1.

            
                        create tt-dwf-sdo-ctbl.
                        buffer-copy dwf-sdo-ctbl except dwf-sdo-ctbl.num-period-ctbl dwf-sdo-ctbl.num-exerc-ctbl to tt-dwf-sdo-ctbl.
                        assign tt-dwf-sdo-ctbl.num-period-ctbl = v-count
                               tt-dwf-sdo-ctbl.num-exerc-ctbl = year(tt-param.dt-fim)
                               tt-dwf-sdo-ctbl.val-sdo-ctbl-inic = dwf-sdo-ctbl.val-sdo-ctbl-fim
                               tt-dwf-sdo-ctbl.ind-sdo-ctbl-inic = dwf-sdo-ctbl.ind-sdo-ctbl-fim
                               tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = dwf-sdo-ctbl.val-sdo-ctbl-fim
                               tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = dwf-sdo-ctbl.ind-sdo-ctbl-fim
                               tt-dwf-sdo-ctbl.dat-inic-valid = dt-aux
                               tt-dwf-sdo-ctbl.dat-livre-1 = date("01/" + string(v-count) + "/" + string(year(tt-param.dt-fim)))
                               tt-dwf-sdo-ctbl.dat-livre-2 = dt-aux
                               tt-dwf-sdo-ctbl.val-sdo-ctbl-db = 0
                               tt-dwf-sdo-ctbl.val-sdo-ctbl-cr = 0.
            end.
        end.    
    end.

    /* 
    - Atualizaá∆o das contas sintÇticas    
    */
    for each tt-dwf-cta-ctbl
       where tt-dwf-cta-ctbl.cod-cta-ctbl-sup = ''
         and tt-dwf-cta-ctbl.ind-tip-cta-ctbl = 'S':

        for each tt-dwf-sdo-ctbl
           where tt-dwf-sdo-ctbl.cod-modul-dtsul = c-modul
             and tt-dwf-sdo-ctbl.cod-empresa = tt-param.c-empresa
             and tt-dwf-sdo-ctbl.cdn-empresa = tt-param.i-empresa-ems2
             and tt-dwf-sdo-ctbl.cod-cta-ctbl = tt-dwf-cta-ctbl.cod-cta-ctbl:

            run pi-recalcula-saldo-sinteticas (
                input tt-dwf-sdo-ctbl.cod-modul-dtsul,
                input tt-dwf-sdo-ctbl.cod-cta-ctbl,
                input tt-dwf-sdo-ctbl.cod-ccusto,
                input tt-dwf-sdo-ctbl.cod-unid-negoc,
                input tt-dwf-sdo-ctbl.num-exerc-ctbl,
                input tt-dwf-sdo-ctbl.num-period-ctbl,
                output d-saldo-ini,
                output d-saldo-db,
                output d-saldo-cr).

            assign tt-dwf-sdo-ctbl.val-sdo-ctbl-inic = d-saldo-ini
                   tt-dwf-sdo-ctbl.val-sdo-ctbl-db = d-saldo-db
                   tt-dwf-sdo-ctbl.val-sdo-ctbl-cr = d-saldo-cr
                   tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = d-saldo-ini 
                                                    + d-saldo-db 
                                                    - d-saldo-cr.

            /* Ajusta situaá∆o do saldo */
            if tt-dwf-sdo-ctbl.val-sdo-ctbl-inic < 0 then
                assign tt-dwf-sdo-ctbl.val-sdo-ctbl-inic = tt-dwf-sdo-ctbl.val-sdo-ctbl-inic * (-1)
                       tt-dwf-sdo-ctbl.ind-sdo-ctbl-inic = 'C'.
    
            if tt-dwf-sdo-ctbl.val-sdo-ctbl-fim < 0 then
                assign tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim * (-1)
                       tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = 'C'.
               
        end.
    end.    
end.
/***************************************************************************************************/
procedure pi-desfaz-apuracao-produto:

    def buffer btt-dwf-sdo-ctbl for tt-dwf-sdo-ctbl.
    def var d-debitos as decimal no-undo.
    def var d-creditos as decimal no-undo.
    def var d-saldo-ini as decimal no-undo.
    def var d-valor as decimal no-undo.
    def var c-ind-sdo-ctbl as char no-undo.
    def var dt-aux as date no-undo.

    for each tt-dwf-lancto-ctbl
        where tt-dwf-lancto-ctbl.log-lancto-apurac-restdo = yes:

        /* Elimina o lote de encerramento */
        for each tt-dwf-item-lancto-ctbl
           where tt-dwf-item-lancto-ctbl.cod-empresa     = tt-dwf-lancto-ctbl.cod-empresa
             and tt-dwf-item-lancto-ctbl.cdn-empresa     = tt-dwf-lancto-ctbl.cdn-empresa
             and tt-dwf-item-lancto-ctbl.cod-modul-dtsul = tt-dwf-lancto-ctbl.cod-modul-dtsul
             and tt-dwf-item-lancto-ctbl.cod-lote-ctbl   = tt-dwf-lancto-ctbl.cod-lote-ctbl
             and tt-dwf-item-lancto-ctbl.cod-lancto-ctbl = tt-dwf-lancto-ctbl.cod-lancto-ctbl:
            delete tt-dwf-item-lancto-ctbl.
        end.
        delete tt-dwf-lancto-ctbl.
    end.

    for each tt-dwf-sdo-ctbl-antes-encert:
        delete tt-dwf-sdo-ctbl-antes-encert.
    end.

    for each tt_data_apuracao:
        delete tt_data_apuracao.
    end.
    /* Recalcula o saldo da contas anal°ticas */
    for each tt-dwf-cta-ctbl
       where tt-dwf-cta-ctbl.ind-tip-cta-ctbl = "A":

        for each tt-dwf-sdo-ctbl
            where tt-dwf-sdo-ctbl.cod-cta-ctbl = tt-dwf-cta-ctbl.cod-cta-ctbl
            by tt-dwf-sdo-ctbl.cod-empresa
            by tt-dwf-sdo-ctbl.num-exerc-ctbl
            by tt-dwf-sdo-ctbl.num-period-ctbl:

            assign d-debitos = 0
                   d-creditos = 0.

            for each tt-dwf-lancto-ctbl
                where tt-dwf-lancto-ctbl.cod-empresa      = tt-dwf-sdo-ctbl.cod-empresa
                  and tt-dwf-lancto-ctbl.cdn-empresa      = tt-dwf-sdo-ctbl.cdn-empresa
                  and tt-dwf-lancto-ctbl.cod-modul-dtsul  = tt-dwf-sdo-ctbl.cod-modul-dtsul
                  and tt-dwf-lancto-ctbl.dat-lancto-ctbl >= tt-dwf-sdo-ctbl.dat-livre-1
                  and tt-dwf-lancto-ctbl.dat-lancto-ctbl <= tt-dwf-sdo-ctbl.dat-livre-2:

                for each tt-dwf-item-lancto-ctbl
                    where tt-dwf-item-lancto-ctbl.cod-empresa     = tt-dwf-lancto-ctbl.cod-empresa
                      and tt-dwf-item-lancto-ctbl.cdn-empresa     = tt-dwf-lancto-ctbl.cdn-empresa
                      and tt-dwf-item-lancto-ctbl.cod-modul-dtsul = tt-dwf-lancto-ctbl.cod-modul-dtsul
                      and tt-dwf-item-lancto-ctbl.cod-lote-ctbl   = tt-dwf-lancto-ctbl.cod-lote-ctbl
                      and tt-dwf-item-lancto-ctbl.cod-lancto-ctbl = tt-dwf-lancto-ctbl.cod-lancto-ctbl
                      and tt-dwf-item-lancto-ctbl.cod-cta-ctbl    = tt-dwf-sdo-ctbl.cod-cta-ctbl
                      and tt-dwf-item-lancto-ctbl.cod-ccusto      = tt-dwf-sdo-ctbl.cod-ccusto
                      and tt-dwf-item-lancto-ctbl.cod-unid-negoc  = tt-dwf-sdo-ctbl.cod-unid-negoc:

                    /* DÇbitos */
                    if tt-dwf-item-lancto-ctbl.ind-natur-lancto-ctbl = "D" then 
                        assign d-debitos = d-debitos + tt-dwf-item-lancto-ctbl.val-lancto-ctbl.
                    /* CrÇditos */
                    else 
                        assign d-creditos = d-creditos + tt-dwf-item-lancto-ctbl.val-lancto-ctbl.
                end. /* for each tt-dwf-item-lancto-ctbl */
            end. /* for each tt-dwf-lancto-ctbl */

            /* Atualiza total de dÇbitos e crÇditos no per°odo */
            assign tt-dwf-sdo-ctbl.val-sdo-ctbl-db = d-debitos
                   tt-dwf-sdo-ctbl.val-sdo-ctbl-cr = d-creditos.

            if tt-dwf-sdo-ctbl.ind-sdo-ctbl-inic = "D" then
                assign d-saldo-ini = tt-dwf-sdo-ctbl.val-sdo-ctbl-inic.
            else 
                assign d-saldo-ini = tt-dwf-sdo-ctbl.val-sdo-ctbl-inic * (-1).
                   
            /* Atualiza saldo final: INICIAL + DB - CR */
            assign tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = d-saldo-ini + 
                                                      tt-dwf-sdo-ctbl.val-sdo-ctbl-db -
                                                      tt-dwf-sdo-ctbl.val-sdo-ctbl-cr.

            /* Acerta "Sinal" do Saldo Final (DB ou CR) */
            assign d-valor = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim.
            run pi-acerta-debito-credito (input-output d-valor,
                                          output c-ind-sdo-ctbl).
            assign tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = d-valor
                   tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = c-ind-sdo-ctbl.

            /* Ajusta o saldo inicial do per°odo seguinte */
            /* acerta data para o dia 25 do màs do saldo*/
            assign dt-aux = date(tt-dwf-sdo-ctbl.num-period-ctbl,
                                 25,
                                 tt-dwf-sdo-ctbl.num-exerc-ctbl).
            assign dt-aux = dt-aux + 10. /* dia 25 + 10 dias, para pegar o pr¢ximo màs */                                     

            find first btt-dwf-sdo-ctbl
                 where btt-dwf-sdo-ctbl.cod-empresa = tt-dwf-sdo-ctbl.cod-empresa
                   and btt-dwf-sdo-ctbl.cdn-empresa = tt-dwf-sdo-ctbl.cdn-empresa
                   and btt-dwf-sdo-ctbl.cod-modul-dtsul = tt-dwf-sdo-ctbl.cod-modul-dtsul
                   and btt-dwf-sdo-ctbl.cod-cta-ctbl = tt-dwf-sdo-ctbl.cod-cta-ctbl
                   and btt-dwf-sdo-ctbl.cod-ccusto = tt-dwf-sdo-ctbl.cod-ccusto
                   and btt-dwf-sdo-ctbl.cod-unid-negoc = tt-dwf-sdo-ctbl.cod-unid-negoc
                   and btt-dwf-sdo-ctbl.num-exerc-ctbl = year(dt-aux)
                   and btt-dwf-sdo-ctbl.num-period-ctbl = month(dt-aux)
                   and btt-dwf-sdo-ctbl.cod-estab = tt-dwf-sdo-ctbl.cod-estab
                   no-error.
            if avail btt-dwf-sdo-ctbl then 
                assign btt-dwf-sdo-ctbl.val-sdo-ctbl-inic = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim
                       btt-dwf-sdo-ctbl.ind-sdo-ctbl-inic = tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim.
            else if tt-dwf-sdo-ctbl.val-sdo-ctbl-fim <> 0 then do:
                /* Caso a apuraá∆o do produto tenha zerado o saldo, Ç necess†rio verificar se existem per°odos posteriores 
                   para replicar o saldo, que n∆o ser† mais zero sem a apuraá∆o */
                find first tt_period
                     where tt_period.ttv_num_mes = (if tt-dwf-sdo-ctbl.num-period-ctbl = 12 then 1 else tt-dwf-sdo-ctbl.num-period-ctbl + 1)
                       and tt_period.ttv_num_ano = (if tt-dwf-sdo-ctbl.num-period-ctbl = 12 then tt-dwf-sdo-ctbl.num-exerc-ctbl + 1 else tt-dwf-sdo-ctbl.num-exerc-ctbl)
                    no-error.

                /* Cria saldo para os meses seguintes */
                repeat while avail tt_period:
                    create btt-dwf-sdo-ctbl.
                    assign btt-dwf-sdo-ctbl.cod-modul-dtsul   = tt-dwf-sdo-ctbl.cod-modul-dtsul
                           btt-dwf-sdo-ctbl.cdn-empresa       = tt-dwf-sdo-ctbl.cdn-empresa
                           btt-dwf-sdo-ctbl.cod-empresa       = tt-dwf-sdo-ctbl.cod-empresa
                           btt-dwf-sdo-ctbl.cod-estab         = ""
                           btt-dwf-sdo-ctbl.cod-cta-ctbl      = tt-dwf-sdo-ctbl.cod-cta-ctbl
                           btt-dwf-sdo-ctbl.cod-ccusto        = tt-dwf-sdo-ctbl.cod-ccusto
                           btt-dwf-sdo-ctbl.cod-unid-negoc    = tt-dwf-sdo-ctbl.cod-unid-negoc
                           btt-dwf-sdo-ctbl.num-period-ctbl   = tt_period.ttv_num_mes
                           btt-dwf-sdo-ctbl.num-exerc-ctbl    = tt_period.ttv_num_ano
                           btt-dwf-sdo-ctbl.val-sdo-ctbl-inic = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim
                           btt-dwf-sdo-ctbl.ind-sdo-ctbl-inic = tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim
                           btt-dwf-sdo-ctbl.val-sdo-ctbl-cr   = 0
                           btt-dwf-sdo-ctbl.val-sdo-ctbl-db   = 0
                           btt-dwf-sdo-ctbl.val-sdo-ctbl-fim  = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim
                           btt-dwf-sdo-ctbl.ind-sdo-ctbl-fim  = tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim
                           btt-dwf-sdo-ctbl.ind-espec-cta-ctbl = tt-dwf-sdo-ctbl.ind-espec-cta-ctbl
                           &IF "{&mgadm_version}" >= "2.09" &THEN
                           btt-dwf-sdo-ctbl.dat-sdo            = tt_period.ttv_dat_fim_param
                           &ENDIF
                           btt-dwf-sdo-ctbl.dat-livre-1        = tt_period.ttv_dat_inic_param 
                           btt-dwf-sdo-ctbl.dat-livre-2        = tt_period.ttv_dat_fim_param 
                           btt-dwf-sdo-ctbl.dat-inic-valid     = tt-dwf-sdo-ctbl.dat-inic-valid 
                           btt-dwf-sdo-ctbl.dat-fim-valid      = tt-dwf-sdo-ctbl.dat-fim-valid
                           .
                    find first tt_period
                         where tt_period.ttv_num_mes = (if btt-dwf-sdo-ctbl.num-period-ctbl = 12 then 1 else btt-dwf-sdo-ctbl.num-period-ctbl + 1)
                               and tt_period.ttv_num_ano = (if btt-dwf-sdo-ctbl.num-period-ctbl = 12 then btt-dwf-sdo-ctbl.num-exerc-ctbl + 1 else btt-dwf-sdo-ctbl.num-exerc-ctbl)
                        no-error. 
                end.
            end.
        end. /* for each tt-dwf-sdo-ctbl */
    end. /* for each tt-dwf-cta-ctbl */

end procedure.
/***************************************************************************************************/
procedure pi-calcula-saldo-ini-conta-lucros-perdas:

    define buffer btt-dwf-sdo-ctbl for tt-dwf-sdo-ctbl.

    find last dwf-histor-sped-ctbl
        where dwf-histor-sped-ctbl.cod-empresa = tt-param.c-empresa
          and dwf-histor-sped-ctbl.cod-estab = ''
          and dwf-histor-sped-ctbl.dat-inic-period < tt-param.dt-ini
          and dwf-histor-sped-ctbl.dat-fim-period < tt-param.dt-fim
          and dwf-histor-sped-ctbl.cod-produt-dtsul = (if tt-param.c-contabilidade = 'ems2' then 'EMS 2' else 'EMS 5')
          and dwf-histor-sped-ctbl.ind-diario = 'Geral'
          no-lock no-error.
          
    /* 
    - Caso tenha sido executada pelo SPED, o saldo inicial da conta de lucros e perdas ser† buscado do MLF; 
      Caso contr†rio, ser† utilizado o saldo inicial desta conta do produto;
    */
    &if "{&mgadm_version}" >= "2.09" &then
    if avail dwf-histor-sped-ctbl and
       dwf-histor-sped-ctbl.log-apurac-result-sped = yes then do:
    &else
    if avail dwf-histor-sped-ctbl and
       dwf-histor-sped-ctbl.log-livre-2 = yes then do:
    &endif
        /* 
        Essa rotina s¢ ser† executada quandoo periodo anterior, no mesmo ano, tiver sido apurado pelo SPED. 
        */
        for each dwf-sdo-ctbl NO-LOCK
           where dwf-sdo-ctbl.cod-modul-dtsul = (if tt-param.c-contabilidade = 'ems2' then 'MCT' else 'FGL')
             and dwf-sdo-ctbl.cod-empresa = tt-param.c-empresa
             and dwf-sdo-ctbl.cdn-empresa = tt-param.i-empresa-ems2
             and dwf-sdo-ctbl.cod-cta-ctbl = tt-param.c-conta-lucros-perdas
             and dwf-sdo-ctbl.num-period-ctbl = month(tt-param.dt-ini - 1)
             and dwf-sdo-ctbl.num-exerc-ctbl = year(tt-param.dt-ini - 1)
             and dwf-sdo-ctbl.dat-livre-2 = (tt-param.dt-ini - 1):
             for each btt-dwf-sdo-ctbl where btt-dwf-sdo-ctbl.cod-modul-dtsul = dwf-sdo-ctbl.cod-modul-dtsul
                    and btt-dwf-sdo-ctbl.cod-empresa     = dwf-sdo-ctbl.cod-empresa
                    and btt-dwf-sdo-ctbl.cdn-empresa     = dwf-sdo-ctbl.cdn-empresa
                    and btt-dwf-sdo-ctbl.cod-cta-ctbl    = dwf-sdo-ctbl.cod-cta-ctbl
                    and btt-dwf-sdo-ctbl.cod-ccusto      = dwf-sdo-ctbl.cod-ccusto
                    and btt-dwf-sdo-ctbl.cod-unid-negoc  = dwf-sdo-ctbl.cod-unid-negoc
                    and btt-dwf-sdo-ctbl.num-period-ctbl >= month(tt-param.dt-ini)
                    and btt-dwf-sdo-ctbl.num-period-ctbl <= month(tt-param.dt-fim)
                    and btt-dwf-sdo-ctbl.num-exerc-ctbl  = dwf-sdo-ctbl.num-exerc-ctbl
                    and btt-dwf-sdo-ctbl.cod-estab       = dwf-sdo-ctbl.cod-estab:
                 assign btt-dwf-sdo-ctbl.val-sdo-ctbl-inic = dwf-sdo-ctbl.val-sdo-ctbl-fim
                        btt-dwf-sdo-ctbl.ind-sdo-ctbl-inic = dwf-sdo-ctbl.ind-sdo-ctbl-fim
                        btt-dwf-sdo-ctbl.val-sdo-ctbl-fim  = dwf-sdo-ctbl.val-sdo-ctbl-fim
                        btt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = dwf-sdo-ctbl.ind-sdo-ctbl-fim.
             end.                                  
         end.
    end.

end.
/***************************************************************************************************/
procedure pi-verifica-unid-negoc-depara:
    /* A l¢gica desta pi foi adaptada da l¢gica existente na procedure 
    pi_extrator_sped_verifica_un_depara, no programa prgint/utb/utb733za.py (EMS 5) */

    define input param p-cod-cta-ctbl   as char no-undo.
    define input param p-cod-ccusto     as char no-undo.
    define input param p-cod-unid-negoc as char no-undo.
    define input param p-dat-movto      as date no-undo.
    define output param p-cod-return    as char no-undo.

    /* Verifica se a Unidade de Neg¢cio est† informada no de-para na data do lanáamento/saldo */
    if can-find(first tt-dwf-cta-ctbl-refer
                where tt-dwf-cta-ctbl-refer.cod-cta-ctbl = p-cod-cta-ctbl
                  and tt-dwf-cta-ctbl-refer.cod-ccusto   = p-cod-ccusto
                  and tt-dwf-cta-ctbl-refer.cod-unid-neg = p-cod-unid-negoc) then do:
        for each tt-dwf-cta-ctbl-refer
           where tt-dwf-cta-ctbl-refer.cod-cta-ctbl = p-cod-cta-ctbl
             and tt-dwf-cta-ctbl-refer.cod-ccusto   = p-cod-ccusto
             and tt-dwf-cta-ctbl-refer.cod-unid-neg = p-cod-unid-negoc:

            if p-dat-movto >= tt-dwf-cta-ctbl-refer.dat-inic-period and
               p-dat-movto <= tt-dwf-cta-ctbl-refer.dat-fim-period then do:
                assign p-cod-return = p-cod-unid-negoc.
            end.
        end.
    end.

    /* Verifica se a Unidade de Neg¢cio est† informada no de-para na data do lanáamento/saldo, com centro de custo em branco */
    if p-cod-return = "" and
       can-find(first tt-dwf-cta-ctbl-refer
                where tt-dwf-cta-ctbl-refer.cod-cta-ctbl = p-cod-cta-ctbl
                  and tt-dwf-cta-ctbl-refer.cod-ccusto   = ''
                  and tt-dwf-cta-ctbl-refer.cod-unid-neg = p-cod-unid-negoc) then do:
        for each tt-dwf-cta-ctbl-refer
           where tt-dwf-cta-ctbl-refer.cod-cta-ctbl = p-cod-cta-ctbl
             and tt-dwf-cta-ctbl-refer.cod-ccusto   = ''
             and tt-dwf-cta-ctbl-refer.cod-unid-neg = p-cod-unid-negoc:

            if p-dat-movto >= tt-dwf-cta-ctbl-refer.dat-inic-period and
               p-dat-movto <= tt-dwf-cta-ctbl-refer.dat-fim-period then do:
                assign p-cod-return = p-cod-unid-negoc.
            end.
        end.
    end.

    /* Se o centro de custo for branco e n∆o houver traduá∆o especifica para a unidade de neg¢cio 
       na conta (p-cod-cta-ctbl), ent∆o verifica se a unidade est† em alguma traduá∆o para esta
       conta, independente do centro de custo. */
    if p-cod-return = "" and
       p-cod-ccusto = "" and 
       can-find(first tt-dwf-cta-ctbl-refer
                where tt-dwf-cta-ctbl-refer.cod-cta-ctbl = p-cod-cta-ctbl
                  and tt-dwf-cta-ctbl-refer.cod-unid-neg = p-cod-unid-negoc) then do:
        for each tt-dwf-cta-ctbl-refer
           where tt-dwf-cta-ctbl-refer.cod-cta-ctbl = p-cod-cta-ctbl
             and tt-dwf-cta-ctbl-refer.cod-unid-neg = p-cod-unid-negoc:

            if p-dat-movto >= tt-dwf-cta-ctbl-refer.dat-inic-period and
               p-dat-movto <= tt-dwf-cta-ctbl-refer.dat-fim-period then do:
                assign p-cod-return = p-cod-unid-negoc.
            end.
        end.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-recalc-saldo:

    define input param p-modul        as char no-undo.
    define input param p-empresa      as char no-undo.
    define input param p-empresa-ems2 like tt-param.i-empresa-ems2 no-undo.
    define input param p-cod-cta-ctbl as char no-undo.

    define buffer btt-dwf-sdo-ctbl for tt-dwf-sdo-ctbl.
    define variable d-valor as decimal no-undo.
    define variable c-ind-sdo-ctbl as char no-undo.

    for each tt-dwf-sdo-ctbl
       where tt-dwf-sdo-ctbl.cod-modul-dtsul = p-modul
         and tt-dwf-sdo-ctbl.cod-empresa     = p-empresa
         and tt-dwf-sdo-ctbl.cdn-empresa     = p-empresa-ems2
         and tt-dwf-sdo-ctbl.cod-cta-ctbl    = p-cod-cta-ctbl
         by tt-dwf-sdo-ctbl.cod-ccusto
         by tt-dwf-sdo-ctbl.cod-unid-negoc
         by tt-dwf-sdo-ctbl.num-exerc-ctbl
         by tt-dwf-sdo-ctbl.num-period-ctbl:

        /* O saldo inicial do primeiro periodo ser† zero e dos pr¢ximos periodos
           possuir† o valor calculado do saldo final do periodo anterior. Logo,
           n∆o Ç necess†rio realizar a convers∆o de sinal de acordo com a situaá∆o (D ou C) 
           Para a conta de lucros e perdas, o saldo ser† diferente de zero. Portanto, Ç necess†rio 
           converter o sinal conforme a situaá∆o */


        if tt-dwf-sdo-ctbl.val-sdo-ctbl-inic < 0 then
            assign tt-dwf-sdo-ctbl.val-sdo-ctbl-inic = tt-dwf-sdo-ctbl.val-sdo-ctbl-inic * (-1).

        if tt-dwf-sdo-ctbl.ind-sdo-ctbl-inic = 'C' then do:
            assign tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = tt-dwf-sdo-ctbl.val-sdo-ctbl-inic
                                                    - tt-dwf-sdo-ctbl.val-sdo-ctbl-db 
                                                    + tt-dwf-sdo-ctbl.val-sdo-ctbl-cr.

            if tt-dwf-sdo-ctbl.val-sdo-ctbl-fim < 0 then
                assign tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = 'D'
                       tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim * (-1).
            else
                assign tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = 'C'.
        end.
        else do:
            assign tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = tt-dwf-sdo-ctbl.val-sdo-ctbl-inic
                                                    + tt-dwf-sdo-ctbl.val-sdo-ctbl-db 
                                                    - tt-dwf-sdo-ctbl.val-sdo-ctbl-cr.
            if tt-dwf-sdo-ctbl.val-sdo-ctbl-fim < 0 then
                assign tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = 'C'
                       tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim * (-1).
            else
                assign tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = 'D'.
        end.

        /* Atualiza o saldo inicial do pr¢ximo periodo */                                                    
        for first btt-dwf-sdo-ctbl
            where btt-dwf-sdo-ctbl.cod-modul-dtsul = tt-dwf-sdo-ctbl.cod-modul-dtsul
              and btt-dwf-sdo-ctbl.cod-empresa     = tt-dwf-sdo-ctbl.cod-empresa
              and btt-dwf-sdo-ctbl.cdn-empresa     = tt-dwf-sdo-ctbl.cdn-empresa
              and btt-dwf-sdo-ctbl.cod-cta-ctbl    = tt-dwf-sdo-ctbl.cod-cta-ctbl
              and btt-dwf-sdo-ctbl.cod-ccusto      = tt-dwf-sdo-ctbl.cod-ccusto
              and btt-dwf-sdo-ctbl.cod-unid-negoc  = tt-dwf-sdo-ctbl.cod-unid-negoc
              and btt-dwf-sdo-ctbl.num-period-ctbl = (if tt-dwf-sdo-ctbl.num-period-ctbl < 12 then (tt-dwf-sdo-ctbl.num-period-ctbl + 1) else 1)
              and btt-dwf-sdo-ctbl.num-exerc-ctbl  = (if tt-dwf-sdo-ctbl.num-period-ctbl < 12 then tt-dwf-sdo-ctbl.num-exerc-ctbl else (tt-dwf-sdo-ctbl.num-exerc-ctbl + 1))
              and btt-dwf-sdo-ctbl.cod-estab       = tt-dwf-sdo-ctbl.cod-estab:
            assign btt-dwf-sdo-ctbl.val-sdo-ctbl-inic = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim.
        end.

        /* Ajusta situaá∆o do saldo */

        if tt-dwf-sdo-ctbl.val-sdo-ctbl-inic < 0 then
            assign tt-dwf-sdo-ctbl.val-sdo-ctbl-inic = tt-dwf-sdo-ctbl.val-sdo-ctbl-inic * (-1)
                   tt-dwf-sdo-ctbl.ind-sdo-ctbl-inic = 'C'.
    
        if tt-dwf-sdo-ctbl.val-sdo-ctbl-fim < 0 then
            assign tt-dwf-sdo-ctbl.val-sdo-ctbl-fim = tt-dwf-sdo-ctbl.val-sdo-ctbl-fim * (-1)
                   tt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = 'C'.
    end.

end procedure.
/***************************************************************************************************/
procedure pi-recalcula-saldo-sinteticas:
    define input param p-modulo as char no-undo.
    define input param p-cod-cta-ctbl-sup as char no-undo.
    define input param p-cod-ccusto as char no-undo.
    define input param p-cod-unid-negoc as char no-undo.
    define input param p-num-exerc-ctbl as int no-undo.
    define input param p-num-period-ctbl as int no-undo.
    define output param p-saldo-ini as decimal no-undo.
    define output param p-saldo-db as decimal no-undo.
    define output param p-saldo-cr as decimal no-undo.

    define buffer btt-dwf-cta-ctbl for tt-dwf-cta-ctbl.
    define buffer btt-dwf-sdo-ctbl for tt-dwf-sdo-ctbl.

    define variable d-saldo-ini as decimal no-undo.
    define variable d-saldo-db as decimal no-undo.
    define variable d-saldo-cr as decimal no-undo.

    define variable d-valor as decimal no-undo.
    define variable c-ind-sdo-ctbl as char no-undo.

    for each btt-dwf-cta-ctbl
        where btt-dwf-cta-ctbl.cod-cta-ctbl-sup = p-cod-cta-ctbl-sup:
        if btt-dwf-cta-ctbl.ind-tip-cta-ctbl = 'A' then do:
            /* Busca o saldo da conta analitica */
            for first btt-dwf-sdo-ctbl
                where btt-dwf-sdo-ctbl.cod-modul-dtsul = p-modulo
                  and btt-dwf-sdo-ctbl.cod-empresa = tt-param.c-empresa
                  and btt-dwf-sdo-ctbl.cdn-empresa = tt-param.i-empresa-ems2
                  and btt-dwf-sdo-ctbl.cod-cta-ctbl = btt-dwf-cta-ctbl.cod-cta-ctbl
                  and btt-dwf-sdo-ctbl.cod-ccusto = p-cod-ccusto
                  and btt-dwf-sdo-ctbl.cod-unid-negoc = p-cod-unid-negoc
                  and btt-dwf-sdo-ctbl.num-period-ctbl = p-num-period-ctbl
                  and btt-dwf-sdo-ctbl.num-exerc-ctbl = p-num-exerc-ctbl:

                assign p-saldo-ini = (if btt-dwf-sdo-ctbl.ind-sdo-ctbl-inic = 'C' 
                                      then btt-dwf-sdo-ctbl.val-sdo-ctbl-inic * (-1)
                                      else btt-dwf-sdo-ctbl.val-sdo-ctbl-inic)
                       p-saldo-db  = btt-dwf-sdo-ctbl.val-sdo-ctbl-db
                       p-saldo-cr  = btt-dwf-sdo-ctbl.val-sdo-ctbl-cr
                       .

            end.
        end.
        else do:
            /* Chama recursivo */
            run pi-recalcula-saldo-sinteticas (
                input p-modulo,
                input btt-dwf-cta-ctbl.cod-cta-ctbl,
                input p-cod-ccusto,
                input p-cod-unid-negoc,
                input p-num-exerc-ctbl,
                input p-num-period-ctbl,
                output d-saldo-ini,
                output d-saldo-db,
                output d-saldo-cr).

            for first btt-dwf-sdo-ctbl
                where btt-dwf-sdo-ctbl.cod-modul-dtsul = p-modulo
                  and btt-dwf-sdo-ctbl.cod-empresa = tt-param.c-empresa
                  and btt-dwf-sdo-ctbl.cdn-empresa = tt-param.i-empresa-ems2
                  and btt-dwf-sdo-ctbl.cod-cta-ctbl = btt-dwf-cta-ctbl.cod-cta-ctbl
                  and btt-dwf-sdo-ctbl.cod-ccusto = p-cod-ccusto
                  and btt-dwf-sdo-ctbl.cod-unid-negoc = p-cod-unid-negoc
                  and btt-dwf-sdo-ctbl.num-period-ctbl = p-num-period-ctbl
                  and btt-dwf-sdo-ctbl.num-exerc-ctbl = p-num-exerc-ctbl:

                assign btt-dwf-sdo-ctbl.val-sdo-ctbl-inic = d-saldo-ini
                       btt-dwf-sdo-ctbl.val-sdo-ctbl-db = d-saldo-db
                       btt-dwf-sdo-ctbl.val-sdo-ctbl-cr = d-saldo-cr
                       btt-dwf-sdo-ctbl.val-sdo-ctbl-fim = d-saldo-ini 
                                                        + d-saldo-db 
                                                        - d-saldo-cr.

                /* Ajusta situaá∆o do saldo */
                assign d-valor = btt-dwf-sdo-ctbl.val-sdo-ctbl-inic.
                run pi-acerta-debito-credito (input-output d-valor,
                                              output c-ind-sdo-ctbl).
                assign btt-dwf-sdo-ctbl.val-sdo-ctbl-inic = d-valor
                       btt-dwf-sdo-ctbl.ind-sdo-ctbl-inic = c-ind-sdo-ctbl.

                assign d-valor = btt-dwf-sdo-ctbl.val-sdo-ctbl-fim.
                run pi-acerta-debito-credito (input-output d-valor,
                                              output c-ind-sdo-ctbl).
                assign btt-dwf-sdo-ctbl.val-sdo-ctbl-fim = d-valor
                       btt-dwf-sdo-ctbl.ind-sdo-ctbl-fim = c-ind-sdo-ctbl.
            end.

            assign p-saldo-ini = p-saldo-ini + d-saldo-ini
                   p-saldo-db  = p-saldo-db + d-saldo-db
                   p-saldo-cr  = p-saldo-cr + d-saldo-cr.
        end.
    end.

end procedure.
/***************************************************************************************************/
/* 
    FIM da rotina de apuraá∆o de resultados 
*/
