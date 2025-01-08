
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHARACTER FORMAT "x(35)":U
    FIELD usuario           AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    field cod-estab-ini     as char
    field cod-estab-fim     as char
    FIELD i-ano-med         AS INTEGER FORMAT "9999":U
    FIELD i-mes-med         AS INTEGER FORMAT "99":U
    FIELD da-data-ini       as date
    FIELD da-data-fim       as date
    FIELD da-data-medio     AS DATE
    FIELD it-codigo-ini     AS CHARACTER
    FIELD it-codigo-fim     AS CHARACTER
    FIELD cod-rep-ini       AS INTEGER
    FIELD cod-rep-fim       AS INTEGER
    FIELD cod-emitente-ini  AS INTEGER
    FIELD cod-emitente-fim  AS INTEGER
    FIELD cod-gr-cli-ini    AS INTEGER
    FIELD cod-gr-cli-fim    AS INTEGER
    FIELD fm-cod-com-ini    AS CHARACTER
    FIELD fm-cod-com-fim    AS CHARACTER
    FIELD l-vl-presente     as dec format ">9.999999" 
    FIELD vl-icms-est       AS DEC
    FIELD l-imp-nota        AS LOG.    

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

def temp-table tt-calcula
    FIELD ajustes               AS LOGICAL INITIAL NO
    field tipo                  as int   /*( 1 - NFF 2 - Devolucoes **/
    FIELD cod-estabel           AS CHARACTER
    field cod-msg               as int format "999"
    field unid-neg              like unid-neg-fat.cod_unid_negoc /*unid-neg.codigo*/
    field descricao-un          AS CHARACTER  /*like unid-neg-fat.descricao*/
    field unid-neg-nota         like unid-neg-fat.cod_unid_negoc /*unid-neg.codigo*/
    field descricao-un-nota     AS CHARACTER  /*like unid-neg-fat.descricao*/
    field nome-abrev            like emitente.nome-abrev
    FIELD nr-nota-fis           LIKE nota-fiscal.nr-nota-fis
    FIELD nr-pedcli             LIKE nota-fiscal.nr-pedcli
    FIELD dt-emis-nota          AS DATE FORMAT "99/99/9999"
    FIELD nat-operacao          LIKE it-nota-fisc.nat-operacao
    FIELD cod-categoria         AS CHARACTER
    field cgc                   as char 
    field cod-emitente          like emitente.cod-emitente
    field cod-rep               like repres.cod-rep
    field cod-gr-cli            like emitente.cod-gr-cli
    field cd-gr-com             AS CHARACTER FORMAT "x(04)" 
    FIELD c-desc-grupo          AS CHARACTER
    FIELD fm-cod-com            LIKE ITEM.fm-cod-com
    FIELD c-desc-familia        AS CHARACTER
    FIELD fm-codigo             LIKE ITEM.fm-codigo
    FIELD codigo-orig           LIKE ITEM.codigo-orig
    field it-codigo             like item.it-codigo 
    field descricao             as char 
    field qtd                   as decimal
    field receita               as decimal 
    field ipi                   as decimal
    field receita-bruta         as decimal
    field devolucao             as decimal
    field rec-sem-ipi           as decimal
    field vl-icms               as decimal
    field vl-icms-cp            as DECIMAL /* CREDITO PRESUMIDO */
    field vl-icms-cpi           as DECIMAL /* CREDITO PRESUMIDO IMPORTADO */
    FIELD vl-icms-cpre          AS DECIMAL /* CREDITO PRESUMIDO REGIME ESPECIAL */
    FIELD vl-icms-subs          AS DECIMAL
    field vl-pis                as decimal
    field vl-cofins             as decimal
    FIELD vl-CPRB               as decimal
    field vl-iss                as decimal
    FIELD vl-icms-est           AS DECIMAL
    field vl-acordo             as decimal
    field vl-fidelidade         as decimal
    field comissao              as decimal
    field comissao-distrato     as decimal
    field frete                 as decimal
    field custo-fixo-prod       as decimal
    field rol                   as decimal 
    FIELD vl-prot-preco         AS DECIMAL
    field vpc                   as decimal 
    field vl-mkt                as decimal 
    field custo-mat             as decimal 
    field lucro-bruto           as decimal 
    field margem-contribuicao   as decimal
    field p&d                   as decimal
    field marg-contrib-p&d      as DECIMAL
    field preco-medio           as decimal 
    field perc-lucro-rol        as decimal
    field desp-adm              as decimal
    field desp-com              as decimal
    field lucro-operacional     as decimal 
    FIELD calcula-vpc           AS LOG
    FIELD c-mercado             AS CHARACTER
    FIELD c-origem              AS CHARACTER
    FIELD estado                AS CHARACTER
    FIELD pais                  AS CHARACTER
    FIELD nome-repres           AS CHARACTER 
    FIELD transf-margem         AS DECIMAL
    FIELD atendente             AS CHARACTER INITIAL "0"
    FIELD nome-matriz           AS CHARACTER 
    FIELD ncm                   LIKE ITEM.class-fiscal
    FIELD cod-segmento          AS CHAR
    FIELD desc-segmento         AS CHAR
    FIELD desc-segmento-ant     AS CHAR
    FIELD consum-final          LIKE natur-oper.consum-final
    FIELD vl-bicms-it           LIKE it-nota-fisc.vl-bicms-it
    FIELD c-vertical            AS CHAR
    FIELD cod-estab-substituido AS CHAR
    FIELD unid-neg-substituida  AS CHAR
    FIELD de-vl-icms-fcp        AS DECIMAL
    FIELD de-vl-icms-uf-dest    AS DECIMAL
    FIELD nr-seq-fat            AS INTEGER
    FIELD serie                 AS CHAR FORMAT "x(5)"
    FIELD de-vl-icms-uf-remet   AS DECIMAL 
    FIELD it-codigo-kit         AS CHAR FORMAT "x(16)"
    FIELD it-codigo-kit-desc    AS CHAR FORMAT "x(40)"
    FIELD desc-segmento-kit     AS CHAR 
    FIELD desc-segmento-kit-ant AS CHAR
    FIELD desc-unidade-kit-ant  AS CHAR 
    FIELD cod-transp            AS INTEGER
    FIELD nome-transp           AS CHARACTER FORMAT "X(30)"
    FIELD dt-prev-entrega       AS CHAR
    FIELD dt-entrega            AS CHAR
    FIELD cidade                AS CHAR

    index item
          it-codigo
    index totais
          ajustes
          unid-neg
          it-codigo
    INDEX chave
          tipo
          cod-estabel
          unid-neg
          nome-abrev
          cod-gr-cli
          fm-cod-com
          it-codigo
          nr-nota-fis
          serie
          nr-seq-fat
          cod-rep
          cod-segmento
          c-vertical
    INDEX ch-ajustes ajustes tipo cod-estabel c-mercado c-origem unid-neg.

