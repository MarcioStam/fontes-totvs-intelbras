define temp-table tt-param
    field destino            as integer
    field arquivo            as char format "x(50)":U
    field usuario            as char format "x(12)":U
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field desc-classifica    as char format "x(40)":U
    field imprime-par        as logi 
    field item-ini           as char format "x(16)"
    field item-fim           as char format "x(16)"
    field fabric-ini         as int format ">>>,>>9" 
    field fabric-fim         as int format ">>>,>>9"
    field obs-ini            as int
    field obs-fim            as int.
    
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita for tt-digita.

