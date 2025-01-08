DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEF NEW GLOBAL SHARED VARIABLE g-cod-emitente-bodi317im1br AS INTEGER.
DEF NEW GLOBAL SHARED VARIABLE g-codigo-orig-bodi317sd     AS INTEGER.

PROCEDURE pi-calc-juros:
    DEFINE INPUT  PARAM p-cod-cond-pagto       AS INT.
    DEFINE OUTPUT PARAM p-indice-financiamento AS DEC.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.

    FIND FIRST cond-pagto NO-LOCK
         WHERE cond-pagto.cod-cond-pag = p-cod-cond-pagto NO-ERROR.
    
    IF NOT AVAIL cond-pagto THEN DO:
        RUN pi-erro (INPUT "Condiá∆o de pagamento n∆o cadastrada!").
    END.
    
    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK":U.
    
    IF AVAIL cond-pagto THEN DO:
        FIND FIRST tab-finan-indice NO-LOCK
             WHERE tab-finan-indice.nr-tab-finan = cond-pagto.nr-tab-finan
               AND tab-finan-indice.num-seq = cond-pagto.nr-ind-finan NO-ERROR.

        IF AVAIL tab-finan-indice THEN DO:
            ASSIGN  p-indice-financiamento = tab-finan-indice.tab-ind-fin.
        END.
    END.   

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-calcula-icms:
    DEFINE INPUT  PARAM p-conta            AS CHAR. 
    DEFINE INPUT  PARAM p-cod-estabel      AS CHAR.
    DEFINE INPUT  PARAM p-it-codigo        AS CHAR. 
    DEFINE OUTPUT PARAM de-perc-icms       AS DEC.
    DEFINE OUTPUT PARAM de-perc-desc-icms  AS DEC.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.

    DEFINE VARIABLE h-bodi317im1br         AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-boes505              AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-nat-oper             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-return               AS LOGICAL     NO-UNDO.

    FOR EACH tt-erro:
        DELETE tt-erro.
    END.

    DEFINE VARIABLE l-consumidor-final AS LOGICAL     NO-UNDO.
    
    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-guid = p-conta NO-ERROR.
    
    IF  NOT AVAIL int-emitente THEN DO:
        RUN pi-erro (INPUT "C¢digo do Cliente CRM N∆o Encontrado").
    END.
    
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = int-emitente.cod-emitente NO-ERROR.
    
    IF  NOT AVAIL emitente THEN DO:
        RUN pi-erro (INPUT "Cliente " + STRING(int-emitente.cod-emitente) + " n∆o cadastrado.").
    END.
    
    FIND FIRST loc-entr NO-LOCK USE-INDEX ch-entrega
         WHERE loc-entr.cod-entrega = "padrao"
           AND loc-entr.nome-abrev  = emitente.nome-abrev NO-ERROR.
    
    IF  NOT AVAIL loc-entr THEN DO:
        RUN pi-erro (INPUT "Local de entrega do cliente " + STRING(emitente.cod-emitente) + " n∆o cadastrado.").
    END.
    
    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = p-cod-estabel NO-ERROR.
    
    IF NOT AVAIL estabelec THEN DO:
        RUN pi-erro (INPUT "Estabelecimento n∆o cadastrado!").
    END.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

    IF NOT AVAIL ITEM THEN DO:
        RUN pi-erro (INPUT "Produto n∆o cadastrado!").
    END.

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK":U.
    
    IF  NOT VALID-HANDLE(h-boes505) THEN
        RUN esbo/boes505.p PERSISTENT SET h-boes505.
    
    IF NOT VALID-HANDLE (h-bodi317im1br) THEN
        RUN dibo/bodi317im1br.p PERSISTENT SET h-bodi317im1br.


