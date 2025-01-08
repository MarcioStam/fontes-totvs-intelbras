define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer

    FIELD cod-estab-ini    AS CHARACTER
    FIELD cod-estab-fim    AS CHARACTER
    FIELD cod-emitente-ini AS INTEGER
    FIELD cod-emitente-fim AS INTEGER
    FIELD unid-negoc-ini   AS CHARACTER
    FIELD unid-negoc-fim   AS CHARACTER
    FIELD dt-trans-ini     AS DATE FORMAT "99/99/9999"
    FIELD dt-trans-fim     AS DATE FORMAT "99/99/9999"
    FIELD dt-evento-ini    AS DATE FORMAT "99/99/9999"
    FIELD dt-evento-fim    AS DATE FORMAT "99/99/9999"
    FIELD dt-vencto-ini    AS DATE FORMAT "99/99/9999"
    FIELD dt-vencto-fim    AS DATE FORMAT "99/99/9999"
    FIELD tipo-acordo-ini  AS INTEGER
    FIELD tipo-acordo-fim  AS INTEGER
    FIELD tipo-verba-ini   AS INTEGER
    FIELD tipo-verba-fim   AS INTEGER
    FIELD situacao         AS INTEGER.

define temp-table tt-digita no-undo
    field campo AS CHARACTER
    index id campo.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.


/* Temp-Table com as informa‡äes dos t¡tulos com saldo em aberto - esutp024rpa.p */
DEFINE TEMP-TABLE tt_tit_acr NO-UNDO
    FIELD cod_estab          AS CHARACTER  FORMAT "x(3)"
    FIELD cod_espec          AS CHARACTER  FORMAT "x(3)"
    FIELD cod_ser_docto      AS CHARACTER  FORMAT "x(3)"
    FIELD cod_tit_acr        AS CHARACTER  FORMAT "x(10)"
    FIELD cod_parcela        AS CHARACTER  FORMAT "x(02)"
    FIELD cod_unid_negoc     AS CHARACTER  FORMAT "x(3)"
    FIELD val_origin_tit_acr AS DECIMAL    FORMAT ">>>,>>>,>>9.99"   DECIMALS 2
    FIELD val_sdo_tit_acr    AS DECIMAL    FORMAT ">>>,>>>,>>9.99"   DECIMALS 2
    FIELD val_perc_rat       AS DECIMAL    FORMAT "->>9.9999999999"  DECIMALS 10
    FIELD nom_cliente        AS CHARACTER  FORMAT "x(40)"
    FIELD nom_matriz         AS CHARACTER  FORMAT "x(12)"
    INDEX idx_tit_acr        AS PRIMARY UNIQUE
          cod_estab
          cod_espec
          cod_ser_docto
          cod_tit_acr
          cod_parcela
          cod_unid_negoc.
