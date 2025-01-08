define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    FIELD c-emp            LIKE emscad.empresa.cod_empresa
    FIELD c-cod-cenar-ctbl LIKE sdo_orcto_ctbl_bgc.cod_cenar_ctbl
    FIELD c-cod-plano-cc   LIKE sdo_orcto_ctbl_bgc.cod_plano_ccus
    FIELD c-cod-plano-cta  LIKE sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl
    FIELD c-est-ini        LIKE estabelecimento.cod_estab INIT ""
    FIELD c-est-fim        LIKE estabelecimento.cod_estab INIT "ZZZ"
    FIELD c-periodo        AS CHAR
    FIELD da-data-ini      AS DATE
    FIELD da-data-fim      AS DATE
    field l-habilitaRtf    as LOG.

define temp-table tt-digita no-undo
    field mes              as integer   format "99":U
    field ano              as INTEGER format "9999":U
    index id mes.

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEF TEMP-TABLE tt-movto LIKE movto-estoq
    FIELD r-movto AS ROWID
    INDEX ch-cta-ctbl
          cod-estabel
          dt-trans
          ct-codigo
          sc-codigo.


/*--- Defini‡Æo das Tabelas Tempor rias ---*/
DEF TEMP-TABLE tt-dados
    FIELD cod_empresa           LIKE emscad.empresa.cod_empresa
    FIELD cod_estabel           LIKE estabelecimento.cod_estab
    FIELD cod_plano_cta_ctbl    LIKE cta_ctbl.cod_plano_cta_ctbl
    FIELD cod_plano_cc          LIKE emscad.ccusto.cod_plano_cc
    FIELD cod_cta_ctbl          LIKE cta_ctbl.cod_cta_ctbl
    FIELD cod_ccusto            LIKE emscad.ccusto.cod_ccusto
    FIELD cod_projeto           LIKE proj_financ.cod_proj_financ
    FIELD cod_unid_negoc        LIKE unid_negoc.cod_unid_negoc
    FIELD cod_cenar_ctbl        LIKE item_lancto_ctbl.cod_cenar_ctbl
    FIELD des_historico         LIKE movto_real_orcto.des_historicao
    FIELD des_histor_movto      LIKE movto_real_orcto.des_histor_movto
    FIELD origem                AS CHAR FORMAT "x(3)"   /**** APB, ACR, FGL ou CEP ***/
    FIELD ind_natur_lancto_ctbl AS CHAR FORMAT "X(3)"   /**** DB ou CR             ***/
    FIELD cod_emitente          AS INT  FORMAT ">>>,>>>,>>9"
    FIELD nome_emitente         AS CHAR FORMAT "X(40)"
    FIELD dt_transacao          AS DATE FORMAT "99/99/9999"
    FIELD cod_espec_docto       AS CHAR FORMAT "x(3)"
    FIELD cod_ser_docto         AS CHAR FORMAT "x(3)"
    FIELD cod_tit_ap            AS CHAR FORMAT "x(10)"
    FIELD cod_parcela           AS CHAR FORMAT "x(2)"
    FIELD val_aprop_ctbl        AS DEC  FORMAT ">>>,>>>,>>9.99".

DEF TEMP-TABLE tt-conta
    FIELD cod_cta_ctbl LIKE cta_ctbl.cod_cta_ctbl
    FIELD ind_espec_cta_ctbl LIKE cta_ctbl.ind_espec_cta_ctbl
    FIELD orcado AS DEC FORMAT "->>>,>>>,>>9.99"
    FIELD realizado AS DEC FORMAT "->>>,>>>,>>9.99"
    INDEX codigo IS PRIMARY cod_cta_ctbl
    INDEX esp ind_espec_cta_ctbl
    INDEX tp-codigo ind_espec_cta_ctbl cod_cta_ctbl.

DEF TEMP-TABLE tt-cc
    FIELD cod-estab AS CHAR FORMAT "X(3)"
    FIELD cc-codigo AS CHAR FORMAT "x(5)"    
    INDEX codigo IS PRIMARY UNIQUE cod-estab cc-codigo.
