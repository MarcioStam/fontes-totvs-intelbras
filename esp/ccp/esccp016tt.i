define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field cod-estabel      as char
    field cd-plano         as int
    field ano              as int
    field ge-codigo        as int
    field ind-saldos       as int
    field ind-relatorio    as int
    field l-dependente     as log
    field l-independente   as log
    field l-des-sal-ent-zr as log
    field l-dep-saldo-disp as log
    field cod-comprado-ini as char
    field cod-comprado-fim as char
    field it-codigo-ini    as char
    field it-codigo-fim    as char
    field data-ini         as date
    field data-fim         as date
    field data-politica-ini as date
    field data-politica-fim as date
    field periodo-ini       as int
    field periodo-fim       as int
    field cod-obsoleto-ini  as int
    field cod-obsoleto-fim  as int.
    
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.
