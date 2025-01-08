define input parameter pUser as character no-undo.
define variable cmd as character no-undo.

find dictdb._connect no-lock
   where dictdb._connect._connect-name = pUser no-error.

if available (dictdb._connect) then do:
   assign cmd = '/opt/progress/dlc/bin/proshut ' + pdbname('dictdb') + ' -C disconnect ' + string(dictdb._connect._connect-usr).

   unix silent value(cmd).
end.
