define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field ep-codigo        like mgcad.empresa.ep-codigo
    field pag-ini          LIKE pagamento.nr-pagamento
    field pag-fim          LIKE pagamento.nr-pagamento
    field linha            as char format "x(20)":U
    field ncm              as char format "x(60)":U
    field comissao         as char format "x(20)":U
    field RefBancaria      as char format "x(30)":U.


define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.


DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

