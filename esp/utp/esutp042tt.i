define temp-table tt-param no-undo
   field destino          as integer
   field arquivo          as char format "x(35)":U
   field usuario          as char format "x(12)":U
   field data-exec        as date
   field hora-exec        as integer
   field cpf-cnpj-ini     as character
   field cpf-cnpj-fim     as character
   field tg-ra            as logical
   field tg-rmc           as logical
   field tg-telecom       as logical
   field tg-seguranca     as logical
   field tg-informatica   as logical
   FIELD tg-nenhum        AS LOGICAL
   field tg-csv           as logical
   FIELD tg-ativo         AS INTEGER.

define temp-table tt-digita no-undo
   field ordem            as integer   format ">>>>9":U
   field exemplo          as character format "x(30)":U
   index id ordem.

define temp-table tt-raw-digita
   field raw-digita as raw.