def temp-table tt_input_leitura_sdo no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    index tt_ID                            is primary
          ttv_num_seq_1                    ascending.

def temp-table tt_retorna_sdo_ctbl no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequ¼ncia" column-label "NumSeq"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Contÿbil" column-label "Conta Contÿbil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cenÿrio Contÿbil" column-label "Cenÿrio Contÿbil"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field tta_dat_sdo_ctbl                 as date format "99/99/9999" initial ? label "Data Saldo Contÿbil" column-label "Data Saldo Contÿbil"
    field tta_val_sdo_ctbl_db              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto D²bito" column-label "Movto D²bito"
    field tta_val_sdo_ctbl_cr              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto Cr²dito" column-label "Movto Cr²dito"
    field tta_val_sdo_ctbl_fim             as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Contÿbil Final" column-label "Saldo Contÿbil Final"
    field tta_val_apurac_restdo            as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apura»’o Resultado" column-label "Apura»’o Resultado"
    field tta_val_apurac_restdo_db         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apura»’o Restdo DB" column-label "Apura»’o Restdo DB"
    field tta_val_apurac_restdo_cr         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apura»’o Restdo CR" column-label "Apura»’o Restdo CR"
    field tta_val_apurac_restdo_acum       as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuracao Final" column-label "Apuracao Final"
    field tta_val_sdo_ctbl_db_sint         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto D²bito Sint" column-label "Movto D²bito Sint"
    field tta_val_sdo_ctbl_cr_sint         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto Cr²dito Sint" column-label "Movto Cr²dito Sint"
    field tta_val_sdo_ctbl_fim_sint        as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Sint²tico" column-label "Saldo Sint²tico"
    field tta_val_apurac_restdo_sint       as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuracao Resultado" column-label "Apuracao Resultado"
    field tta_val_apurac_restdo_sint_db    as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apur Restdo Sint DB" column-label "Apur Restdo Sint DB"
    field tta_val_apurac_restdo_sint_cr    as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apur Restdo Sint CR" column-label "Apur Restdo Sint CR"
    field tta_val_apurac_restdo_sint_acum  as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apur Result Sint" column-label "Apur Result Sint"
    field tta_val_movto_empenh             as decimal format "->>,>>>,>>>,>>9.99" decimals 9 initial 0 label "Movto Empenhado" column-label "Movto Empenhado"
    field tta_qtd_sdo_ctbl_db              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade DB" column-label "Quantidade DB"
    field tta_qtd_sdo_ctbl_cr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade CR" column-label "Quantidade CR"
    field tta_qtd_sdo_ctbl_fim             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade Final" column-label "Quantidade Final"
    field ttv_val_movto_ctbl               as decimal format ">>>,>>>,>>>,>>9.99" decimals 2
    field tta_qtd_movto_empenh             as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Qtde Movto Empenhado" column-label "Qtde Movto Empenhado"
    index tt_cta                          
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_proj_financ              ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_dat_sdo_ctbl                 ascending
          tta_num_seq                      ascending
    index tt_id2                          
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_proj_financ              ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_dat_sdo_ctbl                 ascending
    index tt_seq                          
          tta_num_seq                      ascending.

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seq±¼ncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsist¼ncia" column-label "Inconsist¼ncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".

