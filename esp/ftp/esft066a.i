{utp/ut-glob.i}
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
    field i-embarque-ini    as integer
    field i-embarque-fim    as integer
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
    field i-embarque-ini   like nota-fiscal.nr-embarque
    field i-embarque-fim   like nota-fiscal.nr-embarque
    field i-cod-portador   as integer
    field rs-gera-titulo   as integer
    field desc-titulo      as char format "x(35)"
    field i-pais           as int
    field c-estabel-fim    as char
    field c-arquivo-exp    as char.
