define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field cod-estabel      as char
    field ind-itens-com-saldo as int
    field cod-depos        as char
    field fm-codigo-ini    as char
    field fm-codigo-fim    as char
    field it-codigo-ini    as char
    field it-codigo-fim    as char.
    
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.
