define temp-table tt-param no-undo
   field destino        as integer
   field arquivo        as char format "x(35)":U
   field usuario        as char format "x(12)":U
   field data-exec      as date
   field hora-exec      as integer
   field exec-rpa       as logical
   field param-rpa      as raw
   field exec-rpb       as logical
   field param-rpb      as raw
   field exec-rpc       as logical
   field param-rpc      as raw
   field exec-rpd       as logical
   field param-rpd      as raw.

define temp-table tt-param-rpa no-undo
   field Unico as logical
   field CPF   as character
   field CNPJ  as character.

define temp-table tt-param-rpb no-undo
   field AguardandoPagamento  as logical
   field PagamentoConfirmado  as logical
   FIELD PedidoCancelado      AS LOGICAL
   field Unico                as logical
   field CodigoPedido         as integer.

define temp-table tt-param-rpc no-undo
   field Unico          as logical
   field CodigoPedido   as integer.

define temp-table tt-param-rpd no-undo
   field it-codigo-ini    like item.it-codigo
   field it-codigo-fim    like item.it-codigo.

define temp-table tt-digita no-undo
   field ordem            as integer   format ">>>>9":U
   field exemplo          as character format "x(30)":U
   index id ordem.

define temp-table tt-raw-digita
   field raw-digita as raw.
