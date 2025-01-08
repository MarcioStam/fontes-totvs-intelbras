define temp-table tt-param no-undo
   field destino        as integer
   field arquivo        as char format "x(35)":U
   field usuario        as char format "x(12)":U
   field data-exec      as date
   field hora-exec      as integer
   field login-ini      as integer
   field login-fim      as integer.

define temp-table tt-raw-digita
   field raw-digita as raw.

define temp-table tt-ad no-undo
   field sAMAccountName    as character format 'x(12)'
   field displayName       as character format 'x(40)'
   field manager           as character format 'x(12)'
   field employeeId        as integer
   field employeeNumber    as character format 'x(11)'
   field departmentNumber  as character format 'x(8)'
   field accountDisabled   as logical
   field office            as character format 'x(10)'
   field mail              as character format 'x(40)'
   field telephoneNumber   as character format 'x(20)'
   field cod-estabel       as character format 'x(3)'
   field cod_unid_negoc    as character format 'x(3)'
   field cod_ccusto        as character format 'x(11)'
   index ch-pri is primary unique sAMAccountname.
