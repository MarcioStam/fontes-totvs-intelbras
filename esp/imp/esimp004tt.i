/* Parameters Definitions ---                                           */

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field l-fatur          as logical 
    field l-veiculo        as logical
    field de-cotacao       as dec
    field l-det            as logical
    FIELD cod-estabel      AS CHAR FORMAT "x(3)".
    
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field e-mail           as character format "x(60)":U
    index id ordem.

