/***********************************************************************
**  Programa..: ESP/REP/ESREP020RP.P
**  Autor.....: Anderson Cenci
**  Data......: FEVEREIRO/2008 - Desenvolvimento
**  Descricao.: Notas de Entrada - Despesas Acessorias
**  Vers∆o....: 000 - 27/02/2008 - Desenvolvimento Programa
**              001 - 14/05/2012 - Inclus∆o do detalhe de outras
**              despesas - Fabiano Sakae Ribeiro (Exponencial TI/SQL Works)
************************************************************************/
{include/i-prgvrs.i ESREP020 2.04.00.001}

/****************************  Definitions  ****************************/

/* Include Definitions ---                                              */

{utp/ut-glob.i}
/* {include/i-rpvar.i} */
{esp/rep/esrep020tt.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp      AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-outr-desp AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-pis       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-cofins    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE lFirst       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE val-desp     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-caminho-arquivo AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-emitente LIKE emitente.nome-abrev NO-UNDO.

/* Form Definitions ---                                                 */
/*
FORM "Documento        Ser   Nat Oper    Emit Emiss∆o              Outras       Valor ICMS       Valor Despesa        PIS     COFINS Outras Des":U
     "           Forn Desp Nome Abreviado Desp Descriá∆o                         Valor Despesa                                                 ":U COLON 1
     "-----------------------------------------------------------------------------------------------------------------------------------------":U COLON 1
    WITH STREAM-IO WIDTH 137 NO-LABELS NO-BOX PAGE-TOP FRAME f-cab-detal.
*/
/* FORM docum-est.nro-docto                                             */
/*      docum-est.serie-docto                                           */
/*      docum-est.nat-operacao                                          */
/*      docum-est.cod-emitente                                          */
/*      docum-est.dt-emissao                                            */
/*      docum-est.valor-outras                                          */
/*      docum-est.icm-deb-cre                                           */
/*      docum-est-cex.val-desp                                          */
/*      de-pis                 COLUMN-LABEL "PIS":U                     */
/*      de-cofins              COLUMN-LABEL "COFINS":U                  */
/*      de-outr-desp           COLUMN-LABEL "Outras Desp":U             */
/*     WITH STREAM-IO NO-BOX DOWN FRAME f-reg-resum WIDTH 140.          */
/*                                                                      */
/* FORM docum-est.nro-docto                                             */
/*      docum-est.serie-docto                                           */
/*      docum-est.nat-operacao                                          */
/*      docum-est.cod-emitente                                          */
/*      docum-est.dt-emissao                                            */
/*      docum-est.valor-outras                                          */
/*      docum-est.icm-deb-cre                                           */
/*      docum-est-cex.val-desp                                          */
/*      de-pis                 COLUMN-LABEL "PIS":U                     */
/*      de-cofins              COLUMN-LABEL "COFINS":U                  */
/*      de-outr-desp           COLUMN-LABEL "Outras Desp":U             */
/*     WITH STREAM-IO NO-BOX NO-LABEL DOWN FRAME f-reg-detal WIDTH 137. */
/*                                                                      */
/* FORM docum-est-cex.cod-emitente-desp COLON 10                        */
/*      c-emitente                                                      */
/*      docum-est-cex.cod-desp                                          */
/*      desp-imp.descricao                                              */
/*      docum-est-cex.val-desp FORMAT ">>>>>,>>>,>>9.99":U              */
/*     WITH STREAM-IO NO-BOX NO-LABEL DOWN FRAME f-detalhe WIDTH 137.   */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.


/* ************************  Function Prototypes ********************** */

FUNCTION fn-emitente RETURNS CHARACTER
  ( p-cod-emitente AS INTEGER )  FORWARD.


/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.
FIND FIRST tt-param NO-ERROR.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST mgcad.empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

/*ASSIGN c-sistema      = "Espec°ficos Intelbras":U
       c-titulo-relat = "Notas de Entrada - Despesas Acessorias":U
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U.*/

DO ON STOP UNDO, LEAVE:
/*     {include/i-rpcab.i} */
/*     {include/i-rpout.i} */

/*     VIEW FRAME f-cabec.  */
/*     VIEW FRAME f-rodape. */

    /*ASSIGN c-caminho-arquivo = SESSION:TEMP-DIRECTORY + c-seg-usuario.*/
    ASSIGN c-caminho-arquivo = c-dir-arquivo-session + c-seg-usuario.

    OS-CREATE-DIR VALUE(c-caminho-arquivo).

    ASSIGN c-caminho-arquivo = c-caminho-arquivo + "/" + "esrep020.csv".
    ASSIGN c-caminho-arquivo = REPLACE(c-caminho-arquivo, "~\":U, "/":U).

    /* Elimina arquivo jˇ existente */
    OS-DELETE VALUE(c-caminho-arquivo) NO-ERROR.

    /* Inicia Exportaªío */
    OUTPUT TO VALUE(c-caminho-arquivo) CONVERT TARGET "iso8859-1":U.

    IF tt-param.ind-tip-relat = 1 THEN
        PUT UNFORMATTED "Estab.;Documento;Ser;Nat Oper;Emit;Emiss∆o;Outras;Valor ICMS;Valor Despesa;PIS;COFINS;Outras Des" SKIP.
    ELSE
        PUT UNFORMATTED "Estab.;Documento;Ser;Nat Oper;Emit;Emiss∆o;Outras;Valor ICMS;Valor Despesa;PIS;COFINS;Outras Des;Forn Desp;Nome Abreviado;Desp;Descriá∆o;Valor Despesa" SKIP.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "":U).

    RUN pi-relatorio IN THIS-PROCEDURE.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar in h-acomp.
    
/*     {include/i-rpclo.i} */
    DOS SILENT START excel VALUE(c-caminho-arquivo).
    
    RETURN "OK":U.
END.


/* **********************  Internal Procedures  *********************** */
PROCEDURE pi-relatorio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Imprimindo...":U).

    FOR EACH nota-fiscal NO-LOCK USE-INDEX ch-distancia
        WHERE nota-fiscal.cod-estabel  >= tt-param.ini-cod-estabel
          AND nota-fiscal.cod-estabel  <= tt-param.fim-cod-estabel
          AND nota-fiscal.nat-operacao BEGINS "3":U
          AND nota-fiscal.dt-cancel     = ?
          AND nota-fiscal.dt-emis-nota >= tt-param.ini-data
          AND nota-fiscal.dt-emis-nota <= tt-param.fim-data,
        FIRST docum-est NO-LOCK
        WHERE docum-est.serie        = nota-fiscal.serie
          AND docum-est.nro-docto    = nota-fiscal.nr-nota-fis
          AND docum-est.cod-emitente = nota-fiscal.cod-emitente
          AND docum-est.nat-operacao = nota-fiscal.nat-operacao:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Nota: " + nota-fiscal.nr-nota-fis).

        ASSIGN de-pis       = 0
               de-cofins    = 0
               de-outr-desp = 0.

        FOR EACH item-doc-est NO-LOCK
            WHERE item-doc-est.serie-docto  = nota-fiscal.serie
              AND item-doc-est.nro-docto    = nota-fiscal.nr-nota-fis
              AND item-doc-est.cod-emitente = nota-fiscal.cod-emitente
              AND item-doc-est.nat-operacao = nota-fiscal.nat-operacao:
            ASSIGN de-pis    = de-pis    + item-doc-est.valor-pis 
                   de-cofins = de-cofins + item-doc-est.val-cofins.
        END.

        ASSIGN val-desp = 0.

        IF AVAILABLE docum-est THEN DO:
            FIND docum-est-cex
                WHERE docum-est-cex.serie        = nota-fiscal.serie
                  AND docum-est-cex.nro-docto    = STRING(nota-fiscal.nr-nota-fis)
                  AND docum-est-cex.cod-emitente = nota-fiscal.cod-emitente
                  AND docum-est-cex.nat-operacao = nota-fiscal.nat-operacao
                  AND docum-est-cex.cod-desp  = 1 /*** IMPOSTO IMPORTACAO ***/ NO-LOCK NO-ERROR.

            IF AVAILABLE docum-est-cex THEN DO:
                ASSIGN val-desp = docum-est-cex.val-desp.
                IF docum-est.aliquota-icm <> 0 THEN
                    ASSIGN de-outr-desp = docum-est.valor-outras - docum-est.icm-deb-cre - docum-est-cex.val-desp - de-pis - de-cofins.
                ELSE
                    ASSIGN de-outr-desp = docum-est.valor-outras - docum-est-cex.val-desp - de-pis - de-cofins.
            END.
            ELSE DO:
                ASSIGN de-outr-desp = docum-est.valor-outras - de-pis - de-cofins
                       val-desp = 0.
            END.
        END.

        FIND FIRST despesa-aces NO-LOCK
            WHERE despesa-aces.ser-docto-ac  = nota-fiscal.serie
              AND despesa-aces.nro-docto-ac  = nota-fiscal.nr-nota-fis
              AND despesa-aces.cod-forn-ac   = nota-fiscal.cod-emitente NO-ERROR.

        IF AVAILABLE despesa-aces THEN
            ASSIGN de-outr-desp = de-outr-desp + despesa-aces.valor.

        IF tt-param.ind-tip-relat = 2 THEN DO:
            PUT UNFORMATTED string(docum-est.cod-estabel ) + ";" +
                            string(docum-est.nro-docto   ) + ";" +
                            string(docum-est.serie-docto ) + ";" +
                            string(docum-est.nat-operacao) + ";" +
                            string(docum-est.cod-emitente) + ";" +
                            string(docum-est.dt-emissao  ) + ";" +
                            string(docum-est.valor-outras) + ";" +
                            string(docum-est.icm-deb-cre ) + ";" +
                            string(val-desp              ) + ";" +
                            string(de-pis                ) + ";" +
                            string(de-cofins             ) + ";" +
                            string(de-outr-desp          ) + ";".         
        END.
        ELSE DO:
            PUT UNFORMATTED string(docum-est.cod-estabel ) + ";" +
                            string(docum-est.nro-docto   ) + ";" +
                            string(docum-est.serie-docto ) + ";" +
                            string(docum-est.nat-operacao) + ";" +
                            string(docum-est.cod-emitente) + ";" +
                            string(docum-est.dt-emissao  ) + ";" +
                            string(docum-est.valor-outras) + ";" +
                            string(docum-est.icm-deb-cre ) + ";" +
                            string(val-desp              ) + ";" +
                            string(de-pis                ) + ";" +
                            string(de-cofins             ) + ";" +
                            string(de-outr-desp          ) SKIP.         
        END.
        
        ASSIGN lFirst = YES.
        IF tt-param.ind-tip-relat = 2 THEN DO:
            FOR EACH docum-est-cex NO-LOCK
                WHERE docum-est-cex.serie-docto  = nota-fiscal.serie
                  AND docum-est-cex.nro-docto    = nota-fiscal.nr-nota-fis
                  AND docum-est-cex.cod-emitente = nota-fiscal.cod-emitente
                  AND docum-est-cex.nat-operacao = nota-fiscal.nat-operacao:

                IF docum-est-cex.cod-desp = 1 THEN NEXT.

                FIND FIRST desp-imp
                    WHERE desp-imp.cod-desp = docum-est-cex.cod-desp NO-LOCK NO-ERROR.

                IF NOT AVAILABLE desp-imp OR NOT desp-imp.inc-val-outras-desp THEN NEXT.

                IF lFirst THEN DO:
                    PUT UNFORMATTED string(docum-est-cex.cod-emitente-desp)      + ";" +
                                    fn-emitente(docum-est-cex.cod-emitente-desp) + ";" + 
                                    string(docum-est-cex.cod-desp)               + ";" + 
                                    string(desp-imp.descricao    )               + ";" + 
                                    string(docum-est-cex.val-desp) SKIP.    

                    ASSIGN lFirst = NO.
                END.
                ELSE DO:
                    IF tt-param.ind-tip-relat = 2 THEN DO:
                        PUT UNFORMATTED string(docum-est.cod-estabel ) + ";" +
                                        string(docum-est.nro-docto   ) + ";" +
                                        string(docum-est.serie-docto ) + ";" +
                                        string(docum-est.nat-operacao) + ";" +
                                        string(docum-est.cod-emitente) + ";" +
                                        string(docum-est.dt-emissao  ) + ";" +
                                        string(docum-est.valor-outras) + ";" +
                                        string(docum-est.icm-deb-cre ) + ";" +
                                        string(val-desp              ) + ";" +
                                        string(de-pis                ) + ";" +
                                        string(de-cofins             ) + ";" +
                                        string(de-outr-desp          ) + ";".         
                    END.
                    ELSE DO:
                        PUT UNFORMATTED string(docum-est.cod-estabel ) + ";" +
                                        string(docum-est.nro-docto   ) + ";" +
                                        string(docum-est.serie-docto ) + ";" +
                                        string(docum-est.nat-operacao) + ";" +
                                        string(docum-est.cod-emitente) + ";" +
                                        string(docum-est.dt-emissao  ) + ";" +
                                        string(docum-est.valor-outras) + ";" +
                                        string(docum-est.icm-deb-cre ) + ";" +
                                        string(val-desp              ) + ";" +
                                        string(de-pis                ) + ";" +
                                        string(de-cofins             ) + ";" +
                                        string(de-outr-desp          ) SKIP.         
                    END.
                    PUT UNFORMATTED string(docum-est-cex.cod-emitente-desp)      + ";" +
                                    fn-emitente(docum-est-cex.cod-emitente-desp) + ";" + 
                                    string(docum-est-cex.cod-desp)               + ";" + 
                                    string(desp-imp.descricao    )               + ";" + 
                                    string(docum-est-cex.val-desp) SKIP.    
                END.
            END.
            PUT SKIP(1).
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.


/* ************************  Function Implementations ***************** */

FUNCTION fn-emitente RETURNS CHARACTER
  ( p-cod-emitente AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    FIND FIRST emitente
        WHERE emitente.cod-emitente = p-cod-emitente NO-LOCK NO-ERROR.

    IF AVAILABLE emitente THEN
        RETURN emitente.nome-abrev.
    ELSE
        RETURN "":U.

END FUNCTION.

