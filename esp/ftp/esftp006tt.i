define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    FIELD c-periodo        AS CHAR FORMAT '99/9999' /*LIKE cota-esc.periodo*/
    FIELD dt-ini-ent       LIKE ped-item.dt-entrega
    FIELD dt-fim-ent       LIKE ped-item.dt-entrega
    FIELD dt-ini-nff       LIKE docum-est.dt-trans
    FIELD dt-fim-nff       LIKE docum-est.dt-trans
    FIELD i-cod-rep-ini    LIKE repres.cod-rep     
    FIELD i-cod-rep-fim    LIKE repres.cod-rep     
    FIELD c-sup-ini        LIKE regiao.nome-ab-reg 
    FIELD c-sup-fim        LIKE regiao.nome-ab-reg
    FIELD cotas            AS LOGICAL
    FIELD carteira         AS LOGICAL
    FIELD devolucoes       AS LOGICAL
    FIELD realizado        AS LOGICAL
    FIELD detalhes         AS LOGICAL
    field cod-estabel      as char.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