DEFINE TEMP-TABLE tt-indicadores NO-UNDO
    FIELD indicador AS INTEGER
    FIELD sequencia AS INTEGER
    FIELD conta     AS CHARACTER
    INDEX chave indicador sequencia.
    
DEFINE TEMP-TABLE tt-contab-indicadores
    /*FIELD cod-estabel  AS CHARACTER FORMAT "x(03)"*/
    FIELD indicador    AS INTEGER
    FIELD cod-unid-neg AS CHARACTER
    FIELD valor        AS DECIMAL   FORMAT "->>>,>>>,>>>,>>9.99"
    INDEX chave
          indicador
          cod-unid-neg.
    

DEFINE TEMP-TABLE tt-vpc
    FIELD cod-estabel  AS CHARACTER
    FIELD raiz-cnpj    AS CHARACTER
    FIELD cod-unid-neg AS CHARACTER
    FIELD valor        AS DECIMAL
    INDEX chave cod-estabel raiz-cnpj cod-unid-neg.

DEFINE TEMP-TABLE tt-total-vpc
    FIELD cod-estabel  AS CHARACTER
    FIELD raiz-cnpj    AS CHARACTER
    FIELD cod-unid-neg AS CHARACTER
    FIELD valor        AS DECIMAL
    INDEX chave cod-estabel raiz-cnpj cod-unid-neg.

DEFINE TEMP-TABLE tt-tot-unid
    FIELD cod-estabel    AS CHARACTER
    FIELD cod-unid-negoc AS CHARACTER
    FIELD valor          AS DECIMAL DECIMALS 2 EXTENT 20
    INDEX chave cod-estabel cod-unid-negoc.

