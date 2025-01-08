define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as INTEGER
    field c-loc-ini       like item.cod-localiz
    field c-loc-fim       like item.cod-localiz
    field i-ge-ini        like item.ge-codigo  
    field i-ge-fim        like item.ge-codigo  
    field c-fm-ini        like item.fm-codigo  
    field c-fm-fim        like item.fm-codigo  
    field c-it-ini        like item.it-codigo  
    field c-it-fim        like item.it-codigo  
    field c-comprador-ini like item.cod-comprado 
    field c-comprador-fim like item.cod-comprado 
    field l-ativo         AS LOGICAL
    field l-obsoleto-auto AS LOGICAL
    field l-obsoleto      AS LOGICAL
    field l-total         AS LOGICAL
    field i-mat           as INTEGER
    FIELD d-total-dep     AS DEC FORMAT "->>>,>>>,>>9.99".

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE NEW GLOBAL SHARED TEMP-TABLE tt-itens NO-UNDO
    field it-codigo  as char format "x(7)"
    field descricao  as char format "x(36)"
    field unit-mat   as dec  format "->>,>>>,>>9.99"
    field unit-mob   as dec  format "->>,>>>,>>9.99"
    field unit-ggf   as dec  format "->>,>>>,>>9.99"
    field quantidade as dec  format "->,>>>,>>9.99"
    FIELD disponivel AS DEC  FORMAT "->,>>>,>>9.99"
    field valor      as dec  format "->>,>>>,>>9.99"
    FIELD cod-depos  LIKE deposito.cod-depos
    FIELD nome       LIKE deposito.nome
    index codigo is primary it-codigo.


DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

