define temp-table tt-param no-undo
   field destino              as integer
   field arquivo              as char format "x(35)":U
   field usuario              as char format "x(12)":U
   field data-exec            as date
   field hora-exec            as integer
   field exec-item            as logical
   field it-codigo-ini        as character
   field it-codigo-fim        as character
   field exec-categoria       as logical
   field categoria-ini        as character
   field categoria-fim        as character
   field exec-categoria-item  as logical
   field categoria-item-ini   as character
   field categoria-item-fim   as character.

define temp-table tt-digita no-undo
   field ordem            as integer   format ">>>>9":U
   field exemplo          as character format "x(30)":U
   index id ordem.

define temp-table tt-raw-digita
   field raw-digita as raw.

define temp-table MsgErro no-undo
   field SeqErro  as integer     format '>>9'
   field DescErro as character   format 'x(120)'
   index idErro   is primary unique SeqErro.
