/**************************************************************************
**  Programa.: WES595.p
**  Autor....: Carlos Daniel
**  Data.....: Julho de 2016
**  Objetivo.: UPC de Write para a tabela reservas-ast
***************************************************************************/
TRIGGER PROCEDURE FOR WRITE OF reservas-ast OLD BUFFER b-old-reservas-ast.
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

IF AVAIL reservas-ast AND AVAIL b-old-reservas-ast THEN DO:

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
           hist-reservas-ast.qt-reserva-para     = reservas-ast.qt-reserva
           hist-reservas-ast.data-limite-para    = reservas-ast.data-limite
           hist-reservas-ast.dt-reserva          = reservas-ast.dt-reserva
           .

    IF NEW reservas-ast THEN
        ASSIGN hist-reservas-ast.tipo-acao           = "ADD".
    ELSE
        ASSIGN hist-reservas-ast.qt-reserva-de       = b-old-reservas-ast.qt-reserva
               hist-reservas-ast.data-limite-de      = b-old-reservas-ast.data-limite
               hist-reservas-ast.tipo-acao           = "UPD".
END.
