define input parameter pUser as character no-undo.
define input parameter pAmbiente as character no-undo.
define variable cmd as character no-undo.

FOR EACH dictdb._connect no-lock
   where dictdb._connect._connect-name = trim(pUser)
     AND dictdb._connect._connect-device <> "soo-progress":

    CREATE int-desconecta-usuar.
    ASSIGN int-desconecta-usuar.cod-usuario = dictdb._connect._connect-name
           int-desconecta-usuar.banco       = pdbname('dictdb')
           int-desconecta-usuar.ambiente    = pAmbiente
           int-desconecta-usuar.id-usuario  = dictdb._connect._connect-usr.

end.