/*     log-manager:write-message("Msg0138a antes buscar natureza " +           */
/*                               estabelec.cod-estabel  +                      */
/*                               " Cliente " + string(emitente.cod-emitente) + */
/*                               " ITEM " + ITEM.it-codigo                     */
/*                               ).                                            */

    
    

    ASSIGN l-consumidor-final = NO.

    IF  NOT emitente.contrib-icm THEN
        ASSIGN l-consumidor-final = YES.
    
    RUN defineNatOperacao IN h-boes505 (INPUT  estabelec.cod-estabel,
                                        INPUT  emitente.cod-emitente,
                                        INPUT  "padrao", 
                                        INPUT  ITEM.it-codigo,
                                        INPUT  l-consumidor-final,
                                        OUTPUT c-nat-oper,
                                        OUTPUT l-return).


/*     log-manager:write-message("Msg0138a apos Natureza " + */
/*                               string(l-return)  +         */
/*                               " Natureza " + c-nat-oper   */
/*                               ).                          */



    IF l-return = NO THEN DO:
         RUN pi-erro (INPUT 'Erro Item'). // + " - Natureza de operaá∆o n∆o encontrada para este Estabelecimento x Cliente x Comercio/Industria, Verifique com GRUPO.TRIBUTARIO - escdp015").

         IF  VALID-HANDLE(h-bodi317im1br) THEN
             DELETE PROCEDURE h-bodi317im1br.

         IF  VALID-HANDLE(h-boes505) THEN
             DELETE PROCEDURE h-boes505.

         RETURN "NOK":U.
    END.

    ASSIGN g-cod-emitente-bodi317im1br = int-emitente.cod-emitente.
    ASSIGN g-codigo-orig-bodi317sd     = ITEM.codigo-orig.
    ASSIGN de-perc-icms = 0.

    IF emitente.contrib-icm = YES THEN DO:
        FOR FIRST inf-compl  /* conteudo do cd0908 */
            WHERE inf-compl.cdn-identif = 5
            AND inf-compl.cod-indice = item.it-codigo + CHR(2) + estabelec.estado + CHR(2) + loc-entr.estado NO-LOCK:
            ASSIGN de-perc-icms = inf-compl.val-campo.
        END.
    END.
    IF de-perc-icms = 0 THEN DO:
        RUN calculaAliquotaICMS IN h-bodi317im1br(INPUT  emitente.contrib-icms,
                                                  INPUT  emitente.natureza,
                                                  INPUT  estabelec.estado,
                                                  INPUT  estabelec.pais,
                                                  INPUT  loc-entr.estado,
                                                  INPUT  item.it-codigo,
                                                  INPUT  c-nat-oper,
                                                  OUTPUT de-perc-icms, 
                                                  OUTPUT l-return).
    END.
    IF l-return = NO THEN DO:
         RUN pi-erro (INPUT "Erro na busca DO ICMS, Entrar em contato com a Intelbras! " + ITEM.it-codigo).

         IF  VALID-HANDLE(h-bodi317im1br) THEN
             DELETE PROCEDURE h-bodi317im1br.

         IF  VALID-HANDLE(h-boes505) THEN
             DELETE PROCEDURE h-boes505.

         RETURN "NOK":U.
    END.
        
    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = c-nat-oper NO-ERROR.

    IF (ITEM.cd-trib-icm <> 1  AND 
        ITEM.cd-trib-icm <> 4) or
       (natur-oper.cd-trib-icm <> 1 AND
        natur-oper.cd-trib-icm <> 4) THEN /* quando Ç isento */
        ASSIGN de-perc-icms = 0.

    IF  ITEM.cd-trib-icm        = 4 
    AND natur-oper.cd-trib-icm  = 4 
    AND natur-oper.perc-red-icm > 0 
    AND de-perc-icms            > 0    THEN DO:
        ASSIGN de-perc-icms = de-perc-icms * (1 - natur-oper.perc-red-icm / 100).
    END.

    ASSIGN de-perc-desc-icms = dec(substr(natur-oper.char-2,66,5)).

    ASSIGN g-cod-emitente-bodi317im1br = 0.
    ASSIGN g-codigo-orig-bodi317sd     = 0.
    
    IF  VALID-HANDLE(h-bodi317im1br) THEN
        DELETE PROCEDURE h-bodi317im1br.
    
    IF  VALID-HANDLE(h-boes505) THEN
        DELETE PROCEDURE h-boes505.

    RETURN "OK":U.
    
END.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.
