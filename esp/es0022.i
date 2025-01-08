define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    FIELD ano              AS INT FORMAT "9999"
    FIELD mes              AS INT FORMAT "99".

define temp-table tt-digita no-undo
    field mes              as integer   format "99":U
    field ano              as INTEGER format "9999":U
    index id mes.

def temp-table tt-raw-digita
   field raw-digita      as raw.
