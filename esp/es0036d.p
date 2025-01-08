DEFINE VARIABLE cmd AS CHARACTER NO-UNDO.

/*
int-desconecta-usuar.ambiente: producao
                               homologacao
                               desenvolvimento
*/

FOR EACH int-desconecta-usuar EXCLUSIVE-LOCK:
    ASSIGN cmd = "proshut /db" + int-desconecta-usuar.ambiente + "/" + int-desconecta-usuar.banco + " -C disconnect " + STRING(int-desconecta-usuar.id-usuario).
    UNIX SILENT VALUE(cmd).
    DELETE int-desconecta-usuar.
END.

QUIT.

    
