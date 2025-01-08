/*{utp/ut-glob.i}*/
{utp/utapi019.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

define temp-table tt-ft2100
    field destino           as integer  
    field arquivo           as char
    field usuario           as char
    field data-exec         as date
    field hora-exec         as integer
    field tipo-atual        as integer   /* 1 - Atualiza, 2 - Desatualiza */
    field c-desc-tipo-atual as char format "x(15)"
    field da-emissao-ini    as date format "99/99/9999"
    field da-emissao-fim    as date format "99/99/9999"
    field da-saida          as date format "99/99/9999"
    field da-vencto-ipi     as date format "99/99/9999"
    field da-vencto-icms    as date format "99/99/9999"
    field da-vencto-iss     as date format "99/99/9999"
    field c-estabel-ini     as char
    field c-estabel-fim     as char
    field c-serie-ini       as char
    field c-serie-fim       as char
    field c-nr-nota-ini     as char
    field c-nr-nota-fim     as char
    &IF "{&BF_DIS_VERSAO_EMS}" >= "2.07" &then
    field de-embarque-ini   as dec  format ">>>>>>>>>>>>>>>9"
    field de-embarque-fim   as dec  format ">>>>>>>>>>>>>>>9"
    &ELSE
    field i-embarque-ini   as int  format "->,>>>,>>9"
    field i-embarque-fim   as int  format "->,>>>,>>9"
    &ENDIF
    field c-preparador      as char
    field l-disp-men        as log
    field l-b2b             as log
    FIELD log-1             AS LOG.
 
define temp-table tt-ft0604
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
    field da-periodo-ini   as date
    field da-periodo-fim   as date
    field c-estabel-ini    as character
    field c-estabel-fim    as character
    field rs-tipo-nota     as integer
    field rs-data-atualiz  as INTEGER
    FIELD tg-serie-padrao  AS LOGICAL.

define temp-table tt-ft0603
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field da-emis-ini      as date
    field da-emis-fim      as date
    field c-estabel-ini    as char
    field c-serie-ini      as char
    field c-serie-fim      as char
    field c-nota-fis-ini   as char
    field c-nota-fis-fim   as char
    &IF "{&BF_DIS_VERSAO_EMS}" >= "2.07" &then
    field de-embarque-ini  like nota-fiscal.cdd-embarq
    field de-embarque-fim  like nota-fiscal.cdd-embarq
    &ELSE
    field i-embarque-ini  like nota-fiscal.nr-embarque
    field i-embarque-fim  like nota-fiscal.nr-embarque
    &ENDIF
    field i-cod-portador   as integer
    field rs-gera-titulo   as integer
    field desc-titulo      as char format "x(35)"
    field i-pais           as int
    field c-estabel-fim    as char
    field c-arquivo-exp    as char.

define temp-table tt-ft2200 no-undo
    field destino           as integer
    field arquivo           as char format "x(35)"
    field usuario           as char format "x(12)"
    field data-exec         as date
    field hora-exec         as integer
    field cod-estabel       like nota-fiscal.cod-estabel
    field serie             like nota-fiscal.serie
    field nr-nota-fis       like nota-fiscal.nr-nota-fis
    field dt-cancela        like nota-fiscal.dt-cancela
    field desc-cancela      like nota-fiscal.desc-cancela
    field arquivo-estoq     as char
&IF '{&BF_DIS_VERSAO_EMS}' >= '2.03' &THEN
    field reabre-resumo     as logical
&ENDIF
&IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
    field cancela-titulos   as logical
&ENDIF
    field imprime-ajuda     as logical
    field l-valida-dt-saida as logical.
