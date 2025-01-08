/*********************************************************************************
** Programa: esp/crm/escrm001d.p
** Vers∆o..: 1.00
** Data....: 19/01/2011
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: API para calcular o Valor do Frete da Nota Fiscal
*********************************************************************************/


/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE h-botr098       AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-vl-frete     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-frete-tot AS DECIMAL     NO-UNDO.



/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER p-rw-nota-fiscal AS ROWID       NO-UNDO.
DEFINE OUTPUT PARAMETER p-vl-frete       AS DECIMAL     NO-UNDO.



/*--- Bloco Principal ---*/
/* IF  NOT VALID-HANDLE(h-botr098) THEN             */
/*     RUN trbo/botr098.p PERSISTENT SET h-botr098. */

FIND FIRST nota-fiscal NO-LOCK
    WHERE  ROWID(nota-fiscal) = p-rw-nota-fiscal NO-ERROR.
IF  AVAIL nota-fiscal THEN DO:

    FIND FIRST estabelec NO-LOCK
        WHERE  estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.
    IF  NOT AVAIL estabelec THEN
        RETURN "NOK":U.
    
    /* TMS FIND FIRST nota-fiscal-tr NO-LOCK
        WHERE  nota-fiscal-tr.cgc-rem     = estabelec.cgc
        AND    nota-fiscal-tr.nr-nf       = INT(nota-fiscal.nr-nota-fis)
        AND    nota-fiscal-tr.cd-serie    = nota-fiscal.serie NO-ERROR.
    IF  AVAIL nota-fiscal-tr THEN DO:
        FOR EACH  pre-con-nf NO-LOCK
            WHERE pre-con-nf.cgc-rem     = nota-fiscal-tr.cgc-rem
            AND   pre-con-nf.nr-nf       = nota-fiscal-tr.nr-nf
            AND   pre-con-nf.cd-serie-nf = nota-fiscal-tr.cd-serie:
            ASSIGN de-vl-frete = 0.
            IF  VALID-HANDLE(h-botr098) THEN DO:
                RUN setConstraintPreCon IN h-botr098 (INPUT  pre-con-nf.cod-estabel,
                                                      INPUT  pre-con-nf.nr-calculo,
                                                      INPUT  pre-con-nf.cd-serie).
                RUN openQueryStatic     IN h-botr098 (INPUT  "PreCon") NO-ERROR.
                RUN getFirst            IN h-botr098.
                RUN getDecField         IN h-botr098 (INPUT  "#Vl-Frete-precon",
                                                      OUTPUT de-vl-frete).
            END.

            ASSIGN de-vl-frete-tot = de-vl-frete-tot + de-vl-frete.
        END.
    END.*/
END.

/* Retorna o Valor Total de Frete C†lculado */
ASSIGN p-vl-frete = de-vl-frete-tot.


/* IF  VALID-HANDLE(h-botr098) THEN DO: */
/*     RUN destroy IN h-botr098.        */
/*     ASSIGN h-botr098 = ?.            */
/* END.                                 */

RETURN "OK".
    
