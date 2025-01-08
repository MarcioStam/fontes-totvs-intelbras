define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(55)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field imprime-par      as logi 
    field tipo-ini         as int format ">>9"
    field tipo-fim         as int format ">>9"
    field loc-ini          as char format "x(10)"
    field loc-fim          as char format "x(10)"
    field it-ini           as char format "x(16)"
    field it-fim           as char format "x(16)"
    field obs-ini          as int
    field obs-fim          as int
    field depos            as char format "x(3)"
    field detalhado        as logi format "Detalhado/Resumido"
    field saldo            as logi format "Ocupada/Dispon¡vel"
    field qtde             as logi format "Com Qtde/Sem Qtde"
    field dt-inv           as date format "99/99/9999"
    field cod-estabel      as char.
    
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita for tt-digita.

