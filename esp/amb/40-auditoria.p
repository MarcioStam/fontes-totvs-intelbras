DEFINE INPUT PARAMETER c-ambiente AS CHARACTER NO-UNDO.

define buffer busuar_grp_usuar for usuar_grp_usuar.

for each usuar_grp_usuar no-lock
   where usuar_grp_usuar.cod_grp_usuar = 'Z01' /** Auditoria Interna **/
     and not can-find (first busuar_grp_usuar
                       where busuar_grp_usuar.cod_grp_usuar = 'ADM'
                         and busuar_grp_usuar.cod_usuario   = usuar_grp_usuar.cod_usuario):
   create busuar_grp_usuar.
   assign busuar_grp_usuar.cod_grp_usuar = 'ADM'.
   buffer-copy usuar_grp_usuar except cod_grp_usuar to busuar_grp_usuar.
end.

return 'ok'.
