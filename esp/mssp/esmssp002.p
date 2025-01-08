/**
 * Zoom de cidades para SharePoint
 **/

create widget-pool.

{include/i-freeac.i}

define temp-table ttCidade no-undo
   field pais     like mgcad.cidade.pais
   field uf       like mgcad.cidade.estado
   field estado   like unid-feder.no-estado
   field cidade   like mgcad.cidade.cidade
   index idx_pri is primary unique pais uf cidade.

define output parameter table for ttCidade.

define variable c-uf       as character no-undo.
define variable c-pais     as character no-undo.
define variable c-estado   as character no-undo.
define variable c-cidade   as character no-undo.

for each mgcad.cidade no-lock
   where mgcad.cidade.pais = 'Brasil',
   first unid-feder of mgcad.cidade no-lock:

   assign c-pais   = fn-free-accent(upper(trim(mgcad.cidade.pais)))
          c-estado = fn-free-accent(upper(trim(unid-feder.no-estado)))
          c-cidade = fn-free-accent(upper(trim(mgcad.cidade.cidade)))
          c-uf     = upper(trim(mgcad.cidade.estado)).

   create ttCidade.
   assign ttCidade.pais   = c-pais
          ttCidade.uf     = c-uf
          ttCidade.estado = c-estado
          ttCidade.cidade = c-cidade.
end.
