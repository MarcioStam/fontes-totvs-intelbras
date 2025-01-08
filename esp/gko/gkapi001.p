/*------------------------------------------------------------------------
    File        : GKAPI001.P
    Purpose     : Gerar hist¢rico de integra‡Æo GKO X EMS.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Maio de 2012
    Notes       : <none>
------------------------------------------------------------------------*/
{include/i-prgvrs.i GKAPI001 2.00.00.000}

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

{esp/gko/gkapi001.i} /* Defini‡Æo temp-table "tt-log-gko" */

/* Buffer Definitions ---                                               */

DEFINE BUFFER bf-gko-importacao-1     FOR gko-importacao.
DEFINE BUFFER bf-gko-importacao-2     FOR gko-importacao.
DEFINE BUFFER bf-gko-log-importacao-1 FOR gko-log-importacao.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER TABLE FOR tt-log-gko.


/* ***************************  Main Block  *************************** */

FIND LAST param-global NO-LOCK NO-ERROR.

FOR EACH tt-log-gko
    BREAK BY tt-log-gko.nom-arquivo-integracao:

    IF FIRST-OF(tt-log-gko.nom-arquivo-integracao) THEN DO:
        FIND LAST bf-gko-importacao-1 NO-LOCK NO-ERROR.

        FIND LAST bf-gko-importacao-2
            WHERE bf-gko-importacao-2.nom-arquivo-integracao = tt-log-gko.nom-arquivo-integracao NO-LOCK NO-ERROR.

        CREATE gko-importacao.
        ASSIGN gko-importacao.seq-importacao         = IF AVAILABLE bf-gko-importacao-1 THEN bf-gko-importacao-1.seq-importacao + 1 ELSE 1
               gko-importacao.nom-arquivo-integracao = tt-log-gko.nom-arquivo-integracao
               gko-importacao.seq-imp-arquivo        = IF AVAILABLE bf-gko-importacao-2 THEN bf-gko-importacao-2.seq-imp-arquivo + 1 ELSE 1
               gko-importacao.dat-integracao         = TODAY
               gko-importacao.hor-integracao         = TIME
               gko-importacao.log-imp-erro           = tt-log-gko.log-imp-erro
               gko-importacao.ind-tipo-integracao    = tt-log-gko.ind-tipo-integracao.
    END.

    IF tt-log-gko.log-imp-erro THEN DO:
        FIND LAST gko-importacao
            WHERE gko-importacao.nom-arquivo-integracao = tt-log-gko.nom-arquivo-integracao NO-LOCK NO-ERROR.

        IF AVAILABLE gko-importacao THEN
            FIND LAST bf-gko-log-importacao-1
                WHERE bf-gko-log-importacao-1.seq-importacao = gko-importacao.seq-importacao NO-LOCK NO-ERROR.

        CREATE gko-log-importacao.
        ASSIGN gko-log-importacao.seq-importacao = IF AVAILABLE gko-importacao THEN gko-importacao.seq-importacao ELSE 0
               gko-log-importacao.seq-log-erro   = IF AVAILABLE bf-gko-log-importacao-1 THEN bf-gko-log-importacao-1.seq-log-erro + 1 ELSE 1
               gko-log-importacao.des-erro-imp   = tt-log-gko.des-erro-imp.

        IF AVAILABLE bf-gko-log-importacao-1 THEN
            RELEASE bf-gko-log-importacao-1.
    END.
END.

RETURN "OK":U.

