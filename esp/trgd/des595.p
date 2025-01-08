/********************************************************************************
 ** UPC........: des543.p - UPC Delete Crm-relacionamento Cliente
 ** Data.......: Setembro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes Relacionamento Cliente p/ o CRM
 ********************************************************************************/
TRIGGER PROCEDURE FOR DELETE OF reservas-ast.

{utp/ut-glob.i}

DEFINE BUFFER bf-hist-reservas-ast FOR hist-reservas-ast.

FUNCTION fnRetornaSeq RETURNS INTEGER
    (INPUT c-item  AS CHARACTER,
     INPUT c-estab AS CHARACTER,
     INPUT c-depos AS CHARACTER,
     INPUT c-usuar AS CHARACTER):

    FOR LAST  bf-hist-reservas-ast
        WHERE bf-hist-reservas-ast.it-codigo   = c-item
        AND   bf-hist-reservas-ast.cod-estabel = c-estab
        AND   bf-hist-reservas-ast.cod-depos   = c-depos
        AND   bf-hist-reservas-ast.cd-usuario  = c-usuar
        USE-INDEX ch-hist-reservas-ast NO-LOCK:

        RETURN bf-hist-reservas-ast.sequencia + 1.
    END.

    RETURN 1.
END FUNCTION.

IF AVAIL reservas-ast THEN DO:
    CREATE hist-reservas-ast.
    ASSIGN hist-reservas-ast.it-codigo           = reservas-ast.it-codigo
           hist-reservas-ast.cod-estabel         = reservas-ast.cod-estabel
           hist-reservas-ast.cod-depos           = reservas-ast.cod-depos
           hist-reservas-ast.cd-usuario          = reservas-ast.cd-usuario
           hist-reservas-ast.sequencia           = fnRetornaSeq(INPUT reservas-ast.it-codigo,
                                                                INPUT reservas-ast.cod-estabel,
                                                                INPUT reservas-ast.cod-depos,
                                                                INPUT reservas-ast.cd-usuario)
           hist-reservas-ast.data-atualiza       = NOW
           hist-reservas-ast.cd-usuario-atualiza = c-seg-usuario
           hist-reservas-ast.dt-reserva          = reservas-ast.dt-reserva
           hist-reservas-ast.tipo-acao           = "DEL".
END.
