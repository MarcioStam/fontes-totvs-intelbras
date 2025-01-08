/*****  Definição TT-param usado no cc0311 ******/

define temp-table tt-param
    field destino        as integer
    field arquivo        as char format "x(30)"
    field usuario        as char
    field data-exec      as date
    field hora-exec      as integer
    field i-nr-ordem     as integer
    field da-data-ped    as date format "99/99/9999"
    field c-est-cob      as char
    field c-resp         as char
    field i-cod-mens     as integer
    field i-frete        as integer
 &if "{&bf_mat_versao_ems}" >= "2.05" &then
    field l-importacao   as logical
 &endif
    field i-condicao     as integer
    field i-forn-ini     as integer 
    field i-forn-fim     as integer format "999999999"
    field c-estabel-ini  as char
    field c-estabel-fim  as char
    field i-ord-ini      like cotacao-item.numero-ordem
    field i-ord-fim      like cotacao-item.numero-ordem
    field da-cot-ini     like cotacao-item.data-cotacao
    field da-cot-fim     like cotacao-item.data-cotacao
    field c-it-ini       like cotacao-item.it-codigo
    field c-it-fim       like cotacao-item.it-codigo
    field c-comp-ini     as char
    field c-comp-fim     as char
    field i-processo-ini as integer
    field i-processo-fim as integer
    field c-estab        as char format "x(20)"
    field c-deresp       as char format "x(20)"
    field c-msg          as char
    field c-pagto        as char
    field c-frete        as char 
 &if "{&bf_mat_versao_ems}" >= "2.05" &then
    field c-importacao   as char
 &endif
    field c-destino      as char
    field c-estab-gestor      like estabelec.cod-estabel
    field c-nome-estabelec-2  like estabelec.nome
 &if defined (bf_mat_oper_triangular) &then 
    field i-cod-emit-terc like item-doc-est.cod-emit-terc
    field c-nome-abrev    like emitente.nome-abrev
 &endif   
    field data-pagto      like cond-especif.data-pagto
    field perc-pagto      like cond-especif.perc-pagto
    field comentarios     like cond-especif.comentarios.

/*********************************************************/
