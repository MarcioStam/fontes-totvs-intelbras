DEFINE INPUT PARAMETER c-ambiente AS CHARACTER NO-UNDO.

FOR EACH fnd_empres EXCLUSIVE-LOCK:

    IF  NOT fnd_empres.des_razao_social MATCHES "*HOMOLOGACAO*"
    AND NOT fnd_empres.des_razao_social MATCHES "*DESENVOLVIMENTO*" THEN
        ASSIGN fnd_empres.des_razao_social = '.. ' + c-ambiente + ' .. Atualizado: ' + STRING(TODAY) + ' ' + fnd_empres.des_razao_social.

END.

RETURN 'ok'.
